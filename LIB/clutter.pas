(*
  Вызов dm_Clutter перед созданием x.REL(relief.pas) определяет файл клеточек x.GSM
  Размер x.GSM - (w-1)*(h-1), где w*h - размер матрицы файла x.REL; элемент - WORD:
  Файл .CLU должен лежать в ExeDir
*)
unit clutter; interface

//файл для идентификации области с кодом LCode,
//в .GSM будут значения 0,1 (1 - on area)
//aShortName - короткое имя с расширением => ExeDir\aShortName
function clutter_make_file_01(aShortName: string; LCode: longint): boolean;


implementation

uses wcmn;


function clutter_make_file_01(aShortName: string; LCode: longint): boolean;
var f: TextFile;
begin
  Result:=false;
  if not ftopen(f, ExeDir+aShortName, 'w') then exit;
  try
    writeln(f, '0 0');//первый 0 - всегда 0; второй 0 - "GSM-код пустоты"
    writeln(f, LCode, ' 1');//Dm-код  GSM-код
    Result:=true;
  finally
    ftclose(f);
  end;
end;

end.
