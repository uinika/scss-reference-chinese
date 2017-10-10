---
title: Web前端开发遵循的一些规范与约定
tags: Zen
categories: Web
---

开发团队目前正在全面切换到`ES6  + Vue / React + Webpack`这套技术栈，小伙伴们开发过程中对编码方面的规范以及ES6使用上的约定存在诸多困惑，所以参考了Github以及互联网企业UED们的开源文档，结合团队之前积累的大量开发约定和范式，整理了这篇**code style**文档并且同样[开源](https://uinika.github.io/)出来，计划在team小伙伴们熟练掌握以后，开始逐步在项目中开启[ESLint](https://eslint.org/)校验。

## JavaScript & ES6

基于爱彼迎的[Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)代码规范进行整理，适用于使用Babel提供ES6预编译环境的场景。

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

> let和const都具有代码块级的作用域。

<!-- more -->

### 对象

- 使用字面量语法创建对象，而不要使用`new`关键字。

```javascript
const myObject = new Object();  // not recommend

const myObject = {}  // it is correct
```

- 对象当中的方法使用**简写函数**、**简写属性**进行定义。

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

当对象中同时存在简写属性和普通属性时，需要将简写内容进行分组。

```javascript
vm.group = {
  // 简写属性
  username,
  password,
  isAuthorized,
  // 普通属性
  age: "20",
  height: 182,
  weight: 76,
  homeland: "CHINA"
}
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

const hank = new Hank("uinika", 18);
hank.printName().printAge();
```

代码中必须使用`extends`实现继承，因为`extends`是ES6内建的原型继承方法，不会对`instanceof()`的返回结果形成破坏。

```javascript
class Uinika extends Hank {
  constructor(height) {
    this.height = height;
  }
  print() {
    console.log(this);
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
const target = ["A", "B", "C", "D"];
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

为避免频繁按下`shift+"`组合键，请在代码中尽可能使用单引号`'`声明字符串。

```javascript
const name = "Hank";  // bad way
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
name => name + "zheng"; 
```

使用箭头函数来书写**立即调用的函数表达式**（*IIFE，Immediately Invoked Function Expression*）。

```javascript
(() => {
  console.info('Hello Hank!');
})();
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


## HTML




<!-- more -->