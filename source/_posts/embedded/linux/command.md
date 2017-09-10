---
title: Linux命令行必知必会
tags: Linux
categories: Note
---

将Linux作为开发环境编写代码已经3年有余，在配置了大量**快捷键**、**辅助工具**、**开源字体**之后，日常开发已经完全离不开Linux，本文基于最新的**Linux mint 18.2**发行版，总结了自己在Linux下进行日常开发所经常使用到的命令。

## tree

以树形格式列出指定目录的内容，用来方便的在命令行中展示项目结构。

* `-L` 需要显示的最大目录树深度。
* `--dirsfirst` 优先显示目录。

```
➜  aves git:(master) tree -L 1 server  sources --dirsfirst
server
├── common
├── dashboard
├── login
├── system
└── app.js
sources
├── assets
├── common
├── dashboard
├── demo
├── layout
├── login
├── app.js
└── index.html
```
<!-- more -->

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

## rm / mv / cp

文件操作相关的3个命令。

### rm

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

### mv

移动文件，或修改文件名称。

```
➜  mv file file1 
```

### cp

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

## chown / chgrp

修改指定文件的所有者关系，但是也可以修改所属组关系。

### chown

修改文件的所有者、所属组关系。

```bash
➜  ls -l
-rwxrwxrwx 1 hank hank 148100671 7月   1 15:05 config.atom.zip
➜  sudo chown root config.atom.zip
➜  ls -l
-rwxrwxrwx 1 root hank 148100671 7月   1 15:05 config.atom.zip
```

通过使用`:`符号可以同时修改文件所有者和所属组。

```bash
➜  ~ ll -l
-rwxrwxrwx 1 hank hank 156M 7月   1 15:05 config.vscode.zip
➜  ~ sudo chown root:root config.vscode.zip
➜  ~ ls -l
-rwxrwxrwx 1 root root 162986482 7月   1 15:05 config.vscode.zip
```

### chgrp

修改文件的所属组关系。

```bash
➜  ls -l
-rwxrwxrwx 1 root hank 148100671 7月   1 15:05 config.atom.zip
➜  sudo chgrp root config.atom.zip 
➜  ls -l
-rwxrwxrwx 1 root root 148100671 7月   1 15:05 config.atom.zip
```

## ssh

OpenSSH的SSH客户端，用于登陆远程主机并执行命令行。

```
➜  ssh root@192.168.1.2  
```

## netstat

显示网络连接、路由表、接口统计、伪装连接、多播成员信息。

```bash
➜  netstat -tcp
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 192.168.0.4:41966       sc.10086.com.defa:https ESTABLISHED 18133/chrome
tcp        0      0 192.168.0.4:39476       user.128.220.139.p:http ESTABLISHED 18133/chrome
... ... ...
```

> 相似功能的还有`ss`、`ip`命令。

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

## fdisk

操作磁盘分区表。

* `-l` 列出磁盘的分区表。

```bash
➜  sudo fdisk -l
Disk /dev/sda: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x97c43a12

设备       启动      Start     末尾     扇区   Size Id 类型
/dev/sda1  *          2048  204802047  204800000  97.7G  7 HPFS/NTFS/exFAT
/dev/sda2        204802048  614402047  409600000 195.3G  7 HPFS/NTFS/exFAT
/dev/sda3        614402048 1638402047 1024000000 488.3G  7 HPFS/NTFS/exFAT
/dev/sda4       1638402048 1953521663  315119616 150.3G  7 HPFS/NTFS/exFAT

Disk /dev/sdb: 119.2 GiB, 128035676160 bytes, 250069680 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0xf8545dc0

设备       启动     Start    末尾    扇区   Size Id 类型
/dev/sdb1            2048 225288191 225286144 107.4G 83 Linux
/dev/sdb2       225290238 250068991  24778754  11.8G  5 扩展
/dev/sdb5       225290240 250068991  24778752  11.8G 82 Linux 交换 / Solaris
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

* `-name` 根据文件名称。
* `-type` 根据文件类型。
* `-user` 根据文件拥有者。

```
➜  find -name index.html
./.deploy_git/2017/08/30/article/2017/guiyang-big-data/index.html
./.deploy_git/2017/08/27/article/2017/chengdu-real-estate-1/index.html
./.deploy_git/2017/08/27/article/2017/chengdu-real-estate-2/index.html
./.deploy_git/2017/08/27/article/2017/chengdu-real-estate-3/index.html
... ... ...
```

## locate

通过文件名称在索引数据库中快速查找文件的位置。

```bash
➜  locate /etc/host
/etc/host.conf
/etc/hostname
/etc/hosts
/etc/hosts.allow
/etc/hosts.deny
```

> 大部分Linux发行版的索引数据库都放置在crontab中定时执行更新，但是也可以通过`sudo updatedb`手动的更新。

## grep

搜索目录下文件当中存在的**字符串**，下面例子查询字符串`"hank"`被`./source`目录下哪些文件所使用。

* -R 在指定目录下进行递归查找。

```
➜  grep "hank" -R ./source 
source/linux/command.md:drwxrwxr-x   9 hank hank   4096 8月  31 00:02 .
source/linux/command.md:-rw-rw-r--   1 hank hank   1966 8月  26 18:56 _config.yml
source/linux/command.md:-rw-rw-r--   1 hank hank 505845 8月  31 00:02 db.json
source/linux/command.md:drwxrwxr-x   8 hank hank   4096 8月  31 00:18 .git
source/linux/command.md:-rw-rw-r--   1 hank hank     83 8月  26 02:29 .gitignore
source/linux/command.md:-rw-rw-r--   1 hank hank    277 8月  24 03:15 index.html
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

