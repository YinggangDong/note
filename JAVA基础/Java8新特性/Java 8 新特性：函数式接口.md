# 函数式接口

[toc]



## 概念

只有一个抽象方法的是函数式接口。

函数式接口有时候被称为SAM类型，意思是单抽象方法(Single Abstract Method)。

一般来说，这个抽象方法指明了接口的目标用途。因此，函数式接口通常表示单个动作。

**eg：**标准接口Runnable是一个函数式接口，因为它只定义了一个方法run()；因此，run()定义了Runnable的动作。

注意点：

这里说的只有一个抽象方法是除object类的方法之外的。

因为接口默认继承java.lang.Object，所以如果接口显示声明覆盖了Object中方法，那么也不算抽象方法，因为每个类都继承了Object类，相当于每个类都继承有Object类方法的实现。例如比较器接口 Comparator ，该接口中有两个抽象方法，一个是 compare，一个是 equals，由于equals实际是显式覆盖了Object中的equals方法，所以在函数式接口定义中认为它是只有一个抽象方法。

## 注解@FunctionalInterface

1. FunctionalInterface 注解用来标识函数式接口

2. JDK8接口中的静态方法和默认方法，都不算是抽象方法。

3. 接口默认继承java.lang.Object，所以如果接口显示声明覆盖了Object中方法，那么也不算抽象方法。

4. 该注解不是必须的，如果一个接口符合"函数式接口"定义，那么加不加该注解都没有影响。加上该注解能够更好地让编译器进行检查。如果编写的不是函数式接口，但是加上了@FunctionInterface，那么编译器会报错。

## 实例

函数式接口：

```java
/**
 * MyFunctionalInterface 类是 函数式接口
 * <p>
 * 任何接口，如果只包含唯一一个抽象方法，就是一个函数式接口，例： Callable、Runnable、Comparator
 * <p>
 * FunctionalInterface 注解用来标识函数式接口
 * 1、该注解只能标记在"有且仅有一个抽象方法"的接口上。
 * 2、JDK8接口中的静态方法和默认方法，都不算是抽象方法。
 * 3、接口默认继承java.lang.Object，所以如果接口显示声明覆盖了Object中方法，那么也不算抽象方法。
 * 4、该注解不是必须的，如果一个接口符合"函数式接口"定义，那么加不加该注解都没有影响。加上该注解能够更好地让编译器进行检查。
 * 如果编写的不是函数式接口，但是加上了@FunctionInterface，那么编译器会报错。
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

    /**
     * equals 方法是 显式覆盖了Object的equals方法
     * Object的其他方法也可以显式覆盖,包括各种native方法
     *
     * @param obj 比较参数
     * @return 比较结果
     * @author dongyinggang
     * @date 2020/10/12 18:54
     */
    @Override
    boolean equals(Object obj);

}

```

函数式接口的实现及调用：

```java
/**
 * FunctionalInterfaceTest 类是 函数式接口测试类
 *
 * @author dongyinggang
 * @date 2020-10-12 19:58
 **/
public class FunctionalInterfaceTest {

    public static void main(String[] args) {

        //1.通过实现类实现函数式接口
        FunctionalInterfaceDemo interfaceImpl = new InterfaceImpl();
        interfaceImpl.abstractMethod();

        //2.匿名内部类实现函数式接口
        FunctionalInterfaceDemo demo = new FunctionalInterfaceDemo() {
            @Override
            public void abstractMethod() {
                System.out.println("通过内部类形式实现abstractMethod");
            }
        };
        demo.abstractMethod();

        //3.lambda实现函数式接口
        FunctionalInterfaceDemo lambda =
                ()-> System.out.println("lambda表达式实现abstractMethod");
        lambda.abstractMethod();

    }
}
```

## 内置函数式接口

### 核心内置函数接口

#### 1. Consumer接口-消费型接口

通常重写其accept(T)方法用于在forEach(Consumer<? super T> action)中进行对list中元素的操作。有参数，无返回值，只是对参数进行了一定的处理。

实例如下：

```java
/**
 * lambdaErgodic 方法是 lambda方式进行遍历
 *
 * @param list 要遍历的list对象
 * @author dongyinggang
 * @date 2020/9/9 10:59
 */
private static void lambdaErgodic(List<String> list){
    /*
     * 使用 lambda 表达式以及函数操作(functional operation),
     * foreach的参数是Consumer<? super T>
     * Consumer是JDK提供的一个函数式编程接口，其待实现方法是accept方法，
     * 除此之外还有一个default修饰的andThen方法（函数式接口只能有一个未实现方法）
     *
     * 下面的示例就是通过lambda表达式实现了accept方法
     */
    System.out.println("lambda表达式简写版：");
    list.forEach((s) -> System.out.print(s + "->"));
    System.out.println();

    //上下两者等价,下面实际是匿名内部类
    System.out.println("匿名内部类版：");
    list.forEach(new Consumer<String>() {
        @Override
        public void accept(String s) {
            System.out.print(s + "->");
        }
    });
    System.out.println();

    //在 Java 8 中使用双冒号操作符(double colon operator)
    System.out.println("lambda表达式+双冒号操作符版：");
    list.forEach(System.out::print);
    System.out.println();
}
```

