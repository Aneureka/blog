---
title: 说说并查集吧！
date: 2018-05-26 16:04:27
tags: 算法
---

也是最近遇到的问题，我们都知道无向带权图的最小路径求解有Prim和Kruskal这两个经典的贪心算法（不知道或忘了也没关系，但最好先看一看[后者](https://en.wikipedia.org/wiki/Kruskal%27s_algorithm)的过程）。其中Prim算法执行（调度）的过程比较难，但不用加以判断；Kruskal算法执行容易（只需要拿出当前的最小权重边），但判断（会不会造成环）就要花一定功夫了。每次都用DFS去判断有无环显然不太现实，会浪费很多之前的操作积累的信息。嗯，此时我们就要用到并查集了。<!-- more -->



## 引入

我们先不管并查集是什么，想想，要怎样才能知道，加入当前的最小权重边uv之后，就产生了环呢？那就是在未加入边uv之前，我们已经加入的边构成的最小生成森林中，uv是否已经连通。如果uv已经连通了，那么如果我们再加入uv的话，显然会造成环了；如果uv还没有连通，甚至u或v不在已经构造好的最小生成森林中的话，就不会有环出现了。

所以关键点变成了我们要怎么知道**uv是否连通**，还有要**动态的维护**这个连通/不连通的关系。

而连通意味着“等价”，也就是如果有点abcde是互相连通的，那么这五个点对外界来说它们是“等价”的。比如我要叫这五个人去完成一个任务，我只要在这五个人中选出一个代表，让他去通知他的同伴就行了。

所以并查集就是来维护这么两个动作：

- 并（Union）：把两个元素对应的等价类合并起来，在图中就对应加入两个点构成的边
- 查（Find）：判断两个元素是不是在一个等价类里面，在图中就可以对应“判断两个点是不是连通”的问题了



## 实现

那…怎样实现这么一个数据结构？实现的难点似乎在于我们要动态地去维护每个等价类。

先考虑一下数组吧，比如我们有0到n-1的数字，我们可以开辟一个空间大小为n的数组，每个元素的**下标**也就代表了这个元素。那么数组空间本身要放什么呢？前面说到，我要命令abcde去完成某个任务，那么我最好要能知道一个人（比如e）的代表是谁。所以数组空间可以放某个元素的代表，也就是它所属的等价类的代表。不妨将数组命名为id，则id[k]也就是元素k的代表。

这样的话，find操作就很简单了，只需要check一下两个元素的id一不一样；但union操作就很烦，需要遍历一遍数组，把原先id为q的全改为p。具体的代码如下：

```Java
// O(1)
public boolean connected(int p, int q){
        return id[p] == id[q];
}

// O(n)
public void union(int p, int q){
        int pid = id[p];
        int qid = id[q];
        for (int i = 0; i < id.length; i++)
            if (id[i] == pid)
                id[i] = qid;
}
```

是不是很简单！

但问题来了，如果union操作很多的话，每次都是O(n)的代价，也还是挺伤的。

考虑到connected操作的代价仅仅为O(1)，我们可以考虑分摊一些给union操作。

O(1)，O(n)，分摊后貌似两个就都是O(logn)了呢！那我们可以用树来想这个问题了。

我们可以把每个等价类想成一棵树，所有的等价类就是一个森林。在这种语境下，加入有两个元素p和q，判断p、q在不在一个等价类，只要看它们所在的树的根节点一不一样；合并p、q所在的等价类也只需要找到它们的根节点，假设为root_p、root_q，然后把root_p连到root_q（或者反过来）就行了。看看图（自己画的，有点丑）：

![root-union.png](https://i.loli.net/2018/05/26/5b090ddeda4e8.png)

然后问题来了…怎么去实现这个树（森林）呢？感觉很复杂，每个节点还要保存它的父节点，也就是parent。但实际上想一想又觉得很简单，因为我们竟然不需要知道一个节点的子节点！所以每个节点只需要知道它的parent是谁就行了。所以我们还是可以用上文提到的id数组来实现，只不过此时的id数组得改为parent数组，也就是说数组存的是每个元素的parent。那么union和find的实现就可以写成下面的代码了：

```Java
// to find the root of the element
// if i==id[i], it's the root
private int root(int i){
    while (i != id[i])
        i = id[i];
    return i;
}

// just compare the root of these two element
public boolean connected(int p, int q){
    return root(p) == root(q);
}

// connect the root of these two element
public void union(int p, int q){
    int i = root(p);
    int j = root(q);
    id[i] = j;
}
```

是不是感觉也挺好理解？



## 优化

以上也就是并查集的两种常见的实现了，虽然第二种方法较好的分摊了find和union的复杂度，但毕竟根本上是树实现，树实现总会遇到个问题——不平衡。我们知道在树中查找一个元素的root跟这个元素在树中的深度是正相关的，所以最好不要让一个元素的深度过大。

确定目标：尽量**降低树的高度**。

较为简单的做法是，我们可以用一个新的数组size来存储每个树的大小（即权重），并加以维护。这样在union的时候，我们可以将size较小的树挂到size较大的树上去。详细的代码在这：[WeightedQuickUnionUF](https://github.com/Aneureka/Algorithm/blob/master/src/main/java/union_find/WeightedQuickUnionUF.java) （之前写的了）

另外一个做法是路径压缩，也就是，在我们查找元素的时候，顺便把它到root的路径上的所有点都直接挂到root上。最终希望达成的效果应该是所有的元素都直接挂到root上面。find操作的代码是这样的：

```Java
public int find(int p){
    int root = p;
    while (root != id[root])
        root = id[root];
    // compress all the nodes in the path
    while (p != root){
        int newp = id[p];
        id[p] = root;
        p = newp;
    }
    return root;
}
```



## 后语

关于并查集就说这么多啦，就当做是复习了。

相关代码可以看我的github~

 https://github.com/Aneureka/Algorithm/blob/master/src/main/java/union_find/QuickFindUF.java

第二篇了😋~
