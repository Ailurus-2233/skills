# Compatible with Windows PowerShell 5.1 and PowerShell 7.
# Dot-source to load helpers only. Customize only the STAGES section in copies.

function Read-WizardValue {
    param([Parameter(Mandatory)][string]$Prompt)
    Write-Host "$Prompt (type /cancel to stop): " -NoNewline
    $answer = [Console]::ReadLine()
    if ($null -eq $answer -or $answer -eq '/cancel') {
        throw [OperationCanceledException]::new('Wizard cancelled or input ended.')
    }
    return $answer
}

function Read-WizardSecret {
    param([Parameter(Mandatory)][string]$Prompt)
    if ([Console]::IsInputRedirected) {
        throw [OperationCanceledException]::new('Secret entry requires an interactive console.')
    }
    $secret = Read-Host "$Prompt (empty input cancels)" -AsSecureString
    if ($null -eq $secret -or $secret.Length -eq 0) {
        throw [OperationCanceledException]::new('Secret entry cancelled.')
    }
    return $secret
}

function Confirm-WizardAction {
    param([Parameter(Mandatory)][string]$Question)
    $answer = Read-WizardValue "$Question Type yes to continue"
    if ($answer -cne 'yes') {
        throw [OperationCanceledException]::new('Action was not confirmed.')
    }
}

function Show-WizardStage {
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][ValidateRange(1, 10000)][int]$Number,
        [Parameter(Mandatory)][ValidateRange(1, 10000)][int]$Total
    )
    if ($Number -gt $Total) { throw 'Stage number exceeds total.' }
    if (-not [Console]::IsOutputRedirected) {
        try { Clear-Host -ErrorAction Stop } catch { Write-Host '' }
    }
    Write-Host "[$Number/$Total] $Title"
}

function Assert-WizardRegularPath {
    param([Parameter(Mandatory)][string]$Path)
    $cursor = [IO.Path]::GetFullPath($Path)
    while ($cursor) {
        # Get-Item also inspects a dangling link; Test-Path alone may miss it.
        $item = Get-Item -LiteralPath $cursor -Force -ErrorAction SilentlyContinue
        if ($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw 'Configuration paths must not contain symbolic links or junctions.'
        }
        $parent = [IO.Path]::GetDirectoryName($cursor)
        if ($parent -eq $cursor) { break }
        $cursor = $parent
    }
}

function Set-WizardJsonValue {
    # String values only; secrets stay SecureString and must use a task-specific sink.
    # This is a JSON writer, not a dotenv/XML/INI writer. Keys are literal top-level keys.
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Key,
        [Parameter(Mandatory)][AllowEmptyString()][string]$Value
    )
    $ErrorActionPreference = 'Stop'
    $fullPath = [IO.Path]::GetFullPath($Path)
    Assert-WizardRegularPath $fullPath
    $directory = [IO.Path]::GetDirectoryName($fullPath)
    if (-not [IO.Directory]::Exists($directory)) { throw 'Create the configuration directory before writing.' }
    $exists = [IO.File]::Exists($fullPath)
    if ($exists) {
        $original = [IO.File]::ReadAllText($fullPath)
        $jsonOptions = @{ InputObject = $original; ErrorAction = 'Stop' }
        if ((Get-Command ConvertFrom-Json).Parameters.ContainsKey('DateKind')) { $jsonOptions.DateKind = 'String' }
        $document = ConvertFrom-Json @jsonOptions
        if ($null -eq $document -or $document.GetType().FullName -ne 'System.Management.Automation.PSCustomObject') {
            throw 'Configuration must be a JSON object.'
        }
        # Duplicate/case-colliding properties must not be silently collapsed by PowerShell.
        # A normalized round-trip cannot prove their absence, so use the parser below.
        Assert-WizardJsonKeys $original
    } else {
        $document = [PSCustomObject]@{}
    }
    $property = $document.PSObject.Properties[$Key]
    if ($property -and $property.Name -cne $Key) { throw 'A differently cased configuration key already exists.' }
    if ($property) { $property.Value = $Value }
    else { $document | Add-Member -NotePropertyName $Key -NotePropertyValue $Value }
    $serialized = ConvertTo-Json -InputObject $document -Depth 100 -WarningAction Stop -ErrorAction Stop
    $temporary = Join-Path $directory ('.wizard-' + [Guid]::NewGuid().ToString('N') + '.tmp')
    try {
        [IO.File]::WriteAllText($temporary, $serialized + [Environment]::NewLine, [Text.UTF8Encoding]::new($false))
        Assert-WizardRegularPath $fullPath
        if ($exists) {
            if ([IO.File]::ReadAllText($fullPath) -cne $original) { throw 'Configuration changed while the wizard was writing.' }
            [IO.File]::Replace($temporary, $fullPath, [NullString]::Value)
        } else {
            [IO.File]::Move($temporary, $fullPath)
        }
    } finally {
        if ([IO.File]::Exists($temporary)) { [IO.File]::Delete($temporary) }
    }
    # No values or secret material are printed or accumulated for a summary.
}

function Assert-WizardJsonKeys {
    param([Parameter(Mandatory)][string]$Json)
    # Inspect JSON string tokens followed by ':'; braces in strings are consumed
    # as part of the token. Reject duplicate keys in each object before rewriting.
    $stack = [Collections.Generic.Stack[object]]::new()
    $tokens = [regex]::Matches($Json, '"(?:\\.|[^"\\])*"|[{}:]')
    for ($i = 0; $i -lt $tokens.Count; $i++) {
        $token = $tokens[$i].Value
        if ($token -eq '{') {
            $stack.Push([Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase))
        } elseif ($token -eq '}') {
            if ($stack.Count -gt 0) { [void]$stack.Pop() }
        } elseif ($token.StartsWith('"') -and $i + 1 -lt $tokens.Count -and $tokens[$i + 1].Value -eq ':') {
            $name = ConvertFrom-Json -InputObject $token -ErrorAction Stop
            if ($stack.Count -eq 0 -or -not $stack.Peek().Add($name)) { throw 'Duplicate or case-colliding JSON keys are not supported.' }
        }
    }
}

# STAGES: replace this function in the generated copy. Keep all stages inside it.
function Invoke-Wizard {
    $ErrorActionPreference = 'Stop'
    Show-WizardStage -Title 'Review the manual procedure' -Number 1 -Total 1
    Write-Host 'Replace this example with the agreed steps; it performs no setup.'
    Confirm-WizardAction 'Finish this example?'
    Write-Host 'Example complete. No configuration was changed.'
}

if ($MyInvocation.InvocationName -ne '.') {
    try { Invoke-Wizard }
    catch {
        # Do not print exception details: a task-specific sink may include a secret.
        Write-Host 'Wizard stopped. Completed earlier stages are not rolled back.'
        exit 1
    }
}
