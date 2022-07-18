# Spring工具拾遗(一)：StopWatch

[toc]



```shell
Benchmark                        Mode  Cnt   Score   Error  Units
StopWatchBenchmark.useStopWatch  avgt   10  57.909 ± 5.910  ms/op
StopWatchBenchmark.useSystem     avgt   10  65.292 ± 7.197  ms/op
```



```
Benchmark                             Mode  Cnt   Score    Error  Units
StopWatchBenchmark.useStopWatchOne    avgt    5  19.799 ±  7.482  ms/op
StopWatchBenchmark.useStopWatchThree  avgt    5  53.057 ± 22.730  ms/op
StopWatchBenchmark.useSystemOne       avgt    5  26.854 ± 39.255  ms/op
StopWatchBenchmark.useSystemThree     avgt    5  60.700 ± 28.056  ms/op
```





## 参考内容

【1】[Spring计时器StopWatch使用](https://blog.csdn.net/gxs1688/article/details/87185030)

【2】[Callable接口详解](https://blog.csdn.net/m0_37204491/article/details/87930790)

【3】[StopWatch单线程问题及多线程ConcurrentStopWatch解决方案](https://blog.csdn.net/musuny/article/details/88903312)