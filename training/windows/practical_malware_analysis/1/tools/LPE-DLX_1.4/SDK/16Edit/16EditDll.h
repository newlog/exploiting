
/*****************************************************************************

  16EditDll.h (VC/BC)
  -----------

  version: FX

  Include file for 16Edit.dll.

  by yoda

*****************************************************************************/

#ifndef __16EditDll_h__
#define __16EditDll_h__

#include <windows.h>

//
// constants
//

// handler action codes
#define HE_ACTION_EXITING                0x00000001
#define HE_ACTION_SAVED                  0x00000002
#define HE_ACTION_FILEACCESSINFO         0x00000004
#define HE_ACTION_WINDOWCREATED          0x00000008

// flags for HE_SETTINGS
#define HE_SET_FORCEREADONLY             0x00000001
#define HE_SET_NORESIZE                  0x00000002
#define HE_SET_SETCURRENTOFFSET          0x00000004
#define HE_SET_SETSELECTION              0x00000008
#define HE_SET_ACTIONHANDLER             0x00000010
#define HE_SET_INPUTFILE                 0x00000020
#define HE_SET_MEMORYBLOCKINPUT          0x00000040
#define HE_SET_ONTOP                     0x00000080
#define HE_SET_PARENTWINDOW              0x00000100
#define HE_SET_MINIMIZETOTRAY            0x00000200
#define HE_SET_SAVEWINDOWPOSITION        0x00000400
#define HE_SET_RESTOREWINDOWPOSITION     0x00000800
#define HE_SET_USERWINDOWPOSITION        0x00001000

//
// structures
//

// force byte alignment of structures
#if defined(__BORLANDC__)
#pragma option -a1
#else if defined(_MSC_VER)
#pragma pack(1)
#endif

#ifndef EXTERN_HE_STRUCTS
#define EXTERN_HE_STRUCTS

typedef struct _HE_DATA_INFO
{
	void*       pDataBuff;
	DWORD       dwSize;                // data indicator
	BOOL        bReadOnly;
} HE_DATA_INFO, *PHE_DATA_INFO;

typedef struct _HE_POS
{
	DWORD       dwOffset;
	BOOL        bHiword;       // (opt.) first digit of the pair ? ...or the 2nd one ?
	BOOL        bTextSection;  // (opt.) Caret in the text part ?
} HE_POS, *PHE_POS;

#endif // EXTERN_HE_STRUCTS

typedef struct _HE_WIN_POS
{
	int                 iState;             // SW_SHOWNORMAL/SW_MAXIMIZE/SW_MINIMIZE
	int                 ix, iy, icx, icy;   // left, top, width, height
} HE_WIN_POS, *PHE_WIN_POS;

typedef struct _HE_ACTION
{
	DWORD        dwActionCode;

	DWORD        dwNewSize;            // HE_ACTION_SAVED

	BOOL         bReadWrite;           // HE_ACTION_FILEACCESSINFO

	HWND         hwnd16Edit;           // HE_ACTION_WINDOWCREATED
} HE_ACTION, *PHE_ACTION;

typedef BOOL (__stdcall* procActionHandler)(PHE_ACTION pa);

typedef struct _HE_SETTINGS
{
	DWORD              dwMask;             // HE_SET_XXX flags

	procActionHandler  pHandler;           // HE_SET_ACTIONHANDLER

	HE_POS             posCaret;           // HE_SET_SETCURRENTOFFSET

	DWORD              dwSelStartOff;      // HE_SET_SETSELECTION
	DWORD              dwSelEndOff;        // 

	HWND               hwndParent;         // HE_SET_PARENTWINDOW

	union
	{
		char*                szFilePath;         // HE_SET_INPUTFILE

		HE_DATA_INFO         diMem;              // HE_SET_MEMORYBLOCKINPUT
	};

	HE_WIN_POS         wpUser;             // HE_SET_USERWINDOWPOSITION
} HE_SETTINGS, *PHE_SETTINGS;

#if defined(_MSC_VER)
#pragma pack()
#endif

//
// function prototypes
//

#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

BOOL   __stdcall HESpecifySettings(PHE_SETTINGS sets);
BOOL   __stdcall HEEnterWindowLoop();
BOOL   __stdcall HEEnterWindowLoopInNewThread();

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // __16EditDll_h__