---
title: Linux Archive
date: 2017-11-10 23:39:48
tags: Linux
---

## 下载

* Ubuntu 16.04：http://releases.ubuntu.com/16.04/
* Ubuntu 14.04：http://releases.ubuntu.com/14.04/<!-- more -->

## 安装（双系统）

#### 工具

EasyUEFI(uefi+gpt), EasyBCD(bios+mbr), UltraISO, 分区助手, DiskGenius...

#### 教程

* Ubuntu 16.04与Win10双系统双硬盘安装图解：

  http://m.blog.csdn.net/fesdgasdgasdg/article/details/54183577

* Windows下安装Ubuntu 16.04双系统：

  http://www.cnblogs.com/Duane/p/5424218.html

#### 卸载（双系统）

* UEFI+GPT安装WIN10、Ubuntu双系统后彻底删除Ubuntu教程：

  http://tieba.baidu.com/p/4485862313

* 一台电脑上含有多个ubuntu系统的卸载方法：

  http://www.cnblogs.com/woshijpf/p/3835659.html


## 基本配置

#### 常用软件

* 资源：http://songqinglong.blog.51cto.com/7591177/1950125

* 搜狗输入法：http://www.jianshu.com/p/620f123da7cb

* chrome：https://my.oschina.net/Data01/blog/700821

#### FQ

* 安装Shadowsocks-Qt5：https://github.com/shadowsocks/shadowsocks-qt5/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97

* 设置开机自启动：http://www.afox.cc/archives/83

* 配置SwitchyOmega：https://github.com/FelisCatus/SwitchyOmega/wiki/GFWList

* 双显卡切换：http://abcdxyzk.github.io/blog/2013/03/26/ubuntu-use-nvidia/

* 更改PIP源：http://www.cnblogs.com/microman/p/6107879.html

* 切换python2和3：http://blog.csdn.net/sinat_37345418/article/details/68945662

* 双系统时间不同步的问题：https://ziyoo.ren/2016/12/ubuntu-windows-wrong-time/

* 解决Linux关闭SSH后程序终止的问题：http://zjking.blog.51cto.com/976858/1117828

* 关闭占用80端口进程：lsof -i:80   ;    ps -9 [pids]

## 软件配置

#### MKL(Intel Math Kernel Library)

* https://registrationcenter.intel.com/en/products/postregistration/?dnld=t&SN=33RM-4WXJW6ML&EmailID=972579500@qq.com&Sequence=2071221（需要先邮箱申请）
* http://blog.csdn.net/ray_up/article/details/38683383
* http://www.cnblogs.com/yzsatcnblogs/p/4432450.html

#### Cuda(Nvidia)

* https://developer.nvidia.com/cuda-downloads
* http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/
* http://blog.csdn.net/masa_fish/article/details/51882183
* http://notes.maxwi.com/2017/02/26/ubuntu-cuda8-env-set/
* https://askubuntu.com/questions/760492/login-loop-after-upgrade-to-16-04
* https://www.zhihu.com/question/35249192
* http://blog.csdn.net/wkk15903468980/article/details/56489704
* http://www.linuxdiyf.com/linux/26370.html

#### Tensorflow

* http://blog.csdn.net/tina_ttl/article/details/51762471


## 常见问题

#### 驱动
* 连不上Wifi：http://www.linuxdiyf.com/linux/26162.html
* 网卡驱动没有安装：http://www.360doc.com/content/13/1230/16/13232598_341274239.shtml
* 安装无线网卡驱动：
  http://blog.sina.com.cn/s/blog_77e29a590102w0hv.html
  https://askubuntu.com/questions/215498/how-to-install-qualcomm-atheros-ar9565-wireless-drivers

#### grub
* 开机进入grub问题：http://m.blog.csdn.net/canghai1129/article/details/38655899


## 虚拟机

* VMware Tools：http://www.linuxidc.com/Linux/2016-04/130807.htm


## 学习

#### 资料

* 鸟哥的Linux私房菜：http://linux.vbird.org/​

#### 数据库

* 导入、导出数据库命令：http://www.cnblogs.com/jiunadianshi/articles/2022334.html


## 服务器

#### Centos

* 定时运行脚本：http://blog.csdn.net/netdxy/article/details/50562864
* Xshell上传文件：http://www.linuxidc.com/Linux/2015-05/117975.htm
* 安装Jenkins：https://segmentfault.com/a/1190000004639325
* 安装Git：https://my.oschina.net/antsky/blog/514586
* 6.x 升级Python版本：https://ruiaylin.github.io/2014/12/12/python%20update/
* CentOS 7 安装Python3、pip3：https://ehlxr.me/2017/01/07/CentOS-7-%E5%AE%89%E8%A3%85-Python3%E3%80%81pip3/
* Shadowsocks
     * 配置Shadowsocks：http://morning.work/page/2015-12/install-shadowsocks-on-centos-7.html
     * 使用Shadowsocks代理：http://blog.csdn.net/yanzi1225627/article/details/51121507
     * 配置Shadowsocks客户端：http://www.jianshu.com/p/58b4fb753409
* Yum搭建LNMP环境：http://www.jianshu.com/p/447e02d7951d
* Mysql
     * Yum安装Mysql5.7：http://www.cnblogs.com/jimboi/p/6405560.html
     * Mysql开启远程连接：http://www.111cn.net/sys/CentOS/71588.htm
     * 完全卸载Mysql：http://blog.csdn.net/testcs_dn/article/details/39502475
     * centos7 mysql数据库安装和配置：http://www.cnblogs.com/starof/p/4680083.html
* Java
     * 安装Java JDK注意事项：http://www.cnblogs.com/hanyinglong/p/5025635.html
     * 安装JDK 8：http://www.jianshu.com/p/848b06dd19aa
* Tomcat
     * 安装与配置Tomcat-8：http://blog.sina.com.cn/s/blog_6a7cdcd40101b1km.html
     * 部署多项目：http://www.jianshu.com/p/122563f8e886
     * 部署Java web项目：http://www.cnblogs.com/hanyinglong/p/5024643.html
     * 启动GZIP压缩：http://blog.csdn.net/hbcui1984/article/details/5666327
     * 配置域名访问：http://www.cnblogs.com/qixing/p/3282434.html
* CentOS7下编译安装tesseract-ocr：http://blog.csdn.net/StruggleRookie/article/details/71606540