#### 2. Supplier<T>：供给型接口（T get（））

只有返回值，没有入参。可以用来产生随机数等不需要输入的场景。

```java
/**
 * SupplierDemo 类是 内置函数式接口-Supplier<T>：供给型接口（T get（））
 *
 * @author dongyinggang
 * @date 2020-10-19 20:19
 **/
public class SupplierDemo {

    public static void main(String[] args) {
        SupplierDemo supplierDemo = new SupplierDemo();
        Random ran = new Random();
        List<Integer> list = supplierDemo.supplier(10, () -> ran.nextInt(10));

        for (Integer i : list) {
            System.out.println(i);
        }
    }

    /**
     * 随机产生sum个数量得集合
     * @param sum 集合内元素个数
     * @param sup Supplier接口
     * @return 随机产生的集合
     */
    private List<Integer> supplier(int sum, Supplier<Integer> sup){
        List<Integer> list = new ArrayList<>();
        for (int i = 0; i < sum; i++) {
            list.add(sup.get());
        }
        return list;
    }
}
```
#### 3. Function<T, R>：函数型接口（R apply（T t））

既有入参，又有出参，传入的入参经过处理后得到出参， 入参出参的类型可以有别,也可以一致。

示例如下：

```java
/**
 * FunctionDemo 类是 内置函数式接口-Function<T, R>：函数型接口（R apply（T t））
 * 既有入参，又有出参，传入的入参经过处理后得到出参
 * 入参出参的类型可以有别,也可以一致
 *
 * @author dongyinggang
 * @date 2020-10-19 20:30
 **/
public class FunctionDemo {

    private static final int SIX = 6;

    public static void main(String[] args) {
        FunctionDemo functionDemo = new FunctionDemo();
        //重写apply方法,获取工单后六位的编号
        Integer wrNum = functionDemo.function("FXGD20201019100001",
                (wrCode) -> Integer.valueOf(wrCode.substring(wrCode.length() - SIX))
        );
        System.out.println("当前工单编号" + wrNum);
    }

    /**
     * function 方法是 获取工单号的当前生成编号
     *
     * @param wrCode   工单号 “前缀+日期+6位编号”
     * @param function 待重写apply方法的Function接口
     * @return 6位编号的int值
     * @author dongyinggang
     * @date 2020/10/19 20:35
     */
    private Integer function(String wrCode, Function<String, Integer> function) {
        return function.apply(wrCode);
    }
```

#### 4. Predicate<T>：断言型接口（boolean test（T t））

输入一个参数,输出一个boolean类型的返回值判断是否满足要求。

示例如下：

```java
/**
 * PredicateDemo 类是 内置函数式接口-Predicate<T>：断言型接口（boolean test（T t））
 *  输入一个参数,输出一个boolean类型的返回值判断是否满足要求
 * @author dongyinggang
 * @date 2020-10-19 20:43
 **/
public class PredicateDemo {

    /**
     * 断言型接口：Predicate<T>
     */
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<>();
        list.add(102);
        list.add(172);
        list.add(13);
        list.add(82);
        list.add(109);
        //通过重写lambda重写test方法,过滤小于100的数
        List<Integer> newList = filterInt(list, x -> (x > 100));
        for (Integer integer : newList) {
            System.out.println(integer);
        }
    }

    /**
     * 过滤集合
     * @param list 要遍历的list
     * @param pre 待重写test方法的Predicate接口
     * @return 过滤后的集合
     */
    private static List<Integer> filterInt(List<Integer> list, Predicate<Integer> pre){
        List<Integer> newList = new ArrayList<>();
        for (Integer integer : list) {
            //如果满足重写之后的test方法,则将元素add到newList中
            if (pre.test(integer)){
                newList.add(integer);
            }
        }
        return newList;
    }
}
```

### 其他常见内置函数式接口

#### 1. Comparator接口-比较器借口

通常重写其 int compare(T o1, T o2) 方法用于 Arrays.sort(T[] a, Comparator<? super T> c) 中作为比较器进行排序。

