unit input; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TInputForm = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    function InputStr(aCaption: string; var Data: string): boolean;
    function InputInt(aCaption: string; var Data: Integer): boolean;
    function InputNum(aCaption: string; var Data: Integer): boolean;{Data>0}
  end;

var
  InputForm: TInputForm;

implementation

uses wcmn;

{$R *.DFM}

function TInputForm.InputStr(aCaption: string; var Data: string): boolean;
begin
  Result := false;
  Caption := aCaption;
  Edit1.Text := Data;
  if ShowModal<>mrOk then exit;
  Data := Edit1.Text;
  Result := true;
end;

function TInputForm.InputInt(aCaption: string; var Data: Integer): boolean;
label Start;
var n: Integer;
begin
  Result := false;
  Caption := aCaption;
  Edit1.Text := IntToStr(Data);
Start:
  if ShowModal<>mrOk then exit;
  n := ivaldef(Edit1.Text, 0);
  if not isintstring(Edit1.Text) then begin
    Tell('¬ведите целое число');
    goto Start;
  end;
  Data := n;
  Result := true;
end;

{Data>0}
function TInputForm.InputNum(aCaption: string; var Data: Integer): boolean;
label Start;
var n: Integer;
begin
  Result := false;
  Caption := aCaption;
  Edit1.Text := IntToStr(Data);
Start:
  if ShowModal<>mrOk then exit;
  n := ivaldef(Edit1.Text, -1);
  if not isdigitstring(Edit1.Text) or (n<=0) then begin
    Tell('¬ведите целое положительное число');
    goto Start;
  end;
  Data := n;
  Result := true;
end;

procedure TInputForm.FormShow(Sender: TObject);
begin
  ActiveControl:=Edit1
end;

end.
