Comment %
******************************************************************************

  LDS.INC (MASM/TASM)
  -------

  version: 0.2

  Include file for LordPE Dumper Server plugins.
  Please send me (LordPE@gmx.net) your plugins.

  by yoda

******************************************************************************
%

;
; ---- CONSTANTS -------------------------------------------------------------
;

LDS_INTERFACE_VERSION                      EQU     000000002h                  ; 0.2
.CONST
LDS_WND_NAME                               DB      "[ LordPE Dumper Server ]", 0

; commands
WM_LDS_CMD_FIRST                           EQU     WM_USER + 07000h

; wParam - client PID
; lParam - PLDS_VERSION
WM_LDS_CMD_QUERYVERSION                    EQU     WM_LDS_CMD_FIRST +  10

; wParam - client PID
; lParam - PLDS_LOG_ENTRY
WM_LDS_CMD_ADDLOG                          EQU     WM_LDS_CMD_FIRST +  20      ; max are 1024 characters (including NUL)

; wParam - client PID
; lParam - PLDS_MODULE_INFO
WM_LDS_CMD_QUERYPROCESSMODULEINFO          EQU     WM_LDS_CMD_FIRST +  30

; wParam - client PID
; lParam - PLDS_ENUM_PIDS
WM_LDS_CMD_ENUMPROCESSIDS                  EQU     WM_LDS_CMD_FIRST +  31

; wParam - client PID
; lParam - PLDS_ENUM_PROCESSMODULES
WM_LDS_CMD_ENUMPROCESSMODULES              EQU     WM_LDS_CMD_FIRST +  32

; wParam - client PID
; lParam - PLDS_FIND_PID
WM_LDS_CMD_FINDPROCESSID                   EQU     WM_LDS_CMD_FIRST +  33

; wParam - client PID
; lParam - PLDS_FULL_DUMP/PLDS_FULL_DUMP_EX
WM_LDS_CMD_DUMPPROCESSMODULE               EQU     WM_LDS_CMD_FIRST +  40

; wParam - client PID
; lParam - PLDS_PARTIAL_DUMP
WM_LDS_CMD_DUMPPROCESSBLOCK                EQU     WM_LDS_CMD_FIRST +  41

; dump options
LDS_DUMP_CORRECTIMAGESIZE                  EQU     000000001h
LDS_DUMP_USEHEADERFROMDISK                 EQU     000000002h
LDS_DUMP_FORCERAWMODE                      EQU     000000004h
LDS_DUMP_SAVEVIAOFN                        EQU     000000008h

; rebuilding options
LDS_REB_REALIGNIMAGE                       EQU     000010000h
LDS_REB_WIPERELOCATIONOBJECT               EQU     000020000h
LDS_REB_REBUILDIMPORTS                     EQU     000040000h
LDS_REB_VALIDATEIMAGE                      EQU     000080000h
LDS_REB_CHANGEIMAGEBASE                    EQU     000100000h

;
; ---- STRUCTURES ------------------------------------------------------------
; (the uncool structure element prefixes are needed for TASM)
;

LDS_VERSION                            STRUCT
	v_dwStructSize                 DWORD  ?
	v_dwVersion                    DWORD  ?
LDS_VERSION                            ENDS
PLDS_VERSION                           TYPEDEF PTR LDS_VERSION

LDS_LOG_ENTRY                          STRUCT
	le_dwStructSize                DWORD  ?
	le_szStr                       LPSTR  ?
	le_dwStrSize                   DWORD  ?                                ; including NUL-character
	le_bCatAtLast                  BOOL   ?                                ; add str at end of last item's text ?
LDS_LOG_ENTRY                          ENDS
PLDS_LOG_ENTRY                         TYPEDEF PTR LDS_LOG_ENTRY

LDS_MODULE_INFO                        STRUCT
	mi_dwStructSize                DWORD  ?
	mi_dwPID                       DWORD  ?
	mi_hImageBase                  HANDLE ?                                ; if NULL - calling module is snapped
	mi_dwImageSize                 DWORD  ?
	mi_cModulePath                 CHAR MAX_PATH DUP (?)                   ; cModulePath[0] == 0 if not set
LDS_MODULE_INFO                        ENDS
PLDS_MODULE_INFO                       TYPEDEF PTR LDS_MODULE_INFO

LDS_ENUM_PIDS                          STRUCT
	ep_dwStructSize                DWORD  ?
	ep_dwChainSize                 DWORD  ?
	ep_pdwPIDChain                 LPVOID ?                                ; DWORD array for PIDs
	ep_dwItemCount                 DWORD  ?
