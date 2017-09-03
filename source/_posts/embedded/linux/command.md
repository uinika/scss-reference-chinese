---
title: Linux命令行必知必会
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

```bash
➜  cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 142
model name	: Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz
... ... ...
➜  cat /proc/version 
Linux version 4.12.2-041202-generic (kernel@gloin) (gcc version 6.3.0 20170618 (Ubuntu 6.3.0-19ubuntu1) ) #201707150832 SMP Sat Jul 15 12:34:02 UTC 2017
```

> cat命令也可用于查看CPU、内核版本等系统信息。

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

## free

查看操作系统内存使用情况。

```bash
➜  free
              total        used        free      shared  buff/cache   available
Mem:       12110732     1996616     2339832      380248     7774284     9356872
Swap:      12389372           0    12389372
```

## df

查看文件系统磁盘空间的使用。

```
➜  df
文件系统           1K-块      已用      可用 已用% 挂载点
udev             6032356         0   6032356    0% /dev
tmpfs            1211076      9768   1201308    1% /run
/dev/sdb1      110743360  15959824  89135000   16% /
tmpfs            6055364     32508   6022856    1% /dev/shm
tmpfs               5120         4      5116    1% /run/lock
tmpfs            6055364         0   6055364    0% /sys/fs/cgroup
cgmfs                100         0       100    0% /run/cgmanager/fs
tmpfs            1211076        68   1211008    1% /run/user/1000
/dev/sda3      511999996 400954728 111045268   79% /media/hank/media
/dev/sda2      204799996 137228808  67571188   68% /media/hank/develop
/dev/sdc1       15099432   4246304  10853128   29% /media/hank/CCSA_X64FRE
```

## mount / umount

Linux允许多个文件系统共存，也允许在系统运行时挂载当前内核提供支持的文件系统。

### mount

挂载文件系统至指定目录，可以通过`-t`参数指定挂载的文件系统类型：

1. `ext/ext2/ext3/ext4`  Linux常用文件系统
2. `msdos`               MS-DOS的FAT，即FAT16
3. `vfat`                Windows的FAT或FAT32
4. `nfs`                 网络文件系统
5. `ntfs`                Windows的NTFS
6. `auto`                自动检测文件系统

```bash
➜  sudo mount -t ntfs /dev/sdc1 /workspace/linux
```

### umount

卸载指定目录下挂载的文件系统

```bash
➜  sudo umount /dev/sdc1
```

>  嵌入式开发中常用的文件系统还有cramfs、jffs2（*NOR Flash*）、yaffs/yaffs2（*NAND Flash*）。

## lsmod / insmod / rmmod

Linux内核时可以动态加载、卸载模块（*例如驱动程序模块*）。

### lsmod

查看当前Linux内核已经加载的模块，该命令实际是列出/proc/modules目录下的内容。

```bash
➜  lsmod
Module                  Size  Used by
nls_iso8859_1          16384  0
uas                    24576  0
usb_storage            69632  2 uas
cmac                   16384  1
rfcomm                 77824  14
ccm                    20480  6
rtsx_usb_ms            20480  0
memstick               16384  1 rtsx_usb_ms
... ... ...
```

### insmod

向内核插入模块。

如下代码向内核插入驱动模块driver.ko。

```bash
➜  insmod driver.ko
```
> .ko是内核模块文件的后缀名。

插入模块时可以通过insmod命令向模块传入参数，

```bash
➜  insmod test.ko time=2017
```

> 如果模块版本与内核不一致，模块将无法插入系统，虽然可以使用`-f`参数强制插入，但可能会引起错误。

### rmmod

将模块从内核中卸载，并释放所占用的系统资源。

```bash
➜  rmmod test.ko
```

> 模块可能被其它模块依赖，或正在被应用程序使用，此时无法卸载该模块。依然可以通过`-f`参数强制卸载，不过并不推荐这么做。

## modprobe

可以加载、卸载内核模块，并且可以自动解决模块间的依赖关系，将某模块所依赖的其它模块全部加载。

> 因为`modprobe`处理模块时会忽略模块路径，所以模块必须按照`make modues_install`方式安装（*即模块必须放在`/lib/modules/$(uname -r)`目录下*），并拥有正确的`/lib/modules/$(uname -r)/modules.dep`文件，`modprobe`命令会根据该文件来解析依赖关系。

## mknod

加载驱动模块到内核之后，需要通过`mknod`为驱动建立对应的设备节点，否则无法通过驱动来操作设备。
命令使用格式为`mknod 设备名 设备类型 主设备号 次设备号`，下面命令创建了一个字符设备led，主设备号为231，次设备号为0。

```bash
➜  mknod /dev/led c 231 0
```

## sync

