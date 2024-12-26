unit Runline;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons;

type
  TRunForm = class(TForm)
    BitBtn1: TBitBtn;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FCancel: boolean;//после Finish остаётся!
    Fpercents: integer;
  public
    Index: integer;//m.b.used in Go
    procedure Start(aCaption: string; aStartLabel: string = '');//SetWaitCursor;
    procedure Finish;//SetDefCursor; FCancel не менять!
    procedure Go(t: real); //0<=t<=1
    procedure Go2(i,count: integer); overload;//i=0..count-1
    procedure Go2(i,count, _mod{10,100,...}: integer); overload;//i=0..count-1
    function Cancelled: boolean;//<-Application.ProcessMessages
    function Cancelled2(msg: string): boolean;//msg='Прервать?'

    property Cancel: boolean read FCancel;
  end;

var
  RunForm: TRunForm;

implementation

uses Wcmn;

{$R *.lfm}

procedure TRunForm.Start(aCaption: string; aStartLabel: string);
begin
  Caption := aCaption;
  FCancel:=false;
  SetWaitCursor;
  Fpercents:=-99;//!

  Go(0);//!

  Label1.Caption := aStartLabel;//!
  Application.ProcessMessages;
end;

procedure TRunForm.Finish;
begin
  //FCancel не менять!
  Hide;
  SetDefCursor;

  Application.ProcessMessages;
end;

procedure TRunForm.Go(t: real);
var percents: integer;
begin
  percents := Round(t*100);
  if percents<>Fpercents then begin
    Fpercents:=percents;
    Label1.Caption := IntToStr(Fpercents) + '%';
    ProgressBar1.Position := Fpercents;
    Show;//!
    Application.ProcessMessages;
  end;
end;

procedure TRunForm.Go2(i,count: integer);//i=0..count-1
begin
    Application.ProcessMessages;
    Label1.Caption := IntToStr(i+1) + '/' + IntToStr(count);
    ProgressBar1.Position := Round((i/count)*100);
    Show;//!
end;

procedure TRunForm.Go2(i,count, _mod{10,100,...}: integer);//i=0..count-1
begin
  //Application.ProcessMessages;
  if i mod _mod<>0 then begin
    Application.ProcessMessages;
    EXIT;//пропускание!
  end;
  Go2(i,count);
end;

function TRunForm.Cancelled: boolean;
begin
  Result:=Cancelled2('Прервать процесс?');
end;

function TRunForm.Cancelled2(msg: string): boolean;
begin
  Application.ProcessMessages;//!
  if FCancel then if not TellYN(msg) then FCancel:=false;
  Result:=FCancel;
end;

procedure TRunForm.BitBtn1Click(Sender: TObject);
begin
  FCancel:=true;
end;

procedure TRunForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then BitBtn1Click(nil);
end;


initialization
  RunForm:=NIL;//for Assigned-test - for use in DLL!

finalization
  //if Assigned(RunForm) then RunForm.Free;//for DLL! --- НЕЛЬЗЯ в EXE!!!

end.


