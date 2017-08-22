---
title: Angular最佳实践
tags: web
categories: All hands train
---

![](1-angular/angular.ico "Angular1.x")

## 为什么选择Angular


## 总体项目结构

![](1-angular/structure.png "Angular1.x")

## app.js

```javascript
"use strict";

(function () {

  angular.module("app", [
      // library
      "ngAnimate",
      "ngSanitize",
      "ui.router",
      "ui.bootstrap",
      // custom
      "app.common",
      "app.login",
      "app.layout",
    ])
    .config(config)
    .run(run)

  config.$inject = ["$qProvider", "$stateProvider", "$urlRouterProvider", "$httpProvider"];

  function config($qProvider, $stateProvider, $urlRouterProvider, $httpProvider) {};

  run.$inject = ["$rootScope"];

  function run($rootScope) {}

})();
```

## http.js

## controller.js

## service.js

## directive.js


