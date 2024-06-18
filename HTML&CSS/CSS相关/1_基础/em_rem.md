# em and rem

em
    - em是相对于元素的字体大小(font-size)来计算的
    - 1em = 1font-size
    - em会根据字体大小的改变而改变

rem
    - rem是相对于根元素的字体大小(font-size)来计算

```css
em例子
.box3{
    font-size: 50px;
    width: 10em;
    height: 10em;
    background-color: greenyellow;
}
高度和宽度就为100px
```

```css
rem例子
html{
    font-size: 30px;
}

.box3{
    font-size: 50px;
    width: 10rem;
    height: 10rem;
    background-color: greenyellow;
}
高度和宽度就为100px
```