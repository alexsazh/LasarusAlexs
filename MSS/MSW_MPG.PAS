unit Msw_mpg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls;

type
  TFormMPg = class(TForm)
    Label1: TLabel;
    EditCode: TEdit;
    Label2: TLabel;
    EditCut: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EditEps: TEdit;
    OKBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMPg: TFormMPg;

implementation

{$R *.DFM}

procedure TFormMPg.OKBtnClick(Sender: TObject);
begin
  Close;
end;


end. {of unit}
