unit PSSCAN;

{$MODE Delphi}

 interface

uses classes;


function psscan_dict_to_mark: boolean;
function psscan_array_to_mark(xcheck: boolean): boolean;

{s меняется:}
function psscan_token(var s, rem: string; var proc_lev: integer; execname: boolean; var EOS: boolean): boolean;

{s меняется: (...\(...), а конец - в след строке}
function psscan_execfilestring(var s, rem: string; var proc_lev: integer): boolean;


implementation

uses
  SysUtils, Forms,
  Wcmn, Pso, Psstacks, PSOBJ, PSOBJX, Psarrays, Psdicts, PSX;

const
  Symbols = '/{}[](<>%';

{Delimeters: Symbols, WhiteSpace, p=pend}
(*
  /        - name
  //       - value
  { [ <<   - mark
  ]        - array
  }        - proc
  >>       - dict
  (...)    - string (\n \r \ooo ...)
  <...>    - hexstring (0..9 A..F a..f)
  %        - rem
*)

{Private:}

{Return: Delimeter OR pend}
function read_word(p, pend: PChar; var len: Integer): PChar;
begin
  len:=0;
  while (p^<=#32) and (p<pend) do inc(p);
  while (p<pend) and (p^>#32) and (pos(p^,Symbols)=0) do begin
    inc(len);
    inc(p);
  end;
  Result:=p;
end;

function IsNumStr(s: string; var realnum: boolean): boolean;
var i: Integer; digit: boolean;
begin
  Result:=true;
  realnum:=false;
  digit:=false;
  for i:=1 to Length(s) do begin
    if (s[i]>='0') and (s[i]<='9') then begin digit:=true; continue; end;
    if (i=1) and ( (s[1]='-') or (s[1]='+') ) then continue;
    if s[i]='.' then begin
      if realnum then begin Result:=false; exit; end; {/...}
      realnum:=true;
      continue;
    end;
    Result:=false;
    exit;
  end;{for}
  if not digit then Result:=false;
end;

function do_name(p: PChar; len: Integer; xcheck, slesh_name: boolean): boolean;
var s: string; o: TPsObj; realnum: boolean;
begin
  Result:=false;
  if len<=0 then exit;

  SetLength(s, len);
  memcpy(@s[1], p, len);

  if not slesh_name and IsNumStr(s, realnum) then begin
    if s[1]='.' then s:='0'+s;
    if realnum then o:=psobj_real( rvaldef(s,0) )
    else o:=psobj_int( ivaldef(s,0) );
  end else begin
    o:=psobj_name(s);
    o.xcheck:=xcheck;
  end;
  (*
  {DEBUG:}
  if s='#msversion' then begin
    realnum:=false;
  end;
  *)
  Result:=operandstack.push(o);
end;

{после "/" или "//"; Return: Delimeter OR pend}
function read_name(p, pend: PChar; double_slesh: boolean): PChar;
var wlen: Integer;
begin
  if double_slesh then Tell('SCANNER: "//" - NotImplemented');

  p:=read_word(p, pend, wlen);
  dec(p,wlen);
  do_name(p,wlen,false,true);
  Result:=p+wlen;
end;

{после '<'; Return: после '>' или p}
function read_hexstring(p, pend: PChar): PChar;
begin
  Result:=nil;
  Tell('SCANNER: "read_hexstring": Not Implemented');
end;

{после '('; Return: после ')' или p}
function read_string(p, pend: PChar): PChar;
var i: Integer; s: string;
begin
  Result:=p;
  i:=0;
  while true do begin
    if i>pend-p-1 then break;
    if (p+i)^='\' then begin   {(...\)...)}
      if isdigit((p+i+1)^) then inc(i,4)
      else inc(i,2);
      continue;
    end;
    if (p+i)^=')' then begin
      SetLength(s,i);
      if i>0 then memcpy(@s[1], p, i);
      operandstack.push(psobj_str_s(s));
      Result:=p+i+1;
      break;
    end;
    inc(i);
  end;{while}
end;


{Public:}

function psscan_dict_to_mark: boolean;
var d,o_key,o_val: TPsObj; dx: TPsDict; i,n: Integer;
begin
  Result:=false;
  d:=psobj_dict;

  TPsObjX(dx):=psobj_psobjx(d);

  n:=operandstack.counttomark(false);
  if n<0 then begin Ps.Error0('SCANNER: NoMark for dict (>>)'); exit; end;
  if (n mod 2)<>0 then begin Ps.Error('SCANNER: %d elements ToMark (>>)',[n]); exit; end;
  for i:=n div 2 downto 1 do begin
    if Ps.Stat<>0 then exit;
    operandstack.index(2*i-1,o_key);
    if o_key.pstype<>nametype then begin Ps.Error0('SCANNER: TypeCheck in <<...>>'); exit; end;
    operandstack.index(2*i-2,o_val);
    dx.def(o_key.key,o_val);
  end;

  operandstack.PopN(n+1);
  operandstack.Push(d);
  Result:=(Ps.Stat<=0);
end;

function psscan_array_to_mark(xcheck: boolean): boolean;
var a,o: TPsObj; ax: TPsArray; i,n: Integer;
begin
  Result:=false;
  a:=psobj_array(0);

  TPsObjX(ax):=psobj_psobjx(a);

  n:=operandstack.counttomark(xcheck);
  if n<0 then begin Ps.Error0('SCANNER: NoMark for array'); exit; end;
  for i:=n-1 downto 0 do begin
    if Ps.Stat<>0 then exit;
    operandstack.index(i,o);
    ax.add(o);
  end;

  operandstack.PopN(n+1);
  a.xcheck:=xcheck;
  operandstack.Push(a);
  Result:=(Ps.Stat<=0);
end;

{s меняется:}
function psscan_token(var s, rem: string; var proc_lev: integer; execname: boolean; var EOS: boolean): boolean;
label
  START;
var
  p: PChar; {position in s}
  pend: PChar; {#0, p<pend}
  slen, wlen: Integer;
  proc_lev0: Integer;
begin
  Result:=true;
  rem:='';

START:
  slen:=Length(s);
  EOS:=true;
  if slen=0 then exit;
  p:=@s[1]; {slen>0}
  pend:=p+slen;
  proc_lev0:=proc_lev;
  EOS:=false;

  while true do begin
    {
    Application.ProcessMessages;
    }
    if PS.Stat<>0 then begin Result:=false; EXIT; end;
    p:=read_word(p, pend, wlen);
    if (p>=pend) and (wlen=0) then {after read_word - for s='  '}
    begin
      s:='';
      EOS:=true;
      break;
    end;
    dec(p, wlen); {p->начало слова}
    case p^ of
      '/':
        begin
          (*
          if ((p+1)^='s') and ((p+2)^=' ') then
            rem:=''; {DEBUG}
          *)
          if (p+1)^='/' then p:=read_name(p+2, pend, true)
          else p:=read_name(p+1, pend, false);

          s:=copy(s,p-@s[1]+1,pend-p);
          EXIT;
        end;
      '{': begin inc(p); pso_mark; pso_cvx; inc(proc_lev); end;
      '[': begin inc(p); pso_mark; end;
      '}':
        begin
          inc(p); dec(proc_lev);
          if not psscan_array_to_mark(true) then begin Result:=false; EXIT; end;
          if proc_lev=proc_lev0 then begin
            s:=copy(s,p-@s[1]+1,pend-p);
            EXIT;
          end;
        end;
      ']':
        begin
          inc(p);

          if (proc_lev=0) and execname then begin
             if not psscan_array_to_mark(false) then begin Result:=false; EXIT; end;
          end else begin
             operandstack.push( psobj_name_x(']') );
          end;

          if proc_lev=proc_lev0 then begin
            s:=copy(s,p-@s[1]+1,pend-p);
            EXIT;
          end;
        end;
      '(':
        begin
          inc(p);  {'('+1}
          p:=read_string(p, pend); {')'+1 OR '('+1}
          if p=nil then begin
            Result:=false;
            EXIT;
          end;
          if (p-1)^<>')' then begin {конец - в след.строке:}
            EOS:=true;
            s:=copy(s,p-@s[1],pend-p+1)+'\r\n';
            EXIT;
          end;
          if proc_lev=proc_lev0 then begin
            s:=copy(s,p-@s[1]+1,pend-p);
            EXIT;
          end;
        end;
      '<':
        if (p+1)^='<' then begin
          inc(p,2); pso_mark;
        end else begin
          p:=read_hexstring(p+1, pend); {'>'+1 OR '<'+1}
          if p=nil then begin
            Result:=false;
            EXIT;
          end;
          if (p-1)^<>'>' then begin {конец - в след.строке:}
            EOS:=true;
            s:=copy(s,p-@s[1],pend-p+1);
            EXIT;
          end;
          if proc_lev=proc_lev0 then begin
            s:=copy(s,p-@s[1]+1,pend-p);
            EXIT;
          end;
        end;
      '>':
        if (p+1)^='>' then begin
          inc(p,2);

          if (proc_lev=0) and execname then begin
             if not psscan_dict_to_mark then begin Result:=false; EXIT; end;
          end else begin
             operandstack.push( psobj_name_x('>>') );
          end;

          if proc_lev=proc_lev0 then begin
            s:=copy(s,p-@s[1]+1,pend-p);
            EXIT;
          end;
        end else begin
          Ps.Error('SCANNER: symbol "%s"',['>']);
          Result:=false;
          EXIT;
        end;
      '%':
        begin
          EOS:=true;
          s:='';
          rem:=copy(s,p-@s[1]+2,pend-p-1);
          EXIT;
        end;
      else
        if wlen>0 then begin
          if  not do_name(p, wlen, true, false) then begin {only push!}
            Result:=false;
            EXIT;
          end;
          inc(p,wlen);
          s:=copy(s,p-@s[1]+1,pend-p); {=> FLinePost in file}

          {execution after change s:}
          if (proc_lev=0) and execname then pso_exec;

          if proc_lev=proc_lev0 then EXIT
          else goto START;  {строка s - заново}

        end else begin
          Ps.Error('SCANNER: symbol "%s"',[p^]);
          Result:=false;
          EXIT;
        end;
    end;{case}
  end;{while}
end;

function psscan_execfilestring(var s, rem: string; var proc_lev: integer): boolean;
var
  slen: Integer;
  EOS: boolean;
begin
  Result:=true;
  rem:='';
  slen:=Length(s);
  if slen=0 then exit;
  EOS:=false;

  while not EOS do begin
    if PS.Stat<>0 then break; {->true}
    if not psscan_token(s,rem,proc_lev,true,EOS) then begin
      Result:=false;
      exit;
    end;
  end;
end;


end.
