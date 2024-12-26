unit use_lnk; interface

uses
  Windows,OTypes;
  
type
  ILink2 = interface(IUnknown)
    ['{147182FD-27F7-4592-B202-86FEF081D480}']

    function Open(Path: PChar): Integer; stdcall;
    procedure SaveAs(Path: PChar); stdcall;

    function GetCount: Integer; stdcall;

    function ImageWidth: Integer; stdcall;
    function ImageHeight: Integer; stdcall;

    procedure GetSys(out sys: tsys); stdcall;
    procedure SetSys(sys: psys); stdcall;

    procedure GetPoint(Ind: Integer; out a,b: TGauss); stdcall;
    procedure SetPoint(Ind: Integer; a,b: PGauss); stdcall;

    procedure AddPoint(a,b: PGauss); stdcall;

    // pixel -> projection meter
    procedure l_to_g(ix,iy: Double; out ox,oy: Double); stdcall;

    // pixel -> latitude, longitude; GetSys(sys) && sys.prj > 0
    function l_to_r(ix,iy: Double; out ox,oy: Double): Integer; stdcall;

    procedure g_to_l(ix,iy: Double; out ox,oy: Double); stdcall;
    procedure r_to_l(ix,iy: Double; pps: Integer; out ox,oy: Double); stdcall;

    function Containsg(x,y: double): Boolean; stdcall;
  end;

function GetLink2Intf(const IID: TGUID; var Obj): HResult;

implementation

const
  dll_lnk = 'dll_lnk.dll';

var
  lnk_dll: THandle;

function GetLink2Intf(const IID: TGUID; var Obj): HResult;
type
  tfunc = function(const CLSID,IID: TGUID; var Obj): HResult; stdcall;
var
  func: tfunc;
begin
  Result:=S_FALSE; TPointer(Obj):=0;

  if lnk_dll = 0 then
  lnk_dll:=LoadLibrary('dll_lnk.dll');

  if lnk_dll >= 32 then begin
    @func:=GetProcAddress(lnk_dll,'DllGetInterface');
    if Assigned(func) then Result:=func(IID,IID,Obj)
  end
end;

initialization
begin
  lnk_dll:=0;
end;

finalization
begin
  if lnk_dll >= 32 then
  FreeLibrary(lnk_dll);
end;

end.

