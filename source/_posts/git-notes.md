---
title: GIT 小结
date: 2019-08-14 23:34:14
tags: Git
---

记录关于 Git 的一些学习笔记，希望能做到熟练熟练再熟练 🖊<!-- more -->

## overview

- 分布式：DVCS - Distributed Version Control System
- 高性能：
    - 关注内容本身，对 提交修改、融合分支、求取差分对过程都进行了性能优化
    - 使用了 差分编码（Delta Encoding），仅保存代码修改的差分
    - 分布式的架构减轻了中央服务器的性能压力
- 安全性：所有的文件内容、目录结构、版本、标签等都经过加密哈希校验算法（SHA1）保护
- 灵活性（柔软性）：支持非线性的开发工作流程，支持或大或小的软件项目，兼容各种操作系统和协议



## difference between `~` and `^`

`HEAD~` 、 `HEAD^` 或 `HEAD~1` 、 `HEAD^1` 都表示 `HEAD` 的第一个父节点，但 `HEAD~2` 表示 `HEAD` 第一个父节点的第一个父节点，而 `HEAD^2` 表示 `HEAD` 的第二个父节点。这在包含 merge 分支的节点上有所区别

更多的细节 → https://stackoverflow.com/questions/2530060/in-plain-english-what-does-git-reset-do



## git init

`git init [[--bare] <directory>]` 

`--bare` 标记创建了一个没有工作目录的仓库

对于所有的 Git 工作流，中央仓库是**裸仓库**，开发者的本地仓库是**非裸仓库**（向非裸仓库推送分支有可能会覆盖已有的代码变动）

比如可以 ssh 到服务器中，创建一个裸仓库 `git init --bare my-project.git` ，然后用 `git clone` 指令在客户端克隆下来



## git config

`git config [--global] user.name <name>` 

`git config [--global] user.email <email>`

其他还有设置 alias editor 等




## git add

`git add` 命令将工作目录中的变化添加到**缓存区**，通常可以配合 `git status` 使用

缓存区是 Git 三个树状文件结构之一，另外两个是工作目录和提交历史

`git add <file>`

`git add <directory>` 提交目录下的所有更改

`git add -p` 交互式的缓存，一般不会用到




## git status

列出已缓存（已经 add）、未缓存（还没有 add）、未追踪的文件（修改了也不会 add）

```
# On branch master
# Changes to be committed:
# (use "git reset HEAD <file>..." to unstage)
#
#modified: hello.py
#
# Changes not staged for commit:
# (use "git add <file>..." to update what will be committed)
# (use "git checkout -- <file>..." to discard changes in working directory)
#
#modified: main.py
#
# Untracked files:
# (use "git add <file>..." to include in what will be committed)
#
#hello.pyc
```





## git log

显示提交历史

`git log`

`git log -n <limit>`

`git log --stat` 更具体的统计信息，包含哪些文件被更改了，以及每个文件相对的增删行数

`git log -p` 会显示每个提交的细节，包括全部的差异（最详细，与 Github 上的差不多）

`git log --author="<pattern>"` 搜索特定作者的提交

`git log --grep="<pattern>"` 搜索 *commit message* 匹配特定 pattern 的提交

`git log <file>` 只显示包含特定文件的提交

`git log <since>..<until>` 两个参数可以是提交 ID，分支名、HEAD 等

`git log --graph --decorate --oneline --numstat` 其他一些有用的选项

- `--graph` 标记会绘制一幅字符组成的图形，左边是提交，右边是提交信息
- `--decorate` 标记会加上提交所在的分支名称和标签
- `--oneline` 标记将提交信息显示在同一行，一目了然
- `--numstat` 显示提交代码行数统计
- `--pretty=format:"<string>"` 格式化输出

`git shortlog` 便于创建发布声明

`git log` 的内容一般是下面这种形式

```
commit 6f326b35f87c5909f39556a5166a96ca86a22ef4 (HEAD -> master, origin/master)
Author: Hiki [aneureka2@gmail.com](mailto:aneureka2@gmail.com)
Date: Sun Jul 28 18:56:21 2019 +0800

   Complete assignment #2
```

其中 commit 后面的字符串是**提交内容的 SHA-1 校验总和**（checksum）

有两个作用，第一是保证提交的正确性，如果它被损坏，则会生成一个不同的 checksum；第二是代表了某次提交的唯一标识

`HEAD` 指向当前的提交，`~` 用于标识提交的父节点的相对引用，`^` 表示上一个节点

比如 `3157e~1` 表示 `3157e` 的上一个提交，`HEAD~3` 是当前提交的回溯 3 个节点的提交

