---
title: jQuery中那些容易被忽略的问题
tags: Web
categories: Summary
---

伴随`Vue`、`Angular`、`React`等编译式前端框架的崛起，前端开发人员逐渐从繁琐的DOM操作当中解脱出来。但是在项目实践过程当中，依然有诸多问题需要通过直接与DOM对话来解决，虽然现代化浏览器已经支持等HTML5新特性，不过为了屏蔽各种浏览器原生API接口的差异化，最终依然需要借助`jQuery`来实现DOM操作。所以，`jQuery`这款诞生于2006年的库，依然在现代化前端开发当中扮演着重要角色，本文结合笔者近几年的实践经验，总结了使用`jQuery`过程当中容易被忽略的一些问题。

## jQuery对象和DOM对象

- DOM对象：通过原生javascript（如`getElementsByTagName`或`getElementId`）获取的html节点。

```javascript
var dom = document.getElementById("app") // 获取DOM对象
var html = dom.innerHTML; // 获取DOM元素内的HTML代码 
```

![](jquery/dom.png "通过document获取原生DOM对象")

- jQuery对象：被jQuery包装过的DOM对象

```javascript
var jq = $("#app"); // 获取jQuery对象
var html = jq.html(); // 获取jQuery对象内的HTML代码
```

![](jquery/jquery.png "jQuery对象的本质是数组")

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

提升选择器性能的有效途径是为选择器指定上下文，并以上下文为基础使用`first()`、`last()`、`find()`、`filter()`、`hasClass()`等jQuery筛选API。

下面对jQuery选择器的性能由高向低进行排序：

1. ID选择器

底层通过调用`document.getElementById()`实现。

```javascript
$("#id")
```

2. 标签选择器

底层通过调用`document.getElementsByTagName()`实现。

```javascript
$("input")
```

3. 类选择器

底层通过调用`document.getElementsByClassName()`实现。

```javascript
$(".class")
```

4. 属性及其它选择器

底层通过对HTML字符串进行正则表达式匹配来实现。

```javascript
$("[contenteditable]")
```

> jQuery底层有使用原生`document.querySelectorAll()`，可以有效提升IE8及以上浏览器当中选择器的性能。

