---
title: JavaScript简明语法书
tags: JavaScript
categories: Web
---

JavaScript遵循的语言规范是ECMAScript，从2012年开始，所有的现代浏览器都完整支持ECMAScript 5.1标准。2015年6月17日，ECMA国际组织发布了第6版ECMAScript标准，官方称为ECMAScript 2015（*通常称为ES6*），从此ECMAScript每年发布一次新标准，**本文覆盖了当前最新ECMAScript2017草案当中的特性**。

![](javascript/logo.jpg)

<!-- more -->



JavaScript标准化工作由**ECMA**（*European Computer Manufacturers Association*）国际组织负责，JavaScript的语言标准被称为**ECMAScript**，企业遵循该标准开发各自的JavaScript实现，例如Firefox的`SpiderMonkey`或者Chrome中的`V8`解析引擎。

> ECMAScript的规范文档主要针对解析引擎的开发人员，而非JavaScript脚本的编写人员。

ECMAScript并未对**文档对象模型DOM**进行定义，该标准交由**W3C**（*World Wide Web Consortium*）和**WHATWG**（*Web Hypertext Application Technology Working Group*）制定。本文使用Firefox浏览器作为JavaScript测试代码的编写与运行环境，可以通过`Ctrl+Shift+K`快捷键进入控制台，或者使用`Shift+F4`进入代码草稿纸，执行和调试本文中的示例代码。

## Grammar and types

本章节主要讨论JavaScript的基础语法、变量声明、数据类型和字面量。

### Basics

JavaScript是轻量级的、解释型的、使用*first-class functions*（*即函数能够以参数的形式传递给其它函数，也可以作为其它函数的返回值，或能够以值的形式指派给一个变量*）的编程语言，其编程风格是基于原型的、多范式的、面向对象的动态脚本语言。

JavaScript对大小写敏感，并且使用Unicode字符集编码。JavaScript语句*statements*以分号进行分隔， 空格、缩进、换行符被称为*whitespace*，JavaScript源代码从左至右执行，并能自动在语句尾部插入分号。但为避免出现副作用，依然推荐在语句末尾手动添加分号。

### Comments

JavaScript注释的语法与C++等其它语言类似。

```javascript
// a one line comment
 
/* this is a longer, 
   multi-line comment
 */
 
/* You can't, however, /* nest comments */ SyntaxError */
```

### Declarations

JavaScript拥有3种变量声明方式。

1. `var`：声明一个变量。
2. `let`：声明具有块作用域的变量。
3. `const`：声明只读的常量。

### Variables

变量名称被称为标识符*identifiers*，必须以`字母`、下划线`_`、美元符`$`开头，其它字符可以是数字或大小写字母。

### Declaring variables

声明变量有3种方式：

1. 使用关键字`var`声明，可以是局部或全局变量。

```javascript
var x = 42
```

2. 不使用关键字声明，变量为全局变量。

```javascript
x = 42
```

3. 使用关键字`let`声明一个块作用域变量。

```javascript
let y = 13
```

### Evaluating variables

使用`var`或`let`关键字声明变量时，如果不指定初值，那么其默认值为`undefined`。因此，如果对一个未经声明的变量进行操作，就会发生`ReferenceError`错误。

```javascript
var a;
console.log("The value of a is " + a); // The value of a is undefined

var b;
console.log("The value of b is " + b); // The value of b is undefined

console.log("The value of c is " + c); // Uncaught ReferenceError: c is not defined

let x;
console.log("The value of x is " + x); // The value of x is undefined

console.log("The value of y is " + y); // Uncaught ReferenceError: y is not defined
let y;
```

可以通过`undefined`判断变量是否被赋值，下面代码中input变量没有被指定值，if语句的结果为true。

```javascript
var input;
if(input === undefined){
  doThis();
} else {
  doThat();
}
```

在布尔上下文中，`undefined`被自动判定为`false`，下面代码中变量myArray的值为undefined，因此myFunction()函数将会被执行。

```javascript
var myArray = [];
if (!myArray[0]) myFunction();
```

数值上下文当中`undefined`会被转换为`NaN`。

```javascript
var a;
a + 2;  // Evaluates to NaN
```

如果变量的值为`null`，那么该变量在数值上下文中被视为`0`，布尔表达式中被视为`false`。

```javascript
var n = null;
console.log(n * 32); // Will log 0 to the console
```

### Variable scope

函数外部声明的变量是**全局变量**(*global variable*)，在整个文档上下文中有效。函数内部声明的变量称为**局部变量**(*local variable*)，只在被声明的函数当中有效。

JavaScript在ECMAScript 2015规范发布之前，并没有块作用域概念。因此代码块中的定义的变量将会被指派到临近的函数作用域或全局作用域。

```javascript
if (true) {
  var x = 5;
}
console.log(x);  // x is 5
```

使用ECMAScript 2015的let关键字声明，则会展现出不同的行为。

```javascript
if (true) {
  let y = 5;
}
console.log(y);  // ReferenceError: y is not defined
```

### Variable hoisting

JavaScript可以引用稍后声明的变量而不会引发异常，即感觉上是将变量提升至函数或语句的顶部，被提升的变量将会返回`undefined`。即使在使用或引用某个变量之后，再进行声明或初始化操作，这个被提升的引用仍将返回`undefined`。

```javascript
/**
 * Example 1
 */
console.log(x === undefined); // true
var x = 3;

/**
 * Example 2
 */
// will return a value of undefined
var myvar = "my value";
 
(function() {
  console.log(myvar); // undefined
  var myvar = "local value";
})();
```

上面代码也可以改写为如下形式。

```javascript
/**
 * Example 1
 */
var x;
console.log(x === undefined); // true
x = 3;
 
/**
 * Example 2
 */
var myvar = "my value";
 
(function() {
  var myvar;
  console.log(myvar); // undefined
  myvar = "local value";
})();
```

由于存在变量声明提升，函数中所有`var`语句应该尽可能放置在接近函数顶部的位置，这将大大提升程序代码的清晰程度。

ECMAScript 2015当中，`let`和`const`将不会被提升至代码块顶部，因此在代码块当中，在变量声明之前引用该变量将会发生`ReferenceError`(*变量进入暂时性死区，直至该变量被声明*)。

```javascript
console.log(x); // ReferenceError
let x = 3;
```

### Function hoisting

对于函数而言，只有**函数声明**可以被提升至代码顶部，而非**函数表达式**。

```javascript
/* Function declaration */

foo(); // "bar"

function foo() {
  console.log("bar");
}


/* Function expression */

baz(); // TypeError: baz is not a function

var baz = function() {
  console.log("bar2");
};
```

### Global variables

浏览器中的全局对象是**window**，可以通过`window.variable`语法读写全局变量。也可以通过指定*window*或*frame*的名字，从一个*window*或*frame*访问另一个*window*或*frame*中声明的变量。例如，在文档中声明1个变量*phoneNumber*，那么就可以在子*frame*中通过`parent.phoneNumber`进行引用。

### Constants

可以通过关键字`const`创建一个只读的常量，常量标识符的命名规则与变量相同。

```javascript
const PI = 3.14;
```

常量不可以通过赋值改变其值，也不可以在脚本运行时重新声明，**它必须被初始化为某个值**。

`const`常量的作用域与`let`变量的作用域相同，在同一作用域中，常量名不能与变量名、函数名同名。

```javascript
// THIS WILL CAUSE AN ERROR
function f() {};
const f = 5;

// THIS WILL CAUSE AN ERROR ALSO
function f() {
  const g = 5;
  var g;

  //statements
}
```

但是，`const`声明的对象的属性并不会受到常量的保护。

```javascript
const MY_OBJECT = {"key": "value"};
MY_OBJECT.key = "otherValue";
```

### Data structures and types

- 原生数据类型Boolean、null、undefined、Number、String、Symbol(*ECMAScript 2015定义的全新数据类型，其实例唯一并且不可变*)。

- 引用数据类型，对象Object。

### Data type conversion

JavaScript是动态类型语言，声明变量时不需要指定数据类型，因为在脚本执行过程中变量的数据类型会动态转换。

```javascript
var answer = 42;
answer = "Thanks for all the fish...";
```

在涉及加号运算符**+**的数字和字符串表达式中，JavaScript自动将数字值转换为字符串。

```javascript
x = "The answer is " + 42 // "The answer is 42"
y = 42 + " is the answer" // "42 is the answer"
```

涉及其它运算符时，JavaScript并不会将数字转换为字符串。

```javascript
"37" - 7 // 30
"37" + 7 // "377"
```

### Converting strings to numbers

可以通过下面2种方法将字符串转换为对应的数字。

1. 通过`parseInt()`、`parseFloat()`进行转换。
2. 使用单目的加法运算符`+`。

```javascript
"1.1" + "1.1" = "1.11.1"
(+"1.1") + (+"1.1") = 2.2   
// Note: the parentheses are added for clarity, not required.
```

### Literals

计算机科学中，字面量*literal*用于表达源代码中一个固定值的表示方法，例如整数、浮点数、字符串、布尔类型。而在JavaScript当中，可以使用如下几种字面量：

#### Array literals

数组字面量是使用方括号`[]`包含零个或多个表达式的列表，每个表达式代表数组的1个元素，数组的长度就是方括号中元素的个数。

```javascript
var coffees = ["French Roast", "Colombian", "Kona"];
var a=[3];
console.log(a.length); // 1
console.log(a[0]); // 3
```

如果在方括号中连续书写2个逗号`,`，数组就会产生一个值为`undefined`的元素，下面数组`fish`的第2个元素值为undefined。

```javascript
var fish = ["Lion", , "Angel"];
```

往数组列表最后一个元素后添加的逗号将被忽略，例如下面代码中数组`myList`的长度为`3`。

```javascript
var myList = ['home', , 'school', ];
```

下面代码中，数组`myList`的长度为4，元素`myList[0]`和`myList[2]`缺失，被默认为`undefined`。

```javascript
var myList = [ , 'home', , 'school'];
```

