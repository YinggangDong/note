# HttpClient学习

> HttpClient是客户端的http通信实现库，这个类库的作用是接收和发送http报文，使用这个类库，它相比传统的 HttpURLConnection，增加了易用性和灵活性，我们对于http的操作会变得简单一些；

## 一、HttpClient基础之HTTP

### 1.1 HTTP协议

> HTTP协议（Hyper Text Transfer Protocol，超文本传输协议）是TCP/IP协议的一个应用层协议，用于定义WEB浏览器和WEB服务器之间交换数据的过程以及数据本身的格式。**HTTP协议的特点：无状态。**

### 1.2 HTTP协议到底约束了什么

- 约束了浏览器以何种格式向服务端发送数据

- 约束了服务器应该以何种格式来接受客户端发送的数据

- 约束了服务器应该一何种格式来反馈数据给浏览器

- 约束了浏览器以何种格式来接收服务器反馈的数据

- 浏览器给服务器发送数据：一次请求

- 服务器给浏览器反馈数据：一次响应

### 1.3 HTTP协议版本

HTTP协议版本包括：HTTP/1.0和HTTP/1.1以及HTTP-NG

### 1.4 HTTP请求消息和响应消息的结构

- HTTP请求消息包括：一个请求行，若干请求头，以及实体内容，其中一些请求头和实体内容是可选的。
- HTTP响应消息包括：一个状态行，若干响应头，以及实体内容，其中一些消息头和实体内容是可选的。

**常见的响应状态码有**：

200：表示OK；

404：表示请求的资源路径不存在

500：表示服务器有问题。

### 1.5 HTTP常用的请求方式：GET和POST

> 开发中主要处理的就是Get和Post请求

##### GET请求方式

GET请求资源包括请求参数：第一个参数使用？和资源连接，其他参数使用&符号连接，GET请求信息限制不超过1KB如：[https://www.baidu.com/s?wd=http&rsv_spt=1](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.baidu.com%2Fs%3Fwd%3Dhttp%26rsv_spt%3D1)，GET请求暴露了请求信息

##### POST请求方式

POST请求行中不再有请求信息，参数全部在请求的实体中；POST隐藏了请求信息，较安全；并且POST方式没有限制请求的数据大小

![img](https://upload-images.jianshu.io/upload_images/6615897-9742e00c8b2bd729.png?imageMogr2/auto-orient/strip|imageView2/2/w/499/format/webp)