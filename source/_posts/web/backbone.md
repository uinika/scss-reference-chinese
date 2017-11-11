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

![](backbone/intro-views.png "Backbone")


## 视图组件化

**视图组件化**是Vue、React、Angular2等现代化前端框架的基本思想，其主要目的是将复杂的DOM结构切割为更小粒度的HTML代码片段。Backbone通过`Backbone.View.extend()`继承函数来新建一个视图对象（*即组件*），该视图对象即可以使用`el`属性挂载到现有DOM，也可以通过`template`属性建立全新的视图对象。对Vue2比较熟悉的同学，应该会感觉到这样的写法与*Vue组件对象*非常相似。事实上Backbone视图对象不旦与Vue2，也与Angular2和React当中的**组件对象**作用极其类似，具体请参考下面的代码：

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
import Vue from 'vue';

new Vue({
  template: '<div>模板字符串<div>',

  data: {
    // 组件绑定的数据
  },
 
  methods: {
    myEvent() {
      // 组件自定义事件
    },
  },

});
```

```jsx
/* React组件对象 */
import React from 'react';
import ReactDOM from 'react-dom';

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

```typescript
/* Angular2组件对象 */
import { Component, Input } from '@angular/core';
import { Demo } from './demo';

@Component({
  selector: 'demo-detail',
  template: `
    <div>模板字符串</div>
  `
})
export class HeroDetailComponent {
  @Input() demo: Demo;
}
```

## 作用域控制

通过上面代码的比较，大家应该能够了解，Backbone视图对象的核心任务在于**DOM选择器、数据事件绑定的作用域控制**。Web前端组件化的过程，实质是可以认为是一个切割DOM的过程，切割DOM必然意味同时需要分离**事件**和**绑定数据**，并且控制视图对象上选择器的作用范围。

首先，Backbone的事件绑定机制源于JQuery的事件委托方法`on()`，Backbone仅仅将其封装成为一个简单明了的糖衣语法对象，集中注册当前视图对象上涉及的DOM事件，以及事件触发的选择器和事件类型。

```javascript
var View = Backbone.View.extend({
  id: "login",
  template: Handlebars.compile(Html),
  initialize: function () {},
  events: {
    "input": "checked",
    "click .btn": "login"
  },
  render: function () {
    this.$el.html(this.template());
    this.$(".rember-me").iCheck({
      checkboxClass: "icheckbox_square-blue",
      radioClass: "iradio_square-blue"
    });
    return this;
  },
  login: function () {
    var login = new Model();
    login.auth();
  }
});

return View;
```

其次，从DOM选择器的角度，上面Backbone对象当中所有需要对于DOM进行的操作，都封装到`this.$el()`或者`this.$()`函数上进行，核心目的就是为了控制JQuery选择器的作用域，防止选择器的互相污染，并提升选择器的效率。

## 数据绑定

Backbone原生的数据绑定需要依赖于underscore当中的`<%=...%>`表达式，但鉴于underscore模板表达式在书写循环语句时语法过于繁杂，因此在实际生产环境下，笔者采用了Handlebars模板引擎进行数据绑定，通过执行`template: Handlebars.compile(Html)`编译字符串模板，提供与Angular以及Vue当中Mustache表达式类似的开发体验。因为字符串模板编译后通过`this.$el.html(this.template())`插入当前视图对象，因此也就实质上完成了上面内容所提到的**数据绑定的作用域控制**。

```html
{{#each comments}}
  <h1>{{title}}</h1>
  <p>{{content}}</p>
{{/each}}
```

## MVVM与双向绑定

