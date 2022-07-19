# JMH基准测试工具

## JMH是什么？
JMH 是 OpenJDK 团队开发的一款基准测试工具，一般用于代码的性能调优，精度甚至可以达到纳秒级别，适用于 java 以及其他基于 JVM 的语言。和 Apache JMeter 不同，JMH 测试的对象可以是任一方法，颗粒度更小，而不仅限于rest api。

JMH 自动生成基准测试代码的本质就是使用 maven 插件的方式，在 package 阶段对配置项目进行解析和包装。

github：https://github.com/openjdk/jmh

## JMH引入

需要引入以下依赖：

```xml
<!-- JMH性能测试框架 -->
<dependencies>
    <dependency>
        <groupId>org.openjdk.jmh</groupId>
        <artifactId>jmh-core</artifactId>
        <version>1.35</version>
    </dependency>
    <dependency>
        <groupId>org.openjdk.jmh</groupId>
        <artifactId>jmh-generator-annprocess</artifactId>
        <version>1.35</version>
    </dependency>
</dependencies>
```

## 常见注解

### 示例代码

```java
/**
 * 异常性能测试
 * 验证异常对性能的影响
 *
 * @author dongyinggang
 * @module performance-tests
 * @date 2022/6/30 10:56
 */
//开辟目标数量的进程来进行测试
@Fork(1)
//预热的迭代次数
@Warmup(iterations = 2)
//度量:iterations进行测试的轮次，time每轮进行的时长，timeUnit时长单位，batchSize批次数量
@Measurement(iterations = 10)
//平均时间
@BenchmarkMode(Mode.AverageTime)
//测试结果使用的单位
@OutputTimeUnit(TimeUnit.MILLISECONDS)
public class ExceptionBenchmark {
    private static final int LIMIT = 10_000;

    public static void main(String[] args) throws RunnerException {
        Options options = new OptionsBuilder()
                .include(ExceptionBenchmark.class.getSimpleName())
                .build();
        new Runner(options).run();
    }

    @Benchmark
    public void doNotThrowException(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            blackhole.consume(new Object());
        }
    }
}
```

### 3.1 @BenchmarkMode(Mode.All)
Mode有：

- Throughput: 整体吞吐量，例如“1秒内可以执行多少次调用” (thrpt,参加第5点)
- AverageTime: 调用的平均时间，例如“每次调用平均耗时xxx毫秒”。（avgt）
- SampleTime: 随机取样，最后输出取样结果的分布，例如“99%的调用在xxx毫秒以内，99.99%的调用在xxx毫秒以内”（simple）
- SingleShotTime: 以上模式都是默认一次 iteration 是 1s，唯有 SingleShotTime 是只运行一次。往往同时把 warmup 次数设为0，用于测试冷启动时的性能。（ss）
### 3.2 @OutputTimeUnit(TimeUnit.MILLISECONDS)
统计单位， 微秒、毫秒 、分、小时、天

### 3.3 @State
类注解，JMH测试类必须使用@State注解，State定义了一个类实例的生命周期，可以类比Spring Bean的Scope。由于JMH允许多线程同时执行测试，不同的选项含义如下：

- Scope.Thread：默认的State，每个测试线程分配一个实例；
- Scope.Benchmark：所有测试线程共享一个实例，用于测试有状态实例在多线程共享下的性能；
- Scope.Group：每个线程组共享一个实例；
### 3.4 @Benchmark
很重要的方法注解，表示该方法是需要进行 benchmark 的对象。和@test 注解一致

### 3.5 @Setup
方法注解，会在执行 benchmark 之前被执行，正如其名，主要用于初始化。

