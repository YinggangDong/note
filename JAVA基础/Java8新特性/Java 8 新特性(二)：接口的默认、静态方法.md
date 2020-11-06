# Java 8 新特性(二)：接口的默认、静态方法

> JAVA 8对接口进行了升级，原来的接口只能含有无方法体的方法定义，现在则引入了默认方法和静态方法的概念。

[toc]

## 概念

JAVA 8中引入的默认方法和静态方法是在接口中能够具有方法体的，分别被default和static关键字修饰的方法。

## 引入原因

### 默认方法

JAVA 8 中引入接口默认方法的主要场景如下：

​	以前创建了一个接口，并且已经被大量的类实现。

​	如果需要再扩充这个接口的功能加新的方法，就会导致所有已经实现的子类需要重写这个方法。

​	如果在接口中使用默认方法就不会有这个问题，原来的子类就不需要再重写这个方法了，只需要实际需要该接口的实现类进行重写。
所以从 JDK8 开始新加了接口默认方法，便于接口的扩展。

### 静态方法

接口的静态方法定义之后并不能够被其实现类发现，即不能通过实现类调用接口的静态方法，其调用只能通过**（接口名称.静态方法）**的形式调用，通过实现类或者实现类实例进行调用时都会提示“static method may be invoked on containing interface class only.”。

但接口中引入静态方法的实际用途不太明确，在网上找到一个样例，是讲在 JAVA 8 支持接口静态方法后，通过其来进行代码重构，提高代码内聚性的相关样例。

