unit Convert; interface

uses
  OTypes,SysUtils;

const
  HexC: array[0..15] of char = '0123456789ABCDEF';

function Decimals(i: longint): word;
function MaxDecimal(i: word): longint;
function int_Round(i,k: longint): longint;
function int_Even(i: longint): longint;
function lMult(i,j: word): longint;

function IStrCat(s: pChar; i: longint; last: boolean): pChar;
function fStrCat(s: pChar; f: double; dec: word; last: boolean): pChar;
function xyStrCat(s: pChar; x,y: longint; last: boolean): pChar;

procedure ItoA(i: longint; L: word; var fa);
function AtoI(var fa; L: word): longint;

function iLongStr(d: longint): string;
function TimeStr(t: longint): string;
function DateStr(d: longint): string;
function DateShort(d: longint): string;
function DateMonth(d: longint): string;
function MonthStr(d: longint): string;
function DayRuss(d: longint): string;
function DayStr(d: word): string;

function SVal(var a; len: word): string;
function IVal(var a; len: word): longint;
function RVal(var a; len: word): double;
function TVal(var fa): longint;
function DVal(var fa; len: word): longint;

function sTrunc(s: string): string;

function xStrUpper(p: pChar): pChar;
function xStrComp(s,t: pChar): boolean;

function StrRus(p: pChar): pChar;
function WinString(s: string): string;
function DosString(s: string): string;
function StrDosCopy(p: pChar; s: string): pChar;
function StrRusCopy(dst,src: pChar): pChar;

procedure R_to_G(r: double; var g,m: Integer; var s: double; long: boolean);
function Radian(g,m: SmallInt; s: double): double;
function Sec_to_Rad(sec: longint): double;
function Round_Angle(a: double; m: word): double;

function Str_xy(x,y: double; m: word; d,s: pChar): pChar;
function StrAngle(a: double; long: boolean; s: pChar): pChar;

function StrToken(dst,src: pChar): pChar;
function IntToken(s: pChar; var i: longint): boolean;
function RealToken(s: pChar; var r: double): boolean;

function dec_Round(d: double): longint;

function ReadPool(buf: pBytes; pos,size: word; var s: string): word;

function Get_Month(date: longint): word;
function Get_WeekDay(date: longint): SmallInt;
function PackDate(day,month,year: word): longint;
function Next_Date(date,days: longint): longint;
function Date_Dist(d1,d2: longint): longint;

function _UpperDos(s: string): string;
function TxtCompare(s,t: string): boolean;

implementation

function Decimals(i: longint): word;
var
  k: word;
begin
  k:=1; i:=Abs(i); while i > 9 do
  begin i:=i div 10; Inc(k) end;
  Decimals:=k
end;

function MaxDecimal(i: word): longint;
begin
  Result:=9; while i > 1 do begin
    Result:=Result*10+9; Dec(i)
  end
end;

function int_Round(i,k: longint): longint;
begin
  Result:=((i+k-1) div k) * k
end;

function int_Even(i: longint): longint;
begin
  Result:=i; if Odd(i) then Dec(Result)
end;

function lMult(i,j: word): longint;
begin
  Result:=i; Result:=Result*j
end;

function IStrCat(s: pChar; i: longint; last: boolean): pChar;
var
  t: tNumStr;
begin
  str(i,t); Result:=StrCat(s,t);
  if not last then Result:=StrCat(s,' ')
end;

function fStrCat(s: pChar; f: double; dec: word; last: boolean): pChar;
var
  t: tNumStr;
begin
  str(f:0:dec,t); Result:=StrCat(s,t);
  if not last then Result:=StrCat(s,' ')
end;

function xyStrCat(s: pChar; x,y: longint; last: boolean): pChar;
begin
  IStrCat(s,x,false); Result:=IStrCat(s,y,last)
end;

function AtoI(var fa; L: word): longint;
var
  a: array[0..15] of char absolute fa;
  i: word; sign: boolean;
begin
  i:=0; Result:=0; sign:=false;

  while (i < L) and (a[i] = ' ') do Inc(i);

  if a[i] = '+' then Inc(i) else
  if a[i] = '-' then begin Inc(i); sign:=true end;

  while i < L do begin
    Result:=(Result*10)+ord(a[i])-ord('0'); Inc(i)
  end;

  if sign then Result:=-Result
end;

procedure ItoA(i: longint; L: word; var fa);
var
  a: alfa absolute fa; t: longint;
