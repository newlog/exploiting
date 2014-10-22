{*****************************************************************************

  HEditDll.pas (Delphi)
  ------------

  version: FX

  Include file for 16Edit.dll.

  by yoda

*****************************************************************************}


unit HEditDll;

interface

uses windows;

const

//
// constants
//

// handler action codes
HE_ACTION_EXITING                      = $00000001;
HE_ACTION_SAVED                        = $00000002;
HE_ACTION_FILEACCESSINFO               = $00000004;
HE_ACTION_WINDOWCREATED                = $00000008;

// flags for HE_SETTINGS
HE_SET_FORCEREADONLY                   = $00000001;
HE_SET_NORESIZE                        = $00000002;
HE_SET_SETCURRENTOFFSET                = $00000004;
HE_SET_SETSELECTION                    = $00000008;
HE_SET_ACTIONHANDLER                   = $00000010;
HE_SET_INPUTFILE                       = $00000020;
HE_SET_MEMORYBLOCKINPUT                = $00000040;
HE_SET_ONTOP                           = $00000080;
HE_SET_PARENTWINDOW                    = $00000100;
HE_SET_MINIMIZETOTRAY                  = $00000200;
HE_SET_SAVEWINDOWPOSITION              = $00000400;
HE_SET_RESTOREWINDOWPOSITION           = $00000800;
HE_SET_USERWINDOWPOSITION              = $00001000;

type

//
// structures
//
    PHE_DATA_INFO       = ^HE_DATA_INFO;
    HE_DATA_INFO        = packed record
        pDataBuff       : Pointer;
        dwSize          : DWORD;                 // data indicator
        bReadOnly       : BOOL;
    End;

    PHE_POS             = ^HE_POS;
    HE_POS              = packed record
        dwOffset        : DWORD;
        bHiword         : BOOL;                  // (opt.) first digit of the pair ? ...or the 2nd one ?
        bTextSelection  : BOOL;                  // (opt.) Caret in the text part ?
    End;

    PHE_WIN_POS         = ^HE_WIN_POS;
    HE_WIN_POS          = packed record
        iState          : Integer;               // SW_SHOWNORMAL/SW_MAXIMIZE/SW_MINIMIZE
        ix, iy, icx, icy: Integer;               // left, top, width, height
    End;


    PHE_ACTION          = ^HE_ACTION;
    HE_ACTION           = packed record
        dwActionCode    : DWORD;
        dwNewSize       : DWORD;                 // HE_ACTION_SAVED
        bReadWrite      : BOOL;                  // HE_ACTION_FILEACCESSINFO
        hwnd16Edit      : HWND;                  // HE_ACTION_WINDOWCREATED
    End;

    INPUT_UNION         = record
        Case Integer Of
        0: (szFilePath   : PChar);               // HE_SET_INPUTFILE
        1: (diMem        : HE_DATA_INFO);        // HE_SET_MEMORYBLOCKINPUT
        End;

    procActionHandler   = Function(pa : PHE_ACTION) : BOOL; StdCall;

    PHE_SETTINGS        = ^HE_SETTINGS;
    HE_SETTINGS         = packed record
        dwMask          : DWORD;                 // HE_SET_XXX flags
        pHandler        : procActionHandler;     // HE_SET_ACTIONHANDLER
        posCaret        : HE_POS;                // HE_SET_SETCURRENTOFFSET
        dwSelStartOff   : DWORD;                 // HE_SET_SETSELECTION
        dwSelEndOff     : DWORD;                 //
        hwndParent      : HWND;                  // HE_SET_PARENTWINDOW
        input           : INPUT_UNION;
        wpUser          : HE_WIN_POS;            // HE_SET_USERWINDOWPOSITION
    End;

//
// function prototypes
//
Function HESpecifySettings(sets : PHE_SETTINGS) : BOOL; StdCall;
Function HEEnterWindowLoop : BOOL; StdCall;
Function HEEnterWindowLoopInNewThread : BOOL; StdCall;

implementation

Function HESpecifySettings;             External '16Edit.dll' name 'HESpecifySettings';
Function HEEnterWindowLoop;             External '16Edit.dll' name 'HEEnterWindowLoop';
Function HEEnterWindowLoopInNewThread;  External '16Edit.dll' name 'HEEnterWindowLoopInNewThread';

end.
