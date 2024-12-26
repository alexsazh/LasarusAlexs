unit UDBF;
INTERFACE
type
    TDBFHeader = Record
    Version,
    Year,
    Month,
    Day         : Byte;
    RecordCount : Longint;
    HeaderLen,
    RecordLen   : Word;
    Reserv      : Array [1..20] of Byte
  end;
  TDBFField  = record
    FieldName : Array [1..10] of Char;
    Zero1     : Byte;
    FieldType : Char;
    FieldOfs  : Word;
    Zero2     : Word;
    FieldLen,
    FieldDec  : Byte;
    Reserv    : Array [1..14] of Byte;
  end;
function Lval(var ss:shortstring;len:byte):longint;
function Get_dbaseText(var ff:file;NF:BYTE;ww:word;var s:shortstring):boolean;

IMPLEMENTATION
function Lval(var ss:shortstring;len:byte):longint;
var
  iw,i:byte;
  l:longint;
  code:integer;
  sw:string[255];
begin
iw:=0;
for i:=1 to len do if ss[i]<>' ' then begin inc(iw); sw[iw]:=ss[i]  end;
byte(sw[0]):=iw;
val(sw,l,code);
LVAL:=L;
end;

function Get_dbaseText(var ff:file;NF:byte;ww:word;var s:shortstring):boolean;
var
  HEAD:record
  DBFHead:TDBFHeader;
  Field:array[1..10] of TDBFField;
  end;
  N:integer;
  iw:integer;
  ll:longint;
  sw:string[11];
begin
 Get_dBaseText:=false;
iw:=-1;
   seek(ff,0);
   BlockRead(ff,HEAD,32,N);
   if N<>32 then exit;
   BlockRead(ff,HEAD.field,HEAD.DBFHEAD.HEADERlen-32,N);
   if N<>HEAD.DBFHEAD.HEADERlen-32 then exit;
ll:=HEAD.DBFHead.HeaderLen+1;
while iw<>ww do begin
   seek(ff,ll);
   BlockRead(ff,sw[1],HEAD.field[1].fieldlen,N);
    if N<>HEAD.field[1].fieldlen then exit;
iw:=Lval(sw,HEAD.field[1].fieldlen);
inc(ll,HEAD.DBFHead.RecordLen);
end;
dec(ll,HEAD.DBFHead.RecordLen-HEAD.field[1].fieldlen);
   seek(ff,ll);
   BlockRead(ff,s[1],HEAD.field[nf].fieldlen,N);
    if N<>HEAD.field[nf].fieldlen then exit;
byte(s[0]):=HEAD.field[nf].fieldlen;
Get_dBaseText:=true;
end;
end.