`..` 句法的 🌰 → `git log --oneline master..some-feature` 显示在 `some-feature` 分支而不在 `master` 分支的提交历史



## git checkout ⭐️

`git checkout` 有三个不同的作用：检出提交、检出文件和检出分支，是一个**只读操作**

`git checkout` 可以用于回滚错误的修改

**检出提交**

检出提交会使工作目录与这个提交完全匹配，可以用它来查看项目之前的状态，而不改变当前的状态。检出文件使你能够查看某个特定文件的旧版本，而工作目录中剩下的文件不变

`git checkout <commit>`

更新工作目录中的所有文件，使得和某个特定提交中的文件一致，`<commit>` 可以是提交的哈希串，也可以是 `HEAD / HEAD~1` 等，此时会处在分离 HEAD 的状态

比如我们执行了 `git checkout a1e8fb5` ，这将会使我们的工作目录与 `a1e8fb5` 提交所处的状态完全一样。我们可以查看文件，编译项目，运行测试，甚至编辑文件而不需要考虑是否会影响项目的当前状态，此时我们所做的一切**都不会**被保存到仓库中。为了继续开发，我们返回到当前状态：

`git checkout master` （假设当前分支是 `master` ）

注意 `git checkout HEAD` 是不能回到当前状态的，因为此时 `HEAD` 已经变成 `a1e8fb5` 了

如果我们回到前面的提交，想要做一些修改并保存时，可以用 `git stash` 或 `git checkout -b <branch> <commit-id>` 

**检出文件**

如果只对一个文件感兴趣，可以用 `git checkout <commit> <file>` 来获取它的一个旧版本

与检出提交不同，此时确实会影响到这个文件的当前状态，旧的文件版本会显示为“需要提交的更改”，允许你回滚到文件之前的版本。如果想要回到这个文件当前的版本，可以用 `git checkout HEAD <file>` （这里 `HEAD` 并没有产生变化）

**检出分支**

`git checkout <existing-branch>`

切换到另一个已有的分支，并更新工作目录的版本

`git checkout -b <new-branch>` 创建并查看 `<new-branch>`

`git checkout -b <new-branch> <existing-branch>` 和上一条相同，但将 `<existing-branch>` 作为新分支的基，而不是当前分支



## git revert

用来撤销一个已经提交的快照，需要注意的是，`git revert` 并不是从项目历史中移除这个提交，而是加上一个撤销了本次更改的新提交，从而避免丢失项目提交历史。

`git revert [--no-commit] <commit>`

`git revert <since>..<until>`

使用场景：比如我们发现某个 bug 是在某次提交中引入的，此时我们就可以撤销这次提交，而不需要手动去复原

```bash
git commit -m "Make some changes that will be undone"

# we find something buggy in the new code, and decide to revert it
git revert HEAD
```



## git reset ⭐️

`git reset` 相对 `git revert` 来说比较危险，因为这种撤销方式不会保留原来的状态，也即是不能 UNDO 的，是少数几个可能会造成工作丢失的命令之一

与 `git checkout` 一样，`git reset` 有多种用法。它可能被用来移除提交快照，撤销缓存区和工作目录的修改。然而，`git reset` 应该只被用于进行**本地修改**

`git reset <file>` 从缓存区移除特定文件，但不改变工作目录，只是取消这次文件修改的缓存

`git reset` 等同于 `git reset --mixed` ，重设缓存区，但不改变工作目录，相当于撤销最近的一次 `git add`

`git reset --hard` 重设缓存区，且改变工作目录，相当于我们最近的修改不想要了

`git reset <commit>` 将当前分支的末端移到 `commit` ，将缓存区重设到这个提交，但不改变工作目录，所有 `<commit>` 之后的更改会保留在工作目录中，但是是 unstaged 的状态

`git reset --hard <commit>` 将当前分支的末端移到 `<commit>` ，将缓存区和工作目录都重设到这个提交。它不仅清除了未提交的更改，同时还清除了 `<commit>` 之后的所有提交

`git reset --soft <commit>`  回到之前某次提交（取消前面的提交），但工作区和缓存区都不变，也就是所有 `git add` 的记录都还在



## git clean

将未追踪的文件从工作目录中移除，不可撤销

`git clean` 通常与 `git reset --hard` 一起使用，因为 reset 只影响被追踪的文件，所以需要 clean 来清理未追踪的部分，比如我们除了修改还新增了一些未 `git add` 的文件

`git clean -n` 告诉我们那些文件在命令执行后会被移除，而不是真的删除它