LDS_ENUM_PIDS                          ENDS
PLDS_ENUM_PIDS                         TYPEDEF PTR LDS_ENUM_PIDS

LDS_ENUM_PROCESS_MODULES               STRUCT
	epm_dwStructSize               DWORD  ?
	epm_dwPID                      DWORD  ?
	epm_dwChainSize                DWORD  ?
	epm_pdwImageBaseChain          LPVOID ?                                ; DWORD array for module handles
	epm_dwItemCount                DWORD  ?
LDS_ENUM_PROCESS_MODULES               ENDS
PLDS_ENUM_PROCESS_MODULES              TYPEDEF PTR LDS_ENUM_PROCESS_MODULES

LDS_FIND_PID                           STRUCT
	fp_dwStructSize                DWORD  ?
	fp_cProcessPath                CHAR MAX_PATH DUP (?)                   ; can be incomplete
	fp_dwPID                       DWORD  ?
LDS_FIND_PID                           ENDS
PLDS_FIND_PID                          TYPEDEF PTR LDS_FIND_PID

LDS_FULL_DUMP                          STRUCT
	fd_dwStructSize                DWORD  ?
	fd_dwFlags                     DWORD  ?                                ; LDS_DUMP_XXX/LDS_REB_XXX
	fd_dwPID                       DWORD  ?
	fd_hModuleBase                 HANDLE ?                                ; NULL - calling module is dumped
	fd_bDumpSuccessfully           BOOL   ?
	fd_dwSizeOfDumpedImage         DWORD  ?
	fd_bUserSaved                  BOOL   ?                                ; LDS_DUMP_SAVEVIAOFN
	fd_cSavedTo                    CHAR MAX_PATH DUP (?)                   ; LDS_DUMP_SAVEVIAOFN
	fd_pDumpedImage                LPVOID ?                                ; !LDS_DUMP_SAVEVIAOFN
	; rebuilding structure elements
	fd_dwRealignType               DWORD  ?                                ; 0-normal 1-hardcore 2-nice
	fd_dwNewImageBase              DWORD  ?                                ; format: 0xXXXX0000
LDS_FULL_DUMP                          ENDS
PLDS_FULL_DUMP                         TYPEDEF PTR LDS_FULL_DUMP

LDS_FULL_DUMP_EX                       STRUCT                                  ; ver 0.2
	fd_dwStructSize                DWORD  ?
	fd_dwFlags                     DWORD  ?                                ; LDS_DUMP_XXX/LDS_REB_XXX
	fd_dwPID                       DWORD  ?
	fd_hModuleBase                 HANDLE ?                                ; NULL - calling module is dumped
	fd_bDumpSuccessfully           BOOL   ?
	fd_dwSizeOfDumpedImage         DWORD  ?
	fd_bUserSaved                  BOOL   ?                                ; LDS_DUMP_SAVEVIAOFN
	fd_cSavedTo                    CHAR MAX_PATH DUP (?)                   ; LDS_DUMP_SAVEVIAOFN
	fd_pDumpedImage                LPVOID ?                                ; !LDS_DUMP_SAVEVIAOFN
	; rebuilding structure elements
	fd_dwRealignType               DWORD  ?                                ; 0-normal 1-hardcore 2-nice
	fd_dwNewImageBase              DWORD  ?                                ; format: 0xXXXX0000
	dwEntryPointRva                DWORD  ?                                ; 0 = don't set to image
	dwExportTableRva               DWORD  ?                                ; 0 = don't set to image
	dwImportTableRva               DWORD  ?                                ; 0 = don't set to image
	dwResourceDirRva               DWORD  ?                                ; 0 = don't set to image
	dwRelocationDirRva             DWORD  ?                                ; 0 = don't set to image
LDS_FULL_DUMP_EX                       ENDS
PLDS_FULL_DUMP_EX                      TYPEDEF PTR LDS_FULL_DUMP_EX

LDS_PARTIAL_DUMP                       STRUCT
	pd_dwStructSize                DWORD  ?
	pd_dwPID                       DWORD  ?
	pd_pBlock                      LPVOID ?
	pd_dwBlockSize                 DWORD  ?
	pd_bSaveViaOfn                 BOOL   ?
	pd_bDumpSuccessfully           BOOL   ?
	pd_bUserSaved                  BOOL   ?                                ; bSaveViaOfn
	pd_cSavedTo                    CHAR MAX_PATH DUP (?)                   ; bSaveViaOfn
	pd_pDumpedImage                LPVOID ?                                ; !bSaveViaOfn
LDS_PARTIAL_DUMP                       ENDS
PLDS_PARTIAL_DUMP                      TYPEDEF PTR LDS_PARTIAL_DUMP