begin
  t:=Abs(i); while L > 0 do begin
    a[L]:=chr(ord('0')+(t mod 10)); t:=t div 10; Dec(L)
  end; if i < 0 then a[1]:='-'
end;

function iLongStr(d: longint): string;
var
  t: longint; s: string[3];
begin
  Result:=''; t:=Abs(d); while t <> 0 do begin
    s[0]:=chr(3); ItoA(t mod 1000,3,s[1]);
    if length(Result) > 0 then Result:=' '+Result;
    Result:=s+Result; t:=t div 1000
  end;

  while (length(Result) > 2) and (Result[1] = '0') do
  System.Delete(Result,1,1);

  if d < 0 then Result:='-'+Result
end;

function TimeStr(t: longint): string;
const
  s: string[8] = '00:00:00';
begin
  ItoA(t div 10000,2,s[1]);
  ItoA(t div 100,2,s[4]);
  ItoA(t,2,s[6]);
  Result:=s
end;

function DateStr(d: longint): string;
const
  s: string[10] = '01.01.1996';
begin
  ItoA(d,2,s[1]);
  ItoA(d div 100,2,s[4]);
  ItoA(d div 10000,4,s[7]);
  Result:=s
end;

function DateShort(d: longint): string;
begin
  Result:=DateStr(d);
  Delete(Result,7,2)
end;

function DateMonth(d: longint): string;
begin
  Result:=DateStr(d); Result[0]:=chr(5)
end;

function MonthStr(d: longint): string;
const
  russ: array[1..12] of string[15] =
  ('Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август',
   'Сентябрь','Октябрь','Ноябрь','Декабрь');
var
  month: word;
begin
  Result:=''; month:=Get_Month(d);
  if month in [1..12] then Result:=russ[month]
end;

function DayRuss(d: longint): string;
begin
  Result:=IntToStr(d mod 100)+' '+MonthStr(d);
  if Get_Month(d) in [3,8] then Result:=Result+'а'
  else Result[length(Result)]:='я'
end;

function DayStr(d: word): string;
const
  s: array[0..1] of char = '00';
begin
  ItoA(d,2,s); Result:=s
end;

function SVal(var a; len: word): string;
var
  i1,i2: word; s: array[1..255] of char;
