::Created by victor888, QQ:2511755859
::Special thanks to CLONECD
::Special thanks to all the testers who provided with valid test results.
::Ordering and showing drive letters by drive type
echo %time% 理顺盘符-启动 >>X:\Users\Log.txt
@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Lpath.txt
set /p Upath=<Lpath.txt
if exist %Upath%:\Edgeless\Config\OrderDrvAnotherWay (
  echo %time% 理顺盘符-使用旧版理顺方法 >>X:\Users\Log.txt
  call 0orderdrv_old.cmd
  exit
)
set ver=2020-11-08 PS+

::If "AUTO" was set to "y", all messed drive letters will be re-ordered automaticly without nitification. 
::If "AUTO" was set to "n", a notification will come out to ask for confirmation wether to re-order messed driver letters. 

set AUTO=y

:: 1. "U" is the FIRST Removable USB Disk drive letter to be fixed just change it as you like.
:: 2. "T" is the FIRST USB CDROM drive letter to be fixed just change it as you like.
:: 3. Above drive letters must not be conflict with any other existing drive letters, otherwise error will happen.
:: 4. You may disable the function of fixing above drive letters simply by deleting them.

set USBCDROM=T
set USBDRV=U

:: Following notes are for the first hard disk that the system found.
set upactdrv=N
if exist %Upath%:\Edgeless\Config\UpActDrv echo %time% 理顺盘符-响应UpActDrv开关 >>X:\Users\Log.txt
if exist %Upath%:\Edgeless\Config\UpActDrv set upactdrv=Y

::1. "N" means do not put active partiction drive letter or driver letter which contains windows (x:\windows\system32\config) ahead of all hard drive letters.
::2. "Y" means put active partiction drive letter or driver letter which contains windows (x:\windows\system32\config) ahead of all hard drive letters.

set winfirst=N
if exist %Upath%:\Edgeless\Config\WinFirst echo %time% 理顺盘符-响应WinFirst开关 >>X:\Users\Log.txt
if exist %Upath%:\Edgeless\Config\WinFirst set upactdrv=Y
if exist %Upath%:\Edgeless\Config\WinFirst set winfirst=Y
::1. "N" means active partition drive letter will be the first driver letter among all driver letters as long as upactdrv is set to Y.
::2. "Y" means  driver letter which contains windows (x:\windows\system32\config) will be the first driver letter among all driver letters when  upactdrv is set to Y and no active partition drive letter exists.

pushd %~dp0

if %~d0 neq %systemdrive% (
  if not exist %temp%\%~nx0 (
    copy %0 %temp%\ /y >nul
    copy drvtype.exe %temp%\ /y >nul 2>&1
    copy fsutil.exe %temp%\ /y >nul 2>&1
    copy mountvol.exe %temp%\ /y >nul 2>&1
    copy smartctl.exe %temp%\ /y >nul 2>&1
    pushd %temp%\
    call %~nx0
    exit
  )
)


echo                 Batch file for ordering messed drive letters.
echo                    V.!ver!, By Victor888 from WUYOU.NET
echo       ------------------------------------------------------------------
echo.
echo Here is detailed information:
echo.


::get all drive letters by fsutil.exe
call :fsutil
if defined ALLDRV (
  set ALLDRV=!ALLDRV:\=!
  set ALLDRV=!ALLDRV: =!
  set ALLDRV=!ALLDRV::=: !
)

echo All drive letters: %ALLDRV%

::get all volume mount points and their full paths and merge them
FOR /F %%a in ('mountvol ^|find "\"') do set mtvdrv=!mtvdrv! %%a

::get unique drive letters which contain ":"
set mtvdrv=%mtvdrv: =%
set mtvdrv=%mtvdrv:\\?\Volume= %
set mtvdrv=%mtvdrv:}\=}%

for %%a in (%mtvdrv%) do (
  for /f "delims=} tokens=1,2" %%b in ("%%a") do (
    set drv=%%c
    set ttmp=%%c
    set ttmp=!ttmp:~-2,1!
    if !ttmp! equ : set mtdrv=!mtdrv! !drv:~0,2!
  )
)

if defined mtdrv (
  set mtdrv=!mtdrv: =!
  set mtdrv=!mtdrv::=: !
  echo Mounted drive letters: !mtdrv!
)

::get virtual drive letters which has no mount point
set virdrv=%ALLDRV%
for %%a in (%mtdrv%) do (
  set virdrv=!virdrv:%%a=!
)

