---
title: CSS3.0新特性集锦
tags: CSS
categories: Web
---

![](css3/logo.png)

<!-- more -->

## box-sizing

用于更改用于计算元素宽度和高度的默认的 CSS 盒子模型。

CSS中设置HTML元素的`width`与`height`只会作用在该元素的**内容区**，盒子模型的宽高会叠加`border`、`padding`的值，因此调整宽高度的时候需要时刻注意该HTML元素的`border`、`padding`，该特性在实现响应式布局时显得相当烦琐，而`box-sizing`属性正是用来调整这一行为的。

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

![](css3/box-sizing.png)

```css
.block {
  box-sizing: content-box;
  box-sizing: border-box;
}
```

## flex

弹性盒模型

## transition

## animation

