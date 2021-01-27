# Springboot 整合 Mybatis 框架

## 依赖

通过idea进行Springboot项目创建的时候，可以选择SQL中的mybatis，初始化项目时会自动引入相关依赖。

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.1.3</version>
</dependency>
```

## 配置文件

```yml
# 数据库连接
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/test?allowMultiQueries=true&serverTimezone=UTC
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password:

mybatis:
  mapper-locations: classpath:mapping/*Mapper.xml
  type-aliases-package: com.example.demo.dao

logging:
  level:
    com:
      example:
        demo:
          mapper: debug
```





## idea连接数据库-驱动下载地址修改

下载驱动时默认地址是 https://repo1.maven.org/maven2/  开头的，而非maven文件里面设置的阿里云地址。

经过查询资料，发现这是idea的一个名叫 jdbc-drivers.xml 的文件进行设置的。在windows下通常是C:\Users\10338\\.IntelliJIdea2019.1\config\jdbc-drivers 类似这样的c盘的 idea的配置文件中进行的配置，进入这里，将所有的 https://repo1.maven.org/maven2/  替换为 https://maven.aliyun.com/repository/public/ 就可以通过阿里云的maven仓库进行下载了。

记得重启idea才会生效。



## 参考内容

【1】[SpringBoot整合Mybatis完整详细版](https://blog.csdn.net/iku5200/article/details/82856621)