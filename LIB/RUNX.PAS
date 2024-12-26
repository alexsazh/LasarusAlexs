unit runx; interface


function run(cmd: string; wait: boolean): boolean;


implementation

uses windows, sysutils;


function run(cmd: string; wait: boolean): boolean;
var
  PROC_INFO: TProcessInformation;
  stinfo: tstartupinfo;
  zs: array [0..512] of Char;
begin
  Result := CreateProcess(NIL,StrPCopy(zs,cmd),NIL,
                        NIL,false,0,NIL,NIL,stinfo,PROC_INFO);
  if Result and wait then WaitForSingleObject(PROC_INFO.hProcess,INFINITE);
end;


end.
