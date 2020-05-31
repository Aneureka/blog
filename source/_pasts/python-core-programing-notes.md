---
title: 《Python 核心编程》一点笔记
date: 2017-09-13 23:02:35
tags: 读书笔记
---

1. 缩进4个空格长度，避免使用制表符

2. python的赋值语句不会返回值，如y = (x = x+1)是错误的

3. 交换两个值：x, y = y, x

4. python不支持重载标识符<!-- more -->

5. _xxx：类中的私有变量/方法名
   \_\_xxx\_\_：系统定义的名字

6. obj.__doc__可以获得文档说明（obj可以是一个模块、类或函数名）

7. 在python3.x中，input实际上就是以前的raw_input，而原先的input没有了

8. if __name__ == '__main__': 的解释：
    所有的模块都有一个内置属性__name__，它的值取决于使用者如何应用这个模块：
    - 如果import一个模块，那么模块__name__的值通常为模块文件名（不带路径、拓展名）
    - 如果直接运行该模块，__name__将为缺省值'__main__'
      一个结论：if __name__ == '__main__': 比 直接main() 更好，尤其是多文件导入的时候

9. python的'None'类似与C的'NULL'，它的布尔值总为False

10. 复数表示方法：a + bj  
  常用：c.real    c.imag    c.conjugate()

11. xrange()是range()的兄弟版本，返回一个迭代器而不是一个列表，有利于节省内存，适用于超大数据集的情况

12. python可以执行多个比较操作，如 4<3<5!=2<7  =>  False

13. 比较两个对象：
    - a is b
    - id(a) == id(b)

14. int 和 string 是不可变对象，python会高效地缓存它们

15. 在python3.6中，cmp(a,b)  =>   (a>b) - (a<b)

16. /：真正的除法
    //：舍去小数部分

17. 位操作符：
    - ~num：按位取反
    - num1 << num2：左移
    - num1 ^ num2：异或

18. divmod()：返回一个包含商和余数的元组
    round()：四舍五入（返回浮点型）

19. 进制转换：
    - hex(255) = '0xff'
    - oct(255) = '0377'

20. ASCII转换：
    - ord('a') = 97
    - chr(97) = 'a'

21. 随机函数：
    - randint(a, b)
    - choice(list)
    - random()

22. seq1 + seq2 不如使用"".join(list)
    对列表来说，推荐用extend()而不是+

23. list()  str()  tuple() 等转换是将对象作为参数，并将其内容浅拷贝到新对象中

24. foo = "Hello"' world!' = “Hello” + ' world!'

25. 如果一个普通字符串与一个Unicode字符串连接，结果为Unicode字符串

26. 字符串格式化符号：
    - %u：转化成无符号十进制数
    - %e/%E：转化成科学计数法
    - %g/%G：%e和%f / %E和%F的简写
    - %%：输出%
      格式化操作符辅助指令：
    - -：用作左对齐
    - +：在正数前面显示加号
    - <sp>：在正数前面显示空格
    - 0：显示的数字前面填充0而不是空格，如'%2d' % 2   =>  02
    - (var)：映射变量（字典参数）
      'There is %(num)d %(lang)s Quotation Symbols' % {'lang':Python, 'num':3}

27. 原始操作符：r
    r'\n'  =>  '\\n'

28. dir() help()

29. type(('xyz'))  =>  <type 'str'>
    type(('xyz',))  =>  <type 'tuple'>

30. 浅拷贝：[:]  list()  copy.copy()
    深拷贝：copy.deepcopy()

31. python的字典是用可变的哈希表实现的

32. 字典比较算法（顺序）：1. 长度    2. 键    3. 值

33. 所有的不可变对象都是可哈希的，故可作为字典的值，且值相等的数字代表相同的键，如1和1.0

34. sorted()  zip() 返回一个序列
    reversed()  enumerate() 返回迭代器

35. 可以在while for循环中使用else语句，else子句只在循环后执行，break之后会跳过else块

36. 以'a'模式打开的文件是为追加数据准备的，所有写入的数据都将追加到文件结尾，即使seek()到其他地方

37. 处理特定异常：
    try: A
    except MyException( as e): B
    else: C
    finally: D

38. 触发异常：raise Exception(args)

39. 内嵌函数：函数体内再定义函数，只有当前函数能访问

40. 装饰器：

    @g

    @f

    def foo()     =\>     g(f(foo))

41. def func(\*tuple, \*\*dict)

42. lambda表达式：

    * 格式：lambda [arg1[, arg2, ..., argN]]: exp
    * lambda表达式返回可调用的函数对象
    * def true(): return True  \<==\>  lambda : True
    * def add(x, y): return x+y  \<==\>  lambda x,y : x+y
    * def add(x, y=2): return x+y  \<==\>  lambda x,y=2 : x+y

43. 生成器：yield   每一次返回一个结果，使用与需要迭代穿越一个巨大数据集时

44. \_\_init\_\_不适用于不可变对象，而\_\_new\_\_都可以

45. 通过实例属性来修改类属性是很危险的。

    * 对于可变类属性，类属性会被改变
    * 对于不可变类属性，实例属性的修改不对他造成影响，但会创建一个同名的实例属性覆盖掉类属性

46. self 类似与 java 的 this

47. 静态方法：@staticmethod   def foo():

    类方法：@classmethod   def foo(cls):

48. \_\_doc\_\_方法不会从基类继承，因为文档字符串对类、函数/方法，还有模块来说都是唯一的

49. 多重继承寻找关系：

    * 经典类：深度优先（先找父母，再找父母的同级）
    * 新式类：广度优先（先找完同级，再找父母）（采用广度优先的原因：菱形效应MRO问题）

50. eval(exp) 可对表达式求值，如eval('100+200')  =\>  300

51. thread模块：提供基本的线程和锁的支持（不建议使用）

    threading模块：提供更高级别，功能更强的线程管理的功能

52. 未完待续。