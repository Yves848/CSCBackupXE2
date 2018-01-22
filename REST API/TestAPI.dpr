program TestAPI;

uses
  Vcl.Forms,
  uTestAPI in 'uTestAPI.pas' {Form2},
  XSuperObject in '..\XSuperObject.pas',
  XSuperJSON in '..\XSuperJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