再看一个例子，数组`myList`的长度是`4`，元素`myList[1]`和`myList[3]`缺失，只有最后的逗号被忽略。

```javascript
var myList = ['home', , 'school', , ];
```

> 显式将缺失的元素声明为`undefined`，将大大提高代码的清晰度和可维护性。

#### Boolean literals

布尔类型有`true`和`false`两种字面量。

>  不要混淆布尔对象与原始布尔类型，布尔对象只是原始布尔类型的包装类。

#### Integers

整数可以用如下方式表示：
1. **十进制**整数由一串数字序列组成，没有任何前缀。
2. **八进制**整数以0(或0O、0o)开头，只能包括数字0-7。
3. **十六进制**整数以0x(或0X)开头，可以包含数字0-9和字母a~f或A~F。
4. **二进制**整数以0b(或0B)开头，只能包含数字0和1。

```javascript
0, 117 and -345 (decimal, base 10)
015, 0001 and -0o77 (octal, base 8) 
0x1123, 0x00111 and -0xF1A7 (hexadecimal, "hex" or base 16)
0b11, 0b0011 and -0b11 (binary, base 2
```

#### Floating-point literals

浮点数可以以小数或指数形式表示，但至少拥有一位数字，且必须带小数点或者e或E。

```javascript
3.14      
-.2345789 // -0.23456789
-3.12e+12  // -3.12*1012
.1e-23    // 0.1*10-23=10-24=1e-24
```

#### Object literals

对象字面量是封闭在花括号`{}`中的*键-值对*的列表。

```javascript
var Sales = "Toyota";

function CarTypes(name) {
  return (name === "Honda") ?
    name :
    "Sorry, we don't sell " + name + "." ;
}

var car = { myCar: "Saturn", getCar: CarTypes("Honda"), special: Sales };

console.log(car.myCar);   // Saturn
console.log(car.getCar);  // Honda
console.log(car.special); // Toyota
```

可以使用数字或字符串作为属性名，也可以嵌套使用对象字面量。

```javascript
var car = { manyCars: {a: "Saab", "b": "Jeep"}, 7: "Mazda" };

console.log(car.manyCars.b); // Jeep
console.log(car[7]); // Mazda
```

对象属性名可以使用空字符串，如果对象属性名是非法的标识符，则必须使用双引号`""`进行包裹。不合法的属性名不能用`.`访问其属性值，而要通过类数组标记`[""]`进行访问和赋值。

```javascript
var unusualPropertyNames = {
  "": "An empty string",
  "!": "Bang!"
}
console.log(unusualPropertyNames."");   // SyntaxError: Unexpected string
console.log(unusualPropertyNames[""]);  // An empty string
console.log(unusualPropertyNames.!);    // SyntaxError: Unexpected token !
console.log(unusualPropertyNames["!"]); // Bang!
```

注意观察如下代码：

```javascript
var foo = {a: "alpha", 2: "two"};
console.log(foo.a);    // alpha
console.log(foo[2]);   // two
//console.log(foo.2);  // Error: missing ) after argument list
//console.log(foo[a]); // Error: a is not defined
console.log(foo["a"]); // alpha
console.log(foo["2"]); // two
```

ES2015当中，对象字面量提供了更多的新特性(**例如在创建时设置原型、简写foo：foo属性赋值、定义方法、调用父类的super方法、使用表达式动态计算属性名**)，更利于面向对象的设计。

```javascript
var obj = {
    // __proto__
    __proto__: theProtoObj,
    // Shorthand for ‘handler: handler’
    handler,
    // Methods
    toString() {
     // Super calls
     return "d " + super.toString();
    },
    // Computed (dynamic) property names
    [ 'prop_' + (() => 42)() ]: 42
};
```

#### RegExp literals

正则表达式字面量通过正斜杠`/`包围正则表达式而成。

```javascript
var re = /ab+c/;
```

#### String literals

由双引号`"`或单引号`‘`括起来的零个或多个字符。

```javascript
"foo"
'bar'
"1234"
"one line \n another line"
"John's cat"
```

可以在*字符串字面量*上使用*字符串对象*的所有方法，JavaScript会自动将字符串字面量转换为临时的字符串对象。当方法调用完毕之后，该临时字符串对象就会被销毁。

```javascript
console.log("John's cat".length) 
// Will print the number of symbols in the string including whitespace. 
// In this case, 10.
```

ES2015提供了模板字面量特性(*template literals*)，提供了一些语法糖帮助构建字符串。除此之外，还可以在模板字面量中通过添加标签来自定义模板的解析过程，从而防止注入攻击，或者建立基于字符串的高级封装。

```javascript
// Basic literal string creation
`In JavaScript '\n' is a line-feed.`

// Multiline strings
`In JavaScript template strings can run
 over multiple lines, but double and single
 quoted strings cannot.`

// String interpolation
var name = "Bob", time = "today";
`Hello ${name}, how are you ${time}?`

// Construct an HTTP request prefix is used to interpret the replacements and construction
POST`http://foo.org/bar?a=${a}&b=${b}
     Content-Type: application/json
     X-Credentials: ${credentials}
     { "foo": ${foo},
       "bar": ${bar}}`(myOnReadyStateChangeHandler);
```

转义字符(*Escaping characters*)，通过在引号前加上反斜线`\`，可以在字符串中插入引号。

<table>
 <caption>JavaScript转义字符</caption>
 <tbody>
  <tr>
   <td>\0</td>
   <td>Null字节</td>
  </tr>
  <tr>
   <td>\b</td>
   <td>退格符</td>
  </tr>
  <tr>
   <td>\f</td>
   <td>换页符</td>
  </tr>
  <tr>
   <td>\n</td>
   <td>换行符</td>
  </tr>
  <tr>
   <td>\r</td>
   <td>回车符</td>
  </tr>
  <tr>
   <td>\t</td>
   <td>Tab (制表符)</td>
  </tr>
  <tr>
   <td>\v</td>
   <td>垂直制表符</td>
  </tr>
  <tr>
   <td>\'</td>
   <td>单引号</td>
  </tr>
  <tr>
   <td>\"</td>
   <td>双引号</td>
  </tr>
  <tr>
   <td>\\</td>
   <td>反斜杠字符（\）</td>
  </tr>
  <tr>
   <td>\<em>XXX</em></td>
   <td>由从0～377最多三位八进制数XXX表示的Latin-1字符，例如\251是版权标识的八进制序列。</td>
  </tr>
  <tr>
   <td>\x<em>XX</em></td>
   <td>由从00～FF两位十六进制数字XX表示的Latin-1字符，例如\xA9是版权标识的十六进制序列。</td>
  </tr>
  <tr>
   <td><em>\uXXXX</em></td>
   <td>由四位十六进制数字XXXX表示的Unicode字符，例如\u00A9是版权标识的Unicode序列。</td>
  </tr>
  <tr>
   <td>\u<em>{XXXXX}</em></td>
   <td>Unicode code point转义字符。例如\u{2F804}相当于Unicode转义字符\uD87E\uDC04的简写。</td>
  </tr>
 </tbody>
</table>

可以按照以下方式，在字符串中使用转义字符。

```javascript
var quote = "He read \"The Cremation of Sam McGee\" by R.W. Service.";
var test = "one line \n another line";
var home = "c:\\temp";
```

JavaScript中执行换行有2种方式，一种是在换行之前加上反斜线`\`转义换行码。

```javascript
var str = "this string \
is broken \
across multiple\
lines."
console.log(str);   // this string is broken across multiplelines.
```

另一种方式，则是直接在行末添加换行符进行转义。

```javascript
var poem = 
"Roses are red,\n\
Violets are blue.\n\
Sugar is sweet,\n\
and so is foo."
```


## Functions

函数是JavaScript的基本组成部分之一，包含了一段用于执行特定计算的语句，调用函数时，必须在调用该函数的作用域内对其进行定义。

### Defining function

#### 函数声明

由函数名称、参数列表、函数语句构成，例如下面代码定义了一个square函数：

```javascript
function square(number) {
  return number * number;
}
```

```javascript
function myFunc(theObject) {
  theObject.make = "Toyota";
}

var mycar = {make: "Honda", model: "Accord", year: 1998};
var x, y;

x = mycar.make; // x gets the value "Honda"

myFunc(mycar);
y = mycar.make; // y gets the value "Toyota"
                // (the make property was changed by the function)
```

#### 函数表达式

函数也可以通过函数表达式的方式来创建，这样的函数是匿名的，例如函数square也可这样进行定义：

```javascript
var square = function(number) { return number * number };
var x = square(4) // x gets the value 16
```

当然，这样方式定义的函数也可以提供函数名，并且可以用于在函数内部指代函数本身，例如下面代码中的fac函数。

```javascript
var factorial = function fac(n) { return n < 2 ? 1 : n * fac(n-1) };

console.log(factorial(3));
```

通过这种方式，可以很方便的将函数作为参数传递给另外一个函数，例如下面的map函数。

```javascript
function map(f,a) {
  var result = [], // Create a new Array
      i;
  for (i = 0; i != a.length; i++)
    result[i] = f(a[i]);
  return result;
}

var multiply = function(x) {return x * x * x}; // Expression function.
map(multiply, [0, 1, 2, 5, 10]);
```

JavaScript当中，可以先进行条件判断后，再来对函数进行定义，例如当num等于0时才会定义myFunc。

```javascript
var myFunc;
if (num === 0){
  myFunc = function(theObject) {
    theObject.make = "Toyota"
  }
}
```

> 除上述2种定义函数的方法之外，也可以在运行时用Function构造器来创建一个函数。

### Calling functions

定义函数仅仅是赋予其名称并明确被调用后的行为，函数只有在调用后才会被真正执行，例如定义square函数之后可以这样进行调用。

```javascript
square(5);
```

函数的调用和函数的定义一定要处于同一个作用域，其中函数声明的方式可以进行函数提升。

```javascript
console.log(square(5));
/* ... */
function square(n) { return n * n }
```

但是使用函数表达式定义函数时，则无法实现函数提升。

```javascript
console.log(square); // square is hoisted with an initial value undefined.
console.log(square(5)); // TypeError: square is not a function
var square = function (n) { 
  return n * n; 
}
```

在函数内部可以使用当前函数名进行递归操作，即函数可以调用其本身，例如下面函数执行的递归阶乘运算：

```javascript
function factorial(n){
  if ((n === 0) || (n === 1))
    return 1;
  else
    return (n * factorial(n - 1));
}

