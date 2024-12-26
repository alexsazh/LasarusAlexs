unit MSCMN;

{$MODE Delphi}

 interface

uses Color;


const ms_version: real = 1.0; {пишется в начале файла .GC}
const tmp_ms_file_name = 'tmp_ms.tmp';

type
  { "context": заполняется в obj.pas}
  tMsContext = record
    cmyk: tCMYKColor;
    cmyk_ok: boolean;
    ac: tRGBColor;     {A,T}
    lc: tRGBColor;     {A,L}
    lw: real;          {L}
    snum: Integer;     {S}
    fname: string;     {T:font}
    fh: real;          {T}
  end;

procedure MsContext_Clear(con: TMsContext);


const
  colorslist32: array [0..31] of string = (
        '[/Black    1]','[0.0 0.0 0.0 1.0]',   {0}
        '[/Blue     1]','[1.0 1.0 0.0 0.0]',   {1}
        '[/Green    1]','[1.0 0.0 1.0 0.0]',   {2}
        '[/Cyan     1]','[1.0 0.0 0.0 0.0]',   {3}
        '[/Red      1]','[0.0 1.0 1.0 0.0]',   {4}
        '[/Magenta  1]','[0.0 1.0 0.0 0.0]',   {5}
        '[/Yellow   1]','[0.0 0.0 1.0 0.0]',   {6  "brown"}
  {LIGHT:}
        '[/Black   0.3]','[0.0 0.0 0.0 0.3]',  {7}
  {DARK:}
        '[/Black   0.7]','[0.0 0.0 0.0 0.7]',  {8}
  {LIGHT:}
        '[/Blue    0.5]','[0.5 0.5 0.0 0.0]',  {9}
        '[/Green   0.5]','[0.5 0.0 0.5 0.0]',  {10}
        '[/Cyan    0.5]','[0.5 0.0 0.0 0.0]',  {11}
        '[/Red     0.5]','[0.0 0.5 0.5 0.0]',  {12}
        '[/Magenta 0.5]','[0.0 0.5 0.0 0.0]',  {13}
        '[/Yellow  0.5]','[0.0 0.0 0.5 0.0]',  {14  "yellow"}
        '[/Black   0  ]','[0.0 0.0 0.0 0.0]'   {15}
  ); {colorslist32}

{"l.XX":}
function ms_layer_from_scode(scode: string): string;
{->"layer : /scode  obj def %rem"}
function ms_obj_str(layer,scode,obj,rem: string): string;

//------------------------------------

function lCode2string(code:longint):string;
function String2lcode(scode:string):longint;

function ismscode(s: string): boolean;  //буква, буква/цифра и 7 цифр
function ms_loc(loc: byte): char; {M,S,L,A,T,R}
function ms_code(lcode: longint; loc: byte): string; {M00000000}
procedure parse_ms_code(aMsCode: string; var lcode: longint; var loc: byte);

//------------------------------------

function sread_mscode(var s: string): string; {lcode loc -> scode}


implementation

uses
  SysUtils,
  Wcmn;


procedure MsContext_Clear(con: TMsContext);
begin
  con.fname:='';
  FillChar(con,SizeOf(con),0);
end;

function ms_layer_from_scode(scode: string): string;
begin
  Result := 'l.'+system.copy(scode,2,2);
end;

{->"layer : /scode  obj def %rem"}
function ms_obj_str(layer,scode,obj,rem: string): string;
begin
  Result:='';
  if scode='' then exit;
  if scode[1]<>'M'
    then Result := Format('%s : /%s  %s def  %s%s',[layer,scode,obj,'%',rem])
    else Result := Format('%s /%s  %s%s',['%',scode,'%',rem]);
end;


//------------------------------------------------------

//буква, буква/цифра и 7 цифр:
function ismscode(s: string): boolean;
var i: integer;
begin
  Result := false;
  if length(s)<>9 then exit;
  if not isalfa(s[1]) then exit;
//  for i:=2 to 9 do if not isdigit(s[i]) then exit;
  for i:=3 to 9 do if not isdigit(s[i]) then exit;
  Result := true;
end;


function lCode2string(code:longint):string;
var st:string; sd,lnumb: longint;
begin
  sd:=code div 10000000;
  lnumb:=code mod 10000000;
  st:=Format('%7.7d',[lnumb]);
  Result:=chr(48{ord('0')}+sd)+st;
end;

function String2lcode(scode:string):longint;
var st:string;
begin
  st:=Scode+#0;
  Result:=(ord(scode[1])-48{ord('0')})*10000000+ StrToInt(strpas(@st[2]));
end;

function ms_loc(loc: byte): char; {M,S,L,A,T,R}
const charlist: string[6] = 'MSLATR';
begin
  if (loc>=Length(charlist)) then begin
    loc:=0;
    Tellf('RANGE ERROR: ms_loc <- %d',[loc]);
  end;
  Result := charlist[loc+1];
end;

function ms_code(lcode: longint; loc: byte): string; {M00000000}
begin
  Result := ' ' + lCode2string(lcode);
  Result[1] := ms_loc(loc);
end;

procedure parse_ms_code(aMsCode: string; var lcode: longint; var loc: byte);
begin
  loc := pos(aMsCode[1], 'MSLATR') - 1;
  lcode := String2lcode( copy(aMsCode,2,8) );
end;

//------------------------------------------------------



{lcode loc -> scode}
function sread_mscode(var s: string): string;
var lcode: longint; loc: byte;
begin
  lcode:=sread_int(s);
  loc:=sread_int(s);
  Result:=ms_code(lcode,loc);
end;


end.
