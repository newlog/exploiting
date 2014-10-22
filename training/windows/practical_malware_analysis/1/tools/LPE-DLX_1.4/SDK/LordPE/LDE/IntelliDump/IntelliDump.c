/*

	LordPE Dump Engine example: IntelliDump
	---------------------------------------

	Performs a more intelligent process data dumping by reading
	the target bytes in region steps. Not accessible ones are
	padded by zeros.
	Useful for dumping .NET CLR applications because they have
	several regions with PAGE_NOACCESS attributes in their
	module memory.

	by yoda (12th August 2k2)

*/

#define  WIN32_LEAN_AND_MEAN
#include <windows.h>

// compilat optimization
#pragma comment(linker,"/SUBSYSTEM:WINDOWS /FILEALIGN:512 /MERGE:.rdata=.text /MERGE:.data=.text /SECTION:.text,EWR /IGNORE:4078")

//
// macros
//
#define MakePtr( cast, ptr, addValue )   (cast)( (DWORD)(ptr) + (DWORD)(addValue))

//
// global variables
//
HINSTANCE                 hInst;

//
// DLL ENTRYPOINT
//
BOOL WINAPI DllMain(
  HINSTANCE hinstDLL,  // handle to DLL module
  DWORD fdwReason,     // reason for calling function
  LPVOID lpvReserved   // reserved
)
{
	if ( fdwReason == DLL_PROCESS_ATTACH ) // dll was loaded ?
	{
		hInst = hinstDLL; // save dll base
		DisableThreadLibraryCalls( hinstDLL ); // reduce the size of the working code set
	}

	return TRUE;
}

//
// exported routines - LDE implementation
//

PSTR __stdcall GetLDEName()
{
	return "IntelliDump";
}

BOOL __stdcall DumpProcessRange( IN DWORD dwProcessId, IN void* pStartAddr, IN DWORD dwcBytes, OUT void* pDumpedBytes, OUT char* szErrorStr)
{
	BOOL                       bRet;
	HANDLE                     hProc;
	DWORD                      cb, cbFailure = 0, cb2Do, dwBlockSize;
	MEMORY_BASIC_INFORMATION   minfo;
	char                       cBuff[100];

	// get process handle
	hProc = OpenProcess( PROCESS_VM_READ, FALSE, dwProcessId );
	if ( !hProc )
	{
		lstrcpy( szErrorStr, "Error while querying process handle !" );
		return FALSE; // ERR
	}

	//
	// first let's try 2 dump the whole block directly
	//
	bRet = ReadProcessMemory( hProc, pStartAddr, pDumpedBytes, dwcBytes, &cb );
	CloseHandle( hProc );
	if ( bRet )
		goto TidyUp;

	//
	// scan the memory information
	//
	hProc = OpenProcess( PROCESS_VM_READ | PROCESS_QUERY_INFORMATION, FALSE, dwProcessId );
	if ( !hProc )
	{
		lstrcpy( szErrorStr, "Error while querying process handle !" );
		return FALSE; // ERR
	}

	cb2Do              = dwcBytes;
	minfo.BaseAddress  = pStartAddr;
	while ( cb2Do )
	{
		// get memory info
		bRet = VirtualQueryEx(
			hProc,
			minfo.BaseAddress,
			&minfo, sizeof(minfo));
		if ( !bRet )
		{
			lstrcpy( szErrorStr, "VirtualQueryEx() failed !" );
			goto TidyUp; // ERR
		}

		#define f  minfo.Protect

		dwBlockSize = min( minfo.RegionSize, cb2Do );
		if ( pStartAddr ) // first region dump ?
			dwBlockSize -= (DWORD)pStartAddr - (DWORD)minfo.BaseAddress;

		if ( ((f & PAGE_GUARD)     != 0) || // do we have access there ?
			 ((f & PAGE_NOACCESS)  != 0) )
		{
			//
			// don't try 2 dump this memory part
			//

			// zero not dumped part in output buffer
			memset(
				MakePtr( PVOID, pDumpedBytes, dwcBytes - cb2Do ),
				0,
				dwBlockSize);
			cbFailure += dwBlockSize;
		}
		else
		{
			//
			// dump normally
			//

			bRet = ReadProcessMemory(
				hProc,
				pStartAddr ? pStartAddr : minfo.BaseAddress,
				MakePtr( PVOID, pDumpedBytes, dwcBytes - cb2Do ),
				dwBlockSize,
				&cb);
			if ( pStartAddr ) // only non-zero  on first region dump
				pStartAddr = NULL;
			if ( !bRet )
			{
				// OK,no...zero not dumped part in output buffer
				memset(
					MakePtr( PVOID, pDumpedBytes, dwcBytes - cb2Do ),
					0,
					dwBlockSize);
				cbFailure += dwBlockSize;				
			}
		}

		// adjust vars
		minfo.BaseAddress   = MakePtr( PVOID, minfo.BaseAddress, minfo.RegionSize );
		cb2Do              -= dwBlockSize;
	}

	bRet = TRUE; // ret an OK

	if ( cbFailure ) // were any bytes not dumpable ?
	{
		wsprintf(
			cBuff,
			"0x%X of 0x%X bytes could not be dumped\nand were padded with zeros.",
			cbFailure, dwcBytes);
		MessageBox( GetActiveWindow(), cBuff, "IntelliDump", MB_ICONWARNING );
	}

	//
	// tidy up
	//
TidyUp:
	CloseHandle( hProc );

	return bRet;
}

void __stdcall ShowLDEInfo( IN HWND hwndParent )
{
	//
	// here you could normally show an about dialog or something like that
	//

	MessageBox(
		hwndParent,
		"This is a LDE performing a more intelligent process\n" \
		"data dumping by reading the target bytes in region steps.\n" \
		"Not accessible ones are padded by zeros. Useful for dumping\n" \
		".NET CLR applications because they have several regions\n" \
		"with PAGE_NOACCESS attributes in their module memory.\n" \
		"\n" \
		"An example LDE by yoda\n",
		"About IntelliDump",
		MB_OK | MB_ICONINFORMATION);

	return;
}
