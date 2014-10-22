
'*****************************************************************************
'
'  16EditDll.bas (VB)
'  -------------
'
'  version: FX
'
'  Include file for 16Edit.dll.
'
'  by yoda
'
'  Note:
'  Please contact me if you know how to realize the union in the HE_SETTINGS
'  structure in a more efficient way.
'
'*****************************************************************************

'
' CONSTANTS
'

' handler action codes
Public Const HE_ACTION_EXITING              As Long = &H1
Public Const HE_ACTION_SAVED                As Long = &H2
Public Const HE_ACTION_FILEACCESSINFO       As Long = &H4
Public Const HE_ACTION_WINDOWCREATED        As Long = &H8

' flags for HE_SETTINGS
Public Const HE_SET_FORCEREADONLY           As Long = &H1
Public Const HE_SET_NORESIZE                As Long = &H2
Public Const HE_SET_SETCURRENTOFFSET        As Long = &H4
Public Const HE_SET_SETSELECTION            As Long = &H8
Public Const HE_SET_ACTIONHANDLER           As Long = &H10
Public Const HE_SET_INPUTFILE               As Long = &H20
Public Const HE_SET_MEMORYBLOCKINPUT        As Long = &H40
Public Const HE_SET_ONTOP                   As Long = &H80
Public Const HE_SET_PARENTWINDOW            As Long = &H100
Public Const HE_SET_MINIMIZETOTRAY          As Long = &H200
Public Const HE_SET_SAVEWINDOWPOSITION      As Long = &H400
Public Const HE_SET_RESTOREWINDOWPOSITION   As Long = &H800
Public Const HE_SET_USERWINDOWPOSITION      As Long = &H1000

'
' STRUCTURES
'
Public Type HE_DATA_INFO
    pDataBuff          As Long
    dwSize             As Long                   ' data indicator
    bReadOnly          As Long
End Type

Public Type HE_POS
    dwOffset           As Long
    bHiword            As Long                   ' (opt.) first digit of the pair ? ...or the 2nd one ?
    bTextSelection     As Long                   ' (opt.) Caret in the text part ?
End Type

Public Type HE_WIN_POS
    iState             As Long                   ' SW_SHOWNORMAL/SW_MAXIMIZE/SW_MINIMIZE
    ix                 As Long                   ' left
    iy                 As Long                   ' top
    icx                As Long                   ' width
    icy                As Long                   ' height
End Type

Public Type HE_ACTION
    dwActionCode       As Long
    dwNewSize          As Long                   ' HE_ACTION_SAVED
    bReadWrite         As Long                   ' HE_ACTION_FILEACCESSINFO
    hwnd16Edit         As Long                   ' HE_ACTION_WINDOWCREATED
End Type

Public Type HE_SETTINGS
    dwMask             As Long                   ' HE_SET_XXX flags
    pHandle            As Long                   ' HE_SET_ACTIONHANDLER
    posCaret           As HE_POS                 ' HE_SET_SETCURRENTOFFSET
    dwSelStartOff      As Long                   ' HE_SET_SETSELECTION
    dwSelEndOff        As Long                   '
    hwndParent         As Long                   ' HE_SET_PARENTWINDOW
    FilePath_pDataBuff As String                 ' \
    dwSize             As Long                   ' - union! (HE_SET_INPUTFILE or HE_SET_MEMORYBLOCKINPUT)
    bReadOnly          As Long                   ' /
    wpUser             As HE_WIN_POS             ' HE_SET_USERWINDOWPOSITION
End Type

'
' FUNCTION PROTOTYPES
'
Public Declare Function HESpecifySettings Lib "16Edit.dll" (sets As HE_SETTINGS) As Boolean
Public Declare Function HEEnterWindowLoop Lib "16Edit.dll" () As Boolean
Public Declare Function HEEnterWindowLoopInNewThread Lib "16Edit.dll" () As Boolean


    

    


    





