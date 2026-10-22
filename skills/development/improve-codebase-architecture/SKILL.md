---
name: improve-codebase-architecture
description: 扫描代码库寻找加深机会，以可视化 HTML 报告呈现，然后对你挑中的那个展开追问。
disable-model-invocation: true
---

# 改进代码库架构

暴露架构上的摩擦，提出**加深机会**：把浅模块变成深模块的重构。目标是可验证性与 agent 可导航性。

本命令以项目的领域模型为*依据*，并建立在一套共享的设计词汇之上：

- 加载 "codebase-design"，用其中的架构词汇（**模块**、**接口**、**深度**、**缝**、**适配器**、**杠杆**、**局部性**）分析候选项；描述真实代码时沿用代码里的准确名称。
- `.adev/GLOSSARY.md` 里的领域语言给好的缝命名；`.adev/adr/` 里的 ADR 记录着本命令不应重新翻炒的决策。

## 流程

### 1. 探索

**先定范围再扫描：YAGNI。** 加深一个模块的回报在于让未来对它的改动更容易，所以要多给最近改动过的部分加权。先看哪里，再决定看什么：

- 用户给了方向（某个模块、某个子系统、某个痛点）就照着走，跳过下面的推断。
- 否则，回看足够长的一段提交历史（`git log --oneline`），找出代码库的热点——反复出现的文件和区域，让这些路径先拉住你的注意力。改动分散、没有明显热点时，再把网撒大。

先按 `.adev/agents/domain.md` 定位并读取当前上下文词汇表（单上下文 `.adev/GLOSSARY.md`，多上下文由 `.adev/GLOSSARY-MAP.md` 指向）和你所触及区域的 ADR。

然后走查代码库；范围大且可独立扫描时再派子 agent。不要套死板的启发式；记下有证据的摩擦：

- 哪里要理解一个概念，得在一大堆小模块之间来回跳？
- 哪些模块是**浅**的，接口几乎和实现一样复杂？
- 哪里把纯函数抽出来只是为了"好测"，而真正的缺陷藏在它们的调用方式里（没有**局部性**）？
- 哪些紧耦合的模块在缝上互相渗漏？
- 哪些部分无法通过接口手动验证，或 agent 难以顺着接口导航？

对任何疑似浅模块的东西做**删除测试**：删掉它会让复杂度集中，还是只是挪了个地方？"会集中"正是你要找的信号。

### 2. 以 HTML 报告呈现候选项

候选项较多、关系需要图示时，写一个离线可打开的 HTML 文件到主工作区 `.adev/architecture-reviews/<时间戳>.html`，打开供用户查看并告知绝对路径。只有少量简单候选项时，直接在会话中用 Markdown 报告即可。

HTML 报告使用内联 CSS、手工 div 与内联 SVG；不依赖 CDN。每个候选项配一张能解释变化的前后对比图。

骨架如下，图例与配色约定照用：

```html
<!doctype html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8" />
    <title>{{仓库名}} 架构评审</title>
    <style>
      /* 所有布局、颜色与图形样式写在本文件，保证离线可看 */
      body { margin: 0; background: #fafaf9; color: #0f172a; font: 16px/1.5 system-ui, sans-serif; }
      main { max-width: 1100px; margin: auto; padding: 3rem 1.5rem; }
      article { margin: 2rem 0; padding: 1.5rem; background: white; border: 1px solid #d6d3d1; border-radius: 12px; }
      .comparison { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1rem; }
      svg { max-width: 100%; height: auto; }
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
      @media (max-width: 700px) { .comparison { grid-template-columns: 1fr; } }
    </style>
  </head>
  <body>
    <main>
      <header>...</header>
      <section id="candidates">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

页头只放仓库名、日期和一行紧凑图例：实心框 = 模块，虚线 = 缝，红箭头 = 渗漏，粗黑框 = 深模块。不写引言段，直接进候选项。

每个候选项渲染一张卡片（一个 `<article>`），图承重，文字稀疏：

- **标题**：短，点出这次加深（如"收拢工单接收管线"）。
- **徽章行**：推荐力度 `Strong`（翠绿）/ `Worth exploring`（琥珀）/ `Speculative`（石灰），再加一个依赖类别标签（`进程内` / `本地可替换` / `端口与适配器` / `占位`）。
- **文件**：等宽列表，`font-mono text-sm`。
- **前后对比图**：卡片的主角。两列并排。按候选项选用内联 SVG 依赖图、手工盒子加箭头、剖面图、体量图或调用树坍缩；图形必须在无网络、无脚本时可见。
- **问题**：一句话。痛在哪。
- **方案**：一句话。改什么。
- **收益**：用具体效果说明，例如"缺陷处理集中在一处"、"一个接口服务多个调用点"。避免只有"更易维护"一类无法核实的泛称。
- **ADR 提示**（如适用）：琥珀色底框里一行字。

**领域用 `.adev/GLOSSARY.md` 的词汇，架构用 `/codebase-design` 的词汇。** 如果 `.adev/GLOSSARY.md` 定义了"工单"，就说"工单接收模块"，不说"GongDanHandler"，也不说"工单服务"。

**ADR 冲突**：候选项与既有 ADR 矛盾时，只在摩擦真实到值得重开该 ADR 时才摆出来，并在卡片上标清楚（如琥珀色警示框：_"与 ADR-0007 冲突，但值得重开，因为……"_）。不要把 ADR 禁止的每一个理论上的重构都列一遍。

风格：留白大方，颜色克制——一个主色，红色只给渗漏，琥珀只给警示。用内联 CSS 保证布局和图例离线可读。

报告以 **Top recommendation** 一节收尾：一张更大的卡片，你会先动哪个候选项、为什么，附一个跳到该卡片的锚链接。

报告只提出候选方向，不提前完成接口设计。用户已指定候选项时直接进入第 3 步；否则交付报告供用户选择。

### 3. 追问（grilling）循环

用户挑定候选项后，调用 Skill 工具的 "grilling"，陪他走决策树：约束、依赖、加深后模块的形状、缝后面放什么、哪些手动验证步骤仍然有效。

副作用随决策定型就地发生；调用 Skill 工具的 "domain-modeling"，随时保持领域模型为最新：

- **用 `.adev/GLOSSARY.md` 里没有的概念给加深后的模块命名？** 把该术语补进当前上下文词汇表。文件不存在就懒惰创建。
- **对话中敲细了一个模糊术语？** 当场更新当前上下文词汇表。
- **用户带着承重理由否决了候选项？** 提供一份 ADR，措辞如：_"要不要我把这个记成 ADR，免得以后的架构评审再提同样的建议？"_ 只在该理由确实是未来探索者避免重蹈所需时才提供； 转瞬即逝的理由（"眼下不值得"）和不说自明的理由跳过。
- **想为加深后的模块探索备选接口？** 调用 Skill 工具的 "codebase-design"，用其"设计两次"的并行子 agent 模式。
