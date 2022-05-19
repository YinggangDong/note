# Feign 1：基础信息

> `Feign` 远程调用，核心就是通过一系列的封装和处理，将以 JAVA 注解形式定义的远程调用 API 接口，最终转换成 `HTTP` 请求的形式，然后将响应结果解析成 JAVA Bean，放回给调用者的过程。

## 版本介绍

### Netflix [Feign](https://so.csdn.net/so/search?q=Feign&spm=1001.2101.3001.7020)还是 Open Feign？

首先需要明确：他俩是属于同一个东西，Feign属于Netflix开源的组件。针对于差异性，下面分这几个方面展开做出对比。

#### GAV坐标差异

```xml
<dependency>
    <groupId>com.netflix.feign</groupId>
    <artifactId>feign-core</artifactId>
</dependency>

<dependency>
    <groupId>io.github.openfeign</groupId>
    <artifactId>feign-core</artifactId>
</dependency>


```

#### 官网地址差异

- https://github.com/Netflix/feign

- https://github.com/OpenFeign/feign

不过现在访问 https://github.com/Netflix/feign 已经被重定向到了后者上。

#### 发版历史

- Netflix Feign：1.0.0 发布于 2013.6，于 2016.7 月发布其最后一个版本 8.18.0 

- Open
  Feign：首个版本便是 9.0.0版，于 2016.7 月发布，然后一直持续发布到现在（未停止）

从以上3个特点其实你可以很清楚的看到两者的区别和联系，简单的理解：Netflix Feign 仅仅只是改名成为了Open Feign而已，然后Open Feign项目在其基础上继续发展至今。

> 9.0 版本之前它叫 Netflix Feign，自 9.0 版本起它改名叫 Open Feign 了。

### 三、spring-cloud-starter-feign还是spring-cloud-starter-openfeign？

#### GAV坐标差异：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-feign</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>

```

#### 发版历史：

- `spring-cloud-starter-feign`：2015.3发布1.0.0版本，2019.5.23发布其最后一个版本1.4.7.RELEASE
  **值得注意的是，从1.4.0.RELEASE开始，它的1.4.x的发版轨迹完全同下的1.4.x的发版轨迹**

- `spring-cloud-starter-openfeign`：2017.11发布其首个版本，版本号为：1.4.0.RELEASE。现在仍持续更新中，当下最新版为2.2.1.RELEASE。**说明：`1.4.7.RELEASE` 是整个 `Spring Cloud1.x` 关于Feign方面的最终版本，2.x版本还在持续维护更新中**

注意：老的 spring-cloud-starter-feign 从 1.2.0.RELEASE 开始 已放弃 Netflix feign 而全面使用更新的Open Feign版本，而spring-cloud-starter-openfeign 更是和 Netflix Feign 已经没有关系了。

## 参考内容

1. [SpringBoot与SpringCloud版本对应关系](https://blog.csdn.net/majinggogogo/article/details/109129910)
2. [Spring Boot 与 Spring Cloud 详细映射关系](https://start.spring.io/actuator/info)