```java
/**
 * staticMethod 方法是 通过双冒号 引用静态方法 ContainingClass::staticMethodName
 * <p>
 * 本例是引用Person类的 compareByAge 方法
 *
 * @author dongyinggang
 * @date 2020/10/10 9:43
 */
private static void staticMethod() {
    System.out.println("1.调用静态方法：");
    List<Person> roster = Person.createRoster();
    for (Person p : roster) {
        p.printPerson();
    }
    Person[] rosterAsArray = roster.toArray(new Person[roster.size()]);

    /**
     * 年龄比较器类
     *
     * 实现了函数式接口Comparator
     *
     * 注：Comparator接口 有两个抽象方法 compare 和 equals方法
     * 而它被称为函数式接口的原因是：
     *    如果接口声明了一个覆盖java.lang.Object的全局方法之一的抽象方法，
     * 那么它不会计入接口的抽象方法数量中，因为接口的任何实现都将具有java.lang.Object
     * 或其他地方的实现。
     */
    class PersonAgeComparator implements Comparator<Person> {
        @Override
        public int compare(Person a, Person b) {
            //这里如果 参数1 > 参数2 时返回正数,则为升序排列,否则为降序排列
            return a.getBirthday().compareTo(b.getBirthday());
        }
    }

    /**
     * 1.通过局部内部类作为sort方法的比较器实现类
     */
    Arrays.sort(rosterAsArray, new PersonAgeComparator());
    System.out.println("通过局部内部类的方式,排序完成：");
    for (Person person : rosterAsArray) {
        person.printPerson();
    }

    /**
     * 2.通过匿名内部类方式实现
     *
     * 将泛型指定为Person类，并重写compare方法
     * 参数类型变为Person是可行的，因为是Object的子类
     */
    Arrays.sort(rosterAsArray, new Comparator<Person>() {
        @Override
        public int compare(Person o1, Person o2) {
            return Person.compareByAge(o1, o2);
        }
    });

    /**
     * 3. 通过lambda表达式的方式作为Comparator的实现类，替代匿名内部类
     */
    Arrays.sort(rosterAsArray,
            (Person a, Person b) -> a.getBirthday().compareTo(b.getBirthday()));

    /**
     * 4.通过已存在的方法简化lambda表达式
     * 和3的区别只是变成调用已存在方法而非重写比较逻辑
     * 实际还是将通过lambda表达式替代了Comparator的匿名内部类的生成
     */
    Arrays.sort(rosterAsArray, (a, b) -> {
        return Person.compareByAge(a, b);
    });

    /**
     * 和上方等价，因为是一句话方法体，进行格式简化
     */
    Arrays.sort(rosterAsArray, (a, b) -> Person.compareByAge(a, b));


    /**
     * 4.调用已经存在的方法的最简形式
     *
     * 方法引用Person::compareByAge在语义上与lambda表达式相同(a, b) -> Person.compareByAge(a, b)。每个都有以下特征：
     *
     * - 它的形参列表是从复制Comparator<Person>.compare，这里是(Person, Person)。
     * - 它的主体调用该方法Person.compareByAge。
     */
    Arrays.sort(rosterAsArray, Person::compareByAge);
}
```

#### 2. Runnable接口

通常通过重写Runnable接口的run()方法进行线程功能的设置，然后通过new Thread(Runnable target)进行线程的创建。

```java
/**
 * LambdaRunnable 类是 lambda实现Runnable接口
 *
 * @author dongyinggang
 * @date 2020-09-05 10:14
 **/
public class LambdaRunnable {
    public static void main(String[] args) {

        //1.1使用匿名内部类
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("Hello Runnable");
            }
        }).start();

        //1.2使用lambda表达式
        new Thread(()-> System.out.println("Hello Lambda Runnable")).start();

        //2.1使用匿名内部类
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                System.out.println("Hello Runnable");
            }
        };

        //2.2使用lambda表达式
        Runnable runnable1 = ()-> System.out.println("Hello Lambda Runnable");

        new Thread(runnable).start();
        new Thread(runnable1).start();
    }
}
```



## 参考内容

- [1]  [JDK8新特性：函数式接口@FunctionalInterface的使用说明](https://blog.csdn.net/aitangyong/article/details/54137067)
- [2]  [函数式接口](https://www.jianshu.com/p/8005f32caf3d)
- [3]  [Lambda表达式和函数式接口](https://www.cnblogs.com/gclokok/p/10941002.html)
- [4]  [Java 8 新特性：Lambda 表达式](https://blog.csdn.net/sun_promise/article/details/51121205)
- [5]  [java8新特性——四大内置核心函数式接口](https://www.cnblogs.com/wuyx/p/9000312.html)