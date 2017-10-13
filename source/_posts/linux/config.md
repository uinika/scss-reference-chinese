---
title: Linux开发环境个性化配置
tags: Embedded
categories: Linux
---

## Mount NTFS

```bash
sudo apt-get install ntfs-3g
sudo ntfsfix /dev/sda1
sudo ntfsfix /dev/sda2
sudo ntfsfix /dev/sda3
sudo ntfsfix /dev/sda4
```

## VSCode

```javascript
{
  "workbench.statusBar.visible": false,
  "workbench.activityBar.visible": true,
  "editor.tabSize": 2,
  "editor.fontSize": 12,
  "editor.fontFamily": "Source Code Pro, Consolas, Ubuntu mono",
  "window.zoomLevel": 0,
  "beautify.tabSize": 2,
  "editor.dragAndDrop": false,
  "window.openFilesInNewWindow": "on",
  "explorer.openEditors.visible": 0,
  "editor.lineHeight": 19,
  "typescript.check.tscVersion": false,
  "window.menuBarVisibility": "toggle",
  "workbench.welcome.enabled": false,
  "editor.wordWrap": "on",
  "editor.wordWrapColumn": 100,
  "editor.minimap.enabled": false,
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "Monokai",
  "editor.renderWhitespace": "boundary",
  "vsicons.dontShowNewVersionMessage": true,
  "material-icon-theme.showUpdateMessage": false,
  "emmet.syntaxProfiles": {
    "vue-html": "html",
    "vue": "html"
  }
}
```

<!-- more -->

## DEB Packages

```bash
sudo apt-get install nginx autoconf git goldendict gcolor2 terminator guake tree tmux build-essential vim p7zip wireshark filezilla kchmviewer synaptic emacs uget shutter audacious alacarte okular putty ddd fcitx-table-wbpy whois darktable unrar rar calibre vokoscreen chromium-browser darktable inkscape gimp
sudo apt-get install libreoffice-l10n-zh-cn libreoffice-help-zh-cn thunderbird-locale-zh-cn thunderbird-locale-zh-hans firefox-locale-zh-hans language-pack-gnome-zh-hans language-pack-zh-hans
sudo apt-get install minicom lib32z1 lib32ncurses5 lib32stdc++6
sudo apt-get install audacity blender
sudo apt-get install classicmenu-indicator unity-tweak-tool
sudo apt-get install ttf-wqy-zenhei
```

## Z-Shell

```bash
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
- OR -
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

## Vim

```bash
git clone https://github.com/wklken/k-vim.git
sudo apt-get install ctags build-essential cmake python-dev silversearcher-ag
cd k-vim/
sh -x install.sh
```

### Reinstall YCM

```bash
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
```

## Root Password

```bash
sudo passwd root
```

## USB Support for Virtualbox

```bash
sudo adduser hank vboxusers
```

## Color of Ubuntu

```bash
Ubuntu [灰]   #42413C
Stardict [黄]   #f0e8c9
```

## Environment Variable

```bash
sudo vim /etc/profile
export PATH=$PATH:/opt/jdk/bin:/opt/nodejs/bin:/opt/mongodb/bin
export JAVA_HOME=/opt/jdk/ 
source /etc/profile
```

## Stardict

```bash
sudo cp -a * /usr/share/stardict/dic
```
 
## Git

```bash
git config --global user.name 'hank.zheng'
git config --global user.email uinika@outlook.com
git config --global core.editor vim
```

### .gitconfig

```
[user]
  name = hank.zheng
  email = uinika@outlook.com
[core]
 editor = vim
 autocrlf = false
[alias]
  st = status
  sts = stash
  cm = commit
  cko = checkout
  df = diff
  br = branch
  ps = push
  pl = pull
  lg = log
  ad = add
  cl = clone
  mg = merge
  sh = show
[push]
  default = matching
[credential]
  helper = store
[branch]
  autosetuprebase = always
```

## Nginx

```bash
sudo vim /etc/nginx/nginx.conf
```

```bash
include /home/hank/nginx.conf
```

### nginx.conf for linux

```javascript
  server {
    listen 1985;
    root /opt/manual/angular;
  }
  server {
    listen 1986;
    root /opt/manual/es6-tutorial;
  }
  server {
    listen 1987;
    root /opt/manual/vuejs;
  }
```

### nginx.conf for windows

```javascript
  server {
    listen 1985;
    root D:\manual\angular;
  }
  server {
    listen 1986;
    root D:\manual\es6-tutorial;
  }
  server {
    listen 1987;
    root D:\manual\vuejs;
  }
```

## Atom Plugins

```bash
apm i angularjs atom-backbone atom-beautify atom-typescript color-picker emmet file-icons langular-babel monokai nerd-treeview pigments vim-mode
```

## Fonts

### [Source Code Pro](https://github.com/adobe-fonts/source-code-pro)

```bash
sudo mkdir /usr/share/fonts/ms_fonts
sudo cp *.ttf /usr/share/fonts/ms_fonts
sudo chmod 644 /usr/share/fonts/ms_fonts/*
cd /usr/share/fonts/ms_fonts/
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
```

## Ubuntu source list in China

```bash
deb http://cn.archive.ubuntu.com/ubuntu/ xenial main restricted
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-updates main restricted
deb http://cn.archive.ubuntu.com/ubuntu/ xenial universe
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-updates universe
deb http://cn.archive.ubuntu.com/ubuntu/ xenial multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-updates multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu xenial-security main restricted
deb http://security.ubuntu.com/ubuntu xenial-security universe
deb http://security.ubuntu.com/ubuntu xenial-security multiverse
```

## Fix Input-method Issue for Mint18.x 

```bash
sudo apt-get remove fonts-arphic-ukai fonts-arphic-uming
sudo apt-get remove fcitx-ui-qimpanel
```

## Notepadqq Official PPA

```bash
sudo add-apt-repository ppa:notepadqq-team/notepadqq
sudo apt-get update
sudo apt-get install notepadqq
```

## Adobe Flash

```bash
sudo apt-get install flashplugin-installer
```