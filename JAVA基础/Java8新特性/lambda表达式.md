# lambda表达式

[toc]

## 概念

在Java中，Lambda 表达式 (lambda expression)是一个匿名函数。

Lambda表达式基于数学中的λ演算得名，直接对应于其中的Lambda抽象(lambda abstraction)，是一个匿名函数，即没有函数名的函数。Lambda表达式可以表示闭包，但又不同于函数式语言的闭包。Lambda表达式让代码变得简洁并且允许你传递行为，在java8出现之前传递行为的方法只有通过匿名内部类。

Lambda表达式本质上就是一个匿名(即未命名的方法)。**但是这个方法是不能独立执行的（lambda表达式和函数式接口是严格绑定的）**，而是用于实现由函数式接口定义的一个方法（即：**使用 Lambda 表达式实例化函数式接口**）。因此，Lambda表达式会导致运行中产生一个匿名类。



## 演进过程

lambda表达式从根本上来说是用来简化代码的，简化的是函数式接口的实现形式。

以下面的代码为例，看一下JAVA在代码简化的过程中的产物。

主体过程如下：

1. 普通类
2. 静态内部类
3. 局部内部类
4. 匿名内部类
5. lambda简化的匿名内部类

代码如下：

1.函数式接口

```java
/**
 * MyFunctionalInterface 类是 函数式接口
 *
 * @author dongyinggang
 * @date 2020-10-12 18:15
 **/
@FunctionalInterface
public interface MyFunctionalInterface {
    /**
     * lambda 方法是 唯一接口
     *
     * @author dongyinggang
     * @date 2020/9/4 18:00
     */
    void lambda();

}

```

2.普通类

```java
/**
 * OrdinaryClass 类是 1.普通类，最原始的类表现
 *
 * @author dongyinggang
 * @date 2020/10/12 18:14
 */
public class OrdinaryClass implements MyFunctionalInterface {

    @Override
    public void lambda() {
        System.out.println("这是一个普通类");
    }
}
```

3.演进主体代码

```java
/**
 * LambdaEvolution 类是 lambda表达式演进过程类
 *
 * @author dongyinggang
 * @date 2020-09-04 11:30
 **/
public class LambdaEvolution {

    /**
     * 2.静态内部类
     * 在主类内部定义的静态类
     */
    static class StaticInnerClass implements MyFunctionalInterface {

        @Override
        public void lambda() {
            System.out.println("这是一个静态内部类");
        }
    }

    public static void main(String[] args) {

        //1.普通类
        MyFunctionalInterface ordinaryClass = new OrdinaryClass();
        ordinaryClass.lambda();

        //2.静态内部类
        MyFunctionalInterface staticInnerClass = new StaticInnerClass();
        staticInnerClass.lambda();

        /**
         * 3.局部内部类
         * 在类的方法中定义的内部类，是没有static修饰的非静态类
         */
        class LocalInnerClass implements MyFunctionalInterface {

            @Override
            public void lambda() {
                System.out.println("这是一个局部内部类");
            }
        }

        MyFunctionalInterface localInnerClass = new LocalInnerClass();
        localInnerClass.lambda();

        /**
         * 4.匿名内部类 AnonymousInnerClass
         * 没有通过class关键字进行类的声明，直接通过重写FunctionalInterface接口的
         * lambda方法的方式创建了一个实现该接口的匿名类
         */
        MyFunctionalInterface anonymousInnerClass = new MyFunctionalInterface() {

            @Override
            public void lambda() {
                System.out.println("这是一个匿名内部类");
            }
        };
        anonymousInnerClass.lambda();

        /**
         * 5.lambda简化的匿名内部类
         * 通过lambda表达式简化了匿名内部类的创建方式
         */
        MyFunctionalInterface lambdaClass =
                () -> System.out.println("这是一个lambda简化的匿名内部类");
        lambdaClass.lambda();

    }
}
```

## 基本语法

lambda有三部分构成：

第一部分 为一个括号内用逗号分隔的**形式参数**，参数是函数式接口里面方法的参数；

第二部分 为一个箭头符号：**->**；

第三部分 为方法体，可以是表达式和代码块。

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

根据以上基本语法，衍生以下实例代码：

1.数字操作函数式接口

```java
/**
 * MathOperation 类是 数字操作函数式接口
 *
 * @author dongyinggang
 * @date 2020/10/12 15:27
 */
@FunctionalInterface
interface MathOperation {
    /**
     * operation 方法是 数字计算方法
     *
     * @param a 数字a
     * @param b 数字b
     * @return 计算结果值
     * @author dongyinggang
     * @date 2020/9/4 13:19
     */
    int operation(int a, int b);
}
```

2.lambda基础使用demo

