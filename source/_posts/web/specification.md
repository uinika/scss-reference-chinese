---
title: Web前端开发遵循的一些规范与约定
tags: Zen
categories: Web
---

开发团队目前正在全面切换到`ES6  + Vue / React + Webpack`这套技术栈，小伙伴们开发过程中对编码方面的规范以及ES6使用上的约定存在诸多困惑，所以参考了Github以及互联网企业UED们的开源文档，结合团队之前积累的大量开发约定和范式，整理了这篇**code style**文档并且同样[开源](https://uinika.github.io/)出来，计划在team小伙伴们熟练掌握以后，逐步在项目中使用[ESLint](https://eslint.org/)校验代码风格。

![](specification/logo.jpg)

<!-- more -->

## 总体原则

1. **驼峰命名**（*camelCase*）：用于定义JavaScript`基本数据类型`、`函数方法`。
3. **帕斯卡命名**（*PascalCase*）：用于JavaScript声明`Class类`、`Object对象`、`Array数组`引用数据类型。
2. **短横线命名**（*kebab-case*）：用于自定义`HTML视图`、`SCSS样式`、`Assets资源`，即样式与视图相关的自定义元素都采用该方式命名。

```html
<template>
  <main id = 'app'>
    <section class = 'article-content'>
      <my-paragraph>kebab-case</my-paragraph>
    </section>
  </main>
<template>

<style>
#app {
  background: url(../assets/banner-logo.png);  // kebab-case
}
.article-content {  // kebab-case
  font-size: 18px;
}
</style> 

<script>
let currentDate = 'Tue Oct 10 2017 17:52:04 GMT+0800 (CST)';  // camelCase

const changeDate = function() {  // camelCase
  console.log(new Date());
};

const YourName = {  // PascalCase
  name: 'uinika'
};
</script>
```

> **所有代码的缩进必须使用2个空格**。

## JavaScript & ES6

本规范基于**爱彼迎**的[Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)代码规范进行制定，适用于使用Babel提供ES6预编译环境的场景。

### 命名原则

代码块的花括号`{`、流程控制语句的小括号`(`前必须放置**1个空格**，且每个函数、代码块之前通过换行进行分隔。

```javascript
class Hank {
  constrocter() {
    this.height = '182cm',
    this.weight = '75kg'
  }

  // 换行分隔代码块
  toString() {                         // 花括号前放置空格
    if (this.height && this.weight) {  // 小括号前放置空格
      console.info('toString');
    }
  }
}
```

不要在函数参数列表的前后添加**任何空格**，但是可以使用**1个空格**将JavaScript运算符分隔开，并且在每个代码文件末尾保留**1个空行**。

```javascript
// 函数参数列表前后不添加空格
((window)=>{
  var self = window; // 使用1个空格分隔运算符
})(window)
// 保留1个空行
```

使用美元符`$`作为存储**jQuery对象**变量名称的前缀。

```javascript
const menu = $('#menu');  // bad way

const $menu = $('#menu'); // good way
```

使用下划线`_`作为代码中**私有变量**的前缀，避免其它小伙伴操作该变量造成污染。

```javascript
function traverse(array) {
  let _index = 0;  // 将数组索引声明为私有变量，防止误操作导致索引泄露
  for(_index; array.length < _index; _index++ ) {
    console.log(array[_index]);
  };
};
```

> **严禁在项目中使用单字母和拼音命名的变量和函数名称**。

### 数据类型

- 基本数据类型: `String、Number、Boolean、null、undefined`，使用**let**进行定义，不再使用var。

- 引用数据类型：`Object、Array、Function`，引用数据类型全部通过**const**进行定义。

```javascript
let myBoolean = true;
let myNumber = 32;
let myString = 'this is a string';

const array = [0, 1, 2, 3, 4, 5];
const object = {a: 'a', b: 'b', c: 'c'};
```

> let和const都具有代码块级的作用域，书写时注意将两者进行分组。

### 对象

使用字面量语法创建对象，而不要使用`new`关键字。

```javascript
const myObject = new Object();  // not recommend

const myObject = {}  // it is correct
```

对象当中的方法使用**简写函数**、**简写属性**进行定义。

```javascript
let username = 'admin';
let password = 'admin';

vm.login = {
  username, password, // 简写属性
  // 简写函数
  auth(username, password) {
    // ... ...
  }
}
```

当对象中同时存在*简写属性*和*普通属性*时，需要将*简写属性*写到单独的组。

```javascript
vm.group = {
  // 简写属性
  username,
  password,
  isAuthorized,
  // 普通属性
  age: '20',
  height: 182,
  weight: 76,
  homeland: 'CHINA'
}
```

使用`.`运算符访问对象属性，或者使用`[]`通过变量访问属性。

```javascript
const user = {
  height: 182,
  weight: 75
}

console.info( user.height );
console.info( user['weight'] );
```

ES6中新出现的`class`关键字，实质是构造函数创建对象的一种糖衣语法，目的是更加容易的向对象添加原型方法。因此，建议尽可能使用`class`创建类及原型方法，避免在构造函数上使用`prototype`关键字。

```javascript
//定义类
class Point {
  // 构造函数
  constructor(x, y) {
    this.x = x;  // this指向实例对象
    this.y = y;
  }

  // 定义类方法不需要使用function关键字进行声明
  toString() {
    return this.x + this.y; 
  }
}
```

通过在`class`类方法上返回`this`对象，可以在该类的实例化对象上进行**链式**方法调用。

```javascript
class Hank {
  constructor(name, age) {
    this.age = age;
    this.name = name;
  }

  printName() {
    console.info(this.name);
    return this;
  }
  printAge() {
    console.info(this.age);
    return this;
  }
}

const hank = new Hank('uinika', 18);
hank.printName().printAge();
```

代码中尽可能使用`extends`实现继承，因为`extends`是ES6内建的**原型继承方法，不会对`instanceof()`的返回结果形成破坏。

```javascript
class Uinika extends Hank {
  constructor(height, weight) {
    super('uinika', 18);  // 实例化父级构造器
    this.height = height;
    this.weight = weight;
  }

  print() {
    console.log(this);  // 打印自己以及父级构造器当中的属性
  }
}
```

### 数组

- 使用字面量语法创建数组，而不要使用`new Array()`关键字。

```javascript
const myArray = new Array();  // not recommend

const myArray = [] // it is correct
```

- 添加数组元素时使用`Arrary.push()`，而不要使用索引赋值。

```javascript
const myArray = [];

myArray[myArray.length] = 'uinika'; // not recommend

myArray.push('uinika'); // it is correct
```

- 使用ES6的扩展运算符（*spread*）`...`复制数组。

```javascript
const target = ['A', 'B', 'C', 'D'];
const copy = [];

// not recommend
for (let index = 0; index < target.length; index++) {
  copy[i] = target[i];
}

// it's correct
const copy = [...target];
```

- 使用ES6提供的`Array.from()`方法将**类数组对象**（*同时具备索引和长度*）转换为数组。

```javascript
const myObject = {
  '0': 'A',
  '1': 'B',
  '2': 'C',
  length: 3
};

let myArray = Array.from(myObject); // ['A', 'B', 'C']
```

### 字符串

为避免频繁按下`shift+'`组合键，请在代码中尽可能使用单引号`'`声明字符串。

```javascript
const name = 'Hank';  // bad way
const name = 'Hank';  // good way
```

字符串过长时，必须通过`+`或者`\`运算符进行**换行**和**缩进**处理，让代码更加美观易读。

```javascript
// bad way
let bad = 'hank is first name and zheng is last name';

// good way
let good = 'hank is first name \
            and zheng is last name';

// best way
let best = 'hank is first name' 
         + 'and zheng is last name';
```

拼接字符串**HTML模板**时，请使用**模板字符串**`${}`，而非**字符串连接符**`+`。

```javascript
// bad
function sayHi(name) {
  return 'How are you, ' + name + '?';
}

// good
function sayHi(name) {
  return `How are you, ${name}?`;
}
```

### 函数

使用函数声明（*function declaration*）代替函数表达式（*function expression*），因为前者可以进行函数提升（*function hoisting*）。

```javascript
// bad
const bad = function () {};

// good
function good() {};
```

需要使用**函数表达式**、**匿名函数**的场景下，请直接使用箭头函数符号`=>`，这样可以在箭头函数内部创建新的`this`作用域。

```javascript
// 一个标准的箭头函数写法
(name, password) => {
  console.info(name, password);
}

// 箭头函数的简写形式
name => name + 'zheng'; 
```

使用箭头函数来书写**立即调用的函数表达式**（*IIFE，Immediately Invoked Function Expression*）。

```javascript
(() => {
  console.info('Hello Hank!');
})();
```

### 布尔运算

尽可能使用`===`和`!==`去同时比较**值**与**数据类型**，而非通过`==`和`!=`仅比较**值**。

```javascript
if(variable1 === '' && variable2 !== 0 ){
  console.info('just a test!');
}
```

各数据类型的布尔运算结果如下，使用`if()`等逻辑判断语句时需要注意。

1. 对象类型的`object`和`array`都计算为`true`，无论其是否为**空对象**`{}`或者**空数组**`[]`。
2. **空**字符串类型`''`计算为`false`，但**非空**字符串`'string'`计算为`true`。
3. 数字类型`NaN`和`0`计算为`false`。
4. `undefined`和`null`都是`false`。

``` javascript
if ([0]) {
  // 结果为true，因为JavaScript中object和array都同属对象类型，布尔运算时对象类型都会被渲染为true。
}
```

利用JavaScript逻辑判断语句的强制数据类型转换特性，可以更加简洁的书写布尔判断。

```javascript
if (name !== '') {} // bad
if (name) {}       // good

if (collection.length > 0) {}  // bad
if (collection.length) {}      // good
```

如果通过`if...else...`语句使用多行代码块，则`else`放在`if`代码块关闭括号`}`同一行。

```javascript
// bad job
if (test) {
  ...
}
else {
  ...
}

