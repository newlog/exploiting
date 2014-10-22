'******************************************************************************
'
'  LDS.bas
'  -------
'
'  version: 0.2
'
'  Include file for LordPE Dumper Server plugins.
'  Please send me (LordPE@gmx.net) your plugins.
'
'  By yoda
'
'******************************************************************************

'
' CONSTANTS
'

Public Const LDS_INTERFACE_VERSION              As Long = &O2        ' 0.2
Public Const LDS_WND_NAME                       As String = "[ LordPE Dumper Server ]"
Public Const WM_USER                            As Long = &O400
Public Const MAX_PATH                           As Long = 260

' commands
Public Const WM_LDS_CMD_FIRST                   As Long = WM_USER + &H7000

' wParam - client PID
' lParam - PLDS_VERSION
Public Const WM_LDS_CMD_QUERYVERSION            As Long = WM_LDS_CMD_FIRST + 10

' wParam - client PID
' lParam - PLDS_LOG_ENTRY
Public Const WM_LDS_CMD_ADDLOG                  As Long = WM_LDS_CMD_FIRST + 20    ' max are 1024 characters (including NUL)

' wParam - client PID
' lParam - PLDS_MODULE_INFO
Public Const WM_LDS_CMD_QUERYPROCESSMODULEINFO  As Long = WM_LDS_CMD_FIRST + 30

' wParam - client PID
' lParam - PLDS_ENUM_PIDS
Public Const WM_LDS_CMD_ENUMPROCESSIDS          As Long = WM_LDS_CMD_FIRST + 31

' wParam - client PID
' lParam - PLDS_ENUM_PROCESSMODULES
Public Const WM_LDS_CMD_ENUMPROCESSMODULES      As Long = WM_LDS_CMD_FIRST + 32

' wParam - client PID
' lParam - PLDS_FIND_PID
Public Const WM_LDS_CMD_FINDPROCESSID           As Long = WM_LDS_CMD_FIRST + 33

' wParam - client PID
' lParam - PLDS_FULL_DUMP/PLDS_FULL_DUMP_EX
Public Const WM_LDS_CMD_DUMPPROCESSMODULE       As Long = WM_LDS_CMD_FIRST + 40

' wParam - client PID
' lParam - PLDS_PARTIAL_DUMP
Public Const WM_LDS_CMD_DUMPPROCESSBLOCK        As Long = WM_LDS_CMD_FIRST + 41

' dump options
Public Const LDS_DUMP_CORRECTIMAGESIZE          As Long = &H1
Public Const LDS_DUMP_USEHEADERFROMDISK         As Long = &H2
Public Const LDS_DUMP_FORCERAWMODE              As Long = &H4
Public Const LDS_DUMP_SAVEVIAOFN                As Long = &H8

' rebuilding options
Public Const LDS_REB_REALIGNIMAGE               As Long = &H10000
Public Const LDS_REB_WIPERELOCATIONOBJECT       As Long = &H20000
Public Const LDS_REB_REBUILDIMPORTS             As Long = &H40000
Public Const LDS_REB_VALIDATEIMAGE              As Long = &H80000
Public Const LDS_REB_CHANGEIMAGEBASE            As Long = &H100000

'
' STRUCTURES
'

Public Type LDS_VERSION
    dwStructSize             As Long
    dwVersion                As Long
End Type

Public Type LDS_LOG_ENTRY
    dwStructSize             As Long
    szStr                    As String
    dwStrSize                As Long                                 ' including NUL-character
    bCatAtLast               As Long                                 ' add str at end of last item's text ?
End Type

Public Type LDS_MODULE_INFO
    dwStructSize             As Long
    dwPID                    As Long
    hImageBase               As Long                                 ' if NULL - calling module is snapped
    dwImageSize              As Long
    cModulePath(MAX_PATH)    As Byte                                 ' cModulePath[0] == 0 if not set
End Type

Public Type LDS_ENUM_PIDS
    dwStructSize             As Long
    dwChainSize              As Long
    pdwPIDChain              As Long                                 ' DWORD array for PIDs
    dwItemCount              As Long
End Type

Public Type LDS_ENUM_PROCESS_MODULES
    dwStructSize             As Long
    dwPID                    As Long
    dwChainSize              As Long
    pdwImageBaseChain        As Long                                 ' DWORD array for module handles
    dwItemCount              As Long
End Type

Public Type LDS_FIND_PID
    dwStructSize             As Long
    cProcessPath(MAX_PATH)   As Long                                 ' can be incomplete
    dwPID                    As Long
End Type

Public Type LDS_FULL_DUMP
    dwStructSize             As Long
    dwFlags                  As Long                                 ' LDS_DUMP_XXX/LDS_REB_XXX
    dwPID                    As Long
    hModuleBase              As Long                                 ' NULL - calling module is dumped
    bDumpSuccessfully        As Long
    dwSizeOfDumpedImage      As Long
    bUserSaved               As Long                                 ' LDS_DUMP_SAVEVIAOFN
    cSavedTo(MAX_PATH)       As Long                                 ' LDS_DUMP_SAVEVIAOFN
    pDumpedImage             As Long                                 ' !LDS_DUMP_SAVEVIAOFN
    
    ' rebuilding structure elements
    dwRealignType            As Long                                 ' 0-normal 1-hardcore 2-nice
    dwNewImageBase           As Long                                 ' format: 0xXXXX0000
End Type

Public Type LDS_FULL_DUMP_EX
    dwStructSize             As Long
    dwFlags                  As Long                                 ' LDS_DUMP_XXX/LDS_REB_XXX
    dwPID                    As Long
    hModuleBase              As Long                                 ' NULL - calling module is dumped
    bDumpSuccessfully        As Long
    dwSizeOfDumpedImage      As Long
    bUserSaved               As Long                                 ' LDS_DUMP_SAVEVIAOFN
    cSavedTo(MAX_PATH)       As Long                                 ' LDS_DUMP_SAVEVIAOFN
    pDumpedImage             As Long                                 ' !LDS_DUMP_SAVEVIAOFN
    
    ' rebuilding structure elements
    dwRealignType            As Long                                 ' 0-normal 1-hardcore 2-nice
    dwNewImageBase           As Long                                 ' format: 0xXXXX0000
    dwEntryPointRva          As Long                                 ' 0 = don't set to image
    dwExportTableRva         As Long                                 ' 0 = don't set to image
    dwImportTableRva         As Long                                 ' 0 = don't set to image
    dwResourceDirRva         As Long                                 ' 0 = don't set to image
    dwRelocationDirRva       As Long                                 ' 0 = don't set to image
End Type

Public Type LDS_PARTIAL_DUMP
    dwStructSize             As Long
    dwPID                    As Long
    pBlock                   As Long
    dwBlockSize              As Long
    bSaveViaOfn              As Long
    bDumpSuccessfully        As Long
    bUserSaved               As Long                                 ' bSaveViaOfn
    cSavedTo(MAX_PATH)       As Byte                                 ' bSaveViaOfn
    pDumpedImage             As Long                                 ' !bSaveViaOfn
End Type








    





