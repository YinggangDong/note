# Java 8 新特性(七)：日期时间API 

> Java 8之前，我们经常使用Date类和SimpleDateFormat类完成日期转化的相关操作。而在Java 8 中，Date类很大程度上可以说是被全面替代了，新引入的日期时间API以一种更稳定而清晰的姿态出现，改变了以前的混乱状态。

[toc]

## 背景

Java 8 之前，每当使用日期相关类型时，我们都是使用 Date 类型来做，但很多时候 Date类型的一些内容都不够直观。而且还有大量已经被废弃的方法等。因此在 Java 8 中，重写了日期相关的一系列API，具有更高的可读性和易用性。

## 实际应用 

### localDateTime 与 Date的相互转换

```java
		/**
     * convertLocalDateTime 方法是 Date转化为LocalDateTime
     *
     * @param date 入参是Date对象
     * @return LocalDateTime对象
     * @author dongyinggang
     * @date 2020/10/30 14:05
     */
    public static LocalDateTime date2LocalDateTime(Date date){
        //指定时区为当前系统时区
        ZoneId zoneId = ZoneId.systemDefault();
        //获取当前时区的LocalDateTime对象
        return LocalDateTime.ofInstant(date.toInstant(),zoneId);
    }

    /**
     * localDateTime2Date 方法是 LocalDateTime 转化为 Date
     *
     * @param localDateTime LocalDateTime对象
     * @return Date对象
     * @author dongyinggang
     * @date 2020/11/4 10:29
     */
    public static Date localDateTime2Date(LocalDateTime localDateTime){
        return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
    }
```



## 参考内容

- [1]  [Java 8中用java.time.LocalDate全面代替老旧的Date,Calendar类](https://blog.csdn.net/weixin_33897722/article/details/85075499)
- [2]  [Java 8 新特性：Java 类库的新特性之日期时间API (Date/Time API )](https://blog.csdn.net/sun_promise/article/details/51383618)

