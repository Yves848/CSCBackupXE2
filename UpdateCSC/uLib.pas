unit uLib;

interface

Uses
  System.Classes, System.JSON, Sysutils, Winapi.Windows,uRecords, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

Type
  tLogUpLoad = class(tObject)
  private
     IdHTTP1 : tIdHTTP;
    public
       url : String;
       JSONString : String;
       constructor create;
       function upload(sJSON : String) : String;
  end;

  tlogObj = class(tObject)
    public
       time_stamp : tdatetime;
       description : string;
  end;

  tUpdObj = class(tObject)
  public
      date_time : tdatetime;
      apb : string;
      updversion : string;
      cscversion_before : string;
      cscversion_after : string;
      iresult : integer;
      log : tStrings;
      constructor create;
      procedure AddLog(sdesc : string);
      Function toJSON : String;
  end;

  tBackuplog_Detail = class(tobject)
    public
       date_time : tDateTime;
       Type_Ligne : Integer;
       description : string;
       Constructor create;
  end;

  tBackupLog = class(tObject)
    private
       iresult_sum : Integer;
    public
       Pharmacie : String;
       APB : String;
       GO_Version : String;
       GO_Patch : String;
       CSC_Version : String;
       DT_Start : tDateTime;
       DT_Stop : tDateTime;
       iResult : Integer;
       Detail : TStrings;
       constructor create;
       destructor free;
       procedure Add(iType : Integer; dDate : tDateTime; sDescription : String);
       Function toJSON : String;
  end;

  tSet = class(tObject)
    aConfigMail: pConfigMailRecord;
    lMailRules: tStrings;
    lEntries : tStrings;
    destination : string;
    aRotation : pRotationRecord;
  end;

const
  CmdLine = 'C:\corilus_backup\CSCBackupXE.exe /config="C:\corilus_backup\%s.set" /auto';
  OPSWBackupCmd = 'opswbackup.exe';
  CSCBackupXECmd = 'CSCBackupXE.exe';

  SQLiteDateFormat = 'yyyy-mm-dd'; // 'YYYY-MM-DD';
  SQLiteTimeFormat = 'hh:nn:ss.zzz'; // 'HH:MM:SS.SSS';
  SQLiteDateTimeFormat = 'yyyy-mm-dd hh:nn:ss.zzz'; // 'YYYY-MM-DD HH:MM:SS.SSS';

var
  OPSWBackupPath: String = 'C:\corilus_backup\';
  OPSWBackupPathOld: String = 'C:\corilus_backup_Old\';
  TempPath : String = 'temp';
  UndoPath : String = 'Undo';
  FTP_Site  : String = 'ftp.sherpagreenock.be';
  FTP_User  : String = 'sherpagr-log';
  FTP_Pswd  : String = 'sh3rpaLog';
  bDebug    : Boolean = False;
  LogLevel  : Integer = 0;

procedure ExtractResource(const SaveToPath, resname, filename: String);

implementation

Function tBackupLog.toJSON : String;
var
  LJSONObject: TJSONObject;
  JSONLogObject : TJSONObject;
  JSONLogArray : TJSONArray;
  i : integer;
begin
      LJSONObject := TJSONObject.Create;
      LJSONObject.AddPair('APB',apb);
      LJSONObject.AddPair('GO_VERSION',GO_Version);
      LJSONObject.AddPair('GO_PATCH',GO_Patch);
      LJSONObject.AddPair('CSC_VERSION',CSC_Version);
      LJSONObject.AddPair('DT_START',formatdatetime(SQLiteDateTimeFormat,DT_Start));
      LJSONObject.AddPair('DT_STOP',formatdatetime(SQLiteDateTimeFormat,DT_Stop));
      if iresult_sum = 0 then
         LJSONObject.AddPair('result',TJSONNumber.Create(0))
      else
         LJSONObject.AddPair('result',TJSONNumber.Create(1));

      JSONLogArray := TJSONArray.Create;
      i := 0;
      while i <= Detail.Count -1 do
      begin
        JSONLogObject := TJSONObject.Create;
        JSONLogObject.AddPair('Timestamp',Formatdatetime(SQLiteTimeFormat,tBackuplog_Detail(Detail.Objects[i]).date_time));
        JSONLogObject.AddPair('Type_Ligne',TJSONNumber.Create((tBackuplog_Detail(Detail.Objects[i]).Type_Ligne)));
        JSONLogObject.AddPair('Description',tBackuplog_Detail(Detail.Objects[i]).description);
        JSONLogArray.Add(JSONLogObject);
        inc(i);
      end;

      LJSONObject.AddPair('Log',JSONLogArray);
      result := LJSONObject.ToJSON;
