unit pso; interface

{$DEFINE PSTACK_BY_TELL}


uses psobj;

function pso_create: boolean;

{PostScript Operators:}

{XXX:}

procedure pso_tree;

{Stack:}
procedure pso_pop;
procedure pso_exch;
procedure pso_dup;
procedure pso_copy;
procedure pso_index;
procedure pso_roll;
procedure pso_clear;
procedure pso_count;
procedure pso_mark;
procedure pso_counttomark;

{Math:}
procedure pso_add;
procedure pso_div;
procedure pso_idiv;
procedure pso_mod;
procedure pso_mul;
procedure pso_sub;
procedure pso_neg;
procedure pso_round;
procedure pso_sqrt;
procedure pso_atan;
procedure pso_cos;
procedure pso_sin;
procedure pso_exp;

{Array:}
procedure pso_array;
{procedure pso_mark;}  {"[": Stack}
procedure pso_array_to_mark; {"]"}
procedure pso_length;
{procedure pso_get;}  {Dict}
{procedure pso_put;}  {Dict}
procedure pso_getinterval;
procedure pso_putinterval;
procedure pso_astore;
procedure pso_aload;
{procedure pso_copy;}  {Stack}
procedure pso_forall;

{Dict:}
procedure pso_dict;
{procedure pso_mark;}  {"<<": Stack}
procedure pso_dict_to_mark; {">>"}
{procedure pso_length;}        {Array}
procedure pso_begin;
procedure pso_end;
procedure pso_def;
{procedure pso_def;}   {GS: "odef" ???}
procedure pso_load;
procedure pso_get;
procedure pso_put;
procedure pso_known;
procedure pso_where;
{procedure pso_copy;}   {Stack}
{procedure pso_forall;} {Array}
procedure pso_currentdict;
procedure pso_systemdict;
procedure pso_userdict;
procedure pso_globaldict;
{procedure pso_statusdict;}   {- in systemdict}
procedure pso_countdictstack;

{String:}
procedure pso_string;
{procedure pso_length;}        {Array}
{procedure pso_get;}           {Dict}
{procedure pso_put;}           {Dict}
{procedure pso_getinterval;}   {Array}
{procedure pso_putinterval;}   {Array}
{procedure pso_copy;}          {Stack}
{procedure pso_forall;}        {Array}
procedure pso_anchorsearch;
procedure pso_search;
procedure pso_currentstring;   {xxx}

{Bool:}
procedure pso_eq;
procedure pso_ne;
procedure pso_ge;
procedure pso_gt;
procedure pso_le;
procedure pso_lt;

procedure pso_and;
procedure pso_not;
procedure pso_or;
procedure pso_xor;

procedure pso_true;
procedure pso_false;

{Control:}
procedure pso_exec;
procedure pso_if;
procedure pso_ifelse;
procedure pso_for;
procedure pso_repeat;
procedure pso_loop;
{
exit_flag yes: for,loop,repeat,forall
no:  cshow,filenameforall,kshow,pathforall,resourceforall
}
procedure pso_exit;
procedure pso_stop;
procedure pso_stopped;
procedure pso_quit;

{Type:}
procedure pso_type;
procedure pso_cvlit;
procedure pso_cvx;
procedure pso_xcheck;
procedure pso_cvi;
procedure pso_cvn;
procedure pso_cvs;

{File:}
procedure pso_file;
procedure pso_closefile;
procedure pso_writestring;
procedure pso_readline;    {file str -> substr bool}
procedure pso_token;       {file token -> any true || false}
procedure pso_run;
procedure pso_runlibfile;  {GS}
procedure pso_findlibfile; {GS: name -> path file true || name false}
procedure pso_currentfile;
procedure pso_print;
procedure pso_pstack;

{VM:}
procedure pso_save;
procedure pso_restore;

{Misc:}
procedure pso_bind;
procedure pso_null;
procedure pso__confirm;  {GS: (s) .confirm ->}
procedure pso_getenv;    {GS: (s) .getenv -> (s) _1 || _0}

{GState:}
procedure pso_gsave;
procedure pso_grestore;

{Coord:}
procedure pso_matrix;
procedure pso_translate;
procedure pso_scale;
procedure pso_rotate;
procedure pso_concat;
procedure pso_transform;
procedure pso_dtransform;

{Path:}
procedure pso_newpath;
procedure pso_currentpoint;
procedure pso_moveto;
procedure pso_lineto;
procedure pso_curveto;
procedure pso_closepath;

{Paint:}
procedure pso_clip;

{Device:}

{Font:}


implementation

uses
  SysUtils, Math,    Windows, Dialogs,
  wcmn, psstacks, psdicts, psnames, pslogs, psarrays,
  psobjx, psfiles, psx, psscan, pscmn,
  psgstate, psmat, pspath;


{Private:}

function PsCurrentName: string;
var po: PPsObj;
begin
  po:=namestack.indexp(0);
  if po=nil then Result:=''
  else Result:=Ps.Names.Name(po^.key);
end;

function CheckStackCount(n: Integer): boolean;
begin
  Result:=false;
  if Ps.Stat<>0 then exit;
  if operandstack.count<n then Ps.Error0('OperandStackUnderflow')
  else Result:=true;
end;

function CheckStack(a: array of tpstypeset): boolean;
var i,ind,count,h,n: integer; pstype: tpstype;
begin
  Result:=true;
  if Ps.Stat<>0 then exit;
  h:=High(a);
  n:=h+1;
  count:=operandstack.count;
  if count<n then begin
    Ps.Error0('OperandStackUnderflow'); Result:=false; exit;
  end;
  for i:=0 to h do begin        {Low(a)=0}
    ind:=( h-(i) );
    if (a[i]=anytypeset) then continue;
    pstype:=(operandstack.indexp(ind))^.pstype;
    if pstype in a[i] then continue;
    Ps.Error0('TypeCheck');
    Result:=false;
    exit;
  end;
end;


{Operators:}

function pso_(name: string; op: TPsOp): boolean;
var key: Integer; o: TPsObj;
begin
  key:=Ps.Names.Key(name);
  o:=psobj_op(op);
  o.namekey:=key;
  Result:=systemdict.def(key,o);
end;