> 直接在命令行输入`$PATH`也可打印环境变量。

## su / sudo

### su

更改用户ID或切换到root用户。

```bash
➜  su
➜  whoami
root
➜  exit
➜  whoami
hank
```

> 切换到root用户后，可以通过`exit`命令进行退出。

* `-`, `-l`, `--login` 提供类似用户直接登陆的环境。

### sudo

临时获取root用户权限。

```
➜  sudo vim /etc/sudoers
```

> sudo命令需要将用户添加到sudoer组中，一般通过/etc/sudoers文件进行修改。

## uname

打印系统信息。

* `-a` 打印全部的系统信息。

```bash
➜  uname -a
Linux hank-linux 4.12.2-041202-generic #201707150832 SMP Sat Jul 15 12:34:02 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
```

## who / whoami

用户信息显示相关的两条命令。

### who

显示当前登陆到系统的所有用户。

```bash
➜  who
hank     tty7         2017-09-03 12:15 (:0)
hank     pts/0        2017-09-03 12:15 (hank-linux)
hank     pts/1        2017-09-03 23:08 (hank-linux)
hank     pts/2        2017-09-03 23:09 (hank-linux)
hank     pts/3        2017-09-03 23:14 (hank-linux)
hank     pts/4        2017-09-03 23:15 (hank-linux)
```

### whoami

打印当前登陆用户的名称。

```bash
➜  whoami
hank
```

## id

打印用户以及组的ID。

```bash
➜  id root
uid=0(root) gid=0(root) 组=0(root)
```

## groups

显示用户所属组的详细信息。

```bash
➜  groups hank
hank : hank adm cdrom sudo dip plugdev lpadmin sambashare vboxusers
```

## passwd

更改指定用户密码。

```bash
➜  ~ passwd hank
更改 hank 的密码。
```

## useradd / usermod / userdel

添加、设置、删除用户。

```bash
➜  ~ sudo useradd uinika
➜  ~ sudo passwd uinika 
输入新的 UNIX 密码：
➜  ~ sudo userdel uinika
```

* `/etc/passwd`：用户账户信息文件。

```
hank:x:1000:1000:hank.zheng,,,:/home/hank:/usr/bin/zsh
uinika:x:1001:1001::/home/uinika:
```

* `/etc/shadow`：用户账户加密信息文件。

```
hank:$6$qNevDR2S$zGTwRTbPTlB72L8Qj4gbLvFmFnX/UMVP729FYKQEQevjibRoiSYxaprsu1wvdWN3s5VaP0zq581pYTQATMAA0.:17362:0:99999:7:::
uinika:$6$1vI1oFXa$0NDka/ceb6QMSkf9Z8M7S/UUO0dNAEnj2fFP7p2LKlEY.9tVyKxJ4AmRiUevUSzLc/fqyUF.PNQ91Fj4GYXw9.:17412:0:99999:7:::
```

## groupadd / groupmod / groupdel

添加、设置、删除组。

```bash
➜  ~ sudo groupadd zheng
➜  ~ sudo groupmod -g 8888 zheng  // 修改组ID为8888
➜  ~ sudo groupdel zheng
```

* `/etc/group`：组账户信息文件。
```
hank:x:1000:
vboxusers:x:132:hank
zheng:x:8888:
```
* `/etc/gshadow`：组账户加密信息文件。
```
hank:!::
vboxusers:!::hank
zheng:!::
```

