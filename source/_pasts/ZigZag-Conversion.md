---
title: ZigZag Conversion
date: 2017-08-04 15:59:09
tags: Leetcode
---

### Problem

The string `"PAYPALISHIRING"` is written in a zigzag pattern on a given number of rows like this: (you may want to display this pattern in a fixed font for better legibility)

```
P   A   H   N
A P L S I I G
Y   I   R

```

And then read line by line: 

```
"PAHNAPLSIIGYIR"
```

<!-- more -->Write the code that will take a string and make this conversion given a number of rows:

```
string convert(string text, int nRows);
```

```
convert("PAYPALISHIRING", 3)
```

 should return 

```
"PAHNAPLSIIGYIR"
```
---
<!-- more -->
### Thinking

分成两部分格式化输出= =，这道题有点那啥。

---

### Answer

```java

class Solution {

    public String convert(String s, int numRows) {

        if (numRows == 1)
            return s;

        // 计算周期
        int n = s.length();
        int t1 = numRows;
        int t2 = numRows - 2;
        int k = n / (t1 + t2) + 1;

        // 初始化
        char[][] c1 = new char[k][t1];
        char[][] c2 = new char[k][t2];
        for (int i = 0; i < k; i++){
            for (int j = 0; j < t1; j++)
                c1[i][j] = '_';
            for (int j = 0; j < t2; j++)
                c2[i][j] = '_';
        }

        // 分为两个部分
        for (int i = 0; i < k; i++) {
            int index = i * (t1 + t2);
            for (int j = 0; j < t1+t2; j++){
                if (index + j < n){
                    if (j < t1) c1[i][j] = s.charAt(index+j);
                    else c2[i][t2-1-(j-t1)] = s.charAt(index+j);
                }
            }
        }

        // 格式输出
        String result = "";
        for (int i = 0; i < numRows; i++){
            for (int j = 0; j < k; j++){
                if (c1[j][i] != '_')
                    result += c1[j][i];
                if (i > 0 && i < numRows-1 && c2[j][i-1] != '_')
                    result += c2[j][i-1];
            }
        }

        return result;
    }

}
```