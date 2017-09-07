---
title: Vue2新特性两三事儿
tags: Web
categories: Summary
---

![](vue/logo.png)

Vue是一款**高度封装的**、**开箱即用的**、**一栈式的前端框架**，即可以结合webpack进行编译式前端开发，也适用基于gulp、grunt等自动化工具直接挂载至window。经历2个小型项目的初步尝试之后，正在和勤智前端团队的小伙伴一起，将前端架构逐步从Angular切换至Vue。为了帮助team里小伙伴们更加快速的上手，所以专门组织了本次training，一方面为大家讲解Vue2带来的各种有趣特性，另一方面聊聊与之前使用Angular的相似与异同。

<!-- more -->

## Vue与Angular的比较

1. **组件化**：Angular的设计思想照搬了Java Web开发当中MVC分层的概念，通过`Controller`切割并控制页面作用域，然后通过`Service`来实现复用，是一种对页面进行**纵向**分层的解耦思想。而Vue允许开发人员将页面抽象为若干独立的组件，即将页面DOM结构进行**横向**切割，通过组件完成功能复用、作用域控制，组件对外只提供props和state，并采用Vuex完成组件间的通信和同步。

![](vue/components.png "组件化")

2. **双向绑定**：


3. **虚拟DOM**：


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
    // a computed getter
    reversedMessage: function () {
      // `this` points to the vm instance
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
// 下面语句会触发setter方法，但是firstName和lastName也会被相应更新
vm.fullName = 'John Doe'
</script>

```

### 观察者属性watch

通过watch属性可以手动观察Vue实例上的数据变动，当然也可以调用实例上的`vm.$watch`达到相同的目的。

```html
<div id="watch-example">
  <p>
    Ask a yes/no question: <input v-model="question">
  </p>
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

Mustache不能用于HTML属性，需要借助于`v-bind`指令。

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
... ...
Vue.component('my-component', {
  template: '<p class="foo bar">Hi</p>',
  data: {
    isActive: true
  },
})
... ...
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

我们还可以将1个数组赋值给`v-bind:style`中绑定的属性值，从而提供多个带前缀的值。

```html
<!-- 下面代码会渲染数组中最后一个被浏览器支持的值 -->
<div :style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }"></div>
```

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


## 内置指令

带有`v-`前缀，当表达式的值改变时，将其影响响应式的作用于DOM。指令可以接收后面以`:`表示的参数（*被指令内部的arg属性接收*），或者以`.`开头的修饰符（*指定该指令以特殊方式绑定*）。

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

### Vue2.4.2内置指令

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
  .trim = "过滤输入的首尾空格"
/>
```

## 组件