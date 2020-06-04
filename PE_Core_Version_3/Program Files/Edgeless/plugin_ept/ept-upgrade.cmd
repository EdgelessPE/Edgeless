@echo off
echo %time% ept-upgrade-运行，第一参数：%1 >>X:\Users\Log.txt
set /a retryTime=0
if exist Spath.txt del /f /q Spath.txt
if exist Y_u.txt del /f /q Y_u.txt
if exist X:\Users\ept\upgrade\DontLoad.txt del /f /q X:\Users\ept\upgrade\DontLoad.txt
if exist X:\Users\ept\upgrade\Retry.txt del /f /q X:\Users\ept\upgrade\Retry.txt
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
    if not exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt echo ept-upgrade 没有可以升级的插件
    echo %time% ept-upgrade-没有可以升级的插件 >>X:\Users\Log.txt
    if exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt (
        echo %time% ept-upgrade-存在未知插件，列出： >>X:\Users\Log.txt
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt >>X:\Users\Log.txt
        echo ept-upgrade 没有可以升级的插件，不过ept注意到有一些无法识别的插件，请手动关注其更新情况：
        echo.
        echo ----------
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt
        echo ----------
        echo.
    )
    goto endUpgrade
)
echo ept-upgrade 检测到如下更新
echo.
echo ----------
type "X:\Users\ept\upgrade\UpgradeList_User.txt"
echo ----------
echo.

if /i "%1" == "-y" echo ept-upgrade 将会执行自动更新
if /i "%1" == "-b" echo ept-upgrade 将会执行自动更新但是不加载
if /i "%1" == "-y" echo Y >Y_u.txt
if /i "%1" == "-b" echo Y >Y_u.txt
if /i "%1" == "-b" echo B >X:\Users\ept\upgrade\DontLoad.txt
if exist Y_u.txt echo %time% ept-upgrade-Y_u.txt建立完成 >>X:\Users\Log.txt

if not exist Y_u.txt CHOICE /C ybn /M "您希望开始执行更新吗?（更新/仅下载/取消）"
if %errorlevel%==3 goto endUpgrade
if %errorlevel%==2 echo B >X:\Users\ept\upgrade\DontLoad.txt
echo %time% ept-upgrade-用户确认进行更新，选择：%errorlevel% >>X:\Users\Log.txt
if exist X:\Users\ept\upgrade\DontLoad.txt echo %time% ept-upgrade-DontLoad.txt建立完成 >>X:\Users\Log.txt

echo Start >X:\Users\ept\upgrade\UpgradeTime.txt

set /p EL_Part=<X:\Users\ept\upgrade\EL_Part.txt
if not defined EL_Part set /p EL_Part=<Spath.txt
if exist Spath.txt del /f /q Spath.txt

if not defined EL_Part (
    echo ept-upgrade 奇怪的错误：Edgeless盘符未定义
    echo %time% ept-upgrade-奇怪的错误：Edgeless盘符未定义 >>X:\Users\Log.txt
    goto endUpgrade
)

echo ept-upgrade 正在转移过期的插件包...
if not exist %EL_Part%:\Edgeless\Resource\过期插件包 md %EL_Part%:\Edgeless\Resource\过期插件包
if not exist %EL_Part%:\Edgeless\Resource\过期插件包 (
    echo ept-upgrade 对%EL_Part%盘的访问遭拒绝，请检查后重试
    echo %time% ept-upgrade-对%EL_Part%盘的访问遭拒绝 >>X:\Users\Log.txt
    goto endUpgrade
)
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\UpgradeList_Path.txt") do (
    move /y "%%i" %EL_Part%:\Edgeless\Resource\过期插件包 >nul
)
ren %EL_Part%:\Edgeless\Resource\过期插件包\*.7z *.7zf


echo ept-upgrade 开始下载更新，手贱点击窗口黑色部分会导致程序暂停
:reDown
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\UpgradeList_Name.txt") do (
    echo ept-upgrade 正在更新%%i
    if exist X:\Users\ept\DownloadFail.txt del /f /q X:\Users\ept\DownloadFail.txt >nul
    if exist X:\Users\ept\SaveFail.txt del /f /q X:\Users\ept\SaveFail.txt >nul
    pecmd exec =!cmd.exe /c "ept-install %%i -a"
    if exist X:\Users\ept\DownloadFail.txt (
        echo ept-upgrade =============错误：下载%%i失败=============
        echo.
        echo %time% ept-upgrade-错误：下载%%i失败 >>X:\Users\Log.txt
        echo %%i>>X:\Users\ept\upgrade\Retry.txt
    )
    if exist X:\Users\ept\SaveFail.txt (
        echo ept-upgrade =============错误：保存%%i失败=============
        echo.
        echo %time% ept-upgrade-错误：保存%%i失败 >>X:\Users\Log.txt
        echo %%i>>X:\Users\ept\upgrade\Retry.txt
    )
)
echo %time% ept-upgrade-当前轮下载任务完成，检查需要重试的插件 >>X:\Users\Log.txt
if "%retryTime%"=="1" (
    if exist Y_u.txt (
        echo %time% ept-upgrade-自动模式，当前已经重试一次，自动退出 >>X:\Users\Log.txt
        echo ept-upgrade 重试自动结束，以下插件的更新失败，请手动启用旧版本：
        type X:\Users\ept\upgrade\Retry.txt
        goto endUpgrade
    )
)
if not exist X:\Users\ept\upgrade\Retry.txt goto skipRetry

    echo ept-upgrade 准备开始对失败的项目进行重试，当前重试次数：%retryTime%，需要重试的插件有：
    type X:\Users\ept\upgrade\Retry.txt
    if not exist Y_u.txt CHOICE /C yn /M "您希望开始重试吗?（确认/取消）"
    echo.
    if %errorlevel%==2 (
        echo ept-upgrade 以下插件的更新失败，请手动启用旧版本（Resource目录下的“过期插件包”文件夹）：
        type X:\Users\ept\upgrade\Retry.txt
        goto endUpgrade
    )
    set /a retryTime+=1
    echo %time% ept-upgrade-开始对失败的项目重试，重试次数：%retryTime%，需要重试的插件有： >>X:\Users\Log.txt
    type X:\Users\ept\upgrade\Retry.txt >>X:\Users\Log.txt
    if exist X:\Users\ept\upgrade\UpgradeList_Name.txt del /f /q X:\Users\ept\upgrade\UpgradeList_Name.txt
    ren X:\Users\ept\upgrade\Retry.txt UpgradeList_Name.txt
    goto reDown

:skipRetry
if exist X:\Users\ept\upgrade\UpgradeTime.txt del /f /q X:\Users\ept\upgrade\UpgradeTime.txt
if exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt (
    echo ept-upgrade 更新完成，不过ept注意到有一些无法识别的插件，请手动关注其更新情况：
        echo %time% ept-upgrade-存在未知插件，列出： >>X:\Users\Log.txt
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt >>X:\Users\Log.txt
        echo.
        echo ----------
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt
        echo ----------
        echo.
)
if not exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt echo ept-upgrade 更新完成

:endUpgrade
if exist X:\Users\ept\upgrade\Retry.txt del /f /q X:\Users\ept\upgrade\Retry.txt
@echo on