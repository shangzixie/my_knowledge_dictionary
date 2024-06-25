# channel

Channel是类型安全的，可以确保发送和接收的数据类型一致。
Channel是阻塞的，当发送或接收操作没有被满足时，会阻塞当前goroutine，直到满足条件。
Channel是有缓存的，可以指定缓存区大小，当缓存区已满时发送操作会被阻塞，当缓存区为空时接收操作会被阻塞。

## 各种状态

| 操作               | 空 channel                  | 已关闭 channel       | 活跃 channel         |
|--------------------|-----------------------------|----------------------|----------------------|
| `close(ch)`        | 成功关闭或 panic            | panic                | 成功关闭              |
| `ch <- v`          | 永远阻塞                    | panic                | 成功发送或阻塞        |
| `v, ok = <-ch`     | 永远阻塞                    | 不阻塞               | 成功接收或阻塞        |


### 1. 空 channel

**定义**：一个刚创建的 channel，尚未进行任何发送或接收操作，且未关闭。

**行为**：

- `close(ch)`: 调用 `close` 函数关闭一个空 channel 是合法的操作，但是如果`var ch = chan int`声明一个nil channel，调用`close(ch)`会导致panic。
- `ch <- v`: 尝试向空 channel 发送数据时会阻塞，直到有接收方准备好。
- `v, ok = <-ch`: 尝试从空 channel 接收数据时会阻塞，直到有发送方发送数据。

### 2. 已关闭 channel

**定义**：一个已经通过 `close` 函数关闭的 channel。

**行为**：

- `close(ch)`: 再次关闭已关闭的 channel 会导致 panic。
- `ch <- v`: 尝试向已关闭的 channel 发送数据会导致 panic。
- `v, ok = <-ch`: 尝试从已关闭的 channel 接收数据不会阻塞。它会返回 channel 类型的零值，并且 `ok` 为 `false`。

### 3. 活跃 channel

**定义**：一个正在使用的 channel，即可以进行数据的发送和接收，并且未关闭。

**行为**：

- `close(ch)`: 调用 `close` 函数关闭活跃的 channel 是合法操作。
- `ch <- v`: 尝试向活跃的 channel 发送数据，如果缓冲区满则会阻塞，直到有接收方接收数据。
- `v, ok = <-ch`: 尝试从活跃的 channel 接收数据，如果没有数据则会阻塞，直到有发送方发送数据。

## 源码

```golang

type hchan struct {
    //channel分为无缓冲和有缓冲两种。
    //对于有缓冲的channel存储数据，借助的是如下循环数组的结构
    qcount   uint           // 循环数组中的元素数量
    dataqsiz uint           // 循环数组的长度
    buf      unsafe.Pointer // 指向底层循环数组的指针
    elemsize uint16 //能够收发元素的大小

    closed   uint32   //channel是否关闭的标志
    elemtype *_type //channel中的元素类型

    //有缓冲channel内的缓冲数组会被作为一个“环型”来使用。
    //当下标超过数组容量后会回到第一个位置，所以需要有两个字段记录当前读和写的下标位置
    sendx    uint   // 下一次发送数据的下标位置
    recvx    uint   // 下一次读取数据的下标位置

    //当循环数组中没有数据时，收到了接收请求，那么接收数据的变量地址将会写入读等待队列
    //当循环数组中数据已满时，收到了发送请求，那么发送数据的变量地址将写入写等待队列
    recvq    waitq  // 读等待队列
    sendq    waitq  // 写等待队列

    lock mutex //互斥锁，保证读写channel时不存在并发竞争问题
}
```

Channel底层的同步机制是基于等待队列和信号量实现的。每个Channel都维护着一个等待队列，其中包含了所有等待操作的goroutine；同时还维护着一个计数器，用于记录当前缓存区中的元素数量。当发送操作需要等待时，会将当前goroutine添加到等待队列中，并使计数器减一；当接收操作需要等待时，会将当前goroutine添加到等待队列中，并使计数器加一。当有其他操作满足条件时，会从等待队列中取出相应的goroutine，并将其重新加入到可执行队列中，等待调度器的调度。

## 读写操作

向 channel 写数据:

若等待接收队列 recvq 不为空，则缓冲区中无数据或无缓冲区，将直接从 recvq 取出 G ，并把数据写入，最后把该 G 唤醒，结束发送过程。
若缓冲区中有空余位置，则将数据写入缓冲区，结束发送过程。
若缓冲区中没有空余位置，则将发送数据写入 G，将当前 G 加入 sendq ，进入睡眠，等待被读 goroutine 唤醒。

从 channel 读数据:

若等待发送队列 sendq 不为空，且没有缓冲区，直接从 sendq 中取出 G ，把 G 中数据读出，最后把 G 唤醒，结束读取过程。
如果等待发送队列 sendq 不为空，说明缓冲区已满，从缓冲区中首部读出数据，把 G 中数据写入缓冲区尾部，把 G 唤醒，结束读取过程。
如果缓冲区中有数据，则从缓冲区取出数据，结束读取过程。
将当前 goroutine 加入 recvq ，进入睡眠，等待被写 goroutine 唤醒。

关闭 channel:

关闭 channel 时会将 recvq 中的 G 全部唤醒，本该写入 G 的数据位置为 nil。将 sendq 中的 G 全部唤醒，但是这些 G 会 panic。

## 如何避免在Channel中出现死锁的情况

1. 避免在单个goroutine中对Channel进行读写操作：如果一个goroutine同时进行Channel的读写操作，很容易出现死锁的情况，因为该goroutine无法切换到其他任务，导致无法释放Channel的读写锁。因此，在进行Channel的读写操作时，应该尽量将它们分配到不同的goroutine中，以便能够及时切换任务。
2. 使用缓冲Channel：缓冲Channel可以在一定程度上缓解读写操作的同步问题，避免因为Channel状态不满足条件而导致的死锁问题。如果Channel是非缓冲的，那么写操作必须等到读操作执行之后才能完成，反之亦然，这种同步会导致程序无法继续执行。而如果使用缓冲Channel，就可以避免这种同步问题，即使读写操作之间存在时间差，也不会导致死锁。
3. 使用select语句：select语句可以在多个Channel之间进行选择操作，避免因为某个Channel状态不满足条件而导致的死锁问题。在使用select语句时，应该注意判断每个Channel的状态，避免出现同时等待多个Channel的情况，这可能导致死锁。
4. 使用超时机制：在进行Channel的读写操作时，可以设置一个超时时间，避免因为Channel状态不满足条件而一直等待的情况。如果超过一定时间仍然无法读写Channel，就可以选择放弃或者进行其他操作，以避免死锁。

## reference

[link](https://developer.aliyun.com/article/1213336)