## ps / top / kill

Linux进程相关的操作。

### ps

显示一个当前所有进程的快照。

- `-ef` 查看所有进程的PID（*进程号*）、命令详细目录、执行者等信息。

```bash
➜  ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 00:03 ?        00:00:01 /sbin/init splash
root         2     0  0 00:03 ?        00:00:00 [kthreadd]
root         4     2  0 00:03 ?        00:00:00 [kworker/0:0H]
... ... ...
```

- `-aux` 除显示进程信息外，还显示CPU及内存占用率、进程状态。

```bash
➜  ps -aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.1  0.0 185672  6156 ?        Ss   00:03   0:01 /sbin/init splash
root         2  0.0  0.0      0     0 ?        S    00:03   0:00 [kthreadd]
root         4  0.0  0.0      0     0 ?        S<   00:03   0:00 [kworker/0:0H]
... ... ...
```

> 管道Linux进程间通信的重要方式，Shell命令行中，管道线`|`用于连接两个进程的输出和输入。

```bash
➜  blog git:(master) ✗ ps -ef | grep python
hank      1598  1326  0 00:04 ?        00:00:00 /usr/bin/python3 /usr/bin/cinnamon-launcher
hank      1638  1326  0 00:04 ?        00:00:00 /usr/bin/python3 /usr/bin/cinnamon-killer-daemon
hank      1777  1326  0 00:04 ?        00:00:00 /usr/bin/python /usr/bin/blueberry-tray
```

### top

动态显示Linux进程信息。

```bash
➜  top

top - 00:36:54 up 33 min,  2 users,  load average: 0.70, 0.60, 0.48
Tasks: 223 total,   1 running, 221 sleeping,   0 stopped,   1 zombie
%Cpu(s):  1.7 us,  0.7 sy,  0.0 ni, 97.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 12110732 total,  9707752 free,  1079692 used,  1323288 buff/cache
KiB Swap: 12389372 total, 12389372 free,        0 used. 10461888 avail Mem 

PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
1167 root      20   0  430556  90728  64768 S   2.3  0.7   1:09.62 Xorg
1639 hank      20   0  551256  56188  35188 S   2.3  0.5   0:21.21 python2
1613 hank      20   0 2158736 198220  68256 S   1.0  1.6   1:07.52 cinnamon
... ... ...
```

### kill

发送一个信号给进程，可以使用信号名或数字，因此下面例子中的2条命令作用相同。

```bash
➜  kill -9 1639
➜  kill -SIGKILL 1639
```

## which / whereis

查询Linux命令所在的位置。

### which

查询指定Linux命令文件的位置。

```bash
➜  which atom
/usr/bin/atom
```

### whereis

找出指定Linux命令所对应的`binary`、`source`、`manual page`文件。

```bash
➜  whereis tar
tar: /usr/lib/tar /bin/tar /usr/include/tar.h /usr/share/man/man1/tar.1.gz
```

## whois

查询域名注册的详细信息。

```
➜  whois chengdu.gov.cn 
Domain Name: chengdu.gov.cn
ROID: 20021209s10061s00002738-cn
Domain Status: ok
Registrant ID: s77d811mb88kmg
Registrant: 成都市人民政府行政效能建设办公室（成都市人民政府政务公开办公室）
Registrant Contact Email: cpletterbox@126.com
Sponsoring Registrar: 北京新网数码信息技术有限公司
Name Server: ns1.alidns.com
Name Server: ns2.alidns.com
Registration Time: 2001-06-28 00:00:00
Expiration Time: 2018-06-28 00:00:00
DNSSEC: unsigned
```


## crontab

Linux的定时任务通常由守护进程**cron**处理，cron会读取包含命令行及其调用时间的配置文件**crontab文件**（*英文crontab是指定时任务*），该命令就是用来对crontab配置文件执行列出、安装、删除等维护操作的。

```bash
➜  ps -ef | grep cron
root       933     1  0 00:03 ?        00:00:00 /usr/sbin/cron -f
hank     11203  8236  0 02:02 pts/1    00:00:00 grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn cron
```

通过`crontab -u 用户名 file`命令设置定时执行指定的file命令文件。

```bash
➜  crontab -u hank ./test.task
```

缺省文件名的情况下，使用如下参数可以管理crontab。

- `-e` 编辑用户的crontab。
- `-l` 列出用户的crontab。
- `-r` 删除用户的crontab。
- `-i` 删除crontab前弹出提示。