begin
  Move(a,s,len); i1:=1; i2:=len;
  while (i1 <= i2) and ((s[i1] = ' ') or (s[i1] = #0)) do Inc(i1);
  while (i1 <= i2) and ((s[i2] = ' ') or (s[i2] = #0)) do Dec(i2);
  SVal:=Copy(s,i1,i2+1-i1)
end;

function IVal(var a; len: word): longint;
var
  rc: Integer;
begin
  Val(SVal(a,len),Result,rc)
end;

function RVal(var a; len: word): double;
var
  rc: Integer;
begin
  val(SVal(a,len),Result,rc)
end;

function TVal(var fa): longint;
var
  a: array[0..15] of char absolute fa;
  hour,min,sec,sec100: word; tt: longint;
begin
  if length(SVal(a,8)) = 0 then
    DecodeTime(Time,hour,min,sec,sec100)
  else begin
    hour:=AtoI(a[0],2); min:=AtoI(a[3],2); sec:=AtoI(a[6],2)
  end;

  tt:=hour; TVal:=(tt * 3600) + (min * 60) + sec
end;

function DVal(var fa; len: word): longint;
var
  a: array[0..15] of char absolute fa;
  year,month,day: word; dd: longint;
begin
  if length(SVal(a,len)) = 0 then
    DecodeDate(Date,year,month,day)
  else begin
    day:=AtoI(a[0],2); month:=AtoI(a[3],2);
    year:=AtoI(a[6],len-6); if len = 8 then
    Inc(year,1900)
  end;

  dd:=year; DVal:=(dd * 10000) + (month * 100) + day
end;

function sTrunc(s: string): string;
var
  i: word;
begin
  i:=Pos(' ',s); if i > 0 then s[0]:=chr(i-1);
  i:=Pos(#0,s); if i > 0 then s[0]:=chr(i-1);
  sTrunc:=s
end;

const
  _UpChar: array[0..255] of byte =
   (00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {00}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {10}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {20}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {30}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {40}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {50}
    00,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,  {60}
    32,32,32,32,32,32,32,32,32,32,32,00,00,00,00,00,  {70}

    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {80}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {90}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {A0}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {B0}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {C0}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {D0}
    32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,  {E0}
    32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32); {F0}

function xStrUpper(p: pChar): pChar;
var
  s: pbytes absolute p;
  i,l: SmallInt; c: byte;
begin
  l:=StrLen(p); for i:=0 to l-1 do begin
    c:=s^[i]; s^[i]:=c-_UpChar[s^[i]]
  end; Result:=p
end;
                         
function xStrComp(s,t: pChar): boolean;
var
  l: SmallInt; v: tShortStr;
begin
  Result:=false; l:=StrLen(t);

  while StrLen(s) >= l do begin

    Move(s^,v,l); v[l]:=#0;
    if StrComp(v,t) = 0 then
    begin Result:=true; Break end;

    s:=StrScan(s,' '); if s = nil then Break;
    s:=@pbytes(s)^[1]
  end
end;

function StrRus(p: pChar): pChar;

procedure Update_char(p: pChar; up,dn: char);
var
  t: pChar;
begin
  t:=StrScan(p,up); if (t <> nil) and
  (t <> p) then t^:=dn
end;

begin
  Update_char(p,'Ю','ю');
  Update_char(p,'Я','я');
  StrRus:=p
end;

function WinString(s: string): string;
var
  i: word; c: char;
begin
  for i:=1 to length(s) do begin c:=s[i];
    if (c >= #$80) and (c <= #$AF) then
      c:=chr(ord(c)+$40)
    else
    if (c >= #$E0) and (c <= #$EF) then
      c:=chr(ord(c)+$10)
    else
    if c = #0 then c:=' ';

    s[i]:=c
  end;

  Result:=s
end;

function DosString(s: string): string;
var
  i: word; c: char;
begin
  for i:=1 to length(s) do begin
    c:=s[i];
    if (c >= #$C0) and (c <= #$EF) then
      c:=chr(ord(c)-$40)
    else
    if c >= #$F0 then c:=chr(ord(c)-$10);

    s[i]:=c
  end;

  Result:=s
end;

function StrDosCopy(p: pChar; s: string): pChar;
begin
  Result:=StrPCopy(p,WinString(s))
end;

function StrRusCopy(dst,src: pChar): pChar;
begin
  Result:=StrPCopy(dst,WinString(StrPas(src)))
end;

procedure R_to_G(r: double; var g,m: Integer; var s: double; long: boolean);
begin
  if r < 0 then r:=r+2*Pi;
  r:=r * 180.0 / Pi; g:=trunc(r); r:=(r-g)*60; m:=trunc(r);
  s:=(r-m)*60; if not long then begin if s >= 30 then Inc(m); s:=0 end;
  if Abs(s-59.99) < 0.01 then begin Inc(m); s:=0 end; if m = 60 then
  begin Inc(g); m:=0 end
end;

function Radian(g,m: SmallInt; s: double): double;
var
  xg,xm: double;
begin
  xg:=g; xm:=m; xm:=(xm + s/60)/60;
  if g < 0 then xg:=xg - xm else xg:=xg + xm;
  Radian:=xg * Pi / 180
end;

function Sec_to_Rad(sec: longint): double;
begin
  Sec_to_Rad:=sec*Pi/180/3600/100
end;

function Round_Angle(a: double; m: word): double;
var
  gr,min: Integer; sec: double;
begin
  R_to_G(Abs(a),gr,min,sec,true); if m = 0 then sec:=0
  else sec:=Round(sec*m)/m; Result:=Radian(gr,min,sec);
  if a < 0 then Result:=-Result
end;

function Str_xy(x,y: double; m: word; d,s: pChar): pChar;
var
  sx,sy: tShortStr;
begin
  str(x:0:m,sx); str(y:0:m,sy);
  Str_xy:=StrCat(StrCat(StrCopy(s,sx),d),sy)
end;

function RealStr(r: double; l,m: word): string;
var
  s: string[31];
begin
  str(r:l:m,s); Result:=s
end;

function StrAngle(a: double; long: boolean; s: pChar): pChar;
var
  g,m: Integer; sec: double; t: string[31];
begin
  R_to_G(Abs(a), g,m,sec, long);
  t:=''; if a < 0 then t:='-';
  t:=t+IntToStr(g)+#176+IntToStr(m)+'''';
  if long then t:=t+RealStr(sec,2,1)+'"';
  Result:=StrPCopy(s,t)
end;

function StrToken(dst,src: pChar): pChar;
var
  p: pChar;
begin
  StrCopy(dst,#0); StrToken:=nil;

  if (src <> nil) and (StrLen(src) > 0) then begin

    p:=nil; while true do begin
      p:=StrScan(src,' '); if (p = nil) or
      (p <> src) then Break; src:=@pbytes(p)^[1]
    end;

    if p <> nil then begin
      p^:=#0; StrCopy(dst,src);
      p:=pChar(@pbytes(p)^[1]);
      StrCopy(src,p)
    end
    else begin
      StrCopy(dst,src); src^:=#0
    end; StrToken:=dst
  end;
end;

function IntToken(s: pChar; var i: longint): boolean;
var
  t: tShortStr; rc: Integer;
begin
  Result:=false; i:=0;
  if StrToken(t,s) <> nil then begin
    Val(t,i,rc); if rc = 0 then Result:=true
  end
end;

function RealToken(s: pChar; var r: double): boolean;
var
  t: tShortStr; rc: Integer;
begin
  RealToken:=false;
  if StrToken(t,s) <> nil then begin
    Val(t,r,rc); if rc = 0 then RealToken:=true
  end
end;

function dec_Round(d: double): longint;
var
  k: longint;
begin
  k:=1; while d >= 10 do
  begin d:=d / 10; k:=k * 10 end;
  dec_Round:=Round(d) * k
end;

function ReadPool(buf: pBytes; pos,size: word; var s: string): word;
var
  ch: char;
begin
  s:=''; while pos < size do begin
    ch:=char(buf^[pos]); Inc(pos);
    if ch in [#0,#13] then Break;
    s:=s+ch
  end;

  ReadPool:=pos
end;

function Get_Month(date: longint): word;
begin
  Result:=(date div 100) mod 100
end;

function Get_WeekDay(date: longint): SmallInt ;
begin
  Result:=0; if date >= 19960101 then begin
    Result:=Date_Dist(19960101,date+1) mod 7;
    if Result = 0 then Result:=7
  end
end;

function Get_Month_Days(date: longint): word; var month: word;
const
  Days: array[1..12] of word =
  (31,28,31,30,31,30,31,31,30,31,30,31);
begin
  Result:=0; month:=Get_Month(date); if month in [1..12] then begin
    Result:=Days[month]; if month = 2 then
    if (date div 10000) mod 4 = 0 then
    Inc(Result)
  end
end;

function PackDate(day,month,year: word): longint;
begin
  Result:=year; Result:=Result*10000 + month*100 + day
end;

function Next_Date(date,days: longint): longint;
var
  y: longint; m,d,md: word;
begin
  while days > 0 do begin
    y:=date div 10000; m:=Get_Month(date);
    d:=Succ(date mod 100); md:=Get_Month_Days(date);

    if d > md then begin d:=1; Inc(m);
      if m > 12 then begin m:=1; Inc(y) end
    end;

    date:=PackDate(d,m,y);
    Dec(days)
  end;

  Result:=date
end;

function Date_Dist(d1,d2: longint): longint;
var
  t1,t2: longint;
begin
  Result:=0; if d2 > 19900101 then begin
    if d1 < d2 then begin t1:=d1; t2:=d2 end
    else begin t1:=d2; t2:=d1 end;

    Result:=0; while t1 < t2 do begin
      t1:=Next_Date(t1,1); Inc(Result)
    end;

    if d1 > d2 then Result:=-Result
  end
end;

function _UpperDos(s: string): string;
const
  _UpChar: array[0..255] of byte =
   (00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {00}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {10}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {20}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {30}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {40}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {50}
    00,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,  {60}
    32,32,32,32,32,32,32,32,32,32,32,00,00,00,00,00,  {70}

    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {80}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {90}
    32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,  {A0}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {B0}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {C0}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,  {D0}
    80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,  {E0}
    00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00); {F0}

var
  i: word; ch: byte;
begin
  Result:=s; for i:=1 to length(Result) do begin
    ch:=byte(Result[i]); Result[i]:=char(ch-_UpChar[ch])
  end
end;

function TxtCompare(s,t: string): boolean;
var
  i: word; len: char;
begin
  TxtCompare:=false; t:=_UpperDos(t);

  while length(t) >= length(s) do begin
    len:=t[0]; t[0]:=s[0]; if s = t then
    begin TxtCompare:=true; Break end; t[0]:=len;

    i:=Pos(' ',t); if i > 0 then begin Delete(t,1,i);
      while (length(t) > 0) and (t[1] = ' ') do Delete(t,1,1)
    end else Break
  end
end;

end.
