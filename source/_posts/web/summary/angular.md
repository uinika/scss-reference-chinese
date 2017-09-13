---
title: Angular1.x最佳实践总结
tags: Web
categories: Summary
---

![](angular/angular.ico)

## 为什么是Angular，而非React

早在2015年11月的时候，就已经开始尝试使用`webpack`+`babel`+`react`+`reflux`技术栈，但是团队对这种编译式前端开发的反馈并不友好，一方面 webpack1.x版本打包的效率仍然较差，每次保存操作后页面reload速度缓慢，比较影响开发过程中的心情愉悦指数。另一方面，team里的同学对于传统`jQuery`+`backbone`+`handlebar`+`requirejs`开发方式带有思维惯性，不太能接受JSX和ES6模块化的写法。

对于React的组件化思想，我个人是非常赞同的，但是比较遗憾的地方在于facebook并未提供出解决组件间通讯的官方实现，其Virtual DOM与Webpack.sourcemap结合使用后，debug变成一件非常困难的事情，并未在实际开发中体现其性能和效率上的优势。且因为社区驱动的reflux、redux的存在，又为开发带来了额外的复杂度。

<!-- more -->

**更具有决定因素的是，截至在2015年底，React依然是0.14.x版本，框架自身还处于不断成熟的过程中，API也一直在调整和变化。**

