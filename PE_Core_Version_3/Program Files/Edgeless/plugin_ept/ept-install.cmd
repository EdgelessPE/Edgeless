@if not exist X:\Users\Data call ept-update
@echo off
if exist tmp.txt del /f /q tmp.txt >nul
if exist name.txt del /f /q name.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul
if exist X:\Users\pack.7zf del /f /q X:\Users\pack.7zf >nul
setlocal enabledelayedexpansion
set /a row=0
for /f "usebackq delims==; tokens=*" %%i in (X:\Users\Data) do (
    set /a row+=1
    if !row!==%1 echo %%i >tmp.txt
)
if not exist tmp.txt (
    call ept-search %1
    @echo off
    goto end
)

for /f "usebackq delims==_ tokens=1,2,3,4*" %%i in (tmp.txt) do (
    echo %%i>name.txt
    echo %%j>ver.txt
    echo %%k>au.txt
    echo %%l>cate.txt
)
echo ----------
set /p name=<name.txt
set /p ver=<ver.txt
set /p au=<au.txt
set /p cate=<cate.txt

echo ept-install 命中序号%1对应的插件
echo 软件名：%name%
echo 版本号：%ver%
echo 打包者：%au%
echo 分类：%cate%
echo ----------
CHOICE /C yn /M "是否开始安装%name%？"
if %errorlevel%==2 goto end
echo 正在向服务器发送下载请求
::pause
"X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -d X:\Users -o pack.7zf "http://s.edgeless.top/ept.php?name=%name%&version=%ver%&author=%au%&category=%cate:~0,-1%"
echo 正在安装插件包
pecmd exec ="%ProgramFiles%\Edgeless\plugin_loader\load.cmd" "X:\Users\pack.7zf"
echo ----------
echo 安装完成
:end
if exist tmp.txt del /f /q tmp.txt >nul
if exist name.txt del /f /q name.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul
echo on