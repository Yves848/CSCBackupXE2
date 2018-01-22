unit backupUtils;

interface

uses
  System.IOUtils, System.sysutils, System.Classes, System.DateUtils, System.regularexpressions,
  Winapi.Windows, PhToolsStr,  Dialogs,uEncryption,
  Winapi.Messages,  uRecords, ulog;

const
  // General use constants ......

  LUSFile = 'C:\ProgramData\Corilus\UpdateServices\Data\LUS\GKP.info';
  LogDir = 'Logs\';
  TempDir = 'Temp\';

  {$IFDEF DEBUG}
    LogUploadUrl = 'http://localhost:8080/Dash/SaveLog.php';
  {$ELSE}
    LogUploadUrl = 'http://backup.sherpagreenock.be/SaveLog.php';
  {$ENDIF}
  GOAPBCmd = '@"C:\Program Files\Corilus\Greenock\GreenockMaintenanceDB.exe" /APB > "%sAPB.TXT"';
  GreenockMaintenance = 'GOAPB.cmd';
  eMailRegEx = '^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$';

  aMailTriggers: array [0 .. 2] of String = ('Always', 'If Warnings', 'If Failed');

  // Windows Messages constants ......

  TH_MESSAGE = WM_USER + 1;

  TH_FINISHED = 1;
  TH_NEWFILE = 2;
  TH_ERROR = 3;
  TH_LOG = 4;
  TH_SAVELOG = 5;
  TH_XMLLOAD = 6;
  TH_HINT = 7;
  TH_SENDMAIL = 8;

  // Process Priority constants .......

  BELOW_NORMAL_PRIORITY_CLASS = $00004000;
  ABOVE_NORMAL_PRIORITY_CLASS = $00008000;

  LOW_PRIORITY = IDLE_PRIORITY_CLASS;
  BELOW_NORMAL_PRIORITY = BELOW_NORMAL_PRIORITY_CLASS;
  NORMAL_PRIORITY = NORMAL_PRIORITY_CLASS;
  ABOVE_NORMAL_PRIORITY = ABOVE_NORMAL_PRIORITY_CLASS;
  HIGH_PRIORITY = HIGH_PRIORITY_CLASS;
  REALTIME_PRIORITY = REALTIME_PRIORITY_CLASS;

  aPriority: array [0 .. 5] of cardinal = (LOW_PRIORITY, BELOW_NORMAL_PRIORITY, NORMAL_PRIORITY, ABOVE_NORMAL_PRIORITY, HIGH_PRIORITY,
    REALTIME_PRIORITY);

type
  tBackupResult = (brSuccess, brWarnings, brError);



Function MakeTarName(bVersion: Boolean = False; APB: String = '999999'; Version: String = '000'; Patch: String = '000'): String;
Function GetFileProperties(sFileName: String): pBackupFileProperties;
Function GetFileSize(sFichier: String): Integer;
function FileSizeStr(filename: string): string;
Function GetGOProperties: pGreenockProperties;
procedure ExtractResource(const SaveToPath, resname, filename: String);
Procedure ExtractDependencies;
Procedure CheckEnvironment;
Procedure ApplyRotation(sPath: String; iMaxFiles: Integer = 3; iNBJours: Integer = 7);
Procedure CreateAPBCmd;
Function GetDiskInfo(sTarget: String): pDiskInfos;
function StrInArray(const Value: String; const ArrayOfString: Array of String): Integer;
function ListFile(masque: String; lList: tStrings; var pUncompSize: cardinal): Boolean;
function CreateFileEntry(pPath: String; bRecursive: Boolean = True): tFileEntryRecord;
Function _CopyFile(FileSource, FileDest: String; bFailIfExists: Boolean = True): Integer;
function AntiSlash2Slash(_str: String): String;
function Slash2AntiSlash(_str: String): String;
procedure __CopyFile(FileSource, FileDest: string; Taille: LongInt);
function SizeStr(iSize: cardinal): string;

