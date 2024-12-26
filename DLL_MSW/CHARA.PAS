unit CHARA;

{$MODE Delphi}

 interface

uses Classes;


function Chara_FindAndReadBlocks(fnames: TStrings): boolean;


implementation

uses
  SysUtils,
  Wcmn, PSSCAN;


//execute charalist = (CharaDictBegin ... CharaDictEnd):
procedure Chara_Execute(charalist: tStrings);
var i: integer; s,rem: string; proc_lev: integer;
begin
  proc_lev:=0;//!
  if charalist.count>0 then for i:=0 to charalist.Count-1 do begin
//    pslib_runstring(charalist[i]);
    s:=charalist[i];
    psscan_execfilestring(s, rem, proc_lev);
  end;
end;

//find in file and add to charalist:
procedure Chara_AddBlock(fname: string; var charalist: tStrings);
const
  name_begin='CharaDictBegin';
  name_end='CharaDictEnd';
var
  f: text; s: string; name_begin_ok: boolean;
begin
  if ftopen(f,fname,'r') then try
    name_begin_ok:=false;
    while not eof(f) do begin
      readln(f,s);
      if not name_begin_ok and (pos(name_begin,s)=1) then name_begin_ok:=true;
      if name_begin_ok then begin
        charalist.add(s);
        if pos(name_end,s)=1 then break;
      end;
    end;//while not eof(f)
  finally
    ftclose(f);
  end;
end;

//-------------------------------------------------

//main function:
function Chara_FindAndReadBlocks(fnames: TStrings): boolean;
var i: integer; charalist: tstringlist;
begin
  Result:=false;
  if fnames.count=0 then exit;
  charalist:=tstringlist.Create;
  try
    for i:=0 to fnames.count-1 do Chara_AddBlock(fnames[i], TStrings(charalist));
    Chara_Execute(charalist);
    Result:=charalist.count>0;
  finally
    charalist.Free;
  end;
end;


end.
