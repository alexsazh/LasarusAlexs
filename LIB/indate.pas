//¬вод даты
unit indate; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFormDate = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditDay: TEdit;
    EditMonth: TEdit;
    EditYear: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    FDate: TDateTime;//defined, if Execute
  public
    function Execute(aDate: TDateTime): boolean;//=>FDate
    function Date: TDateTime;//FDate->
    function sDate: string;//FDate->s
  end;

var
  FormDate: TFormDate;

implementation

{$R *.DFM}

uses wcmn;


function TFormDate.Execute(aDate: TDateTime): boolean;
var aYear, aMonth, aDay: Word;
begin
  Result:=false;

  DecodeDate(aDate, aYear, aMonth, aDay);
  EditDay.Text:=IntToStr(aDay);
  EditMonth.Text:=IntToStr(aMonth);
  EditYear.Text:=IntToStr(aYear);

  if ShowModal=mrOk then begin
    aDay:=ivaldef(EditDay.Text,1);
    aMonth:=ivaldef(EditMonth.Text,1);
    aYear:=ivaldef(EditYear.Text,2000);
    FDate:=EncodeDate(aYear, aMonth, aDay);
    Result:=true;
  end;
end;

function TFormDate.Date: TDateTime;//FDate->
begin
  Result:=FDate;
end;

function TFormDate.sDate: string;//FDate->s
begin
  Result:=FormatDateTime('d mmm yyyy', FDate);
end;


end.
