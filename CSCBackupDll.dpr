library CSCBackupDll;

uses
  System.SysUtils,
  System.Classes,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  UVar in 'UVar.pas',
  XSuperObject,
  AbBase,
  AbBrowse,
  AbZBrows,
  AbZipper,
  AbComCtrls,
  AbMeter,
  AbArcTyp,
  AbUtils,
  uToolCompress in 'uToolCompress.pas';

type
  tCallBackFunction = procedure(iPos : Integer) of object;


procedure TestCallBack(sString : pChar; func : tCallBackFunction);
  var
    i : Integer;
  begin
     Showmessage(sString);
     i := 0;
     while i <= 100 do
     begin
        func(i);
        inc(i);
     end;
  end;

procedure CompressFiles(jsConfig : tSuperObject;eItemProgress :tItemProgress; eSaveProgress : tSaveProgress);
var
   pToCompress : tToCompress;
begin
   pToCompress := tToCompress.create(jsConfig, eItemProgress, eSaveProgress);
   //Showmessage('Created');
   pToCompress.MakeZip;
   pToCompress.Free;
end;

{$R *.res}

exports
   TestCallBack,
   CompressFiles;

begin
    
    

end.
