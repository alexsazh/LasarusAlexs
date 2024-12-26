unit wait;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormWait = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  FormWait: TFormWait;


//использовать в блоке try-finally(!):
procedure wait_show(msg: string);
procedure wait_show2(msg: string);//только если FormWait.Visible
procedure wait_hide;


implementation

{$R *.lfm}

uses Wcmn;


procedure wait_show(msg: string);
begin
  SetWaitCursor;//!
  FormWait.Caption := Application.ExeName;
  FormWait.Label1.Caption := msg;
  FormWait.Hint:=FormWait.Label1.Caption;//!
  FormWait.Show;//нельзя ShowModal!
  FormWait.Refresh;//!
  Application.ProcessMessages;//!
end;

procedure wait_show2(msg: string);
begin
  if FormWait.Visible then wait_show(msg);
end;

procedure wait_hide;
begin
  FormWait.Hide;
  SetDefCursor;//!
  Application.ProcessMessages;
end;

{ Events: }

procedure TFormWait.FormCreate(Sender: TObject);
begin
  //language from ExeName.msg:
  if wcmn_language_test('') then wcmn_language_form(Self);

  //Ini.RForm(Self);
end;

procedure TFormWait.FormDestroy(Sender: TObject);
begin
  //Ini.WForm(Self);
end;

end.
