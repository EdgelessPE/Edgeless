@echo off
cd /d "%~dp0"
echo %time% Disk_Installer-运行 >>X:\Users\Log.txt
title Edgeless硬盘版安装器
color 3f
cls
echo.
echo 在本地系统上安装Edgeless之后，您可以在无U盘情况下进入Edgeless
echo 目前仅支持Win8/8.1/10系统安装
echo.
echo 按任意键开始扫描本地系统
pause >nul

::检查已有的更新
echo %time% Disk_Installer-用户按下任意键，检查已安装的更新 >>X:\Users\Log.txt
del /f /q UPdateP.txt
for %%1 in (C D E F G H I J K L M N O P Q R S T U V W Y Z ) do if exist %%1:\Edgeless\version_Disk.txt echo %%1>UPdateP.txt
set /p UPdatePath=<UPdateP.txt
del /f /q UPdateP.txt
if not defined UPdatePath goto scan
set /p version_usb=<"X:\Program Files\version.txt"
set /p version_disk=<%UPdatePath%:\Edgeless\version_Disk.txt
echo %time% Disk_Installer-读取信息，UPdatePath：%UPdatePath%，version_usb：%version_usb%，version_disk：%version_disk% >>X:\Users\Log.txt
if "%version_disk%"=="%version_usb%" goto newest
echo %time% Disk_Installer-%UPdatePath%盘的Edgeless可更新 >>X:\Users\Log.txt
title 有可用的Edgeless硬盘版更新：%UPdatePath%盘
cls
echo.
echo      发现%UPdatePath%盘可更新Edgeless
echo.
echo   本地版本：%version_disk%
echo   U盘版本：%version_usb%
echo =========================================
echo.
pause
goto scan

:scan
echo %time% Disk_Installer-开始扫描本地磁盘，扫描结果如下： >>X:\Users\Log.txt
del /f /q DiskList.txt
for %%1 in (C D E F G H I J K L M N O P Q R S T U V W Y Z ) do if exist %%1:\Recovery\WindowsRE\Winre.wim echo %%1 >>DiskList.txt
type DiskList.txt >>X:\Users\Log.txt
if not exist DiskList.txt (
    cls
    echo 未发现可以安装的硬盘
)
if exist DiskList.txt (
    cls
    echo.
    echo 扫描到以下盘符的Windows可以安装Edgeless硬盘版
    echo ==========================================
    type DiskList.txt
    echo ==========================================
)

echo.
echo 如果使用了精简版系统或上一次程序被提前结束，扫描时可能不会列出，请手动输入盘符
echo.
echo.
set /p a=输入目标系统的盘符并回车：
echo %time% Disk_Installer-用户输入了目标盘符：%a% >>X:\Users\Log.txt

if not defined a goto scan
if not exist %a%:\ (
    echo %time% Disk_Installer-%a%盘不存在 >>X:\Users\Log.txt
    cls
    echo.
    echo 错误：不存在%a%盘
    echo.
    pause
    goto scan
)
if not exist %a%:\Recovery\WindowsRE\Winre.wim (
    echo %time% Disk_Installer-%a%盘不存在Winre.wim，显示警告 >>X:\Users\Log.txt
    cls
    echo.
    echo 警告：%a%盘上的系统可能不支持安装Edgeless硬盘版，按任意键继续
    pause >nul
)

::扫描EdgelessU盘
:reCheckELU
echo %time% Disk_Installer-开始扫描EdgelessU盘 >>X:\Users\Log.txt
del /f /q Upath.txt >nul
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Upath.txt
set /p Upath=<Upath.txt
echo %time% Disk_Installer-使用%Upath%%作为Edgeless盘符 >>X:\Users\Log.txt
if not defined Upath (
    echo %time% Disk_Installer-要求插入U盘 >>X:\Users\Log.txt
    cls
    echo.
    echo 请插入Edgeless启动盘，然后按任意键继续
    pause >nul
    goto reCheckELU
)

::找出最新的wim文件

::列出所有.wim文件
dir /b %Upath%:\*.wim >1.tmp

::查找Edgeless_Beta开头的文件
findstr /b /c:"Edgeless_Beta_" 1.tmp >2.tmp

::找出版本号最高的
set maxVer=1.0.0
for /f "usebackq delims==_ tokens=1,2,3*" %%i in (2.tmp) do (
    if "!maxVer!" lss "%%~nk" set "maxVer=%%~nk"
)
echo %time% Disk_Installer-最新版wim文件为：Edgeless_Beta_%maxVer%.wim >>X:\Users\Log.txt
del /f /q *.tmp

