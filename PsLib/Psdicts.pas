unit Psdicts;

{$MODE Delphi}

 interface
(*
{$DEFINE SORTED_DICT}
*)

uses
  classes,
  Arrayx, PSOBJ, PSOBJX;

const PsDictDelta = 32;
var PsDictItemSize: integer;

type
  PDictItem = ^TDictItem;
  TDictItem = record
    key: Integer;
    val: TPsObj;
  end;

  PPsDict = ^TPsDict;
  TPsDict = class(TPsObjX)
  protected
    _: TArray;//of TDictItem
    {$IFDEF KEY_INDEX}
    FKeyNum: TIntArray; {Num>0, Num=Ind+1}
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    function GetP(i: Integer): PDictItem;
    function Put(i: Integer; Item: TDictItem): boolean;
    function Insert(i: Integer; Item: TDictItem): boolean;
    function Exec: boolean; override;
    function CreateCopy: TPsObjX; override;
    function PrintItem(Item: TDictItem): string;
    function Print: string; override;
    procedure SaveToStream(st: TStream); override;
    procedure LoadFromStream(st: TStream); override;
    procedure CheckOperators; override;
    {$IFDEF KEY_INDEX}
    procedure KeyIndexCreate;
    procedure KeyIndexFree;
    {$ENDIF}
    function Value(Key: Integer; var o: TPsObj; var i: Integer): boolean;
    function Def(Key: Integer; Val: TPsObj): boolean;
    function DefS(name: string; Val: TPsObj): boolean;
    function Count: Integer;

    function ItemName(i: integer): string;
    procedure ForAll(proc: tpsobj);

    //DEBUG:
    function View(sname: string): string;
  end;


function systemdict: TPsDict;
function globaldict: TPsDict;
function userdict: TPsDict;
function currentdict: TPsDict;

implementation

uses Wcmn, Psstacks, PSNAMES, PSLOGS, Pso, PSX;

function _DictItem(Key: Integer; Val: TPsObj): TDictItem;
begin
  Result.Key:=Key;
  Result.Val:=Val;
end;


function systemdict: TPsDict;
var po: PPsObj;
begin
  po:=dictstack.GetP(0);
  TPsObjX(Result):=psobj_psobjx(po^);
end;

function globaldict: TPsDict;
var po: PPsObj;
begin
  po:=dictstack.GetP(1);
  TPsObjX(Result):=psobj_psobjx(po^);
end;

function userdict: TPsDict;
var po: PPsObj;
begin
  po:=dictstack.GetP(1);
  TPsObjX(Result):=psobj_psobjx(po^);
end;

function currentdict: TPsDict;
var o: TPsObj;
begin
  dictstack.Index(0,o);
  TPsObjX(Result):=psobj_psobjx(o);
end;


{Private:}

{Public:}

constructor TPsDict.Create;
begin
  inherited Create;
  _:=TArray.Create(PsDictItemSize, PsDictDelta);
end;

destructor TPsDict.Destroy;
begin
  _.Free;
  {$IFDEF KEY_INDEX}
  FKeyNum.Free;
  {$ENDIF}
  inherited Destroy;
end;

procedure TPsDict.Clear;
begin
//  _.Free;
  _.Clear;
end;

function TPsDict.GetP(i: Integer): PDictItem;
begin
  Result:=_.GetP(i);
end;

function TPsDict.Put(i: Integer; Item: TDictItem): boolean;
begin
  Result:=true;
  try
    _.Put(i,Item);
  except
    Result:=false;
  end;
end;

function TPsDict.Insert(i: Integer; Item: TDictItem): boolean;
begin
  Result:=true;
  try
    _.Insert(i,Item);
  except
    Result:=false;
  end;
end;

function TPsDict.Exec: boolean;
begin
  Tell('ERROR: CALL "TPsDict.Exec"');
  Result:=false;
end;

function TPsDict.CreateCopy: TPsObjX;
var d: TPsDict;
begin
  d:=TPsDict.Create;
  d._.Count:=_.Count;
  memcpy(d._.Memory, _.Memory, _.Count*_.ItemSize);
  Result:=d;
end;

function TPsDict.PrintItem(Item: TDictItem): string;
var name: string;
begin
  name:=Ps.Names.Name(Item.Key);
  Result:=name+'='+psobj_print(Item.Val);
end;

function TPsDict.Print: string;
var Item: TDictItem; i: Integer;
begin
  Result:='';
  for i:=0 to _.count-1 do begin
    _.Get(i,Item);
    if i>0 then Result:=Result+' ';
    Result:=Result+PrintItem(Item);
  end;
end;

procedure TPsDict.SaveToStream(st: TStream);
var i,l: integer;
begin
  i:=integer(dicttype); st.Write(i, sizeof(i));
  l:=_.Count; st.Write(l, sizeof(l));
  if l>0 then st.Write(_.Memory^,l*PsDictItemSize);
end;

