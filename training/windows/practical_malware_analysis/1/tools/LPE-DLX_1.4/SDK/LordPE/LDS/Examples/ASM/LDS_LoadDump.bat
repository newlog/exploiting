;@ECHO OFF
;GOTO MAKE
Comment %

LordPE Dumper Server - plugin example for ASM
---------------------------------------------

If the LDS window isn't opened up to now, the plugin will search for the LordPE path
in the registry and tries to lunch LDS. After that the user has to select an executable
file. The plugin will create a process with it and let's LDS dump it. Afterwarts the
process is killed.
Doesn't work for console applications.

by yoda

%

.586p
.MODEL FLAT, STDCALL
OPTION CASEMAP:NONE

INCLUDE    \masm32\include\kernel32.inc
INCLUDELIB \masm32\lib\kernel32.lib
INCLUDE    \masm32\include\user32.inc
INCLUDELIB \masm32\lib\user32.lib
INCLUDE    \masm32\include\advapi32.inc
INCLUDELIB \masm32\lib\advapi32.lib
INCLUDE    \masm32\include\shell32.inc
INCLUDELIB \masm32\lib\shell32.lib
INCLUDE    \masm32\include\comdlg32.inc
INCLUDELIB \masm32\lib\comdlg32.lib

INCLUDE    \masm32\include\windows.inc
INCLUDE    LDS.INC

;------------------------------CONST------------------------------
.CONST
szPluginName                   DB "Plugin example for ASM by yoda...", 0
szNoLDS                        DB "LordPE Dumper Server not opened and could not be lunched !", 0
szCap                          DB "LordPE Plugin", 0
szLPERegEntry                  DB "exefile\shell\Load into PE editor (LordPE)\command", 0
szLPECmdArgs                   DB "/LDS-T+L", 0
szOpen                         DB "open", 0
szOfnFilter                    DB "*.exe", 0, "*.exe", 0, "*.*", 0, "*.*", 0, 0
szCurDir                       DB ".", 0
szProcCreateErr                DB "Error while creating process !", 0

;------------------------------DATA?------------------------------
.DATA?
dwMyPid                        DWORD ?
hwndLDS                        HANDLE ?
LogEntry                       LDS_LOG_ENTRY <?>
FDumpInfo                      LDS_FULL_DUMP <?>
OFN                            OPENFILENAME <?>
cFileName                      CHAR MAX_PATH DUP (?)
SI_                            STARTUPINFO <?>
PI_                            PROCESS_INFORMATION <?>

;------------------------------CODE-------------------------------
.CODE

; returns: BOOL
FindLDSAndLunch PROC
	LOCAL  hKey                 : HANDLE
	LOCAL  dwType               : DWORD
	LOCAL  cKey[MAX_PATH + 50]  : CHAR
	LOCAL  cCmd[MAX_PATH + 50]  : CHAR
	LOCAL  dwBuffSize           : DWORD
	LOCAL  bRet                 : BOOL
	
	xor     eax, eax
	mov     bRet, eax
	
	; -> get LDS Path via its registry entry for the exe file shell extension
	invoke  RegOpenKeyEx, HKEY_CLASSES_ROOT, offset szLPERegEntry, 0, KEY_READ, addr hKey
	test    eax, eax
	jnz     @Exit
	mov     dwBuffSize, sizeof cKey
	invoke  RegQueryValueEx, hKey, NULL, 0, addr dwType, addr cKey, addr dwBuffSize
	push    eax                                                            ; save ret value
	invoke  RegCloseKey, hKey
	pop     eax                                                            ; ...and restore
	test    eax, eax
	jnz     @Exit
	
	; find 2nd quotation mark - end of path
	lea     ebx, [cKey + 1]                                                ; ebx -> address of LordPE shell cmd + 1
	mov     al, '"'
	lea     edi, [ebx]
	mov     ecx, sizeof cKey
	repnz   scasb
	
	; -> build command line with the "/LDS" command
	sub     edi, ebx                                                       ; edi -> LordPE path length
	invoke  lstrcpyn, addr cCmd, ebx, edi
	
	; -> lunch LordPE with the build command line which includes the Dumper Server lunch command + modifiers
	invoke  ShellExecute, 0, offset szOpen, addr cCmd, offset szLPECmdArgs, NULL, SW_SHOW
	cmp     eax, 32
	jle     @Exit
	
	; -> return TRUE
	sub     eax, eax
	inc     eax
	mov     bRet, eax
