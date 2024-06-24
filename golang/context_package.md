# context

## Introduction

作用: 取消信号的传递, 超时控制, 请求范围的数据传递, 并行任务的协调

## 取消信号的传递

确保在任务取消时所有相关的 goroutine 都能及时退出。

```golang
package main

import (
    "context"
    "fmt"
    "time"
)

// worker 模拟一个需要长时间运行的任务
func worker(ctx context.Context, id int) {
    for {
        select {
        case <-ctx.Done():
            fmt.Printf("Worker %d: received cancel signal, exiting\n", id)
            return
        default:
            // 模拟任务处理
            fmt.Printf("Worker %d: processing...\n", id)
            time.Sleep(500 * time.Millisecond)
        }
    }
}

func main() {
    // 创建一个带有取消功能的上下文
    ctx, cancel := context.WithCancel(context.Background())

    // 启动多个 worker goroutine
    for i := 1; i <= 3; i++ {
        go worker(ctx, i)
    }

    // 模拟一些其他工作，主 goroutine 运行 2 秒后取消所有 worker
    time.Sleep(2 * time.Second)
    fmt.Println("Main: cancelling context")
    cancel()

    // 给 goroutines 一些时间打印它们的退出消息
    time.Sleep(1 * time.Second)
}

```

## 超时控制

多个 Goroutine 同时订阅 ctx.Done() 管道中的消息，一旦接收到取消信号就立刻停止当前正在执行的工作。
在 Goroutine 构成的树形结构中对信号进行同步以减少计算资源的浪费是 context.Context 的最大作用. 每一个 context.Context 都会从最顶层的 Goroutine 一层一层传递到最下层。context.Context 可以在上层 Goroutine 执行出现错误时，将信号及时同步给下层。

```golang
func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
    defer cancel()

    go handle(ctx, 500*time.Millisecond)
    select {
        case <-ctx.Done():
            fmt.Println("main", ctx.Err())
    }
}

func handle(ctx context.Context, duration time.Duration) {
    select {
        case <-ctx.Done():
            fmt.Println("handle", ctx.Err())
        case <-time.After(duration):
            fmt.Println("process request with", duration)
    }
}
```

`handle`函数里面 `time.after`函数会500ms后触发, 然后`handle`函数就结束了. 所以此时会打印 `process request with 500ms`. 但是`main`函数一直在监听ctx, ctx在1s后会自动call `ctx.done()`, 所以会打印 `main context deadline exceeded`.


## 防止 Goroutine 泄露

通过在每个 goroutine 中监听 `ctx.Done()` 通道，我们可以确保在上下文超时或取消时，所有 goroutine 都能及时退出，释放资源。

```golang
package main

import (
    "context"
    "fmt"
    "time"
)

// worker 模拟一个需要长时间运行的任务
func worker(ctx context.Context, id int) {
    for {
        select {
        case <-ctx.Done():
            fmt.Printf("Worker %d: received cancel signal, exiting\n", id)
            return
        default:
            // 模拟任务处理
            fmt.Printf("Worker %d: processing...\n", id)
            time.Sleep(500 * time.Millisecond)
        }
    }
}

func main() {
    // 创建一个带有 3 秒超时的上下文
    ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
    defer cancel()

    // 启动多个 worker goroutine
    for i := 1; i <= 5; i++ {
        go worker(ctx, i)
    }

    // 等待上下文超时
    <-ctx.Done()
    fmt.Println("Main: context expired, all workers should be cancelled")

    // 给 goroutines 一些时间打印它们的退出消息
    time.Sleep(1 * time.Second)
}
```

## reference

[link](https://www.digitalocean.com/community/tutorials/how-to-use-contexts-in-go)
[link](https://www.topgoer.com/%E5%B8%B8%E7%94%A8%E6%A0%87%E5%87%86%E5%BA%93/Context.html)
[link](https://go.cyub.vip/concurrency/context/)