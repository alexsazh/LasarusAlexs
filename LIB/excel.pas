unit excel; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  OleServer, ExcelXP;


//Приложение (рекомендовано держать только 1 запущенное приложение):
function excel_begin(_visible: boolean): boolean;//запуск ExcelApp, MSG
procedure excel_end;//закрытие ExcelApp

//Книга:
function excel_book_new: variant;//создаёт новую книгу и делает её текущей (активной)
procedure excel_book_saveas(fname: string);//запись в файл

//Разное:
function excel_column_s(cnum{>=1}: integer): string;//A..Z,AA..AZ,...


var
  ExcelApp: variant;//Excel Application, рекомендовано держать только 1 запущенное приложение


type
  TExcelForm = class(TForm)
    ExcelApplication1: TExcelApplication;//ДЛЯ ТЕСТОВ
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
    Tell('Ошибка запуска приложения "Excel"');
  end;
end;

procedure excel_end;
begin
  ExcelApp.Quit;
  ExcelApp:=Unassigned;//!
end;


function excel_book_new: variant;
begin
//1: "Лист1", "Лист1"
//6: "Книга1", "Лист1" - "без Basic"
  ExcelApp.WorkBooks.Add(1{>=1});
  Result := ExcelApp.WorkBooks.Item[ ExcelApp.WorkBooks.Count{последняя} ];
  Result.Activate;//?
end;

procedure excel_book_saveas(fname: string);
begin
  ExcelApp.DisplayAlerts:=False;//перезапись существ-го файла!
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
  nalfa:=icZ-icA+1;//кол-во в алфавите

  ic1 := icA-1 + (cnum div nalfa);//на 1-ом =0
  ic2 := icA-1 + (cnum mod nalfa);//внутри алфавита

  if cnum>nalfa{2 символа} then Result := char(ic1) + char(ic2)
  else Result := char(ic2);
end;


{ TExcelForm: }


end.
