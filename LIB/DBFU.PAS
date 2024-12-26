(*
	tDbf: DBF-файл (use Stream: flib.pas)
	(тест: T_DBF.PAS)
*)

unit dbfu; interface uses cmn, dm_ext,flib,objects,iolib,slib;

procedure sdbfseparate(s0:string; var code:long; var s1:string);

{
        DBFile structure:

32      TDBFHeader       % HeaderLen - до первого #32, вкл. #13
                         % RecordLen - включая #32 => сумма полей +1
32      TDBFField1       % FieldOfs - от #32 , >= 1 , =1 для 1-го поля
32      TDBFField2       % FieldType: 'C'=char;
        ...
1       #13              % End of Header => 97 при 2-х полях по 32 б.
        #32 Record1      % Begin of Records' List
        #32 Record2
        ...
}
const _BufSize = 1024;

type

  TFileName  = FNameStr;
  
{
---------------	Заголовок DBF-файла и заголовок записи: ----------------
}
  TDBFHeader = record
    Version,
    Year,
    Month,
    Day         : Byte;
    RecordCount : Longint;
    HeaderLen,
    RecordLen   : Word;
    Reserv      : Array [1..20] of Byte
  end;

  PDBFField  = ^TDBFField;
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
{
------------------------------------------------------------------------
}

  tdbf = object(tobject)
       Ok : boolean;
       function find_lcode_all(lcode:long;var rec0,rcount:long):boolean; {2-DIVISION }
       function find_lcode(lcode:long):boolean;  { 2 - DIVISION }
       function find_name_all(fname,sfind:string; first:boolean):boolean;

       function getfieldofs(n:word):word;
       function getfield_s(n:word; var s:string):boolean;
       function getfield(n:word; var p:pchar; var l:word):boolean;

       function setrec(n:longint):boolean;

       function getfcount:word;
       function getrcount:word;
       function getrcurrent:longint;

       constructor init(fn:TFileName);
       destructor  done; virtual;
  private
       header     : tdbfheader;
       fcount : word;
       pfields : pdbffield;
       rcurrent : longint;
       prec : pchar;
       dbfile : tfile;
       function getrecposition(n:longint):longint;
  end;


{---------------------------------}
implementation

const code_field_n=0;
const name_field_n=1;
const dbf_separator=':';


procedure sdbfseparate(s0:string; var code:long; var s1:string);
var cpos:word;
begin
   code:=0; s1:='';
   cpos:=pos(dbf_separator,s0); if (cpos<=0) then exit;
   if not val_i(copy(s0,1,cpos-1),code) then exit;
   s1:=copy(s0,cpos+1,length(s0)-cpos);
end;

{----------------------------------------------------}

function tdbf.find_lcode_all(lcode:long; var rec0,rcount:long):boolean; {2-DIVISION }
var nr0,nr1,nr2,nrmax,v:long; s:string[24];
begin
     find_lcode_all:=false;
     if not find_lcode(lcode) then exit;
     nr1:=getrcurrent;
     nr0:=nr1;
     while nr0>0 do begin
           dec(nr0);
           setrec(nr0);
           getfield_s(code_field_n,s); if not val_i(s,v) then exit;
           if (v<>lcode) then break;
     end;
     if (nr0<nr1) then inc(nr0);

     setrec(nr1);
     nr2:=nr1; nrmax:=getrcount-1;
     while nr2<nrmax do begin
           inc(nr2);
           setrec(nr2);
           getfield_s(code_field_n,s); if not val_i(s,v) then exit;
           if (v<>lcode) then break;
     end;
     if nr2>nr1 then dec(nr2);

     rec0:=nr0; rcount:=nr2-nr0+1;
     setrec(rec0);
     find_lcode_all:=true;
end;

function tdbf.find_lcode(lcode:long):boolean;  { 2 - DIVISION }
var nl,nm,nr,v:long; s:string[64]; _ok:boolean;
begin
     _ok:=false; nl:=0; nr:=getrcount-1;

     while true do begin
         if (nr-nl)<=1 then break;
         nm:=(nl+nr) div 2;
         if not setrec(nm) then exit;
         getfield_s(code_field_n,s);    {about('HOUSES/2: '+s);}
         if not val_i(s,v) then exit;
         if (v=lcode) then begin _ok:=true; break; end;
         if (v<lcode) then nl:=nm;
         if (v>lcode) then nr:=nm;
     end;

     if not _ok then begin            {test nr}
        if not setrec(nr) then exit;
        getfield_s(code_field_n,s);
        if not val_i(s,v) then exit;
        if (v=lcode) then _ok:=true;
     end;

     if (not _ok) and (nl<>nr) then begin      {test nl}
        if not setrec(nl) then exit;
        getfield_s(code_field_n,s);
        if not val_i(s,v) then exit;
        if (v=lcode) then _ok:=true;
     end;

     find_lcode:=_ok;
