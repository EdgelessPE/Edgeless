echo %time% 检查更新程序-下载hub-启动 >>X:\Users\Log.txt
set autoRetry=t
:home
"X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -o "hub.7z" https://pineapple.edgeless.top/api/v2/info/hub_addr
::"X:\Program Files\Edgeless\EasyDown\EasyDown.exe" -Down("http://s.edgeless.top/?token=burner","hub.7z","X:\Program Files\Edgeless\system_update")
if %autoRetry%==t goto waitForRetry
if not exist "X:\Program Files\Edgeless\system_update\hub.7z" call checknet.cmd
goto thisEnd


:waitForRetry
if exist "X:\Program Files\Edgeless\system_update\hub.7z" goto thisEnd
set autoRetry=f
echo %time% 检查更新程序-下载hub-准备自动重试 >>X:\Users\Log.txt
cls
echo.
echo   首次下载Edgeless Hub失败，程序将在3秒后重新发送下载请求
pecmd wait 3000
goto home

:thisEnd