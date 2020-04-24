echo %time% 插件包下载程序-checknet-检查网络 >>X:\Users\Log.txt
title 正在检查网络连接情况
ping cloud.tencent.com
if %errorlevel%==1 goto nonet
title Edgeless服务器无响应
echo %time% 检查更新程序-checknet-服务器无响应 >>X:\Users\Log.txt
cls
echo.
echo.
echo.
echo         下载失败，Edgeless服务器无响应
echo               请联系作者解决此问题
echo.
echo.
pause
exit


:nonet
title 无法连接至互联网
echo %time% 检查更新程序-checknet-Edgeless未联网 >>X:\Users\Log.txt
cls
echo.
echo.
echo.
echo         下载失败，当前系统未接入互联网
echo.
echo.
echo.
pause
exit