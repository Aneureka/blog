---
title: Effective Java Notes
date: 2017-09-07 19:32:17
tags: 读书笔记
---

1. 用静态工厂方法代替构造器

    * 常用的方法名称：valueOf,	getInstance,	getType...
    * 优势
        * 有方法名称，增强可读性
        * 不必每次在调用的时候都常见一个新对象<!-- more -->

2. 在遇到多个构造器参数时考虑使用构建器（Builder：例如StringBuilder）

    * 重叠构造器会使代码可读性很差
    * 将Builder类作为当前类的内嵌静态类，必选参数组成Builder的构造器参数，可选参数组成添加元素的方法（如StringBuilder的append）

3. 在使用private的构造函数实现单例模式时，建议在构造器内部添加异常处理（使构造器在被要求创建第二个实例时抛出异常）。因为有特权的客户端可以借助AccessibleObject.serAccessible方法，通过反射机制调用私有的构造器，发动攻击。

4. 实现Singleton还有枚举的方法（最佳），如：

    ```java
    private Object Elvis {
        INSTANCE;
        public void leaveTheBuilding(){...}
    }
    ```

5. 覆盖equals时要覆盖hashCode

6. 始终覆盖toString方法

7. 考虑实现Comparable接口，对于逻辑上可以排序的类

8. 用private+get/set代替简单的public

9. 复合优先于继承！（继承破坏了封装性，使得子类要考虑父类的内部实现）

10. 接口在大多数场合要由于抽象类，但接口修改的代价较大

11. 在c/cpp使用的很好的函数参数，在java中可以用只含有一个（静态）函数的类代替，如Comparator

12. 在泛型使用的大多数场合，列表优于数组

    * 数组与泛型相比，有两个重要的不同点。

      首先，数组是协变的（如果Sub为Super的子类型，那么Sub[]为Super[]的子类型）

      泛型则是不可变的（对于任意两个不同的类型T1, T2，List<T1>跟List<T2>没有任何子父类型的关系）

        ```java
        // Fails at runtime
        Object[] objectArray = new Long[1];
        objectArray[0] = "I don't fit in"; // Throws ArrayStoreException
        
        // Won't Compile
        List<Object> ol = new ArrayList<Long>(); // Incompatible types
        o1.add("I don't fit in");
        ```

      利用数组，会在运行时发现错误；而利用列表，则是在编译时发现错误

    * 数组是具现化的（在运行时才知道并检查它们的元素类型约束），而泛型则是通过擦除（在编译时强化它们的类型信息，并在运行时丢弃类型信息，擦除使得泛型可以与没有使用泛型的代码随意进行互用）

    * 由于这些原因，创建泛型数组是非法的，如List<E>[], new List<String>[]等等，因为它不是类型安全的。如果它合法，编译器在其他正确的程序中发生的转换就会在运行时失败。

13. 利用有限制通配符提升API的灵活性（泛型）

    * 生产者使用<? extends T>，消费者使用<? super T>
    * PECS（producer-extends, consumer-super）

14. 可以将不同的行为与每个枚举常量关联起来

    ```java
    public enum Operation {
        PLUS { double apply(double x, doubel y){return x + y;} },
        MINUS { double apply(double x, doubel y){return x - y;} },
        TIMES { double apply(double x, doubel y){return x * y;} },
        DIVIDE { double apply(double x, doubel y){return x / y;} };
        
        abstract double apply(double x, double y);
    }
    ```

15. 要对构造器的每个可变参数进行保护性拷贝（不能直接用对象引用）

16. 可以使用辅助类（helper class）减少参数个数

17. 一般情况下，优先使用foreach而不是for

18. 如果需要精确计算结果，避免使用float和double，而是用BigDecimal/int/long

19. 为连接n个字符串而重复的使用"+"字符，需要n^2的时间

20. 并发相关的东西看不太懂= =，还是得先补补并发变成的知识呀...

21. 序列化（Serialization）：将对象编码成字节流；反序列化则是 相反的过程

22. 反序列化是一个隐藏的构造器；也使得类中私有的属性和方法暴露出来

23. 为了继承而设计的类，应该尽可能少的使用序列化，用户的接口也应该尽可能少的实现Serializable接口

24. 内部类不应该实现Serializable