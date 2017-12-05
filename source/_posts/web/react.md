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
  document.getElementById('app')
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

大家注意理解上面类组件`constructor()`构造函数当中，`this.handleClick.bind(this)`的含义。使用`bind()`是为了将类组件的`this`作用域绑定至指定函数，从而方便的在该函数内部使用`this`操作React类组件上的其它方法。

### 绑定组件this到事件处理函数

当然，如果你认为`bind()`使用起来又臭又长，这里有2种方式可以绕开它：

（1）通过实验性的类属性转换语法（*Class properties transform*）正确绑定`this`到事件回调函数当中，不过需要额外安装`babel-plugin-transform-class-properties`插件支持。

```jsx
class Button extends React.Component {
  // 本质是将一个箭头函数赋值给一个变量
  handleClick = () => {
    console.log('这是：', this);
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        点击我
      </button>
    );
  }
}
```

（2）或者通过箭头函数的方式直接调用事件处理函数。

```jsx
class Button extends React.Component {
  handleClick() {
    console.log('这是：', this);
  }

  render() {
    // 这样的书写语法可以确保this正确的绑定到handleClick
    return (
      <button onClick={(e) => this.handleClick(e)}>
        点击我
      </button>
    );
  }
}
```

> 这种方式的缺点在于每次不同的事件回调函数被建立时都会触发React组件的重绘（*比如下面的Button*），如果此时事件回调传递`props`到子级组件，则这些组件全部都会发生重绘，从而对页面性能造成影响。因此，React官方更加推荐**通过组件构造器调用`bind()`**和**类属性语法**这两种方式。

### 向事件处理函数传递参数

通常情况下，我们都需要传递参数到事件处理函数，例如传递每一行的`id`，下面使用的`arrow functions`和`Function.prototype.bind`两种写法都是等效的。

```jsx
<button onClick={(e) => this.deleteRow(id, e)}>删除行</button>
<button onClick={this.deleteRow.bind(this, id)}>删除行</button>
```

第1个参数`e`表示的是React事件对象，紧随其后的第2个参数即用来表示`id`。


## 条件渲染

React中的条件渲染类似于JavaScript中的条件运算，可以通过`if`等条件运算符去动态展示元素、组件的状态。

```jsx
function User(props) {
  return <h1>欢迎回来！</h1>;
}

function Guest(props) {
  return <h1>请登录！</h1>;
}

// 通过Greeting组件条件渲染上面定义的2个组件
function Greeting(props) {
  const isLogged = props.isLogged;
  if (isLogged) {
    return <User />;
  }
  return <Guest />;
}

ReactDOM.render(
  <Greeting isLogged={false} />, // 尝试将false改成true，会得到不同的展示结果
  document.getElementById('app')
);
```

### 元素变量

可以将React元素赋值给一个变量，这样可以方便的在组件内部进行条件渲染。下面例子中的`<LoginControl />`组件会根据自身的状态，有条件的渲染`<LoginButton />`或`<LogoutButton />`以及之前例子中的`<Greeting />`组件。

```jsx
// 无状态组件
function LoginButton(props) {
  return (
    <button onClick={props.onClick}> 登入 </button>
  );
}

// 无状态组件
function LogoutButton(props) {
  return (
    <button onClick={props.onClick}> 登出 </button>
  );
}

// 带有状态的组件
class LoginControl extends React.Component {
  constructor(props) {
    super(props);
    this.handleLoginClick = this.handleLoginClick.bind(this);
    this.handleLogoutClick = this.handleLogoutClick.bind(this);
    this.state = {isLogged: false};
  }

  handleLoginClick() {
    this.setState({isLogged: true});
  }
  handleLogoutClick() {
    this.setState({isLogged: false});
  }

  render() {
    let button = null;
    const isLogged = this.state.isLogged;

    if (isLogged) {
      button = <LogoutButton onClick={this.handleLogoutClick} />;
    } else {
      button = <LoginButton onClick={this.handleLoginClick} />;
    }

    return (
      <div>
        <Greeting isLogged={isLogged} /> {button}
      </div>
    );
  }
}

ReactDOM.render(
  <LoginControl />,
  document.getElementById('app')
);
```