function pso_create: boolean;
begin
  Result:=(Ps.Stat=0);
  if not Result then exit;

  {operators -> systemdict:}
  Ps.Vm.Global:=true; {?}

  pso_('tree', pso_tree);  {XXX}

  pso_('null', pso_null);
  pso_('mark', pso_mark);
  pso_('[', pso_mark);
  pso_('<<', pso_mark);
  pso_(']', pso_array_to_mark);
  pso_('>>', pso_dict_to_mark);

  pso_('true', pso_true);
  pso_('false', pso_false);
  pso_('cvlit', pso_cvlit);
  pso_('cvx', pso_cvx);
  pso_('xcheck', pso_xcheck);
  pso_('cvi', pso_cvi);
  pso_('cvn', pso_cvn);
  pso_('cvs', pso_cvs);
  pso_('type', pso_type);

  pso_('counttomark', pso_counttomark);
  pso_('pop', pso_pop);
  pso_('index', pso_index);
  pso_('dup', pso_dup);
  pso_('copy', pso_copy);
  pso_('exch', pso_exch);
  pso_('roll', pso_roll);
  pso_('clear', pso_clear);
  pso_('count', pso_count);

  pso_('systemdict', pso_systemdict);
  pso_('globaldict', pso_globaldict);
  pso_('userdict', pso_userdict);
  pso_('currentdict', pso_currentdict);
  pso_('countdictstack', pso_countdictstack);

  pso_('array', pso_array);
  pso_('length', pso_length);

  pso_('dict', pso_dict);
  pso_('begin', pso_begin);
  pso_('end', pso_end);
  pso_('def', pso_def);
  pso_('odef', pso_def);
  pso_('load', pso_load);
  pso_('known', pso_known);
  pso_('where', pso_where);

  pso_('get', pso_get);
  pso_('put', pso_put);
  pso_('getinterval', pso_getinterval);
  pso_('putinterval', pso_putinterval);

  pso_('bind', pso_bind);
  pso_('pstack', pso_pstack);
  pso_('print', pso_print);
  pso_('.confirm', pso__confirm);
  pso_('getenv', pso_getenv);

  pso_('exec', pso_exec);
  pso_('if', pso_if);
  pso_('ifelse', pso_ifelse);
  pso_('for', pso_for);
  pso_('astore', pso_astore);
  pso_('aload', pso_aload);
  pso_('forall', pso_forall);
  pso_('repeat', pso_repeat);
  pso_('loop', pso_loop);
  pso_('exit', pso_exit);
  pso_('stop', pso_stop);
  pso_('stopped', pso_stopped);
  pso_('quit', pso_quit);

  pso_('string', pso_string);
  pso_('anchorsearch', pso_anchorsearch);
  pso_('search', pso_search);

  pso_('file', pso_file);
  pso_('closefile', pso_closefile);
  pso_('run', pso_run);
  pso_('runlibfile', pso_runlibfile);
  pso_('findlibfile', pso_findlibfile);
  pso_('writestring', pso_writestring);
  pso_('readline', pso_readline);
  pso_('token', pso_token);
  pso_('currentfile', pso_currentfile);
  pso_('currentstring', pso_currentstring);

  pso_('not', pso_not);
  pso_('and', pso_and);
  pso_('or', pso_or);
  pso_('xor', pso_xor);

  pso_('eq', pso_eq);
  pso_('ne', pso_ne);
  pso_('ge', pso_ge);
  pso_('gt', pso_gt);
  pso_('le', pso_le);
  pso_('lt', pso_lt);

  pso_('add', pso_add);
  pso_('div', pso_div);
  pso_('idiv', pso_idiv);
  pso_('mod', pso_mod);
  pso_('mul', pso_mul);
  pso_('sub', pso_sub);
  pso_('neg', pso_neg);
  pso_('round', pso_round);
  pso_('sqrt', pso_sqrt);
  pso_('atan', pso_atan);
  pso_('cos', pso_cos);
  pso_('sin', pso_sin);
  pso_('exp', pso_exp);

  pso_('gsave', pso_gsave);
  pso_('grestore', pso_grestore);

  pso_('matrix', pso_matrix);
  pso_('translate', pso_translate);
  pso_('scale', pso_scale);
  pso_('rotate', pso_rotate);
  pso_('concat', pso_concat);
  pso_('transform', pso_transform);
  pso_('dtransform', pso_dtransform);

  pso_('newpath', pso_newpath);
  pso_('currentpoint', pso_currentpoint);
  pso_('moveto', pso_moveto);
  pso_('lineto', pso_lineto);
  pso_('curveto', pso_curveto);
  pso_('closepath', pso_closepath);

  pso_('clip', pso_clip);

  pso_('save', pso_save);
  pso_('restore', pso_restore);


  Ps.Vm.Global:=false;
  Result:=(Ps.Stat=0);
end;


procedure pso_tree;
begin
  PS.Tree;
end;

procedure pso_null;
begin
  operandstack.push(psobj_null);
end;

procedure pso_mark;
begin
  operandstack.push(psobj_mark);
end;

procedure pso_array_to_mark;
begin
  if not psscan_array_to_mark(false)
  then PS.Error0('NoMark for "]"');
end;

procedure pso_dict_to_mark;
begin
  if not psscan_dict_to_mark
  then PS.Error0('NoMark for ">>"');
end;

procedure pso_true;
begin
  operandstack.push(psobj_bool(true));
end;

procedure pso_false;
begin
  operandstack.push(psobj_bool(false));
end;

procedure pso_cvlit;
var po: PPsObj;
begin
  if not CheckStackCount(1) then exit;
  po:=operandstack.indexp(0);
  po^.xcheck:=false;
end;

procedure pso_cvx;
var po: PPsObj;
begin
  if not CheckStackCount(1) then exit;
  po:=operandstack.indexp(0);
  po^.xcheck:=true;
end;

procedure pso_xcheck;
var po: PPsObj; b: boolean;
begin
  if not CheckStackCount(1) then exit;
  po:=operandstack.indexp(0);
  b:=po^.xcheck;
  operandstack.pop;
  operandstack.push(psobj_bool(b));
end;

procedure pso_cvi;
var po: PPsObj; s: string; x: TPsReal; valcode: integer;
begin
  if not CheckStackCount(1) then exit;
  po:=operandstack.indexp(0);
  if psobj_cvi(po^) then exit; {num - ok}

  {string:}
  if po^.pstype=stringtype then begin

    s:=TPsStr(psobj_psobjx(po^))._;
    val( s, x, valcode );
    if valcode<>0 then x:=0;

    operandstack.pop;
    operandstack.push( psobj_int( Round(x) ) );

  end else begin
    PS.Error0('TypeCheck in -cvi-');
  end;
end;

procedure pso_cvn;
var po: PPsObj; s: string;
begin
  if not CheckStack([stringtypeset]) then exit;
  po:=operandstack.indexp(0);
  s:=TPsStr( psobj_psobjx(po^) )._;
  operandstack.pop;
  operandstack.push( psobj_name(s) );
end;

procedure pso_cvs;
var po: PPsObj; o: TPsObj; ox: TPsStr;
begin
  if not CheckStack([anytypeset,stringtypeset]) then exit;
  operandstack.index(0,o); {str}
  po:=operandstack.indexp(1);
  ox:=TPsStr(psobj_psobjx(o));
  ox._:=psobj_cvs(po^);
  operandstack.popn(2);
  operandstack.push(o); {new o->ox._}
end;

procedure pso_type;
var o: TPsObj;
begin
  if not CheckStackCount(1) then exit;
  with operandstack do begin
    index(0,o);
    pop;
    push( psobj_name( psobj_type(@o) ) );
  end;
end;

procedure pso_counttomark;
var n: Integer;
begin
  n:=operandstack.counttomark(false);
  if n>=0 then operandstack.push(psobj_int(n))
  else Ps.Error0('NoMark');
end;

