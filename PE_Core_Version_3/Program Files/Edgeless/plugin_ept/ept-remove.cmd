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
if /i "%2" == "-y" echo ept-remove 将会执行自动移除
set /p tar=<tmp.txt
echo %time% ept-remove-tar:%tar% >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt >nul
if /i "%2" neq "-y" CHOICE /C yn /M "您是否确认移除%tar:~0,-1%?"
if %errorlevel%==2 goto end
echo %time% ept-remove-用户确认开始移除，开始检查插件快捷方式 >>X:\Users\Log.txt

echo ept-remove 正在追溯%tar:~0,-1%创建的快捷方式...
if exist run.wcs del /f /q run.wcs
if exist run.cmd del /f /q run.cmd
if exist "X:\Program Files\Edgeless\run.wcs" del /f /q "X:\Program Files\Edgeless\run.wcs"
if exist "X:\Program Files\Edgeless\run.cmd" del /f /q "X:\Program Files\Edgeless\run.cmd"
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\Plugins_info\Preload\Batch\%tar:~0,-1%.txt") do (
    findstr /i "X:\Users\Default\Desktop" "X:\Program Files\Edgeless\安装程序\%%i">run.wcs
)
echo %time% ept-remove-用于创建快捷方式的语句集合： >>X:\Users\Log.txt
type run.wcs >>X:\Users\Log.txt
if not exist run.wcs (
    echo ept-remove 插件未创建桌面快捷方式
    echo %time% ept-remove-插件未创建桌面快捷方式：不存在run.wcs >>X:\Users\Log.txt
    goto skipRLink
)
set /p nullCheck=<run.wcs
if not defined nullCheck (
    echo ept-remove 插件未创建桌面快捷方式
    echo %time% ept-remove-插件未创建桌面快捷方式：run.wcs为空 >>X:\Users\Log.txt
    goto skipRLink
)
pecmd file X:\Users\Default\Desktop\tmp
if not exist X:\Users\Default\Desktop\tmp md X:\Users\Default\Desktop\tmp
move "X:\Users\Default\Desktop\*.lnk" X:\Users\Default\Desktop\tmp >nul

move /y run.wcs "X:\Program Files\Edgeless\run.wcs" >nul
pecmd load "X:\Program Files\Edgeless\run.wcs"
ren "X:\Program Files\Edgeless\run.wcs" run.cmd
pecmd exec !"X:\Program Files\Edgeless\run.cmd"
del /f /q "X:\Program Files\Edgeless\run.cmd"

if not exist "X:\Users\Default\Desktop\*.lnk" (
    echo ept-remove 当前插件的桌面快捷方式已失效，追溯失败
    echo %time% ept-remove-快捷方式已失效，追溯失败：桌面无.lnk文件 >>X:\Users\Log.txt
    goto skipRLink
)
dir /b "X:\Users\Default\Desktop\*.lnk">link.txt
echo %time% ept-remove-收集到的快捷方式： >>X:\Users\Log.txt
type link.txt >>X:\Users\Log.txt

if exist "X:\Users\Default\Desktop\*.lnk" del /f /q "X:\Users\Default\Desktop\*.lnk"
move X:\Users\Default\Desktop\tmp\*.lnk X:\Users\Default\Desktop >nul
pecmd file X:\Users\Default\Desktop\tmp

if not exist link.txt (
    echo ept-remove 当前插件的桌面快捷方式已失效，追溯失败
    echo %time% ept-remove-快捷方式已失效，追溯失败：link.txt创建失败 >>X:\Users\Log.txt
    goto skipRLink
)
for /f "usebackq delims==; tokens=*" %%i in ("link.txt") do (
    pecmd file "X:\Users\Default\Desktop\%%i"
)
del /f /q link.txt

:skipRLink
echo ept-remove 正在移除%tar:~0,-1%...
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\Plugins_info\Preload\Dir\%tar:~0,-1%.txt") do (
    pecmd file "X:\Program Files\Edgeless\%%i"
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