![](react/conditional-rendering.gif "条件渲染示例")


声明一个变量和使用`if`关键字是进行条件渲染非常好的方式，但有些时候可能需要使用到更简短的语法，接下来介绍几种行内的条件渲染方式：

### 内联条件渲染-&&运算符

将JSX表达式嵌入到一个花括号`{}`运算符中（*表达式中包含了JavaScript逻辑和`&&`操作符*），可以方便的将React元素包含到条件渲染判断语句当中。

```jsx
function Mailbox(props) {
  const unreadMessages = props.unreadMessages;
  return (
    <div>
      <h1>Hello!</h1>
      {unreadMessages.length > 0 &&
        <h2>
          You have {unreadMessages.length} unread messages.
        </h2>
      }
    </div>
  );
}

const messages = ['React', 'Re: React', 'Re:Re: React'];
ReactDOM.render(
  <Mailbox unreadMessages={messages} />,
  document.getElementById('app')
);
```

JavaScript当中`true && 表达式`的结果总是`表达式`，而`false && 表达式`的结果总是`false`。换而言之，如果条件判断结果为`true`，则`&&`运算符右侧的React元素将会出现在输出当中，如果为`false`则React会自动跳过不进行任何渲染。

### 内联条件渲染-三目运算符

另外一种使用内联条件渲染的方式是通过三目运算符`condition ? true : false`，下面例子中使用它对一小块文本进行了条件渲染。

```jsx
render() {
  const isLogged = this.state.isLogged;
  return (
    <div>
      用户 <b>{isLogged ? '已经' : '没有'}</b> 登录.
    </div>
  );
}
```

三目运算符也可以用于进行多行的条件渲染：

```jsx
render() {
  const isLogged = this.state.isLogged;
  return (
    <div>
      {isLogged ? (
        <LogoutButton onClick={this.handleLogoutClick} />
      ) : (
        <LoginButton onClick={this.handleLoginClick} />
      )}
    </div>
  );
}
```

> 如同JavaScript一样，条件渲染的使用完全依照开发团队的习惯和实际工作的需求，但是无论如何都不要书写过于复杂的条件渲染语句，否则可以考虑将条件渲染过程抽象为一个具体的组件。

### 阻止组件的渲染

极少的情况下，开发人员需要将组件隐藏起来，即便它已经被其它组件渲染出来，如果需要这样做，可以让组件`render()`函数返回`null`而非JSX的内容。

下面的例子中，组件`<WarningBanner />`的渲染依赖于一个名为`warn`的props值，如果其值为`false`则该组件不会渲染。

```jsx
function WarningBanner(props) {
  if (!props.warn) {
    return null;
  }

  return (
    <div className="warning">
      警告信息！
    </div>
  );
}

class Page extends React.Component {
  constructor(props) {
    super(props);
    this.state = {showWarning: true}
    this.handleToggleClick = this.handleToggleClick.bind(this);
  }

  handleToggleClick() {
    this.setState(prevState => ({
      showWarning: !prevState.showWarning
    }));
  }

  render() {
    return (
      <div>
        <WarningBanner warn={this.state.showWarning} />
        <button onClick={this.handleToggleClick}>
          {this.state.showWarning ? '隐藏' : '显示'}
        </button>
      </div>
    );
  }
}

ReactDOM.render(
  <Page />,
  document.getElementById('app')
);
```

![](react/prevent-component-render.gif "阻止组件的渲染")

> React组件的`render()`方法返回`null`值并不会影响组件**生命周期钩子函数**的触发，诸如`componentWillUpdate()`和`componentDidUpdate()`依然会被正常调用。


## List和Key

通常情况下，在JavaScript当中我们会像下面代码这样循环一个数组列表。

```jsx
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map((number) => number * 2);
console.log(doubled); // [2, 4, 6, 8, 10]
```

React当中循环一个组件列表的方式与上面非常相似，下面代码会渲染出一个从1至5编号的无序列表。

