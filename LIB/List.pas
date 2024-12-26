(*
  TPtrList
  TObjList
  TClassList
*)
unit List;

{$MODE Delphi}

 interface

uses
  Classes,
  Arrayx, Nums;


Type
  PPtrList = ^TPtrList;
  TPtrList = class(TArray)
  protected
    function Get(Index: Integer): Pointer;//m.b. Index>=Count (NIL)
    procedure Put(Index: Integer; Item: Pointer);//m.b. Index>=Count (EXPAND)
  public
    constructor Create(aDelta: integer);
    constructor New;
    function Add(Item: pointer): Integer;
(*  FROM TARRAY:
    function Add(Item: Pointer): Integer;
    procedure Clear;                                 {Count=0, Capacity=0}
    procedure Delete(Index: Integer);                {со здвигом списка}
    procedure Exchange(Index1, Index2: Integer);
    function Expand: TList;
    function First: Pointer;
    function IndexOf(Item: Pointer): Integer;
    procedure Insert(Index: Integer; Item: Pointer); {со здвигом списка}
    function Last: Pointer;
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(Item: Pointer): Integer;         {IndexOf+Delete}
*)
    procedure AddByIndexes(aList: TPtrList; Indexes: tinta);
    function FindFirstNil(_expand: boolean = true{совместимость!}): Integer; {всегда >=0}

    property Capacity;
    property Count;
    property Memory;
    property Items[Index: Integer]: Pointer read Get write Put; default;
  end;

  //Обработка объектов:
  TestFunction = function( Obj: TObject ): boolean;
  TListFunction = function( Obj: TObject; pData: pointer{ForAll, m.b.nil} ): boolean of object;

  //tclass = class of tobject;//СУЩЕСТВУЕТ - Любой потомок tobject (Help: class of, class references)

  //Список объектов без FreeItem:
  PObjList = ^TObjList;
  TObjList = class(TPtrList)
  protected
    function Get(Index: Integer): TObject;//m.b. Index>=Count (NIL)
    procedure Put(Index: Integer; Item: TObject);//m.b. Index>=Count (EXPAND)
  public
    procedure Free_Items;

    function FindFirst(aTest: TestFunction): Integer;//ForAll, if aTest=false
    procedure ForAll(aTest: TListFunction; pData: pointer{m.b.nil});//aTest=true => break
    procedure DeleteAll(aTest: TListFunction; pData: pointer);//aTest=true => delete

    property Memory;
    property Capacity;
    property Count;
    property Items[Index: Integer]: TObject read Get write Put; default;
  end;

  //Список объектов с FreeItem(!):
  PClassList = ^TClassList;
  TClassList = class(TObjList)
  protected
    //function Get(Index: Integer): TObject; {m.b. Index>=Count}
    procedure Put(Index: Integer; Item: TObject);//m.b. Index>=Count (EXPAND)
  public
    //FREE ITEMS:
    destructor Destroy; override;
    procedure FreeItem(Index: Integer);           {Item.Free}
    procedure Delete(Index: Integer); override;   {Item.Free+Offset}
    procedure SetCount(NewCount: Integer); override;

    //Манипуляции без FreeItem:
    function Disconnect(Index: Integer): TObject; //put(nil) without Free!
    procedure DisconnectAll; //put(nil) without Free!
    function MoveFrom(lst: tclasslist; Index: Integer): TObject; //Disconnect+Add
    procedure MoveFrom2(lst: tclasslist; Index,aCount: Integer);
    procedure MoveFromList(lst: tclasslist);//"MoveFrom" все элементы

    property Memory;
    property Capacity;
    //property Count: Integer read GetCount write SetCount;
    property Count;                            //НОВАЯ ПРОЦ SetCount используется ???
    property Items[Index: Integer]: TObject read Get write Put; default;
  end;


implementation


{ TPtrList: }

constructor TPtrList.Create(aDelta: integer);
begin
  inherited Create(sizeof(Pointer), aDelta);
end;

constructor TPtrList.New;
begin
  inherited Create(sizeof(Pointer), 32);
end;

function TPtrList.Get(Index: Integer): Pointer;
begin
  if not inherited Get(Index, Result) then Result := nil;
