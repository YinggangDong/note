# Java 8 新特性：Optional

> Java 8 之前，面对可能为空的各类对象，我们往往需要一个类似 obj！=null 的判断来进行Java 8 引入了一个新的 Optional 类，用来进行对象是否为 null 的判断。

[TOC]

## 概述

Optional 的完整路径是 java.util.Optional，使用它是为了避免代码中的 if (obj != null) { } 这样范式的代码，可以采用链式编程的风格。而且通过 Optional 中提供的 filter 方法可以判断对象是否符合条件，在符合条件的情况下才会返回，map 方法可以在返回对象前修改对象中的属性。

## Optional源码

### 1 Optional 的属性

```java
/**
 * 一个公共空Optional实例
 */
private static final Optional<?> EMPTY = new Optional<>();

/**
 * 如果非空，则value值存在，否则value值为null
 */
private final T value;
```

### 2 构造函数

Optional有两个构造函数，一个无参构造，一个有参构造。两者都是私有方法，因此，在代码中，不能够通过调用构造方法进行Optional对象的创建。

其中，无参构造只在 EMPTY 被赋值时使用，被用来创建了一个value为null的Optional对象。有参构造仅被of()直接调用。

```java
    /**
     * 无参构造方法，构造一个value为空的Optional对象，是一个私有构造方法
     */
    private Optional() {
        this.value = null;
    }

		/**
     * 有参构造方法
     * 如果value为null,则抛出空指针异常,否则将值赋给Optional对象的value属性
     * 也是一个私有构造函数
     */
    private Optional(T value) {
        this.value = Objects.requireNonNull(value);
    }
```

### 3 常用方法

```java
/**
 * 返回一个空的Optional对象
 */
public static<T> Optional<T> empty() {
    @SuppressWarnings("unchecked")
    Optional<T> t = (Optional<T>) EMPTY;
    return t;
}

/**
 * 有参构造方法
 * 如果value为null,则抛出空指针异常,否则将值赋给Optional对象的value属性
 * 也是一个私有构造函数
 */
private Optional(T value) {
    this.value = Objects.requireNonNull(value);
}

/**
 * 调用有参构造方法，返回一个value为入参的Optional对象
 * 若入参为null,会抛出空指针异常
 */
public static <T> Optional<T> of(T value) {
    return new Optional<>(value);
}

/**
 * 返回一个Optional对象，value值为入参
 * 允许value值为null,若为null则调用empty()进行返回
 */
public static <T> Optional<T> ofNullable(T value) {
    return value == null ? empty() : of(value);
}

/**
 * 获取Optional对象的value值
 * 若为空，则抛异常NoSuchElementException
 */
public T get() {
    if (value == null) {
        throw new NoSuchElementException("No value present");
    }
    return value;
}

/**
 * 判断value值是否为null
 * 为null,则返回false,否则返回true
 */
public boolean isPresent() {
    return value != null;
}

/**
 * 如果value不为null,执行consumer的accept方法进行相应逻辑
 * 否则,不做任何操作
 */
public void ifPresent(Consumer<? super T> consumer) {
    if (value != null)
        consumer.accept(value);
}

/**
 * filter方法的参数是内置函数式接口-断言接口Predicate的实现类
 * 首先判断实现类是否为空,若空则抛异常
 * 然后判断value是否为null,为null时直接返回空的Optional
 * 不为null是判断是否满足要求predicate的test条件，满足则返回其本身,否则返回空的Optional
 */
public Optional<T> filter(Predicate<? super T> predicate) {
    Objects.requireNonNull(predicate);
    if (!isPresent())
        return this;
    else
        return predicate.test(value) ? this : empty();
}

/**
 * map方法
 * map的参数是Function接口的实现类
 * 当value为null时,返回空的Optional
 * 不为null时,调用参数的apply方法并返回ofNullable(结果)的Optional对象
 */
public<U> Optional<U> map(Function<? super T, ? extends U> mapper) {
    Objects.requireNonNull(mapper);
    if (!isPresent())
        return empty();
    else {
        return Optional.ofNullable(mapper.apply(value));
    }
}

/**
 *
 */
public<U> Optional<U> flatMap(Function<? super T, Optional<U>> mapper) {
    Objects.requireNonNull(mapper);
    if (!isPresent())
        return empty();
    else {
        return Objects.requireNonNull(mapper.apply(value));
    }
}

/**
 * 如果optional对象保存的值不是null，则返回原来的值，否则返回value
 */
public T orElse(T other) {
    return value != null ? value : other;
}

/**
 * 功能与orElse一样，只不过orElseGet参数是一个Supplier的实现类
 */
public T orElseGet(Supplier<? extends T> other) {
    return value != null ? value : other.get();
}

/**
 * 值不存在则抛出异常，存在则什么不做
 */
public <X extends Throwable> T orElseThrow(Supplier<? extends X> exceptionSupplier) throws X {
    if (value != null) {
        return value;
    } else {
        throw exceptionSupplier.get();
    }
}
```

