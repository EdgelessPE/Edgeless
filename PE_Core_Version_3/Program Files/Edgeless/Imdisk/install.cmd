@echo off

setlocal

pushd "%~dp0"

title ImDisk Virtual Disk Driver setup

echo ImDisk Virtual Disk Driver setup
echo.

set IMDISK_TOTAL_DEVICES=0
set IMDISK_VALID_DEVICES=0
set IMDISK_PENDING_REMOVAL_DEVICES=0

if exist "%SystemRoot%\system32\imdisk.exe" (
  for /f %%a in ('imdisk -l -n ^| find /v /i ^"No^"') do call :addline "%%a"
)

if %IMDISK_VALID_DEVICES% GTR 0 (
  echo Number of existing ImDisk virtual disks: %IMDISK_VALID_DEVICES%
  echo.
  if "%IMDISK_SILENT_SETUP%" == "1" (
    echo Please dismount all existing ImDisk virtual disks before upgrade!
    echo.
  ) else (
    .\msgboxw.exe "Please dismount all existing ImDisk virtual disks before upgrade!" 16 "ImDisk Virtual Disk Driver setup"
    start "" "%SystemRoot%\system32\control.exe" "%SystemRoot%\system32\imdisk.cpl"
  )
  popd
  endlocal
  goto :eof
)

echo Number of existing ImDisk virtual disks: %IMDISK_TOTAL_DEVICES%
echo.
if %IMDISK_TOTAL_DEVICES% == 0 (
  "%SystemRoot%\system32\net.exe" stop imdsksvc
  "%SystemRoot%\system32\net.exe" stop awealloc
  "%SystemRoot%\system32\net.exe" stop imdisk
  if exist "%SystemRoot%\system32\taskkill.exe" "%SystemRoot%\system32\taskkill.exe" /F /IM imdsksvc.exe
)

"%SystemRoot%\system32\rundll32.exe" setupapi.dll,InstallHinfSection DefaultInstall 132 .\imdisk.inf

if errorlevel 1 (
  if not "%IMDISK_SILENT_SETUP%" == "1" .\msgboxw.exe "Setup failed. Please try to reboot the computer and then try to run the setup package again." 16 "ImDisk Virtual Disk Driver setup"
  popd
  endlocal
  goto :eof
)

set IMDISK_START_FAILED=1
if %IMDISK_TOTAL_DEVICES% == 0 (
  set IMDISK_START_FAILED=0
  net start imdsksvc || set IMDISK_START_FAILED=1
  net start awealloc || set IMDISK_START_FAILED=1
  net start imdisk || set IMDISK_START_FAILED=1
)

if not "%IMDISK_SILENT_SETUP%" == "1" (
  if %IMDISK_START_FAILED% == 0 (
   .\msgboxw.exe "Setup finished successfully. Open ImDisk Virtual Disk Driver applet in Control Panel or use imdisk command line to manage your virtual disks!" 0 "ImDisk Virtual Disk Driver setup"
  ) else (
   .\msgboxw.exe "Setup finished, but drivers or services could not start. Please try to reboot the computer and then try to run the setup package again." 16 "ImDisk Virtual Disk Driver setup"
  )
)

popd

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
