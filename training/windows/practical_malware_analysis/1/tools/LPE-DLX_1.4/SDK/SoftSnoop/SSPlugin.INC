Comment @

SSPlugin.INC

Include file for the development of SoftSnoop plugins in MASM.
For detailed information have a look at SSPlugin.h !

by yoda

@

IFNDEF __SSPlugin
__SSPlugin EQU 1

PLUGIN_INTERFACE_VERSION    EQU 00011000h  ; 1.1
SSAPIPROC                   EQU STDCALL
MAX_PLUGIN_NUM              EQU 50
MAX_PLUGIN_WND_NUM          EQU MAX_PLUGIN_NUM

;-> Messages for the plugin windows
SS_DEBUGSTART               EQU WM_USER + 02000h
SS_DEBUGSTOP                EQU WM_USER + 02001h
SS_DEBUGBREAK               EQU WM_USER + 02002h
SS_APICALL                  EQU WM_USER + 02003h
SS_APIRETURN                EQU WM_USER + 02006h
SS_DEBUGEVENT               EQU WM_USER + 02004h
SS_PRINTTEXT                EQU WM_USER + 02005h
SS_ENTRYREACHED             EQU WM_USER + 02007h
SS_APIRETURNEX              EQU WM_USER + 02008h

;-> SoftSnoop API structures
;ALL STRUCTURE ARE ALIGNED TO 1 BYTE !!!

APIINFO STRUCT
	szDllName                 DD ?
	szApiName                 DD ?
APIINFO ENDS

APIRETURNVALUEINFO STRUCT
	dwRetVal                  DD ?
	pRetVal                   DD ?	
APIRETURNVALUEINFO ENDS

SSAPI STRUCT
	Print                     DD ?                                           ; function address
	ShowError                 DD ?                                           ; function address
	AddPluginFunction         DD ?                                           ; function address
	szDebuggeePath            DD ?                                           ; function address
	pPI                       DD ?                                           ; pointer to PROCESS_INFORMATION
	lpbDebugging              DD ?                                           ; LPBOOL
	lpbWinNT                  DD ?                                           ; LPBOOL
	ImageBase                 DD ?                                           ; LPBOOL
	SizeOfImage               DD ?                                           ; LPBOOL
	hSSWnd                    DD ?                                           ; HWND
	hLBDbg                    DD ?                                           ; HWND
	hSSInst                   DD ?                                           ; HINSTANCE
	lpbHandleExceptions       DD ?                                           ; LPBOOL
	lpbStopAtDB               DD ?                                           ; LPBOOL
	lpbGUIOutPut              DD ?                                           ; LPBOOL
	lpbGUIOnTop               DD ?                                           ; LPBOOL
	ResumeProcess             DD ?                                           ; function address
	SuspendProcess            DD ?                                           ; function address
	RegisterPluginWindow      DD ?                                           ; function address
	UnregisterPluginWindow    DD ?                                           ; function address
	SetSSOnTop                DD ?                                           ; function address
	GetSSApiVersion           DD ?                                           ; function address
	
	;------ 1.1 ------
	lpbPluginHandled          DD ?                                           ; LPBOOL
	lpbStopAtEntry            DD ?                                           ; LPBOOL
	lpbShowTIDs               DD ?                                           ; LPBOOL
	lpdwEntryPointVA          DD ?                                           ; LPDWORD
	hPluginMenu               DD ?                                           ; HANDLE
	ProcAddrToMenuID          DD ?                                           ; function address
	StartDebugSession         DD ?                                           ; function address
	EndDebugSession           DD ?                                           ; function address
	ExitSS                    DD ?                                           ; function address
	PrintStatus               DD ?                                           ; function address
	lpbCmdArgs                DD ?                                           ; LPBOOL
	szCmdArgs                 DD ?                                           ; LPSTR (size: MAX_PATH)
	lpbNoTrapDlls             DD ?                                           ; LPBOOL
	szNoTrapDlls              DD ?                                           ; LPSTR (size: 300)

	; To be continued... a bigger structure will be also compatible to
	; to plugins which expect an older version of the structure.
SSAPI ENDS

ENDIF