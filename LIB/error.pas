(*
  Перепишите к себе "errors.pas"
  и заполните MyErMsgs
*)
unit error; interface

type
  TMyError = class
  private
  protected
    FMsg: string;//last ErrorMessage
    FStatus: longint;//last ErrorNumber, 0=>Ok
  public
    function Put(aStatus: longint): longint; virtual;//Result=last ErrorNumber; FMsg:=''
    function PutMsg(aStatus: longint; aMsg: string): longint; virtual;//Result=last ErrorNumber
    procedure Clear;//FStatus:=0; FMsg:='';
    function Print: string; virtual;

    property _: longint read FStatus;
    property Msg: string read FMsg;
  end;


implementation

uses SysUtils;


function TMyError.PutMsg(aStatus: longint; aMsg: string): longint;//Result=last ErrorNumber
begin
  if FStatus=0 then begin
    FStatus:=aStatus;
    FMsg:=aMsg;
  end;
  Result:=FStatus;
end;

function TMyError.Put(aStatus: longint): longint;//Result=last ErrorNumber
begin
  Result:=PutMsg(aStatus,'');
end;

procedure TMyError.Clear;
begin
  FStatus:=0;
  FMsg:='';
end;

function TMyError.Print: string;
begin
  Result := Format('%d: %s',[FStatus, FMsg]);
end;

end.
