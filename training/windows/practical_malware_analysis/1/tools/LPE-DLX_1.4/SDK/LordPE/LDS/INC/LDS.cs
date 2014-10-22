
/*****************************************************************************

  LDS.cs (C#)
  ------

  version: 0.2

  Include file for LordPE Dumper Server plugins.
  Please send me (LordPE@gmx.net) your plugins.
  
  Not all elements of this include file were fully tested !

  by yoda

*****************************************************************************/

using System;
using System.Runtime.InteropServices;

sealed public class LDS
{
	//
	// constants
	//
	public const uint LDS_INTERFACE_VERSION              = 0x00000002;
	private const string LDS_WND_NAME                    = "[ LordPE Dumper Server ]";

	// commands
	[Flags()]
	private enum LDSCommands : uint
	{
		WM_USER                           = 0x00000400,
		WM_LDS_CMD_FIRST				  = WM_USER + 0x7000,

		// wParam - client PID
		// lParam - PLDS_VERSION
		WM_LDS_CMD_QUERYVERSION           = WM_LDS_CMD_FIRST +  10,

		// wParam - client PID
		// lParam - PLDS_LOG_ENTRY
		WM_LDS_CMD_ADDLOG                 = WM_LDS_CMD_FIRST +  20,  // max are 1024 characters (including NUL)

		// wParam - client PID
		// lParam - PLDS_MODULE_INFO
		WM_LDS_CMD_QUERYPROCESSMODULEINFO = WM_LDS_CMD_FIRST +  30,

		// wParam - client PID
		// lParam - PLDS_ENUM_PIDS
		WM_LDS_CMD_ENUMPROCESSIDS         = WM_LDS_CMD_FIRST +  31,

		// wParam - client PID
		// lParam - PLDS_ENUM_PROCESSMODULES
		WM_LDS_CMD_ENUMPROCESSMODULES     = WM_LDS_CMD_FIRST +  32,

		// wParam - client PID
		// lParam - PLDS_FIND_PID
		WM_LDS_CMD_FINDPROCESSID          = WM_LDS_CMD_FIRST +  33,

		// wParam - client PID
		// lParam - PLDS_FULL_DUMP/PLDS_FULL_DUMP_EX
		WM_LDS_CMD_DUMPPROCESSMODULE      = WM_LDS_CMD_FIRST +  40,

		// wParam - client PID
		// lParam - PLDS_PARTIAL_DUMP
		WM_LDS_CMD_DUMPPROCESSBLOCK       = WM_LDS_CMD_FIRST +  41
	}

	// dump options
	[Flags()]
	public enum DumpModifiers : uint
	{
		LDS_DUMP_CORRECTIMAGESIZE         = 0x00000001,
		LDS_DUMP_USEHEADERFROMDISK        = 0x00000002,
		LDS_DUMP_FORCERAWMODE             = 0x00000004,
		LDS_DUMP_SAVEVIAOFN               = 0x00000008
	}

	// rebuilding options
	[Flags()]
	public enum RebuildingModifiers : uint
	{
		LDS_REB_REALIGNIMAGE              = 0x00010000,
		LDS_REB_WIPERELOCATIONOBJECT      = 0x00020000,
		LDS_REB_REBUILDIMPORTS            = 0x00040000,
		LDS_REB_VALIDATEIMAGE             = 0x00080000,
		LDS_REB_CHANGEIMAGEBASE           = 0x00100000
	}

