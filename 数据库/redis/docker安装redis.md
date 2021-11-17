# docker安装redis

## 1.查看redis可用版本

```shell
docker search redis
```

![image-20210928131430576](图片/image-20210928131430576.png)

## 2.拉取最新的redis镜像

拉取官方的最新镜像

```shell
docker pull redis:latest
```

![image-20210928131602741](图片/image-20210928131602741.png)

## 3.查看本地镜像

```shell
docker images
```

![image-20210928131646638](图片/image-20210928131646638.png)

可以看到已经将镜像拉取到

## 4.运行容器

```shell
docker run -itd --name redis-test -p 6379:6379 redis
```

![image-20210928131819899](图片/image-20210928131819899.png)

## 5.安装成功

查看容器的运行信息

![image-20210928131905424](图片/image-20210928131905424.png)

## 6.测试连接

通过redis-cli连接测试redis服务

```shell
docker exec -it redis-test /bin/bash
```

![image-20210928132736284](图片/image-20210928132736284.png)

能够正常的进行redis的操作。

