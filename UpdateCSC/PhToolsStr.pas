unit PhToolsStr;

interface

Uses
  SysUtils, Classes, Windows{, IdHashMessageDigest, idHash};

  Function testdate(Jour,Mois,annee: string) : boolean;
  Function DoubleQuote(Chaine : String) : String;
  Function Padl(Src : String; PadC : String; Long : Integer) : String;
  Function PadR(Src : String; PadC : String; Long : Integer) : String;
  Function Padc(Chaine,Remplissage : String; Longueur : Integer) : String;
  Function Replicate(Caractere : String; Longueur : Integer) : String;
  Function rPos(_substring,_String : String) : Integer;
  Function nPos(_substring,_String : String; occurs : Integer) : Integer;
  Procedure Replace(Source : String;Var Dest : String; Index,Count : Word);
  Function IIf(Expr : Boolean; Reslt1, Reslt2 : Variant) : Variant;
  Function ValidNumber(var sNumber : String): Boolean;
  Function AddSlash(Chaine : String) : String;
  Function changehint(chaine : string) : string;
  Function Dateddmmyyy(chaine : Tdatetime) : string;
  Function texteversclephonetique(origine : string) : string;
  Function EstVide(Liste : TstringList) : Boolean;
  Function SplitString(Chaine, sep : String) : TStringlist;
  function ReplaceStr(s, OldSubStr, NewSubStr: string): string;
  function IsNumeric(s: string): Boolean;
  function GetCharFromVirtualKey(Key: Word): string;
  function verifncompte(chaine : string) : boolean;
  function formatntel(chaine : string) : string;
  function ReduceStr(sStr: string; iLength: integer): string;
  function RemoveSuperfluousBlanks(const S: string): string;
  procedure FileReplaceString(const FileName, searchstring, replacestring: string);
  function StringReplace(const S, OldPattern, NewPattern: string; IgnoreCase: Boolean): string;
  function StrToFloatDef(const S: string; Default: Extended): Extended; // <HA3814>
  function EncryptStr(const s,key: string): string; // <HA4013>
  function ConvUTF8(sIn: string): string; // <HA12712>
  function DeleteSpaces(Str: string): string;
  function StrKeepChars(sIn: string; aChars: TSysCharSet): string; // <HA15744>
  function RemoveNonAlfaNumeric(sIn: string): string;  // <HA15744>
  function GetMD5(const value : string) : string; // <HA17622>
  function GetMD5file(const fileName : string) : string;  // <HA17622>
  Function BoolToString(bValue : Boolean) : String;
implementation

uses
  phmath;

Function BoolToString(bValue : Boolean) : String;
begin
    result := IIF(bValue,'True','False');
end;

// vdv le 4/4/2001 début clé phonétique
Function  texteversclephonetique(origine : string) : string;
var ind,ind2 : integer;
    valeur   : char;
    const assimil : array [1..3,1..2] of char = (('D','T'),('F','S'),('B','P'));
begin
     // supprimer les caractères accentués.
     origine := uppercase(origine);
     // supprimer les caratères <> de A à Z
     ind := 1;
     while ind < length(origine) do begin
           valeur := origine[ind];
           if not (valeur in ['A'..'Z']) then begin
              delete(origine,ind,1);
              dec(ind);
           end;
           inc(ind);
     end;
     // supprimer les doubles
     ind := 1;
     while ind < length(origine) do begin
           if copy(origine,ind,1) = copy(origine,ind+1,1) then begin
              delete(origine,ind,1);
           end;
           for ind2 := 1 to 3 do begin
               if origine[ind] = assimil[ind2,1] then
                  origine[ind] := assimil[ind2,2];
           end;
           inc(ind);
     end;
     result := origine;
end;
// vdv le 4/4/2001 fin clé phonétique


Function  Dateddmmyyy(chaine : Tdatetime) : string;
begin
     if chaine <> 0 then
        result := formatdatetime('ddmmyyyy',chaine)
     else
        result := '00000000';
end;

Function  testdate(Jour,Mois,annee: string) : boolean;
begin
     result := true;
     if (strtointdef(jour,-1)<1)or(strtointdef(jour,-1)>31) then
        result := false;
     if (strtointdef(Mois,-1)<1)or(strtointdef(Mois,-1)>12) then
        result := false;
     if (strtointdef(Annee,-1)<1900)or(strtointdef(Annee,-1)>2100) then
        result := false;
end;
Function  DoubleQuote(Chaine : String) : String;
var
   i : Integer;
