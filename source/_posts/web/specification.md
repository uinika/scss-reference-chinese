---
title: Web前端开发遵循的一些规范与约定
tags: Web
categories: Summary
---

开发团队目前正在全面切换到`ES6 + Vue + React`这套技术栈，小伙伴们开发过程中对编码方面的规范以及ES6使用上的约定存在诸多困惑，所以参考了Github以及互联网企业UED们的开源文档，结合团队之前积累的大量开发约定和范式，整理了这篇**code style**文档并且同样[开源](https://uinika.github.io/)出来，计划在team小伙伴们熟练掌握以后，开始逐步在项目中引入[ESLint](https://eslint.org/)。

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

### 对象创建

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

> 当对象中同时存在简写属性和普通属性时，需要将简写内容进行分组。

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

## CSS & SCSS


## HTML




<!-- more -->