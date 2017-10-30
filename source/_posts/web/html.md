---
title: HTML5语义化标签概览
tags: HTML
categories: Web
---

Web语义化（*Semantic Web*）是指使用合理的HTML元素去格式化书写页面内容，有利于计算机进行解析，方便PDA、文字浏览器、残障人士进行阅读，更加有利于搜索引擎和爬虫进行SEO索引。本篇文章翻译自Mozilla的官方文档[HTML Reference](https://developer.mozilla.org/en-US/docs/Web/HTML/Element)，包含了**HTML5**新增的标签元素，方便大家快速的定位自己所需的HTML标签，书写更加优雅的语义化DOM结构。本文内所涉及的HTML元素都经过[Can I use](https://caniuse.com)进行了兼容性校对，在标注各元素当前兼容性状态的同时，也提供了Mozilla和W3C推荐的标准Demo用例，便于大家快速开发格式良好的Web页面。

![](html/logo.png)

<!-- more -->

## 根级元素

| 元素 | 语义 |
|:-----|:-----|
| `<html>` | 一个HTML文档的根元素，所有其它HTML元素必须是其后代。 |
| `<head>`  | 定义文档相关的元数据信息，包括标题、样式、脚本等。 |
| `<body>` | 展现HTML文档的内容区域，一个文档只能拥有一个`<body>`元素。 |

```html
<!DOCTYPE html>
<html lang='zh-CN'>
  <head></head>
  <body></body>
</html>
```


## 元数据

包含页面相关的信息，可以辅助搜索引擎和浏览器引用或渲染页面。

| 元素 | 语义 |
|:-----|:-----|
| `<base>`  | 指定文档中所有URL的基地址，一份文档只能拥有一个`<base>`元素。 |
| `<link>`  | 指定外部资源与文档的关系，可以为导航定义关系框架，但通常用来链接CSS文件。 |
| `<meta>`  | 表达那些不能由其它元数据标签表达的信息。 |
| `<style>` | 包含文档的CSS样式信息。 |
| `<title>` | 定义文档的标题，显示在浏览器的标题栏或标签页上。 |

```html
<title>Title</title>
<meta name='renderer' content='webkit' />
<meta http-equiv='X-UA-Compatible' content='IE=edge' />
<meta http-equiv='content-type' content='text/html; charset=UTF-8' />
<meta name='viewport' content='width=device-width, initial-scale=1' />

<base target="_blank" href="https://www.w3.org/">
<link href='../styles/base.css' rel='stylesheet' type='text/css' />
```


## 内容分区

块级元素，用来将文档内容进行逻辑上的组织与划分，为页面内容创建清晰明确的大纲与分区。除`<address>`外，其它元素都已经获得当前主流浏览器的支持。

| 元素 | 语义 |
|:-----|:-----|
| `<nav>`     | 描述含有多个超级链接、链接列表的区域。 |
| `<article>` | 表示页面当中的独立结构，即可独立分配和复用的结构。可以是文章、用户评论、交互式组件等独立的项目内容。 |
| `<section>` | 表示HTML文档中的一个独立的功能性章节，该元素内通常会包含`<h1>-<h6>`子节点，可以通过`<article>`组合多个`<section>`的内容。 |
| `<aside>`   | 表达一个与其它页面内容无关的独立部分，可以被单独拆分且不会影响整体。通常表现为侧边栏、嵌入内容、广告、web应用程序、个人资料信息、博客链接等。 |
| `<footer>`  | 表示最近的章节内容、根节点元素的页脚，通常包含有作者、版权、文档相关链接等信息。 |
| `<h1–h6>`   | 用来体现**6**个层级的段落标题，其中`<h1>`级别最高，`<h6>`级别最低，|
| `<header>`  | 一组介绍性信息，可能包含标题元素，也可以包含logo、搜索表单等信息。 |
| `<hgroup>`  | 代表一个文档片段的多层次标题信息，即对`<h1>`-`<h6>`进行分组。 |
| `<address>` | 为距离该标签最近的`<article>`或`<body>`祖先元素提供联系信息，*IE和Edge暂未提供支持*。 |

```html
<nav>
  <ul>
    <li><a href='#'>Home</a></li>
    <li><a href='#'>About</a></li>
    <li><a href='#'>Contact</a></li>
  </ul>
</nav>

<address>
  You can contact author at <a href='https://uinika.github.io/'>Hank</a>.
</address>

<article>
  <header>
    <h1>Heading</h1>
  </header>
  <section>
    <p>Paragraph</p>
  </section>
  <footer>
    <p>Paragraph</p>
  </footer>
  <aside>
    <p>Paragraph</p>
  </aside>
</article>

<hgroup>
  <h1>Heading level 1</h1>
  <h2>Heading level 2</h2>
  <h3>Heading level 3</h3>
  <h4>Heading level 4</h4>
  <h5>Heading level 5</h5>
  <h6>Heading level 6</h6>
</hgroup>
```

![](html/content-partition.png '内容分区Demo')


## 文本内容

块级元素，用来组织`<body>`标签内区块、章节的内容，并标识出这些内容的宗旨与结构，这对于**可访问性**（*accessibility*）和**搜索引擎优化**（*SEO*）非常重要。

| 元素 | 语义 |
|:-----|:-----|
| `<dl>`         | 定义一个描述性的列表，通常用于展示词汇表、元数据、键值对列表。 |
| `<dd>`         | 代表描述性列表`<dl>`当中的1项描述，该元素只能作为`<dt>`的子元素出现。 |
| `<dt>`         | 代表描述性列表`<dl>`当中的1个术语，该元素只能作为`<dt>`子元素出现，该元素后面通常会跟随`<dd>`，多个连续出现的`<dt>`由出现在其后面的第1个`<dd>`定义。 |
| `<div>`        | 通用的文档流内容容器，语义上不代表任何特定类型内容，可以用来对其它元素进行分组，一般用于样式化相关的需求，只出现没有其它语义元素可用的场景下 。 |
| `<figure>`     | 一段独立的内容，通常需要嵌套`<figcaption>`使用，用于对引用的插图、表格、代码段进行说明。 |
| `<figcaption>` | 用于在`<figure>`元素内添加插图、表格、代码段的说明信息 |
| `<hr>`         | 表示两个段落元素之间的主题转折，通常被渲染为一条水平线。 |
| `<li>`         | 表示列表里的条目，可以被包含在`<ol>`、`<ul>`、`<menu>`内部。 |
| `<ul>`         | 表示无序列表，即列表中项目的顺序是无意义的。 |
| `<ol>`         | 表示有序列表，渲染结果会带有序数编号。 |
| `<main>`       | 用于呈现文档`<body>`中的主体内容，一个文档只能使用一个`<main>`元素，且不应该放置主体内容之外的侧边栏、导航栏、搜索栏、版权信息、网站logo等信息。</main> |
| `<p>`          | 表示一个文本段落，是一个典型的块级元素。 |
| `<pre>`        | 表示预定义格式文本，该元素中的文本会按照原文件中的格式编排，文本中的*空格*和*换行*都会原样呈现出来。 |
| `<blockquote>` | 表达HTML元素的引用内容，渲染时会有缩进。引用来源可以通过该元素的`cite`属性进行标注`<blockquote cite='https://uinika.github.io/'>`；如果要以文本形式体现引文出处，则可以直接通过`<cite>`元素。 |

```html
<blockquote cite='https://developer.mozilla.org/en-US/docs/Web/HTML/Element'>
  <p>This is a block quotation.</p>
</blockquote>

<div>Division [dɪˈvɪʒən] n. 分开，分隔</div>

<dl>
  <dt>Firefox</dt>
  <dd>A open source web browser.</dd>
  <!-- Other terms and descriptions -->
</dl>

<figure>
  <img src='https://www.w3.org/2008/site/images/logo-w3c-screen-lg' alt='logo'>
  <figcaption>W3C Logo</figcaption>
</figure>

<hr>

<ol>
  <li>item1</li>
  <li>item2</li>
  <li>item3</li>
</ol>

<ul>
  <li>item</li>
  <li>item</li>
  <li>item</li>
</ul>

<main>
  <h1>Heading</h1>
  <p>Paragraph</p>

  <article>
    <p>Paragraph</p>
  </article>
</main>

<pre>
  body {
    color:red;
  }
</pre>
```

![](html/text-content.png '文本内容Demo')


## 内联文本

行内元素，用来定义字词、文本行片段等内联元素的语义和结构。

| 元素 | 语义 |
|:-----|:-----|
| `<a>`      | 用于创建指向其它地址链接、锚元素。 |
| `<abbr>`   | 表示缩写，但是可以通过`title`属性提供完整的描述。 |
| `<b>`      | 加粗文本，体现与普通文本的区别，但并不表示**强调**，可以用来标注文章中的引言。 |
| `<bdi>`    | 使文本脱离其父元素的文本方向设置，*仅Chrome和Firefox支持，但测试未体现效果*。 |
| `<bdo>`    | 按照`dir`属性改变**文字**的输出方向。 |
| `<br>`     | 在文本中产生一个换行效果。 |
| `<cite>`   | 表示文档中引用的内容。 |
| `<code>`   | 呈现一段计算机代码，默认显示为等宽字体。 |
| `<data>`   | 将指定内容与机器可读的翻译连接起来，如果与日期和时间相关，则必须使用`<time>`元素，*仅IE和Safari不支持该元素* |
| `<dfn>`    | 表示一个术语或者条款的定义。 |
| `<em>`     | 标记出需要用户重点阅读的内容，可以嵌套使用，嵌套层级越深表示内容更加重点。 |
| `<i>`      | 斜体显示文本，用来与其它文本内容进行区分，*包括IE和Edge都不支持该元素，其它浏览器正常支持*。 |
| `<kbd>`    | 表示用户输入，它将产生一个行内元素，会以浏览器默认的*monospace*字体显示。 |
| `<mark>`   | 需要进行突出显示的文字，例如显示搜索引擎的关键词。*caniuse中未找到该元素的兼容性信息，但是mozilla文档认为其兼容Opera外的所有浏览器*。 |
| `<q>`      | 表示**行内**的引用文本，同样拥有一个`cite`属性，如果是**块级**的文本引用则需要使用`<blockquote>`替代。 |
| `<rp>`     | 定义不支持ruby元素浏览器所要显示的内容，比如圆括号`()`，*caniuse中未找到该元素的兼容性信息，但是mozilla文档认为其兼容Opera外的所有浏览器*。 |
| `<rt>`     | 描述东亚字符的发音，主要放置在`<ruby>`元素中使用，*仅IE不支持该元素，但Edge支持*。 |
| `<rtc>`    | 描述东亚文字的语义，发音`<rt>`和语义`<rtc>`都主要放置在`<ruby>`元素中使用，*仅IE不支持该元素，但Edge支持*。 |
| `<ruby>`   | 用来添加东亚文字发音或语义，*所有浏览器都支持该元素*。 |
| `<s>`      | 使用删除线渲染文本，是已被废弃的`<strike>`标签的缩写版本，但是HTML4中就已经不提倡使用，而是以`<del>`来代替。 |
| `<samp>`   | 定义样本文本，用于提取内容并加以强调，通常使用浏览器默认的*mono*等宽字体。 |
| `<small>`  | 呈现小号字体效果，可嵌套递归使用，HTML5中，除了样式上的含义，该元素被重新定义为表示边注释和附属细则，包括版权和法律文本，*浏览器IE和Edge都不支持该元素，其它正常支持*。 |
| `<span>`   | 短语内容的通用行内容器，没有任何特殊语义，主要用来展现行内样式，`<span>`与`<div>`两者的作用相似，但是`<div>`是块元素`<span>`是行内元素。 |
| `<strong>` | 定义强调文本，一般会粗体显示。 |
| `<sub>`    | 定义下标文本，以当前文本流中字符高度的一半显示，*包括IE和Edge都不支持该元素，其它浏览器正常支持*。 |
| `<sup>`    | 定义上标文本，以当前文本流中字符高度的一半显示，*仅IE不支持该元素，但Edge支持* |
| `<time>`   | 表示24小时制时间或公历日期，该元素不会呈现任何特殊效果，*目前IE和Safari不支持该元素*。 |
| `<u>`      | 标识这里是一段下划线文本。 |
| `<var>`    | 表示这里是一个变量的内容，*仅IE不支持该元素*。 |
| `<wbr>`    | 设置英文单词中字母的换行时机（*Word Break Opportunity*），*仅IE不支持该元素*。 |

```html
<p dir="ltr">
  <bdi>right-to-left</bdi>
</p>

<p>
  <bdo dir="rtl">right-to-left</bdo>
</p>

<ul>
  <li>
    <data value="32">Hank</data>
  </li>
  <li>
    <data value="22">Uinika</data>
  </li>
</ul>

<p>
  Keyboard: <kbd>cmd</kbd> Run dialog                     <br>
  Keyboard: <kbd>Ctrl</kbd> + <kbd>S</kbd> Save document  <br>
</p>

<ruby>
  明日<rp>(</rp><rt>Ashita</rt><rp>)</rp>
</ruby>

<p>
  This article describes several <b class="keywords">text-level</b> elements.  <br>
  More information can be found in <cite>[ISO-0000]</cite>.                    <br>
  <dfn>The Internet</dfn> is a global system of interconnected networks.       <br>
  Declare a Javascript variable: <code>var i = 0;</code>.                      <br>
</p>

<p>
  <q cite="https://www.mozilla.org/">Mozilla</q>        <br>
  <a href="#attr-href">Description same-page link.</a>  <br>
  <abbr title="Internationalization">I18N</abbr>        <br>
  <span>span [spæn] n.跨度，范围</span>                  <br>
  <em>Emphasis</em> ['emfəsɪs] n.强调                   <br>
  <i>italic</i> [ɪˈtælɪk] n.斜体字                      <br>
  Mark <mark>highlight</mark> text.                     <br>
  It is a <samp>Sample</samp> text.                     <br>
  Text is <small>Small</small>.                         <br>
  Text is <strong>Strong</strong>.                      <br>
  <sub>Subscript</sub>                                  <br>
  <sup>Superscript</sup>                                <br>
  <time>22:05</time>                                    <br>
  <u>Underline text</u>                                 <br>
  <s>Strike is deprecated.</s>                          <br>
  A simple equation: <var>x</var> = <var>y</var> + 2    <br>
  This guy come from Eng<wbr>land.                      <br>
</p>
```

![](html/inline-text.png '内联文本Demo')


## 图片和多媒体

HTML提供的对图片、音频、视频的支持。

| 元素 | 语义 |
|:-----|:-----|
| `<area>`  | 在图片上定义一个热点区域。 |
| `<video>` | 向文档中嵌入视频内容。 |
| `<audio>` | 向文档中嵌入音频内容，资源可以通过`src`属性或`<source>`元素进行描述。 |
| `<img>`   | 描述文档中的一个图像。 |
| `<map>`   | 定义图片上可点击的链接区域，通常与`<area>`搭配使用。 |
| `<track>` | 用来指定计时字幕，需要作为媒体元素`<audio>`和`<video>`的子元素使用。 |

```html
<video src='foo.ogg'>
  <track kind='subtitles' src='foo.en.vtt' srclang='en' label='English'>
  <track kind='subtitles' src='foo.sv.vtt' srclang='cn' label='Chinese'>
</video>

<audio src='foo.ogg'>
  <track kind='captions' src='foo.en.vtt' srclang='en' label='English'>
  <track kind='captions' src='foo.sv.vtt' srclang='cn' label='Chinese'>
</audio>

<audio controls='controls'>
  <source src='foo.wav' type='audio/wav'>
</audio>

<map name='map-example'>
  <area shape='circle' coords='200,250,25' href='another.htm' />
  <area shape='default' />
</map>

<img src='logo.png' alt='logo'>
```


## 内嵌内容

HTML提供的常规多媒体之外的支持，但是这些支持并不容易交互。

| 元素 | 语义 |
|:-----|:-----|
| `<source>` | 用来定义`<picture>`、`<audio>`、`<video>`内的多媒体资源。 |
| `<embed>`  | 嵌入外部的交互式插件。 |
| `<object>` | 用于引入外部的插件资源。 |
| `<param>`  | 用来定义`<object>`的参数。 |

```html
<embed type='video/quicktime' src='movie.mov' width='250' height='220'>

<video controls>
  <source src='video.webm' type='video/webm'>
  <source src='video.ogg'  type='video/ogg'> 
  <source src='video.mov'  type='video/quicktime'>
</video>

<object data='move.swf' type='application/x-shockwave-flash'>
  <param name='foo' value='bar'>
</object>
```


## 脚本

提供脚本语言（*例如JavaScript*）支持的HTML标签。

| 元素 | 语义 |
|:-----|:-----|
| `<canvas>`   | 用来通过JavaScript脚本绘制位图，。 |
| `<noscript>` | 如果不支持页面上的脚本类型，或者浏览器关闭了脚本支持，该元素定义了需要显示在html上的内容。 |
| `<script>`   | 用于嵌入或引用可执行脚本。 |

```html
<canvas id='bitmap'></canvas>

<script>
var canvas=document.getElementById('bitmap');
var ctx=canvas.getContext('2d');
ctx.fillStyle='#FF0000';
ctx.fillRect(8, 8, 100, 50);
</script>
```

![](html/canvas.png 'Canvas位图绘制Demo')


## 编辑标识

两个HTML元素配合起来使用，用以标记文档中的更新与修正。

| 元素 | 语义 |
|:-----|:-----|
| `<del>` | 表示已经从文档中删除的文本，会渲染删除线。 |
| `<ins>` | 定义插入到文档中的文本。 |

```html
<!-- del内的错误文字应该被ins内的正确文字修正-->
This is <del>delete</del> <ins>insert</ins> operation.
```

![](html/ins-del.png '编辑标识Demo')


## 表格内容

用于创建和展示表格。

| 元素 | 语义 |
|:-----|:-----|
| `<table>`    | 展现表格化数据，是所有表格相关元素的父元素。 |
| `<caption>`  | 表格的标题，常作为`<table>`的第1个子元素出现，并显示在表格内容的最前面。 |
| `<colgroup>` | 对表格的列进行组合，便于通过`<col>`设置属性并进行格式化。 |
| `<col>`      | 为表格的列定义各种属性值，只能用于`<colgroup>`内部。 |
| `<thead>`    | 定义表格的列头的行。 |
| `<tbody>`    | 表格的主体，用来放置`<tr>`元素 |
| `<tfoot>`    | 表格的尾部，通常用来表达汇总信息 |
| `<th>`       | 定义一列单元格的头部信息 |
| `<tr>`       | 定义表格中的行，可以用来放置`<td>`和`<th>`元素。 |
| `<td>`       | 定义表格中的单元格 |

```html
<table>

  <caption>Demo</caption>

  <colgroup>
    <col style='background-color: blue'>
    <col style='background-color: gray'>
  </colgroup>

  <thead>
    <tr>
      <th>月份</th>
      <th>工资</th>
    </tr>
  </thead>

  <tfoot>
    <tr>
      <td>合计</td>
      <td>￥180</td>
    </tr>
  </tfoot>

  <tbody>
    <tr>
      <td>1月</td>
      <td>￥100</td>
    </tr>
    <tr>
      <td>2月</td>
      <td>￥80</td>
    </tr>
  </tbody>

</table>
```

![](html/table.png '表格Demo')


## 表单

用来创建用户交互表单的HTML元素。

| 元素 | 语义 |
|:-----|:-----|
| `<form>`     | 代表一个交互表单区域。 |
| `<button>`   | 表示一个按钮。|
| `<input>`    | 输入域，用来接收用户的输入。 |
| `<datalist>` | 定义`<input>`的可能的选项值，*目前仅Safari未提供该元素支持*。 |
| `<label>`    | 为输入域元素`<input>`定义标题。|
| `<fieldset>` | 用来对表单控件的内容进行分组。 |
| `<legend>`   | 为`<fieldset>`元素定义标题，*IE不支持该元素*。 |
| `<textarea>` | 用来创建多行文本输入域。|
| `<select>`   | 用来创建单选/多选菜单。 |
| `<option>`   | 用来定义下拉列表元素`<select>`的一个选项。 |
| `<optgroup>` | 可以对`<select>`元素中的`<option>`进行分组。 |
| `<meter>`    | 用来显示已知范围的比例值，通常被渲染为柱状图。 |
| `<output>`   | 控制文本输出的API，*IE不支持该元素*。 |
| `<progress>` | 用来展示完成进度，通常渲染为一个进度条，*已经获得包括IE在内的全部浏览器支持*。 |

```html
<form action='/server/api' method='post'>
  <fieldset>
    <legend>Fieldset</legend>
    <input type='checkbox' name='check' id='check-A' value='A' />
    <label for='check-A'>单选按钮</label>
    <input type='checkbox' name='check' id='check-B' value='B' />
    <label for='check-B'>单选按钮</label>
  </fieldset>

  <input type='radio' id='radio'>
  <label for='radio'>单选按钮</label>

  <progress value='70' max='100'>Progress</progress>

  <meter min='200' max='500' value='350'>Meter</meter>

  <button name='button'>Button</button>

  <select>
    <optgroup label='四川'>
      <option value='chengdu'>成都</option>
      <option value='mianyang'>绵阳</option>
    </optgroup>
    <optgroup label='贵州'>
      <option value='guiyang'>贵阳</option>
      <option value='zunyi'>遵义</option>
    </optgroup>
  </select>

  <textarea name='textarea' rows='10' cols='30'>Textarea</textarea>

  <label>Datalist
    <input list='browsers'>
  </label>
  <datalist id='browsers'>
    <option value='Internet Explorer' />
    <option value='Chrome' />
    <option value='Firefox' />
    <option value='Opera' />
    <option value='Safari' />
  </datalist>
</form>
```

![](html/form.png '表单元素Demo')


## 交互元素

用来帮助建立用户可交互的元素。

| 元素 | 语义 |
|:-----|:-----|
| `<dialog>`   | 展示对话框或其它交互组件，*仅Opera和Chrome支持*。 |
| `<details>`  | 定义查看和检索附加信息的小部件。 |
| `<summary>`  | 展示`<details>`元素的摘要或总结。|

```html
<details open>
  <summary>摘要</summary>
  <p>内容1</p>
  <p>内容2</p>
</details>

<dialog open>
  <p>Dialog</p>
</dialog>
```

![](html/interactive.png '交互元素Demo')


## Web组件

用来建立用户自定义元素，（*[Web Component](https://www.w3.org/TR/components-intro/)目前还处于草案阶段，还未成为事实上的标准，且部分内容已经被废弃*）。

| 元素 | 语义 |
|:-----|:-----|
| `<slot>`     | 作为占位符，用来插入自定义的标记文本，*该元素目前还属于实验性技术*。 |
| `<template>` | ES6模板字面量，该元素中的内容在页面加载时不被渲染，但可以通过JavaScript实例化，*目前已经得到IE外的其它全部浏览器支持*。 |


## 废弃的元素

W3C的HTML规范声明放弃使用的元素。

| Deprecated | Deprecated | Deprecated | Deprecated | Deprecated | Deprecated |
|:-----|:-----|:-----|:-----|:-----|:-----|
|`<acronym>`  |`<applet>` |`<basefont>`|`<big>`     |`<blink>`    |`<center>` |
|`<dir>`      |`<font>`   |`<frame>`   |`<frameset>`|`<image>`    |`<isindex>`|
|`<keygen>`   |`<listing>`|`<marquee>` |`<multicol>`|`<nextid>`   |`<noembed>`|
|`<plaintext>`|`<spacer>` |`<strike>`  |`<tt>`      |`<xmp>`      |`<command>`|
|`<content>`  |`<element>`|`<shadow>`  |`<menu>`    |`<menuitem>` |`...`      |


## 全局HTML属性

所有HTML元素都通用的属性值。

| Attribute | Elements | Description |
|:-----|:-----|:-----|
| *accesskey* | `全局属性` | 定义*focus*至指定HTML元素的快捷键。 |
| *class* | `全局属性` | 通常用于添加CSS样式。 |
| *contenteditable* | `全局属性` | 指定HTML元素中的内容是否可以编辑。 |
| *data-* | `全局属性` | 添加自定义属性到HTML元素。 |
| *dir* | `全局属性` | 定义文本方向，属性值可以是`ltr`（*Left-To-Right*）或者`rtl`（*Right-To-Left*）。 |
| *draggable* | `全局属性` | 定义HTML元素是否能够执行拖动操作。 |
| *dropzone* | `全局属性` | 指定接收拖放内容的HTML元素。 |
| *hidden* | `全局属性` | 不渲染指定的HTML元素。 |
| *id* | `全局属性` | 通常用来设置CSS样式，其**属性值必须唯一**。 |
| *lang* | `全局属性` | 定义HTML元素中所使用的语言。 |
| *style* | `全局属性` | 用于直接在HTML元素上定义CSS样式。 |
| *tabindex* | `全局属性` | 重写浏览器默认的`tab`键顺序。 |
| *title* | `全局属性` | 鼠标*hover*到HTML元素上时显示的提示信息。 |
| *slot* | `实验属性` | 将影子DOM阴影树中的一个槽分配给一个元素。 |


## 其它HTML属性

配置指定HTML标签的特性或行为。

| Attribute | Elements | Description |
|:-----|:-----|:-----|
| *accept* | `<form>, <input>` | 表单向服务器提交的文件类型。 |
| *accept-charset* | `<form>` | 表单字符集编码。 |
| *action* | `<form>` | 表单提交的远程URI。 |
| *align* | `<applet>, <caption>, <col>, <colgroup>,  <hr>, <iframe>, <img>, <table>, <tbody>,  <td>,  <tfoot> , <th>, <thead>, <tr>` | 指定元素的水平对齐方式。 |
| *alt* | `<applet>, <area>, <img>, <input>` | 图片无法显示时的替换文字。 |
| *async* | `<script>` | 引用的JavaScript脚本将会被异步执行。 |
| *autocomplete* | `<form>, <input>` | 表单是否能由浏览器进行自动填充。 |
| *autofocus* | `<button>, <input>, <keygen>, <select>, <textarea>` | 页面加载后输入焦点自动*focus*至指定HTML元素。 |
| *autoplay* | `<audio>, <video>` | 自动播放音、视频多媒体。 |
| *buffered* | `<audio>, <video>` | 指定缓冲多媒体的时间范围。 |
| *challenge* | `<keygen>` | 与公钥一同被提交的*challenge string*。 |
| *charset* | `<meta>, <script>` | 声明页面脚本当中的字符串编码。 |
| *checked* | `<command>, <input>` | 标识页面加载后默认选中的HTML元素。 |
| *cite* | `<blockquote>, <del>, <ins>, <q>` | 包含引用或修改资源的URI。 |
| *code* | `<applet>` | 指定需要执行的`applet`类文件的URI。 |
| *codebase* | `<applet>` | 指定`code`属性中指定的`applet`类文件的绝对或相对URL。 |
| *cols* | `<textarea>` | 定义输入域的列数。 |
| *colspan* | `<td>, <th>` | 定义一个单元格所跨越的列数。 |
| *content* | `<meta>` | 包含`http-equiv`或`name`属性的值（具体哪个取决于上下文）。 |
| *controls* | `<audio>, <video>` | 是否向用户显示回放控件。 |
| *coords* | `<area>` | 用于标识图片`<img>`热点区域的坐标值。 |
| *crossorigin* | `<audio>, <img>, <link>, <script>, <video>` | 指示该HTML元素如何处理跨域请求。 |
| *data* | `<object>` | 指定外部资源的URL，例如1个flash视频。 |
| *datetime* | `<del>, <ins>, <time>` | 标识关联到指定HTML元素的日期与时间。 |
| *default* | `<track>` | 指定默认的多媒体轨道。 |
| *defer* | `<script>` | 指示脚本在页面解析完成之后再进行执行。 |
| *disabled* | `<button>, <command>, <fieldset>, <input>, <keygen>, <optgroup>, <option>, <select>, <textarea>` | 使指定HTML元素失效并且不能交互。 |
| *download* | `<a>, <area>` | 标识用于下载资源的超链接。 |
| *enctype* | `<form>` | 当表单`method`属性为`POST`时，用来指定表单内容的**MIME**类型 。 |
| *for* | `<label>, <output>` | 需要进行标注或用户输出的HTML元素的ID |
| *form* | `<button>, <fieldset>, <input>, <keygen>, <label>, <meter>, <object>, <output>, <progress>, <select>, <textarea>` | 指明HTML元素属于哪个表单。 |
| *formaction* | `<input>, <button>` | 单独标识元素的`action`行为，会对`<form>`上的`action`造成覆盖。 |
| *headers* | `<td>, <th>` | 包含一个空格分隔的字符串列表，每个字符串对应于此元素相关的`<th>`的`id`属性。 |
| *href* | `<a>, <area>, <base>, <link>` | 链接资源的URL。 |
| *hreflang* | `<a>, <area>, <link>` | 指定链接资源使用的语言。 |
| *http-equiv* | `<meta>` | 包含HTTP协议头名称，可以改变浏览器和服务器的行为，目前仅有`content-security-policy`和`refresh`两个属性值可用，其它属性值已被废弃或被推荐以其它方式定义。 |
| *integrity* | `<link>, <script>` | 实验特性，允许浏览器验证HTML元素获取内容的安全性，目前仅Chrome和Firefox支持。 |
| *ismap* | `<img>` | 标识`<img>`是服务器端图片映射的一部分。 |
| *kind* | `<track>` | 指定一种*text track*。 |
| *label* | `<track>` | 指定*text track*的用户可读标题。 |
| *list* | `<input>` | 一组显示给用户的预定义的输入建议列表，其值是`<datalist>`元素的ID属性。 |
| *loop* | `<audio>, <bgsound>, <marquee>, <video>` | 是否单曲循环播放多媒体内容。 |
| *low* | `<meter>` | 标识低量程的上界。 |
| *high* | `<meter>` | 标识高量程的下界。 |
| *manifest* | `<html>` | 指定文档缓存清单的URL地址，CANIUSE显示仅Chrome对该属性支持良好，但Mozilla社区标识该属性已得到大部份浏览器支持，不过已经过时且有可能被废弃。 |
| *min* | `<input>, <meter>` | 指定HTML表单元素允许的最**小**值。 |
| *max* | `<input>, <meter>, <progress>` | 指定HTML表单元素允许的最**大**值。 |
| *maxlength* | `<input>, <textarea>` | 标识指定表单元素允许的最**大**字符数。 |
| *minlength* | `<input>, <textarea>` | 标识指定表单元素允许的最**小**字符数。 |
| *media* | `<a>, <area>, <link>, <source>, <style>` | 指定HTML元素链接资源所应用的媒体类型。 |
| *method* | `<form>` | 定义表单的HTTP请求方式。 |
| *multiple* | `<input>, <select>` | 标识`email`或`file`类型的输入域是否可以进行多选操作。 |
| *muted* | `<audio>, <video>` | 页面加载后多媒体默认为静音模式。 |
| *name* | `<button>, <form>, <fieldset>, <iframe>, <input>, <keygen>, <object>, <output>, <select>, <textarea>, <map>, <meta>, <param>` | 元素的名称，可用于标识表单域。 |
| *novalidate* | `<form>` | 提交时当前表单不进行验证。 |
| *open* | `<details>` | 页面加载时是否展示详细内容。 |
| *optimum* | `<meter>` | 该属性用于标识一个位于`max`和`min`之间的最优数值。 |
| *pattern* | `<input>` | 定义输入域内容的正则表达式校验。 |
| *ping* | `<a>` | 表示浏览器会发送1个ping请求到该属性指向的资源，Mozilla标识该元素受IE、Safari以外的其它浏览器支持，但是CANIUSE认为仅Chrome和Safari支持良好。 |
| *placeholder* | `<input>, <textarea>` | 在表单输入域上展示用户信息提示。 |
| *poster* | `<video>` | 标识多媒体视频的海报封面URL地址。 |
| *preload* | `<audio>, <video>` | 定义预加载的多媒体内容。 |
| *radiogroup* | `<command>` | 用于指定一组命令的名称，Moziila和CANIUSE都标识该属性暂未获得任何浏览器的支持。 |
| *readonly* | `<input>, <textarea>` | 标识指定表单元素是否能够进行编辑，或是以只读方式进行展示。 |
| *rel* | `<a>, <area>, <link>` | 指定目标对象与链接对象之间的关系。 |
| *required* | `<input>, <select>, <textarea>` | 标识该表单控件是否为必填项。 |
| *reversed* | `<ol>` | 让列表倒序进行排列。 |
| *rows* | `<textarea>` | 定义文本输入域的行数。 |
| *rowspan* | `<td>, <th>` | 定义表格单元跨越的行数。 |
| *sandbox* | `<iframe>` | 该属性用于对内联框架中出现的内容进行额外限制，属性值可以是空字符串（*所有的限制都适用*）或者是空格分隔的令牌（*解除特定限制*）。 |
| *scope* | `<th>` | 定义表格头部`<th>`中的单元格，拥有`row, col, rowgroup, colgroup, auto`这几个枚举属性值。 |
| *scoped* | `<style>` | 指定样式只应用于该元素的父元素及其子元素，该属性仅Firefox支持，且已经过时，并不保证使用正常。 |
| *selected* | `<option>` | 页面加载时，表单元素`<select>`的默认选项。 |
| *shape* | `<a>, <area>` | 该属性用于在超链接区域创建图像映射，仅有Chrome和Safari支持，仅用于HTML4，且HTML5当中已经过时。 |
| *spellcheck* | `<textarea>, <input>` | 是否对文本域、输入域进行拼写检查。 |
| *size* | `<input>, <select>` | 指定输入域元素的宽度尺寸。 |
| *sizes / srcset* | `<img>, <source>` | 为HTML元素定义多个图片资源，使浏览器在恰当的时刻显示相应图片（*例如在高分辨率屏幕下*），仅IE11及以下浏览器不兼容该属性。 |
| *span* | `<col>, <colgroup>` | 该属性值为一个正整数，表示该HTML元素所跨越的连续列个数，通常默认值为**1**。 |
| *src* | `<audio>, <embed>, <iframe>, <img>, <input>, <script>, <source>, <track>, <video>` | 需要嵌入页面的内容的URL。 |
| *srcdoc* | `<iframe>` | 覆盖父元素`src`属性指定的内容，仅IE和Eage不支持该属性。 |
| *srclang* | `<track>` | 多媒体轨道的文本数据（*字幕*）的国家语言类型。 |
| *start* | `<ol>` | 定义有序列表的起始数值。 |
| *step* | `<input>` | 与`min`和`max`结合使用，设置数字值或者日期时间的增量限制。 |
| *summary* | `<table>` | 用于定义表格的概述文本。 |
| *target* | `<a>, <area>, <base>, <form>` | 指定URL链接的打开方式，可选值有`_self`、`_blank`、`_parent`、`_top`，其中`<form>`元素还可以选择`iframename`值。 |
| *type* | `<button>, <input>, <command>, <embed>, <object>, <script>, <source>, <style>, <menu>` | 定义HTML元素的类型。 |
| *usemap* | `<img>,  <input>, <object>` | 元素关联图片的URL片断（*以符号`#`开头*）。 |
| *value* | `<button>, <option>, <input>, <li>, <meter>, <progress>, <param>` | 定义页面加载时HTML元素显示的默认值。 |
| *wrap* | `<textarea>` | 标识文本换行的方式。 |