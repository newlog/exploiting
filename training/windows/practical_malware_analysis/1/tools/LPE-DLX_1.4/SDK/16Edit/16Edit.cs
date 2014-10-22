/*****************************************************************************

  16Edit.cs (C#)
  ---------

  version: FX

  Include file for 16Edit.dll.

  by yoda

*****************************************************************************/

using System;
using System.Runtime.InteropServices;

[Flags()]
	public enum ShowWindowFlags : ushort
	{
		SW_HIDE             = 0,
		SW_SHOWNORMAL       = 1,
		SW_NORMAL           = 1,
		SW_SHOWMINIMIZED    = 2,
		SW_SHOWMAXIMIZED    = 3,
		SW_MAXIMIZE         = 3,
		SW_SHOWNOACTIVATE   = 4,
		SW_SHOW             = 5,
		SW_MINIMIZE         = 6,
		SW_SHOWMINNOACTIVE  = 7,
		SW_SHOWNA           = 8,
		SW_RESTORE          = 9,
		SW_SHOWDEFAULT      = 10,
		SW_FORCEMINIMIZE    = 11,
		SW_MAX              = 11,
	}

public class cls16Edit
{
	//
	// constants
	//

	// handler action codes 
	[Flags()]
		public enum heActionFlags : uint
		{
			HE_ACTION_EXITING               = 0x00000001,
			HE_ACTION_SAVED                 = 0x00000002,
			HE_ACTION_FILEACCESSINFO        = 0x00000004,
			HE_ACTION_WINDOWCREATED         = 0x00000008
		}

	// flags for HE_SETTINGS
	[Flags()]
		public enum heSettingFlags : uint
		{
			HE_SET_FORCEREADONLY            = 0x00000001,
			HE_SET_NORESIZE                 = 0x00000002,
			HE_SET_SETCURRENTOFFSET         = 0x00000004,
			HE_SET_SETSELECTION             = 0x00000008,
			HE_SET_ACTIONHANDLER            = 0x00000010,
			HE_SET_INPUTFILE                = 0x00000020,
			HE_SET_MEMORYBLOCKINPUT         = 0x00000040,
			HE_SET_ONTOP                    = 0x00000080,
			HE_SET_PARENTWINDOW             = 0x00000100,
			HE_SET_MINIMIZETOTRAY           = 0x00000200,
			HE_SET_SAVEWINDOWPOSITION       = 0x00000400,
			HE_SET_RESTOREWINDOWPOSITION    = 0x00000800,
			HE_SET_USERWINDOWPOSITION       = 0x00001000
		}

	//
	// structures
	//
	[StructLayout(LayoutKind.Sequential)]
		public unsafe struct HE_DATA_INFO
		{
			public void*       pDataBuff;
			public uint        dwSize;
			public uint        bReadOnly;
		}
	
	[StructLayout(LayoutKind.Sequential)]
		public struct HE_POS
		{
			public uint        dwOffset;
			public uint        bHiword;       // (opt.) first digit of the pair ? ...or the 2nd one ?
			public uint        bTextSection;  // (opt.) Caret in the text part ?
		}

	[StructLayout(LayoutKind.Sequential)]
		public struct HE_WIN_POS
		{
			public int         iState;             // SW_SHOWNORMAL/SW_MAXIMIZE/SW_MINIMIZE
			public int         ix, iy, icx, icy;   // left, top, width, height
		}

	[StructLayout(LayoutKind.Sequential)]
		public struct HE_ACTION
		{
			public uint        dwActionCode;
			public uint        dwNewSize;            // HE_ACTION_SAVED
			public uint        bReadWrite;           // HE_ACTION_FILEACCESSINFO
			public uint        hwnd16Edit;           // HE_ACTION_WINDOWCREATED
		}

	[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
		public unsafe struct HE_SETTINGS_FILE_INPUT
		{
			public uint		          dwMask;             // HE_SET_XXX flags
			public void*              pHandler;           // HE_SET_ACTIONHANDLER
			public HE_POS             posCaret;           // HE_SET_SETCURRENTOFFSET
			public uint               dwSelStartOff;      // HE_SET_SETSELECTION
			public uint               dwSelEndOff;        // 
			public uint               hwndParent;         // HE_SET_PARENTWINDOW
			public String             szFilePath;         // HE_SET_INPUTFILE
			public uint               Reserved0;
			public uint               Reserved1;
			public HE_WIN_POS         wpUser;             // HE_SET_USERWINDOWPOSITION
		}

	[StructLayout(LayoutKind.Sequential)]
		public unsafe struct HE_SETTINGS_MEMBLOCK_INPUT
		{
			public uint		          dwMask;             // HE_SET_XXX flags
			public void*              pHandler;           // HE_SET_ACTIONHANDLER
			public HE_POS             posCaret;           // HE_SET_SETCURRENTOFFSET
			public uint               dwSelStartOff;      // HE_SET_SETSELECTION
			public uint               dwSelEndOff;        // 
			public uint               hwndParent;         // HE_SET_PARENTWINDOW
			public HE_DATA_INFO       diMem;              // HE_SET_MEMORYBLOCKINPUT
			public HE_WIN_POS         wpUser;             // HE_SET_USERWINDOWPOSITION
		}

	[StructLayout(LayoutKind.Explicit, CharSet=CharSet.Ansi)]
		public unsafe struct HE_SETTINGS
		{
			[FieldOffset(00)]
			public HE_SETTINGS_MEMBLOCK_INPUT  heMemBlockInput;
			[FieldOffset(00)]
			public HE_SETTINGS_FILE_INPUT      heFileInput;
		}

	//
	// extern 16Edit.dll API definitions
	//

	// HESpecifySettings
	[DllImport("16Edit.DLL", EntryPoint="HESpecifySettings")]
	static private extern bool _HESpecifySettings(ref HE_SETTINGS pset);

	static public bool HESpecifySettings(ref HE_SETTINGS pset)
	{
		return _HESpecifySettings(ref pset);
	}

	// HEEnterWindowLoop
	[DllImport("16Edit.DLL", EntryPoint="HEEnterWindowLoop")]
	static private extern bool _HEEnterWindowLoop();

	static public bool HEEnterWindowLoop()
	{
		return _HEEnterWindowLoop();
	}

	// HEEnterWindowLoopInNewThread
	[DllImport("16Edit.DLL", EntryPoint="HEEnterWindowLoopInNewThread")]
	static private extern bool _HEEnterWindowLoopInNewThread();

	static public bool HEEnterWindowLoopInNewThread()
	{
		return _HEEnterWindowLoopInNewThread();
	}
}