`git clean -f` 移除当前目录下未被跟踪的文件，其中 `-f` 是必需的，除非 `clean.requireForce` 被设置为 `false` ，且不会删除 `.gitignore` 中指定的未追踪文件

`git clean -f <path>`

`git clean -df` 移除未追踪的文件和目录

`git clean -xf` 移除未追踪的文件，以及 Git 一般忽略的文件



## git commit \-\-amend \[-m <message\>\]

将缓存的修改和之前的提交合并到一起，而不是提交一个全新的快照，（缓存区没有文件时）还可以用来简单地编辑上一次提交的信息而不改变快照

```bash
git add hello.py
git commit

git add main.py
git commit --amend --no-edit
```



## git rebase ⭐️

将分支移到一个新的基提交

从内容的角度来看，rebase 只不过是将分支从一个提交移到了另一个。但从内部机制来看，Git 是通过在选定的基上创建新提交来完成这件事的——它事实上重写了项目历史。理解这一点很重要，尽管分支看上去是一样的，但它包含了全新的提交

`git rebase <base>` base 可以是任何类型的提交引用（ID、分支名、标签或者 HEAD 及其相对引用）

主要目的是为了保持一个线性的项目历史，比如我们在 feature 分支工作时，master 分支合并了其他分支的一些进展（比如临时修复了一个 bug ）。此时我们要将 feature 分支整合进 master 分支，可以选择直接 merge 或先 rebase 后 merge 。前者会产生一个三路合并（3-way merge）和一个合并提交，而后者产生的是一个快速向前的合并以及完美的线性历史。rebase 相当于让我们的 feature 分支不在基于原来的 master 分支，而是修改后的 master 分支

举个 🌰

```bash
# begin a new branch
git checkout -b new-feature master
# modify and Create some files
git commit -a -m "Start developing a feature"
```

在 new-feature 分支开发了一半的时候，我们意识到项目中有一个安全漏洞：

```bash
# temporarily check out a new branch for fixing bug
git checkout -b hotfix master
# fix the bugs and commit
git commit -a -m "Fix security hole"
# return to master
git checkout master
git merge hotfix
git branch -d hotfix
```

将 hotfix 分支并回之后 master，我们有了一个分叉的项目历史。我们用 rebase 整合 feature 分支以获得线性的历史，而不是使用普通的 merge

```bash
git checkout new-feature
git rebase master

git checkout master
git merge new-feature
```

`git rebase -i`

开始交互式的 rebase，在过程中修改单个提交的机会，而不是盲目地将所有提交都移到新的基上，是粒度更小、更灵活的版本

下面是一个 🌰

```bash
# begin a new feature development
git checkout -b new-feature master
# modify some files and commit
git commit -a -m "Start developing a feature"
# more files
git commit -a -m "Fix something from the previous commit"

git checkout master
# modify some files and commit (not recommended)
git commit -a -m "Fix security hole"

git checkout new-feature
git rebase -i master
```

然后会打开一个编辑器，包含 new-feature 的两个提交，和一些提示

```
pick 32618c4 Start developing a feature
pick 62eed47 Fix something from the previous commit
```

我们可以更改每个提交前的 pick 命令来决定在 rebase 时提交移动的方式，在这个例子中我们只需要用 squash 命令把两个提交并在一起就可以了

```
pick 32618c4 Start developing a feature
squash 62eed47 Fix something from the previous commit
```

保存并关闭编辑器以开始 rebase，此时另一个编辑器会打开，询问你合并后的快照的提交信息。在定义了提交信息之后，rebase 就完成了。注意缩并的提交和原来的两个提交的 ID 都不一样，告诉我们这确实是个新的提交

```bash
git checkout master
git merge new-feature
```

最后我们还是跟之前一样 checkout 后 merge 就可以了



## git reflog

Git 用引用日志这种机制来记录分支顶端的更新，允许我们回到那些不被任何分支或标签引用的更改。在重写历史（比如用 rebase ）后，引用日志包含了分支旧状态的信息，有需要的话我们可以回到这个状态（此时 `git log` 已经看不到分支的旧状态了）

每次当前的 HEAD 更新时（如切换分支、拉取新更改、重写历史或只是添加新的提交），引用日志都会添加一个新条目

`git reflog --relative-date`

下面是一个 🌰

```
0a2e358 HEAD@{0}: reset: moving to HEAD~2
0254ea7 HEAD@{1}: checkout: moving from 2.2 to master
c10f740 HEAD@{2}: checkout: moving from master to 2.2
```

