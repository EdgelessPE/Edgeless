cd /d %~dp0
echo %time% openesd-启动 >>X:\Users\Log.txt
echo %1 >>X:\Users\Log.txt
echo [WinNT6]>WinNTSetup.txt
::设定镜像源
echo Source=%1>>WinNTSetup.txt
::设置引导驱动器
if exist Z:\ echo BootDest=Z:>>WinNTSetup.txt else echo BootDest=C:>>WinNTSetup.txt
if exist Z:\ echo %time% openesd-存在z分区 >>X:\Users\Log.txt
if not exist Z:\ echo %time% openesd-不存在z分区 >>X:\Users\Log.txt
echo [WinNT6\TWEAKS]>>WinNTSetup.txt
::显示隐藏文件
echo ShowHidden=1 >>WinNTSetup.txt
::显示拓展名
echo ShowFileExt=1 >>WinNTSetup.txt
::显示此电脑（这台电脑）
echo MyCompOnDesktop=1 >>WinNTSetup.txt
::如果存在全局无人值守文件则使用
if exist X:\AutoUnattend.xml echo %time% openesd-使用全局无人值守文件 >>X:\Users\Log.txt
if exist X:\AutoUnattend.xml echo UnattendedFile=X:\AutoUnattend.xml >>WinNTSetup.txt

if exist WinNTSetup.ini del WinNTSetup.ini
ren WinNTSetup.txt WinNTSetup.ini
pecmd exec WinNTSetup_x64.exe
exit

