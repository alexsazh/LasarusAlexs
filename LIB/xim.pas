unit xim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TFormImage = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
    function LoadFromFile(aFileName: string): boolean;//.bmp;.ico;.jpg;.jpeg;.wmf;.emf

    property Pixel[x: integer; x: integer;]
  end;

var
  FormImage: TFormImage;

implementation

{$R *.dfm}

uses wcmn;


function TFormImage.LoadFromFile(aFileName: string): boolean;
begin
  try
    Image1.Picture.LoadFromFile(aFileName);
    Result:=true;
  except
    Result:=false;
    Tellf('Необрабатываемый формат (%s)',[aFileName]);
  end;
end;

end.