如果 `HEAD@{0}` 表示是事件是我们误操作的，那么我们可以通过 `git reset --hard 0254ea7` 回到前面那个提交

注意，引用日志提供的安全网只对提交到本地仓库的更改有效，而且**只有移动操作**会被记录

*reflog 的存在意味着我们不会真正丢失任何已经提交的修改或数据*



## git remote

允许我们创建、查看和删除和其它仓库之间的连接

`git remote [-v]` 列出我们与其他仓库之间的远程连接（同时显示每个连接的 URL）

`git remote add <name> <url>` 创建一个新的远程仓库链接，在添加之后，可以将 `<name>` 作为 `<url>` 便捷的别名在其他 Git 命令中使用

`git remote rm <name>` 

`git remote rename <old-name> <new-name>`

**origin** 当我们用 `git clone` 克隆仓库时，它自动创建了一个名为 origin 的远程连接，指向被克隆的仓库。这在开发者创建中央仓库的本地副本时非常有用，因为它提供了拉取上游更改和发布本地提交的快捷方式，这也是为什么大多数基于 Git 的项目将它们的中央仓库取名为 origin

Git 支持多种方式来引用一个远程仓库。其中两种最简单的方式便是 **HTTP** 和 **SSH** 协议。HTTP 是允许**匿名**、**只读**访问仓库的简易方式；如果希望对仓库进行读写，需要使用 SSH 协议

除了 origin 仓库以外，在多人协作的时候，我们通常会创建自己的远程仓库，比如 `git remote add hiki[https://dev.example.com/hiki.git](https://dev.example.com/hiki.git)` ，这样别人就可以访问到我们的远程仓库了



## git fetch

将提交从远程仓库导入到我们的本地仓库，注意拉取下来的提交存储为远程分支，如 `remotes/origin/master` ，而不是我们一直使用的本地分支，我们可以在整合进自己的项目副本之前查看更改

`git fetch <remote>` 拉取仓库中所有的分支，同时会从另一个仓库中下载所有需要的提交和文件

`git fetch <remote> <branch>` 只拉取指定的分支

在使用 `git fetch` 时，我们一般先拉取远程的分支到本地来，然后再通过 `git checkout` 和 `git log` 等命令去查看这些分支，如果接受远程分支包含的更改，我们在用 `git merge` 将它并入本地分支，而 `git pull` 是这两个过程的快捷方式

举个 🌰

```bash
git fetch origin
```

然后它会显示被下载下来的分支

```bash
a1e8fb5..45e66a4 master -> origin/master
a1e8fb5..9e8ab1c develop -> origin/develop
* [new branch] some-feature -> origin/some-feature
```

若想查看添加到上游 `master` 上的提交，我们可以运行 `git log` ，用 `origin/master` 过滤

```bash
git log --oneline master..origin/master
```

用下面这些命令接受更改并并入我们的本地 `master` 分支

```bash
git checkout master
git log origin/master
git merge origin/master
```

`origin/master` 和 `master` 分支现在指向了同一个提交，我们已经和上游的更新保持了同步。



## git pull

该命令将 `git fetch` 和 `git merge` 合二为一，即拉取当前分支对应的远程副本中的更改，并立即并入本地副本

`git pull --rebase <remote>` 使用 `git rebase` 合并远程分支和本地分支，而不是使用 `git merge`

`--rebase` 标记可以用来保证线性的项目历史，防止合并提交（merge commits）的产生。很多开发者倾向于使用 rebase 而不是 merge，因为「我想要把我的更改放在其他人完成的工作之后」

 事实上，使用 --rebase 的 pull 的工作流是如此普遍，以致于我们可以直接在配置项中设置它：

```bash
git config --global branch.autosetuprebase always # In git < 1.7.9
git config --global pull.rebase true              # In git >= 1.7.9
```

在运行这个命令之后，所有的 `git pull` 命令将使用 `git rebase` 而不是 `git merge`



## git push

将本地仓库中的提交转移到远程仓库中

`git push <remote> <branch>` 将指定的分支推送到 `<remote>` 上，包括所有需要的提交和提交对象。它会在目标仓库中创建一个本地分支。为了防止覆盖已有的提交，如果会导致目标仓库**非快速向前合并**时，Git 不允许 push 行为

`git push <remote> --force` 即使会导致非快速向前合并也强制推送，一般不能用 `--force` 

`git push <remote> --all` 将所有本地分支推送到指定的远程仓库

`git push <remote> --tags` 当推送一个分支或是使用 `--all` 选项时，标签不会被自动推送上去。`--tags` 将我们所有的本地标签推送到远程仓库中去