> 在React进入15.x版本之后，穿插使用其完成了一个称为[Saga](https://github.com/uinika/saga)的新项目，新增的context属性结合Redux使用，可以简化组件间通信不少的工作量。

早在2013年beta版发布的时候，Angular就被视为一件神奇的事物，虽然双向绑定的性能问题一直遭到开发人员诟病，但Google从2013年至今一直给予比较完善的支持，形成了成熟的API文档的同时，也提供了大量的最佳实践原则。而Gulp这样基于事件流的前端自动化工具的兴起，简化了前、后端技术架构分离后，前端宿主环境的开发、打包、模拟数据的问题。

**虽然2016年上半年Angluar2已经展露头角，但是从技术成熟度的角度考量，还是最终决定使用Angular1.x。**

截至到目前为止，前端小组的同学已经使用Angular近1年半的时间，其间经历了5个项目、2款产品的考验，积累了许多实践经验，仅在这里做一些总结和分享。

> 2017年，Webpack2、Vue2、Angular4的相继发布，编译式的前端开发已经成为大势所趋，且单页面场景下Angular在性能和组件化解耦方面暴露出非常多不足，目前勤智的前端小组正在全面转向Vue2。

## 项目结构

目录build、release主要放置编译、打包压缩后的前端代码，mocks里是基于express编写的模拟restful接口，与前端页面服务分处于不同端口不同域下，因此express中需要进行CORS跨域处理。partials目录下是全部工程代码，内部模块组织结构如下：

![](angular/structure-global.png "整体结构")

将javascript业务、css样式、html表现分离开编写，css采用Less进行预编译，使用gulp先合并全部Less后再处理成css，便于colors、resets等变量全局共享。使用`script.`、`style.`、`view.`前缀便于在vscode或atom中组织代码层次，以体现更加直观、优雅的项目结构。

![](angular/structure-module.png "模块结构")

## Index索引页

一个非常传统的index.html，但是内置了URL的配置模块，方便实施人员根据现场服务环境，对后端URL地址进行修改。但更好的实践是单独将其作为一个config.js文件外部引入，代价是需要调整打包策略，避免gulp对config.js进行代码混淆和压缩操作。

```html
<!DOCTYPE html>
<html lang="zh-CN" ng-app="app" ng-strict-di>

<head>
  <title>Angular Demo</title>
  <meta name="renderer" content="webkit" />
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="icon" href="assets/favicon.ico" type="image/png" />
  <!-- base -->
  <link href="libraries/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
  <link href="libraries/animate/animate.min.css" rel="stylesheet" />
  <!-- jquery plugin -->
  <link href="libraries/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
  <link href="libraries/admin/css/AdminLTE.css" rel="stylesheet" />
  <link href="libraries/admin/css/skins/skin-red-light.css" rel="stylesheet" />
  <!-- angular plugin -->
  <link href="libraries/angular-tree-control/css/tree-control.css" rel="stylesheet" />
  <link href="libraries/angular-ui-tree/angular-ui-tree.min.css" rel="stylesheet" />
  <!-- bundle -->
  <link href="bundles/styles.css" rel="stylesheet" />
</head>

<body class="fixed skin-red-light layout-top-nav">
  <div id="app" ui-view></div>
  <!-- base -->
  <script src="libraries/jquery/jquery.min.js"></script>
  <script src="libraries/lodash/lodash.min.js"></script>
  <script src="libraries/moment/moment-with-locales.min.js"></script>
  <!-- jquery plugin -->
  <script src="libraries/bootstrap/js/bootstrap.min.js"></script>
  <script src="libraries/admin/js/app.js"></script>
  <script src="libraries/jquery-fastclick/fastclick.min.js"></script>
  <script src="libraries/jquery-slimscroll/jquery.slimscroll.min.js"></script>
  <!-- angular -->
  <script src="libraries/angular/angular.js"></script>
  <script src="libraries/angular/angular-animate.js"></script>
  <script src="libraries/angular/angular-messages.js"></script>
  <script src="libraries/angular/angular-aria.js"></script>
  <script src="libraries/angular/i18n/angular-locale_zh-cn.js"></script>
  <script src="libraries/angular/angular-sanitize.js"></script>
  <!-- angular plugin -->
  <script src="libraries/angular-router/angular-ui-router.js"></script>
  <script src="libraries/angular-ui-select/select.min.js"></script>
  <script src="libraries/angular-ui/ui-bootstrap-tpls.js"></script>
  <!-- bundle -->
  <script>
    angular.module("app.common", []).constant("URL", {
      "master": "http://192.168.13.77:8081/test"
      "slave": "http://192.168.13.77:8080/test"
    });
  </script>
  <script src="bundles/scripts.js"></script>
</body>

</html>
```

## App启动点

该文件是整个项目的程序入口点，gulp自动化压缩后会作为bundle.js文件最顶部的一段代码，因此这里开启Javascript严格模式后全局有效。每个js文件都使用立即调用函数表达式**IIFE**（*Immediately-Invoked Function Expression*）进行封装，防止局部变量泄露到全局。`run`和`config`代码块编写为函数名称进行引用，从而避免JS函数过度嵌套后，影响代码的可读性。

```javascript
"use strict";

(function () {

  angular.module("app", [
      // library
      "ngAnimate", "ngSanitize", "ui.router", "ui.bootstrap",
      // custom
      "app.common", "app.login", "app.layout",
    ])
    .config(config)
    .run(run)

  /* config block */
  config.$inject = ["$qProvider", "$stateProvider", "$urlRouterProvider", "$httpProvider"];

  function config($qProvider, $stateProvider, $urlRouterProvider, $httpProvider) {};

  /* run block */
  run.$inject = ["$rootScope"];

  function run($rootScope) {}

})();
```

## Module模块

为了更直观的体现**Angular模块化**的概念，会将如下代码新建为单独的`a.module.js`文件，主要用于模块的依赖声明，以及嵌套路由配置。其中，路由使用了[ui-router](https://github.com/angular-ui/ui-router/wiki)提供的方案，父级路由使用`abstract`属性和`template:"<ui-view/>"`来实现与子路由的松耦合。

Angular module中的路由配置是整份前端代码的切割点，通过它完成了整个单页面应用在源码层面的文件切分。更重要的是，通过`controllerAs`的使用，在接下来的控制器中，通过`this`指针代替传统`$scope`的写法，有助于避免在有嵌套的controller中调用`$parent`，有效防止作用域污染的发生。

```javascript
(function () {
  
  angular
    .module("app.template", []);

  angular
    .module("app.template")
    .config(templateConfig);

  templateConfig.$inject = ["$stateProvider"];

  function templateConfig($stateProvider) {
    $stateProvider
      .state("template", {
        parent: "layout",
        abstract: true,
        url: "/template",
        template: "<ui-view/>"
      })
      // Judged
      .state("template.judged", {
        parent: "template",
        url: "/judged",
        templateUrl: "partials/template/judge/view.html",
        controller: "TemplateJudgeController",
        controllerAs: "Judge"
      })
      // Trial
      .state("template.trial", {
        parent: "template",
        url: "/trial",
        templateUrl: "partials/template/trial/view.html",
        controller: "TemplateTrialController",
        controllerAs: "Trial"
      })
  }

})();
```

## Controller控制器

控制器中，通过`$inject属性注解`手动实现依赖注入，避免代码压缩合并后出现依赖丢失的情况。将`this`指针赋值给`vm`对象（view model），其它方法和属性都以子对象的形式挂载到vm下面，使其更加整洁和面向对象。

由于Angular会自动绑定未在HTML中声明的属性，因此约定将所有双向绑定属性声明到vm对象当中，且通过赋予其默认值来表达所属数据类型。

> 下面代码中的`activate()`函数主要用来放置controller的初始化逻辑。

```javascript
(function () {

  angular
    .module("app.login")
    .controller("LoginController", LoginController);

  LoginController.$inject = ["loginService", "$state", "verify", "$uibModal", "$scope"];

  function LoginController(loginService, $state, verify, $uibModal, $scope) {
    var vm = this;

    // initialization
    function activate() {};

    // two-way data binding on view
    vm.account = {
      username: "",
      password: "",
      message: "",
      onSubmit: function () {
        loginService.auth({
            username: vm.account.username,
            password: vm.account.password
          })
          .then(function (result) {
            if (loginService.validate(result)) {
              vm.account.message = result.message;
            }
          })
      }
    };

    // initialization function invoked
    activate();
  };

})();
```

## Service服务

主要用来放置数据操作和数据交互的逻辑，例如：*负责XHR请求、本地存储、内存存储和其它任何数据操作*。最后，Service通过返回一个对象来组织这些服务。通常情况下，项目每个模块只拥有一个controller，但是可以存在多个service，Angular的设计理念就是寄希望通过service来完成业务的复用，这一点主要继承了传统MVC的分层思想。

> Angular的service总是单例的，这意味每个`injector`都只有一个实例化的`service`。

```javascript
(function () {

  angular
    .module("app.login")
    .service("loginService", loginService);

  loginService.$inject = ["$http", "URL"];

  function loginService($http, URL) {
    var path = URL.master;
    return {
      auth: function (data) {
        return $http.post(
            path + "/login", data
          )
          .catch(function (error) {
            console.error(error);
          })
      },
      validate: function () {
        // it is a login validator
      }
    }
  };

})();
```

## Directive指令

指令的命名需要使用一个短小、唯一、具有描述性的前缀（*比例企业名称*），可以通过在指令配置对象中使用`controllerAs`属性，取得与控制器中vm同样的用法，

> 使用controllerAs属性时，如果需要把父级作用域绑定到指令controller属性指定的作用域时，可以使用`bindToController=true`。

```javascript
(function () {

  /**
   * @type directive
   * @name wiserv-scroll
   * @param wiserv-scroll-offset
   * @description auto resize base on overflow-y
   */
  angular.module("app.common")
    .directive("wiservScroll", wiservScroll);

  wiservScroll.$inject = ["$window", "$document"];

  function wiservScroll($window, $document) {
    return {
      restrict: "ACE",
      scope: {
        offset: "@wiservScrollOffset"
      },
      link: function link(scope, element, attrs) {
        var _window = $($window);
        var _document = $($document);
        var _offset = $window.parseInt(scope.offset);

        format();

        _window.resize(function () {
          format();
        })

        function format() {
          // scroll
          element.css({
            "overflow-y": "scroll"
          });
          // size
          var contentHeight = _window.height() || 0;
          var navbarHeight = _document.find(".main-header").outerHeight() || 0;
          var boxheaderHeight = _document.find(".box-header").outerHeight() || 0;
          // calculate
          element.outerHeight((contentHeight - navbarHeight - boxheaderHeight) - _offset);
        }
      }
    };
  };

  /**
   * @type directive
   * @name slim-scroll
   * @param slim-scroll-offset slim-scroll-width slim-scroll-color slim-scroll-edge
   * @description auto resize base on slimscroll
   */
  angular.module("app.common")
    .directive("slimScroll", slimScroll);

  slimScroll.$inject = ["$window", "$document"];

  function slimScroll($window, $document) {
    return {
      restrict: "ACE",
      scope: {
        height: "@slimScrollOffset",
        size: "@slimScrollWidth",
        color: "@slimScrollColor",
        distance: "@slimScrollEdge"
      },
      link: function link(scope, element, attrs) {
        var _window = $($window);
        var _document = $($document);
        // property
        var _height = $window.parseInt(scope.height);
        var _size = scope.size ? (scope.size + "px") : ("6px");
        var _color = scope.color ? (scope.color + "") : ("red");
        var _distance = scope.distance ? (scope.distance + "px") : ("0px");

        format();

        _window.resize(function () {
          format();
        });

        function format() {
          // size
          var contentHeight = _window.height() || 0;
          var navbarHeight = _document.find(".main-header").outerHeight() || 0;
          var boxheaderHeight = _document.find(".box-header").outerHeight() || 0;
          // calculate
          element.slimScroll({
            height: ((contentHeight - navbarHeight - boxheaderHeight) - _height) + "px",
            color: _color,
            size: _size,
            distance: _distance,
            alwaysVisible: true
          });
        };

      }
    };
  };
})();
```

## Filter过滤器

过滤输出给用户的表达式值，可用于`view`、`controller`、`service`。

```javascript
(function () {

  angular.module("app.common")
    .filter("trim", trim);

  trim.$inject = ["$sce"];

  function trim($sce) {
    return function (input) {
      if (typeof input === "string" && input)
        input.replace(/\s/g, "")
      return out;
    }
  };

})();
```

> 最佳实践是只通过filter筛选指定的对象属性，而非扫描对象本身，避免带来糟糕的性能问题。

## JWT权限控制

为了适配移动端浏览器，采用JWT（*JSON Web Token，一种JSON风格的轻量级的授权和身份认证规范*）作为前后端交互时的权限控制协议。主要是考虑前后端分离之后，在不借助cookie和session的场景下（*部分移动端浏览器未实现相关特性*），使浏览器端发起的每个HTTP请求都能正确携带权限信息，以便于服务器端进行有效行拦截。

单页面场景下，权限认证需要关注如下3个核心问题：

1. 登陆校验成功后，持有服务器端生成的token令牌。
2. 每次HTTP请求都需要持有该token令牌的信息。
3. 登陆超时和访问未授权页面的处理（通常为跳转）。

> 如下代码为项目入口点`config代码块`的配置，用于获取并放置token令牌，以及处理登陆超时的跳转。

```javascript
config.$inject = ["$qProvider", "$stateProvider", "$urlRouterProvider", "$httpProvider"];

function config($qProvider, $stateProvider, $urlRouterProvider, $httpProvider) {
  $qProvider.errorOnUnhandledRejections(false);
  $urlRouterProvider.otherwise("/login");
  $stateProvider
    .state("login", {
      url: "/login",
      templateUrl: "partials/login/view.html",
      controller: "LoginController",
      controllerAs: "Login"
    })
    .state("layout", {
      url: "/layout",
      templateUrl: "partials/layout/view.html",
      controller: "LayoutController",
      controllerAs: "Layout"
    })

  /** HTTP Interceptor */
  $httpProvider.interceptors.push(interceptor);
  interceptor.$inject = ["$q", "$location"];

  function interceptor($q, $location) {
    return {
      "request": function (config) {
        var token = sessionStorage.token;
        if (token) {
          config.headers = _.assign({}, {
            "Authorization": "Wiserv " + token
          }, config.headers)
        };
        return config;
      },
      "response": function (response) {
        $q.when(response, function (result) {
          if (response.data && response.data.head && typeof response.data === "object") {
            if (result.data.head.status === 202) {
              sessionStorage.message = "登录超时，请重新登录！";
              $location.url("/wiserv");
            };
          };
        });
        return response;
      }
    };
  };

};
```

> 如下代码为项目入口点`run代码块`的配置，主要是处理未登陆访问授权页面的跳转。

```javascript
run.$inject = ["$rootScope"];

function run($rootScope) {
  // router listener
  $rootScope.$on("$stateChangeStart",
    function (event, toState, toParams, fromState, fromParams) {
      if (toState.name !== "login") {
        if (!sessionStorage.token) {
          window.location.href = "/wiserv";
        };
      };
    });
};
```

## Module中的Run和Config

Run和Config分别是Aangular模块加载的2个生命周期：

1. **Config**：首先执行的是Config阶段，该阶段发生在provider注册和配置的时候，主要用于连接并注册好所有数据源，因此**provider**、**constant**都可以注入到Config代码块中，但是其它不确定是否初始化完成的服务不能注入进来。
2. **run**：其次开始进入Run阶段，该阶段发生在injector创建完成之后，主要用于启动应用，是Angular中最接近C语言main方法的概念。为了避免在模块启动之后再进行配置操作，所以只允许注入**service**、**value**、**constant**。

## $location的配置

`$location`服务是Angular对浏览器原生`window.location`的封装，可以通过`$locationProvider`进行配置。

```javascript
$locationProvider.html5Mode(true).hashPrefix("*");
```

- **Hashbang模式**：`http://localhost:5008/#!/login?user=hank`
- **HTML5模式**：`http://localhost:5008/login?user=hank`

> Hashbang是指由`#!`构成的字符串，类UNIX系统会将Hashbang后内容作为解释器指令进行解析。

## 跨控制器的事件交互

当Angular当中同一张页面存在多个控制器时（*例如使用了嵌套路由*），可以通过scope的事件机制进行通信。

- `$scope.$on(name, listener);` 监听给定类型的事件。
- `$scope.$emit(name, args);` 向**上**派发事件，可以携带参数。
- `$scope.$broadcast(name, args);` 向**下**派发事件，可以携带参数。

```javascript
// 事件广播
$scope.$broadcast("SEARCH", vm.search.input);

// 监听事件
function activate() {
  $scope.$on("SEARCH", function (event, data) {
    vm.menu.fetch();
  });
};
```

> 事件相关的处理（*即`$on()`方法*），可以统一写在每个控制器的初始化方法`activate()`当中。

## Angular的HTML模板编译步骤

Angular中HTML模板的编译会经历下面3个步骤：

1. $compile遍历DOM查找匹配的Angular指令。

2. 当DOM上的所有指令被识别，`$compile`会按其`priority`属性的优先级进行排序，接下来指令的`compile`函数被执行（*每个compile函数都拥有1次修改DOM的机会*），每一条指令的`compile`函数都将返回一个`link`函数，这些函数最后会被合并到一个统一的链接函数当中。

3. `$compile`通过这个被合并的链接函数，依次调用每个指令的`link`函数，注册监听器到HTML元素，以及在`scope`中设置`$watch`，最后完成`scope`和`template`的双向绑定。

![](angular/two-way-data-binding.png "双向数据绑定")

```javascript
var $compile = ...; // injected into your code
var scope = ...;
var parent = ...; // DOM element where the compiled template can be appended

var html = "<div ng-bind="exp"></div>";

// Step 1: parse HTML into DOM element
var template = angular.element(html);

// Step 2: compile the template
var linkFn = $compile(template);

// Step 3: link the compiled template with the scope.
var element = linkFn(scope);

// Step 4: Append to DOM (optional)
parent.appendChild(element);
```

> 上面是Angular官方文档中非常具有信息量的一段demo代码。

## 指令complie()和link()的区别

将compile和link分为两个阶段主要是出于性能的考虑，让多次Model的变化只引发一次DOM结构的改变。

- `compile()`：对HTML模板自身进行转换，仅在编译阶段执行一次。

```javascript
function compile(tElement, tAttrs, transclude) {
  return {
    pre: function preLink(scope, iElement, iAttrs, controller) { ... },
    post: function postLink(scope, iElement, iAttrs, controller) { ... }
  }
  // or
  return function postLink( ... ) { ... }
}
```

- `link()`: 在View和Model之间进行动态关联，将会被执行多次，只能在未定义`compile`的场景下使用。

```javascript
function link(scope, iElement, iAttrs, controller, transcludeFn) {
  link: {
    pre: function preLink(scope, iElement, iAttrs, controller) { ... },
    post: function postLink(scope, iElement, iAttrs, controller) { ... }
  }
  // or
  link: function postLink( ... ) { ... }
}
```

## $digest循环

Angular增强了浏览器原生的事件循环（*event loop*）机制，将事件循环分为**JavaScript原生**和**Angular可执行上下文**两部分，只有进入Angular可执行上下文才能够使用双向数据绑定、异常处理、属性观察等特性。

可以在JavaScript中通过`$apply()`方法进入到Angular可执行上下文，在大多数`controller`、`service`当中`$apply()`已经被隐式的调用，只有在整合第3方类库需要自定义事件时才会显式使用`$apply()`。

![](angular/event-loop.png "事件循环")

1. 调用`scope.$apply(stimulusFn)`进入Angular可执行上下文，作为参数的stimulusFn函数就是需要运行在Angular可执行上下文内的代码。
2. Angular执行stimulusFn()函数，该函数通常会对应用状态进行修改。
3. Angular进入$digest循环，$digest循环又分为$evalAsync队列和$watch列表2个较小的循环。$digest循环会迭代执行直到Model状态稳定下来，即$evalAsync队列为空且$watch列表中检测不到任何变化的时候。
4. $evalAsync队列主要用来异步处理Angular执行上下文之外的任务（*例如基于当前scope对表达式进行异步渲染*），这一过程将会发生在浏览器视图渲染之前，从而避免视图闪烁。
5. $watch列表是一个在最后一次迭代之后，依然可能发生变化的表达式集合。一旦检测到变化发生，`$watch()`函数将会被调用，并使用改变后的值对DOM进行更新。
6. 当$digest循环结束后，执行流程离开Angular和JavaScript上下文。

综上所述，$digest循环作为Angular的脏值检查机制，繁重的实现过程造成其性能开销较大。因此，视图层绑定数据时，最佳实践原则是尽量使用`::`一次性绑定，以便减少不必要的$digest循环。

```html
<span>{{::username}}</span>
```

## 如何理解Provider

Provider用于创建可以由injector依赖注入的服务，Provider需要通过auto模块中的$provide服务进行创建，Provider拥有`provider()`、`value()`、`factory()`、`service()`、`constant()`、`decorator()`六种创建方式。

![](angular/provider.png "$provide")

1. `provider(name, provider)` 该方式必须实现一个`$get`方法，是其它Provide创建方式的核心（*不包括Constant*）。
2. `constant(name, obj)` 定义常量，可以被注入到任何地方，但是不能被decorator装饰，也不能被注入其它service。
3. `value(name, obj)` 可以是任意数据类型，不能被注入到config，但可以被decorator装饰。
4. `factory(name, fn)` 创建可注入的普通函数，可以return任意值，实质是只拥有$get方法的provider。
5. `service(name, Fn)` 创建可注入的构造函数，调用时会通过`new`关键字，可以不用return任何值，它在AngularJS中是单例的。
6. `decorator(name, decorFn)` 用来装饰其他provider，可以中断服务的创建流程，然后重写或者修改服务的行为。但Constant不能被装饰，因为Constant并非provider()创建。

```javascript
(function () {

  var module = angular.module("app.test", [])
    .config(testConfig)
    .controller("TestController", TestController);

  /* Config */
  testConfig.$inject = ["$provide"];

  function testConfig($provide) {

    // 模块上定义provider
    var provider = $provide.provider("message", function () {
      var message;
      return {
        setMessage: function (infomation) {
          message = infomation;
        },
        $get: function () {
          return {
            infomation: "This is a " + message
          }
        }
      }
    });
    provider.setMessage("Provider!"); // 设置Provider需要返回的消息

    // config中定义factory
    $provide.factory("factory", function () {
      return {
        reminder: "This is a Factory!"
      }
    });
    // config中定义service
    $provide.service("service", function () {
      this.warning = "This is a Service!";
    });

    // config中定义constant
    $provide.constant("CONSTANT", "This is a Constant!");
    // config中定义value
    $provide.value("value", "This is a Value!");

    // config上定义decorator
    $provide.decorator("value", decorator);
    decorator.$inject = ["$delegate"]; // $delegate是需要被修饰服务的实例，即上面语句中声明的value
    function decorator($delegate) {
      return $delegate + " with Decorator!!"; // 对value进行修饰
    };

  };

  /* Controller */
  TestController.$inject = ["message", "CONSTANT", "value", "factory", "service"];

  function TestController(message, CONSTANT, value, factory, service) {
    console.info(message.infomation); // controller中调用provider
    console.info(CONSTANT); // controller中调用constant
    console.info(value); // controller中调用value
    console.info(factory.reminder); // controller内调用factory
    console.info(service.warning); // controller内调用service
  };

  /**
   * This is a Provider!
   * This is a Constant!
   * This is a Value! with Decorator!!
   * This is a Factory!
   * This is a Service!
   */

})();
```

除了在config当中通过`$provide`定义provider之外，还可以通过module上提供的语法糖方法更加方便的建立provider，出于代码松耦合以及分块编写的考虑，这里推荐使用语法糖的方式去提供provider。

```javascript
(function () {

  var module = angular.module("app.test", [])
    .config(testConfig)
    .controller("TestController", TestController);

  testConfig.$inject = ["$provide", "messageProvider"];

  function testConfig($provide, messageProvider) {
    messageProvider.setMessage("Provider!"); // provider可以被注入到config中
  };

  // module上定义provider
  module.provider("message", function () {
    var message;
    return {
      setMessage: function (infomation) {
        message = infomation;
      },
      $get: function () {
        return {
          infomation: "This is a " + message
        }
      }
    }
  });

  // module上定义factory
  module.factory("factory", function () {
    return {
      reminder: "This is a Factory!"
    }
  });

  // module上定义service
  module.service("service", function () {
    this.warning = "This is a Service!";
  });

  module.constant("CONSTANT", "This is a Constant!"); // module上定义constant
  module.value("value", "This is a Value!"); // module上定义value

  // module上定义decorator
  module.decorator("value", decorator);
  decorator.$inject = ["$delegate"];

  function decorator($delegate) {
    return $delegate + " with Decorator!!";
  };

  TestController.$inject = ["message", "CONSTANT", "value", "factory", "service"];

  function TestController(message, CONSTANT, value, factory, service) {
    // controller当中调用各个provider
    console.info(message.infomation);
    console.info(CONSTANT);
    console.info(value);
    console.info(factory.reminder);
    console.info(service.warning);
  };

  /**
   * This is a Provider!
   * This is a Constant!
   * This is a Value! with Decorator!!
   * This is a Factory!
   * This is a Service!
   */

})();
```

## Angular当中的$q

一个promises/deferred对象的Promises/A+兼容实现，受到[Kris Kowal"s Q](https://github.com/kriskowal/q)启发但并未实现全部功能，$q能够以如下2种流行的方式进行使用。

1. Kris Kowal"s Q或者jQuery的Deferred对象：首先通过`$q.defer()`创建一个deferred对象，然后通过deferred对象的promise属性转换为Promise对象。

```javascript
function asyncGreet(name) {
  var deferred = $q.defer();

  setTimeout(function() {
    deferred.notify("About to greet " + name + ".");
    if (okToGreet(name)) {
      deferred.resolve("Hello, " + name + "!");
    } else {
      deferred.reject("Greeting " + name + " is not allowed.");
    }
  }, 1000);

  return deferred.promise;
}
```

2. 类似ES6原生Promise的方式：$q作为构造函数，接收`resolver()`函数作为第1个参数，`$q(resolver)`将会返回一个新建的Promise对象。
 
```javascript
$q(function(resolve, reject) {
  setTimeout(function() {
    if (okToGreet(name)) {
      resolve("Hello, " + name + "!");
    } else {
      reject("Greeting " + name + " is not allowed.");
    }
  }, 1000);
});
```

> 出于team逐步向ES6标准演进的考虑，这里推荐使用ES6原生风格的Promise写法。

## 不容忽视的$sce服务

$sce用于在Angular中提供严格的上下文转义（*SCE, Strict Contextual Escaping*）服务，从而避免XSS（*跨站脚本攻击*）, clickjacking（*点击劫持*）等安全性问题，$sce服务目前支持的上下文类型有5种。

```javascript
(function () {

  angular.module("app.common")
    .filter("wiservTrustHtml", wiservTrustHtml);

  wiservTrustHtml.$inject = ["$sce"];

  function wiservTrustHtml($sce) {
    return function (val) {
      return $sce.trustAsHtml(val);
    };
  };

})();
```

> 最佳实践原则，项目中所有用户可以自由进行编辑的位置，都需要通过`$sce`进行无害化处理。