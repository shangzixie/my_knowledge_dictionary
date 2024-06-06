# golang scheduler

## background

1. cpu上下文切换不同线程需要成本， 上下文切换时候， cpu也没充分利用起来
2. 多线程随着同步竞争， 如锁等， 开发设计会越来越复杂
3. 每个任务负责一个线程， 会导致线程数目过多， 但是线程数目过多会导致cpu上下文切换成本过高， 而且内存占用也高： 一个进程会分配4G的虚拟内存，虽然这些内存并不会实际被占用； 一个线程占用4M内存；

## solution

### M:N模型

所以用到了以下模型：

![54](/Image/golang/54.png)

所以， go把这种协程叫做goroutine, 并每个goroutine内存只占用几kb：

![8](/Image/golang/55.png)

## 早期版本

早期goroutine的M:N模型： 定义G为goroutine, M为thread线程

全局有个队列， 每次thread去执行一个goroutine时候， 就给队列加把锁， 然后从队列里面取一个goroutine执行， 执行完毕后， 再给队列加把锁， 然后从队列里面取一个goroutine执行， 以此类推
![9](/Image/golang/56.png)

这种缺点是：

![10](/Image/golang/57.png)

总结：

![11](/Image/golang/58.png)

### GMP模型

所以引入了GMP模型a

![12](/Image/golang/59.png)
![13](/Image/golang/60.png)
![14](/Image/golang/61.png)

### 该模型具有几个特点

![15](/Image/golang/62.png)

如果一个goroutine阻塞， 那么就新创建一个thread去拿阻塞队列里面的任务执行， 这里面是拿`G2`去执行：
![17](/Image/golang/64.png)
![18](/Image/golang/65.png)


如果其他线程没有goroutine执行， 那么就从全局queue里面拿：
![16](/Image/golang/63.png)

### 具体流程参考

[视频](https://www.bilibili.com/video/BV19r4y1w7Nx?p=5&vd_source=876f070b226adc2dd07033543abb6c67)

![19](/Image/golang/66.png)

## 为什么goroutine高效

goroutine切换线程不需要进入到内核中切换, 传统的操作系统线程调度器是在内核中运行的, 切换线程步骤:

1. 当前线程（A）执行中：

线程A正在用户态运行。

2. 进入内核态：

由于某种原因（如时间片用完、中断、系统调用等），线程A需要被暂停。操作系统会触发上下文切换过程，CPU切换到内核态。将

3. 保存当前线程（A）的上下文：

在内核态，操作系统保存线程A的上下文信息。这包括：

* 程序计数器（PC）：指示当前正在执行的指令地址。
* 栈指针（SP）：指示当前栈的顶端。
* 通用寄存器：CPU中的所有通用寄存器的值。
* 其他处理器状态：如标志寄存器、段寄存器等。
这些信息通常被保存到内核中的线程控制块（TCB）或进程控制块（PCB）中。

4. 选择下一个线程（B）：

操作系统调度器选择下一个要运行的线程（B）。这个选择可以基于多种策略，如优先级、时间片轮转等。
读取并恢复线程（B）的上下文：

操作系统读取线程B的上下文信息，并将其加载到CPU的寄存器中。这包括程序计数器、栈指针和其他寄存器的值。

5. 切换到用户态并执行线程（B）：

最后，操作系统切换到用户态，开始执行线程B。CPU开始从线程B的程序计数器指向的位置继续执行。

**Goroutine上下文切换过程**

1. 当前Goroutine（G1）执行中：

Goroutine G1正在用户态运行。

2. 决定切换：

由于某种原因（如G1主动让出CPU，例如通过I/O操作、channel操作、time.Sleep等，或者被抢占），Go运行时的调度器决定需要切换Goroutine。
保存当前Goroutine（G1）的上下文：

在用户态，Go运行时保存Goroutine G1的上下文信息。这包括：

* 程序计数器（PC）：指示当前正在执行的指令地址。
* 栈指针（SP）：指示当前栈的顶端。
* 通用寄存器：少量寄存器的值。
* 这些信息存储在Go运行时的内部数据结构中，而不是复制到内核。

3. 选择下一个Goroutine（G2）：

Go调度器选择下一个要运行的Goroutine（G2）。这个选择可以基于多种策略，如优先级、时间片轮转等。

4. 恢复Goroutine（G2）的上下文：

Go运行时从内部数据结构中读取Goroutine G2的上下文信息，并将其加载到CPU的寄存器中。这包括程序计数器、栈指针和其他必要的寄存器。

5. 继续执行Goroutine（G2）：

CPU从Goroutine G2的程序计数器指向的位置继续执行。
