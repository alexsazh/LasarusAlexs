unit Arrayx;

{$MODE Delphi}

 interface
uses
  Classes, Wcmn;

const DeltaDefault = 128;


Type
  //функция сравнения (p1,p2: указатели на Item, Result>0 <=> Item1>Item2):
  TCmpProc = function(p1,p2: pointer): integer;

  _TIntegerArray = array of integer;

  PArray = ^TArray;
  TArray = class
  private
  protected
    FCapacity: Integer;  //use in AddFrom
    FCount: Integer;
    FDelta: Integer;
    FItemSize: word;
    FTmpItem: PChar;
    FMemory: PChar;
    FModified: boolean;
    procedure FModify; virtual;
    procedure Grow; virtual;                        {inc(Capacity, FDelta)}
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer); virtual;
  public
    Status: Integer;

    constructor Create(aItemSize: word; aDelta: Integer);
    destructor Destroy; override;
    function NextInd(i,di: integer): integer;//mod Count
    function Next(var Item; di: integer): boolean;//mod Count

    function Add(const Item): Integer;
    procedure Clear; virtual;                       {Count=0, Capacity=0}
    procedure Delete(Index: Integer); virtual;      {сдвиг элементов влево}
    procedure DeleteFirst; virtual;            {сдвиг элементов влево; if count=0 - ничего}
    procedure DeleteLast; virtual;
    procedure Exchange(Index1, Index2: Integer);
    function Get(Index: Integer; var Item): boolean;//m.b. Index>=Count (FALSE)
    function GetP(Index: Integer): Pointer;//m.b. Index>=Count (FALSE)
    procedure Put(Index: Integer; const Item);//m.b. Index>=Count (расширение массива!)
    function IndexOf(const Item): Integer;
    function Insert(Index: Integer; const Item): integer; {сдвиг элементов вправо!}
    procedure Move(CurIndex, NewIndex: Integer);     {Delete+Insert}
    function Remove(const Item): Integer;            {IndexOf+Delete}
    procedure Mul(aa: array of TArray);//пересечение набора массивов aa=[a1,a2,...]
    procedure Sort(CmpProc: TCmpProc; ar2: tarray);//по возрастанию; ar2 m.b. nil
    procedure SortByStrings(Strings: TStrings);
    procedure Reverse;
    procedure FillC(c: char);
    procedure AddFrom(a: tarray);//a.ItemSize=ItemSize;

    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Memory: PChar read FMemory;
    property ItemSize: Word read FItemSize;
    property Delta: Integer read FDelta;
    property Modified: boolean read FModified;
  end;

  TIntArray = class( TArray )
  protected
    function Get(Index: Integer): Integer;
    procedure Put(Index: Integer; Item: Integer);
  public
    constructor Create(aDelta: Integer);
    constructor New;
    function Add(i: integer): Integer;
    procedure Sort(ar2: tarray);//по возрастанию
    function First: Integer;
    function Last: Integer;
    procedure Inc(Index: Integer);
    procedure Dec(Index: Integer);
    procedure Fill(i0,di,n: integer);//n=count
    procedure array_of_integer(var A: _TIntegerArray);

    property Items[Index: Integer]: Integer read Get write Put; default;
  end;

  TRelArray = class( TArray )
  protected
    function Get(Index: Integer): TRel;
    procedure Put(Index: Integer; Item: TRel);
  public
    constructor Create(aDelta: Integer);
    constructor New;
    procedure Sort(ar2: tarray);//по возрастанию

    property Items[Index: Integer]: TRel read Get write Put; default;
  end;

  TRelPntArray = class( TArray )
  protected
    function Get(Index: Integer): rpoint;
    procedure Put(Index: Integer; Item: rpoint);
  public
    constructor Create(aDelta: Integer);

    property Items[Index: Integer]: rpoint read Get write Put; default;
  end;


implementation

uses
  SysUtils,
  Nums;

{ TArray methods: }

constructor TArray.Create( aItemSize: word; aDelta: Integer );
begin
  inherited Create;

  if aItemSize>0 then FItemSize := aItemSize
  else FItemSize := 1;                      {default}
  if aDelta>0 then FDelta := aDelta
  else FDelta := maxi(256 div FItemSize, 1); {default}

  FTmpItem := malloc(FItemSize);
  if FTmpItem=nil then Fail;
end;

destructor TArray.Destroy;
begin
  //Clear;
  if FCapacity<>0 then FreeMem(FMemory, FCapacity*FItemSize);
  if Assigned(FTmpItem) then mfree(FTmpItem, FItemSize);
  inherited Destroy;
end;

procedure TArray.FModify;
begin
  FModified:=true;
end;

function TArray.NextInd(i,di: integer): integer;//mod Count
begin
  Result := mymod(i+di, FCount);
end;

function TArray.Next(var Item; di: integer): boolean;//mod Count
var i: integer;
begin
  Result:=true;
  i:=IndexOf(Item);
  if i>=0 then Get(NextInd(i,di), Item) else Result:=false;
end;

