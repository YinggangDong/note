# synchronized锁

[toc]

## synchronized锁是什么？

synchronized是Java的一个**关键字**，它能够将**代码块(方法)锁起来**

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

## synchronized用处是什么？

•       synchronized保证了线程的**原子性**。(被保护的代码块是一次被执行的，没有任何线程会同时访问)

•       synchronized还保证了**可见性**。(当执行完synchronized之后，修改后的变量对其他的线程是可见的)

Java中的synchronized，通过使用内置锁，来实现对变量的同步操作，进而实现了**对变量操作的原子性和其他线程对变量的可见性**，从而确保了并发情况下的线程安全。

## synchronized的原理