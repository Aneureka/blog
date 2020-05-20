---
title: ANIMATE ME! —— 似乎我们都可以拥有自己的二次元头像了
date: 2019-08-22 22:24:53
tags: 神经网络 风格转换
---

最近一两个月 Junho Kim 一伙儿提出 [U-GAT-IT](https://arxiv.org/abs/1907.10830) 无监督方法来搞图片风格转换，在 selfie2anime、horse2zebra 等场景下取得了第一名的好成绩，一下子斩获了 Github trending 的头名。于是乎...<!-- more -->

下面是论文中的一些例子，是不是看起来还不错~

![image-20190822223430022](http://ww4.sinaimg.cn/large/006y8mN6ly1g68txiksikj31c60eakjl.jpg)

这里面关注度最高的当然是 selfie2anime 啦，毕竟谁都想打破次元壁，看看自己在二次元世界里面能不能逆袭嘛（

俺也一样，所以在作者放出预训练模型之后，我第一时间就尝试了一下（没办法自己 Google cloud 的乞丐显卡真的训练不起来，而且还是 from scratch...），拿自己开刀的结果是有点惨不忍睹，这里就不放图了 233

但我相信之后模型会优化地越来越好，所以决定在预训练模型的基础上做个小程序，让更多人快速认识到自己就算在二次元里也是 choubi 的事实...

于是乎，`ANIMATE ME!` 就诞生啦，命名延续自在下上一个小作品 [PUSH TO KINDLE!]([https://tokindle.top](https://tokindle.top/) ，要是能作出一个系列就好了呢... （在想 peach ）

放一些小程序的截图，现在功能还比较简单，基本就是上传、转换、预览...（好看吗 ^_^）

![screenshot](http://ww2.sinaimg.cn/large/006y8mN6ly1g68udbhiv1j319r0u04qq.jpg)

会再做一些功能，比如图片编辑呀，加入一些亚洲人的数据集再训练呀 blabla

最后是小程序码 🎊

<img src="http://ww4.sinaimg.cn/large/006y8mN6ly1g68uglzvv1j30k40k4tai.jpg" width="200px" />

忘记说了，小程序端跟后端都是开源哒~

- https://github.com/Aneureka/animate-me
- https://github.com/Aneureka/UGATIT-s2a

望君喜欢~