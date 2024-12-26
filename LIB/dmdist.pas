(*
  Функции вычисления расстояния.

  BL - ГРАДУСЫ!!!

  uses dll_bl.dll (tol)

  КАРТА ОТКРЫТА (!!!):

  uses dml3_sys: tsys{OTypes.pas} from dmlib3d.pas - параметры проекции последней открытой карты

*)
unit dmdist; interface

uses vlib, vlib3d;

//КАРТА ОТКРЫТА:

//2d-расстояние по эллипсоиду:
//9 = WGS-1984:
function dmdm_2d_xy(p1,p2{x,y}: tnum2; pps,elp: Integer): double;

//3d-расстояние по прямой:
function dmdm_3d_xyh(p1,p2{x,y,h}: tnum3; pps,elp: Integer): double;


implementation

uses
  dmw_use,
  wcmn, nums,
  dmdist0, dmlib3d;


//------- КАРТА ОТКРЫТА: -------------------------------------

function dmdm_2d_xy(p1,p2{x,y}: tnum2; pps,elp: Integer): double;
var bl1,bl2: tnum2;
begin
  if pps=1{геодезия} then begin
    dm_XY_BL(p1.x,p1.y, bl1.x,bl1.y);//rad
    dm_XY_BL(p2.x,p2.y, bl2.x,bl2.y);//rad
    Result := dmd_2d_rad(bl1,bl2, dml3_sys.elp);
  end else begin
    Result := v_dist(p1,p2);//2D-отрезок
  end;
end;

function dmdm_3d_xyh(p1,p2{x,y,h}: tnum3; pps,elp: Integer): double;
var blh1,blh2,xyz1,xyz2: tnum3;
begin
  if pps=1{геодезия} then begin
    dm_XY_BL(p1.p.x,p1.p.y, blh1.p.x,blh1.p.y);//rad
    blh1.z:=p1.z;//!
    dm_XY_BL(p2.p.x,p2.p.y, blh2.p.x,blh2.p.y);//rad
    blh2.z:=p2.z;//!

    xyz1:=dmd_blh_rad_xyz(blh1, elp);
    xyz2:=dmd_blh_rad_xyz(blh2, elp);

    Result := v3_dist(xyz1,xyz2);//отрезок
  end else begin
    Result := v3_dist(p1,p2);//отрезок
  end;
end;


end.
