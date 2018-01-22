unit uversion;

interface
Uses
   Windows,SysUtils,Types;

   procedure GetBuildInfo(Exe : String;var V1, V2, V3, V4: Word);
   function _getVersion(_AppPath : String) : String;

implementation

{
  [YGO] 29/01/2008
        - Remplacement de la variable globale sVersion par la foction _getVersion
          pour toujours avoir le bon n° de version pour l'EXE et la DLL.
}
function _getVersion(_AppPath : String) : String;
var
   V1,
   V2,
   V3,
   V4  : Word;
begin
   Result := ''; 
   if fileexists(_apppath) then
   begin
      GetBuildinfo(_AppPath,V1,V2,V3,V4);
      Result := Inttostr(V1)+'.'+Inttostr(V2)+'.'+Inttostr(V3)+'.'+inttostr(V4);
   end;
end;

procedure GetBuildInfo(Exe : String;var V1, V2, V3, V4: Word);
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(exe), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(exe), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

end.
