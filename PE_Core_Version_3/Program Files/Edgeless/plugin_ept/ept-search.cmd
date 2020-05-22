@if not exist X:\Users\Data call ept-update
@echo off
echo ept-search 在本地索引中命中以下插件包
find /n /i "%1" X:\Users\Data
echo ----------
echo 使用   ept-install [序号]    安装
echo on