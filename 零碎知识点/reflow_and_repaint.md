# reflow and repaint 重排和重绘

## blog 1

![1](../Image/Piecemeal_Knowledge/1.png)
![1](../Image/Piecemeal_Knowledge/2.png)
![1](../Image/Piecemeal_Knowledge/3.png)
![1](../Image/Piecemeal_Knowledge/4.png)
![1](../Image/Piecemeal_Knowledge/5.png)
![1](../Image/Piecemeal_Knowledge/6.png)

总结: 通过html构建DOM Tree, 再通过CSS 和 DOM Tree构建带有样式的Render Tree. 在Render Tree中, 一些`display:none`, `<head>`等不可见标签都不会出现. 一旦Render Tree完成, 浏览器就会 paint (draw) the render tree nodes on the screen.

Reflow: 意味着重新计算元素的位置等, 影响layout, 会导致render tree变化. parts of the render tree (or the whole tree) will need to be revalidated and the node dimensions recalculated.
Repaint: 重新画, 不会影响layout, no dimensions changed. parts of the screen will need to be updated, either because of changes in geometric properties of a node or because of stylistic change, such as changing the background color. This screen update is called a repaint, or a redraw.

## blog 2

![1](../Image/Piecemeal_Knowledge/7.png)
![1](../Image/Piecemeal_Knowledge/8.png)
![1](../Image/Piecemeal_Knowledge/9.png)
![1](../Image/Piecemeal_Knowledge/10.png)
![1](../Image/Piecemeal_Knowledge/11.png)
![1](../Image/Piecemeal_Knowledge/12.png)
![1](../Image/Piecemeal_Knowledge/13.png)
![1](../Image/Piecemeal_Knowledge/14.png)
![1](../Image/Piecemeal_Knowledge/15.png)
![1](../Image/Piecemeal_Knowledge/16.png)
![1](../Image/Piecemeal_Knowledge/17.png)

## reference

[blog](https://medium.com/swlh/what-the-heck-is-repaint-and-reflow-in-the-browser-b2d0fb980c08)
[blog2](https://www.phpied.com/rendering-repaint-reflowrelayout-restyle/)