**MVVM**是*Model-View-ViewModel*的缩写形式，相比传统**MVC**模式的*Model-View-Controller*，最主要的区别在于将模型Model与视图View的绑定工作从控制器**Controller**，前置到视图模型对象**ViewModel**当中。**MVVM**这一概念最先由Angular1.x在Web前端开发当中提出，但是事实上Angular1.x仍然保留了Controller的存在，并严重依赖于其间接绑定`$scope`（*可以理解为Angular中的ViewModel*），这也正是笔者认为Angular1.x设计上的一个缺陷所在，一方面Controller的存在会让组件化工作进行得极其困难，另一方面为了抽象复用的业务逻辑，Angular不得不专门抽象出对应于Controller的Service服务层，而Web前端实际开发过程当中，大量的业务复用是基于DOM结构存在的，横向抽象出的Service层作用显得比较鸡肋，这也正是为什么虽然Angular提供了比Backbone更加完整的单页面应用开发体验，但笔者依然并未将其视为现代化前端开发当中组件化思想来源的原因所在。

![](backbone/intro-model-view.png 'MVVM')

视图模型对象**ViewModel**存在的意义，主要是为了更加清晰的进行**View->Model->View**数据绑定，Angular1.x默认对Mustache表达式执行双向绑定（*View和Model的数据双向映射，无需事先声明*），Vue2采用了单向绑定（*数据必须先在ViewModel中进行声明*）响应式数据更新（*View和Model都基于ViewModel中事先声明的数据进行映射*）。而Backbone和Handlebars默认是单向进行绑定，如果需要实现**View**和**Model**的双向数据映射，必须通过手动监听`Backbone.Model`对象上的`change`事件，并且在事件触发后立刻执行该视图对象上的`render()`渲染函数。

```javascript
var Model = Backbone.Model.extend({
  default: {
    cases: {}
  },
  initialize: function () {
    this.getCaseList();
  },
  getCaseList: function () {
    var self = this;
    Http.fetch({
        url: "/legal/verdict",
        method: "GET"
      })
      .then(function (data) {
        if (Http.verify(data, 200)) {
          self.set(data);
        }
      })
  }
});

var View = Backbone.View.extend({
  id: "demo",
  model: new Model(),
  initialize: function () {
    this.listenTo(this.model, 'change', this.render);
  },
  template: Handlebars.compile(Html),
  events: {},
  render: function () {
    this.$el.html(this.template(this.model.attributes));
    return this;
  }
});

return View;
```

上面代码中，首先设置视图对象的`model`属性，通过`new Model()`实例化当前代码内所继承的`Backbone.Model`对象。然后在当前视图对象的初始化函数`initialize`当中，通过Backbone视图对象上内置的`listenTo(this.model, 'change', this.render)`方法完成对模型的监听，并设置相应的回调渲染函数。从API使用的角度而言，**Backbone缺乏一个真实的ViewModel概念**，但是实际生产环境下，可以考虑将该视图对象所涉及的多个数据对象集中放置在一个`Model`内部处理，从而最大程度上模拟ViewModel作为视图和模型之间数据绑定介质的作用，虽然这样的灵活处理方式显得并不优雅。

## 前端路由

![](backbone/intro-routing.png "Router")


```javascript
var Router = Backbone.Router.extend({
  initialize: function () {
    this.app = $("#app");
  },
  routes: {
    '': "login",
    "login": "login",
    "dashboard": "dashboard",
  },
  login: function () {
    var loginView = new Login;
    this.app.html(loginView.render().$el);
  },
  layout: function () {
    this.layoutView = new Layout;
    return this.app.html(this.layoutView.$el);
  },
  // dashboard是嵌套视图
  dashboard: function () {
    var dashboardView = new Dashboard;
    this.layout().find("#main").html(dashboardView.render().$el);
  },
});

return Router;
```


## 模型与集合分离的缺陷

![](backbone/intro-collections.png "Collection")


## 僵尸视图问题

https://lostechies.com/derickbailey/2013/02/06/managing-events-as-relationships-not-just-references/


## 构建单页面应用

http://marionettejs.com/

https://github.com/walmartlabs/thorax

## 基于RequireJS模块化

