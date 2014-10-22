# Microsoft Developer Studio Generated NMAKE File, Based on Plugin.dsp
!IF "$(CFG)" == ""
CFG=Plugin - Win32 Debug
!MESSAGE Keine Konfiguration angegeben. Plugin - Win32 Debug wird als Standard verwendet.
!ENDIF 

!IF "$(CFG)" != "Plugin - Win32 Release" && "$(CFG)" != "Plugin - Win32 Debug"
!MESSAGE UngÅltige Konfiguration "$(CFG)" angegeben.
!MESSAGE Sie kînnen beim AusfÅhren von NMAKE eine Konfiguration angeben
!MESSAGE durch Definieren des Makros CFG in der Befehlszeile. Zum Beispiel:
!MESSAGE 
!MESSAGE NMAKE /f "Plugin.mak" CFG="Plugin - Win32 Debug"
!MESSAGE 
!MESSAGE FÅr die Konfiguration stehen zur Auswahl:
!MESSAGE 
!MESSAGE "Plugin - Win32 Release" (basierend auf  "Win32 (x86) Application")
!MESSAGE "Plugin - Win32 Debug" (basierend auf  "Win32 (x86) Application")
!MESSAGE 
!ERROR Eine ungÅltige Konfiguration wurde angegeben.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Plugin - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release

ALL : "..\Plugins\LDS_TaskViewer.exe"


CLEAN :
	-@erase "$(INTDIR)\Plugin.obj"
	-@erase "$(INTDIR)\rsrc.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "..\Plugins\LDS_TaskViewer.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /Fp"$(INTDIR)\Plugin.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x407 /fo"$(INTDIR)\rsrc.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Plugin.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\LDS_TaskViewer.pdb" /machine:I386 /out:"..\Plugins\LDS_TaskViewer.exe" 
LINK32_OBJS= \
	"$(INTDIR)\Plugin.obj" \
	"$(INTDIR)\rsrc.res"

"..\Plugins\LDS_TaskViewer.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Plugin - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "..\Plugins\LDS_TaskViewer.exe"


CLEAN :
	-@erase "$(INTDIR)\Plugin.obj"
	-@erase "$(INTDIR)\rsrc.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\LDS_TaskViewer.pdb"
	-@erase "..\Plugins\LDS_TaskViewer.exe"
	-@erase "..\Plugins\LDS_TaskViewer.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /Fp"$(INTDIR)\Plugin.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x407 /fo"$(INTDIR)\rsrc.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Plugin.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\LDS_TaskViewer.pdb" /debug /machine:I386 /out:"..\Plugins\LDS_TaskViewer.exe" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\Plugin.obj" \
	"$(INTDIR)\rsrc.res"

"..\Plugins\LDS_TaskViewer.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Plugin.dep")
!INCLUDE "Plugin.dep"
!ELSE 
!MESSAGE Warning: cannot find "Plugin.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Plugin - Win32 Release" || "$(CFG)" == "Plugin - Win32 Debug"
SOURCE=.\Plugin.c

"$(INTDIR)\Plugin.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\rsrc.rc

"$(INTDIR)\rsrc.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