	//
	// structures
	//
	[StructLayout(LayoutKind.Sequential)]
	public struct LDS_VERSION
	{
		public uint         dwStructSize;
		public uint         dwVersion;
	}

	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
	public struct LDS_LOG_ENTRY
	{
		public uint         dwStructSize;
		public string       szStr;
		public uint         dwStrSize;                                // including NUL-character
		public uint         bCatAtLast;                               // add str at end of last item's text ?
	}

	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
	public struct LDS_MODULE_INFO
	{
		public uint         dwStructSize;
		public uint         dwPID;
		public uint         hImageBase;                               // if NULL - calling module is snapped
		public uint         dwImageSize;
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst=260)]
		public string       cModulePath;                              // cModulePath[0] == 0 if not set
	}

	[StructLayout(LayoutKind.Sequential)]
	public unsafe struct LDS_ENUM_PIDS
	{
		public uint         dwStructSize;
		public uint         dwChainSize;
		public uint*        pdwPIDChain;                              // DWORD array for PIDs
		public uint         dwItemCount;
	}

	[StructLayout(LayoutKind.Sequential)]
	public unsafe struct LDS_ENUM_PROCESS_MODULES
	{
		public uint         dwStructSize;
		public uint         dwPID;
		public uint         dwChainSize;
		public uint*        pdwImageBaseChain;                        // DWORD array for module handles
		public uint         dwItemCount;
	}

	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
	public unsafe struct LDS_FIND_PID
	{
		public uint         dwStructSize;
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst=260)]
		public string       cProcessPath;                             // can be incomplete
		public uint         dwPID;
	}

	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
	public unsafe struct LDS_FULL_DUMP
	{
		public uint         dwStructSize;
		public uint         dwFlags;                                  // LDS_DUMP_XXX/LDS_REB_XXX
		public uint         dwPID;
		public uint         hModuleBase;                              // NULL - calling module is dumped
		public uint         bDumpSuccessfully;
		public uint         dwSizeOfDumpedImage;
		public uint         bUserSaved;                               // LDS_DUMP_SAVEVIAOFN
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst=260)]
		public string       cSavedTo;                                 // LDS_DUMP_SAVEVIAOFN
		public void*        pDumpedImage;                             // !LDS_DUMP_SAVEVIAOFN
		// rebuilding structure elements
		public uint         dwRealignType;                            // 0-normal 1-hardcore 2-nice
		public uint         dwNewImageBase;                           // format: 0xXXXX0000
	}

	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
	public unsafe struct LDS_FULL_DUMP_EX                         // ver 0.2 
	{
		public uint         dwStructSize;
		public uint         dwFlags;                                  // LDS_DUMP_XXX/LDS_REB_XXX
		public uint         dwPID;
		public uint         hModuleBase;                              // NULL - calling module is dumped
		public uint         bDumpSuccessfully;
		public uint         dwSizeOfDumpedImage;
		public uint         bUserSaved;                               // LDS_DUMP_SAVEVIAOFN
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst=260)]
		public string       cSavedTo;                                 // LDS_DUMP_SAVEVIAOFN
		public void*        pDumpedImage;                             // !LDS_DUMP_SAVEVIAOFN
		// rebuilding structure elements
		public uint         dwRealignType;                            // 0-normal 1-hardcore 2-nice
		public uint         dwNewImageBase;                           // format: 0xXXXX0000
		public uint         dwEntryPointRva;                          // 0 = don't set to image
		public uint         dwExportTableRva;                         // 0 = don't set to image
		public uint         dwImportTableRva;                         // 0 = don't set to image
		public uint         dwResourceDirRva;                         // 0 = don't set to image
		public uint         dwRelocationDirRva;                       // 0 = don't set to image
	}

	[StructLayout(LayoutKind.Sequential)]
	public unsafe struct LDS_PARTIAL_DUMP
	{
		public uint         dwStructSize;
		public uint         dwPID;
		public void*        pBlock;
		public uint         dwBlockSize;
		public uint         bSaveViaOfn;
		public uint         bDumpSuccessfully;
		public uint         bUserSaved;                               // bSaveViaOfn
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst=260)]
		public string       cSavedTo;                                 // bSaveViaOfn
		public void*        pDumpedImage;                             // !bSaveViaOfn
	}

	//
	// prepare the usage of Win32 APIs
	//
	[DllImport("User32.DLL", EntryPoint="FindWindowA", CharSet=CharSet.Ansi)]
	static private extern uint _FindWindow(string szClass, string szWin); 

	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_VERSION lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_LOG_ENTRY lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_MODULE_INFO lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_ENUM_PIDS lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_ENUM_PROCESS_MODULES lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_FIND_PID lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_FULL_DUMP lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_FULL_DUMP_EX lParam);
	[DllImport("User32.DLL", EntryPoint="SendMessageA")]
	static private extern uint _SendMessage(uint hWnd, uint uMsg, uint wParam, ref LDS_PARTIAL_DUMP lParam);

	[DllImport("Kernel32.DLL", EntryPoint="GetCurrentProcessId")]
	static private extern uint _GetCurrentProcessId(); 

	//
	// static routines
	//

	/// <returns>0 in case of an error</returns>
	static public uint GetLDSWindowHandle()
	{
		return _FindWindow(null, LDS_WND_NAME.ToString());
	}

	static public bool IsLDSUp()
	{
		return GetLDSWindowHandle() == 0 ? false : true;
	}

	static public bool QueryVersion(ref LDS_VERSION ver)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd,
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_QUERYVERSION),
			PID,
			ref ver);

		return true; // OK
	}

	static public bool AddToLog(ref LDS_LOG_ENTRY log)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_ADDLOG),
			PID,
			ref log);

		return true; // OK
	}

	static public bool QueryModuleInfo(ref LDS_MODULE_INFO mod)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_QUERYPROCESSMODULEINFO),
			PID,
			ref mod);

		return true; // OK
	}

	static public bool EnumProcessIDs(ref LDS_ENUM_PIDS pidlist)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_ENUMPROCESSIDS),
			PID,
			ref pidlist);

		return true; // OK
	}

	static public bool EnumProcessModules(ref LDS_ENUM_PROCESS_MODULES modlist)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_ENUMPROCESSMODULES),
			PID,
			ref modlist);

		return true; // OK
	}

	static public bool FindProcessID(ref LDS_FIND_PID fp)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_FINDPROCESSID),
			PID,
			ref fp);

		return true; // OK
	}

	static public bool DoFullDump(ref LDS_FULL_DUMP fd)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_DUMPPROCESSMODULE),
			PID,
			ref fd);

		return true; // OK
	}

	static public bool DoFullDumpEx(ref LDS_FULL_DUMP_EX fd)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_DUMPPROCESSMODULE),
			PID,
			ref fd);

		return true; // OK
	}

	static public bool DoPartialDump(ref LDS_PARTIAL_DUMP pd)
	{
		uint hwnd = GetLDSWindowHandle();
		uint PID  = _GetCurrentProcessId();

		if (hwnd == 0)
			return false; // ERR
		_SendMessage(
			hwnd, 
			Convert.ToUInt32(LDSCommands.WM_LDS_CMD_DUMPPROCESSBLOCK),
			PID,
			ref pd);

		return true; // OK
	}
}
