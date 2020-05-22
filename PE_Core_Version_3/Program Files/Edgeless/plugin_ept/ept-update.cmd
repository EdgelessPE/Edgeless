@echo off
echo ept-update 开始更新插件包索引
"X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -d X:\Users -o Data.txt http://s.edgeless.top/?token=index
if exist X:\Users\Data.txt (
    if exist X:\Users\Data del /f /q X:\Users\Data>nul
    ren X:\Users\Data.txt Data
    echo ept-update 索引更新完成
) else (
    echo ept-update 索引更新失败，请检查网络连接
)
echo on