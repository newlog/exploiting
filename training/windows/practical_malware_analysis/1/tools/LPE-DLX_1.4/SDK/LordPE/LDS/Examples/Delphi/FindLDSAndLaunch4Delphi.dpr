(*

    Code by SnowPanther/UG2000

*)

Function FindLDSAndLaunch : Boolean;
Var cKey        : Array[0..255+50]of Char;
    bSize,dType : Longword;
    cCmd        : String;
    rkey        : HKEY;
Begin
FindLDSAndLaunch:=False;
// get LDS path via registry entry for the exe file shell extension
if RegOpenKeyExA(HKEY_CLASSES_ROOT,'exefile\shell\Load into PE editor (LordPE)\command',
                 0,$20019,rkey)<>0then exit;
bSize:=sizeof(cKey);
if RegQueryValueEx(rKey,nil,0,@dType,@cKey,@bSize)<>0then
  begin RegCloseKey(rkey); exit end;
RegCloseKey(rkey);
// find 2nd quotation mark - end of path
cCmd:=copy(cKey,pos('"',cKey),length(cKey)-pos('"',cKey));
// launch LordPE with the command line of Dumper Server launch command + modifiers
delete(cCmd,1,1);
delete(cCmd,pos('"',cCmd),length(cCmd)-pos('"',cCmd)+1);
if ShellExecute(0,'open',pchar(cCmd),'/LDS-T+L',nil,SW_SHOW)<=32then exit;
FindLDSAndLaunch:=True;
End;

Begin
hwndLDS:=FindWindow(nil,LDS_WND_NAME); // Find LDS window
if hwndLDS=0 then
  if FindLDSAndLaunch then
    begin SysUtils.Sleep(500); hwndLDS:=FindWindow(nil,LDS_WND_NAME) end
  else
    ShowError('Launch LordPE''s dumper server first !');
End.
