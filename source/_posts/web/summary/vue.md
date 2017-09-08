---
title: Vue2新特性两三事儿
tags: Web
categories: Summary
---

![](vue/logo.png)

Vue是一款**高度封装的**、**开箱即用的**、**一栈式的前端框架**，即可以结合webpack进行编译式前端开发，也适用基于gulp、grunt等自动化工具直接挂载至window。经历2个小型项目的初步尝试之后，正在和勤智前端团队的小伙伴一起，将前端架构逐步从Angular切换至Vue。为了帮助team里小伙伴们更加快速的上手，所以专门组织了本次training，一方面为大家讲解Vue2带来的各种有趣特性，另一方面聊聊与之前使用Angular的相似与异同。

<!-- more -->

## Vue与Angular的比较

* **组件化**：Angular的设计思想照搬了Java Web开发当中MVC分层的概念，通过`Controller`切割并控制页面作用域，然后通过`Service`来实现复用，是一种对页面进行**纵向**分层的解耦思想。而Vue允许开发人员将页面抽象为若干独立的组件，即将页面DOM结构进行**横向**切割，通过组件完成功能复用、作用域控制，组件对外只提供props和state，并采用Vuex完成组件间的通信和同步。

![](vue/components.png "组件化")

* **双向绑定**：


* **虚拟DOM**：Vue通过建立Virtual DOM（*VNode*）来追踪真实DOM发生的变化。


## Vue对象的选项

通过向构造函数`new Vue()`传入一个`option`对象去创建一个Vue实例。

```javascript
var vm = new Vue({
  // 数据
  data: "声明双向绑定的数据对象",
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

> Vue实例通常使用`vm`（View Model）变量来命名。

### 属性计算computed

在HTML模板表达式中放置太多业务逻辑，会让模板过重且难以维护。因此，可以考虑将模板中比较复杂的表达式拆分到computed属性当中。

```html
<!-- 不使用计算属性 -->
<div id="example">
  {{ message.split('').reverse().join('') }}
</div>

<!-- 将表达式抽象到计算属性 -->
<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>

<script>
  var vm = new Vue({
    el: '#example',
    data: {
      message: 'Hello'
    },
    computed: {
      reversedMessage: function () {
        return this.message.split('').reverse().join('')
      }
    }
  })
</script>
```

> 计算属性只在相关依赖发生改变时才会重新求值，这意味只要上面例子中的message没有发生改变，多次访问reversedMessage计算属性总会返回之前的计算结果，而不必再次执行函数，这是computed和method的一个重要区别。

计算属性默认只拥有getter方法，但是可以自定义一个setter方法。

```html
<script>
... ... ...
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
... ... ...
// 下面语句触发setter方法，firstName和lastName也会被相应更新
vm.fullName = 'John Doe'
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
    el: '#watch-example',
    data: {
      question: '',
      answer: 'I cannot give you an answer until you ask a question!'
    },
    watch: {
      // 如果question发生改变，该函数就会运行
      question: function (newQuestion) {
        this.answer = 'Waiting for you to stop typing...'
        this.getAnswer()
      }
    },
    methods: {
      // _.debounce是lodash当中限制操作频率的函数
      getAnswer: _.debounce(
        function () {
          if (this.question.indexOf('?') === -1) {
            this.answer = 'Questions usually contain a question mark. ;-)'
            return
          }
          this.answer = 'Thinking...'
          var vm = this
          axios.get('https://yesno.wtf/api')
            .then(function (response) {
              vm.answer = _.capitalize(response.data.answer)
            })
            .catch(function (error) {
              vm.answer = 'Error! Could not reach the API. ' + error
            })
        },
        // 这是用户停止输入等待的毫秒数
        500
      )
    }
  })
</script>
```

> 使用watch属性的灵活性在于，当监测到数据变化的时候，可以做一些设置中间状态之类的处理。

### 混合属性mixins

用来将指定的mixin对象复用到Vue组件当中。

```javascript
// mixin对象
var mixin = {
  created: function () {
    console.log('混合对象的钩子被调用')
  },
  methods: {
    foo: function () {
      console.log('foo')
    },
    conflicting: function () {
      console.log('from mixin')
    }
  }
}

