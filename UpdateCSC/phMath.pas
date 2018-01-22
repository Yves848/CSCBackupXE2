unit phMath;

interface
  function mod2 (nombre : extended) : extended;
  function  arrondi(W_arrive : extended; W_decim : integer; W_sp : boolean) : extended ;

implementation

Uses
  Math,SysUtils;

function mod2 (nombre : extended) : extended;
var bidon : extended;
begin
     bidon := round(nombre/97);
     bidon := nombre-(bidon*97);
     if bidon <= 0 then bidon := bidon+97;
     result := bidon;
end;

function arrondi(W_arrive : extended;W_decim : integer;W_sp : boolean) : extended ;
var Wtrav   : currency;
    Wtrav2  :integer;
    fraction:extended;
    chaine  : string;
    SW_neg  : boolean;
    forme   : string;
    ind     : integer;
begin
    if W_sp then begin
     SW_neg := false;
     if W_sp then w_decim := 3;                   // si arrondi spécial tjs 3 decim
     fraction := 0;                               //  init part. fract.

     Wtrav  := frac(abs(w_arrive));                    // Extraire fraction
     if w_arrive < 0 then SW_neg := true;
     w_arrive := abs(W_arrive);
     Wtrav2 := trunc(wtrav*intpower(10,W_decim)); // la mettre en entier
     if W_sp then begin                           // si arrondi spéciale
        if Wtrav2 > 494 then
           W_arrive := W_arrive+1;                // si plafond
        end
     else begin
          chaine := inttostr(trunc(Wtrav*intpower(10,W_decim+1)));             //
          fraction := Wtrav2/intpower(10,W_decim);
     end;
     result := trunc(W_arrive);
     result := result+fraction;
     if not W_sp then begin
        if W_decim+1<=length(chaine) then begin
           if strtoint(copy(chaine,W_decim+1,1))>4 then
              result := result+(10/intpower(10,W_decim+1));
        end;
     end;
     if SW_neg then result := result*-1;
    end
    else begin
         forme := '#####0.';
         for ind := 1 to W_decim do forme := forme+'0';
         result := strtofloat(formatfloat(forme,W_arrive));
    end;
end;

end.