begin
     i := 1;
     Result := '';
     While i <= length(Chaine) do begin
        Result := result + Chaine[i];
        if Chaine[i] = #39 then Result := Result + #39;
        inc(i);
     end;
end;

Function Padl(Src : String; PadC : String; Long : Integer) : String;
{*********************************************************************************
 * Cadrage à Droite (remplissage à GAUCHE).
 *
 * Auteur          : YG pour AB2M
 * Dernière Modif  : 24/04/1997
 * Paramètres      : - Src  : Chaine à complèter.
 *                   - PadC : Chaine de remplissage (le plus souvent un caractère 0 ou " ").
 *                   - Long : Longueur que doit avoir la chaine de retour.
 *
 * Retour          : Une chaine Cadrée à droite;
 ***********************************************************************************
}
Var
   sTmpStr  : String;
   iLTmpStr : Integer;
   f        : Integer;
Begin
   src:= trim(Src);
   sTmpStr := '';
   For F := 1 to Long do sTmpStr := sTmpStr + PadC;
   sTmpStr  := sTmpStr + Src;
   iLTmpStr := Length(sTmpStr);
   Result   := Copy(sTmpStr,(iLTmpStr-Long)+1,Long);
end;

Function PadR(Src : String; PadC : String; Long : Integer) : String;
{***************************************************************************
 * Cadrage à Gauche (remplissage à DROITE).
 *
 * Auteur          : YG pour AB2M
 * Dernière Modif  : 24/04/1997
 * Paramètres      : - Src  : Chaine à complèter.
 *                   - PadC : Chaine de remplissage (le plus souvent un caractère 0 ou " ").
 *                   - Long : Longueur que doit avoir la chaine de retour.
 *
 * Retour          : Une chaine Cadrée à Gauche;
 ****************************************************************************
}
Var
   sTmpStr  : String;

   f        : Integer;
Begin
   Src := trim(Src);
   sTmpStr := '';
   For F := 1 to Long do sTmpStr := sTmpStr + PadC;
   sTmpStr  := Src+sTmpStr;
   Result   := Copy(sTmpStr,1,Long);
end;


Function Padc(Chaine,Remplissage : String; Longueur : Integer) : String;
Begin
     Chaine := Trim(Chaine);
     if Length(Chaine) < Longueur then begin
        Result := replicate(Remplissage,(Longueur-Length(Chaine)) div 2 )+Chaine;
        Result := Result +  Replicate(Remplissage,Longueur-length(Result));
     end
     else Result := Chaine;
end;

Function Replicate(Caractere : String; Longueur : Integer) : String;
var
   f : Integer;
Begin
     Result := '';
     For f := 1 to Longueur do Result := Result + Caractere;
end;

Function rPos(_substring,_String : String) : Integer;
var
   i      : Integer;
   iStart,
   iLen   : Integer;
begin
     REsult := 0;
     if Length(_String) >= Length(_subString) then begin
        iLen   := Length(_SubString);
        i      := Length(_String)-iLen;
        While i > 0 do begin
           istart := i;
           if Copy(_string,iStart,iLen) = _Substring then begin
              I := 0;
              Result := iStart;
           end;
           Dec(i);
        end;
     end;
end;

Function nPos(_substring,_String : String; occurs : Integer) : Integer;
var
   i      : Integer;
   iStart,
   iLen   : Integer;
   iCount : Integer;
begin
{
 Renvoie la position de la Nème occurence de la chaine recherchée dans la
 chaine source. (EN PARTANT DE LA DROITE).
}
     iCount := 0;
     REsult := 0;
     if Length(_String) >= Length(_subString) then begin
        iLen   := Length(_SubString);
        i      := Length(_String)-iLen;
        While i > 0 do begin
           istart := i;
           if Copy(_string,iStart,iLen) = _Substring then begin
              if iCount < occurs then begin
                 inc(iCount);
              end
              else begin
                 I := 0;
                 Result := iStart;
              end;

           end;
           Dec(i);
        end;
     end;
end;

Procedure Replace(Source : String; var Dest : String; Index,Count : Word);
begin
   Delete(Dest,Index,Count);
   Insert(Source,Dest,Index);
end;

