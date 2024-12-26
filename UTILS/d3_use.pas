unit d3_use;

{$MODE Delphi}

 interface

uses
  OTypes;

type
  pgl_xyz = ^tgl_xyz;
  tgl_xyz = record x,y,z: Single end;

  pgl_vpoints = ^tgl_vpoints;
  tgl_vpoints = array[0..1023] of tgl_xyz;

function rel_Open(fn: PChar): Boolean; stdcall;
function rel_Update(fn: PChar): Boolean; stdcall;
procedure rel_Close; stdcall;

function rel_Handle: Pointer; stdcall;

procedure rel_Info(out XTiles,YTiles: Integer;
                   out TileWidth,TileHeight: Integer;
                   out xmin,ymin,zmin: Double;
                   out xmax,ymax,zmax: Double;
                   out a0,k0: Double); stdcall;

function rel_Tile(i,j: Integer; buf: PWords): Boolean; stdcall;
procedure rel_SetTile(i,j: Integer; buf: PWords); stdcall;
function rel_Norm(i,j: Integer): pgl_vpoints; stdcall;
function rel_ZRange(i,j: Integer; out z1,z2: Double): Boolean; stdcall;
function rel_Value(x,y: Double; out z: Double): Boolean; stdcall;
function rel_Value1(r: PGeoPoint; out z: Double): Boolean; stdcall;
procedure rel_Get_sys(out sys: tsys); stdcall;
function rel_to_bl(x,y: Double; out b,l: Double): Integer; stdcall;
procedure rel_l_to_g(ip,jp,ix,iy: Integer; out gx,gy: Double); stdcall;
procedure rel_g_to_l(gx,gy: Double; out px,py: Double); stdcall;

function rm_Open(fn: PChar; rw: Boolean): Pointer; stdcall;
procedure rm_Close(rm: Pointer); stdcall;

procedure rm_Info(rm: Pointer;
                  out XTiles,YTiles: Integer;
                  out TileWidth,TileHeight: Integer;
                  out xmin,ymin,zmin: Double;
                  out xmax,ymax,zmax: Double;
                  out a0,k0: Double); stdcall;

function rm_GetTile(rm: Pointer;
                    i,j: Integer; buf: PWords): Boolean; stdcall;

procedure rm_SetTile(rm: Pointer;
                     i,j: Integer; buf: PWords); stdcall;

function rm_ZRange(rm: Pointer;
                   i,j: Integer; out z1,z2: Double): Boolean; stdcall;

function rm_Value(rm: Pointer;
                  x,y: Double; out z: Double): Boolean; stdcall;

function rm_Value1(rm: Pointer;
                   r: PGeoPoint; out z: Double): Boolean; stdcall;

procedure rm_Get_sys(rm: Pointer; out sys: tsys); stdcall;

function rm_g_to_bl(rm: Pointer;
                    x,y: Double; out b,l: Double): Integer; stdcall;

function rm_l_to_bl(rm: Pointer;
                    x,y: Double; out b,l: Double): Integer; stdcall;

procedure rm_l_to_g(rm: Pointer;
                    ip,jp,ix,iy: Integer; out gx,gy: Double); stdcall;

procedure rm_g_to_l(rm: Pointer;
                    gx,gy: Double; out px,py: Double); stdcall;

function rm_GetBoundPolyCount(rm: Pointer): Integer; stdcall;
// return Polygons Count

function rm_GetBoundPoly(rm: Pointer;
                         Ind: Integer; out lp: PLPoly): Integer;
stdcall;
// return Ind - polygon

function tiff_get_bound(Path: PChar; g: PGPoly): Integer; stdcall;
// Return: 0=meter; 1=radian

function jgw_xy_to_bl(x,y: Double; out b,l: Double): Integer; stdcall;
// Return: 0=meter; 1=radian

implementation

const
  dll_d3 = 'dll_d3.dll';

