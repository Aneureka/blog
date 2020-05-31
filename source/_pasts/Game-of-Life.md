---
title: Game of Life
date: 2017-10-12 21:07:22
tags: Leetcode
---

### Problem

According to the Wikipedia's article: "The Game of Life, also known simply as Life, is a cellular automaton devised by the British mathematician John Horton Conway in 1970."

Given a board with m by n cells, each cell has an initial state live (1) or dead (0). Each cell interacts with its eight neighbors (horizontal, vertical, diagonal) using the following four rules (taken from the above Wikipedia article):

1. Any live cell with fewer than two live neighbors dies, as if caused by under-population.
2. Any live cell with two or three live neighbors lives on to the next generation.
3. Any live cell with more than three live neighbors dies, as if by over-population..
4. Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.

Write a function to compute the next state (after one update) of the board given its current state.<!-- more -->

### Following up

1. Could you solve it in-place? Remember that the board needs to be updated at the same time: You cannot update some cells first and then use their updated values to update other cells.

2. In this question, we represent the board using a 2D array. In principle, the board is infinite, which would cause problems when the active area encroaches the border of the array. How would you address these problems?

---

### Thinking

这道题如果不要求（其实也只是建议）in-place的话就没有挑战性了，加入in-place的话，首先有两个想法，第一个是能不能找到一种顺序，使得后边的替换不会收到前边替换的结果的影响，这道题的话应该是不行的（emmmm...应该很多题都不行），然后另一个想法是看能不能找到一个滑动窗口或临时储值器之类的东西，保存当前运算完的结果，然后等到后边的用完前边的值之后再做更新，嗯，是可以的。然后就要考虑怎样使得这个储值器尽可能小，思考了一下，用一个一维数组就可以啦。

---

### Answer

```java
class Solution {
    public void gameOfLife(int[][] board) {
        int m = board.length;
        int n = board[0].length;

        // 用一个数组做临时储值器，不管更新储值器，则可以实现in-place的替换
        int[] window = new int[n];
        for (int i = 0; i < m; i++){
            int[] tmp = Arrays.copyOf(window, n);
            for (int j = 0; j < n; j++){
                // 计算出周围数字的和
                int total = 0;
                for (int di = i-1; di <= i+1; di++)
                    for (int dj = j-1; dj <= j+1; dj++)
                        if (di >= 0 && di < m && dj >= 0 && dj < n)
                            total += board[di][dj];
                total -= board[i][j];
                // 判断
                if (board[i][j] == 0 && total == 3 || board[i][j] == 1 && (total < 2 || total > 3))
                    window[j] = 1-board[i][j];
                else
                    window[j] = board[i][j];
            }
            // 将上一个覆盖
            if (i > 0)
                board[i-1] = tmp;
            // 如果到达末尾，则末尾用window代替
            if (i == m-1)
                board[i] = window;
        }

    }
}
```