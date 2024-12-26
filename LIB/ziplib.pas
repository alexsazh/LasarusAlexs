unit ziplib; interface


function ziplib_1(source, dest: string): boolean;//без проверок, имя <= 8 символов(!)


implementation

uses SysUtils, wcmn, errors;


function _zip_path: string;
begin
  Result := ExeDir+'pkzip.exe';
end;

function ziplib_1(source, dest: string): boolean;//без проверок
var scmd,sexe: string;
begin
  Result:=false;
  sexe:=_zip_path;
  if FileExists(sexe) then begin
    if FileExists(dest) and not DeleteFile(dest) then MyEr.PutMsg(4,dest);
    scmd:=Format('%s %s %s',[_zip_path, dest, source]);
    if MyEr._=0 then Result:=run(scmd, true);
  end else begin
    Tellf('Программа "%s" не найдена',[sexe]);
  end;
end;


end.
