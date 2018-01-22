unit uProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothLabel, AdvSmoothProgressBar, AdvSmoothPanel, Vcl.StdCtrls;

type
  TfProgress = class(TForm)
    pbItemProgress: TAdvSmoothProgressBar;
    pbArchive: TAdvSmoothProgressBar;
    lFileName: TLabel;
    lFileNum: TLabel;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    Procedure Process;
  end;

var
  fProgress: TfProgress;

implementation

{$R *.dfm}

Procedure tfProgress.Process;
begin
   Application.ProcessMessages;
end;

end.