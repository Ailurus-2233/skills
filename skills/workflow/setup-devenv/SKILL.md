---
name: setup-devenv
description: "为需要本地工单流程的仓库配置工单、分诊标签、测试与手动验收及领域文档；统一写入 .adev 并忽略该目录。首次使用依赖这些配置的技能前运行。"
disable-model-invocation: true
---

# 配置开发工作流

面向 C# 工控及纯桌面项目（WPF、WinForms、Avalonia）。初始化时由用户选择是否需要自动化测试，后台数据流与客户端操作采用不同的验证方式。所有仓库使用同一布局，不判断团队或个人归属。

## 1. 探索

- 查看根部 `AGENTS.md`、`.gitignore` 与 `.adev/agents/`，读取已有配置和指针。
- 查看 `.sln` / `.slnx`、项目与 UI 框架、通信层、已有构建入口、日志和仿真环境。非 C# 仓库按实际项目记录验证方式，不强加硬件或 dotnet 前提。
- 查看 `.adev/GLOSSARY.md`、`.adev/GLOSSARY-MAP.md`、`.adev/adr/`。多项目不自动等于多上下文，依据领域边界决定。
- 检查旧版 `docs/agents/`、`docs/adr/`、`docs/analysis/`、`.scratch/`、`.out-of-scope/`、`CONTEXT.md` / `CONTEXT-MAP.md`、根部 `GLOSSARY.md` / `GLOSSARY-MAP.md` 与 `AGENTS.local.md` 中的工作流内容，列出迁移映射。
- 确认 `triage` 是否可用，决定是否生成标签映射。

完成标准：已知配置、真实验证环境和待迁移内容已查明；同名目标冲突明确列出。

## 2. 确认尚未确定的选择

逐节给出推荐；用户已经确定的内容直接沿用，不重复询问。

**工单。** 先按项目工作分类 ADR 确定类型（feature 新功能、performance 性能优化、repair 问题修复，其他类型先定义）；月份取工作首次建立的用户当地年月，描述沿用原 feature 的工作名称。跨月继续沿用原目录。统一使用本地 Markdown：`.adev/<类型>/<yyyy-mm>/<描述>/spec.md` 与 `.adev/<类型>/<yyyy-mm>/<描述>/issues/<NN>-<slug>.md`。读写、评论、阻塞、关闭及认领均通过本地文件完成，无需 GitHub / GitLab 或其工具。已有远端 tracker 配置改为本地约定；远端历史工单仅在用户指定迁移范围后导入本地文件。

**标签。** `triage` 可用时，推荐保留 `needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`，以及分类 `bug`、`enhancement`。已有本地标签不同时收集映射，写 `.adev/agents/triage-labels.md`。`ready-for-agent` 表示可开始实现，不代表无需人验收。

**验证。** 必须取得用户对“是否需要自动化测试”的明确选择，写入 `.adev/agents/verification.md`；已有明确选择直接沿用，旧配置仅写“默认不新增”不算用户选择。未回答时可继续探索，但不能把该配置标为初始化完成。启用时，自动化测试仅验证后台执行的数据流输入输出是否符合预期；客户端的点击、导航、编辑等操作流程始终由用户手动验收。记录构建、测试入口（启用时）、启动、操作和日志位置；测试入口尚不存在时记录待实现安排。工控项目明确仿真器/真机、连接方式及关键路径；纯桌面项目不设硬件前提。每张 ticket 全部实现且构建和所需数据流测试通过后，一次性交付 Markdown 验收清单，分别记录自动化证据和手动验收项，由 `check-result` 读取结果、推进修复并调用 `code-review`。清单为 `.adev/<类型>/<yyyy-mm>/<描述>/acceptance/<NN>-<slug>.md`，格式见 `check-result/references/acceptance.md`。宽重构优先 expand–contract，不把不可编译的工单标为完成。

