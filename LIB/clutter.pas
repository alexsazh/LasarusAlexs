(*
  ����� dm_Clutter ����� ��������� x.REL(relief.pas) ���������� ���� �������� x.GSM
  ������ x.GSM - (w-1)*(h-1), ��� w*h - ������ ������� ����� x.REL; ������� - WORD:
  ���� .CLU ������ ������ � ExeDir
*)
unit clutter; interface

//���� ��� ������������� ������� � ����� LCode,
//� .GSM ����� �������� 0,1 (1 - on area)
//aShortName - �������� ��� � ����������� => ExeDir\aShortName
function clutter_make_file_01(aShortName: string; LCode: longint): boolean;


implementation

uses wcmn;


function clutter_make_file_01(aShortName: string; LCode: longint): boolean;
var f: TextFile;
begin
  Result:=false;
  if not ftopen(f, ExeDir+aShortName, 'w') then exit;
  try
    writeln(f, '0 0');//������ 0 - ������ 0; ������ 0 - "GSM-��� �������"
    writeln(f, LCode, ' 1');//Dm-���  GSM-���
    Result:=true;
  finally
    ftclose(f);
  end;
end;

end.
