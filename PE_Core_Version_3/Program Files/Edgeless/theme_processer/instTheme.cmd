@echo off
echo %time% 主题安装程序-运行 >>X:\Users\Log.txt
color 3f
set /p lastETH=<X:\Users\Theme\Path\eth.txt
if not defined lastETH set lastETH=X:\Edgeless自定义主题.eth
:begin
del /f /q Inspath.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Inspath.txt
set /p Upath=<Inspath.txt
echo %time% 主题安装程序-使用%Upath%作为Edgeless盘符 >>X:\Users\Log.txt
if not exist Inspath.txt goto wait
if not defined Upath goto wait
if not exist %Upath%:\ goto wait


goto readInfo

:home
if %1==eth goto instThemePack
if %1==eis goto instResourcePack
if %1==ems goto instResourcePack
if %1==esc goto instResourcePack
if %1==ess goto instResourcePack
if %1==els goto instLoadScreen
if %1==jpg goto instWallPaper

exit



:instThemePack
set /p themePath=<X:\Users\Theme\Path\eth.txt
for /f "delims=" %%i in ("%themePath:"=%") do set name=%%~nxi
echo %time% 主题安装程序-安装主题包：%name% >>X:\Users\Log.txt
echo %time% 主题安装程序-U盘内原文件情况 >>X:\Users\Log.txt
dir %Upath%:\Edgeless\Default >>X:\Users\Log.txt
dir %Upath%:\Edgeless\Default\LoadScreen >>X:\Users\Log.txt
cd /d X:\Windows\System32

if exist %Upath%:\Edgeless\Default pecmd file %Upath%:\Edgeless\Default
if exist %Upath%:\Edgeless\Default pecmd file %Upath%:\Edgeless\Default
if exist %Upath%:\Edgeless\Default echo %time% 主题安装程序-删除default目录失败 >>X:\Users\Log.txt
md %Upath%:\Edgeless\Default
if exist X:\Users\Theme\ThemePack_unpack\LoadScreen.els md %Upath%:\Edgeless\Default\LoadScreen

if not exist %Upath%:\Edgeless\Default md %Upath%:\Edgeless\Default
copy /y X:\Users\Theme\ThemePack_unpack\IconPack.eis %Upath%:\Edgeless\Default\IconPack.eis
copy /y X:\Users\Theme\ThemePack_unpack\MouseStyle.ems %Upath%:\Edgeless\Default\MouseStyle.ems
copy /y X:\Users\Theme\ThemePack_unpack\StartIsBackConfig.esc %Upath%:\Edgeless\Default\StartIsBackConfig.esc
copy /y X:\Users\Theme\ThemePack_unpack\SystemIconPack.ess %Upath%:\Edgeless\Default\SystemIconPack.ess
if exist %Upath%:\Edgeless\Default\Intro pecmd file X:\Users\Theme\ThemePack_unpack\Intro=>%Upath%:\Edgeless\Default

if exist %Upath%:\Edgeless\wp_backup.jpg del /f /q %Upath%:\Edgeless\wp_backup.jpg
if exist %Upath%:\Edgeless\wp.jpg ren %Upath%:\Edgeless\wp.jpg wp_backup.jpg
copy /y X:\Users\Theme\ThemePack_unpack\WallPaper.jpg %Upath%:\Edgeless\wp.jpg

if exist X:\Users\Theme\ThemePack_unpack\LoadScreen.els "%ProgramFiles%\7-Zip_x64\7z.exe" x X:\Users\Theme\ThemePack_unpack\LoadScreen.els -o%Upath%:\Edgeless\Default\LoadScreen -aoa

cd /d X:\Windows\System32
if exist %Upath%:\Edgeless\Default call "X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 主题安装程序 主题包已安装至%Upath%分区
if not exist %Upath%:\Edgeless\Default call "X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 10000 主题安装程序 %Upath%分区不可读写，主题包安装失败！

echo %time% 主题安装程序-U盘内现文件情况 >>X:\Users\Log.txt
dir %Upath%:\Edgeless\Default >>X:\Users\Log.txt
dir %Upath%:\Edgeless\Default\LoadScreen >>X:\Users\Log.txt

if exist X:\Users\Theme\ThemePack_unpack\IconPack.eis set eisNameU=图标资源包：%name:~0,-4% 
if exist X:\Users\Theme\ThemePack_unpack\SystemIconPack.ess set essNameU=系统图标资源包：%name:~0,-4% 
if exist X:\Users\Theme\ThemePack_unpack\LoadScreen.els set elsNameU=LoadScreen资源包：%name:~0,-4% 
if exist X:\Users\Theme\ThemePack_unpack\MouseStyle.ems set emsNameU=鼠标样式资源包：%name:~0,-4% 
if exist X:\Users\Theme\ThemePack_unpack\StartIsBackConfig.esc set escNameU=开始菜单样式配置文件：%name:~0,-4% 

echo %time% 主题安装程序-变量重命名完成 >>X:\Users\Log.txt
echo  图标资源包：%eisNameU% >>X:\Users\Log.txt
echo  系统图标资源包：%essNameU% >>X:\Users\Log.txt
echo  LoadScreen资源包：%elsNameU% >>X:\Users\Log.txt
echo  鼠标样式资源包：%emsNameU% >>X:\Users\Log.txt
echo  开始菜单样式配置文件：%escNameU% >>X:\Users\Log.txt

goto writeInfo



:instResourcePack
echo %time% 主题安装程序-安装资源包 >>X:\Users\Log.txt
if not exist %Upath%:\Edgeless\Default md %Upath%:\Edgeless\Default

if %1==eis set /p pathE=<X:\Users\Theme\Path\eis.txt
if %1==ems set /p pathE=<X:\Users\Theme\Path\ems.txt
if %1==esc set /p pathE=<X:\Users\Theme\Path\esc.txt
if %1==ess set /p pathE=<X:\Users\Theme\Path\ess.txt

if %1==eis set type=IconPack.eis
if %1==ems set type=MouseStyle.ems
if %1==esc set type=StartIsBackConfig.esc
if %1==ess set type=SystemIconPack.ess

echo %time% 主题安装程序-资源包路径：%pathE% >>X:\Users\Log.txt

for /f "delims=" %%i in ("%pathE:"=%") do set fileName=%%~nxi

for /f "skip=1 delims=:" %%i in ('^(echo "%pathE%"^&echo.^)^|findstr /o ".*"') do set/a l=%%i-5

if %l% leq 33 goto noCheckThemeUnpack
if %pathE:~1,31%==X:\Users\Theme\ThemePack_unpack for /f "delims=" %%i in ("%lastETH:"=%") do set fileName=%%~nxi
if %pathE:~1,31%==X:\Users\Theme\ThemePack_unpack echo %time% 主题安装程序-资源包来源于主题%fileName% >>X:\Users\Log.txt
:noCheckThemeUnpack


cd /d X:\Windows\System32

if %l% leq 16 goto noCheckCopySelf
if %pathE:~1,-1%==%Upath%:\Edgeless\Default\%type% pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 主题安装程序 禁止套娃！！！
if %pathE:~1,-1%==%Upath%:\Edgeless\Default\%type% exit
:noCheckCopySelf

if %1==eis set eisNameU=图标资源包：%fileName:~0,-4% 
if %1==ems set emsNameU=鼠标样式资源包：%fileName:~0,-4% 
if %1==esc set escNameU=开始菜单样式配置文件：%fileName:~0,-4% 
if %1==ess set essNameU=系统图标资源包：%fileName:~0,-4% 

del /f /q %Upath%:\Edgeless\Default\%type%
if exist %Upath%:\Edgeless\Default\%type% echo %time% 主题安装程序-删除%Upath%分区的%type%失败 >>X:\Users\Log.txt
copy /y %pathE% %Upath%:\Edgeless\Default\%type%

if exist %Upath%:\Edgeless\Default\%type% pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 主题安装程序 成功安装资源包至%Upath%分区
if not exist %Upath%:\Edgeless\Default\%type% pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 10000 主题安装程序 尝试安装资源包至%Upath%分区失败


echo %time% 主题安装程序-变量重命名完成 >>X:\Users\Log.txt
echo  图标资源包：%eisNameU% >>X:\Users\Log.txt
echo  系统图标资源包：%essNameU% >>X:\Users\Log.txt
echo  LoadScreen资源包：%elsNameU% >>X:\Users\Log.txt
echo  鼠标样式资源包：%emsNameU% >>X:\Users\Log.txt
echo  开始菜单样式配置文件：%escNameU% >>X:\Users\Log.txt

goto writeInfo



:instLoadScreen
if not exist %Upath%:\Edgeless\Default md %Upath%:\Edgeless\Default
del /f /q %Upath%:\Edgeless\Default\LoadScreen\*.jpg
if not exist %Upath%:\Edgeless\Default\LoadScreen md %Upath%:\Edgeless\Default\LoadScreen
if exist %Upath%:\Edgeless\Default\LoadScreen\*.jpg echo %time% 主题安装程序-删除%Upath%分区的LoadScreen失败 >>X:\Users\Log.txt

set /p pathL=<X:\Users\Theme\Path\els.txt
"%ProgramFiles%\7-Zip_x64\7z.exe" x %pathL% -o%Upath%:\Edgeless\Default\LoadScreen -aoa
cd /d X:\Windows\System32
if exist %Upath%:\Edgeless\Default\LoadScreen\*.jpg pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 主题安装程序 成功安装LoadScreen资源包至%Upath%分区
if not exist %Upath%:\Edgeless\Default\LoadScreen\*.jpg pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 10000 主题安装程序 尝试安装LoadScreen资源包至%Upath%分区失败
for /f "delims=" %%i in ("%pathL:"=%") do set fileName=%%~nxi

for /f "skip=1 delims=:" %%i in ('^(echo "%pathL%"^&echo.^)^|findstr /o ".*"') do set/a ll=%%i-5
if %ll% leq 33 goto noCheckThemeUnpackLoadScreen

if %pathL:~1,31%==X:\Users\Theme\ThemePack_unpack for /f "delims=" %%i in ("%lastETH:"=%") do set fileName=%%~nxi
if %pathL:~1,31%==X:\Users\Theme\ThemePack_unpack echo %time% 主题安装程序-资源包来源于主题%fileName% >>X:\Users\Log.txt

:noCheckThemeUnpackLoadScreen

set elsNameU=LoadScreen资源包：%fileName:~0,-4% 


echo %time% 主题安装程序-变量重命名完成 >>X:\Users\Log.txt
echo  图标资源包：%eisNameU% >>X:\Users\Log.txt
echo  系统图标资源包：%essNameU% >>X:\Users\Log.txt
echo  LoadScreen资源包：%elsNameU% >>X:\Users\Log.txt
echo  鼠标样式资源包：%emsNameU% >>X:\Users\Log.txt
echo  开始菜单样式配置文件：%escNameU% >>X:\Users\Log.txt

goto writeInfo



:instWallPaper
if exist %Upath%:\Edgeless\wp_backup.jpg del /f /q %Upath%:\Edgeless\wp_backup.jpg
if exist %Upath%:\Edgeless\wp.jpg ren %Upath%:\Edgeless\wp.jpg wp_backup.jpg
copy /y X:\Users\Theme\ThemePack_unpack\WallPaper.jpg %Upath%:\Edgeless\wp.jpg
cd /d X:\Windows\System32
if exist %Upath%:\Edgeless\wp.jpg pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 主题安装程序 成功安装壁纸至%Upath%分区
if not exist %Upath%:\Edgeless\wp.jpg pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 10000 主题安装程序 尝试安装壁纸至%Upath%分区失败
exit



:wait
cd /d X:\Windows\System32
pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 10000 主题安装程序 未检测到合法的Edgeless启动盘，安装失败
exit




:readInfo
if not exist %Upath%:\Edgeless\Default\Info.txt goto useUnknown
for /f "tokens=1* delims=:" %%i in ('Type %Upath%:\Edgeless\Default\Info.txt^|Findstr /n ".*"') do (
if "%%i"=="1" echo %%j>eisName.txt
if "%%i"=="2" echo %%j>essName.txt
if "%%i"=="3" echo %%j>elsName.txt
if "%%i"=="4" echo %%j>emsName.txt
if "%%i"=="5" echo %%j>escName.txt
)
set /p eisNameU=<eisName.txt
set /p essNameU=<essName.txt
set /p elsNameU=<elsName.txt
set /p emsNameU=<emsName.txt
set /p escNameU=<escName.txt

echo %time% 主题安装程序-读取Info.txt >>X:\Users\Log.txt
type %Upath%:\Edgeless\Default\Info.txt >>X:\Users\Log.txt

echo %time% 主题安装程序-解析Info.txt >>X:\Users\Log.txt
echo eisNameU：%eisNameU% >>X:\Users\Log.txt
echo essNameU：%essNameU% >>X:\Users\Log.txt
echo elsNameU：%elsNameU% >>X:\Users\Log.txt
echo emsNameU：%emsNameU% >>X:\Users\Log.txt
echo escNameU：%escNameU% >>X:\Users\Log.txt

goto home



:writeInfo
echo %eisNameU:~0,-1% >%Upath%:\Edgeless\Default\Info.txt
echo %essNameU:~0,-1% >>%Upath%:\Edgeless\Default\Info.txt
echo %elsNameU:~0,-1% >>%Upath%:\Edgeless\Default\Info.txt
echo %emsNameU:~0,-1% >>%Upath%:\Edgeless\Default\Info.txt
echo %escNameU:~0,-1% >>%Upath%:\Edgeless\Default\Info.txt

echo %time% 主题安装程序-写入Info.txt然后退出 >>X:\Users\Log.txt
type %Upath%:\Edgeless\Default\Info.txt >>X:\Users\Log.txt
exit



:useUnknown
echo %time% 主题安装程序-初次安装主题，使用UnKnown >>X:\Users\Log.txt
set eisNameU=图标资源包：Unknown 
set essNameU=系统图标资源包：Unknown 
set elsNameU=LoadScreen资源包：Unknown 
set emsNameU=鼠标样式资源包：Unknown 
set escNameU=开始菜单样式配置文件：Unknown 
goto home

