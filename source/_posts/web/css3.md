---
title: CSS3.0新特性集锦
tags: CSS
categories: Web
---

阅读W3C工作组成员[Lea Verou](https://github.com/LeaVerou)的《CSS揭秘》之后，开始重新审视重度交互下CSS3提供的各种最新特性，于是参考Mozilla的[CSS Reference](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference)并结合[W3C规范](https://www.w3.org)对常用CSS3特性进行了归纳和总结。因为CSS2.1以后的规范越来越庞大，所以W3C工作组将这些规范打散到不同模块当中，每个模块都独立进行版本更新，所有CSS2.1已有特性模块都被升级到以*3*作为版本号，如果是全新的功能模块则版本号从*1*开始。因此，CSS3并非真正意义上的W3C规范，准确的描述应为**CSS标准规范第3版与部分版本号为1的新规范的集合**。目前CSS各模块版本的更新速度不尽相同，因此后续很难再给予准确的版本号描述。

![](css3/logo.png)

<!-- more -->

> 一直以来，浏览器都通过前缀来区分那些最新的、具有实验性质的CSS3属性，例如Firefox（*-moz-*）、IE（*-ms-*）、Opera（*-o-*）、Safari和Chrome（*-webkit-*），但是这样并不利于规范的升级与统一，因此后续的新版浏览器正在逐步放弃这种做法，改为通过配置开关来启用这些实验性属性的支持。

## box-sizing

CSS中设置HTML元素的`width`与`height`只会作用在该元素的**内容区**，盒子模型的宽高会叠加`border`、`padding`的值，因此调整宽高度的时候需要时刻注意该HTML元素的`border`、`padding`，该特性在实现响应式布局时显得相当烦琐，而`box-sizing`属性正是用来调整这一行为的。

```css
.block {
  box-sizing: content-box;
  box-sizing: border-box;
}
```

![](css3/box-sizing.png "box-sizing")

1. `content-box`：默认值，宽度和高度都不包含内容的`border`和`padding`。
```javascript
width  = "内容的宽度"
height = "内容的高度"
```
2. `border-box`：盒子模型的宽、高度都会包含`border`和`padding`。
```javascript
width  = "border + padding + 内容区width"
height = "border + padding + 内容区height"
```


## flex

本段内容翻译自**CSS Tricks**社区的[《A Complete Guide to Flexbox》](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)一文，Flex在最近的最近的W3C草案称为**Flexbox Layout**（笔者文章中统一翻译为**伸缩盒布局**），主要用于更有效的排列、布局、分配container中items之间的空间，即使是在这些元素尺寸未知或者动态的时候。Flex伸缩布局的主要思想，是让container具体改变其中items宽度、高度、顺序的能力，从而更优雅的填充可利用空间，并在它们缩小时防止overflow发生。

![](css3/flex-axis.png "Flex Axis")

![](css3/flex-container.png "容器container")

![](css3/flex-items.png "条目items")

> Flex非常适用于组件级别、小粒度的页面布局，更大粒度的布局可以考虑使用Grid。

### container的属性

#### display

定义一个flex container，可以设置行内或者块级元素，设置之后其直接子元素将会纳入flex上下文。

```css
.container {
  display: flex; /* or inline-flex */
}
```

#### flex-direction

定义items在container中的排列方向，可以是**垂直**或者**水平**的方向。

![](css3/flex-direction.png "flex-direction")

```css
.container {
  flex-direction: row | row-reverse | column | column-reverse;
}
```

1. `row (默认)`: 在*ltr*环境下从**左**到**右**，*rtl*当中从**右**至**左**进行排列。 
2. `row-reverse`: 在*ltr*环境下从**右**到**左**，*rtl*当中从**左**至**右**进行排列。
3. `column`: 作用与`row`属性值类似，但是方向为从**上**至**下**。
4. `column-reverse`: 作用与`row-reverse`属性值类似，但是方向为从**下**至**上**。

#### flex-wrap

默认情况下，items总是会试图填充一行，但是可以通过这个属性去调整这一行为，让items根据需要进行换行。

![](css3/flex-wrap.png "flex-wrap")

```css
.container{
  flex-wrap: nowrap | wrap | wrap-reverse;
}
```

`nowrap` (默认): 所有items将会位于同一行当中。
`wrap`: items将会从**上**至**下**进行换行。
`wrap-reverse`: items将会从**下**至**上**进行换行。

#### flex-flow

该属性是`flex-direction`和`flex-wrap`的简写，用来定义container的**main axes**和**cross axes**，其默认值为`row nowrap`。

```css
flex-flow: <‘flex-direction’> || <‘flex-wrap’>
```

#### justify-content

英文justify有对齐的意思，即沿着main axis进行对齐。主要用于items不能伸缩时，分配空余的container空间；或是items能够伸缩，但是已经达到最大尺寸的场景。因此，该属性会在一行中的items发生溢出时影响其在container中的对齐方式。

```css
.container {
  justify-content: flex-start | flex-end | center | space-between | space-around | space-evenly;
}
```

![](css3/justify-content.png "justify-content")

`flex-start (默认)`: items被放置到每行开始的位置。
`flex-end`: items会被放置到每行结束的位置。
`center`: items会在该行居中放置。
`space-between`: items规则分布在一行当中，第1个item位于行的**开始**位置，最后1个item位于行**结束**的位置。
`space-around`: 所有items两侧都拥有相同的间距，因此视觉上的间距并不相等。第1个item将会依靠container边缘保持**1个单元**的距离，但接下来的item两侧都拥有着自己的空间，这样会导致出现**2个单元**的间距。
`space-evenly`: 所以items**平均分布**在一行，每个item的间隔距离视觉上**完全相等**。

#### align-items

该属性用于定义当前行中的items如何基于**cross axis**进行布局，功能与**main axis**上的`justify-content`属性类似。

```
.container {
  align-items: flex-start | flex-end | center | baseline | stretch;
}
```

![](css3/align-items.png "align-items")

`stretch (默认)`: 填充父容器，`stretch [stretʃ] n.伸展`（仍然需要考虑到`min-width`/`max-width`）。
`flex-start`: items的起始位置位于该行cross axis的**顶部**。
`flex-end`: items的起始位置位于该行cross axis的**底部**。
`center`: items位于该行cross axis的**居中位置**。
`baseline`: items基于它们**基线**的位置进行排列。

#### align-content

该属性用于设置当cross-axis拥有额外空间时，如何去排列container的行。类似于`justify-content`在main axis内如何排列每个**单独**的items行，因此当仅存在一个items行的时候，该属性并不会体现任何效果。

```css
.container {
  align-content: flex-start | flex-end | center | space-between | space-around | stretch;
}
```

![](css3/align-content.png "align-content")

`stretch (默认)`: container中的**行**伸缩并且占据剩余的空间。
`flex-start`: container中的行放置在容器**起始**的位置。
`flex-end`: container中的行放置在容器**结束**的位置。
`center`: 容器里的行在container中处于**居中**位置。
`space-between`: 第1行位于container起始的位置，最后1行位于container最后的位置，接下来**中间的行**进行平均分布。
`space-around`: 每行都以**相同的间隔距离**均匀分布。

### items的属性

#### order

items默认按照HTML源代码的先后顺序排列，但是可以通过items的`order`属性来控制其在container中的顺序。

![](css3/order.png "order")

```css
.item {
  order: <integer>; /* default is 0 */
}
```

#### flex-grow

用来定义items在container中**弹性伸展**的比例，其属性值为**没有单位的比例值**，从而规定每个item所应该占据的空间。如果所有item的`flex-grow`设置为**1**，那么每个item将会均匀的占据container中剩余的空间。如果其中某个item的`flex-grow`设置为**2**，则将会占据其它item两倍的空间。

![](css3/flex-grow.png "flex-grow")

```css
.item {
  flex-grow: <number>; /* default 0 */
}
```

> `flex-grow`的属性值不能是**负数**，否则将会被认为是一个无效值。


#### flex-shrink

该属性用来设置item**弹性收缩**时的比例，属性值依然为**没有单位的比例值**（`shrink [ʃrɪŋk] n.收缩`）。

```css
.item {
  flex-shrink: <number>; /* default 1 */
}
```

> `flex-shrink`的属性值同样不能为**负数**，否则会被认为无效。

#### flex-basis

设置不伸缩的情况下items的原始默认尺寸，其属性值可以是**长度值**或者**关键字**。

- `length`：单位数值，例如`20%`、`5rem`、`px`、`mm`、`pt`。
- `auto`：基于items自身的高度和宽度属性。
- `content`：根据items的内容自动调整大小尺寸，该主流浏览器对该关键字的支持还不太友好，因此包括类似的`max-content`, `min-content`, `fit-content`属性值较少被使用。

```css
.item {
  flex-basis: <length> | auto; /* default auto */
}
```

> `flex-basis`属性值如果设置为`0`，items内部内容以外的区域将不会被考虑。但如果设置为`auto`，剩余空间将基于`flex-grow`进行分配。

![](css3/flex-basis.png "flex-basis")

#### flex

该属性是`flex-grow`, `flex-shrink`, `flex-basis`属性的简写，该属性值第2个参数（*flex-shrink*）、第3个参数（*flex-basis*）是可选的，默认值为`0 1 auto`。

```css
.item {
  flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]
}
```

> 推荐使用该简写属性来简化items的设置。

#### align-self

items上的这个属性会覆写container上`align-items`属性的设置。

```css
.item {
  align-self: auto | flex-start | flex-end | center | baseline | stretch;
}
```

![](css3/align-self.png "align-self")

> 注意，item上的`float`, `clear`, `vertical-align`属性不会对flex布局造成影响。

### Flex布局思维导图

![](css3/flex.png "Flex布局属性概览")


## grid


## transition


## animation


## transform

## @media