## 测试结果 
测试平均耗时的示例如下：
```dos
Benchmark                                                 Mode  Cnt    Score    Error  Units
ExceptionBenchmark.createExceptionWithoutThrowingIt       avgt   10   14.443 ±  4.204  ms/op
ExceptionBenchmark.doNotThrowException                    avgt   10    0.056 ±  0.009  ms/op
ExceptionBenchmark.throwAndCatchException                 avgt   10   15.056 ±  3.378  ms/op
ExceptionBenchmark.throwExceptionAndUnwindStackTrace      avgt   10  189.837 ± 55.140  ms/op
ExceptionBenchmark.throwExceptionWithoutAddingStackTrace  avgt   10    0.402 ±  0.041  ms/op
```
- Benchmark：是进行测试的对象。
- Mode：测试的指标
- Cnt：测试次数
- Score：测试的平均结果
- Error：误差
- Units：单位 ms/op -> 每次操作用时多少毫秒

测试吞吐量的测试如下：
```dos
Benchmark                           Mode  Cnt      Score      Error   Units
DemoBenchmark.doNotThrowException  thrpt   10  65727.158 ± 8827.278  ops/ms
```

## 验证异常的资源消耗

1. 异常开销的相关验证

```java

package info.dyg.order.performancetests;

import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Warmup;
import org.openjdk.jmh.infra.Blackhole;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;

import java.util.concurrent.TimeUnit;

/**
 * 异常性能测试
 * 验证异常对性能的影响
 *
 * @author dongyinggang
 * @module performance-tests
 * @date 2022/6/30 10:56
 */
@Fork(1)
@Warmup(iterations = 2)
@Measurement(iterations = 10)
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
public class ExceptionBenchmark {
    private static final int LIMIT = 10_000;

    public static void main(String[] args) throws RunnerException {
        Options options = new OptionsBuilder()
                .include(ExceptionBenchmark.class.getSimpleName())
                .build();
        new Runner(options).run();
    }

    @Benchmark
    public void doNotThrowException(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            blackhole.consume(new Object());
        }
    }

    @Benchmark
    public void throwAndCatchException(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            try {
                throw new Exception();
            } catch (Exception e) {
                blackhole.consume(e);
            }
        }
    }

    @Benchmark
    public void createExceptionWithoutThrowingIt(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            blackhole.consume(new Exception());
        }
    }

    @Benchmark
    @Fork(value = 1, jvmArgs = "-XX:-StackTraceInThrowable")
    public void throwExceptionWithoutAddingStackTrace(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            try {
                throw new Exception();
            } catch (Exception e) {
                blackhole.consume(e);
            }
        }
    }

    @Benchmark
    public void throwExceptionAndUnwindStackTrace(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            try {
                throw new Exception();
            } catch (Exception e) {
                blackhole.consume(e.getStackTrace());
            }
        }
    }
}

```

结果如下：

```dos
Benchmark                                                 Mode  Cnt    Score    Error  Units
ExceptionBenchmark.createExceptionWithoutThrowingIt       avgt   10   14.443 ±  4.204  ms/op
ExceptionBenchmark.doNotThrowException                    avgt   10    0.056 ±  0.009  ms/op
ExceptionBenchmark.throwAndCatchException                 avgt   10   15.056 ±  3.378  ms/op
ExceptionBenchmark.throwExceptionAndUnwindStackTrace      avgt   10  189.837 ± 55.140  ms/op
ExceptionBenchmark.throwExceptionWithoutAddingStackTrace  avgt   10    0.402 ±  0.041  ms/op
```

| 效率 | 描述                           | 结果                                    |
| ---- | ------------------------------ | --------------------------------------- |
| 1    | 不产生异常                     | 0.056 ±(99.9%) 0.009 ms/op [Average]    |
| 2    | 抛出并捕获异常，但不追踪堆栈   | 0.402 ±(99.9%) 0.041 ms/op [Average]    |
| 3    | 创建异常，不抛出               | 14.443 ±(99.9%) 4.204 ms/op [Average]   |
| 4    | 抛出并捕获异常                 | 15.056 ±(99.9%) 3.378 ms/op [Average]   |
| 5    | 抛出并捕获异常，并展开堆栈追踪 | 189.837 ±(99.9%) 55.140 ms/op [Average] |

