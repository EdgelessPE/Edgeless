setlocal
pushd "%~dp0"
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
    echo Fail
  ) else (
    echo Fail
     exit
  )
  popd
  endlocal
  goto :eof
)
echo 现有 ImDisk 虚拟磁盘数量: %IMDISK_TOTAL_DEVICES%
if %IMDISK_TOTAL_DEVICES% == 0 (
  "%SystemRoot%\system32\net.exe" stop imdsksvc
  "%SystemRoot%\system32\net.exe" stop awealloc
  "%SystemRoot%\system32\net.exe" stop imdisk
  if exist "%SystemRoot%\system32\taskkill.exe" "%SystemRoot%\system32\taskkill.exe" /F /IM imdsksvc.exe
)

"%SystemRoot%\system32\rundll32.exe" setupapi.dll,InstallHinfSection DefaultInstall 132 .\imdisk.inf

if errorlevel 1 (
  if not "%IMDISK_SILENT_SETUP%" == "1" echo Fail
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
   echo Success
  ) else (
   echo Fail
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
