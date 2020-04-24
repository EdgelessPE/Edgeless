@echo off
title 正在恢复默认系统图标
color
start /wait X:\Windows\System32\xcmd.exe recImageRes.wcs
exit