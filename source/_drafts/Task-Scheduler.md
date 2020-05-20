---
title: Task Scheduler
date: 2017-10-10 17:58:49
tags: Leetcode
---

### Problem

Given a char array representing tasks CPU need to do. It contains capital letters A to Z where different letters represent different tasks.Tasks could be done without original order. Each task could be done in one interval. For each interval, CPU could finish one task or just be idle.

However, there is a non-negative cooling interval n that means between two same tasks, there must be at least n intervals that CPU are doing different tasks or just be idle.

You need to return the least number of intervals the CPU will take to finish all the given tasks.<!-- more -->

### Example

Input: tasks = ['A','A','A','B','B','B'], n = 2

Output: 8

Explanation: A -> B -> idle -> A -> B -> idle -> A -> B.

---

### Thinking

这道题原先看的时候没啥思路，然后自己试了几个例子之后，觉得或许可以模拟这个“选择最佳任务”的过程，每次选择的时候都遵循这个原则：如果能找到不在idle期间的task，则选择剩余数量最多的；如果找不到，则选择idle期最短的。有点贪心的意思，结果写了70行代码，以为应该肯定是TLE，没想到AC了。看了discussion，发现别人是用数学的思想，7行代码，复杂度On，还是得学习一个...

---

### Answer

```java
class Solution {
    public int leastInterval(char[] tasks, int n) {

        int all = tasks.length;
        if (n == 0) return all;

        // 保存各个任务（字母）剩余个数并初始化
        int[] counts = new int[26];
        int[] durations = new int[26];
        for (char task : tasks)
            counts[task-'A']++;

        // 每个周期找出最合适的task，并计算idle或count
        int time = 0;
        for (int i = 0; i < all; i++){
            int bestTask = findCurrentBestTask(counts, durations);
            // 如果找出的当前的task需要等待
            if (durations[bestTask] != 0){
                int d = durations[bestTask];
                reduceTime(durations, d);
                time += d;
            }
            reduceTime(durations, 1);
            time += 1;
            counts[bestTask]--;
            durations[bestTask] = n;
        }

        return time;

    }

    private int findCurrentBestTask(int[] counts, int[] durations){
        int res = 0, max = 0, min = 101;

        for (int i = 0; i < counts.length; i++){
            if (counts[i] > max && durations[i] == 0){
                max = counts[i];
                res = i;
            }
        }
        if (max != 0) return res;

        for (int i = 0; i < durations.length; i++){
            if (durations[i] < min && counts[i] > 0){
                min = durations[i];
                res = i;
            }
        }
        return res;
    }

    private void reduceTime(int[] durations, int d){
        for (int i = 0; i < durations.length; i++)
            durations[i] = Math.max(0, durations[i]-d);
    }
}
```