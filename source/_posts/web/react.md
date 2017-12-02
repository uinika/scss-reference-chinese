---
title: React 16.2.x官方文档解读
tags: JavaScript
categories: Web
---

全文翻译自[React 16.2.0英文文档](https://reactjs.org/)，适当精简了生产环境不常使用的内容，并对部分比较复杂的概念进行更翔实的解读，以及与Vue2进行了一些特性上的比较。应该是目前**最新**、**最完整**的React上手指南，适合已经具备**组件式**前端框架开发经验的同学快速上手React 16。

![](react/logo.ico)

<!-- more -->


## 快速开始

如果使用npm作为依赖管理工具，可以通过下面命令安装React。

```bash
npm install --save react react-dom
```

一个使用ES6的最简单例子是这样的：

```jsx
import React from 'react';
import ReactDOM from 'react-dom';

ReactDOM.render(
  <h1>Hello, React 16.2.0 !</h1>,
  document.getElementById('app')
);
```

当然，也可以使用独立的React发布包，直接在`<script>`标签当中包含使用。

```html
<!-- Development Versions-->
<script crossorigin src="https://unpkg.com/react@16/umd/react.development.js"></script>
<script crossorigin src="https://unpkg.com/react-dom@16/umd/react-dom.development.js"></script>
<!-- Production Versions -->
<script crossorigin src="https://unpkg.com/react@16/umd/react.production.min.js"></script>
<script crossorigin src="https://unpkg.com/react-dom@16/umd/react-dom.production.min.js"></script>
```

## JSX

JSX是一个具有**JavaScript编程特性**的**类HTML标签**语言，目前*TypeScript*和*Vue2*都已经对JSX语法提供了良好的支持，广泛的应用于现代化前端开发当中。

### 向JSX中嵌入表达式

开发人员可以通过花括号语法`{}`嵌入JavaScript表达式（*例如2+2、user.name、auth(user)*）。

```jsx
function auth(user) {
  return user.name + ' ' + user.password;
}

const user = {
  name: 'hank',
  password: '12345'
};

const element = (
  <h1>
    User Info：{auth(user)}.
  </h1>
);

ReactDOM.render(
  element,
  document.getElementById("app")
);
```

> 通过使用圆括号语法`()`，可以方便的书写多行JSX。

### JSX本身也是一种表达式

编译之后，JSX表达式会被转换为标准的JavaScript对象。这意味着可以在JSX中使用`if`和`for`等JavaScript语句、指定一个变量、接收其作为参数、甚至是从一个函数当中返回它们。

```jsx
function getUserInfo(user) {
  if (user) {
    return <h1>User Info：{auth(user)}</h1>;
  }
  return <h1>No Info.</h1>;
}
```

### 指定JSX的属性

可以使用引号`"`指定一个字符串字面量作为JSX的属性。

```jsx
const element1 = <div className="dashboard"></div>;
const element2 = <div tabIndex="0"></div>;
```

也可以使用花括号表达式`{}`嵌入JavaScript表达式到JSX属性当中，此时无需在花括号外使用引号。

```jsx
const element = <img src={user.avatarUrl}></img>;
```

> 相比于静态的HTML，由于JSX编程性上更加接近于JavaScript，React DOM使用驼峰风格（*camelCase*）的属性名称来代替原生HTML属性风格，例如：HTML中的`class`和`tabindex`变为JSX中的`className`以及`tabIndex`。

### 使用JSX指定子元素

如果JSX标签内容为空，可以使用`/>`直接进行关闭。

```jsx
const element = <img src={user.avatarUrl} />;
```

当然，JSX标签可能也会包含子元素 ，如同下面这样：

```jsx
const element = (
  <div>
    <h1>Hello!</h1>
    <h2>React 16.2.0!</h2>
  </div>
);
```

### JSX可以预防脚本注入攻击

React DOM默认会在JSX渲染之前，避免任何值嵌入。因此可以确保不会被注入显式编写在应用外的其它内容。为了避免XSS跨站脚本攻击，任何内容在渲染之前都会被转换为字符串。

```jsx
const text = response.dangerInput;
// This is safe:
const element = <h1>{text}</h1>;
```

### JSX最终会被转换为对象

Babel会将JSX编译为一个`React.createElement()`函数调用，因此下面代码中的`element1`与`element2`是等效的。

```jsx
const element1 = (
  <h1 className="demo">
    Hello, world!
  </h1>
);
```
```javascript
const element2 = React.createElement(
  'h1',
  {className: 'demo'},
  'Hello, React 16.2.0!'
);
```

虽然`React.createElement()`会执行各类检查帮助你编写准确无误的代码，但是本质上其建立的对象是下面的样子：

```jsx
// Note: this structure is simplified
const element = {
  type: 'h1',
  props: {
    className: 'demo',
    children: 'Hello, React 16.2.0!'
  }
};
```

这些对象被称为**React elements**，React读取这些对象并通过它们去构建DOM，并负责维护其状态，其名称乃至于功能都与Vue2模板编译所使用的`createElement()`函数一致。


## Elements

**元素Elements**是React应用的最小组成部份，不同于浏览器的DOM元素，React元素是一个非常易于建立的普通对象。React的组件（*Elements*）和元素（*Components*）是非常容易混淆的两个概念，事实上React的组件是由元素所组成的，元素是React的JSX模板的最小组成部分。

### 渲染一个React元素到DOM

通过`ReactDOM.render()`方法渲染一个React元素到HTML的DOM根结点。

```jsx
const element = <h1>Hello, React 16.2.0 !</h1>;

ReactDOM.render(
  element,
  document.getElementById('app')
);
```

### 更新已经被渲染的React元素

React元素是不可变的，建立后就不能修改其**属性**以及**子元素**。React元素就像电影中的一个关键帧，总是在确切的时间点展现UI。

从old fashion的角度来看，更新UI总是需要去建立一个新的React元素，然后再通过`ReactDOM.render()`渲染出来。例如下面代码，每间隔1秒钟使用`setInterval()`回调函数执行`ReactDOM.render()`方法。

```jsx
function timer() {
  const element = (
    <div>
      <h1>你好, React 16.2.0 !</h1>
      <h2>现在时间是{new Date().toLocaleTimeString()}。</h2>
    </div>
  );
  ReactDOM.render(
    element,
    document.getElementById('app')
  );
}

setInterval(timer, 1000);
```

### React元素是按需更新的

React DOM会比较当前React元素与其之前的状态，然后只对发生变化的DOM局部执行更新操作。

![](react/elements-update.gif "React只对变化的那部分DOM内容进行更新")


## Components

**组件Components**可以将UI拆分为独立且可复用的片断，React组件接收`props`作为输入参数，并在最后返回React元素。

### 函数式组件与类组件

定义React组件最简单的方法是通过JavaScript函数。

```javascript
// 接收props参数
function Welcome(props) {
  return <h1>你好, {props.name}！</h1>; // 返回React元素
}
```

当然也可以通过ES6的`class`关键字定义一个等效组件，从而获取更多的有趣特性。

```jsx
class Welcome extends React.Component {
  render() {
    return <h1>你好, {this.props.name}！</h1>;
  }
}
```

### 渲染一个组件

首先定义一个React组件，然后将组件赋值给一个React元素，最后再使用`ReactDOM.render()`方法渲染该React元素到页面上。

```jsx
// 定义一个函数式组件
function Welcome(props) {
  return <h1>你好, {props.name}！</h1>;
}

// 将上面定义的组件赋予一个React元素
const element = <Welcome name="Hank" />;

// 渲染这个元素
ReactDOM.render(
  element,
  document.getElementById('app')
);
```

> React组件的名称通常约定为**大写**格式。

### 组合使用多个组件

我们可以在一个组件返回的JSX当中组合引用其它的组件。

```jsx
function Welcome(props) {
  return <h1>你好, {props.name}！</h1>;
}

function App() {
  return (
    <div>
      <Welcome name="Hank" />
      <Welcome name="Jack" />
      <Welcome name="Candy" />
    </div>
  );
}

ReactDOM.render(
  <App />,
  document.getElementById('app')
);
```

### 组件的抽取

可以将一个较大的组件分割为更加细粒度的组件，便于复用与维护，例如下面这个函数式组件`Comment`：

```jsx
function Comment(props) {
  return (
    <div className="Comment">
      <div className="UserInfo">
        <img className="Avatar"
          src={props.author.avatarUrl}
          alt={props.author.name}
        />
        <div className="UserInfo-name">
          {props.author.name}
        </div>
      </div>
      <div className="Comment-text">
        {props.text}
      </div>
      <div className="Comment-date">
        {formatDate(props.date)}
      </div>
    </div>
  );
}
```

可以将其拆分为`Avatar`，`UserInfo`，`Comment`三个具有包含关系的组件。

```jsx
function Avatar(props) {
  return (
    <img className="Avatar"
      src={props.user.avatarUrl}
      alt={props.user.name}
    />
  );
}

function UserInfo(props) {
  return (
    <div className="UserInfo">
      <Avatar user={props.user} />
      <div className="UserInfo-name">
        {props.user.name}
      </div>
    </div>
  );
}

function Comment(props) {
  return (
    <div className="Comment">
      <UserInfo user={props.author} />
      <div className="Comment-text">
        {props.text}
      </div>
      <div className="Comment-date">
        {formatDate(props.date)}
      </div>
    </div>
  );
}
```

### Props是只读的

无论是以函数式还是`class`类的方式声明组件，都不能对它们的`props`进行修改。

```jsx
function pure(firstname, lastname) {
  return firstname + lastname; // 没有对props进行修改
}

function impure(firstname, lastname) {
  firstname = "nothing"; // 对props进行了修改，因此不建议这样做
}
```

> **重要原则：组件外部只能通过props改变组件本身的行为。**


## State


## Lifecycle