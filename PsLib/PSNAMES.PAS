unit PSNAMES;

{$MODE Delphi}

 interface

uses classes;

type
  TPsName = class
  private
    FList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function IndexOf(const S: string): Integer;
    function Key(name: string): Integer;
    function Name(Key: Integer): string;
    function Count: integer;
    procedure SetCount(aCount: Integer);
    procedure SaveToStream(st: TStream);
    procedure LoadFromStream(st: TStream);
  end;


implementation

uses Wcmn;

constructor TPsName.Create;
begin
  FList:=TStringList.Create;
end;

destructor TPsName.Destroy;
begin
  FList.Free;
end;

function TPsName.IndexOf(const S: string): Integer;
var i: Integer;
begin
  Result:=-1;
  for i:=0 to FList.Count-1 do begin
    if FList.Strings[i]<>S then continue;
    Result:=i;
    exit;
  end;
end;

function TPsName.Key(name: string): Integer;
begin
  try
    Result:=IndexOf(name);
    if Result=-1 then Result:=FList.Add(name);
  except
    Result:=-1;
    {Tellf('EXCEPTION: TPsName.Key(%s); count=%d',[name,FList.Count]);}
  end;
end;

function TPsName.Name(Key: Integer): string;
begin
  try
    Result:=FList[Key];
  except
    Result:='';
    Tellf('EXCEPTION: TPsName.Name(%d); count=%d',[Key,FList.Count]);
  end;
end;

function TPsName.Count: integer;
begin
  Result:=FList.Count;
end;

procedure TPsName.SetCount(aCount: Integer);
var i: integer;
begin
  if aCount>FList.Count then for i:=1 to aCount-FList.Count do FList.Add('');
  if aCount<FList.Count then for i:=FList.Count-1 downto aCount do FList.Delete(i);
end;

procedure TPsName.SaveToStream(st: TStream);
var i,l,li: integer; s: string;
begin
  l:=FList.Count; st.Write(l, sizeof(l));
  if l>0 then for i:=0 to l-1 do begin
    s:=FList[i];
    li:=Length(s); st.Write(li, sizeof(li));
    if li>0 then st.Write(s[1], li);
  end;
end;

procedure TPsName.LoadFromStream(st: TStream);
var i,l,li: integer; s: string;
begin
  st.Read(l, sizeof(l));
  FList.Clear;
  if l>0 then for i:=0 to l-1 do begin
    st.Read(li, sizeof(li));
    SetLength(s,li);
    if li>0 then st.Read(s[1], li);
    FList.Add(s);
  end;
end;


end.
