unit uRecords;

interface

Uses
  System.Classes;

Type
  pXMLRecord = ^tXMLRecord;
  tXMLRecord = record

  end;

  pBackupRecord = ^tBackupRecord;

  tBackupRecord = record
    lFiles: tStrings;
    sDestinationDir: String;
    sTarName: String;
    sTempDir: String;
  end;

  pBackupSummaryRecord = ^tBackupSummaryRecord;

  tBackupSummaryRecord = record
    iWarnings: Integer;
    iErrors: Integer end;

    tFileEntryRecord = class(tObject)
    bIsFile: Boolean;
    sFullName: String;
    sShortName: String;
    iFileSize: cardinal;
    bRecurs: Boolean;
    bExclude: Boolean;
  end;

  pMailRecord = ^tMailRecord;

  tMailRecord = record
    aBackupSummary: Integer;
    bVersion: Boolean;
    ABPNr: String;
    VersionNr: String;
    PatchNR: String;
  end;

  pBalloonHintRecord = ^tBalloonHintRecord;

  tBalloonHintRecord = record
    sTitle: String;
    sMessage: String;
  end;

  pNewFileRecord = ^tNewFileRecord;

  tNewFileRecord = record
    sFileName: String;
    iFileSize: Integer;
    iIndexFile: Integer;
  end;

  pErrorRecord = ^tErrorRecord;

  tErrorRecord = record
    dDate: tDateTime;
    sMessage: String;
  end;

  pLogRecord = ^tLogRecord;

  tLogRecord = record
    sMessage: String;
    dDate: tDateTime;
  end;

  pSaveLogRecord = ^tSaveLogRecord;

  tSaveLogRecord = record
    sLogName: String;
  end;

  pXMLLoaded = ^tXMLLoaded;

  tXMLLoaded = record
    sXMLName: String;
  end;

  pBackupFileProperties = ^tRecordFileProperties;

  tRecordFileProperties = record
    bFileExist: Boolean;
    APBNr: String;
    VersionNr: String;
    fileDateTime: tDateTime;
    NameDateTime: tDateTime;
    fileSize: cardinal;
  end;

  pGreenockProperties = ^tGreenockProperties;

  tGreenockProperties = record
    ABPNr: String;
    VersionNr: String;
    PatchNR: String;
  end;

  pDiskInfos = ^tDiskInfos;

  tDiskInfos = record
    iAvailable: Int64;
    iTotal: Int64;
  end;

  pConfigMailRecord = ^tConfigMailRecord;

  tConfigMailRecord = Record
    User: String;
    Pass: String; // Use decryption.
    SMTP: String;
    From: String;
  End;



  tMailRuleRecord = class(tObject)
    sTo: String;
    When: String;
  End;

  pRotationRecord = ^tRotationRecord;

  tRotationRecord = Record
    NbMax: Integer;
    AgeMax: Integer;
  End;

  pOptionsRecord = ^tOptionRecord;

  tOptionRecord = Record

  End;

implementation

end.
