cd /d "%~dp0"
start WinXShell.exe -ui -jcfg wxsUI\UI_Logon.zip
pause
start WinXShell.exe  -console -ui -jcfg wxsUI\UI_Logon.zip -bk bk.jpg
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Settings.zip
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Shutdown.zip\full.jcfg -blur 5.0
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Shutdown.zip\full.jcfg
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Resolution.zip
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Shutdown.zip
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_WIFI.zip\main.jcfg -theme dark
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Volume.zip\main.jcfg
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Resolution.zip\wallpaper.jcfg
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Calendar.zip\calendar.jcfg
rem start WinXShell.exe -ui -jcfg wxsUI\UI_Calendar.zip\calendar.jcfg -theme light
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_SystemInfo.zip
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Launcher.jcfg -theme dark
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Launcher-full.jcfg -custom
echo exit...
pause
exit 0

rem run with parameter
rem change resolution directly
start WinXShell.exe -ui -jcfg wxsUI\UI_Resolution.zip -direct
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Resolution.zip -lua direct.lua
pause
rem no sound playing when volume changed
start WinXShell.exe -ui -jcfg wxsUI\UI_Volume.zip -nobeep
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_WIFI.zip -hidewindow
pause
start WinXShell.exe -ui -jcfg wxsUI\UI_Launcher.zip -theme dark
pause
