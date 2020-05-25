@echo off
echo %time% ept-help-运行 >>X:\Users\Log.txt
echo.
echo Edgeless插件包管理工具
echo.
echo 语法：
echo    ept install 或 ept-install 或 ept-get install [序号]/[关键词] {-y}
echo        安装指定序号插件或搜索插件，可以使用-y跳过确认
echo.
echo    ept search 或 ept-search 或 ept-cache search [关键词]
echo        搜索插件
echo.
echo    ept remove 或 ept-remove 或 ept-get remove [序号]/[关键词] {-y}
echo        移除指定序号插件或查找已加载的插件，可以使用-y跳过确认
echo.
echo    ept update 或 ept-update 或 ept-get update
echo        更新本地索引
echo.
@echo on