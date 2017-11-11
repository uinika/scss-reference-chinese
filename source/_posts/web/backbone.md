---
title: 为什么认为Backbone是现代化前端框架的基石
tags: JavaScript
categories: Web
---

伴随着W3C协议规范不断更新，以及现代化浏览器技术的不断进步，Web前端技术在整体取得日新月异发展的同时，也推动着页面UI/UE与交互逻辑的迅速膨胀。开发人员函需从大量底层处理的劳动中解脱出来，更加从容的去面对纷繁复杂的单页面交互需求。本文开头会先简单的梳理一下历史，然后基于现代化前端框架的主要特性，逐一对Backbone进行比较和剖析。

![](backbone/logo.png)

从前端技术发展趋势的角度而言，目前层出不穷的现代化前端框架的诞生，都可以认为是Angular和Backbone等古典前端框架设计思想走向融合之后的产物。虽然截至到本文开始执笔的时间，Backbone已经有些**old fashion**，但之所以单独对Backbone着重笔墨，主要是在**组件化**和**作用域控制**等方面，Backbone更加接近于现代化前端框架的设计理念，而这两点又正好是同一时期的Angular并没有解决好的问题。

<!-- more -->

起步于2005年的[jQuery](http://jquery.com/)仅仅对DOM操作进行了基础性的封装，提供了可链式调用的写法、更加友好的ajax函数、屏蔽了浏览器兼容性的丰富选择器，但是并没有解决前端开发中选择器滥用、作用域相互污染、代码复用度低冗余度高、数据和事件绑定烦琐等等痛点。

为此，2009年横空出世的[Angular](https://angularjs.org/)提供了一揽子解决方案，对浏览器原生事件机制进行深度封装的同时，提供了路由、双向绑定、指令等现代化前端框架的特性，但是也正是由于其封装的抽象程度太深，学习曲线相对陡峭，而对于`controller`和`$scope`的过度倚重，以及照搬Java的MVC分层思想试图通过`service`来完成页面逻辑的复用，并未彻底解决前端开发前面提到的诸多痛点。

诞生于2010的[Backbone](http://backbonejs.org/)则另辟蹊径，通过与[Undersocre](http://underscorejs.org/)、[Require](http://requirejs.org/)、[Handlebar](http://handlebarsjs.com/)的整合，为那个年代的开发人员提供了Angular之外，一个更加轻量和友好的前端开发解决方案，许多思想对于后续的现代化前端框架的发展起到了举足轻重的作用。


## 视图组件化

**视图组件化**是Vue、React、Angular2等现代化前端框架的基本思想，其主要目的是将复杂的DOM结构切割为更小粒度的HTML代码片段。Backbone通过`Backbone.View.extend()`继承函数来新建一个视图对象（*即组件*），该视图对象即可以使用`el`属性挂载到现有DOM，也可以通过`template`属性建立全新的视图对象。对Vue2比较熟悉的同学，应该会感觉到这个写法与Vue组件对象非常类似。

：

```javascript
/* Backbone视图对象 */
Backbone.View.extend({
  id: "app",

  template: '...',

  events: {
    "click .icon":          "open",
    "click .button.edit":   "openEditDialog",
    "click .button.delete": "destroy"
  },

  initialize: function() {
    this.listenTo(this.model, "change", this.render);
  },

  render: function() {
    this.$el.html(this.template());
    return this;
  }

});
```

```javascript
/* Vue组件对象 */
new Vue({
  el: '#example',

  data: {},
 
  methods: {

  }

})
```

```jsx
/* React组件对象 */
class MyComponent extends React.Component {
  constructor(props) {
    // 组件构造函数
  }

  myEvent(event) {
    event.preventDefault();
  }

  render() {
    return (
      // JSX
    );
  }
};
```



## 作用域控制

选择器与事件的作用域控制。

## MVVM


## 数据绑定


## 双向绑定


## 前端路由


## 僵尸视图问题

## 单页面应用


## 完整Demo