```java
/**
 * LambdaDemo 类是 lambda基础使用
 *
 * @author dongyinggang
 * @date 2020-09-04 13:15
 **/
public class LambdaDemo {

    public static void main(String[] args) {

        int c = 5;
        //带参数类型声明的lambda表达式
        MathOperation add = (a, b) -> a + b;

        //不带参数类型声明的lambda表达式
        MathOperation sub = (a, b) -> a - b;

        //带大括号和return的lambda表达式
        MathOperation mul = (a, b) -> {
            int d = a * b;
            return d * c;
        };

        //没有大括号及返回语句
        MathOperation div = (a, b) -> a / b;

        System.out.println(add.operation(1, 2));
        System.out.println(sub.operation(2, 1));
        System.out.println(mul.operation(3, 2));
        System.out.println(div.operation(4, 2));
    }
}
```

## 与匿名类的区别

在我看来，lambda表达式可以理解为对只有一个函数的匿名内部类的再次简化，代码简化如下:

```java
/**
 * 4.匿名内部类 AnonymousInnerClass
 * 没有通过class关键字进行类的声明，直接通过重写FunctionalInterface接口的
 * lambda方法的方式创建了一个实现该接口的匿名类
 */
MyFunctionalInterface anonymousInnerClass = new MyFunctionalInterface() {

    @Override
    public void lambda() {
        System.out.println("这是一个匿名内部类");
    }
};
anonymousInnerClass.lambda();
/**
 * 5.lambda简化的匿名内部类
 * 通过lambda表达式简化了匿名内部类的创建方式
 */
MyFunctionalInterface lambdaClass =
  () -> System.out.println("这是一个lambda简化的匿名内部类");
lambdaClass.lambda();
```

但实际在运行过程中可以发现，它的实质还是一个被简化的匿名内部类，尽管写作格式被简化，但实际运行中与匿名内部类无异。![image-20201012203525545](lambda表达式.assets/image-20201012203525545.png)

其中四个实例对象都是通过lambda表达式实现函数式接口 MathOperation 的 operation(int a, int b) 方法的方式来进行声明的，从红框中可以看出，这里其实是生成了四个匿名类。冒号后面实际就是内部类的地址。

但是我们是否可以有这样的表述“lambda表达式是否只是一个匿名内部类的语法？”，答案是No，原因有两种：

 **性能影响**: 假如lambda表达式是采用匿名内部类实现的，那么每一个lambda表达式都会在磁盘上生成一个class文件。当JVM启动时，这些class文件会被加载进来，因为所有的class文件都需要在启动时加载并且在使用前确认，从而会导致JVM的启动变慢。（以LambdaRunnable和LambdaDemo为例）

**向后的扩展性:** 如果Java8的设计者从一开始就采用匿名内部类的方式，那么这将限制lambda表达式未来的发展范围。

另外的区别还有：

1. 在匿名类中，this 指代的是匿名类本身；而在lambda表达式中，this指代的是lambda表达式所在的这个类。

2. lambda表达式的类型是由上下文决定的，而匿名类中必须在创建实例的时候明确指定。

3. Lambda 表达式的编译方法是：Java 编译器编译 Lambda 表达式并将他们转化为类里面的私有函数，它使用 invokedynamic 指令（ Java 7 ，即动态启用）动态绑定该方法。

Lambda表达式是采用动态启用（Java7）来延迟在运行时的加载策略。当javac编译代码时，它会捕获代码中的Lambda表达式并且生成一个动态启用的调用地址(称为Lambda工厂）。当动态启用被调用时，就会向Lambda表达式发生转换的地方返回一个函数式接口的实例。然后将Lambda表达式的内容转换到一个将会通过动态启用来调用的方法中。在这一步骤中，JVM实现者有自由选择策略的权利。



## lambda作用域

在[Lambda表达式](http://blog.csdn.net/sun_promise/article/details/51121205)中访问外层作用域和旧版本的匿名对象中的方式类似。你可以直接访问标记了final的外层局部变量，或者实例的字段以及静态变量。

[Lambda表达式](http://blog.csdn.net/sun_promise/article/details/51121205)不会从超类（supertype）中继承任何变量名，也不会引入一个新的作用域。Lambda表达式基于词法作用域，也就是说lambda表达式函数体里面的变量和它外部环境的变量具有相同的语义（也包括lambda表达式的形式参数）。此外，this关键字及其引用，在Lambda表达式内部和外部也拥有相同的语义。

4、方法和构造函数引用

5、Lamda 表达式作用域

6、内置函数式接口

7、Optionals

## 参考内容

- [1]  [Lambda表达式和函数式接口](https://www.cnblogs.com/gclokok/p/10941002.html)
- [2]  [lambda表达式的变量作用域](https://blog.csdn.net/weixin_38091140/article/details/84793802)
- [3]  [Java 8 新特性：Lambda 表达式](https://blog.csdn.net/sun_promise/article/details/51121205) ---非常详细的lambda详解
- [4]  []()