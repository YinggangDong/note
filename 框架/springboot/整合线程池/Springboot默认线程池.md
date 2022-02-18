# Spring Boot教程(21) – 默认线程池

原文：[Spring Boot教程(21) – 默认线程池](https://zhuanlan.zhihu.com/p/85855282)



之前我们简要说过`@Async`和`@Scheduled`的用法，这俩注解会帮你完成异步任务和定时任务的需求。不知道你有没有想过，这些异步任务和定时任务都是在哪个线程执行的？Spring Boot肯定在背后做了很多工作，本文就来说说框架都为我们做了什么。

首先肯定是有线程池的。Spring Boot已经帮你创建并配置好了，还配了两个，一个供`@Async`使用，一个供`@Scheduled`使用。

Spring将异步任务和定时任务的执行，抽象出了两个接口，`TaskExecutor`和`TaskScheduler`。我们先来说说`TaskExecutor`。

![img](https://pic1.zhimg.com/80/v2-ac52b68b843475bff082877cd802c7b8_720w.jpg)

如果你对Java的线程池相关的API比较熟，那么在需要使用线程池的场景，你可能会用`Executors`来生成`ExecutorService`（继承于`Executor`），从而执行任务。Spring中的`TaskExecutor`其实和Java的`Executor`是一样的，只不过后者是在Java 5的时候被引入的，Spring为了兼容之前的Java版本，自己搞了一套。时至今日，Spring已经最低要求Java 8了，但是为了兼容之前的Spring版本，还是保持了自己的API，基础的`TaskExecutor`接口已经直接继承于`Executor`了（如上图）。

`TaskExecutor`有很多实现，比如`SyncTaskExecutor`会在调用者的当前线程同步执行任务；比如`SimpleAsyncTaskExecutor`会针对每个任务新建一个线程，运行完线程就停止；比如你可以通过`ConcurrentTaskExecutor`，将`Executor`对象包装成`TaskExecutor`对象，这样将Java的`Executor`对象纳入到Spring管理，方便使用；再比如最常用的`ThreadPoolTaskExecutor`，内部有个线程池，任务扔进去运行就完了。实际上`ThreadPoolTaskExecutor`封装了Java的`ThreadPoolExecutor`，封装的同时也会对其进行一些配置。

Spring Boot会帮你自动生成一个`ThreadPoolTaskExecutor`，进行了默认配置，相关代码在`TaskExecutionAutoConfiguration`。使用如下属性，还可以对线程池进行自定义，比如核心线程数目、最多线程数目、线程名前缀等等：

![img](https://pic2.zhimg.com/80/v2-29171497fab45369c8bc05106b95f3e5_720w.jpg)

如果你的代码里需要`ThreadPoolTaskExecutor`，直接通过`@Autowired`引入就行了。而`@Async`注解用的正是Spring Boot自动生成的这个对象，具体一点说，就是它会去容器里找`TaskExecutor`类型的Bean，如果有多个，他会再去找名为“taskExecutor”、类型为`Executor`的Bean。我在源码里扒拉半天才搞清楚的，如果也想搞清楚，可以查看`AsyncExecutionAspectSupport`的`getDefaultExecutor`方法。

下面再来说说`TaskScheduler`。

![img](https://pic1.zhimg.com/80/v2-d07a77a08754559269bcda12ff3b8820_720w.jpg)

`TaskScheduler`倒是没有什么历史遗留问题，你看看上图中的它的方法，会发现，这不跟`@Scheduled`注解的参数是大致对应的嘛，简直太好理解了：

![img](https://pic4.zhimg.com/80/v2-3a459c7d03cf7f99161bb758ea8a1e2f_720w.jpg)

我们上面说了，定时任务也有一个对应的线程池，具体实现由`ThreadPoolTaskScheduler`负责的，它其实是封装了Java里的`ScheduledExecutorService`。并且也有对应的属性方便你去自定义：

![img](https://pic4.zhimg.com/80/v2-828c4ebfdec159896758f29ddd9a6857_720w.png)

如果你研究透了之后会发现，以上其实就是典型的Spring Boot的特点，“自动配置好，不够你自己改”。你通过`@EnableAsync`和`@EnableScheduling`来开启功能，然后就可以通过`@Async`和`@Scheduled`来执行异步任务和定时任务，这些任务会分别扔给容器里的`ThreadPoolTaskExecutor`和`ThreadPoolTaskScheduler`，然后放到各自的线程池中运行，想要自定义可以在application.properties中修改属性，如果还觉得不够用，甚至可以给容器提供自己的`TaskExecutor`和`TaskScheduler`实现来覆盖Spring Boot默认给你的对象。如果你只想自定义`@Async`使用的线程池，可以通过`AsyncConfigurer`提供一个自己的`Executor`实现。这样一步步由浅入深，由简单场景过渡到复杂场景，各种需求都可以满足。如果有人还不理解Spring Boot的特点到底是啥，你可以拿本文的例子来讲。

再说说`@Async`的异常处理。如果你的`@Async`方法的返回值是`Future`类型或者`ListenableFuture`或者`CompletableFuture`等类型，那么你在调用`Future.get()`方法的时候，异常会被抛出。如果你的`@Async`方法的返回值是void，那么你可以通过`AsyncConfigurer`传递一个全局的`AsyncUncaughtExceptionHandler`对象用来处理异常，它会跟你的任务在同一线程执行。

还有几个类，Spring文档并没有给出怎么用，但是源码告诉了大家怎么用。

比如`TaskExecutorCustomizer`，你的`ThreadPoolTaskExecutor`在创建完成并通过application.properties做了定制之后，还可以通过`TaskExecutorCustomizer`进行进一步的定制。对应的，`TaskSchedulerCustomizer`还可以对`ThreadPoolTaskScheduler`进行定制。比如`TaskDecorator`，可以对放到`ThreadPoolTaskExecutor`里执行的`Runnable`进行封装。你需要做的就是实现`TaskExecutorCustomizer`、`TaskSchedulerCustomizer`或者`TaskDecorator`，并通过`@Bean`方法或者`@Component`注解，将他们放到容器中去。

PS：我写完之后反复读了本文，感觉如果不跟着源码一起看的话，很可能不能很好理解。源码和概念相结合，使用效果更佳。