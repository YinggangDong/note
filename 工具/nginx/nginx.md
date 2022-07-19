# nginx使用

> Nginx是lgor Sysoev为俄罗斯访问量第二的rambler.ru站点设计开发的。从2004年发布至今，凭借开源的力量，已经接近成熟与完善。
>
> Nginx功能丰富，可作为HTTP服务器，也可作为反向代理服务器，邮件服务器。支持FastCGI、SSL、Virtual Host、URL Rewrite、Gzip等功能。并且支持很多第三方的模块扩展。

## 常用功能

### 1、Http代理，反向代理

作为web服务器最常用的功能之一，尤其是反向代理。

## docker安装

1. 获取 nginx 镜像：docker pull nginx

2. 启动nginx：

3. 映射配置文件

   1. 本地创建目录
   2. 复制容器内的文件到本地目录
   3. 停止并移除容器
   4. 再次启动容器并作目录挂载

   ```ruby
   命令：
   docker run  -p 80:80 --name nginx --restart=always 
   -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
   -v /data/nginx/conf.d:/etc/nginx/conf.d \
   -v /data/nginx/html:/usr/share/nginx/html \ 
   -v /data/nginx/logs:/var/log/nginx \ 
   -d  nginx
   注：为了好看所以做了换行，执行的时候还是需要改成一行，每行一个空格隔开就可以了
   
   ```

   ```
   docker run  -p 80:80 --name nginx --restart=always -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx/conf.d:/etc/nginx/conf.d -v /data/nginx/html:/usr/share/nginx/html -v /data/nginx/logs:/var/log/nginx -d  nginx
   ```

   