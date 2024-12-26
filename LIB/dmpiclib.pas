{
   Картинка (координаты ГАУССОВЫ, карта закрыта):
   tDmDraw, tDmPic
}
unit dmpiclib; interface

uses
  otypes,
  list, vlib, llibx, matx, dmlib, dmlibx;

type
  tDmPic = class;

  //элемент картинки (координаты ГАУССОВЫ):
  tDmDraw = class
  protected
    FPic: tDmPic;//картинка, в к-ую включается объект
    FDMO: TDmOx;//<-- ReadFromDmFile
    //FVisible: boolean;//default=false(!)
    //procedure SetVisible(aVisible: boolean); virtual;
    procedure Transform(aMat: pMatrix); virtual;
  public
    constructor Create(aPic: tDmPic; aDMO: TDmOx);//aDMO=TDMO.Create2(true, true) (координаты ГАУСОВЫ, FGraph используется)
    destructor Destroy; override;

    //property Visible: boolean read FVisible write SetVisible;
    property DMO: TDmOx read FDMO;
  end;


  //картинка - список элементов tDmDraw - базовый тип для движения:
  tDmPic = class
  protected
    FList: tclasslist;//of tDmDraw, элементы м.б. NIL
    function Get(i: integer): tDmDraw;
    procedure Put(i: integer; aDmDraw: tDmDraw);
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function AddItem(aItem: tDmDraw): boolean;//добавление в FList, false, если уже есть(!)
    function RemoveItem(aItem: tDmDraw): integer;//Delete!
    //procedure ShowAll;//Visible=true for FList
    procedure Transform(aMat: pMatrix);
    function Find_ID(id: integer): integer;//index in FList по 1000-характеристике
    function Find_Ofs(ofs: integer): integer;//index in FList по dmoffset

    property Count: integer read GetCount;
    property Items[i: integer]: tDmDraw read Get write Put; default;
  end;


implementation

uses
  SysUtils,
  dmw_dde, dmw_use,
  wcmn;


{ tDmDraw: }

constructor tDmDraw.Create(aPic: tDmPic; aDMO: TDmOx);
begin
  inherited Create;
  FPic:=aPic;
  FDMO:=aDMO;
end;

destructor tDmDraw.Destroy;
begin
  FDMO.Free;
  //FPic.RemoveItem(Self);
end;
(*
procedure tDmDraw.SetVisible(aVisible: boolean);
begin
  FVisible:=aVisible;
end;
*)
procedure tDmDraw.Transform(aMat: pMatrix);
begin
  FDMO.Points.Transform(aMat, nil);
end;


{ tDmPic: }

constructor tDmPic.Create;
begin
  inherited Create;
  FList:=tclasslist.New;
end;

destructor tDmPic.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure tDmPic.Clear;
begin
  FList.Clear;
end;

function tDmPic.Get(i: integer): tDmDraw;
begin
  tobject(Result):=FList[i];
end;

procedure tDmPic.Put(i: integer; aDmDraw: tDmDraw);
begin
  FList.Put(i, aDmDraw);
end;

function tDmPic.GetCount: integer;
begin
  Result:=FList.Count;
end;

function tDmPic.AddItem(aItem: tDmDraw): boolean;//добавление в список
begin
  Result := Find_ID(aItem.DMO.ID)<0;
  if Result then Result := FList.Add(aItem)>=0
  else Tellf('tDmPic.AddItem: Повторное добавление объекта ID=%d невозможно.',[aItem.DMO.ID]);
end;

function tDmPic.RemoveItem(aItem: tDmDraw): integer;//Delete!
begin
  Result:=FList.Remove(aItem);
end;

procedure tDmPic.Transform(aMat: pMatrix);
var i: integer;
begin
  if FList.Count>0 then for i:=0 to FList.Count-1 do
    if Assigned(Items[i]) then Items[i].Transform(aMat);
end;
(*
procedure tDmPic.ShowAll;//Visible=true for FList
var i: integer;
begin
  if FList.Count>0 then for i:=0 to FList.Count-1 do
    if Assigned(Items[i]) then
      Items[i].Visible:=true;
end;
*)
function tDmPic.Find_ID(id: integer): integer;//index in FList по 1000-характеристике
var i: integer;
begin
  Result:=-1;
  if FList.Count>0 then for i:=0 to FList.Count-1 do begin
    if Assigned(Items[i]) and (Items[i].FDMO.ID=id) then begin
      Result:=i;
      break;
    end;
  end;//for i
end;

function tDmPic.Find_Ofs(ofs: integer): integer;//index in FList по dmoffset
var i: integer;
begin
  Result:=-1;
  if FList.Count>0 then for i:=0 to FList.Count-1 do begin
    if Assigned(Items[i]) and (Items[i].FDMO.dmoffset=ofs) then begin
      Result:=i;
      break;
    end;
  end;//for i
end;


end.
