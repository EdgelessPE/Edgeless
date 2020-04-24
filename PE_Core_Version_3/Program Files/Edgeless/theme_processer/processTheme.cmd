@echo off
cd /d %~dp0
echo %1>path.txt
set /p a=<path.txt

echo %time% 主题处理程序-运行 >>X:\Users\Log.txt
echo %1 >>X:\Users\Log.txt
echo %time% 主题处理程序-解析后缀名：%a:~-4,3% >>X:\Users\Log.txt

if %a:~-4,3%==eth goto procThemePack
if %a:~-4,3%==eis goto procResourcePack
if %a:~-4,3%==ems goto procResourcePack
if %a:~-4,3%==esc goto procResourcePack
if %a:~-4,3%==ess goto procResourcePack
if %a:~-4,3%==els goto procResourcePack

exit

:procThemePack
if not exist X:\Users\Theme\Path\eth.txt echo %time% 主题处理程序-全新解压eth >>X:\Users\Log.txt
if not exist X:\Users\Theme\Path\eth.txt goto useNew
set /p oldPath=<X:\Users\Theme\Path\eth.txt
echo %time% 主题处理程序-上一次eth路径：%oldPath% >>X:\Users\Log.txt
if %oldPath%==%a% goto useOld
goto useNew

:useOld
echo %time% 主题处理程序-同一个eth >>X:\Users\Log.txt
cd /d X:\Windows\System32
pecmd exec "%ProgramFiles%\Edgeless\theme_processer\procThemePack.wcs"
if exist X:\Users\Theme\ThemePack_unpack\Intro.wcs pecmd exec X:\Users\Theme\ThemePack_unpack\Intro.wcs
exit


:useNew
echo %time% 主题处理程序-另一个eth >>X:\Users\Log.txt
if not exist X:\Users\Theme\Path md X:\Users\Theme\Path
echo %1>X:\Users\Theme\Path\eth.txt

pecmd file X:\Users\Theme\ThemePack_unpack
md X:\Users\Theme\ThemePack_unpack
"%ProgramFiles%\7-Zip_x64\7z.exe" x %a% -oX:\Users\Theme\ThemePack_unpack -aoa
cd /d X:\Windows\System32
pecmd exec "%ProgramFiles%\Edgeless\theme_processer\procThemePack.wcs"
if exist X:\Users\Theme\ThemePack_unpack\Intro.wcs pecmd exec X:\Users\Theme\ThemePack_unpack\Intro.wcs
exit


:procResourcePack
echo %time% 主题处理程序-处理资源包 >>X:\Users\Log.txt

if not exist X:\Users\Theme\Path md X:\Users\Theme\Path
echo %1>X:\Users\Theme\Path\%a:~-4,3%.txt

if %a:~-4,3%==eis set type=IconPack.eis
if %a:~-4,3%==ems set type=MouseStyle.ems
if %a:~-4,3%==esc set type=StartIsBackConfig.esc
if %a:~-4,3%==ess set type=SystemIconPack.ess
if %a:~-4,3%==els set type=LoadScreen.els
::pecmd file X:\Users\Theme\ResoucePack_packed\%type%
::copy /y %a% X:\Users\Theme\ResoucePack_packed\%type%
if %a:~-4,3%==eis pecmd exec "%ProgramFiles%\Edgeless\theme_processer\procIconPack.wcs"
if %a:~-4,3%==ems pecmd exec "%ProgramFiles%\Edgeless\theme_processer\procMouseStyle.wcs"
if %a:~-4,3%==esc pecmd exec "%ProgramFiles%\Edgeless\theme_processer\procStartIsBackConfig.wcs"
if %a:~-4,3%==ess pecmd exec "%ProgramFiles%\Edgeless\theme_processer\procSystemIconPack.wcs"
if %a:~-4,3%==els pecmd exec "%ProgramFiles%\Edgeless\theme_processer\procLoadScreen.wcs"
exit