end;

function tdbf.find_name_all(fname,sfind:string; first:boolean):boolean;
var j,l,n:word; s0,sn:string; fd:text;
begin
     find_name_all:=false;
     if not ftopen(fd,fname,'w') then exit;
     for j:=0 to getrcount-1 do begin
         setrec(j);
         getfield_s(name_field_n,s0);
         if (sfind='') then n:=1 else n:=pos(sfind,s0);
         if (n=0) then continue;
         if (n>1) and first then continue;
         getfield_s(code_field_n,sn);
         writeln(fd,sn,dbf_separator,s0);
     end;
     close(fd);
     find_name_all:=true;
end;

{---------------------------------}

function tdbf.getfield_s(n:word; var s:string):boolean;
var p:pchar; l:word;
begin
     getfield_s:=false;
     if not Ok then exit;
     if not getfield(n,p,l) then exit;
     move(p^,s[1],l); s[0]:=char(l);
     getfield_s:=true;
end;

function tdbf.getfieldofs(n:word):word;
var _pc:pchar; _pf:pdbffield;
begin
     getfieldofs:=0;
     if n>=fcount then exit;
     _pc:=pchar(pfields);
     inc(_pc,n*sizeof(tdbffield));
     _pf:=pdbffield(_pc);
     getfieldofs:=_pf^.fieldofs;
end;

function tdbf.getfield(n:word; var p:pchar; var l:word):boolean;
var _pc:pchar; _pf:pdbffield;
begin
     getfield:=false;
     if not Ok then exit;
     if prec=nil then exit;
     if n>=fcount then exit;
     _pc:=pchar(pfields);
     inc(_pc,n*sizeof(tdbffield));
     _pf:=pdbffield(_pc);
     l    :=_pf^.fieldlen;
     p:=prec + _pf^.fieldofs;

     getfield:=true;
end;

function tdbf.setrec(n:longint):boolean;
var fpos0,fpos1:longint;
begin
     setrec:=false;
     if not Ok then exit;
     if prec=nil then exit;
     if n>=header.recordcount then exit;
     fpos0:=getrecposition(n);
     fpos1:=dbfile.getpos;
     if fpos1<>fpos0
        then dbfile.seek(fpos0);
     dbfile.read(prec^,header.recordlen);
     if dbfile.status<>stOk then begin Ok:=false; exit; end;
     rcurrent:=n;
     setrec:=true;
end;

function tdbf.getfcount:word;
begin getfcount:=fcount end;

function tdbf.getrcount:word;
begin getrcount:=header.recordcount end;

function tdbf.getrcurrent:longint;
begin getrcurrent:=rcurrent;  end;

constructor tdbf.init(fn:TFileName);
var i:word; pf:pdbffield; c:byte;
begin
     dbfile.init(fn,stOpen,_BufSize);
     rcurrent:=0;
     Ok:=false;
     if dbfile.status<>stOk then exit;
     dbfile.read(header,sizeof(header));
     fcount := (header.HeaderLen-1-sizeof(tdbfheader)) div sizeof(tdbffield);
     pfields := _malloc(fcount*sizeof(tdbffield));
     if pfields<>nil then begin
          pf:=pfields;
          for i:=1 to fcount do begin
              dbfile.read(pf^,sizeof(tdbffield));
              inc(pf);
          end;
     end else exit;
     prec := _malloc( header.recordlen );
     if prec<>nil then setrec(0) else exit;
     Ok:=true;
end;

destructor  tdbf.done;
begin
     if not Ok then exit;
     dbfile.done;
     if pfields<>nil then _mfree(pfields,fcount*sizeof(tdbffield));
     if prec<>nil then _mfree(prec,header.recordlen);
end;

function tdbf.getrecposition(n:longint):longint;
begin
     getrecposition:=header.headerlen + n*header.recordlen;
end;

{---------------------------------}
BEGIN
END.