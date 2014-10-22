
/*****************************************************************************

  LDS.h
  -----

  version: 0.2

  Include file for LordPE Dumper Server plugins.
  Please send me (LordPE@gmx.net) your plugins.

  by yoda

*****************************************************************************/

#ifndef __LDS_h__
#define __LDS_h__

#include <windows.h>

//
// constants
//

#define LDS_INTERFACE_VERSION              0x00000002              // 0.2
#define LDS_WND_NAME                       "[ LordPE Dumper Server ]"

// commands
#define WM_LDS_CMD_FIRST                   WM_USER + 0x7000

// wParam - client PID
// lParam - PLDS_VERSION
#define WM_LDS_CMD_QUERYVERSION            WM_LDS_CMD_FIRST +  10

// wParam - client PID
// lParam - PLDS_LOG_ENTRY
#define WM_LDS_CMD_ADDLOG                  WM_LDS_CMD_FIRST +  20  // max are 1024 characters (including NUL)

// wParam - client PID
// lParam - PLDS_MODULE_INFO
#define WM_LDS_CMD_QUERYPROCESSMODULEINFO  WM_LDS_CMD_FIRST +  30

// wParam - client PID
// lParam - PLDS_ENUM_PIDS
#define WM_LDS_CMD_ENUMPROCESSIDS          WM_LDS_CMD_FIRST +  31

// wParam - client PID
// lParam - PLDS_ENUM_PROCESSMODULES
#define WM_LDS_CMD_ENUMPROCESSMODULES      WM_LDS_CMD_FIRST +  32

// wParam - client PID
// lParam - PLDS_FIND_PID
#define WM_LDS_CMD_FINDPROCESSID           WM_LDS_CMD_FIRST +  33

// wParam - client PID
// lParam - PLDS_FULL_DUMP/PLDS_FULL_DUMP_EX
#define WM_LDS_CMD_DUMPPROCESSMODULE       WM_LDS_CMD_FIRST +  40

// wParam - client PID
// lParam - PLDS_PARTIAL_DUMP
#define WM_LDS_CMD_DUMPPROCESSBLOCK        WM_LDS_CMD_FIRST +  41

// dump options
#define LDS_DUMP_CORRECTIMAGESIZE          0x00000001
#define LDS_DUMP_USEHEADERFROMDISK         0x00000002
#define LDS_DUMP_FORCERAWMODE              0x00000004
#define LDS_DUMP_SAVEVIAOFN                0x00000008

// rebuilding options
#define LDS_REB_REALIGNIMAGE               0x00010000
#define LDS_REB_WIPERELOCATIONOBJECT       0x00020000
#define LDS_REB_REBUILDIMPORTS             0x00040000
#define LDS_REB_VALIDATEIMAGE              0x00080000
#define LDS_REB_CHANGEIMAGEBASE            0x00100000

//
// structures
//

// force byte alignment of structures
#if defined(__BORLANDC__)
#pragma option -a1
#else if defined(_MSC_VER)
#pragma pack(1)
#endif

typedef struct _LDS_VERSION
{
	IN     DWORD         dwStructSize;
	OUT    DWORD         dwVersion;
} LDS_VERSION, *PLDS_VERSION;

typedef struct _LDS_LOG_ENTRY
{
	IN     DWORD         dwStructSize;
	IN     char*         szStr;
	IN     DWORD         dwStrSize;                                // including NUL-character
	IN     BOOL          bCatAtLast;                               // add str at end of last item's text ?
} LDS_LOG_ENTRY, *PLDS_LOG_ENTRY;

typedef struct _LDS_MODULE_INFO
{
	IN     DWORD         dwStructSize;
	IN     DWORD         dwPID;
	IN OUT HMODULE       hImageBase;                               // if NULL - calling module is snapped
	OUT    DWORD         dwImageSize;
	OUT    char          cModulePath[MAX_PATH];                    // cModulePath[0] == 0 if not set
} LDS_MODULE_INFO, *PLDS_MODULE_INFO;

