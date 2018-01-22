{

 ____               __                          ___
/\  _`\            /\ \__                      /\_ \
\ \ \L\ \_ __   ___\ \ ,_\   ___     ___    ___\//\ \
 \ \ ,__/\`'__\/ __`\ \ \/  / __`\  /'___\ / __`\\ \ \
  \ \ \/\ \ \//\ \L\ \ \ \_/\ \L\ \/\ \__//\ \L\ \\_\ \_
   \ \_\ \ \_\\ \____/\ \__\ \____/\ \____\ \____//\____\
    \/_/  \/_/ \/___/  \/__/\/___/  \/____/\/___/ \/____/

Coded by Protocol - Hackhound.org
}
Unit uMain;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, CommCtrl, ExtCtrls, ShellApi, System.ImageList, CurvyControls, AdvSmoothButton;

Type
  TFrmMain = Class(TForm)
    LvFileMan: TListView;
    TvFileMan: TTreeView;
    Splitter: TSplitter;
    ilTvFileMan: TImageList;
    ilLvFileMan: TImageList;
    CurvyPanel1: TCurvyPanel;
    btQuit: TAdvSmoothButton;
    Procedure FormCreate(Sender: TObject);
    Procedure TvFileManClick(Sender: TObject);
    procedure btQuitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  End;
  Function GetNodeByText(ATree: TTreeView; AValue: String; AVisible: Boolean): TTreeNode;
  Function TracePath(Node: TTreeNode; DirName: String): String;

Var
  FrmMain           : TFrmMain;
  IconList          : TStringList;
Implementation

{$R *.dfm}

Function ImageList_ReplaceIcon(ImageList: THandle; Index: Integer; Icon: hIcon): Integer; stdcall; external 'comctl32.dll' name 'ImageList_ReplaceIcon';

Function FormatFileSize(Size: extended): String;
{Credit P0ke}
Begin
  If Size = 0 Then
  Begin
    Result := '0 B';
  End
  Else If Size < 1000 Then
  Begin
    Result := FormatFloat('0', Size) + ' B';
  End
  Else
  Begin
    Size := Size / 1024;
    If (Size < 1000) Then
    Begin
      Result := FormatFloat('0.0', Size) + ' KB';
    End
    Else
    Begin
      Size := Size / 1024;
      If (Size < 1000) Then
      Begin
        Result := FormatFloat('0.00', Size) + ' MB';
      End
      Else
      Begin
        Size := Size / 1024;
        If (Size < 1000) Then
        Begin
          Result := FormatFloat('0.00', Size) + ' GB';
        End
        Else
        Begin
          Size := Size / 1024;
          If (Size < 1024) Then
          Begin
            Result := FormatFloat('0.00', Size) + ' TB';
          End
        End
      End
    End
  End;
End;

Procedure AddDrives;
Var
  cDrives           : Array[0..128] Of char;
  pDrive            : PChar;
  Icon              : TIcon;
  shInfo            : TSHFileInfo;
  TreeNode          : TTreeNode;
Begin
  If GetLogicalDriveStrings(SizeOf(cDrives), cDrives) = 0 Then
    exit;
  FrmMain.TvFileMan.Items.BeginUpdate;
  pDrive := cDrives;
  Icon := TIcon.Create;
  While pDrive^ <> #0 Do
  Begin
    TreeNode := FrmMain.TvFileMan.Items.Add(Nil, pDrive);
    SHGetFileInfo(PChar(pDrive), 0, shInfo, SizeOf(shInfo), SHGFI_ICON Or SHGFI_SMALLICON Or SHGFI_SYSICONINDEX);
    Icon.Handle := shInfo.hIcon;
    TreeNode.ImageIndex := FrmMain.ilTvFileMan.AddIcon(Icon);
    TreeNode.SelectedIndex := TreeNode.ImageIndex;
    Inc(pDrive, 4);
  End;
  Icon.Free;
  FrmMain.TvFileMan.Items.EndUpdate;
End;

{*
Procedure AddDrives;
var
  Ld            :DWORD;
  I             :Integer;
  TreeNode      :TTreeNode;
  Icon          :TIcon;
  shInfo        :TSHFileInfo;
  pDrive        :String;
begin
Icon := TIcon.Create;
  FrmMain.TvFileMan.Items.BeginUpdate;
    Ld := GetLogicalDrives;
    for I := 0 to 25 do
    begin
      if (Ld and (1 shl I)) <> 0 then
      begin
        pDrive := String( Char(Ord('A') + I) + ':' ) +'\';
        TreeNode := FrmMain.tvFileMan.Items.Add(nil,pDrive);
          SHGetFileInfo(pChar(pDrive), 0, shInfo, SizeOf(shInfo),SHGFI_ICON or SHGFI_SMALLICON or SHGFI_SYSICONINDEX);
           Icon.Handle := shInfo.hIcon;
           TreeNode.ImageIndex :=  FrmMain.ilTvFileMan.AddIcon(Icon);
           TreeNode.SelectedIndex  := TreeNode.ImageIndex;
      end;
    end;
  FrmMain.TvFileMan.Items.EndUpdate;
Icon.Free;
end;
*}

Function TracePath(Node: TTreeNode; DirName: String): String;
Begin
  While Node.Parent <> Nil Do
  Begin
    Result := ExcludeTrailingPathDelimiter(Node.Parent.Text) + '\' + Result;
    Node := Node.Parent;
  End;
  Result := Result + ExcludeTrailingPathDelimiter(DirName) + '\';
  //FrmMain.StatusBar.SimpleText := Result;
