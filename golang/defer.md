# defer

## basic logic

![2](../Image/golang/2.png)

the result:

![3](../Image/golang/3.png)

defer statements delay the execution of the function or method or an anonymous method until the function it belonging returns.

More details. There is a `defer stack`, when execute the defer function, it will append the function into stack. after finish all code, it will pop the stack and execute them.
