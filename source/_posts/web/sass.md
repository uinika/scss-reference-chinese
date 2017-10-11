---
title: SASS快速上手
tags: CSS
categories: Web
---

![](sass/logo.png)

<!-- more -->

## 编码规则

Sass以**UTF-8**编码输出CSS文件，当且仅当编译后的文件包含**非ASCII**字符时，才会输出`@charset`声明，并使用该声明上指定的字符集。

```scss
@charset "utf-8";
#app {
  background: url('../assets/背景图片.png');
}
```

## CSS扩展

### 嵌套规则

SASS允许CSS规则嵌套使用，父子规则将会呈现**包含选择器**关系，这样可以避免重复使用父级选择器，简化CSS代码结构。

```scss
// SASS
#app {
  width: 100%;
  height: 100%;
  main.login {
    display: flex;
  }
}

// CSS
#app {
  width: 100%;
  height: 100%;
}

#app main.login {
  display: flex;
}
```

### 嵌套属性



### 引用父级选择器&

SASS使用`$`关键字在CSS规则中引用**父级选择器**，例如嵌套使用伪类选择器的场景下。

```scss
// SASS
a {
  font-weight: bold;
  text-decoration: none;
  &:hover {
    color: blue;
    text-decoration: underline;
  }
}

// CSS
a {
  font-weight: bold;
  text-decoration: none;
  a:hover {
    color: blue;
    text-decoration: underline;
  }
}
```

关键字`&`会使用父级选择器**级联替换**全部其出现的位置，

```scss
// SCSS
#main {
  color: black;
  a {
    font-weight: bold;
    &:hover {
      color: red;
    }
  }
}

// CSS
#main {
  color: black;
}
#main a {
  font-weight: bold;
}
#main a:hover {
  color: red;
}
```

`&`必须出现在组合选择器的开头位置，后面再连接自定义的后缀。

```scss
// SCSS
#app {
  color: gray;
  &-sidebar {
    border: 1px solid;
  }
}

// CSS
#app {
  color: gray;
}
#app-sidebar {
  border: 1px solid;
}
```

> If the parent selector can't have a suffix applied, Sass will throw an error.

## 注释

## SassScript

## @rule和#directive