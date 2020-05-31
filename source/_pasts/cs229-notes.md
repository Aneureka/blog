---
title: Machine Learning 基础问题的探讨与总结
date: 2018-11-02 20:55:55
tags: machine-learning cs229 
---

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>

这周才开始入门 ML 坑 \_\(:з」∠\)\_ 课程是在B站看的低清无码，达成了“B站学习”成就~🤞

不会重新抄一遍 notes 里面的东西了，就挑一些觉得值得思考的问题啦。<!-- more -->



## BGD 和 SGD 的区别？SGD 为什么会收敛？

BGD 是 batch gradient descent ，每次更新 θ 值都需要用到整个训练集，直到 θ 收敛到某一个数；SGD 是 stochastic gradient descent ，每次更新 θ 只需要用到训练集中的一组数据，所以其优势也直观地体现出来了：快。那么为什么在 SGD 的方法下，θ的值能够收敛，也就是 cost function 相对于 θ 的导数可以收敛呢？BGD 的情况比较容易理解，因为每次所选的数据都是一样的；但 SGD 每次都是随机选的一组数据... 

然后就去 google 了一下，发现 SGD 本来就是不收敛的😅，由于是随机选的数据，它最终总是在最优点附近“跳来跳去”，因为对于随机的样本来说，这些少数的样本在最优点的梯度也未必是0（但整体的梯度是0），mini-batch 也存在这个现象。

