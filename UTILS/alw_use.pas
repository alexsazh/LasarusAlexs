unit alw_use; interface

uses
  OTypes;

type
  PPointItem = ^TPointItem;
  TPointItem = record
    x,y,z: SmallInt; gps_t: Word;
    alt,cod,int: Byte
  end;

  PPointBlock = ^TPointBlock;
  TPointBlock = record
    N_block: Word;                // Факт. кол-во точек в блоке
    X_ave: Double;                // Ср. значения <X,Y,Z>
    Y_ave: Double;
    Z_ave: Double;
    X_min: Double;                // Мин. и макс. значения <X,Y,Z>
    X_max: Double;
    Y_min: Double;
    Y_max: Double;
    Z_min: Double;
    Z_max: Double;
    gps_time_min: Double;       	// Мин. и макс. GPS времени
    gps_time_max: Double;
    Z_sko: Double;                // СКО по Z
    I_reg: Word;                	// Номер режима
    Intens_min: SmallInt;
    Intens_max: SmallInt;
    Intens_ave: SmallInt;
    Intens_sko: SmallInt;
  end;

  PIgnorItem = ^TIgnorItem;
  TIgnorItem = record
    dh: Longint;
    dx,dy,cod: Byte;
    intense: Byte;
  end;
  
function alx_Open(Path: PChar): Boolean; stdcall;
procedure alx_Close; stdcall;

function alx_Is_Intense: Boolean; stdcall;

function alx_Get_Bound(out lt,rb: txyz): Integer; stdcall;

function alx_Get_BlockCount: Integer; stdcall;

function alx_Get_Block(I: Integer; Block: PPointBlock): PPointItem; stdcall;

function alx_Get_RegularSize(out I_max,J_max: Integer): Integer; stdcall;
function alx_Get_RegularBlock(I,J: Integer): PIgnorItem; stdcall;
function alx_Get_RegularBase(I,J: Integer): Double; stdcall;
function alx_Get_RegularIntense(I,J: Integer): Integer; stdcall;
{
    I: 0..I_max J: 0..J_max
    x1:=ignol_X0 + I*250; x2:=x1 + 250;
    y1:=ignol_Y0 + J*250; y2:=y1 + 250;
}

procedure alx_Tower_Matrix_identify; stdcall;

procedure alx_Tower_Matrix_Orient(a,b: PGauss;
                                  z0,h1,fx,fy: Double); stdcall;
{   ось X - по вектору знака
    h1 - 1   характеристика
    fx - 711 характеристика - вращение вокруг оси X, по вектору знака
    fy - 710 характеристика - вращение вокруг оси Y, ось Y - влево

    ось X - по вектору знака, ось Y - влево, ось Z - вверх
    поворот - вокруг оси X, потом - оси Y, потом - оси Z.
}

function alx_Tower_Matrix: PDoubles; stdcall;

function alx_Tower_Count: Integer; stdcall;

function alx_Tower_Get_Name(Ind: Integer; Str: PChar): PChar;
stdcall;

function alx_Open_tower(Name: PChar): Boolean; stdcall;

function alx_Tower_Point_Count: Integer; stdcall;
procedure alx_Tower_Get_Point(Ind: Integer; out v: txyz); stdcall;

function alx_Tower_Rib_Count: Integer; stdcall;
procedure alx_Tower_Get_Rib(Ind: Integer; out v1,v2: txyz); stdcall;

function alx_Tower_Typ_Rib(Ind: Integer; out v1,v2: txyz): Integer;//=0 - конструктив
stdcall;

implementation

const
  dll_alw = 'dll_alw.dll';

function alx_Open(Path: PChar): Boolean; external dll_alw;
procedure alx_Close; external dll_alw;

function alx_Is_Intense: Boolean; external dll_alw;

function alx_Get_Bound(out lt,rb: txyz): Integer; external dll_alw;

function alx_Get_BlockCount: Integer; external dll_alw;

function alx_Get_Block(I: Integer; Block: PPointBlock): PPointItem;
external dll_alw;

function alx_Get_RegularSize(out I_max,J_max: Integer): Integer;
external dll_alw;

function alx_Get_RegularBlock(I,J: Integer): PIgnorItem;
external dll_alw;

function alx_Get_RegularBase(I,J: Integer): Double;
external dll_alw;

function alx_Get_RegularIntense(I,J: Integer): Integer;
external dll_alw;

procedure alx_Tower_Matrix_identify;
external dll_alw;

procedure alx_Tower_Matrix_Orient(a,b: PGauss;
                                  z0,h1,fx,fy: Double);
external dll_alw;

function alx_Tower_Matrix: PDoubles;
external dll_alw;

function alx_Tower_Count: Integer;
external dll_alw;

function alx_Tower_Get_Name(Ind: Integer; Str: PChar): PChar;
external dll_alw;

function alx_Open_tower(Name: PChar): Boolean;
external dll_alw;

function alx_Tower_Point_Count: Integer;
external dll_alw;

procedure alx_Tower_Get_Point(Ind: Integer; out v: txyz);
external dll_alw;

function alx_Tower_Rib_Count: Integer;
external dll_alw;
procedure alx_Tower_Get_Rib(Ind: Integer; out v1,v2: txyz);
external dll_alw;
function alx_Tower_Typ_Rib(Ind: Integer; out v1,v2: txyz): Integer;
external dll_alw;

end.
