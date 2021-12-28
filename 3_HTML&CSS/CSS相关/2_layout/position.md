# [CSS position](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning)

## static

Static positioning is the default that every element gets. It just means "put the element into its normal position in the document flow — nothing special to see here."

## relative

他跟`static`很相似, 占据在正常的文档流中, 跟static唯一的区别就是它可以和其他元素`重叠`, 并且可以通过`top bottom left right`去设置dom的位置.

![22](../../../Image/CSS/22.png)

例如图片中黄色组件, 通过设置`top: 30px; left: 30px`, 将会让这个元素相对于static向下和向右移动`30px`

## absolute

![23](../../../Image/CSS/23.png)

脱离了正常的文档流, 可以看到蓝色的dom挤在了一起, 黄色元素像不复存在一样. 该黄色dom位于独立的一层, 这个时候设置`top bottom left right` 已经不是relative相对位置, 而是相对于页面的位置. 例如图中通过设置`top: 30px; left: 30px`, 元素会相对于页面向下和向右移动`30px`