// good job
if (test) {
  ...
} else {
  ...
}
```

### 注释

- 使用`/** */`作为多行注释，用来标注全局功能模块的*名称*、*类型*、*参数*、*返回值*、*描述*等信息。

```javascript
/**
  * @name   auto-resize
  * @type   directive
  * @param  数值类型，表示缩进的像素值
  * @return null
  * @description 自动根据当前window大小计算页面的显示尺寸
  */
```

- 使用`/* */`作为单行注释，标注局部代码块的*参数*、*返回值*、*描述信息*。

```javascript
/* 
 * @param  用户输入字符串
 * @return null
 * @description 去除目标字符串全部空格
 */
function trim(input) {
  if (typeof input === 'string' && input)
    input.replace(/\s/g, '');
}
```

- 使用`// `作为行内注释，标记代码段信息。

```javascript
function trustHtml($sce) {
  return $sce.trustAsHtml(val);  //返回被信任的HTML字符串
};
```

> 使用`// TODO:`格式注释描述**问题本身**，使用`// FIXME:`格式注释描述**问题解决方式**。

```javascript
() => {
  issue();   // TODO: 描述问题本身的信息
  handle();  // FIXME: 描述如何解决问题
  return this;
}
```

### 解构赋值

通过解构赋值存取多属性对象，可以减少临时变量声明的数量。

