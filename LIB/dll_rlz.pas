(*
  Обращение к файлу .RLZ
  Источник - "tol\d3_use.pas"
  .RLZ - плиточный и сжатый
  x,y: Double - Гаусс (метры)

  rlz_ - через rel_ Толика (OLD)
  rlzm_ - через rm_ Толика (NEW)
*)
unit dll_rlz; interface

uses Otypes, d3_use, vlib, llibx, llib3d;

//закоммент-ые ф-ии - см. d3_use.pas:
(*
//открыть-закрыть файл .RLZ:
function rel_Open(fn: PChar): Boolean; stdcall;
procedure rel_Close; stdcall;

//XTiles,YTiles: кол-во плиток (X - горизонталь)
//TileWidth,TileHeight: размер плитки (W - горизонталь, 129,257,... - 1-ПЕРЕКРЫТИЕ ПЛИТОК)
//xmin,ymin,xmax,ymax: ГАУСС - КРАЯ прямоуг-ка
//формула высоты: h = a0 + k0*Word, где Word - элемент м-цы
procedure rel_Info(out XTiles,YTiles: Integer;
                   out TileWidth,TileHeight: Integer;
                   out xmin,ymin,zmin: Double;
                   out xmax,ymax,zmax: Double;
                   out a0,k0: Double); stdcall;

//получить значение (высота):
function rel_Value(x,y: Double; out z: Double): Boolean; stdcall;

//получить значение (высота) через BL - 2 ф-ии в паре:
procedure rel_Get_sys(out sys: tsys); stdcall;
function rel_Value1(r: PGeoPoint; out z: Double): Boolean; stdcall;
*)

//OLD: ФУНКЦИИ НА rel_ (между rel_Open - rel_Close):

function rlz_get_step: Double;//шаг матрицы (из rel_Info)
procedure rlz_get_box(var xmin,ymin,xmax,ymax: double);//из rel_Info

function rlz_get_bound_bl(pl_bl: tpl): boolean;//200706
function rlz_get_bound_blz(pl_bl: tpl3d): boolean;//200706 - заполнение z=0


//NEW: ФУНКЦИИ НА rm_ (между rm_Open - rm_Close):

//из rm_Info:
procedure rlzm_get_box(rm: Pointer; var box: tnum4; var step: double);

//получение высоты z - с проверкой корректности z:
function  rlzm_xy_z    (rm: Pointer; p: tnum2; out z: double): boolean;
function  rlzm_blrad_z(rm: Pointer; sys: tsys; p{rad}: tnum2; out z: double): boolean;


implementation

uses nums, llib;


//OLD: ------------------------------------

function rlz_get_step: Double;
var
  XTiles,YTiles: Integer; TileWidth,TileHeight: Integer;
  xmin,ymin,zmin: Double; xmax,ymax,zmax: Double; a0,k0: Double;
begin
  rel_Info(XTiles,YTiles, TileWidth,TileHeight, xmin,ymin,zmin, xmax,ymax,zmax, a0,k0);
  Result := (ymax-ymin)/(XTiles*(TileWidth-1)+1);//"-+1" - ПЕРЕКРЫТИЕ ПЛИТОК
end;

procedure rlz_get_box(var xmin,ymin,xmax,ymax: double);
var
  XTiles,YTiles: Integer; TileWidth,TileHeight: Integer;
  zmin: Double; zmax: Double; a0,k0: Double;
begin
  rel_Info(XTiles,YTiles, TileWidth,TileHeight, xmin,ymin,zmin, xmax,ymax,zmax, a0,k0);
end;

function rlz_get_bound_bl(pl_bl: tpl): boolean;
var
  rm: Pointer;
  xmin,ymin,xmax,ymax: double;
  bmin,lmin,bmax,lmax: double;
begin
  rlz_get_box(xmin,ymin,xmax,ymax);
(*
  Толя:
  "через rel_open" => rel_g_to_l + rel_to_bl
  "через rm_open"  => rm_g_to_bl
  rm_g_to_bl: Integer - 1-радианы получились, 0-нет
*)
  rm:=rel_Handle;
  Result:=
    (rm_g_to_bl(rm, xmin,ymin, bmin,lmin)=1)//радианы
    and (rm_g_to_bl(rm, xmax,ymax, bmax,lmax)=1);//радианы

  //pl_bl - ПРОТИВ ЧАС.СТР. (и Толик, и Оракл):
  pl_bl.Clear;//!
  pl_bl.AddRect(grad(bmin),grad(lmin), grad(bmax),grad(lmax));//по час.стр., ГРАДУСЫ
  pl_bl.Reverse;//!
end;

function rlz_get_bound_blz(pl_bl: tpl3d): boolean;
begin
  Result:=rlz_get_bound_bl(pl_bl.pl);
  if Result then pl_bl.ha.Count:=pl_bl.pl.Count;//заполнение z=0
end;


//NEW: ------------------------------------


procedure rlzm_get_box(rm: Pointer; var box: tnum4; var step: double);
var
  XTiles,YTiles: Integer; TileWidth,TileHeight: Integer;
  zmin,zmax: Double; a0,k0: Double;
begin
  rm_Info(rm, XTiles,YTiles, TileWidth,TileHeight, box.a.x,box.a.y,zmin, box.b.x,box.b.y,zmax, a0,k0);
  step := (box.b.y-box.a.y)/(XTiles*(TileWidth-1)+1);//"-+1" - ПЕРЕКРЫТИЕ ПЛИТОК
end;


function rlzm_xy_z(rm: Pointer; p: tnum2; out z: double): boolean;
begin
  Result:=rm_Value(rm, p.x,p.y,z);
  if Result and (z<-1000{Толик -5000 иногда возвращает})
  then Result := FALSE;//!
end;

function  rlzm_blrad_z(rm: Pointer; sys: tsys; p{rad}: tnum2; out z: double): boolean;
var gp: TGeoPoint;
begin
  gp.x:=p.x;
  gp.y:=p.y;
  gp.s:=sys;
  Result:=rm_Value1(rm, @gp, z);
  if Result and (z<-1000{Толик -5000 иногда возвращает})
  then Result := FALSE;//!
end;


end.