但有一个方法可以使 SGD 收敛，就是让 α （step / learning rate）衰减。因为随机梯度很快就能到达最优点附近，如果步长逐步减小，最终它会停在最优点附近一个较优的点上（**但未必正好停在最优点**）。可以看看[知乎](https://www.zhihu.com/question/27012077)上的讨论（该不会暴露了我所谓的 google 就是刷刷知乎吧🤣）...



## 正规方程（normal equations）是怎么来的？

先说说为什么有正规方程这个东西，因为在线性回归中，cost function 是二次函数，所以可以直接用求导的方式得到其最大值。

而 cost function 可以由 θ 与 training set 来表达：

$$J\left ( \theta \right ) = \frac{1}{2} \sum_{i=1}^{m}\left ( h_{\theta} \left ( x^{\left ( i \right )} \right ) - y^{\left ( i \right )}\right )^{2} = \frac{1}{2} \left ( X\theta - \vec{y} \right )^{T} \left ( X\theta - \vec{y} \right )$$

因此结合方阵的迹（trace）的性质可以进行以下推导：

\begin{equation}\begin{split}
\bigtriangledown_{\theta}J\left ( \theta \right ) 
&= \bigtriangledown_{\theta} \frac{1}{2} \left ( X\theta - \vec{y} \right )^{T} \left ( X\theta - \vec{y} \right )  \\\\
&= \frac{1}{2} \bigtriangledown_{\theta} \left ( \theta^{T}X^{T}X\theta - \theta^{T}X^{T}\vec{y} - \vec{y}^{T}X\theta + \vec{y}^{T}\vec{y}\right )  \\\\
&= \frac{1}{2} \bigtriangledown_{\theta} tr\left ( \theta^{T}X^{T}X\theta - \theta^{T}X^{T}\vec{y} - \vec{y}^{T}X\theta + \vec{y}^{T}\vec{y}\right ) \\\\
&= \frac{1}{2} \bigtriangledown_{\theta} \left ( tr\theta^{T}X^{T}X\theta - 2 tr \vec{y}^{T}X\theta \right ) \\\\
&= \frac{1}{2} \left ( X^{T}X\theta + X^{T}X\theta - 2X^{T}\vec{y} \right )  \\\\
&= X^{T}X\theta - X^{T}\vec{y}
\end{split}\end{equation}

其中第三个等号成立是因为实数的迹与其本身相同（实数可以看成“一阶矩阵”），倒数第二个等号利用了 trace 的性质：\\(\bigtriangledown_{A} tr ABA^{T}C = CAB + C^{T}AB^{T}\\) 、\\(trABC = trCAB = trBCA\\) 以及 \\(\bigtriangledown_{A}trAB = B^{T}\\)。

所以为了得到 J 的最小值，我们可以另上一个等式为 0 ，则得到\\(X^{T}X\theta = X^{T}\vec{y}\\)，即$$\theta = \left ( X^{T}X \right )^{-1}X^{T}\vec{y}$$



## 逻辑回归损失函数的说明推导

我们知道逻辑回归函数是 \\(y = \frac{1}{1 + e^{-(w^Tx+b)}}\\) ，可转化为 \\(ln\frac{y}{1-y} = w^Tx+b\\)，这里可以把 \\(y\\) 看做样本 \\(x\\) 作为正例的概率，那么 \\(1-y\\) 也就是负例的概率了。从 [后验概率](https://en.wikipedia.org/wiki/Posterior_probability) 的观点看待这个问题（即 \\(x\\) 的概率分布已知），上式可以重写成 \\(ln\frac{p(y=1|x;\theta)}{p(y=0|x;\theta)} = w^Tx+b\\)。设 \\(p(y=1|x;\theta) = h_\theta (x) \\)，\\(p(y=0|x;\theta) = 1-h_\theta (x) \\)，则有 \\(p(y|x;\theta) = (h_\theta (x))^{y} (1-h_\theta (x))^{1-y}\\)

于是，我们可以用极大似然法来寻找逻辑回归函数的优化目标，也就是说，对于每一个输入样本 \\(x\\) ，我们希望它的计算结果属于其真实标记的概率越大越好。设最大似然函数为 \\(L(\theta)\\)，则有 
\begin{equation}\begin{split} 
L(\theta) 
&= p(\overrightarrow{y}|X;\theta) \\\\
&= \prod_{i=1}^{m} p(y^{(i)}|x^{(i)};\theta) \\\\
&= \prod_{i=1}^{m} (h_\theta (x^{(i)}))^{y^{(i)}} (1-h_\theta (x^{(i)}))^{1-y^{(i)}} \end{split}\end{equation}

显然，寻找 \\(L(\theta)\\) 的最大值相当于寻找 \\(logL(\theta)\\) 的最大值，设 \\(logL(\theta)\\)（实际上是对数似然）为\\(l(\theta)\\)，则 \\(l (\theta) = \sum_{i=1}^{m}y^{(i)}\log h(x^{(i)}) + (1-y^{(i)})(1-\log h(x^{(i)})) \\)，接下来只需要对 \\(l(\theta)\\) 求导就可以得到梯度了。

在求导之前，先说明一下对数几率函数 \\(g(z) = \frac{1}{1+e^{-z}}\\) 导数的性质：\\(g'(z) = g(z)(1-g(z))\\)，具体计算过程这里就不赘述了，直接求导就好。

继续上边的讨论，下面是 \\(l(\theta)\\) 的求导过程：

\begin{equation}\begin{split}
\frac{\partial}{\partial \theta_j} l(\theta)
&= (y\frac{1}{g(\theta^T x)} - (1-y)\frac{1}{1-g(\theta^T x)})\frac{\partial}{\partial \theta_j}g(\theta^T x) \\\\
&= (y\frac{1}{g(\theta^T x)} - (1-y)\frac{1}{1-g(\theta^T x)})g(\theta^T x)(1-g(\theta^T x))\frac{\partial}{\partial \theta_j}\theta^T x \\\\
&= (y(1-g(\theta^T x)) - (1-y)g(\theta^T x)) x_j \\\\
&= (y - h_\theta(x)) x_j
\end{split}\end{equation}

故逻辑回归的优化目标也就确定了，接下来只需要运用梯度下降方法来对 \\(\theta\\) 进行优化：
$$\theta_j := \theta_j + \alpha (y^{(i)} - h_\theta(x^{(i)}))x_j^{(i)}$$ 



## SVM 说明与核心推导

SVM (Support Vector Machine) 即 <code>支持向量机</code> ，其学习目标是使得分离超平面与支持向量（离超平面最近的向量）的距离最大化，也即求出分离超平面 （表示为 <code>wx + b = 0</code> ）对应的 w 和 b ，这可以形式化为一个凸二次规划的求解问题。因此，SVM 学习算法的核心/本质是求解凸二次规划的最优化算法。

支持向量机由简单到复杂可分为三种类型：线性可分支持向量机（硬间隔最大化）、线性支持向量机（软间隔最大化）和非线性支持向量机（核技巧和软间隔最大化）。 接下来讨论的是 SVM 算法推导的核心思想，所以只基于最简单的线性可分支持向量机。

从下图可以看出，我们学习的目标是找出这么一个超平面，使得这个平面距离两边的正负例都尽可能远，这样如果出现一个新的样本，我们就更有把握判断它的正负性（确信程度更高）。而且，在图中可以看到，点 A、B、C 中最终影响到超平面选择的只有点 C。

<img src="https://i.loli.net/2018/12/20/5c1b42e9d7de6.png" width="250px" />

那么如何量化这一段“距离”呢？在超平面 <code>w·x + b = 0</code> 已经确定的情况下，<code>|w·x + b|</code> 能够相对地表示点 x 距离超平面的远近，而 <code>w·x + b</code> 的符号与类标记 y 的符号是否一致可以表示分类是否正确，所以我们可以用 <code>y(w·x+b)</code> 来表示分类预测的正确性与确信度。而 <code>y(w·x+b)</code> 实际上就是 <u>函数间隔</u> 。

表面上函数间隔已经很好地完成了分类预测的正确性和确信度的量化工作，但有一个问题是，只要我们成比例地改变 w 和 b ，比如将它们改成 2w 和 2b ，此时超平面并不会改变，但函数间隔却变成原来的两倍。<u>这也告诉我们</u>，我们可以对 w 施加某些约束，使得 w 和 b 不能再随意地成比例变化。比如我们可以满足 \\(||w|| = 1\\)，这时候函数间隔就变成了几何间隔。

所以，当样本 \\(\left ( x_{i}, y_{i} \right )\\) 被超平面 \\(\left ( w, b \right )\\) 正确分类时，点\\(x_{i}\\) 与超平面  \\(\left ( w, b \right )\\) 的距离是：

$$\gamma_{i} = y_{i} \left ( \frac{w}{||w||}\cdot x_{i} + \frac{b}{||w||}\right )$$

而对于完整的训练集中的所有样本点，几何间隔取各个点与超平面的间隔最小值，即 \\(min \gamma_{i}\\) 。

于是我们的问题转变为求得一个分离超平面，使得上式的值最大。具体可以表示为下面的带约束最优化问题：

\begin{equation}\begin{split}
& \underset{w,b}{max} \quad \gamma \\\\
& s.t. \quad y_{i} \left ( \frac{w}{||w||}\cdot x_{i} + \frac{b}{||w||}\right ) \geqslant \gamma, \quad i = 1,2,...,N
\end{split}\end{equation}

考虑到几何间隔与函数间隔的关系，这个问题可以改写为：

\begin{equation}\begin{split}
& \underset{w,b}{max} \quad \frac{\widehat{\gamma}}{||w||} \\\\
& s.t. \quad y_{i} \left ( w \cdot x_{i} + b \right ) \geqslant \widehat{ \gamma }, \quad i = 1,2,...,N
\end{split}\end{equation}

又因为函数间隔 \\(\widehat{ \gamma }\\) 的取值不会影响到最优化问题的解（显然，当 w 和 b 成比例变化的时候，\\(\widehat{ \gamma }\\) 也会随之成比例变化，从而产生一个等价的问题），所以我们可以取 \\(\widehat{ \gamma } = 1\\) ，将 \\(\widehat{ \gamma } = 1\\) 代入上面的最优化问题，注意到 \\(\underset{w,b}{max}\ \frac{1}{||w||}\ \Leftrightarrow\ \underset{w,b}{min}\ \frac{1}{2} ||w||^{2}\\) ，所以又可以转化为下面的线性可分支持向量机学习的最优化问题：

\begin{equation}\begin{split}
& \underset{w,b}{min} \quad \frac{1}{2} ||w||^{2} \\\\
& s.t. \quad y_{i} \left ( w \cdot x_{i} + b \right ) - 1 \geqslant 0, \quad i = 1,2,...,N
\end{split}\end{equation}

接下来的正在企划中...



## 如何证明 SVM 中最大间隔超平面的存在唯一性？

企划中... DDL 寒假




## 附：一些课程资源

- 视频：[Bilibili](https://www.bilibili.com/video/av14806439?from=search&seid=9371710165798031344)，其他如网易云课堂、youtube都可以~（反正都是渣画质）
- 课程地址：https://see.stanford.edu/Course/CS229
- 一些PS题解：http://nbviewer.jupyter.org/github/zyxue/stanford-cs229/tree/master
- [《统计学习方法》](https://book.douban.com/subject/10590856/)
- 南大计科的《机器学习导论》课程
- 安利一个 emoji 查询网站！https://emojifinder.com