> jQuery作者已经将选择器引擎独立为[Sizzle](http://sizzlejs.com/)库，而Sizzle会按照**从右到左**的顺序来解析选择器字符串，从而提高查询效率，缩小查找范围和遍历次数。

## 缓存常用的jQuery选择器对象

将需要常用的jQuery选择器对象赋值给一个局部或全局变量，是有效提升jQuery运行性能的良好开端。

```javascript
var $jq = $("#app");
$jq.find("div.tree").append("string");
$jq.find("[contenteditable].test").html();
$jq.find(".demo.test").html();
```

## 减少循环时的DOM操作

在`for`、`while`、`$.each()`等循环语句中，尽量减少DOM操作的次数，最好先将模板在循环中组装完成之后再一次性插入DOM。

```javascript
var $app = $("#app");
var template = "";
for (var i = 0; i <= 100; i++) {
  template += "<p>This is a paragraph!<p>"
}
$app.find("div").html(template);
```

## 使用原生方式处理jQuery数组

jQuery选择器的结果是一个数组类型的对象，建议使用`for`或`while`等原生语法对其进行处理，而非jQuery封装过的`$.each()`。

```html
<body>
  <div id="app">
    <div class="demo">1</div>
    <div class="demo">2</div>
    <div class="demo">3</div>
    <div class="demo">4</div>
    <div class="demo">5</div>
  </div>
</body>
```

```javascript
var $demo = $(".demo");
for (var i = 0; i < $demo.length; i++) {
  // 通过数组索引提取后，jQuery对象转换成DOM对象，所以这里使用了DOM对象的innerHTML属性
  console.info($demo[i].innerHTML);
}
```

可以通过关键字`length`检查数组长度，从而判断jQuery对象是否存在。

```javascript
var $demo = $(".demo");
if ($demo.length !== 0) {
  // do something
}
```

## 尽可能使用事件委托

jQuery3.x版本继续简化了事件委托函数，仅剩下`on()`、`off()`、`one()`、`trigger()`、`triggerHandler()`五个事件处理函数。

```html
<div id="app">
  <div id="parent">
    <p>parent</p>
    <div id="current">
      <p>current</p>
      <div id="child">child</div>
    </div>
  </div>
</div>
```

```javascript
/* on可以用于处理冒泡事件，但是无法捕获事件 */
$("#current").on("click", function () {
  console.info("current is clicked!");
});

$("#child").trigger("click");  // on可以处理向上冒泡的click事件

$("#parent").trigger("click");  // on无法捕获父级元素的click事件
```

> 单页面场景下绑定的`on`事件，必须在路由切换时通过`off`解除事件绑定，否则会造成大量无用的事件句柄堆积在内存。

## 通过extend()封装可复用代码

- `jQuery.extend()`：拓展**全局对象$**，例如下面例子中的`$.test()`，`$.demo()`;

- `jQuery.fn.extend()`：拓展**jQuery对象数组**，例如下面例子中的`$("div").test()`，`$("div").demo()`;

```javascript
(function ($) {
  /* 标准写法 */
  $.extend({
    test: function () {
      alert("$.extend");
    }
  });
  /* 简便写法 */
  $.demo = function () {
    // 返回全局对象$，便于链式调用
    return this;
  };
  /* 标准写法 */
  $.fn.extend({
    test: function () {
      alert("$.fn.extend");
    }
  });
  /* 简便写法 */
  $.fn.demo = function () {
    // 返回jQuery对象数组，便于链式调用
    return this;
  }
})(jQuery);
```

> 两种方式的最大区别在于自定义方法所属的宿主对象不同。

## 使用HTML5的data属性绑定数据

通过HTML5提供的data属性可以更加方便的完成数据绑定，特别是在不借助`handlebar`、`lodash.template()`等模板引擎的时候。

```html
<div id="app"
  data-number = 13.2
  data-string = "uinika"
  data-boolean = true
  data-null = null
  data-undefine = undefine
  data-object= '{"name": "hank"}'
  data-array= '["demo1", "demo2"]'>
</div>
```

```javascript
$("#app").data("number");
$("#app").data("string");
$("#app").data("boolean");
$("#app").data("null");
$("#app").data("undefine");
$("#app").data("object").name;
$("#app").data("array")[1];
```

## 尽量使用原生JavaScript

在不影响浏览器兼容性的情况下，尽量使用JavaScript原生API。

```javascript
var $demo = $(".demo");  // 缓存选择器

$demo.is(":checked");  // 通过jQuery封装过的is()方法
$demo[0].checked;  // 通过DOM原生的checked属性

$demo.css({"color": "red"});  // 通过jQuery封装过的css()方法
$demo[0].style.color = "red";  // 通过DOM原生的style.color属性

$("<p></p>");  // 通过jQuery新建<p>标签
$(document.createElement("p"));  // 通过DOM原生的createElement方法
```

## $(document).ready()

该函数内的代码会在DOM加载完毕后，内容（*如图片*）加载完成前执行；生产环境中，尽可能在每个js文件下使用该函数。

```javascript
$(document).ready(function () {
  // 标准写法
});

$(function () {
  // 简化写法
});
```

> JavaScript原生的`window.onload()`只会在DOM和图片等资源全部加载完成之后才执行。

## 延迟对象$.Deferred()

Deferred()是一个工厂函数，用来建立新的deferred对象（deferred [dɪ'fɜ:d] adj.延缓的），该对象上可以注册多个回调函数队列，这些函数的执行依赖于任意同步或者异步函数的执行结果（`sucess`或`failure`）。该对象可以视为jQuery版本的Promise实现，可以更加优雅的解决JavaScript回调嵌套的问题。

>  jQuery的Deferred对象是基于[CommonJS Promises/A](http://wiki.commonjs.org/wiki/Promises/A)规范设计的。

- deferred.notify()：触发Deferred上progress相关的回调函数。

- deferred.resolve()：Resolve一个Deferred对象，并触发resolve状态相关的回调函数。

- deferred.reject()：Reject一个Deferred对象，并触发reject状态相关的回调函数。

- deferred.progress()：该函数在Deferred对象生成progress通知时被调用。

- deferred.done()：该函数在Deferred对象被resolve时调用。

- deferred.fail()：该函数在Deferred对象被rejecte时调用。

- deferred.then()：Deferred对象resolved、rejected、progress时，都会被触发的回调函数。

> `$.ajax()`返回的就是一个deferred对象。



