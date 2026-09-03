---
name: handoff
description: 把当前对话压缩成一份交接文档，供另一个 agent 接手继续工作。
argument-hint: "下一个会话要用来做什么？"
disable-model-invocation: true
---

写一份交接文档，总结当前对话，让一个新的 agent 能无缝接手这项工作。保存到操作系统的临时目录（Windows 上即 `%TEMP%` 所指路径），而不是当前工作区。

文档中必须包含一个"建议使用的 skills"小节，点名下一个 agent 应当通过 Skill 工具调用哪些 skill。使用本仓库现有的 skill 名，例如：`grilling`、`to-spec`、`to-tickets`、`implement`、`code-review`、`diagnosing-bugs`。

不要重复其他产物（规格说明、计划、ADR、工单、提交、diff）里已经记录的内容，用路径或 URL 引用它们即可。

脱敏所有敏感信息，例如 API 密钥、密码、个人身份信息。

如果用户传了参数，把它当作下一个会话要聚焦的内容描述，并据此裁剪文档。