procedure pso_pop;
begin
  operandstack.pop;
end;

procedure pso_index;
var o,o_i: TPsObj;
begin
  if not CheckStack([integertypeset]) then exit;
  with operandstack do begin
    index(0, o_i); pop;
    index(o_i.i, o); push(o);
  end;
end;

procedure pso_dup;
var o: TPsObj;
begin
  if not CheckStackCount(1) then exit;
  with operandstack do begin
    index(0,o); push(o);
  end;
end;

procedure pso_copy;
var po0, po1: PPsObj; n,i: integer; a1,a2: TPsArray;
    d1,d2: TPsDict; item: TDictItem; s1,s2: TPsStr;
begin
  if not CheckStackCount(1) then exit;
  po0:=operandstack.indexp(0);
  n:=po0^.i;

  if po0^.pstype=integertype then begin

    if not CheckStackCount(n+1) then exit;
    operandstack.pop;
    for i:=n-1 downto 0 do begin
      po1:=operandstack.indexp(n-1);
      operandstack.push(po1^);
    end;

  end else if po0^.pstype=arraytype then begin

    if not CheckStack([arraytypeset,arraytypeset]) then exit;
    po1:=operandstack.indexp(1);
    operandstack.popn(2);

    a1:=TPsArray(psobj_psobjx(po1^));
    a2:=TPsArray(psobj_psobjx(po0^));
    a2.count:=a1.count;
    for i:=0 to a1.count-1 do a2.put(i, a1.getp(i)^);
    operandstack.push(po0^);

  end else if po0^.pstype=dicttype then begin

    if not CheckStack([dicttypeset,dicttypeset]) then exit;
    po1:=operandstack.indexp(1);
    operandstack.popn(2);

    d1:=TPsDict(psobj_psobjx(po1^));
    d2:=TPsDict(psobj_psobjx(po0^));
    for i:=0 to d1.count-1 do begin
      item:=d1.getp(i)^;
      d2.def(item.key, item.val);
    end;
    operandstack.push(po0^);

  end else if po0^.pstype=stringtype then begin

    if not CheckStack([stringtypeset,stringtypeset]) then exit;
    po1:=operandstack.indexp(1);
    operandstack.popn(2);

    s1:=TPsStr(psobj_psobjx(po1^));
    s2:=TPsStr(psobj_psobjx(po0^));
    s2._:=s1._;
    operandstack.push(po0^);

  end else begin
    PS.Error0('TypeCheck in -copy-');
  end;
end;


procedure pso_exch;
var o0,o1: TPsObj;
begin
  if not CheckStackCount(2) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    popn(2);
    push(o0);
    push(o1);
  end;
end;

procedure pso_roll;
var po: PPsObj; n,j,i,i2: integer; a: TPsArray;
begin
  if not CheckStack([integertypeset,integertypeset]) then exit;
  with operandstack do begin
    po:=indexp(0); j:=po^.i;
    po:=indexp(1); n:=po^.i;
  end;
  if not CheckStackCount(n+2) then exit;
  operandstack.popn(2);

  if (j=0) or (abs(j)>=n) then exit;

  a:=TPsArray.Create;
  try
    for i:=0 to n-1 do a.add(operandstack.indexp(i)^);
    operandstack.popn(n);
    for i:=n-1 downto 0 do begin
      i2 := (i+j) mod n;
      if i2<0 then i2:=n+i2;
      operandstack.push(a.getp(i2)^);
    end;
  finally
    a.Free;
  end;
end;

procedure pso_clear;
begin
  operandstack.count:=0;
end;

procedure pso_count;
begin
  operandstack.Push(psobj_int(operandstack.count));
end;

procedure pso_systemdict;
var po: PPsObj;
begin
  po:=dictstack.GetP(0);
  operandstack.push(po^);
end;

procedure pso_globaldict;
var po: PPsObj;
begin
  po:=dictstack.GetP(1);
  operandstack.push(po^);
end;

procedure pso_userdict;
var po: PPsObj;
begin
  po:=dictstack.GetP(0);
  operandstack.push(po^);
end;

procedure pso_currentdict;
var o: TPsObj;
begin
  dictstack.index(0,o);
  operandstack.push(o);
end;

procedure pso_countdictstack;
begin
  operandstack.push(psobj_int(dictstack.count));
end;

procedure pso_array;
var o: TPsObj;
begin
  if not CheckStack([integertypeset]) then exit;
  with operandstack do begin
    index(0,o); pop;  {array size}
    push( psobj_array(o.i) );
  end;
end;

procedure pso_length;
var o: TPsObj; a: TPsArray; s: string; d: TPsDict;
begin
  if not CheckStackCount(1) then exit;
  operandstack.index(0,o);

  if o.pstype=arraytype then begin
    operandstack.pop;
    a:=TPsArray( psobj_psobjx(o) );
    operandstack.push( psobj_int( a.count ) );
  end else
  if o.pstype=stringtype then begin
    operandstack.pop;
    s:=TPsStr( psobj_psobjx(o) )._;
    operandstack.push( psobj_int( Length(s) ) );
  end else
  if o.pstype=nametype then begin
    operandstack.pop;
    s:=PS.Names.Name( o.key );
    operandstack.push( psobj_int( Length(s) ) );
  end else
  if o.pstype=dicttype then begin
    operandstack.pop;
    d:=TPsDict( psobj_psobjx(o) );
    operandstack.push( psobj_int( d.count ) );
  end else begin
    PS.Error0('TypeCheck in -length-');
  end;
end;

procedure pso_dict;
begin
  if not CheckStackCount(1) then exit;
  operandstack.pop;  {dict size}
  operandstack.push(psobj_dict);
end;

procedure pso_begin;
var o: TPsObj;
begin
  if not CheckStack([dicttypeset]) then exit;
  operandstack.index(0,o);
  operandstack.pop;
  dictstack.push(o);
end;

procedure pso_end;
begin
  dictstack.pop;
end;

procedure pso_def;
var o0,o1: TPsObj;
begin
  if not CheckStack([nametypeset, anytypeset]) then exit;
  operandstack.index(1, o1); {key}
  operandstack.index(0, o0); {val}
  if currentdict.def( o1.key, o0 ) then operandstack.popn(2);
end;

procedure pso_load;
var o0,d,o: TPsObj;
begin
  if not CheckStack([nametypeset]) then exit;
  operandstack.index(0, o0); {key}
(*
  if PS.Names.Name(o0.key)='dasharray' then
    o.pstype:=nulltype;
*)
  if dictstack.find(o0.key,d,o) then begin
    operandstack.pop;
    operandstack.push(o);
  end else begin
    Ps.Error('/load "%s" - NotFound',[Ps.Names.Name(o0.key)]);
  end;
end;

procedure pso_known;
var o0,o1,o: TPsObj; d: TPsDict; i:integer;
begin
  if not CheckStack([dicttypeset,nametypeset]) then exit;
  operandstack.index(0,o0); {key}
  operandstack.index(1,o1); {dict}
  operandstack.popn(2);
  d:=TPsDict( psobj_psobjx(o1) );
  if d.value(o0.key,o,i) then operandstack.push(psobj_bool(true))
  else operandstack.push(psobj_bool(false))
