unit Psstacks;

{$MODE Delphi}

 interface
(*
{$DEFINE STACK_AS_ARRAY}
*)
uses Psarrays, PSOBJ, Psdicts;

type
{$IFDEF STACK_AS_ARRAY}
  TPsStack = class(TPsArray)
{$ELSE}
  TPsStack = class
  private
    FCapacity: integer;
    FCount: integer;
    FMemory: PChar;
{$ENDIF}
  public
    CallCount: array[0..1]of integer; {Push, PopN}
{$IFNDEF STACK_AS_ARRAY}
    constructor Create;
    destructor Destroy; override;
{$ENDIF}
    function Push(o: TPsObj): boolean; virtual;
    function Pop: boolean; virtual;
    function PopN(n: Integer): boolean; virtual;
    function Index(Ind: Integer; var o: TPsObj): boolean;
    function IndexP(Ind: Integer): PPsObj;

    function CountToType(typ: TPsType; xcheck: boolean): Integer; {>=0; не включая искомый}
    function CountToMark(xcheck: boolean): Integer; {>=0; не включая искомый}

{$IFDEF STACK_AS_ARRAY}
    function Print: string; override;
{$ELSE}
    function GetP(Ind: Integer): PPsObj;
    function Print: string;
    procedure SetCount(NewCount: integer);

    property Count: integer read FCount write SetCount;
{$ENDIF}
  end;

  TOperandStack = class(TPsStack)
    function Push(o: TPsObj): boolean; override; {overflow}
    function PopN(n: Integer): boolean; override; {underflow}
  end;

  TExecStack = class(TPsStack)
    function Push(o: TPsObj): boolean; override; {overflow}
    function PopN(n: Integer): boolean; override; {underflow}
  end;

  TNameStack = class(TPsStack)
    function Push(o: TPsObj): boolean; override; {overflow}
    function PopN(n: Integer): boolean; override; {underflow}
    function CurrentName: string;
  end;

  TDictStack = class(TPsStack)
    function Push(o: TPsObj): boolean; override;
    function PopN(n: Integer): boolean; override; {Count>=3}
    function Find(Key: Integer; var d, o: TPsObj): boolean;
    function currentdict: TPsDict;    
  end;


var
  operandstack: TOperandStack;
  dictstack: TDictStack;
  execstack: TExecStack;
  namestack: TPsStack;

implementation

uses
  SysUtils,
  Wcmn, PSOBJX, Pso, PSX;

{TPsStack:}

{$IFNDEF STACK_AS_ARRAY}
constructor TPsStack.Create;
begin
  inherited Create;

end;

destructor TPsStack.Destroy;
begin
  ReallocMem(FMemory,0); {"FreeMem"}
  inherited Destroy;
end;
{$ENDIF}

{$IFNDEF STACK_AS_ARRAY}
procedure TPsStack.SetCount(NewCount: integer);
begin
  if NewCount>FCapacity then begin
    FCapacity:=NewCount;
    inc(FCapacity, PsArrayDelta);    {Push}
    try
      ReAllocMem(FMemory, FCapacity*PsObjSize);  {not set to 0}
    except
      Tell('TPsStack: Недостаточно памяти.');
      exit;
    end;
  end;
  FCount:=NewCount;
end;
{$ENDIF}

function TPsStack.Push(o: TPsObj): boolean;
begin
  inc( CallCount[0] );
{$IFDEF STACK_AS_ARRAY}
  Result:=(_.Add(o)>=0);
{$ELSE}
  Result:=true;
  SetCount(FCount+1);
  StrMove(FMemory+(FCount-1)*PsObjSize, @o, PsObjSize);
  {System.Move(o, (FMemory+(FCount-1)*PsObjSize)^, PsObjSize);}
{$ENDIF}
end;

function TPsStack.Pop: boolean;
begin
  Result:=PopN(1);
end;

function TPsStack.PopN(n: Integer): boolean;
begin
  inc( CallCount[1] );
{$IFDEF STACK_AS_ARRAY}
  if _.Count>=n then begin _.Count:=_.Count-n; Result:=true; end
  else Result:=false;
{$ELSE}
  if FCount>=n then begin SetCount(FCount-n); Result:=true; end
  else Result:=false;
{$ENDIF}
end;

