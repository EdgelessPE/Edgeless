set TCC64=D:\DevKit\tcc64
set TCC32=D:\DevKit\tcc32
%TCC64%\tcc.exe c_helper.c %TCC64%\lib\kernel32.def %TCC64%\lib\user32.def -o c_helper_x64.exe
%TCC32%\tcc.exe c_helper.c %TCC64%\lib\kernel32.def %TCC64%\lib\user32.def -o c_helper_x86.exe
pause