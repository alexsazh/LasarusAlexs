unit tablib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, DBTables, StdCtrls, Buttons, ExtCtrls;

type
  TTabForm = class(TForm)
    DataSource1: TDataSource;
    Table1: TTable;
    DBGrid1: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TabForm: TTabForm;


type
  TTab = class
  private
    table: ttable;
    FileName: string;
  public
    ColCount: integer;
    RowCount: integer;
    function Open(aFileName: string): boolean;
    procedure Close;
    function ShowModal: boolean;
    procedure WriteToStrings(slist: TStrings);//по строкам
  end;



{ FUNCTIONS: }

function TabLib_Show(FileName: string): boolean;


implementation

{$R *.DFM}


{ FUNCTIONS: }

function TabLib_Show(FileName: string): boolean;
var Tab: TTab;
begin
  Result:=false;
  Tab:=TTab.Create;
  try
    if Tab.Open(FileName) then try
      Tab.ShowModal;
      Result:=true;
    finally
      Tab.Close;
    end;
  finally
    Tab.Free;
  end;
end;



{ TTab: }


function TTab.Open(aFileName: string): boolean;
begin
  Result:=false;
  if not FileExists(aFileName) then exit;

  FileName:=aFileName;
  Table:=TabForm.Table1;

  Table.TableName:=FileName;
  Table.Open;
  Result:=Table.Active;
//  TabForm.ShowModal;//DEBUG
  if Result then begin
    ColCount:=Table.FieldCount;
    RowCount:=Table.RecordCount;
  end;

end;

procedure TTab.Close;
begin
  if Table.Active then Table.Close;
end;


function TTab.ShowModal: boolean;
begin
  TabForm.Caption:=FileName;
  Result := TabForm.ShowModal=mrOk ;
end;


procedure TTab.WriteToStrings(slist: TStrings);
var i,j: integer; s: string;
begin
  slist.clear;

  table.First;
  if RowCount>0 then for j:=0 to RowCount-1 do begin
    if ColCount>0 then for i:=0 to ColCount-1 do begin
      s:=table.Fields[i].AsString;
      slist.Add(s);
    end;
    table.Next;
  end;//for j
end;


end.
