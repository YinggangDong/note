# Springboot配置（一）：配置文件读取

> 在做项目的过程中，有些参数可能会变动，如果写死在代码中，则每次都需要重新部署项目才能完成其变更，因此会将这些参数写到配置文件或数据库中，常见的有，项目的数据库连接信息，日志级别，系统邮件发送功能中使用的邮箱等。本文就讨论一下Springboot对配置文件的读取。

看一下配置文件的内容：



## 1.@Value注解进行单配置注入

@Value 是比较常见的配置文件加载注解，给类变量通过@Value注解指定配置文件属性，就可以将属性值赋给目标字段。

示例如下：



## 2.@ConfigurationProperties注解进行批量注入



## 参考内容

【1】[springboot中使用@Value读取配置文件](https://www.cnblogs.com/duanxz/p/4520627.html)

【2】[SpringBoot配置文件详解](https://www.cnblogs.com/charleswone/p/11437661.html)

【3】[@ConfigurationProperties 注解使用姿势，这一篇就够了](https://blog.csdn.net/yusimiao/article/details/97622666)