//
// SS Plugin Example: Debug Event Logger
//

Library PluginExp3;

{$IMAGEBASE $018000000}
{$R rsrc.res}

uses
  Windows,
  messages,
  SSPlugin;

CONST szGetSSApi      : pchar              = 'GetSSApi';
      szMyDllName     : pchar              = 'PluginExp3';
      ID_LB                                = 1001;
VAR   pApi            : LPSSAPI;
      hDlg_           : HWND;
      bRunning        : boolean;

PROCEDURE AddLb(szText : pchar);
BEGIN
    // add a line in the plugin listbox
    SendDlgItemMessage(hDlg_, ID_LB, LB_ADDSTRING, 0, LPARAM(szText));
    // scroll down
    SendDlgItemMessage(hDlg_, ID_LB, WM_VSCROLL, SB_LINEDOWN, 0);
END;

FUNCTION DlgProc(hDlg : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : boolean; STDCALL;
VAR   pDB    : ^DEBUG_EVENT;
BEGIN
    Result := FALSE;
    Case Msg of
        WM_INITDIALOG:
            BEGIN
            bRunning := TRUE;
            hDlg_ := hDlg;
            // register dlg
            pApi.RegisterPluginWindow(hDlg);
            Result := TRUE;
            END;

        WM_CLOSE:
            BEGIN
            // clean up
            pApi.UnregisterPluginWindow(hDlg);
            // close dlg
            EndDialog(hDlg, 0);
            Result := TRUE;
            bRunning := FALSE;
            END;

        SS_DEBUGSTART:
            BEGIN
            SendDlgItemMessage(hDlg_, ID_LB, LB_RESETCONTENT, 0, 0);
            AddLB(pchar('Start of Debugging'));
            END;

        SS_DEBUGBREAK:
            AddLb(pchar('DEBUG BREAK reached...'));

        SS_DEBUGSTOP:
            AddLb(pchar('End of Debugging'));

        SS_DEBUGEVENT:
            BEGIN
            pDB := pointer(wParam);
            Case pDB.dwDebugEventCode of
                CREATE_PROCESS_DEBUG_EVENT:
                    AddLb(pchar('CREATE_PROCESS_DEBUG_EVENT'));
                EXCEPTION_DEBUG_EVENT:
                    AddLb(pchar('EXCEPTION_DEBUG_EVENT'));
                OUTPUT_DEBUG_STRING_EVENT:
                    AddLb(pchar('OUTPUT_DEBUG_STRING_EVENT'));
                EXIT_PROCESS_DEBUG_EVENT:
                    AddLb(pchar('EXIT_PROCESS_DEBUG_EVENT'));
                LOAD_DLL_DEBUG_EVENT:
                    AddLb(pchar('LOAD_DLL_DEBUG_EVENT'));
                UNLOAD_DLL_DEBUG_EVENT:
                    AddLb(pchar('UNLOAD_DLL_DEBUG_EVENT'));
                CREATE_THREAD_DEBUG_EVENT:
                    AddLb(pchar('CREATE_THREAD_DEBUG_EVENT'));
                EXIT_THREAD_DEBUG_EVENT:
                    AddLb(pchar('EXIT_THREAD_DEBUG_EVENT'));
                RIP_EVENT:
                    AddLb(pchar('RIP_EVENT'));
            END; // ... of case struct
            END;
    END;
END;

FUNCTION StartSSPlugin : boolean;
BEGIN
    // return succcess
    Result := TRUE;
    // is plugin already running ?
    If (bRunning) Then
         BEGIN
         pApi.ShowError(pchar('Plugin is already running !'));
         Exit;
         END;
    // show dlg
    DialogBoxParam(
        GetModuleHandle(szMyDllName),
        pchar(101),
        0,
        @DlgProc,
        0);
END;

PROCEDURE DllEntry(dwReason: DWORD);
VAR  GetSSApi   : fGetSSApi;
     hMod       : HMODULE;
BEGIN
    Case dwReason of
    DLL_PROCESS_ATTACH:
        BEGIN
        // get address of "GetSSApi" and call it
        bRunning := FALSE;
        hMod := GetModuleHandle(nil);
        GetSSApi := fGetSSApi(GetProcAddress(hMod, szGetSSApi));
        pApi := GetSSApi;
        END;
    END;
END;

EXPORTS StartSSPlugin; // export the startroutine of the plugin

BEGIN
    // fix DllEntry function address and call it
    DllProc := @DllEntry;
    DllEntry(DLL_PROCESS_ATTACH);
END.

