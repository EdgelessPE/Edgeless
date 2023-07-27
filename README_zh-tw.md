<h1 align="center">
  <br>
  <a href="https://home.edgeless.top" alt="logo" ><img src="https://home.edgeless.top/favicon.ico" width="150"/></a>
  <br>
  Edgeless
  <br>
</h1>

<h4 align="center">强大而優雅的 PE 工具<br>同時也許是東半球第一個部分開源的 PE 項目</h4>

<p align="center">
  <a href="https://home.edgeless.top">主頁</a> •
  <a href="https://wiki.edgeless.top">檔案</a> •
  <a href="https://down.edgeless.top">下載站</a> •
  <a href="https://www.edgeless.top">博客</a> •
  <a href="https://home.edgeless.top/jump/qqg.html">QQ群</a>
</p>

[简体中文](https://github.com/EdgelessPE/Edgeless/blob/master/README.md) | 繁體中文 | [English](https://github.com/EdgelessPE/Edgeless/blob/master/README_en.md)

## 许可证
Edgeless的**自編代碼**基於 [MPL-2.0](https://www.mozilla.org/en-US/MPL/) 協議開源，除了 `setTheme.cmd`。

>根據 MPL-2.0 協議，所有使用了 Edgeless 自編代碼的項目均需要注明版權信息（可以是本倉庫鏈接 [https://github.com/EdgelessPE/Edgeless](https://github.com/EdgelessPE/Edgeless) 或是 Edgeless 主頁鏈接 [https://home.edgeless.top/](https://home.edgeless.top/)，不遵守此條款的項目會被視爲侵權項目，Edgeless 團隊保留對侵權項目的盜用追究權利。

> 顯然本倉庫內包含的文件不全是 Edgeless 的自編代碼。

> 雖然 `setTheme.cmd` 不開源，但是我們不反對對此腳本的複刻行爲。


## 如何使用
### 構建 4.x 版本內核
查看倉庫 [EdgelessPE/wimbuilder-component](https://github.com/EdgelessPE/wimbuilder-component)。
### 構建 3.x 版本內核
克隆此倉庫，然後將 `Core` 部分的文件夾覆蓋複製到您的 PE 項目文件夾中並進行問題檢修工作。
>我們不建議缺乏 Windows 繫統 和 WinPE 基礎知識的使用者進行此工作。

此外，您的 PE 需要添加 PECMD 支持並完成構建，我們推薦使用 `Wimbuilder` 繫列軟件構建您的 PE 核心。

## 獲取髮行和組件
請前往[主頁](https://home.edgeless.top)或[下載站](https://down.edgeless.top)查看。
>核心版本號最後一位不爲 0 的版本爲 Alpha 內測版本（例如 3.1.2），需要持有[內測邀請碼](https://home.edgeless.top/jump/qqg.html)獲取。

## 插件包使用授權
儘管我們的源代碼是開源的，但是您在使用我們提供的下載站提供插件包時用到了我們提供的服務，而這一服務需要授權，[點擊此處](https://wiki.edgeless.top/v2/cooperation/permit.html)查看授權細則。

## 其他類型的授權
[點擊此處](https://wiki.edgeless.top/v2/cooperation/permit.html)查看其他授權細則。

## Awesome Edgeless
查看 Edgeless 生態中值得注意的一些項目👇

* [Edgeless Hub](https://github.com/EdgelessPE/edgeless-hub) -🚀 Edgeless 聚合桌麵客戶端
* [Edgeless Bot](https://github.com/EdgelessPE/edgeless-bot) -🤖 每日檢查上遊更新並自動構建插件包
* [what-did-ventoy-do](https://github.com/EdgelessPE/what-did-ventoy-do) - 分析 Ventoy2Disk 日誌以獲取 Ventoy 信息