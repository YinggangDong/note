响应式编程

dubbo -》基于netty

线程模型

单reactor单线程

单reactor多线程：reactor-》 -》worker

主从reactor多线程。



自定义报文协议

1. 有分隔符 0x04 data 0x04

2. TLV tag length value

报文头 

长度 int 4 报文头内容

|      | 报文头        | 报文体   |
| ---- | ------------- | -------- |
|      | 长度          | 长度     |
|      | 序号          | 登陆内容 |
|      | 版本号        |          |
|      | type 100 登录 |          |

报文





|            |          |                       |
| ---------- | -------- | --------------------- |
| 分隔符     | 0x04     | 表示我们的报文        |
| 总报文长度 | int 4    | 总保温长度，不包含4位 |
| type       | 报文类型 | 比如 100 登录         |
| datalength |          |                       |
| data       | String   | 报文体                |



client-》handle -》encoder-》——decode-》handle-》server



netty的容量、读写指针的形式来做写和读。

容量可以进行扩展。

可读字节数：写的减掉读的。