@Echo off
:: Delete Files
If Exist "%SystemDrive%\Users\Default\Desktop\desktop.ini" Attrib -S -H "%SystemDrive%\Users\Default\Desktop\desktop.ini" & del /q /f "%SystemDrive%\Users\Default\Desktop\desktop.ini" & del /q /f /A:R /A:H /A:S /A:A "%SystemDrive%\Users\Default\Desktop\desktop.ini"
If Exist "%SystemDrive%\Users\Public\Desktop\desktop.ini" Attrib -S -H "%SystemDrive%\Users\Default\Desktop\desktop.ini" & del /q /f "%SystemDrive%\Users\Public\Desktop\desktop.ini" & del /q /f /A:R /A:H /A:S /A:A "%SystemDrive%\Users\Public\Desktop\desktop.ini"
:: Remove Google Chrome.lnk. It is auto created at startup without the correct target. Seems not longer the case
:: If Exist "%SystemDrive%\Users\Default\Desktop\Google Chrome.lnk" Attrib -S -H "%SystemDrive%\Users\Default\Desktop\Google Chrome.lnk" & del /q /f "%SystemDrive%\Users\Default\Desktop\Google Chrome.lnk" & del /q /f /A:R /A:H /A:S /A:A "%SystemDrive%\Users\Default\Desktop\Google Chrome.lnk"
:: If Exist "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" Attrib -S -H "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" & del /q /f "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" & del /q /f /A:R /A:H /A:S /A:A "%SystemDrive%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"

:: Diplay booted in BIOS or UEFI mode in System properties
wpeutil.exe UpdateBootInfo
For /f "tokens=2* delims= " %%A in ('Reg Query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') Do Set Firmware=%%B
If %Firmware%==0x1 (Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /t REG_SZ /v Model /d "Booted in BIOS mode" /f)
If %Firmware%==0x2 (Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /t REG_SZ /v Model /d "Booted in UEFI mode" /f)

:: Written From Plugins
:: Register Msi Windows Installer
If Exist %WinDir%\System32\Msi.dll (%WinDir%\System32\Regsvr32.exe /S %WinDir%\System32\Msi.dll)
If Exist %WinDir%\SysWOW64\Msi.dll (%WinDir%\SysWOW64\Regsvr32.exe /S %WinDir%\SysWOW64\Msi.dll)
Exit