end;

procedure TPtrList.Put(Index: Integer; Item: Pointer);
begin
  inherited Put(Index, Item);
end;

function TPtrList.Add(Item: pointer): Integer;
begin
  Result := inherited Add(Item);
end;

procedure TPtrList.AddByIndexes(aList: TPtrList; Indexes: tinta);
var i,ind: integer; p: pointer;
begin
  if Indexes.Count>0 then for i:=0 to Indexes.Count-1 do begin
    ind:=Indexes[i];
    if ind>=0 then begin p:=aList[ind]; Add(p); end;
  end;
end;

function TPtrList.FindFirstNil(_expand: boolean = true{совместимость!}): Integer;
var i: Integer;
begin
  Result:=-1;
  if FCount>0 then for i:=0 to FCount-1 do begin
    if Items[i]<>nil then CONTINUE;
    Result:=i;
    EXIT;
  end;
  if _expand and (Result=-1) then begin
    Count := Count+1;
    Result := Count;
  end;
end;


{ TObjList: }

function TObjList.Get(Index: Integer): TObject;
begin
  Result :=  inherited Get(Index);
end;

procedure TObjList.Put(Index: Integer; Item: TObject);
begin
  inherited Put(Index, Item);
end;


procedure TObjList.Free_Items;
var i: integer;
begin
  if Count>0 then for i:=Count-1 downto 0 do
    Items[i].Free;
end;


function TObjList.FindFirst(aTest: TestFunction): Integer;
var i: Integer;
begin
  Result:=-1;
  if FCount>0 then for i:=0 to FCount-1 do begin
    if not aTest( Items[i] ) then CONTINUE;
    Result:=i;
    EXIT;
  end;
end;

procedure TObjList.ForAll(aTest: TListFunction; pData: pointer);
var i: Integer;
begin
  if FCount>0 then for i:=0 to FCount-1 do
    if aTest( Items[i], pData ) then BREAK;
end;

procedure TObjList.DeleteAll(aTest: TListFunction; pData: pointer);
var i: Integer;
begin
  i:=0;
  while i<FCount do begin
    if aTest( Items[i], pData ) then Delete(i){virtual!}
    else inc(i);//next
  end;//while
end;


{ TClassList: }

destructor TClassList.Destroy;
begin
  SetCount(0);//=>Items.Free!
  inherited;
end;

procedure TClassList.Put(Index: Integer; Item: TObject);
begin
  //if Item=nil then Items[Index].Free;           {m.b. NIL !!!}
  Items[Index].Free;           {m.b. NIL !!!, Free - при любой записи!}
  inherited Put(Index, Item);//Modified!
end;


procedure TClassList.FreeItem(Index: Integer);
begin
  Put(Index, nil);
end;

procedure TClassList.Delete(Index: Integer);
begin
  //if Assigned(Get(Index)) then FreeItem(Index);
  Put(Index, nil);
  inherited Delete(Index);
end;

procedure TClassList.SetCount(NewCount: Integer);
var i: Integer;
begin
  if NewCount<Count then for i:=Count-1 downto NewCount do
    Items[i].Free;
  inherited SetCount(NewCount);
end;


//put(nil) without Free:
function TClassList.Disconnect(Index: Integer): TObject;
begin
  Result:=Get(Index);
  inherited Put(Index, nil); {!}
end;

procedure TClassList.DisconnectAll;
var i: integer;
begin
  if Count>0 then for i:=0 to Count-1 do Disconnect(i);
end;

//Disconnect+Add:
function TClassList.MoveFrom(lst: tclasslist; Index: Integer): TObject;
var o: tobject;
begin
  o:=lst.Disconnect(Index);
  Add(o);
  Result:=o;
end;

procedure TClassList.MoveFrom2(lst: tclasslist; Index,aCount: Integer);
var i: integer;
begin
  if aCount>0 then for i:=Index to Index+aCount-1 do MoveFrom(lst, i);
end;

procedure TClassList.MoveFromList(lst: tclasslist);
begin
  MoveFrom2(lst, 0, lst.count);
end;


end.
