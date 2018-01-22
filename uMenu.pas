unit uMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,System.regularexpressions, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.ExtCtrls, sPanel, AdvMemo, Vcl.Buttons, sSpeedButton, Vcl.StdCtrls, Vcl.Mask,
  sMaskEdit, sCustomComboEdit, sToolEdit, uAddEntry, Vcl.ComCtrls, sTreeView, acTitleBar, sListView, sEdit, sLabel, AdvSmoothButton, sButton, System.ImageList,
  Vcl.ImgList, acAlphaImageList, acPopupCtrls, sScrollBox, sFrameBar, sTrackBar, acSlider, sBevel, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, sBitBtn,
  sDialogs, XSuperObject, uGreenockTools, uToolCompress, JvComponentBase, JvTrayIcon, advmjson, AdvSmoothLabel, acPathDialog, JvBalloonHint;

const
   eMailRegEx = '^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$';

type
  tPopUpEvent = Procedure(sTitle: String; sMessage: String) Of Object;

  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    sPanel1: TsPanel;
    sPanel2: TsPanel;
    sPanel3: TsPanel;
    sPanel4: TsPanel;
    sLabel1: TsLabel;
    sAlphaImageList1: TsAlphaImageList;
    sLabel2: TsLabel;
    lCompression: TsLabel;
    sTBCompression: TsTrackBar;
    sLMaxFiles: TsLabel;
    sTBMaxFiles: TsTrackBar;
    sLAgeMax: TsLabel;
    sTBAgeMax: TsTrackBar;
    slPath: TsSlider;
    slLogs: TsSlider;
    slVersion: TsSlider;
    slPopUps: TsSlider;
    slVisible: TsSlider;
    sgEntries: TAdvStringGrid;
    sgMailRules: TAdvStringGrid;
    sLabel7: TsLabel;
    sAlphaImageList2: TsAlphaImageList;
    btAddFolder: TsBitBtn;
    btAddFile: TsBitBtn;
    btRemoveEntry: TsBitBtn;
    btAddMail: TsBitBtn;
    btRemovemail: TsBitBtn;
    btnOpen: TsBitBtn;
    btnSave: TsBitBtn;
    btnSaveAs: TsBitBtn;
    btnQuit: TsBitBtn;
    btnNew: TsBitBtn;
    btnBackup: TsBitBtn;
    sOpenDialog1: TsOpenDialog;
    sSaveDialog1: TsSaveDialog;
    sDEDestination: TsDirectoryEdit;
    TrayIcon: TJvTrayIcon;
    sPanel5: TsPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    lFileName: TAdvSmoothLabel;
    sPathDialog1: TsPathDialog;
    sOpenDialog2: TsOpenDialog;
    JvBalloonHint1: TJvBalloonHint;
    procedure sSpeedButton3Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sTBMaxFilesChange(Sender: TObject);
    procedure sTBAgeMaxChange(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure sgMailRulesGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
    procedure sgMailRulesGetEditorProp(Sender: TObject; ACol, ARow: Integer; AEditLink: TEditLink);
    procedure btnSaveClick(Sender: TObject);
    procedure sTBCompressionChange(Sender: TObject);
    procedure btAddFolderClick(Sender: TObject);
    procedure btRemoveEntryClick(Sender: TObject);
    procedure btAddFileClick(Sender: TObject);
    procedure sgMailRulesCellValidate(Sender: TObject; ACol, ARow: Integer; var Value: string; var Valid: Boolean);
    procedure btAddMailClick(Sender: TObject);
    procedure btRemovemailClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
  private
    { Déclarations privées }
    CurrentConfig: ISuperObject;
    bCanClose: Boolean;
    slMailsWhen : tStrings;
    slCompressions : tStrings;
    Procedure UpdateMaxFiles;
    Procedure UpdateAgeMax;
    Procedure UpdateCompression;
    Procedure ParseConfigFile(sFile : String);
    Function BuildConfigFile : ISuperObject;
    Procedure FillEntries(aEntries : ISuperArray);
    Procedure InsertEntry(X : ISuperObject; I : Integer = -1);
    Procedure FillRules(aRules : iSuperArray);
    Procedure InsertRule(X : ISuperObject; I : Integer = -1);
    Procedure CleanEntries;
    Procedure CleanRules;
    Procedure MakeArchive(pconfig: String);
    Procedure Popup(sTitle: String; sMessage: String);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Procedure tForm1.InsertRule(X : ISuperObject; I : Integer = -1);
var
   Row : Integer;
begin
   if i = -1 then
   begin
      Row := sgMailRules.RowCount -1;
      if sgMailRules.Cells[0,Row] <> '' then
      begin
         sgMailRules.RowCount := sgMailRules.RowCount + 1;
         Row := sgMailRules.RowCount -1;
      end;
      sgMailRules.Cells[0,Row] := X.S['to'];
      sgMailRules.Cells[1,Row] := slMailsWhen[X.I['when']];
   end;
end;

Procedure tForm1.InsertEntry(X : ISuperObject; I : Integer = -1);
var
    Row : Integer;
    bCheck : Boolean;
begin
    if i = -1 then
    begin
       Row := sgEntries.RowCount-1;
       if sgEntries.Cells[0,Row] <> '' then
       begin
          sgEntries.RowCount := sgEntries.RowCount +1;
          Row := sgEntries.RowCount -1;
       end;
       sgEntries.Cells[0,Row] := X.S['name'];
       if X.I['type'] = 0 then
       begin
          sgEntries.Cells[1,Row] := 'Recurs';
          bCheck := (X.I['recurs'] = 1);
          sgEntries.AddCheckBox(1,Row,bCheck,false);
       end
       else
       begin
          sgEntries.Cells[1,Row] := 'File';
       end;
    end;
end;

Procedure tForm1.CleanEntries;
begin
   sgEntries.Clear;
   sgEntries.ColumnHeaders.Add('Entry Name');
   sgEntries.ColumnHeaders.Add('Type');
   sgEntries.RowCount := 2;
   //sgEntries.Cells[0,1] := '';
   //sgEntries.Cells[1,1] := '';
end;

Procedure tForm1.CleanRules;
begin
   sgMailRules.Clear;
   sgMailRules.ColumnHeaders.Add('To');
   sgMailRules.ColumnHeaders.Add('When');

   sgMailRules.RowCount := 2;
end;

Procedure tForm1.FillEntries(aEntries : ISuperArray);
var
   i : Integer;
   X : iSuperObject;
begin
   CleanEntries;
   i := 0;
   while i <= aEntries.Length -1 do
   begin
       X := aEntries.O[i];
       InsertEntry(X);
       inc(i);
   end;
end;

Procedure tForm1.FillRules(aRules : iSuperArray);
var
   i : Integer;
   X : iSuperObject;
begin
   CleanRules;
   i := 0;
   while i <= aRules.Length -1 do
   begin
      X := aRules.O[i];
      InsertRule(X);
      inc(i);
   end;

end;

Procedure tForm1.Popup(sTitle: String; sMessage: String);
Begin
  TrayIcon.BalloonHint(sTitle, sMessage);
End;

Procedure TForm1.MakeArchive(pconfig: String);
Var
  ptoCompress       : tToCompress;
  jsResult          : ISuperObject;
Begin

  ptoCompress := tToCompress.create(Self, pconfig, Nil, Nil);
  ptoCompress.pPopUps := Self.Popup;
  //pToCompress.Visible := True;
  jsResult := ptoCompress.MakeZip;

End;

procedure TForm1.FormCreate(Sender: TObject);
begin
   bCanClose := True;
   slMailsWhen := tStringList.Create;
   slMailsWhen.Add('Always');
   slMailsWhen.Add('If Warnings');
   slMailsWhen.Add('If Errors');

   slCompressions := tStringList.Create;
   slCompressions.Add('Normal');
   slCompressions.Add('Maximum');
   slCompressions.Add('Fast');
   slCompressions.Add('Super Fast');

   ParseConfigFile(sConfig);

   TrayIcon.Active := True;

   If bAuto Then
   Begin
      MakeArchive(sConfig);
      Application.Terminate;
   End;


   If Not bSilent Then
   Begin
     Show;
   End;
end;



Procedure tForm1.ParseConfigFile(sFile : String);
var
   anArray : ISuperArray;
begin
   if FileExists(sFile) then
   begin
      CurrentConfig := TSuperObject.ParseFile(sFile);
      sTBCompression.Position := CurrentConfig.I['compressionlevel'];
      sTBMaxFiles.Position := CurrentConfig.I['nbmax'];
      sTBAgeMax.Position := CurrentConfig.I['agemax'];
      sDEDestination.Text := CurrentConfig.S['destination'];
      lFileName.Caption.Text := CurrentConfig.S['filename'];
      slPath.SliderOn := CurrentConfig.B['local'];
      slLogs.SliderOn := CurrentConfig.B['generatelog'];
      slVersion.SliderOn := CurrentConfig.B['version'];
      slVisible.SliderOn := CurrentConfig.B['visible'];
      slPopUps.SliderOn := CurrentConfig.B['popups'];
      anArray := CurrentConfig.A['entries'];
      FillEntries(anArray);
      anArray := CurrentConfig.A['rules'];
      FillRules(anArray);
   end;
   UpdateMaxFiles;
   UpdateAgeMax;
   UpdateCompression;
end;

Function tForm1.BuildConfigFile : ISuperObject;
var
    iRow : Integer;
    iType : Integer;
    anArray : ISuperArray;
    arule : ISuperObject;
    anEntry : ISuperObject;
begin
     result := SO;
     result.S['filename'] := lFileName.Caption.Text;
     result.I['compressionlevel'] := sTBCompression.Position;
     result.S['destination'] := sDEDestination.Text;
     result.I['nbmax'] := sTBMaxFiles.Position;
     result.I['agemax'] := sTBAgeMax.Position;
     result.B['version'] := slVersion.SliderOn;
     result.B['local'] := slPath.SliderOn;
     result.B['visible'] := slVisible.SliderOn;
     result.B['popups'] := slPopUps.SliderOn;
     result.B['generatelog'] := slLogs.SliderOn;
     anArray := SA;
     iRow := 1;
     while iRow <= sgMailRules.RowCount -1 do
     begin
        anEntry := SO;
        anEntry.S['to'] := sgMailRules.Cells[0,iRow];
        anEntry.I['when'] := sgMailRules.ComboIndex[1,iRow];
        anArray.O[iRow-1] := anEntry;
        inc(iRow);
     end;
     result.A['rules'] := anArray;

     anArray := SA;
     iRow := 1;
     while iRow <= sgEntries.RowCount -1 do
     begin
        anEntry := SO;
        anEntry.S['name'] := sgEntries.Cells[0,iRow];
        if FileExists(anEntry.S['name']) then
           iType := 1
        else
        if DirectoryExists(anEntry.S['name']) then
           iType := 0;

        anEntry.I['type'] := iType;
        if iType = 0 then
        begin
           if sgMailRules.CheckCell(1,iRow) then
              anEntry.I['recurs'] := 1
           else
              anEntry.I['recurs'] := 0;
        end
        else
           anEntry.I['recurs'] := 0;

        anArray.O[iRow-1] := anEntry;
        inc(iRow);
     end;
     result.A['entries'] := anArray;

end;

Procedure tForm1.UpdateCompression;
begin
     lCompression.Caption := 'Compression : '+slCompressions[sTBCompression.Position];
end;

Procedure tForm1.UpdateAgeMax;
begin
   sLAgeMax.Caption := Format('Age Max %d days',[sTBAgeMax.Position]);
end;

Procedure tForm1.UpdateMaxFiles;
begin
     //if sTBMaxFiles.Position = 1 then
     
     sLMaxFiles.Caption := Format('Keep Max %d files',[sTBMaxFiles.Position]);
end;

procedure TForm1.btAddFileClick(Sender: TObject);
var
   x : ISuperObject;
begin
     if sOpenDialog2.Execute then
     begin
        X := SO;
        X.S['name'] := sOpenDialog2.FileName;
        X.I['type'] := 1;
        X.I['recurs'] := 0;
        InsertEntry(X);
        // Test Modifiation.
     end;

end;

procedure TForm1.btAddFolderClick(Sender: TObject);
var
   x : ISuperObject;
begin
     if sPathDialog1.Execute then
     begin
        X := SO;
        X.S['name'] := IncludeTrailingPathDelimiter(sPathDialog1.Path);
        X.I['type'] := 0;
        X.I['recurs'] := 1;
        InsertEntry(X);
     end;

end;

procedure TForm1.btAddMailClick(Sender: TObject);
var
   X : ISuperObject;
begin
   X := SO;
   X.S['to']   := '';
   X.I['when'] := 0;
   InsertRule(X);
   sgMailRules.Row := sgMailRules.RowCount -1;
   sgMailRules.Col := 0;
   sgMailRules.SetFocus;
   sgMailRules.ShowCellEdit;
end;

procedure TForm1.btnBackupClick(Sender: TObject);
begin
   MakeArchive(CurrentConfig.S['filename']);
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
    sOpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
    if sOpenDialog1.Execute then
    begin
       ParseConfigFile(sOpenDialog1.FileName);
    end;
end;

procedure TForm1.btnQuitClick(Sender: TObject);
begin
      Close;
end;

procedure TForm1.btnSaveAsClick(Sender: TObject);
var
   lFile : tStrings;
   X  : ISuperObject;
   bSave : Boolean;
begin
   lFile := TStringList.Create;
   CurrentConfig := BuildConfigFile;

   bSave := sSaveDialog1.Execute;
   if bSave then
   begin
      CurrentConfig.S['filename'] := sSaveDialog1.FileName;
   end;


   lFile.Text := CurrentConfig.AsJSON(true);
   lFile.SaveToFile(CurrentConfig.S['filename']);
   ParseConfigFile(CurrentConfig.S['filename']);
end;

procedure TForm1.btnSaveClick(Sender: TObject);
var
   lFile : tStrings;
   X  : ISuperObject;
   bSave : Boolean;
begin
   lFile := TStringList.Create;
   CurrentConfig := BuildConfigFile;
   bSave := True;
   if CurrentConfig.S['filename'] = '' then
   begin
       bSave := sSaveDialog1.Execute;
       if bSave then
       begin
          CurrentConfig.S['filename'] := sSaveDialog1.FileName;
       end;
   end;

   lFile.Text := CurrentConfig.AsJSON(true);
   lFile.SaveToFile(CurrentConfig.S['filename']);
end;

procedure TForm1.btRemoveEntryClick(Sender: TObject);
begin
    if sgEntries.Row > 1 then
      sgEntries.RemoveRows(sgEntries.Row,1)
    else
    begin
       if sgEntries.Row = 1 then
         CleanEntries;
    end;
end;

procedure TForm1.btRemovemailClick(Sender: TObject);
begin
    if sgMailRules.RowCount > 2 then
      sgMailRules.RemoveRows(sgMailRules.Row,1)
    else
    begin
       if sgMailRules.Row = 1 then
         CleanRules;
    end;
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
   Close;
end;

procedure TForm1.sgMailRulesCellValidate(Sender: TObject; ACol, ARow: Integer; var Value: string; var Valid: Boolean);
var
 match: tMatch;
 R : tRect;
begin
     match := tRegex.match(Value, eMailRegEx);
     Valid := match.Success;
     if not Valid then
     begin
        r := SGMailRules.CellRect(ACol, ARow);
        r.TopLeft := sgMailRules.ClientToScreen(R.TopLeft);
        R.BottomRight := sgMailRuleS.ClientToScreen(R.BottomRight);
        JvBalloonHint1.ActivateHintRect(R,'Error !','Invalid Email Address');
     end;
end;

procedure TForm1.sgMailRulesGetEditorProp(Sender: TObject; ACol, ARow: Integer; AEditLink: TEditLink);
begin
      if ARow > 0 then
         if ACol = 1 then
         begin
            sgMailRules.Combobox.Clear;
            sgMailRules.Combobox.Items.AddStrings(slMailsWhen);
         end;
end;

procedure TForm1.sgMailRulesGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
begin
      if ARow > 0 then
        if ACol = 1 then
           AEditor := edComboList;
end;

procedure TForm1.sSpeedButton3Click(Sender: TObject);
begin
      Close;
end;

procedure TForm1.sTBAgeMaxChange(Sender: TObject);
begin
   UpdateAgeMax;
end;

procedure TForm1.sTBCompressionChange(Sender: TObject);
begin
    UpdateCompression;
end;

procedure TForm1.sTBMaxFilesChange(Sender: TObject);
begin
    UpdateMaxFiles;
end;

end.
