---
title: Webpack深度剖析
tags: JavaScript
categories: Web
---

![](webpack/logo.png)

## Webpack3新特性ModuleConcatenationPlugin

附上[英文原文链接](https://webpack.js.org/plugins/module-concatenation-plugin/)。

过去webpack打包的时候，每个module都会被包装到独立的函数闭包，这些包装函数会让JavaScript在浏览器中执行更缓慢。经过比较，`Closure Compiler`和`RollupJS`提升、连接全部模块作用域到一个闭包的方式，会让代码在浏览器中执行得更加迅速。因此，Webpack3当中提供了如下plugin来开启类似特性。

```javascript
new webpack.optimize.ModuleConcatenationPlugin()
```

> Webpack3作用域提升的实现依赖于ECMAScript模块语法，因此Webpack会基于开发人员当前使用的模块系统回滚到过去的打包方式。

<!-- more -->

### 不使用ModuleConcatenationPlugin打包的文件

```bash
➜  bundles git:(master) ll
总用量 8.7M
-rw-rw-r-- 1 hank hank  24K 9月   6 11:44 0.210c1525bfe14cba4ee0.js
-rw-rw-r-- 1 hank hank  61K 9月   6 11:44 0.210c1525bfe14cba4ee0.js.map
-rw-rw-r-- 1 hank hank 5.9K 9月   6 11:44 1.d4b8545dc3dc93af7f6a.js
-rw-rw-r-- 1 hank hank  28K 9月   6 11:44 1.d4b8545dc3dc93af7f6a.js.map
-rw-rw-r-- 1 hank hank  765 9月   6 11:44 2.57378280a5698f76c576.js
-rw-rw-r-- 1 hank hank 6.4K 9月   6 11:44 2.57378280a5698f76c576.js.map
-rw-rw-r-- 1 hank hank 244K 9月   6 11:44 app.13fca0a1be03d8b4a15b.js
-rw-rw-r-- 1 hank hank 710K 9月   6 11:44 app.13fca0a1be03d8b4a15b.js.map
-rw-rw-r-- 1 hank hank 1.4K 9月   6 11:44 app.24004a5d2621177eb1e6bcdabc919636.css
-rw-rw-r-- 1 hank hank 1.9K 9月   6 11:44 app.24004a5d2621177eb1e6bcdabc919636.css.map
-rw-rw-r-- 1 hank hank 1.6K 9月   6 11:44 manifest.c3fe0dc0d40ea3fac1a5.js
-rw-rw-r-- 1 hank hank  15K 9月   6 11:44 manifest.c3fe0dc0d40ea3fac1a5.js.map
-rw-rw-r-- 1 hank hank 983K 9月   6 11:44 vendor.128582091fc1c542ae63.js
-rw-rw-r-- 1 hank hank 6.7M 9月   6 11:44 vendor.128582091fc1c542ae63.js.map
```

### 使用ModuleConcatenationPlugin打包的文件

```bash
➜  bundles git:(master) ✗ ll
总用量 8.7M
-rw-rw-r-- 1 hank hank  23K 9月   6 11:47 0.331a96e6fa24027ff29f.js
-rw-rw-r-- 1 hank hank  60K 9月   6 11:47 0.331a96e6fa24027ff29f.js.map
-rw-rw-r-- 1 hank hank 5.8K 9月   6 11:47 1.241c026697aa61a8ca09.js
-rw-rw-r-- 1 hank hank  27K 9月   6 11:47 1.241c026697aa61a8ca09.js.map
-rw-rw-r-- 1 hank hank  714 9月   6 11:47 2.731ff84fbfc108bc253b.js
-rw-rw-r-- 1 hank hank 5.9K 9月   6 11:47 2.731ff84fbfc108bc253b.js.map
-rw-rw-r-- 1 hank hank 1.4K 9月   6 11:47 app.24004a5d2621177eb1e6bcdabc919636.css
-rw-rw-r-- 1 hank hank 1.9K 9月   6 11:47 app.24004a5d2621177eb1e6bcdabc919636.css.map
-rw-rw-r-- 1 hank hank 244K 9月   6 11:47 app.d041e73d9c21f495b099.js
-rw-rw-r-- 1 hank hank 709K 9月   6 11:47 app.d041e73d9c21f495b099.js.map
-rw-rw-r-- 1 hank hank 1.6K 9月   6 11:47 manifest.46788d45af925b1aa79a.js
-rw-rw-r-- 1 hank hank  15K 9月   6 11:47 manifest.46788d45af925b1aa79a.js.map
-rw-rw-r-- 1 hank hank 983K 9月   6 11:47 vendor.154264c34d147a00c862.js
-rw-rw-r-- 1 hank hank 6.7M 9月   6 11:47 vendor.154264c34d147a00c862.js.map
```

> 文件尺寸的变化不大。


