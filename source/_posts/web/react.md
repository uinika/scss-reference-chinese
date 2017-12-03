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
    你好, React 16.2.0！
  </h1>
);
```
```javascript
const element2 = React.createElement(
  'h1',
  {className: 'demo'},
  '你好, React 16.2.0！'
);
```

虽然`React.createElement()`会执行各类检查帮助你编写准确无误的代码，但是本质上其建立的对象是下面的样子：

```jsx
// 为了理解方便，下面展示的对象是被简化后的
const element = {
  type: 'h1',
  props: {
    className: 'demo',
    children: '你好, React 16.2.0！'
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
  firstname = "nothing"; // 对props进行了修改，不建议这样做
}
```

> **重要原则：组件外部只能通过props改变组件本身的行为。**


## State

首先，我们来改写之前定时器`timer`的例子。

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

然后，将JSX元素`element`从`timer()`函数中提取出来，并抽象为一个JSX组件`Clock`，然后通过`props`向组件传递当前`date`参数。

```jsx
function Clock(props) {
  return (
    <div>
      <h1>Hello, world!</h1>
      <h2>It is {props.date.toLocaleTimeString()}.</h2>
    </div>
  );
}

function timer() {
  ReactDOM.render(
    <Clock date={new Date()} />,
    document.getElementById('app')
  );
}

setInterval(timer, 1000);
```

但是，我们希望`Clock`组件的更新总是来自于其内部状态，而非通过组件外部的`props`进行传入，如同下面代码这样：

```jsx
ReactDOM.render(
  <Clock />,
  document.getElementById('root')
);
```

这就引出了React组件当中的另一个重要概念**state**，`state`与`props`非常类似，但是其属于组件私有，只能由组件自身进行控制。另外，前面章节有提到**类组件具有比函数式组件更丰富的特性**，而`state`就是这些特性当中的一个，因为它只能由类组件进行使用。


### 将函数式组件转换为类组件

首先，需要建立一个继承自`React.Component`ES6的Class类，并添加一个`render()`方法；然后，将组件内容移动至该方法当中，并将函数式组件中传入的`props`参数，修改为通过`this.props`进行引用。

```jsx
class Clock extends React.Component {
  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.props.date.toLocaleTimeString()}.</h2>
      </div>
    );
  }
}
```

### 向类组件添加state

首先，将`render()`函数中的`this.props.date`替换为`this.state.date`。

```jsx
class Clock extends React.Component {
  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    );
  }
}
```

然后，定义一个`constructor()`构造方法去初始化`this.state`。

```jsx
class Clock extends React.Component {
  // 注意这里是如何将props传递到构造函数中的
  constructor(props) {
    super(props); // 类组件总是会使用props作为参数调用基类构造器。
    this.state = {date: new Date()};
  }

  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    );
  }
}
```

最后，从`<Clock />`元素移除作为`props`的`date`属性。

```jsx
ReactDOM.render(
  <Clock />,
  document.getElementById('app')
);
```

最终结果看起来是下面这样的：

```jsx
class Clock extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }

  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    );
  }
}

ReactDOM.render(
  <Clock />,
  document.getElementById('app')
);
```

接下来，我们需要利用React组件提供的**生命周期方法**，每间隔1秒对当前显示的时间进行更新。

## Lifecycle

多组件应用程序开发当中，非常重要的一点在于：**在组件被销毁的时候去释放组件占用的资源**。即当组件被渲染至DOM的时候，需要初始化`Clock`组件中的定时器，React生命周期中称为`mounting挂载`；然后在组件被销毁时，清除组件定时器所占用的资源，React生命周期中称为`unmounting卸载`。React提供了两个**生命周期钩子（*lifecycle hooks*）**：`componentDidMount()`和`componentWillUnmount()`。

### componentDidMount()钩子

React组件被渲染到HTML DOM后被执行，可以用来初始化之前例子中的定时器。

```jsx
componentDidMount() {
  // 设置timer ID到this指针
  this.timerID = setInterval(
    () => this.tick(),
    1000
  );
}
```

### componentWillUnmount()钩子

React组件从HTML DOM卸载之前得到执行，可以用来销毁定义在组件`this`上的定时器。

```jsx
componentWillUnmount() {
  clearInterval(this.timerID);
}
```

### 抽取timer()函数

`timer()`函数会通过`this.setState()`定时更新组件本身的`state`，从而动态展示当前时间。

```jsx
class Clock extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.timer(),
      1000
    );
  }

  componentWillUnmount() {
    clearInterval(this.timerID);
  }

  timer() {
    this.setState({
      date: new Date()
    });
  }

  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    );
  }
}

