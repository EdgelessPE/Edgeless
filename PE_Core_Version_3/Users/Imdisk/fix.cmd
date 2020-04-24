@echo off
del /f /q X:\Users\Imdisk\isotar.txt
del /f /q X:\Users\Imdisk\isopath.txt
echo msgbox "提示：Imdisk挂载关联已修复！",64,"Edgeless Smart ISO">alert.vbs && start alert.vbs && ping -n 2 127.1>nul && del alert.vbs
exit