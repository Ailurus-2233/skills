# 配置内容

这些是生成目标仓库配置时的语义要求；只写实际启用的 tracker 与布局。

## issue-tracker.md

本地默认：

- spec：`.adev/<feature>/spec.md`；实现工单：`.adev/<feature>/issues/<NN>-<slug>.md`，一工单一文件。
- 读取：读完整正文与追加记录；评论：追加带日期的小节，保留原文。
- 阻塞：`**阻塞于：**` 引用真实编号/标题；全部依赖已完成才就绪。
- 实现状态：`ready-for-agent` → `in-progress` → `awaiting-verification` → `done`。`done` 要求手动验收与审查问题处理完；失败回到实现，不释放依赖。
- 上述 `ready-for-agent` 是规范角色，实际写入使用标签映射值；`in-progress` / `awaiting-verification` / `done` 是实现生命周期状态，不参加分诊映射。
- 分诊状态和分类字符串取自 `triage-labels.md`；实现中的状态不混作分诊角色。
- 地图：`.adev/<effort>/MAP.md`；决策工单：`.adev/<effort>/tickets/<NN>-<slug>.md`。状态 `open` → `claimed` → `closed`，回答落在工单，地图只加摘要与链接。决策工单不套分诊标签。
- 外部 PR 需求入口：关闭。

真实 tracker 记录仓库身份、已可用工具及读取/创建/评论/阻塞/子工单/关闭/认领的实际操作。只创建该平台缺失的已确认标签。启用外部 PR 时补外部贡献者判定、原始需求读取及评论权限；保持 PR 本身的代码审查和合并为独立操作，不因完成分诊自动合并。

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

按事实记录项目类型、构建命令、启动方式、日志与观察入口、仿真或真机要求。默认编译检查 + 手动验收，新增自动化测试需用户明确要求。手动记录包含动作、预期、实际结果和用户确认；编译成功不等于验收通过。没有对应工具或设备时如实记录阻塞。

## domain.md

记录单/多上下文路径。探索前读 `.adev/GLOSSARY.md`，或从 `.adev/GLOSSARY-MAP.md` 选择相关词汇表，再读触及区域的 ADR。文件不存在则继续，不预建空文档；已存在时使用规范术语，冲突须说明。词汇表只记录领域概念，ADR 默认标题 + 1–3 句背景、决定、理由，复杂决策按需展开。
