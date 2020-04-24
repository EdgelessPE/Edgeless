::为System文件夹（放置系统镜像）创建桌面快捷方式
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\System echo %%1>Syspath.txt
set /p Syspath=<Syspath.txt
if defined Syspath echo %time% Launcher-使用%Syspath%作为系统镜像盘符 >>X:\Users\Log.txt
if defined Syspath pecmd link X:\Users\Default\Desktop\系统镜像,%Upath%:\System,,X:\Users\Icon\shortcut\system.ico,0
exit