因为推送会弄乱远程分支结构，很重要的一点是，永远不要推送到其他开发者的仓库

下面的 🌰 描述了将本地提交推送到中央仓库的一些标准做法。首先，确保我们本地的 `master` 和中央仓库的副本是一致的，提前 fetch 中央仓库的副本并在上面 rebase。交互式 rebase 同样是共享之前清理提交的好机会。接下来，git push 命令将我们本地 master 分支上的所有提交发送给中央仓库

```bash
git checkout master
git fetch origin master
git rebase -i origin/master
# Squash commits, fix up commit messages etc.
git push origin master
```

因为我们已经确信本地的 master 分支是最新的，它应该导致快速向前的合并，`git push` 不应该抛出非快速向前之类的问题



## git branch

分支代表了一条独立的开发流水线，该命令允许我们创建、列出、重命名和删除分支，但不允许你切换分支或是将被 fork 的历史放回去，因此 `git branch` 和 `git checkout` 、`git merge` 这两个命令经常紧密结合在一起使用

`git branch` 列出仓库中的所有分支（包括本地分支和远程分支）

`git branch <branch>` 创建一个名为 `<branch>` 的分支。注意并不会自动切换到那个分支去，要实现这个功能可以用 `git checkout -b <branch>`

`git branch -d <branch>` 删除指定的分支，但 Git 会阻止删除包含未合并更改的分支

`git branch -D <branch>` 强制删除指定分支，即使包含未合并更改。当我们希望永远删除某条开发线的所有提交时可以用这个命令

`git branch -m <branch>` 将当前分支命名为 `<branch>`



## git merge

当当前分支顶端到目标分支路径是线性之时，我们可以采取**快速向前合并**，而当和目标分支之间的路径不是线性之时，Git 只能执行**三路合并**。如果我们不想进行快速向前合并，可以显式地执行 `git merge --no-ff <branch>` 

`git merge` 通常与 `git branch` 搭配使用，因为我们合并了一个新的 feature 之后，通常会删除它

![](http://ww2.sinaimg.cn/large/006tNc79ly1g5zmm245omj30y40k27al.jpg)



## git cherry-pick

“复制”一个提交节点并在当前分支做一次完全一样的新提交



## git hook

Git 钩子是仓库中特定事件发生时 Git 自动运行的普通脚本，存在于每个仓库的 `.git/hooks` 目录中，最常见的使用场景包括推行提交规范，根据仓库状态改变项目环境和接入**持续集成**工作流

在多人项目中维护钩子比较复杂，可以在 `.git` 目录外创建一个存放钩子的目录，然后用符号链接同步到 `.git/hooks` 中

所有带 `pre-` 的钩子允许我们修改即将发生的操作，而带 `post-` 的钩子只能用于通知

**本地钩子**

- pre-commit：可以用来检查即将被提交的代码快照，比如运行一些自动化测试
- prepare-commit-msg：可以用来方便地修改自动生成的 squash 或 merge 提交
- commit-msg：用户输入提交信息之后被调用，用来提醒开发者提交信息不符合团队的规范
- post-commit
- post-checkout
- pre-rebase

**服务端钩子**

- pre-receive：如果不喜欢提交信息的格式或提交的更改，可以用来拒绝这次提交
- update：在实际更新前被调用
- post-receive：在成功推送后被调用，适合用于发送邮件或**触发一个持续集成系统**

这些钩子都是对 `git push` 的不同阶段作出响应

服务端钩子的输出会传送到客户端的控制台中，所以给开发者发送信息是很容易的



## git rm

`git rm —cached <files>` 用于删除文件的缓存，比如有时候我们没有将 `.idea` 加入到 `.gitignore` 中，之后就需要先将 `.idea` 文件夹从缓存中去掉



## git tag

用于标识项目版本，比如我们要发布一个软件的 release 2.0 版本，可以用

```bash
git tag <tagname> [-a] # 如果我们需要对该标签进行描述，可以加 `-a`
git push origin --tags # 普通的 push 不会加入本地的 tags
```

我们也可以只 push 一个 tag

```bash
git push origin <tag>
```

在 github 上操作也可以



## git stash ⭐️

用来把我们当前的修改先藏起来，先接受别人的提交记录，再拿出来继续处理我们的修改

`git stash` 临时储存我们的修改

`git stash pop` 将存储起来的修改应用到工作目录中

`git stash list` 查看修改的储存历史

`git stash apply stash@{<num>}` 应用序号为 `<num>` 的修改



## Reference

[https://github.com/geeeeeeeeek/git-recipes](https://github.com/geeeeeeeeek/git-recipes)