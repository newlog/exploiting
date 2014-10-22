Comment #
*****************************************************************************

  16EditDll.INC (MASM/TASM)
  -------------

  version: FX

  Include file for 16Edit.dll.

  by yoda
  
*****************************************************************************  
#

;
; constants
;

; handler action codes
HE_ACTION_EXITING                        EQU 00000001h
HE_ACTION_SAVED                          EQU 00000002h
HE_ACTION_FILEACCESSINFO                 EQU 00000004h
HE_ACTION_WINDOWCREATED                  EQU 00000008h

; flags for HE_SETTINGS
HE_SET_FORCEREADONLY                     EQU 00000001h
HE_SET_NORESIZE                          EQU 00000002h
HE_SET_SETCURRENTOFFSET                  EQU 00000004h
HE_SET_SETSELECTION                      EQU 00000008h
HE_SET_ACTIONHANDLER                     EQU 00000010h
HE_SET_INPUTFILE                         EQU 00000020h
HE_SET_MEMORYBLOCKINPUT                  EQU 00000040h
HE_SET_ONTOP                             EQU 00000080h
HE_SET_PARENTWINDOW                      EQU 00000100h
HE_SET_MINIMIZETOTRAY                    EQU 00000200h
HE_SET_SAVEWINDOWPOSITION                EQU 00000400h
HE_SET_RESTOREWINDOWPOSITION             EQU 00000800h
HE_SET_USERWINDOWPOSITION                EQU 00001000h

;
; structures
; 

HE_DATA_INFO STRUCT
	pDataBuff     LPVOID  ?
	dwSize        DWORD   ?                            ; data indicator
	bReadOnly     BOOL    ?
HE_DATA_INFO ENDS
PHE_DATA_INFO         TYPEDEF PTR HE_DATA_INFO

HE_POS STRUCT
	dwOffset      DWORD   ?
	bHiword       BOOL    ?                            ; (opt.) first digit of the pair ? ...or the 2nd one ?
	bTextSection  BOOL    ?                            ; (opt.) Caret in the text part ?
HE_POS ENDS
PHE_POS               TYPEDEF PTR HE_POS

HE_WIN_POS STRUCT
	iState        DWORD   ?                            ; SW_SHOWNORMAL/SW_MAXIMIZE/SW_MINIMIZE
	ix            DWORD   ?                            ; left
	iy            DWORD   ?                            ; top
	icx           DWORD   ?                            ; width
	icy           DWORD   ?                            ; height
HE_WIN_POS ENDS
PHE_WIN_POS           TYPEDEF PTR HE_WIN_POS       

HE_ACTION STRUCT
	dwActionCode        DWORD   ?
	dwNewSize           DWORD   ?                      ; HE_ACTION_SAVED
	bReadWrite          BOOL    ?                      ; HE_ACTION_FILEACCESSINFO
	hwnd16Edit          HWND    ?                      ; HE_ACTION_WINDOWCREATED
HE_ACTION ENDS
PHE_ACTION            TYPEDEF PTR HE_ACTION

PACTION_HANDLER       TYPEDEF LPVOID                       ; typedef BOOL (__stdcall* procActionHandler)(PHE_ACTION pa)

INPUT UNION
	szFilePath             LPSTR          ?            ; HE_SET_INPUTFILE
	diMem                  HE_DATA_INFO  <?>           ; HE_SET_MEMORYBLOCKINPUT
INPUT ENDS
	
HE_SETTINGS STRUCT
	dwMask             DWORD             ?             ; HE_SET_XXX flags
	pHandler           PACTION_HANDLER   ?             ; HE_SET_ACTIONHANDLER
	posCaret           HE_POS           <?>            ; HE_SET_SETCURRENTOFFSET
	dwSelStartOff      DWORD             ?             ; HE_SET_SETSELECTION
	dwSelEndOff        DWORD             ?             ;
	hwndParent         HWND              ?             ; HE_SET_PARENTWINDOW
	input              INPUT            <?>            ;
	wpUser             HE_WIN_POS       <?>            ; HE_SET_USERWINDOWPOSITION
HE_SETTINGS ENDS
PHE_SETTINGS          TYPEDEF PTR HE_SETTINGS

;
; function prototypes
;

;BOOL   __stdcall HESpecifySettings(PHE_SETTINGS sets);
HESpecifySettings             PROTO :PHE_SETTINGS

;BOOL   __stdcall HEEnterWindowLoop();
HEEnterWindowLoop             PROTO

;BOOL   __stdcall HEEnterWindowLoopInNewThread();
HEEnterWindowLoopInNewThread  PROTO
