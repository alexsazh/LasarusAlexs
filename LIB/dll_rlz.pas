(*
  ��������� � ����� .RLZ
  �������� - "tol\d3_use.pas"
  .RLZ - ��������� � ������
  x,y: Double - ����� (�����)

  rlz_ - ����� rel_ ������ (OLD)
  rlzm_ - ����� rm_ ������ (NEW)
*)
unit dll_rlz; interface

uses Otypes, d3_use, vlib, llibx, llib3d;

//���������-�� �-�� - ��. d3_use.pas:
(*
//�������-������� ���� .RLZ:
function rel_Open(fn: PChar): Boolean; stdcall;
procedure rel_Close; stdcall;

//XTiles,YTiles: ���-�� ������ (X - �����������)
//TileWidth,TileHeight: ������ ������ (W - �����������, 129,257,... - 1-���������� ������)
//xmin,ymin,xmax,ymax: ����� - ���� �������-��
//������� ������: h = a0 + k0*Word, ��� Word - ������� �-��
procedure rel_Info(out XTiles,YTiles: Integer;
                   out TileWidth,TileHeight: Integer;
                   out xmin,ymin,zmin: Double;
                   out xmax,ymax,zmax: Double;
                   out a0,k0: Double); stdcall;

//�������� �������� (������):
function rel_Value(x,y: Double; out z: Double): Boolean; stdcall;

//�������� �������� (������) ����� BL - 2 �-�� � ����:
procedure rel_Get_sys(out sys: tsys); stdcall;
function rel_Value1(r: PGeoPoint; out z: Double): Boolean; stdcall;
*)

//OLD: ������� �� rel_ (����� rel_Open - rel_Close):

function rlz_get_step: Double;//��� ������� (�� rel_Info)
procedure rlz_get_box(var xmin,ymin,xmax,ymax: double);//�� rel_Info

function rlz_get_bound_bl(pl_bl: tpl): boolean;//200706
function rlz_get_bound_blz(pl_bl: tpl3d): boolean;//200706 - ���������� z=0


//NEW: ������� �� rm_ (����� rm_Open - rm_Close):

//�� rm_Info:
procedure rlzm_get_box(rm: Pointer; var box: tnum4; var step: double);

//��������� ������ z - � ��������� ������������ z:
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
  Result := (ymax-ymin)/(XTiles*(TileWidth-1)+1);//"-+1" - ���������� ������
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
  ����:
  "����� rel_open" => rel_g_to_l + rel_to_bl
  "����� rm_open"  => rm_g_to_bl
  rm_g_to_bl: Integer - 1-������� ����������, 0-���
*)
  rm:=rel_Handle;
  Result:=
    (rm_g_to_bl(rm, xmin,ymin, bmin,lmin)=1)//�������
    and (rm_g_to_bl(rm, xmax,ymax, bmax,lmax)=1);//�������

  //pl_bl - ������ ���.���. (� �����, � �����):
  pl_bl.Clear;//!
  pl_bl.AddRect(grad(bmin),grad(lmin), grad(bmax),grad(lmax));//�� ���.���., �������
  pl_bl.Reverse;//!
end;

function rlz_get_bound_blz(pl_bl: tpl3d): boolean;
begin
  Result:=rlz_get_bound_bl(pl_bl.pl);
  if Result then pl_bl.ha.Count:=pl_bl.pl.Count;//���������� z=0
end;


//NEW: ------------------------------------


procedure rlzm_get_box(rm: Pointer; var box: tnum4; var step: double);
var
  XTiles,YTiles: Integer; TileWidth,TileHeight: Integer;
  zmin,zmax: Double; a0,k0: Double;
begin
  rm_Info(rm, XTiles,YTiles, TileWidth,TileHeight, box.a.x,box.a.y,zmin, box.b.x,box.b.y,zmax, a0,k0);
  step := (box.b.y-box.a.y)/(XTiles*(TileWidth-1)+1);//"-+1" - ���������� ������
end;


function rlzm_xy_z(rm: Pointer; p: tnum2; out z: double): boolean;
begin
  Result:=rm_Value(rm, p.x,p.y,z);
  if Result and (z<-1000{����� -5000 ������ ����������})
  then Result := FALSE;//!
end;

function  rlzm_blrad_z(rm: Pointer; sys: tsys; p{rad}: tnum2; out z: double): boolean;
var gp: TGeoPoint;
begin
  gp.x:=p.x;
  gp.y:=p.y;
  gp.s:=sys;
  Result:=rm_Value1(rm, @gp, z);
  if Result and (z<-1000{����� -5000 ������ ����������})
  then Result := FALSE;//!
end;


end.