Linux对文件的操作都是先保存在缓存中，并没有立即写入磁盘，通常需要经系统调度后才会写入磁盘，当然这里也可以使用`sync`命令强制进行写入。

```bash
➜  sync
```

## find

搜索目录当中的**文件**，命令格式为`$find 路径 –选项 目标文件`。

* -name 根据文件名进行搜索

```
➜  find -name index.html
./.deploy_git/2017/08/30/article/2017/guiyang-big-data/index.html
./.deploy_git/2017/08/27/article/2017/chengdu-real-estate-1/index.html
./.deploy_git/2017/08/27/article/2017/chengdu-real-estate-2/index.html
./.deploy_git/2017/08/27/article/2017/chengdu-real-estate-3/index.html
... ... ...
```

## grep

搜索目录下文件当中存在的**字符串**，下面例子查询字符串`"hank"`被`./source`目录下哪些文件所使用。

* -R 在指定目录下进行递归查找。

```
➜  blog git:(master) ✗ grep "hank" -R ./source 
source/_posts/web/summary/jquery.md:  data-object= '{"name": "hank"}'
source/_posts/embedded/linux/command.md:drwxrwxr-x   9 hank hank   4096 8月  31 00:02 .
source/_posts/embedded/linux/command.md:-rw-rw-r--   1 hank hank   1966 8月  26 18:56 _config.yml
source/_posts/embedded/linux/command.md:-rw-rw-r--   1 hank hank 505845 8月  31 00:02 db.json
source/_posts/embedded/linux/command.md:drwxrwxr-x  13 hank hank   4096 8月  31 00:02 .deploy_git
source/_posts/embedded/linux/command.md:drwxrwxr-x   8 hank hank   4096 8月  31 00:18 .git
source/_posts/embedded/linux/command.md:-rw-rw-r--   1 hank hank     83 8月  26 02:29 .gitignore
source/_posts/embedded/linux/command.md:-rw-rw-r--   1 hank hank    277 8月  24 03:15 index.html
... ... ...
```

## env / printenv

查看系统当前的环境变量设置，下面例表是一些常见环境变量：

- *PATH*：指定Shell执行时会到哪些目录寻找应用。
- *TERM*：指定系统终端。
- *SHELL*：当前用户Shell类型。
- *HOME*：当前用户主目录。
- *LOGNAME*：当前用户的登录名。
- *USER*：当前用户名。
- *HISTSIZE*：历史命令记录数。

> Shell中可以通过`$环境变量名`来引用指定的环境变量信息。


如下是Linux环境变量修改的3种方式及其区别：

- `/etc/profile` 对本机全部用户有效。
- `~/.bashrc` 对当前用户有效。
- `export 新增环境变量` 仅对当前打开的终端有效。

```bash
➜  echo $PATH
/home/hank/bin:/home/hank/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/jdk/bin:/opt/nodejs/bin:/opt/mongodb/bin
➜  PATH=$PATH:/workspace/linux
➜  printenv PATH
/home/hank/bin:/home/hank/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/jdk/bin:/opt/nodejs/bin:/opt/mongodb/bin:/workspace/linux
```

### env

该命令用于在一个被修改的环境变量下运行程序，也可用于打印全部或指定的环境变量（*通过`env $PATH`*）。

```bash
➜  env
... ... ...
PATH=/home/hank/bin:/home/hank/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/jdk/bin:/opt/nodejs/bin:/opt/mongodb/bin
SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
TERM=xterm
HOME=/home/hank
... ... ...
```

### printenv

专门用于打印全部或指定的环境变量（*通过`printenv PATH`*）。

```bash
➜  printenv PATH
/home/hank/bin:/home/hank/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/jdk/bin:/opt/nodejs/bin:/opt/mongodb/bin
```

## fdisk

操作磁盘分区表。


## su / sudo

### su

切换到root用户，可能存在危险。

```bash
➜  su
➜  whoami
root
➜  exit
➜  whoami
hank
```

> 切换到root用户后，可以通过`exit`命令进行退出。

### sudo

临时获取root用户权限。

```
➜  sudo vim /etc/sudoers
```

> sudo命令需要将用户添加到sudoer组中，一般通过/etc/sudoers文件进行修改。

## uname

打印系统信息。

```bash
➜  uname -a
Linux hank-linux 4.12.2-041202-generic #201707150832 SMP Sat Jul 15 12:34:02 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
```

## man

1 可执行程序或shell命令
2 系统调用（*内核提供的函数*）
3 库调用（*程序库中的函数*）
4 特殊文件（*通常位于 /dev*）
5 文件格式和规范，如/etc/passwd
6 游戏
7 杂项（*包括宏包和规范，如man(7)，groff(7)*）
8 系统管理命令(*通常只针对root用户*)
9 内核例程

## whereis

## whois

## whoami

## ssh

