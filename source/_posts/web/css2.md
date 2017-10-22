---
title: CSS2.1典型布局概述
tags: CSS
categories: Web
---

层叠样式表（**CSS**，*Cascading Stylesheet*）用于指定浏览器所渲染的样式（*如颜色、定位、装饰*），距离2011年CSS2.1版本发布至今，已经整整过去**6**个年头，浏览器和前端技术经历了日新月异的变化。虽然目前CSS3.0规范在选择器、弹性盒模型、动画与过渡方面进行了诸多增强，但是[W3C规范](https://www.w3.org/)始终保持着一致的继承性，所以CSS2.1及之前版本规范中提出的大量特性与概念依旧得以沿用。本文详细参考[Mozilla开发者社区](https://developer.mozilla.org/en-US/docs/Web/CSS)、[网易NEC](http://nec.netease.com/)前端开源项目、[CSS Mastery](https://www.apress.com/cn/book/9781430223979)，将CSS2.1当中常用的概念与典型布局进行了比较全面的梳理与概括。

![](css2/logo.jpg)

<!-- more -->

## 层叠优先级

浏览器通过层叠样式表的优先级判断哪些CSS属性值与HTML元素最为相关，从而在该HTML元素上应用这些CSS属性值。当HTML元素同时拥有多个CSS声明时，每条CSS规则都会**接管**或者**覆盖**该元素从祖先元素继承而来的规则。

### 定义位置优先级

按照样式**声明与定义位置**的不同，优先级**由高向低**排列如下：

1. 行内样式：`<span style="">`
2. 内嵌样式表：`<style></style>`
3. 引入的外部样式表：`<link href="demo.css" rel="stylesheet" />`

### 选择器优先级

按照所使用**CSS选择器**的不同，优先级**由高向低**排列如下：

1. ID选择器（*例如`#example`*）
2. 类选择器（*例如`.example`*），属性选择器（*例如`[type="radio"]`*），伪类选择器（*例如`:hover`*）
3. 类型选择器（*例如`h1`*）和 伪元素（*例如`::before`*）

> 通用选择器（`*`）、组合选择器（*`+, >, ~, ' '`*）、否定伪类选择器（*`:not()`*）对特异性没有影响（*但`:not()`内声明的选择器会影响优先级*）。

### 样式继承

每个CSS属性值都会指明其是否可以继承，以便在没有手动为HTML元素指定样式值时，该元素默认应该使用哪个样式。

- 可继承CSS属性（*inherited property*）：未指定值时，取父元素同属性的计算值（*computed value*）。
- 非继承CSS属性（*reset property*）：未指定值时，取该属性的初始值（*initial value*）。

所有CSS属性都可以使用如下2个值：

1. `inherit`：让该CSS元素值去继承父元素同名CSS属性的计算值。
2. `initial`：将被父元素覆盖的属性值重置为该CSS属性的默认值。

### !important

使用`!important`规则的样式声明将会覆盖其它任何声明，如果两条带有`!important`规则的声明被应用到相同HTML元素上，拥有更高优先级的声明将会被采用。

```scss
background: red !important; 
```

> 不要在全站、插件当中使用`!important`，尽量只在局部页面需要覆写的情况下使用。


## 盒子模型

每个HTML元素都会被CSS描述为一个矩形的盒子，每个盒子模型都由`content`**内容**、`padding`**内边距**、`border`**边框**、`margin`**外边距**4个框所组成。

![](css2/boxmodel.png)

> `content`内容区域设置的背景、颜色、图片样式会延伸到`padding`区域。

## 可替换HTML元素

HTML可替换元素（*replaced element*）的渲染并不由**CSS**控制，某些情况下，CSS会对可替换元素做特殊处理，比如计算外边距和一些auto值。

```html
<!-- 典型可替换元素 -->
<img/> <object/> <video/>
<!-- 表单元素 -->
<textarea/> <input/>
<!-- 特殊场景下表现为可替换元素 -->
<audio/> <canvas/>
```

> 通过CSS的`content`属性插入的HTML内容，被称为**匿名可替换元素**（*anonymous replaced elements*）。

## 简写属性

CSS规范定义简写属性的目的，在于将同一主题的常见属性定义集中在一起，从而编写更简洁、更具可读性的样式表。

```css
/* background */
#app {
  background-color: #000;
  background-image: url(images/bg.gif);
  background-repeat: no-repeat;
  background-position: top right;
}
#app {
  background: #000 url(images/bg.gif) no-repeat top right;
}

/* font */
#app {
  font-style: italic;
  font-weight: bold;
  font-size: .8em;
  line-height: 1.2;
  font-family: Arial, sans-serif;
}
#app {
  font: italic bold .8em/1.2 Arial, sans-serif;
}
```

目前CSS可以进行简写的属性如下：

- `flex`
- `list-style`
- `transition` `transform`,
- `background` `font` `margin` `padding`
- `border` `border-top` `border-right` `border-bottom` `border-left` `border-width` `border-color` `border-style` `border-radius`


## 块级/行内元素

### 块级元素（*block-level*）
当HTML元素的`display`属性为`block`、`list-item`、`table`时，该元素就是**块级元素**。块级元素视觉上呈现为竖直排列的**块**，`<div>`和`<p>`都是典型的块级元素。

### 行内元素（*inline-level*）
当HTML元素的`display`属性为`inline`、`inline-block`、`inline-table`时，该元素为**行内元素**。视觉上行内元素的内容会逐行进行排列，**文本**和**图片**都是典型的行内级元素。

## 定位

CSS为开发人员提供了3种布局方式：**标准文档流**、**定位布局**、**浮动布局**。盒子模型生成之后，浏览器渲染引擎会通过如下属性定位其在文档中的位置。

### position属性

- `static`
元素**遵循**常规文档流，指定元素使用正常的布局行为，即元素在文档常规流中当前的布局位置。此时`top`、`right`、`bottom`、`left`和`z-index`属性无效。换而言之，只有当`position`属性值为`非static`时，层叠顺序才可以通过`z-index`属性定义。

- `relative`
元素**遵循**常规文档流，参照自身在常规流中的位置，通过4个偏移属性`top`、`right`、`bottom`、`left`进行定位，但并不会影响常规流中的其它元素。当该元素的`z-index`不为`auto`时，这种定位方式会创建一个新的层叠上下文。

- `fixed`
元素**脱离**常规文档流，与`absolute`属性值类似，但元素的包含块为`viewport`，常用于设置滚动屏幕时仍固定在相同位置的元素。当该元素的`z-index`不为`auto`时，此种定位方式依然会创建一个新的层叠上下文。

- `absolute`
元素**脱离**常规文档流，所以不会为元素预留空间，元素位置将会参照**最近的非static定位祖先元素**，如果该祖先元素不存在，则相对于根级容器进行定位。元素的偏移位置不影响常规流中的其它元素，其`margin`不会与其它边距产生折叠。当该元素的`z-index`不为`auto`时，该种定位方式同样会创建一个新的层叠上下文。

  * 绝对定位元素的`top`、`right`、`bottom`、`left`属性未设置时，会紧随在前面的兄弟元素之后，虽然位置上不影响常规流中其它元素，但是该元素会失去其位置并与后继元素发生折叠。
  * 如果同时指定绝对定位元素的`top`和`bottom`将会优先采用`top`；如果同时指定`left`和`right`，则优先采用`left`。
  * 当绝对定位元素的`height`和`width`属性值为`auto`时，会自动计算并填充父元素的宽度。
  * 当同时指定绝对定位元素的`top`和`bottom`时，如果`height`的值为`auto`，则会填充父元素的**垂直**空间。
  * 当同时指定绝对定位元素的`left`和`right`时，如果`width`的值为`auto`，则会填充父元素的**水平**空间。

### float属性
当一个元素发生浮动以后，会被移出正常的文档流，然后向左或者向右平移，一直平移直到。
元素**脱离**正常文档流，但是**会保留部分的流式特性**，如果`float`设置为`left`则元素放置在其父容器内左则，`right`就会放置在其父容器内的右侧（*触碰到父容器的边框或另一个浮动元素*），而`none`表示当前元素不进行浮动。

* 发生浮动后的元素允许**文本**、**内联元素**环绕在其旁边，这也是认为其保留部分流式特性的原因所在。
* 发生浮动定位时，元素CSS属性的`position`必须为`static`或`relative`。
* 使用`float`之后会让元素的`display`属性体现为块元素。

- `none`：元素**不浮动**。
- `left`：元素**向左**浮动。
- `right`：元素**向右**浮动。

> `float`属性在**绝对定位**和**display为none**时不会生效。

### clear属性

指出当前HTML元素哪一侧的元素不需要进行浮动。

- `none`：两侧都**可以**存在浮动元素。
- `left`：不允许**左侧**出现浮动元素。
- `right`：不允许**右侧**出现浮动元素。
- `both`：**两侧**都**不**允许出现浮动元素。

```html
<div class="test1">1</div>
<div class="test2">2</div>
<div class="test3">3</div>

<style>
.test1 {
  float: left;
}
.test2 {
  clear: both;
}
.test3 {
  float: left;
}
</style>

<!-- 渲染结果 -->
1
2
3
```


## 外边距塌陷

margin塌陷（*margin collapsing*）是指HTML块元素的顶部margin和底部margin有时会被折叠为margin值最大的外边距，外边距塌陷通常发生在下面3种情况：

- 相邻的两个兄弟HTML元素之间的margin会塌陷。

```html
<!-- 两个p元素的margin发生塌陷，渲染出p元素的间隔为30px -->
<p style="margin-bottom: 30px;">该元素的margin-bottom为30px</p>
<p style="margin-top: 20px;">该元素的margin-top为20px</p>
```

- 块级父元素与其第1个/最后1个子元素

如果块级的父HTML元素未使用`border-top`、`padding-top`、`inline`、 `clear`属性（*即`border-top`、`padding-top`为0的时候*），此时父元素与第1个子元素会发生**上外边距合并**，展现出的外边距将是两者之间`margin-top`最大的那个。

```html
<section style="margin-top: 30px;">
  <p style="margin-top: 50px;">父子元素的margin-top发生合并，父元素会渲染出子元素50px的margin-top效果</p>
</section>
```

如果块级父元素未使用`border`、`padding`、`inline`、`height`、`min-height`、`max-height`属性，则父元素与最后1个子元素将发生**下外边距合并**。

```html
<section style="margin-bottom: 15px;">
  <p style="margin-bottom: 40px;">父子元素的margin-bottom发生塌陷，父元素会渲染出子元素40px的margin-bottom效果</p>
</section>
```

- 空的块元素

如果一个没有内容的**空块级元素**未使用`border`、`padding`、`inline`、`height`、`min-height`属性，此时它将会与相临的兄弟元素发生**上下外边距合并**。

```html
<!-- 中间div元素的与相邻p元素首先发生margin塌陷，然后两个p元素的margin再次发生塌陷，最终只渲染出间隔30px的两个p元素 -->
<p style="margin-bottom: 10px;">该HTML元素与下面元素的margin-bottom为10px</p>
<div style="margin-top: 5px; margin-bottom: 10px;"></div>
<p style="margin-top: 30px;">该HTML元素与上面元素的margin-top为30px</p>
```

当存在一个负值`margin`时，塌陷后的外边距是两者之和；如果`margin`都为负值，则取绝对值最大的那个。

```html
<!-- 两个div元素发生外边距塌陷，渲染出的div元素间隔距离是20px -->
<div style="margin-bottom: -80px;">该元素的margin-bottom为-80px</div>
<div style="margin-top: 100px;">该元素的margin-top为100px</div>
```

> 即使外边距为0，这些规则也仍旧生效。


## 包含块

HTML元素的尺寸、位置经常受到其包含块（*containing block*）的影响，通常情况下包含块是其父元素，但特殊情况下并不总是这样，因此必须通过HTML元素的`position`属性来确定其包含块。

1. 如果`position`属性是`static`或`relative`，包含块就是其父级块元素（*例如`inline-block`、`block`、`list-item`*）或格式化上下文（*例如table容器、flex容器、grid容器、block容器本身*）内容区的边缘组成。

2. 如果`position`属性是`absolute`，包含块就是由距离最近的`position`属性值`非static`（*`fixed`, `absolute`, `relative`, `sticky`*）的祖先元素的内边距区的边缘组成。

3. 如果`position`属性是`fixed`，包含块由**viewport**或**页面区域**所组成。

4. 如果`position`属性是`absolute`或`fixed`，包含块也有可能是由满足下面条件的**最近父元素的内边距区的边缘**组成：

* 一个非none的转换或透视值。
* 一个将会改变的转换或透视值。
* 一个非none的过滤值，或者一个将会改变的过滤值（*仅工作在Firefox*）。

> 根元素`<html>`所在的包含块是一个被称为**初始包含块**的矩形区域。

CSS属性被赋予一个百分比值的时候，其值由该元素的**包含块**计算而来的。

1. 一个HTML元素的`height`、`top`、`bottom`属性值由包含块的`height`属性值计算而来（*如果包含块的`height`值依赖于其内容，且包含块的`position`属性值为`relative`或`static`，则该HTML元素的这些值为**0***）。
2. 一个HTML元素的`width`、`left`、`right`、`padding`、`margin`属性由包含块的`width`属性值来计算而来。

接下来的各个例子中的CSS样式都统一使用如下HTML：

```html
<body>
  <section>
    <p>This is a paragraph!</p>
  </section>
</body>
```

下面例子中，因为`<p>`元素处于静态位置，其临近的祖先HTML元素`<section>`是一个块元素，所以其包含块就是`<section>`，

![](css2/containing-block-1.png "包含块-Example-1")

```css
body {
  background: beige;
}

section {
  display: block;
  width: 400px;
  height: 160px;
  background: lightgray;
}

p {
  width:  50%;  /* == 400px * 50% = 200px */
  height: 25%;  /* == 160px * 25% = 40px  */
  margin:  5%;  /* == 400px *  5% = 20px  */
  padding: 5%;  /* == 400px *  5% = 20px  */
  background: cyan;
}
```

下面例子中，HTML元素`<p>`的包含块是`<body>`，因为`<section>`不是块元素且没有建立格式化上下文。

![](css2/containing-block-2.png "包含块-Example-2")

```css
body {
  background: beige;
}

section {
  display: inline;
  background: lightgray;
}

p {
  width: 50%;     /* == half the body's width  */
  height: 200px;  /* Note: a percentage would be 0 */
  background: cyan;
}
```

下面例子中，元素`<p>`的包含块是`<section>`，这是因为`<section>`的`position`属性为`absolute`，`<p>`的百分比属性值受到包含块`<section>`的`padding`值影响，

![](css2/containing-block-3.png "包含块-Example-3")

```css
body {
  background: beige;
}

section {
  position: absolute;
  left: 30px;
  top: 30px;
  width: 400px;
  height: 160px;
  padding: 30px 20px;
  background: lightgray;
}

p {
  position: absolute;
  width:  50%;  /* == (400px + 20px + 20px) * 50% = 220px */
  height: 25%;  /* == (160px + 30px + 30px) * 25% = 55px  */
  margin:  5%;  /* == (400px + 20px + 20px) *  5% = 22px  */
  padding: 5%;  /* == (400px + 20px + 20px) *  5% = 22px  */
  background: cyan;
}
```

下面例子中，元素`<p>`的`position`属性为`fixed`，因此其包含块为**初始化包含块**（*屏幕上的viewport*）。因此`<p>`元素的尺寸会受到浏览器window尺寸的影响。

![](css2/containing-block-4.png "包含块-Example-4")

```css
body {
  background: beige;
}

section {
  width: 400px;
  height: 480px;
  margin: 30px;
  padding: 15px;
  background: lightgray;
}

p {
  position: fixed;
  width: 50%;   /* == (50vw - (width of vertical scrollbar))    */
  height: 50%;  /* == (50vh - (height of horizontal scrollbar)) */
  margin: 5%;   /* == (5vw  - (width of vertical scrollbar))    */
  padding: 5%;  /* == (5vw  - (width of vertical scrollbar))    */
  background: cyan;
}
```

下面例子中，元素`<p>`的`position`属性为`absolute`，因此其包含块为`<section>`，因为`<section>`作为临近祖先元素，并且使用了非`none`的`transform`属性。

![](css2/containing-block-5.png "包含块-Example-5")

```css
body {
  background: beige;
}

section {
  transform: rotate(0deg);
  width: 400px;
  height: 160px;
  background: lightgray;
}

p {
  position: absolute;
  left: 80px;
  top: 30px;
  width:  50%;  /* == 200px */
  height: 25%;  /* == 40px  */
  margin:  5%;  /* == 20px  */
  padding: 5%;  /* == 20px  */
  background: cyan;
}
```


## 一列布局

```html
<main id="app">
  <div class="column">
    <h1>column</h1>
  </div>
</main>
```

### 一列定宽布局

![](css2/layout-1-1.png "一列定宽布局")

```scss
#app {
  background: $gray;
  .column {
    background: $pink;
    width: 400px; // 宽度使用绝对单位
    height: 100%;
  }
}
```

### 一列宽度自适应

![](css2/layout-1-2.png "一列宽度自适应")

```html
<main id="app">
  <div class="column">
    <h2>column</h2>
  </div>
</main>
```
```scss
#app {
  background: $gray;
  .column {
    background: $pink;
    width: 60%;  // 宽度使用相对单位
    height: 100%;
  }
}
```

### 一列宽度居中

![](css2/layout-1-3.png "一列宽度居中")

```html
<main id="app">
  <div class="column">
    <h2>column</h2>
  </div>
</main>
```
```scss
#app {
  background: $gray;
  .column {
    background: $pink;
    width: 60%;
    height: 100%;
    margin: 0 auto; // 块元素居中
  }
}
```

## 二列布局

```html
<main id="app">
  <div class="column-left">
    <h1>column-left</h1>
  </div>
  <div class="column-right">
    <h1>column-right</h1>
  </div>
</main>
```

### 二列定宽布局

![](css2/layout-2-1.png "二列定宽布局")

```scss
#app {
  background: $gray;
  .column-left {
    background: $cyan;
    width: 300px;  // 绝对宽度
    height: 100%;
    float: left;
  }
  .column-right {
    background: $pink;
    width: 400px;  // 绝对宽度
    height: 100%;
    float: left;
  }
}
```


### 二列宽度自适应

![](css2/layout-2-2.png)

```scss
#app {
  background: $gray;
  .column-left {
    background: $cyan;
    width: 30%;  // 相对宽度
    height: 100%;
    float: left;
  }
  .column-right {
    background: $pink;
    width: 60%;  // 相对宽度
    height: 100%;
    float: left;
  }
}
```


### 二列右侧宽度自适应

![](css2/layout-2-3.png)

```scss
#app {
  background: $gray;
  .column-left {
    background: $cyan;
    width: 30%; // 左栏设置固定值
    height: 100%;
    float: left;
  }
  .column-right {
    background: $pink;
    height: 100%; 
    // 右栏不设置宽度和浮动
  }
}
```


### 二列左侧宽度自适应

![](css2/layout-2-4.png)

```scss
#app {
  background: $gray;
  .column-left {
    background: $cyan;
    height: 100%;
    float: left;
    width: 100%;
  }
  .column-right {
    background: $pink;
    height: 100%;
    float: right;
    width: 30%;
    margin-left: -30%; // 负外边距
  }
}
```

>> `负外边距`和`不设置宽度和浮动`都可以用来分别实现**二列左右侧宽度自适应**效果。

## 三列布局

### 三列中间自适应布局

![](css2/layout-3-1.png)
```html
<main id="app">
  <div class="column-left">
    <h1>column-left</h1>
  </div>
  <div class="column-middle">
    <div>
      <h1>column-middle</h1>
    </div>
  </div>
  <div class="column-right">
    <h1>column-right</h1>
  </div>
</main>
```
```scss
#app {
  background: $gray;
  .column-left {
    background: $cyan;
    height: 100%;
    position: relative;
    float: left;
    width: 350px;
    margin-right: -350px;  // 负外边距
  }
  .column-middle {
    background: $pink;
    height: 100%;
    float: left;
    width: 100%;
    // 嵌套div让出左右block的负值外边距
    div {
      margin-right: 300px;
      margin-left: 350px;
    }
  }
  .column-right {
    background: $blue;
    height: 100%;
    float: right;
    width: 300px;
    margin-left: -300px;  // 负外边距
  }
}
```

### 三列左侧自适应布局

![](css2/layout-3-2.png)

```html
<main id="app">
  <div class="column-left">
    <div>
      <h1>column-left</h1>
    </div>
  </div>
  <div class="column-right">
    <h1>column-right</h1>
  </div>
  <!-- 居中内容因为浮动必须放置在DOM结构的最后 -->
  <div class="column-middle">
    <h1>column-middle</h1>
  </div>
</main>
```
```scss
#app {
  background: $gray;
  .column-left {
    background: $pink;
    height: 100%;
    float: left;
    width: 100%;
    margin-right: -650px;  // 设置外边距为负值
    div {
      margin-right: 650px;  // 补偿负值外边距
    }
  }
  .column-middle {
    background: $cyan;
    height: 100%;
    float: right;
    width: 350px;
  }
  .column-right {
    background: $blue;
    height: 100%;
    float: right;
    width: 300px;
  }
}
```

### 三列右侧自适应布局

![](css2/layout-3-3.png)

```html
<main id="app">
  <div class="column-left">
    <h1>column-left</h1>
  </div>
  <div class="column-middle">
    <h1>column-middle</h1>
  </div>
  <div class="column-right">
    <div>
      <h1>column-right</h1>
    </div>
  </div>
</main>
```

```scss
#app {
  background: $gray;
  .column-left {
    background: $blue;
    height: 100%;
    width: 300px;
    position: relative; // 将块元素设置为相对定位
    float: left;
  }
  .column-middle {
    background: $cyan;
    height: 100%;
    width: 350px;
    position: relative; // 将块元素设置为相对定位
    float: left;
  }
  .column-right {
    background: $pink;
    float: right;
    height: 100%;
    width: 100%;
    margin-left: -650px; // 设置外边距为负值
    div {
      margin-left: 650px; // 补偿负值外边距
    }
  }
}
```



## 圣杯布局

[圣杯布局](https://alistapart.com/article/holygrail)


## 双飞翼布局


## 垂直居中

最早实现垂直居中的技术是通过组合使用`position`的`absolute`和`relative`属性进行偏移和修正，该方式会产生冗余HTML标签从而影响页面的语义化，所以笔者并不推荐使用。

```html
<div class="parent">
  <div class="center">
    Center
  </div>
</div>
```

```scss
$width: 500px;   // 居中元素的宽度
$height: 300px;  // 居中元素的高度
$offset: 50%;    // 偏移
$amend: -50%;    // 修正偏移
.parent {
  position: absolute;
  width: $width;
  height: $height;
  top: $offset;
  left: $offset;
  background: blue;
  .center {
    position: relative;
    width: $width;
    height: $height;
    top: $amend;
    left: $amend;
    background: white;
  }
}
```

![](css2/vertical-center-1.png "定位相对偏移位置实现垂直居中")

如果知道居中HTML元素的`width`和`height`尺寸，且不希望使用冗余标签影响页面语义化，可以考虑通过**margin负值**方便的实现垂直居中。

![](css2/vertical-center-2.gif "基于CSS2绝对定位的简单垂直居中")

```html
<body>
  <div class="center">
    Center
  </div>
</body>
```

```scss
<style>
.center {
  position: absolute;
  width: 300px;
  height: 400px;
  top: 50%;
  left: 50%;
  margin-left: -150px;
  margin-top: -200px;
}
</style>
```

![](css2/vertical-center-3.png "通过表格布局垂直居中")

当不知道居中HTML元素的具体尺寸的时候，可以通过**表格定位**实现居中效果。

```html
<table>
  <tr>
    <td class="center">
      center
    </td>
  </tr>
</table>
```

```scss
table {
  width: 100%;
  .center {
    text-align: center;
    vertical-align: middle;
  }
}
```

如果需要让HTML结构更加语义化，可以通过`display`的`table`和`table-cell`属性将上面例子修改成下面这样：

```html
<div class="parent">
  <div class="center">
    Center
  </div>
</div>
```

```scss
.parent {
  display: table;
  width: 100%;
  .center {
    display: table-cell;
    text-align: center;
    vertical-align: middle;
  }
}
```

![](css2/vertical-center-4.png "通过影子元素实现垂直居中")

table的渲染与传统块级元素的渲染略有不同，table只能扩张到内部嵌套内容的宽度，而块级元素则可以自动扩张到其父级元素的宽度。

CSS2.1当中最终极和完美的居中技术是通过**影子HTML元素**，如果设置其到100%高度的父元素当中，然后分别设置`vertical-align: middle`。影子元素并不会影响页面的语义化，因为可以将其设置为一个伪元素（**）。

```html
<div class="parent">
  <div class="center">
    <h1>Center</h1>
    <p>Center</p>
  </div>
</div>
```

```scss
.parent {
  text-align: center;
  height: 300px;
  background: gray;
}
.parent:before {
  content: '';
  display: inline-block;
  vertical-align: middle;
  height: 100%;
}
.center {
  display: inline-block;
  vertical-align: middle;
  width: 300px;
  background: white;
}
```

![](css2/vertical-center-5.png "影子元素垂直居中效果")


## 响应式栅格


## CSS精灵

## margin负值


## vertical-align

## line-height

## text-align

## 溢出与换行