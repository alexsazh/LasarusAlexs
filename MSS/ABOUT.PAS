unit ABOUT;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TAboutForm = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    Image2: TImage;
    Panel1: TPanel;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

uses Wcmn;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  //language from ExeName.msg:
  if wcmn_language_test('') then wcmn_language_form(Self);
  Image2.Picture.Icon:=Application.Icon;
end;

end.
