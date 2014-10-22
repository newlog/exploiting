@echo off

SET PROJECTNAME=UseProcs1
SET MASMBINPATH=\MASM32\BIN

%MASMBINPATH%\Ml.exe /c /coff %PROJECTNAME%.asm
%MASMBINPATH%\Link.exe /SUBSYSTEM:CONSOLE /MERGE:.idata=.text /MERGE:.data=.text /MERGE:.rdata=.text /OUT:..\%PROJECTNAME%.exe /SECTION:.text,EWR /IGNORE:4078 %PROJECTNAME%.obj

del *.obj

echo.
pause