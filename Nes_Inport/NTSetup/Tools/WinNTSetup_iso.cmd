@echo off

IF %1!==! (
echo.
echo  WinNTSetup ISO file support
echo.
echo  this batch will be executed to mount an ISO file
echo  right-click on the "source button" and select an ISO file
echo  path of the ISO will be saved inside %1
echo.
echo  sample for "ImDisk Virtual Disk Driver"
echo  http://www.ltr-data.se/opencode.html/#ImDisk
echo.
echo  silent install: imdiskinst -y
echo  mount command : imdisk -a -m #: -f %1
echo.
pause
goto :EOF
)
cd /d X:\Windows\System32
imdisk -a -m #: -f %1
