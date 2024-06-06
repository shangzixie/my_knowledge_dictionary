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
