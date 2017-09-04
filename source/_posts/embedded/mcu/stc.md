---
title: STC90C516RD+单片机
tags: Embedded
categories: Note
---

## MCS-51单片机

兼容Intel MCS-51体系架构的一系列单片机，全球有众多的半导体厂商都有基于这一体系的产品，例如Atmel的AT89C52， NXP的P89V51，宏晶科技的STC90C516RD+。

### 单片机供开发者使用的三大资源：

1. **Flash** 闪存（*Flash Memory*），主要分为NOR和NADN两种类型，可以在断电条件下存放用户的程序和数据，STC90C516RD+内部集成61K的Flash程序存储器。

> 早机单片机使用ROM（*Read Only Memory*）存储器来保存程序。

2. **RAM** 随机存取存储器（*Random Access Memory*），用于存放程序执行的中间结果和过程数据，掉电后存储内容丢失，STC90C516RD+内部集成了1280字节的RAM。

> DDR（*Double Data Rate SDRAM*）属于RAM的一种类型。

3. **SFR** 特殊功能寄存器（*Special Function Register*），对片内各功能模块进行管理、控制、监视的`控制寄存器`和`状态寄存器`。

### 寻址方式

处理器根据指令中给出的地址信息来寻找物理地址的方式，是确定本条指令的数据地址以及下一条要执行的指令地址的方法。 

间接寻址 & 直接寻址

可位寻址 & 不可位寻址

STC90C516RD+属于5V单片机，工作电压在5.5-3.3V。

keil开发环境中选择Intel 8052编译，头文件包含<reg51.h>即可。
