---
title: 为什么认为Backbone是现代化前端框架的基石
tags: Web
categories: Summary
---

![](backbone/logo.png)

起步于2005年的[jQuery](http://jquery.com/)仅仅对DOM操作进行了基础性的封装，提供了可链式调用的写法、更加友好的ajax函数、屏蔽了浏览器兼容性的丰富选择器，但是并没有解决前端开发中选择器滥用、作用域相互污染、代码复用度低冗余度高、数据和事件绑定烦琐等等痛点。

为此，2009年横空出世的[Angular](https://angularjs.org/)提供了一揽子解决方案，对浏览器原生事件机制进行深度封装的同时，提供了路由、双向绑定、指令等现代化前端框架的特性，但是也正是由于其封装的抽象程度太深，学习曲线当时而言是非常陡峭的，而且对于`controller`和`$scope`的过度倚重，以及照搬Java的MVC分层思想试图通过`service`来完成页面逻辑的复用，并未彻底解决前端开发前面提到的诸多痛点。

诞生于2010的[Backbone](http://backbonejs.org/)则另辟蹊径，通过与[Undersocre](http://underscorejs.org/)、[Require](http://requirejs.org/)、[Handlebar](http://handlebarsjs.com/)的整合，为那个年代的开发人员提供了Angular之外，一个更加轻量和友好的前端开发解决方案，许多思想对于后续的现代化前端框架的发展起到了举足轻重的作用。

从前端技术发展趋势的角度而言，目前诸多现代化前端框架的诞生，都可以认为是Angular和Backbone等古典前端框架设计思想走向融合之后的产物。之所以这篇文章将Backbone单独提出来单独讲解，主要是在**组件化**和**作用域控制**等方面，Backbone更加接近于现代化前端框架的设计理念，而这两点又正好是Angular并没有解决好的问题。

<!-- more -->


## 组件化

**组件化**是Vue、React、Angular2等现代化前端框架的总体思想，组件化的真实含义来源于将复杂的DOM结构切割为更小粒度的HTML代码片段，从而能够更加从容的面对日益复杂的单页面交互。


## 选择器和事件的作用域控制


## MVVM


## 数据绑定


## 双向绑定


## 前端路由




