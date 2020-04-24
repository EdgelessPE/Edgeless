echo %time% 7zf处理程序-运行 >>X:\Users\Log.txt
echo %time% 7zf处理程序-目标插件包 >>X:\Users\Log.txt
echo %1 >>X:\Users\Log.txt
pecmd exec ="%ProgramFiles%\Edgeless\plugin_loader\p7zf.wcs"
if exist X:\Users\load7zf (
rd X:\Users\load7zf
echo %time% 7zf处理程序-载入插件包 >>X:\Users\Log.txt
pecmd exec ="%ProgramFiles%\Edgeless\plugin_loader\load.cmd" %1
pecmd load "X:\Program Files\Edgeless\plugin_loader\7zftip.wcs"
exit
)
if not exist X:\Users\load7zf echo %time% 7zf处理程序-用户关闭加载窗口 >>X:\Users\Log.txt
exit