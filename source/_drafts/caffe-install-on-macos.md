---
title: macOS 10.13 安装 caffe 避坑攻略
date: 2018-12-12 00:35:50
tags: caffe
---

不吹不黑，坑是真的多，下面说的是（基本）无痛的步骤，仅限 macOS 哦，有问题可以在下面留言，咱们一起探♂讨。<!-- more -->


## 开发环境

** 👉 系统版本：macOS High Sierra**
没错，被迫从 Mojave 降级回去了，不然首先 snappy 就安装失败，顺便贴个[系统降级教程](https://www.macdu.org/site/download?_=Z5xtYmw)

** 👉 Python 环境：Anaconda2**
我觉得装这个应该是最省事的了，官网下载（比较慢），记得安装的时候选择安装到~目录下，然后加进去环境变量，比如如果用 zsh 的话，在 ~/.zshrc 里面加两句
```bash
export ANACONDA_HOME=$HOME/anaconda2 # 注意这里的2（也可能没有）
export PATH=$ANACONDA_HOME/bin:$PATH
```
最后 source 一下

** 👉 Xcode 10.1**
在 App Store 装一下

** 👉 Homebrew**

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```






## 依赖安装

安装一些（应该）会用到的工具：

```bash
brew install cmake
```

安装 Caffe 所需的依赖（这一步坑挺多的），如果已经安装的话，建议先卸载

```bash
brew install -vd snappy leveldb gflags glog szip lmdb
brew install openblas
brew install hdf5 opencv

# 这一步很重要，直接安装boost会安装成1.68或以上的版本，在我的环境下老是会出错，cmake的时候会找不到boost..(坑一)
brew install boost@1.59 boost-python@1.59
# 链接boost和boost-python
brew link --force boost@1.59
brew link --force boost-python@1.59
```

#### 安装 protobuf

直接从 Homebrew 安装 protobuf 会安装成 3.6.1 的版本，不能正确编译（坑二），可以直接 source 编译 protobuf 的 3.5.1 版本。

在某一个你常用的目录下（比如 ~/Downloads 或 ~/Desktop）：

```bash
# brew install wget
wget https://github.com/protocolbuffers/protobuf/archive/v3.5.1.zip
unzip protobuf-3.5.1.zip
cd protobuf-3.5.1
./autogen.sh
./configure
make
make install
```



## 安装 Caffe

#### 下载 Caffe

直接从 Github 上拉取：

```
# cd ~
git clone https://github.com/BVLC/caffe.git
cd caffe
```

#### 编译

这一步分成两种做法，一种是修改 Makefile.config 直接 make，另一种是先 cmake。这里我们用 cmake（两种都试过，最终还是用 cmake 了，坑少）

```
cd your/path/to/caffe
mkdir build
cmake ..
```

在这一步如果 boost 是直接从 Homebrew 安装的会提示找不到 boost，很迷。

然后在 build 文件夹里面修改一些文件的编译选项，主要是因为我们是用 CPU_ONLY 的方式去编译的

1. 修改 CMakeCache.txt

   ```
   // Build Caffe without CUDA support
   - CPU_ONLY:BOOL=OFF
   + CPU_ONLY:BOOL=ON
   ```

2. 修改 CaffeConfig.cmake

   ```
   # Cuda support variables
   - set(Caffe_CPU_ONLY OFF)
   + set(Caffe_CPU_ONLY ON)
   ```

然后依次执行：

```
make all
make runtest
make pycaffe
```

如果出现 "no module named caffe" 的话（我没出现这个情况😝），在设定环境变量的文件加入：

```
export PYTHONPATH=path/to/your/caffe/python:$PYTHONPATH  
```



## 参考资料

[MacOS mojave cmake 安装caffe](http://codeleading.com/article/455156487/)

（其实参考了很多，但基本都没啥用，主要还是因为其他教程比较老.. 推荐在谷歌搜这种实时性比较强的资料的时候先**设定搜索日期**，避免找到往往没有用甚至产生新坑的远古资料）