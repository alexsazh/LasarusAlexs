unit FR_Nmain;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TFfrmMain = class(TForm)
    Button1: TButton;
    Button5: TButton;
    Button2: TButton;
    ButtScale: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtScaleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FfrmMain: TFfrmMain;

implementation

uses fr_sea, NavyHead, UFrmnavy, NavScale, wmPick;

{$R *.lfm}

procedure TFfrmMain.Button1Click(Sender: TObject);
begin
Fseafrm.show
end;

procedure TFfrmMain.Button5Click(Sender: TObject);
begin
FnavyHead.Show;
end;

procedure TFfrmMain.Button2Click(Sender: TObject);
begin
FFrame.show
end;

procedure TFfrmMain.ButtScaleClick(Sender: TObject);
begin
FnavScale.show
end;
end.