end;

Procedure tBackupLog.Add(iType : Integer; dDate : tDateTime; sDescription : String);
var
   pBackuplog_Detail : tBackuplog_Detail;
begin
    pBackuplog_Detail := tBackuplog_Detail.create;
    pBackuplog_Detail.date_time := dDate;
    pBackuplog_Detail.Type_Ligne := iType;
    pBackuplog_Detail.description := sDescription;
    iresult_sum := iresult_sum + iType;
    Detail.AddObject('',pBackuplog_Detail);
end;

constructor tBackupLog.create;
begin
     inherited create;
     Detail := tStringList.Create;
     iresult_sum := 0;
end;

destructor tBackupLog.free;
begin
     FreeAndNil(Detail);
     inherited free;
end;

Constructor tBackuplog_Detail.create;
begin
     inherited create;
end;

constructor tLogUpLoad.create;
begin
    IdHTTP1 := tIdHTTP.Create(Nil);
end;

function tLogUpLoad.upload(sJSON : String) : String;
var
   JsonToSend: TStringStream;
   response : String;
begin
   JsonToSend := TStringStream.Create(sJSON, TEncoding.UTF8);
   IdHTTP1.Request.ContentType := 'application/json';
   //IdHTTP1.ProxyParams.ProxyServer := '127.0.0.1';
   //IdHTTP1.ProxyParams.ProxyPort := 8888;
   //IdHTTP1.Request.CharSet := 'utf-8';
   response := IdHTTP1.Post(url,JsonToSend);
   result := response;
end;

constructor tUpdObj.create;
begin
  cscversion_before := 'None';
  cscversion_after := 'None';
  log := tStringList.Create;
end;

function tUpdObj.toJSON;
var
  LJSONObject: TJSONObject;
  JSONLogObject : TJSONObject;
  JSONLogArray : TJSONArray;
  i : integer;
begin
  LJSONObject := TJSONObject.Create;
  LJSONObject.AddPair('date_time',formatdatetime(SQLiteDateTimeFormat,date_time));
  LJSONObject.AddPair('apb',apb);
  LJSONObject.AddPair('updversion',updversion);
  LJSONObject.AddPair('cscversion_before',cscversion_before);
  LJSONObject.AddPair('cscversion_after',cscversion_after);
  LJSONObject.AddPair('result',TJSONNumber.Create(iresult));

  JSONLogArray := TJSONArray.Create;
  i := 0;
  while i <= log.Count -1 do
  begin
     JSONLogObject := TJSONObject.Create;
     JSONLogObject.AddPair('Timestamp',Formatdatetime(SQLiteTimeFormat,tlogObj(Log.Objects[i]).time_stamp));
     JSONLogObject.AddPair('Description',tlogObj(Log.Objects[i]).description);
     JSONLogArray.Add(JSONLogObject);
     inc(i);
  end;
  LJSONObject.AddPair('Log',JSONLogArray);
  result := LJSONObject.ToJSON;
end;

procedure tUpdObj.AddLog(sdesc : string);
var
   pLogObj : tlogObj;
begin
   pLogObj := tlogObj.Create;
   pLogObj.time_stamp := Now;
   pLogObj.description := sdesc;
   log.AddObject('',pLogObj);
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

end.
