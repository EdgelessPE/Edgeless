@echo off
echo %time% ept-help-运行 >>X:\Users\Log.txt
echo.
echo Edgeless插件包管理工具
echo.
echo 语法：
echo    ept install 或 ept-install 或 ept-get install [序号] {-y /-a}/[关键词]
echo        安装指定序号插件或搜索插件，参数-y表自动安装，参数-a表自动安装并保存
echo.
echo    ept search 或 ept-search 或 ept-cache search [关键词]
echo        搜索插件
echo.
echo    ept remove 或 ept-remove 或 ept-get remove [序号] {-y}/[关键词]
echo        移除指定序号插件或查找已加载的插件，参数-y表自动移除
echo.
echo    ept update 或 ept-update 或 ept-get update
echo        更新本地索引
echo.
@echo on