
;******************************************************************************
;
;  LDS.ni (NASM)
;  ------
;
;  version: 0.2
;
;  Include file for LordPE Dumper Server plugins.
;  Please send me (LordPE@gmx.net) your plugins.
;
;  by yoda
;
;******************************************************************************

%ifndef __LDS_ni__
%define __LDS_ni__

;
; ---- CONSTANTS -------------------------------------------------------------
;
LDS_INTERFACE_VERSION                      EQU     000000002h                  ; 0.2
LDS_WND_NAME:                              DB      "[ LordPE Dumper Server ]", 0
MAX_PATH                                   EQU     260

; commands
WM_USER                                    EQU     000000400h
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
;

STRUC LDS_VERSION
	.dwStructSize                 RESD  1
	.dwVersion                    RESD  1	
ENDSTRUC

STRUC LDS_LOG_ENTRY
	.dwStructSize                 RESD  1
	.szStr                        RESD  1
	.dwStrSize                    RESD  1                                  ; including NUL-character
	.bCatAtLast                   RESD  1                                  ; add str at end of last item's text ?
ENDSTRUC

STRUC LDS_MODULE_INFO
	.dwStructSize                 RESD  1
	.dwPID                        RESD  1
	.hImageBase                   RESD  1                                  ; if NULL - calling module is snapped
	.dwImageSize                  RESD  1
	.cModulePath                  RESB  MAX_PATH                           ; cModulePath[0] == 0 if not set
ENDSTRUC

STRUC LDS_ENUM_PIDS
	.dwStructSize                 RESD  1
	.dwChainSize                  RESD  1
	.pdwPIDChain                  RESD  1                                  ; DWORD array for PIDs
	.dwItemCount                  RESD  1
ENDSTRUC

STRUC LDS_ENUM_PROCESS_MODULES
	.dwStructSize                 RESD  1
	.dwPID                        RESD  1
	.dwChainSize                  RESD  1
	.pdwImageBaseChain            RESD  1                                  ; DWORD array for module handles
	.dwItemCount                  RESD  1
ENDSTRUC

STRUC LDS_FIND_PID
	.dwStructSize                 RESD  1
	.cProcessPath                 RESB  MAX_PATH                           ; can be incomplete
	.dwPID                        RESD  1
ENDSTRUC

STRUC LDS_FULL_DUMP
	.dwStructSize                 RESD  1
	.dwFlags                      RESD  1                                  ; LDS_DUMP_XXX/LDS_REB_XXX
	.dwPID                        RESD  1
	.hModuleBase                  RESD  1                                  ; NULL - calling module is dumped
	.bDumpSuccessfully            RESD  1
	.dwSizeOfDumpedImage          RESD  1
	.bUserSaved                   RESD  1                                  ; LDS_DUMP_SAVEVIAOFN
	.cSavedTo                     RESB  MAX_PATH                           ; LDS_DUMP_SAVEVIAOFN
	.pDumpedImage                 RESD  1                                  ; !LDS_DUMP_SAVEVIAOFN
	; rebuilding structure elements
	.dwRealignType                RESD  1                                  ; 0-normal 1-hardcore 2-nice
	.dwNewImageBase               RESD  1                                  ; format: 0xXXXX0000
ENDSTRUC

STRUC LDS_FULL_DUMP_EX
	.dwStructSize                 RESD  1
	.dwFlags                      RESD  1                                  ; LDS_DUMP_XXX/LDS_REB_XXX
	.dwPID                        RESD  1
	.hModuleBase                  RESD  1                                  ; NULL - calling module is dumped
	.bDumpSuccessfully            RESD  1
	.dwSizeOfDumpedImage          RESD  1
	.bUserSaved                   RESD  1                                  ; LDS_DUMP_SAVEVIAOFN
	.cSavedTo                     RESB  MAX_PATH                           ; LDS_DUMP_SAVEVIAOFN
	.pDumpedImage                 RESD  1                                  ; !LDS_DUMP_SAVEVIAOFN
	; rebuilding structure elements
	.dwRealignType                RESD  1                                  ; 0-normal 1-hardcore 2-nice
	.dwNewImageBase               RESD  1                                  ; format: 0xXXXX0000
	.dwEntryPointRva              RESD  1                                  ; 0 = don't set to image
	.dwExportTableRva             RESD  1                                  ; 0 = don't set to image
	.dwImportTableRva             RESD  1                                  ; 0 = don't set to image
	.dwResourceDirRva             RESD  1                                  ; 0 = don't set to image
	.dwRelocationDirRva           RESD  1                                  ; 0 = don't set to image
ENDSTRUC

STRUC LDS_PARTIAL_DUMP
	.dwStructSize                 RESD  1
	.dwPID                        RESD  1
	.pBlock                       RESD  1
	.dwBlockSize                  RESD  1
	.bSaveViaOfn                  RESD  1
	.bDumpSuccessfully            RESD  1
	.bUserSaved                   RESD  1                                  ; bSaveViaOfn
	.cSavedTo                     RESB  MAX_PATH                           ; bSaveViaOfn
	.pDumpedImage                 RESD  1                                  ; !bSaveViaOfn
ENDSTRUC

%endif ; __LDS_ni__