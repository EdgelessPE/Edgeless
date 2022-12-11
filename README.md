<h1 align="center">
  <br>
  <a href="https://home.edgeless.top" alt="logo" ><img src="https://home.edgeless.top/favicon.ico" width="150"/></a>
  <br>
  Edgeless
  <br>
</h1>

<h4 align="center">强大而优雅的 PE 工具<br>同时也许是东半球第一个部分开源的 PE 项目</h4>

<p align="center">
  <a href="https://home.edgeless.top">主页</a> •
  <a href="https://wiki.edgeless.top">文档</a> •
  <a href="https://down.edgeless.top">下载站</a> •
  <a href="https://www.edgeless.top">博客</a> •
  <a href="https://home.edgeless.top/jump/qqg.html">QQ群</a>
</p>

简体中文 | [English](https://github.com/EdgelessPE/Edgeless/blob/master/README_en.md)

## 许可证
Edgeless的**自编代码**基于 [MPL-2.0](https://www.mozilla.org/en-US/MPL/) 协议开源，除了 `setTheme.cmd`。

>根据 MPL-2.0 协议，所有使用了 Edgeless 自编代码的项目均需要注明版权信息（可以是本仓库链接 [https://github.com/EdgelessPE/Edgeless](https://github.com/EdgelessPE/Edgeless) 或是 Edgeless 主页链接 [https://home.edgeless.top/](https://home.edgeless.top/)，不遵守此条款的项目会被视为侵权项目，Edgeless 团队保留对侵权项目的盗用追究权利。

> 显然本仓库内包含的文件不全是 Edgeless 的自编代码。

> 虽然 `setTheme.cmd` 不开源，但是我们不反对对此脚本的复刻行为。


## 如何使用
### 构建 4.x 版本内核
查看仓库 [EdgelessPE/wimbuilder-component](https://github.com/EdgelessPE/wimbuilder-component)。
### 构建 3.x 版本内核
克隆此仓库，然后将 `Core` 部分的文件夹覆盖复制到您的 PE 项目文件夹中并进行问题检修工作。
>我们不建议缺乏 Windows 系统 和 WinPE 基础知识的使用者进行此工作。

此外，您的 PE 需要添加 PECMD 支持并完成构建，我们推荐使用 `Wimbuilder` 系列软件构建您的 PE 核心。

## 获取发行和组件
请前往[主页](https://home.edgeless.top)或[下载站](https://down.edgeless.top)查看。
>核心版本号最后一位不为 0 的版本为 Alpha 内测版本（例如 3.1.2），需要持有[内测邀请码](https://home.edgeless.top/jump/qqg.html)获取。

## 插件包使用授权
尽管我们的源代码是开源的，但是您在使用我们提供的下载站提供插件包时用到了我们提供的服务，而这一服务需要授权，[点击此处](https://wiki.edgeless.top/v2/cooperation/permit.html)查看授权细则。

## 其他类型的授权
[点击此处](https://wiki.edgeless.top/v2/cooperation/permit.html)查看其他授权细则。

## Awesome Edgeless
查看 Edgeless 生态中值得注意的一些项目👇

* [Edgeless Hub](https://github.com/EdgelessPE/edgeless-hub) -🚀 Edgeless 聚合桌面客户端
* [Edgeless Bot](https://github.com/EdgelessPE/edgeless-bot) -🤖 每日检查上游更新并自动构建插件包
* [what-did-ventoy-do](https://github.com/EdgelessPE/what-did-ventoy-do) - 分析 Ventoy2Disk 日志以获取 Ventoy 信息