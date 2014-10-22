# Microsoft Developer Studio Generated NMAKE File, Based on IntelliDump.dsp
!IF "$(CFG)" == ""
CFG=IntelliDump - Win32 Debug
!MESSAGE Keine Konfiguration angegeben. IntelliDump - Win32 Debug wird als Standard verwendet.
!ENDIF 

!IF "$(CFG)" != "IntelliDump - Win32 Release" && "$(CFG)" != "IntelliDump - Win32 Debug"
!MESSAGE UngÅltige Konfiguration "$(CFG)" angegeben.
!MESSAGE Sie kînnen beim AusfÅhren von NMAKE eine Konfiguration angeben
!MESSAGE durch Definieren des Makros CFG in der Befehlszeile. Zum Beispiel:
!MESSAGE 
!MESSAGE NMAKE /f "IntelliDump.mak" CFG="IntelliDump - Win32 Debug"
!MESSAGE 
!MESSAGE FÅr die Konfiguration stehen zur Auswahl:
!MESSAGE 
!MESSAGE "IntelliDump - Win32 Release" (basierend auf  "Win32 (x86) Dynamic-Link Library")
!MESSAGE "IntelliDump - Win32 Debug" (basierend auf  "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR Eine ungÅltige Konfiguration wurde angegeben.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "IntelliDump - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release

ALL : "..\LDE\IntelliDump.LDE"


CLEAN :
	-@erase "$(INTDIR)\IntelliDump.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\IntelliDump.exp"
	-@erase "$(OUTDIR)\IntelliDump.lib"
	-@erase "..\LDE\IntelliDump.LDE"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "INTELLIDUMP_EXPORTS" /Fp"$(INTDIR)\IntelliDump.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\IntelliDump.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\IntelliDump.pdb" /machine:I386 /def:"IntelliDump.def" /out:"..\LDE\IntelliDump.LDE" /implib:"$(OUTDIR)\IntelliDump.lib" 
DEF_FILE= \
	".\IntelliDump.DEF"
LINK32_OBJS= \
	"$(INTDIR)\IntelliDump.obj"

"..\LDE\IntelliDump.LDE" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "IntelliDump - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "..\LDE\IntelliDump.LDE"


CLEAN :
	-@erase "$(INTDIR)\IntelliDump.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\IntelliDump.exp"
	-@erase "$(OUTDIR)\IntelliDump.lib"
	-@erase "$(OUTDIR)\IntelliDump.pdb"
	-@erase "..\LDE\IntelliDump.ilk"
	-@erase "..\LDE\IntelliDump.LDE"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "INTELLIDUMP_EXPORTS" /Fp"$(INTDIR)\IntelliDump.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\IntelliDump.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\IntelliDump.pdb" /debug /machine:I386 /def:"IntelliDump.def" /out:"..\LDE\IntelliDump.LDE" /implib:"$(OUTDIR)\IntelliDump.lib" /pdbtype:sept 
DEF_FILE= \
	".\IntelliDump.DEF"
LINK32_OBJS= \
	"$(INTDIR)\IntelliDump.obj"

"..\LDE\IntelliDump.LDE" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("IntelliDump.dep")
!INCLUDE "IntelliDump.dep"
!ELSE 
!MESSAGE Warning: cannot find "IntelliDump.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "IntelliDump - Win32 Release" || "$(CFG)" == "IntelliDump - Win32 Debug"
SOURCE=.\IntelliDump.c

"$(INTDIR)\IntelliDump.obj" : $(SOURCE) "$(INTDIR)"



!ENDIF 