@Exit:
	mov     eax, bRet
	RET
FindLDSAndLunch ENDP

Main:
	; -> get LDS window handle
	invoke  FindWindow, NULL, offset LDS_WND_NAME
	test    eax, eax
	jnz     Save_LDS_Wnd_Handle
	
	; -> try to find LordPE entries in the registry and lunch LordPE Dumper Server
	call    FindLDSAndLunch
	dec     eax                                                            ; TRUE returned ?
	jz      LDS_Opened
	
	; error msg
	invoke  MessageBox, 0, offset szNoLDS, offset szCap, MB_OK or MB_ICONERROR
	jmp     @Exit
LDS_Opened:
	invoke  Sleep, 500	                                               ; wait for LDS to start up
	invoke  FindWindow, NULL, offset LDS_WND_NAME                          ; try again to get LDS wnd handle
	test    eax, eax
	jz      @Exit   
Save_LDS_Wnd_Handle:
	mov     hwndLDS, eax
	call    GetCurrentProcessId
	push    eax
	pop     dwMyPid                                                        ; save process id in "dwMyPid"

	; -> log plugin name in LDS
	mov     LogEntry.le_dwStructSize, sizeof LogEntry
	mov     LogEntry.le_szStr, offset szPluginName
	mov     LogEntry.le_dwStrSize, sizeof szPluginName
	mov     LogEntry.le_bCatAtLast, FALSE
	invoke  SendMessage, hwndLDS, WM_LDS_CMD_ADDLOG, dwMyPid, offset LogEntry
	
	; -> let user select a file
        mov     OFN.lStructSize, sizeof OFN
        mov     OFN.lpstrFilter, offset szOfnFilter
        push    hwndLDS
        pop     OFN.hWndOwner
        mov     OFN.lpstrFile, offset cFileName
        mov     OFN.nMaxFile, sizeof cFileName
        mov     OFN.lpstrInitialDir, offset szCurDir
        mov     OFN.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_HIDEREADONLY
        invoke  GetOpenFileName, offset OFN
        dec     eax
        jnz     @Exit

        ; -> create process
        mov     SI_.cb, sizeof SI_
        invoke  CreateProcess, offset cFileName, NULL, NULL, NULL, FALSE, 0, NULL, NULL, \
        	offset SI_, offset PI_
        dec     eax
        jz      @F
        invoke  MessageBox, hwndLDS, offset szProcCreateErr, offset szCap, MB_OK or MB_ICONERROR
        jmp     @Exit
@@:
	; -> wait, suspend, dump and let user save dumped image via LDS's ofn
	invoke  Sleep, 1000
	invoke  SuspendThread, PI_.hThread
	
	mov     FDumpInfo.fd_dwStructSize, sizeof FDumpInfo
	push    PI_.dwProcessId
	pop     FDumpInfo.fd_dwPID
	mov     FDumpInfo.fd_hModuleBase, NULL                                    ; dump calling module
	mov     FDumpInfo.fd_bDumpSuccessfully, 0
	mov     FDumpInfo.fd_dwFlags, LDS_DUMP_CORRECTIMAGESIZE or\
	                              LDS_DUMP_USEHEADERFROMDISK or\
	                              LDS_DUMP_FORCERAWMODE or\
	                              LDS_DUMP_SAVEVIAOFN or\
	                              LDS_REB_REALIGNIMAGE or\
	                              LDS_REB_WIPERELOCATIONOBJECT or\
	                              LDS_REB_REBUILDIMPORTS or\
	                              LDS_REB_VALIDATEIMAGE
	mov     FDumpInfo.fd_dwRealignType, 2
	invoke  SendMessage, hwndLDS, WM_LDS_CMD_DUMPPROCESSMODULE, dwMyPid, offset FDumpInfo
	
        ; kill process + cleanup
        invoke  TerminateProcess, PI_.hProcess, 0
        invoke  CloseHandle, PI_.hProcess
        invoke  CloseHandle, PI_.hThread
@Exit:
	invoke  ExitProcess, 0
End Main

:MAKE

\MASM32\BIN\Ml.exe /c /coff LDS_LoadDump.BAT
\MASM32\BIN\Link.exe /SUBSYSTEM:WINDOWS /MERGE:.idata=.text /MERGE:.data=.text /MERGE:.rdata=.text /SECTION:.text,EWR /IGNORE:4078  LDS_LoadDump.OBJ

DEL *.OBJ

ECHO.
PAUSE
CLS