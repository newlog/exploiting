{

LordPE Dumper Server - plugin example for Delphi
------------------------------------------------

Queries and displays the LDS version.
Queries the ProcessId by the module path and displays it.

by yoda

}

program LDS_VerPid;

uses
  Windows,
  SysUtils,
  LDS in 'LDS.pas';

//
// constants
//
const
    szPluginName  : PChar          = 'Plugin example for Delphi by yoda...';

//
// global variables
//
var
    ldsVer        : LDS_VERSION;
    ldsFindPid    : LDS_FIND_PID;
    hwndLDS       : HWND;
    dwMyPid       : DWORD;
    str           : String;

Procedure LDSLog(szStr : PChar; bCat : Boolean);
var ldsLog : LDS_LOG_ENTRY;
Begin
    FillChar(ldsLog, sizeof(ldsLog), 0);           // needed because 'Boolean' seems to be BYTE sized in Delphi
    ldsLog.dwStructSize  := sizeof(ldsLog);
    ldsLog.szStr         := szStr;
    ldsLog.dwStrSize     := StrLen(szStr) + 1;
    ldsLog.bCatAtLast    := bCat;
    SendMessage(hwndLDS, WM_LDS_CMD_ADDLOG, WParam(dwMyPid), LParam(@ldsLog));
End;

//
// ENTRYPOINT
//
begin
    //
    // find LDS window
    //
    hwndLDS := FindWindow(nil, LDS_WND_NAME);
    If hwndLDS = 0 Then
        Begin
        MessageBox(0,
            PChar('Please lunch LordPE''s Dumper Server first !'),
            PChar('LordPE Plugin'),
            MB_OK or MB_ICONERROR);
        Exit;
        End;

    // get current PID
    dwMyPid := GetCurrentProcessId();

    //
    // print plugin name
    //
    LDSLog(szPluginName, FALSE);

    //
    // get and print version
    //
    ldsVer.dwStructSize   := sizeof(ldsVer);
    ldsVer.dwVersion      := 0;
    SendMessage(hwndLDS, WM_LDS_CMD_QUERYVERSION, WParam(dwMyPid), LParam(@ldsVer));
    FmtStr(
        str,
        'Interface version is: %d.%d',
        [ldsVer.dwVersion and $FFFF0000, ldsVer.dwVersion and $FFFF]);
    LDSLog(PChar(str), FALSE);

    //
    // receive instance PID from LDS and print
    //
    ldsFindPid.dwStructSize   := sizeof(ldsFindPid);
    ldsFindPid.dwPID          := 0;
    GetModuleFileName(0, ldsFindPid.cProcessPath, sizeof(ldsFindPid));
    SendMessage(hwndLDS, WM_LDS_CMD_FINDPROCESSID, WParam(dwMyPid), LParam(@ldsFindPid));
    If ldsFindPid.dwPID = 0 Then // PID found ?
        LDSLog('Searched my PID with the module path...not found :(', FALSE)
    Else
        Begin
        FmtStr(str, 'Searched my PID with the module path...found: 0x%.*X', [8, ldsFindPid.dwPID]);
        LDSLog(PChar(str), FALSE);
        End;
end.
