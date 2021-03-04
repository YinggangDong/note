# JVM(3)：线程安全

> ”当多个线程访问一个对象时，如果不用考虑这些线程在运行时环境下的调度和交替执行，也不需要进行额外的同步，或者在调用方进行任何其他的协调操作，调用这个对象的行为都可以获得正确的结果，那这个对象是线程安全的。“

## 1 Java 语言中的线程安全

按线程安全按“安全强度”由强至若来排序，我们可以将 Java 语言中各项操作共享的数据分为以下 5 类：不可变、绝对线程安全、相对线程安全、线程兼容和线程对立。

1. **不可变对象**

不可变（Immutable）的对象一定是线程安全的，不需要再采取任何的线程安全保障措施。只要一个不可变的对象被正确地构建出来，永远也不会看到它在多个线程之中处于不一致的状态。多线程环境下，应当尽量使对象成为不可变，来满足线程安全。

不可变的类型：

final 关键字修饰的基本数据类型
String
枚举类型
Number 部分子类，如 Long 和 Double 等数值包装类型，BigInteger 和 BigDecimal 等大数据类型。但同为 Number 的原子类 AtomicInteger 和 AtomicLong 则是可变的。
对于集合类型，可以使用 Collections.unmodifiableXXX() 方法来获取一个不可变的集合。

例外：this逃逸,详情见 [参考【2】](#reference2) 

2. **绝对线程安全**

绝对线程安全完全满足本篇开头Brian Goetz给出的线程安全的定义。这种定义十分严格，要达到这个要求通常需要付出很大代价，有些时候甚至不切实际。Java中线程安全的类，大多数都不是绝对线程安全的。

3. **相对线程安全**

在一般情况下，调用者都不需要考虑线程同步，大多数情况下，都能够正常运行。jdk 里面大多数类都是相对安全的。最常见的例子是java里面Vector类。记得网上经典的面试问题就是 Vertor 和 List 的区别，一般情况下都会说Vertor 是线程安全的，List 是非线程安全的。但是考虑以下情况，一个线程遍历 Vector，另外一个线程删除Vector 中的一个元素，会导致什么问题？有可能在 read 方法中抛出 ArrayIndexOutOfBoundException。

在Java语言中，大部分线程安全类都属于这种类型，例如 Vector、HashTable、Collections 的 synchronizedCollection() 方法包装的集合等。

4. **线程兼容**

指线程本身并不是线程安全的，但可以通过调用端的正确同步手段来保证对象在并发环境中可以安全的使用，我们平时说的一个类线程不安全绝大多数时候是指这一种情况。Java API 中大部分的类都是属于线程兼容的，如 ArrayList、HashMap 等。

5. **线程对立**

无论调用端是否采取了同步措施，都无法在多线程环境中并发使用的代码。

一个线程对立的例子是 Thread 类的 suspend() 和 resume() 方法，如果两个线程同时持有一个线程对象，一个尝试去中断线程，一个尝试去恢复线程，如果并发尽心的话，无论调用时是否进行了同步，目标线程都是存在死锁风险的，如果 suspend()  中断的线程就是即将要执行 resume() 的那个线程，那就肯定要死锁了。因此，suspend() 和 resume() 方法已经被 JDK 声明废弃。

## 2 线程安全的实现方法

通过虚拟机提供的同步和锁机制来编写代码可以有效的实现线程安全。

1. **互斥同步**

同步指在多个线程并发访问共享数据时，保证共享数据在同一时刻只被一个（或者是一些，使用信号量的时候）线程使用。

互斥是实现同步的一种手动，临界区（Critical Section）、互斥量（Mutex）和信号量（Semaphore）都是主要的互斥实现方式。

Java中最基本的互斥同步手段就是 synchronized 关键字，属于一个重量级操作。

除了 synchronized 之外，我们还可以使用 `java.util.concurrent` 包中的重入锁（`ReentrantLock`）来实现同步。代码区别上如下：

synchronized

```java
		/**
     * synchronizedBlockObj1 和 synchronizedBlockObj2 方法是 两个方法分别锁不同的对象
     * 这样对两个对象分别加锁，实际上是互不影响的，可以分别执行，不会阻塞另一个线程
     *
     * @author dongyinggang
     * @date 2020/12/9 19:41
     */
    void synchronizedBlockObj1() {
        // 修饰代码块
        synchronized (lock1){
            for (int i = 0; i < FIVE_INT; i++) {
                System.out.println(Thread.currentThread().getName());
            }
        }
    }
```

lock

```java
private void func() {
    lock.lock();
    try {
        for (int i = 0; i < 10; i++) {
            System.out.println(Thread.currentThread().getName() + " 输出 " + i);
        }
        System.out.println(Thread.currentThread().getName() + " 输出完毕");
    } finally {
        lock.unlock(); // 确保释放锁，从而避免发生死锁。
        System.out.println(Thread.currentThread().getName() + " 释放锁");
    }
}
```

## 参考内容

【1】深入理解 Java 虚拟机（第二版）

【2】<a name="reference2">[this引用逃逸](https://www.cnblogs.com/jian0110/p/9369096.html) </a>