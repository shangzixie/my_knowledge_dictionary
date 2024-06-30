# defer

## basic logic

![2](../Image/golang/2.png)

the result:

![3](../Image/golang/3.png)

defer statements delay the execution of the function or method or an anonymous method until the function it belonging returns.

More details. There is a `defer stack`, when execute the defer function, it will append the function into stack. after finish all code, it will pop the stack and execute them.

## defer使用时的坑

先来看看几个例子。例1：

```golang
func f() (result int) {
    defer func() {
        result++
    }()
    return 0
}
```

例2：

```golang

func f() (r int) {
     t := 5
     defer func() {
       t = t + 5
     }()
     return t
}
```

例3：

```golang
func f() (r int) {
    defer func(r int) {
          r = r + 5
    }(r)
    return 1
}
```

例1的正确答案不是0，例2的正确答案不是10，如果例3的正确答案不是6......

defer是在return之前执行的。这个在 官方文档中是明确说明了的。要使用defer时不踩坑，最重要的一点就是要明白，return xxx这一条语句并不是一条原子指令!

**函数返回的过程是这样的：先给返回值赋值，然后调用defer表达式，最后才是返回到调用函数中。**

defer表达式可能会在设置函数返回值之后，在返回到调用函数之前，修改返回值，使最终的函数返回值与你想象的不一致。

其实使用defer时，用一个简单的转换规则改写一下，就不会迷糊了。改写规则是将return语句拆成两句写，return xxx会被改写成:

返回值 = xxx
调用defer函数
空的return

先看例1，它可以改写成这样：

```golang
func f() (result int) {
     result = 0  //return语句不是一条原子调用，return xxx其实是赋值＋ret指令
     func() { //defer被插入到return之前执行，也就是赋返回值和ret指令之间
         result++
     }()
     return
}
```

所以这个返回值是1。

再看例2，它可以改写成这样：

```golang
func f() (r int) {
     t := 5
     r = t //赋值指令
     func() {        //defer被插入到赋值与返回之间执行，这个例子中返回值r没被修改过
         t = t + 5
     }
     return        //空的return指令
}
```

所以这个的结果是5。

最后看例3，它改写后变成：

```golang
func f() (r int) {
     r = 1  //给返回值赋值
     func(r int) {        //这里改的r是传值传进去的r，不会改变要返回的那个r值
          r = r + 5
     }(r)
     return        //空的return
}
```

所以这个例子的结果是1。

defer确实是在return之前调用的。但表现形式上却可能不像。本质原因是return xxx语句并不是一条原子指令，defer被插入到了赋值 与 ret之间，因此可能有机会改变最终的返回值。

## reference

[link](https://tiancaiamao.gitbooks.io/go-internals/content/zh/03.4.html)
