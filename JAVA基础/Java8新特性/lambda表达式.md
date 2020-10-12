# lambda表达式

[toc]

## 概念

lambda表达式是JAVA8的新特性之一，也称为闭包。

在我看来，lambda表达式可以理解为对只有一个函数的匿名内部类的再次简化，不需要再





### 定义

## 演进过程

lambda表达式从根本上来说是用来简化代码的，尤其针对的是

## 基本语法

基本语法:

**(parameters) -> expression**

或

**(parameters) ->{ statements; }**

```java
// 1. 不需要参数,返回值为 5
() -> 5
 
// 2. 接收一个参数(数字类型),返回其2倍的值
x -> 2 * x
 
// 3. 接受2个参数(数字),并返回他们的差值
(x, y) -> x – y
 
// 4. 接收2个int型整数,返回他们的和
(int x, int y) -> x + y
 
// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)
(String s) -> System.out.print(s)
```



2、Lambda表达式

3、函数式接口

4、方法和构造函数引用

5、Lamda 表达式作用域

6、内置函数式接口

7、Optionals