end;

procedure pso_where;
var o0,d,o: TPsObj;
begin
  if not CheckStack([nametypeset]) then exit;
  operandstack.index(0, o0); {key}
  operandstack.pop;
  if dictstack.find(o0.key,d,o) then begin
    operandstack.push(d);
    operandstack.push(psobj_bool(true));
  end else begin
    operandstack.push(psobj_bool(false));
  end;
end;

procedure pso_get;
var po0,po1: PPsObj; o: TPsObj; d: TPsDict; a: TPsArray; s: string; i:integer;
begin
  if not CheckStackCount(2) then exit;
  po0:=operandstack.indexp(0);
  po1:=operandstack.indexp(1);

  if po1.pstype=dicttype then begin

    if not CheckStack([dicttypeset,nametypeset]) then exit;
    d:=TPsDict(psobj_psobjx(po1^));
    if d.Value(po0^.key,o,i) then with operandstack do begin
      popn(2);
      push(o);
    end else begin
      PS.Error('Undefined name (%s) in -get-',[PS.Names.Name(po0^.key)]);
    end;

  end else if po1.pstype=arraytype then begin

    if not CheckStack([arraytypeset,integertypeset]) then exit;
    a:=TPsArray(psobj_psobjx(po1^));
    a.get(po0^.i,o);
    with operandstack do begin
      popn(2);
      push(o);
    end;

  end else if po1.pstype=stringtype then begin

    if not CheckStack([stringtypeset,integertypeset]) then exit;
    s:=TPsStr(psobj_psobjx(po1^))._;
    with operandstack do begin
      popn(2);
      push( psobj_int( Ord(s[po0^.i+1]) ) );
    end;

  end else begin
    PS.Error0('TypeCheck in -get-');
  end;
end;

procedure pso_getinterval;
var po: PPsObj; o2: TPsObj; a,a2: TPsArray; ind,acount,i: integer; s,s2: TPsStr;
begin
  if not CheckStackCount(3) then exit;
  if not CheckStack([integertypeset,integertypeset]) then exit;
  with operandstack do begin
    po:=indexp(0); acount:=po^.i;
    po:=indexp(1); ind:=po^.i;
    po:=indexp(2);
  end;

  if po^.pstype=arraytype then begin

    a:=TPsArray(psobj_psobjx(po^));

    o2:=psobj_array(acount);
    a2:=TPsArray(psobj_psobjx(o2));

    for i:=0 to acount-1 do a2.put(i, a.getp(ind+i)^);

    operandstack.popn(3);
    operandstack.push(o2);

  end else if po^.pstype=stringtype then begin

    s:=TPsStr(psobj_psobjx(po^));

    o2:=psobj_str(acount);
    s2:=TPsStr(psobj_psobjx(o2));

    for i:=1 to acount do s2._[i]:=s._[ind+i];

    operandstack.popn(3);
    operandstack.push(o2);

  end else begin
    PS.Error0('TypeCheck in -getinterval-');
  end;
end;

procedure pso_put;
var po0,po1,po2: PPsObj; d: TPsDict; a: TPsArray; s: TPsStr;
begin
  if not CheckStackCount(3) then exit;
  po0:=operandstack.indexp(0);
  po1:=operandstack.indexp(1);
  po2:=operandstack.indexp(2);

  if po2.pstype=dicttype then begin

    if not CheckStack([dicttypeset,nametypeset,anytypeset]) then exit;
    d:=TPsDict(psobj_psobjx(po2^));
    if d.Def(po1^.key,po0^) then operandstack.popn(3);

  end else if po2.pstype=arraytype then begin

    if not CheckStack([arraytypeset,integertypeset,anytypeset]) then exit;
    a:=TPsArray(psobj_psobjx(po2^));
    a.put(po1^.i,po0^);
    if PS.Stat<=0 then operandstack.popn(3);

  end else if po2.pstype=stringtype then begin

    if not CheckStack([stringtypeset,integertypeset,integertypeset]) then exit;
    s:=TPsStr(psobj_psobjx(po2^));
    try
      s._[po1^.i+1]:=Char(po0^.i);
    except
      PS.Error0('RangeCheck in -put- to string');
    end;
    if PS.Stat<=0 then operandstack.popn(3);

  end else begin
    PS.Error0('TypeCheck in -put-');
  end;
end;

procedure pso_putinterval;
var po0,po1,po2: PPsObj; a,a2: TPsArray; ind,i: integer; s,s2: TPsStr;
begin
  if not CheckStackCount(3) then exit;
  if not CheckStack([integertypeset,anytypeset]) then exit;
  with operandstack do begin
    po0:=indexp(0);
    po1:=indexp(1); ind:=po1^.i;
    po2:=indexp(2);
  end;

  if (po0^.pstype=arraytype) and (po2^.pstype=arraytype) then begin
    a2:=TPsArray(psobj_psobjx(po0^));
    a:=TPsArray(psobj_psobjx(po2^));
    for i:=0 to a2.count-1 do a.put(ind+i, a2.getp(i)^);
    operandstack.popn(3);
  end else if (po0^.pstype=stringtype) and (po2^.pstype=stringtype) then begin
    s2:=TPsStr(psobj_psobjx(po0^));
    s:=TPsStr(psobj_psobjx(po2^));
    for i:=1 to Length(s2._) do s._[ind+i]:=s2._[i];
    operandstack.popn(3);
  end else begin
    PS.Error0('TypeCheck in -putinterval-');
  end;
end;

procedure pso_bind;
var o: TPsObj; a: TPsArray;
begin
  if not CheckStackCount(1) then exit;
  operandstack.index(0, o);
  if (o.pstype=arraytype) and (o.xcheck) then begin
    TPsObjX(a):=psobj_psobjx(o);
    a.bind;
  end;
end;

procedure pso_pstack;
var s: string;
begin
  s:=Format('pstack(%d)> ',[operandstack.count])+_EOL_+operandstack.print;
{$IFDEF PSTACK_BY_TELL}
  Tell(s);
{$ELSE}
  PsLog_WL(s);
  if Assigned(PS.FLogForm) then PS.FLogForm.Show;
{$ENDIF}
end;

procedure pso__confirm;
var
  o: TPsObj; s: string;
{$IFNDEF PSTACK_BY_TELL}
  zs1,zs2: array[0..256]of char;
{$ENDIF}
begin
  if not CheckStack([stringtypeset]) then exit;
  operandstack.index(0,o);
  s:=TPsStr(psobj_psobjx(o))._;
  operandstack.pop;
  if Assigned(PS.FLogForm) then PS.FLogForm.Show;
{$IFNDEF PSTACK_BY_TELL}
  MessageBox(0, StrPCopy(zs1,s), StrPCopy(zs2,'PS: Confirm'), mb_Ok or mb_IconInformation {or MB_TASKMODAL});
{$ENDIF}
end;

