---
title: Product of Array Except Self
date: 2017-10-18 11:57:01
tags: Leetcode
---

### Problem

Given an array of n integers where n > 1, nums, return an array output such that output[i] is equal to the product of all the elements of nums except nums[i].

Solve it without division and in O(n).

For example, given [1,2,3,4], return [24,12,8,6].

Write a function to compute the next state (after one update) of the board given its current state.<!-- more -->

### Following up

Could you solve it with constant space complexity? (Note: The output array does not count as extra space for the purpose of space complexity analysis.)

---

### Thinking

这题主要是要求不使用除法，Time O(n)（必须）和 Space O(1) （建议），联想到之前求前缀和的题，这道题也可以用左右扫描的处理方式，核心思想是res[i] = mul(i-1) * mul(i+1)。

---

### Answer

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n = nums.length;
        int[] res = new int[n];
        // 保存前缀积（不包含本身）
        res[0] = 1;
        for (int i = 1; i < n; i++){
            res[i] = res[i-1]*nums[i-1];
        }
        // 从右到左扫描
        int right = 1;
        for (int j = n-2; j >= 0; j--){
            right *= nums[j+1];
            res[j] *= right;
        }
        return res;
    }
}
```