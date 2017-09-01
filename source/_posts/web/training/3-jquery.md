---
title: jQuery中一些容易被忽略的问题
tags: Web
categories: Training
---

伴随`Vue`、`Angular`、`React`等编译式前端框架的崛起，前端开发人员逐渐从繁琐的DOM操作当中解脱出来。但是在项目实践过程当中，依然有诸多问题需要通过直接与DOM对话来解决，虽然现代化浏览器已经支持等HTML5新特性，不过为了屏蔽各种浏览器原生API接口的差异化，最终依然需要借助`jQuery`来实现DOM操作。所以，`jQuery`这款诞生于2006年的库，依然在现代化前端开发当中扮演着重要角色，本文结合笔者近几年的实践经验，总结了使用`jQuery`过程当中容易被忽略的一些问题。

## jQuery对象和DOM对象

- DOM对象：通过原生javascript（如`getElementsByTagName`或`getElementId`）获取的html节点。

```javascript
var dom = document.getElementById("app") // 获取DOM对象
var html = dom.innerHTML; // 获取DOM元素内的HTML代码 
```

![](3-jquery/dom.png "通过document获取原生DOM对象")

- jQuery对象：被jQuery包装过的DOM对象

```javascript
var jq = $("#app"); // 获取jQuery对象
var html = jq.html(); // 获取jQuery对象内的HTML代码
```

![](3-jquery/jquery.png "jQuery对象的本质是数组")

> 不能交换使用jQuery对象、DOM对象上的属性，如上面代码中的`innerHTML`与`html()`。

<!-- more -->

## jQuery对象->DOM对象

jQuery提供了2种转换DOM对象的方法：

（1）jQuery对象是一个类似于数组的对象，因此可以通过数组运算符`[]`获取指定索引的DOM对象。

```javascript
var jq = $(".test"); // jQuery对象
var dom = jq[0];  // DOM对象
```

（2）通过jQuery本身提供的`get(index)`方法来获取指定index的对象。

```javascript
var jq = $(".test"); // jQuery对象
var dom = jq.get(0);  // DOM对象
```

## DOM对象->jQuery对象

将DOM对象通过`$()`函数包装起来，就可以获得jQuery对象。

```javascript
var dom = document.getElementById("test");
var jq = $(dom);
```

> 可以考虑使用**$**作为前缀为jQuery对象进行命名，例如上面代码中的变量`jq`可以命名为`$jq`。


## jQuery选择器性能

下面对jQuery选择器的性能由高向低进行排序：

1. ID选择器

```javascript
$("#id")
```

2. 标签选择器

```javascript
$("input")
```

3. 类选择器

```javascript
$(".class")
```

4. 伪类选择器

```javascript
$("[contenteditable]")
```

## 异步$defer对象