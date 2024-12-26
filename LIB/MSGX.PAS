//msg - сообщения
unit MSGX;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMsgForm = class(TForm)
    Label1: TLabel;
  private
  public
    procedure Open(sFmt: string; Args: array of const);
  end;

var
  MsgForm: TMsgForm;

implementation

{$R *.lfm}

procedure TMsgForm.Open(sFmt: string; Args: array of const);
begin
  Caption:=Application.ExeName;
  Label1.Caption:=Format(sFmt,Args);
  Hint:=Label1.Caption;//!
  Show;//ShowModal - всё останавливается до закрытия
  SetFocus;
  Application.ProcessMessages;
end;

end.
