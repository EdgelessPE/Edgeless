@echo off

setlocal

title ImDisk Virtual Disk Driver Uninstall

echo ImDisk Virtual Disk Driver Uninstall
echo.

set IMDISK_TOTAL_DEVICES=0
set IMDISK_VALID_DEVICES=0
set IMDISK_PENDING_REMOVAL_DEVICES=0

if exist "%SystemRoot%\system32\imdisk.exe" (
  for /f %%a in ('imdisk -l -n') do call :addline "%%a"
)

if %IMDISK_VALID_DEVICES% GTR 0 (
  echo Number of existing ImDisk virtual disks: %IMDISK_VALID_DEVICES%
  echo.
  echo Please dismount all existing ImDisk virtual disks before uninstall!
  echo.
  if not "%IMDISK_SILENT_SETUP%" == "1" (
    pause
    start "" "%SystemRoot%\system32\control.exe" ""%SystemRoot%\system32\imdisk.cpl"
  )
  endlocal
  goto :eof
)

echo Number of existing ImDisk virtual disks: %IMDISK_TOTAL_DEVICES%
if %IMDISK_TOTAL_DEVICES% == 0 (
  "%SystemRoot%\system32\net.exe" stop imdsksvc
  "%SystemRoot%\system32\net.exe" stop awealloc
  "%SystemRoot%\system32\net.exe" stop imdisk
  if exist "%SystemRoot%\system32\taskkill.exe" "%SystemRoot%\system32\taskkill.exe" /F /IM imdsksvc.exe
)

start "" "%SystemRoot%\system32\rundll32.exe" setupapi.dll,InstallHinfSection DefaultUninstall 132 %SystemRoot%\inf\imdisk.inf

endlocal

goto :eof

:addline

"%SystemRoot%\system32\imdisk.exe" -l -u %~1 > nul 2>&1

if errorlevel 1 (
  set /a IMDISK_PENDING_REMOVAL_DEVICES=%IMDISK_PENDING_REMOVAL_DEVICES% + 1 > nul
) else (
  set /a IMDISK_VALID_DEVICES=%IMDISK_VALID_DEVICES% + 1 > nul
)

set /a IMDISK_TOTAL_DEVICES=%IMDISK_TOTAL_DEVICES% + 1 > nul

goto :eof
