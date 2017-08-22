---
title: Angular最佳实践
tags: web
categories: All hands train
---

![](1-angular/angular.ico "Angular1.x项目结构")

## 为什么选择angular，而非react？

地


## how to use ?

## 项目结构

![](1-angular/structure.png "Angular1.x")

### index.html

```html

```

### app.js

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

  /* 配置块 */
  config.$inject = ["$qProvider", "$stateProvider", "$urlRouterProvider", "$httpProvider"];

  function config($qProvider, $stateProvider, $urlRouterProvider, $httpProvider) {};

  /* 运行块 */
  run.$inject = ["$rootScope"];

  function run($rootScope) {}

})();
```

### controller.js

### service.js

### directive.js

### http.js

