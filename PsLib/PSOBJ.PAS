unit PSOBJ;

{$MODE Delphi}

 interface

uses PSOBJX;

var PsObjSize: integer;

type
  TPsInt = Integer;
  TPsReal = Real;
  TPsOp = procedure;

  TPsType = (
  {SIMPLE:}
    nulltype,      {=0 !!!}
    marktype,
    booleantype, integertype, realtype,
    savetype,
    fonttype, {fontID}

    nametype, operatortype,

    {COMPOSITE (VM):}
    stringtype,                 {FIRST composite !!!}
    arraytype, packedarraytype,
    dicttype,

    filetype,
    gstatetype,

    conditiontype, {DispPS}
    locktype {DispPS}
);

  TPsTypeSet = set of TPsType;

const
  anytypeset: TPsTypeSet = [];

  integertypeset: TPsTypeSet = [ integertype, booleantype ];
  numtypeset: TPsTypeSet = [ integertype, realtype, booleantype ];

  nametypeset: TPsTypeSet = [ nametype ];
  stringtypeset: TPsTypeSet = [ stringtype ];
  stringabletypeset: TPsTypeSet = [ stringtype, nametype ];
  filetypeset: TPsTypeSet = [ filetype ];

  arraytypeset: TPsTypeSet = [ arraytype, packedarraytype ];
  dicttypeset: TPsTypeSet = [ dicttype ];

  proctypeset: TPsTypeSet = [ arraytype, packedarraytype, nametype, operatortype ];

  savetypeset: TPsTypeSet = [ savetype ];
type
  PPsObj = ^TPsObj;
  TPsObj = record
    namekey: Integer; {XXX}
    pstype: TPsType;
    xcheck: boolean;
    global: boolean;
    case Integer of
    0: (key: Integer);   {name}
    1: (vmi: Integer);   {composite}
    2: (ind: Integer);   {save,font}
    3: (i: TPsInt);    {int,bool}
    4: (r: TPsReal);   {real}
    5: (op: TPsOp);    {operator}
  end;

function sPsType(typ: TPsType): string;
function psobj_type(po: PPsObj): string;

function psobj_vm(o: TPsObj): boolean;
function psobj_psobjx(o: TPsObj): TPsObjX;
function psobj_exec(o: TPsObj; execarray: boolean): boolean;
function psobj_createcopy(o: TPsObj): TPsObj;

function psobj_print(o: TPsObj): string;
function psobj_cvs(o: TPsObj): string;
function psobj_AsString(o: TPsObj): string;
function psobj_AsReal(o: TPsObj): TPsReal;
function psobj_AsInt(o: TPsObj): TPsInt;

function psobj_cvi(var o: TPsObj): boolean;
function psobj_cvr(var o: TPsObj): boolean;
function psobj_eq(o,o2: TPsObj): boolean;

function psobj_null: TPsObj;
function psobj_mark: TPsObj;
function psobj_bool(b: boolean): TPsObj;
function psobj_int(i: TPsInt): TPsObj;
function psobj_real(r: TPsReal): TPsObj;

function psobj_str(len: integer): TPsObj;
function psobj_str_s(s: string): TPsObj;
function psobj_name(s: string): TPsObj;
function psobj_name_x(s: string): TPsObj;
function psobj_op(op: TPsOp): TPsObj;

function psobj_array(aSize: Integer): TPsObj;
function psobj_dict: TPsObj;
function psobj_file(fname,fmode: string; var o: TPsObj): boolean;

procedure psobj_checkoperators(po: PPsObj);


implementation

uses SysUtils, Classes,
  Wcmn, Psstacks, PSVMS, Psdicts, PSNAMES, Psarrays, PSFILES,
  Pso, PSX;

function sPsType(typ: TPsType): string;
begin
  case typ of
    nulltype:     Result:='nulltype';
    marktype:     Result:='marktype';
    booleantype:  Result:='booleantype';
    integertype:  Result:='integertype';
    realtype:     Result:='realtype';
    savetype:     Result:='savetype';
    fonttype:     Result:='fonttype';
    nametype:     Result:='nametype';
    operatortype: Result:='operatortype';
    stringtype:   Result:='stringtype';
    arraytype:    Result:='arraytype';
    packedarraytype: Result:='packedarraytype';
    dicttype:     Result:='dicttype';
    filetype:     Result:='filetype';
    gstatetype:   Result:='gstatetype';
    else          Result:='unknowntype';
  end;{case}
end;

function psobj_type(po: PPsObj): string;
begin
  Result:=sPsType(po^.pstype);
end;

function psobj_vm(o: TPsObj): boolean;
begin
  Result := ( Ord(o.pstype)>=Ord(stringtype) );
end;

function psobj_psobjx(o: TPsObj): TPsObjX;
begin
  Result:=Ps.Vm.Get(o.vmi, o.global);
end;

