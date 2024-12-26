unit Runline2; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons;

type
  TRunForm2 = class(TForm)
    BitBtn1: TBitBtn;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    ProgressBar2: TProgressBar;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FCancel: boolean;//после Finish остаётся!
    FIndex,FCount: integer;
    Fpercents: integer;
    procedure _Go(i,count: integer; t: real); //i=0..count-1, 0<=t<=1
  public
    Index: integer;//m.b.used in Go
    procedure Start(aCaption: string);//SetWaitCursor;
    procedure Finish;//SetDefCursor; FCancel не менять!
    procedure Go_i(i,count: integer); //i=0..count-1
    procedure Go_t(t: real); //0<=t<=1
    function Cancelled: boolean;//<-Application.ProcessMessages
    function Cancelled2(msg: string): boolean;//msg='Прервать?'
  end;

var
  RunForm2: TRunForm2;

implementation

uses wcmn;

{$R *.DFM}

procedure TRunForm2.Start(aCaption: string);
begin
  Caption := aCaption;
  FCancel:=false;
  SetWaitCursor;
  _Go(0,0,0);//!
end;

procedure TRunForm2.Finish;
begin
  //FCancel не менять!
  Hide;
  SetDefCursor;
end;

procedure TRunForm2._Go(i,count: integer; t: real);
var percents: integer;
begin
  percents := Round(t*100);
  if (count<>FCount) or (i<>FIndex) or (percents<>Fpercents) then begin
    Fpercents:=percents;
    FIndex:=i;
    FCount:=count;

    if count>0 then begin
      Label1.Caption := IntToStr(i+1) + '/' + IntToStr(count);
      ProgressBar1.Position := Round((i/count)*100);
    end else begin
      Label1.Caption := '';
      ProgressBar1.Position := 0;
    end;

    Label2.Caption := IntToStr(Fpercents) + '%';
    ProgressBar2.Position := Fpercents;

    Show;//!
    Application.ProcessMessages;
  end;
end;

procedure TRunForm2.Go_i(i,count: integer); //i=0..count-1
begin
  _Go(i,count, 0);
end;

procedure TRunForm2.Go_t(t: real); //0<=t<=1
begin
  _Go(FIndex,FCount, t);
end;

function TRunForm2.Cancelled: boolean;
begin
  Result:=Cancelled2('Прервать процесс?');
end;

function TRunForm2.Cancelled2(msg: string): boolean;
begin
  if FCancel then if not TellYN(msg) then FCancel:=false;
  Result:=FCancel;
end;

procedure TRunForm2.BitBtn1Click(Sender: TObject);
begin
  FCancel:=true;
end;

procedure TRunForm2.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then BitBtn1Click(nil);
end;

end.
