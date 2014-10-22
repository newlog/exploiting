// -> routine prototypes for procs.dll <-

#ifndef _PROCS_
#define _PROCS_

DWORD  __stdcall GetNumberOfProcesses();
BOOL   __stdcall GetProcessIDList(DWORD *dwIDArray, DWORD dwArraySize);
BOOL   __stdcall GetProcessPath(DWORD dwPID, char *szBuff, DWORD dwBuffSize);
BOOL   __stdcall GetProcessBaseSize(DWORD dwPID, DWORD *dwImageBase, DWORD *dwImageSize);

DWORD  __stdcall GetNumberOfModules(DWORD dwPID);
BOOL   __stdcall GetModuleHandleList(DWORD dwPID,DWORD *dwHandleArray, DWORD dwArraySize);
BOOL   __stdcall GetModulePath(DWORD dwPID, DWORD dwModh, char *szBuff, DWORD dwBuffSize);
BOOL   __stdcall GetModuleSize(DWORD dwPID, DWORD dwModh, DWORD *dwImageSize);

DWORD  __stdcall GetProcessPathID(char* szPath);
HANDLE __stdcall GetModuleHandleEx(DWORD dwPID, char* szModule);

#endif