procedure pso_getenv;
var o: TPsObj; s: string;
begin
  if not CheckStack([stringtypeset]) then exit;
  operandstack.index(0,o);
  s:=TPsStr(psobj_psobjx(o))._;
  operandstack.pop;

  s:=wcmn_GetEnv(s);
  if s<>'' then begin
    operandstack.push(psobj_str_s( str2psstr(s) ));
    operandstack.push(psobj_bool(true));
  end else begin
    operandstack.push(psobj_bool(false));
  end;
end;

procedure pso_print;
var s: string; o: TPsObj;
begin
  if not CheckStack([stringtypeset]) then exit;
  operandstack.index(0, o);
  s:=TPsStr(psobj_psobjx(o))._;
  operandstack.pop;
  PsLog_WL('PRINT>'+s);
  if Assigned(PS.FLogForm) then PS.FLogForm.Show;
end;

procedure pso_exec;
var o: TPsObj;
begin
  if not CheckStackCount(1) then exit;
  operandstack.index(0, o);
  operandstack.pop;
  psobj_exec(o, true);
end;

procedure pso_if;
var o0,o1: TPsObj;
begin
  if not CheckStack([integertypeset,proctypeset]) then exit;
  operandstack.index(0, o0);
  operandstack.index(1, o1);
  operandstack.popn(2);
  if o1.i<>0 then psobj_exec(o0, true);
end;

procedure pso_ifelse;
var o0,o1,o2: TPsObj;
begin
  if not CheckStack([integertypeset,proctypeset,proctypeset]) then exit;
  operandstack.index(0, o0);
  operandstack.index(1, o1);
  operandstack.index(2, o2);
  operandstack.popn(3);
  if o2.i<>0 then psobj_exec(o1, true) else psobj_exec(o0, true);
end;

procedure pso_for;
var o: TPsObj; po: PPsObj; i_ini,i_inc,i_lim,i: integer;
begin
  if not CheckStack([integertypeset,integertypeset,integertypeset,arraytypeset]) then exit;
  operandstack.index(0, o);
  if o.xcheck then with operandstack do begin
    po:=indexp(1); i_lim:=po^.i;
    po:=indexp(2); i_inc:=po^.i;
    po:=indexp(3); i_ini:=po^.i;
    popn(4);

    i:=i_ini;
    while PS.Stat=0 do begin
      if i>i_lim then break;
      push(psobj_int(i));
      psobj_exec(o,true);
      inc(i,i_inc);
    end;
    if PS.Stat=-1 then PS.Stat:=0; {-1: exit}
  end else begin
    PS.Error0('NotExecutedArray in -for-');
  end;
end;

procedure pso_astore;
var o: TPsObj; a: TPsArray; i,acount: integer;
begin
  if not CheckStack([arraytypeset]) then exit;
  operandstack.index(0,o);
  a:=TPsArray(psobj_psobjx(o));
  acount:=a.count;

  if not CheckStackCount(acount+1) then exit;
  operandstack.pop;

  for i:=acount-1 downto 0 do a.Put(acount-1-i, operandstack.indexp(i)^);
  operandstack.popn(acount);
  operandstack.push(o);
end;

procedure pso_aload;
var o: TPsObj; a: TPsArray; i: integer;
begin
  if not CheckStack([arraytypeset]) then exit;
  operandstack.index(0,o);
  a:=TPsArray(psobj_psobjx(o));

  operandstack.pop;

  for i:=0 to a.count-1 do operandstack.push( a.GetP(i)^ );
  operandstack.push(o);
end;

procedure pso_forall;
var o0,o1: TPsObj; d: TPsDict; a: TPsArray; i: integer; s: string;
begin
  if not CheckStackCount(2) then exit;
  operandstack.index(0,o0);
  operandstack.index(1,o1);

  if not CheckStack([arraytypeset]) then exit;
  if not o0.xcheck then begin
    PS.Error0('NotExecutedArray in -forall-');
    exit;
  end;

  if o1.pstype=dicttype then begin

      d:=TPsDict(psobj_psobjx(o1));
      operandstack.popn(2);
      d.forall(o0);
      if PS.Stat=-1 then PS.Stat:=0; {exit}

  end else if o1.pstype=arraytype then begin

    with operandstack do begin
      a:=TPsArray(psobj_psobjx(o1));
      popn(2);

      for i:=0 to a.count-1 do begin
        if PS.Stat<>0 then break;
        push( a.getp(i)^ );
        psobj_exec(o0,true);
      end;
      if PS.Stat=-1 then PS.Stat:=0;
    end;

  end else if o1.pstype=stringtype then begin

    with operandstack do begin
      s:=TPsStr(psobj_psobjx(o1))._;
      popn(2);

      for i:=1 to Length(s) do begin
        if PS.Stat<>0 then break;
        push( psobj_int( Ord(s[i]) ) );
        psobj_exec(o0,true);
      end;
      if PS.Stat=-1 then PS.Stat:=0;
    end;

  end else begin
    PS.Error0('TypeCheck in -forall-');
  end;
end;

procedure pso_repeat;
var o: TPsObj; po: PPsObj; n,i: integer;
begin
  if not CheckStack([integertypeset,arraytypeset]) then exit;
  operandstack.index(0, o);
  if o.xcheck then with operandstack do begin
    po:=indexp(1); n:=po^.i;
    popn(2);

    for i:=1 to n do begin
      if PS.Stat<>0 then break;
      psobj_exec(o,true);
    end;
    if PS.Stat=-1 then PS.Stat:=0;
  end else begin
    PS.Error0('NotExecutedArray in -repeat-');
  end;
end;

procedure pso_loop;
var o: TPsObj;
begin
  if not CheckStack([arraytypeset]) then exit;
  operandstack.index(0, o);
  if o.xcheck then begin
    operandstack.pop;
    while PS.Stat=0 do psobj_exec(o,true);
    if PS.Stat=-1 then PS.Stat:=0;
  end else begin
    PS.Error0('NotExecutedArray in -loop-');
  end;
end;

procedure pso_exit;
begin
  PS.Stat:=-1;
end;

procedure pso_stop;
begin
  PS.Stat:=-2;
end;

procedure pso_quit;
begin
  PS.Stat:=-3;
end;

procedure pso_stopped;
var o: TPsObj;
begin
  if not CheckStackCount(1) then exit;
  operandstack.index(0, o);
  operandstack.pop;

  PS.StoppedContext:=true;
  try
    try
      psobj_exec(o, true);
    except
      if PS.Stat=0 then PS.Stat:=1; {неизвестна€ ошибка}
    end;
  finally
    PS.StoppedContext:=false;
  end;

  if (PS.Stat=-2) or (PS.Stat>0) then begin
    PS.Stat:=0;
    operandstack.push(psobj_bool(true));
  end else begin
    operandstack.push(psobj_bool(false));
  end;
end;

procedure pso_string;
var o: TPsObj;
begin
  if not CheckStack([integertypeset]) then exit;
  with operandstack do begin
    index(0, o);
    pop;
    push(psobj_str(o.i));
  end;
end;

