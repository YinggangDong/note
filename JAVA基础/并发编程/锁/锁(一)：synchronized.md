# 锁(一)：synchronized

## 1 synchronized是什么？

synchronized是Java的一个**实现线程同步的关键字**，它能够将**代码块(方法)锁起来**。

**随着学习的进行我们知道在JDK1.5之前synchronized是一个重量级锁，相对于j.u.c.Lock，它会显得那么笨重，以至于我们认为它不是那么的高效而慢慢摒弃它**。

不过，**随着Javs SE 1.6对synchronized进行的各种优化后，synchronized并不会显得那么重了**。

-  它使用起来是非常简单的，只要在代码块(方法)添加关键字synchronized，即可以**实现同步**的功能~

  ```java
public synchronized void test(){
        //doSomething
}
  ```

synchronized是一种**互斥锁**

- **一次只能允许一个线程进入被锁住的代码块**

synchronized是一种**内置锁/监视器锁**

- Java中**每个对象**都有一个**内置锁(监视器,也可以理解成锁标记)**，而synchronized就是使用**对象的内置锁(监视器)**来将代码块(方法)锁定的！ (锁的是对象，但我们同步的是方法/代码块)

## 2 synchronized的特性

#### 2.1 原子性

**所谓原子性就是指一个操作或者多个操作，要么全部执行并且执行的过程不会被任何因素打断，要么就都不执行。**

在Java中，对基本数据类型的变量的读取和赋值操作是原子性操作，即这些操作是不可被中断的，要么执行，要么不执行。但是像i++、i+=1等操作字符就不是原子性的，它们是分成**读取、计算、赋值**几步操作，原值在这些步骤还没完成时就可能已经被赋值了，那么最后赋值写入的数据就是脏数据，无法保证原子性。

被synchronized修饰的类或对象的所有操作都是原子的，因为在执行操作之前必须先获得类或对象的锁，直到执行完才能释放，这中间的过程无法被中断（除了已经废弃的stop()方法），即保证了原子性。

**注意！面试时经常会问比较synchronized和volatile，它们俩特性上最大的区别就在于原子性，volatile不具备原子性。**

#### 2.2 可见性

**可见性是指多个线程访问一个资源时，该资源的状态、值信息等对于其他线程都是可见的。**

synchronized和volatile都具有可见性，其中synchronized对一个类或对象加锁时，一个线程如果要访问该类或对象必须先获得它的锁，而这个锁的状态对于其他任何线程都是可见的，并且在释放锁之前会将对变量的修改刷新到主存当中，保证资源变量的可见性，**如果某个线程占用了该锁，其他线程就必须在锁池中等待锁的释放**。

而volatile的实现类似，被volatile修饰的变量，**每当值需要修改时都会立即更新主存**，主存是共享的，所有线程可见，所以确保了其他线程读取到的变量永远是最新值，保证可见性。

#### 2.3 有序性

**有序性值程序执行的顺序按照代码先后执行。**

synchronized和volatile都具有有序性，Java允许编译器和处理器对指令进行重排，**但是指令重排并不会影响单线程的顺序，它影响的是多线程并发执行的顺序性**。synchronized保证了每个时刻都只有一个线程访问同步代码块，也就确定了线程执行同步代码块是分先后顺序的，保证了有序性。

#### 2.4 可重入性

**synchronized和ReentrantLock都是可重入锁**。当一个线程试图操作一个由其他线程持有的对象锁的临界资源时，将会处于阻塞状态，**但当一个线程再次请求自己持有对象锁的临界资源时，这种情况属于重入锁**。通俗一点讲就是说一个线程拥有了锁仍然还可以重复申请锁。

## 3 synchronized的原理

在理解锁实现原理之前先了解一下Java的对象头和Monitor，在JVM中，对象是分成三部分存在的：对象头、实例数据、对齐填充。

![image-20210222144223756](图片/image-20210222144223756.png)

实例数据和对齐填充与synchronized无关。

**实例数据**存放类的属性数据信息，包括父类的属性信息，如果是数组的实例部分还包括数组的长度，这部分内存按4字节对齐；

**对齐填充**不是必须部分，由于虚拟机要求对象起始地址必须是8字节的整数倍，对齐填充仅仅是为了使字节对齐。

