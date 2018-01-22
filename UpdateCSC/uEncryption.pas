unit uEncryption;

interface
function crypte(text: string): string; // Fonction pour crypter la chaine
function decrypte(text: string): string; // Fonction pour décrypter la chaine

implementation

function crypte(text: string): string; // Fonction pour crypter la chaine
var
  pos: Integer;
  text1: string;
  a: Integer;
begin
  a := 69; // chiffre à changer suivant le cryptage désiré
  text1 := text;
  for pos := 1 to length(text1) do
    text1[pos] := chr(ord(text1[pos]) + a); // crypte la chaine
  crypte := text1;
end;

function decrypte(text: string): string; // Fonction pour décrypter la chaine
var
  pos: Integer;
  text1: string;
  a: Integer;
begin
  a := 69; // chiffre à changer suivant le cryptage désiré
  text1 := text;
  for pos := 1 to length(text1) do
    text1[pos] := chr(ord(text1[pos]) - a); // decrypte la chaine
  result := text1;
end;

end.
