(*
  матрицы nx*ny
  построчно слева направо (x) и сверху вниз (y) - как Image(bmp) и Relief
  с √ј”——ќ¬ќ… прив€зкой к местности
  Ok: if Count>0
*)
unit mlibg; interface

uses nums, vlib, mlib, relief, llibx;


type
  tnuma2g = class(tnuma2)
  protected
    //FDmName: string;//from LoadFromDm
    FBox: tnum4;//FBox.a=LU(лев.верх.), FBox.b=RD(пр.нижн.) (√аусс => a.x>b.x)
    procedure SetBox(aBox: tnum4);
    function GetStepsG: tnum2;//метры (√аусс: GetStep.x по вертикали, GetStep.x<0(!))
  public
    procedure Clear; override;
    function GetSizesG: tnum2;//метры (√аусс: GetSize.x по вертикали!)
    procedure SetSizes(w,h: integer; aBox{Gauss}: tnum4);//inherited SetSizes(w,h) exists
    procedure GetSizes(var w,h: integer; var aSize{Gauss}: tnum2);//aSize.x по вертикали
    procedure LoadFromRelief(rel: TRelief); override;//Clear
    //через создание временного .REL по хар-ке nChara, aStep-метры:
    procedure LoadFromDm(aDmName: string; aStep: single; nChara: integer);
    procedure LoadFromDm2(aDmName: string; GLT,GRB: tnum2; aStep: single; nChara: integer);
    function ValOnPoint(gp: tnum2): tnum;//в точке gp (Gauss)
    function ValOnLine(pl: tpl): tnum;//среднее значение на мн-ве точек
    //ѕреобр-ие координат (см. imagex.pas):
    //√аусс->ix,iy (с прит€гиванием к матрице):
    procedure gxgy_to_ixiy(gp: tnum2; var ix,iy: integer);
    //ix,iy->√аусс:
    procedure ixiy_to_gxgy(ix,iy: integer; var gp: tnum2);

    //property DmName: string read FDmName;
    property LU: tnum2 read FBox.a;//лев.верх. точка (√аусс)
    property Box: tnum4 read FBox write SetBox;
    property SizesG: tnum2 read GetSizesG;
    property StepsG: tnum2 read GetStepsG;
  end;


implementation

uses
  SysUtils,
  wcmn, imagex;

{ tnuma2g: }

procedure tnuma2g.Clear;
begin
  inherited Clear;
  //FDmName:='';
  FBox.a:=v_xy(0,0);
  FBox.b:=v_xy(0,0);
end;

procedure tnuma2g.SetBox(aBox: tnum4);
begin
  FBox:=aBox;
end;

procedure tnuma2g.SetSizes(w,h: integer; aBox: tnum4);
begin
  inherited SetSizes(w,h);
  SetBox(aBox);
end;

procedure tnuma2g.GetSizes(var w,h: integer; var aSize{Gauss}: tnum2);
begin
  w:=Width;
  h:=Height;
  aSize:=GetSizesG;
end;

function tnuma2g.GetSizesG: tnum2;//метры (√аусс: GetSize.x по вертикали!)
begin
  Result := v_box_size(FBox);
end;

function tnuma2g.GetStepsG: tnum2;//метры (√аусс: GetStep.x по вертикали, <0 !!!)
var boxsize: tnum2; w,h: integer;
begin
  w:=Width;
  h:=Height;
  boxsize:=GetSizesG;
  if h<=1 then Result.x:=0 else Result.x:=-boxsize.x/(h-1);//step.x<0(!)
  if w<=1 then Result.y:=0 else Result.y:= boxsize.y/(w-1);
end;

procedure tnuma2g.gxgy_to_ixiy(gp: tnum2; var ix,iy: integer);//√аусс->ix,iy
var sz: tnum2; w,h: integer;
begin
  w:=FWidth;
  h:=Height;
  sz:=GetSizesG;
  imx_xy_to_ixiy2(gp, ix,iy, LU,sz, w,h);//imagex.pas
end;

procedure tnuma2g.ixiy_to_gxgy(ix,iy: integer; var gp: tnum2);//ix,iy->√аусс
var sz: tnum2; w,h: integer;
begin
  w:=Width;
  h:=Height;
  sz:=GetSizesG;
  imx_ixiy_to_xy(ix,iy, gp, LU,sz,w,h);//imagex.pas
end;

//-----------------------------------------------

procedure tnuma2g.LoadFromRelief(rel: TRelief);
begin
  inherited LoadFromRelief(rel);//Clear
  FBox.a:=rel.GXY[0];
  FBox.b:=rel.GXY[2];
end;

procedure tnuma2g.LoadFromDm(aDmName: string; aStep: single; nChara: integer);
var rel: TRelief;
begin
  Clear;
  if not FileExists(aDmName) then exit;
  rel:=TRelief.Create;
  try
    if relief_make_and_load(aDmName, aStep, nChara, rel) then begin
      //FDmName:=aDmName;
      LoadFromRelief(rel);
    end;
  finally
    rel.Free;
  end;
end;

procedure tnuma2g.LoadFromDm2(aDmName: string; GLT,GRB: tnum2; aStep: single; nChara: integer);
var rel: TRelief;
begin
  Clear;
  if not FileExists(aDmName) then exit;
  rel:=TRelief.Create;
  try
    if relief_make_and_load2(aDmName, GLT,GRB, aStep, nChara, rel) then begin
      //FDmName:=aDmName;
      LoadFromRelief(rel);
    end;
  finally
    rel.Free;
  end;
end;


function tnuma2g.ValOnPoint(gp: tnum2): tnum;//в точке gp (Gauss)
var ix,iy: integer;
begin
  gxgy_to_ixiy(gp, ix,iy);
  Result:=Val[ix,iy];
end;

function tnuma2g.ValOnLine(pl: tpl): tnum;//среднее значение на мн-ве точек
var sz: tnum2; w,h,ix,iy,i: integer;
begin
  Result:=0;//default
  w:=Width;
  h:=Height;
  sz:=GetSizesG;
  if (sz.x>0) and (sz.y>0) and (FCount>0) and (pl.count>0) then begin
    for i:=0 to pl.count-1 do begin
      imx_xy_to_ixiy2(pl[i], ix,iy, LU,sz, w,h);
      Result:=Result+Val[ix,iy];
    end;//for i
    Result:=Result/pl.count;
  end;//if
end;


end.