function psobj_exec(o: TPsObj; execarray: boolean): boolean;
var ox: TPsObjX; done: boolean; d, o2: TPsObj;
begin
  done:=false;
  Result:=false;
  if Ps.Stat<>0 then exit;

  if o.xcheck then begin

    {x-array: - execstack}
    if not done and (o.pstype in arraytypeset) and execarray then begin
      if not execstack.push(o) then exit;
      try
        ox:=psobj_psobjx(o);
        Result:=ox.Exec;
      finally
        execstack.pop;
      end;
      done:=true;
    end;

    {x-string, x-file: - execstack}
    if not done and ( (o.pstype=stringtype) or (o.pstype=filetype) ) then begin
      if not execstack.push(o) then exit;
      try
        ox:=psobj_psobjx(o);
        Result:=ox.Exec;
      finally
        execstack.pop;
      end;
      done:=true;
    end;

    {x-name:}
    if not done and (o.pstype=nametype) then begin
(*
    {DEBUG: StopOn:}
    if PS.Names.Name(o.key)='def' then begin
      done:=true;
    end;
*)
      if dictstack.Find(o.key,d,o2) then begin
        if not namestack.push(o) then exit;

        try
          Result:=psobj_exec(o2,true); {recursion}
        finally
          namestack.pop;
        end;

        done:=true;
      end else begin
        Result:=false;
        done:=true;
        Ps.Error('Executable name "%s" not found',[Ps.Names.Name(o.key)]);
      end;
    end;

    {x-operator:}
    if not done and (o.pstype=operatortype) then begin
      if not namestack.push(o) then exit;
      try
        o.op;  {procedure!}
      finally
        namestack.pop;
      end;
      Result:=(Ps.Stat<=0);
      done:=true;
    end;

    {x-null:}
    if not done and (o.pstype=nulltype) then begin
      Result:=(Ps.Stat<=0);
      done:=true;
    end;

  end;{if o.xcheck}

  if not done then Result:=operandstack.Push(o); {default}
end;

function psobj_createcopy(o: TPsObj): TPsObj;
begin
  memcpy(@Result, @o, PsObjSize);
end;

function psobj_print(o: TPsObj): string;
var ox: TPsObjX; bracket: array[0..1]of char;
begin
  if psobj_vm(o) then ox:=psobj_psobjx(o) else ox:=nil;
  if o.xcheck then begin bracket[0]:='{'; bracket[1]:='}'; end
  else begin bracket[0]:='['; bracket[1]:=']'; end;

  case o.pstype of
    nulltype:     Result:='null';
    marktype:     if o.xcheck then Result:='{'
                  else Result:='[';
    booleantype:  Result:=bool_str[o.i];
    integertype:  Result:=IntToStr(o.i);
    realtype:     Result:=Format('%.2f',[o.r]);
    savetype:     Result:=Format('<save%d>',[o.ind]);
    fonttype:     Result:=Format('<font%d>',[o.ind]);
    nametype:     if o.xcheck then Result:=Ps.Names.Name(o.key)
                  else Result:='/'+Ps.Names.Name(o.key);
    operatortype: {Result:='operator';}
                  Result:='-'+Ps.Names.Name(o.namekey)+'-';  {XXX}
  {COMPOSITE (VM):}
    stringtype:   Result:='('+ox.print+')';
    arraytype:    Result:=bracket[0]+ox.print+bracket[1];
    {packedarraytype,}
    dicttype:     Result:='<<'+ox.print+'>>';
    filetype:     Result:=Format('<file=%s>',[ox.print]);
    {gstatetype:}
    else          Result:='unknowntype';
  end;{case}
end;

function psobj_cvs(o: TPsObj): string;
begin
  case o.pstype of
    booleantype:  Result:=bool_str[o.i];
    integertype:  Result:=IntToStr(o.i);
    realtype:     Result:=Format('%.2f',[o.r]);
    nametype:     Result:=Ps.Names.Name(o.key);
    operatortype: Result:=Ps.Names.Name(o.namekey);  {XXX}
    stringtype:   Result:=TPsStr(psobj_psobjx(o))._;
    else          Result:='--nostringval--';
  end;{case}
end;

function psobj_AsString(o: TPsObj): string;
begin
  Result:='';
  case o.pstype of
    stringtype: Result:=TPsStr(psobj_psobjx(o))._;
    nametype: Result:=Ps.Names.Name(o.key);
  end;
end;

function psobj_AsReal(o: TPsObj): TPsReal;
begin
  if psobj_cvr(o) then Result:=o.r else Result:=0;
end;

function psobj_AsInt(o: TPsObj): TPsInt;
begin
  if psobj_cvi(o) then Result:=o.i else Result:=0;
end;

function psobj_cvi(var o: TPsObj): boolean;
begin
  Result:=true;
  case o.pstype of
    realtype: o.i:=Round(o.r);
    integertype,
    booleantype: ;
    else Result:=false; {o.i не меняется! (pso_cvi)}
  end;
  if Result then o.pstype:=integertype;
end;

function psobj_cvr(var o: TPsObj): boolean;
begin
  Result:=true;
  case o.pstype of
    realtype: ;
    integertype,
    booleantype: begin o.pstype:=realtype; o.r:=o.i; end;
    else Result:=false;
  end;
