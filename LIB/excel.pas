unit excel; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  OleServer, ExcelXP;


//���������� (������������� ������� ������ 1 ���������� ����������):
function excel_begin(_visible: boolean): boolean;//������ ExcelApp, MSG
procedure excel_end;//�������� ExcelApp

//�����:
function excel_book_new: variant;//������ ����� ����� � ������ � ������� (��������)
procedure excel_book_saveas(fname: string);//������ � ����

//������:
function excel_column_s(cnum{>=1}: integer): string;//A..Z,AA..AZ,...


var
  ExcelApp: variant;//Excel Application, ������������� ������� ������ 1 ���������� ����������


type
  TExcelForm = class(TForm)
    ExcelApplication1: TExcelApplication;//��� ������
  private
  public
  end;

var
  ExcelForm: TExcelForm;

implementation

{$R *.dfm}

uses
  ComObj,
  wcmn;


function excel_begin(_visible: boolean): boolean;
begin
  Result:=true;
  try
    ExcelApp:=CreateOleObject('Excel.Application');//IDispatch
    ExcelApp.Visible:=_visible;
  except
    Result:=false;//!
    ExcelApp:=Unassigned;//?
    Tell('������ ������� ���������� "Excel"');
  end;
end;

procedure excel_end;
begin
  ExcelApp.Quit;
  ExcelApp:=Unassigned;//!
end;


function excel_book_new: variant;
begin
//1: "����1", "����1"
//6: "�����1", "����1" - "��� Basic"
  ExcelApp.WorkBooks.Add(1{>=1});
  Result := ExcelApp.WorkBooks.Item[ ExcelApp.WorkBooks.Count{���������} ];
  Result.Activate;//?
end;

procedure excel_book_saveas(fname: string);
begin
  ExcelApp.DisplayAlerts:=False;//���������� �������-�� �����!
  try
    ExcelApp.ActiveWorkBook.SaveAs(fname);
  finally
    ExcelApp.DisplayAlerts:=True;//restore default
  end;
end;


function excel_column_s(cnum{>=1}: integer): string;//A..Z,AA..AZ,...
var icA,icZ,nalfa,ic1,ic2: integer;
begin
  Result := '';

  icA:=ord('A');
  icZ:=ord('Z');
  nalfa:=icZ-icA+1;//���-�� � ��������

  ic1 := icA-1 + (cnum div nalfa);//�� 1-�� =0
  ic2 := icA-1 + (cnum mod nalfa);//������ ��������

  if cnum>nalfa{2 �������} then Result := char(ic1) + char(ic2)
  else Result := char(ic2);
end;


{ TExcelForm: }


end.
