# lambda表达式

[toc]

## 概念

lambda表达式是JAVA8的新特性之一，也称为闭包。

Java SE 8添加了2个对集合数据进行批量操作的包: java.util.function 包以及 java.util.stream 包。 流(stream)就如同迭代器(iterator),但附加了许多额外的功能。 总的来说,lambda表达式和 stream 是自Java语言添加泛型(Generics)和注解(annotation)以来最大的变化。

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