其中对象头是要关注的内容，它是 synchronized 实现锁的基础，因为synchronized申请锁、上锁、释放锁都与对象头有关。对象头主要结构是由 `Mark Word` 和 `Class Metadata Address`组成，**其中**`Mark Word` 存储对象的hashCode、锁信息或分代年龄或GC标志等信息，`Class Metadata Address`**是类型指针指向对象的类元数据，JVM通过该指针确定该对象是哪个类的实例**。

锁也分不同状态，JDK6之前只有两个状态：无锁、有锁（重量级锁），而在JDK6之后对synchronized进行了优化，新增了两种状态，总共就是四个状态：**无锁状态、偏向锁、轻量级锁、重量级锁**，其中无锁就是一种状态了。锁的类型和状态在对象头`Mark Word`中都有记录，在申请锁、锁升级等过程中JVM都需要读取对象的`Mark Word`数据。

每一个锁都对应一个monitor对象，在HotSpot虚拟机中它是由ObjectMonitor实现的（C++实现）。每个对象都存在着一个monitor与之关联，对象与其monitor之间的关系有存在多种实现方式，如monitor可以与对象一起创建销毁或当线程试图获取对象锁时自动生成，但当一个monitor被某个线程持有后，它便处于锁定状态。

## 4 synchronized的使用

synchronized一般可以用来修饰三种东西：

1.实例（普通）方法

2.静态方法

3.代码块（锁不一样的对象，或者类）

被加锁的方法和代码块均放在一个类中，用来支持演示各种锁的情形，其实例代码如下：

```java
package cn.dyg.keyword.syn;

/**
 * SynObj 类是 synchronized加锁对象
 * synchronized 是 Java 的一个关键字，它能够将代码块(方法)锁起来
 *
 * @author dongyinggang
 * @date 2020-12-09 13:12
 **/
public class SynObj {

    private final Object lock1 = new Object();
    private final Object lock2 = new Object();

    /**
     * staticMethod 给静态方法付加锁,锁的是SynObj类
     *
     * @author dongyinggang
     * @date 2020/12/9 13:11
     */
    public synchronized static void staticMethod(){
        while (true){
            System.out.println(Thread.currentThread().getName());
        }
    }

    /**
     * instanceMethod 方法是 给实例方法加synchronized锁
     * 给普通方法加锁，锁的是对象实例，多个实例时会出现并发问题
     *
     * @author dongyinggang
     * @date 2020/11/27 16:28
     */
    public synchronized void instanceMethod(){
        while (true){
            System.out.println(Thread.currentThread().getName());
        }
    }

    /**
     * synchronizedBlock 方法是 给代码块加synchronized锁
     * 如果是加this的话，实际与给实例方法加synchronized一样，都是锁了本类的实例
     *
     * @author dongyinggang
     * @date 2020/11/27 16:39
     */
    public synchronized void synchronizedBlock(){
        // 修饰代码块
        synchronized (this){
            while (true){
                System.out.println(Thread.currentThread().getName());
            }
        }
    }

    public synchronized void synchronizedBlockThis(){
        // 修饰代码块
        synchronized (this){
            while (true){
                System.out.println(Thread.currentThread().getName());
            }
        }
    }

    /**
     * synchronizedBlockObj1 和 synchronizedBlockObj1 方法是 两个方法分别锁不同的对象
     * 这样对两个对象分别加锁，实际上是互不影响的，可以分别执行，不会阻塞另一个线程
     *
     * @author dongyinggang
     * @date 2020/12/9 19:41
     */
    public void synchronizedBlockObj1(){
        // 修饰代码块
        synchronized (lock1){
            while (true){
                System.out.println(Thread.currentThread().getName());
            }
        }
    }

    public void synchronizedBlockObj2(){
        // 修饰代码块
        synchronized (lock2){
            while (true){
                System.out.println(Thread.currentThread().getName());
            }
        }
    }
}

```

### 4.1 同步实例方法

修饰实例方法时，锁的是对象实例，锁一个对象实例的时候可以达到锁的目的，但多个实例时会出现并发问题。看一下示例代码：

