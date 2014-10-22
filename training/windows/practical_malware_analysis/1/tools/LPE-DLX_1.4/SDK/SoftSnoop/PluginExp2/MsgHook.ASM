;
; SS plugin example: MsgHook
;

.386
.model flat,stdcall
option casemap:none

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

include \masm32\include\windows.inc
include SSPlugin.INC
include resource.INC

;------ PROTOs ------
DlgProc PROTO :HWND, :UINT, :WPARAM, :LPARAM

;------ CONST ------
.CONST
szGetSSApi                  DB "GetSSApi",0
szOpenErr                   DB "Plugin already running !",0
szPluginName                DB "&Install MsgHook",0
szMessageBoxA               DB "MessageBoxA",0

;------ DATA ------
.DATA
API                         SSAPI <>
pAPI                        DD 0
hInst                       DD 0
bRunning                    DD 0

;------ CODE ------
.CODE
DllEntry PROC USES EDI ESI EBX, hInstance : HINSTANCE, reason : DWORD, reserved1 : DWORD
	.IF reason == DLL_PROCESS_ATTACH
	    PUSH   hInstance
	    POP    hInst
	
	    ; get address of SSAPI structure
	    PUSH   0
	    CALL   GetModuleHandle
	    PUSH   OFFSET szGetSSApi
	    PUSH   EAX
	    CALL   GetProcAddress
	    OR     EAX, EAX
	    JZ     ExitEntry          ; return FALSE
	    CALL   EAX
	    OR     EAX, EAX
	    JZ     ExitEntry          ; return FALSE
	    
	    ; get a copy of SoftSnoop's SSAPI structure (easier to use)
	    MOV    pAPI, EAX
	    MOV    EDI, OFFSET API
	    MOV    ESI, EAX
	    MOV    ECX, SIZEOF API
	    REP    MOVSB
	    
	    ; add plugin in SoftSnoop's menu
            PUSH   OFFSET RunPlugin
	    PUSH   OFFSET szPluginName
	    CALL   API.AddPluginFunction
	    OR     EAX, EAX
	    JZ     ExitEntry
	.ENDIF	
	MOV    EAX, TRUE
    ExitEntry:	
	RET
DllEntry ENDP

DlgProc PROC USES EBX ESI EDI, hDlg : HWND, Msg : UINT, wParam : WPARAM, lParam : LPARAM
        .IF Msg == WM_CLOSE
            MOV    bRunning, FALSE
            
            ; clean up
            PUSH   hDlg
            CALL   API.UnregisterPluginWindow
            ; close dlg
            PUSH   0
            PUSH   hDlg
            CALL   EndDialog
        .ELSEIF Msg == WM_INITDIALOG
            MOV    bRunning, TRUE
            
            ; register dlg
            PUSH   hDlg
            CALL   API.RegisterPluginWindow
            
            ; enable "Don't modify"
            INVOKE CheckDlgButton, hDlg, IDC_KEEPFLAG, BST_CHECKED
        .ELSEIF Msg == SS_APICALL
            PUSH   lParam
            PUSH   wParam
            PUSH   hDlg
            CALL   HandleApiCall
        .ENDIF
	XOR    EAX, EAX
	RET
DlgProc ENDP

RunPlugin PROC SSAPIPROC
	; plugin already opened
	.IF bRunning
	    PUSH   OFFSET szOpenErr
	    CALL   API.ShowError
	    RET	
	.ENDIF

	; create dlg
	INVOKE DialogBoxParam, hInst, IDD_MAINDLG, NULL, OFFSET DlgProc, NULL
	
	; return TRUE !
	XOR    EAX, EAX
	INC    EAX
	RET
RunPlugin ENDP

HandleApiCall PROC hDlg : HWND, wParam : WPARAM, lParam : LPARAM
	LOCAL dwBytesWritten  : DWORD
	LOCAL hProc           : HANDLE
	LOCAL dwMsgFlag       : DWORD
	
	; is it a "MessageBoxA" call ?
	MOV    EDX, wParam
	ASSUME EDX : PTR APIINFO
	MOV    EBX, [EDX].szApiName
	ASSUME EDX : NOTHING
	PUSH   OFFSET szMessageBoxA
	PUSH   EBX
	CALL   lstrcmpi
	OR     EAX, EAX
	JNZ    @@ExitProc
	
	; it's a "MessageBoxA" call :)
	; get current process handle
	MOV    EDI, pAPI
	ASSUME EDI : PTR SSAPI
	MOV    EAX, [EDI].pPI
	ASSUME EAX : PTR PROCESS_INFORMATION
	PUSH   [EAX].hProcess
	POP    hProc
	ASSUME EAX : NOTHING
	ASSUME EDI : NOTHING
	
	; get the value of the selected flag
	INVOKE IsDlgButtonChecked, hDlg, IDC_KEEPFLAG
	CMP    EAX, BST_CHECKED
	JZ     @@ExitProc
	INVOKE IsDlgButtonChecked, hDlg, IDC_OK
	.IF    EAX == BST_CHECKED
	    MOV     dwMsgFlag, MB_OK
	.ENDIF
	INVOKE IsDlgButtonChecked, hDlg, IDC_INFO
	.IF    EAX == BST_CHECKED
	    MOV     dwMsgFlag, MB_ICONINFORMATION
	.ENDIF	
	INVOKE IsDlgButtonChecked, hDlg, IDC_WARNING
	.IF    EAX == BST_CHECKED
	    MOV     dwMsgFlag, MB_ICONWARNING
	.ENDIF	
	INVOKE IsDlgButtonChecked, hDlg, IDC_ERROR
	.IF    EAX == BST_CHECKED
	    MOV     dwMsgFlag, MB_ICONERROR
	.ENDIF
		
	; modify the thread stack of the thread who called the API
	MOV    EDX, lParam                                ; EDX -> thread stack
	ADD    EDX, 4 * SIZEOF DWORD                      ; EDX -> address of the MessageBox flag
	INVOKE WriteProcessMemory, hProc, EDX, ADDR dwMsgFlag, 4, ADDR dwBytesWritten
	
    @@ExitProc:
	RET
HandleApiCall ENDP

End DllEntry
