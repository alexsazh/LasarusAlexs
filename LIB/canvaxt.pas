(*
  ����� on TCanvax(canvax.pas):
  TCanvaxText - ������ (���) ������ ������ on TCanvax
  TCanvaxStr - TCanvaxText ������ �� �������
  TCanvaxText,TCanvaxStr ������ FCanvax.Canvas.Font(!!!), ����� ���� FFont(!)
*)
unit canvaxt; interface

uses
  Graphics{TCanvas, TColor}, Types{TRect},
  canvax;


type
  //���� ������������ ������:
  TTextAlignX = (ttax_Left, ttax_Right, ttax_Center);
  TTextAlignY = (ttay_Top, ttay_Bottom, ttay_Center);

  //������ (���) ������ ������ on TCanvax:
  //"�������� ������" - �����, � �-�� ������������ ���� ��� �������� ������ � ���-�� �� Alignment:
  TCanvaxText = class
  protected
    FCanvax: TCanvax;//Create
    FFont: TFont;//����� ������ ��-��(!), Create: Assign(FCanvax.Canvas.Font)
    FTextAlignX: TTextAlignX;//Create
    FTextAlignY: TTextAlignY;//Create
    function GetStrSize(s: string): TPoint;//Width & Height
    function GetStrLeftTop(s: string; x,y: integer): TPoint;//x,y - �������� ������ (Alignment=>Result)
  public
    constructor Create(aCanvax: TCanvax; xali: TTextAlignX=ttax_Left; yali: TTextAlignY=ttay_Top);
    destructor Destroy; override;
    function GetInterval(k: double): integer;//k: 1, 1.5, 2, ...
    function GetStrWidth(s: string): integer;
    function GetStrRect(s: string; x,y: integer; dx: integer=0; dy: integer=0): TRect;//x,y - �������� ������(+Alignment); dx,dy - ����

    procedure DrawStr(s: string; x,y: integer; aBackColor: TColor=-1);//x,y - �������� ������(+Alignment)

    property Canvax: TCanvax read FCanvax;
    property Font: TFont read FFont;//����� ������ ��-��(!)
  end;

  //TCanvaxText ������ �� �������:
  TCanvaxStr = class(TCanvaxText)
  protected
    FStr: string;
  public
    constructor Create(s: string; aCanvax: TCanvax; xali: TTextAlignX=ttax_Left; yali: TTextAlignY=ttay_Top);
    function GetStrWidth: integer;
    function GetStrRect(x,y: integer; dx: integer=0; dy: integer=0): TRect;//x,y - �������� ������(+Alignment); dx,dy - ����
    procedure DrawStr(x,y: integer; aBackColor: TColor=-1);//x,y - �������� ������(+Alignment)

    property Str: string read FStr;
  end;


implementation

{ TCanvaxText: }

constructor TCanvaxText.Create(aCanvax: TCanvax; xali: TTextAlignX=ttax_Left; yali: TTextAlignY=ttay_Top);
begin
  inherited Create;

  FCanvax:=aCanvax;
  FTextAlignX:=xali;
  FTextAlignY:=yali;

  FFont:=TFont.Create;//����� ������ ��-��(!)
  FFont.Assign(FCanvax.Canvas.Font);//default
end;

destructor TCanvaxText.Destroy;
begin
  FFont.Free;
end;

function TCanvaxText.GetInterval(k: double): integer;//k: 1, 1.5, 2, ...
begin
  Result:=Round( abs(FFont.Height)*k );
end;

function TCanvaxText.GetStrWidth(s: string): integer;
begin
  FCanvax.Canvas.Font.Assign(FFont);//set font
  Result:=FCanvax.Canvas.TextWidth(s);
end;

function TCanvaxText.GetStrSize(s: string): TPoint;//Width & Height
var wh: TSize;
begin
  FCanvax.Canvas.Font:=FFont;//set font
  wh:=FCanvax.Canvas.TextExtent(s);
  Result.x:=wh.cx;
  Result.y:=wh.cy;
end;

function TCanvaxText.GetStrLeftTop(s: string; x,y: integer): TPoint;//��������� Alignment; x,y - �������� ������
var wh: TPoint;
begin
  Result:=Point(x,y);//default
  if (FTextAlignX<>ttax_Left) or (FTextAlignY<>ttay_Top) then begin

    wh:=GetStrSize(s);//on FFont!

    case FTextAlignX of
      ttax_Right:  Result.x:=x-wh.x;
      ttax_Center: Result.x:=x-Round(wh.x/2);
    end;//case

    case FTextAlignY of
      ttay_Bottom: Result.y:=y-wh.y;
      ttay_Center: Result.y:=y-Round(wh.y/2);
    end;//case

  end;//if TextAlign
end;

function TCanvaxText.GetStrRect(s: string; x,y: integer; dx: integer=0; dy: integer=0): TRect;//dx,dy - ����; x,y - �������� ������
var wh: TPoint;
begin
  //������� ����-��:
  wh:=GetStrSize(s);//on FFont!
  inc(wh.x, 2*dx);
  inc(wh.y, 2*dy);

  //���������:
  Result.TopLeft:=GetStrLeftTop(s, x,y);//on FFont!
  dec(Result.Left, dx);
  dec(Result.Top,  dy);
  Result.Right  := Result.Left + wh.x;
  Result.Bottom := Result.Top  + wh.y;
end;

procedure TCanvaxText.DrawStr(s: string; x,y: integer; aBackColor: TColor=-1);//x,y - �������� ������(+Alignment)
var p: TPoint;
begin
  if aBackColor<0 then FCanvax.Canvas.Brush.Style:=bsClear//��� �������
  else FCanvax.SetSolidBrush(aBackColor);

  p:=GetStrLeftTop(s, x,y);//on FFont!

  FCanvax.Canvas.Font:=FFont;//set font
  FCanvax.Canvas.TextOut(p.x,p.y, s);
end;


{ TCanvaxStr: }

constructor TCanvaxStr.Create(s: string; aCanvax: TCanvax; xali: TTextAlignX=ttax_Left; yali: TTextAlignY=ttay_Top);
begin
  inherited Create(aCanvax, xali,yali);
  FStr:=s;
end;

function TCanvaxStr.GetStrWidth: integer;
begin
  Result := inherited GetStrWidth(Fstr);
end;

function TCanvaxStr.GetStrRect(x,y: integer; dx: integer=0; dy: integer=0): TRect;//x,y - �������� ������(+Alignment); dx,dy - ����
begin
  Result := inherited GetStrRect(Fstr, x,y, dx,dy);
end;

procedure TCanvaxStr.DrawStr(x,y: integer; aBackColor: TColor=-1);//x,y - �������� ������(+Alignment)
begin
  inherited DrawStr(Fstr, x,y, aBackColor);
end;


end.
