;-> routine prototypes for procs.dll <-

IFNDEF _PROCS_
_PROCS_ EQU 1

GetNumberOfProcesses      PROTO
GetProcessIDList          PROTO :LPDWORD, :DWORD
GetProcessPath            PROTO :DWORD, :LPSTR, :DWORD
GetProcessBaseSize        PROTO :DWORD, :LPDWORD, :LPDWORD

GetNumberOfModules        PROTO :DWORD
GetModuleHandleList       PROTO :DWORD, :LPDWORD, :DWORD
GetModulePath             PROTO :DWORD, :DWORD, :LPSTR, :DWORD
GetModuleSize             PROTO :DWORD, :DWORD, :LPDWORD

GetProcessPathID          PROTO :LPSTR
GetModuleHandleEx         PROTO :DWORD, :LPSTR

ENDIF