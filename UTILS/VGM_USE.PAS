unit vgm_use; interface

uses
  OTypes;

function obj_Open(fn: PChar): Boolean; stdcall;
procedure obj_Close; stdcall;

function obj_Count: Integer; stdcall;

procedure obj_Item(Ind: Integer;
                   out Code,Loc,Color: Integer;
                   Name: PChar); stdcall;

procedure obj_Color_to_Pen(Color: Integer;
                           out mm,tag,width: Integer;
                           out style,pcolor: Integer); stdcall;

procedure obj_Color_to_Brush(Color: Integer;
                             out fc,pc,msk: Integer); stdcall;

procedure obj_Color_to_Font(Color: Integer;
                            out fnt,cl: Integer;
                            out height: Float); stdcall;

function vgm_Open(fn: PChar; rw: Boolean): Boolean; stdcall;
function vgm_Count: Integer; stdcall;

function vgm_Index_Of_Code(Code: Integer): Integer; stdcall;

function Vgm_Height(vgm_Ind: Integer): Double; stdcall;

function vgm_Get_hdr(vgm_Ind: Integer;
                     out w,h: Integer): Integer; stdcall;

function vgm_Get_poly(vgm_Ind,lp_i: Integer; out cl: Integer;
                      lp: PLLine; lp_Max: Integer): Integer; stdcall;
// Return 2 - Polyline; 3 - Polygon                     

implementation

const
  vgm_dll = 'dll_vgm.dll';

function obj_Open(fn: PChar): Boolean;
external vgm_dll;

procedure obj_Close;
external vgm_dll;

function obj_Count: Integer;
external vgm_dll;

procedure obj_Item(Ind: Integer;               // > 0
                   out Code,Loc,Color: Integer;
                   Name: PChar);
external vgm_dll;

procedure obj_Color_to_Pen(Color: Integer;
                           out mm,tag,width: Integer;
                           out style,pcolor: Integer);
external vgm_dll;

procedure obj_Color_to_Brush(Color: Integer;
                             out fc,pc,msk: Integer);
external vgm_dll;

procedure obj_Color_to_Font(Color: Integer;
                            out fnt,cl: Integer;
                            out height: Float);
external vgm_dll;

function vgm_Open(fn: PChar; rw: Boolean): Boolean;
external vgm_dll;

function vgm_Count: Integer;
external vgm_dll;

function vgm_Index_Of_Code(Code: Integer): Integer;
external vgm_dll;

function Vgm_Height(vgm_Ind: Integer): Double; // > 0
external vgm_dll;

function vgm_Get_hdr(vgm_Ind: Integer;         // > 0
                     out w,h: Integer): Integer;
external vgm_dll;

function vgm_Get_poly(vgm_Ind,lp_i: Integer; out cl: Integer;
                      lp: PLLine; lp_Max: Integer): Integer;
external vgm_dll;

end.
