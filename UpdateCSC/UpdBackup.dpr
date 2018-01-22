program UpdBackup;

{$R 'gzip.res' 'gzip.rc'}

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fUpdBAckup},
  uLib in 'uLib.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('TabletDark');
  Application.CreateForm(TfUpdBAckup, fUpdBAckup);
  Application.Run;
end.
