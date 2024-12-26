unit MSW_COL;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, SysUtils,
  Wcmn, CheckLst;

type

  { TColSepDlg }

  TColSepDlg = class(TForm)
    Model: TRadioGroup;
    Nb: TNotebook;
    Ok: TBitBtn;
    Cancel: TBitBtn;
    Page1: TPage;
    Page2: TPage;
    RGBList: TCheckListBox;
    CMYKList: TCheckListBox;
    procedure ModelClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Page1BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
  private
    procedure ColSepDlgUpdate;
  public
    { Public declarations }
  end;

var
  ColSepDlg: TColSepDlg;

  CMYKChecked: TStringlist;
  RGBChecked: TStringlist;

{-------------------------------------------------------------}
implementation

uses help;
{$R *.lfm}
{-------------------------------------------------------------}


procedure TColSepDlg.ColSepDlgUpdate;
begin
  NB.PageIndex := Model.ItemIndex;
  CMYKList.ItemIndex := 0;
  RGBList.ItemIndex := 0;
end;

{-------------------------------------------------------------}


procedure TColSepDlg.ModelClick(Sender: TObject);
begin
  ColSepDlgUpdate;
end;

procedure TColSepDlg.FormHide(Sender: TObject);
var i: integer; s: string;
begin
  //выбранные цвета: CMYK:
  CMYKChecked.Clear;
  for i:=0 to CMYKList.Items.Count-1 do begin
    if CMYKList.Checked[i] then CMYKChecked.Add(CMYKList.Items[i]);
  end;

  //выбранные цвета: RGB:
  RGBChecked.Clear;
  for i:=0 to RGBList.Items.Count-1 do begin
    if RGBList.Checked[i] then RGBChecked.Add(RGBList.Items[i]);
  end;

  Ini.Section:='Color';

  Ini.WI('Model',Model.ItemIndex);

  s:='';
  for i:=0 to CMYKList.Items.Count-1 do
    if CMYKList.Checked[i] then s:=s+Format('%d ',[i]);
  Ini.WS('CMYKListChecked',s);
  s:='';
  for i:=0 to RGBList.Items.Count-1 do
    if RGBList.Checked[i] then s:=s+Format('%d ',[i]);
  Ini.WS('RGBListChecked',s);
end;

procedure TColSepDlg.FormCreate(Sender: TObject);
var i: integer; s,si: string;
begin
  //language from ExeName.msg:
  if wcmn_language_test('') then wcmn_language_form(Self);

  Ini.Section:='Color';

  Model.ItemIndex := Ini.RI('Model',0);

  s := Ini.RS('CMYKListChecked','');
  while true do begin
    si:=sread_word(s);
    if si='' then break;
    i:=sread_int(si);
    if i<CMYKList.Items.Count then CMYKList.Checked[i]:=true;
  end;
  s := Ini.RS('RGBListChecked','');
  while true do begin
    si:=sread_word(s);
    if si='' then break;
    i:=sread_int(si);
    if i<RGBList.Items.Count then RGBList.Checked[i]:=true;
  end;

  ColSepDlgUpdate;
end;


procedure TColSepDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=112{F1} then begin
    Application.HelpCommand(HELP_CONTEXT, _help_colsep);
  end;//F1
end;

procedure TColSepDlg.Page1BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin

end;

initialization
  CMYKChecked:=TStringlist.Create;
  RGBChecked:=TStringlist.Create;
finalization
  CMYKChecked.Free;
  RGBChecked.Free;

end.
