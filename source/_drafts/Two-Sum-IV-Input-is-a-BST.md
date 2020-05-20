---
title: Two Sum IV - Input is a BST
date: 2017-08-22 00:33:01
tags: Leetcode
---

### Problem

Given a Binary Search Tree and a target number, return true if there exist two elements in the BST such that their sum is equal to the given target.<!-- more -->

### Example

```
Input: 
    5
   / \
  3   6
 / \   \
2   4   7

Target = 9

Output: True
---------------------
Input: 
    5
   / \
  3   6
 / \   \
2   4   7

Target = 28

Output: False
```

---

### Thinking

先将BST中的value存放到list中，再用双指针

---

### Answer

```java
public class Solution {

    public boolean findTarget(TreeNode root, int k) {
        List<Integer> collector = new ArrayList<>();
        save(collector, root);
        return isTwoSum(collector, k);
    }

    // 将BST的值存到List中
    public void save(List<Integer> collector, TreeNode x){
        if (x == null)
            return;
        save(collector, x.left);
        collector.add(x.val);
        save(collector, x.right);
    }

    public boolean isTwoSum(List<Integer> collector, int k){
        int low = 0, high = collector.size()-1;
        while (low < high){
            int t = collector.get(low) + (int)collector.get(high);
            if (t < k) low++;
            else if (t > k) high--;
            else return true;
        }
        return false;
    }

}
```