function TArray.Add(const Item): Integer;
begin
  Result := FCount;
  if Result >= FCapacity then Grow;
  if Status<>0 then begin Result:=-1; Exit; end;
  memcpy(FMemory+FItemSize*Result, @Item, FItemSize);
  Inc(FCount);
  FModify;
end;

procedure TArray.Clear;
begin
  SetCount(0);//virtual!
  SetCapacity(0);
  FModify;
end;

procedure TArray.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Exit;
  Dec(FCount);
  if Index < FCount then
    memcpy(FMemory+FItemSize*Index, FMemory+FItemSize*(Index+1), (FCount-Index)*FItemSize);
  FModify;
end;

procedure TArray.DeleteFirst;
begin
  Delete(0);
end;

procedure TArray.DeleteLast;
begin
  if FCount<=0 then Exit;
  Dec(FCount);
  FModify;
end;

procedure TArray.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) or
    (Index2 < 0) or (Index2 >= FCount) then Exit;

  Get(Index1, FTmpItem^);
  memcpy(FMemory+FItemSize*Index1, FMemory+FItemSize*Index2, FItemSize);
  Put(Index2, FTmpItem^);
  FModify;
end;

function TArray.Get(Index: Integer; var Item): boolean;
begin
  if (Index < 0) or (Index >= FCount) then begin
    Result := False;
    FillChar(Item, FItemSize, 0);                       //???
  end else begin
    Result := True;
    memcpy(@Item, FMemory+FItemSize*Index, FItemSize);
  end;
end;

function TArray.GetP(Index: Integer): Pointer;
begin
  Result := nil;
  if (Index < 0) or (Index >= FCount) then Exit;
  Result := FMemory+FItemSize*Index;
end;

procedure TArray.Grow;
begin
  SetCapacity(FCapacity + FDelta);
end;

function TArray.IndexOf(const Item): Integer;
begin
  Result := 0;
  while (Result < FCount) do
    if memcmp(FMemory+FItemSize*Result, @Item, FItemSize)<>0 then Inc(Result)
    else break;
  if Result = FCount then Result := -1;
end;

{вставляет на место "Index"}
function TArray.Insert(Index: Integer; const Item): integer;
begin
  Result:=-1;

  if (Index < 0) or (Index > FCount) then Exit;
  if FCount = FCapacity then Grow;
  if Status<>0 then Exit;

  if Index < FCount then
    memcpy(FMemory+FItemSize*(Index+1), FMemory+FItemSize*Index, (FCount-Index)*FItemSize);

  memcpy(FMemory+FItemSize*Index, @Item, FItemSize);
  Inc(FCount);

  Result:=Index;
  FModify;
end;

procedure TArray.Move(CurIndex, NewIndex: Integer);
begin
  if CurIndex <> NewIndex then
  begin
    if (NewIndex < 0) or (NewIndex >= FCount) then Exit;
    Get(CurIndex, FTmpItem^);
    Delete(CurIndex);
    Insert(NewIndex, FTmpItem^);
    FModify;
  end;
end;

procedure TArray.Put(Index: Integer; const Item);
begin
  if (Index < 0) then EXIT;
  if (Index < FCount) then begin
    memcpy(FMemory+FItemSize*Index, @Item, FItemSize);
  end else begin
    if Index>FCount then SetCount(Index);
    if Status=0 then Add(Item);
  end;

  FModify;
end;

function TArray.Remove(const Item): Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then Delete(Result);
end;

procedure TArray.Mul(aa: array of TArray);//пересечение массивов aa=[a1,a2,...]
var i,j,ind: integer; a0,a1: TArray;
begin
  Clear;
  //aa пуст:
  if High(aa)<Low(aa) then exit;
  //1 элемент в aa:
  a0 := aa[ Low(aa) ];
  if High(aa)=Low(aa) then begin AddFrom(a0); exit; end;
  //более одного массива в aa:
  if a0.Count>0 then for i:=0 to a0.Count-1 do begin
    a0.Get(i, FTmpItem^);
    //проверка принадлежности эл-та FTmpItem^ к другим массивам:
    ind:=-1;
    for j:=Low(aa)+1 to High(aa) do begin
      a1 := aa[j];
      ind:=a1.IndexOf(FTmpItem^);
      if ind<0 then break;
    end;
    //если принадлежит всем:
    if ind>=0 then Add(FTmpItem^);
  end;//for i
end;

procedure TArray.Sort(CmpProc: TCmpProc; ar2: tarray);
var i: integer; Replaced: boolean;
begin
  repeat

    Replaced:=false;

    if Count>1 then for i:=1 to Count-1 do begin

      if CmpProc( GetP(i-1), GetP(i) )>0 then begin
        Exchange(i-1,i);
        if ar2<>nil then ar2.Exchange(i-1,i);
        Replaced:=true;
      end;

    end;

  until not Replaced;

  FModify;//хотя, не всегда ...
end;

procedure TArray.SortByStrings(Strings: TStrings);
var i: integer; Replaced: boolean;
begin
  if Strings.Count<>Count then exit;
  repeat

    Replaced:=false;

    if Count>1 then for i:=1 to Count-1 do begin

      if Strings[i-1]>Strings[i] then begin
        Strings.Exchange(i-1,i);
        Exchange(i-1,i);
        Replaced:=true;
      end;

    end;

  until not Replaced;

  FModify;//хотя, не всегда ...
