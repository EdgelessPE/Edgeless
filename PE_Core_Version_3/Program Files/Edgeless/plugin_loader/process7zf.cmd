echo %time% 7zf处理程序-运行 >>X:\Users\Log.txt
echo %time% 7zf处理程序-目标插件包 >>X:\Users\Log.txt
echo %1 >>X:\Users\Log.txt
pecmd exec ="%ProgramFiles%\Edgeless\plugin_loader\p7zf.wcs"

::处理正常的加载请求
if exist X:\Users\load7zf (
rd X:\Users\load7zf
echo %time% 7zf处理程序-载入插件包 >>X:\Users\Log.txt
pecmd exec ="%ProgramFiles%\Edgeless\plugin_loader\load.cmd" %1
pecmd load "X:\Program Files\Edgeless\plugin_loader\7zftip.wcs"
exit
)

::处理LocalBoost请求
if exist X:\Users\installToBoost (
rd X:\Users\installToBoost
md X:\Users\LocalBoost
echo %time% 7zf处理程序-使用LocalBoost安装 >>X:\Users\Log.txt
if not exist "X:\Users\LocalBoost\repoPart.txt" pecmd exec ="X:\Program Files\Edgeless\plugin_localboost\GUI.wcs"
echo %1>"X:\Users\LocalBoost\pluginPath.txt"
pecmd exec "X:\Program Files\Edgeless\plugin_localboost\installToRepo.wcs"
exit
)
if not exist X:\Users\load7zf echo %time% 7zf处理程序-用户关闭加载窗口 >>X:\Users\Log.txt
exit