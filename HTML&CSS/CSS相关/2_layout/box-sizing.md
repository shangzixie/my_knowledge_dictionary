# box-sizing

[video](https://www.youtube.com/watch?v=ns9Mv5JWYVQ&list=PLmOn9nNkQxJFs5KfK5ihVgb8nNccfkgxn&index=58)

```
可见框的大小 = 内容区content + 内边距padding + 边框border

box-sizing 用来设置盒子尺寸的计算方式（设置width和height的作用）
可选值：
    content-box 默认值，width和height用来设置内容区的大小
    border-box 宽度和高度用来设置整个盒子可见框的大小
        width 和 height 指的是内容区 和 内边距 和 边框的总大小
```

例如:

```css
.box1{
    width: 100px;
    height: 100px;
    background-color: #bfa;
    padding: 10px;
    border: 10px red solid;
```

1. 如果设置`box-sizing: content-box`则, 内容区高宽`100px`, 加上`padding`和`border`, 宽高`10 + 10 + 100 + 10 + 10 = 140px`.
2. 如果设置`box-sizing: border-box`则该盒子总共`100px`, `100 = 10 + 10 + content + 10 + 10`, 所以内容区宽高`60px`