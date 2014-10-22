;
; Example of using procs.dll in MASM.
;
; Lists all processes and its modules with ImageBase, SizeOfImage and path !
; (No error checking !)
;

.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

include \masm32\include\windows.inc
include console.inc

; include procs.dll stuff
include    procs.inc
includelib procs.lib


;------ DEFINITIONS ------
MAX_PROCESS_NUM          EQU 50
MAX_MODULE_NUM           EQU 200

;------ CONST -----
.CONST
szLn                     DB 13,10,0
szProcInfo               DB "Process Information: (%d)",13,10,13,10,0
szProcHead               DB "PID:        ImageBase:  ImageSize:  Path:",13,10,0
szProcForm               DB "%08lX    %08lX    %08lX    %s",13,10,0
szModInfo                DB "Modules of %s: (%d)",13,10,0
szModHead                DB "Handle:    Size:      Path:",13,10,0
szModForm                DB "%08lX   %08lX   %s",13,10,0

;------ DATA ------
.DATA
dwProcCnt                DD 0
dwModCnt                 DD 0
dwPIDChain               DD MAX_PROCESS_NUM DUP (0)
dwModChain               DD MAX_MODULE_NUM DUP (0)
dwCurBase                DD 0
dwCurSize                DD 0
cPath                    DB MAX_PATH DUP (0)
cOut                     DB 300 DUP (0)
hMod                     DD 0

;------ CODE ------
.CODE
main:
	;---- list process information ----
	CALL   GetNumberOfProcesses
	MOV    dwProcCnt, EAX
	
	INVOKE wsprintf, OFFSET cOut, OFFSET szProcInfo, dwProcCnt
	INVOKE Cout, OFFSET cOut, 0
	
	INVOKE GetProcessIDList, OFFSET dwPIDChain, SIZEOF dwPIDChain
	
	PUSH   0
	PUSH   OFFSET szProcHead
	CALL   Cout
	
	;---- process PID array ----
	LEA    EDI, OFFSET dwPIDChain
	.WHILE dwProcCnt
	    MOV    ESI, DWORD PTR [EDI]				; ESI -> PID

	    INVOKE GetProcessBaseSize, ESI, OFFSET dwCurBase, OFFSET dwCurSize
	    OR     EAX, EAX
	    .IF ZERO?
	        MOV    dwCurBase, EAX
	        MOV    dwCurSize, EAX
	    .ENDIF
	    INVOKE GetProcessPath, ESI, OFFSET cPath, SIZEOF cPath
	    .IF EAX == FALSE
	        ; NUL-terminate cPath
	        MOV     EAX, OFFSET cPath;
	        MOV     BYTE PTR [EAX], 0
	    .ENDIF	    
	    INVOKE wsprintf, OFFSET cOut, OFFSET szProcForm, ESI, dwCurBase, dwCurSize, OFFSET cPath	    
	    PUSH   0
	    PUSH   OFFSET cOut
	    CALL   Cout   
	    
	    ADD    EDI, 4
	    SUB    dwProcCnt, 1
	.ENDW
	
	; ---- process all modules ----
	LEA    EBX, OFFSET szLn
	INVOKE Cout, EBX, 0
	INVOKE Cout, EBX, 0
	
	INVOKE GetNumberOfProcesses
	MOV    dwProcCnt, EAX

	LEA    EDI, OFFSET dwPIDChain                           ; EDI -> PID Chain
	.WHILE dwProcCnt
	    MOV    EBX, DWORD PTR [EDI]				; EBX -> PID
	    
	    ; print the main module path again and number of modules
	    INVOKE GetProcessPath, EBX, OFFSET cPath, SIZEOF cPath
	    .IF EAX == FALSE
	        ; NUL-terminate cPath
	        MOV     EAX, OFFSET cPath;
	        MOV     BYTE PTR [EAX], 0
	    .ENDIF
	    INVOKE GetNumberOfModules, EBX
	    MOV    dwModCnt, EAX
	    INVOKE wsprintf, OFFSET cOut, OFFSET szModInfo, OFFSET cPath, dwModCnt
	    INVOKE Cout, OFFSET cOut, 0
	    
	    ; printf grid header
	    INVOKE Cout, OFFSET szModHead, 0
	    
	    ; zero the module handle array and fill it with module handles
	    PUSHAD
	    XOR    EAX, EAX
	    LEA    EDI, OFFSET dwModChain
	    MOV    ECX, SIZEOF dwModChain
   ChainZeroLoop:
   	    STOSB
   	    LOOP   ChainZeroLoop
   	    POPAD
	    INVOKE GetModuleHandleList, EBX, OFFSET dwModChain, SIZEOF dwModChain
	    
	    LEA   ESI, OFFSET dwModChain
	    .WHILE DWORD PTR [ESI]				; ESI -> Module handle chain
	        MOV    EAX, DWORD PTR [ESI]
	        MOV    hMod, EAX
	        
	        ; get module path, base and size and print it
	        INVOKE GetModulePath, EBX, hMod, OFFSET cPath, SIZEOF cPath
	        .IF EAX == FALSE
	            ; NUL-terminate cPath
	            MOV     EAX, OFFSET cPath;
	            MOV     BYTE PTR [EAX], 0
	        .ENDIF	        
	        INVOKE GetModuleSize, EBX, hMod, OFFSET dwCurSize
	        
	        INVOKE wsprintf, OFFSET cOut, OFFSET szModForm, hMod, dwCurSize, OFFSET cPath
	        INVOKE Cout, OFFSEt cOut, 0	        
	        
	        ADD    ESI, 4
	    .ENDW    
	    
	    ; write a clear line
	    INVOKE Cout, OFFSET szLn, 0
	    
	    ADD    EDI, 4
	    SUB    dwProcCnt, 1
	.ENDW

Quit:
	XOR    EAX, EAX
	PUSH   EAX
	CALL   ExitProcess	
end main
