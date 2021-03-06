---
title: 动态规划的初心者视角
date: 2018-05-29 16:59:15
tags: 算法
---

“初心者”是在下中学沉迷的游戏《水浒Q传》对未转职新手的称谓，这个称呼真的很Nice！而动态规划问题作为一类使无数玩家望而却步的经典问题，也是必须要面对的中期BOSS了。这一期（？）我们就以初心者的角度来聊一聊动态规划究竟是怎样一种思想，一些相关经典问题，以及如何去感受其数学之美。<!-- more -->

之后如果能理解得更深刻，肯定会补上DP的其他问题的！



## 一步

那么，动态规划——该怎么去理解它？

我们知道，平常在编写程序时，时不时会提到“代码逻辑优化”。这个“优化”实质上大部分情况是在争取**减少无关运算**（如DFS剪枝）或把程序执行过程中**重复的运算减少**。

动态规划即是针对后者，把一个问题划分为多个子问题，求解完所有子问题，从而得到问题的解（是不是有点递归的意思），但与朴素递归不同的是，动态规划试图仅仅解决每个子问题一次，并记下执行结果，当重复执行的时候直接“查表”，从而去减少计算量。

知道了动态规划的执行过程之后，大概也知道动态规划的适用情况了：

- 最优子结构性质。动态规划问题必须要是“可规划”的，也就是说，一个问题要能够被拆解为几个子问题，	比如一个问题的最优解要依赖于子问题的最优解。这大概也是动态规划问题最难的地方，我们需要去找出问题中隐含的递推关系（即找出状态转移方程）。
- 无后效性。子问题的解一旦确定之后，就不能再去改变它了。因为在子问题求解完之后我们就把它当成字典中的一项来查了。这个问题会在后面的例子里面再次提到。
- 子问题重叠性质。前面说了，动态规划的目标是通过减少子问题的重复求解来降低程序复杂度。如果子问题完全不重叠，那动态规划还不如直接DFS呢。



## 大爆炸

我们以斐波那契这个经典问题为例子，虽然这个例子并不是最好的（比如它没有体现出“最优”转换），但它足够简单，也可以解释清楚动态规划到底是什么东西。

#### 递归解法

这个大概没有不会的了。直接利用斐波那契数列的递归定义就行了，F\(n\) = F\(n-1\) + F\(n-2\)~

```C
int fib(int n) {
    if (n < 0)
        return -1;
    if (n == 0 || n == 1)
        return n;
    return fib(n-1) + fib(n-2);
}
```

执行的过程是这样的——

![斐波那契递归](https://i.loli.net/2018/05/29/5b0d25ee506c0.png)

其中F(n-2)需要求解2次，F(n-3)需要求解3次，不断委托下去，可以想象F(1)和F(2)最后被求解的次数将会很大很大。而实际上是可以将它们的求解结果先存起来的。



#### 拓扑分析

（中间玩个了游戏玩的头疼..Euclidea…）

我们可以用一个图来阐明斐波那契数列的递推关系：

![斐波那契递推关系](https://i.loli.net/2018/05/30/5b0d798561f82.png)

可以清楚地看出各个项目之间的依赖关系，而且这种依赖关系将构成一个有向无环图。换言之，整个问题集合的依赖关系构成的图满足某种**拓扑排序**。所以我们才可以依照这个排序去逆向地思考递归问题。比如在这个斐波那契问题中：

① 我们首先求出影响最小的节点（不依赖于其他任何节点）的值，如F(0)，并将其结果保存起来；

② 然后去掉F(0)，继续步骤 ①，直到F(n)求解完毕

代码如下：

```c
// 在这个具体问题中，我们还可以优化存储方案，因为我们知道F(n)只会依赖于F(n-1)和F(n-2)，而不会再依赖于更前的结果，所以我们可以根据其变量声明周期，减少存储空间利用
int fib_dp(int n) {
    if (n < 0)
        return -1;
    if (n == 0 || n == 1)
        return n;
    int fn; // f(n)
    int fn_1 = 1; // f(n-1)
    int fn_2 = 0; // f(n-2)
    for (int i = 2; i <= n; i++) {
        fn = fn_1 + fn_2;
        fn_2 = fn_1;
        fn_1 = fn;
    }
    return fn;
}
```



## 闪念

从上面的一个简单例子，我们可以抽象出动态规划问题的整体框架：

- 找出问题与子问题之间的递推关系，即写出状态转移方程。斐波那契问题之所以简单也是因为它的递推关系已经非常明显，但这一步往往是最难想到的，也是问题关键点所在。
- 建立各个问题间的DAG，也就是建立出子问题间依赖的拓扑序列。我们关注的是建立这样的拓扑序列，而不关系具体的形式。比如大多数DP问题（如背包问题）一般用二维数组来存储子问题的解，但这并不重要。
- 逆向执行递归过程。

嗯，这次的入门级DP也就讲到这儿啦，希望能对DP有个基础的框架性的理解，会尝试着用动态规划的思维方式去想一些问题。DP的问题形式有很多，接下来应该还会讲到背包问题、划分型DP、树形DP等其他经典的问题。

我觉得最重要的还是在编写程序的时候，要有意识地去分析算法的复杂度，以及算法执行的过程，特别是递归问题（如经典的DFS），是否会产生大量的重复运算，要怎么去解决它。

（感谢锤子的标题支持）



