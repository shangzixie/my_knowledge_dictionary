# timer and ticker

* ticker定时器表示每隔一段时间就执行一次，一般可执行多次。
* timer定时器表示在一段时间后执行，默认情况下只执行一次，如果想再次执行的话，每次都需要调用 time.Reset() 方法，此时效果类似ticker定时器。同时也可以调用 Stop() 方法取消定时器
* timer定时器比ticker定时器多一个 Reset() 方法，两者都有 Stop() 方法，表示停止定时器,底层都调用了stopTimer() 函数。
