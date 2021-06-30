---
title: 分享我的 Notion 使用方式
date: 2021-05-08 00:17:54
tags:
	- Note
	- Productivity
---

[Notion](https://www.notion.so/) 是我最喜爱的笔记软件（或谓之知识管理工具），从去年到现在通过 Notion 记录了包括学习、读书、日记、项目等方面（当然还有补番目录）的几十篇笔记，也渐渐喜欢上了写作和阅读。下面跟大家分享我的使用实践，希望能跟大家一起探讨，挖掘出工具更大的价值~

### 将 Notion 分为 private 和 public workspace

private workspace 用于记录个人的学习笔记、读书笔记、项目计划和每日日记。

public workspace 用于发表在公众场合的文章、感想或简历（比如这篇小文章）。

这样做的好处是能做到比较简明的权限分离，也能更专注地写作。

<div align="center">
<img src="https://i.loli.net/2021/05/14/vlCQS2KJu9NcpU5.jpg" width="300px" />
</div>


### 使用 「链接 + 搜索」代替「页面树」

无限层级是 Notion 一个很有用的特性，我们自然而然地会把它当成”文件夹“使用（我原来的做法）。”文件夹“的好处是能在侧栏清晰地看见笔记的层级，比如 learning 页下有 algorithm /  Java / English 等页面，能够自上而下地查看自己当前所建立的”知识管理树“。—— 后来我放弃了。有一个很大的痛点是我没法清晰地理清笔记之间的联系，比如在复习 Java 相关知识的时候，我常常会直接切到 learning / Java 页下复习，而忘记还有另外一个 reading / Thinking in Java 页也整理了 Java 相关的笔记。

因此，在 [Notion backlinks](https://www.notion.so/guides/creating-links-and-backlinks) 出现后，我开始用链接和搜索的方式进行知识组织和管理。在这种模式下，每个 page 都链接或被链接到其他的 page，形成页面间的网状结构。如打开 Java 页会发现 Thinking in Java 链接到此页面，而 Java 页也在页面开头链接了 programming language。在复习时，只需要「⌘ + K」搜索 Java 关键词就能查看 Java 页面，从而理清它的上下游关系。

<div style="display: flex; flex-direction: row; justify-content: space-around; flex-wrap: wrap;">
<img src="https://i.loli.net/2021/05/14/GK3AEnSWRN4tLqM.jpg" width="300px" />
<img src="https://i.loli.net/2021/05/14/hSWY8PHgG64abVo.jpg" width="300px" />
</div>


另外，链接有时候也能充当标签的作用。比如在这篇课程笔记中，涉及到关于 command 相关的笔记时，我会在后面加一个链接，相当于打了一个 command 的 tag。

<div align="center">
<img src="https://i.loli.net/2021/05/14/Sd4w6uTqckhsoOJ.jpg" width="300px" />
</div>


- **Q: 我用页面树就不能搜索了吗，也能看到所有 Java 相关的笔记啊？**

  可以！只是我原来在基于页面树的笔记组织下，不太会想起用「搜索」这个功能，而是习惯在侧栏通过自上而下的方式查找。

- **Q: 为什么要这么麻烦，Notion 不支持 page 级别的 tag 吗，就像博客文章那样？**

  是的！所以这也算是在当前情况下对 Notion tag 的实现方式（你看还支持多层级 tag 呢）。

- **Q: 我在笔记的某个 block 里打 command 的 tag，command 页能链接到这个 block 吗？**

  不能！这也是我对 Notion 的另外一个使用痛点，不支持 block 之间的链接。实际上我也尝试过 [Logseq](https://logseq.com/) 和 [Obsidian](https://obsidian.md/) （[Roamresearch](https://roamresearch.com/) 由于太贵了连试的机会都没），最终还是因为 bug 太多、写作功能太简单而错过了（高情商）。

- **Q: 这种方式相比「页面树」有什么缺点吗？**

  有的。比如目前 Notion 还没有 Graph view，没法像「页面树」那样从宏观上查看笔记的分布和关系，不过没有关西（x），可以等官方的 Notion API~

- **Q：Notion 的搜索功能好用吗？**

  一般。能够支持基本的搜索功能，但不能进行基于组件的搜索，比如不能实现通过 ”TODO“ 或 ”todo:false“关键词搜索到所有的 TODO 事项。

### 将近期常用的笔记加到 Favorites 中，并隐藏 Private section

在基于「链接 + 搜索」的笔记组织方式下，侧栏的笔记列表是平铺开的，而不像「页面树」有鲜明的层级关系，因此一般情况下我的 Private section 都是隐藏的状态，对知识的查找偏向于使用「搜索」功能。一些近期常用的笔记会加到 Favorites 中。

<div align="center">
<img src="https://i.loli.net/2021/05/14/ZkuYNTP3QcmF2qB.jpg" width="300px" />
</div>


### 使用 Notion database 做条目整理

[Notion database](https://www.notion.so/guides/using-database-views) 是 Notion 一个重要的特性，对我来说主要的好处是能通过创建各种 view 配合 filter 实现对条目的管理，也可以做一些简单的看板。

<img src="https://i.loli.net/2021/05/14/sd3v98GrAIuLF6n.jpg" />

### 使用 Notion API 做更多事情 #TODO

目前 [Notion API](https://www.notion.so/api-beta) 还处于开发和内测阶段，刚有了一些进展（从订阅的邮件内容来看），希望后续能通过 API 将 Notion 集成到博客系统中（当然目前也有一些第三方 API 可以用了），方便写作。不过由于众所周知的原因，做成博客的话网络情况应该不会太好。

Notion API 也可以用于做一些浏览器插件，实现比如像 Graph view、悬浮目录这样的好东西。