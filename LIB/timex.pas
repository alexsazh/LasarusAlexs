unit timex;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ComCtrls;

type
  TFormTime = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DateTimePicker1: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
  private
    procedure SetTime(aTime: TDateTime);
    function GetTime: TDateTime;
  public
    function Input: boolean;//default value =0
    function Input2(aCaption: string): boolean;//default value =0
    property Time: TDateTime read GetTime write SetTime;
  end;

var
  FormTime: TFormTime;

implementation

{$R *.dfm}

uses wcmn;

const Time000=1000;//иначе с ошибкой переходит через ноль

{ private: }

procedure TFormTime.SetTime(aTime: TDateTime);
begin
  DateTimePicker1.DateTime:=aTime+Time000;//иначе с ошибкой переходит через ноль
end;

function TFormTime.GetTime: TDateTime;
begin
  Result:=DateTimePicker1.DateTime-Time000;//иначе с ошибкой переходит через ноль
end;

{ public: }

function TFormTime.Input: boolean;
begin
  Caption := 'Время';
  Result := ShowModal=mrYes ;
end;

function TFormTime.Input2(aCaption: string): boolean;
begin
  Caption := aCaption;
  Result := ShowModal=mrYes ;
end;

{ Events: }

procedure TFormTime.FormCreate(Sender: TObject);
begin
  SetTime(0);//default value
end;

end.
