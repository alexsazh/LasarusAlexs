(*
  Функции вычисления расстояния.

  BL - ГРАДУСЫ!!!
  КАРТА ЗАКРЫТА!!!

  uses dll_bl.dll (tol)
*)
unit dmdist0;

{$MODE Delphi}

 interface

uses Vlib, vlib3d;

//КАРТА ЗАКРЫТА:

//Геоцентрика:
//b,l - радианы:
procedure bl_to_xyz(b{rad},l{rad},h: Double; elp{9 = WGS-1984}: Integer;
                    out x,y,z: Double); stdcall;
function dmd_blh_rad_xyz(blh{rad}: tnum3; elp: Integer): tnum3;

//3d-расстояние(Геоцентрика):
//9=WGS-1984:
function blz2blz_dist(b1,l1,h1,b2,l2,h2: Double; elp{9 = WGS-1984}: integer): Double; stdcall;




//2d-расстояние по эллипсоиду:
//elp: 9 = WGS-1984:
function dmd_2d_rad (bl1,bl2{rad}: tnum2;  elp{9}: Integer): double; stdcall;
function dmd_2d_rad2(bl1,bl2{rad}: tnum2;  elp{9}: Integer; var azimut{RAD 0-2PI от X к Y}: double): double; stdcall;
function dmd_2d_grad(bl1,bl2{grad}: tnum2; elp{9}: Integer): double; stdcall;


implementation

uses
  Wcmn;


//3D-расстояние - перевод в ГЕОЦЕНТРИЧЕСКИЕ XYZ:

procedure bl_to_xyz(b,l,h: Double; elp{9 = WGS-1984}: Integer;
                    out x,y,z: Double); stdcall;
external 'dll_bl.dll';

function dmd_blh_rad_xyz(blh{rad}: tnum3; elp: Integer): tnum3;
begin
  bl_to_xyz(blh.p.x,blh.p.y,blh.z, elp, Result.p.x,Result.p.y,Result.z);
end;


//9=WGS-1984:
function blz2blz_dist(b1,l1,h1,b2,l2,h2: Double; elp{9 = WGS-1984}: integer): Double;
var v1,v2: tnum3;
begin
  bl_to_xyz(b1,l1,h1, elp, v1.p.x,v1.p.y,v1.z);
  bl_to_xyz(b2,l2,h2, elp, v2.p.x,v2.p.y,v2.z);
  Result := v3_dist(v1,v2);
end;


//2D-ГЕОДЕЗИЧЕСКОЕ расстояние (дуга эллипсоида БЕЗ УЧЁТА Z):

function Set_Ellipsoid(elp: Integer): Integer; stdcall;
external 'dll_bl.dll';

//требует Set_Ellipsoid:
//fi - azimuth(RAD от N по час.стр. 0-360); Result - distance(m):
function Geoid_Dist(b1,l1, b2,l2: double; var fi{RAD}: double): double; stdcall;
external 'dll_bl.dll';

//требует Set_Ellipsoid:
//fi - azimuth(RAD от N по час.стр. 0-360); r - длина дуги; Result - ???:
function Geoid_Forw(b1,l1, r{m},fi{RAD}: double; out b2,l2: double): double; stdcall;
external 'dll_bl.dll';


//-------- КАРТА ЗАКРЫТА: ------------------------------------

function dmd_2d_rad(bl1,bl2{rad}: tnum2; elp: Integer): double;
var az{азимут RAD 0-2PI от X к Y}: double;
begin
  //Толя: Set_Ellipsoid - обращение к таблице => можно каждый раз перед Geoid_Dist:
  Set_Ellipsoid(elp);
  Result:=Geoid_Dist(bl1.x,bl1.y, bl2.x,bl2.y, az);
end;

function dmd_2d_rad2(bl1,bl2{rad}: tnum2; elp{9}: Integer; var azimut{RAD 0-2PI от X к Y}: double): double;
begin
  //Толя: Set_Ellipsoid - обращение к таблице => можно каждый раз перед Geoid_Dist:
  Set_Ellipsoid(elp);
  Result:=Geoid_Dist(bl1.x,bl1.y, bl2.x,bl2.y, azimut);
end;

function dmd_2d_grad(bl1,bl2{grad}: tnum2; elp: Integer): double;
begin
  Result:=dmd_2d_rad(v_rad(bl1),v_rad(bl2), elp);
end;


end.