procedure TPsDict.LoadFromStream(st: TStream);
var l: integer;
begin
  st.Read(l, sizeof(l));
  _.Count:=l;
  if l>0 then st.Read(_.Memory^,l*PsDictItemSize);
end;

procedure TPsDict.CheckOperators;
var i: integer;
begin
  for i:=0 to _.Count-1 do
    psobj_checkoperators(@(GetP(i)^.val));
end;

{$IFDEF KEY_INDEX}
procedure TPsDict.KeyIndexCreate;
var i: integer;
begin
  if FKeyNum<>nil then exit;

  FKeyNum:=TIntArray.Create(0);  {=> 256/4=64}
  FKeyNum.Count:=PS.Names.Count;

  for i:=0 to _.Count-1 do FKeyNum[ GetP(i)^.key ]:=i+1;
end;

procedure TPsDict.KeyIndexFree;
begin
  FKeyNum.Free;
  FKeyNum:=nil;
end;
{$ENDIF}

function TPsDict.Value(Key: Integer; var o: TPsObj; var i: Integer): boolean;
var
  PItem: PDictItem;
{$IFDEF SORTED_DICT}
  di,dir: Integer;
label true_end;
{$ELSE}
  j: integer;
{$ENDIF}
begin
{$IFDEF SORTED_DICT}
  Result:=false;
  i:=_.Count div 2;
  if _.Count=0 then exit;
  di:=i;
  dir:=0;

  repeat
    PItem:=_.GetP(i);
    if PItem^.Key=Key then goto true_end
    else if PItem^.Key<Key then dir:=1 else dir:=-1;
    di:=di div 2;
    inc(i, dir*di);
  until di=0;

  if dir>0 then while PItem^.Key<Key do begin
    inc(i);
    PItem:=_.GetP(i);
    if PItem=nil then exit;
    if PItem^.Key>Key then exit;
    if PItem^.Key=Key then goto true_end;
  end;

  if dir<0 then while PItem^.Key>Key do begin
    dec(i);
    PItem:=_.GetP(i);
    if PItem=nil then begin inc(i); exit; end;
    if PItem^.Key<Key then begin inc(i); exit; end;
    if PItem^.Key=Key then goto true_end;
  end;

  exit;

true_end:
  o:=PItem^.val;
  Result:=true;

{$ELSE}
  Result:=false;
  i:=_.Count; {=>Add !!!}

  {$IFDEF KEY_INDEX}
  if FKeyNum<>nil then begin
    j:=FKeyNum[Key];
    if j>0 then begin
      i:=j-1;
      o:=GetP(i).val;
      Result:=true;
    end;
    exit;
  end;
  {$ENDIF}

  for j:=0 to _.Count-1 do begin
    PItem:=_.GetP(j);
    if (PItem=nil) or (PItem^.Key<>Key) then continue;
    o:=PItem^.val;
    i:=j;
    Result:=true;
    exit;
  end;
{$ENDIF}
end;

function TPsDict.Def(Key: Integer; Val: TPsObj): boolean;
var o: TPsObj; Item: TDictItem; j: Integer;
begin
  if Val.namekey<=0 then Val.namekey:=Key; {XXX}
  Item:=_DictItem(Key,Val);
  if Value(Key,o,j) then begin
    Result:=Put(j,Item);
  end else begin
    if j>=_.Count then begin
      j:=_.Add(Item);
      Result:=(j>=0);
      {$IFDEF KEY_INDEX}
      if Result and (FKeyNum<>nil) then FKeyNum[Key]:=j+1;
      {$ENDIF}
    end else
      Result:=Insert(j,Item);
  end;

  if not Result then
    Ps.Error('/Def: %s=%s',[Ps.Names.Name(Key),psobj_print(Val)]);

{$IFDEF PSLOG}
  PsLog_WL('def> '+PrintItem(Item));
{$ENDIF}
end;

function TPsDict.DefS(name: string; Val: TPsObj): boolean;
begin
  Result:=Def( PS.Names.Key(name), Val);
end;

function TPsDict.Count: Integer;
begin
  Result:=_.Count;
end;


function TPsDict.ItemName(i: integer): string;
var di: tdictitem;
begin
  _.get(i, di);
  Result := PS.Names.Name( di.key );
end;


procedure TPsDict.ForAll(proc: tpsobj);
var i: integer; item: TDictItem;
begin
  for i:=0 to count-1 do begin
    if PS.Stat<>0 then break;
    item:=getp(i)^;
    operandstack.push( psobj_name( Ps.Names.Name(item.key) ) );
    operandstack.push( item.val );
    psobj_exec(proc,true);
  end;
end;


function TPsDict.View(sname: string): string;
var key: integer; o: tpsobj; i: integer;
begin
  Result:='';
  key:=Ps.Names.Key(sname);
  if Value(key,o,i) then Result:=psobj_print(o);
end;


initialization
  PsDictItemSize:=sizeof(TDictItem);

end.
