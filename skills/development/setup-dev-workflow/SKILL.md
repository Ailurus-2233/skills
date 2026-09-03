---
name: setup-dev-workflow
description: "为本仓库配置开发工作流：工单跟踪方式、手动验证约定、领域文档布局。首次使用其他流程类 skill 前运行一次。"
disable-model-invocation: true
---

# 配置开发工作流

为目标仓库生成其他 skill 依赖的约定文件。本 skill 面向 **C# 桌面端**场景（工控：WPF/WinForms + PLC/串口/总线通信；或纯桌面端）：通常无公网 issue tracker、无法靠自动化测试验收，工控项目的验证还依赖真实设备或仿真器。

这是对话驱动的 skill，不是脚本：先探索，再向用户汇报，确认后才写入。

## 流程

### 1. 探索

查看仓库现状，不要假设：

- `git remote -v`：是否有远端？指向哪里？（工控项目常无远端或在私有 Git 服务器）
- 仓库根部的 `AGENTS.md`：是否存在？是否已有 `## Agent skills` 段落？
- `CONTEXT.md`、`docs/adr/`、`docs/agents/`：是否已存在？
- `.scratch/`：是否已有本地 markdown 工单惯例？
- 解决方案结构：`.sln`、几个项目、UI 框架（WPF/WinForms/Avalonia）、通信层（Modbus/S7/OPC UA/串口）等，用于理解验证手段。
- 是否有仿真器/模拟器（如 Modbus 仿真、PLC 仿真）可作为验证环境。

### 2. 汇报并逐节确认

汇总现状，然后按节提问。每节给出推荐答案，用户可以一句话接受；探索已定论的节直接跳过。

**Section A：工单跟踪（issue tracker）**

> 说明：工单是 to-spec / to-tickets 读写的工作单元。工控桌面项目推荐**本地 markdown**，不依赖任何外部服务。

默认推荐 **本地 markdown**（工单存于 `.scratch/<feature>/issues/`）。可选：

- **本地 markdown**（推荐）：零依赖，随仓库走，适合单机/内网开发
- **GitHub**：远端在 GitHub 且有网时使用（`gh` CLI）
- **其他**（GitLab、私有系统）：让用户一段话描述工作流，原样记录

记录到 `docs/agents/issue-tracker.md`。

**Section B：验证约定**

> 说明：本工作流**不用自动化测试做验收**。每个实现片段完成后，agent 停下来给出手动验证步骤，由用户实际运行程序确认。

先确认项目类型，这决定验证手段的天花板：

- **工控项目**（涉及 PLC/串口/总线等设备通信）：继续问清——
  - 验证环境：真实设备 / 仿真器 / 两者（默认：仿真器优先，关键路径过真实设备）
  - 日志位置：验证时观察哪个日志/界面（默认：应用内日志窗口 + 通信报文界面）
- **纯桌面端**（不依赖任何硬件）：验证只需在本机启动应用操作界面即可，**不要求硬件环境**，agent 生成验证步骤时不得包含连接设备/仿真器一类前提。

两者都要确认：

- 启动方式：Visual Studio F5 / `dotnet run` / 已部署的 exe（默认：仓库根 README 写明，agent 引用）

记录到 `docs/agents/verification.md`（含项目类型结论），`implement` 每次生成验证步骤时遵守。

**Section C：文档布局**

默认 **single-context**（根部一个 `CONTEXT.md` + `docs/adr/`），不问直接写。仅当仓库是多解决方案的大型 monorepo 时才提供 multi-context 选项。

记录到 `docs/agents/domain.md`。

### 3. 确认后写入

先把以下内容草稿给用户过目，允许修改：

- 要写入 `AGENTS.md` 的 `## Agent skills` 块
- `docs/agents/issue-tracker.md`、`docs/agents/verification.md`、`docs/agents/domain.md` 的内容

目标文件固定为 **`AGENTS.md`**：存在则编辑；不存在则创建。不使用 `CLAUDE.md`。

已有 `## Agent skills` 块时原地更新，不追加、不覆盖周围用户内容。

块的内容：

```markdown
## Agent skills

### 工单跟踪

[一句话说明工单在哪]。见 `docs/agents/issue-tracker.md`。

### 验证约定

[一句话说明验证环境]。见 `docs/agents/verification.md`。

### 领域文档

[一句话说明布局]。见 `docs/agents/domain.md`。
```

`.gitignore` 中若无 `.scratch/`，询问用户是否忽略它（推荐：不忽略，工单随仓库提交，保留决策痕迹）。

### 4. 完成

告知用户配置完成、哪些 skill 会读取这些文件。以后可直接编辑 `docs/agents/*.md`；只有更换工单跟踪方式时才需要重跑本 skill。
