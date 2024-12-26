unit RUNLINE2;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TRunForm = class(TForm)
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    ProgressBar2: TProgressBar;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FCancel: boolean;
  public
    function Cancelled: boolean;//<-Application.ProcessMessages
    procedure Start(aCaption: string);//SetWaitCursor;
    procedure Finish;//SetDefCursor;
    procedure Go(t: real); //0<=t<=1
    procedure Start2(aCaption: string);
    procedure Finish2;
    procedure Go2(t: real); //0<=t<=1
  end;

var RunForm: TRunForm;

implementation

uses Wcmn;

{$R *.lfm}


function TRunForm.Cancelled: boolean;
begin
  Application.ProcessMessages;
  Result:=FCancel;
end;


procedure TRunForm.Start(aCaption: string);
begin
  Caption := aCaption;
  Label1.Caption := '0%';
  Label2.Caption := '';
  ProgressBar1.Position := 0;
  ProgressBar2.Position := 0;
  FCancel:=false;
  SetWaitCursor;
  Show;
end;

procedure TRunForm.Finish;
begin
  SetDefCursor;
  Hide;
end;

procedure TRunForm.Go(t: real);
var percents: integer;
begin
  percents := Round(t*100);
  Label1.Caption := IntToStr(percents) + '%';
  ProgressBar1.Position := percents;
end;


procedure TRunForm.Start2(aCaption: string);
begin
  Label2.Caption := aCaption;
  ProgressBar2.Position := 0;
end;

procedure TRunForm.Finish2;
begin
  Label2.Caption := '';
  ProgressBar2.Position := 0;
end;

procedure TRunForm.Go2(t: real);
var percents: integer;
begin
  percents := Round(t*100);
  ProgressBar2.Position := percents;
end;

//-----------------------------------------------

procedure TRunForm.BitBtn1Click(Sender: TObject);
begin
  FCancel:=true;
end;

procedure TRunForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then BitBtn1Click(nil);
end;

end.
