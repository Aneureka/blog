---
title: Longest Palindromic Substring
date: 2017-08-04 16:01:55
tags: Leetcode
---

### Problem

Given a string **s**, find the longest palindromic substring in **s**. You may assume that the maximum length of **s** is 1000.<!-- more -->

### Example

Input: "babad"

Output: "bab"

Note: "aba" is also a valid answer.

Input: "cbbd"

Output: "bb"

---

### Thinking

最大回文字串的长度满足单调性+范围，故二分答案，但同时要注意二分的时候分奇偶情况处理

---

### Answer

```java
public class Solution {

    public String longestPalindrome(String s) {

        if (s.equals("")) return "";

        // 分为奇数情况和偶数情况，找出最大长度
        int n = s.length();
        int n0 = n / 2;
        int n1 = n - n0;
        int maxLen = Math.max(getMaxLen(s, 1, n0, 0),
                getMaxLen(s, 1, n1, 1));

        // 找出最大长度对应的子字符串
        for (int i = 0; i <= n-maxLen; i++){
            String subs = s.substring(i, i+maxLen);
            if (isPalindrome(subs))
                return subs;
        }

        return "";
    }


    private int getMaxLen(String s, int low, int high, int flag){

        int maxLen = 0;

        // 二分答案
        while (low <= high) {
            int mid = (low + high) / 2;
            int len = 2 * mid - flag;
            if (hasPalindrome(s, len)) {
                low = mid+1;
                if (len >= maxLen)
                    maxLen = len;
            }
            else {
                high = mid-1;
            }
        }
        return maxLen;

    }


    private boolean hasPalindrome(String s, int len){
        int n = s.length();
        if (len > n) return false;
        for (int i = 0; i <= n-len; i++)
            if (isPalindrome(s.substring(i, i+len)))
                return true;
        return false;
    }


    private boolean isPalindrome(String s) {
        int n = s.length();
        for (int i = 0; i < n/2; i++)
            if (s.charAt(i) != s.charAt(n-1-i))
                return false;
        return true;
    }

}

```