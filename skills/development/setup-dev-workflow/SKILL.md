---
name: setup-dev-workflow
description: "为仓库配置 C# 开发工作流：工单、分诊标签、手动验证与领域文档；统一写入 .adev 并忽略该目录。首次使用其他流程类 skill 前运行。"
disable-model-invocation: true
---

# 配置开发工作流

面向 C# 工控及纯桌面项目（WPF、WinForms、Avalonia）。默认采用编译检查与用户手动验收；只有用户明确要求才新增自动化测试。所有仓库使用同一布局，不判断团队或个人归属。

## 1. 探索

- 查看远端、根部 `AGENTS.md`、`.gitignore` 与 `.adev/agents/`，读取已有配置和指针。
- 查看 `.sln` / `.slnx`、项目与 UI 框架、通信层、已有构建入口、日志和仿真环境。非 C# 仓库按实际项目记录验证方式，不强加硬件或 dotnet 前提。
- 查看 `.adev/GLOSSARY.md`、`.adev/GLOSSARY-MAP.md`、`.adev/adr/`。多项目不自动等于多上下文，依据领域边界决定。
- 检查旧版 `docs/agents/`、`docs/adr/`、`docs/analysis/`、`.scratch/`、`.out-of-scope/`、`CONTEXT.md` / `CONTEXT-MAP.md`、根部 `GLOSSARY.md` / `GLOSSARY-MAP.md` 与 `AGENTS.local.md` 中的工作流内容，列出迁移映射。
- 确认 `triage` 是否可用，决定是否生成标签映射。

完成标准：已知配置、真实验证环境和待迁移内容已查明；同名目标冲突明确列出。

## 2. 确认尚未确定的选择

逐节给出推荐；用户已经确定的内容直接沿用，不重复询问。

**工单。** 默认本地 Markdown：`.adev/<feature>/spec.md` 与 `.adev/<feature>/issues/<NN>-<slug>.md`。也支持 GitHub、GitLab 或用户指定的平台；真实 tracker 需记录实际读写、评论、阻塞、子工单、关闭及认领操作。外部 PR 需求入口默认关闭，只有显式启用后才记录外部贡献者的判定和发现方式；本地 tracker 不扫描 PR。

**标签。** `triage` 可用时，推荐保留 `needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`，以及分类 `bug`、`enhancement`。已有平台标签不同时收集映射，写 `.adev/agents/triage-labels.md`。`ready-for-agent` 表示可开始实现，不代表无需人验收。

**验证。** 记录构建、启动、操作和日志位置。工控项目明确仿真器/真机、连接方式及关键路径；纯桌面项目不设硬件前提。每个验收片段先编译通过再给手动步骤；宽重构优先 expand–contract，拆不开则合并验收片段，不把不可编译的工单标为完成。显式要求的测试补充手动验收，不自动取消手动关卡。

**领域文档。** 默认 `.adev/GLOSSARY.md` + `.adev/adr/`。多上下文才采用 `.adev/GLOSSARY-MAP.md`，指向 `.adev/contexts/<context>/GLOSSARY.md` 与 `.adev/adr/<context>/`。词汇和 ADR 有内容时才创建。

## 3. 写入

展示尚未确认的配置草稿及迁移计划，按用户确认结果写入；本次会话中已明确授权的选择无需再次确认。

1. 检查并创建根部 `.adev/`。先迁移已确认的旧工作流内容：`docs/agents` → `.adev/agents`，`docs/adr` → `.adev/adr`，`docs/analysis` → `.adev/analysis`，`.scratch/<feature>` → `.adev/<feature>`，`.out-of-scope` → `.adev/out-of-scope`。词汇改名并迁入上述布局，同步相对链接及指针。不整体搬走 `docs/`；仅当目标原本已有不同内容时报告冲突并等待裁决，不先生成目标再人为制造冲突。旧 `AGENTS.local.md` 只合并工作流指针，保留其余个人规则。
2. 在迁入配置上原地更新或补建 `.adev/agents/issue-tracker.md`、`verification.md`、`domain.md`；有 triage 时另生成 `triage-labels.md`。保留既有有效约定，按已确认选择更新。参考 [references/configuration.md](references/configuration.md) 的操作语义，按目标仓库事实填写，不留下占位符。
3. 根部 `AGENTS.md` 创建或原地更新 `## Agent skills`：分别用一句话说明工单、验证、领域文档和可用时的分诊标签，并指向对应 `.adev/agents/*.md`。保留其他内容。消费者直接读取配置；被忽略目录需要显式访问，不能依赖默认搜索发现。
4. 根部 `.gitignore` 不存在则创建；缺少有效的整目录规则时补 `/.adev/`，等效规则已生效则不重复。处理会抵消它的反向规则，保留其他内容。此项是初始化固定操作。
5. 在 Git 仓库用 `git check-ignore -v --no-index .adev/agents/issue-tracker.md` 验证忽略规则。已跟踪文件不会因忽略规则取消跟踪，报告剩余文件，不自动执行 `git rm --cached`。

完成标准：配置与根部指针一致；`.adev/` 存在且被有效忽略；已有内容和用户规则保留；重复运行不重复生成指针或忽略行。报告未解决的迁移冲突或已跟踪文件。

## 4. 交付

说明生成路径、迁移结果和哪些 skill 使用配置。配置可直接编辑。多 worktree 调用者必须显式传递主工作区 `.adev` 的绝对路径：忽略目录不会随 checkout 复制，工单只能有一个权威副本。