{внутренн€€:}
procedure _pso_search(anchor: boolean);
var o0,o1: TPsObj; s0,subs,pre,post: string; ind,l0,lsubs: integer;
begin
  if not CheckStack([stringtypeset,stringtypeset]) then exit;
  with operandstack do begin
    index(0, o0);
    index(1, o1);
    popn(2);

    s0:=TPsStr(psobj_psobjx(o1))._;
    subs:=TPsStr(psobj_psobjx(o0))._;
    lsubs:=Length(subs);

    if anchor then begin
      if subs=system.copy(s0,1,lsubs) then ind:=1 else ind:=0;
    end else begin
      ind:=system.pos(subs,s0);
    end;

    if ind>0 then begin
      l0:=Length(s0);
      if not anchor then pre:=system.copy(s0,1,ind-1);
      post:=system.copy(s0,ind+lsubs,l0-ind-lsubs+1);

      push(psobj_str_s(post));
      push(o0);
      if not anchor then push(psobj_str_s(pre));
      push(psobj_bool(true));
    end else begin
      push(o1);
      push(psobj_bool(false));
    end;
  end;
end;

procedure pso_anchorsearch;
begin
  _pso_search(true);
end;
procedure pso_search;
begin
  _pso_search(false);
end;

procedure pso_file;
var o,o0,o1: TPsObj; fname, fmode: string;
begin
  if not CheckStack([stringtypeset,stringtypeset]) then exit;
  operandstack.index(0, o0); {fmode}
  operandstack.index(1, o1); {fname}
  fmode:=TPsStr(psobj_psobjx(o0))._;
  fname:=TPsStr(psobj_psobjx(o1))._;
  fname:=psstr2str(fname);
  if psobj_file(fname,fmode,o) then begin
    operandstack.popn(2);
    operandstack.push(o);
  end;
end;

procedure pso_closefile;
var o: TPsObj;
begin
  if not CheckStack([filetypeset]) then exit;
  operandstack.index(0, o);
  operandstack.pop;
  TPsFile(psobj_psobjx(o)).Close;
end;

procedure pso_run;
var f: TPsObj;
begin
  if Ps.Stat<>0 then exit;

  if not CheckStack([stringtypeset]) then exit;
  if not operandstack.push(psobj_str_s('r')) then exit;
  pso_file;
  if Ps.Stat<>0 then exit;

  operandstack.index(0, f);
  pso_cvx;
  try
    pso_exec;
  finally
    TPsFile(psobj_psobjx(f)).Close;
  end;
end;

procedure pso_runlibfile;
var ox: TPsStr; fullname,fname: string;
begin
  if not CheckStack([stringtypeset]) then exit;
  ox:=TPsStr(psobj_psobjx(operandstack.indexp(0)^));   {fname}
  fname:=psstr2str(ox._);
  fullname:=Ps.FindFile(fname);
  if (fullname<>'') then ox._:=str2psstr(fullname); {замена в TPsObjX}

  pso_run;
end;

procedure pso_findlibfile; {name -> path file true || name false}
var
  po: PPsObj; o: TPsObj; oname: TPsStr;
  fname, fullname: string; find_ok: boolean;
begin
  if not CheckStack([stringtypeset]) then exit;
  po:=operandstack.indexp(0);               {fname}
  oname:=TPsStr(psobj_psobjx(po^));
  fname:=psstr2str(oname._);
  fullname:=Ps.FindFile(fname);
  find_ok:=(fullname<>'');

  if find_ok and not psobj_file(fullname,'r',o) then find_ok:=false;

  if find_ok then begin
    oname._:=str2psstr(fullname);            {name->path}
    operandstack.push(o);                    {file}
    operandstack.push(psobj_bool(true))      {true}
  end else begin
    operandstack.push(psobj_bool(false));    {name, false}
  end;
end;

procedure pso_writestring;
var o0,o1: TPsObj; os: TPsStr; ox: TPsFile;
begin
  if not CheckStack([filetypeset, stringtypeset]) then exit;
  operandstack.index(0,o0);      {str}
  os:=TPsStr(psobj_psobjx(o0));
  operandstack.index(1,o1);      {file}
  ox:=TPsFile(psobj_psobjx(o1));
  operandstack.popn(2);
  ox.writestring(os._);
end;

procedure pso_readline;
var o0,o1: TPsObj; os: TPsStr; ox: TPsFile;
begin
  if not CheckStack([filetypeset, stringtypeset]) then exit;
  operandstack.index(0,o0);      {str}
  os:=TPsStr(psobj_psobjx(o0));
  operandstack.index(1,o1);      {file}
  ox:=TPsFile(psobj_psobjx(o1));
  operandstack.popn(2);
  operandstack.push(o0);
  operandstack.push( psobj_bool( ox.readline(os._) ) );
end;

procedure pso_token; {file -> any true || false}
var po: PPsObj; ox: TPsFile;
begin
  if not CheckStack([filetypeset]) then exit;
  po:=operandstack.indexp(0);               {file}
  ox:=TPsFile(psobj_psobjx(po^));

  operandstack.pop;
  if ox.Token then operandstack.push(psobj_bool(true))
  else operandstack.push(psobj_bool(false))
end;

procedure pso_currentfile;
var n: Integer;
begin
  n:=execstack.counttotype(filetype,true);
  if n>=0 then operandstack.push(execstack.indexp(n)^)
  else Ps.Error0('NoCurrentFile');
end;

procedure pso_currentstring;
var n: Integer;
begin
  n:=execstack.counttotype(stringtype,true);
  if n>=0 then operandstack.push(execstack.indexp(n)^)
  else Ps.Error0('NoCurrentString');
end;

procedure pso_not;
var po: PPsObj;
begin
  if not CheckStack([integertypeset]) then exit;
  po:=operandstack.indexp(0);
  if po^.i=0 then po^.i:=1 else po^.i:=0;
end;

{внутренн€€:}
procedure _pso_bool(bool_mode: word); {1=and; 2=or; 3=xor}
var po0,po1: PPsObj; b0,b1: boolean;
begin
  if not CheckStack([integertypeset,integertypeset]) then exit;
  po0:=operandstack.indexp(0);
  po1:=operandstack.indexp(1);
  b0:=(po0^.i<>0);
  b1:=(po1^.i<>0);
  operandstack.popn(2);

  case bool_mode of
    1: operandstack.push( psobj_bool(b0 and b1) );
    2: operandstack.push( psobj_bool(b0 or b1) );
    3: operandstack.push( psobj_bool(b0 xor b1) );
    else begin
      operandstack.push( psobj_bool(false) );
      Tellf('_pso_bool: Unknown bool_mode=%d',[bool_mode]);
    end;
  end;{case}
end;

procedure pso_and;
begin
  _pso_bool(1);
end;
procedure pso_or;
begin
  _pso_bool(2);
end;
procedure pso_xor;
begin
  _pso_bool(3);
end;

procedure pso_eq;
var o0,o1: TPsObj;
begin
  if not CheckStackCount(2) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    popn(2);
    push( psobj_bool(psobj_eq(o0,o1)) ); {o0,o1 мен€ютс€!}
  end;