end;

function psobj_eq(o,o2: TPsObj): boolean;
begin
  Result:=false;

  if (o.pstype in numtypeset) and (o2.pstype in numtypeset) then begin
    psobj_cvr(o);
    psobj_cvr(o2);
    Result:=(o.r=o2.r);
    exit;
  end;

  if (o.pstype in stringabletypeset) and (o2.pstype in stringabletypeset) then begin
    Result := ( psobj_asstring(o)=psobj_asstring(o2) );
    exit;
  end;

  if o.pstype<>o2.pstype then exit;

  case o.pstype of
    nulltype, marktype: Result:=true;
    savetype, fonttype: Result:=(o.ind=o2.ind);
    operatortype:       Result:=(o.namekey=o2.namekey);
  end;

  if not (psobj_vm(o) and psobj_vm(o2)) then exit;
  Result := (o.vmi=o2.vmi) and (o.global=o2.global);
end;

{creation new objects:}

function psobj_null: TPsObj;
begin
  FillChar(Result,PsObjSize,0);
  {Result.pstype:=nulltype;}    {=0}
  Result.Global:=Ps.VM.Global;
end;

function psobj_mark: TPsObj;
begin
  Result:=psobj_null;
  Result.pstype:=marktype;
end;

function psobj_bool(b: boolean): TPsObj;
begin
  Result:=psobj_null;
  Result.pstype:=booleantype;
  Result.i:=bool2int(b);
end;

function psobj_int(i: TPsInt): TPsObj;
begin
  Result:=psobj_null;
  Result.pstype:=integertype;
  Result.i:=i;
end;

function psobj_real(r: TPsReal): TPsObj;
begin
  Result:=psobj_null;
  Result.pstype:=realtype;
  Result.r:=r;
end;

function psobj_str(len: integer): TPsObj;
var pss: TPsStr;
begin
  Result:=psobj_null;
  Result.pstype:=stringtype;
  pss:=TPsStr.Create;
  SetLength(pss._,len);
  if len>0 then FillChar(pss._[1],len,32);
  Result.vmi:=Ps.VM.Add(pss);
end;

function psobj_str_s(s: string): TPsObj;
var pss: TPsStr;
begin
  Result:=psobj_null;
  Result.pstype:=stringtype;
  pss:=TPsStr.Create;
  pss._:=s;
  Result.vmi:=Ps.VM.Add(pss);
end;

function psobj_name(s: string): TPsObj;
begin
  Result:=psobj_null;
  Result.pstype:=nametype;
  Result.key:=Ps.Names.Key(s);
  Result.namekey:=Result.key;
end;

function psobj_name_x(s: string): TPsObj;
begin
  Result:=psobj_name(s);
  Result.xcheck:=true;
end;

function psobj_op(op: TPsOp): TPsObj;
begin
  Result:=psobj_null;
  Result.pstype:=operatortype;
  Result.xcheck:=true;
  Result.op:=op;
end;

function psobj_array(aSize: Integer): TPsObj;
var ox: TPsArray;
begin
  Result:=psobj_null;
  Result.pstype:=arraytype;
  ox:=TPsArray.Create;
  if aSize>0 then ox.Count:=aSize;
  Result.vmi:=Ps.VM.Add(ox);
end;

function psobj_dict: TPsObj;
begin
  Result:=psobj_null;
  Result.pstype:=dicttype;
  Result.vmi:=Ps.VM.Add(TPsDict.Create);
end;

function psobj_file(fname,fmode: string; var o: TPsObj): boolean;
var f: TPsFile; mode: word; FGlobal: boolean;
begin
  Result:=false;
  case fmode[1] of
    'r': mode := fmOpenRead or fmShareDenyNone;
    'w': mode := fmCreate or fmShareDenyNone;
    else begin
      Ps.Error('Unknown file mode (%s)',[fmode]);
      exit;
    end;
  end;

  f:=TPsFile.Create;
  if f.Open(fname, mode) then begin
    FGlobal:=Ps.Vm.Global;{save}
    Ps.Vm.Global:=true;

    o:=psobj_null;{=> Global}
    o.pstype:=filetype;
    o.vmi:=Ps.VM.Add(f);

    Ps.Vm.Global:=FGlobal;{restore}
    Result:=true;
  end else begin
    f.Free;
    Ps.Error('Unable open file (%s) in mode (%s)',[fname,fmode]);
  end;
end;

procedure psobj_checkoperators(po: PPsObj);
var o: TPsObj; j: integer;
begin
  if po^.pstype=operatortype then begin

    {новый адрес проседуры:}
    if not systemdict.value(po^.namekey,o,j)
    then Tellf('psobj_checkoperators:\nоператор -%s- не найден',[PS.Names.Name(po^.namekey)])
    else po^.op:=o.op;

  end else if psobj_vm(po^) then begin
    psobj_psobjx(po^).CheckOperators;
  end;
end;


initialization
  PsObjSize:=sizeof(TPsObj);

end.