[代码进化史：Java8接口静态方法应用](https://my.oschina.net/geektao/blog/3156306)

## 方法定义规则

1．默认方法使用 default 关键字，一个接口中可以有多个默认方法。

2．接口中既可以定义抽象方法，又可以定义默认方法，默认方法不是抽象方法。

3．子类实现接口的时候，可以直接调用接口中的默认方法，即继承了接口中的默认方法。

4．接口中同时还可以定义静态方法，静态方法通过接口名调用。

## 方法调用

### 默认方法

实现类未重写默认方法时，调用时默认调用接口的默认方法，若实现类重写了默认方法，则调用实现类的重写方法。

基于 JAVA 类单继承，多实现的情况，可能会出现继承或实现的类和接口中有重名的默认方法的问题，主要有以下四种情形：

#### 1.一个类实现了一个接口的默认方法

接口MyInterface：

```java
package cn.dyg.lambda.defaultmethod;

/**
 * MyInterface 接口是 测试默认方法和静态方法的接口
 *
 * @author dongyinggang
 * @date 2020-10-10 16:52
 **/
public interface MyInterface {

    /**
     * 在interface里面的变量都是public static final 的
     *
     * 接口就是提供一种统一的协议, 而接口中的属性也属于协议中的成员。
     * 它们是公共的,静态的,最终的常量。相当于全局常量。
     *
     * 尽管不写public static final,也是默认常量
     */
    String INTERFACE_STATIC_VARIABLE = "静态变量";

    /**
     * defaultMethod 方法是 接口默认方法
     *
     * 接口的默认方法被引入的主要原因：
     *    以前创建了一个接口，并且已经被大量的类实现。
     *    如果需要再扩充这个接口的功能加新的方法，就会导致所有已经实现的子类需要重写这个方法。
     *    如果在接口中使用默认方法就不会有这个问题。
     *    所以从 JDK8 开始新加了接口默认方法，便于接口的扩展。
     *
     * @author dongyinggang
     * @date 2020/10/10 16:53
     */
    default void defaultMethod(){
        System.out.println("这是接口MyInterface的默认方法");
    }

    /**
     * defaultMethodWaitOverride 方法是 等待重写的接口默认方法
     *
     * @author dongyinggang
     * @date 2020/10/12 9:47
     */
    default void defaultMethodWaitOverride(){
        System.out.println("等待重写的默认方法");
    }

    /**
     * staticMethod 方法是 接口静态方法
     *
     * 在Java 8中，在接口中添加静态方法带来了一个限制 ：这些方法不能由实现它的类继承。
     * 这样做是有道理的，因为一个类可以实现多个接口。如果2个接口具有相同的静态方法，
     * 它们都将被继承，编译器就不知道要调用哪个接口。
     *
     * 参考：
     *  关于在java 8中，为什么不能调用当前类正在实现的接口的静态方法的解释
     *      https://blog.csdn.net/u012580143/article/details/81217732
     *
     * 疑问：
     *   引入的原因是什么？有什么源码级应用么？暂时个人理解是有部分方法实现可以通过static方法写在接口中，
     *   不需要必须写一个实现类来实现对应方法。提高代码的内聚性。
     *
     * 代码进化史：Java8接口静态方法应用
     *   https://my.oschina.net/geektao/blog/3156306
     *
     * @author dongyinggang
     * @date 2020/10/10 16:53
     */
    static void staticMethod(){
        System.out.println("这是接口的静态方法");
    }
    /**
     * ordinaryMethod 方法是 普通方法
     *
     * @author dongyinggang
     * @date 2020/10/10 16:54
     */
    void ordinaryMethod();
}

```

实现类DefaultMethodDemo：

```java
package cn.dyg.lambda.defaultmethod;

/**
 * DefaultMethodDemo 类是接口默认方法demo类
 *
 * 参考内容：
 * 1.Java8 在接口的变化：
 *      https://blog.csdn.net/axuanqq/article/details/82773631
 * 2.接口默认方法
 *      https://blog.csdn.net/h294590501/article/details/80303722
 * 3.JAVA8学习5-接口默认方法（default）
 *      https://blog.csdn.net/z_yemu/article/details/89312788?utm_medium=distribute.pc_relevant.none-task-blog-title-4&spm=1001.2101.3001.4242
 *
 * @author dongyinggang
 * @date 2020-10-10 16:58
 **/
public class DefaultMethodDemo implements MyInterface {


    public static void main(String[] args) {
        DefaultMethodDemo defaultMethodDemo = new DefaultMethodDemo();
        //1.接口的默认方法
        defaultMethodDemo.defaultMethod();
        //2.接口被重写的默认方法
        defaultMethodDemo.defaultMethodWaitOverride();
        //3.接口的静态方法,只能通过接口直接调用,实现类并不能重写该方法
        MyInterface.staticMethod();
        //4.实现类中有和接口静态方法重名的方法
        //  如果实例声明时使用了MyInterface就会报错,因为找不到唯一的方法,
        //  使用DefaultMethodDemo声明调用的实际是实现类自己的静态方法
        //  如果没有在当前实现类中定义staticMethod,就会提示
        //  "static method may be invoked on containing interface class only."
        //  因为实现类并不能够继承接口的静态方法
        defaultMethodDemo.staticMethod();
        //5.实现类重写的普通方法
        defaultMethodDemo.ordinaryMethod();

        //接口的全局变量
        System.out.println("通过接口访问" + MyInterface.INTERFACE_STATIC_VARIABLE);
        System.out.println("通过实现类访问" + DefaultMethodDemo.INTERFACE_STATIC_VARIABLE);
        //虽然标红,但实际是可以通过实现类的实例来访问接口的全局变量的,但不提倡这样写
        System.out.println("通过实现类实例访问" + defaultMethodDemo.INTERFACE_STATIC_VARIABLE);

    }

    /**
     * ordinaryMethod 方法是 普通方法
     *
     * @author dongyinggang
     * @date 2020/10/10 16:54
     */
    @Override
    public void ordinaryMethod() {
        System.out.println("DefaultMethodDemo类实现的ordinaryMethod");
    }

    /**
     * staticMethod 方法是 接口实现类尝试重写接口的static方法
     * <p>
     * 会发现并不能实现重写,加上 @Override 注解编译器会直接报错
     * "Method does not override method from its superclass"
     *
     * @author dongyinggang
     * @date 2020/10/12 9:08
     */
//    @Override
    public void staticMethod() {
        System.out.println("DefaultMethodDemo类尝试重写静态方法");
    }

    @Override
    public void defaultMethodWaitOverride() {
        System.out.println("DefaultMethodDemo类重写了默认方法");
    }
}
```

这个样例中，实现类 DefaultMethodDemo 没有实现接口 MyInterface 的默认方法 defaultMethod(),但实现了该接口的默认方法 defaultMethodWaitOverride(),在 main 方法中调用 defaultMethod 实际调用的是接口的默认方法，而调用 defaultMethodWaitOverride 则是调用了实现类重写的 defaultMethodWaitOverride() 方法。

#### 2.一个类实现两（多）个接口，且两（多）个接口有相同的默认方法

在已存在1中 MyInterface 接口的情况下，定义一个新的接口 MyInterface2 也有默认方法 defaultMethod() ，此时，实现类会被要求重写重名的默认方法。

接口：

```java
/**
 * MyInterface2 接口是 接口2
 *
 * @author dongyinggang
 * @date 2020-10-12 11:44
 **/
public interface MyInterface2 {

    /**
     * defaultMethod 方法是 和MyInterface默认方法重名的默认接口
     *
     * @author dongyinggang
     * @date 2020/10/12 11:44
     */
    default void defaultMethod(){
        System.out.println("这是接口MyInterface2的默认方法");
    }
}
```

实现类：

```java
/**
 * MultiImplDemo 类是 模拟实现多个接口，多个接口的默认方法重名的情况
 *
 * @author dongyinggang
 * @date 2020-10-12 11:45
 **/
public class MultiImplDemo implements MyInterface,MyInterface2 {

    public static void main(String[] args) {
        MyInterface myInterface = new MultiImplDemo();
        MyInterface2 myInterface2 = new MultiImplDemo();
        MultiImplDemo multiImplDemo = new MultiImplDemo();
        //以下三种调用都是调用了 MultiImplDemo 重写的 defaultMethod 方法
        myInterface.defaultMethod();
        myInterface2.defaultMethod();
        multiImplDemo.defaultMethod();
    }

    /**
     * defaultMethod 方法是 MultiImplDemo 重写的 defaultMethod 方法
     * 由于 MultiImplDemo 实现了两个接口 MyInterface、MyInterface2
     * 两个接口中有相同的默认方法 defaultMethod 此时如果不重写 defaultMethod 编译期会提示
     * "实现类 inherit unrelated defaults for 重名方法 两个接口"的错误
     * 要求实现类必须重写 defaultMethod 方法
     * @author dongyinggang
     * @date 2020/10/12 13:12
     */
    @Override
    public void defaultMethod() {
        System.out.println("MultiImplDemo重写了两个接口的都有的默认方法");
    }

    /**
     * ordinaryMethod 方法是 接口普通方法
     *
     * @author dongyinggang
     * @date 2020/10/12 13:04
     */
    @Override
    public void ordinaryMethod() {
        System.out.println("MultiImplDemo类重写MyInterface的普通方法");
    }
}
```

#### 3.一个类A实现一个接口C 同时继承接口C的实现类B

这种情况下，最多可能有这个默认方法的三种实现，最原始的是接口C 中的默认方法实现，第二个是实现类B中重写接口C 的默认方法，第三个是类A中的重写的默认方法。

这三个方法实现的优先级是：类A > 实现类B > 接口C 中的默认方法

值得一提的是，这种情况下，类A中不必须存在该默认方法的重写，接口C和实现类B中的默认方法并不冲突。

```java
/**
 * ExtendsAndImpl 类是 模拟既继承又实现接口且父类和接口中有重名的默认方法
 *
 * @author dongyinggang
 * @date 2020-10-12 13:22
 **/
public class ExtendsAndImpl extends DefaultMethodDemo implements MyInterface{

    public static void main(String[] args) {
        MyInterface myInterface = new ExtendsAndImpl();
        DefaultMethodDemo defaultMethodDemo = new ExtendsAndImpl();
        ExtendsAndImpl extendsAndImpl = new ExtendsAndImpl();
        //当 ExtendsAndImpl 未重写 defaultMethodWaitOverride 方法时,
        // 实际调用了 DefaultMethodDemo 重写的 defaultMethodWaitOverride方法
        //当 ExtendsAndImpl 重写 defaultMethodWaitOverride 方法时,
        // 实际调用了 ExtendsAndImpl 重写的 defaultMethodWaitOverride方法
        myInterface.defaultMethodWaitOverride();
        defaultMethodDemo.defaultMethodWaitOverride();
        extendsAndImpl.defaultMethodWaitOverride();

    }

    /**
     * defaultMethodWaitOverride 方法是 重写的 defaultMethodWaitOverride 方法
     * 实际完成了对 DefaultMethodDemo 类中方法的重写
     * 在本类中并不要求一定重写该方法，默认会调用 DefaultMethodDemo 的 defaultMethodWaitOverride 方法
     *
     * 在下面的ExtendsAndImpl2类中，因为 DefaultMethodDemo 未实现 MyInterface2
     * 所以会出现类似实现多个接口时的提示，要求必须重写默认方法
     *
     * @author dongyinggang
     * @date 2020/10/12 13:43
     */
    @Override
    public void defaultMethodWaitOverride(){
        System.out.println("ExtendsAndImpl重写了默认方法");
    }

}
```

#### 4.一个类A实现一个接口C 同时未继承接口C的实现类B

由于 DefaultMethodDemo 实现了 MyInterface 接口，因此继承了接口的默认方法 defaultMethod() , ExtendsAndImpl2 同时又实现了接口 MyInterface2，继承了其中的默认方法 defaultMethod()，因此使用ExtendsAndImpl2 类时会出现不能够找到唯一的 defaultMethod() 方法的问题，因此要求 ExtendsAndImpl2  类必须重写 defaultMethod() 方法。

```java
class ExtendsAndImpl2 extends DefaultMethodDemo implements MyInterface2{

    /**
     * defaultMethod 方法是 要求必须重写默认方法
     *
     * @author dongyinggang
     * @date 2020/10/12 14:02
     */
    @Override
    public void defaultMethod() {
        System.out.println("要求必须重写该默认方法");
    }
}
```

### 静态方法

接口的静态方法并不能够被其实现类继承，即对其实现类，接口的静态方法都是屏蔽、不可见的，因此只能通过**（接口.静态方法）**进行调用。

当实现类尝试重写时，会提示"Method does not override method from its superclass"，原因即实现类不可见该静态方法。

与此相比，在接口中声明的全局变量（实际是默认由public static final修饰的常量）是实现类可见的。

样例如下：

接口：

```java
package cn.dyg.lambda.defaultmethod;

/**
 * MyInterface 接口是 测试默认方法和静态方法的接口
 *
 * @author dongyinggang
 * @date 2020-10-10 16:52
 **/
public interface MyInterface {

    /**
     * 在interface里面的变量都是public static final 的
     *
     * 接口就是提供一种统一的协议, 而接口中的属性也属于协议中的成员。
     * 它们是公共的,静态的,最终的常量。相当于全局常量。
     *
     * 尽管不写public static final,也是默认常量
     */
    String INTERFACE_STATIC_VARIABLE = "静态变量";

    /**
     * defaultMethod 方法是 接口默认方法
     *
     * 接口的默认方法被引入的主要原因：
     *    以前创建了一个接口，并且已经被大量的类实现。
     *    如果需要再扩充这个接口的功能加新的方法，就会导致所有已经实现的子类需要重写这个方法。
     *    如果在接口中使用默认方法就不会有这个问题。
     *    所以从 JDK8 开始新加了接口默认方法，便于接口的扩展。
     *
     * @author dongyinggang
     * @date 2020/10/10 16:53
     */
    default void defaultMethod(){
        System.out.println("这是接口MyInterface的默认方法");
    }

    /**
     * defaultMethodWaitOverride 方法是 等待重写的接口默认方法
     *
     * @author dongyinggang
     * @date 2020/10/12 9:47
     */
    default void defaultMethodWaitOverride(){
        System.out.println("等待重写的默认方法");
    }

    /**
     * staticMethod 方法是 接口静态方法
     *
     * 在Java 8中，在接口中添加静态方法带来了一个限制 ：这些方法不能由实现它的类继承。
     * 这样做是有道理的，因为一个类可以实现多个接口。如果2个接口具有相同的静态方法，
     * 它们都将被继承，编译器就不知道要调用哪个接口。
     *
     * 参考：
     *  关于在java 8中，为什么不能调用当前类正在实现的接口的静态方法的解释
     *      https://blog.csdn.net/u012580143/article/details/81217732
     *
     * 疑问：
     *   引入的原因是什么？有什么源码级应用么？暂时个人理解是有部分方法实现可以通过static方法写在接口中，
     *   不需要必须写一个实现类来实现对应方法。提高代码的内聚性。
     *
     * 代码进化史：Java8接口静态方法应用
     *   https://my.oschina.net/geektao/blog/3156306
     *
     * @author dongyinggang
     * @date 2020/10/10 16:53
     */
    static void staticMethod(){
        System.out.println("这是接口的静态方法");
    }
    /**
     * ordinaryMethod 方法是 普通方法
     *
     * @author dongyinggang
     * @date 2020/10/10 16:54
     */
    void ordinaryMethod();
}

```

实现类：

```java
/**
 * DefaultMethodDemo 类是接口默认方法demo类
 *
 * 参考内容：
 * 1.Java8 在接口的变化：
 *      https://blog.csdn.net/axuanqq/article/details/82773631
 * 2.接口默认方法
 *      https://blog.csdn.net/h294590501/article/details/80303722
 * 3.JAVA8学习5-接口默认方法（default）
 *      https://blog.csdn.net/z_yemu/article/details/89312788?utm_medium=distribute.pc_relevant.none-task-blog-title-4&spm=1001.2101.3001.4242
 *
 * @author dongyinggang
 * @date 2020-10-10 16:58
 **/
public class DefaultMethodDemo implements MyInterface {


    public static void main(String[] args) {
        DefaultMethodDemo defaultMethodDemo = new DefaultMethodDemo();
        //1.接口的默认方法
        defaultMethodDemo.defaultMethod();
        //2.接口被重写的默认方法
        defaultMethodDemo.defaultMethodWaitOverride();
        //3.接口的静态方法,只能通过接口直接调用,实现类并不能重写该方法
        MyInterface.staticMethod();
        //4.实现类中有和接口静态方法重名的方法
        //  如果实例声明时使用了MyInterface就会报错,因为找不到唯一的方法,
        //  使用DefaultMethodDemo声明调用的实际是实现类自己的静态方法
        //  如果没有在当前实现类中定义staticMethod,就会提示
        //  "static method may be invoked on containing interface class only."
        //  因为实现类并不能够继承接口的静态方法
        defaultMethodDemo.staticMethod();
        //5.实现类重写的普通方法
        defaultMethodDemo.ordinaryMethod();

        //接口的全局变量
        System.out.println("通过接口访问" + MyInterface.INTERFACE_STATIC_VARIABLE);
        System.out.println("通过实现类访问" + DefaultMethodDemo.INTERFACE_STATIC_VARIABLE);
        //虽然标红,但实际是可以通过实现类的实例来访问接口的全局变量的,但不提倡这样写
        System.out.println("通过实现类实例访问" + defaultMethodDemo.INTERFACE_STATIC_VARIABLE);

    }

    /**
     * ordinaryMethod 方法是 普通方法
     *
     * @author dongyinggang
     * @date 2020/10/10 16:54
     */
    @Override
    public void ordinaryMethod() {
        System.out.println("DefaultMethodDemo类实现的ordinaryMethod");
    }

    /**
     * staticMethod 方法是 接口实现类尝试重写接口的static方法
     * <p>
     * 会发现并不能实现重写,加上 @Override 注解编译器会直接报错
     * "Method does not override method from its superclass"
     *
     * @author dongyinggang
     * @date 2020/10/12 9:08
     */
//    @Override
    public void staticMethod() {
        System.out.println("DefaultMethodDemo类尝试重写静态方法");
    }

    @Override
    public void defaultMethodWaitOverride() {
        System.out.println("DefaultMethodDemo类重写了默认方法");
    }
}

```

## 参考内容

- [1] [Java8 在接口的变化](https://blog.csdn.net/axuanqq/article/details/82773631)
- [2] [接口默认方法](https://blog.csdn.net/h294590501/article/details/80303722)
- [3] [JAVA8学习5-接口默认方法（default）](https://blog.csdn.net/z_yemu/article/details/89312788?utm_medium=distribute.pc_relevant.none-task-blog-title-4&spm=1001.2101.3001.4242)
- [4] [代码进化史：Java8接口静态方法应用](https://my.oschina.net/geektao/blog/3156306)
- [5] [关于在java 8中，为什么不能调用当前类正在实现的接口的静态方法的解释](https://blog.csdn.net/u012580143/article/details/81217732)
- [6]  [Java 8 新特性：接口的静态方法和默认方法](https://blog.csdn.net/sun_promise/article/details/51220518) ---详细