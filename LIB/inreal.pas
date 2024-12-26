unit inreal; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TInRealForm = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
    function InputReal(aCaption: string; var r: double): boolean;//r надо задавать!
  end;

var
  InRealForm: TInRealForm;

implementation

uses wcmn;

{$R *.DFM}

function TInRealForm.InputReal(aCaption: string; var r: double): boolean;
begin
  Result := false;
  Caption := aCaption;
  Edit1.Text := Format('%.2f',[r]);
  if ShowModal<>mrOk then exit;
  r := rvaldef(Edit1.Text, 0);
  Result := true;
end;


{ Events: }

procedure TInRealForm.FormShow(Sender: TObject);
begin
  ActiveControl:=Edit1;
end;

procedure TInRealForm.FormCreate(Sender: TObject);
begin
  Ini.RForm(Self);
end;

procedure TInRealForm.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);
end;

end.