## 示例代码

通过实例看Optional的各方法的实际作用，相关代码如下：

```java
/**
 * OptionalDemo 类是 Optional的样例类
 *
 * @author dongyinggang
 * @date 2020-10-21 15:58
 **/
public class OptionalDemo {
    public static void main(String[] args) {

//        ofTest();

//        ofNullableTest();

//        filterTest();
//        mapTest();
//        flatMapTest();
//        orElseTest();
//        orElseGetTest();
        orElseThrowTest();
    }

    /**
     * empty()方法测试
     * 返回一个value为null的Optional对象
     * 由于value为null,本方法输出null
     */
    private static void emptyTest(){
        Optional empty = Optional.empty();
        System.out.println(empty);
    }

    /**
     * of()方法测试
     * 输出optional对象的value值-name
     */
    private static void ofTest(){
        System.out.println("of()方法测试");
        //1.of方法为非null的值创建一个Optional。
        Optional optional = Optional.of("name");
        System.out.println(optional.get());

        Optional<List> optionalList = Optional.of(new ArrayList<>());
        System.out.println(optionalList.get());
    }

    /**
     * ofNullable()方法测试
     * ofNullable方法为指定的值创建一个Optional，如果指定的值为null，则返回一个空的Optional。
     * 返回的Optional对象调用orElse方法,
     * 若Optional的value为空则将其赋值为orElse方法的参数,通常用来给null赋默认值
     */
    private static void ofNullableTest(){
        System.out.println("ofNullable()方法测试:");
        Optional<String> empty = Optional.ofNullable(null);
        try {
            //抛出异常,NoSuchElementException
            System.out.println(empty.get());
        }catch (NoSuchElementException e){
            System.out.println("value为空,没有输出");
        }
        Optional<String> value = Optional.ofNullable("value");
        System.out.println(value.get());

    }

    /**
     * isPresent方法测试
     * 同时进行ifPresent方法的测试
     */
    private static void isPresentTest(){
        //3.通过Optional的方法进行strings的非null值输出
        String[] strings = new String[]{"1",null,"3","4",null};
        for (String string : strings) {
            Optional<String> strOptional = Optional.ofNullable(string);
            //isPresent,若value值存在,返回true,否则返回false
            if(strOptional.isPresent()){
                System.out.println(strOptional.get());
            }
            //与上方等价,若value值存在,执行lambda表达式重写的Consumer的accept方法
            strOptional.ifPresent(System.out::println);
        }
    }

    /**
     * filter方法测试
     * 将String数组中长度大于1的元素取出来放到新的List中去
     */
    private static void filterTest(){
        System.out.println("filter方法测试：");
        String[] strings = new String[]{"1",null,"31","41",null};
        List<String> newString = new ArrayList<>();
        for (String string : strings) {
            //将strings中长度大于1的字符串筛选出来
            Optional<String> strOptional =
                    Optional.ofNullable(string).filter((s)->s.length()>1);
            strOptional.ifPresent(newString::add);
        }
        System.out.println(newString.toString());
    }

    /**
     * map方法测试
     * 将员工list中的名称写成一个新的list
     */
    private static void mapTest(){
        System.out.println("map方法测试");
        Employee employee = new Employee("张三");
        Employee employee1 = new Employee("李四");
        Employee employee2 = new Employee(null);
        List<Employee> employeeList = new ArrayList<>();
        employeeList.add(employee);
        employeeList.add(employee1);
        employeeList.add(employee2);
        List<String> nameList = new ArrayList<>();

        for (Employee item : employeeList) {
            //这里的getName是实例方法,入参是item,是调用对象,因此是引用特定类型的实例方法
            Optional<String> optional = Optional.ofNullable(item).map(Employee::getName);
            optional.ifPresent(nameList::add);
        }
        System.out.println(nameList.toString());
        //List通过stream进行
        List<String> nameStreamList =
                employeeList.stream().map(Employee::getName).collect(Collectors.toList());
        System.out.println(nameStreamList.toString());
    }

    /**
     * flatMap方法测试
     * 调用changeName方法修改employee的name并输出
     * 和map的主要区别是flatMap要求返回值必须为Optional对象,而map可以为任意对象
     */
    private static void flatMapTest() {
        System.out.println("flatMap测试");
        Employee employee = new Employee("王五");
        Optional<Employee> optional = Optional.of(employee);
        optional.flatMap((value)->Optional.ofNullable(employee.changeName(value)))
                .ifPresent(System.out::println);

    }

    /**
     * orElse方法测试
     * 当optional的value为null时，返回orElse的入参值
     * 否则返回value值
     */
    private static void orElseTest(){
        System.out.println("orElseTest测试");
        Optional<String> optional = Optional.ofNullable(null);
        String defaultValue = optional.orElse("default");
        System.out.println(defaultValue);

        Optional<String> optional1 = Optional.ofNullable("原值");
        String defaultValue1 = optional1.orElse("default");
        System.out.println(defaultValue1);
    }

    /**
     * orElseGet方法测试
     * 和orElse的区别是orElse指定了对象，orElseGet的参数是指定了一个 Supplier 接口的实现类
     * 当optional的value为null时，返回orElseGet的参数的返回值
     * 否则返回value值
     */
    private static void orElseGetTest(){
        System.out.println("orElseGet测试");
        Optional<String> optional = Optional.ofNullable(null);
        String defaultValue = optional.orElseGet(()->"默认值");
        System.out.println(defaultValue);

        Optional<String> optional1 = Optional.ofNullable("原值");
        String defaultValue1 = optional1.orElseGet(()->"默认值");
        System.out.println(defaultValue1);
    }

    /**
     * orElseThrow方法测试
     * 和orElse的区别是orElse指定了对象，orElseThrow的参数是指定了一个 Supplier 接口的实现类
     * 并且该实现类的返回值被限定为 Throwable 的子类
     * 当optional的value为null时，抛出orElseThrow的参数的get方法返回的异常
     * 否则返回value值
     */
    private static void orElseThrowTest(){
        System.out.println("orElseThrow测试");

        Optional<String> optional1 = Optional.ofNullable("原值");
        String defaultValue1 = optional1.orElseThrow(NoSuchElementException::new);
        System.out.println(defaultValue1);

        Optional<String> optional = Optional.ofNullable(null);
        String defaultValue = optional.orElseThrow(NoSuchElementException::new);
        System.out.println(defaultValue);

    }

}
```

