@echo off
echo %time% load.cmd-运行，第一参数：%1 >>X:\Users\Log.txt
echo %1 >X:\Users\tarplug.txt
set /p t=<X:\Users\tarplug.txt
echo %time% load.cmd-运行，清洗后的参数：%t%，去引号的参数：%t:~1,-2%，调用load.wcs >>X:\Users\Log.txt
echo %t:~1,-2%>X:\Users\tarplug.txt
echo 正在热加载插件，请稍候...
pecmd load "X:\Program Files\Edgeless\plugin_loader\load.wcs"
del /f /q X:\Users\tarplug.txt
echo %time% load.cmd-任务完成 >>X:\Users\Log.txt