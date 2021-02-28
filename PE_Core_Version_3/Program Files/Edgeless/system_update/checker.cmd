@echo off
echo %time% 检查更新程序-启动 >>X:\Users\Log.txt
title 正在检查Edgeless更新
color 3f
cd /d %~dp0"
set /p vnw=<"X:\Program Files\version.txt"
echo %time% 检查更新程序-wim信息%vnw% >>X:\Users\Log.txt


if %vnw:~9,4%==Alpa goto alpha

if not exist version_ol.txt "X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -o "version_ol.txt" https://pineapple.edgeless.top/api/v2/info/iso_version
::if not exist version_ol.txt "X:\Program Files\Edgeless\EasyDown\EasyDown.exe" -Down("http://s.edgeless.top/?token=version","version_ol.txt","X:\Program Files\Edgeless\system_update")
if not exist version_ol.txt goto df
set /p vol=<version_ol.txt
echo %time% 检查更新程序-在线Beta信息%vol% >>X:\Users\Log.txt

if %vol%==%vnw:~20,5% goto newest
title 发现存在Edgeless更新
cls
echo.
echo.
echo   当前版本：%vnw:~20,5%
echo   最新版本：%vol%
echo =========================================
echo.
echo.
echo  请重启回到正常系统后使用Edgeless Hub更新
echo.
echo.
echo.
echo.
echo.
pause
exit
:ctn
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Npath.txt
set /p Upath=<Npath.txt
echo %time% 检查更新程序-使用%Upath%作为Edgeless盘符 >>X:\Users\Log.txt
if not exist %Upath%:\ (
    echo %time% 检查更新程序-未检测到合法的Edgeless启动盘 >>X:\Users\Log.txt
    cls
    echo      未检测到合法的Edgeless启动盘
    echo   请插入Edgeless启动盘，然后按任意键
    pause
    goto ctn
)
if exist "X:\Program Files\Edgeless\Edgeless Hub\edgeless-hub.exe" goto skipDownHub
title 正在下载Edgeless Hub
echo %time% 检查更新程序-下载Edgeless Hub >>X:\Users\Log.txt
cls
call downloadhub.cmd
pecmd exec="X:\Program Files\Edgeless\plugin_loader\load.cmd" "X:\Program Files\Edgeless\system_update\hub.7z"

if not exist "X:\Program Files\Edgeless\Edgeless Hub\edgeless-hub.exe" (
    echo %time% 检查更新程序-Edgeless Hub未加载（奇怪错误） >>X:\Users\Log.txt
    cls
    title 遇到了很奇怪的问题：Edgeless Hub未加载
    call downloadhub.cmd
    pecmd exec="X:\Program Files\Edgeless\plugin_loader\load.cmd" "X:\Program Files\Edgeless\system_update\hub.7z"
)

:skipDownHub
pecmd link "X:\Users\Default\Desktop\Edgeless Hub.LNK" "X:\Program Files\Edgeless\Edgeless Hub\edgeless-hub.exe"
pecmd exec  "X:\Program Files\Edgeless\Edgeless Hub\edgeless-hub.exe"
exit



:df
title 正在检查网络
ping cloud.tencent.com
if %errorlevel%==1 goto nonet
title Edgeless服务器无响应
echo %time% 检查更新程序-服务器无响应 >>X:\Users\Log.txt
cls
echo.
echo.
echo.
echo         检查失败，Edgeless服务器无响应
echo               请联系作者解决此问题
echo.
echo.
pause
del /f /q version_ol.txt
exit


:nonet
echo %time% 检查更新程序-Edgeless未联网 >>X:\Users\Log.txt
title 无法连接至互联网
cls
echo.
echo.
echo.
echo         检查失败，当前系统未接入互联网
echo.
echo.
echo.
pause
del /f /q version_ol.txt
exit

:newest
echo %time% 检查更新程序-已是最新版本 >>X:\Users\Log.txt
title 当前版本已是最新版本
cls
echo.
echo.
echo.
echo  恭喜，当前版本是最新版本！
echo =========================================
echo 版本信息：
echo 完整版本号：%vnw%
echo 系统名称：%vnw:~0,8%
echo 渠道类型：%vnw:~9,4%
echo 发行版本：%vnw:~14,5%
echo 版本编号：%vnw%
echo =========================================
echo.
echo.
echo.
pause
del /f /q version_ol.txt
exit


:alpha
if not exist "X:\Program Files\Edgeless\system_update\version_ola.txt" "X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -o "version_ola.txt" https://pineapple.edgeless.top/api/v2/alpha/version?token=WDNMD
::if not exist "X:\Program Files\Edgeless\system_update\version_ola.txt" "X:\Program Files\Edgeless\EasyDown\EasyDown.exe" -Down("http://s.edgeless.top/?token=alpha","version_ola.txt","X:\Program Files\Edgeless\system_update")
if not exist "X:\Program Files\Edgeless\system_update\version_ola.txt" goto df
set /p voa=<"X:\Program Files\Edgeless\system_update\version_ola.txt"

if not exist "X:\Program Files\Edgeless\system_update\version_ol.txt" "X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -o "version_ol.txt" https://pineapple.edgeless.top/api/v2/info/iso_version
::if not exist "X:\Program Files\Edgeless\system_update\version_ol.txt" "X:\Program Files\Edgeless\EasyDown\EasyDown.exe" -Down("http://s.edgeless.top/?token=version","version_ol.txt","X:\Program Files\Edgeless\system_update")
if not exist "X:\Program Files\Edgeless\system_update\version_ol.txt" goto df
set /p vol=<"X:\Program Files\Edgeless\system_update\version_ol.txt"

echo %time% 检查更新程序-在线Alpha信息%voa% >>X:\Users\Log.txt
echo %time% 检查更新程序-在线Beta信息%vol% >>X:\Users\Log.txt

title Edgeless Alpha内测版
cls
echo.
echo           Edgeless Alpha内测版
echo        感谢您对Edgeless项目的支持！
echo ===============================================
echo 当前版本：%vnw%
echo 最新版本（Alpha内测）：%voa%
echo 最新版本（Beta 正式）：%vol%
echo ===============================================
echo.
echo  Alpha版本不提供OTA，如果需要更新请手动进行更新
echo.
echo.
pause
exit