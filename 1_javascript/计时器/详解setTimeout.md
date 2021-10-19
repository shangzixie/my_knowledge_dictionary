# setTimeout 详解

first, need to know, [what does setTimeout(..., 0) do](https://stackoverflow.com/questions/779379/why-is-settimeoutfn-0-sometimes-useful). 从这篇文章了解到，`setTimeout(callback, 0)`，会将`callback`函数放到`event queue`内，待到当前的event都处理完才轮到执行这个callback. So using `setTimeout(..., 0)` will basically make your code run after the current event loop tick.

second, watch the [video](https://www.youtube.com/watch?v=8aGhZQkoFbQ&t=3s) to learn more about event loop in js.


## reference

[link](https://segmentfault.com/a/1190000002633108)