```jsx
const numbers = [1, 2, 3, 4, 5];
const listItems = numbers.map((number) =>
  <li>{number}</li>
);

ReactDOM.render(
  <ul>{listItems}</ul>,
  document.getElementById('app')
);
```

### 列表组件

接下来，我们将上面例子中的列表循环封装到一个组件当中去，该组件将会接收一个`numbers`数组作为`props`。

```jsx
function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((number) =>
    <li>{number}</li>
  );
  return (
    <ul>{listItems}</ul>
  );
}

const numbers = [1, 2, 3, 4, 5];
ReactDOM.render(
  <NumberList numbers={numbers} />,
  document.getElementById('app')
);
```

但是，当你执行这段代码时，会得到这个警告信息：`Warning: Each child in an array or iterator should have a unique "key" prop.`。这里，通过添加`key={number.toString()}`可以修复该问题。

```jsx
function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((number) =>
    // 列表循环中的`key`是一个特殊的字符串属性
    <li key={number.toString()}>
      {number}
    </li>
  );
  return (
    <ul>{listItems}</ul>
  );
}
```

### 列表循环的key

`key`属性用来帮助React鉴别具体哪一项内容发生了变化，可以给列表循环当中的每个具体项一个确切的、稳定的标识。

```jsx
const numbers = [1, 2, 3, 4, 5];
const listItems = numbers.map((number) =>
  <li key={number.toString()}>
    {number}
  </li>
);
```

最佳实践是使用字符串类型的键值来作为列表循环当中每项的唯一标识，通常情况下可以使用列表的`id`值来作为`key`。

```jsx
const todoItems = todos.map((todo) =>
  <li key={todo.id}>
    {todo.text}
  </li>
);
```

如果没有稳定的`id`值，可以考虑使用循环列表每项的索引值`index`作为`key`。

```jsx
const todoItems = todos.map((todo, index) =>
  <li key={index}>
    {todo.text}
  </li>
);
```

在列表项顺序可能发生变化的场景下，React官方并不推荐使用索引作为`key`，因为会带来性能方面的负面影响，并引发组件状态的问题。

### key的使用位置 

属性`key`只作用于数组循环上下文的内部，通常情况下是在ES6提供的`map()`遍历方法内。

```jsx
function ListItem(props) {
  // 这里不需要指定key值
  return <li>{props.value}</li>;
}

function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((number) =>
    // key必须放置在数组循环的作用域范围内（即map()方法内部）
    <ListItem key={number.toString()} value={number} />
  );
  return (
    <ul>
      {listItems}
    </ul>
  );
}

const numbers = [1, 2, 3, 4, 5];
ReactDOM.render(
  <NumberList numbers={numbers} />,
  document.getElementById('app')
);
```

### key必须唯一

`key`值必须保持在数组循环作用域范围内的唯一，而非全局上下文范围内的唯一，因此在不同的数组循环内使用相同`key`值是被允许的。

```jsx
function Blog(props) {
  const sidebar = (
    <ul>
      {props.posts.map((post) =>
        <li key={post.id}> {post.title} </li>
      )}
    </ul>
  );
  const content = props.posts.map((post) =>
    <div key={post.id}>
      <h3>{post.title}</h3>
      <p>{post.content}</p>
    </div>
  );
  return (
    <div>
      {sidebar}
      <hr />
      {content}
    </div>
  );
}

const posts = [
  {id: 1, title: '你好', content: '欢迎使用React 16.2.0！'},
  {id: 2, title: '安装方式', content: '可以通过npm和yarn安装React'}
];
ReactDOM.render(
  <Blog posts={posts} />,
  document.getElementById('app')
);
```

`key`仅仅只是作为React内部的标记，并不会被渲染到组件和DOM当中，如果在组件内部需要使用到`key`的属性值，可以考虑也同时将其传递给组件的`props`。

```jsx
const content = posts.map((post) =>
  // post.id同时赋值给了key属性和id props。
  <Post key={post.id} id={post.id} title={post.title} />
);
```

### 嵌入map()至JSX




