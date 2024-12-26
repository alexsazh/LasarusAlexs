unit gslib; interface

uses Windows, SysUtils;


function gsl_exec_gs2(GsPath, IncDirs, params: string; _wait{ожидание окончания}: boolean): boolean;


implementation

uses wcmn;


function gsl_exec_gs2(GsPath, IncDirs, params: string; _wait{ожидание окончания}: boolean): boolean;
var GsInc, sexec: string;
begin
  GsInc := wcmn_file_dir0(GsPath);
  if IncDirs<>'' then GsInc := GsInc + ';' + IncDirs;
  sexec := Format('%s -q -I%s %s',[GsPath,GsInc,params]);
  Result:=run(sexec,_wait{ожидание окончания});
end;


end.