function TPsStack.Index(Ind: Integer; var o: TPsObj): boolean;
begin
{$IFDEF STACK_AS_ARRAY}
  Result:=_.Get(Count-1-Ind,o);
{$ELSE}
  Result:=true;
  if Ind<FCount then
    StrMove(@o, FMemory+(FCount-1-Ind)*PsObjSize, PsObjSize)
    {System.Move((FMemory+(FCount-1-Ind)*PsObjSize)^, o, PsObjSize)}
  else
    Result:=false;
{$ENDIF}
end;

function TPsStack.IndexP(Ind: Integer): PPsObj;
begin
{$IFDEF STACK_AS_ARRAY}
  Result:=GetP(Count-1-Ind);
{$ELSE}
  Result:=PPsObj( FMemory+(FCount-1-Ind)*PsObjSize );
{$ENDIF}
end;

{$IFNDEF STACK_AS_ARRAY}
function TPsStack.GetP(Ind: Integer): PPsObj;
begin
  Result:=PPsObj( FMemory+Ind*PsObjSize );
end;
{$ENDIF}

function TPsStack.Print: string;
var o: TPsObj; i: Integer;
begin
  Result:='';
  for i:=0 to Count-1 do begin
    Index(i,o);
    if i>0 then Result:=Result+_EOL_;
    Result:=Result+psobj_print(o);
  end;
end;

function TPsStack.CountToType(typ: TPsType; xcheck: boolean): Integer;
var i,n: integer; o: TPsObj;
begin
  Result:=-1;
  n:=0;
  for i:=0 to Count-1 do begin
    Index(i,o);
    if (o.pstype=typ) and (o.xcheck=xcheck) then begin Result:=n; exit; end;
    inc(n);
  end;
end;

function TPsStack.CountToMark(xcheck: boolean): Integer;
begin
  Result:=CountToType(marktype,xcheck);
end;

{TOperandStack:}

function TOperandStack.PopN(n: Integer): boolean;
begin
  Result := inherited PopN(n);
  if not Result then Ps.Error0('OperandStackUnderflow');
end;

function TOperandStack.Push(o: TPsObj): boolean;
begin
  Result := inherited Push(o);
  if not Result then Ps.Error0('OperandStackOverflow');
end;

{TExecStack:}

function TExecStack.PopN(n: Integer): boolean;
begin
  Result := inherited PopN(n);
  if not Result then Ps.Error0('ExecStackUnderflow');
end;

function TExecStack.Push(o: TPsObj): boolean;
begin
  Result := inherited Push(o);
  if not Result then Ps.Error0('ExecStackOverflow');
end;

{TNameStack:}

function TNameStack.PopN(n: Integer): boolean;
begin
  Result := inherited PopN(n);
  if not Result then Ps.Error0('NameStackUnderflow');
end;

function TNameStack.Push(o: TPsObj): boolean;
begin
  Result := inherited Push(o);
  if not Result then Ps.Error0('NameStackOverflow');
end;

function TNameStack.CurrentName: string;
var po: PPsObj;
begin
  po:=IndexP(0);
  if (po<>nil) and (po^.pstype=nametype) then Result:=Ps.Names.Name(po^.key)
  else Result:='';
end;


{TDictStack:}

function TDictStack.PopN(n: Integer): boolean; {Count>=3}
begin
  if Count>=n+3 then begin Result := inherited PopN(n); end
  else begin Result:=false; Ps.Error0('DictStackUnderflow'); end;
end;

function TDictStack.Push(o: TPsObj): boolean;
begin
  Result := inherited Push(o);
  if not Result then begin Ps.Error0('DictStackOverflow'); exit; end;
{$IFDEF KEY_INDEX}
  TPsDict(psobj_psobjx(o)).KeyIndexCreate;
{$ENDIF}
end;

function TDictStack.Find(Key: Integer; var d, o: TPsObj): boolean;
var i,j: Integer; dx: TPsDict;
begin
  Result:=false;
  for i:=0 to Count-1 do begin
    Index(i,d);
    TPsObjX(dx):=psobj_psobjx(d);
    if not dx.Value(Key,o,j) then continue;
    Result:=true;
    break;
  end;
end;

function TDictStack.currentdict: TPsDict;
var o: TPsObj;
begin
  index(0,o);
  Result:=TPsDict( psobj_psobjx(o) );
end;

end.
