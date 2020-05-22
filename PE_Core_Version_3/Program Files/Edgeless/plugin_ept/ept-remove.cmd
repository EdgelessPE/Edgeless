@echo off
@del /f /q List >nul
@copy /y X:\Users\Plugins_info\Preload\List.txt "%~dp0List" >nul
setlocal enabledelayedexpansion
set /a row=0
for /f "usebackq delims==; tokens=*" %%i in (List) do (
    set /a row+=1
    if !row!==%1 echo %%i >tmp.txt
)
if not exist tmp.txt (
    goto search
)
set /p tar=<tmp.txt
@del /f /q tmp.txt >nul
CHOICE /C yn /M "是否确认移除%tar%？"
if %errorlevel%==2 goto end
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\Plugins_info\Preload\Dir\%tar:~0,-1%.txt") do (
    del /f /s /q "X:\Program Files\Edgeless\%%i"
    rd /s /q "X:\Program Files\Edgeless\%%i"
)
echo ----------
echo 移除完成
goto end


:search
echo ept-remove 命中以下插件
find /n /i "%1" List
echo ----------
echo 使用   ept-remove [序号]    移除

:end
echo on