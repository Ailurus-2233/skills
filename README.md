# Skills

个人常用 Skill 仓库，用于规范日常开发流程。参考社区优秀的开源 Skill 实现，逐步沉淀自己的工程实践。

## 目录结构

```
.
├── skills/                  # 正式可用的 Skill
│   ├── workflow/            # 定义一般工作流的常用技能
│   ├── development/         # 开发常用技能
│   ├── agent/               # 服务于 agent、技能与 agent 配置的技能
│   ├── in-progress/         # 编写中，尚未定稿
│   └── archive/             # 已废弃，仅保留存档
├── .adev/                   # 本地工作流配置、词汇、ADR、工单（Git 忽略）
├── docs/                    # 其他设计说明、使用笔记
├── ref/                     # 参考的开源 Skill（不入库，见 .gitignore）
└── README.md
```

## 当前 Skill

任务辅助产物按所属 ticket 和保留期限存放：

| 产物 | 有 ticket | 无 ticket |
| --- | --- | --- |
| 临时脚本、过程日志（可随时清理） | `.adev/<类型>/<yyyy-mm>/<描述>/temp/` | `.adev/temp/<desc>/` |
| 持久化辅助脚本 | `.adev/<类型>/<yyyy-mm>/<描述>/scripts/` | `.adev/scripts/<desc>/` |

正式验收证据与累计回归测试不放在可清理目录；持久化脚本仍随 `.adev/` 保留本地。

分类 ADR 同时提供工作索引：链接实际工作目录与依据，显示当前状态、工单进度、待办和更新时间。状态随发布、实现、验收、修复与完成从权威记录刷新；其他关联 ADR 链接此索引，不重复维护工作状态。

工作资料按 `.adev/<类型>/<yyyy-mm>/<描述>/` 组织。类型由项目 ADR 定义：`feature` 为新功能、`performance` 为性能优化、`repair` 为问题修复；年月取工作首次建立的年月，跨月继续沿用原目录。目录内保存 `spec.md`、`issues/<编号-名称>.md`、`acceptance/<编号-名称>.md`，所有工单共用 `test/` 中的一个测试项目。每张工单推进时，本次用例与此前所有已验收用例必须通过累计回归；此前明确构造在单元测试项目中的测试仍沿用原项目并纳入回归。

技能分为三类：`workflow` 共同定义一般工作流，`development` 提供开发常用能力，`agent` 服务于 agent 及技能、配置的维护。全套流程的路由见 `ask`。

### 工作流技能（`skills/workflow/`）

| Skill | 用途 |
| --- | --- |
| [setup-devenv](skills/workflow/setup-devenv/SKILL.md) | 为目标仓库配置工单跟踪、手动验证约定（工控/纯桌面端）、文档布局；首次使用依赖本地工单的流程前运行。统一存入 `.adev/`，并在 `.gitignore` 中忽略 |
| [ask](skills/workflow/ask/SKILL.md) | 不确定该用哪个 skill / 流程时的路由器 |
| [grill-me](skills/workflow/grill-me/SKILL.md) | 同一面试的无状态入口（不在仓库中时使用） |
| [grill-with-docs](skills/workflow/grill-with-docs/SKILL.md) | 面试打磨想法，沿途沉淀 `.adev/GLOSSARY.md` 词汇表与 ADR |
| [wayfinder](skills/workflow/wayfinder/SKILL.md) | 超大多会话工作的决策地图：decision tickets + fog of war |
| [to-spec](skills/workflow/to-spec/SKILL.md) | 把对话综合成 spec，保存为本地 Markdown 文件 |
| [to-tickets](skills/workflow/to-tickets/SKILL.md) | 把 spec/计划拆成 tracer-bullet 工单，按项目配置区分后台数据流测试与手动验收标准 |
| [triage](skills/workflow/triage/SKILL.md) | 把外来 bug/请求在分诊角色状态机里移动，产出 agent-ready 工单 |
| [implement](skills/workflow/implement/SKILL.md) | 完成整张 ticket，构建及所需数据流测试通过后交付 Markdown 验收清单 |
| [implement-spec](skills/workflow/implement-spec/SKILL.md) | 仅显式调用：按工单依赖并行实现，逐批集成编译，按 ticket 交付验收清单 |
| [check-result](skills/workflow/check-result/SKILL.md) | 读取用户填写的验收清单，推进修复或确认验收通过，再调用 code-review 完成审查 |
| [code-review](skills/workflow/code-review/SKILL.md) | 变更审查：实现质量；有真实 spec 时核对需求，复杂变更按轴并行 |

### 开发常用技能（`skills/development/`）