// You could then compute the factorials of one through five as follows
var a, b, c, d, e;
a = factorial(1); // a gets the value 1
b = factorial(2); // b gets the value 2
c = factorial(3); // c gets the value 6
d = factorial(4); // d gets the value 24
e = factorial(5); // e gets the value 120
```

### Function scope

在函数作用域中定义的函数，可以访问其父函数中定义的所有变量，以及父函数有权访问的任何其他变量。

```javascript
// The following variables are defined in the global scope
var num1 = 20,
    num2 = 3,
    name = "Chamahk";

// This function is defined in the global scope
function multiply() {
  return num1 * num2;
}

multiply(); // Returns 60

// A nested function example
function getScore () {
  var num1 = 2,
      num2 = 3;
  
  function add() {
    return name + " scored " + (num1 + num2);
  }
  
  return add();
}

getScore(); // Returns "Chamahk scored 5"
```

### Scope and the function stack

#### 递归

递归是指函数可以指向并调用自身。

```javascript
var foo = function bar() {
   // statements go here
};
```

在该函数作用域下，有3种方式可以调用该函数本身。

1. 函数名`bar()`
2. 语句`arguments.callee()`
3. 指向该函数的变量名`foo()`

调用自身的函数称为**递归函数**(*recursive function*)，某种意义上**递归**类似于**循环**，都是在重复执行相同的代码，且都需要一个避免陷入无限循环/递归的终止条件。

例如，下面的while循环：

```javascript
var x = 0;
while (x < 10) { // "x < 10" is the loop condition
   // do stuff
   x++;
}
```

可以被转换为递归函数`loop()`：

```javascript
function loop(x) {
  if (x >= 10) // "x >= 10" is the exit condition (equivalent to "!(x < 10)")
    return;
  // do stuff
  loop(x + 1); // the recursive call
}
loop(0);
```

有些算法不能使用简单的循环来实现，例如获取树结构的所有节点时，使用递归函数将会更加简便。

```javascript
function walkTree(node) {
  if (node == null) // 
    return;
  // do something with node
  for (var i = 0; i < node.childNodes.length; i++) {
    walkTree(node.childNodes[i]);
  }
}
```

递归函数当中使用了**函数堆栈**，具体请看下面的例子：

```javascript
function foo(i) {
  if (i < 0)
    return;
  console.log('begin: ' + i);
  foo(i - 1);
  console.log('end: ' + i);
}
foo(3);

// Output:

// begin: 3
// begin: 2
// begin: 1
// begin: 0
// end: 0
// end: 1
// end: 2
// end: 3
```

#### 嵌套函数和闭包

闭包(*closure*)是拥有自身独立环境和变量的表达式(通常是函数)，在一个函数内嵌套另外一个函数，此时内部函数就形成了闭包。

内部函数只可以在外部函数中访问，且内部函数相对外部函数是私有的(不能使用外部函数的参数和变量)，但内部函数可以继承外部函数的参数和变量。换而言之，内部函数可以包含外部函数的作用域。

```javascript
function addSquares(a, b) {
  function square(x) {
    return x * x;
  }
  return square(a) + square(b);
}
a = addSquares(2, 3); // returns 13
b = addSquares(3, 4); // returns 25
c = addSquares(4, 5); // returns 41
```

由于内部函数形成了闭包，所以可以在内部函数当中调用外部函数，并为外部函数和内部函数指定参数：

```javascript
function outside(x) {
  function inside(y) {
    return x + y;
  }
  return inside;
}
fn_inside = outside(3); // Think of it like: give me a function that adds 3 to whatever you give it
result = fn_inside(5); // returns 8

result1 = outside(3)(5); // returns 8
```

> 注意上例中`inside`被返回时`x`是如何保留下来的，一个闭包中必须保存其可见作用域中的所有参数和变量，因为每次调用所传入的参数可能都是不同的，每次对外部函数的调用实际上相当于重新创建了这个闭包，只有当返回的`inside`没有再被引用时，相应的内存才会被释放。

#### 多层嵌套函数

函数可以被多层嵌套(例如，函数A可以包含函数B，函数B可以再包含函数C)，最终B和C都形成了闭包，所以B可以访问A，C可以访问B和A。因此，闭包能够以类似递归的方式包含多个作用域，从而形成一条作用域链(*scope chaining*)。

```javascript
function A(x) {
  function B(y) {
    function C(z) {
      console.log(x + y + z);
    }
    C(3);
  }
  B(2);
}
A(1); // logs 6 (1 + 2 + 3)
```

上面例子中，C可以访问B的y、A的x，因为B是一个包含了A的闭包，所以B可以访问A的参数和变量；C是一个包含了B的闭包，因为B包含A，C也包含A，所以C可以访问B和A的参数和变量。但是，反过来A却不能访问C，因为A看不到B中的参数和变量，而C是B中的一个变量，所以C是B私有的。


#### 命名冲突

当同一个闭包作用域下2个参数或者变量同名时，就会产生命名冲突。更近的作用域拥有更高的优先级，更远的作用域优先级相应也就更低。

```javascript
function outside() {
  var x = 10;
  function inside(x) {
    return x;
  }
  return inside;
}
result = outside()(20); // returns 20 instead of 10
```

### Closures

闭包是JavaScript中最强大的特性之一，JavaScript允许函数嵌套，并且内部函数可以访问定义在外部函数中的所有变量和函数，以及外部函数能访问的所有变量和函数。但外部函数却不能够访问定义在内部函数中的变量和函数，这给内部函数的变量提供了一定的安全性。当内部函数以某种方式被任何一个外部函数作用域访问时，就产生了一个**闭包**。

> 当内部函数生存周期大于外部函数时，由于内部函数可以访问外部函数的作用域，定义在外部函数的变量、函数的生存周期就会大于外部函数本身。

```javascript
var pet = function(name) {   // The outer function defines a variable called "name"
  var getName = function() {
    return name;             // The inner function has access to the "name" variable of the outer function
  }
  return getName;            // Return the inner function, thereby exposing it to outer scopes
}
myPet = pet('Vivie');
   
myPet();                     // Returns "Vivie"
```

实际代码可能更加复杂，在下面的情形中，返回了一个包含可以操作外部函数的一系列方法所组成的对象。

```javascript
var createPet = function(name) {
  var sex;
  
  return {
    setName: function(newName) {
      name = newName;
    },
    
    getName: function() {
      return name;
    },
    
    getSex: function() {
      return sex;
    },
    
    setSex: function(newSex) {
      if(typeof newSex === 'string' && (newSex.toLowerCase() === 'male' || newSex.toLowerCase() === 'female')) {
        sex = newSex;
      }
    }
  }
}

var pet = createPet('Vivie');
pet.getName();                  // Vivie

pet.setName('Oliver');
pet.setSex('male');
pet.getSex();                   // male
pet.getName();                  // Oliver
```

上面代码中，内嵌函数可以操作外部函数的`name`参数，除了内嵌函数本身，没有其它方法可以取得内嵌的变量。内嵌函数的内嵌变量就像保险柜一样，为内嵌函数保留稳定而又安全的数据去参与运算。这些内嵌函数可以不被分配给一个变量，甚至不一定要有名字。

```javascript
var getCode = (function() {
  var secureCode = '0]Eal(eh&2';    // A code we do not want outsiders to be able to modify...
  
  return function() {
    return secureCode;
  };
}());

getCode();    // Returns the secureCode
```

尽管有上述优点，但使用闭包时仍然要小心避免一些陷阱，例如外部函数定义了与内部函数相同的变量名，那么外部函数将再也无法指向该变量。

```javascript
var createPet = function(name) {  // Outer function defines a variable called "name"
  return {
    setName: function(name) {    // Enclosed function also defines a variable called "name"
      name = name;               // ??? How do we access the "name" defined by the outer function ???
    }
  }
}
```

> 闭包中的this变量非常诡异，使用时必须十分小心，因为this指代什么完全取决于函数在何处被调用，而非在何处被定义。

### Arguments object

函数的实际参数会被保存在一个类似数组的arguments对象中，在函数作用域内可以通过`arguments[i]`引用传入的参数，第1个传来的参数是`arguments[0]`，参数个数可以通过`arguments.length`获得。使用arguments对象，可以处理比声明个数更多的参数，这在事先不知道参数个数的场景下十分有用。

例如，设想有一个用来连接字符串的函数，唯一事先确定的参数是用来分隔字符串各连接部分的字符(即下面例子中的`separator`参数)，该函数可以按如下方式进行定义：

```javascript
function myConcat(separator) {
   var result = ''; // initialize list
   var i;
   // iterate through arguments
   for (i = 1; i < arguments.length; i++) {
      result += arguments[i] + separator;
   }
   return result;
}
```

可以向这个函数传递任意数量的参数，从而返回一个由各参数连接而成的字符串。

```javascript
// returns "red, orange, blue, "
myConcat(', ', 'red', 'orange', 'blue');

// returns "elephant; giraffe; lion; cheetah; "
myConcat('; ', 'elephant', 'giraffe', 'lion', 'cheetah');

// returns "sage. basil. oregano. pepper. parsley. "
myConcat('. ', 'sage', 'basil', 'oregano', 'pepper', 'parsley');
```

> arguments变量只是*类数组对象*，并不是一个真正意义的数组，称其为类数组对象只是因为其具备索引和length属性，但并不拥有其它Array对象的操作方法。

### Function parameter

ECMAScript 6为函数添加了两个新类型的参数：默认参数(*default parameters*)，剩余参数(*rest parameters*)。

#### Default parameters

JavaScript中，函数参数的默认值是undefined。然而某些情况下可能需要设置不同的默认值，此时就可以考虑使用默认参数。

> 过去设定默认值的方法是在函数内判断参数值是否为undefined，如果为true则赋予一个默认值。

下面例子中，调用函数时没有实参传递给b，其值默认为undefined，于是a*b计算得到NaN：

```javascript
function multiply(a, b) {
  b = typeof b !== 'undefined' ?  b : 1;

  return a * b;
}

