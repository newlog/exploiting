//
// SS plugin example: HelloWorld
//

#define  WIN32_LEAN_AND_MEAN

#include <windows.h>
#include "..\SSPlugin.h"

#pragma comment(linker,"/FILEALIGN:0x200 /MERGE:.rdata=.text /MERGE:.data=.text /SECTION:.text,EWR /IGNORE:4078")

// global variables
fGetSSApi  GetSSApi;
LPSSAPI    pSSApi;

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  fdwReason, 
                       LPVOID lpReserved
					 )
{
	HMODULE hSS;

	switch(fdwReason) 
    { 
	case DLL_PROCESS_ATTACH:
		// get "GetSSApi" address of SoftSnoop
		hSS = GetModuleHandle(NULL);
		if (!hSS)
			return FALSE;
		GetSSApi = (fGetSSApi)GetProcAddress(hSS, "GetSSApi");
		if (!GetSSApi)
			return FALSE;
		// call the function (get struct pointer)
		pSSApi = GetSSApi();
		break;
	}
	return TRUE;
}

BOOL SSAPIPROC StartSSPlugin()
{
	// print a line in the SoftSnoop listbox
	pSSApi->Print("Hello, I'm a plugin :)");
	return TRUE;
}
