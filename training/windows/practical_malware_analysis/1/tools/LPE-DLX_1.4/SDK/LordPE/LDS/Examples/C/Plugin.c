/*

LordPE Dumper Server - plugin example for C
-------------------------------------------

Lists all currently running proccesses and its modules + some infos in a
TreeView control.

by yoda

*/

#define  WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <commctrl.h>
#include "resource.h"
#include "..\LDS.h"

#pragma comment(lib, "COMCTL32.LIB")
#pragma comment(linker,"/ENTRY:main /SUBSYSTEM:WINDOWS /FILEALIGN:512 /MERGE:.rdata=.text /MERGE:.data=.text /SECTION:.text,EWR /IGNORE:4078")

// prototypes
void           ErrorMsg(char* szText);
char*          ExtractFileName(char* szDir);
void           LDSLog(HWND hwndLDS, char* szBuff, DWORD dwBuffSize);
BOOL __stdcall MainDlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam);
void           ShowTaskList(HWND hDlg);

//
// constants
//
const char       cPluginName[]          = "Plugin example for C by yoda...";

//
// global variables
//
HWND             hwndLDS;
HINSTANCE        hInst;
DWORD            dwMyPID;

//
// ENTRYPOINT
//
void main()
{
	INITCOMMONCONTROLSEX iccex;

	// get acces to TreeView control
	iccex.dwSize  = sizeof(iccex);
	iccex.dwICC   = ICC_TREEVIEW_CLASSES;
	InitCommonControlsEx(&iccex);

	// save PID + base away
	dwMyPID = GetCurrentProcessId();
	hInst   = GetModuleHandle(NULL);

	//
	// find DumperServer window
	//
	hwndLDS = FindWindow(NULL, LDS_WND_NAME);
	if (!hwndLDS)
	{
		ErrorMsg("Please lunch LordPE's Dumper Server first !");
		goto Exit;
	}

	//
	// show plugin name in LDS window
	//
	LDSLog(hwndLDS, (char*)cPluginName, sizeof(cPluginName));

	//
	// open dlg + list information
	//
	DialogBoxParam(
		hInst,
		(PSTR)IDD_MAINDLG,
		NULL,
		MainDlgProc,
		0);

Exit:
	ExitProcess(0);
}

void ErrorMsg(char* szText)
{
	MessageBox(0, szText, "LordPE Plugin", MB_ICONERROR | MB_TOPMOST);
	return;
}

char* ExtractFileName(char* szDir)
{
	char* pCH;

	pCH = (char*)((DWORD)szDir + lstrlen(szDir) - 1);
	while (*pCH != '\\')
		pCH--;
	pCH++;

	return pCH;
}

void LDSLog(HWND hwndLDS, char* szBuff, DWORD dwBuffSize)
{
	LDS_LOG_ENTRY     lle;

	lle.dwStructSize  = sizeof(lle);
	lle.bCatAtLast    = FALSE;
	lle.szStr         = szBuff;
	lle.dwStrSize     = dwBuffSize;
	SendMessage(hwndLDS, WM_LDS_CMD_ADDLOG, dwMyPID, (LPARAM)&lle);

	return;
}

BOOL __stdcall MainDlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch(uMsg)
	{
	case WM_INITDIALOG:
		ShowTaskList(hDlg);
		return TRUE;

	case WM_CLOSE:
		// end dlg
		EndDialog(hDlg, 0);
		return TRUE;
	}

	return FALSE;
}

void ShowTaskList(HWND hDlg)
{
	DWORD                      dwPids[60];
	DWORD                      dwMods[200];
	LDS_ENUM_PIDS              ep;
	LDS_ENUM_PROCESS_MODULES   epm;
	LDS_MODULE_INFO            mi;
	TV_INSERTSTRUCT            tvInsert;
	UINT                       u, u2;
	char                       buff[MAX_PATH + 50];
	HWND                       hTV;
	HTREEITEM                  htiPID;

	hTV = GetDlgItem(hDlg, MD_TREE);

	//
	// enum PIDS
	//
	memset(&ep, 0, sizeof(ep));
	ep.dwStructSize    = sizeof(ep);
	ep.pdwPIDChain     = (PDWORD)&dwPids;
	ep.dwChainSize     = sizeof(dwPids);
	SendMessage(hwndLDS, WM_LDS_CMD_ENUMPROCESSIDS, dwMyPID, (LPARAM)&ep);

	//
	// trace PIDs
	//
	memset(&tvInsert, 0, sizeof(tvInsert));
	tvInsert.item.mask     = TVIF_TEXT;
	tvInsert.item.pszText  = buff;
	tvInsert.hInsertAfter  = TVI_LAST;
	for (u = 0; u < ep.dwItemCount; u++)
	{
		tvInsert.hParent = NULL; // set root as parent

		// show PID + eventually calling module (0)
		memset(&mi, 0, sizeof(mi));
		mi.dwStructSize    = sizeof(mi);
		mi.dwPID           = dwPids[u];
		mi.hImageBase      = NULL;
		SendMessage(hwndLDS, WM_LDS_CMD_QUERYPROCESSMODULEINFO, dwMyPID, (LPARAM)&mi);
		if (!mi.cModulePath[0])
			wsprintf(buff, "PID: 0x%08lX", dwPids[u]);
		else
			wsprintf(buff, "PID: 0x%08lX (%s)", dwPids[u], ExtractFileName(mi.cModulePath));
		htiPID = (HTREEITEM)SendMessage(hTV, TVM_INSERTITEM, 0, (LPARAM)&tvInsert);
		tvInsert.hParent = htiPID; // parent -> PID item

		// get module bases
		memset(&epm, 0, sizeof(epm));
		epm.dwStructSize      = sizeof(epm);
		epm.dwPID             = dwPids[u];
		epm.pdwImageBaseChain = (PDWORD)&dwMods;
		epm.dwChainSize       = sizeof(dwMods);
		SendMessage(hwndLDS, WM_LDS_CMD_ENUMPROCESSMODULES, dwMyPID, (LPARAM)&epm);

		//
		// trace modules
		//
		for (u2 = 0; u2 < epm.dwItemCount; u2++)
		{
			tvInsert.hParent = htiPID; // add after PID

			// get module infos
			memset(&mi, 0, sizeof(mi));
			mi.dwStructSize    = sizeof(mi);
			mi.dwPID           = dwPids[u];
			mi.hImageBase      = (HMODULE)dwMods[u2];
			SendMessage(hwndLDS, WM_LDS_CMD_QUERYPROCESSMODULEINFO, dwMyPID, (LPARAM)&mi);

			// path (1)
			tvInsert.item.pszText = mi.cModulePath;
			tvInsert.hParent = (HTREEITEM)SendMessage(hTV, TVM_INSERTITEM, 0, (LPARAM)&tvInsert);
			// (parent -> module path)

			// base (2)
			tvInsert.item.pszText = buff;
			wsprintf(buff, "ImageBase: 0x%08lX", mi.hImageBase);
			SendMessage(hTV, TVM_INSERTITEM, 0, (LPARAM)&tvInsert);

			// size (2)
			wsprintf(buff, "ImageSize: 0x%08lX", mi.dwImageSize);
			SendMessage(hTV, TVM_INSERTITEM, 0, (LPARAM)&tvInsert);			
		}
	}

	return;
}