```java
/**
 * SynInstanceRunnable 类是 锁实例方法
 *
 * @author dongyinggang
 * @date 2020-12-09 18:17
 **/
public class SynInstanceRunnable implements Runnable {

    private SynObj synObj;

    public SynInstanceRunnable(SynObj synObj){
        this.synObj = synObj;
    }

    @Override
    public void run() {
        synObj.instanceMethod();
    }

    public static void main(String[] args) {

//        twoThreadOneInstance();
        twoThreadTwoInstance();
    }

    /**
     * twoThreadOneInstance 方法是 两个线程,一个对象,实例方法加锁
     * 可以看到此时的输出全是一个线程名称，没有输出第二个线程的名字。
     * 对普通方法加synchronized关键字，锁的是对象，如果两个线程都使用同一个对象来生成线程，
     * 那么就出现了第二个启动的线程始终在等待第一个线程结束的情况。
     * Spring中默认是单例模式的，因此方法的锁能够起到相应的作用
     *
     * @author dongyinggang
     * @date 2020/12/9 18:40
     */
    private static void twoThreadOneInstance()  {
        SynObj synObj = new SynObj();

        //两个线程同一个对象
        Thread thread1 = new Thread(new SynInstanceRunnable(synObj));
        Thread thread2 = new Thread(new SynInstanceRunnable(synObj));
        thread1.start();
        thread2.start();
    }

    /**
     * twoThreadTwoInstance 方法是 两个线程，两个对象，实例方法加锁
     * 两个线程交替输出，没有达到锁住方法的目的
     *
     * @author dongyinggang
     * @date 2020/12/9 18:50
     */
    private static void twoThreadTwoInstance() {
        SynObj synObj1 = new SynObj();
        SynObj synObj2 = new SynObj();

        //两个线程两个对象
        Thread thread1 = new Thread(new SynInstanceRunnable(synObj1));
        Thread thread2 = new Thread(new SynInstanceRunnable(synObj2));
        thread1.start();
        thread2.start();
    }
}
```

如果是锁的同一个对象，那执行顺序实际是串行的，以twoThreadOneInstance()的例子为例，由于调用的加锁方法实际是一个死循环，输出始终是第一个线程的名称，第二个线程名称并不会被输出。Spring管理的对象是单例模式的，因此方法的锁能够起到相应的作用。

![image-20201209194912385](图片/image-20201209194912385.png)

如果是两个线程，对应两个对象，就会出现锁不能达到预期目的的情况，示例代码为上面的twoThreadTwoInstance()方法,调用后的输出是两个线程名称交替的。

![image-20201209194842277](图片/image-20201209194842277.png)

### 4.2 同步静态方法

当使用synchronized修饰静态方法时，锁的是类，而非对象， 此时任何尽管我们写了让两个线程分别去获取一个对象实例进行方法调用，也始终是只有第一个线程在执行，第二个线程始终无法获取到锁来进行输出。

示例代码如下：

```java
package cn.dyg.keyword.syn;

/**
 * SynStaticRunnable 类是 锁静态方法
 *
 * @author dongyinggang
 * @date 2020-12-09 19:35
 **/
public class SynStaticRunnable implements Runnable {

    private SynObj synObj;

    public SynStaticRunnable(SynObj synObj){
        this.synObj = synObj;
    }

    @Override
    public void run() {
        //调用加锁的静态方法
        SynObj.staticMethod();
    }

    public static void main(String[] args) {
        twoThreadTwoInstance();
        //其他方法依然可以正常调用。
        doSomething();
    }

    /**
     * twoThreadTwoInstance 方法是 两个线程，两个对象，静态方法加锁
     * 虽然是两个对象，但是实际锁静态方法时锁的是类，因此先执行的线程会阻塞其他线程
     *
     * @author dongyinggang
     * @date 2020/12/9 18:50
     */
    private static void twoThreadTwoInstance() {
        SynObj synObj1 = new SynObj();
        SynObj synObj2 = new SynObj();

        //两个线程两个对象
        Thread thread1 = new Thread(new SynStaticRunnable(synObj1));
        Thread thread2 = new Thread(new SynStaticRunnable(synObj2));
        thread1.start();
        thread2.start();
    }

    private static void doSomething(){
        while(true){
            System.out.println("其他方法可以被调用");
        }
    }
}
```

但注意的是，尽管我们说这种情况下锁的是类，但要明确，该类的其他方法是可以被正常调用的。

