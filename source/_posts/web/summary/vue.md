---
title: Vue2新特性两三事儿
tags: Web
categories: Summary
---

![](vue/logo.png)

经历2个小型项目的尝试之后，正在和勤智前端团队的小伙伴一起，将前端架构逐步从Angular切换至Vue。为了帮助team里小伙伴们更加快速的上手，所以专门组织了本次training，一方面为大家讲解Vue2带来的各种有趣特性，另一方面聊聊与之前使用Angular的相似与异同。

<!-- more -->

## Vue与Angular的3个基本区别

1. **组件化**：Angular的设计思想照搬了Java Web开发当中MVC分层的概念，通过`Controller`切割并控制页面作用域，然后通过`Service`来实现复用，是一种对页面进行**纵向**分层的解耦思想。而Vue允许开发人员将页面抽象为若干独立的组件，即将页面DOM结构进行**横向**切割，通过组件完成功能复用、作用域控制，组件对外只提供props和state，并采用Vuex完成组件间的通信和同步。

![](vue/components.png "组件化")

### 双向绑定


### 虚拟DOM


## Vue对象

通过向构造函数`new Vue()`传入一个`option`对象去创建一个Vue实例。

```javascript
var vm = new Vue({
  // 数据
  data: "声明双向绑定的数据对象",
  props: "接收来自父组件的数据",
  propsData: "创建实例时手动传递props，方便测试props",
  computed: "计算属性",
  methods: "定义可以通过vm对象访问的方法",
  watch: "Vue实例化时会调用$watch()方法遍历watch对象的每1个属性",
  // DOM
  el: "将页面上已存在的DOM元素作为Vue实例的挂载目标",
  template: "可以替换挂载元素的字符串模板",
  render: "渲染函数，字符串模板的替代方案",
  renderError: "仅用于开发环境，在render()出现错误时，提供另外的渲染输出",
  // 生命周期钩子
  beforeCreate: "发生在Vue实例初始化之后，data observer和event/watcher事件配置之前",
  created: "发生在Vue实例初始化以及data observer和event/watcher事件被配置之后",
  beforeMount: "挂载开始之前被调用，render()首次被调用",
  mounted: "el被新建的vm.$el替换，并挂载到实例上之后调用",
  beforeUpdate: "数据更新时调用，发生在虚拟DOM重新渲染和打补丁之前",
  updated: "数据更改导致虚拟DOM重新渲染和打补丁之后被调用",
  activated: "keep-alive组件激活时调用",
  deactivated: "keep-alive组件停用时调用",
  beforeDestroy: "实例销毁之前调用，Vue实例依然可用",
  destroyed: "Vue实例销毁后调用，事件监听和子实例全部被移除，释放系统资源",
  // 资源
  directives: "包含Vue实例可用指令的哈希表",
  filters: "包含Vue实例可用过滤器的哈希表",
  components: "包含Vue实例可用组件的哈希表",
  // 组合
  parent: "指定当前实例的父实例，子实例用this.$parent访问父实例，父实例通过$children数组访问子实例",
  mixins: "将属性混入Vue实例对象，并在Vue自身实例对象的属性被调用之前得到执行",
  extends: "用于声明继承另一个组件，从而无需使用Vue.extend，便于扩展单文件组件",
  provide&inject: "2个属性需要一起使用，用来向所有子组件注入依赖，类似于React的Context",
  // 其它
  name: "允许组件递归调用自身，便于调试时显示更加友好的警告信息",
  delimiters: "改变模板字符串的风格，默认为{{}}",
  functional: "使组件无状态(没有data)和无实例(没有this上下文)",
  model: "允许自定义组件使用v-model时定制prop和event",
  inheritAttrs: "默认情况下，父作用域的非props属性绑定会应用在子组件的根元素上。当编写嵌套有其它组件或元素的组件时，可以将该属性设置为false关闭这些默认行为",
  comments: "设为true时会保留并且渲染模板中的HTML注释"
});
```

> Vue实例通常使用`vm`（View Model）变量来命名。


## Vue对象的实例方法

Vue 实例暴露了一些有用的实例属性与方法。它们都有前缀 $，以便与用户定义的属性区分开来。

```javascript
let vm = new Vue();
vm = {
  // 属性
  $data: "",
  $props: "",
  $el: "",
  $options: "",
  $parent: "",
  $root: "",
  $children: "",
  $slots: "",
  $scopedSlots: "",
  $refs: "",
  $isServer: "",
  $attrs: "",
  $listeners: "",
  // 数据
  $watch: "",
  $set: "",
  $delete: "",
  // 事件
  $on: "",
  $once: "",
  $off: "",
  $emit: "",
  // 生命周期
  $mount: "",
  $forceUpdate: "",
  $nextTick: "",
  $destroy: "",
}
```

## Vue对象实例的生命周期

每个Vue实例在创建时，都需要经过一系列初始化过程（*设置数据监听、编译模板、挂载实例到DOM、在数据变化时更新DOM*），并在同时运行一些钩子函数，让开发人员能够在特定生命周期内执行自己的代码。

![](vue/lifecycle.png "组件的生命周期")

> 不要Vue实例的属性、回调上使用箭头函数，比如`created: () => console.log(this.a)`或`vm.$watch('a', newValue => this.myMethod())`。因为箭头函数的this与父级上下文绑定，并不指向Vue实例本身，所以前面代码中的`this.a`或`this.myMethod`会是`undefined`。


## 数据绑定

Vue视图层通过[Mustache](http://mustache.github.io/)`['mʌstæʃ]`语法与Vue实例中的data属性进行双向绑定，但是也可以通过内置指令`v-once`完成一个单向的绑定，再或者通过`v-html`指令将绑定的字符串输出为HTML，虽然这样很容易招受XSS攻击。

```html
<span>Message: {{ hello }}</span>
<span v-once>这个将不会改变: {{ msg }}</span>
<div v-html="rawHtml"></div>
```

Mustache不能用于HTML属性，需要借助于`v-bind`指令。

```html
<div v-bind:id="dynamicId"></div>
<button v-bind:disabled="isButtonDisabled">Button</button>
```

## Mustache语法中使用JavaScript语句

Vue对于所有数据绑定都提供了JavaScript表达式支持，但是每个绑定只能使用**1**个表达式。

```html
<span>{{ number + 1 }}</span>
<button>{{ ok ? 'YES' : 'NO' }}</button>
<p>{{ message.split('').reverse().join('') }}</p>
<div v-bind:id="'list-' + id"></div>
<!-- 这是语句，不是表达式 -->
{{ var a = 1 }}
<!-- 流控制也不会生效，请使用三元表达式 -->
{{ if (ok) { return message } }}
```

## 内置指令

带有`v-`前缀，当表达式的值改变时，将其影响响应式的作用于DOM。指令可以接收后面以`:`表示的参数（*被指令内部的arg属性接收*），或者以`.`开头的修饰符（*指定该指令以特殊方式绑定*）。

```html
<p v-if="seen">现在你看到我了</p>
<!-- 绑定事件 -->
<a v-bind:href="url"></a>
<!-- 绑定属性 -->
<a v-on:click="doSomething">
<!-- .prevent 修饰符告诉 v-on 指令对于触发的事件调用 event.preventDefault() -->
<form v-on:submit.prevent="onSubmit"></form>
```

Vue为`v-bind`和`v-on`这两个常用的指令提供了简写形式。

```html
<!-- v-bind -->
<a v-bind:href="url"></a>
<a :href="url"></a>
<!-- v-on -->
<a v-on:click="doSomething"></a>
<a @click="doSomething"></a>
```

