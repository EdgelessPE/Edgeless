@echo off
set "root=%~dp0"
for /f %%i in ('dir /b /ad UI_*') do (
  pushd %%i
  7z a -o%root% "%root%%%i.zip" *
  popd
)

pause