var
  bOverrideParams: Boolean;
  bExtract: Boolean;
  bFirstRun: Boolean;
  bAuto: Boolean;
  bSilent: Boolean;
  bMakeExe : Boolean;
  xVisible, xPopUps, xGenLogs: Boolean;
  iParam: Integer;
  sConfig: String;
  sZipFile : String;
  AppName: String;
  sCaption: String;
  cPriority: Integer;

implementation

uses
  uFileChoose;

Function GetDiskInfo(sTarget: String): pDiskInfos;
var
  aDiskInfos: pDiskInfos;
  FreeAvailable, TotalSpace: Int64;
begin
  New(aDiskInfos);
  if GetDiskFreeSpaceEx(PChar(sTarget), FreeAvailable, TotalSpace, nil) then
  begin
    aDiskInfos.iAvailable := FreeAvailable;
    aDiskInfos.iTotal := TotalSpace;
  end;
  result := aDiskInfos;
end;

Procedure CreateAPBCmd;
var
  f: TextFile;

begin
  if (fileexists(Addslash(ExtractFileDir(PAramstr(0))) + GreenockMaintenance)) then
    Deletefile(PChar(Addslash(ExtractFileDir(PAramstr(0))) + GreenockMaintenance));

  AssignFile(f, Addslash(ExtractFileDir(PAramstr(0))) + GreenockMaintenance);
  Rewrite(f);
  Writeln(f, format(GOAPBCmd, [Addslash(ExtractFileDir(PAramstr(0)))]));
  writeln(f, 'pause');
  close(f);
end;

Function GetGOProperties: pGreenockProperties;
var
  GOProperties: pGreenockProperties;
  lInfos: tStrings;
  sVersion: String;
begin
  aLog.Send('GetGOProperties');
  New(GOProperties);
  lInfos := tStringList.Create;
  aLog.Send(LUSFile);

  lInfos.LoadFromFile(LUSFile);
  sVersion := lInfos[lInfos.Count - 1];
  lInfos.Clear;
  lInfos.Free;
  lInfos := SplitString(sVersion, '_');
  if (lInfos.Count = 2) then
  begin
    GOProperties.VersionNr := lInfos[1];
    GOProperties.PatchNR := 'NONE';
  end
  else
  begin
    GOProperties.VersionNr := lInfos[1];
    GOProperties.PatchNR := lInfos[2];
  end;
  result := GOProperties;
end;

Procedure ApplyRotation(sPath: String; iMaxFiles: Integer = 3; iNBJours: Integer = 7);
var
  lFiles: tStrings;
  SR: TSearchRec;
  iFound: Integer;
  sFileName: String;
  sDate: String;
  i: Integer;
  BackupFileProperties: pBackupFileProperties;
  DefaultDir, MainLogDir: String;
  LogFileName: String;
begin
  lFiles := tStringList.Create;
  iFound := FindFirst(Addslash(sPath) + '*.cor', faAnyFile, SR);
  DefaultDir := Addslash(ExtractFileDir(PAramstr(0)));
  MainLogDir := Addslash(DefaultDir + LogDir);

  while iFound = 0 do
  begin
    lFiles.Add(Addslash(sPath) + SR.Name);
    iFound := FindNext(SR);
  end;
  System.sysutils.FindClose(SR);

  while lFiles.Count > iMaxFiles do
  begin
    LogFileName := tPath.GetFileNameWithoutExtension(lFiles[0]);
    //LogFileName := tPath.GetFileNameWithoutExtension(LogFileName);
    if fileexists(MainLogDir + LogFileName + '.log') then
      Deletefile(PChar(MainLogDir + LogFileName + '.log'));

    Deletefile(PChar(lFiles[0]));
    lFiles.Delete(0);
  end;

  if lFiles.Count > 1 then
  begin
    i := 1;
    while i <= lFiles.Count - 1 do
    begin
      BackupFileProperties := GetFileProperties(lFiles[i]);
      if DaysBetween(BackupFileProperties.fileDateTime, now) > iNBJours then
      begin
        Deletefile(PChar(lFiles[i]));
      end;
      inc(i);
    end;
  end;

  lFiles.Free;