{*******************************************************************************
 * IIF                                                                         .
 *                                                                             .
 *      Evalue l'expression EXPR et renvoie                                    .
 *                          Reslt1 si le résultat est TRUE                     .
 *                          Reslt2 si le résultat est False                    .
 *                                                                             .
 *      Resultat := IIF(...,...,...) remplace avantageusement un bloc de code  .
 *      du type :                                                              .
 *               If Expr then                                                  .
 *               begin                                                         .
 *                   Resultat := Reslt1;                                       .
 *               end                                                           .
 *               else begin                                                    .
 *                   Resultat := Reslt2;                                       .
 *               end;                                                          .
 *                                                                             .
 *      De plus, Reslt1 et Reslt2 peuvent eux-mêmes être des fonctions IIF     .
 *      imbriquées....                                                         .
 *      Exemple : X := 5;                                                      .
 *                Y := 3;                                                      .
 *                Z := 7;                                                      .
 *               Resultat := IIF(x>y,IIF(x<z,1,2),3);  // Resultat = 1 !!      .
 *******************************************************************************}

Function IIf(Expr : Boolean; Reslt1, Reslt2 : Variant) : Variant;
Begin
     If Expr then Result := Reslt1 Else Result := Reslt2;
end;


Function  ValidNumber(var sNumber : String): Boolean;
var
   i : Integer;
   L : Integer;
begin
     I := 1;
     L := Length(sNumber);
     Result := True;
     While (i <= L) and Result do begin
        If not (sNumber[i] in ['0'..'9','.','-']) then begin
           if sNumber[i] = ',' then sNumber[i] := '.'
           else Result := False;
        end;
        inc(i);
     end;
end;

Function AddSlash(Chaine : String) : String;
Begin
   Result := chaine;
   If Chaine[Length(Chaine)]<>'\' then Result := Result + '\';
end;

