(*
  Включение этого модуля приводит к нормальной выгрузке из памяти на NT(!)
  программы, использующей OLE,COM (Семенович).
*)
unit xole; interface

uses
  ActiveX,Windows,SysUtils;

implementation

var
  ole_load: HResult;

function nt_CoInitialize: HResult;
type
  tinit = function(pvReserved: Pointer; coInit: Longint): HResult;
  stdcall;
var
  lib: HModule; init: tinit;
begin
  Result:=s_FALSE;

  lib:=LoadLibrary('OLE32.dll');
  if lib >= 32 then begin
    @init:=GetProcAddress(lib,'CoInitializeEx');
    if Assigned(init) then Result:=init(nil,0);
    FreeLibrary(lib)
  end
end;

initialization
begin
  if Win32Platform = Ver_Platform_Win32_NT then
    ole_load:=nt_CoInitialize
  else
    ole_load:=CoInitialize(nil);
end;

finalization
  if ole_load = S_OK then
  CoUninitialize;

end.







