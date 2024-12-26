(*
  MyEr.SetMsg - заполнение списка сообщений
  MyEr.Put - ошибка (если уже _<>0, то старая остаётся)
*)
unit errors; interface

uses Classes, error;

type
  TMyErrors = class(TMyError)
  private
    FMyErMsgs: TStringList;
    procedure GrowMsgs;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetMsg(aStatus: integer; aMsg: string);//заполнение списка FMyErMsgs
    function PutMsg(aStatus: integer; aMsg: string): integer; override;//Result=last ErrorNumber
    function Put(aStatus: integer): integer; override;//Result=last ErrorNumber

    //from error.pas:
    //procedure Clear;
    //procedure Print: string;

    property _;//read only integer FStatus
    property Msg;//read only
  end;

var MyEr: TMyErrors;


implementation

uses SysUtils;


constructor TMyErrors.Create;
begin
  FMyErMsgs:=TStringList.Create;
end;

destructor TMyErrors.Destroy;
begin
  FMyErMsgs.Free;
end;

procedure TMyErrors.GrowMsgs;
var i: integer;
begin
  for i:=0 to 9 do FMyErMsgs.Add('');
end;

function TMyErrors.PutMsg(aStatus: integer; aMsg: string): integer;//Result=last ErrorNumber
begin
  if FStatus=0 then begin
    FStatus:=aStatus;
    if (aStatus>0) and (aStatus<FMyErMsgs.Count) then
    FMsg:=Format('%s (%s)',[FMyErMsgs[aStatus],aMsg]) else FMsg:=aMsg;
  end;
  Result:=FStatus;
end;

function TMyErrors.Put(aStatus: integer): integer;//Result=last ErrorNumber
var aMsg: string;
begin
  if (aStatus>0) and (aStatus<FMyErMsgs.Count) then aMsg:=FMyErMsgs[aStatus] else aMsg:='';
  Result := inherited PutMsg(aStatus,aMsg);
end;

procedure TMyErrors.SetMsg(aStatus: integer; aMsg: string);
begin
  while aStatus>=FMyErMsgs.Count do GrowMsgs;
  FMyErMsgs[aStatus]:=aMsg;
end;

initialization
  MyEr:=TMyErrors.Create;
finalization
  MyEr.Free;

end.
