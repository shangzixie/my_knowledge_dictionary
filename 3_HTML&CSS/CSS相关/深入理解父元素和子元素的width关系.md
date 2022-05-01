# [【深入理解父元素与子元素的width关系】](https://www.cnblogs.com/zhuzhenwei918/p/6389567.html)

[toc]

## 父元素与子元素均为内联元素时

```html
<!DOCTYPE html>
<html>
<head>
    <title>fortest</title>
    <style>
        /*第一种情况：父元素与子元素均为内联元素时*/
        span{
            width:200px; /*失效，因为内联元素不可设置width和height*/
        }
        a{
            width: 100%; /*失效，内联元素设置100%也是毫无意义的*/
        }
    </style>
</head>
<body>
    <span><a href="">父子元素width关系</a></span>
</body>
</html>
```

![4](../../Image/CSS/4.png)

## 父子元素都是块级元素

```html
<!DOCTYPE html>
<html>
<head>
    <title>fortest</title>
    <style>
        div.parent{
            width: 500px;
            height: 300px;
            background: #ccc;
        }
        div.son{
            width: 100%;
            height: 200px;
            background: green;
        }
    </style>
</head>
<body>
    <div class="parent">
        <div class="son"></div>
    </div>
</body>
</html>
```

![5](../../Image/CSS/5.png)

这时，子元素设置为了父元素width的100%，那么子元素的宽度也是500px；
但是如果我们把子元素的width去掉之后，就会发现子元素还是等于父元素的width。也就是说，对于块级元素，子元素的宽度默认为父元素的100%。

补充：当我们给子元素添加padding和margin时，可以发现宽度width是父元素的宽度减去子元素的margin值和padding值，下面的例子亦是如此.
毫无疑问，如果去掉子元素的height，就会发现子元素的高度为0，故height是不会为100%的，一般我们都是通过添加内容（子元素）将父元素撑起来。

## 父元素是块级元素、子元素是内联元素

### 内联元素是一般的类型（img、input除外）

这种情况下，同样子元素是没有办法设置宽度的，也就谈不上100%的问题了。 即内联元素必须依靠其内部的内容才能撑开。

### 内联元素是input和img这样的可以设置width和height的类型

首先应当明白：为什么img是内联元素还可以设置它的宽和高呢？因为除了我们常常理解的块级元素和内联元素的分类方法，还有一种替换元素和不可替换元素的分类方法，可以将之分为**替换元素**和**不可替换元素**

* 替换元素：替换元素就是浏览器根据元素的标签和属性，来决定元素的具体显示内容的元素
例如浏览器会根据`<img>`标签的src属性的值来读取图片信息并显示出来，而如果查看(X)HTML代码，则看不到图片的实际内容
又例如根据`<input>`标签的type属性来决定是显示输入框，还是单选按钮等。(X)HTML中的`<img>、<input>、<textarea>、<select>、<object>`都是替换元素。这些元素往往没有实际的内容，即是一个空元素，例如：`<img src=”cat.jpg” />  <input type="submit" name="Submit" value="提交" />`  浏览器会根据元素的标签类型和属性来显示这些元素。可替换元素也在其显示中生成了框

* 不可替换元素: (X)HTML的大多数元素是不可替换元素，即其内容直接表现给用户端（例如浏览器）

当时img这种元素时，不管我们怎么设置父元素的宽度和高度，而不设置img的宽和高时，img总是表现为其原始的宽和高。

而如果我们只设置了其高度，不设置宽度看看其表现时怎么样的吧，如下所示（原始图片的大小为1920X1080的图片）：

```html
<!DOCTYPE html>
<html>
<head>
    <title>fortest</title>
    <style>
        div.parent{
            width: 500px;
            height: 300px;
            background: #ccc;
        }
        img{
            height: 100px;
            background: green;
        }
    </style>
</head>
<body>
    <div class="parent">
        <img class="son" src="http://img2.3lian.com/2014/c7/12/d/77.jpg"></img>
    </div>
</body>
</html>
```

![6](../../Image/CSS/6.png)

由此我们可以发现，虽然没有设置宽度，但是表现在浏览器上为160px，它并没有继承父元素的100%得到500px，而是根据既定的高度来等比例缩小宽度。  同样， 如果只设置width，那么height也会等比例改变

如果我们把img的width设置为100%，就可以发现其宽度这时就和父元素的宽度一致了，如下所示：

![7](../../Image/CSS/7.png)

而我们一般的做法时，首先确定img的父元素的宽度和高度，然后再将img的宽度和高度设置位100%，这样，图片就能铺满父元素了。