multiply(5); // 5
```

使用默认参数之后，就不再需要对参数进行默认值检查。

```javascript
function multiply(a, b = 1) {
  return a * b;
}

multiply(5); // 5
```

#### Rest parameters

剩余参数语法允许将不确定数量的参数表示为数组，下面例子中，使用剩余参数收集从第2个至最后1个参数，然后将剩余参数数组的每个元素与第1个参数相乘。

```javascript
function multiply(multiplier, ...theArgs) {
  return theArgs.map(x => multiplier * x);
}

var arr = multiply(2, 1, 2, 3);
console.log(arr); // [2, 4, 6]
```

### Arrow functions

箭头函数表达式与函数表达式相比，具有更简短的语法，并以词法方式绑定this。

> 箭头函数总是匿名的。

#### 更简短的语法

```javascript
var a = [
  'Hydrogen',
  'Helium',
  'Lithium',
  'Beryllium'
];

var a2 = a.map(function(s) { return s.length; });

console.log(a2); // logs [8, 6, 7, 9]

var a3 = a.map(s => s.length);

console.log(a3); // logs [8, 6, 7, 9]
```

### 词法式绑定this

箭头函数出现之前，每个新函数都重新定义了自己的this(严格模式下，以函数方式调用时this为undefined，以对象方式使用时this指向对象上下文)，不利于实现面向对象的编程风格。

```javascript
function Person() {
  // The Person() constructor defines `this` as itself.
  this.age = 0;

  setInterval(function growUp() {
    // In nonstrict mode, the growUp() function defines `this` 
    // as the global object, which is different from the `this`
    // defined by the Person() constructor.
    this.age++;
  }, 1000);
}

var p = new Person();
```

ECMAScript 3/5当中，通过把this的值赋值给一个变量可以修复该问题。

```javascript
function Person() {
  var self = this; // Some choose `that` instead of `self`. 
                   // Choose one and be consistent.
  self.age = 0;

  setInterval(function growUp() {
    // The callback refers to the `self` variable of which
    // the value is the expected object.
    self.age++;
  }, 1000);
}
```

> 可以使用Function.prototype.bind()方法为函数传递正确的this。

使用箭头函数可以正确捕捉闭包上下文中的this值，所以下面的代码工作正常。

```javascript
function Person() {
  this.age = 0;

  setInterval(() => {
    this.age++; // |this| properly refers to the person object
  }, 1000);
}

var p = new Person();
```

### Predefined functions

JavaScript语言当中的顶级内建函数：

- eval()：对字符串格式的JavaScript代码求值。

- uneval()：创建的一个Object的源代码的字符串表示。

- isFinite()：判断传入的值是否为有限的数值。

- isNaN()：判断一个值是否是NaN，其内部的强制转换规则十分有趣(可以考虑使用ES6中定义的Number.isNaN()代替，或使用typeof来判断数值类型)。

- parseFloat()：解析字符串参数，并返回一个浮点数。

- parseInt()：解析字符串参数，并返回指定基数的整数。

- decodeURI()：对经过encodeURI函数或其他类似方法编码过的字符串进行解码。

- decodeURIComponent()：对经过encodeURIComponent函数或其他类似方法编码过的字符串进行解码。

- encodeURI()：通过用以一个，两个，三个或四个转义序列表示字符的UTF-8编码替换统一资源标识符(URI)的某些字符来进行编码(每个字符对应四个转义序列，这四个序列组了两个”替代“字符)。

- encodeURIComponent()：通过用以一个，两个，三个或四个转义序列表示字符的UTF-8编码替换统一资源标识符（URI）的每个字符来进行编码（每个字符对应四个转义序列，这四个序列组了两个”替代“字符）。

- escape()： *已废弃*，用于计算生成一个新的字符串，其中的某些字符已被替换为十六进制转义序列。使用encodeURI或者encodeURIComponent替代本方法。

- unescape()：*已废弃*，用于计算生成一个新的字符串，其中的十六进制转义序列将被其表示的字符替换。建议使用decodeURI()或者decodeURIComponent替代本方法。


## Working with objects

Javascript基于简单的对象范式设计，一个对象由多个`key-value`属性组成。

### Objects overview

Javascript对象的概念可以比照现实生活中的物体，一个对象就是一个拥有属性和类型的实体。例如，一个杯子可以看作一个拥有颜色，图案，重量，材质等属性的对象。

### Objects and properties

属性用来定义对象的特征，可以通过点运算符`.`来访问。

```javascript
objectName.propertyName
```

对象名字与变量一样对大小写敏感，可以在定义对象属性时直接进行赋值。

```javascript
var myCar = new Object();
myCar.make = "Ford";
myCar.model = "Mustang";
myCar.year = 1969;
```

没有赋值的属性默认为`undefined`，而非`null`。

```javascript
myCar.color; // undefined
```

对象的属性也可以通过方括号`[]`访问或设置，例如可以按下面方式访问`myCar`对象的属性：

```javascript
// four variables are created and assigned in a single go, 
// separated by commas
var myObj = new Object(),
    str = 'myString',
    rand = Math.random(),
    obj = new Object();

myObj.type              = 'Dot syntax';
myObj['date created']   = 'String with space';
myObj[str]              = 'String value';
myObj[rand]             = 'Random Number';
myObj[obj]              = 'Object';
myObj['']               = 'Even an empty string';

console.log(myObj);
```

> 因为每个对象属性都有一个用于访问它的字符串值，所以对象有时也被称为关联数组(*associative arrays*) 。

当然，也可以通过变量作为索引来访问对象的属性：

```javascript
var propertyName = 'make';
myCar[propertyName] = 'Ford';

propertyName = 'model';
myCar[propertyName] = 'Mustang';
```

可以在`for...in`语句中通过方括号`[]`来枚举一个对象的全部属性，如下`showProps(obj, objName)`函数的作用是将某个对象及其名称作为参数传入时，返回该对象全部属性所组成的字符串。

```javascript
function showProps(obj, objName) {
  var result = '';
  for (var i in obj) {
    // obj.hasOwnProperty() is used to filter out properties from the object's prototype chain
    if (obj.hasOwnProperty(i)) {
      result += objName + '.' + i + ' = ' + obj[i] + '\n';
    }
  }
  return result;
}
```

因此，函数调用`showProps(myCar, "myCar")`将返回以下值：

```javascript
myCar.make = Ford
myCar.model = Mustang
myCar.year = 1969
```

### Enumerate the properties of an object

从ECMAScript 5开始，有3种原生方法可以用于枚举对象的属性：

- `for...in` 依次访问一个对象及其原型链中所有可枚举的属性。

- `Object.keys(o)` 返回对象o所拥有的属性名称(不包括原型)组成的数组。

- `Object.getOwnPropertyNames(o)` 返回对象o所拥有属性名称(无论是否可枚举)组成的数组。

在ECMAScript 5之前，没有原生方法可以枚举对象的所有属性，但可以通过如下编写函数来完成：

```javascript
function listAllProperties(o) {
	var objectToInspect;     
	var result = [];
	
	for(objectToInspect = o; objectToInspect !== null; objectToInspect = Object.getPrototypeOf(objectToInspect)) {  
      result = result.concat(Object.getOwnPropertyNames(objectToInspect));  
	}
	
	return result; 
}
```

> 这个函数在展示隐藏属性(即原型中不能通过对象访问的属性，因为更早的原型链中包含有相同的属性名)时很有用，可以通过在数组中去除同名元素即可列出需要访问的属性。

### Creating new objects

#### Using object initializers

对象初始化器(*object initializer*)也被称为对象字面量。

```javascript
var obj = {
  property_1: value_1,   // property_# may be an identifier...
  property_2: value_2,   // or a number...
  // ...,
 'property n': value_n
}; // or a string
```

JavaScript每次遇到对象字面量时都会创建对象，同样的，在函数中的对象字面量，在每次函数调用时也会创建对象。

下面例子中，只有当`cond`的值为`true`时，才会创建对象并赋值给变量`x`。

```javascript
if (cond) var x = {greeting: 'hi there'};
```

下面例子中，`myHonda`对象拥有3个属性，且其`engine`属性本身也是一个对象。

```javascript
var myHonda = {color: 'red', wheels: 4, engine: {cylinders: 4, size: 2.2}};
```

#### Using a constructor function

首先，创建一个构造函数来定义对象(*通常构造函数首字母大写*)，然后通过`new`关键字创建对象实例。


下面创建一个Car类，拥有make, model, year属性：

```javascript
function Car(make, model, year) {
  this.make = make;
  this.model = model;
  this.year = year;
}
```

> 注意通过this关键字将传入函数的参数赋值给对象属性。

接下来，可以像这样来创建mycar对象：

```javascript
var mycar = new Car('Eagle', 'Talon TSi', 1993);
var kenscar = new Car("Nissan", "300ZX", 1992);
var vpgscar = new Car("Mazda", "Miata", 1990);
```

一个对象的属性值可以是另一个对象：

```javascript
function Person(name, age, sex) {
  this.name = name;
  this.age = age;
  this.sex = sex;
}


var rand = new Person('Rand McKinnon', 33, 'M');
var ken = new Person('Ken Jones', 39, 'M');

function Car(make, model, year, owner) {
  this.make = make;
  this.model = model;
  this.year = year;
  this.owner = owner;
}

var car1 = new Car('Eagle', 'Talon TSi', 1993, rand);
var car2 = new Car('Nissan', '300ZX', 1992, ken);

