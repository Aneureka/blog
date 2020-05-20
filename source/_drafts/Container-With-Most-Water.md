---
title: Container With Most Water
date: 2017-08-24 11:23:58
tags: Leetcode
---

### Problem

Given *n* non-negative integers *a1*, *a2*, ..., *an*, where each represents a point at coordinate (*i*, *ai*). *n* vertical lines are drawn such that the two endpoints of line *i* is at (*i*, *ai*) and (*i*, 0). Find two lines, which together with x-axis forms a container, such that the container contains the most water.

Note: You may not slant the container and *n* is at least 2.<!-- more -->

### Thinking

自己思考的是用优化后的暴力解法，其中一个用例用了2ms，TLE了，可能时间限制比较严格。然后去Discuss大神区看了标准的解法，用的是双指针（哎，其实原先自己也有想到双指针，但差距就在于我不知道怎么设定双指针的移动条件，从而遍历出所有取得MaxArea的情况）。

大概思路：建立双支针，比较两指针所在的高度，移动高度较小位置的指针（如果移动高度较大位置的指针，由于指针向中间移动，所以下一个Area必定小于当前Area）

---

### Answer

```java
public class ContainerWithMostWater {

    // 正解，双指针，关键在于如何遍历maxArea的情况
    public int maxArea(int[] height) {
        int left = 0, right = height.length - 1;
        int maxArea = 0;

        while (left < right) {
            maxArea = Math.max(maxArea, Math.min(height[left], height[right]) * (right - left));
            if (height[left] < height[right])
                left++;
            else
                right--;
        }

        return maxArea;
    }


//	优化的暴力解法，TLE
//	public int maxArea(int[] height) {
//
//		int res = 0;
//		int ix = 0;
//		for (int i = 0; i < height.length-1; i++){
//			if (height[i] < height[ix]) continue;
//			for (int j = i+1; j < height.length; j++){
//				int area = (j-i) * Math.min(height[i], height[j]);
//				if (area >= res){
//					res = area;
//					ix = i;
//				}
//			}
//		}
//
//		return res;
//	}
}
```