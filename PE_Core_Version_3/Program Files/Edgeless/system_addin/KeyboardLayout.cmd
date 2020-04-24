@Echo off
title Edgeless键盘布局
color 3f
SetLocal ENABLEEXTENSIONS
FOR /F "skip=2 tokens=3" %%A IN ('REG QUERY "HKU\.DEFAULT\Control Panel\International" /v Locale') DO Set LCID=%%A
Set LCID=%LCID:~-4%
:: Update registry keyboard layouts in HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinPE\KeyboardLayouts
Wpeutil ListKeyboardLayouts 0x%LCID% >nul

:_Menu
Cls
Echo.
Echo   01] Belgian French (fr-BE)
Echo   02] Chinese PRC (zh-CN)
Echo   03] Chinese Taiwan (zh-TW)
Echo   04] Dutch (nl-NL)
Echo   05] English UK (en-GB)
Echo   06] English US (en-US)
Echo   07] French (fr-FR)
Echo   08] German (de-DE)
Echo   09] Greek (el-GR)
Echo   10] Hebrew (he-IL)
Echo   11] Hungarian (hu-HU)
Echo   12] Italian (it-IT)
Echo   13] Korean (ko-KR)
Echo   14] Portuguese (pt-PT)
Echo   15] Portuguese Brazil (pt-BR)
Echo   16] Russian (ru-RU)
Echo   17] Spanish (es-ES)
Echo   18] Swedish (sv-SE)
Echo   19] Turkish (tr-TR)
Echo.
Echo   20] Exit
Echo.
Echo.
set /p Locale="输入完整序号并回车："
Echo.
If "%Locale%"=="01" Echo Set the Keyboard Layout to Belgian French (fr-BE) & Call :_Run %LCID%:0000080c
If "%Locale%"=="02" Echo Set the Keyboard Layout to Chinese PRC (zh-CN) & Call :_Run %LCID%:00000804
If "%Locale%"=="03" Echo Set the Keyboard Layout to Chinese Taiwan (zh-TW) & Call :_Run %LCID%:00000404
If "%Locale%"=="04" Echo Set the Keyboard Layout to Dutch (nl-NL) & Call :_Run %LCID%:00000413
If "%Locale%"=="05" Echo Set the Keyboard Layout to English UK (en-GB) & Call :_Run %LCID%:00000809
If "%Locale%"=="06" Echo Set the Keyboard Layout to English US (en-US) & Call :_Run %LCID%:00000409
If "%Locale%"=="07" Echo Set the Keyboard Layout to French (fr-FR) & Call :_Run %LCID%:0000040c
If "%Locale%"=="08" Echo Set the Keyboard Layout to German (de-DE) & Call :_Run %LCID%:00000407
If "%Locale%"=="09" Echo Set the Keyboard Layout to Greek (el-GR) & Call :_Run %LCID%:00000408
If "%Locale%"=="10" Echo Set the Keyboard Layout to Hebrew (he-IL) & Call :_Run %LCID%:0000040d
If "%Locale%"=="11" Echo Set the Keyboard Layout to Hungarian (hu-HU) & Call :_Run %LCID%:0000040e
If "%Locale%"=="12" Echo Set the Keyboard Layout to Italian (it-IT) & Call :_Run %LCID%:00000410
If "%Locale%"=="13" Echo Set the Keyboard Layout to Korean (ko-KR) & Call :_Run %LCID%:00000412
If "%Locale%"=="14" Echo Set the Keyboard Layout to Portuguese (pt-PT) & Call :_Run %LCID%:00000816
If "%Locale%"=="15" Echo Set the Keyboard Layout to Portuguese Brazil (pt-BR) & Call :_Run %LCID%:00000416
If "%Locale%"=="16" Echo Set the Keyboard Layout to Russian (ru-RU) & Call :_Run %LCID%:00000419
If "%Locale%"=="17" Echo Set the Keyboard Layout to Spanish (es-ES) & Call :_Run %LCID%:0000040a
If "%Locale%"=="18" Echo Set the Keyboard Layout to Swedish (sv-SE) & Call :_Run %LCID%:0000041d
If "%Locale%"=="19" Echo Set the Keyboard Layout to Turkish (tr-TR) & Call :_Run %LCID%:0000041f
If "%Locale%"=="20" Exit
Goto _Menu

:_Run
Echo wpeutil SetKeyboardLayout %~1
wpeutil SetKeyboardLayout %~1
Call "X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 Edgeless键盘布局 键盘布局切换成功
Exit
