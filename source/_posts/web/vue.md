---
title: Vue2技术栈归纳与精粹
tags: JavaScript
categories: Web
---

Vue是一款**高度封装的**、**开箱即用的**、**一栈式的前端框架**，既可以结合webpack进行编译式前端开发，也适用基于gulp、grunt等自动化工具直接挂载至`全局window`使用。本文成文于Vue2.4.x版本发布之初，笔者生产环境当前使用的最新版本为2.5.2。在经历多个前端重度交互项目的开发实践之后，笔者结合官方文档对Vue技术栈进行了全面的梳理、归纳和注解，因此本文可以作为Vue2官方tutorial的补充性读物。建议暂不具备Vue2开发经验的同学，完成官方tutorial的学习之后再行阅读本文。

![](vue/logo.png)

<!-- more -->

Vue2.2.x之后的版本，Vue框架及其技术栈功能日趋完善，相比React+Reflux/Redux/MobX的组合，Vue更加贴近W3C技术规范（*例如实现仍处于W3C草案阶段的`<template>`、`<slot>`、`is`等新特性，提供了良好易用的模板书写环境*），并且技术栈和开源生态更加完整和易于配置，将React中大量需要手动编码处理的位置，整合成最佳实践并抽象为简单的语法糖（比如Vuex中提供的`store`的模块化特性），让开发人员始终将精力聚焦于业务逻辑本身。

Vue2的API结构相比Angular2更加简洁，可以自由的结合TypeScript或是ECMAScript6使用，并不特定于具体的预处理语言去获得最佳使用体验，框架本身的特性也并不强制依赖于各类炫酷的语法糖。Vue2总体是一款非常**轻量**的技术栈，设计实现上紧随W3C技术规范，着力于处理**HTML模板组件化**、**事件和数据的作用域分离**、**多层级组件通信**三个单页面前端开发当中的重点问题。本文在行文过程中，穿插描述了Angular、React等前端框架的异同与比较，供徘徊于各类前端技术选型的开发人员参考。

## Vue与Angular的比较

### 组件化

Angular的设计思想照搬了Java Web开发当中MVC分层的概念，通过`Controller`切割并控制页面作用域，然后通过`Service`来实现复用，是一种对页面进行**纵向**分层的解耦思想。而Vue允许开发人员将页面抽象为若干独立的组件，即将页面DOM结构进行**横向**切割，通过组件的拼装来完成功能的复用、作用域控制。每个组件只提供`props`作为单一接口，并采用Vuex进行`state tree`的管理，从而便捷的实现组件间状态的通信与同步。

![](vue/components.png "组件化")

Angular在1.6.x版本开始提供`component()`方法和`Component Router`来提供组件化开发的体验，但是依然需要依赖于`controller`和`service`的划分，实质上依然没有摆脱MVC纵向分层思想的桎梏。

### 双向绑定与响应式绑定

Vue遍历data对象上的所有属性，并通过原生`Object.defineProperty()`方法将这些属性转换为`getter/setter`（*只支持IE9及以上浏览器*）。Vue内部通过这些getter/setter追踪依赖，在属性被修改时触发相应变化，从而完成模型到视图的双向绑定。每个Vue组件实例化时，都会自动调用`$watch()`遍历自身的data属性，并将其记录为依赖项，当这些依赖项的setter被触发时会通知watcher重新计算新值，然后触发Vue组件的`render()`函数重新渲染组件。

![](vue/data.png "响应式绑定的生命周期")

与Aangular双向数据绑定不同，Vue组件不能检测到实例化后data属性的添加、删除，因为Vue组件在实例化时才会对属性执行getter/setter处理，所以data对象上的属性必须在实例化之前存在，Vue才能够正确的进行转换。因而，Vue提供的并非真正意义上的双向绑定，更准确的描述应该是**单向绑定，响应式更新**，而Angular即可以通过`$scope`影响view上的数据绑定，也可以通过视图层操作`$scope`上的对象属性，属于真正意义上的**视图与模型的双向绑定**。

```javascript
var vm = new Vue({
  data:{
    a:1
  }
})
vm.a = 1  // 响应的
vm.b = 2 // 非响应的
```

因此，Vue不允许在已经实例化的组件上添加新的动态根级响应属性（*即直接挂载在data下的属性*），但是可以使用`Vue.set(object, key, value)`方法添加响应式属性。

```javascript
Vue.set(vm.someObject, "b", 2)

// vm.$set()实例方法是Vue.set()全局方法的别名
this.$set(this.someObject, "b",2)

// 使用Object.assign()或_.extend()也可以添加响应式属性，但是需要创建同时包含原属性、新属性的对象，从而有效触发watch()方法
this.someObject = Object.assign({}, this.someObject, { a: 1, b: 2 })
```

Vue对DOM的更新是异步的，观察到数据变化后Vue将开启一个队列，缓冲在同一事件循环（*Vue的event loop被称为**tick** [tɪk] n.标记，记号*）中发生的所有数据变化。如果同一个watcher被多次触发，只会向这个队列中推入一次。

> Vue内部会通过原生JavaScript的`Promise.then`、`MutationObserver`、`setTimeout(fn, 0)`来执行异步队列当中的watcher。

在需要人为操作DOM的场景下，为了在Vue响应数据变化之后再更新DOM，可以手动调用`Vue.nextTick(callback)`，并将DOM操作逻辑放置在callback回调函数中，从而确保响应式更新完成之后再进行DOM操作。

```html
<div id="example">{{message}}</div>

<script>
// 使用Vue实例上的.$nextTick()
var vue = new Vue({
  el: "#example",
  data: {
    message: "123"
  }
})
vue.message = "new message" // 更改数据
vue.$el.textContent === "new message" // false
vue.nextTick(function () {
  vm.$el.textContent === "new message" // true
})
</script>

<script>
// 组件内使用vm.$nextTick()，不需要通过全局Vue，且回调函数中this自动指向当前Vue实例
Vue.component("example", {
  template: "<span>{{ message }}</span>",
  data: function () {
    return {
      message: "没有更新"
    }
  },
  methods: {
    updateMessage: function () {
      this.message = "更新完成"
      console.log(this.$el.textContent) // 没有更新
      this.$nextTick(function () {
        console.log(this.$el.textContent) // 更新完成
      })
    }
  }
})
</script>
```

### 虚拟DOM

**Vritual DOM**这个概念最先由React引入，是一种DOM对象差异化比较方案，即将DOM对象抽象成为Vritual DOM对象（*即render()函数渲染的结果*），然后通过差异算法对Vritual DOM进行对比并返回差异，最后通过一个补丁算法将返回的差异对象应用在真实DOM结点。

