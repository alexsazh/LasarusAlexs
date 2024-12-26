unit obj_intf; interface

uses
  Windows,OTypes,xlib;

type
  IObjAuto = interface(IUnknown)
    ['{38905320-23A7-479E-A8B7-A17E770F996D}']

    function Stop: HResult; stdcall;

    function Get_Count: int; stdcall;
    function Get_FName(Str: PChar; MaxLen: int): PChar; stdcall;
    procedure ItemColor(Ind: int; out Code,Loc: int; Str: PChar; MaxLen: int); stdcall;
    function ItemIndex(Code,Loc: int): int; stdcall;
    function Locate(Code,Loc: int): int; stdcall;
    function OpenDB(Path: PChar): int; stdcall;
  end;

  tdll_pipe = class(tlib)
    constructor Create;
    function GetObjAutoClient(out Obj): bool;
    function GetObjAutoServer(const Intf: IObjAuto; out Obj): bool;
  end;

implementation

constructor tdll_pipe.Create;
begin
  inherited Create('dll_pipe.dll')
end;

function tdll_pipe.GetObjAutoClient(out Obj): bool;
type
  tfunc = function(out Obj): HResult; stdcall;
var
  f: tfunc;
begin
  Result:=false; TPointer(Obj):=0;
  @f:=GetProc('GetObjAutoClient');
  if Assigned(f) then
  Result:=f(Obj) = S_OK
end;

function tdll_pipe.GetObjAutoServer(const Intf: IObjAuto; out Obj): bool;
type
  tfunc = function(const Intf: IObjAuto; out Obj): HResult; stdcall;
var
  f: tfunc;
begin
  Result:=false; TPointer(Obj):=0;
  @f:=GetProc('GetObjAutoServer');
  if Assigned(f) then
  Result:=f(Intf,Obj) = S_OK
end;

end.
