/************************************************************************\

  SSPlugin.h

  Include file for the development of SoftSnoop plugins in C/C++.

  by yoda


  Additions/Changes in 1.1:
  -------------------------
  - Each plugin is now executed in an own thread !!!
  - SS_ENTRYREACHED
  - SS_DEBUGEVENT
  - SSAPI.lpbStopAtEntry
  - SSAPI.lpbPluginHandled
  - SSAPI.StartDebugSession
  - SSAPI.EndDebugSession
  - SSAPI.ExitSS
  - SSAPI.PrintStatus
  - SSAPI.lpbCmdArgs
  - SSAPI.szCmdArgs
  - SSAPI.lpbNoTrapDlls
  - SSAPI.szNoTrapDlls
  - SSAPI.lpbShowTIDs
  - SSAPI.ProcAddrToMenuID
  - APIRETURNVALUEINFO
  - SSAPI.SS_APIRETURNEX

\************************************************************************/


#ifndef __SSPlugin
#define __SSPlugin

#ifdef __cplusplus
extern "C" {
#endif

#define PLUGIN_INTERFACE_VERSION    0x00011000  // 1.1
#define SSAPIPROC                   __stdcall
#define MAX_PLUGIN_NUM              50
#define MAX_PLUGIN_WND_NUM          MAX_PLUGIN_NUM

/* 

-> Messages for the plugin windows

 SoftSnoop sends then SS_XXX messages via "SendMessage" therefore it'll
 wait for the plugin to finish until it continues its work.

*/

// wParam - 0
// lParam - 0
// Remarks:
//  SoftSnoop sends this message after all initialization works are done and
//  before the debug loop is entered.
#define SS_DEBUGSTART       WM_USER + 0x2000

// wParam - 0
// lParam - 0
// Remarks:
//  SoftSnoop sends this message after all cleanups are done and after the SoftSnoop
//  GUI was updated.
#define SS_DEBUGSTOP        WM_USER + 0x2001

// wParam - 0
// lParam - 0
// Remarks:
//  Plugins will also receive this message if then user disabled to stop
//  at the DEBUG_BREAK within SoftSnoop.
#define SS_DEBUGBREAK       WM_USER + 0x2002

// wParam - 0
// lParam - 0
// Remarks:
//  Plugins will only receive this message if SSAPI.lpbStopAtEntry is true.
//  If the handler of this window message wants to call SSAPI.ResumeProcess then
//  you've to set SSAPI.lpbPluginHandled to TRUE !!!
#define SS_ENTRYREACHED     WM_USER + 0x2007

// wParam - pointer to a APIINFO structure
// lParam - ESP of the thread who called the API (parameter modification possible :)
// Remarks:
//  Plugins are informed about *ALL* API calls and before SoftSnoop handles them.
#define SS_APICALL          WM_USER + 0x2003

// wParam - pointer to a APIINFO structure
// lParam - return value of the specified API
// Remarks:
// Plugins are informed about *ALL* API return values and before SoftSnoop handles them.
#define SS_APIRETURN        WM_USER + 0x2006

// wParam - pointer to a APIINFO structure
// lParam - pointer to a APIRETURNVALUEINFO structure
// Remarks:
// The same as SS_APIRETURN but with more information. The old one still exists to avoid
// version problems. The additional information provide the possibility to modify the
// return values of APIs easily. Set SSAPI.lpbPluginHandled to TRUE to avoid SS from
// modifing the return value of the current API and make the GUI print your changes !!!
#define SS_APIRETURNEX      WM_USER + 0x2008

// wParam - pointer to DEBUG_EVENT structure
// lParam - 0
// Remarks:
//  The plugins will be informed about the debug event before SoftSnoop will
//  be able to process it. You could prevent SoftSnoop and all at time not
//  informed plugins from processing the debug event if you set 
//  the "dwDebugEventCode" member of the DEBUG_EVENT structure to 0 !!!
//  Or you could set lpbPluginHandled to TRUE to avoid SS from processing
//  the current debug event.
#define SS_DEBUGEVENT       WM_USER + 0x2004

// wParam - pointer to NUL-terminated ASCII string which was added in
//          SS's main window listbox
// lParam - 0
#define SS_PRINTTEXT        WM_USER + 0x2005

/* SoftSnoop API prototypes */
typedef void   (SSAPIPROC* fPrint)(char* szText);
typedef BOOL   (SSAPIPROC* fStartSSPlugin)();
typedef int    (SSAPIPROC* fShowError)(char* szText);
typedef BOOL   (SSAPIPROC* fAddPluginFunction)(char* szPName, fStartSSPlugin pFunctAddr);
typedef void   (SSAPIPROC* fResumeProcess)();
typedef void   (SSAPIPROC* fSuspendProcess)();
typedef BOOL   (SSAPIPROC* fRegisterPluginWindow)(HWND hPluginWnd);
typedef BOOL   (SSAPIPROC* fUnregisterPluginWindow)(HWND hPluginWnd);
typedef void   (SSAPIPROC* fSetSSOnTop)(BOOL bTop);
typedef DWORD  (SSAPIPROC* fGetSSApiVersion)();
typedef void   (SSAPIPROC* fStartDebugSession)();
typedef void   (SSAPIPROC* fPrintStatus)(char* szText);
typedef BOOL   (SSAPIPROC* fEndDebugSession)();
typedef void   (SSAPIPROC* fExitSS)();
typedef DWORD  (SSAPIPROC* fProcAddrToMenuID)(fStartSSPlugin pProc);

/* 
  
-> SoftSnoop API structures 

 ALL STRUCTURE ARE ALIGNED TO 1 BYTE !!!

*/

#pragma pack(1)
typedef struct
{
	char*                    szDllName;
	char*                    szApiName; // if the HIWORD is not zero than it's a
	                                    // pointer to a NUL-terminated ASCII string
	                                    // else it's an ordinal
} APIINFO, *LPAPIINFO;

typedef struct
{
	DWORD    dwRetVal;
	void*    pRetVal;
} APIRETURNVALUEINFO, *LPAPIRETURNVALUEINFO;

typedef struct
{
	// ------ 1.0 ------
	fPrint                   Print;                 // print msg in SS main wnd listbox
	fShowError               ShowError;             // show error msg in main wnd
	fAddPluginFunction       AddPluginFunction;     // add MenuItem in "Plugins"
	char*                    szDebuggeePath;        // FULL PATH of debuggee (only exe files)
	LPPROCESS_INFORMATION    pPI;                   // ...of debuggee
	LPBOOL                   lpbDebugging;          // currently debugging ?
	LPBOOL                   lpbWinNT;              // are we on NT ?
	LPDWORD                  lpdwImageBase;         // ...of debuggee
	LPDWORD                  lpdwSizeOfImage;       // ...of debuggee
	HWND                     hSSWnd;                // handle of SS main window
	HWND                     hLBDbg;                // handle of SS listbox in main win
	HINSTANCE                hSSInst;               // base of SoftSnoop.exe
	LPBOOL                   lpbHandleExceptions;
	LPBOOL                   lpbStopAtDB;           // stop at DEBUG_BREAK ?
	LPBOOL                   lpbGUIOutPut;          // SS debug output ?
	LPBOOL                   lpbGUIOnTop;           // SS main window topmost ?
	fResumeProcess           ResumeProcess;         // resume all threads
	fSuspendProcess          SuspendProcess;        // suspend all threads

	// After a successfull call of this function
	// the specified window will receive the SS_XXX messages
	fRegisterPluginWindow    RegisterPluginWindow; 

	// Every window which shouldn't receive the SS_XXX messages anymore or
	// is closed should call this function !
	fUnregisterPluginWindow  UnregisterPluginWindow;

	fSetSSOnTop              SetSSOnTop;

	// In the HIWORD of the returned DWORD is the number before the comma
	// and in the LOWORD is the number after the comma.
	// E.g.:  1.23  -> 0x00012300
	fGetSSApiVersion         GetSSApiVersion;

	// ------ 1.1 ------
	LPBOOL                   lpbPluginHandled;      // see SS_ENTRYREACHED, SS_DEBUGEVENT,
                                                    // SS_APIRETURNEX
	LPBOOL                   lpbStopAtEntry;        // stop at EntryPoint ?
	LPBOOL                   lpbShowTIDs;           // "Show TID of events" ?

	// EntryPoint VA (with ImageBase) of debuggee. This isn't already available
	// at the time of SS_DEBUGSTART but at the time of SS_DEBUGBREAK or SS_ENTRYREACHED !
	LPDWORD                  lpdwEntryPointVA;

	// Plugin menu stuff
	HANDLE                   hPluginMenu;           // "Plugins" submenu handle
	// pProc is the address of the function you exported as "StartSSPlugin" or
	// you passed to AddPluginFunction.
	fProcAddrToMenuID        ProcAddrToMenuID;

	// A new debug session with the exe file path pointed
	// by SSAPI.szDebuggeePath will be started.
	fStartDebugSession       StartDebugSession;

	// The same effect as pressing the read circle button in SS.
	fEndDebugSession         EndDebugSession;

	// Cleans up and quits SS.
	fExitSS                  ExitSS;

	// Puts a string into the status line of the SS main window.
	// You can pass NULL to this function to set the standart status text
	// ("Debugging: FILENAME...").
	fPrintStatus             PrintStatus;

	// Additional commandline parameters
	LPBOOL                   lpbCmdArgs;
	char*                    szCmdArgs;             // MAX_PATH size

	// No-trap dll list
	LPBOOL                   lpbNoTrapDlls;
	char*                    szNoTrapDlls;          // 300 size

	// To be continued... a bigger structure will be also compatible to
	// to plugins which expect an older version of the structure.
} SSAPI, *LPSSAPI;
#pragma pack()

typedef LPSSAPI (__stdcall* fGetSSApi)();

#ifdef __cplusplus
}
#endif

#endif // __SSPlugin