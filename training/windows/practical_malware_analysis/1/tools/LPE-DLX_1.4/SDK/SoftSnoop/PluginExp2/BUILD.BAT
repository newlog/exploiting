@echo off

SET PROJECTNAME=MsgHook
SET MASMBINPATH=\MASM32\BIN
SET MASMLIBPATH=\MASM32\LIB

%MASMBINPATH%\Cvtres.exe /machine:ix86 rsrc.res
%MASMBINPATH%\ml /Zp1 /c /coff /Cp %PROJECTNAME%.asm
%MASMBINPATH%\Link /DLL /SUBSYSTEM:WINDOWS /MERGE:.idata=.text /MERGE:.data=.text /MERGE:.rdata=.text /SECTION:.text,EWR /IGNORE:4078 %PROJECTNAME%.obj rsrc.obj

del *.obj

echo.
pause