```

> 上面代码将rand、ken作为owner参数的值。

可以使用下面代码访问car2的拥有者的姓名：

```javascript
car2.owner.name
```

可以总是为之前定义的对象增加新的属性：

```javascript
car1.color = 'black';
```

> 为car1增加color属性，并赋值为"black"，然而这并不会影响其它对象。

> 要为某个类型的所有对象增加新属性，必须将属性加入到Car对象的类型定义函数中。


#### Using the Object.create method

通过Object.create()创建对象时，可以通过传入第1个参数选定要创建对象的原型，第2个参数指定创建对象的属性和值。

```javascript
// Animal properties and method encapsulation
var Animal = {
  type: 'Invertebrates', // Default value of properties
  displayType: function() {  // Method which will display type of Animal
    console.log(this.type);
  }
};

// Create new animal type called animal1 
var animal1 = Object.create(Animal);
animal1.displayType(); // Output:Invertebrates

// Create new animal type called Fishes
var fish = Object.create(Animal);
fish.type = 'Fishes';
fish.displayType(); // Output:Fishes
```

### Inheritance

所有JavaScript对象至少继承于一个对象，被继承的对象称作原型，原型中的属性可以通过`prototype`属性进行访问。

### Indexing object properties

如果最初使用字符串名称定义一个属性，则后面可以通过该字符串名称来访问(无论通过点运算符`.`还是数组运算符`[]`)。

```javascript
var obj = {}

obj["name"]="test"

console.log(obj["name"]); // test
console.log(obj.name); // test
```

但是，如果使用了数字来定义属性名称，则必须通过索引进行访问。

```javascript
var obj = {}

obj[5]="test"

console.log(obj[5]); // test
console.log(obj.5); // Exception: SyntaxError: missing ) after argument list
```

对于DOM操作情况其实也类似，例如获取forms数组，即可以通过数字访问(*出现在DOM中的序数*)，也可以通过字符串访问(*标签form的name属性*)。

例如，HTML文档中第2个<form>标签拥有一个值为`myForm`的`name`属性，那么可以通过下面3种方式都访问该form元素。

```javascript
 document.forms[1]
 document.forms["myForm"]
 document.forms.myForm
```

### Defining properties for an object type

我们可以通过prototype属性，为上面定义过的Car类定义属性，从而让Car类的所有对象都具备该属性。下面代码为`Car`类增加了`color`属性，然后为对象`car1`的`color`属性赋值。

```javascript
Car.prototype.color = null;
car1.color = 'black';
```

> 参见Function对象的prototype属性。

### Defining methods

对象的方法是指与某个对象属性关联的函数。

```javascript
objectName.methodname = function_name;

var myObj = {
  myMethod: function(params) {
    // ...do something
  }

  // OR THIS WORKS TOO

  myOtherMethod(params) {
    // ...do something else
  }
};

// then call the method in the context of the object as follows
object.methodname(params);
```

可以在对象的构造函数中定义该对象的方法，例如为之前定义过的Car对象添加一个格式化显示其属性的方法。

```javascript
function displayCar() {
  var result = 'A Beautiful ' + this.year + ' ' + this.make + ' ' + this.model;
  pretty_print(result); // pretty_print is a function to display a horizontal rule and a string.
}

this.displayCar = displayCar;

function Car(make, model, year, owner) {
  this.make = make;
  this.model = model;
  this.year = year;
  this.owner = owner;
  this.displayCar = displayCar;
}

car1.displayCar();
car2.displayCar();
```

* 注意上面代码中的this指代的是该方法所属的对象。

### Using this for object references

关键字this在对象的方法中可以用来指代当前对象，例如，下面代码中用来检测某个对象属性中的最大/最小值的`validate`函数。

```javascript
function validate(obj, lowval, hival) {
  if ((obj.value < lowval) || (obj.value > hival)) {
    alert('Invalid Value!');
  }
}
```

然后在每个元素的`onchange`事件处理器中调用该`validate()`并将this传入。

```html
<input type="text" name="age" size="3" onChange="validate(this, 18, 99)" />
```

this可以在HTML表单中指代当前form元素，下面例子中，表单中button元素的onclick事件处理器通过`this.form`来指代其所在的表单元素`myForm`。

```html
<form name="myForm">
  <p>
    <label>Form name:<input type="text" name="text1" value="Beluga"></label>
  </p>
  <p>
    <input name="button1" type="button" value="Show Form Name" onclick="this.form.text1.value = this.form.name">
  </p>
</form>
```

### Defining getters and setters

getter/setter语法用来获取或设置对象(*通过对象字面量定义*)的属性，直接定义getter/setter函数的语法为`get property()`或`set proerty()`，

```javascript
var o = {
  a: 7,
  get b() { 
    return this.a + 1;
  },
  set c(x) {
    this.a = x / 2;
  }
};

console.log(o.a); // 7
console.log(o.b); // 8
o.c = 50;
console.log(o.a); // 25
```

> 需要注意，getter/setter的函数名称应该为对象字面量中的属性名。

如果需要定义一个已经声明的函数作为getter/setter，可以使用`Object.defineProperty`语法(旧语法中使用`Object.prototype.__defineGetter__`)。

下面例子使用getter/setter为Date对象的原型添加year属性，定义year属性的getter/setter时用到了Date类中已有的getFullYear和setFullYear方法。

```javascript
// These statements define a getter and setter for the year property.
var d = Date.prototype;
Object.defineProperty(d, 'year', {
  get: function() { return this.getFullYear(); },
  set: function(y) { this.setFullYear(y); }
});

// These statements use the getter and setter in a Date object.
var now = new Date();
console.log(now.year); // 2000
now.year = 2001; // 987617605170
console.log(now);
// Wed Apr 18 11:13:25 GMT-0700 (Pacific Daylight Time) 2001
```

总结一下，定义getter/setter方法有2种方式：

1. 在对象字面量中添加`get/set property()`函数，其中getter方法没有参数，而setter方法只接受1个参数(*设置新值*）。

```javascript
var o = {
  a: 7,
  get b() { return this.a + 1; },
  set c(x) { this.a = x / 2; }
};
```

2. 使用Object.defineProperties函数，对一个已创建的对象添加getter/setter方法，该函数第1个参数是需要定义getter/setter的对象，第2个参数是一个对象，该对象的属性名会作为getter/setter的名字，属性值是用来定义getter/setter的函数，下面例子定义了和上面相同的getter/setter方法。

```javascript
var o = { a: 0 };

Object.defineProperties(o, {
    'b': { get: function() { return this.a + 1; } },
    'c': { set: function(x) { this.a = x / 2; } }
});

o.c = 10; // Runs the setter, which assigns 10 / 2 (5) to the 'a' property
console.log(o.b); // Runs the getter, which yields a + 1 or 6
```

> 这两种定义方式取决于当前的编程风格和工作量，第1种方式更加简洁和自然，第2种方式虽然更能体现JavaScript的动态特性，但也会让代码变得更加难以阅读和理解。

### Deleting properties

可以使用`delete`操作符删除一个非继承的属性。

```javascript
// Creates a new object, myobj, with two properties, a and b.
var myobj = new Object;
myobj.a = 5;
myobj.b = 12;

// Removes the a property, leaving myobj with only the b property.
delete myobj.a;
console.log ('a' in myobj); // yields "false"
```

如果一个全局变量未使用`var`关键字声明，那么也可以通过`delete`进行删除。

```javascript
g = 17;
delete g;
```

### Comparing Objects

JavaScript对象属于引用类型，任意2个单独的对象永远不可能相等，即使它们拥有相同的属性。只有在比较2个具备相同引用的对象时才返回true。

```javascript
// Two variables, two distinct objects with the same properties
var fruit = {name: 'apple'};
var fruitbear = {name: 'apple'};

fruit == fruitbear; // return false
fruit === fruitbear; // return false
```

```javascript
// Two variables, a single object
var fruit = {name: 'apple'};
var fruitbear = fruit;  // assign fruit object reference to fruitbear

// here fruit and fruitbear are pointing to same object
fruit == fruitbear; // return true
fruit === fruitbear; // return true
```

```javascript
fruit.name = 'grape';
console.log(fruitbear);    // yields { name: "grape" } instead of { name: "apple" }
```


## Details of the object model

JavaScript是基于原型(*而非基于类*)的面向对象语言。

### Class-based vs. prototype-based languages

基于类的面向对象语言，构建在类(*class*)和实例(*instance*)两个概念之上。

- **类**：定义了所有用于具有某一组特征对象的属性，类并不描述任何特定的个体。

- **实例**：类的实例化体现，即类的一个成员。

JavaScript等基于原型的语言只会拥有**对象**，且具备一个**原型对象**(*prototypical object*)的概念。原型对象可以作为新对象获取属性的模板，但新对象可以(*在创建时或运行时*)指定其自身属性。而任何对象都可以作为另一个对象的原型(*prototype*)，从而允许后者共享前者的属性。

<table>
 <caption>基于类(Java)和基于原型(JavaScript)语言中对象的比较</caption>
 <thead>
  <tr>
   <th>基于类 (Java)</th>
   <th>基于原型的 (JavaScript)</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>类、实例分别为不同的概念</td>
   <td>所有对象均为实例</td>
  </tr>
  <tr>
   <td>通过类定义定义类，然后通过构造方法来实例化类</td>
   <td>通过构造器函数来定义、创建一个对象</td>
  </tr>
  <tr>
   <td>通过<code>new</code>操作符创建单个对象</td>
   <td>同样通过<code>new</code>操作符创建对象</td>
  </tr>
  <tr>
   <td>通过类定义来定义子类，从而构建对象的层级结构</td>
   <td>指定一个对象作为原型并且与构造函数一起构建对象的层级结构</td>
  </tr>
  <tr>
   <td>遵循类链继承属性</td>
   <td>遵循原型链继承属性</td>
  </tr>
  <tr>
   <td>类定义指定类所有实例的全部属性，无法在运行时动态添加属性</td>
   <td>构造器函数或原型指定初始的属性，然后允许动态的向单个对象或者整个对象集合中添加或移除属性</td>
  </tr>
 </tbody>
</table>

### The employee example

![](javascript/05.simple-object-hierarchy.png)

#### Employee definitions 

```java
public class Employee {
   public String name = "";
   public String dept = "general";
}
```
```javascript
function Employee() {
  this.name = '';
  this.dept = 'general';
}
```

#### Manager and WorkerBee definitions

```java
public class Manager extends Employee {
   public Employee[] reports = new Employee[0];
}

