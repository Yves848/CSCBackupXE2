unit uAddEntry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sToolEdit, Vcl.StdCtrls, Vcl.Mask, sMaskEdit, sCustomComboEdit;

type
  TfAddEntry = class(TForm)
    sDirectoryEdit1: TsDirectoryEdit;
    sFilenameEdit1: TsFilenameEdit;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  fAddEntry: TfAddEntry;

implementation

{$R *.dfm}

end.