![image-20201209200023484](图片/image-20201209200023484.png)

如果使用实例来调用静态方法,编译器会提示但运行不会报错。输出和上面的一致。我们每次都是起了两个线程，在我们没有指定名称的情况下，两个线程名称分别为Thread-0和Thread-1，每次输出的名称只有一个，但并不是固定的，哪个资源先获取到了锁，就会死死抱住不放开。

### 4.3 同步一个代码块

锁代码块的情况相对要复杂一点点，这里主要看四种情况：

1. 两个线程，一个对象，代码块加锁，锁 this 对象
2. 两个线程，两个对象，代码块加锁，锁 this 对象
3. 两个线程，一个对象，两个方法分别锁 this 对象

4. 两个线程，一个对象的两个实例方法，锁了不同的Object

首先，这次实现Runnable接口的对象如下：

```java
public class SynBlockRunnable implements Runnable {

    private SynObj synObj;

    public SynBlockRunnable(SynObj synObj){
        this.synObj = synObj;
    }

    @Override
    public void run() {
        synObj.synchronizedBlock();
    }
}
```

#### 4.3.1 两个线程，一个对象，代码块加锁，锁 this 对象

这种情况下，和 4.1 中修饰实例方法是一样的，两个线程实际是在争夺对象 synObj 的资源，哪个线程竞争到了,就可以进入死循环,不断输出自己的线程名，另一个线程由于始终不能够获取到锁，因此一直被阻塞，无法输出任何内容。

```java
/**
 * twoThreadOneInstance 方法是 两个线程,一个对象,代码块加锁,锁 this 对象
 * 这种方式和锁实例方法是一样的,两个线程实际是在争夺对象 synObj 的资源,
 * 哪个线程竞争到了,就可以进入死循环,不断输出自己的线程名
 *
 * @author dongyinggang
 * @date 2020/12/9 20:23
 */
private static void twoThreadOneInstance() {
    SynObj synObj = new SynObj();

    //两个线程
    Thread thread1 = new Thread(new SynBlockRunnable(synObj));
    Thread thread2 = new Thread(new SynBlockRunnable(synObj));
    thread1.start();
    thread2.start();
}
```

#### 4.3.2 两个线程，两个对象，代码块加锁，锁 this 对象

这种方式和锁实例方法是一样的,锁 this 锁得是一个实例,因此,当我们两个线程传入的是不同对象的情况下,两个线程实际是都获得了自己对象的资源，都能够进行自己名字的输出。对应的控制台输出就是交替的。

```java
	 /**
     * twoThreadTwoInstance 方法是 两个线程，两个对象，代码块加锁,锁 this 对象
     * 这种方式和锁实例方法是一样的,锁 this 锁得是一个实例,
     * 因此,当我们两个线程传入的是不同对象的情况下,
     * 两个线程实际是都获得了自己对象的资源，都能够进行自己名字的输出
     *
     * @author dongyinggang
     * @date 2020/12/9 18:50
     */
    private static void twoThreadTwoInstance() {
        SynObj synObj1 = new SynObj();
        SynObj synObj2 = new SynObj();

        //两个线程两个对象
        Thread thread1 = new Thread(new SynBlockRunnable(synObj1));
        Thread thread2 = new Thread(new SynBlockRunnable(synObj2));
        thread1.start();
        thread2.start();
    }
```

#### 4.3.3 两个线程，一个对象，两个方法分别锁了this

尽管两个线程分别调用了一个对象的不同方法，但由于锁的资源是一样的，因此只要有一方获得了资源，那么另一方就失去了执行对应方法的先决条件，就会陷入阻塞，不能够执行。

```java
/**
 * twoThreadSynThis 方法是 两个线程，一个对象，两个方法分别锁了this
 * 两个线程看似调用了 SynObj 的两个不同实例方法,实例方法中都存在锁,并且都锁了this
 * 两个线程实际都在竞争实例的资源,谁竞争到了,就一直执行,另一个虽然是调用了不同方法,
 * 但由于始终获取不到锁,所以就无法执行
 * 如果这里是两个对象了，虽然都锁了this，但实际此this非彼this，两者会互不影响
 *
 * @author dongyinggang
 * @date 2020/12/9 20:29
 */
private static void twoThreadSynThis() {
    SynObj synObj = new SynObj();

    //两个线程个对象
    Thread thread1 = new Thread(new SynBlockRunnable(synObj));
    Thread thread2 = new Thread(()->synObj.synchronizedBlockThis());
    thread1.start();
    thread2.start();
}
```

