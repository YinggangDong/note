# 并发编程(二)：Thread类解析

> 既然要学习并发编程，那 Thread 类就跳不过去了，因为 Java 中的并发，归根结底都是新的 Thread 实例的 start() 方法的调用，因此，在这里对 Thread 类的常见方法进行梳理。

[toc]

## 一 Thread 的构造方法

### 1.1 常见构造

常见的构建方法通常是指定 Runnable 对象和名称，值得注意的是，多个构造方法实际调用的都是 Thread 类的 init 方法,该方法的参数含 Runnable 对象和线程名称。常见构造方法的调用代码如下：

```java
		/**
     * constructor 方法是 常见构造方法
     * 1.无参构造
     * 2.指定线程名称的线程
     * 3.指定 runnable 实现类的线程
     * 4.指定 runnable 和线程名称的线程
     * 调用方法实际是调用了 init 方法
     *
     * @author dongyinggang
     * @date 2020/11/30 15:17
     */
    public static void constructor(){
        //1.无参构造
        Thread thread = new Thread();
        System.out.println(thread.getName());
        //2.指定线程名称的线程
        thread = new Thread("t-1");

        Runnable runnable = new ImplRunnable("r-1");
        //3.指定 runnable 实现类的线程
        thread = new Thread(runnable);
        //4.指定 runnable 和线程名称的线程
        thread = new Thread(runnable,"t-2");

    }
```

### 1.2 线程名称的设置与获取

线程名称的获取通常通过 Thread.currentThread().getName() ,可以获取当前执行线程的名称。

如果没有做什么的设置，我们会发现线程的名字是这样子的：**主线程叫做main，其他线程是Thread-x**

看一下线程初始化的默认命名步骤。

以无参构造为例：

![image-20201201195438054](图片/image-20201201195438054.png)

可以看到当无线程名称传入时，默认的名称以 "Thread-" + nextThreadNum() 构成，看一下 nextThreadNum() 方法的实现。

![image-20201201195542189](图片/image-20201201195542189.png)

threadInitNumber 这个变量作为一个静态 int 变量，初始值为0，所以线程从Thread-0开始，随着匿名线程的增加，该值不断进行自增，这个变量实际就是匿名线程的创建次序，**直接指定名称的线程不会使该值进行自增**。

以这段代码为例：

```java
public static void constructor(){
    //1.无参构造
    Thread thread = new Thread();
    System.out.println(thread.getName());
    //2.指定线程名称的线程
    thread = new Thread("t-1");

    Runnable runnable = new ImplRunnable("r-1");
    //3.指定 runnable 实现类的线程
    thread = new Thread(runnable);
    System.out.println(thread.getName());
    //4.指定 runnable 和线程名称的线程
    thread = new Thread(runnable,"t-2");

}
```

运行后可以看到结果如下：

![image-20201201200304458](图片/image-20201201200304458.png)

通过指定线程名称的方式创建线程时，并没有使 threadInitNumber 自增，源码中也可以看到支持这一点：

![image-20201201200430080](图片/image-20201201200430080.png)

name是由入参决定的，与 threadInitNumber 无关。

当我们决定自己命名线程名称时，我们应当如何做呢，常见的命名方式有两种：

1. 通过构造方法设置线程名称

2. 通过setName方法设置线程名称

示例代码如下：

```java
		/**
     * threadName 方法是 设置线程名称的两种方式
     * 1.通过构造方法设置线程名称
     * 2.通过setName方法设置线程名称
     * 注：
     * 若没有指定线程名称,会使用"Thread-x"(x指线程初始数量,是 Thread 类的 threadInitNumber)
     *
     * @author dongyinggang
     * @date 2020/12/1 18:14
     */
    public static void threadName(){
        //1.通过构造方法设置线程名称
        Thread thread = new Thread(ThreadSourceTest::outputThreadName,"t-1");

        thread.start();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        //2.通过setName方法设置线程名称
        thread.setName("t-2");
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    /**
     * outputThreadName 方法是 输出线程名称的方法
     *
     * @author dongyinggang
     * @date 2020/12/1 19:20
     */
    private static void outputThreadName(){
        int i = 0;
        int times = 4;
        while(i<times){
            System.out.println(Thread.currentThread().getName()+" is running");
            try {
                i++;
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
```

通过构造方法将线程名称设置为“t-1”，运行 1s 后将线程名称通过 setName 方法设置新的线程名称“t-2”，再运行 1s，可以得到输出结果如下：

 ![image-20201201201242914](图片/image-20201201201242914.png)

符合预期，出现了两种方式分别设置的线程名称。

## 参考内容