public class WorkerBee extends Employee {
   public String[] projects = new String[0];
}
```

```javascript
function Manager() {
  Employee.call(this);
  this.reports = [];
}
Manager.prototype = Object.create(Employee.prototype);

function WorkerBee() {
  Employee.call(this);
  this.projects = [];
}
WorkerBee.prototype = Object.create(Employee.prototype);
```

#### SalesPerson and Engineer definitions

```java
public class SalesPerson extends WorkerBee {
   public String dept = "sales";
   public double quota = 100.0;
}


public class Engineer extends WorkerBee {
   public String dept = "engineering";
   public String machine = "";
}
```
```javascript
function SalesPerson() {
   WorkerBee.call(this);
   this.dept = 'sales';
   this.quota = 100;
}
SalesPerson.prototype = Object.create(WorkerBee.prototype);

function Engineer() {
   WorkerBee.call(this);
   this.dept = 'engineering';
   this.machine = '';
}
Engineer.prototype = Object.create(WorkerBee.prototype);
```

#### Creating objects with simple definitions

![](javascript/05.creating-objects-with-simple-definitions.png)

```javascript
var jim = new Employee; // parentheses can be omitted if the constructor takes no arguments
// jim.name is ''
// jim.dept is 'general'

var sally = new Manager;
// sally.name is ''
// sally.dept is 'general'
// sally.reports is []

var mark = new WorkerBee;
// mark.name is ''
// mark.dept is 'general'
// mark.projects is []

var fred = new SalesPerson;
// fred.name is ''
// fred.dept is 'sales'
// fred.projects is []
// fred.quota is 100

var jane = new Engineer;
// jane.name is ''
// jane.dept is 'engineering'
// jane.projects is []
// jane.machine is ''
```

### Object properties

接下来讨论，对象如何通过prototype chain从其它对象继承属性，以及在运行时添加1个属性时所发生的情况。

#### Inheriting properties

假如通过下面语句创建了mark作为WorkerBee对象的实例：

```javascript
var mark = new WorkerBee;
```

javascript解析`new`操作符时，会创建一个通用对象，并将其作为关键字`this`的值传递给`WorkerBee`构造函数。该构造函数显式的设置projects的属性值，然后隐式的将该构造函数内部的`__proto__`属性设置为WorkerBee.prototype的值，`__proto__`最终决定了返回对象属性时所使用的原型链。最后，JavaScript返回新创建的对象，并赋值给变量mark。

![](javascript/05.mark-WorkerBee.png)

上述过程，不会显式将`mark`所继承原型链中的属性作为本地变量存放在mark对象，获取属性值时，javascript首先检查对象本身是否存在该属性值；如果有，则返回该值；如果不存在，则会通过`__proto__`对原型链进行检查。如果原型链中包含该属性值，则返回这个值；如果没有找到该属性，就认为对象中不存在该属性；因此，mark对象中的属性打印如下：

```javascript
mark.name = '';
mark.dept = 'general';
mark.projects = [];
```

构造函数当中的属性值，是WorkerBee中所有对象所共享的默认值，但可以通过mark来修改这些属性：

```javascript
mark.name = 'Doe, Mark';
mark.dept = 'admin';
mark.projects = ['navigator'];
```

#### Adding properties

JavaScript可以在运行时为任意对象添加属性，而不必受限于构造器函数提供的属性。

```javascript
mark.bonus = 3000;
```

> 这样对象mark就拥有了bonus属性，而其它WorkerBee则不具备该属性。

如果向构造器函数的原型对象添加属性，那么该属性将添加到从该原型中继承属性的所有对象当中。

```javascript
Employee.prototype.specialty = "none";
```

> 执行上面语句后，mark对象将会拥有`specialty`属性，其值为`"none"`。

下图展示了在`Employee`原型中添加该属性，然后在`Engineer`原型中重载该属性的效果。

![](javascript/05.figure8.4.png)

### More flexible constructors

我们可以通过为构造函数传入参数，来创建具有指定属性值的实例。

![](javascript/05.figure8.5.png)

接下来的代码用Java和Javascript分别描述了上面图表中对象的定义。

```java
// Java
public class Employee {
   public String name;
   public String dept;
   public Employee () {
      this("", "general");
   }
   public Employee (String name) {
      this(name, "general");
   }
   public Employee (String name, String dept) {
      this.name = name;
      this.dept = dept;
   }
}
```

```javascript
// Javascript
function Employee(name, dept) {
  this.name = name || '';
  this.dept = dept || 'general';
}
```

```java
// Java
public class WorkerBee extends Employee {
   public String[] projects;
   public WorkerBee () {
      this(new String[0]);
   }
   public WorkerBee (String[] projs) {
      projects = projs;
   }
}
```

```javascript
// Javascript
function WorkerBee(projs) {
   this.projects = projs || [];
}
WorkerBee.prototype = new Employee;
```

```java
// Java
public class Engineer extends WorkerBee {
   public String machine;
   public Engineer () {
      dept = "engineering";
      machine = "";
   }
   public Engineer (String mach) {
      dept = "engineering";
      machine = mach;
   }
}
```

```javascript
// Javascript
function Engineer(mach) {
   this.dept = 'engineering';
   this.machine = mach || '';
}
Engineer.prototype = new WorkerBee;
```

> 上述代码中，使用了JavaScript设置默认值的习惯性用法，通过逻辑或操作符`||`对第1个参数进行布尔运算，如果结果为真，则操作符返回该值，否则操作符返回第2个参数的值。

```javascript
this.name = name || "";
```

运行上述代码之后，可以通过如下语句创建新的`Engineer`：

```javascript
var jane = new Engineer("belau");
```

此时，`Jane`的属性如下所示：

```javascript
jane.name == "";
jane.dept == "engineering";
jane.projects == [];
jane.machine == "belau"
```

到目前为止，构造函数已经能够创建一个普通对象，然后为新对象指定本地的属性和属性值。接下来，还可以直接调用原型链上更高层次对象的构造函数，从而添加更多的属性。

![](javascript/05.figure8.6.png)

下面代码是`Engineer`构造器的定义：

```javascript
function Engineer (name, projs, mach) {
  this.base = WorkerBee;
  this.base(name, "engineering", projs);
  this.machine = mach || "";
}
```

如下所示，创建一个新的`Engineer`对象：

```javascript
var jane = new Engineer("Doe, Jane", ["navigator", "javascript"], "belau");
```

上面代码执行时会经历如下步骤：

1. `new`操作符创建了1个新的通用对象，并将其`__proto__`属性设置为`Engineer.prototype`。
2. `new`操作符将该新对象作为`this`的值传递给`Engineer`构造器。
3. 构造器为该新对象创建1个名为`base`的新属性，并指向`WorkerBee`的构造器，从而让`WorkerBee`构造器成为`Engineer`对象的1个方法。
4. 构造器调用`base`方法，并将传递给该构造器参数中的2个再传递给`base`方法，同时还传递1个字符串参数`"engineering"`。通过显式在构造器中使用`"engineering"`表明所有Engineer对象继承的`dept属性`具有相同值，且该值重载了继承自`Employee`的值。
5. 因为`base`是`Engineer`的1个方法，在调用`base`时，JavaScript会将在步骤1中创建的对象绑定给`this`关键字。这样，`WorkerBee`函数接着将`"Doe, Jane"`和`"engineering"`参数传递给`Employee`构造器函数。当从`Employee`构造器函数返回时，`WorkerBee`函数用剩下的参数设置`projects`属性。
6. 当从`base`方法返回后，`Engineer`构造器将对象的`machine`属性初始化为`"belau"`。
7. 当从构造器返回时，JavaScript会将新对象赋值给`jane`变量。

在`Engineer`构造器中调用`WorkerBee`构造器，并不会为`Engineer`对象设置好继承关系，因为调用`WorkerBee`构造器只会确保`Engineer`对象以所有在构造器中所指定的属性被调用。如果后续在`Employee`或者`WorkerBee`原型中添加了属性，这些属性将不会被`Engineer`对象继承。

例如下面的例子：

```javascript
function Engineer(name, projs, mach) {
  this.base = WorkerBee;
  this.base(name, 'engineering', projs);
  this.machine = mach || '';
}
var jane = new Engineer('Doe, Jane', ['navigator', 'javascript'], 'belau');
Employee.prototype.specialty = 'none';
```

上面代码中，对象`jane`不会继承`specialty`属性，必须显式设置原型才能确保动态的继承。

修改成下面语句，即可使`jane`对象的`specialty`属性为*none*。

```javascript
function Engineer(name, projs, mach) {
  this.base = WorkerBee;
  this.base(name, 'engineering', projs);
  this.machine = mach || '';
}
Engineer.prototype = new WorkerBee;
var jane = new Engineer('Doe, Jane', ['navigator', 'javascript'], 'belau');
Employee.prototype.specialty = 'none';
```

继承的另一种实现途径是使用`call()`或`apply()`方法，下面两段代码的实现方式是等价的：

```javascript
function Engineer(name, projs, mach) {
  WorkerBee.call(this, name, 'engineering', projs);
  this.machine = mach || '';
}
```

```javascript
function Engineer(name, projs, mach) {
  this.base = WorkerBee;
  this.base(name, 'engineering', projs);
  this.machine = mach || '';
}
```

> 因为不再需要再使用base，所以调用call()的方式更简单明了。


### Property inheritance revisited

前面小节描述了JavaScript构造器和原型如何提供层级结构和继承的实现，接下来讨论更进一步的细节。

#### Local versus inherited values

正如本章前面所述，在访问一个对象的属性时，JavaScript 将执行下面的步骤：

- 1、检查本地值是否存在。如果存在返回该值。
- 2、如果本地值不存在，检查原型链(通过`__proto__`属性)。
- 3、如果原型链中某个对象具有指定属性的值，则返回该值。
- 4、如果这样的属性不存在，则对象不具有该属性。

以上步骤的结果依赖于定义对象的方式，看下面这个例子：

```javascript
function Employee () {
  this.name = "";
  this.dept = "general";
}