function  changehint(chaine : string) : string;
var ind : integer;
begin
   ind := pos('&',chaine);
   while ind > 0 do begin
         delete(chaine,ind,1);
         insert(#13,chaine,ind);
         ind := pos('&',chaine);
   end;
   result := chaine;
end;

Function EstVide(Liste : TstringList) : Boolean;
Begin
   Result := True;
   if Liste.Count > 0 then begin
      If Liste.Count = 1 then begin
         Result := Length(Trim(Liste[0])) = 0;
      end
      else begin
         Result := False;
      end;
   end;
end;

Function SplitString(Chaine, sep : String) : TStringlist;
var
   i    : Integer;
   temp : String;
begin
   result := Tstringlist.Create;
   While trim(Chaine) <> '' do begin
      i := pos(sep,chaine);
      if i  > 0 then begin
         temp := Copy(chaine,1,i-1);
         delete(chaine,1,i);
      end
      else begin
         temp := Chaine;
         Chaine := '';
      end;
      Result.add(temp);

   end;
   if trim(chaine) <> '' then result.add(chaine);

end;

function ReplaceStr(s, OldSubStr, NewSubStr: string): string;
var
  i: integer;
  OldSubLen, TotalLength: integer;
begin
  Result := '';
  if s <> '' then
  begin
    OldSubLen := Length(OldSubStr); // für die Performance - for performance
    TotalLength := Length(s);
    i := 1;
    while i <= TotalLength do
    begin
      if (i <= TotalLength - OldSubLen) and (Copy(s, i, OldSubLen) = OldSubStr) then
      begin
        Result := Result + NewSubStr;
        Inc(i, OldSubLen);
      end
      else
      begin
        Result := Result + s[i];
        Inc(i);
      end;
    end;
  end;
end;

function IsNumeric(s: string): Boolean;
var
  Code: Integer;
  Value: Double;
begin
  val(s, Value, Code);
  Result := (Code = 0)
end;

function GetCharFromVirtualKey(Key: Word): string;
var
   keyboardState: TKeyboardState;
   asciiResult: Integer;
begin
   GetKeyboardState(keyboardState) ;
   SetLength(Result, 2) ;
   asciiResult := ToAscii(key, MapVirtualKey(key, 0), keyboardState, @Result[1], 0) ;
   case asciiResult of
     0: Result := '';
     1: SetLength(Result, 1) ;
     2:;
     else
       Result := '';
   end;
end;

function verifncompte(chaine : string) : boolean;
var indice : word;
    modulo : extended;
    tempos : string;
    test   : string[1];
    tempo  : extended;
begin
   result := true;
   indice := 1;
   tempos := chaine;
   while indice <= length(tempos) do begin
     test := tempos[indice];
     if (test < '0') or (test >'9') then begin
       delete(tempos,indice,1);
       indice := 1;
     end
     else inc(indice);
   end;
   tempos := trim(tempos);
   if tempos >'' then begin
      tempo := strtofloat(copy(tempos,1,10));
      modulo := mod2(tempo);
      if round(modulo) = 0 then modulo := 97;
      if round(modulo) <> strtointdef(copy(tempos,11,2),0) then result := false;
   end;
end;

// verif format téléphone
function formatntel(chaine : string) : string;
var indice : integer;
    tempos : string;
    test   : string[1];
    test2  : string[2];
    chaine2: string;
begin
     chaine := trim(chaine);
     indice := 1;
     while (indice <= length(chaine)) and (length(chaine) > 0) do begin
           test := chaine[indice];
           if (test < '0') or (test > '9') then begin
              delete(chaine,indice,1);
              indice := 0;
           end;
           inc(indice);
     end;
     test2 := copy(chaine,1,2);
     if (test2 = '02') or (test2 ='04') or (test = '03') then begin
        if (    (copy(chaine,1,4) = '0475')
             or (copy(chaine,1,4) = '0476')
             or (copy(chaine,1,4) = '0477')
             or (copy(chaine,1,4) = '0478')
             or (copy(chaine,1,4) = '0479')
             or (copy(chaine,1,4) = '0486')
             or (copy(chaine,1,4) = '0495')
             or (copy(chaine,1,4) = '0496')
           )
           and (length(chaine) = 10) then begin
           chaine2 := copy(chaine,1,4)+'/'+copy(chaine,5,2)+'.'+copy(chaine,7,2)+'.'+copy(chaine,9,2);
        end
        else begin
           chaine2 := test2+'/';
           chaine2 := chaine2+copy(chaine,3,3)+'.'+copy(chaine,6,2)+'.'+copy(chaine,8,2);
        end;
     end
     else begin
        chaine2 := copy(chaine,1,3)+'/'+chaine2+copy(chaine,4,2)+'.'+copy(chaine,6,2)+'.'+copy(chaine,8,2);
     end;
     result := chaine2;
end;

// <HA> function to reduce the length of a string
// removed words are replaced by "_", letters by "."
function ReduceStr(sStr: string; iLength: integer): string;
var
  i1, i2, len, n: integer;
  sWords: TStringList;
  s: string;
begin
  // init
  sWords := TStringList.Create;
  Result := sStr;
  // Check input
  if (sStr <> '') and (iLength > 2) and (Length(sStr) > iLength) then
  begin
    sWords.CommaText := ReplaceStr(sStr,',',';');
    n := sWords.Count;
    i1 := n div 2 + 1;
    i2 := (n mod 2) * 2 - 1;
    len := length(sStr);
    // Remove words until length is below maximum
    while (len > iLength) and (i1 > 0) and (i1 <= n) do begin
      len := len - Length(sWords[i1-1]);
      if len >= iLength - 1 then begin
        sWords[i1-1] := '_';  // Replace word by "_"
        Inc(len);
      end
      else begin
        sWords[i1-1] := Copy(sWords[i1-1],1,iLength-len-1) + '.'; // Replace removed letters by "."
        len := 0;
      end;
      i1 := i1 + i2; // Next word
      if i2 > 0 then i2 := -(abs(i2) + 1) else i2 := abs(i2) + 1;
    end;
    s := Copy(ReplaceStr(sWords.CommaText,',',' '),1,iLength);
    Result := ReplaceStr(s,';',',');
  end;
  sWords.Free;
end;

function RemoveSuperfluousBlanks(const S: string): string;
var i, Count: integer;
  Temp: string;
  ThisChar, prevChar: Char;
begin
  Temp := '';
  PrevChar := #0;
  Count := Length(S);

  for i := 1 to Count do
  begin
    ThisChar := S[i];
    if (ThisChar <> ' ') or (ThisChar <> PrevChar) then
      Temp := Temp + ThisChar;
    PrevChar := ThisChar;
  end;
  Result := Temp;
end;

// Vervangt alle searchstring waarden door de waarde in replacestring in de gegeven TextFile
procedure FileReplaceString(const FileName, searchstring, replacestring: string);
var
  fs: TFileStream;
  S: string;
begin
  fs := TFileStream.Create(FileName, fmOpenread or fmShareDenyNone);
  try
    SetLength(S, fs.Size);
    fs.ReadBuffer(S[1], fs.Size);
  finally
    fs.Free;
  end;
  S  := StringReplace(S, SearchString, replaceString, false);
  fs := TFileStream.Create(FileName, fmCreate);
  try
    fs.WriteBuffer(S[1], Length(S));
  finally
    fs.Free;
  end;
end;

// Vervangt een stringwaarde door een andere in de gegevens string
function StringReplace(const S, OldPattern, NewPattern: string;
  IgnoreCase: Boolean): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  if IgnoreCase then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := AnsiPos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

// <HA3814> Implementation of StrToFloatDef like StrToIntDef with default value when string can not be converted to float value
function StrToFloatDef(const S: string; Default: Extended): Extended;
begin
  try
    Result := StrToFloat(S);
  except
    Result := Default;
  end;
end;

// <HA4013> (XOR) String Encryprtion, if key="" use Corilus-key !
function EncryptStr(const s,key: string): string;
const
  csCorKey: string = 'C7osru!L';  // scrambled "Cor!Lus7"
var
  sKey,sRes: string;
  i,j,iXor: integer;
begin
  Result := '';
  if Length(s) < 1 then Exit;  // Nothing to encrypt !!
  sKey := key;
  if sKey = '' then sKey := csCorKey;
  // Encrypt
  sRes := '';
  j := 1;
  for i := 1 to Length(s) do begin
    // <HA.20100317> prevent 0 as char > string-termination char !!
    // <HA19474> prevent space (32) as char > can be removed after trim !!
    if Ord(s[i]) = 255 then iXor := 0 else if Ord(s[i]) = 254 then iXor := 32 else iXor := Ord(s[i]);
    iXor := iXor xor Ord(sKey[j]);
    if iXor = 0 then iXor := 255;
    if iXor = 32 then iXor := 254;
    sRes := sRes + Chr(iXor); // <HA19474>
    j := j + 1;
    if j > Length(sKey) then j := 1;
  end;
  Result := sRes;
end;

// <HA12712> Convert string sIn to UTF8 (7b) !
function ConvUTF8(sIn: string): string;
var
  i,iCode: integer;
  sRes: string;
begin
  sRes := sIn;
  // remove non-UTF8 chars
  for i := 1 to Length(sRes) do begin
    iCode := Ord(sRes[i]);
    if iCode > 127 then begin
      if iCode = 199 then sRes[i] := 'C';
      if sRes[i] in ['ç'] then sRes[i] := 'c';
      if sRes[i] in ['ý','ÿ'] then sRes[i] := 'y';
      if sRes[i] in ['à','á','â','ä','ã'] then sRes[i] := 'a';
      if sRes[i] in ['è','é','ê','ë'] then sRes[i] := 'e';
      if sRes[i] in ['ì','í','î','ï'] then sRes[i] := 'i';
      if sRes[i] in ['ò','ó','ô','ö','õ'] then sRes[i] := 'o';
      if sRes[i] in ['ù','ú','û','ü'] then sRes[i] := 'u';
      if sRes[i] in ['È','É','Ê','Ë'] then sRes[i] := 'E';
      if sRes[i] in ['Ì','Í','Î','Ï'] then sRes[i] := 'I';
      if sRes[i] in ['Ù','Ú','Û','Ü'] then sRes[i] := 'U';
      if sRes[i] in ['Ò','Ó','Ô','Ö','Õ'] then sRes[i] := 'O';
      if sRes[i] in ['À','Á','Â','Ä','Ã'] then sRes[i] := 'A';
      if Ord(sRes[i]) > 127 then sRes[i] := '*';
    end;
  end;
  Result := sRes;
end;

function DeleteSpaces(Str: string): string;
var
  i: Integer;
begin
  i:=0;
  while i<=Length(Str) do
    if Str[i]=' ' then Delete(Str, i, 1)
    else Inc(i);
  Result:=Str;
end;

// <HA15744> StrKeepChars > JclStrings-alternative
function StrKeepChars(sIn: string; aChars: TSysCharSet): string;
var
  sRes: ansistring;
  i: integer;
begin
  // remove chars not in set aChars !
  for i := 1 to Length(sIn) do begin
    if sIn[i] in aChars then sRes := sRes + sIn[i];
  end;
  Result := sRes;
end;

// <HA15744> Remove Non-alfanumeric characters from string
function RemoveNonAlfaNumeric(sIn: string): string;
begin
  Result := StrKeepChars(sIn,['a'..'z','A'..'Z','0'..'9']);
end;

// <HA17622> Get MD5 HashCode-string for string value
function GetMD5(const value : string) : string;
//var
//  idmd5 : TIdHashMessageDigest5;
begin
 // idmd5 := TIdHashMessageDigest5.Create;
 { try
    result := idmd5.HashStringAsHex(value);
  finally
    idmd5.Free;
  end;}
end;

function GetMD5file(const fileName : string) : string;
{var
  idmd5 : TIdHashMessageDigest5;
  fs : TFileStream;
  hash : T4x4LongWordRecord;}
begin
  {idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
  try
    result := idmd5.HashStreamAsHex(fs);
  finally
    fs.Free;
    idmd5.Free;
  end;}
end;


end.
