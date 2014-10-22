/*

  Example of using procs.dll in C

  Prints its PID without "GetCurrentProcessID" and current procs.dll base.

*/


#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "procs.h"

#pragma comment(linker,"/FILEALIGN:512 /MERGE:.rdata=.text /MERGE:.data=.text /SECTION:.text,EWR /IGNORE:4078")
#pragma comment(lib, "..\\Release\\procs.lib")

int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow )
{
	char    cBuff[MAX_PATH];
	DWORD   dwPID;
	HANDLE  hProcs;

	// get the calling exe path
	GetModuleFileName(NULL, cBuff, sizeof(cBuff));

	// get PID
	dwPID = GetProcessPathID(cBuff);
	if (!dwPID)
	{
		MessageBox(0, "Couldn't get PID :(", NULL, MB_ICONERROR);
		return -1;
	}
	// get procs.dll base
	hProcs = GetModuleHandleEx(dwPID, "procs.dll");
	if (!hProcs)
	{
		MessageBox(0, "GetModuleHandleEx failed :(", NULL, MB_ICONERROR);
		return -1;
	}

	// print result
	wsprintf(cBuff, "My PID: 0x%08lX\nProcs.dll base: 0x%08lX", dwPID, hProcs);
	MessageBox(0, cBuff, ":D", MB_ICONINFORMATION | MB_SYSTEMMODAL);

	return 0;
}