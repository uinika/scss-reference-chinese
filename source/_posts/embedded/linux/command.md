---
title: Linux常用命令精粹
tags: Linux
categories: Note
---

将Linux作为开发环境编写代码已经3年有余，在配置了大量**快捷键**、**辅助工具**、**开源字体**之后，日常开发基本已经离不开Linux，本文总结了自己在Linux下进行日常开发所经常使用到的命令。

## ls

查看当前目录下的文件。

- `-al` 查看当前目录下的文件列表，包括隐藏的

```bash
➜  blog git:(master) ✗ ls -al
drwxrwxr-x   9 hank hank   4096 8月  31 00:02 .
drwxrwxrwx   4 root root   4096 8月  24 03:15 ..
-rw-rw-r--   1 hank hank   1966 8月  26 18:56 _config.yml
-rw-rw-r--   1 hank hank 505845 8月  31 00:02 db.json
drwxrwxr-x  13 hank hank   4096 8月  31 00:02 .deploy_git
drwxrwxr-x   8 hank hank   4096 8月  31 00:18 .git
-rw-rw-r--   1 hank hank     83 8月  26 02:29 .gitignore
-rw-rw-r--   1 hank hank    277 8月  24 03:15 index.html
drwxrwxr-x 302 hank hank  12288 8月  26 02:29 node_modules
-rw-rw-r--   1 hank hank    610 8月  26 02:29 package.json
-rw-rw-r--   1 hank hank  90061 8月  26 02:29 package-lock.json
drwxrwxr-x  12 hank hank   4096 8月  31 00:02 public
-rw-rw-r--   1 hank hank    203 8月  24 03:15 README.md
drwxrwxr-x   2 hank hank   4096 8月  24 03:15 scaffolds
drwxrwxr-x   6 hank hank   4096 8月  24 03:15 source
drwxrwxr-x   3 hank hank   4096 8月  24 03:15 themes
```

<!-- more -->

## cd

切换目录

- `/` 根目录
- `.` 当前目录
- `..` 上层目录
- `~` 用户主目录
- `-` 上次工作目录

```bash
➜  blog git:(master) ✗ cd -
/workspace/blog/source
➜  source git:(master) ✗ cd -
/workspace/blog
```

## pwd

查看当前路径

```bash
➜  blog git:(master) ✗ pwd
/workspace/blog
```

## mkdir

创建目录

- `-m` 创建目录的同时指定访问权限
- `-p` 如果所创建目录的父目录不存在，则创建父目录

```bash
➜  / mkdir -pm 777 /workspace/linux
```

## rmdir

删除空目录

- `-p` 如果删除目录的父目录也为空，则删除父目录

```bash
sudo rmdir /workspace/linux
```

> zshell中可以缺省`-p`属性。

## rm

删除目录和文件

- `-f` 强制删除，无需用户确认
- `-i` 删除前需要确认
- `-r` 递归删除
- `-v` 显示删除过程

```
➜  linux ls
file1  file2  file3
➜  linux rm -rvi file*
rm：是否删除普通空文件 'file1'？ y
已删除'file1'
rm：是否删除普通空文件 'file2'？ y
已删除'file2'
rm：是否删除普通空文件 'file3'？ y
已删除'file3'
```

## touch

创建空文件

```bash
➜  linux touch file1 file2 file3
➜  linux ll
总用量 0
-rw-rw-r-- 1 hank hank 0 8月  31 00:47 file1
-rw-rw-r-- 1 hank hank 0 8月  31 00:47 file2
-rw-rw-r-- 1 hank hank 0 8月  31 00:47 file3
```

## echo

输出一行文本

Linux命令行中的输出重定向
- `>` 输出到一个新文件
- `>>` 输出到现有文件末尾，如果文件不存在则创建新文件

```bash
➜  linux echo "Hello Hank" >> file
➜  linux head file
Hello Hank
```

## file

查看文件类型，以及二进制文件的详细信息（包括处理器体系结构）

```bash
➜  blog git:(master) ✗ file *
_config.yml:       ASCII text
db.json:           UTF-8 Unicode text, with very long lines, with no line terminators
index.html:        HTML document, ASCII text, with CRLF line terminators
node_modules:      directory
package.json:      ASCII text
package-lock.json: ASCII text
public:            directory
README.md:         ASCII text
scaffolds:         directory
source:            directory
themes:            directory
```

## more / less

浏览文本文件，空格翻页，q退出

```bash
➜  blog git:(master) ✗ more index.html 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Document</title>
</head>
<body>
  <h1>test</h1>
</body>
</html>
```

> less命令功能更丰富，支持键盘翻页键，可以向前先后任意翻页浏览，并支持文本搜索，例如输入`/abc`可在文本中搜索字符串abc

## head / tail

查看文件头部或尾部，默认显示10行。

- `-n` [数字] 显示[数字]所指定的行数
- `-c` [数字] 显示[数字]所指定的字节数

```bash
➜  blog git:(master) ✗ head -n4 index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
```

## cat

将一个或多个文件输出到标准输出。

- `-n` 从1开始对输出行进行编号
- `-b` 类似于-n，从1开始编号，但忽略空白行
- `-s` 遇到连续两行或以上的空白行，就替换为一行空白行