End;

procedure TFrmMain.btQuitClick(Sender: TObject);
begin
   Close;
end;

Procedure TFrmMain.FormCreate(Sender: TObject);
Begin
  AddDrives;
End;

Function FormatAttr(Attr: Integer): String;
Begin
  SetLength(Result, 0);
  If Bool(Attr And FILE_ATTRIBUTE_READONLY) Then
    Result := 'R';
  If Bool(Attr And FILE_ATTRIBUTE_ARCHIVE) Then
    Result := Result + ' A';
  If Bool(Attr And FILE_ATTRIBUTE_SYSTEM) Then
    Result := Result + ' S';
  If Bool(Attr And FILE_ATTRIBUTE_HIDDEN) Then
    Result := Result + ' H';
End;

Function GetNodeByText(ATree: TTreeView; AValue: String; AVisible: Boolean): TTreeNode;
Var
  Node              : TTreeNode;
Begin
  Result := Nil;
  If ATree.Items.Count = 0 Then
    exit;
  Node := ATree.Items[0];
  While Node <> Nil Do
  Begin
    If UpperCase(Node.Text) = UpperCase(AValue) Then
    Begin
      Result := Node;
      If AVisible Then
        Result.MakeVisible;
      Break;
    End;
    Node := Node.GetNext;
  End;
End;

Procedure ListFolders(Directory: String);
Var
  SearchRec         : TSearchRec;
  SHFileInfo        : TSHFileInfo;
  Icon              : TIcon;
  LItem             : TListItem;
  NodeList          : TStringList;
  nCount            : Integer;
  TmpN              : TTreeNode;
Begin

  NodeList := TStringList.Create;
  Icon := TIcon.Create;
  Try
    FrmMain.ilLvFileMan.Clear;
    FrmMain.LvFileMan.Items.Clear;

    FrmMain.TvFileMan.Items.BeginUpdate;
    FrmMain.LvFileMan.Items.BeginUpdate;

    SetErrorMode($8007);                //Stops Errors From Removable Storage.

    TmpN := FrmMain.TvFileMan.Selected.getFirstChild;
    For nCount := 0 To FrmMain.TvFileMan.Selected.Count - 1 Do
    Begin
      NodeList.Add(TmpN.Text);
      TmpN := TmpN.getNextSibling;
    End;

    If FindFirst(Directory + '*.*', FaAnyFile, SearchRec) = 0 Then
    Begin
      Repeat
        If SearchRec.name = '.' Then
          continue;
        If SearchRec.name = '..' Then
          continue;
        SHGetFileInfo(PChar(Directory + SearchRec.name), 0, SHFileInfo, SizeOf(SHFileInfo), SHGFI_TYPENAME Or SHGFI_ICON Or SHGFI_SMALLICON);

        If (lowercase(SHFileInfo.szTypeName) = 'file folder')
          Or ((SearchRec.Attr and faDirectory) = faDirectory)
          Or (lowercase(SHFileInfo.szTypeName) = 'folder') Then
        Begin
          If NodeList.IndexOf(SearchRec.name) <> -1 Then
          Begin
            //  find it
            NodeList.Delete(NodeList.IndexOf(SearchRec.name));
          End
          Else
          Begin
            //  dnt find it
            FrmMain.TvFileMan.Items.AddChild(FrmMain.TvFileMan.Selected, SearchRec.name);
          End;
        End
        Else
        Begin
          LItem := FrmMain.LvFileMan.Items.Add;
          LItem.Caption := SearchRec.name;
          LItem.SubItems.Add(FormatFileSize(SearchRec.Size));
          LItem.SubItems.Add(SHFileInfo.szTypeName);
          LItem.SubItems.Add(FormatAttr(SearchRec.Attr));

          Icon.Handle := SHFileInfo.hIcon;
          LItem.ImageIndex := FrmMain.ilLvFileMan.AddIcon(Icon);

        End;
      Until FindNext(SearchRec) <> 0;
      If NodeList.Count <> 0 Then
      Begin
        For nCount := 0 To NodeList.Count - 1 Do
        Begin
          TmpN := GetNodeByText(FrmMain.TvFileMan, NodeList.Strings[nCount], True);
          TmpN.Delete;
        End;
      End;
    End;
  Finally
    FrmMain.TvFileMan.Items.EndUpdate;
    FrmMain.LvFileMan.Items.EndUpdate;
    NodeList.Free;
    Icon.Free;
  End;
End;

Procedure TFrmMain.TvFileManClick(Sender: TObject);
Const
  OnNode            = TVHT_ONITEMICON Or TVHT_ONITEMLABEL;
Var
  HTInfo            : TTVHitTestInfo;
  Node              : TTreeNode;
Begin
  Node := Nil;
  GetCursorPos(HTInfo.pt);
  HTInfo.pt := ScreenToClient(HTInfo.pt);
  If TreeView_HitTest(TvFileMan.Handle, HTInfo) <> Nil Then
  Begin
    If Bool(HTInfo.Flags And OnNode) Then
      Node := TvFileMan.Items.GetNode(HTInfo.hItem);
    If Node <> Nil Then
    Begin
      ListFolders(TracePath(TvFileMan.Selected, TvFileMan.Selected.Text));
    End;
  End;
End;

End.

