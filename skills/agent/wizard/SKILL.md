---
name: wizard
description: 生成一个交互式 PowerShell 向导，带着人一步一步完成只有人能做的操作。用于安装厂商软件与授权、配置串口/总线驱动、在 PLC 编程软件里下载程序、现场接线确认、一次性迁移或切换等场景。agent 自己能完成的步骤不要动用本 skill。
---

# Wizard（向导）

**向导**是一个 PowerShell 脚本，带着人逐步走完一套手工流程——这种流程自己动手做很繁琐，每次向 AI 重新解释一遍也很繁琐。它会清屏后逐个阶段展开：说明这一步要做什么、引导人完成操作、采集产生的值、在合适的地方落盘（`.env` 或项目配置文件）、每个阶段都有确认闸门，并显示还剩几个阶段。工控场景的典型用途：安装厂商运行时/授权、配置串口或现场总线驱动、在 PLC 编程软件（如 TIA Portal、CX-Programmer、Studio 5000）里下载程序、现场接线与上电确认；也包括一次性迁移、把项目从一种状态切到另一种状态。

编写向导时先读并复制 [template.ps1](template.ps1)。它兼容 Windows PowerShell 5.1 / PowerShell 7；只修改副本的 `STAGES` 区，辅助函数的修复集中维护在模板中。

## 模板接口

- `Show-WizardStage -Title ... -Number ... -Total ...`：显示阶段与进度。
- `Read-WizardValue -Prompt ...`：读取公开值，EOF 或 `/cancel` 立即停止。
- `Read-WizardSecret -Prompt ...`：交互控制台隐藏输入，返回 `SecureString`；空输入取消，重定向输入被拒绝。
- `Confirm-WizardAction -Question ...`：只有完整、小写的 `yes` 才继续；任何其他回答停止流程。
- `Set-WizardJsonValue -Path ... -Key ... -Value ...`：幂等更新 JSON 对象的顶层字符串键，保留无关属性；拒绝重复/大小写冲突键、符号链接及 junction 路径，不自动创建配置目录。JSON 会重新格式化，不支持带注释 JSON。

JSON 写入函数只接收公开字符串，秘密值留在 `SecureString` 中交给本次任务明确指定的秘密存储接口；不打印、反射或汇总秘密值。`.env`、XML、INI 以及嵌套路径需要针对实际消费者实现独立写入步骤并验证序列化，不能套用 JSON 写入函数。

阶段全部定义在 `Invoke-Wizard` 内；仅直接执行脚本才启动流程，dot-source 只加载函数。每个不可逆动作前调用 `Confirm-WizardAction`。取消不会回滚已完成阶段，阶段需能安全重跑。结尾仅汇总动作、目标位置和下一步，不汇总采集值。

## 流程

### 1. 界定流程范围（scope）

弄清人必须亲手做的每一步，以及沿途要采集的每个值。先读仓库，不要开口问冷问题：

- 安装/配置类：`.env`、`.env.example`、`README`、项目配置文件（`.config`、`.json`、`appsettings*.json`）、已有的安装/部署文档——每一个配置项引用都是向导必须产出的值。
- 迁移/切换类：当前状态、目标状态、两者之间不可逆的动作。

然后把排好序的阶段清单和每个阶段产出的值给用户看并确认：用户可以增加、删除、调整顺序。

**完成标准：** 每个阶段按序命名；对每个要采集的值都知道：(a) 人从哪里得到它，(b) 写到哪里（`.env`、配置文件、都不写——有些阶段是纯动作），(c) 是秘密值（`Read-WizardSecret`）还是公开值（`Read-WizardValue`）。

### 2. 映射每个阶段的人行路径

为每个阶段写出人要走的精确路径：打开什么软件或界面、点哪里、值显示在哪个位置、填进哪个变量。例如："安装厂商运行时 → 以管理员运行 setup.exe → 许可证管理器 → 输入授权码 → 确认服务已启动"。**如果你并不确切知道当前的界面或命令，就明说，然后问用户或查官方文档：绝不臆造可能不存在的步骤。**

**完成标准：** 每个阶段都能还原成一段陌生人照做就能完成的说明。

### 3. 编写向导

先按 `.adev/agents/verification.md` 选择任务脚本位置：有 ticket 的一次性向导放在其工作目录 `temp/wizard.ps1`，无 ticket 放在 `.adev/temp/<desc>/wizard.ps1`；需要持久化时分别放在工作目录 `scripts/wizard.ps1` 或 `.adev/scripts/<desc>/wizard.ps1`。复制模板到所选路径，在 `Invoke-Wizard` 内按依赖顺序编写阶段。先指引人到取值位置，再读取值；对照每个值的目的地选择对应的写入接口。保持模板辅助函数不变，实际部署动作与配置格式适配放在 STAGES 区。

### 4. 静态检查并交付

- 语法检查：`powershell -NoProfile -Command "[ScriptBlock]::Create((Get-Content <script> -Raw))"`；如果装有 PSScriptAnalyzer，再跑一遍 `Invoke-ScriptAnalyzer`。
- 在隔离目录 dot-source 模板或生成副本，实际验证涉及的辅助函数：特殊字符往返、重复运行、无关配置保留、取消/EOF，以及拒绝链接路径。检查脚本时不启动厂商软件、不接触真实设备。
- 不要自己端到端运行：它会启动厂商软件、阻塞等待人的输入。改为静态走查：第 1 步列出的每个值都被采集、并落到了第 1 步说好的位置。
- 告诉用户运行方法（例如 `powershell -ExecutionPolicy Bypass -File <script>`）。

## 生命周期

向导默认是一次性的，放在 temp/，可随时清理。需要重复使用时移入上述 scripts/ 并更新运行入口；日志仍写对应 temp/。持久化向导不随临时目录清理，仍遵循 .adev/ 的 Git 忽略约定，不因需要复用就自动提交入库。
