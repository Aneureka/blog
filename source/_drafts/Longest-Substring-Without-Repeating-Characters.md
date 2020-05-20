---
title: Longest Substring Without Repeating Characters
date: 2017-08-04 16:00:32
tags: Leetcode
---

### Problem

Given a string, find the length of the **longest substring** without repeating characters.<!-- more -->

### Example

Given "abcabcbb", the answer is "abc", which the length is 3.

Given "bbbbb", the answer is "b", with the length of 1.

Given "pwwkew", the answer is "wke", with the length of 3. Note that the answer must be a **substring**, "pwke" is a *subsequence* and not a substring.

---

### Thinking

Two pointers处理，O(N)。

---

### Answer

```java
class Solution {

    public int lengthOfLongestSubstring(String s) {

        if (s.length() == 0) return 0;

        int maxLen = 1;
        int n = s.length();
        int ptr1 = 0, ptr2 = 1;

        while (ptr2 < n){
            int len = ptr2 - ptr1 + 1;
            int index = s.substring(ptr1, ptr2).indexOf(s.charAt(ptr2));

            if (index >= 0){
                ptr1 += (index+1);
            }
            else{
                if (len > maxLen)
                    maxLen = len;
            }

            ptr2++;
        }

        return maxLen;

    }

}
```