function rel_Open(fn: PChar): Boolean; stdcall;
external dll_d3;
function rel_Update(fn: PChar): Boolean; stdcall;
external dll_d3;
procedure rel_Close; stdcall;
external dll_d3;

function rel_Handle: Pointer; stdcall;
external dll_d3;

procedure rel_Info(out XTiles,YTiles: Integer;
                   out TileWidth,TileHeight: Integer;
                   out xmin,ymin,zmin: Double;
                   out xmax,ymax,zmax: Double;
                   out a0,k0: Double); stdcall;
external dll_d3;

function rel_Tile(i,j: Integer; buf: PWords): Boolean; stdcall;
external dll_d3;
procedure rel_SetTile(i,j: Integer; buf: PWords); stdcall;
external dll_d3;
function rel_Norm(i,j: Integer): pgl_vpoints; stdcall;
external dll_d3;
function rel_ZRange(i,j: Integer; out z1,z2: Double): Boolean; stdcall;
external dll_d3;
function rel_Value(x,y: Double; out z: Double): Boolean; stdcall;
external dll_d3;
function rel_Value1(r: PGeoPoint; out z: Double): Boolean; stdcall;
external dll_d3;
procedure rel_Get_sys(out sys: tsys); stdcall;
external dll_d3;
function rel_to_bl(x,y: Double; out b,l: Double): Integer; stdcall;
external dll_d3;
procedure rel_l_to_g(ip,jp,ix,iy: Integer; out gx,gy: Double); stdcall;
external dll_d3;
procedure rel_g_to_l(gx,gy: Double; out px,py: Double); stdcall;
external dll_d3;

function rm_Open(fn: PChar; rw: Boolean): Pointer; stdcall;
external dll_d3;

procedure rm_Close(rm: Pointer); stdcall;
external dll_d3;

procedure rm_Info(rm: Pointer;
                  out XTiles,YTiles: Integer;
                  out TileWidth,TileHeight: Integer;
                  out xmin,ymin,zmin: Double;
                  out xmax,ymax,zmax: Double;
                  out a0,k0: Double); stdcall;
external dll_d3;

function rm_GetTile(rm: Pointer;
                    i,j: Integer; buf: PWords): Boolean; stdcall;
external dll_d3;

procedure rm_SetTile(rm: Pointer;
                     i,j: Integer; buf: PWords); stdcall;
external dll_d3;

function rm_ZRange(rm: Pointer;
                   i,j: Integer; out z1,z2: Double): Boolean; stdcall;
external dll_d3;

function rm_Value(rm: Pointer;
                  x,y: Double; out z: Double): Boolean; stdcall;
external dll_d3;

function rm_Value1(rm: Pointer;
                   r: PGeoPoint; out z: Double): Boolean; stdcall;
external dll_d3;

procedure rm_Get_sys(rm: Pointer; out sys: tsys); stdcall;
external dll_d3;

function rm_g_to_bl(rm: Pointer;
                    x,y: Double; out b,l: Double): Integer; stdcall;
external dll_d3;

function rm_l_to_bl(rm: Pointer;
                    x,y: Double; out b,l: Double): Integer; stdcall;
external dll_d3;

procedure rm_l_to_g(rm: Pointer;
                    ip,jp,ix,iy: Integer; out gx,gy: Double); stdcall;
external dll_d3;

procedure rm_g_to_l(rm: Pointer;
                    gx,gy: Double; out px,py: Double); stdcall;
external dll_d3;

function rm_GetBoundPolyCount(rm: Pointer): Integer;
external dll_d3;

function rm_GetBoundPoly(rm: Pointer;
                         Ind: Integer; out lp: PLPoly): Integer;
external dll_d3;

function tiff_get_bound(Path: PChar; g: PGPoly): Integer; stdcall;
external dll_d3;

function jgw_xy_to_bl(x,y: Double; out b,l: Double): Integer; stdcall;
external dll_d3;

end.
