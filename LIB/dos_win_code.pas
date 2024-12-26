unit dos_win_code; interface


function Dos2WinString(const s: string): string;
function Win2DosString(const s: string): string;


implementation

uses wcmn;


function dos_win(ch: Char): Char;
begin
  Result:=ch;
  if ch = #0 then Result:=' ' else
  if ch = #196 then Result:=#150 else
  if ch = #205 then Result:=#151 else
  if ch = #240 then Result:=#168 else
  if ch = #241 then Result:=#184 else

  if ch = #248 then Result:=#176 else//F8->B0 - градус!

  if ch = #249 then Result:=#177 else
  if ch = #252 then Result:=#185 else
  if ch = #253 then Result:=#167 else
  //if ch >= #$F0 then Result:=chr(ord(ch)-$50)//     //???
end;

function win_dos(ch: Char): Char;
begin
  Result:=ch;
  if ch = #0 then Result:=' ' else
  if ch = #150 then Result:=#196 else
  if ch = #151 then Result:=#205 else
  if ch = #168 then Result:=#240 else
  if ch = #184 then Result:=#241 else

  if ch = #176 then Result:=#248 else//B0->F0 - градус!

  if ch = #177 then Result:=#249 else
  if ch = #185 then Result:=#252 else
  if ch = #167 then Result:=#253 else
  //if (ch >= #$A0) and (ch <= #$AF) then Result Result:=chr(ord(ch)+$50)//  //???
end;


function Dos2WinString(const s: string): string;
var i: integer; t: String; ch: char;
begin
  t:=s;

  //if not ver_English then --------------------------------- ver_English

  for i:=1 to length(s) do begin
    ch:=t[i];

    if (ch >= #$80) and (ch <= #$AF) then
      ch:=chr(ord(ch)+$40)
    else
    if (ch >= #$E0) and (ch <= #$EF) then
      ch:=chr(ord(ch)+$10)
    else
      ch:=dos_win(ch);

    t[i]:=ch
  end;

  Result:=t
end;


function Win2DosString(const s: string): string;
var i: integer; t: string;  ch: char;
begin
  t:=s;

  //if not ver_English then/////////////////////////////////---ver_English
  for i:=1 to length(s) do begin
    ch:=t[i];

    if (ch >= #$C0) and (ch <= #$EF) then
      ch:=chr(ord(ch)-$40)
    else
    if ch >= #$F0 then
      ch:=chr(ord(ch)-$10)
    else
      ch:=win_dos(ch);

    t[i]:=ch;
  end;

  Result:=t;
end;



end.
