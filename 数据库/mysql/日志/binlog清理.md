# binlog清理

删除mysql的binlog日志有两种方法：自动删除和手动删除

## 1.自动删除

 永久生效：修改mysql的配置文件my.cnf，添加binlog过期时间的配置项：expire_logs_days=30，然后重启mysql，这个有个致命的缺点就是需要重启mysql。

 临时生效：进入mysql，用以下命令设置全局的参数：set global expire_logs_days=30;

 （上面的数字30是保留30天的意思。）

## 2.手动删除

可以直接删除binlog文件，但是可以通过mysql提供的工具来删除更安全，因为purge会更新mysql-bin.index中的条目，而直接删除的话，mysql-bin.index文件不会更新。mysql-bin.index的作用是加快查找binlog文件的速度。

1、首先登录的mysql

2、查看binlog 日志文件 mysql> show binary logs;

3、删除举例：

RESET MASTER;//删除所有binlog日志，新日志编号从头开始

PURGE MASTER LOGS TO 'mysql-bin.010';//删除mysql-bin.010之前所有日志

PURGE MASTER LOGS BEFORE '2003-04-02 22:46:26';// 删除2003-04-02 22:46:26之前产生的所有日志

清除3天前的 binlog
PURGE MASTER LOGS BEFORE DATE_SUB( NOW( ), INTERVAL 3 DAY);

个人感觉还是最下面的好用，当执行时提示0条响应，实现是已经把3天之前的binlog文件已经删除掉了。



## windows下binlog 的位置

mysql安装目录的data文件夹下的形如 mysql-bin.000001 的文件。

目录类似 C:\Program Files\mysql-5.6.13-winx64\data