**领域文档。** 默认 `.adev/GLOSSARY.md` + `.adev/adr/`。多上下文才采用 `.adev/GLOSSARY-MAP.md`，指向 `.adev/contexts/<context>/GLOSSARY.md` 与 `.adev/adr/<context>/`。词汇和 ADR 有内容时才创建；工作分类 ADR 在本次初始化中已有具体内容，必须落盘。

## 3. 写入

展示尚未确认的配置草稿及迁移计划，按用户确认结果写入；本次会话中已明确授权的选择无需再次确认。

旧布局迁移：为 `.adev/<旧工作名>/` 或 `.scratch/<旧工作名>/` 确定 ADR 类型、原始建立年月与描述，统一迁入新工作目录；月份来源不明时询问，不以文件修改时间猜测。整体迁移 spec、issues、acceptance 及工作资料并修正链接。将每工单的独立 test/ 合并为工作级单一测试项目，保留已有用例、来源工单和历史报告，解决项目引用与重名后运行完整累计回归；不得仅移动目录而留下多个项目。保留原始资料直到引用与回归检查完成，未知结果如实报告。没有旧工作目录时仅更新配置与模板。

1. 检查并创建根部 `.adev/`。先迁移已确认的旧工作流内容：`docs/agents` → `.adev/agents`，`docs/adr` → `.adev/adr`，`docs/analysis` → `.adev/analysis`，`.scratch/<feature>` → `.adev/<类型>/<yyyy-mm>/<描述>`，`.out-of-scope` → `.adev/out-of-scope`。词汇改名并迁入上述布局，同步相对链接及指针。不整体搬走 `docs/`；仅当目标原本已有不同内容时报告冲突并等待裁决，不先生成目标再人为制造冲突。旧 `AGENTS.local.md` 只合并工作流指针，保留其余个人规则。
2. 在迁入配置上原地更新或补建 `.adev/agents/issue-tracker.md`、`verification.md`、`domain.md`；有 triage 时另生成 `triage-labels.md`。保留既有有效约定，按已确认选择更新。参考 [references/configuration.md](references/configuration.md) 的操作语义，按目标仓库事实填写，不留下占位符。验证配置同时写入测试存放位置：明确放入单元测试项目的除外，其余放入同一工作目录的共享 `test/` 项目，按参考中的路径映射落盘，并写入累计回归与共享写入约定。按项目 ADR 编号创建或更新工作分类 ADR，在工单配置中写入其路径。
3. 根部 `AGENTS.md` 创建或原地更新 `## Agent skills`：分别用一句话说明工单、验证、领域文档和可用时的分诊标签，并指向对应 `.adev/agents/*.md`。保留其他内容。消费者直接读取配置；被忽略目录需要显式访问，不能依赖默认搜索发现。
4. 根部 `.gitignore` 不存在则创建；缺少有效的整目录规则时补 `/.adev/`，等效规则已生效则不重复。处理会抵消它的反向规则，保留其他内容。此项是初始化固定操作。
5. 在 Git 仓库用 `git check-ignore -v --no-index .adev/agents/issue-tracker.md` 验证忽略规则。已跟踪文件不会因忽略规则取消跟踪，报告剩余文件，不自动执行 `git rm --cached`。

完成标准：用户的自动化测试选择已明确保存，启用时测试范围与入口或待实现安排已记录；配置与根部指针一致；`.adev/` 存在且被有效忽略；已有内容和用户规则保留；重复运行不重复生成指针或忽略行。报告未解决的迁移冲突或已跟踪文件。

## 4. 交付

确认分类 ADR 已包含现有工作目录的有效链接和按权威记录汇总的当前状态；无工作时保留空索引说明，不伪造示例工作。迁移后验证 ADR 到目录、spec/MAP 和工单的链接可达，状态刷新规则已写入 issue-tracker.md。

说明生成路径、迁移结果和哪些 skill 使用配置。配置可直接编辑。多 worktree 调用者必须显式传递主工作区 `.adev` 的绝对路径：忽略目录不会随 checkout 复制，工单只能有一个权威副本。