```javascript
define([
  "snippets/login/script",
  "snippets/layout/script",
  "snippets/dashboard/script",
],
function (
  Login, Layout,
  Dashboard
) {
  var Router = Backbone.Router.extend({
    initialize: function () {
      this.app = $("#app");
    },
    routes: {
      '': "login",
      "login": "login",
      "dashboard": "dashboard",
    },
    login: function () {
      var loginView = new Login;
      this.app.html(loginView.render().$el);
    },
    layout: function () {
      this.layoutView = new Layout;
      return this.app.html(this.layoutView.$el);
    },
    dashboard: function () {
      var dashboardView = new Dashboard;
      this.layout().find("#main").html(dashboardView.render().$el);
    },
  });
  return Router;
});
```

```javascript
define([
    "backbone",
    "handlebars",
    "admin",
    "text!snippets/layout/view.html"
  ],
  function (Backbone, Handlebars, Admin, Html) {
    return Backbone.View.extend({
      id: "layout",
      initialize: function () {
        this.render();
      },
      template: Handlebars.compile(Html),
      events: {

      },
      render: function () {
        this.$el.html(this.template());
        return this;
      }
    });
  }
);
```


## 完整Demo

![](backbone/structure.png "项目结构")

```javascript
require.config({
  baseUrl: "/",
  paths: {
    /*----- core -----*/
    "text": "libraries/core/require.text",
    "domReady": "libraries/core/require.domReady",
    "admin": "libraries/theme/admin/js/app",
    "jquery": "libraries/core/jquery",
    "underscore": "libraries/core/underscore",
    "backbone": "libraries/core/backbone",
    "backbone.marionette": "libraries/core/backbone.marionette",
    "backbone.radio": "libraries/core/backbone.radio",
    "handlebars": "libraries/core/handlebars",
    "bootstrap": "libraries/theme/bootstrap/js/bootstrap",
    /*----- general -----*/
    "router": "snippets/router",
    "http": "general/http",
    "util": "general/util",
    /*----- widget -----*/
    "jquery.iCheck": "libraries/theme/widget/iCheck/icheck",
    "jquery.slimScroll": "libraries/theme/widget/slimScroll/jquery.slimscroll",
    /*----- plugin -----*/
    "jquery.webcam": "libraries/plugin/webcam/jquery.webcam"
  },
  map: {
    "*": {
      css: "libraries/core/require.css"
    }
  },
  shim: {
    /*----- core -----*/
    "underscore": {
      exports: "_"
    },
    "backbone": {
      deps: ["underscore", "jquery"],
      exports: "Backbone"
    },
    "backbone.radio": ["backbone"],
    "backbone.marionette": ["backbone.radio"],
    "bootstrap": ["jquery"],
    "admin": ["jquery", "bootstrap"],
    /*----- general -----*/
    "http": ["jquery"],
    "util": ["jquery"],
    /*----- plugin -----*/
    "jquery.iCheck": ["jquery", "css!libraries/theme/widget/iCheck/square/blue.css"],
    "jquery.slimScroll": ["jquery"],
    "jquery.webcam": ["jquery"]
  },
  waitSeconds: 0
});

require([
    /*----- core -----*/
    "backbone", "admin", "router", "backbone.marionette",
    /*----- general -----*/
    "http", "util",
    /*----- plugin -----*/
    "bootstrap", "jquery.slimScroll", "jquery.webcam"
  ],
  function (Backbone, Admin, Router) {
    var router = new Router();
    Backbone.history.start();
    // backbone debugger
    if (window.__backboneAgent) {
      window.__backboneAgent.handleBackbone(Backbone);
    }
  }
);
```

```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
  <title>Sparrow</title>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="icon" href="assets/favicon.ico" type="image/png" />
  <link href="libraries/theme/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
  <link href="libraries/theme/admin/css/AdminLTE.css" rel="stylesheet" />
  <link href="libraries/theme/admin/css/skins/skin-red.css" rel="stylesheet" />
  <link href="libraries/theme/animate.css" rel="stylesheet" />
  <link href="libraries/theme/awesome/css/font-awesome.css" rel="stylesheet" />
  <link href="bundle.css" rel="stylesheet" />
</head>

<body class="fixed sidebar-mini skin-red">
  <div id="app"></div>
  <script data-main="app" src="libraries/core/require.js"></script>
</body>

</html>
```