cd /d "%~dp0"
rem use can write luacode to xxx.lua file, and run with WinXShell.exe -script X:\test\xxx.lua
WinXShell.exe -luacode "Taskbar:Pin('msra.exe')"
WinXShell.exe -luacode "Taskbar:Pin('cmd.exe', 'lua_pin_test', '/k echo lua_test', 'shell32.dll',27)"
WinXShell.exe -luacode "link('link_test(shortcut).lnk','cmd.exe', '/k echo lua_test')"
WinXShell.exe -luacode "link('link test(notepad).lnk','notepad.exe')"
echo Cleanup after press any key.
pause
WinXShell.exe -luacode "Taskbar:UnPin('msra.exe')"
WinXShell.exe -luacode "Taskbar:UnPin('lua_pin_test')"
del /q "link_test(shortcut).lnk"
del /q "link test(notepad).lnk"