```javascript
/* 对象的解构赋值 */
function getFullName1(user) {
  const name = user.name;        // bad way
  const password = user.password;
  return `${name} ${name}`;
}
function getFullName2(user) {
  const {name, password} = user; // good way
  return `${name} ${password}`;
}
function getFullName3({name, password}) {
  return `${name} ${password}`;  // best way
}

/* 对象的解构赋值 */
const array = [1, 2, 3, 4];
const array1 = array[0];         // bad way
const array2 = array[1];         // bad way
const [array1, array2] = array;  // good way
```

> 函数返回值时，直接返回对象`{}`而非数组`[]`，避免因为数组索引改变导致不能正确读取相应位置数据。


## CSS & SCSS

本规范借鉴**网易NEC**的[CSS基础库命名约定](http://nec.netease.com/)，结合当前开发团队多种CSS样式库混用的场景，在避免CSS选择器冲突的原则下制订，适用于通过Sass预处理器转译CSS的场景。

### 命名原则

- `reset.scss`：消除默认样式和浏览器差异，并设置部分标签的初始样式。

- `color.scss`：所有的取色必须来自公用的颜色列表，通过scss变量在其它文件中使用。

- `base.scss`：基础的公用样式，例如下面CSS选择器规范中定义的class shortcut。

- `skin.scss`: 使用全局UI插件的场景下，用来定制其组件补丁样式，或者以`skin-xx`方式命名多种自定义皮肤。

- `grid.scss`：基于class属性定义的CSS栅格系统，便于根据上下文语义去控制DOM结构。

### 布局选择器

| 语义 | 命名 | 简写 |
|:-----|:-----|:-----|
| 文档 | doc | doc |
| 头部 | head | hd |
| 主体 | body | bd |
| 尾部 | foot | ft |
| 主栏 | main | mn |
| 主栏子容器 | main-container | mcc |
| 侧栏 | side | sd |
| 侧栏子容器 | side-container | sdc |
| 盒容器 | wrap/box | wrap/box |

### 模块/组件选择器

| 语义 | 命名 | 简写 |
|:-----|:-----|:-----|
| 导航 | nav | nav |
| 子导航 | subnav | snav |
| 面包屑 | crumb | crm |
| 菜单 | menu | menu |
| 选项卡 | tab | tab |
| 标题区 | head/title | hd/tt |
| 内容区 | body/content | bd/ct |
| 列表 | list | lst |
| 表格 | table | tb |
| 表单 | form | fm |
| 热点 | hot | hot |
| 排行 | top | top |
| 登录 | login | log |
| 标志 | logo | logo |
| 广告 | advertise | ad |
| 搜索 | search | sch |
| 幻灯 | slide | sld |
| 提示 | tips | tips |
| 帮助 | help | help |
| 新闻 | news | news |
| 下载 | download | dld |
| 注册 | regist | reg |
| 投票 | vote | vote |
| 版权 | copyright | cprt |
| 结果 | result | rst |
| 标题 | title | tt |
| 按钮 | button | btn |
| 输入 | input | ipt |

### 功能选择器

| 语义 | 命名 | 简写 |
|:-----|:-----|:-----|
| 浮动清除 | clear-both | cb |
| 向左浮动 | float-left | fl |
| 向右浮动 | float-right | fr |
| 内联块级 | inline-block | ib |
| 文本居中 | text-align-center | tac |
| 文本居右 | text-align-right | tar |
| 文本居左 | text-align-left | tal |
| 垂直居中 | vertical-align-middle | vam |
| 溢出隐藏 | overflow-hidden | oh |
| 完全消失 | display-none | dn |
| 字体大小 | font-size | fs |
| 字体粗细 | font-weight | fw |

### 颜色/背景选择器

| 语义 | 命名 | 简写 |
|:-----|:-----|:-----|
| 字体颜色 | font-color | fc |
| 背景 | background | bg |
| 背景颜色 | background-color | bgc |
| 背景图片 | background-image | bgi |
| 背景定位 | background-position | bgp |
| 边框颜色 | border-color | bdc |

### 状态选择器

| 语义 | 命名 | 简写 |
|:-----|:-----|:-----|
| 选中 | selected | sel |
| 当前 | current | crt |
| 显示 | show | show |
| 隐藏 | hide | hide |
| 打开 | open | open |
| 关闭 | close | close |
| 出错 | error | err |
| 不可用 | disabled | dis |


## HTML

HTML标签的语义化有助于形成构架良好的DOM结构，有利于搜索引擎爬虫索引、抓取，也有利于不同设备显示的兼容性，以及团队的开发和维护工作。

### 整体结构

统一使用HTML5提供的`<!DOCTYPE html>`文档类型声明，并在`<head>`中使用`<link>`引入外部CSS文件，然后在`<body>`底部通过`<script>`引入JavaScript文件。
```html
<!DOCTYPE html>
<html lang='zh-CN'>

<head>
  <title>Aves</title>
  <meta name='renderer' content='webkit' />
  <meta http-equiv='X-UA-Compatible' content='IE=edge' />
  <meta http-equiv='content-type' content='text/html; charset=UTF-8' />
  <meta name='viewport' content='width=device-width, initial-scale=1' />
</head>

<body>
  <div id='app'>
    <main id='dashboard'></main>
  </div>
</body>

</html>
```
