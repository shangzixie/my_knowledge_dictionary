# Promise Error Handling

![51](../Image/javascript/51.png)
![52](../Image/javascript/52.png)
![53](../Image/javascript/53.png)

上图`53`产生结果为
```
caugh by .catch Error: Unauthorized access to the user data
```

## if try catch in promise

![54](../Image/javascript/54.png)

Summary:

* promise error couldn't catch by `try-catch`
* Inside the promise, the `promise.catch()` method will catch the error caused by the `throw` statement and `reject()`.
* If an error occurs and you don’t have the `promise.catch()` method, the JavaScript engine issues a runtime error and stops the program.
* `try-catch` will catch error inside a promise, and not delegated it out the promise. `try-catch`并不会把错误再往上传递出去


## reference

[blog](https://www.javascripttutorial.net/es6/promise-error-handling/)