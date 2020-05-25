@echo off
echo %time% ept-remove-运行，第一参数：%1，第二参数：%2 >>X:\Users\Log.txt
if not exist X:\Users\ept md X:\Users\ept
if exist X:\Users\ept\List del /f /q X:\Users\ept\List >nul
@copy /y X:\Users\Plugins_info\Preload\List.txt "X:\Users\ept\List" >nul
if not exist "X:\Users\ept\List" echo %time% ept-remove-List拷贝失败！ >>X:\Users\Log.txt
setlocal enabledelayedexpansion
set /a row=0
echo ept-remove 正在读取插件状态信息...
echo %time% ept-remove-开始解析List >>X:\Users\Log.txt
for /f "usebackq delims==; tokens=*" %%i in (X:\Users\ept\List) do (
    set /a row+=1
    if !row!==%1 echo %%i >tmp.txt
)
if not exist tmp.txt (
    echo %time% ept-remove-不存在tmp.txt，跳转至search标签 >>X:\Users\Log.txt
    goto search
)
set /p tar=<tmp.txt
echo %time% ept-remove-tar:%tar% >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt >nul
if /i "%2" neq "-y" CHOICE /C yn /M "您是否确认移除%tar%?"
if %errorlevel%==2 goto end
echo %time% ept-remove-用户确认开始移除 >>X:\Users\Log.txt
echo ept-remove 正在移除%tar%...
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\Plugins_info\Preload\Dir\%tar:~0,-1%.txt") do (
    @del /f /s /q "X:\Program Files\Edgeless\%%i" >nul
)
echo ept-remove 移除完成
echo %time% ept-remove-移除完成 >>X:\Users\Log.txt
goto end


:search
echo ept-remove 命中以下插件
echo %time% ept-remove-运行find，输出如下： >>X:\Users\Log.txt
find /n /i "%1" X:\Users\ept\List >>X:\Users\Log.txt
find /n /i "%1" X:\Users\ept\List
echo ----------
echo 使用   ept remove [序号]    移除

:end
echo %time% ept-remove-任务完成 >>X:\Users\Log.txt
echo on