end;

Function GetFileProperties(sFileName: String): pBackupFileProperties;
var
  aBackupFileProperties: pBackupFileProperties;
  SR: TSearchRec;
  iFound: Integer;
  sPath: String;
  lSplit: tStrings;
  sDate: String;
  sFile: String;
begin
  New(aBackupFileProperties);
  aBackupFileProperties.bFileExist := False;
  if fileexists(sFileName) then
  begin
    iFound := FindFirst(sFileName, faAnyFile, SR);
    if iFound = 0 then
    begin
      aBackupFileProperties.bFileExist := True;
      sFile := tPath.GetFileNameWithoutExtension(sFileName);
      //sFile := tPath.GetFileNameWithoutExtension(sFile);
      lSplit := SplitString(sFile, '_');
      if lSplit.Count > 1 then
      begin
        aBackupFileProperties.APBNr := lSplit[2];
        aBackupFileProperties.VersionNr := lSplit[1];
        sDate := Copy(lSplit[0], 1, 14);
        aBackupFileProperties.NameDateTime := EncodeDateTime(StrToInt(Copy(sDate, 1, 4)), StrToInt(Copy(sDate, 5, 2)), StrToInt(Copy(sDate, 7, 2)),
          StrToInt(Copy(sDate, 9, 2)), StrToInt(Copy(sDate, 11, 2)), 0, 0);
      end
      else
      begin
        sDate := Copy(sFile, 1, 14);
        aBackupFileProperties.NameDateTime := EncodeDateTime(StrToInt(Copy(sDate, 1, 4)), StrToInt(Copy(sDate, 5, 2)), StrToInt(Copy(sDate, 7, 2)),
          StrToInt(Copy(sDate, 9, 2)), StrToInt(Copy(sDate, 11, 2)), 0, 0);
      end;
      aBackupFileProperties.fileDateTime := SR.TimeStamp;
    end;
    System.sysutils.FindClose(SR);
  end;
  result := aBackupFileProperties;
end;

Function MakeTarName(bVersion: Boolean = False; APB: String = '999999'; Version: String = '000'; Patch: String = '000'): String;
(*
  MakeTarName

  Create the archive filename.

  Parameters :

  - bVersion : Boolean
  If True, add the Greenock version and patch number and the APB number. (Default Value = False)
  - APB      : String
  APB Number of the pharmacy. (Default Value = '999999')
  - Version  : String
  Version Number of the Greenock Database. (Default Value = '000')
  - Patch    : String
  Patch Number of the Greenock Database. (Default Value = '000')

  Returns :
  A String containing the filename.

*)
var
  fName: String;
  sDate: String;
begin
  sDate := FormatDateTime('YYYYMMDDHHNNSS', now);
  if bVersion then
    fName := format('%s_%s%s_%s', [sDate, Version, Patch, APB])
  else
    fName := format('%s', [sDate]);

  result := fName + '.zip';
end;

Function GetFileSize(sFichier: String): Integer;
var
  size: Int64;
  handle: Integer;
begin
  result := -1;
  handle := FileOpen(sFichier, fmOpenRead);
  if handle = -1 then
    result := -1
  else
    try
      size := FileSeek(handle, Int64(0), 2);
      result := size;
    finally
      FileClose(handle);
    end;
end;

function FileSizeStr(filename: string): string;
const
  K = Int64(1024);
  M = K * K;
  G = K * M;
  T = K * G;
var
  size: Int64;
  handle: Integer;