typedef struct _LDS_ENUM_PIDS
{
	IN     DWORD         dwStructSize;
	IN     DWORD         dwChainSize;
	OUT    PDWORD        pdwPIDChain;                              // DWORD array for PIDs
	OUT    DWORD         dwItemCount;
} LDS_ENUM_PIDS, *PLDS_ENUM_PIDS;

typedef struct _LDS_ENUM_PROCESS_MODULES
{
	IN     DWORD         dwStructSize;
	IN     DWORD         dwPID;
	IN     DWORD         dwChainSize;
	OUT    PDWORD        pdwImageBaseChain;                        // DWORD array for module handles
	OUT    DWORD         dwItemCount;
} LDS_ENUM_PROCESS_MODULES, *PLDS_ENUM_PROCESS_MODULES;

typedef struct _LDS_FIND_PID
{
	IN     DWORD         dwStructSize;
	IN     char          cProcessPath[MAX_PATH];                   // can be incomplete
	OUT    DWORD         dwPID;
} LDS_FIND_PID, *PLDS_FIND_PID;

typedef struct _LDS_FULL_DUMP
{
	IN     DWORD         dwStructSize;
	IN     DWORD         dwFlags;                                  // LDS_DUMP_XXX/LDS_REB_XXX
	IN     DWORD         dwPID;
	IN     HMODULE       hModuleBase;                              // NULL - calling module is dumped
	OUT    BOOL          bDumpSuccessfully;
	OUT    DWORD         dwSizeOfDumpedImage;
	OUT    BOOL          bUserSaved;                               // LDS_DUMP_SAVEVIAOFN
	OUT    char          cSavedTo[MAX_PATH];                       // LDS_DUMP_SAVEVIAOFN
	OUT    void*         pDumpedImage;                             // !LDS_DUMP_SAVEVIAOFN
	// rebuilding structure elements
	IN     DWORD         dwRealignType;                            // 0-normal 1-hardcore 2-nice
	IN     DWORD         dwNewImageBase;                           // format: 0xXXXX0000
} LDS_FULL_DUMP, *PLDS_FULL_DUMP;

typedef struct _LDS_FULL_DUMP_EX                                   // ver 0.2
{
	IN     DWORD         dwStructSize;
	IN     DWORD         dwFlags;                                  // LDS_DUMP_XXX/LDS_REB_XXX
	IN     DWORD         dwPID;
	IN     HMODULE       hModuleBase;                              // NULL - calling module is dumped
	OUT    BOOL          bDumpSuccessfully;
	OUT    DWORD         dwSizeOfDumpedImage;
	OUT    BOOL          bUserSaved;                               // LDS_DUMP_SAVEVIAOFN
	OUT    char          cSavedTo[MAX_PATH];                       // LDS_DUMP_SAVEVIAOFN
	OUT    void*         pDumpedImage;                             // !LDS_DUMP_SAVEVIAOFN
	// rebuilding structure elements
	IN     DWORD         dwRealignType;                            // 0-normal 1-hardcore 2-nice
	IN     DWORD         dwNewImageBase;                           // format: 0xXXXX0000
	IN     DWORD         dwEntryPointRva;                          // 0 = don't set to image
	IN     DWORD         dwExportTableRva;                         // 0 = don't set to image
	IN     DWORD         dwImportTableRva;                         // 0 = don't set to image
	IN     DWORD         dwResourceDirRva;                         // 0 = don't set to image
	IN     DWORD         dwRelocationDirRva;                       // 0 = don't set to image
} LDS_FULL_DUMP_EX, *PLDS_FULL_DUMP_EX;

typedef struct _LDS_PARTIAL_DUMP
{
	IN     DWORD         dwStructSize;
	IN     DWORD         dwPID;
	IN     void*         pBlock;
	IN     DWORD         dwBlockSize;
	IN     BOOL          bSaveViaOfn;
	OUT    BOOL          bDumpSuccessfully;
	OUT    BOOL          bUserSaved;                               // bSaveViaOfn
	OUT    char          cSavedTo[MAX_PATH];                       // bSaveViaOfn
	OUT    void*         pDumpedImage;                             // !bSaveViaOfn
} LDS_PARTIAL_DUMP, *PLDS_PARTIAL_DUMP;

#if defined(_MSC_VER)
#pragma pack()
#endif

#endif // __LDS_h__
