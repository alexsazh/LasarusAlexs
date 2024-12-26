unit Psarrays;

{$MODE Delphi}

 interface

uses
  classes,
  Arrayx, PSOBJ, PSOBJX;

const
  PsArrayDelta = 128;


type
  TPsArray = class(TPsObjX)
  protected
    _: TArray;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateCopy: TPsObjX; override;
    function GetObj(Ind: Integer): TPsObj;
    procedure Get(Ind: Integer; var o: TPsObj);
    function GetP(Ind: Integer): PPsObj;
    procedure Put(Ind: Integer; const o: TPsObj);
    procedure Add(const o: TPsObj);
    function GetCount: Integer;
    procedure SetCount(aCount: Integer);
    function Exec: boolean; override;
    function Print: string; override;
    procedure SaveToStream(st: TStream); override;
    procedure LoadFromStream(st: TStream); override;
    procedure CheckOperators; override;
    procedure Bind;
    {
    procedure Tree(TreeView: TTreeView; faser: TTreeNode);
    }
    property Count: Integer read GetCount write SetCount;
    property Items[Ind: Integer]: TPsObj read GetObj write Put; default;
  end;


implementation

uses Wcmn, Psdicts, PSX;

constructor TPsArray.Create;
begin
  inherited Create;
  _:=TArray.Create(PsObjSize, PsArrayDelta);
end;

destructor TPsArray.Destroy;
begin
  _.Free;
  inherited Destroy;
end;

function TPsArray.CreateCopy: TPsObjX;
var a: TPsArray;
begin
  a:=TPsArray.Create;
  a._.Count:=_.Count;
  memcpy(a._.Memory, _.Memory, _.Count*_.ItemSize);
  Result:=a;
end;

procedure TPsArray.Get(Ind: Integer; var o: TPsObj);
begin
  if not _.Get(Ind,o) then o:=psobj_null;
end;

function TPsArray.GetObj(Ind: Integer): TPsObj;
begin
  if not _.Get(Ind,Result) then Result:=psobj_null;
end;

function TPsArray.GetP(Ind: Integer): PPsObj;
begin
  Result:=_.GetP(Ind);
end;

procedure TPsArray.Put(Ind: Integer; const o: TPsObj);
begin
  _.Put(Ind,o);
end;

procedure TPsArray.Add(const o: TPsObj);
begin
  _.Add(o);
end;

function TPsArray.GetCount: Integer;
begin
  Result:=_.Count;
end;

procedure TPsArray.SetCount(aCount: Integer);
begin
  _.Count:=aCount;
end;

function TPsArray.Exec: boolean; {for executed array!}
var i: Integer; o: TPsObj;
begin
  Result:=false;
  if _.Count>0 then for i:=0 to _.Count-1 do begin
    if PS.Stat<>0 then break; {->true}
    if not _.Get(i,o) then exit;
    if not psobj_exec(o, false) then exit;
  end;
  Result:=true;
end;

function TPsArray.Print: string;
var o: TPsObj; i: Integer;
begin
  Result:='';
  for i:=0 to _.count-1 do begin
    _.Get(i,o);
    if i>0 then Result:=Result+' ';
    Result:=Result+psobj_print(o);
  end;
end;

procedure TPsArray.SaveToStream(st: TStream);
var i,l: integer;
begin
  i:=integer(arraytype); st.Write(i, sizeof(i));
  l:=_.Count; st.Write(l, sizeof(l));
  if l>0 then st.Write(_.Memory^,l*PsObjSize);
end;

procedure TPsArray.LoadFromStream(st: TStream);
var l: integer;
begin
  st.Read(l, sizeof(l));
  _.Count:=l;
  if l>0 then st.Read(_.Memory^, l*PsObjSize);
end;

procedure TPsArray.CheckOperators;
var i: integer;
begin
  for i:=0 to _.Count-1 do psobj_checkoperators(GetP(i));
end;

procedure TPsArray.Bind;
var o,o2: TPsObj; i,j: Integer; sysd: TPsDict;
begin
  sysd:=systemdict;
  for i:=0 to _.count-1 do begin
    _.Get(i,o);
    if (o.pstype<>nametype) or not o.xcheck then continue;
    if not sysd.Value(o.key,o2,j) then continue;
    if (o2.pstype<>operatortype) then continue;
    _.Put(i,o2);
  end;
end;

(*
procedure TPsArray.Tree(TreeView: TTreeView; faser: TTreeNode);
var i: integer; s: string; o: TPsObj;
begin
  if Count>0 then for i:=0 to Count-1 do begin
    Get(i,o);
    if
    if o.PsType=PsTypeDict then begin
      TPsDict(o).DrawTreeNode(TreeView,nil);
    end else begin
      s:=o.ToStr;
      TreeView.Items.AddChildObject(faser,s,o);
    end;{if}
  end;
end;
*)

end.
