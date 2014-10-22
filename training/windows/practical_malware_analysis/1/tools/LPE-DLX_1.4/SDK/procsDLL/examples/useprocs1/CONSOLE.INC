; -> CONSOLE.INC <-
;
; A small include file for console access !
; by yoda

IFNDEF _CONSOLE_INC_
_CONSOLE_INC_ EQU 1

;----- PROTOs -------
InitConsole     PROTO
Cout            PROTO :LPSTR, :DWORD
Cin             PROTO :LPSTR, :DWORD

;----- DATA ------
.DATA
hConIn                  DD 0
hConOut                 DD 0
dwConBytesRead          DD 0

;----- CODE ------
.CODE
; returns with carry in the case of an error.
InitConsole PROC USES eax ecx edx
	STC
	PUSH STD_INPUT_HANDLE
	CALL GetStdHandle
	INC  EAX
	JZ   @@ExitProc
	DEC  EAX
	MOV  hConIn, EAX
	
	PUSH STD_OUTPUT_HANDLE
	CALL GetStdHandle
	INC  EAX
	JZ   @@ExitProc
	DEC  EAX
	MOV  hConOut, EAX
	
	CLC		; all OK
   @@ExitProc:
	RET
InitConsole ENDP

; _dwStrLen can be 0 to write the whole string at _szOutText
; return values:
; 0     - an error occured
; else  - size of the output
Cout PROC USES ecx edx, _szOutText : LPSTR, _dwStrLen : DWORD
	; was InitConsole already called ?
	.IF  hConOut == 0
	   CALL InitConsole
	   XOR  EAX, EAX
	   JC   @@ExitProc
	.ENDIF
	
	; write text to console
	MOV  EAX, _dwStrLen
	OR   EAX, EAX
	.IF  ZERO?
	   PUSH _szOutText
	   CALL lstrlen
	.ENDIF
	PUSH EAX				; string length to write
	PUSH _szOutText
	PUSH hConOut
	CALL _lwrite				; _lwrite makes ">" in BAT files work ! (WriteConsole doesn't)
	INC  EAX
	JZ   @@ExitProc
	DEC  EAX
	
   @@ExitProc:
	RET
Cout ENDP

; return values:
; 0     - an error occured
; else  - size of the input
Cin PROC USES ecx edx, _szTextBuff : LPSTR, _dwStrLen : DWORD
	; was InitConsole already called ?
	.IF  hConIn == 0
	   CALL InitConsole
	   XOR  EAX, EAX
	   JC   @@ExitProc
	.ENDIF
	
	; read text to buffer
	PUSH 0
	PUSH OFFSET dwConBytesRead
	PUSH _dwStrLen
	PUSH _szTextBuff
	PUSH hConIn
	CALL ReadConsole
	OR   EAX, EAX
	JZ   @@ExitProc
	
	MOV  EAX, dwConBytesRead		; EAX -> number of bytes written	
	
   @@ExitProc:
	RET
Cin ENDP

ENDIF