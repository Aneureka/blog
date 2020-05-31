---
title: Shortest Unsorted Continuous Subarray
date: 2017-10-11 17:03:07
tags: Leetcode
---

### Problem

Given an integer array, you need to find one continuous subarray that if you only sort this subarray in ascending order, then the whole array will be sorted in ascending order, too.

You need to find the shortest such subarray and output its length.<!-- more -->

### Example

Input: [2, 6, 4, 8, 10, 9, 15]

Output: 5

Explanation: You need to sort [6, 4, 8, 10, 9] in ascending order to make the whole array sorted in ascending order.

---

### Thinking

这道题想贴一下discuss中的做法，自己的确实太笨了，这道题主要的思路是能够找出这么两个数A，B，使得A大于后边的数的最小值，B小于前边的数的最大值。但自己在扫描的时候思路太死，每次都求最小值，其实知道这个会造成很多多余的操作，也就是On跟On2的差距了。其实首尾两个方向扫一遍就行啦！这个end=-2的初始化有点trick，很聪明。

---

### Answer

```java
class Solution {
    public int findUnsortedSubarray(int[] A) {
        int n = A.length, beg = -1, end = -2, min = A[n-1], max = A[0];
        for (int i=1;i<n;i++) {
            max = Math.max(max, A[i]);
            min = Math.min(min, A[n-1-i]);
            if (A[i] < max) end = i;
            if (A[n-1-i] > min) beg = n-1-i;
        }
        return end - beg + 1;
    }
}
```