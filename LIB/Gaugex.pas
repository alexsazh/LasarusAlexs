unit Gaugex; interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Gauges, StdCtrls, Buttons;

type
  TFormGauge = class(TForm)
    Gauge: TGauge;
    BtnCancel: TBitBtn;
  private
    { Private declarations }
  public
    procedure Init(minvalue, maxvalue: longint; tittle: string);
    function  Add(delta: longint): boolean; {false=>Cancel}
    procedure Done;
  end;

var
  FormGauge: TFormGauge;

implementation

{$R *.DFM}


procedure TFormGauge.Init(minvalue, maxvalue: longint; tittle: string);
begin
  Gauge.MinValue := minvalue;
  Gauge.MaxValue := maxvalue;
  Gauge.Progress := minvalue;
  Caption := tittle;
  Show;
  {ShowModal;}
end;

function TFormGauge.Add(delta: longint): boolean;
begin
  Add := true;
  {Application.ProcessMessages;}
  Gauge.AddProgress(delta);
  {Add := Visible;}
end;

procedure TFormGauge.Done;
begin
  Hide;
end;


end.
