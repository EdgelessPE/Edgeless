@echo off
title Edgeless防火墙
color 3f
echo.
echo  [1]启用防火墙
echo  [2]禁用防火墙
echo.
set /p cho=输入序号并回车：
cd /d X:\Windows\System32
if %a%==1 wpeutil.exe EnableFirewall
if %a%==2 wpeutil.exe DisableFirewall

if %a%==1 call "X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 Edgeless防火墙 防火墙已启用
if %a%==2 call "X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 Edgeless防火墙 防火墙已禁用

exit