# AGENTS.md

## Agent skills

### 工单跟踪

工单为本地 markdown 文件，存于 `.scratch/<feature>/issues/`。见 `docs/agents/issue-tracker.md`。

### 验证约定

本仓库为 skill 集合（纯 markdown），无自动化验收；修改 skill 后 agent 走读 SKILL.md 并实际调用演练，向用户汇报逐步产出。见 `docs/agents/verification.md`。

### 领域文档

single-context 布局：根部一个 `CONTEXT.md` + `docs/adr/`。见 `docs/agents/domain.md`。
