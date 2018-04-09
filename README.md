**[Sass](http://sass-lang.com/)**是成熟、稳定、强大的**CSS预处理器**，截止到目前为止已经发展有10年，前当最新release版本为`3.5.5`。而**SCSS**是**Sass3**版本当中引入的新语法特性，完全兼容CSS3的同时继承了**Sass**强大的动态功能。本文翻译自[Sass Guide](http://sass-lang.com/guide)和[Sass Syntactically Awesome StyleSheets](http://sass-lang.com/documentation/file.SASS_REFERENCE.html)两篇官方文档，讲解了现代化前端开发当中经常使用的SCSS语法特性，便于开发小组的同学快速上手。

![](scss/logo.png)

基于Gulp完成前端自动化的年代，出于快速上手以及npm安装方便的考虑，开发团队一直沿用[Less](http://lesscss.org)和[gulp-less](https://github.com/stevelacy/gulp-less)作为CSS预处理工具，但是Sass提供了更加丰富的动态语法特征，因此逐步淘汰基于Gulp的[beaver](https://github.com/uinika/beaver)前端项目脚手架以后，新项目全部基于Webpack的[node-sass](https://github.com/sass/node-sass)和[sass-loader](https://github.com/webpack-contrib/sass-loader)作为预处理工具。Sass和Less的详细比较可以参考[sass-vs-less](https://css-tricks.com/sass-vs-less/)和[Sass与Less比拼](http://cued.xunlei.com/log044)两篇文章，里面对两者的优劣做了非常详实的比较。

<!-- more -->


## 安装

如果正在使用的是Linux发行版，需要通过`apt`安装[Ruby](http://www.ruby-lang.org/en/)以及`build-essential`。

```bash
➜  sudo apt-get install ruby-dev
➜  gem install sass
```

命令行当中可以通过`sass input.scss output.css`编译Scss文件，也可以添加`--watch`选项监听Scss文件的变化：

```bash
➜  sass --watch input.scss:output.css
```

如果多个Scss文件放置在一个目录当中，也可以对整个文件目录进行监听。

```bash
➜  sass --watch app/sass:public/stylesheets
```

通过`-i`或者`--interactive`可以运行一个交互式的SassScript命令行。

```bash
➜  sass -i
>> 5px + 8px
13px
```

> 通过`sass --help`获取更多关于SASS在命令行的使用方法。


## 编码规则

SASS首先会检查代码文件的Unicode BOM（*byte order mark*），然后是`@charset`声明，再然后是底层运行Ruby的字符串编码，如果这些都未进行设置，将会默认以**UTF-8**编码输出CSS文件。

```scss
@charset 'utf-8';

#app {
  background: url('../assets/背景图片.png');
}
```

> 建议代码开头位置显式定义`@charset "encoding-name";`，让SASS能够按照给定的字符集编译输出。


## 特性概览

CSS书写代码规模较大的Web应用时，容易造成选择器、层叠的复杂度过高，因此推荐通过SASS预处理器进行CSS的开发，SASS提供的**变量**、**嵌套**、**混合**、**继承**等特性，让CSS的书写更加有趣与程式化。

### 变量

变量用来存储需要在CSS中复用的信息，例如颜色和字体。SASS通过`$`符号去声明一个变量。

```scss
$font-stack:    Helvetica, sans-serif;
$primary-color: #333;

body {
  font: 100% $font-stack;
  color: $primary-color;
}
```

上面例子中变量`$font-stack`和`$primary-color`的**值**将会替换所有引用他们的位置。

```css
body {
  font: 100% Helvetica, sans-serif;
  color: #333; }
```

### 嵌套

SASS允许开发人员以**嵌套**的方式使用CSS，但是**过度的使用嵌套会让产生的CSS难以维护，因此是一种不好的实践**，下面的例子表达了一个典型的网站导航样式：

```scss
nav {
  ul {
    margin: 0;
    padding: 0;
    list-style: none;
  }

  li { display: inline-block; }

  a {
    display: block;
    padding: 6px 12px;
    text-decoration: none;
  }
}
```

大家注意上面代码中的`ul`、`li`、`a`选择器都被嵌套在`nav`选择器当中使用，这是一种书写更高可读性CSS的良好方式，编译后产生的CSS代码如下：

```css
nav ul {
  margin: 0;
  padding: 0;
  list-style: none; }
nav li {
  display: inline-block; }
nav a {
  display: block;
  padding: 6px 12px;
  text-decoration: none; }
```

### 引入

SASS能够将代码分割为多个片段，并以underscore风格的下划线作为其命名前缀（*_partial.scss*），SASS会通过这些下划线来辨别哪些文件是**SASS片段**，并且不让片段内容直接生成为CSS文件，从而只是在使用`@import`指令的位置被导入。CSS原生的`@import`会通过额外的HTTP请求获取引入的样式片段，而SASS的`@import`则会直接将这些引入的片段合并至当前CSS文件，并且不会产生新的HTTP请求。下面例子中的代码，将会在`base.scss`文件当中引入`_reset.scss`片断。

```scss
// _reset.scss
html, body, ul, ol {
  margin:  0;
  padding: 0;
}

// base.scss
@import 'reset';
body {
  font: 100% Helvetica, sans-serif;
  background-color: #efefef;
}
```

SASS中引入片断时，可以**缺省使用文件扩展名**，因此上面代码中直接通过`@import 'reset'`引入，编译后生成的代码如下：

```css
html, body, ul, ol {
  margin: 0;
  padding: 0; }

body {
  font: 100% Helvetica, sans-serif;
  background-color: #efefef; }
```

> SASS片断使用下划线前缀命名，主要用于`SASS命令行工具`watch指定目录源码的场景；如果使用Webpack等打包工具则毋须顾虑该问题，CSS样式将会通过Webpack加载器，按照ES6风格的`import`或Webpack插件`extract-text-webpack-plugin`进行打包和模块化。

### 混合

混合（**Mixin**）用来分组那些需要在页面中复用的CSS声明，开发人员可以通过向Mixin传递变量参数来让代码更加灵活，该特性在添加浏览器兼容性前缀的时候非常有用，SASS目前使用`@mixin name`指令来进行混合操作。

```scss
@mixin border-radius($radius) {
          border-radius: $radius;
      -ms-border-radius: $radius;
     -moz-border-radius: $radius;
  -webkit-border-radius: $radius;
}

.box {
  @include border-radius(10px);
}
```

上面的代码建立了一个名为`border-radius`的Mixin，并传递了一个变量`$radius`作为参数，然后在后续代码中通过`@include border-radius(10px)`使用该Mixin，最终编译的结果如下：

```css
.box {
  border-radius: 10px;
  -ms-border-radius: 10px;
  -moz-border-radius: 10px;
  -webkit-border-radius: 10px; }
```

### 继承

继承是SASS中非常重要的一个特性，可以通过`@extend`指令在选择器之间复用CSS属性，并且不会产生冗余的代码，下面例子将会通过SASS提供的继承机制建立一系列样式：

```scss
// 这段代码不会被输出到最终生成的CSS文件，因为它没有被任何代码所继承。
%other-styles {
  display: flex;
  flex-wrap: wrap;
}

// 下面代码会正常输出到生成的CSS文件，因为它被其接下来的代码所继承。
%message-common {
  border: 1px solid #ccc;
  padding: 10px;
  color: #333;
}

.message {
  @extend %message-common;
}

.success {
  @extend %message-common;
  border-color: green;
}

.error {
  @extend %message-common;
  border-color: red;
}

.warning {
  @extend %message-common;
  border-color: yellow;
}
```

上面代码将`.message`中的CSS属性应用到了`.success`、`.error`、`.warning`上面，魔法将会发生在最终生成的CSS当中。这种方式能够避免在HTML元素上书写多个`class`选择器，最终生成的CSS样式是下面这样的：

```css
.message, .success, .error, .warning {
  border: 1px solid #ccc;
  padding: 10px;
  color: #333; }

.success {
  border-color: green; }

.error {
  border-color: red; }

.warning {
  border-color: yellow; }
```

### 操作符

SASS提供了标准的算术运算符，例如`+`、`-`、`*`、`/`、`%`。在接下来的例子里，我们尝试在`aside`和`article`选择器当中对宽度进行简单的计算。

```scss
.container { width: 100%; }

article[role="main"] {
  float: left;
  width: 600px / 960px * 100%;
}

aside[role="complementary"] {
  float: right;
  width: 300px / 960px * 100%;
}
```

上面代码以`960px`为基准建立了简单的流式网格布局，SASS提供的算术运算符让开发人员可以更容易的将像素值转换为百分比，最终生成的CSS样式如下所示：

```css
.container {
  width: 100%; }

article[role="main"] {
  float: left;
  width: 62.5%; }

aside[role="complementary"] {
  float: right;
  width: 31.25%; }
```


## CSS扩展

SASS当中有两种可用的语法，一种是Scss（*即SASS化的CSS*），这是一种类CSS的语法，以`.scss`作为源码文件后缀。另一种是Sass，提供了比较简明的CSS书写方式，通过缩进而非括号来标识嵌套的选择器，以及使用换行而非分号来分隔各个属性，并使用`.sass`作为代码文件的后缀。

Sass和Scss两种代码风格可以通过`sass-convert`命令行工具进行相互转换：

```
➜  sass-convert test.scss test.sass

➜  sass-convert test.sass test.scss 
```

> 日常开发环境下，出于前端开发的使用习惯，更多会选择Scss语法，接下来的内容也将会以Scss风格为主。

### 嵌套规则

Scss允许CSS规则嵌套使用，父子规则将会呈现**包含选择器**的关系，例如：

```scss
/*===== SCSS =====*/
#main p {
  color: #00ff00;
  width: 97%;

  .redbox {
    background-color: #ff0000;
    color: #000000;
  }
}

/*===== CSS =====*/
#main p {
  color: #00ff00;
  width: 97%; }
  #main p .redbox {
    background-color: #ff0000;
    color: #000000; }
```

这样可以避免重复的使用父级选择器，从而达到简化CSS代码结构的目的，例如：

```scss
/*===== SCSS =====*/
#main {
  width: 97%;

  p, div {
    font-size: 2em;
    a { font-weight: bold; }
  }

  pre { font-size: 3em; }
}

/*===== CSS =====*/
#main {
  width: 97%; }
  #main p, #main div {
    font-size: 2em; }
    #main p a, #main div a {
      font-weight: bold; }
  #main pre {
    font-size: 3em; }
```

### 引用父级选择器&

Scss使用`$`关键字在CSS规则中引用**父级选择器**，例如在嵌套使用伪类选择器的场景下：

```scss
/*===== SCSS =====*/
a {
  font-weight: bold;
  text-decoration: none;
  &:hover { text-decoration: underline; }
  body.firefox & { font-weight: normal; }
}

/*===== CSS =====*/
a {
  font-weight: bold;
  text-decoration: none; }
  a:hover {
    text-decoration: underline; }
  body.firefox a {
    font-weight: normal; }
```

无论CSS规则嵌套的深度怎样，关键字`&`都会使用父级选择器**级联替换**全部其出现的位置：

```scss
/*===== SCSS =====*/
#main {
  color: black;
  a {
    font-weight: bold;
    &:hover { color: red; }
  }
}

/*===== CSS =====*/
#main {
  color: black; }
  #main a {
    font-weight: bold; }
    #main a:hover {
      color: red; }
```

`&`必须出现在复合选择器开头的位置，后面再连接自定义的后缀，例如：

```scss
/*===== SCSS =====*/
#main {
  color: black;
  &-sidebar { border: 1px solid; }
}

/*===== CSS =====*/
#main {
  color: black; }
  #main-sidebar {
    border: 1px solid; }
```

> 如果在父级选择器不存在的场景使用`&`，Scss预处理器会报出错误信息。

### 嵌套属性

CSS许多属性都位于相同的命名空间（*例如`font-family`、`font-size`、`font-weight`都位于`font`命名空间下*），Scss当中只需要编写命名空间一次，后续嵌套的子属性都将会位于该命名空间之下，请看下面的代码：

```scss
/*===== SCSS =====*/
.demo {
  // 命令空间后带有冒号:
  font: {
    family: fantasy;
    size: 30em;
    weight: bold;
  }
}

/*===== CSS =====*/
.demo {
  font-family: fantasy;
  font-size: 30em;
  font-weight: bold; }
```

命令空间上可以直接书写**CSS简写属性**，但是日常开发中建议直接书写**CSS简写属性**，尽量保持CSS语法的一致性。

```scss
.demo {
  font: 20px/24px fantasy {
    weight: bold;
  }
}

.demo {
  font: 20px/24px fantasy;
    font-weight: bold;
}
```

### 占位符选择器%

占位符选择器与`id`或者`class`选择器的用法类似，只是`#`和`.`需要替换成为`%`，占位符选择器必须通过`@extend`指令进行调用。

> 关于占位符的讲解，请具体参考[`@extend`](#extend-extend)章节。


## 注释

SASS支持标准CSS的多行注释`/* */`和单行注释`// `，其中，多行注释会完整输出到编译后的CSS文件，而单行注释则不会。

```scss
/* 多行注释
 * 会原样输出到CSS文件 */
body { color: black; }

// 单行注释不会出现在输出的CSS当中
a { color: green; }
```

编译成为CSS的结果如下：

```css
@charset "UTF-8";
/* 多行注释
 * 会原样输出到CSS文件 */
body {
  color: black; }

a {
  color: green; }
```

插值语句`#{$variable}`可以应用在多行注释当中。

```scss
$version: "3.5.5";
/* 这段CSS是通过SASS #{$version}生成的。*/
```

编译成为CSS的结果：

```css
@charset "UTF-8";
/* 这段CSS是通过SASS 3.5.5生成的。*/
```

> 当注释中出现中文时，SASS会自动在生成的CSS文件头部添加`@charset "UTF-8";`。


## SassScript

SassScript是Sass提供的一系列CSS语法扩展，允许在任意CSS属性上书写变量、计算以及函数。SassScript还可以通过`interpolation`插值生成选择器和属性名，这在编写`mixins`时非常有用。

### 变量$

SassScript通过`$`关键字声明和使用一个变量。

```scss
/*===== SCSS =====*/
$width: 8rem;  // 声明变量

#main {
  width: $width;  // 使用变量
}

/*===== CSS =====*/
#main {
  width: 8rem; }
```

SassScript变量支持块级作用域，嵌套规则当中声明的变量都是**局部变量**，可以通过`!global`将局部变量声明为**全局变量**。

```scss
/*===== SCSS =====*/
#menu {
  $width: 5rem !global;
  width: $width;
}

#sidebar {
  width: $width;
}

/*===== CSS =====*/
#menu {
  width: 5rem; }

#sidebar {
  width: 5rem; }
```

### 数据类型

SassScript支持8种数据类型，

1. **数值number**：*`1.2`, `13`, `10px`*
2. **颜色color**：*`blue`、`#04a3f9`、`rgba(255, 0, 0, 0.5)`*
3. **布尔值bollean**：*`true`、`false`*
4. **空值null**：*`null`*
5. **字符串string**：有或没有引号，*`"menu"`、`'sidebar'`、`navbar`*
6. **数组list**：由空格或逗号分隔，*`1.5em 1em 0 2em, Helvetica, Arial, sans-serif`*
7. **对象map**：*`(key1: value1、key2: value2)`*
8. **函数function**。

> Scss支持所有其它类型的CSS属性值，例如Unicode字符或者`!important`声明。Scss并没有对这些类型进行特殊处理，仅仅将其视为没有使用引号的字符串。

#### String

CSS支持两种类型的字符串：

1. 使用单双引号的：`"Lucida Grande"`， `'http://sass-lang.com'`;
2. 没有使用引号的：`sans-serif`，`bold`;

SassScript能够自动识别这2种字符串，Scss当中使用了哪种类型字符串，就会在生成的CSS文件原样输出该类型字符串。

但是这里存在一个意外，当使用`#{}`插值语法的时候，使用引号的字符串会失去引号，这样可以便于`mixin`中使用选择器的名称。

```scss
/*===== SCSS =====*/
@mixin firefox-message($selector) {
  body.firefox #{$selector}:before {
    content: "Hi, Firefox users!";
  }
}

@include firefox-message(".header");

/*===== CSS =====*/
body.firefox .header:before {
  content: "Hi, Firefox users!"; }
```

#### List

SASS当中可以通过List来表达CSS声明的值，例如`margin: 10px 15px 0 0`或`font-face: Helvetica, Arial, sans-serif`。SASS中的List是一系列由空格或者逗号分隔的值，实际上单个值也可以作为一个List，即只拥有一项元素的List。

List本身的作用不多，但是通过SassScript的List函数可以让它发挥更大的作用。`nth`函数可以操作List中的每一项元素，`join`函数能够合并多个List在一起，`append`函数能够向List添加一项元素，而`@each`指令可以为List当中每项元素添加样式。

除了包含简单的值，List还可以包含其它的List，例如拥有2项元素的List`1px 2px, 5px 6px`包含了`1px 2px`和`5px 6px`两个List，如果内部的List和外部List拥有相同的分隔符，那么必须使用圆括号`()`标识内部List的起始和结束位置，例如`(1px 2px) (5px 6px)`。

当List被转换为普通CSS的时候，SASS不会添加其它圆括号，这意味`(1px 2px) (5px 6px)`和`1px 2px 5px 6px`变成CSS的时候结果是相同的。但是无论如何，它们在SASS里是不相同的，`(1px 2px) (5px 6px)`是一个拥有2个List元素的List，`1px 2px 5px 6px`则是拥有4个普通元素的List。

List里同样可以不包含任何元素，这样的List会被表现为`()`（*同样可以认为其是一个空的map*），它们并不能直接输出为CSS。例如SASS编译`font-family: ()`时将会发生错误。如果List包含一个空的List`()`或者其本身为空值`null`，例如对于`1px 2px () 3px`或`1px 2px null 3px`当中的`null`和`()`将会在输出的CSS当中被移除。

逗号分隔的List尾部可能还跟着一个逗号，这在一些特殊的情况下比较有用，例如展现一个只有1个元素的List，`(1,)`就是一个包含了元素`1`的List，而`(1 2 3,)`是一个逗号分隔的List，这个List又包含着一个空格分隔的List，空格分隔的List拥有着`1`、`2`、`3`三个元素。

> List也可以通过方括号`[]`编写，**方括号编写的List**用来在CSS Grid布局中表达行的名称，但是它同样也可以用于纯SASS代码，同样也可以通过逗号或者空格进行分隔。

#### Map

Map提供了`key`与`value`之间的关联关系，并且能够通过`key`找到相应的`value`。他们可以容易的搜集`value`到一个被命名的分组，然后动态的操作这些分组。它们在CSS中没有直接并行的概念，尽管在句法上与媒体查询表达式相似：

```
$map: (key1: value1, key2: value2, key3: value3);
```

不同与前面提到的List，Map必须总是被圆括号`()`包裹，并且必须使用逗号`,`进行分隔。Map中的`key`与`value`可以是任意的SassScript对象，一个Map可以只拥有1个给定的`key`和对应的`value`（_可以是一个List_），但是一个给定的`value`可能会关联到多个`key`。

和List一样，Map大部分情况下也需要通过SassScript函数对其进行操作。其中`map-get`函数负责查询Map中的`value`，`map-merge`函数添加`value`至Map，指令`@each`可以被用来为Map中的每个`key`和`value`添加样式。Map中键值对的顺序总是与其被建立的时候相同。

List能够使用的位置，Map也能正常使用。当通过一个List函数进行使用的时候，Map被视为拥有键值对的List。例如：`(key1: value1, key2: value2)`在List函数当中将被视为一个嵌套的List（_即`key1 value1, key2 value2`_）。但是，值得注意的是，List并不能相反的被视为一个Map，尽管空的List将会抛出错误。`()`即可以被视为一个没有`key`和`value`的Map，也可以视为没有元素项的List.

注意Map的`key`可以是任意的Sass数据类型（*即使是Map*），并且声明Map的语法允许任意的SassScript表达式，该表达式将会被解析以决定`key`的值。

Map并不能被转换为普通CSS，在CSS函数中使用它作为变量和参数的值将会导致错误。这种情况下，建议使用`inspect($value)`函数为Map的调试生成一个有用的字符串输出。

#### Color

任何CSS颜色表达式都返回一个SassScript色彩值，这包括大量被命名的颜色，它们与未引用的字符串是不可区分的。

在压缩输出模式下，Sass将输出颜色的最小的CSS表示。例如，在压缩模式下，`#FF0000`将输出为红色`red`，而`#FFEBCD`将会输出为白杏色`blanchedalmond`。

用户使用**被命名的颜色**时，经常会遇到一个问题：在。。。SASS喜欢在其他输出模式中键入相同的输出格式。。。之后，一个颜色会被插值到一个选择器，代码压缩时这将会变成不合法的语法。要避免这个问题，在被命名颜色用于构建选择器的时候，总是需要为它们添加引号。

#### First-Class Function

`get-function($function-name)`将会返回一个函数引用，该函数能够被传递到`call($function, $args...)`并得到调用。First-Class函数不能直接用于CSS输出，任何这样的尝试都将会引发错误。

### 运算

SassScript所有数据类型都支持`==或!=`逻辑运算，但是每种数据类型还拥有自己的运算方式。

#### 数值运算

数值类型支持常见的数值运算`+`、`-`、`*`、`/`、`%`，并在必要时在不同的**绝对**数值单位之间转换。SASS数学函数会在计算过程中保留单位，这意味不同单位不能在一起进行运算（_例如`px`和`em`_），两个相同单位的数值相乘后可能会造成运算结果的单位重复，例如：`10px * 10px == 100px * px`，显然这里`px * px`是一个无效单位，此时SASS会由于使用非法单位而报错。

> 关系运算符`<`、 `>`、`<=`、`>=`同样支持数值类型，而相等运算符`==`, `!=`则可以被SASS所有类型所支持。

##### 除法与标识符`/`

CSS允许在属性值中使用`/`作为分隔数字的手段，SassScript为CSS属性语法提供了一个扩展，允许`/`作为除法运算符来使用。如果SassScript当中2个数值通过`/`进行分隔，那么它们的计算结果将会出现在生成的CSS当中。

`/`被解释为除法的情况主要有以下3种：

1. 如果值及其部分被保存到一个变量，或者通过一个函数返回。
2. 值被圆括号`()`包裹，除非这些圆括号在一个List的外面并且该地，
3. 如果指定值被用于其它算术表达式。

例如：

```scss
/*===== SCSS =====*/
p {
  font: 10px/8px;                // 普通CSS，未进行除法运算。
  $width: 1000px;
  width: $width/2;               // 使用一个变量，进行了除法运算。
  width: round(1.5)/2;           // 使用一个函数，进行了除法运算。
  height: (500px/2);             // 使用圆括号, 进行了除法运算。
  margin-left: 5px + 8px/2px;    // 使用了加号+, 进行了除法运算。
  font: (italic bold 10px/8px);  // 在List当中，圆括号不会进行计算。
}

/*===== CSS =====*/
p {
  font: 10px/8px;
  width: 500px;
  height: 250px;
  margin-left: 9px; }
```

如果需要在普通CSS当中使用变量，可以通过`#{}`去插入它们，例如：

```scss
/*===== SCSS =====*/
p {
  $font-size: 12px;
  $line-height: 30px;
  font: #{$font-size}/#{$line-height};
}

/*===== CSS =====*/
p {
  font: 12px/30px; }
```

##### 减法、负数与标识符`-`

中划线`-`在CSS和SASS中有许多不同的意义，可以表达一个减法运算符（`5px - 3px`），一个负数的开始（`-23px`），一元负值运算符（`-$var`），或者一个标识符的组成部分（`font-weight`），大部分情况下何时何地使用是比较清晰的，但也存在一些例外情况，为了避免这些例外需要遵循如下原则：

1. 进行减法运算的时候，符号两则尽量保留空格。
2. 作为负值标识或一元负值运算符时，需要在数值或变量前包含一个空格。
3. 如果是在空格分隔的List中，就用括号将一元负值运算符括起来，就像`10px (-$var)`一样。

不同含义的表达遵循如下的优先次序：

* 表达式中使用字母时，`a-1`表示一个没有引号的字符串，其值为`"a-1"`。但是唯一的例外在于单位的使用，比如`5px-3px`与`5px - 3px`是等效的，其执行结果为`2px`。
* 两个数字之间没有空格意味着这是一个减法，所以`1-2`与`1 - 2`作用相同。
* 将`-`放置在数字开头表示这是一个负数，所以`1 -2`是一个包含了`1`和`-2`两个元素的List。
* 两个数字之间不考虑空格表示这是减法，所以`1 -$var`和`1 - $var`相同。
* 放置在一个值的前面表示这是一元负值运算符，该运算符会返回当前数值的负值。

```bash
➜  hank ✗ sass -i
>> a-1
"a-1"
>> 5px-3px
2px
>> 1 -2
(1 -2)
>> 1-2
-1
```

#### 颜色运算

SASS中所有的数学运算都分段的支持颜色值，即分别对`红`、`绿`、`蓝`依次进行计算。

```scss
/*===== SCSS =====*/
p {
  color: #010203 + #040506;
}
```

在执行完`01 + 04 = 05`，`02 + 05 = 07`，`03 + 06 = 09`运算后编译为下面的CSS：

```css
/*===== CSS =====*/
p {
  color: #050709; }
```

通常来说，使用*颜色函数*比使用*颜色运算*能更加有效的达到相同目的。*颜色运算*同样也可以作用于数值与颜色值，并且依然是分段进行的，例如：

```scss
p {
  color: #010203 * 2;
}
```

进行`01 * 2 = 02`，`02 * 2 = 04`，`03 * 2 = 06`运算后编译为下面CSS：

```css
p {
  color: #020406; }
```

注意，带有alpha通道的颜色（_使用`rgba`或`hsla`函数创建的颜色_）必须具有相同的alpha值单位，以便与其执行颜色运算。

```scss
/*===== SCSS =====*/
p {
  color: rgba(255, 0, 0, 0.75) + rgba(0, 255, 0, 0.75);
}

/*===== CSS =====*/
p {
  color: rgba(255, 255, 0, 0.75); }
```

颜色的alpha通道可以通过`opacify`和`transparentize`函数进行修改，例如：

```scss
/*===== SCSS =====*/
$translucent-red: rgba(255, 0, 0, 0.5);
p {
  color: opacify($translucent-red, 0.3);  // 增加alpha通道值
  background-color: transparentize($translucent-red, 0.25);  // 减少alpha通道值
}

/*===== CSS =====*/
p {
  color: rgba(255, 0, 0, 0.8);
  background-color: rgba(255, 0, 0, 0.25); }
```

IE的filter滤镜要求所有颜色都包括alpha层，并且严格采用`#AABBCCDD`格式，SASS提供了`ie_hex_str`函数能够更加简便的对颜色值进行转换，例如：

```scss
/*===== SCSS =====*/
$translucent-red: rgba(255, 0, 0, 0.5);
$green: #00ff00;
div {
  filter: progid:DXImageTransform.Microsoft.gradient(enabled='false', startColorstr='#{ie-hex-str($green)}', endColorstr='#{ie-hex-str($translucent-red)}');
}

/*===== CSS =====*/
div {
  filter: progid:DXImageTransform.Microsoft.gradient(enabled='false', startColorstr='#FF00FF00', endColorstr='#80FF0000'); }
```

#### 字符串运算 

SassScript使用`+`运算符执行**字符串连接**操作。

```scss
/*===== SCSS =====*/
p {
  cursor: e + -resize;
}

/*===== CSS =====*/
p {
  cursor: e-resize; }
```

注意，如果有引号的字符串被添加到没有引号的字符串（*即带引号的字符串在`+`的左侧*），生成的字符串将会是**有引号**的。同理，如果将没有引号的字符串添加到有引号的字符串（*即没有引号的字符串在`+`的左侧*），则结果为**没有引号**的字符串。

```scss
/*===== SCSS =====*/
p:before {
  content: 'Foo ' + Bar;         // 有引号字符串 + 无引号字符串 = 有引号字符串
  font-family: sans- + 'serif';  // 无引号字符串 + 有引号字符串 = 无引号字符串
}

/*===== CSS =====*/
p:before {
  content: "Foo Bar";
  font-family: sans-serif; }
```

默认情况下，临近的两个CSS属性值可以通过**空格**进行连接。

```scss
/*===== SCSS =====*/
p {
  margin: 3px + 4px auto;
}

/*===== CSS =====*/
p {
  margin: 7px auto; }
```

字符串里可以通过`#{}`插入动态的值，就像下面这样：

```scss
/*===== SCSS =====*/
p:before {
  content: "I ate #{5 + 10} pies!";
}

/*===== CSS =====*/
p:before {
  content: "I ate 15 pies!"; }
```

如果字符串插值`#{}`中的变量是空值，则插值表达式的结果将被视为空字符串。

```scss
/*===== SCSS =====*/
$value: null;  // 空值
p:before {
  content: "I ate #{$value} pies!";
}

/*===== CSS =====*/
p:before {
  content: "I ate  pies!"; }
```

#### 布尔运算

SassScript当中布尔类型的值支持`与and`、`或or`、`非not`运算。

```scss
/*===== SCSS =====*/
$year: 2018;
$moth: 8;
$day: 6;
$name: Hank;
#app {
  @if ($year > 2010 and $moth==8 or $day==6 not $name==Hank) {
    color: blue;
  } @else {
    color: red;
  }
}

/*===== CSS =====*/
#app {
  color: blue; }
```

#### List运算

数组不支持任何特定的计算方式，只能通过[list函数](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#Functions)进行操作，下面代码是一个使用了`hsl($hue, $saturation, $lightness)`函数的例子：

```scss
/*===== SCSS =====*/
a {
  color: hsl(120deg, 100%, 50%)
}

/*===== CSS =====*/
a {
  color: lime; }
```

#### 圆括号

SASS中可以通过圆括号`{}`来调整运算的优先级。

```scss
/*===== SCSS =====*/
p {
  width: 1em + (2em * 3);
}

/*===== CSS =====*/
p {
  width: 7em; }
```

#### 函数

SassScript内置了许多有用的函数，可以通过普通的CSS语句进行调用。

```scss
/*===== SCSS =====*/
p {
  color: hsl(0, 100%, 30%);
}

/*===== CSS =====*/
p {
  color: #990000; }
```

#### 关键词参数

Sass函数还允许通过**关键词参数**(即*带有键名的参数*)进行调用，上面的例子也可以改写为下面代码：

```scss
/*===== SCSS =====*/
p {
  color: hsl($hue: 0, $saturation: 100%, $lightness: 30%);
}

/*===== CSS =====*/
p {
  color: #990000; }
```

虽然这不是很简洁，但可以使样式表更加容易阅读。同时还能够让函数提供更灵活的接口，提供多个参数的同时，并不会变得难以调用。

命名参数能够以任何顺序进行传递，而带有默认值的参数可以省略掉。如果命名参数是变量名，那么下划线与破折号可以互换使用。

可以通过[`Sass::Script::Functions`](http://sass-lang.com/documentation/Sass/Script/Functions.html)查看SASS函数及其参数名称的完整清单，也可以通过Ruby进行自定义。

#### 插值`#{}`

开发人员可以通过**插值**（*interpolation*）`#{}`在选择器和属性名称中使用SassScript变量。

```scss
/*===== SCSS =====*/
$name: uinika;
$attr: border;
p.#{$name} {
  #{$attr}-color: blue;
}

/*===== CSS =====*/
p.uinika {
  border-color: blue; }
```

还可以使用`#{}`将SassScript放入属性值，大多数情况下这种方式并不优于变量，但是使用`#{}`意味着其附近的任意操作都将被视为普通CSS，例如：

```scss
/*===== SCSS =====*/
p {
  $font-size: 12px;
  $line-height: 30px;
  font: #{$font-size}/#{$line-height};
}

/*===== CSS =====*/
p {
  font: 12px/30px; }
```

#### SassScript中的`&`

如同使用选择器一样，SassScript中的`&`引用着当前的**父选择器列表**（_一个由逗号分隔List作为元素再通过空格进行分隔的List_）。

```scss
.navbar.text .sidebar.word,
.menu.item {
  $selector: &;
}
```

上面代码中`$selector`的值为`((".navbar.text" ".sidebar.word"), ".menu.item")`，这里的复合选择器使用了引号`"`标识它是一个字符串，但是真实情况它可能是没有引号的。即使其父选择器并没有包含逗号和空格，`&`依然会拥有两层嵌套，因此它能够被持续的访问。

当**父级选择器列表**不存在的时候，`&`运算符的值为`null`，使用`mixin`当中可以通过该特性判断*父选择器列表*是否存在。

```scss
@mixin does-parent-exist {
  @if & {
    &:hover {
      color: red;
    }
  }
  @else {
    a {
      color: red;
    }
  }
}
```

#### 变量默认值`!default`

可以在变量后添加`!default`声明，如果变量已被赋值就不会再被重新进行赋值，如果变量未被赋值，则会被赋予新值。

```scss
/*===== SCSS =====*/
$content: "First content";
$content: "Second content?" !default;
$new_content: "First time reference" !default;
#main {
  content: $content;
  new-content: $new_content;
}

/*===== CSS =====*/
#main {
  content: "First content";
  new-content: "First time reference"; }
```

如果变量的值是`null`，则会被`!default`视为没有赋值。

```scss
/*===== SCSS =====*/
$content: null;
$content: "Non-null content" !default;
#main {
  content: $content;
}

/*===== CSS =====*/
#main {
  content: "Non-null content"; }
```


## @规则与指令

SASS支持所有CSS3的`@-Rules`规则，以及SASS特有的`#Directive`指令。

### @import / #import

SASS拓展了CSS的`@import`允许其导入`.scss`或`.sass`文件，导入的文件将合并、编译到一个CSS文件，文件中的变量和mixin都可以在导入的主文件当中使用。

SASS会基于当前目录查找其它文件，以及Rack、Rails或者Merb下的SASS文件目录。可以通过`:load_paths`或`--load-path`选项指定额外的搜索目录。 

`@import`通过指定路径以及文件名来引入SASS文件，但是在下面4种情况当中，`@import`仅被编译为普通的CSS语句：

1. 如果文件拓展名为`.css`。
2. 如果文件名以`http://`开头。
3. 如果文件名是`url()`
4. 如果`@import`包含媒体查询语句。

```scss
/*===== SCSS =====*/
@import "app.css";
@import "pp" screen;
@import "https://uinika.github.io/app";
@import url(app);

/*===== CSS =====*/
@import url(app.css);
@import "pp" screen;
@import "https://uinika.github.io/app";
@import url(app);
```

除上述四种情况外，文件拓展名为`.scss`或`.sass`的情况都会进行预编译处理，即使**文件拓展名缺省**依然能够正确的进行导入。

```scss
// 下面2种导入方式等效
@import 'base';
@import 'base.scss;
```

SASS允许在一个`@import`语句内同时导入多个文件。

```scss
@import 'base', 'reset', 'app';
```

`@import`语句内可以有限制的使用`#{}`插值，即不能动态的导入基于变量的SASS文件，只能用于标准CSS的`@import url("");`导入方式。

```scss
/*===== SCSS =====*/
$family: unquote("Droid+Sans");
@import url("http://fonts.googleapis.com/css?family=#{$family}");

/*===== CSS =====*/
@import url("http://fonts.googleapis.com/css?family=Droid+Sans");
```

#### Partial

如果你引入一个SCSS或Sass文件，但并不希望它们编译成CSS文件，那么可以在文件名开头添加一个下划线`_`，这样Sass将不会把该文件编译成CSS文件，然后引入文件的时候不需要添加下划线。例如：你拥有一个` _colors.scss`，但是Sass并不会创建`_colors.css`文件，然后，不过仍然可以通过`@import "colors";`语句引入`_colors.scss`文件。

> 注意，不能在同一目录中包含相同名称的Partial和非Partial；例如：`_colors.scss`不能与`colors.scss`在相同目录下并存。

#### 嵌套的@import

大多数情况下，在代码的顶层使用`@import`导入是最为常用，但是我们依然可以在`CSS规则`和`@media规则`中使用；其效用如同基本的`@import`，仍然会去包含引入文件的内容。

例如``内包含如下代码：

```scss
/*===== SCSS =====*/
// 文件demo.scss包含如下代码
.demo {
  color: red;
}

#app {
  @import "demo"; // 在文件app.scss中引入demo.scss
}

/*===== CSS =====*/
#app .demo {
  color: red;
}
```

> 指令只能用于文档的基本级别，在一个嵌套上下文当中被`@import`引入的文件里，诸如`@mixin`或者`@charset`是不被允许的。

> 不能在`mixin`或者`控制指令`当中嵌套使用`@import`。

### @media / #media

Sass中`@media`的用法与CSS相同，但是允许在CSS规则中嵌套使用。编译时`@media`将被编译到文件最外层，包含嵌套的父级选择器。

```scss
/*===== SCSS =====*/
.sidebar {
  width: 300px;
  @media screen and (orientation: landscape) {
    width: 500px;
  }
}

/*===== CSS =====*/
.sidebar {
  width: 300px;
}

@media screen and (orientation: landscape) {
  .sidebar {
    width: 500px;
  }
}
```

@media的查询条件可以嵌套使用，编译后SASS会自动添加`and`关键字。

```scss
/*===== SCSS =====*/
@media screen {
  .sidebar {
    @media (orientation: landscape) {
      width: 500px;
    }
  }
}

/*===== CSS =====*/
@media screen and (orientation: landscape) {
  .sidebar {
    width: 500px;
  }
}
```

`@media`的查询条件当中也可以使用SassScript。

```scss
/*===== SCSS =====*/
$media: screen;
$feature: -webkit-min-device-pixel-ratio;
$value: 1.5;
@media #{$media} and ($feature: $value) {
  .sidebar {
    width: 500px;
  }
}

/*===== CSS =====*/
@media screen and (-webkit-min-device-pixel-ratio: 1.5) {
  .sidebar {
    width: 500px;
  }
}
```

### @extend / #extend

现实的Web页面开发场景当中，当一个`class`属性拥有其它多个`class`所具备样式的时候，通常的做法是在HTML上书写全部这些`class`，如同下面的代码：

```html
<div class="error seriousError">
  Oh no! You've been hacked!
</div>

<style>
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  border-width: 3px;
}
</style>
```

这样的代码并不利于维护，并且会带来非语义相关的样式到HTML上。

使用Sass提供的`@extend `可以在不同CSS选择器之间继承样式，从而完美避免上述问题。

```scss
/*===== SCSS =====*/
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  @extend .error;
  border-width: 3px;
}

/*===== CSS =====*/
.error, .seriousError {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  border-width: 3px;
}
```

上面代码中`.error`的样式会自动应用到`.seriousError`，作用相当于同时使用了这两个`class`上的样式。

通过`.error`定义的其它样式规则，同样会在`.seriousError`上工作，比如下面这样定义样式后。

```scss
.error.danger {
  background-image: url("/image/warning.png");
}
```

然后`<div class="seriousError danger">`的背景图片同样会是`warning.png`。

#### 工作原理

`@extend`是通过向被继承的CSS选择器，插入需要继承的CSS选择器来进行工作，例如上面例子的代码转换如下：

```scss
/*===== SCSS =====*/
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.error.danger {
  background-image: url("/image/warning.png");
}
.seriousError {
  @extend .error;
  border-width: 3px;
}

/*===== CSS =====*/
.error, .seriousError {
  border: 1px #f00;
  background-color: #fdd; }

.error.danger, .seriousError.danger {
  background-image: url("/image/warning.png"); }

.seriousError {
  border-width: 3px; }
```

> 合并选择器的时候，`@extend`将会避开不必要的样式规则重复，并且不会生成不能匹配任何东西的选择器。

#### 继承复杂的选择器

`class`选择器并不是唯一能被继承的选择器，其它选择器也可以被继承，甚至可以去继承一个CSS元素，接着看下面的代码：

```scss
/*===== SCSS =====*/
.hoverlink {
  @extend a:hover;
}
a:hover {
  text-decoration: underline;
}

/*===== CSS =====*/
a:hover, .hoverlink {
  text-decoration: underline; }
```

就像前面内容中的`.error.intrusion`一样，`a:hover`上定义的规则也会在`.hoverlink`上工作，即使它们拥有着其它的选择器。

```scss
/*===== SCSS =====*/
.hoverlink {
  @extend a:hover;
}
.comment a.user:hover {
  font-weight: bold;
}

/*===== CSS =====*/
.comment a.user:hover, .comment .user.hoverlink {
  font-weight: bold; }
```

#### 多重继承

一个选择器可以同时继承多个选择器的样式，例如：

```scss
/*===== SCSS =====*/
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.attention {
  font-size: 3em;
  background-color: #ff0;
}
.seriousError {
  @extend .error;
  @extend .attention;
  border-width: 3px;
}

/*===== CSS =====*/
.error, .seriousError {
  border: 1px #f00;
  background-color: #fdd;
}

.attention, .seriousError {
  font-size: 3em;
  background-color: #ff0;
}

.seriousError {
  border-width: 3px;
}
```

上面代码中，每个`.seriousError`旁边都会伴随`.error`和`.attention`选择器。通常，文档后面定义的样式将会采取这样的优先级规则：`.seriousError`的背景色是`#ff0`而非`#fdd`，因为`.attention`定义的位置比`.error`更加靠后.

多重继承时还可以使用逗号`,`分隔的选择器列表，例如：`@extend .error, .attention`作用与`@extend .error; @extend .attention;`等效。


#### 链式继承

一个选择器可以继承另外一个选择器，另外一个选择器又继承了第三个选择器，从而形成链式的继承结构。

```scss
/*===== SCSS =====*/
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  @extend .error;
  border-width: 3px;
}
.criticalError {
  @extend .seriousError;
  position: fixed;
  top: 10%;
  bottom: 10%;
  left: 10%;
  right: 10%;
}

/*===== CSS =====*/
.error, .seriousError, .criticalError {
  border: 1px #f00;
  background-color: #fdd; }

.seriousError, .criticalError {
  border-width: 3px; }

.criticalError {
  position: fixed;
  top: 10%;
  bottom: 10%;
  left: 10%;
  right: 10%; }
```

上面代码中，所有使用`.error`的位置也会使用`.seriousError`，同时使用`.seriousError`和`.error`的位置则都会使用到`.criticalError`。

#### 选择器序列

诸如`.foo .bar or .foo + .bar`这样的选择器队列目前还不能被继承，但是嵌套选择器本身是可以使用`@extend`实现继承的，例如:

```scss
/*===== SCSS =====*/
a {
  color: blue;
  &:hover {
    text-decoration: underline;
  }
}

#fake-links .link {
  @extend a;
}

/*===== CSS =====*/
a, #fake-links .link {
  color: blue; }
  a:hover, #fake-links .link:hover {
    text-decoration: underline; }
```

有时候选择器序列会继承出现在另一个序列中的选择器，这种情况下就需要合并两个序列，例如：

```scss
/*===== SCSS =====*/
#admin .tabbar a {
  font-weight: bold;
}
#demo .overview .fakelink {
  @extend a;
}
```

由上面代码在技术上可能匹配2个选择器序列当中的每个序列，可能导致生成的CSS样式体积较大。因此如果例子中需要10个选择器，Sass将会只会生成一个有效的选择器。

当被合并的2个选择器序列没有共同的选择器时，那么将会生成2个新的选择器：第1个选择器序列在第2个之前，以及第2个选择器序列在第1个之前，就像下面这样：

```css
/*===== CSS =====*/
#admin .tabbar a,
#admin .tabbar #demo .overview .fakelink,
#demo .overview #admin .tabbar .fakelink {
  font-weight: bold; }
```

如果需要合并的2个选择器序列共享了部分选择器，那么这些共享的选择器将会被合并，只有不同的选择器会发生变化。下面的例子中，两个选择器序列都包含`#admin`，所以编译结果会合并这两个ID选择器。

```scss
/*===== SCSS =====*/
#admin .tabbar a {
  font-weight: bold;
}
#admin .overview .fakelink {
  @extend a;
}

/*===== CSS =====*/
#admin .tabbar a,
#admin .tabbar .overview .fakelink,
#admin .overview .tabbar .fakelink {
  font-weight: bold; }
```

#### 只能@extend的选择器

有些时候，你只想为需要去`@extend`继承的Class选择器编写样式，并且不希望直接使用到HTML。在编写Sass库的时候，你可能要为使用者提供`@exnted`继承的样式，并且使用者如果不需要可以选择忽略。

如果使用普通的Class选择器，会生成更多额外的CSS。而且可能与其它Class选择器发生样式冲突，因此Sass提供了**占位选择器**（*placeholder selectors*），例如`%foo`。

占位选择器的外观看起来与Class或者ID选择器类似，只是`#`和`.`被`%`所替代。占位选择器可以出现在任意Class和ID选择器能够使用的位置，并能够防止其中定义的规则集被渲染为CSS。

```scss
/*===== SCSS =====*/
// This ruleset won't be rendered on its own.
#context a%extreme {
  color: blue;
  font-weight: bold;
  font-size: 2em;
}
.notice {
  @extend %extreme;
}

/*===== CSS =====*/
#context a.notice {
  color: blue;
  font-weight: bold;
  font-size: 2em; }
```

#### !optional

当继承一个选择器的时候，如果`@extend`没有工作将会发生错误，例如对于`a.important {@extend .notice}`，如果当前文档没有包含`.notice`选择器就会发生错误。如果被包含的这个选择器`.notice`是`h1.notice`，由于`h1`与`a`具有冲突，因此没有新的选择器将会被创建。

如果希望`@extend`不生成任何选择器，可以在选择器后面添加`!optional`标志，例如：

```scss
a.important {
  @extend .notice !optional;
}
```

#### 在指令中使用@extend


在`@media`之类的指令中使用`@extend`会存在一些限制，Sass不能让`@media`代码块之外的CSS规则应用到其内部的选择器，从而避免四处拷贝样式并新建大量的样式块。这意味如果在`@media`或其它CSS指令中使用`@extend`，那么就只能继承当前指令块内出现的选择器。

例如下面的代码工作状态良好：

```scss
@media print {
  .error {
    border: 1px #f00;
    background-color: #fdd;
  }
  .seriousError {
    @extend .error;
    border-width: 3px;
  }
}
```

但是这样的代码就是**错误**的：

```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}

@media print {
  .seriousError {
    // 无效的继承，因为.error定义在@media print指令的外面
    @extend .error;
    border-width: 3px;
  }
}
```

> 希望有一天浏览器能够原生支持`@extend`，并允许它用于`@media`或其它指令当中。

### @at-root / #at-root

某些需要放置在文档根元素上的样式，可以就近的放置在其父选择器上，该特性同样可用于行内CSS选择器。

```scss
/*===== SCSS =====*/
.parent {
  ...
  @at-root .child { ... }
}

/*===== CSS =====*/
.parent { ... }
.child { ... }
```

`@at-root`可以通过**代码块**同时包含多个选择器。

```scss
/*===== SCSS =====*/
.parent {
  ...
  @at-root {
    .child1 { ... }
    .child2 { ... }
  }
  .step-child { ... }
}

/*===== CSS =====*/
.parent { ... }
.child1 { ... }
.child2 { ... }
.parent .step-child { ... }
```

`@at-root`默认情况下仅仅是排除掉父级选择器，但是实际开发过程中也有可能需要将`@media`之类的指令选择性的过滤、移动到外面，这里可以通过`@at-root (without: ...)`和`@at-root (with: ...)`语法实现该操作。

```scss
/*===== SCSS =====*/
@media print {
  .page {
    width: 8in;
    @at-root (without: media) {
      color: red;
    }
  }
}

/*===== CSS =====*/
@media print {
  .page {
    width: 8in;
  }
}

.page {
  color: red;
}
```

可以向`@at-root`传递2个特殊值，`rule`表示普通的CSS规则，因此`@at-root (without: rule)`作用类似于没有任何查询条件的`@at-root`；`all`代码全部CSS规则，`@at-root (without: all)`代表样式将会被移动到所有指令和CSS规则的外侧。

### @debug

`@debug`指令打印SassScript表达式的值到标准错误输出流，可以用来调试具有复杂SassScript的SASS文件，例如：

```scss
/*===== SCSS =====*/
@debug 10em + 12em;

/*===== CSS =====*/
Line 1 DEBUG: 22em
```

### @warn

`@warn`指令打印SassScript表达式的值到标准错误输出流，在警告用户弃用库或者修复`mixin`轻微错误的场景比较有用，`@warn`和`@debug`存在2个主要区别：

> 可以使用`--quiet`命令行选项或SASS的`:quiet`选项来关闭`@warn`警告。
> 样式表trace将与消息一起被打印，开发人员可以方便的看到`@warn`警告发生在样式表的哪里个位置。

```scss
/*===== SCSS =====*/
@mixin adjust-location($x, $y) {
  @if unitless($x) {
    @warn "Assuming #{$x} to be in pixels";
    $x: 1px * $x;
  }
  @if unitless($y) {
    @warn "Assuming #{$y} to be in pixels";
    $y: 1px * $y;
  }
  position: relative;
  left: $x;
  top: $y;
}
```

### @error

`@error`指令抛出一个SassScript表达式的值作为致命错误，其中包含了友好的堆栈trace，可以用来验证`mixin`和`function`的参数，例如：

```scss
@mixin adjust-location($x, $y) {
  @if unitless($x) {
    @error "$x may not be unitless, was #{$x}.";
  }
  @if unitless($y) {
    @error "$y may not be unitless, was #{$y}.";
  }
  position: relative;
  left: $x;
  top: $y;
}
```

> SASS当前还没有提供捕获`@error`的方式。


## 控制指令和表达式

SassScript支持一些基本的控制指令和表达式，例如只在某些条件下包含样式，或是在多次变化中包含相同的样式。

> 控制指令属于高级特性，并不经常使用，主要用于`mixins`当中，尤其是对于Compass这样的库。

### `if()`

内置的`if()`函数允许在一个条件处理分支返回两种可能的结果，它可以用于任意的脚本上下文。`if()`函数只能判断相应的那个参数并且返回，这允许引用已经被定义或者计算的变量，否则将会导致错误发生（*例如除以零*）。

```scss
/*===== SCSS =====*/
div {
  width: if(true, 1px, 2px);
  height: if(false, 1px, 2px); 
}

/*===== CSS =====*/
div {
  width: 1px;
  height: 2px; }
```

### `@if`

`@if`指令接收一个SassScript表达式，当表达式返回`false`或者`null`之外的数据时，会选择使用接下来的嵌套语句，

```scss
/*===== SCSS =====*/
p {
  @if 1+1==2 {
    border: 1px solid;
  }
  @if 5 < 3 {
    border: 2px dotted;
  }
  @if null {
    border: 3px double;
  }
}

/*===== CSS =====*/
p {
  border: 1px solid; }
```

`@if`语句后面可以跟随多个`@else if`语句和一个`@else`语句，如果`@if`语句失败，SASS将逐个尝试`@else if`语句，直至其中一个成功；如果全部失败，则会执行`@else`语句。例如：

```scss
/*===== SCSS =====*/
$type: monster;
p {
  @if $type==ocean {
    color: blue;
  }
  @else if $type==matador {
    color: red;
  }
  @else if $type==monster {
    color: green;
  }
  @else {
    color: black;
  }
}

/*===== CSS =====*/
p {
  color: green; }
```

### `@for`

`@for`指令用于重复输出一组样式，每次重复时都会存在一个计数器变量用于调整输出结果。该指令拥有`@for $var from <start> through <end>`和`@for $var from <start> to <end>`两种形式。

`$var`可以是任意变量名（例如`$i`），`<start>`和`<end>`是返回整数的SassScript表达式，如果`<start>`大于`<end>`，那么计数器将会进行递减而非递增。

`@for`指令会设置`$var`为指定范围内的连续数值，对于`from...through`数值范围包括`<start>`和`<end>`的值，对于`from...to`会从`<start>`开始运行，但不会包括`<end>`的值。

```scss
/*===== SCSS =====*/
@for $i from 1 through 3 {
  .item-#{$i} {
    width: 2em * $i;
  }
}

/*===== CSS =====*/
.item-1 {
  width: 2em; }

.item-2 {
  width: 4em; }

.item-3 {
  width: 6em; }
```


### `@each`

`@each`指令的使用格式为`@each $var in <list or map>`，其中`$var`可以是任意变量名称（_例如`$length`或`$name`_），而`<list or map>`是一个返回`list`或者`map`的SassScript表达式。

`@each`规则设置`$var`为`list`或`map`当中的每一项，输出样式中将会使用`$var`的实际值。

```scss
/*===== SCSS =====*/
@each $animal in puma, sea-slug, egret, salamander {
  .#{$animal}-icon {
    background-image: url('/images/#{$animal}.png');
  }
}

/*===== CSS =====*/
.puma-icon {
  background-image: url("/images/puma.png"); }

.sea-slug-icon {
  background-image: url("/images/sea-slug.png"); }

.egret-icon {
  background-image: url("/images/egret.png"); }

.salamander-icon {
  background-image: url("/images/salamander.png"); }
```

#### 多重赋值

`@each`指令能够以`@each $var1, $var2, ... in <list>`的格式使用多个变量，如果`<list>`是一个列表中的列表元素，那么子列表中的每个元素将会被分配至各自的变量，例如：

```scss
/*===== SCSS =====*/
@each $animal, $color, $cursor in (puma, black, default), (sea-slug, blue, pointer), (egret, white, move) {
  .#{$animal}-icon {
    background-image: url('/images/#{$animal}.png');
    border: 2px solid $color;
    cursor: $cursor;
  }
}

/*===== CSS =====*/
.puma-icon {
  background-image: url("/images/puma.png");
  border: 2px solid black;
  cursor: default; }

.sea-slug-icon {
  background-image: url("/images/sea-slug.png");
  border: 2px solid blue;
  cursor: pointer; }

.egret-icon {
  background-image: url("/images/egret.png");
  border: 2px solid white;
  cursor: move; }
```

由于`maps`被视为一个键值对的列表，所以多重赋值也能够正常的工作，例如：

```scss
/*===== SCSS =====*/
@each $header, $size in (h1: 2em, h2: 1.5em, h3: 1.2em) {
  #{$header} {
    font-size: $size;
  }
}

/*===== CSS =====*/
h1 {
  font-size: 2em; }

h2 {
  font-size: 1.5em; }

h3 {
  font-size: 1.2em; }
```


### `@while`

`@while`指令可以用来重复输出嵌套的样式，直至SassScript表达式返回结果为`false`，可以用于实现比`@for`语句更复杂的循环，但日常开发较少使用。

```scss
/*===== SCSS =====*/
$i: 6;
@while $i>0 {
  .item-#{$i} {
    width: 2em * $i;
  }
  $i: $i - 2;
}

/*===== CSS =====*/
.item-6 {
  width: 12em; }

.item-4 {
  width: 8em; }

.item-2 {
  width: 4em; }
```


## Mixin指令

混入（*Mixin*）可以用来定义Web应用当中需要**复用**的样式，避免出现`.float-left`这样的无语义class。**混入**里可以包含CSS规则以及SASS语法，甚至可以携带参数和引入变量，从而方便的生成各种灵活的样式。

### 定义混入：`@mixin`

混入（*Mixin*）通过SASSR提供的`@mixin`指令来定义，后面跟随混入的名称与参数以及内容块，例如下面代码定义了一个名为`large-text`的Mixin：

```scss
@mixin large-text {
  font: {
    family: Arial;
    size: 20px;
    weight: bold;
  }
  color: #ff0000;
}
```

混入Mixin当中可以同时包含选择器和CSS属性，其中选择器还可以包含父级的选择器，例如：

```scss
@mixin clearfix {
  display: inline-block;
  &:after {
    content: ".";
    display: block;
    height: 0;
    clear: both;
    visibility: hidden;
  }
  * html & {
    height: 1px
  }
}
```

> 因为历史原因，混入Mixin的名字以及其它SASS标识符可以互换连字符`-`和下划线`_`，例如对于名称为`add-column`的混入，也可以将其视为`add_column`，反之亦然。


### 包含混入：`@include`

`@include`指令通过混入的名称和可选的参数，可以引入特定的混入Mixin至文档，从而包含并复用其样式，例如下面代码：

```scss
/*===== SCSS =====*/
@mixin large-text {
  font: {
    family: Arial;
    size: 20px;
    weight: bold;
  }
  color: #ff0000;
}

.page-title {
  @include large-text;
  padding: 4px;
  margin-top: 10px;
}

/*===== CSS =====*/
.page-title {
  font-family: Arial;
  font-size: 20px;
  font-weight: bold;
  color: #ff0000;
  padding: 4px;
  margin-top: 10px; }
```

混入Mixin可以包含在其它规则之外，只要它们不直接定义CSS属性或使用父选择器引用，例如：

```scss
/*===== SCSS =====*/
@mixin silly-links {
  a {
    color: blue;
    background-color: red;
  }
}

@include silly-links;

/*===== CSS =====*/
a {
  color: blue;
  background-color: red; }
```

混入Mixin也可以包含其它的混入，接下来看下面的代码：

```scss
@mixin compound {
  @include highlighted-background;
  @include header-text;
}

@mixin highlighted-background {
  background-color: #fc0;
}

@mixin header-text {
  font-size: 20px;
}
```

> 事实上，混入Mixin还可以包含自己，但是在SASS 3.3版本之前，这种递归调用的行为是被禁止的。另外，只有定义了后代选择器的混入Mixin可以安全的混入源文件的顶层。

### 参数

混入Mixin可以使用SassScript的值作为参数，参数被包括在混入当中并作为为变量提供给其内部使用。多个参数通过逗号`,`分隔，然后通过传递对应顺序的参数进行调用，例如：

```scss
/*===== SCSS =====*/
@mixin sexy-border($color, $width) {
  border: {
    color: $color;
    width: $width;
    style: dashed;
  }
}

p {
  @include sexy-border(blue, 1in);
}

/*===== CSS =====*/
p {
  border-color: blue;
  border-width: 1in;
  border-style: dashed; }
```

混入Mixin可以通过变量赋值语法为参数指定默认值，调用的时候如果缺省参数，则使用默认值代替，例如：

```scss
/*===== SCSS =====*/
// 定义参数$width的默认值为1
@mixin sexy-border($color, $width: 1in) {
  border: {
    color: $color;
    width: $width;
    style: dashed;
  }
}

p {
  @include sexy-border(blue);
}

h1 {
  @include sexy-border(blue, 2in);
}

/*===== CSS =====*/
p {
  border-color: blue;
  border-width: 1in;
  border-style: dashed; }

h1 {
  border-color: blue;
  border-width: 2in;
  border-style: dashed; }
```

#### 关键字参数

混入Mixin在通过`@include指令`进行引入时也可以使用显式的关键字参数，例如可以将上面例子改写为：

```scss
p {
  @include sexy-border($color: blue);
}

h1 {
  @include sexy-border($color: blue, $width: 2in);
}
```

> 虽然上面的方式不够简明，但能够使Scss代码更加容易阅读，并让函数接口更加灵活，并方便的进行多参数的混入。命名参数可以按照任意顺序进行传递，如果有默认值可以省略。并且由于命名参数本质上是变量名称，因此下划线`_`和连字符`-`可以互换使用。

#### 尾部逗号

如果传入**混入Mixin**或者**函数Function**的最后一个参数是位置性的或关键字风格的，那么可以在这个参数后面跟随一个逗号`,`，这种编码风格可以更加简洁的进行重构，并且减少语法错误。

#### 可变参数

有些场景下，**混入Mixin**或者**函数Function**的参数个数是不确定的，例如创建一个可以接收任意数量参数的`box-shadow`混入。SASS里可以通过`...`符号添加**可变参数**支持，将所有剩余的参数包装到一个列表List。

```scss
/*===== SCSS =====*/
@mixin box-shadow($shadows...) {
  -moz-box-shadow: $shadows;
  -webkit-box-shadow: $shadows;
  box-shadow: $shadows;
}

.shadows {
  @include box-shadow(0px 4px 5px #666, 2px 6px 10px #999);
}

/*===== CSS =====*/
.shadows {
  -moz-box-shadow: 0px 4px 5px #666, 2px 6px 10px #999;
  -webkit-box-shadow: 0px 4px 5px #666, 2px 6px 10px #999;
  box-shadow: 0px 4px 5px #666, 2px 6px 10px #999; }
```

可变参数可以包含任意需要传递给**混入Mixin**或者**函数Function**的关键字参数，它们可以通过[`keywords($args)`](http://sass-lang.com/documentation/Sass/Script/Functions.html#keywords-instance_method)函数 进行访问，该函数将会返回一个Map，将它们作为一个从字符串（_不包含`$`_）到值的映射返回。

可变参数也可以在调用Mixin的时候使用，使用相同的语法能够扩展一个值的列表List，以便每个值作为单独的参数传入；或者扩展值的Map，从而使每个键值对都会作为一个关键字参数来进行处理。例如：

```scss
/*===== SCSS =====*/
@mixin colors($text, $background, $border) {
  color: $text;
  background-color: $background;
  border-color: $border;
}

// 使用List作为参数
$values: #ff0000, #00ff00, #0000ff;
.primary {
  @include colors($values...);
}

// 使用Map作为参数
$value-map: (text: #00ff00, background: #0000ff, border: #ff0000);
.secondary {
  @include colors($value-map...);
}

/*===== CSS =====*/
.primary {
  color: #ff0000;
  background-color: #00ff00;
  border-color: #0000ff; }

.secondary {
  color: #00ff00;
  background-color: #0000ff;
  border-color: #ff0000; }
```

> 可以同时传递一个List和一个Map参数，只要List参数位于Map类型参数之前，例如`@include colors($values..., $map...)`。

我们可以通过可变参数包装Mixin并添加额外样式，而不改变Mixin的参数签名。这样**参数**将会通过被包装的Mixin直接进行传递，例如：

```scss
@mixin wrapped-stylish-mixin($args...) {
  font-weight: bold;
  @include stylish-mixin($args...);
}

.stylish {
  // $width参数将会以关键字的形式传递到stylish-mixin
  @include wrapped-stylish-mixin(#00ff00, $width: 100px);
}
```

### 传入内容块到Mixin

**样式块**可以传递到混入Mixin所包含样式的位置，它们会出现在Mixin内任意`@content`指令的位置，从而能够定义关联到选择器和指令的构造的抽象。

```scss
/*===== SCSS =====*/
@mixin apply-to-ie6-only {
  * html {
    @content;
  }
}

@include apply-to-ie6-only {
  #logo {
    background-image: url(/logo.gif);
  }
}

/*===== CSS =====*/
* html #logo {
  background-image: url(/logo.gif); }
```

同样的Mixin可以在简写语法的`.sass`文件中完成（_`@mixin`和`@include`分别用`=`和`+`表示_）。

```scss
=apply-to-ie6-only
  * html
    @content

+apply-to-ie6-only
  #logo
    background-image: url(/logo.gif)
```

> 注意： 当`@content`指令被指定多次或者位于一个循环当中，样式块将会在每次调用中被复制并引用。

有些Mixin可能需要传入一个内容块，或者根据是否传入内容块而具备不同的行为。当内容块传递至当前Mixin的时候，[`content-exists()`](http://sass-lang.com/documentation/Sass/Script/Functions.html#content_exists-instance_method)函数将会返回`true`，从而该函数可以用于帮助实现这类行为。

#### 变量作用域与内容块

传递给Mixin的内容块会在其定义的作用域中进行运算，而非混入Mixin的作用域。这意味Mixin当中的局部变量不能传递至样式块，并将其解析为全局值使用。

```scss
/*===== SCSS =====*/
$color: white;
@mixin colors($color: blue) {
  background-color: $color;
  @content;
  border-color: $color;
}

.colors {
  @include colors {
    color: $color;
  }
}

/*===== CSS =====*/
.colors {
  background-color: blue;
  color: white;
  border-color: blue; }
```

此外，这还清楚的表明，在被传递的内容块中使用的变量与Mixin，会关联到内容块定义位置的其它样式。

```scss
/*===== SCSS =====*/
@mixin smartphone {
  @content;
  color: gold;
}

#sidebar {
  $sidebar-width: 300px;
  width: $sidebar-width;
  @include smartphone {
    width: $sidebar-width / 3;
  }
}

/*===== CSS =====*/
#sidebar {
  width: 300px;
  width: 100px;
  color: gold; }
```


## 函数指令

SASS支持开发人员自定义函数，并且在任意值或脚本上下文里使用，例如：

```scss
/*===== SCSS =====*/
$grid-width: 40px;
$gutter-width: 10px;

@function grid-width($n) {
  @return $n * $grid-width + ($n - 1) * $gutter-width;
}

#sidebar {
  width: grid-width(5);
}

/*===== CSS =====*/
#sidebar {
  width: 240px; }
```

正如上面代码所展示的，函数可以访问任意全局变量并接收参数，其行为类似一个混入Mixin。函数可以包含语句，并且必须调用`@return`来设置函数的返回值。

与Mixin一样，SASS可以通过关键字参数调用自定义函数，因此可以像下面这样调用上面例子中的函数：

```scss
#sidebar {
  width: grid-width($n: 5);
}
```

建议在函数前面添加前缀以避免命名冲突，同时也能够有效区分哪些是自定义的函数，例如为自定义函数添加公司名称作为前缀`-uinika-grid-width`。自定义函数同样也支持可变参数，使用方式与混入Mixin相同。

> 同样由于历史原因，函数名以及其它SASS标识符当中的连字符`-`和下划线`_`都是可以互换的，如果定义了一个名为`grid-width`的函数，那么同样可以通过`grid_width`进行调用，反之亦然。


## 输出类型

虽然SASS默认输出的CSS格式是良好的，但是可以根据开发人员的个人习惯，使用SASS提供的其它4种输出格式。即可以通过`:style`选项进行设定，也可以在命令行中直接使用`--style`标志。

### `:nested`

**嵌套nested**是SASS默认的输出格式，每个属性都会占据一行，但缩进不是固定的，每个规则都基于其嵌套深度进行缩进。例如：

```scss
#main {
  color: #fff;
  background-color: #000; }
  #main p {
    width: 10em; }

.huge {
  font-size: 10em;
  font-weight: bold;
  text-decoration: underline; }
```

> 嵌套格式在阅读较大CSS工程文件时能够帮助开发人员快速的了解代码的结构。

### `:expanded`

**扩展expanded**格式类似于人工手写的CSS样式，每个属性和规则都独占用一行。规则当中的CSS属性会进行缩进，但规则本身并不会进行任何特殊的缩进，例如：

```scss
#main {
  color: #fff;
  background-color: #000;
}
#main p {
  width: 10em;
}

.huge {
  font-size: 10em;
  font-weight: bold;
  text-decoration: underline;
}
```

### `:compact`

**紧凑compact**格式比起上述两种格式占据的空间更小，这种格式将重点聚焦在选择器而非CSS属性上。每个CSS规则独自占据一行，该行还包括全部的CSS属性。*每个嵌套的规则都会另起新行，不嵌套的选择器会输出空白行作为分隔*，例如：

```scss
#main { color: #fff; background-color: #000; }
#main p { width: 10em; }

.huge { font-size: 10em; font-weight: bold; text-decoration: underline; }
```

### `:compressed`

**压缩compressed**格式会尽可能减小所生成文件的体积，并在该文件末尾产生一个换行。除了必要的选择器分隔之外，几乎没有多余的空格。这种格式会让颜色等CSS属性值以最简短的方式来进行表示，由于代码可读性极差，因此主要用于生产环境。

```css
#main{color:#fff;background-color:#000}#main p{width:10em}.huge{font-size:10em;font-weight:bold;text-decoration:underline}
```

## 扩展SASS

对于前端开发人员的特殊需求，SASS为提供了多项高阶定制功能，但是使用这些功能需要非常熟悉**Ruby**。例如自定义SASS函数、缓存存储、自定义导入器等等，这些功能在日常前端开发工作当中并不常用，可以根据需要查阅SASS的源码API文档。

-----

**2018年4月10日，全文完。**