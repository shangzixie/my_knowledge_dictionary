# 深入 React hooks — useEffect

```typescript
  useEffect(() => {
    // 第一次render后, 以及每次state变化后都会调用
    // 相当于 componentDidMount and componentDidUpdate:
    console.log('@');
  }); // 全都检测

  useEffect(() => {
    // 第一次render后会调用
    // 相当于 componentDidMount
    console.log('@');
  }, []); // 谁也不检测

    useEffect(() => {
    // 第一次render后以及每次count变化后会调用
    // 相当于 componentDidMount 和 componentDidUpdate
    console.log('@');
  }, [count]); // 检测count

    useEffect(() => {
    // 第一次render后会被调用
    // 相当于 componentDidMount
    const timer = setInterval();
    // 函数被卸载前被调用, 相当于componentWillUnmount()
    return () => {clearInterval(timer)}
  }, []); // 检测count
```

## reference

[video](https://www.youtube.com/watch?v=_9D-t6EE7vs&list=PLmOn9nNkQxJFJXLvkNsGsoCUxJLqyLGxu&index=119)

[深入 React hooks — useEffect](https://zhuanlan.zhihu.com/p/85192975)

[useEffect 完整指南](https://overreacted.io/zh-hans/a-complete-guide-to-useeffect/)