Vue当中的Virtual DOM对象被称为**VNode**（*`template`当中的内容会被编译为render()函数，而render()函数接收一个createElement()函数，并最终返回一个VNode对象*），补丁算法来自于另外一个开源项目[snabbdom](https://github.com/snabbdom/snabbdom)，即将真实的DOM操作映射成对虚拟DOM的操作，通过减少对真实DOM的操作次数来提升性能。

```bash 
➜  vdom git:(dev) tree
├── create-component.js
├── create-element.js
├── create-functional-component.js
├── helpers
│   ├── extract-props.js
│   ├── get-first-component-child.js
│   ├── index.js
│   ├── is-async-placeholder.js
│   ├── merge-hook.js
│   ├── normalize-children.js
│   ├── resolve-async-component.js
│   └── update-listeners.js
├── modules
│   ├── directives.js
│   ├── index.js
│   └── ref.js
├── patch.js
└── vnode.js
```

VNode的设计出发点与Angular的`$digest`循环类似，都是通过**减少对真实DOM的操作次数来提升性能**，但是Vue的实现更加轻量化，摒弃了Angular为了实现双向绑定而提供的`$apply()`、`$eval()`封装函数，有选择性的实现Angular中`$compile()`、`$watch()`类似的功能。


## Vue对象的选项

通过向构造函数`new Vue()`传入一个`option`对象去创建一个Vue实例。

```javascript
var vm = new Vue({
  // 数据
  data: "声明需要响应式绑定的数据对象",
  props: "接收来自父组件的数据",
  propsData: "创建实例时手动传递props，方便测试props",
  computed: "计算属性",
  methods: "定义可以通过vm对象访问的方法",
  watch: "Vue实例化时会调用$watch()方法遍历watch对象的每个属性",
  // DOM
  el: "将页面上已存在的DOM元素作为Vue实例的挂载目标",
  template: "可以替换挂载元素的字符串模板",
  render: "渲染函数，字符串模板的替代方案",
  renderError: "仅用于开发环境，在render()出现错误时，提供另外的渲染输出",
  // 生命周期钩子
  beforeCreate: "发生在Vue实例初始化之后，data observer和event/watcher事件被配置之前",
  created: "发生在Vue实例初始化以及data observer和event/watcher事件被配置之后",
  beforeMount: "挂载开始之前被调用，此时render()首次被调用",
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
  functional: "让组件无状态(没有data)和无实例(没有this上下文)",
  model: "允许自定义组件使用v-model时定制prop和event",
  inheritAttrs: "默认情况下，父作用域的非props属性绑定会应用在子组件的根元素上。当编写嵌套有其它组件或元素的组件时，可以将该属性设置为false关闭这些默认行为",
  comments: "设为true时会保留并且渲染模板中的HTML注释"
});
```

> Vue实例通常使用`vm`（*View Model*）变量来命名。

### 属性计算computed

在HTML模板表达式中放置太多业务逻辑，会让模板过重且难以维护。因此，可以考虑将模板中比较复杂的表达式拆分到computed属性当中进行计算。

```html
<!-- 不使用计算属性 -->
<div id="example">
  {{ message.split("").reverse().join("") }}
</div>

<!-- 将表达式抽象到计算属性 -->
<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>

<script>
  var vm = new Vue({
    el: "#example",
    data: {
      message: "Hello"
    },
    computed: {
      reversedMessage: function () {
        return this.message.split("").reverse().join("")
      }
    }
  })
</script>
```

> 计算属性只在相关依赖发生改变时才会重新求值，这意味只要上面例子中的message没有发生改变，多次访问reversedMessage计算属性总会返回之前的计算结果，而不必再次执行函数，这是computed和method的一个重要区别。

计算属性默认只拥有**getter**方法，但是可以自定义一个**setter**方法。

```html
<script>
... ... ...
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + " " + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(" ")
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
... ... ...
// 下面语句触发setter方法，firstName和lastName也会被相应更新
vm.fullName = "John Doe"
</script>
```

### 观察者属性watch

通过watch属性可以手动观察Vue实例上的数据变动，当然也可以调用实例上的`vm.$watch`达到相同的目的。

```html
<div id="watch-example">
  <p>Ask a yes/no question: <input v-model="question"></p>
  <p>{{ answer }}</p>
</div>

<script>
  var watchExampleVM = new Vue({
    el: "#watch-example",
    data: {
      question: "",
      answer: "I cannot give you an answer until you ask a question!"
    },
    watch: {
      // 如果question发生改变，该函数就会运行
      question: function (newQuestion) {
        this.answer = "Waiting for you to stop typing..."
        this.getAnswer()
      }
    },
    methods: {
      // _.debounce是lodash当中限制操作频率的函数
      getAnswer: _.debounce(
        function () {
          if (this.question.indexOf("?") === -1) {
            this.answer = "Questions usually contain a question mark. ;-)"
            return
          }
          this.answer = "Thinking..."
          var vm = this
          axios.get("https://yesno.wtf/api")
            .then(function (response) {
              vm.answer = _.capitalize(response.data.answer)
            })
            .catch(function (error) {
              vm.answer = "Error! Could not reach the API. " + error
            })
        },
        // 这是用户停止输入等待的毫秒数
        500
      )
    }
  })
</script>
```

> 使用watch属性的灵活性在于，当监测到数据变化的时候，可以做一些设置中间状态之类的过渡处理。

### 混合属性mixins

用来将指定的mixin对象复用到Vue组件当中。

```javascript
// mixin对象
var mixin = {
  created: function () {
    console.log("混合对象的钩子被调用")
  },
  methods: {
    foo: function () {
      console.log("foo")
    },
    conflicting: function () {
      console.log("from mixin")
    }
  }
}

// vue属性
var vm = new Vue({
  mixins: [mixin],
  created: function () {
    console.log("组件钩子被调用")
  },
  methods: {
    bar: function () {
      console.log("bar")
    },
    conflicting: function () {
      console.log("from self")
    }
  }
})

// => "混合对象的钩子被调用"
// => "组件钩子被调用"
vm.foo() // => "foo"
vm.bar() // => "bar"
vm.conflicting() // => "from self"
```

> 同名组件option对象的属性会被合并为数组依次进行调用，其中mixin对象里的属性会被首先调用。如果组件option对象的属性值是一个对象，则mixin中的属性会被忽略掉。

### 渲染函数render()

用来创建VNode，该函数接收`createElement()`方法作为第1个参数，该方法调用后会返回一个虚拟DOM（*即VNode*）。

直接使用表达式，或者在`render()`函数内通过`createElement()`进行手动渲染，Vue都会自动保持`blogTitle`属性的响应式更新。

```html
<h1>{{ blogTitle }}</h1>

<script>
render: function (createElement) {
  return createElement("h1", this.blogTitle)
}
</script>
```

> 如果组件是一个函数组件，render()还会接收一个context参数，以便为没有实例的函数组件提供上下文信息。

通过render()函数实现虚拟DOM比较麻烦，因此可以使用Babel插件`babel-plugin-transform-vue-jsx`在render()函数中应用JSX语法。

```javascript
import AnchoredHeading from "./AnchoredHeading.vue"

new Vue({
  el: "#demo",
  render (h) {
    return (
      <AnchoredHeading level={1}>
        <span>Hello</span> world!
      </AnchoredHeading>
    )
  }
})
```


## Vue对象全局API

```javascript
Vue.extend(options)                 // 通过继承一个option对象来创建一个Vue实例。
Vue.nextTick([callback, context])   // 在下次DOM更新循环结束之后执行延迟回调。
Vue.set(target, key, value)         // 设置对象的属性，如果是响应式对象，将会触发视图更新。
Vue.delete(target, key)             // 删除对象的属性，如果是响应式对象，将会触发视图更新。
Vue.directive(id, [definition])     // 注册或获取全局指令。
Vue.filter(id, [definition])        // 注册或获取全局过滤器。
Vue.component(id, [definition])     // 注册或获取全局组件。
Vue.use(plugin)                     // 安装Vue插件。
Vue.mixin(mixin)                    // 全局注册一个mixin对象。
Vue.compile(template)               // 在render函数中编译模板字符串。
Vue.version                         // 提供当前使用Vue的版本号。
```

### Vue.mixin(mixin)

使用全局mixins将会影响到所有**之后创建**的Vue实例。

```javascript
// 为自定义选项myOption注入一个处理器。
Vue.mixin({
  created: function () {
    var myOption = this.$options.myOption
    if (myOption) {
      console.log(myOption)
    }
  }
})

new Vue({
  myOption: "hello!"
})

// => "hello!"
```

### Vue.directive(id, [definition])

Vue允许注册自定义指令，用于对底层DOM进行操作。

```javascript
Vue.directive("focus", {
  bind: function() {
    // 指令第一次绑定到元素时调用，只会调用一次，可以用来执行一些初始化操作。
  },
  inserted: function (el) {
    // 被绑定元素插入父节点时调用。
  },
  update: function() {
    // 所在组件的VNode更新时调用，但是可能发生在其子VNode更新之前。
  },
  componentUpdated: function() {
    // 所在组件VNode及其子VNode全部更新时调用。
  },
  unbind: function() {
    // 指令与元素解绑时调用，只会被调用一次。
  }
})
```

> 钩子之间共享数据可以通过`HTMLElement`的`dataset`属性来进行（*即HTML标签上通过`data-`格式定义的属性*）。

上面的钩子函数拥有如下参数：

* el: 指令绑定的HTML元素，可以用来直接操作DOM。
* vnode: Vue编译生成的虚拟节点。
* oldVnode: 之前的虚拟节点，仅在`update`、`componentUpdated`钩子中可用。
* binding: 一个对象，包含以下属性：
  - name: 指令名称，不包括`v-`前缀。
  - value: 指令的绑定值，例如`v-my-directive="1 + 1"`中`value`的值是`2`。
  - oldValue: 指令绑定的之前一个值，仅在`update`、`componentUpdated`钩子中可用。
  - expression: 绑定值的字符串形式，例如`v-my-directive="1 + 1"`当中`expression`的值为`"1 + 1"`。
  - arg: 传给指令的参数，例如`v-my-directive:foo`中`arg`的值是`"foo"`。
  - modifiers: 包含修饰符的对象，例如`v-my-directive.foo.bar`的`modifiers`的值是`{foo: true, bar: true}`。

> 上面参数除`el`之外，其它参数都应该是只读的，尽量不要对其进行修改操作。

### Vue.filter(id, [definition])

Vue可以通过定义过滤器，进行一些常见的文本格式化，可以用于mustache插值和v-bind表达式当中，使用时通过管道符`|`添加在表达式尾部。

```html
<!-- in mustaches -->
{{ message | capitalize }}

<!-- in v-bind -->
<div v-bind:id="rawId | formatId"></div>

<!-- capitalize filter -->
<script>
  new Vue({
    filters: {
      capitalize: function (value) {
        if (!value) return ""
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
      }
    }
  })
</script>
```

过滤器可以串联使用，也可以传入参数。

```html
<span>{{ message | filterA | filterB }}</span>
<span>{{ message | filterA("arg1", arg2) }}</span>
```

### Vue.use(plugin)

Vue通过插件来添加一些全局功能，Vue插件都会覆写其`install()`方法，该方法第1个参数是`Vue构造器`, 第2个参数是可选的`option对象`:

```javascript
MyPlugin.install = function (Vue, options) {
  // 1. 添加全局方法或属性
  Vue.myGlobalMethod = function () {}

  // 2. 添加全局资源
  Vue.directive("my-directive", {
    bind (el, binding, vnode, oldVnode) {}
  })

  // 3. 注入组件
  Vue.mixin({
    created: function () {}
  })

  // 4. 添加实例方法
  Vue.prototype.$myMethod = function (methodOptions) {}
}
```

通过全局方法`Vue.use()`使用指定插件，使用的时候也可以传入一个option对象。

```javascript
Vue.use(MyPlugin, {someOption: true})
```

> vue-router等插件检测到Vue是全局对象时会自动调用`Vue.use()`，如果在CommonJS模块环境中，则需要显式调用`Vue.use()`。


## 实例属性和方法

Vue实例暴露了一系列带有前缀**$**的实例属性与方法。

```javascript
let vm = new Vue();
vm = {
  // Vue实例属性的代理
  $data: "被watch的data对象",
  $props: "当前组件收到的props",
  $el: "Vue实例使用的根DOM元素",
  $options: "当前Vue实例的初始化选项",
  $parent: "父组件Vue对象的实例",
  $root: "根组件Vue对象的实例",
  $children: "当前实例的直接子组件",
  $slots: "访问被slot分发的内容",
  $scopedSlots: "访问scoped slots",
  $refs: "包含所有拥有ref注册的子组件",
  $isServer: "判断Vue实例是否运行于服务器",
  $attrs: "包含父作用域中非props的属性绑定",
  $listeners: "包含了父作用域中的v-on事件监听器",
  // 数据
  $watch: "观察Vue实例变化的表达式、计算属性函数",
  $set: "全局Vue.set的别名",
  $delete: "全局Vue.delete的别名",
  // 事件
  $on: "监听当前实例上的自定义事件，事件可以由vm.$emit触发",
  $once: "监听一个自定义事件，触发一次之后就移除监听器",
  $off: "移除自定义事件监听器",
  $emit: "触发当前实例上的事件",
  // 生命周期
  $mount: "手动地挂载一个没有挂载的Vue实例",
  $forceUpdate: "强制Vue实例重新渲染，仅影响实例本身和插入插槽内容的子组件",
  $nextTick: "将回调延迟到下次DOM更新循环之后执行",
  $destroy: "完全销毁一个实例",
}
```

### $refs属性

**子**组件指定`ref`属性之后，可以通过**父**组件的`$refs`实例属性对其进行访问 。

```html
<div id="parent">
  <user-profile ref="profile"></user-profile>
</div>

<script>
var parent = new Vue({ el: "#parent" })
var child = parent.$refs.profile // 访问子组件
</script>
```

> $refs会在组件渲染完毕后填充，是非响应式的，仅作为需要直接访问子组件的应急方案，因此要**避免在模板或计算属性中使用$refs**。


## 生命周期

每个Vue实例在创建时，都需要经过一系列初始化过程（*设置数据监听、编译模板、挂载实例到DOM、在数据变化时更新DOM*），并在同时运行一些钩子函数，让开发人员能够在特定生命周期内执行自己的代码。

![](vue/lifecycle.png "组件的生命周期")

> 不要在Vue实例的属性和回调上使用箭头函数，比如`created: () => console.log(this.a)`或`vm.$watch("a", newValue => this.myMethod())`。因为箭头函数的this与父级上下文绑定，并不指向Vue实例本身，所以前面代码中的`this.a`或`this.myMethod`将会是`undefined`。

> 通过jQuery对DOM进行的操作可以放置在`Mounted`属性上进行，即当Vue组件已经完成在DOM上挂载的时候。


## 数据绑定

Vue视图层通过[Mustache](http://mustache.github.io/)`["mʌstæʃ]`语法与Vue实例中的data属性进行响应式绑定，但是也可以通过内置指令`v-once`完成一个单向的绑定，再或者通过`v-html`指令将绑定的字符串输出为HTML，虽然这样很容易招受XSS攻击。

```html
<span>Message: {{ result }}</span>
<span v-once>一次性绑定: {{ msg }}</span>
<div v-html="rawHtml"></div>
```

Mustache不能用于HTML属性，此时需要借助于`v-bind`指令。

```html
<div v-bind:id="dynamicId"></div>
<button v-bind:disabled="isButtonDisabled">Button</button>
```

### 绑定HTML的class和style

直接操作`class`与`style`属性是前端开发当中的常见需求，Vue通过`v-bind:class`和`v-bind:style`指令有针对性的对这两种操作进行了增强。

#### v-bind:class

绑定HTML的`class`属性。

```html
<!-- Vue对象中的data -->
<script>
  ... ...
  data: {
    isActive: true,
    hasError: false,
    classObject: {
      active: true,
      "text-danger": false
    }
  }
  ... ...
</script>

<!-- 直接绑定class到一个对象 -->
<div v-bind:class="classObject"></div>

<!-- 直接绑定class到对象的属性 -->
<div class="static" v-bind:class="{ active: isActive, "text-danger": hasError }"></div>

<!-- 渲染结果 -->
<div class="static active"></div>
```

可以传递一个数组给`v-bind:class`从而同时设置多个class属性。

```html
<!-- Vue对象中的data -->
<script>
  ... ...
  data: {
    activeClass: "active",
    errorClass: "text-danger"
  }
  ... ...
</script>

<!-- 绑定class到计算属性 -->
<div v-bind:class="[activeClass, errorClass]"></div>

<!-- 渲染结果 -->
<div class="active text-danger"></div>

<!-- 使用三目运算符，始终添加errorClass，只在isActive为true时添加activeClass -->
<div v-bind:class="[isActive ? activeClass : "", errorClass]"></div>

<!-- 在数组中使用对象可以避免三目运算符的繁琐 -->
<div v-bind:class="[{ active: isActive }, errorClass]"></div>
```

当在自定义组件上使用`class`属性时，这些属性将会被添加到该组件的根元素上面，这一特性同样适用于`v-bind:class`。

```html
<!-- 声明一个组件 -->
<script>
  Vue.component("my-component", {
    template: "<p class="foo bar">Hi</p>",
    data: {
      isActive: true
    },
  })
</script>

<!-- 添加2个class属性 -->
<my-component class="baz boo"></my-component>

<!-- 渲染结果 -->
<p class="foo bar baz boo">Hi</p>

<!-- 使用v-bind:class -->
<my-component v-bind:class="{ active: isActive }"></my-component>

<!-- 渲染结果 -->
<p class="foo bar active">Hi</p>
```

#### v-bind:style

绑定HTML的`style`属性。

```html
<script>
  ... ...
  data: {
    styleObject: {
      color: "red",
      fontSize: "13px"
    },
    styleHeight: {
      height: 10rem;
    }
    styleWidth: {
      width: 20rem;
    }
  }
  ... ...
</script>

<div v-bind:style="styleObject"></div>

<!-- 使用数组可以将多个样式合并到一个HTML元素上面 -->
<div v-bind:style="[styleHeight, styleWidth]"></div>
```

使用`v-bind:style`时Vue会自动添加*prefix前缀*，常见的prefix前缀如下：

* `-webkit-` Chrome、Safari、新版Opera、所有iOS浏览器(包括iOS版Firefox)，几乎所有WebKit内核浏览器。
* `-moz-` 针对Firefox浏览器。
* `-o-` 未使用WebKit内核的老版本Opera。
* `-ms-` 微软的IE以及Edge浏览器。

### 使用JavaScript表达式

Vue对于所有数据绑定都提供了JavaScript表达式支持，但是每个绑定只能使用**1**个表达式。

```html
<span>{{ number + 1 }}</span>
<button>{{ ok ? "YES" : "NO" }}</button>
<p>{{ message.split("").reverse().join("") }}</p>
<div v-bind:id=""list-" + id"></div>

<!-- 这是语句，不是表达式 -->
{{ var a = 1 }}

<!-- if流程控制属于多个表达式，因此不会生效，但可以使用三元表达式 -->
{{ if (ok) { return message } }}
```

### v-model双向数据绑定

`v-model`指令实质上是`v-on`和`v-bind`的糖衣语法，该指令会接收一个`value属性`，存在新值时则触发一个`input事件`。

```html
<!-- 使用v-model的版本 -->
<input v-model="something">
<!-- 使用v-on和v-bind的版本 -->
<input v-bind:value="something"
       v-on:input="something = $event.target.value">
<!-- 也可以自定义输入域的响应式绑定 -->
<custom-input
  v-bind:value="something"
  v-on:input="something = arguments[0]">
</custom-input>
```

> 单选框、复选框一类的输入域将value属性作为了其它用途，因此可以通过组件的`model`选项来避免冲突：


## 内置指令

带有`v-`前缀，当表达式值发生变化时，会响应式的将影响作用于DOM。指令可以接收后面以`:`表示的**参数**（*被指令内部的arg属性接收*），或者以`.`开头的**修饰符**（*指定该指令以特殊方式绑定*）。

```html
<p v-if="seen">Hello world!</p>

<!-- 绑定事件 -->
<a v-bind:href="url"></a>

<!-- 绑定属性 -->
<a v-on:click="doSomething">

<!-- .prevent修饰符会告诉v-on指令对于触发的事件调用event.preventDefault() -->
<form v-on:submit.prevent="onSubmit"></form>
```

Vue为`v-bind`和`v-on`这两个常用的指令提供了简写形式`:`和`@`。

```html
<!-- v-bind -->
<a v-bind:href="url"></a>
<a :href="url"></a>

<!-- v-on -->
<a v-on:click="doSomething"></a>
<a @click="doSomething"></a>
```

目前，Vue在*2.4.2*版本当中提供了如下的内置指令：

```html
<html
  v-text = "更新元素的textContent"
  v-html = "更新元素的innerHTML"
  v-show = "根据表达式的true/false，切换HTML元素的display属性"
  v-for = "遍历内部的HTML元素"
  v-pre = "跳过表达式渲染过程，可以显示原始的Mustache标签"
  v-cloak = "保持在HTML元素上直到关联实例结束编译，可以隐藏未编译的Mustache"
  v-once = "只渲染元素和组件一次"
></html>

<!-- 根据表达式的true和false来决定是否渲染元素 -->
<div v-if="type === "A"">A</div>
<div v-else-if="type === "B"">B</div>
<div v-else-if="type === "C"">C</div>
<div v-else>Not A/B/C</div>

<!-- 动态地绑定属性或prop到表达式 -->
<p v-bind:attrOrProp
  .prop = "被用于绑定DOM属性"
  .camel = "将kebab-case特性名转换为camelCase"
  .sync = "语法糖，会扩展成一个更新父组件绑定值的v-on监听器"
></p>

<!-- 绑定事件监听器 -->
<button
  v-on:eventName
  .stop = "调用event.stopPropagation()"
  .prevent = "调用event.preventDefault()"
  .capture = "添加事件监听器时使用capture模式"
  .self = "当事件是从监听器绑定的元素本身触发时才触发回调" 
  .native = "监听组件根元素的原生事件"-
  .once = "只触发一次回调"
  .left = "点击鼠标左键触发"
  .right = "点击鼠标右键触发"
  .middle = "点击鼠标中键触发"
  .passive = "以{passive: true}模式添加监听器"
  .{keyCode | keyAlias} = "触发特定键触事件"
>
</button>

<!-- 表单控件的响应式绑定 -->
<input 
  v-model
  .lazy = "取代input监听change事件"
  .number = "输入字符串转为数字"
  .trim = "过滤输入的首尾空格" />
```


## 组件

组件可以扩展HTML元素功能，并且封装可重用代码。可以通过`Vue.component( id, [definition] )`注册或者获取全局组件。

```javascript
// 注册组件，传入一个扩展过的构造器
Vue.component("my-component", Vue.extend({ ... }))

// 注册组件，传入一个option对象（会自动调用Vue.extend）
Vue.component("my-component", { ... })

// 获取注册的组件(始终返回构造器)
var MyComponent = Vue.component("my-component")
```

下面代码创建了一个Vue实例，并将自定义组件`my-component`挂载至HTML当中。

```html
<script>
  // 注册自定义组件
  Vue.component("my-component", {
    template: "<div>A custom component!</div>"
  })

  // 创建Vue根实例
  new Vue({
    el: "#example"
  })
</script>

<!-- 原始模板 -->
<div id="example">
  <my-component></my-component>
</div>

<!-- 渲染结果 -->
<div id="example">
  <div>A custom component!</div>
</div>
```

- is属性

浏览器解析完HTML之后才会渲染Vue表达式，但是诸如`<ul> <ol> <table> <select>`限制了可以被包裹的HTML元素，而`<option>`只能出现在某些HTML元素内部，造成Vue表达式可能不会被正确的渲染。因此，Vue提供`is`作为属性别名来解决该问题。

```html
<!-- 不正确的方式 -->
<table>
  <my-row>...</my-row>
</table>

<!-- 使用is的正确方式 -->
<table>
  <tr is="my-row"></tr>
</table>
```

- data必须是函数

`Vue.component()`传入的data属性不能是对象，而必须是函数。这样做的目的是避免组件在相同模板的多个位置被复用时，仅仅返回对象会造成组件间的数据被相互污染，而通过函数每次都返回全新的data对象能完美的规避这个问题。

```javascript
Vue.component("simple-counter", {
  template: "<button v-on:click="counter += 1">{{ counter }}</button>",
  data: function () {
    return {
      a: "",
      b: ""
    }
  }
});
```

- 父子组件之间的通信

父组件通过`props`向下传递数据给子组件，子组件通过`events`给父组件发送消息，即**props down, events up**。

![](vue/props-events.png "父子组件通信")

### props

虽然每个组件的作用域都是独立的，但是可以通过`props属性`向子组件传递数据，这是一种**单向数据流**的体现形式。

```javascript
Vue.component("child", {
  // 声明props
  props: ["message"],
  // 和data属性一样，prop也可以在vm通过this.message进行引用
  template: "<span>{{ message }}</span>"
})
```

> 不要在子组件内部修改props，这样会导致后台报错。

#### 命名方式转换

因为HTML并不区分大小写，所以kebab-case(*驼峰*)风格命名的props，在组件中会以camelCased(*短横线隔开*)风格被接收。

```html
<!-- camelCase in JavaScript -->
<script>
Vue.component("child", {
  props: ["myMessage"],
  template: "<span>{{ myMessage }}</span>"
})
<script>

<!-- kebab-case in HTML -->
<child my-message="hello!"></child>
```

#### 动态props

可以通过`v-bind`指令，响应式的绑定父组件数据到子组件的props。当父组件数据变化时，该变化也会传导至子组件。

```html
<div>
  <input v-model="parentMsg">
  <br>
  <child v-bind:my-message="parentMsg"></child>
</div>
```

使用`v-bind`可以让其参数值能够以JavaScript表达式的方式被解析，否则所有传入的props都会被子组件认为是字符串类型。

```html
<!-- 传递的是字符串"1" -->
<comp some-prop="1"></comp>
<!-- 传递实际的 number -->
<comp v-bind:some-prop="1"></comp>
```

#### 验证props

可以为组件的props指定验证规则，如果传入数据不符合要求，Vue会发出相应警告，这样可以有效提高组件的健壮性。

```javascript
Vue.component("example", {
  props: {
    // 基础类型检测
    propA: Number,
    // 多种类型
    propB: [String, Number],
    // 必传且是字符串
    propC: {
      type: String,
      required: true
    },
    // 数字，有默认值
    propD: {
      type: Number,
      default: 100
    },
    // 数组或对象的默认值由1个工厂函数返回
    propE: {
      type: Object,
      default: function () {
        return { message: "hello" }
      }
    },
    // 自定义验证函数
    propF: {
      validator: function (value) {
        return value > 10
      }
    }
  }
});
```

> `props`会在组件实例创建之前进行校验。

#### 组件的非props属性

组件可以接收任意传入的属性，这些属性都会被添加到组件HTML模板的根元素上（*无论有没有在props中定义*）。

```html
<!-- 带有属性的自定义组件 -->
<bs-date-input
  data-3d-date-picker="true"
  class="date-picker-theme-dark">
</bs-date-input>

<!-- 渲染出来的组件，class属性被合并 -->
<input type="date" data-3d-date-picker="true" class="form-control date-picker-theme-dark">
```

> 父组件传递给子组件的属性可能会覆盖子组件本身的属性，因而会对子组件造成破坏和污染。

### 事件

子组件可以通过Vue的自定义事件与父组件进行通信。

每个Vue实例都实现了如下API，但是并不能直接通过$on监听子组件冒泡的事件，而必须使用v-on指令。

1. `$on(eventName)` 监听事件
2. `$emit(eventName)` 触发事件

> `$on`和`$emit`并不是`addEventListener`和`dispatchEvent`的别名。

```html
<div id="counter-event-example">
  <p>{{ total }}</p>
  <button-counter v-on:increment="incrementTotal"></button-counter>
  <button-counter v-on:increment="incrementTotal"></button-counter>
</div>

<script>
  Vue.component("button-counter", {
    template: "<button v-on:click="incrementCounter">{{ counter }}</button>",
    data: function () {
      return {
        counter: 0
      }
    },
    methods: {
      // 子组件事件
      incrementCounter: function () {
        this.counter += 1
        this.$emit("increment") //向父组件冒泡事件
      }
    },
  })

  new Vue({
    el: "#counter-event-example",
    data: {
      total: 0
    },
    methods: {
      // 父组件事件
      incrementTotal: function () {
        this.total += 1
      }
    }
  })
</script>
```

* `.native`修饰符

开发人员也可以在组件的根元素上监听原生事件，这个时候需要借助到`.native`修饰符。

```html
<my-component v-on:click.native="doTheThing"></my-component>
```

* `.sync`修饰符

Vue中的`props`本质是不能进行响应式绑定的，以防止破坏单向数据流，造成多个子组件对父组件状态形成污染。但是生产环境下，`props`响应式绑定的需求是切实存在的。因此，Vue将`.sync`修饰符封装为糖衣语法，父组件在子组件的props使用该修饰符后，父组件会为props自动绑定`v-on`事件，子组件则在监听到props变化时向父组件`$emit`更新事件，从而让父组件的`props`能够与子组件进行同步。

```html
<!-- 使用.sync修饰符 -->
<comp :foo.sync="bar"></comp>

<!-- 被自动扩展为如下形式，该组件的子组件会通过this.$emit("update:foo", newValue)显式触发更新事件 -->
<comp :foo="bar" @update:foo="val => bar = val"></comp>
```

* 平行组件通信

非父子关系的组件进行通信时，可以使用一个**空**的Vue实例作为**中央事件总线**。

```javascript
var bus = new Vue()
// 触发组件A中的事件
bus.$emit("id-selected", 1)
// 在组件B监听事件
bus.$on("id-selected", function (id) {
  ... ... ...
})
```

> 更好的方式是借助VueX或者Redux之类的flux状态管理库。

### slot

可以将父组件的内容混入到子组件的模板当中，此时可以在子组件中使用`<slot>`作为父组件内容的插槽。

> 父组件模板的内容在父组件作用域内编译，子组件模板的内容在子组件作用域内编译。

#### 匿名插槽

当子组件只有一个没有属性的`<slot>`时，父组件全部内容片段将插入到插槽所在的DOM位置，并替换插槽标签本身。

```html
<!-- 子组件my-component的模板 -->
<div>
  <h2>Child</h2>
  <slot>
    父组件没有需要插入的内容时显示
  </slot>
</div>

<!-- 父组件模板中使用my-component -->
<div>
  <h1>Parent</h1>
  <child>
    <p>Content 1</p>
    <p>Content 2</p>
  </child>
</div>

<!-- 渲染结果 -->
<div>
  <h1>Parent</h1>
  <div>
    <h2>Child</h2>
    <p>Content 1</p>
    <p>Content 2</p>
  </div>
</div>
```

> `<slot>`标签中的内容会在子组件作用域内编译，并在父组件没有需要插入的内容时才会显示。

#### 具名插槽

可以通过`<slot>`元素的`name`属性来配置如何分发内容。

```html
<!-- 子组件 -->
<div id="app">
  <header>
    <slot name="header"></slot>
  </header>
  <main>
    <slot></slot>
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>

<!-- 父组件 -->
<app>
  <div slot="header">Header</div>
  <p>Content 1</p>
  <p>Content 2</p>
  <div slot="footer">Footer</div>
</app>

<!-- 渲染结果 -->
<div id="app">
  <header>
    <div>Header</div>
  </header>
  <main>
    <p>Content 1</p>
    <p>Content 2</p>
  </main>
  <footer>
    <p>Footer</p>
  </footer>
</div>
```

> 匿名slot会作为没有匹配内容的父组件片段的插槽。

#### 作用域插槽

子组件通过`props`传递数据给`<slot>`插槽，父组件使用带有`scope`属性的`<template>`来表示表示当前作用域插槽的模板，`scope`值对应的变量会接收子组件传递来的props对象。

```html
<!-- 子组件通过props传递数据给插槽 -->
<div class="child">
  <slot text="hello from child"></slot>
</div>

<!-- 父组件使用带有scope属性的<template> -->
<div class="parent">
  <child>
    <template scope="props">
      <span>hello from parent</span>
      <span>{{ props.text }}</span>
    </template>
  </child>
</div>

<!-- 渲染结果 -->
<div class="parent">
  <div class="child">
    <span>hello from parent</span>
    <span>hello from child</span>
  </div>
</div>
```

### 函数化组件

即无状态（*没有data*）无实例（*没有this上下文*）的组件，渲染开销较小，且不会出现在`Vue devtools`当中。

```javascript
Vue.component("my-component", {
  functional: true,
  // 通过提供context参数为没有实例的函数组件提供上下文信息
  render: function (createElement, context) {},
  // Props可选
  props: {}
})
```

### 动态组件

使用`<component>`元素并动态绑定其`is`属性，可以让多个组件使用相同的Vue对象挂载点，并实现动态切换。

```html
<script>
var vm = new Vue({
  el: "#example",
  data: {
    currentView: "home"
  },
  components: {
    home: { /* ... */ },
    posts: { /* ... */ },
    archive: { /* ... */ }
  }
})
</script>

<component v-bind:is="currentView">
  <!-- 组件在vm.currentview变化时改变！ -->
</component>
```

如果需要将切换的组件保持在内存，保留其状态并且避免重新渲染，可以使用Vue内置的`keep-alive`指令。

```html
<keep-alive>
  <component :is="currentView">
    <!-- 非活动组件将被缓存！ -->
  </component>
</keep-alive>
```

### 组件异步加载

Vue允许将组件定义为工厂函数，从而异步的解析组件定义。Vue只会在组件渲染时才触发工厂函数，并将结果缓存起来用于后续渲染。定义组件的工厂函数将会接收resolve（*接收到从服务器下载的Vue组件options时被调用*）和reject（*当远程Vue组件options加载失败时调用*）回调函数作为参数。

```javascript
Vue.component("async-example", function (resolve, reject) {
  setTimeout(function () {
    // 将组件定义传递到resolve回调函数当中
    resolve({
      template: "<div>I am async!</div>"
    })
  }, 1000)
})
```

可以结合Webpack提供的**代码切割**功能，将Vue组件的options对象提取到单独JavaScript文件，从而实现异步的按需加载。

```javascript
// 使用webpack的require()来进行异步代码块切割
Vue.component("async-webpack-example", function (resolve) {
  require(["./my-async-component"], resolve)
})

// 使用webpack的import()来进行异步代码块切割
Vue.component(
  "async-webpack-example", () => import("./my-async-component")
)
```

从Vue 2.3.0版本开始，可以通过下面的方式来定义一个异步组件。

```javascript
const AsyncWebpackExample = () => ({
  component: import("./MyComp.vue"),   // 需要加载的组件
  loading: LoadingComp,                // loading时渲染的组件
  error: ErrorComp,                    // 出错时渲染的组件
  delay: 200,                          // 渲染loading组件前的等待时间（默认：200ms）
  timeout: 3000                        // 最长等待时间，超出则渲染error组件（默认：Infinity）
})
```

> 在路由组件上使用这种写法，需要使用vue-router的2.4.0以上版本。

### 组件的循环引用

循环引用，即两个组件互相引用对方，例如下面代码中`tree-folder`、`tree-folder-contents`两个组件同时成为了对方的父或子节点，如果使用Webpack模块化管理工具`requiring`/`importing`组件的时候，会报出`Failed to mount component: template or render function not defined.`错误。

```html
<template>
  <p>
    <span>{{ folder.name }}</span>
    <tree-folder-contents :children="folder.children"/>
  </p>
</template>

<template>
  <ul>
    <li v-for="child in children">
      <tree-folder v-if="child.children" :folder="child"/>
      <span v-else>{{ child.name }}</span>
    </li>
  </ul>
</template>
```

因为`tree-folder`、`tree-folder-contents`相互引用对方之后，无法确定组件加载的先后顺序陷入死循环，所以需要事先指明webpack组件加载的优先级。解决上面例子中Vue组件循环引用的问题，可以在`tree-folder`组件的`beforeCreate()`生命周期函数内注册引发问题的`tree-folder-contents`组件。

```javascript
beforeCreate: function () {
  this.$options.components.TreeFolderContents = require("./tree-folder-contents.vue").default
}
```

### 组件命名约定

JavaScript中命名组件组件时可以使用`kebab-case`、`camelCase`、`PascalCase`，但HTML模板中只能使用`kebab-case`格式。

```html
<kebab-cased-component></kebab-cased-component>
<camel-cased-component></camel-cased-component>
<pascal-cased-component></pascal-cased-component>
<!-- 也可以通过自关闭方式使用组件 -->
<kebab-cased-component />

<script>
components: {
  "kebab-cased-component": {},
  "camelCasedComponent": {},
  "PascalCasedComponent": {}
}
</script>
```

> 推荐JavaScript中通过`PascalCase`方式声明组件， HTML中则通过`kebab-case`方式使用组件。

### 组件递归

当局部注册的Vue组件递归调用自身时，需要在创建组件时添加`name`选项，全局注册的组件则可以省略该属性，因为Vue会自动进行添加。

```javascript
// 局部注册
new Vue({
  el: "#my-component",
  name: "my-component",
  template: "<div><my-component></my-component></div>"
})

// 全局注册
Vue.component("my-component", {
  // name: "my-component", 可以省略name属性
  template: "<div><my-component></my-component></div>"
})
```

> 组件递归出现死循环时，会提示`max stack size exceeded`错误，所以需要确保递归操作都拥有一个终止条件（*比如使用v-if并返回false*）。

### 组件模板

- 可以在Vue组件上使用`inline-template`属性，组件会将内嵌的HTML内容作为组件本身的模板进行渲染，而非将其作为`slot`分发的内容。

```html
<my-component inline-template>
  <div>
    <p>These are compiled as the component"s own template.</p>
    <p>Not parent"s transclusion content.</p>
  </div>
</my-component>
```

- 也可以通过在`<script>`标签内使用`type="text/x-template"`和`id`属性来定义一个内嵌模板。

```html
<script type="text/x-template" id="hello-world-template">
  <p>Hello hello hello</p>
</script>

<script>
Vue.component("hello-world", {
  template: "#hello-world-template"
})
</script>
```


## Vuex状态管理

Vuex是专门为Vue应用程序提供的状态管理模式，每个Vuex应用的核心是`store`（*仓库*），即装载应用程序`state`（*状态*）的容器，每个应用通常只拥有一个`store`实例。

![](vue/vuex.png "Vuex执行流程")

Vuex的`state`是响应式的，即`store`中的`state`发生变化时，相应组件也会进行更新，修改`store`当中`state`的唯一途径是提交`mutations`。

```javascript
const store = new Vuex.Store({
  state: {
    count: 0
  },
  mutations: {
    increment (state) {
      state.count++
    }
  }
})

store.commit("increment")       // 通过store.state来获取状态对象

console.log(store.state.count)  // 通过store.commit()改变状态
```

### State

从`store`当中获取`state`的最简单办法是在计算属性中返回指定的`state`，每当`state`发生改变的时候都会重新执行计算属性，并且更新关联的DOM。

```javascript
const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count () {
      return store.state.count
    }
  }
}
```

Vuex提供`store`选项，将`state`从根组件**注入**到每个子组件中，从而避免频繁`import store`。

```javascript
// 父组件中注册store属性
const app = new Vue({
  el: "#app",
  store: store,
  components: { Counter },
  template: `
    <div class="app">
      <counter></counter>
    </div>`
})

// 子组件，store会注入到子组件，子组件可通过this.$store进行访问
const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count () {
      return this.$store.state.count
    }
  }
}
```

Vuex提供`mapState()`辅助函数，避免使用多个`state`的场景下，多次去声明计算属性。

```javascript
// 在单独构建的版本中辅助函数为 Vuex.mapState
import { mapState } from "vuex"

export default {
  computed: mapState({
    count: state => state.count,
    // 传递字符串参数"count"等同于`state => state.count`
    countAlias: "count",
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
}

// 当计算属性名称与state子节点名称相同时，可以向mapState传递一个字符串数组
computed: mapState([
  "count" // 映射this.count到store.state.count
])
```

`mapState()`函数返回一个包含有`state`相关计算属性的对象，这里可以通过ES6的对象展开运算符`...`将该对象与Vue组件本身的`computed`属性进行合并。

```javascript
computed: {
  localComputed () {},
  ...mapState({})
}
```

Vuex允许在`store`中定义`getters`（*可视为store的计算属性*），`getters`的返回值会根据其依赖被缓存，只有当依赖值发生了改变才会被重新计算。该方法接收`state`作为第1个参数，其它`getters`作为第2个参数。可以直接在`store`上调用`getters`来获取指定的计算值。

```javascript
const store = new Vuex.Store({
  state: {
    todos: [
      { id: 1, text: "...", done: true },
      { id: 2, text: "...", done: false }
    ]
  },
  getters: {
    doneTodos: (state, getters) => {
      return state.todos.filter(todo => todo.done)
    }
  }
})

// 获取doneTodos = [{ id: 1, text: "...", done: true }]
store.getters.doneTodos
```

这样就可以方便的根据`store`中现有的`state`派生出新的`state`，从而避免在多个组件中复用时造成代码冗余。

```javascript
computed: {
  doneTodosCount () {
    return this.$store.getters.doneTodos // 现在可以方便的在Vue组件使用store中定义的doneTodos
  }
}
```

Vuex提供的`mapGetters()`辅助函数将`store`中的`getters`映射到局部计算属性。

```javascript 
import { mapGetters } from "vuex"

export default {
  computed: {
    // 使用对象展开运算符将getters混入computed计算属性
    ...mapGetters([
      "doneTodosCount",
      doneCount: "doneTodosCount" // 映射store.getters.doneTodosCount到别名this.doneCount
    ])
  }
}
```

### Mutations

修改store中的state的唯一方法是提交mutation（*[mjuː"teɪʃ(ə)n] n.变化*），mutations类似于自定义事件，拥有一个字符串事件类型和一个回调函数（*接收state作为参数，是对state进行修改的位置*）。

```javascript
const store = new Vuex.Store({
  state: {
    count: 1
  },
  mutations: {
    // 触发类型为increment的mutation时被调用
    increment (state) {
      state.count++ // 变更状态
    }
  }
})

// 触发mutation
store.commit("increment")
```

可以通过store的`commit()`方法触发指定的mutations，也可以通过`store.commit()`向mutation传递参数。

```javascript
// commit()
store.commit({
  type: "increment",
  amount: 10
})

// store
mutations: {
  increment (state, payload) {
    state.count += payload.amount
  }
}
```

mutation事件类型建议使用常量，并且将这些常量放置在单独文件，便于管理和防止重复。

```javascript
// mutation-types.js
export const SOME_MUTATION = "SOME_MUTATION"

// store.js
import Vuex from "vuex"
import { SOME_MUTATION } from "./mutation-types"

const store = new Vuex.Store({
  state: { ... },
  mutations: {
    // 可以通过ES6的计算属性命名特性去使用常量作为函数名
    [SOME_MUTATION] (state) {
      // mutate state
    }
  }
})
```

> `mutation()`必须是同步函数，因为devtool无法追踪回调函数中对`state`进行的异步修改。

Vue组件可以使用`this.$store.commit("xxx")`提交mutation，或者使用`mapMutations()`将Vue组件中的`methods`映射为`store.commit`调用（*需要在根节点注入`store`*）。

```javascript
import { mapMutations } from "vuex"

export default {
  methods: {
    ...mapMutations([
      "increment" // 映射this.increment()为this.$store.commit("increment")
    ]),
    ...mapMutations({
      add: "increment" // 映射this.add()为this.$store.commit("increment")
    })
  }
}
```

### Actions

Action用来提交mutation，且Action中可以包含异步操作。Action函数接受一个与store实例具有相同方法和属性的`context`对象，因此可以通过调用`context.commit`提交一个mutation，或者通过`context.state`和`context.getters`来获取state、getters。

```javascript
const store = new Vuex.Store({
  state: {
    count: 0
  },
  mutations: {
    increment (state) {
      state.count++
    }
  },
  actions: {
    increment (context) {
      context.commit("increment")
    }
  }
})
```

生产环境下，可以通过ES6的解构参数来简化代码。

```javascript
actions: {
  // 直接向action传递commit方法
  increment ({ commit }) {
    commit("increment")
  }
}
```

Action通过`store.dispatch()`方法进行分发，**mutation**当中只能进行**同步**操作，而**action**内部可以进行**异步**的操作。下面是一个购物车的例子，代码中分发了多个mutations，并进行了异步API操作。

```javascript
actions: {
  checkout ({ commit, state }, products) {
    
    const savedCartItems = [...state.cart.added]  // 把当前购物车的物品备份起来
    commit(types.CHECKOUT_REQUEST)                // 发出结账请求，然后清空购物车
    // 购物Promise分别接收成功和失败的回调
    shop.buyProducts(
      products,
      () => commit(types.CHECKOUT_SUCCESS),                  // 成功操作
      () => commit(types.CHECKOUT_FAILURE, savedCartItems)   // 失败操作
    )
  }
}
```

组件中可以使用`this.$store.dispatch("xxx")`分发action，或者使用`mapActions()`将组件的`methods`映射为`store.dispatch`（*需要在根节点注入`store`*）。

```javascript
import { mapActions } from "vuex"

export default {
  methods: {
    ...mapActions([
      "increment"       // 映射this.increment()为this.$store.dispatch("increment")
    ]),
    ...mapActions({
      add: "increment"  // 映射this.add()为this.$store.dispatch("increment")
    })
  }
}
```

`store.dispatch`可以处理`action`回调函数当中返回的`Promise`，并且`store.dispatch`本身仍然返回一个`Promise`。

```javascript
actions: {
  // 定义一个返回Promise对象的actionA
  actionA ({ commit }) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        commit("someMutation") // 触发mutation
        resolve()
      }, 1000)
    })
  },
  // 也可以在actionB中分发actionA
  actionB ({ dispatch, commit }) {
    return dispatch("actionA").then(() => {
      commit("someOtherMutation") // 触发另外一个mutation
    })
  }
}

// 现在可以分发actionA
store.dispatch("actionA").then(() => {
  ... ... ...
})
```

可以体验通过ES7的异步处理特性`async`/`await`来组合action。

```javascript
actions: {
  async actionA ({ commit }) {
    commit("gotData", await getData())
  },
  async actionB ({ dispatch, commit }) {
    await dispatch("actionA") //等待actionA完成
    commit("gotOtherData", await getOtherData())
  }
}
```

### Module

整个应用使用单一状态树的情况下，所有state都会集中到一个store对象，因此store可能变得非常臃肿。因此，Vuex允许将store切割成模块（*module*），每个模块拥有自己的`state`、`mutation`、`action`、`getter`、甚至是嵌套的子模块。

```javascript
const moduleA = {
  state: {},
  mutations: {},
  actions: {},
  getters: {}
}

const moduleB = {
  state: {},
  mutations: {},
  actions: {}
}

const store = new Vuex.Store({
  modules: {
    a: moduleA,
    b: moduleB
  }
})

store.state.a // moduleA的状态
store.state.b // moduleB的状态
```

module内部的`mutations()`和`getters()`接收的第1个参数是模块的局部状态对象。

```javascript
const moduleA = {
  state: { count: 0 },
  mutations: {
    increment (state) {
      state.count++ // 这里的state是模块的局部状态
    }
  },
  getters: {
    doubleCount (state) {
      return state.count * 2
    }
  }
}
```

模块内部action当中，可以通过`context.state`获取局部状态，以及`context.rootState`获取全局状态。

```javascript
const moduleA = {
  // ...
  actions: {
    incrementIfOddOnRootSum ({ state, commit, rootState }) {
      if ((state.count + rootState.count) % 2 === 1) {
        commit("increment")
      }
    }
  }
}
```

模块内部的`getters()`方法，可以通过其第3个参数接收到全局状态。

```javascript
const moduleA = {
  getters: {
    sumWithRootCount (state, getters, rootState) {
      return state.count + rootState.count
    }
  }
}
```

### 严格模式

严格模式下，如果state变化不是由`mutation()`函数引起，将会抛出错误。只需要在创建`store`的时候传入`strict: true`即可开启严格模式。

```javascript
const store = new Vuex.Store({
  strict: true
})
```

不要在生产环境下启用严格模式，因为它会深度检测不合法的state变化，从而造成不必要的性能损失，我们可以通过在构建工具中增加如下判断避免这种情况。

```javascript
const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== "production"
})
```

> 严格模式下，在属于Vuex的state上使用v-model指令会抛出错误，此时需要手动绑定value并监听input、change事件，并在事件回调中手动提交action。另外一种实现方式是直接重写计算属性的get和set方法。

### 总结

1. 应用层级的状态应该集中到**单个store对象**中。
2. 提交`mutation`是更改状态的唯一方法，并且这个过程是**同步**的。
3. **异步**逻辑都应该封装到`action`里面。

## Webpack Vue Loader

[vue-loader](https://vue-loader.vuejs.org/en/)是由Vue开源社区提供的Webpack加载器，用来将`.vue`后缀的单文件组件转换为JavaScript模块，每个`.vue`单文件组件可以包括以下部分：

1. 一个`<template>`。
2. 一个`<script>`。
3. 多个`<style>`。

```html
<template>只能有1个</template>

<script>只能有1个</script>

<style>可以有多个</style>
<style>可以有多个</style>
<style>可以有多个</style>
```

### CSS作用域

向`.vue`单文件组件的`<style>`标签上添加`scoped`属性，可以让该`<style>`标签中的样式只作用于当前组件。使用scoped时，样式选择器尽量使用class或者id，以提升页面渲染性能。

```html
<!-- 单文件组件定义 -->
<style scoped>
.example {
  color: red;
}
</style>

<template>
  <div class="example">Hank</div>
</template>

<!-- 转换结果 -->
<style>
.example[data-v-f3f3eg9] {
  color: blue;
}
</style>

<template>
  <div class="example" data-v-f3f3eg9>Hank</div>
</template>
```

> 可以在一个组件中同时使用带`scoped`属性和不带该属性的`<style/>`，分别用来定义组件私有样式和全局样式。

### CSS模块化

在单文件组件`.vue`的`<style>`标签上添加`module`属性即可打开CSS模块化特性。[CSS Modules](https://github.com/css-modules/css-modules)用于模块化组合CSS，[vue-loader](https://vue-loader.vuejs.org/en/features/css-modules.html)已经集成了CSS模块化特性。

```html
<style module>
.red {
  color: red;
}
.bold {
  font-weight: bold;
}
</style>
```

CSS模块会向Vue组件中注入名为`$style`计算属性，从而实现在组件的`<template/>`中使用动态的`class`属性进行绑定。

```html
<template>
  <p :class="$style.red">
    This should be red
  </p>
</template>
```


## 动画

Vue在插入、更新、移除**DOM**的时候，提供了如下几种方式去展现进入（*entering*）和离开（*leaving*）的过渡效果。

1. 在CSS过渡和动画中应用class。
2. 钩子过渡函数中直接操作DOM。
3. 使用CSS、JavaScript动画库，如[Animate.css](https://daneden.github.io/animate.css/)、[Velocity.js](http://velocityjs.org/)。

### transition组件

Vue提供了内置组件`<transition/>`来为HTML元素、Vue组件添加过渡动画效果，可以在*条件展示*（*使用`v-if`或`v-show`*）、*动态组件*、*展示组件根节点*的情况下进行渲染。`<transition/>`主要用来处理单个节点，或者同时渲染多个节点当中的一个。

#### 自动切换的class类名

在组件或HTML进入（*entering*）和离开（*leaving*）的过渡效果当中，Vue将会自动切换并应用下图中的六种class类名。

![](vue/transition.png "过渡效果自动切换的class")

可以使用`<transition/>`的`name`属性来自动生成过渡class类名，例如下面例子中的`name: "fade"`将自动拓展为`.fade-enter`，`.fade-enter-active`等，`name`属性缺省的情况下默认类名为`v`。

```html
<div id="demo">
  <button v-on:click="show = !show"> Toggle </button>
  <transition name="fade">
    <p v-if="show">hello</p>
  </transition>
</div>

<script>
new Vue({
  el: "#demo",
  data: {
    show: true
  }
})
</script>

<style>
.fade-enter-active, .fade-leave-active {
  transition: opacity .5s
}
.fade-enter, .fade-leave-to {
  opacity: 0
}
</style>
```

#### 自定义CSS类名

结合`Animate.css`使用时，可以在`<transition/>`当中通过以下属性自定义class类名。

```html
<transition
  enter-class = "animated"
  enter-active-class = "animated"
  enter-to-class = "animated"
  leave-class = "animated"
  leave-active-class = "animated"
  leave-to-class = "animated">
</transition>
```

#### 自定义JavaScript钩子

结合`Velocity.js`使用时，通过v-on在属性中设置钩子函数。

```html
<transition
  v-on:before-enter="beforeEnter"
  v-on:enter="enter"
  v-on:after-enter="afterEnter"
  v-on:enter-cancelled="enterCancelled"
  v-on:before-leave="beforeLeave"
  v-on:leave="leave"
  v-on:after-leave="afterLeave"
  v-on:leave-cancelled="leaveCancelled">
</transition>

<script>
// ...
methods: {
  beforeEnter: function (el) {},
  enter: function (el, done) { done() },
  afterEnter: function (el) {},
  enterCancelled: function (el) {},
  beforeLeave: function (el) {},
  leave: function (el, done) { done() },
  afterLeave: function (el) {},
  leaveCancelled: function (el) {} // 仅用于v-show
}
</script>
```

#### 显式设置过渡持续时间

可以使用`<transition>`上的`duration属性`设置一个以毫秒为单位的显式过渡持续时间。

```html
<transition :duration="1000"> Hank </transition>

<!-- 可以分别定制进入、移出的持续时间 -->
<transition :duration="{ enter: 500, leave: 800 }"> Hank </transition>
```

#### 组件首次渲染时的过渡

通过`<transition>`上的`appear属性`设置组件节点首次被渲染时的过渡动画。

```html
<!-- 自定义CSS类名 -->
<transition
  appear
  appear-class="custom-appear-class"
  appear-to-class="custom-appear-to-class"
  appear-active-class="custom-appear-active-class">
</transition>

<!-- 自定义JavaScript钩子 -->
<transition
  appear
  v-on:before-appear="customBeforeAppearHook"
  v-on:appear="customAppearHook"
  v-on:after-appear="customAfterAppearHook"
  v-on:appear-cancelled="customAppearCancelledHook">
</transition>
```

#### HTML元素的过渡效果

##### Vue组件的key属性

key属性主要用在Vue虚拟DOM算法中去区分新旧VNodes，不显式使用`key`的时候，Vue会使用性能最优的自动比较算法。显式的使用`key`，则会基于`key`的变化重新排列元素顺序，并移除不存在`key`的元素。具有相同父元素的子元素必须有独特的`key`，因为重复的`key`会造成渲染错误。

```html
<ul>
  <!-- 最常见的用法是在使用v-for的时候 -->
  <li v-for="item in items" :key="item.id">...</li>
</ul>
```

##### 元素的的交替过渡

可以通过Vue提供的`v-if`和`v-else`属性来实现多组件的交替过渡，最常见的过渡效果是一个列表以及描述列表为空时的消息。

```html
<transition>
  <table v-if="items.length > 0">
    <!-- ... -->
  </table>
  <p v-else>Sorry, no items found.</p>
</transition>
```

Vue中具有相同名称的元素切换时，需要通过关键字`key`作为标记进行区分，否则Vue出于效率的考虑只会替换相同标签内的内容，因此为`<transition>`组件中的同名元素设置`key`是一个**最佳实践**。

```html
<transition>
  <button v-if="isEditing" key="save"> Save </button>
  <button v-else key="edit"> Edit </button>
</transition>
```

一些场景中，可以通过给相同HTML元素的`key`属性设置不同的状态来代替冗长的`v-if`和`v-else`。

```html
<!-- 通过v-if和v-else来实现 -->
<transition>
  <button v-if="isEditing" key="save"> Save </button>
  <button v-else key="edit"> Edit </button>
</transition>

<!-- 设置动态的key属性来实现 -->
<transition>
  <button v-bind:key="isEditing"> {{ isEditing ? "Save" : "Edit" }} </button>
</transition>
```

而对于使用了多个`v-if`的多元素过渡，也可以通过动态的`key`属性进行大幅度的简化。

```html
<!-- 多个v-if实现的多元素过渡 -->
<transition>
  <button v-if="docState === "saved"" key="saved"> Edit </button>
  <button v-if="docState === "edited"" key="edited"> Save </button>
  <button v-if="docState === "editing"" key="editing"> Cancel </button>
</transition>

<!-- 通过动态key属性可以大幅简化模板代码 -->
<transition>
  <button v-bind:key="docState"> {{ buttonMessage }} </button>
</transition>

<script>
...
computed: {
  buttonMessage: function () {
    switch (this.docState) {
      case "saved": return "Edit"
      case "edited": return "Save"
      case "editing": return "Cancel"
    }
  }
}
</script>
```

#### Vue组件的过渡效果

多个Vue组件之间的过渡不需要使用`key`属性，只需要使用**动态组件**即可。

```html
<transition name="component-fade" mode="out-in">
  <component v-bind:is="view"></component>
</transition>

<script>
new Vue({
  el: "#transition-components-demo",
  data: {
    view: "v-a"
  },
  components: {
    "v-a": {
      template: "<div>Component A</div>"
    },
    "v-b": {
      template: "<div>Component B</div>"
    }
  }
})
<script>

<style>
.component-fade-enter-active, .component-fade-leave-active {
  transition: opacity .3s ease;
}
.component-fade-enter, .component-fade-leave-to {
  opacity: 0;
}
<style>
```

#### 选择HTML元素或Vue组件的过渡模式

`<transition>`的默认进入（*enter*）和离开（*leave*）行为同时发生，所以当多个需要切换显示的HTML元素或Vue组件处于相同位置的时候，这种同时生效的进入和离开过渡不能满足所有需求，Vue可以通过`<transition-gruop>`组件的`mode`属性来选择如下过渡模式。

- `in-out`：新元素先进行过渡，完成之后当前显示的元素再过渡离开。
- `out-in`：当前显示的元素先进行过渡，完成之后新元素再过渡进入。

```html
<transition name="fade" mode="out-in">
  <button v-if="docState === "saved"" key="saved"> Edit </button>
  <button v-if="docState === "edited"" key="edited"> Save </button>
  <button v-if="docState === "editing"" key="editing"> Cancel </button>
</transition>
```

### transition-group组件

`<transition-group>`用来设置多个HTML元素或Vue组件的过渡效果，不同于`<transition>`，该组件默认会被渲染为一个真实的`<span>`元素，但是开发人员也可以通过`<transition-group>`组件的`tag`属性更换为其它合法的HTML元素。`<transition-group>`组件内部的元素必须要提供唯一的`key`属性值。

```html
<div id="list-demo" class="demo">
  <button v-on:click="add">Add</button>
  <button v-on:click="remove">Remove</button>
  <transition-group name="list" tag="p">
    <span v-for="item in items" v-bind:key="item" class="list-item">
      {{ item }}
    </span>
  </transition-group>
</div>

<script>
new Vue({
  el: "#list-demo",
  data: {
    items: [1, 2, 3, 4, 5, 6, 7, 8, 9],
    nextNum: 10
  },
  methods: {
    randomIndex: function () {
      return Math.floor(Math.random() * this.items.length)
    },
    add: function () {
      this.items.splice(this.randomIndex(), 0, this.nextNum++)
    },
    remove: function () {
      this.items.splice(this.randomIndex(), 1)
    },
  }
})
</script>

<style>
.list-item {
  display: inline-block;
  margin-right: 10px;
}
.list-enter-active, .list-leave-active {
  transition: all 1s;
}
.list-enter, .list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
</style>
```

`<transition-group>`实现的列表过渡效果在添加、移除某个HTML元素时，相临的其它HTML元素会瞬间移动至新位置，这个过程并非平滑的过渡。为解决这个问题，`<transition-group>`提供*v-move*特性去覆盖**移动过渡期间**所使用的CSS类名。开启该特性，即可以通过`name`属性手动设置（*下面例子中的`name="flip-list"`与`.flip-list-move`*），也可以直接使用`move-class`属性。

```html
<div id="flip-list-demo" class="demo">
  <button v-on:click="shuffle">Shuffle</button>
  <transition-group name="flip-list" tag="ul">
    <li v-for="item in items" v-bind:key="item">
      {{ item }}
    </li>
  </transition-group>
</div>

<script>
new Vue({
  el: "#flip-list-demo",
  data: {
    items: [1,2,3,4,5,6,7,8,9]
  },
  methods: {
    shuffle: function () {
      this.items = _.shuffle(this.items)
    }
  }
})
</script>

<style>
.flip-list-move {
  transition: transform 1s;
}
<style>
```

可以通过**响应式**的绑定`<transition>`和`<transition-gruop>`上的name属性，从而能够根据组件自身的状态实现具有动态性的过渡效果。

```html
<transition v-bind:name="transitionName"></transition>
```