begin
  handle := FileOpen(filename, fmOpenRead);
  if handle = -1 then
    result := 'Unable to open file ' + filename
  else
    try
      size := FileSeek(handle, Int64(0), 2);
      if size < K then
        result := format('%d bytes', [size])
      else if size < M then
        result := format('%f KB', [size / K])
      else if size < G then
        result := format('%f MB', [size / M])
      else if size < T then
        result := format('%f GB', [size / G])
      else
        result := format('%f TB', [size / T]);
    finally
      FileClose(handle);
    end;
end;

function SizeStr(iSize: cardinal): string;
const
  K = Int64(1024);
  M = K * K;
  G = K * M;
  T = K * G;
begin

  if iSize < K then
    result := format('%d bytes', [iSize])
  else if iSize < M then
    result := format('%f KB', [iSize / K])
  else if iSize < G then
    result := format('%f MB', [iSize / M])
  else if iSize < T then
    result := format('%f GB', [iSize / G])
  else
    result := format('%f TB', [iSize / T]);

end;

procedure ExtractResource(const SaveToPath, resname, filename: String);
var
  rs: TResourceStream;
  fs: TFileStream;
begin
  rs := TResourceStream.Create(hInstance, resname, RT_RCDATA);
  try
    fs := TFileStream.Create(filename, fmCreate);
    try
      fs.CopyFrom(rs, 0);
    finally
      fs.Free;
    end;
  finally
    rs.Free;
  end;
end;

Procedure CheckEnvironment;
var
  DefaultDir: String;
  MainLogDir: String;
begin
  DefaultDir := Addslash(ExtractFileDir(PAramstr(0)));
  MainLogDir := Addslash(DefaultDir + LogDir);
  if not DirectoryExists(MainLogDir) then
  begin
    ForceDirectories(MainLogDir);
  end;

  if Not DirectoryExists(DefaultDir + TempDir) then
  begin
    ForceDirectories(DefaultDir + TempDir);
  end;
end;

Procedure ExtractDependencies;
var
  DefaultDir: String;
  MainLogDir: String;
  aLogRecord: pLogRecord;
begin
  (*
    Test if Cygwin1.dll and gzip.Exe  already exists.
    If Not, extract them from resources.

    Check and create, if needed, the log directory
  *)
  //Log(3,
  New(aLogRecord);
  aLogRecord.sMessage := 'Checking Dependencies';
  aLogRecord.dDate := now;
  PostMessage(fCSCBackupXE.handle, TH_MESSAGE, TH_LOG, Integer(aLogRecord));

  DefaultDir := Addslash(ExtractFileDir(PAramstr(0)));
  MainLogDir := Addslash(DefaultDir + LogDir);
  if not fileexists(DefaultDir + 'cygbz2-1.dll') or not fileexists(DefaultDir + 'cygwin1.dll') or not fileexists(DefaultDir + 'unzip.exe') then
  begin
     ExtractResource(DefaultDir, 'unzip', DefaultDir + 'unzip.zip');
  end;


  if not DirectoryExists(MainLogDir) then
  begin
    ForceDirectories(MainLogDir);
  end;

  if Not DirectoryExists(DefaultDir + TempDir) then
  begin
    ForceDirectories(DefaultDir + TempDir);
  end;
end;



function StrInArray(const Value: String; const ArrayOfString: Array of String): Integer;
var
  Loop: String;
  i: Integer;
begin
  i := 0;
  result := -1;
  for Loop in ArrayOfString do
  begin
    if Value = Loop then
    begin
      result := i;
      Exit;
    end;
    inc(i);
  end;

end;

function ListFile(masque: String; lList: tStrings; var pUncompSize: cardinal): Boolean;
var
  i: Integer;
  _temp: Integer;
  found: Integer;
  SR: TSearchRec;
  _Fsize: Int64;
  SecAtrrs: TSecurityAttributes;
  sName: string;