下面的命令例出了用户hank下的定时任务。

```bash
➜  crontab -u hank -l
no crontab for hank
```

## tar

Linux打包（*将多个文件合并为大文件*）或压缩（*将大文件压缩为体积更小的文件*）文件的命令。

### 压缩-cvf系列参数

* `-cvf` 打包文件，需要压缩较多数量的文件时，将文件打包再进行压缩会更加高效。
* `-zcvf` 打包后压缩为gzip格式，速度快压缩率低。
* `-jcvf` 打包后压缩为bzip2格式，速度和压缩率适中。
* `-Jcvf` 打包后压缩为xz格式，压缩率最高，但是速度较慢。

```bash
➜  tar -cvf bundle.tar ./bundle
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  tar -zcvf bundle.tar.gz ./bundle
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  tar -jcvf bundle.tar.bz2 ./bundle
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  tar -Jcvf bundle.tar.xz ./bundle
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  ls -al
drwxrwxr-x 2 hank hank  4096 9月  10 16:14 bundle
-rw-rw-r-- 1 hank hank 10240 9月  10 18:06 bundle.tar
-rw-rw-r-- 1 hank hank   200 9月  10 18:06 bundle.tar.bz2
-rw-rw-r-- 1 hank hank   193 9月  10 18:06 bundle.tar.gz
-rw-rw-r-- 1 hank hank   224 9月  10 18:06 bundle.tar.xz
```

### 解压-xvf系列参数

* `-xvf` 解包tar格式文件到当前目录。
* `-zxvf` 解包并解压缩gzip格式文件。
* `-jxvf` 解包并解压缩解压bzip2格式文件。
* `-Jxvf` 解包并解压缩解压xz格式文件。

```bash
➜  tar -xvf bundle.tar
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  tar -zxvf bundle.tar.gz
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  tar -jxvf bundle.tar.bz2
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  tar -Jxvf bundle.tar.xz
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  ls
bundle  bundle.tar  bundle.tar.bz2  bundle.tar.gz  bundle.tar.xz
```

### 解压-C参数

使用解压参数后添加`-C 目录`可以将文件解压至指定目录。

```bash
➜  ls
bundle.tar.xz  test
➜  tar -Jxvf bundle.tar.xz -C ./test
./bundle/
./bundle/file1
./bundle/file4
./bundle/file5
./bundle/file2
./bundle/file3
➜  tree
├── bundle.tar.xz
└── test
    └── bundle
        ├── file1
        ├── file2
        ├── file3
        ├── file4
        └── file5
```

> 指定的目录必须已经存在。

## zip / unzip

压缩或者解压Windows下常用的**zip格式**压缩文件。

### zip

压缩文件成为zip格式。

```bash
➜  zip bundle.zip ./bundle 
  adding: bundle/ (stored 0%)
➜  ls
bundle  bundle.zip
```

### unzip

解压zip格式的压缩文件。

* `-d` 解压到指定目录。

```bash
➜  ls
bundle.zip
➜  unzip bundle.zip -d ./test
Archive:  bundle.zip
   creating: ./test/bundle/
➜  tree
├── bundle.zip
└── test
    └── bundle
```

## rar / unrar

压缩或者解压Windows下常用的**rar格式**压缩文件。

### rar

压缩指定文件为rar格式。

* `a` 增加指定文件到rar压缩包当中。

```bash
➜  rar a test.rar ./bundle 

RAR 5.30 beta 2   Copyright (c) 1993-2015 Alexander Roshal   4 Aug 2015
Trial version             Type RAR -? for help
Evaluation copy. Please register.
Creating archive test.rar

Adding    ./bundle/file1                                              OK 
Adding    ./bundle/file4                                              OK 
Adding    ./bundle/file5                                              OK 
Adding    ./bundle/file2                                              OK 
Adding    ./bundle/file3                                              OK 
Adding    ./bundle                                                    0%
Done
➜  ls
bundle  test.rar
```

### unrar

解压rar格式的压缩包。

* `e` 解压文件至当前目录。

```bash
➜  unrar e test.rar ./demo 

UNRAR 5.30 beta 2 freeware      Copyright (c) 1993-2015 Alexander Roshal
Extracting from test.rar

Extracting  ./demo/file1                                              OK 
Extracting  ./demo/file4                                              OK 
Extracting  ./demo/file5                                              OK 
Extracting  ./demo/file2                                              OK 
Extracting  ./demo/file3                                              OK 
All OK
```

## 7zr



## df / patch


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