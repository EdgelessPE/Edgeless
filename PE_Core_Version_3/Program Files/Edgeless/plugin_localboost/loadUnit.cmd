echo %1>tmp.txt
set /p target=<tmp.txt
del /f /q tmp.txt
echo %target:~1,-1%>"X:\Users\LocalBoost\unit.txt"
pecmd load "X:\Program Files\Edgeless\plugin_localboost\loadUnit.wcs"
exit