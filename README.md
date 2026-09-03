# Skills

个人常用 Skill 仓库，用于规范日常开发流程。参考社区优秀的开源 Skill 实现，逐步沉淀自己的工程实践。

## 目录结构

```
.
├── skills/                  # 正式可用的 Skill
│   ├── engineering/         # 工程规范类：代码审查、重构、测试等
│   ├── development/         # 开发流程类：需求分析、调试、发布等
│   ├── misc/                # 其他暂不归类
│   ├── in-progress/         # 编写中，尚未定稿
│   └── archive/             # 已废弃，仅保留存档
├── docs/                    # 设计说明、使用笔记
├── ref/                     # 参考的开源 Skill（不入库，见 .gitignore）
└── README.md
```

## 当前 Skill

一套原子化的开发 skill（参考 matt-pocock 的 skills 改造，面向 C# 工控/桌面端），按功能分两类：**开发时技能**（`skills/development/`，需求分析、规划、实现、调试等流程）与**工程化技能**（`skills/engineering/`，代码审查、架构健康、词汇规范等作用于代码库质量的纪律）。全套流程的路由见 `ask-flow`。

### 开发时技能（`skills/development/`）

需求分析、规划、实现、调试等开发流程中使用的技能。

#### 流程骨架

| Skill                | 用途                                                                                |
| -------------------- | ----------------------------------------------------------------------------------- |
| `setup-dev-workflow` | 为目标仓库配置工单跟踪、手动验证约定（工控/纯桌面端）、文档布局；首次使用前运行一次 |
| `ask-flow`           | 不确定该用哪个 skill / 流程时的路由器                                               |
| `grill-with-docs`    | 面试打磨想法，沿途沉淀 `CONTEXT.md` 词汇表与 ADR                                    |
| `grill-me`           | 同一面试的无状态入口（不在仓库中时使用）                                            |
| `grilling`           | 面试原语：分轮、frontier、推荐答案                                                  |
| `to-spec`            | 把对话综合成 spec，发布到工单跟踪处                                                 |
| `to-tickets`         | 把 spec/计划拆成 tracer-bullet 工单，验收标准为手动验证步骤                         |
| `implement`          | 逐片段实现；每片段完成后停下，给用户手动验证步骤，确认通过才继续                    |

#### 入口坡道（分析类）

| Skill             | 用途                                                          |
| ----------------- | ------------------------------------------------------------- |
| `triage`          | 把外来 bug/请求在分诊角色状态机里移动，产出 agent-ready 工单  |
| `diagnosing-bugs` | 疑难 bug 诊断闭环：先建紧致反馈闭环再假设，修复后手动回归验证 |
| `wayfinder`       | 超大多会话工作的决策地图：decision tickets + fog of war       |

#### 独立工具

| Skill              | 用途                                                                |
| ------------------ | ------------------------------------------------------------------- |
| `prototype`        | 一次性代码回答设计问题（逻辑/状态模型或 UI）                        |
| `research`         | 后台 agent 对照一手资料调研，产出带引用的 markdown                  |
| `to-questionnaire` | 把认知差写成问卷，向持有知识的人索取答案                            |
| `wizard`           | 只有人能走的步骤（厂商软件/授权/驱动/下载程序）生成 PowerShell 向导 |
| `handoff`          | 把当前会话压缩成交接文档供新会话继续                                |
| `wait-what`        | 没听懂时的重讲纠正器                                                |

### 工程化技能（`skills/engineering/`）

作用于代码库质量与规范的纪律，不属于具体开发流程：

| Skill                           | 用途                                                                |
| ------------------------------- | ------------------------------------------------------------------- |
| `code-review`                   | 变更审查：实现质量（合理性/SOLID/风险/注释）+ Spec 两轴并行子 agent |
| `improve-codebase-architecture` | 扫描深化机会，HTML 报告呈现，挑中后进入 grilling loop               |
| `codebase-design`               | 深模块词汇（module/interface/depth/seam/adapter/leverage/locality） |
| `domain-modeling`               | 领域词汇纪律：`CONTEXT.md` 词汇表与 ADR                             |
| `resolving-merge-conflicts`     | 按意图逐 hunk 解决合并/rebase 冲突，永不 `--abort`                  |
| `writing-for-agents`            | 写 skill / AGENTS.md 等 agent 文档的参考（维护本仓库时用）          |

主流程：`grill-with-docs` →（单会话直接 `implement`；多会话则 `to-spec` → `to-tickets` → 逐工单 `implement`）。

与常见流程的关键差异：**不写单元测试和自动化验收脚本**，验收由用户按验证步骤手动运行程序确认；编译检查（`dotnet build`）保留。`tdd` 与 `teach` 未移植（前者被本约定取代，后者非开发流程）。

## Skill 规范

每个 Skill 为一个独立目录，至少包含一个 `SKILL.md`：

```
skills/engineering/my-skill/
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

## 参考来源

`ref/` 存放收集的开源 Skill 实现，仅作本地参考，已加入 `.gitignore` 不入库。

| 仓库                                                                            | 说明                                                                                                                                                                                                                                                      |
| ------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [mattpocock/skills](https://github.com/mattpocock/skills)（`ref/skills/`，MIT） | 本仓库的主要参考：grilling 面试机制、to-spec / to-tickets / implement 主流程、两轴 code-review、wayfinder 决策地图等均移植自这里，并按 C# 工控/桌面端场景改造（去 TDD、本地 markdown 工单、手动验证回环）。原版面向 TypeScript Web 开发 + GitHub Issues。 |
