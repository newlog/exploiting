
{*****************************************************************************

  LDS.pas
  -------

  version: 0.2

  Include file for LordPE Dumper Server plugins.
  Please send me (LordPE@gmx.net) your plugins.

  by yoda

*****************************************************************************}

{$A4}

unit LDS;

interface

uses Windows, Messages;

//
// constants
//
const

LDS_INTERFACE_VERSION                      = $00000002;                // 0.2
LDS_WND_NAME                               = '[ LordPE Dumper Server ]';

// commands
WM_LDS_CMD_FIRST                           = WM_USER + $7000;

// wParam - client PID
// lParam - PLDS_VERSION
WM_LDS_CMD_QUERYVERSION                    = WM_LDS_CMD_FIRST +  10;

// wParam - client PID
// lParam - PLDS_LOG_ENTRY
WM_LDS_CMD_ADDLOG                          = WM_LDS_CMD_FIRST +  20;   // max are 1024 characters (including NUL)

// wParam - client PID
// lParam - PLDS_MODULE_INFO
WM_LDS_CMD_QUERYPROCESSMODULEINFO          = WM_LDS_CMD_FIRST +  30;

// wParam - client PID
// lParam - PLDS_ENUM_PIDS
WM_LDS_CMD_ENUMPROCESSIDS                  = WM_LDS_CMD_FIRST +  31;

// wParam - client PID
// lParam - PLDS_ENUM_PROCESSMODULES
WM_LDS_CMD_ENUMPROCESSMODULES              = WM_LDS_CMD_FIRST +  32;

// wParam - client PID
// lParam - PLDS_FIND_PID
WM_LDS_CMD_FINDPROCESSID                   = WM_LDS_CMD_FIRST +  33;

// wParam - client PID
// lParam - PLDS_FULL_DUMP/PLDS_FULL_DUMP_EX
WM_LDS_CMD_DUMPPROCESSMODULE               = WM_LDS_CMD_FIRST +  40;

// wParam - client PID
// lParam - PLDS_PARTIAL_DUMP
WM_LDS_CMD_DUMPPROCESSBLOCK                = WM_LDS_CMD_FIRST +  41;

// dump options
LDS_DUMP_CORRECTIMAGESIZE                  = $00000001;
LDS_DUMP_USEHEADERFROMDISK                 = $00000002;
LDS_DUMP_FORCERAWMODE                      = $00000004;
LDS_DUMP_SAVEVIAOFN                        = $00000008;

// rebuilding options
LDS_REB_REALIGNIMAGE                       = $00010000;
LDS_REB_WIPERELOCATIONOBJECT               = $00020000;
LDS_REB_REBUILDIMPORTS                     = $00040000;
LDS_REB_VALIDATEIMAGE                      = $00080000;
LDS_REB_CHANGEIMAGEBASE                    = $00100000;

