## JVM问题分析实例 1



## 问题现象

在公司搭建的测试环境中，出现某项目在运行一段时间后，某批量生成工单相关接口报500，项目仍处于运行状态且可以提供其他查询接口的情况。

## 问题分析

鉴于项目刚启动时，该批量生成工单接口可以正常调用，累计调用生成3000工单左右后，该接口报500，即接口可用，但可能被某些内容限制，因此考虑对其内存使用情况等进行排查。

排查过程如下：

1. jps确认项目的pid
2. jinfo pid 可以查看项目JVM的相关参数

```s
VM Flags:
Non-default VM flags: -XX:CICompilerCount=12 -XX:InitialHeapSize=134217728 -XX:MaxHeapSize=134217728 -XX:MaxNewSize=44564480 -XX:MinHeapDeltaBytes=524288 -XX:NewSize=44564480 -XX:OldSize=89653248 -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseParallelGC 
Command line:  -Djava.security.egd=file:/dev/./urandom -Xmx128m
```

3. 通过jmap -heap pid查看堆内存的使用情况

项目重新启动后没做任何操作：

```
Heap Usage:
PS Young Generation
Eden Space:
   capacity = 34078720 (32.5MB)
   used     = 3423112 (3.2645339965820312MB)
   free     = 30655608 (29.23546600341797MB)
   10.044719989483173% used
From Space:
   capacity = 5242880 (5.0MB)
   used     = 5237968 (4.9953155517578125MB)
   free     = 4912 (0.0046844482421875MB)
   99.90631103515625% used
To Space:
   capacity = 5242880 (5.0MB)
   used     = 0 (0.0MB)
   free     = 5242880 (5.0MB)
   0.0% used
PS Old Generation
   capacity = 89653248 (85.5MB)
   used     = 88584440 (84.48070526123047MB)
   free     = 1068808 (1.0192947387695312MB)
   98.80784241079587% used
```

可以看到启动后老年代占用98%，这些对象是无法回收的

新生代enden区空闲29M可用，s0占满，s1（5M）虽然空闲，但是不能用， 老年代没有空间。

注：也就是说启动后只有29M的内存空间用来生成对象。

执行业务后：

```
Heap Usage:
PS Young Generation
Eden Space:
   capacity = 29884416 (28.5MB)
   used     = 29884416 (28.5MB)
   free     = 0 (0.0MB)
   100.0% used
From Space:
   capacity = 5767168 (5.5MB)
   used     = 0 (0.0MB)
   free     = 5767168 (5.5MB)
   0.0% used
To Space:
   capacity = 7864320 (7.5MB)
   used     = 0 (0.0MB)
   free     = 7864320 (7.5MB)
   0.0% used
PS Old Generation
   capacity = 89653248 (85.5MB)
   used     = 89595920 (85.44532775878906MB)
   free     = 57328 (0.0546722412109375MB)
   99.93605585823282% used
```

可以看到：

新生代已经满了，无法为创建的对象分配空间，老年代已满，已无法分配！

### 问题解决

通过以上的分析过程，可以看到是因为堆内存分配过小，导致GC无效，尽管系统尝试多次Full GC，但依然没有空间被腾出来给新生成的对象使用，因此联系运维的同事将堆内存调整至1GB，在以上述命令查看堆内存的占用情况，可以看到GC正常进行且有效的实现了回收，不再出现500的问题。

