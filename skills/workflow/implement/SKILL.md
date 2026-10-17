---
name: implement
description: 按 spec 或本地工单完成整张 ticket 的实现，构建通过后生成一次集中验收的 Markdown 清单，交给用户填写并由 check-result 处理结果。
disable-model-invocation: true
---

# Implement

实现用户指定的 spec 或工单。默认不新增自动化测试，用户明确要求时除外；构建检查不能代替用户手动验收。C# 桌面端使用实际项目的 dotnet build 或等价构建入口，其他项目遵循 `.adev/agents/verification.md`。

## 流程

1. **明确来源。** 按 `.adev/agents/issue-tracker.md` 读取本地 ticket、关联 spec 和追加记录，确认阻塞项均已完成。记录实现前固化的 Git 基准 SHA、分支和已有无关改动，供后续累计审查；继续修复时保留原基准。缺少真实 spec 或引用不明确时请用户指定，不以会话记忆代替。直接实现 spec 时，以本次完整实现范围作为一张 ticket，在本地保存对应工单。
2. **实现整张 ticket。** 标记 `in-progress`，可在内部拆分可编译片段并采用 expand–contract，但不逐片段请求用户验收。完成全部标准并执行项目构建检查；遇到需求冲突或缺失的外部条件时说明具体阻塞。
3. **生成验收清单。** 读取 [清单约定与模板](../check-result/references/acceptance.md)，创建 `.adev/<feature>/acceptance/<NN>-<slug>.md`，在 ticket 写入清单链接与原始审查基准。根据真实实现填齐环境、启动方法、操作与通过标准。清单覆盖 ticket 全部标准，使用列表而非表格。修复任务沿用原清单，保留用户反馈；只更新受影响项及复验方法，不替用户勾选。
4. **一次性交付验收。** 构建通过后标记 `awaiting-verification`，报告实现结果、构建证据和清单的可点击路径。说明用户勾选通过项、记录问题后使用 `/check-result <清单路径>`。此处停止实现，等待清单结果；不逐片段等待口头确认，不提前完成工单或解锁依赖。

用户提交结果后由 `check-result` 判断待验证、继续修复或验收通过，并调用 `code-review` 完成审查与收尾。修复仍属于同一张 ticket 的同一次集中验收流程，不重新要求验证未受影响的已通过项目。
