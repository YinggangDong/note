# Java 8  新特性：Stream类

[TOC]

## 概念

Stream的官方描述：

一个序列的元素支持顺序和并行聚合操作。



## 简述Stream



## Stream的创建



有状态，无状态的区分依据是是否依赖其他元素。

### Stream的应用

#### list转map

常用形式，将对象的某个属性作为key值，将对象作为value，获取到一个map。

```java
Map<Long, User> maps = userList.stream().collect(Collectors.toMap(User::getId,Function.identity()));
```

看来还是使用JDK 1.8方便一些。另外，转换成`map`的时候，可能出现`key`一样的情况，如果不指定一个覆盖规则，上面的代码是会报错的。转成`map`的时候，最好使用下面的方式：

```java
Map<Long, User> maps = userList.stream().collect(Collectors.toMap(User::getId, Function.identity(), (key1, key2) -> key2));
```

有时候，希望得到的`map`的值不是对象，而是对象的某个属性，那么可以用下面的方式：

```java
Map<Long, String> maps = userList.stream().collect(Collectors.toMap(User::getId, User::getAge, (key1, key2) -> key2));
```



## 参考内容

- [1]  [Java 8 新特性：Java 类库的新特性之 Stream类](https://blog.csdn.net/sun_promise/article/details/51480257)
- [2]  [jdk1.8 java.util.stream.Stream类 详解](https://www.cnblogs.com/kaisadadi/p/9099485.html)