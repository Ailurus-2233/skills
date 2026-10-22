# 配置内容

这些是生成目标仓库配置时的语义要求；工单管理统一使用本地 Markdown 文件。

## issue-tracker.md

本地文件操作约定：

- spec：`.adev/<feature>/spec.md`；实现工单：`.adev/<feature>/issues/<NN>-<slug>.md`，一工单一文件。
- 验收清单：`.adev/<feature>/acceptance/<NN>-<slug>.md`，ticket 用 `**验收清单：**` 链接；用户维护通过勾选与问题，`check-result` 处理结果并调用 `code-review`。
- 读取：读完整正文与追加记录；评论：追加带日期的小节，保留原文。
- 阻塞：`**阻塞于：**` 引用真实编号/标题；全部依赖已完成才就绪。
- 实现状态：`ready-for-agent` → `in-progress` → `awaiting-verification` → `done`。`done` 要求手动验收与审查问题处理完；失败回到实现，不释放依赖。
- 上述 `ready-for-agent` 是规范角色，实际写入使用标签映射值；`in-progress` / `awaiting-verification` / `done` 是实现生命周期状态，不参加分诊映射。
- 分诊状态和分类字符串取自 `triage-labels.md`；实现中的状态不混作分诊角色。
- 地图：`.adev/<effort>/MAP.md`；决策工单：`.adev/<effort>/tickets/<NN>-<slug>.md`。状态 `open` → `claimed` → `closed`，回答落在工单，地图只加摘要与链接。决策工单不套分诊标签。
- 工单入口为本地文件；未分类报告放在 `.adev/inbox/issues/`。

工单正文、状态与记录只维护在上述文件中；代码 PR 的创建、审查和合并是独立操作，不作为工单管理的前提。

## triage-labels.md

生成 canonical role → 实际字符串映射，默认一一同名：

| 角色 | 默认字符串 | 含义 |
| --- | --- | --- |
| needs-triage | needs-triage | 待维护者评估 |
| needs-info | needs-info | 待补充信息 |
| ready-for-agent | ready-for-agent | 规格充分，可开始实现，仍需手动验收 |
| ready-for-human | ready-for-human | 实现本身需要人完成 |
| wontfix | wontfix | 不处理 |
| bug | bug | 缺陷分类 |
| enhancement | enhancement | 新功能或改进分类 |

## verification.md

按事实记录项目类型、构建命令、启动方式、日志与观察入口、仿真或真机要求。默认编译检查 + 手动验收，新增自动化测试需用户明确要求。每张 ticket 全部实现后一次集中验收，生成独立 Markdown 列表清单，包含环境、启动方法、具体操作和通过标准，格式按 `check-result/references/acceptance.md`。用户勾选通过项并记录问题；`check-result` 区分待验证、修复和验收通过，通过后调用 `code-review`。修复沿用原清单，只复验受影响项；编译成功不等于验收通过。没有对应工具或设备时如实记录阻塞。

## domain.md

记录单/多上下文路径。探索前读 `.adev/GLOSSARY.md`，或从 `.adev/GLOSSARY-MAP.md` 选择相关词汇表，再读触及区域的 ADR。文件不存在则继续，不预建空文档；已存在时使用规范术语，冲突须说明。词汇表只记录领域概念，ADR 默认标题 + 1–3 句背景、决定、理由，复杂决策按需展开。
