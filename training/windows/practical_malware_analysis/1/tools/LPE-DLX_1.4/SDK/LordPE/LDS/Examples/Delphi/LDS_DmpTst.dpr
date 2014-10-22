{

LordPE Dumper Server - plugin example for Delphi
------------------------------------------------

Dump the process memory of the calling module and let LDS buffer the output memory, so
that we can save it by hand to disk.

dedicated to Snow Panther

by yoda

}

program LDS_DmpTst;

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
    hwndLDS       : HWND;
    dwMyPid       : DWORD;
    lfd           : LDS_FULL_DUMP;
    hOutF         : THandle;
    buff          : Cardinal;

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
    // Task1:
    // dump current calling process module memory via the buffering method -> don't
    // let the user save the file memory
    //

    // let LDS snap the memory and save for us
    FillChar(lfd, sizeof(lfd), 0);
    lfd.dwStructSize              := sizeof(lfd);
    lfd.dwFlags                   := LDS_REB_REALIGNIMAGE; // uninteresting for this test
    lfd.dwPID                     := dwMyPid;
    lfd.hModuleBase               := 0;                    // indicates: target = calling module
    SendMessage(hwndLDS, WM_LDS_CMD_DUMPPROCESSMODULE, WParam(dwMyPid), LParam(@lfd));

    // save the buffered memory to disk
    hOutF := CreateFile(
        'CallModMem.EXE',
        GENERIC_READ or GENERIC_WRITE,
        FILE_SHARE_READ or FILE_SHARE_WRITE,
        nil,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        0);
    If (hOutF <> INVALID_HANDLE_VALUE) and (lfd.bDumpSuccessfully = TRUE) Then
        Begin
        WriteFile(hOutF, Cardinal(lfd.pDumpedImage^), lfd.dwSizeOfDumpedImage, buff, nil);
        CloseHandle(hOutF);
        MessageBox(0,
            'Calling module''s memory was dumped successfully to CallModMem.EXE !',
            'LordPE Plugin',
            MB_OK or MB_ICONINFORMATION);
        End
    Else
        MessageBox(0, 'An error occurred :(', 'LordPE Plugin', MB_OK or MB_ICONERROR);
end.
