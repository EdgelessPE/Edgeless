@if not exist X:\Users\ept\Index call ept-update
@echo off
echo %time% ept-search-运行，第一参数：%1 >>X:\Users\Log.txt
echo %time% ept-search-运行find，输出如下： >>X:\Users\Log.txt
find /n /i "%1" X:\Users\ept\Index >>X:\Users\Log.txt

echo ept-search 在本地索引中命中以下插件
find /n /i "%1" X:\Users\ept\Index
echo ----------
echo.
echo 使用   ept install [序号]    安装
echo %time% ept-search-任务完成 >>X:\Users\Log.txt
echo on