if not exist %Upath%:\Edgeless_Beta_%maxVer%.wim (
    echo %time% Disk_Installer-不存在Edgeless_Beta_%maxVer%.wim，校验失败 >>X:\Users\Log.txt
    cls
    echo.
    echo %Upath%上的启动盘不包含符合文件命名规范的.wim启动文件，无法继续操作
    echo 不存在%Upath%:\Edgeless_Beta_%maxVer%.wim
    pause >nul
    exit
)

::备份原Winre文件
echo %time% Disk_Installer-开始备份原Winre文件 >>X:\Users\Log.txt
takeown /f %a%:\Recovery\WindowsRE\Winre.wim
attrib -s -a -h -r %a%:\Recovery\WindowsRE\Winre.wim
if not exist %a%:\Recovery\WindowsRE\Winre.wim.bak ren %a%:\Recovery\WindowsRE\Winre.wim Winre.wim.bak
if exist %a%:\Recovery\WindowsRE\Winre.wim.bak del /f /q %a%:\Recovery\WindowsRE\Winre.wim
:checkRen
if exist %a%:\Recovery\WindowsRE\Winre.wim (
    echo %time% Disk_Installer-备份Winre.wim失败 >>X:\Users\Log.txt
    explorer %a%:\Recovery\WindowsRE
    cls
    echo.
    echo 重命名%a%:\Recovery\WindowsRE\Winre.wim失败
    echo 请手动将其重命名为Winre.wim.bak
    echo.
    pause
    goto checkRen
)

::复制boot.wim
:copyCheckWim
echo %time% Disk_Installer-开始复制boot.wim >>X:\Users\Log.txt
title 正在复制Edgeless核心
cls
echo 正在复制Edgeless核心...
copy /y %Upath%:\Edgeless_Beta_%maxVer%.wim %a%:\Recovery\WindowsRE\Winre.wim
    if not exist %a%:\Recovery\WindowsRE\Winre.wim (
    echo %time% Disk_Installer-复制boot.wim失败 >>X:\Users\Log.txt
        explorer %a%:\Recovery\WindowsRE
        echo ==================================================================================================
        echo 拷贝%Upath%:\Edgeless_Beta_%maxVer%.wim至%a%:\Recovery\WindowsRE\Winre.wim失败，请手动复制或按任意键重试
        echo ==================================================================================================
        pause >nul
        goto copyCheckWim
    )
::复制Edgeless文件夹
:copyCheckEL
echo %time% Disk_Installer-开始复制Edgeless文件夹 >>X:\Users\Log.txt
title 正在复制Edgeless文件夹
cls
xcopy /s /r /y %Upath%:\Edgeless %a%:\Edgeless\
    if not exist %a%:\Edgeless\version.txt (
    echo %time% Disk_Installer-复制Edgeless文件夹失败 >>X:\Users\Log.txt
        echo =======================================================================
        echo 拷贝%Upath%:\Edgeless至%a%:\Edgeless失败，请手动复制或按任意键重试
        echo =======================================================================
        pause >nul
        goto copyCheckEL
    )
::重命名version.txt为version_Disk.txt
:renCheck
echo %time% Disk_Installer-开始重命名version.txt为version_Disk.txt >>X:\Users\Log.txt
title 正在处理版本标识文件
ren %a%:\Edgeless\version.txt version_Disk.txt
    if not exist %a%:\Edgeless\version_Disk.txt (
        echo %time% Disk_Installer-重命名version.txt为version_Disk.txt失败 >>X:\Users\Log.txt
        echo ================================================================================
        echo 重命名%a%:\Edgeless\version.txt为version_Disk.txt失败，请手动重命名或按任意键重试
        echo ================================================================================
        pause >nul
        goto renCheck
    )
del /f /q %a%:\Edgeless\version.txt >nul
title Edgeless硬盘版安装完成
echo %time% Disk_Installer-Edgeless硬盘版安装完成 >>X:\Users\Log.txt
cls
echo.
echo.
echo ===================================================================
echo Edgeless硬盘版安装完毕，当电脑有故障时会自动进入Edgeless
echo 或者连续三次在Windows开机过程中强行关机即可进入
echo 具体的进入方式请百度：进入winre
echo ===================================================================
echo.
pause
exit



:newest
echo %time% Disk_Installer-%UPdatePath%盘的Edgeless已是最新版本 >>.\Log.txt
title 已是最新版本：%UPdatePath%盘
cls
echo.
echo.
echo.
echo  恭喜，%UPdatePath%盘的Edgeless已是最新版本！
echo =========================================
echo 版本信息：
echo 完整版本号：%version_disk%
echo 系统名称：%version_disk:~0,8%
echo 渠道类型：%version_disk:~9,4%
echo 发行版本：%version_disk:~14,5%
echo 版本编号：%version_disk:~20,5%
echo =========================================
echo.
echo 按任意键重新安装或为其他分区的系统安装
pause >nul
goto scan