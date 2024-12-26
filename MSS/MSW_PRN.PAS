unit MSW_PRN;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Spin, SysUtils, Dialogs;

type

  { TFormPrnCnv }

  TFormPrnCnv = class(TForm)
    Page1: TPage;
    Page2: TPage;
    PrnCnv: TNotebook;
    ToFile: TCheckBox;
    Label1: TLabel;
    PrnRes: TSpinEdit;
    Label2: TLabel;
    PrnList: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CnvRes: TSpinEdit;
    CnvList: TComboBox;
    OutputFile: TEdit;
    ButtonSave: TButton;
    SaveDialog1: TSaveDialog;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonPrnCloseClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  FormPrnCnv: TFormPrnCnv;


{----------------------------------------------}
implementation
{$R *.lfm}
uses Wcmn,MSW_1;
{----------------------------------------------}

//const FormCaptions: array[0..1]of pchar = ('Печать','Конвертирование');


procedure TFormPrnCnv.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPrnCnv.OKBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPrnCnv.FormShow(Sender: TObject);
var ind: word;
begin
  Font:=FormMain.Font;

  ind := FormMain.ModeGroup.ItemIndex - 1 ;
  PrnCnv.PageIndex := ind;
  //Caption := StrPas(FormCaptions[ind]);
end;

procedure TFormPrnCnv.ButtonPrnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPrnCnv.ButtonSaveClick(Sender: TObject);
begin
   SaveDialog1.FileName := OutputFile.Text;
   if SaveDialog1.Execute then begin
      OutputFile.Text := SaveDialog1.FileName;
   end;
end;

procedure TFormPrnCnv.FormCreate(Sender: TObject);
begin
  Ini.RForm(Self);

  //language from ExeName.msg:
  if wcmn_language_test('') then wcmn_language_form(Self);

  Ini.Section:='Print/Convert';

  PrnList.Text := Ini.RS('PrnDrv','ljet3');
  PrnRes.Value := Ini.RI('PrnRes',600);
  CnvList.Text := Ini.RS('CnvDrv','pcxmono');
  CnvRes.Value := Ini.RI('CnvRes',2540);

  ToFile.Checked := Ini.RB('ToFile',false);
  OutputFile.Text := Ini.RS('OutputFile','');
  if not FileExists(OutputFile.Text) then begin
    ToFile.Checked:=false;
    OutputFile.Text:='';
  end;
end;

procedure TFormPrnCnv.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);

  Ini.Section:='Print/Convert';

  Ini.WS('PrnDrv',PrnList.Text);
  Ini.WI('PrnRes',PrnRes.Value);
  Ini.WS('CnvDrv',CnvList.Text);
  Ini.WI('CnvRes',CnvRes.Value);

  Ini.WB('ToFile',ToFile.Checked);
  Ini.WS('OutputFile',OutputFile.Text);
end;

end.