set virdrv=!virdrv: =!
if defined virdrv (
  set virdrv=!virdrv::=: !
  echo Virtual drive letters: !virdrv!
  for /f "tokens=3 delims=	 " %%a in ('reg query HKLM\System\CurrentControlSet\Services\ISODrive\Parameters /s 2^>nul ^|find /i "drive"') do (
    if %errorlevel% equ 0 (
      set indvir=%%a
      if defined indvir (
        for %%b in (!virdrv!) do (
          if /i !indvir!: equ %%b (
            echo The ULTRAISO produced drive letter %%b 
          )
        )
      )
    )
  ) 
)

::judge if exist powershell and its version
for /f tokens^=2^ delims^=^" %%a in ('reg query HKLM\SOFTWARE\Classes\Microsoft.PowerShellConsole.1 /v "FriendlyTypeName" ^|find "@"') do (
  set existps=%%a
  if defined existps (
    for /f "tokens=2 delims= " %%b in ('powershell "$psversiontable" ^|find /i "psversion"') do (
      set psver=%%b
      set psver=!psver:~0,1!
      if !psver! GEQ 3 set psok=yes
    )
  )
)

::get SSD by ps
if !psok!==yes (
  for /f "tokens=1 delims= " %%a in ('powershell "get-physicaldisk" ^|find "SSD"') do (
    set ssdok=%%a
    if defined ssdok (
      set ssdno=%%a !ssdno!
    )
  )
)