// vue属性
var vm = new Vue({
  mixins: [mixin],
  created: function () {
    console.log('组件钩子被调用')
  },
  methods: {
    bar: function () {
      console.log('bar')
    },
    conflicting: function () {
      console.log('from self')
    }
  }
})

// => "混合对象的钩子被调用"
// => "组件钩子被调用"
vm.foo() // => "foo"
vm.bar() // => "bar"
vm.conflicting() // => "from self"
```

> 同名组件的option对象属性会被合并为数组依次调用，其中mixin对象里的属性会被首先调用。如果组件option对象的属性值是一个对象，则mixin中的属性会被忽略掉。

### 渲染函数render()

用来创建VNode，该函数接收`createElement()`方法作为第1个参数，该方法调用后会返回一个虚拟DOM（*即VNode*）。

下面两种情况下，Vue都会自动保持页面的更新，即便`blogTitle`发生变化。

```html
<h1>{{ blogTitle }}</h1>

<script>
render: function (createElement) {
  return createElement('h1', this.blogTitle)
}
</script>
```

> 如果组件是一个函数组件，render()还会接收一个context参数，为没有实例的函数组件提供上下文信息。

通过render()函数实现虚拟DOM比较麻烦，因此可以使用Babel插件`babel-plugin-transform-vue-jsx`在render()函数中应用JSX语法。

```javascript
import AnchoredHeading from './AnchoredHeading.vue'

new Vue({
  el: '#demo',
  render (h) {
    return (
      <AnchoredHeading level={1}>
        <span>Hello</span> world!
      </AnchoredHeading>
    )
  }
})
```

### 函数化组件functional

即无状态（*没有data*）无实例（*没有this上下文*）的组件，渲染开销较小，且不会出现在`Vue devtools`当中。

```javascript
Vue.component('my-component', {
  functional: true,
  // 通过提供context参数为没有实例的函数组件提供上下文信息
  render: function (createElement, context) {},
  // Props可选
  props: {}
})
```

> 实际上，Vue当中的模板都被编译为了render()函数。


## Vue对象全局API

```javascript
Vue.extend(options) //通过继承一个option对象来创建一个Vue实例。
Vue.nextTick([callback, context]) //在下次DOM更新循环结束之后执行延迟回调。
Vue.set(target, key, value) // 设置对象的属性，如果是响应式对象，会触发视图更新。
Vue.delete(target, key) // 删除对象的属性，如果是响应式对象，会触发视图更新。
Vue.directive(id, [definition]) // 注册或获取全局指令。
Vue.filter(id, [definition]) // 注册或获取全局过滤器。
Vue.component(id, [definition]) // 注册或获取全局组件。
Vue.use(plugin) // 安装Vue插件。
Vue.mixin(mixin) // 全局注册一个mixin对象。
Vue.compile(template) // 在render函数中编译模板字符串。
Vue.version // 提供当前使用Vue的版本号。
```

### Vue.mixin(mixin)

使用全局mixins将会影响到所有之后创建的Vue实例。

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
  myOption: 'hello!'
})

// => "hello!"
```

### Vue.directive(id, [definition])

Vue允许注册自定义指令，用于对底层DOM进行操作。

