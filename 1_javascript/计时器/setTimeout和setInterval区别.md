# setTimeout 与 setInterval

setTimeout 表示间隔一段时间之后执行一次调用，而 setInterval 则是每间隔一段时间循环调用，直至 clearInterval 结束。

内存方面，setTimeout 只需要进入一次队列，不会造成内存溢出，setInterval 因为不计算代码时间，有可能通知执行多次代码，导致内存溢出。