//
// structures
//
type
        PLDSVERSION                = ^LDS_VERSION;
        LDS_VERSION                = record
	    dwStructSize           : DWORD;
            dwVersion              : DWORD;
        End;

        PLDS_LOG_ENTRY             = ^LDS_LOG_ENTRY;
        LDS_LOG_ENTRY              = record
            dwStructSize           : DWORD;
            szStr                  : PChar;
            dwStrSize              : DWORD;                            // including NUL-character
	    bCatAtLast             : Boolean;                          // add str at end of last item's text ?
        End;

        PLDS_MODULE_INFO           = ^LDS_MODULE_INFO;
        LDS_MODULE_INFO            = record
            dwStructSize           : DWORD;
            dwPID                  : DWORD;
            hImageBase             : HModule;                          // if NULL - calling module is snapped
	    dwImageSize            : DWORD;
            cModulePath            : Array [0..MAX_PATH - 1] Of Char;  // cModulePath[0] == 0 if not set
        End;

        PLDS_ENUM_PIDS             = ^LDS_ENUM_PIDS;
        LDS_ENUM_PIDS              = record
            dwStructSize           : DWORD;
            dwChainSize            : DWORD;
            pdwPIDChain            : ^DWORD;                           // DWORD array for PIDs
	    dwItemCount            : DWORD;
        End;

        PLDS_ENUM_PROCESS_MODULES  = ^LDS_ENUM_PROCESS_MODULES;
        LDS_ENUM_PROCESS_MODULES   = record
            dwStructSize           : DWORD;
            dwPID                  : DWORD;
            dwChainSize            : DWORD;
	    pdwImageBaseChain      : ^DWORD;                           // DWORD array for module handles
	    dwItemCount            : DWORD;
        End;

        PLDS_FIND_PID              = ^LDS_FIND_PID;
        LDS_FIND_PID               = record
            dwStructSize           : DWORD;
            cProcessPath           : Array [0..MAX_PATH - 1] Of Char;  // can be incomplete
	    dwPID                  : DWORD;
        End;

        PLDS_FULL_DUMP             = ^LDS_FULL_DUMP;
        LDS_FULL_DUMP              = record
            dwStructSize           : DWORD;
            dwFlags                : DWORD;                            // LDS_DUMP_XXX/LDS_REB_XXX
	    dwPID                  : DWORD;
            hModuleBase            : HModule;                          // NULL - calling module is dumped
	    bDumpSuccessfully      : Boolean;
            dwSizeOfDumpedImage    : DWORD;
            bUserSaved             : Boolean;                          // LDS_DUMP_SAVEVIAOFN
	    cSavedTo               : Array [0..MAX_PATH - 1] Of Char;  // LDS_DUMP_SAVEVIAOFN
	    pDumpedImage           : Pointer;                          // !LDS_DUMP_SAVEVIAOFN

            // rebuilding structure elements
	    dwRealignType          : DWORD;                            // 0-normal 1-hardcore 2-nice
	    dwNewImageBase         : DWORD;                            // format: 0xXXXX0000
        End;

        PLDS_FULL_DUMP_EX          = ^LDS_FULL_DUMP_EX;
        LDS_FULL_DUMP_EX           = record
            dwStructSize           : DWORD;
            dwFlags                : DWORD;                            // LDS_DUMP_XXX/LDS_REB_XXX
	    dwPID                  : DWORD;
            hModuleBase            : HModule;                          // NULL - calling module is dumped
	    bDumpSuccessfully      : Boolean;
            dwSizeOfDumpedImage    : DWORD;
            bUserSaved             : Boolean;                          // LDS_DUMP_SAVEVIAOFN
	    cSavedTo               : Array [0..MAX_PATH - 1] Of Char;  // LDS_DUMP_SAVEVIAOFN
	    pDumpedImage           : Pointer;                          // !LDS_DUMP_SAVEVIAOFN

            // rebuilding structure elements
	    dwRealignType          : DWORD;                            // 0-normal 1-hardcore 2-nice
	    dwNewImageBase         : DWORD;                            // format: 0xXXXX0000
            dwEntryPointRva        : DWORD;                            // 0 = don't set to image
            dwExportTableRva       : DWORD;                            // 0 = don't set to image
            dwImportTableRva       : DWORD;                            // 0 = don't set to image
            dwResourceDirRva       : DWORD;                            // 0 = don't set to image
            dwRelocationDirRva     : DWORD;                            // 0 = don't set to image
        End;

        PLDS_PARTIAL_DUMP          = ^LDS_PARTIAL_DUMP;
        LDS_PARTIAL_DUMP           = record
            dwStructSize           : DWORD;
            dwPID                  : DWORD;
            pBlock                 : Pointer;
	    dwBlockSize            : DWORD;
            bSaveViaOfn            : Boolean;
            bDumpSuccessfully      : Boolean;
            bUserSaved             : Boolean;                          // bSaveViaOfn
	    cSavedTo               : Array [0..MAX_PATH-1] Of Char;    // bSaveViaOfn
	    pDumpedImage           : Pointer;                          // !bSaveViaOfn
        End;

implementation

end.
