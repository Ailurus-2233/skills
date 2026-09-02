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

`ref/skills/` 存放收集的开源 Skill 实现，仅作本地参考，已加入 `.gitignore`。
