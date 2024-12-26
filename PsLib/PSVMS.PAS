unit psvms; interface

uses classes, list, psobjx;

const
  PsVMDelta = 512;

type
  TPsVM = class
  private
    FVMG: TClassList;
    FVML_List: TClassList;
    FGlobal: boolean;
    function VML: TClassList;
    function VM: TClassList;
  public
    constructor Create;
    destructor Destroy; override;

    {Save возвращает old FVML_List.Count>=1 || -1}
    function Save: integer;
    {Restore принимает new FVML_List.Count>=1}
    function Restore(aSaveLevel: Integer): boolean;

    function Add(o: TPsObjX): Integer;
    function Get(Ind: Integer; aGlobal: boolean): TPsObjX;

    {SaveToStream сохраняет VML[0]}
    procedure SaveToStream(st: TStream);
    procedure LoadFromStream(st: TStream);
    procedure CheckOperators;

    property Global: boolean read FGlobal write FGlobal;
  end;


implementation

uses wcmn, psstacks, psobj, psarrays, psdicts, psfiles;

{Private:}

function TPsVM.VML: TClassList;
begin
  TObject(Result):=FVML_List[FVML_List.Count-1];
  if Result=nil then Tell('ERROR: TPsVM.VML');
end;

function TPsVM.VM: TClassList;
begin
  if FGlobal then Result:=FVMG
  else Result:=VML;
  if Result=nil then Tell('ERROR: TPsVM.VM');
end;

{Public:}

constructor TPsVM.Create;
begin
  FVMG:=TClassList.Create(PsVMDelta);
  FVML_List:=TClassList.Create(16);
  FVML_List[0]:=TClassList.Create(PsVMDelta);
end;

destructor TPsVM.Destroy;
begin
  FVMG.Free;
  FVML_List.Free;{=>Items Free}
end;

function TPsVM.Save: integer;
var i,n: Integer; vm0,vm1: TClassList; ox,ox2: TPsObjX;
begin
  Result:=-1;
  vm0:=VML;
  if vm0=nil then begin Tell('ERROR: TPsVM.Save'); exit; end;

  try
    vm1:=TClassList.Create(PsVMDelta);
    FVML_List.Add(vm1);
    n:=vm0.Count;
    vm1.count:=n;
    if n>0 then for i:=0 to n-1 do begin
      TObject(ox):=vm0[i];
      try
        ox2:=ox.CreateCopy;
        vm1.put(i,ox2);
      except ;
      end;
    end;
  except
    exit;
  end;

  Result:=FVML_List.Count-1; {1 после первого save}
end;

function TPsVM.Restore(aSaveLevel: Integer): boolean;

  function CheckStack(st: TPsStack): boolean;
  var i: integer; o: TPsObj;
  begin
    Result:=false;
    if st.Count>0 then for i:=0 to st.Count-1 do begin
      st.Index(i,o);
      if not psobj_vm(o) then continue;
      if Get(o.vmi,o.global)=nil then exit;
    end;
    Result:=true;
  end;

begin
  Result:=false;
  if (aSaveLevel>=FVML_List.Count) or (aSaveLevel<=0) then exit;

  if CheckStack(operandstack) and CheckStack(dictstack) and CheckStack(execstack) then
  begin
    FVML_List.Count:=aSaveLevel;
    Result:=true;
  end;
end;

function TPsVM.Add(o: TPsObjX): Integer;
begin
  Result:=VM.Add(o);
end;

function TPsVM.Get(Ind: Integer; aGlobal: boolean): TPsObjX;
begin
  if aGlobal then TObject(Result):=FVMG[Ind]
  else TObject(Result):=VML[Ind];
end;

procedure TPsVM.SaveToStream(st: TStream);
var lst: TClassList;

  procedure _SaveNull;
  var i: integer;
  begin
    i:=0;
    st.write(i, sizeof(i));
  end;

  procedure _SaveLst;
  var i: integer; ox: TPsObjX;
  begin
    i:=lst.count;
    st.write(i, sizeof(i));

    for i:=0 to lst.count-1 do begin
      ox:=TPsObjX(lst[i]);
      if ox=nil then _SaveNull;
      try
        ox.SaveToStream(st);
      except
        _SaveNull;
      end;
    end;
  end;

begin
  lst:=FVMG; _SaveLst;
  lst:=TClassList( FVML_List[FVML_List.Count-1] ); _SaveLst; {последний}
end;


procedure TPsVM.LoadFromStream(st: TStream);
var lst: TClassList;

  procedure _LoadLst;
  var i,l,t: integer; ox: TPsObjX;
  begin
    st.Read(l,sizeof(l));

    lst.Count:=l;
    if l>0 then for i:=0 to l-1 do begin
      st.Read(t, sizeof(t));

      case tpstype(t) of
        nulltype:   ox:=nil;
        stringtype: ox:=TPsStr.Create;
        arraytype:  ox:=TPsArray.Create;
        dicttype:   ox:=TPsDict.Create;
        filetype:   ox:=TPsFile.Create;
        else        begin
                      ox:=nil;
                      Tellf('TPsVM.LoadFromStream:\nНеизвестный тип %d',[t]);
                    end;
      end;{case}

      if ox<>nil then ox.LoadFromStream(st);
      lst[i]:=ox;
    end;
  end;

begin
  FVMG.Count:=0;
  FVML_List.Count:=1;
  TClassList(FVML_List[0]).Count:=0;

  lst:=FVMG; _LoadLst;
  lst:=TClassList(FVML_List[0]); _LoadLst;
end;

procedure TPsVM.CheckOperators;
var lst: TClassList;

  procedure _CheckLst;
  var i: integer;
  begin
    for i:=0 to lst.count-1 do TPsObjX(lst[i]).CheckOperators;
  end;

begin
  lst:=FVMG; _CheckLst;
  lst:=TClassList(FVML_List[0]); _CheckLst;
end;


end.