异常的开销包括：

- 创建异常
- 捕获并捕获异常

从以上来看：

- 1和2对照，创建异常并可发现抛出并捕获异常，比不产生异常的平均耗时高了8倍。
- 1、3、4对照，发现只要创建了异常无论是否抛出都会比1的平均耗时高200+倍，可得出结论，抛出并捕获异常的消耗较小，但创建异常的消耗很大。
- 2和4对照，发现创建异常时，追踪堆栈信息的话，耗时会变为原来的3倍，说明创建异常过程中，追踪堆栈信息对性能损耗较大。
- 3和5对照，发现捕获后输出堆栈信息比直接输出异常耗时增加了12倍，说明输出堆栈信息对性能损耗较大

因此，如果将业务异常默认不获取堆栈信息，能够让异常的性能有效降低。

异常的创建过程中，实际是异常基类的 `Throwable` 的 `fillInStackTrace` 方法来获取并填充堆栈信息，因此重写该方法，不让其去获取并设置堆栈信息即可。

2. 异常性能优化的相关验证

```java
package info.dyg.order.performancetests;

import info.dyg.order.common.exception.BusinessRuntimeException;
import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Warmup;
import org.openjdk.jmh.infra.Blackhole;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;

import java.util.concurrent.TimeUnit;

/**
 * 异常性能优化测试
 * 验证重写异常的 fillInStackTrace 方法可以有效降低异常的性能开销
 *
 * @author dongyinggang
 * @module performance-tests
 * @date 2022/6/30 17:17
 */
@Fork(1)
@Warmup(iterations = 2)
@Measurement(iterations = 10)
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
public class ExceptionOptimizationBenchmark {

    private static final int LIMIT = 10_000;

    public static void main(String[] args) throws RunnerException {
        Options options = new OptionsBuilder()
                .include(ExceptionOptimizationBenchmark.class.getSimpleName())
                .build();
        new Runner(options).run();
    }

    @Benchmark
    public void doNotThrowException(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            blackhole.consume(new Object());
        }
    }

    @Benchmark
    public void throwAndCatchException(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            try {
                throw new Exception();
            } catch (Exception e) {
                blackhole.consume(e);
            }
        }
    }

    @Benchmark
    public void throwAndCatchBusinessRuntimeException(Blackhole blackhole) {
        for (int i = 0; i < LIMIT; i++) {
            try {
                throw new BusinessRuntimeException("test");
            } catch (Exception e) {
                blackhole.consume(e);
            }
        }
    }


}

```

结果如下：

```dos
Benchmark                                                             Mode  Cnt   Score   Error  Units
ExceptionOptimizationBenchmark.doNotThrowException                    avgt   10   0.064 ± 0.008  ms/op
ExceptionOptimizationBenchmark.throwAndCatchBusinessRuntimeException  avgt   10   0.261 ± 0.029  ms/op
ExceptionOptimizationBenchmark.throwAndCatchException                 avgt   10  15.297 ± 2.507  ms/op
```

`ExceptionOptimizationBenchmark`的结果证明，通过给`BusinessRuntimeException`类重写`fillInStackTrace`
方法来实现不追踪堆栈的异常，可以有效降低异常的性能损耗。在`ExceptionOptimizationBenchmark`
中把 `BusinessRuntimeException` 和 `Exception`进行了对比,有明显差异。

- 抛出不追踪堆栈的 `BusinessRuntimeException` 类,耗时是不抛出异常的4倍左右
- 抛出追踪堆栈的 `Exception` 类,耗时是不抛出异常的239倍左右

## 参考内容

【1】[JMH 性能测试框架](https://www.jianshu.com/p/ad34c4c8a2a3)

【2】[基准测试框架JMH使用详解](https://blog.csdn.net/ZYC88888/article/details/113741316)

【3】[10行代码理解Java锁消除 ](https://www.sohu.com/a/304044175_268033)