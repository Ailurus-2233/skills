---
name: handoff
description: 把当前对话压缩成一份交接文档，供另一个 agent 接手继续工作。
argument-hint: "下一个会话要用来做什么？"
disable-model-invocation: true
---

写一份交接文档，总结当前对话，让一个新的 agent 能无缝接手这项工作。保存到主工作区 `.adev/handoffs/<时间戳>-<主题>.md`，并报告绝对路径；同一任务的后续交接更新原文件。交接中引用其他权威文档的绝对路径，跨机器时需明确 `.adev/` 如何交付，不能假定本地路径可用。

文档中必须包含一个"建议使用的 skills"小节，点名下一个 agent 应当通过 Skill 工具调用哪些 skill。使用本仓库现有的 skill 名，例如：`grilling`、`to-spec`、`to-tickets`、`implement`、`code-review`、`diagnosing-bugs`。

不要重复其他产物（规格说明、计划、ADR、工单、提交、diff）里已经记录的内容，用路径或 URL 引用它们即可。

脱敏所有敏感信息，例如 API 密钥、密码、个人身份信息。

如果用户传了参数，把它当作下一个会话要聚焦的内容描述，并据此裁剪文档。