::get hard disk drive letters, Dataram drive letters and fixed USB drive letters by clonecd's DRVTYPE. 
for /f "tokens=1-5 delims=|" %%a in ('drvtype -a ^|find ":"') do (
  set diskorder=%%a
  set hdtype=%%b
  set gptmbr=%%c
  set isssd=%%d
  set strdrv=%%e
  set hddrv=
  
  if !psok!==yes (
    if defined ssdno (
      for %%g in (!ssdno!) do (
        if !diskorder!==%%g set isssd=SSD
      )
    )
  ) else (
    smartctl -i /dev/pd%%a |find "rpm">nul||set isssd=SSD
  )

  if not defined strdrv set strdrv=%%d

  for %%f in (!strdrv!) do (
    set eachdrv=%%f
    set eachdrv=!eachdrv:~1,2!!
    if "!eachdrv:$=!"=="!eachdrv!" (
      set hddrv=!hddrv! !eachdrv!
      set order=!order! !diskorder!:%%f
    )
  )

  set strdrv=!hddrv! rem added on Dec. 31, 2018

  set hdtype=!hdtype:Vmware=!
  if !hdtype! neq %%b (
    set /a ii+=1
    echo Vmware Internel !gptmbr! hard disk !ii! mount path: !hddrv!
    set thddrv=!thddrv! !hddrv!
  ) else (
    set hdtype=!hdtype:diskvirtual=!
    if !hdtype! neq %%b (
      set /a rr+=1
      echo Virtual PC Internel !gptmbr! hard disk !rr! mount path: !hddrv!
      set thddrv=!thddrv! !hddrv!
    ) else (
      set "hdtype=!hdtype:Virtual=!"
      if !hdtype! neq %%b (
        set /a jj+=1
        echo Virtual !gptmbr! hard disk !jj! mount path: !hddrv!
        set virdrv=!virdrv! !hddrv!
      ) else (
        set hdtype=!hdtype:RAMDISK=!
        if !hdtype! neq %%b (
          set /a oo+=1
          echo RAMDISK !gptmbr! hard disk !oo! mount path: !hddrv!
          set virdrv=!virdrv! !hddrv!
        ) else (
          set hdtype=!hdtype:FIRADISK=!
          if !hdtype! neq %%b (
            set /a pp+=1
            echo FIRADISK !gptmbr! hard disk !pp! mount path: !hddrv!
            set firadrv=!firadrv! !hddrv!
          ) else (
            set hdtype=!hdtype:winvblock=!
            if /i !hdtype! neq %%b (
              set /a bb+=1
              echo WINVBLOCK !gptmbr! hard disk !bb! mount path: !hddrv!
              set winvdrv=!winvdrv! !hddrv!
            ) else (
              set hdtype=!hdtype:USB=!
              if /i !hdtype! neq %%b (
                set /a nn+=1
                set tmpsysdrv=!hddrv:%systemdrive%=!
                if /i !hddrv! neq !tmpsysdrv! (
                  set usbsys=!hddrv!
                ) else (
                  set uhddrv=!uhddrv! !hddrv!
                )
                echo Fixed USB !gptmbr! disk !nn! mount path: !hddrv!
              ) else (
                if "!isssd!"=="SSD" (
                  set /a qq+=1
                  echo Solid State !gptmbr! Hard disk !qq! mount path: !hddrv!
                  set ssddrv=!ssddrv! !hddrv!
                  if /i !upactdrv! neq N (
                    if !qq!==1 (
                      for %%f in (!strdrv!) do (
                        set "eachdrv=%%f"
                        if /i !winfirst! neq N (
                          if "!eachdrv:~-1!"=="$" (
                            if "!eachdrv:~-2,1!"==":" set actdrv=!eachdrv:~1,2!
                          )
                        ) else (
                          if exist %%f\Windows\System32\config (
                            set actdrv=%%f
                          )
                        )
                      ) 
                    )
                  )
                ) else (
                  set /a ll+=1
                  set thddrv=!thddrv! !hddrv!
                  echo Internal !gptmbr! hard disk !ll! mount path: !hddrv!
                  if /i !upactdrv! neq N (
                    if !ll!==1 (
                      if not defined actdrv (
                        for %%f in (!strdrv!) do (
                          if /i !winfirst! neq N (
                            if "!eachdrv:~-1!"=="$" (
                              if "!eachdrv:~-2,1!"==":" set actdrv=!eachdrv:~1,2!
                            )
                          ) else (
                            if exist %%f\Windows\System32\config (
                              set actdrv=%%f
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          ) 
        )
      )
    )
  )
)

set newhddrv=!ssddrv! !thddrv! !firadrv! !winvdrv!
set allhddrv=!newhddrv! !uhddrv!

if defined virdrv (
  if defined allhddrv (
    for %%a in (!virdrv!) do (
      for %%b in (!allhddrv!) do (
        if %%a equ %%b (
          set hdvir=!hdvir! %%a
          set virdrv=!virdrv:%%a=!
        ) 
      )
    )
  )
)

if defined hdvir echo No mount point hard disk drive letters: !hdvir!

if defined actdrv set newhddrv=!actdrv! !newhddrv:%actdrv%=!

if defined allhddrv (
  set mthddrv=!allhddrv!
  if defined mtdrv (
    set otherdrv=!mtdrv!
    for %%a in (!mthddrv! !virdrv!) do set otherdrv=!otherdrv:%%a=!
    set otherdrv=!otherdrv: =!

    if defined otherdrv (
      set otherdrv=!otherdrv:%systemdrive%=!
      set otherdrv=!otherdrv::=: !
      echo Other mounted drive letters: !otherdrv!
    )
  )
)

if defined otherdrv (
  for %%a in (%otherdrv%) do (
    set docheck=
    set mnreg=
    for /f "skip=2 tokens=3 delims=	 " %%b in ('reg query HKLM\SYSTEM\MountedDevices /v \DosDevices\%%a') do (
      set "mnreg=%%b"
      if defined mnreg (
        set first8=!mnreg:~0,8!
        if !first8! equ 5F003F00 set docheck=ok
        if !first8! equ 5C003F00 set docheck=ok
        if /i !docheck! equ ok (
          set mnreg=!mnreg:5C=#!
          set mnreg=!mnreg:5f=#!
          set mnreg=!mnreg:23=#!
          set mnreg=!mnreg:26=#!
          set mnreg=!mnreg:00=!
          for /f "tokens=2,3,7 delims=#" %%c in ("!mnreg!") do (
            set tpcode=%%c
            set drvcode=%%d
            set prodcode=%%e

            rem FDC
            if /i !tpcode! equ 464443 (
              set /a fd+=1
              set intflp=!intflp! %%a
              echo Internal Floppy Drive Letter: %%a
            )

            rem DAEMON TOOLS
            if /i !tpcode! equ 4454534F4654425553 (
              set dtdvd=!dtdvd! %%a
              echo Daemon Tools CD/DVD Drive Letter: %%a
            )

            rem IDE
            if /i !tpcode! equ 494445 (
              if /i !tpcode! neq !tpcode:4364526F6D=! (
                set /a id+=1
                set idedvd=!idedvd! %%a
                echo IDE CD/DVD ROM: %%a
              )
            )

            rem SCSI
            if /i !tpcode! equ 53435349 (
              if /i !drvcode! neq !drvcode:4364526F6D=! (
                if /i !prodcode! equ 5669727475616C (
                  echo SCSI Virtual DVD ROM: %%a
                  set msvirdvd = !msvirdvd! %%a
                ) else (
                  echo SCSI CD/DVD ROM: %%a
                  set /a id+=1
                  set scsidvd=!scsidvd! %%a
                )
              )
            )

            rem USBSTOR        
            if /i !tpcode! equ 55534253544F52 (
              if /i !drvcode! equ 4364526F6D (
                set /a id+=1
                set /a ud+=1
                set usbdvd=!usbdvd! %%a
                echo USB CD/DVD ROM: %%a
              )
              if /i !drvcode! equ 4469736B (
                set /a ur+=1
                set usbrem=!usbrem! %%a
                echo Removable USB "Disk" Drive letter: %%a
              )
            )

            rem STORAGE, also removable USB
            if /i !tpcode! equ 53544F52414745 (
              if /i !drvcode! equ 52656D6F7661626C654D65646961 (
                set /a ur+=1
                set usbrem=!usbrem! %%a
                echo Removable USB "Storage" Drive letter: %%a
              )
            )  
    
            rem FIRA_DISK  
            if /i !tpcode! equ 464952414449534B (
              if /i !drvcode! equ 53466C6F707079 (
                set /a fd+=1
                set firaflp=!firaflp! %%a
                echo FIRA Floppy Disk Drive letter: %%a
              )
              if /i !drvcode! equ 4344524F4D (
                set /a frd+=1
                set firadvd=!firadvd! %%a
                echo FIRA CD/DVD ROM: %%a
              )
            )

            rem WINV_BLOCK
            if /i !tpcode! equ 57696E56426C6F636B (
              if /i !drvcode! equ 52414D466C6F7070794469736B (
                set /a fd+=1
                set winvflp=!winvflp! %%a
                echo Winv Block Ram Floppy Disk Drive letter: %%a
              )
              if /i !drvcode! equ 52414D4F70746963616C44697363 (
                set /a wvd+=1
                set wvbkdvd=!wvbkdvd! %%a
                echo Winv Block Ram CD/DVD ROM: %%a
              )
              if /i !drvcode! equ 46696C654F70746963616C44697363 (
                set /a wvd+=1
                set wvbkdvd=!wvbkdvd! %%a
                echo Winv Block File CD/DVD ROM: %%a

              )
            )
          )  
        )
      )
    )
  )
)

set flpdrv=!intflp!!firaflp!!winvflp!


if defined usbdvd (
  set usbdvd=!usbdvd: =!
  set usbdvd=!usbdvd::=: !
  if !ud! geq 1 (
    if defined USBCDROM (
      set tmpud=!usbdvd:%systemdrive%=!
      if defined tmpud ( 
        set FirstUD=!usbdvd:~0,1!
        if /i !USBCDROM! neq !FirstUD! (
          for /f %%a in ('mountvol !FirstUD!: /l') do (
            mountvol !FirstUD!: /d
            mountvol !USBCDROM!: %%a
            echo First USBCD ROM drive letter was set to: !USBCDROM!:
          )
        ) 
        set usbdvd=!usbdvd:~2!
      )  
    )
  )
)

set dvddrv=!scsidvd!!idedvd!!msvirdvd!!dtdvd!!usbdvd!

if defined flpdrv (
  set flpdrv=!flpdrv: =!
  set flpdrv=!flpdrv::=: !
  if !fd! gtr 1 (
    echo ALL Floppy drive letters: %flpdrv%
  )
)

set virdrv=!virdrv! !flpdrv!

if defined dvddrv (
  set dvddrv=!dvddrv: =!
  set dvddrv=!dvddrv::=: !
  if !id! gtr 1 (
    echo ALL DVD/CD drive letters: %dvddrv%
  )
)

if defined firadvd (
  set firadrv=!firadvd: =!
  set firadvd=!firadvd::=: !
  if !frd! gtr 1 (
    echo ALL Virtual Firadisk Optical drive letters: %firadvd%
  )
)

if defined wvbkdvd (
  set wvbkdvd=!wvbkdvd: =!
  set wvbkdvd=!wvbkdvd::=: !
  if !wvd! gtr 1 (
    echo ALL Virtual Winvblock Optical drive letters: %wvbkdvd%
  )
)

if defined usbrem (
  set usbrem=!usbrem: =!
  set usbrem=!usbrem::=: !
  if !ur! gtr 1 (
    echo ALL Removable USB drive letters: %usbrem%
  )
  if !ur! geq 1 (
    if defined USBDRV (
      set tmprem=!usbrem:%systemdrive%=!
      if defined tmprem ( 
        set FirstU=!usbrem:~0,1!
        if /i !USBDRV! neq !FirstU! (
          for /f %%a in ('mountvol !FirstU!: /l') do (
            mountvol !FirstU!: /d
            mountvol !USBDRV!: %%a
            echo First removable USB disk drive letter was set to: !USBDRV!:
          )
        ) 
        set usbrem=!usbrem:~2!
      )  
    )
  )
)

echo SYSTEM DRIVE LETTER: %systemdrive%

if defined newhddrv (
  set totaldrv=%usbsys% %newhddrv% %dvddrv% %uhddrv% %usbrem% %wvbkdvd% %firadvd%
) else (
  set totaldrv=%usbsys% %uhddrv% %usbrem% %dvddrv% %wvbkdvd% %firadvd%
)

set totaldrv=!totaldrv:%systemdrive%=!

if defined virdrv (
  for %%a in (!virdrv!) do set totaldrv=!totaldrv:%%a=!
  set virdrv=!virdrv::=!
)

set totaldrv=!totaldrv: =!
set totaldrv=!totaldrv::=: !

if defined totaldrv set totaldrv=!totaldrv::=!

set fulldrv=CDEFGHIJKLMNOPQRSTUVWXYZ

for %%a in (%virdrv%) do set fulldrv=!fulldrv:%%a=!
set fulldrv=!fulldrv:%systemdrive:~0,1%=!

::ordering drive letters start
set /a kk=-1
for %%a in (%totaldrv%) do (
  set /a kk=kk+1
  call :olddrv %%a
)

if defined ordereddrv (
  if /i !AUTO! equ n (
    echo DRIVE LETTERS to be ordered: %ordereddrv:~0,-1%
    set /p doorder="Are you sure to make above drive letter changes (Y/N)"
    if /i !doorder! equ y (
      call :mountbegin
      if errorlevel 0 (
        echo "Drive letter changing succeeded!"
      ) else (
        echo "Error happened, please check no drive letter used when changing begin!"
      )
    ) else (
      echo Drive letter changing cancelled by user!
    )
  ) else (
    call :mountbegin
  )
) else (
  echo DRIVE LETTER ORDER IS CORRECT.
)

if %~d0 neq %systemdrive% (
  if exist %temp%\drvtype.exe del %temp%\drvtype.exe
  if exist %temp%\smartctl.exe del %temp%\smartctl.exe
  if exist %temp%\mountvol.exe del %temp%\mountvol.exe
  if exist %temp%\fsutil.exe del %temp%\fsutil.exe
  if exist %temp%\%~nx0 del %temp%\%~nx0
)

pushd %~dp0

if !AUTO! equ n (
  pause
  goto :end
) else (
  goto :end
)
goto :end

:olddrv
set nk=!fulldrv:~%kk%,1!
if /i %1 neq !nk! (
  set ordereddrv=!ordereddrv! %1: to !nk!:,
)
goto :eof

:mountbegin
set ordereddrv=!ordereddrv:to=!
set ordereddrv=!ordereddrv: =!
set ordereddrv=!ordereddrv:,= !

for %%a in (!ordereddrv!) do (
  set oldnew=%%a
  call :vid_drv !oldnew:~0,1! !oldnew:~-2,1!
)

for %%a in (!ordereddrv!) do (
  set oldnew=%%a
  mountvol !oldnew:~0,2! /d
)

for %%a in (!newvid!) do (
  set eachnewvid=%%a
  set tmpeachnewvid=!eachnewvid:~0,1!
  if !tmpeachnewvid! neq { (
    pecmd show !eachnewvid:~0,-1!,!eachnewvid:~-1!
  ) else (
    mountvol !eachnewvid:~-1!: \\?\Volume!eachnewvid:~0,-1!\
  )
)

goto :eof

:dsptdrv
set dpd=
for %%a in (!order!) do (
  set eachdpd=%%a
  set tmpeachdpd=!eachdpd:%1=!
  if !eachdpd! neq !tmpeachdpd! (
    if !eachdpd:~-1! neq $ (
      set dpd=!eachdpd:~0,-2!
    ) else (
      set dpd=!eachdpd:~0,-3!
    )
  )
)
goto :eof

:vid_drv
set aa=%1
if defined hdvir (
  set tmphdvir=!hdvir:%1=!
  if !hdvir! neq !tmphdvir! (
    call :dsptdrv !aa!
    set newvid=!newvid! !dpd!%2
  ) else (
    for /f %%b in ('mountvol %1: /l') do (
      set tmp=%%b
      set tmp=!tmp:\\?\Volume=!
      set tmp=!tmp:\=!
      set newvid=!newvid! !tmp!%2
    )
  ) 
) else (
  for /f %%c in ('mountvol %1: /l') do (
    set tmp=%%c
    set tmp=!tmp:\\?\Volume=!
    set tmp=!tmp:\=!
    set newvid=!newvid! !tmp!%2
  )
)
goto :eof

:fsutil
      for /f "delims=:\ " %%a in ('fsutil.exe fsinfo drives^|more') do (
        set tmpdrv=%%a
        if !tmpdrv:~-2! equ %%a set ALLDRV=!ALLDRV! %%a:
      )
goto :eof

:end