end;

procedure TArray.Reverse;
var i,j: integer;
begin
  if FCount<2 then exit;
  i:=0;
  j:=FCount-1;
  while i<j do begin
    Exchange(i, j);
    inc(i);
    dec(j);
  end;
  FModify;
end;

procedure TArray.FillC(c: char);
begin
  if FCount>0 then FillChar(FMemory^,FCount*FItemSize,c);
  FModify;
end;

procedure TArray.SetCapacity(NewCapacity: Integer);
var NewMemory: PChar;
begin
  if NewCapacity<FCount then Exit;

  if NewCapacity<>FCapacity then begin

    if NewCapacity = 0 then begin
      NewMemory := nil;
    end else begin
      NewMemory := malloc(NewCapacity*FItemSize);
      if NewMemory=nil then begin Status:=E_OutOfMemory; Exit; end;

      if FCount <> 0 then
        memcpy(NewMemory, FMemory, FCount*FItemSize);
    end;

    if FCapacity <> 0 then FreeMem(FMemory, FCapacity*FItemSize);
    FMemory := NewMemory;
    FCapacity := NewCapacity;

  end; {NewCapacity<>FCapacity}
end;

procedure TArray.SetCount(NewCount: Integer);
begin
  if NewCount > FCapacity then SetCapacity(NewCount+4);
  if Status<>0 then Exit;
  FCount := NewCount;
  FModify;
end;


procedure TArray.AddFrom(a: tarray);
var count0: integer;
begin
  if a.ItemSize<>ItemSize then exit;
  count0:=Count;
  SetCount(Count+a.Count);
  memcpy(Memory+count0*ItemSize, a.Memory, a.Count*a.ItemSize);
  FModify;
end;


{ TIntArray merthods: }

constructor TIntArray.Create(aDelta: Integer);
begin
  inherited Create( SizeOf(Integer), aDelta );
end;

constructor TIntArray.New;
begin
  inherited Create( SizeOf(Integer), DeltaDefault);
end;


function _IntCmpFunc(p1,p2: pointer): integer;
var pi1,pi2: ^integer;
begin
  pi1:=p1;
  pi2:=p2;
  if pi1^>pi2^ then Result:=1
  else if pi1^<pi2^ then Result:=-1
  else Result:=0;
end;

procedure TIntArray.Sort(ar2: tarray);//по возрастанию
begin
  inherited Sort(_IntCmpFunc,ar2);
end;


function TIntArray.Get(Index: Integer): Integer;
begin
  inherited Get( Index, Result );
end;

procedure TIntArray.Put(Index: Integer; Item: Integer);
begin
  inherited Put( Index, Item );
end;

function TIntArray.Add(i: integer): Integer;
begin
  Result := inherited Add(i);
end;

function TIntArray.First: Integer;
begin
  if count>0 then result:=Items[0] else result:=0;
end;

function TIntArray.Last: Integer;
begin
  if count>0 then result:=Items[count-1] else result:=0;
end;

procedure TIntArray.Inc(Index: Integer);
begin
  Items[Index]:=Items[Index]+1;
  FModify;
end;

procedure TIntArray.Dec(Index: Integer);
begin
  Items[Index]:=Items[Index]-1;
  FModify;
end;

procedure TIntArray.Fill(i0,di,n: integer);//n=count
var i: integer;
begin
  Clear;
  for i:=0 to n-1 do Add(i0+i*di);
end;

procedure TIntArray.array_of_integer(var A: _TIntegerArray);
var i: integer;
begin
  System.SetLength(A, Count);
  if Count>0 then for i:=0 to Count-1 do A[i]:=Items[i];
end;

{ TRelArray methods: }

constructor TRelArray.Create(aDelta: Integer);
begin
  inherited Create( SizeOf(TRel), aDelta );
end;

constructor TRelArray.New;
begin
  inherited Create( SizeOf(TRel), DeltaDefault);
end;


function _RelCmpFunc(p1,p2: pointer): integer;
var pr1,pr2: ^tRel;
begin
  pr1:=p1;
  pr2:=p2;
  if pr1^>pr2^ then Result:=1
  else if pr1^<pr2^ then Result:=-1
  else Result:=0;
end;

procedure TRelArray.Sort(ar2: tarray);//по возрастанию
begin
  inherited Sort(_RelCmpFunc,ar2);
end;


function TRelArray.Get(Index: Integer): TRel;
begin
  inherited Get( Index, Result );
end;

procedure TRelArray.Put(Index: Integer; Item: TRel);
begin
  inherited Put( Index, Item );
end;


{ TRelPntArray methods: }

constructor TRelPntArray.Create(aDelta: Integer);
begin
  inherited Create( SizeOf(rpoint), aDelta );
end;

function TRelPntArray.Get(Index: Integer): rpoint;
begin
  inherited Get( Index, Result );
end;

procedure TRelPntArray.Put(Index: Integer; Item: rpoint);
begin
  inherited Put( Index, Item );
end;


end.