end;

procedure pso_ne;
var o0,o1: TPsObj;
begin
  if not CheckStackCount(2) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    popn(2);
    push( psobj_bool(not psobj_eq(o0,o1)) ); {o0,o1 мен€ютс€!}
  end;
end;

{внутренн€€:}
procedure _pso_g_l(cmp_mode: word); {1=ge,2=gt,3=le,4=lt}
var o0,o1: TPsObj;
begin
  if not CheckStack([numtypeset,numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    psobj_cvr(o0);
    psobj_cvr(o1);
    popn(2);

    case cmp_mode of  {o0,o1 мен€ютс€!}
      1: push( psobj_bool( o1.r>=o0.r ) );
      2: push( psobj_bool( o1.r>o0.r ) );
      3: push( psobj_bool( o1.r<=o0.r ) );
      4: push( psobj_bool( o1.r<o0.r ) );
      else begin
        push( psobj_bool(false) );
        Tellf('_pso_g_l: Unknown cmp_mode=%d',[cmp_mode]);
      end;
    end;{case}
  end;{with}
end;

procedure pso_ge;
begin
  _pso_g_l(1);
end;
procedure pso_gt;
begin
  _pso_g_l(2);
end;
procedure pso_le;
begin
  _pso_g_l(3);
end;
procedure pso_lt;
begin
  _pso_g_l(4);
end;

procedure pso_add;
var o0,o1,o: TPsObj; intresult: boolean;
begin
  if not CheckStack([numtypeset,numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    popn(2);

    intresult := (o0.pstype=integertype) and (o1.pstype=integertype);
    if intresult then begin
      o:=psobj_int(o0.i+o1.i);
    end else begin
      psobj_cvr(o0);
      psobj_cvr(o1);
      o:=psobj_real(o0.r+o1.r);
    end;

    push(o);
  end;
end;

procedure pso_sub;
var o0,o1,o: TPsObj; intresult: boolean;
begin
  if not CheckStack([numtypeset,numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    popn(2);

    intresult := (o0.pstype=integertype) and (o1.pstype=integertype);
    if intresult then begin
      o:=psobj_int(o1.i-o0.i);
    end else begin
      psobj_cvr(o0);
      psobj_cvr(o1);
      o:=psobj_real(o1.r-o0.r);
    end;

    push(o);
  end;
end;

procedure pso_neg;
var po: PPsObj;
begin
  if not CheckStackCount(1) then exit;
  po:=operandstack.indexp(0);
  case po^.pstype of
    integertype: po^.i:=-po^.i;
    realtype:    po^.r:=-po^.r;
    else         PS.Error0('TypeCheck in -neg-');
  end;
end;

procedure pso_round;
var o: TPsObj;
begin
  if not CheckStack([numtypeset]) then exit;
  operandstack.index(0,o);
  if not psobj_cvr(o) then exit;

  operandstack.pop;
  operandstack.push( psobj_int( Round(o.r) ) );
end;

procedure pso_cos;
var o0,o: TPsObj; a: TPsReal;
begin
  if not CheckStack([numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    psobj_cvr(o0);
    pop;
    a:=(o0.r/180)*system.pi;
    o:=psobj_real( cos(a) );
    push(o);
  end;
end;

procedure pso_sin;
var o0,o: TPsObj; a: TPsReal;
begin
  if not CheckStack([numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    psobj_cvr(o0);
    pop;
    a:=(o0.r/180)*system.pi;
    o:=psobj_real( sin(a) );
    push(o);
  end;
end;

procedure pso_atan;              {y x -> a; tg(a)=y/x}
var x,y: TPsObj; a: TPsReal;
begin
  if not CheckStack([numtypeset,numtypeset]) then exit;
  with operandstack do begin
    index(0,x);
    index(1,y);
    psobj_cvr(x);
    psobj_cvr(y);
    popn(2);

    try
      a:=ArcTan( y.r/x.r );
      if (y.r>0) and (x.r<0) then a:=a+PI;
      if (y.r<0) and (x.r<0) then a:=a-PI;
    except
      if y.r>0 then a:=PI/2 else a:=-PI/2;
    end;

    push(psobj_real(a));
  end;
end;

procedure pso_sqrt;
var o0: TPsObj; r: TPsReal;
begin
  if not CheckStack([numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    psobj_cvr(o0);
    try
      r:=sqrt( o0.r );
      pop;
    except
      PS.Error('MathError in <%f sqrt>',[o0.r]);
      exit;
    end;
    push(psobj_real(r));
  end;
end;

procedure pso_exp;
var o0,o1,o: TPsObj; r: TPsReal;
begin
  if not CheckStack([numtypeset,numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);

    psobj_cvr(o0);
    psobj_cvr(o1);
    try
      r:=math.power( o1.r, o0.r );
      popn(2);
    except
      PS.Error('MathError in <%f %f exp>',[o1.r, o0.r]);
      exit;
    end;
    o:=psobj_real(r);
    push(o);
  end;
end;

procedure pso_div;
var o0,o1,o: TPsObj; r: TPsReal; i: TPsInt;
begin
  if not CheckStack([numtypeset,numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);

    psobj_cvr(o0);
    psobj_cvr(o1);
    try
      r:=o1.r/o0.r;
      popn(2);
    except
      PS.Error('MathError in <%f %f div>',[o1.r, o0.r]);
      exit;
    end;
    i:=Round(r);
    if i=r then o:=psobj_int(i) else o:=psobj_real(r);
    push(o);
  end;
end;

procedure pso_idiv;
var o0,o1,o: TPsObj; i: TPsInt;
begin
  if not CheckStack([integertypeset,integertypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);

    try
      i := o1.i div o0.i;
      popn(2);
    except
      PS.Error('MathError in <%d %d idiv>',[o1.i, o0.i]);
      exit;
    end;
    o:=psobj_int(i);
    push(o);
  end;
end;

procedure pso_mod;
var o0,o1: TPsObj; i: TPsInt;
begin
  if not CheckStack([integertypeset,integertypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    popn(2);
    i := o1.i mod o0.i;
    push(psobj_int(i));
  end;
end;

procedure pso_mul;
var o0,o1,o: TPsObj; intresult: boolean;
begin
  if not CheckStack([numtypeset,numtypeset]) then exit;
  with operandstack do begin
    index(0,o0);
    index(1,o1);
    popn(2);

    intresult := (o0.pstype=integertype) and (o1.pstype=integertype);
    if intresult then begin
      o:=psobj_int(o1.i*o0.i);
    end else begin
      psobj_cvr(o0);
      psobj_cvr(o1);
      o:=psobj_real(o1.r*o0.r);
    end;

    push(o);
  end;
end;

procedure pso_gsave;
begin
  GState.GSave;
end;

procedure pso_grestore;
begin
  GState.GRestore;
end;

procedure pso_matrix;
var o: TPsObj; a: TPsArray;
begin
  o:=psobj_array(6);
  a:=TPsArray( psobj_psobjx(o) );

  a.Put(0, psobj_real(1) );
  a.Put(1, psobj_real(0) );
  a.Put(2, psobj_real(0) );
  a.Put(3, psobj_real(1) );
  a.Put(4, psobj_real(0) );
  a.Put(5, psobj_real(0) );

  operandstack.push(o)
end;

procedure pso_translate;
var tx,ty: TPsReal; ctm: TMatrix2; m: TMatrix; o: TPsObj;
begin
  if operandstack.IndexP(0)^.pstype in arraytypeset then begin

    if not CheckStack([numtypeset, numtypeset, arraytypeset]) then exit;
    tx:=psobj_asreal( operandstack.IndexP(2)^ );
    ty:=psobj_asreal( operandstack.IndexP(1)^ );
    operandstack.Index(0,o);
    operandstack.popn(3);
    m:=m_translate(tx,ty);
    mat2psmat(@m, @o);
    operandstack.push(o);

  end else begin

    if not CheckStack([numtypeset, numtypeset]) then exit;
    tx:=psobj_asreal( operandstack.IndexP(1)^ );
    ty:=psobj_asreal( operandstack.IndexP(0)^ );
    operandstack.popn(2);
    ctm:=m2_translate(tx,ty);
    GState.Concat(@ctm);

  end;
end;

procedure pso_scale;
var sx,sy: TPsReal; ctm: TMatrix2; m: TMatrix; o: TPsObj;
begin
  if operandstack.IndexP(0)^.pstype in arraytypeset then begin

    if not CheckStack([numtypeset, numtypeset, arraytypeset]) then exit;
    sx:=psobj_asreal( operandstack.IndexP(2)^ );
    sy:=psobj_asreal( operandstack.IndexP(1)^ );
    operandstack.Index(0,o);
    operandstack.popn(3);
    m:=m_scale(sx,sy);
    mat2psmat(@m, @o);
    operandstack.push(o);

  end else begin

    if not CheckStack([numtypeset, numtypeset]) then exit;
    sx:=psobj_asreal( operandstack.IndexP(1)^ );
    sy:=psobj_asreal( operandstack.IndexP(0)^ );
    operandstack.popn(2);
    ctm:=m2_scale(sx,sy);
    GState.Concat(@ctm);

  end;
end;

procedure pso_rotate;
var a: TPsReal; ctm: TMatrix2; m: TMatrix; o: TPsObj;
begin
  if operandstack.IndexP(0)^.pstype in arraytypeset then begin

    if not CheckStack([numtypeset, arraytypeset]) then exit;
    a:=psobj_asreal( operandstack.IndexP(1)^ );
    operandstack.Index(0,o);
    operandstack.popn(2);
    m:=m_rotate(a);
    mat2psmat(@m, @o);
    operandstack.push(o);

  end else begin

    if not CheckStack([numtypeset]) then exit;
    a:=psobj_asreal( operandstack.IndexP(0)^ );
    operandstack.pop;
    ctm:=m2_rotate(a);
    GState.Concat(@ctm);

  end;
end;

procedure pso_concat;
var ctm: TMatrix2;
begin
  if not CheckStack([arraytypeset]) then exit;
  psmat2mat( operandstack.indexp(0), @(ctm.m) );

  if m_invert( @(ctm.m), @(ctm.m2) ) then begin
    operandstack.pop;
    GState.Concat(@ctm);
  end;
end;

procedure _pso_transform(mode: integer); {0: dtrans; 1: trans}
var x,y: TPsReal; m: TMatrix;
begin
  if operandstack.IndexP(0)^.pstype in arraytypeset then begin

    if not CheckStack([numtypeset, numtypeset, arraytypeset]) then exit;
    x:=psobj_asreal( operandstack.IndexP(2)^ );
    y:=psobj_asreal( operandstack.IndexP(1)^ );
    psmat2mat( operandstack.IndexP(0), @m );
    operandstack.popn(3);
    m_transform(@m, x, y, mode);

  end else begin

    if not CheckStack([numtypeset, numtypeset]) then exit;
    x:=psobj_asreal( operandstack.IndexP(1)^ );
    y:=psobj_asreal( operandstack.IndexP(0)^ );
    operandstack.popn(2);
    m_transform(@(GState.CTM), x, y, mode);

  end;

  operandstack.push( psobj_real(x) );
  operandstack.push( psobj_real(y) );
end;

procedure pso_transform;
begin
  _pso_transform(1);
end;

procedure pso_dtransform;
begin
  _pso_transform(0);
end;

procedure pso_newpath;
begin
  GState.Path.NewPath;
end;

procedure pso_currentpoint;
begin
  operandstack.push(psobj_real(GState.Position.x));
  operandstack.push(psobj_real(GState.Position.y));
end;

procedure pso_moveto;
var x,y: TPsReal;
begin
  if not CheckStack([numtypeset, numtypeset]) then exit;
  x:=psobj_asreal( operandstack.IndexP(1)^ );
  y:=psobj_asreal( operandstack.IndexP(0)^ );
  operandstack.popn(2);
  GState.Path.moveto( PsPoint(x,y) );
end;

procedure pso_lineto;
var x,y: TPsReal;
begin
  if not CheckStack([numtypeset, numtypeset]) then exit;
  x:=psobj_asreal( operandstack.IndexP(1)^ );
  y:=psobj_asreal( operandstack.IndexP(0)^ );
  operandstack.popn(2);
  GState.Path.lineto( PsPoint(x,y) );
end;

procedure pso_curveto;
var x1,y1,x2,y2,x3,y3: TPsReal;
begin
  if not CheckStack([numtypeset, numtypeset, numtypeset, numtypeset, numtypeset, numtypeset]) then exit;
  x1:=psobj_asreal( operandstack.IndexP(5)^ );
  y1:=psobj_asreal( operandstack.IndexP(4)^ );
  x2:=psobj_asreal( operandstack.IndexP(3)^ );
  y2:=psobj_asreal( operandstack.IndexP(2)^ );
  x3:=psobj_asreal( operandstack.IndexP(1)^ );
  y3:=psobj_asreal( operandstack.IndexP(0)^ );
  operandstack.popn(6);
  GState.Path.curveto( PsPoint(x1,y1), PsPoint(x2,y2), PsPoint(x3,y3) );
end;

procedure pso_closepath;
begin
  GState.Path.ClosePath;
end;

procedure pso_clip;
begin
  with GState do begin
    if Path.Count>0 then ClipPath.CopyFrom(Path);
  end;
end;

procedure pso_save;
var n: integer; o: TPsObj;
begin
{ n:=1; }
  n:=PS.VM.Save;

  if n>=1 then begin
    o:=psobj_int(n);
    o.pstype:=savetype;
    operandstack.push(o);
  end else begin
    PS.Error('Error in -save- (new level=%d)',[n]);
  end;
end;

procedure pso_restore;
var n: integer;
begin
{  operandstack.pop; }

  if not CheckStack([savetypeset]) then exit;
  n:=operandstack.indexp(0)^.ind;
  if PS.VM.Restore(n) then operandstack.pop
  else PS.Error('Error in -restore- (new level=%d)',[n]);
end;


end.