```javascript
Vue.directive('focus', {
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

### Vue.use(plugin)

Vue通过插件来添加一些全局功能，Vue插件都会重写其`install()`方法，该方法第1个参数是`Vue构造器`, 第2个参数是可选的`option对象`:

```javascript
MyPlugin.install = function (Vue, options) {
  // 1. 添加全局方法或属性
  Vue.myGlobalMethod = function () {}

  // 2. 添加全局资源
  Vue.directive('my-directive', {
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

通过全局方法`Vue.use()`使用指定插件，使用时可以传入一个选项对象。

```javascript
Vue.use(MyPlugin, {someOption: true})
```

> vue-router等插件检测到Vue是全局对象时会自动调用`Vue.use()`，如果在CommonJS模块环境中，则需要显式调用`Vue.use()`。

### Vue.filter(id, [definition])

Vue可以通过定义过滤器，进行一些常见的文本格式化，可以用于mustache插值和v-bind表达式当中，使用时通过管道符`|`添加在JavaScript表达式尾部。

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
        if (!value) return ''
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
<span>{{ message | filterA('arg1', arg2) }}</span>
```


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

## 生命周期

每个Vue实例在创建时，都需要经过一系列初始化过程（*设置数据监听、编译模板、挂载实例到DOM、在数据变化时更新DOM*），并在同时运行一些钩子函数，让开发人员能够在特定生命周期内执行自己的代码。

![](vue/lifecycle.png "组件的生命周期")

> 不要在Vue实例的属性和回调上使用箭头函数，比如`created: () => console.log(this.a)`或`vm.$watch('a', newValue => this.myMethod())`。因为箭头函数的this与父级上下文绑定，并不指向Vue实例本身，所以前面代码中的`this.a`或`this.myMethod`会是`undefined`。

> 使用jQuery对DOM的操作可以放置在`Mounted`属性上进行，即Vue组件已经完成在DOM上挂载的时候。

## 数据绑定

Vue视图层通过[Mustache](http://mustache.github.io/)`['mʌstæʃ]`语法与Vue实例中的data属性进行双向绑定，但是也可以通过内置指令`v-once`完成一个单向的绑定，再或者通过`v-html`指令将绑定的字符串输出为HTML，虽然这样很容易招受XSS攻击。

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

操作class与style是前端数据绑定的常见需求，Vue通过`v-bind:class`和`v-bind:style`指令有针对性的对这两种操作进行了增强。

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
      'text-danger': false
    }
  }
  ... ...
</script>

<!-- 直接绑定class到一个对象 -->
<div v-bind:class="classObject"></div>

<!-- 直接绑定class到对象的属性 -->
<div class="static" v-bind:class="{ active: isActive, 'text-danger': hasError }"></div>

<!-- 渲染结果 -->
<div class="static active"></div>
```

可以传递一个数组给`v-bind:class`从而同时设置多个class属性。

```html
<!-- Vue对象中的data -->
<script>
  ... ...
  data: {
    activeClass: 'active',
    errorClass: 'text-danger'
  }
  ... ...
</script>

<!-- 绑定class到计算属性 -->
<div v-bind:class="[activeClass, errorClass]"></div>

<!-- 渲染结果 -->
<div class="active text-danger"></div>

<!-- 使用三目运算符，始终添加errorClass，只在isActive为true时添加activeClass -->
<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>

<!-- 在数组中使用对象可以避免三目运算符的繁琐 -->
<div v-bind:class="[{ active: isActive }, errorClass]"></div>
```

当在自定义组件上使用`class`属性时，这些属性将会被添加到该组件的根元素上面，这一特性同样适用于`v-bind:class`。

```html
<!-- 声明一个组件 -->
<script>
  Vue.component('my-component', {
    template: '<p class="foo bar">Hi</p>',
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
      color: 'red',
      fontSize: '13px'
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

使用`v-bind:style`时Vue会自动添加prefix前缀，常见的prefix前缀如下：

* `-webkit-` Chrome、Safari、新版Opera、所有iOS浏览器(包括iOS版Firefox)，几乎所有WebKit内核浏览器。
* `-moz-` 针对Firefox浏览器。
* `-o-` 使用WebKit内核前的老版本Opera。
* `-ms-` 微软的IE以及Edge浏览器。

### 使用JavaScript表达式

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

### v-model双向数据绑定

`v-model`指令实质上是`v-on`和`v-bind`的糖衣语法，该指令会接收一个`value属性`，存在新值时则触发一个`input事件`。

```html
<!-- 使用v-model的版本 -->
<input v-model="something">
<!-- 使用v-on和v-bind的版本 -->
<input v-bind:value="something"
       v-on:input="something = $event.target.value">
<!-- 也可以自定义输入域的双向绑定 -->
<custom-input
  v-bind:value="something"
  v-on:input="something = arguments[0]">
</custom-input>
```

> 单选框、复选框一类的输入域将value属性作为了其它用途，因此可以通过组件的`model`选项来避免冲突：


## 内置指令

带有`v-`前缀，当表达式的值改变时，响应式的将其影响作用于DOM。指令可以接收后面以`:`表示的**参数**（*被指令内部的arg属性接收*），或者以`.`开头的**修饰符**（*指定该指令以特殊方式绑定*）。

```html
<p v-if="seen">Hello world!</p>

<!-- 绑定事件 -->
<a v-bind:href="url"></a>

<!-- 绑定属性 -->
<a v-on:click="doSomething">

<!-- .prevent 修饰符告诉 v-on 指令对于触发的事件调用 event.preventDefault() -->
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

目前，Vue2.4.2版本当中提供了如下内置指令：

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
<div v-if="type === 'A'">A</div>
<div v-else-if="type === 'B'">B</div>
<div v-else-if="type === 'C'">C</div>
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

<!-- 表单控件双向绑定 -->
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
Vue.component('my-component', Vue.extend({ ... }))

// 注册组件，传入一个option对象(自动调用Vue.extend)
Vue.component('my-component', { ... })

// 获取注册的组件(始终返回构造器)
var MyComponent = Vue.component('my-component')
```

下面代码创建了一个Vue实例，并将自定义组件`my-component`挂载至HTML当中。

```html
<script>
  // 注册自定义组件
  Vue.component('my-component', {
    template: '<div>A custom component!</div>'
  })

  // 创建Vue根实例
  new Vue({
    el: '#example'
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

浏览器解析完HTML之后才会渲染Vue表达式，但是诸如`<ul> <ol> <table> <select>`限制了能被其包裹的HTML元素，而`<option>`只能出现在某些HTML元素内部，造成Vue表达式可能不会被正确的渲染。因此，Vue提供了`is`作为属性的别名来解决这个问题。

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

`Vue.component()`传入的data属性不能是对象，而必须是函数。这样做的目的是避免组件在相同模板的多个位置被复用时，仅仅返回对象会造成组件间的数据被相互污染，而通过函数每次都返回全新的data对象能很好的规避这个问题。

```javascript
Vue.component('simple-counter', {
  template: '<button v-on:click="counter += 1">{{ counter }}</button>',
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

虽然每个组件的作用域都是独立的，但是可以通过`props属性`向子组件传递数据，这是一种**单向数据流**的表现形式。

```javascript
Vue.component('child', {
  // 声明props
  props: ['message'],
  // 和data属性一样，prop也可以在vm通过this.message进行引用
  template: '<span>{{ message }}</span>'
})
```

> 不要在子组件内部修改props，这样会导致后台报错。

#### 命名方式转换

因为HTML并不区分大小写，所以kebab-case(*驼峰*)风格命名的props，在组件中会以camelCased(*短横线隔开*)风格被接收。

```html
<!-- camelCase in JavaScript -->
<script>
Vue.component('child', {
  props: ['myMessage'],
  template: '<span>{{ myMessage }}</span>'
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
Vue.component('example', {
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
        return { message: 'hello' }
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

>  `props`会在组件实例创建之前进行校验。

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

> 父组件传递给子组件的属性可能会覆盖子组件本身的属性，从而对子组件造成破坏和污染。

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
  Vue.component('button-counter', {
    template: '<button v-on:click="incrementCounter">{{ counter }}</button>',
    data: function () {
      return {
        counter: 0
      }
    },
    methods: {
      // 子组件事件
      incrementCounter: function () {
        this.counter += 1
        this.$emit('increment') //向父组件冒泡事件
      }
    },
  })
  new Vue({
    el: '#counter-event-example',
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

Vue中的props本质是不能进行双向绑定的，以防止破坏单向数据流，造成多个子组件对父组件状态形成污染。但是生产环境下，props双向绑定的需求是切实存在的。因此，Vue将`.sync`修饰符封装为糖衣语法，父组件在子组件的props使用该修饰符后，父组件会为props自动绑定`v-on`事件，子组件则在监听到props变化时向父组件`$emit`更新事件，从而让父组件的props能够与子组件进行同步。

```html
<!-- 使用.sync修饰符 -->
<comp :foo.sync="bar"></comp>

<!-- 被自动扩展为如下形式，该组件的子组件会通过this.$emit('update:foo', newValue)显式触发更新事件 -->
<comp :foo="bar" @update:foo="val => bar = val"></comp>
```

* 平行组件通信

非父子关系的组件进行通信时，可以使用一个空的Vue实例作为中央事件总线。

```javascript
var bus = new Vue()
// 触发组件A中的事件
bus.$emit('id-selected', 1)
// 在组件B监听事件
bus.$on('id-selected', function (id) {
  ... ... ...
})
```

> 更好的方式是借助VueX或者Redux之类的flux状态管理库。

### slot


## 动画


## 