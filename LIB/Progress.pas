unit Progress;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, SysUtils, Classes, Graphics, Forms, Controls,
  Buttons, ExtCtrls, ComCtrls;

type
  TProgressForm = class(TForm)
    ProgressBar1: TProgressBar;
  end;

  TProgressX = class
  private
    ProgressForm: TProgressForm;
    procedure SetCaption(aCaption: string);
  public
    constructor Create(aCaption: string);
    destructor Destroy; override;
    procedure Go(aPercent: Integer);

    property Caption: string write SetCaption;
  end;

implementation

{$R *.lfm}

constructor TProgressX.Create(aCaption: string);
begin
  ProgressForm:=TProgressForm.Create(nil);
  ProgressForm.Caption:=aCaption;
  ProgressForm.Show;
end;

destructor TProgressX.Destroy;
begin
  ProgressForm.Free;
end;

procedure TProgressX.SetCaption(aCaption: string);
begin
  ProgressForm.Caption:=aCaption;
end;

procedure TProgressX.Go(aPercent: Integer);
begin
  ProgressForm.ProgressBar1.Position:=aPercent;
end;


end.
