# lock in golang

`sync.Mutex`、`sync.RWMutex`

## sync.Mutex

互斥锁, 它能够保证同时只有一个goroutine可以访问共享资源


源码:

```golang
type Mutex struct {
 state int32
 sema  uint32
}
```

state是一个int32类型, 用来表示锁的状态:

从低位开始, 每一位都有特定的含义:

![78](/Image/golang/78.png)

* 第1位: mutexLocked — 表示互斥锁的锁定状态；
* 第2位: mutexWoken — 表示从正常模式被从唤醒；
* 第3位: mutexStarving — 当前的互斥锁进入饥饿状态；
* 第3位后: waitersCount — 当前互斥锁上等待的 Goroutine 个数；

* state & 1：检查锁是否被锁定。
* state & 2：检查是否有 goroutine 被唤醒。
* state & 4：检查是否处于饥饿模式。
* state >> 3：获取等待的 goroutine 数量。

## 正常模式和饥饿模式

在刚开始的时候，是处于正常模式（Barging），也就是，当一个G1持有着一个锁的时候，G2会自旋的去尝试获取这个锁
当自旋超过4次还没有能获取到锁的时候，这个G2就会被加入到获取锁的等待队列里面，并阻塞等待唤醒. 正常模式下，所有等待锁的 goroutine 按照 FIFO(先进先出)顺序等待。唤醒的goroutine(G2)不会直接拥有锁，而是会和新请求锁的 goroutine (G3) 竞争锁。新请求锁的 goroutine(G3) 具有优势：它正在 CPU 上执行，而且可能有好几个，所以刚刚唤醒的 goroutine(G2) 有很大可能在锁竞争中失败，长时间获取不到锁，就会切换到饥饿模式. 在饥饿模式下，锁的所有权会直接移交给等待队列中的下一个 goroutine（G2），而不是让新请求的 goroutine（G3）参与竞争。这保证了等待队列中的 goroutine 最终能够获取到锁，防止长时间的饥饿。


## reference

[link](https://draveness.me/golang/docs/part3-runtime/ch06-concurrency/golang-sync-primitives/)