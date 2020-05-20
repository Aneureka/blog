---
title: 在 macOS 10.13 上编译 py-faster-rcnn 🤞
date: 2018-12-12 18:06:02
tags: computer vision
---

接上一个，这个坑不算多，也比较容易找到相应的 issue（非常感谢 <code>py-faster-rcnn</code> 的开发者），建议配合上一篇 [caffe 的安装配置](https://aneureka.github.io/2018/12/12/caffe-install-on-macos) 阅读~<!-- more -->



## 基本配置

👉 Clone 一下项目源码，记得加上 recursive 模式（项目中引用了 <code>caffe-fast-rcnn</code> 子模块）

```bash
git clone --recursive https://github.com/rbgirshick/fast-rcnn.git
```

👉 进行一些 <code>cpu-only</code> 相关的代码修改

1. 在文件 <code>./lib/fast_rcnn/config.py</code> 中将 <code>USE_GPU_NMS</code> 设为 **False**

2. 在文件 <code>./tools/test_net.py</code> 和 <code>./tools/train_net.py</code> 中将 <code>caffe.set_mode_gpu()</code> 替换为 <code>caffe.set_mode_cpu()</code>

3. 在文件 <code>./lib/setup.py</code> 中注释掉一些代码（总共三处）

   ```python
   # CUDA = locate_cuda()
   
   # self.set_executable('compiler_so', CUDA['nvcc'])
   
   # Extension('nms.gpu_nms',
   #     ['nms/nms_kernel.cu', 'nms/gpu_nms.pyx'],
   #     library_dirs=[CUDA['lib64']],
   #     libraries=['cudart'],
   #     language='c++',
   #     runtime_library_dirs=[CUDA['lib64']],
   #     # this syntax is specific to this build system
   #     # we're only going to use certain compiler args with nvcc and not with
   #     # gcc the implementation of this trick is in customize_compiler() below
   #     extra_compile_args={'gcc': ["-Wno-unused-function"],
   #                         'nvcc': ['-arch=sm_35',
   #                                  '--ptxas-options=-v',
   #                                  '-c',
   #                                  '--compiler-options',
   #                                  "'-fPIC'"]},
   #     include_dirs = [numpy_include, CUDA['include']]
   # ),
   ```

4. 在文件 <code>./lib/fast_rcnn/nms_wrapper.py</code> 中注释掉 gpu 相关的代码

   ```python
   from fast_rcnn.config import cfg
   # from nms.gpu_nms import gpu_nms
   from nms.cpu_nms import cpu_nms
   
   def nms(dets, thresh, force_cpu=False):
       """Dispatch to either CPU or GPU NMS implementations."""
   
       if dets.shape[0] == 0:
           return []
       # if cfg.USE_GPU_NMS and not force_cpu:
       #     return gpu_nms(dets, thresh, device_id=cfg.GPU_ID)
       else:
           return cpu_nms(dets, thresh)
   ```

5. 将项目中的 <code>caffe-fast-rcnn</code> 编译为 <code>cpu-only</code> 模式（下面会讲到，并参考 [caffe 的安装配置](https://aneureka.github.io/2018/12/12/caffe-install-on-macos)）

👉 编译项目的依赖库（Cython）

```
cd $FRCN_ROOT/lib
make
```

👉 编译 caffe 和 pycaffe

```bash
cd $FRCN_ROOT/caffe-fast-rcnn
cp Makefile.config.example Makefile.config
```

👉 在 <code>Makefile.config</code> 配置文件中取消这些注释：

```makefile
CPU_ONLY := 1

BLAS := open
# If you install openblas via Homebrew
BLAS_INCLUDE := $(shell brew --prefix openblas)/include
BLAS_LIB := $(shell brew --prefix openblas)/lib

# If you use anaconda python
ANACONDA_HOME := $(HOME)/anaconda2
PYTHON_INCLUDE := $(ANACONDA_HOME)/include \
		$(ANACONDA_HOME)/include/python2.7 \
		$(ANACONDA_HOME)/lib/python2.7/site-packages/numpy/core/include \
PYTHON_LIB := $(ANACONDA_HOME)/lib

WITH_PYTHON_LAYER := 1

USE_PKG_CONFIG := 1
```

👉 编译

```
make -j8 && make pycaffe
```

可能会出现 <code>Library not loaded: libcaffe.so.1.0.0-rc3</code> 或类似的问题，是因为 <code>libcaffe.so</code> 没有在 DYLD_LIBRARY_PATH 里面，可以手动将 <code>./caffe-fast-rcnn/build/lib/</code> export 到 DYLD_LIBRARY_PATH 中，但更方便的做法是把 <code>./caffe-fast-rcnn/build/lib/libcaffe.so.1.0.0-rc3</code> 复制到 <code>/usr/local/lib</code> 文件夹里面去。

👉 下载模型（为了跑 demo）

```
cd $FRCN_ROOT
./data/scripts/fetch_fast_rcnn_models.sh
```

然后会发现这个几百MB的文件下载得很慢，还可能最终会 Giving up，可以在脚本里面看它的下载位置，用 Chrome 或其他下载工具下载后将 <code>faster_rcnn_models.tgz</code> 复制到 <code>./data</code> 文件夹里面并用 <code>tar zxvf faster_rcnn_models.tgz</code> 将其解压；其它脚本中的文件同理，这时候也可以一并下载下来了。

👉 跑 demo

```
cd $FRCN_ROOT/tools
./demo.py --cpu
```

然后就开心地发现跑通 demo 啦~ 结果大概是这样的

<img src="https://i.loli.net/2018/12/12/5c11032baad7d.png" width="500px" />



后续将会更新训练模型的其他过程和注意点~



## 其他相关资料

如果以上仍不足够解决大家的问题，欢迎在留言区评论，另外大家也可以项目的 issue 或参考以下这些材料，很可能你问题的答案能在里面找到👇

[mac上跑仅cpu模式的fast-rcnn](https://blog.csdn.net/ZYhhhh233/article/details/79971634)

[mac下编译cpu only caffe并用xCode建caffe工程](https://www.cnblogs.com/zhengmeisong/p/9024553.html)

[Issue - How to setup with CPU ONLY mode](https://github.com/rbgirshick/py-faster-rcnn/issues/123)

[Issue - I got the error when running demo.py](https://github.com/rbgirshick/py-faster-rcnn/issues/8)

[Issue - libcaffe.so.1.0.0-rc3 problem](https://github.com/BVLC/caffe/issues/3597)

