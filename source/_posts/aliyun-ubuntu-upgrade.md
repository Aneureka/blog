---
title: 阿里云 Ubuntu 14.04 升级到 16.04
date: 2019-07-30 10:07:10
tags: Linux
---

最近因为需要在服务器（Ubuntu 14.04）上安装 PHP7，无奈试了各种方法都没有对应的包，并且一些包也渐渐不支持 14.04 了，所以更新到 16.04，以下是一些记录。<!-- more -->



## 备份系统（建立磁盘快照）

**这一步是一定要做的！！！**

以阿里云 ECS 为例，在控制台中访问对应的 ECS 实例，并对各个磁盘建立快照（现在是收费的，但价格很便宜，可以接受）。



## 更换 source.list

这一步可能阿里云的服务器才需要，或者阿里云的镜像现在崩了，在升级过程中总是提示访问不到对应的链接，遂全部替换成清华的镜像。

1. 备份 source.list

   ```bash
   sudo cp /etc/apt/source.list /etc/apt/source.list.bak
   ```

2. 将阿里云镜像全部替换为清华镜像

   ```bash
   sudo vim /etc/apt/source.list
   ```

   source.list 的内容大概是这样子的：

   ```shell
   deb https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse 
   deb https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse 
   deb https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse 
   deb https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse 
   deb https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse 
   
   # deb-src https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse 
   # deb-src https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse 
   # deb-src https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse 
   # deb-src https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse 
   # deb-src https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
   ```

   在命令模式下，将所有的 `aliyun.com` 替换为 `tuna.tsinghua.edu.cn`。

   ```shell
   :%s/aliyun.com/tuna.tsinghua.edu.cn/g
   ```

   其中 `:s` 命令用来查找和替换字符串，`%` 表示在全局范围内查找，`g` 代表全局作用范围（global）

   然后 `:wq` 保存即可

   

## 更新源

```bash
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
```



## 更新系统

1. 用 tmux 开一个新的窗口，因为 SSH 连接可能会在升级过程中断

   ```bash
   tmux new -s upgrade
   ```

2. 更新系统

   ```bash
   sudo do-release-upgrade
   ```

   然后一路下来选择 y（但也要看清楚哦，根据自己的具体需求）即可，最后重启系统后，检查各个服务运行正不正常，可能需要再调整一下。如果发生了不可修复的情况，考虑用快照回滚磁盘吧。



