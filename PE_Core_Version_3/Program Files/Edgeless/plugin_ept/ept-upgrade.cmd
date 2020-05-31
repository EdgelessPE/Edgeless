@echo off
echo %time% ept-upgrade-运行，第一参数：%1 >>X:\Users\Log.txt
if exist Spath.txt del /f /q Spath.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version_Disk.txt echo %%1>Spath.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Spath.txt
if not exist Spath.txt (
    echo ept-upgrade 请插入有效的Edgeless启动盘
    echo %time% ept-upgrade-没有检测到启动盘 >>X:\Users\Log.txt
    goto endUpgrade
)
if exist Spath.txt del /f /q Spath.txt
echo ept-upgrade 正在对比插件信息...
pecmd load "X:\Program Files\Edgeless\plugin_ept\ept-upgrade.wcs"
if not exist "X:\Users\ept\upgrade\UpgradeList_User.txt" (
    echo ept-upgrade 没有可以升级的插件
    echo %time% ept-upgrade-没有可以升级的插件 >>X:\Users\Log.txt
    goto endUpgrade
)
echo ept-upgrade 检测到如下更新
echo.
echo ----------
type "X:\Users\ept\upgrade\UpgradeList_User.txt"
echo ----------
echo.
if /i "%1" == "-y" echo ept-upgrade 将会执行自动更新
if /i "%1" neq "-y" CHOICE /C yn /M "是否执行更新?"
if %errorlevel%==2 goto endUpgrade
echo %time% ept-upgrade-用户确认进行更新 >>X:\Users\Log.txt

echo Start >X:\Users\ept\upgrade\UpgradeTime.txt

set /p EL_Part=<X:\Users\ept\upgrade\EL_Part.txt
if not defined EL_Part set /p EL_Part=<Spath.txt
if exist Spath.txt del /f /q Spath.txt

echo ept-upgrade 正在转移过期的插件包...
if not exist %EL_Part%:\Edgeless\Resource\过期插件包 md %EL_Part%:\Edgeless\Resource\过期插件包
if not exist %EL_Part%:\Edgeless\Resource\过期插件包 (
    echo ept-upgrade 对%EL_Part%盘的访问遭拒绝
    echo %time% ept-upgrade-对%EL_Part%盘的访问遭拒绝 >>X:\Users\Log.txt
    goto endUpgrade
)
echo ept-upgrade 开始下载更新，手贱点击窗口黑色部分会导致程序暂停
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\UpgradeList_Path.txt") do (
    move /y "%%i" %EL_Part%:\Edgeless\Resource\过期插件包 >nul
)
ren %EL_Part%:\Edgeless\Resource\过期插件包\*.7z *.7zf

for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\UpgradeList_Name.txt") do (
    echo ept-upgrade 正在更新%%i
    pecmd exec =!cmd.exe /c "ept-install %%i -a"
)
if exist X:\Users\ept\upgrade\UpgradeTime.txt del /f /q X:\Users\ept\upgrade\UpgradeTime.txt
echo ept-upgrade 更新完成

:endUpgrade
@echo on