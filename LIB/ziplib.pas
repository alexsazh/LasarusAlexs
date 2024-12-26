unit ziplib; interface


function ziplib_1(source, dest: string): boolean;//��� ��������, ��� <= 8 ��������(!)


implementation

uses SysUtils, wcmn, errors;


function _zip_path: string;
begin
  Result := ExeDir+'pkzip.exe';
end;

function ziplib_1(source, dest: string): boolean;//��� ��������
var scmd,sexe: string;
begin
  Result:=false;
  sexe:=_zip_path;
  if FileExists(sexe) then begin
    if FileExists(dest) and not DeleteFile(dest) then MyEr.PutMsg(4,dest);
    scmd:=Format('%s %s %s',[_zip_path, dest, source]);
    if MyEr._=0 then Result:=run(scmd, true);
  end else begin
    Tellf('��������� "%s" �� �������',[sexe]);
  end;
end;


end.
