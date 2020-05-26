@if not exist X:\Users\ept\Index call ept-update
@echo off
echo %time% ept-install-运行，第一参数：%1，第二参数：%2 >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt >nul
if exist name.txt del /f /q name.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul
if exist X:\Users\ept\pack.7zf del /f /q X:\Users\ept\pack.7zf >nul
setlocal enabledelayedexpansion
set /a row=0
echo ept-install 正在读取本地插件索引...
echo %time% ept-install-读取本地插件索引 >>X:\Users\Log.txt
for /f "usebackq delims==; tokens=*" %%i in (X:\Users\ept\Index) do (
    set /a row+=1
    if !row!==%1 echo %%i >tmp.txt
)
if not exist tmp.txt (
    echo %time% ept-install-不存在tmp.txt，重定向至ept-search >>X:\Users\Log.txt
    call ept-search %1 tryhit %2
    @echo off
    goto end
)

echo %time% ept-install-开始解析tmp.txt，内容： >>X:\Users\Log.txt
type tmp.txt >>X:\Users\Log.txt
echo ept-install 正在解析插件信息...
for /f "usebackq delims==_ tokens=1,2,3,4*" %%i in (tmp.txt) do (
    echo %%i>name.txt
    echo %%j>ver.txt
    echo %%k>au.txt
    echo %%l>cate.txt
)
set /p name=<name.txt
set /p ver=<ver.txt
set /p au=<au.txt
set /p cate=<cate.txt
echo %time% ept-install-name:%name%,ver:%ver%,au:%au%,cate:%cate% >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul

if /i "%2" == "-y" echo ept-install 将会执行自动安装
if /i "%2" == "-a" echo ept-install 将会执行自动安装并保存

if /i "%2" == "-y" echo Y >Y.txt
if /i "%2" == "-a" echo Y >Y.txt
if /i "%2" == "-a" echo A >A.txt
if exist Y.txt echo %time% ept-install-Y.txt建立完成 >>X:\Users\Log.txt
if exist A.txt echo %time% ept-install-A.txt建立完成 >>X:\Users\Log.txt

echo ept-install 此插件将被安装：
echo ----------
echo 软件名：%name%
echo 版本号：%ver%
echo 打包者：%au%
echo 分类：%cate%
echo ----------
echo.
if not exist Y.txt CHOICE /C yan /M "您希望开始安装%name%吗?（安装/安装并保存/取消）"
if %errorlevel%==3 goto end
if %errorlevel%==2 echo A >A.txt
echo %time% ept-install-用户确认开始安装，开始下载 >>X:\Users\Log.txt
echo ept-install 正在向服务器发送下载请求...
::pause
"X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -d X:\Users\ept -o pack.7zf "http://s.edgeless.top/ept.php?name=%name%&version=%ver%&author=%au%&category=%cate:~0,-1%"
echo ept-install 正在安装插件包%name%...
echo %time% ept-install-开始安装 >>X:\Users\Log.txt
pecmd exec -min ="%ProgramFiles%\Edgeless\plugin_loader\load.cmd" "X:\Users\ept\pack.7zf"
echo ept-install 已完成%name%的安装任务

if exist A.txt (
    echo "%name%_%ver%_%au%.7z" >savename.txt
    call ept-save.cmd
)


:end
echo %time% ept-install-任务完成 >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt >nul
if exist name.txt del /f /q name.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul
if exist Y.txt del /f /q Y.txt >nul
if exist A.txt del /f /q A.txt >nul
if exist savename.txt del /f /q savename.txt >nul
echo on