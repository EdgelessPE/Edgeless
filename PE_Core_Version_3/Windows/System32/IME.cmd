:: Register IME dll and Load CTF Command Script for Korean IME, Chinese (CN|TW|HK) IME or Japanese IME

@Echo OFF
call :REGIST_IME_DLLS %SystemRoot%\System32
call :REGIST_IME_DLLS %SystemRoot%\SysWOW64
Start Ctfmon.exe
Goto :EOF

:REGIST_IME_DLLS
If Not Exist %1\Msutb.dll Goto :EOF
%1\Regsvr32.exe /S %1\Msutb.dll
%1\Regsvr32.exe /S %1\MsCtfMonitor.dll
For /F %%F In ('"Dir "%1\IME\*.dll" /B/O:N/S"') Do %1\Regsvr32.exe /S "%%F"
