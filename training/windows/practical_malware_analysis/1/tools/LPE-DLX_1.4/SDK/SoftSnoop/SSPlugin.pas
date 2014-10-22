{
SSPlugin.PAS

Include file for the development of SoftSnoop plugins in Delphi.
For detailed information have a look at SSPlugin.h !

by yoda
}

unit SSPlugin;

interface
uses windows, messages;

CONST
PLUGIN_INTERFACE_VERSION      = $00011000;  // 1.1
MAX_PLUGIN_NUM                = 50;
MAX_PLUGIN_WND_NUM            = MAX_PLUGIN_NUM;

// Messages for the plugin windows
SS_DEBUGSTART                 = WM_USER + $2000;
SS_DEBUGSTOP                  = WM_USER + $2001;
SS_DEBUGBREAK                 = WM_USER + $2002;
SS_APICALL                    = WM_USER + $2003;
SS_APIRETURN                  = WM_USER + $2006;
SS_DEBUGEVENT                 = WM_USER + $2004;
SS_PRINTTEXT                  = WM_USER + $2005;
SS_ENTRYREACHED               = WM_USER + $2007;
SS_APIRETURNEX                = WM_USER + $2008;

TYPE
// SoftSnoop API prototypes
fPrint                  = PROCEDURE(szText : pchar); STDCALL;
fStartSSPlugin          = FUNCTION() : boolean; STDCALL;
fShowError              = FUNCTION(szText : pchar) : integer; STDCALL;
fAddPluginFunction      = FUNCTION(szPName : pchar; pFunctAddr : fStartSSPlugin) : boolean; STDCALL;
fResumeProcess          = PROCEDURE(); STDCALL;
fSuspendProcess         = PROCEDURE(); STDCALL;
fRegisterPluginWindow   = FUNCTION(hPluginWnd : HWND) : boolean; STDCALL;
fUnregisterPluginWindow = FUNCTION(hPluginWnd : HWND) : boolean; STDCALL;
fSetSSOnTop             = PROCEDURE(bTop : boolean); STDCALL;
fGetSSApiVersion        = FUNCTION() : DWORD; STDCALL;
fStartDebugSession      = PROCEDURE(); STDCALL;
fPrintStatus            = PROCEDURE(szText : pchar); STDCALL;
fEndDebugSession        = FUNCTION() : BOOL; STDCALL;
fExitSS                 = PROCEDURE(); STDCALL;
fProcAddrToMenuID       = FUNCTION(pProc : fStartSSPlugin) : DWORD; STDCALL;

// SoftSnoop API structure
// ALL STRUCTURE ARE ALIGNED TO 1 BYTE !!!
APIInfo              = packed record
    szDllName        : pchar;
    szApiName        : pchar;
END;
LPAPIINFO = ^APIINFO;

APIRETURNVALUEINFO   = packed record
    dwRetVal         : DWORD;
    pRetVal          : Pointer;
END;
LPAPIRETURNVALUEINFO = ^APIRETURNVALUEINFO;

SSAPI                          = packed record
    Print                      : fPrint;
    ShowError                  : fShowError;
    AddPluginFunction          : fAddPluginFunction;
    szDebuggeePath             : pchar;
    pPI                        : ^PROCESS_INFORMATION;
    lpbDebugging               : ^boolean;
    lpbWinNT                   : ^boolean;
    ImageBase                  : ^DWORD;
    SizeOfImage                : ^DWORD;
    hSSWnd                     : HWND;
    hLBDbg                     : HWND;
    hSSInst                    : HINST;
    lpbHandleExceptions        : ^boolean;
    lpbStopAtDB                : ^boolean;
    lpbGUIOutPut               : ^boolean;
    lpbGUIOnTop                : ^boolean;
    ResumeProcess              : fResumeProcess;
    SuspendProcess             : fSuspendProcess;
    RegisterPluginWindow       : fRegisterPluginWindow;
    UnregisterPluginWindow     : fUnregisterPluginWindow;
    SetSSOnTop                 : fSetSSOnTop;
    GetSSApiVersion            : fGetSSApiVersion;

    // ------ 1.1 ------
    lpbPluginHandled           : ^boolean;
    lpbStopAtEntry             : ^boolean;
    lpbShowTIDs                : ^boolean;
    lpdwEntryPointVA           : ^DWORD;
    hPluginMenu                : THandle;
    ProcAddrToMenuID           : fProcAddrToMenuID;
    StartDebugSession          : fStartDebugSession;
    EndDebugSession            : fEndDebugSession;
    ExitSS                     : fExitSS;
    PrintStatus                : fPrintStatus;
    lpbCmdArgs                 : ^boolean;
    szCmdArgs                  : pchar; // MAX_PATH
    lpbNoTrapDlls              : ^boolean;
    szNoTrapDlls               : pchar; // 300 byte
END;
LPSSAPI = ^SSAPI;

fGetSSApi = FUNCTION() : LPSSAPI; STDCALL;

implementation

end.