```bash
➜  blog git:(master) ✗ cat -n index.html >> /workspace/linux/test.html
➜  blog git:(master) ✗ cat /workspace/linux/test.html
1  <!DOCTYPE html>
2  <html lang="en">
3  <head>
4    <meta charset="UTF-8">
5    <meta name="viewport" content="width=device-width, initial-scale=1.0">
6    <meta http-equiv="X-UA-Compatible" content="ie=edge">
7    <title>Document</title>
8  </head>
9  <body>
10   <h1>test</h1>
11 </body>
12 </html>
```

> 通过cat和重定向搭配使用，可以完成将多个文件合并为一个新文件的操作。

## mv

移动文件，或修改文件名称。

```
➜  mv file file1 
```

## cp

复制文件。

- `-a` 保留链接、文件属性并递归复制，等同于`-dpR`，常用用于复制目录
- `-d` 复制时保留链接
- `-f` 若目标文件存在，直接删除不提示
- `-i` 若目标文件存在，需要用户确认操作，与-f 相反
- `-p` 复制文件内容的同时，还复制了文件的访问权限和修改时间
- `-r` 递归复制
- `-v` 显示文件复制过程

```bash
➜  cp -a file1 file2  ./demo 
```

## ln

创建链接。

* 硬链接：`ln`命令默认创建的是硬链接，通过索引节点进行链接，相当于源文件的镜像，占用源文件同样大小的空间，修改其中一个，另外一个也会进行相同改动。

> 硬链接**不能**跨文件系统。

```bash
➜  ls -l
总用量 0
-rw-rw-r-- 1 hank hank 0 8月  31 02:20 file
➜  ln file ./shortcut
➜  ls -l
总用量 0
-rw-rw-r-- 2 hank hank 0 8月  31 02:20 file
-rw-rw-r-- 2 hank hank 0 8月  31 02:20 shortcut
```

* 软链接：加上`-s`选项可以创建软链接，会产生一个链接文件，该文件指向目标文件的位置，类似于Windows下的快捷方式。

```bash
➜  ls -l
总用量 0
-rw-rw-r-- 1 hank hank 0 8月  31 02:20 file
➜  ln -s file  ./shortcut
➜  ls -l
总用量 0
-rw-rw-r-- 1 hank hank 0 8月  31 02:20 file
lrwxrwxrwx 1 hank hank 4 8月  31 02:22 shortcut -> file
```

> 软链接**可以**跨文件系统。

## chmod

改变文件权限。

![](command/chmod.png "文件权限的表示")

* 数字表示法：文件权限的数字表示是由`读`、`写`、`执行`3个权限数字相加，并按照`拥有者`、`组成员`、`其它`的顺序排列而来。

```bash
➜  sudo chmod 753 file
➜  ls -l
总用量 0
-rwxr-x-wx 1 hank hank 0 8月  31 02:20 file
```

* 字符表示法： u/g/o 表示文件的拥有者/组内用户/其它用户，用 rwx 分别表示读/写/执行权限，用+/-表示增加或去除某种权限。

```bash
➜  sudo chmod u+rwx,g+wr,o-wrx file
➜  ls -l
总用量 0
-rwxrw---- 1 hank hank 0 8月  31 02:38 file
```

> 拥有可执行权限的文件，在Linux终端下通常呈现为绿色。
> 可在通过`chmod +x file`快捷的为`user`、`group`、`other`增加可执行权限。

## ifconfig

配置和查看网卡信息。

- `up` 激活指定网卡`ifconfig eth0 up`
- `down` 关闭指定网卡`ifconfig eth0 down`

```bash
➜  /workspace ifconfig
enp3s0    Link encap:以太网  硬件地址 18:db:f2:3d:08:a2  
          UP BROADCAST MULTICAST  MTU:1500  跃点数:1
          接收数据包:0 错误:0 丢弃:0 过载:0 帧数:0
          发送数据包:0 错误:0 丢弃:0 过载:0 载波:0
          碰撞:0 发送队列长度:1000 
          接收字节:0 (0.0 B)  发送字节:0 (0.0 B)

lo        Link encap:本地环回  
          inet 地址:127.0.0.1  掩码:255.0.0.0
          inet6 地址: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  跃点数:1
          接收数据包:11341 错误:0 丢弃:0 过载:0 帧数:0
          发送数据包:11341 错误:0 丢弃:0 过载:0 载波:0
          碰撞:0 发送队列长度:1000 
          接收字节:38060900 (38.0 MB)  发送字节:38060900 (38.0 MB)

wlp2s0    Link encap:以太网  硬件地址 98:54:1b:23:7b:c0  
          inet 地址:192.168.0.4  广播:192.168.0.255  掩码:255.255.255.0
          inet6 地址: fe80::8f47:deee:640c:d14b/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  跃点数:1
          接收数据包:84743 错误:0 丢弃:0 过载:0 帧数:0
          发送数据包:48721 错误:0 丢弃:0 过载:0 载波:0
          碰撞:0 发送队列长度:1000 
          接收字节:99129124 (99.1 MB)  发送字节:16185986 (16.1 MB)
```

## ping

测试到目标主机的网络是否畅通。

```bash
➜  blog git:(master) ✗ ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=3.33 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=2.13 ms
64 bytes from 192.168.0.1: icmp_seq=3 ttl=64 time=2.23 ms
```

## mount / unmount