function WorkerBee () {
  this.projects = [];
}

WorkerBee.prototype = new Employee;
```

基于这些定义，假定通过如下语句创建`WorkerBee`的实例`amy`：

```javascript
var amy = new WorkerBee;
```

则`amy`对象将具有一个本地属性`projects`，而`name`和`dept`属性则是从`__proto__`属性获得的，因此`amy`对象具有的属性值如下：

```javascript
amy.name == "";
amy.dept == "general";
amy.projects == [];
```

现在，假设修改了与Employee相关联原型中的name属性的值：

```javascript
Employee.prototype.name = "Unknown"
```

此时，新的值并不会传播给所有`Employee`实例。

在创建`Employee`对象的任意实例时，该实例的`name`属性将获得一个本地值(*空字符串*)。这意味着在创建一个新的`Employee`对象作为`WorkerBee`的原型时，`WorkerBee.prototype`的`name`属性将具有一个本地值。因此，当JavaScript查找`amy`对象(*WorkerBee的实例*)的`name`属性时，JavaScript将找到`WorkerBee.prototype`中的本地值。因此，也就不会继续在原型链中向上找到`Employee.prototype`了。

如果需要在运行时修改一个对象的属性值，并且希望该值被所有该对象的后代继承，就不能在该对象的构造器函数中定义该属性。而应该将该属性添加到该对象所关联的原型中。

将前面的代码作如下修改：

```javascript
function Employee () {
  this.dept = "general";
}
Employee.prototype.name = "";

function WorkerBee () {
  this.projects = [];
}
WorkerBee.prototype = new Employee;

var amy = new WorkerBee;

Employee.prototype.name = "Unknown";
```

在这种情况下，`amy`的`name`属性将为`"Unknown"`。

> 如果希望对象的属性具有默认值，并且希望在运行时修改这些默认值，则应该在对象的原型中设置这些属性，而非是在构造器函数中。

#### Determining instance relationships

JavaScript的属性查找机制首先在对象自身的属性中查找，如果指定的属性名称没有找到，将在对象的特殊属性`__proto__`中查找。这个过程被称为**在原型链中查找**。

对象的`__proto__`属性是在构建对象时设置的，用来保存`prototype`属性的值。所以表达式`new Foo()`将创建一个对象，其`__proto__ == Foo.prototype`。所以修改`Foo.prototype`的属性，就会改变所有通过`new Foo()`所创建的对象属性。

有了**原型继承prototype inheritance**的存在，就可以通过比较对象的`__proto__`或`prototype`属性检测其继承关系。为此，JavaScript提供了`instanceof`操作符，如果对象继承自函数的原型，则该操作符返回`true`。

```javascript
var f = new Foo();
var isTrue = (f instanceof Foo);
```

更详细一点的例子，通过下面方式创建`Engineer`对象：

```javascript
var chris = new Engineer("Pigman, Chris", ["jsd"], "fiji");
```

对于上面的`chris`对象，以下所有语句结果均为`true`：

```javascript
chris.__proto__ == Engineer.prototype;
chris.__proto__.__proto__ == WorkerBee.prototype;
chris.__proto__.__proto__.__proto__ == Employee.prototype;
chris.__proto__.__proto__.__proto__.__proto__ == Object.prototype;
chris.__proto__.__proto__.__proto__.__proto__.__proto__ == null;
```

基于此，可以编写一个自定义的`instanceOf`函数：

```javascript
function instanceOf(object, constructor) {
   while (object != null) {
      if (object == constructor.prototype)
         return true;
      if (typeof object == "xml") {
        return constructor.prototype == XML.prototype;
      }
      object = object.__proto__;
   }
   return false;
}

instanceOf (chris, Engineer)  // true
instanceOf (chris, WorkerBee)  // true
instanceOf (chris, Employee) // true
instanceOf (chris, Object) // true
instanceOf (chris, SalesPerson) // false
```

> 上面的实现中，检查对象类型是否为"xml"的目的在于解决新近版本JavaScript中表达XML对象的特异之处。

#### Global information in constructors

在创建构造器时设置全局信息需要注意，例如：希望为每位雇员分配1个唯一标识，可能会按如下方式定义`Employee`：

```javascript
var idCounter = 1;

function Employee (name, dept) {
   this.name = name || "";
   this.dept = dept || "general";
   this.id = idCounter++;
}
```

基于该定义，在创建新的`Employee`时，构造器为其分配了序列中的下一个标识符，然后递增全局的标识符计数器。因此，如果随后的语句如下，则`victoria.id`为`1`而`harry.id`为`2`：

```javascript
var victoria = new Employee("Pigbert, Victoria", "pubs")
var harry = new Employee("Tschopik, Harry", "sales")
```

但是问题在于，每一次创建`Employee`对象时，`idCounter`都将被递增一次。如果创建本章中所描述的整个`Employee`层级结构，则每次设置原型时，`Employee`构造器都将会被调用一次。

```javascript
var idCounter = 1;

function Employee (name, dept) {
   this.name = name || "";
   this.dept = dept || "general";
   this.id = idCounter++;
}

function Manager (name, dept, reports) {...}
Manager.prototype = new Employee;

function WorkerBee (name, dept, projs) {...}
WorkerBee.prototype = new Employee;

function Engineer (name, projs, mach) {...}
Engineer.prototype = new WorkerBee;

function SalesPerson (name, projs, quota) {...}
SalesPerson.prototype = new WorkerBee;

var mac = new Engineer("Wood, Mac");
```

假设上面省略掉的函数定义中包含`base`属性，这种情况下`mac`对象创建时`mac.id`的值会为`5`，计数器存在额外递增的问题。

如果需要准确的计数器，可以使用下面的方案：

```javascript
function Employee (name, dept) {
   this.name = name || "";
   this.dept = dept || "general";
   if (name)
      this.id = idCounter++;
}
```

当作为原型创建新的`Employee`实例时并不会指定参数，如果不指定参数，则`name`属性值为空字符串，则接下来的`if`语句中将不会递增计数器。

#### No multiple inheritance

某些面向对象语言可以支持多重继承，即对象可以从多个父对象中继承属性，但是**JavaScript不支持多重继承**。

JavaScript属性的继承是在运行时通过检索对象的原型链来实现的，因为一个对象只拥有一个与之关联的原型，所以JavaScript无法动态的从多个原型链中继承。

JavaScript中，可以在构造器函数中调用多个其它的构造器函数，从而模拟出多重继承的假象。

```javascript
function Hobbyist (hobby) {
   this.hobby = hobby || "scuba";
}

function Engineer (name, projs, mach, hobby) {
   this.base1 = WorkerBee;
   this.base1(name, "engineering", projs);
   this.base2 = Hobbyist;
   this.base2(hobby);
   this.machine = mach || "";
}
Engineer.prototype = new WorkerBee;

var dennis = new Engineer("Doe, Dennis", ["collabra"], "hugo")
```

假设使用本章前面的`WorkerBee`的定义，此时`dennis`对象将会具有如下属性：

```javascript
dennis.name == "Doe, Dennis"
dennis.dept == "engineering"
dennis.projects == ["collabra"]
dennis.machine == "hugo"
dennis.hobby == "scuba"
```

`dennis`确实从`Hobbyist`构造器中获得了`hobby`属性，但如果添加一个新的属性到`Hobbyist`构造器的原型，则`dennis`对象并不会继承该属性。

```javascript
Hobbyist.prototype.equipment = ["mask", "fins", "regulator", "bcd"]
```


## Control flow and error handling

JavaScript中任何表达式(*expression*)都可以看作一条语句(*statement*)，每条语句可以使用分号(*;*)来分隔。可以在每行书写一条语句，也可以在一行书写多条语句，推荐采用第1种方式，以便于代码维护。

### Block statement

通过一对花括号`{}`来分组语句块。

```javascript
{
  statement_1;
  statement_2;
  .
  .
  .
  statement_n;
}
```

在ES6之前，Javascript没有块作用域，如果在块的外部声明一个变量，然后在块中声明了一个相同变量名的变量，并赋予不同的值，那么程序执行中将会使用块中的值，这样做在Javascript中是合法的。

```javascript
var x = 1;
{
  var x = 2;
}
console.log(x); // outputs 2
```

> 从ECMAScript 2015开始，使用`let`定义的变量是块作用域的。

### Conditional statements

条件判断语句，根据指定的条件返回的结果(`true`或`false`)来执行特定的语句。
JavaScript提供了2种条件判断语句：`if...else`和`switch`。

#### if...else

当逻辑条件为`true`时，执行`if`后面的语句，为假时则执行`else`后面的语句。

```
if (condition_1) {
  statement_1;
}
[else if (condition_2) {
  statement_2;
}]
...
[else if (condition_n_1) {
  statement_n_1;
}]
[else {
  statement_n;
}]
```

如果需要在条件表达式当中赋值，需要在赋值语句前后额外添加一对括号：

```javascript
if ((x = y)) {
  /* do the right thing */
}
```

Javascript当中`false`、`undefined`、`null`、`0`、`空字符串""`、`NaN`会被渲染为`false`值。

> 需要注意区分原始数据类型的true和false与Boolean对象的true和false值。

```javascript
var b = new Boolean(false);
if (b) // this condition evaluates to true
if (b == true) // this condition evaluates to false
```

> 可以在if...else...语句中使用多个return语句。

```javascript
function checkData() {
  if (document.form1.threeChar.value.length == 3) {
    return true;
  } else {
    alert('Enter exactly three characters. ' +
    document.form1.threeChar.value + ' is not valid.');
    return false;
  }
}
```

#### switch statement

switch语句渲染表达式的值，然后尝试匹配后续的case，匹配成功则执行相应语句。

```javascript
switch (expression) {
  case label_1:
    statements_1
    [break;]
  case label_2:
    statements_2
    [break;]
    ...
  default:
    statements_def
    [break;]
}
```

```javascript
switch (fruittype) {
  case 'Oranges':
    console.log('Oranges are $0.59 a pound.');
    break;
  case 'Apples':
    console.log('Apples are $0.32 a pound.');
    break;
  case 'Bananas':
    console.log('Bananas are $0.48 a pound.');
    break;
  case 'Cherries':
    console.log('Cherries are $3.00 a pound.');
    break;
  case 'Mangoes':
    console.log('Mangoes are $0.56 a pound.');
    break;
  case 'Papayas':
    console.log('Mangoes and papayas are $2.79 a pound.');
    break;
  default:
   console.log('Sorry, we are out of ' + fruittype + '.');
}
console.log("Is there anything else you'd like?");
```

### Exception handling statements

可以使用`throw`语句抛出异常，并且通过`try...catch`语句进行捕获和处理。

#### Exception types

JavaScript异常处理可以抛出任意对象、数值或字母串作为错误信息，但是使用ECMAScript exceptions、DOMException、DOMError等内置的异常类型将会更加有效。


#### throw statement

throw语句用来抛出1个异常，抛出异常时一个含有值的表达式将会被抛出。

```javascript
throw "Error2";   // String type
throw 42;         // Number type
throw true;       // Boolean type
throw {toString: function() { return "I'm an object!"; } };
```

> 可以在抛出异常时声明一个对象，这样可以在catch块中获取到对象属性。

```javascript
// Create an object type UserException
function UserException(message) {
  this.message = message;
  this.name = 'UserException';
}