过程中有用到Employee类，代码如下：

```java
/**
 * Employee 类是 员工类
 *
 * @author dongyinggang
 * @date 2020-10-21 20:36
 **/
@AllArgsConstructor
@Data
public class Employee {

    /**
     * 姓名
     */
    private String name;

    public Employee changeName(Employee employee){
        employee.setName("修改后的姓名");
        return employee;
    }
}
```

实际应用过程中，鉴于 Optional 优秀的判空能力，有实例如下，其中通过 Optional 进行了外部服务的调用结果的处理，然后根据调用结果通过 Stream 的 Java 8 特性进行了 list2map 的转换，获取到以对象的不同属性为 key 和 value 的 map 对象：

```java
/**
 * getRuleMap 方法是 查询维修中心时效规则Map
 *
 * @return 时效规则Map
 * @author dongyinggang
 * @date 2020/11/4 9:13
 */
private Map<String, String> getRuleMap() {
    try {
        //调用BBPF的字典项,获取维修中心时效规则
        log.info("调用字典接口查询维修中心时效规则--开始--->");
        long start = System.currentTimeMillis();
        CallResponse<List<DictValue>> callResponse = dictValueService.getDictValueListByDictTypeCode(McTimeRuleConstant.MC_TIME_RULE);
        log.info("调用字典接口查询维修中心时效规则--结束--->,耗时{}ms,结果{}", System.currentTimeMillis() - start, callResponse);
        //判断返回值是否为空,然后比较返回值code是否为"00",BBPF返回的正确返回值为"00"
        List<DictValue> ruleList = Optional.ofNullable(callResponse)
                .filter((s) -> "00".equals(s.getCode()))
                .map(CallResponse::getResult).orElseGet(ArrayList::new);
        //ruleList转为Map
        return ruleList.stream().collect(Collectors.toMap(DictValue::getValueName, DictValue::getValueCode, (key1, key2) -> key2));
    } catch (Exception e) {
        throw new BusinessRuntimeException(McErrorCodeEnum.DICT_EXCEPTION.getCode(), McErrorCodeEnum.DICT_EXCEPTION.getMessage());
    }
}
```

## 参考内容

- [1]  [Java8学习笔记（六）--Optional](https://www.cnblogs.com/yw0219/p/7354938.html)

- [2]  [Optional是个好东西，你会用么？（全面深度解析）](https://blog.csdn.net/DBC_121/article/details/104984093)