#### 4.3.4 两个线程,一个对象的两个实例方法,锁了不同的Object

两个线程，分别调用一个对象的不同方法，两个方法分别锁了对象 lock1 和 lock2，两人执行的先决条件不同且可以同时满足，因此互不影响，交替执行。

```java
/**
 * twoThreadSynTwoObj 方法是 两个线程,一个对象的两个实例方法,锁了不同的Object
 * 此时,由于两个方法分别锁了lock1 和 lock2 ,是互不干扰的,因此可以同时被调用
 *
 * @author dongyinggang
 * @date 2020/12/9 20:36
 */
private static void twoThreadSynTwoObj(){
    SynObj synObj = new SynObj();
    Thread thread1 = new Thread(()->synObj.synchronizedBlockObj1());
    Thread thread2 = new Thread(()->synObj.synchronizedBlockObj2());
    thread1.start();
    thread2.start();
}
```

### 4.4 同步一个类

当 synchronized 锁代码块的时候，除了直接锁对象的形式外，还可以锁类时，形如 synchronized(Object.class), 这样的锁和修饰静态方法比较像，作用于整个类。

也就是说两个线程调用同一个类的不同对象上的这种同步语句，也会进行同步。因为只能有一个线程持有这个类的资源。

示例代码如下：

```java
/**
 * SynClass 类是 锁一个类
 *
 * @author dongyinggang
 * @date 2021-02-22 09:01
 **/
public class SynClass {

    /**
     * synClass 方法是 使用synchronized同步一个类
     * 作用于整个类，也就是说两个线程调用同一个类的不同对象上的这种同步语句，也会进行同步。
     * 某个线程竞争到类锁后，其他线程就不能执行了，必须等待目标线程释放
     *
     * @author dongyinggang
     * @date 2021/2/22 9:54
     */
    private void synClass() {
        synchronized (SynClass.class) {
            for (int i = 0; i < 5; i++) {
                System.out.println(Thread.currentThread().getName() + " synClass 运行中");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println(Thread.currentThread().getName() + "当前线程执行完毕");
        }
    }

    public static void main(String[] args) {
        SynClass synClass1 = new SynClass();
        SynClass synClass2 = new SynClass();
        //创建一个线程池
        ExecutorService executorService = ThreadUtil.buildThreadExecutor(2);
        //始终是一个线程在执行,sleep时不释放锁,所以始终是一个线程在执行
        executorService.execute(synClass1::synClass);
        executorService.execute(synClass2::synClass);
        //执行完毕后,终止线程池,如果不执行,则进程不会结束
        executorService.shutdown();
        System.out.println("主线程执行完毕");
    }

}
```

执行结果如下：

![image-20210222104238171](图片/image-20210222104238171.png)

1. 声明两个SynClass对象，分别是 synClass1 和 synClass2 。

2. 通过线程池创建两个线程，分别是 test-t1 和 test-t2 ，分别调用第1步中声名的 synClass1 和 synClass2 的 synClass() 方法
3. 由于通过 synchronized 对 SynClass.class 进行加锁，锁了类，因此只有当首先获取到 SynClass 类资源的线程执行完毕后，另一个线程才能够获取到  SynClass 类资源进行执行。
4. 执行完毕后，关闭线程池，进程结束。

## 参考内容

【1】[synchronized到底锁住的是谁？](https://www.cnblogs.com/yulinfeng/p/11020576.html)

【2】三歪整理的多线程知识

【3】[Java 并发](https://github.com/CyC2018/CS-Notes/blob/master/notes/Java%20%E5%B9%B6%E5%8F%91.md#synchronized)

【4】[深入理解synchronized底层原理，一篇文章就够了！](https://cloud.tencent.com/developer/article/1465413)

【5】[深入分析Synchronized原理](https://www.cnblogs.com/1013wang/p/11806019.html)

【6】[通过一个故事理解可重入锁的机制](https://www.cnblogs.com/gxyandwmm/p/9387833.html)