ReactDOM.render(
  <Clock />,
  document.getElementById('app')
);
```


## 深入State

除了在类组件的构造函数中之外，不允许直接修改`state`，而必须通过组件提供的`setState()`方法。

```jsx
// 错误
this.state.comment = '你好';

// 正确
this.setState({comment: '你好'});
```

React中`this.props`和`this.state`的更新都是**异步**的，当在同一个组件中多次应用时，不能依赖它们去计算下一个状态（*可能会造成错误*），例如下面代码可能会错误的更新计数器：

```jsx
this.setState({
  counter: this.state.counter + this.props.increment,
});
```

要修复这个问题，`setState()`可以接收一个函数作为参数，该函数第1个参数是之前的`state`，第2个参数是`props`。

```jsx
this.setState((prevState, props) => ({
  counter: prevState.counter + props.increment
}));
```

通过`setState()`对state的更新操作都会合并到当前state，例如下面代码的`state`中可以包含多个独立值：

```jsx
constructor(props) {
  super(props);
  this.state = {
    users: [],
    groups: []
  };
}
```

然后可以在组件里，分别使用`setState()`对这些值进行单独更新。

```jsx
componentDidMount() {
  fetchUser().then(response => {
    this.setState({
      users: response.users
    });
  });

  fetchGroup().then(response => {
    this.setState({
      groups: response.groups
    });
  });
}
```

## 单向数据流

React当中的`state`通常被认为是*局部的*或者*封装的*，除了拥有并设置它的组件之外，其它任何组件都不能对其进行访问。因此，父子组件之间，可以通过将`state`赋值给`props`的方式，将父组件的内部状态传递给子组件。

```jsx
<FormattedDate date={this.state.date} />

function FormattedDate(props) {
  return <h2>It is {props.date.toLocaleTimeString()}.</h2>;
}
```

上面代码当中的`FormattedDate`组件通过其props接收了父组件传递过来的状态`this.state.date`。因此，可以认为React组件之间的数据流向是从**父组件至子组件**，即一个**由上至下**的关系，通常被称为**单向数据流**，

> 可以将一个组件树中的`props`想象成一个瀑布流，每个单独组件的`state`如同一个个的独立水源，在任意时间节点加入到瀑布流当中，然后共同向下流动。

下面代码中，在一个`App`组件内部渲染了多个`Clock`组件，每个组件的时间都会独立进行更新，互相不受影响。

```jsx
function App() {
  return (
    <div>
      <Clock />
      <Clock />
      <Clock />
    </div>
  );
}

ReactDOM.render(
  <App />,
  document.getElementById('app')
);
```

![](react/state-update.gif "每个React组件都会单独更新")


## 事件

React事件机制与原生JavaScript事件机制语法上有以下不同：

（1）React事件名称使用驼峰命名camelCase。

（2）JSX可以直接使用函数作为事件处理器。

```jsx
// 原生JavaScript事件
<button onclick="activateLasers()">
  Activate Lasers
</button>

// React事件
<button onClick={activateLasers}>
  Activate Lasers
</button>
```

（3）React不能通过返回`false`阻止事件默认行为，而必须显式调用`preventDefault()`方法。

```jsx
<a href="#" onclick="console.log('The link was clicked.'); return false">
  Click me
</a>

function ActionLink() {
  function handleClick(e) {
    e.preventDefault();
    console.log('The link was clicked.');
  }

  return (
    <a href="#" onClick={handleClick}>点击目标</a>
  );
}
```

上面代码中，传入事件处理函数`handleClick(e)`的参数`e`是React遵循[W3C UI Events事件规范](https://www.w3.org/TR/DOM-Level-3-Events/)实现的合成事件，因此毋需担心跨浏览器兼容性问题。

使用ES6的class定义一个类组件时，通用的做法是以**类方法**的形式定义事件处理函数，例如下面代码定义了一个可以点击切换【打开】和【关闭】状态的按钮。

```jsx
class Toggle extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};

    // 使用bind()方法，将this作用域绑定至回调函数
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        {this.state.isToggleOn ? '打开' : '关闭'}
      </button>
    );
  }
}

ReactDOM.render(
  <Toggle />,
  document.getElementById('app')
);
```

![](react/event-toggle.gif "切换按钮内容的点击事件")

大家注意理解上面代码中JSX回调函数内`this`的意义，JavaScript中类方法默认没有绑定至当前对象的`this`，