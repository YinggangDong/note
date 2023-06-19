# 常用注解(2)：@Transtional

7个传播特性 事务的传播特性有如下7个：



```java
public enum Propagation {
    REQUIRED(0),
    SUPPORTS(1),
    MANDATORY(2),
    REQUIRES_NEW(3),
    NOT_SUPPORTED(4),
    NEVER(5),
    NESTED(6);

    private final int value;

    private Propagation(int value) {
        this.value = value;
    }

    public int value() {
        return this.value;
    }
}
```

@Transactional注解默认使用事务传播特性是REQUIRED.



REQUIRED（必须的）(TransactionDefinition.PROPAGATION_REQUIRED) 使用当前的事务，如果当前没有事务，则自己新建一个事务，子方法是必须运行在一个事务中的，如果当前存在事务，则加入这个事务，成为一个整体。 例如：领导没有钱，但是我有钱，我就会自己买了吃（不存在事务）； 如果领导有钱，就会分一些给我（事务）；



SUPPORTS（支持）(TransactionDefinition.PROPAGATION_SUPPORTS) 如果当前有事务，则使用事务，如果没有，则不使用。 例如：领导没饭吃，我也没饭吃，领导有饭吃，我也有饭吃，也就是说如下面的代码，我在savechild（）方法上加了事务，但是在父级方法中没有加，则不会有事务，如果我在父级方法中也加了事务，才会实现事务。



MANDATORY（强制的）(TransactionDefinition.PROPAGATION_MANDATORY) 这个则会强制要求父级调用者添加事务，否则会报如下错误； 例如 ：领导必须管饭，不管饭我就不干了



REQUIRES_NEW（必须创建新的）(TransactionDefinition.PROPAGATION_REQUIRES_NEW) 如果当前有事务，则挂起该事务，并且创建一个新的事务给自己用。如果当前没有事务，则同REQUIRED。



NOT_SUPPORTED(TransactionDefinition.PROPAGATION_NOT_SUPPORTED) 如果当前有事务，则把该事务挂起，自己不执行。



NOT_SUPPORTED(TransactionDefinition.PROPAGATION_NOT_SUPPORTED) 调用方不允许有任何的事务。 NESTED(TransactionDefinition.PROPAGATION_NESTED) 调用方发生异常，子事务也会受影响回滚。子事务 发生异常，则也会回滚，但是，如果我们给被调用方加上trycatch的话，则就算被调用方发生了异常，也不会影响调用方的执行







类内调用的方案：

1. 转JDK代理：https://blog.csdn.net/try_learner/article/details/118418429k
2. [使用AopContxt.currentProxy()方法获取当前类的代理对象](https://blog.csdn.net/qq_16159433/article/details/120952972)
3. ​                              