begin
  found := FindFirst(masque, faAnyFile, SR);
  result := (found = 0);
  While found = 0 do
  begin

    if ((SR.attr = faDirectory) or (DirectoryExists(extractFilePAth(masque) + SR.Name))) then
    begin
      if (SR.Name <> '.') and (SR.Name <> '..') then
        ListFile(extractFilePAth(masque) + SR.Name + '\*.*', lList, pUncompSize);
    end
    else
    begin
      if (SR.Name <> '.') and (SR.Name <> '..') and (pos('.LCK', uppercase(SR.Name)) = 0) then
      begin
        FillChar(SecAtrrs, SizeOf(SecAtrrs), #0);
        SecAtrrs.nLength := SizeOf(SecAtrrs);
        SecAtrrs.lpSecurityDescriptor := nil;
        SecAtrrs.bInheritHandle := True;
        if lList.IndexOf(extractFilePAth(masque) + SR.Name) = -1 then
        begin
          sName := extractFilePAth(masque) + SR.Name;
          pUncompSize := pUncompSize + GetFileSize(sName);
          lList.Add(sName);
        end;
      end;
    end;
    found := FindNext(SR);
  end;
  System.sysutils.FindClose(SR);
end;

function CreateFileEntry(pPath: String; bRecursive: Boolean = True): tFileEntryRecord;
var
  aFileEntryRecord: tFileEntryRecord;
  bExists: Boolean;
begin
  // Test if it's a file .....
  aFileEntryRecord := tFileEntryRecord.Create;
  bExists := False;
  result := Nil;
  if fileexists(pPath) then
  begin
    bExists := True;
    aFileEntryRecord.bIsFile := True;
    aFileEntryRecord.iFileSize := GetFileSize(pPath);
  end;

  if DirectoryExists(Addslash(pPath)) then
  begin
    bExists := True;
    aFileEntryRecord.bIsFile := False;
    aFileEntryRecord.bRecurs := bRecursive;
  end;

  aFileEntryRecord.sFullName := ExpandFileName(pPath);
  aFileEntryRecord.sShortName := ExtractShortPathName(pPath);
  result := aFileEntryRecord;
end;

function AntiSlash2Slash(_str: String): String;
var
  i: Integer;
begin
  i := 1;
  While i <= length(_str) do
  begin
    if _str[i] = '\' then
      _str[i] := '/';
    inc(i);
  end;
  result := _str;
end;

function Slash2AntiSlash(_str: String): String;
var
  i: Integer;
begin
  i := 1;
  While i <= length(_str) do
  begin
    if _str[i] = '/' then
      _str[i] := '\';
    inc(i);
  end;
  result := _str;
end;

procedure __CopyFile(FileSource, FileDest: string; Taille: LongInt);
var
  FromF, ToF: file;
  NumRead, NumWritten: Integer;
  Buf: array [1 .. 2048] of Char;
  TotLus: LongInt;
  _Pourc: Integer;
begin
  TotLus := 0;
  FileMode := 0;
  AssignFile(FromF, FileSource);
  Reset(FromF, 1);
  if Taille <= 0 then
    Taille := 1; // pour éviter la division par zéro.....
  AssignFile(ToF, FileDest); { Ouverture du fichier de sortie }
  Rewrite(ToF, 1); { Taille d'enregistrement = 1 }
  repeat
    // Application.ProcessMessages;
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
    TotLus := TotLus + NumRead;
    _Pourc := round(TotLus / Taille * 100); // Eventuellement à utiliser avec une Progress bar ou avec un callback
  until (NumRead = 0) or (NumWritten <> NumRead);
  closefile(FromF);
  closefile(ToF);
  FileMode := 2;
end;

Function _CopyFile(FileSource, FileDest: String; bFailIfExists: Boolean = True): Integer;
var
  iSize: Integer;
begin
  result := 0;
  if bFailIfExists then
  begin
    if fileexists(FileDest) then
      result := -2;
  end
  else
  begin
    if fileexists(FileDest) then
      Deletefile(PChar(FileDest));
  end;

  if result = 0 then
  begin
    iSize := GetFileSize(FileSource);
    __CopyFile(FileSource, FileDest, iSize);
  end;

end;

end.