// Make the exception convert to a pretty string when used as a string 
// (e.g. by the error console)
UserException.prototype.toString = function() {
  return this.name + ': "' + this.message + '"';
}

// Create an instance of the object type and throw it
throw new UserException('Value too high');
```

#### try...catch statement

如果`try代码块`中的语句throw出异常，那么执行流程会立即进入`catch代码块`。如果`try代码块`没有抛出异常，`catch代码块`就会被跳过，而`finally代码块`总会紧跟在`try和catch代码块`之后执行。

下面例子调用了一个根据参数值来获取月份英文名称的函数，如果传递值与月份数值不相符，则会抛出一个`"InvalidMonthNo"`异常，并在catch块中设置`monthName`变量为`unknown`。

```javascript
function getMonthName(mo) {
  mo = mo - 1; // Adjust month number for array index (1 = Jan, 12 = Dec)
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  if (months[mo]) {
    return months[mo];
  } else {
    throw 'InvalidMonthNo'; //throw keyword is used here
  }
}

try { // statements to try
  monthName = getMonthName(myMonth); // function could throw exception
}
catch (e) {
  monthName = 'unknown';
  logMyErrors(e); // pass exception object to error handler -> your own function
}
```

##### The catch block

catch代码块用来处理try代码块中产生的异常，catch代码块通过参数`catchID`存放throw语句抛出的值，可以通过该参数获取到抛出的异常信息。

> 下面例子中的catch代码块将会被立即执行，从而打印出try块中抛出的myException异常信息。

```javascript
try {
  throw 'myException'; // generates an exception
}
catch (e) {
  // statements to handle any exceptions
  logMyErrors(e); // pass exception object to error handler
}
```

##### The finally block

finally代码块无论是否抛出异常都会被执行(*即使没有catch代码块，finally代码块的语句最终也会被执行*)。

下面例子用服务器端Javascript打开一个文件，如果文件打开时抛出一个异常，finally会在脚本错误之前关闭文件。

```javascript
openMyFile();
try {
  writeMyFile(theData); //This may throw a error
} catch(e) {  
  handleError(e); // If we got a error we handle it
} finally {
  closeMyFile(); // always close the resource
}
```

> Javascript异常处理按照try -> catch -> finally的顺序执行。

如果finally代码块return一个返回值，那么该返回值将会是整个**try-catch-finally**流程的返回值，不管之前在try和catch代码块中return了什么返回值。

```javascript
function f() {
  try {
    console.log(0);
    throw 'bogus';
  } catch(e) {
    console.log(1);
    return true; // this return statement is suspended
                 // until finally block has completed
    console.log(2); // not reachable
  } finally {
    console.log(3);
    return false; // overwrites the previous "return"
    console.log(4); // not reachable
  }
  // "return false" is executed now  
  console.log(5); // not reachable
}
f(); // console 0, 1, 3; returns false
```

通过finally代码块重写返回值的场景，同样适用于抛出异常或在catch代码块中重新抛出异常的场景。

```javascript
function f() {
  try {
    throw 'bogus';
  } catch(e) {
    console.log('caught inner "bogus"');
    throw e; // this throw statement is suspended until 
             // finally block has completed
  } finally {
    return false; // overwrites the previous "throw"
  }
  // "return false" is executed now
}

try {
  f();
} catch(e) {
  // this is never reached because the throw inside
  // the catch is overwritten
  // by the return in finally
  console.log('caught outer "bogus"');
}

// OUTPUT
// caught inner "bogus" 
```

##### Nesting try...catch statements

可以嵌套一个或多个`try...catch`语句，如果一个内部的`try...catch`语句没有`catch`代码块，它将会自动匹配外部`try...catch`语句的`catch`代码块。

#### Utilizing Error objects

根据错误类型，可以用考虑使用内置对象Error的`name`和`message`属性，从而获取更简练的信息，其中`name`提供了常规的错误类(例如`DOMException`或`Error`)，而`message`提供了一条从错误对象转换成字符串的简明信息。

```javascript
function doSomethingErrorProne() {
  if (ourCodeMakesAMistake()) {
    throw (new Error('The message'));
  } else {
    doSomethingToGetAJavascriptError();
  }
}
....
try {
  doSomethingErrorProne();
} catch (e) {
  console.log(e.name); // logs 'Error'
  console.log(e.message); // logs 'The message' or a JavaScript error message)
}
```

### Promises

ES6增加了对Promise对象的支持，允许对异步的操作流进行控制，Promise对象有以下几种状态:

* 1、pending(*进行中*): 初始的状态，即正在执行，不处于 fulfilled 或 rejected 状态。
* 2、fulfilled(*已完成*): 成功的完成了操作。
* 3、rejected(*已失败*): 失败，没有完成操作。
* 4、settled(*已解决*): Promise 处于 fulfilled 或 rejected 二者中的任意一个状态, 不会是 pending。

![](javascript/06.promises.png)

下面例子使用了Promise和XMLHttpRequest来加载一张图片：

```javascript
function imgLoad(url) {
  return new Promise(function(resolve, reject) {
    var request = new XMLHttpRequest();
    request.open('GET', url);
    request.responseType = 'blob';
    request.onload = function() {
      if (request.status === 200) {
        resolve(request.response);
      } else {
        reject(Error('Image didn\'t load successfully; error code:' 
                     + request.statusText));
      }
    };
    request.onerror = function() {
      reject(Error('There was a network error.'));
    };
    request.send();
  });
}
```


## Loops and iteration

本章节介绍Javascript中的迭代循环语句。

### for statement

for循环会一直重复执行，直到指定的循环条件为fasle。

```
for ([initialExpression]; [condition]; [incrementExpression])
  statement
```

- 1、如果存在初始化表达式`initialExpression`，它将被执行，该表达式主要用于初始化一个或多个循环计数器，也可以声明变量。
- 2、计算`condition`表达式的值，如果值是`true`，循环内的`statement`会被执行。如果是`false`，for循环终止。如果该表达式被省略，则`condition`的值被认为是true。
- 3、循环内的`statement`被执行，如果需要执行多条语句，可以使用代码块`{...}`进行包裹。
- 4、如果有更新表达式`incrementExpression`，执行它，然后流程回至步骤2。

下面例子中，函数`howMany`使用for循环去计算一个滑动列表中被选中项目的个数(*1个`<select>`允许选择多项*)。

```javascript
<form name="selectForm">
  <p>
    <label for="musicTypes">Choose some music types, then click the button below:</label>
    <select id="musicTypes" name="musicTypes" multiple="multiple">
      <option selected="selected">R&B</option>
      <option>Jazz</option>
      <option>Blues</option>
      <option>New Age</option>
      <option>Classical</option>
      <option>Opera</option>
    </select>
  </p>
  <p><input id="btn" type="button" value="How many are selected?" /></p>
</form>

<script>
function howMany(selectObject) {
  var numberSelected = 0;
  for (var i = 0; i < selectObject.options.length; i++) {
    if (selectObject.options[i].selected) {
      numberSelected++;
    }
  }
  return numberSelected;
}

var btn = document.getElementById('btn');
btn.addEventListener('click', function() {
  alert('Number of options selected: ' + howMany(document.selectForm.musicTypes));
});
</script>
```

### do...while statement

`do...while`语句一直重复执行，直到指定的条件值为`false`。

```javascript
do
  statement
while (condition);
```

- 1、`statement`在`condition`执行之前会先执行一次，如果`condition`为`true`，`statement`将再次执行，每个执行的结尾会再次执行`condition`进行检查。
- 2、当`condition`为`false`，执行会停止并将控制权交给do...while后续的语句。

下面例子中，循环将至少重复1次直到`i`不再小于`5`。

```javascript
var i = 0;
do {
  i += 1;
  console.log(i);
} while (i < 5);
```

### while statement

while语句只要指定的条件求值为`true`，就会一直执行。

```
while (condition)
  statement
```

`condition`检测会在每次`statement`执行前发生，如果条件返回为真，`statement`会被执行并紧接着再次测试条件。如果条件返回为假，执行将停止并把控制权交回给`while`后面的语句。

下面例子中的while循环只要`n`小于`3`就会被一直执行：

```javascript
var n = 0;
var x = 0;
while (n < 3) {
  n++;
  x += n;
}
```

在每次循环里，`n`会增加1并被加到`x`上。所以，`x`和`n`的变化是：

- 第一次完成后： n = 1 和 x = 1
- 第二次完成后： n = 2 和 x = 3
- 第三次完成后： n = 3 和 x = 6

在三次完成后， 条件`n<3`结果不再为真，所以循环终止了。















