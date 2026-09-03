---
name: grill-me
description: 不留情面的面试，用来打磨一个计划或设计。不在仓库留下任何文档（无状态）。
disable-model-invocation: true
---

调用 Skill 工具，加载 "grilling"。

与 `grill-with-docs` 的区别：本 skill 是**无状态**入口——不写 `CONTEXT.md`、不产生 ADR，适合不在工作目录中、或纯粹想把一个想法问透的场景。在仓库中工作时优先用 `grill-with-docs`，它会留下纸面记录。