| Skill | 用途 |
| --- | --- |
| [commit-message](skills/development/commit-message/SKILL.md) | 生成中文 Conventional Commits 提交信息；直接调用只输出信息，流程收尾时用于提交 |
| [diagnosing-bugs](skills/development/diagnosing-bugs/SKILL.md) | 疑难 bug 诊断闭环：先建紧致反馈闭环再假设，修复后手动回归验证 |
| [grilling](skills/development/grilling/SKILL.md) | 面试原语：分轮、frontier、推荐答案 |
| [handoff](skills/development/handoff/SKILL.md) | 把当前会话压缩成交接文档供新会话继续 |
| [pr](skills/development/pr/SKILL.md) | 写 PR 描述：行为变化、实际验证证据与合并影响 |
| [prototype](skills/development/prototype/SKILL.md) | 一次性代码回答设计问题（逻辑/状态模型或 UI） |
| [research](skills/development/research/SKILL.md) | 对照一手资料调研，按需保存带引用的 Markdown |
| [wait-what](skills/development/wait-what/SKILL.md) | 没听懂时的重讲纠正器 |
| [codebase-design](skills/development/codebase-design/SKILL.md) | 深模块词汇（module/interface/depth/seam/adapter/leverage/locality） |
| [improve-codebase-architecture](skills/development/improve-codebase-architecture/SKILL.md) | 扫描深化机会，按复杂度交付 Markdown 或离线 HTML 报告 |
| [resolving-merge-conflicts](skills/development/resolving-merge-conflicts/SKILL.md) | 按两侧意图逐 hunk 解决合并/rebase 冲突并验证 |

### Agent 支持技能（`skills/agent/`）

| Skill | 用途 |
| --- | --- |
| [retro](skills/agent/retro/SKILL.md) | 显式复盘会话，提出环境改进建议；不自动新增测试、CI 或规则 |
| [wizard](skills/agent/wizard/SKILL.md) | 只有人能走的步骤（厂商软件/授权/驱动/下载程序）生成 PowerShell 向导 |
| [domain-modeling](skills/agent/domain-modeling/SKILL.md) | 领域词汇纪律：`.adev/GLOSSARY.md` 词汇表与 ADR |
| [writing-for-agents](skills/agent/writing-for-agents/SKILL.md) | 写 skill / AGENTS.md 等 agent 文档的参考（维护本仓库时用） |

主流程：关键选择未定时先用 `grill-with-docs`；明确的小改动直接实现并报告检查结果。需要跨会话工单管理时走 `to-spec` → `to-tickets` → 逐工单 `implement` → 用户填写清单 → `check-result`。

与常见流程的关键差异：**初始化时由用户明确选择是否需要自动化测试，并保存到验证配置**。启用时自动化仅验证后台数据流的输入输出；客户端操作流程始终由用户手动验收。不启用时提供手动输入输出核对步骤。每张 ticket 完整实现并通过项目实际构建及所需数据流测试后一次交付验收清单，分别记录自动化证据和手动验收项。用户在清单勾选手动项并记录问题，`check-result` 读取结果并在验收通过后调用代码审查。独立审查找不到真实 spec 时报告需求核对边界；工单流程仍需真实 spec。`tdd` 与 `teach` 未移植（前者由本地验证约定适配，后者非开发流程）。词汇表与 ADR 统一放在 `.adev/`；多上下文使用 `.adev/GLOSSARY-MAP.md`。

### 已归档（`skills/archive/`）

| Skill | 状态 |
| ----- | ---- |
| `deep-read` | 已停用，保留技能正文及配套参考文件，仅供历史查阅。 |
| `to-questionnaire` | 已停用，移入归档，不再参与工作流。 |

## Skill 规范

每个 Skill 为一个独立目录，至少包含一个 `SKILL.md`。需要可复用执行资源时可以包含脚本模板；当前 `wizard` 提供 PowerShell 模板：

```
skills/agent/my-skill/
├── SKILL.md                 # 入口：名称、描述、触发条件、执行步骤
└── references/              # 可选：引用文档、模板、示例
```

`SKILL.md` 头部使用 YAML frontmatter：

```yaml
---
name: my-skill
description: 一句话说明做什么、何时触发
---
```

正文写清执行步骤与约束，引用文件按需加载，避免一次性塞入全部上下文。

## 生命周期

1. 在 `skills/in-progress/` 中起草、验证；
2. 稳定后移入对应分类目录；
3. 不再使用时移入 `skills/archive/`，不直接删除。

## 对齐基准

本轮对照本地参考仓库 `mattpocock/skills` 的 `49dd158`（2026-10-09）；远端查询未成功，不将此版本宣称为远端最新。保留 C#／Windows、默认本地工单及手动验收适配；`deep-read` 继续归档。

## 参考来源

`ref/` 存放收集的开源 Skill 实现，仅作本地参考，已加入 `.gitignore` 不入库。

| 仓库                                                                                            | 说明                                                                                                                                                                                                                                                      |
| ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [mattpocock/skills](https://github.com/mattpocock/skills)（`ref/skills/`，MIT）                 | 本仓库的主要参考：grilling 面试机制、to-spec / to-tickets / implement 主流程、两轴 code-review、wayfinder 决策地图等均移植自这里，并按 C# 工控/桌面端场景改造（去 TDD、本地 markdown 工单、手动验证回环）。原版面向 TypeScript Web 开发 + GitHub Issues。 |
| [CiferaTeam/deep-code-reader](https://github.com/CiferaTeam/deep-code-reader)（`ref/deep-code-reader/`，MIT） | 深读代码库产出认知 skill 的工具，核心是 ABC 闭卷考试验证循环（A 读源码写文档、B 读源码出题、C 只看文档答题）。已归档的 `deep-read` 移植自这里，产出改为仓库内 `.adev/analysis/` 文档 + AGENTS 指针，并增加 `.sln` 解决方案模式。                                |
| [obra/superpowers](https://github.com/obra/superpowers)（`ref/superpowers/`，MIT）              | Claude Code 的 skill 合集，deep-code-reader 依赖其中的 writing-skills 格式规范；本仓库以自有 `writing-for-agents` 替代该依赖。                                                                                                                       |
