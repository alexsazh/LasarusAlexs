(*
  GetPixels(i,j) - через UQPixels
*)
unit dmbmp; interface

uses
  Types, Graphics,
  UQPixels,
  nums, vlib, llib, llibx, vlib3d, llib3d, imagex, canvax;


type
  TDmBmp = class
  protected
    FBmp: TBitMap;
    FCanvax: TCanvax;
    FQuickPixels: TQuickPixels;
    GBox: tnum4;//Гаусс from Create
    GStep: tnum;//Гаусс (метры) - шаг матрицы
    GTopLeft, GSize: tnum2;//Гаусс (метры) - переход aBox<->FBmp in imagex.pas
    function GetPixels(i,j: integer): TColor;//FQuickPixels!
  public
    constructor Create(aBox: tnum4; aStep: tnum = 1);
    destructor Destroy; override;
    function Ok: boolean;//w,h>0
    procedure Clear(aColor: TColor);//заливка

    function gp_to_ip(gp: tnum2): TPoint;
    function ip_to_gp(ix,iy: integer): tnum2;

    function gp_to_color(gp: tnum2; var aColor: TColor): boolean;

    //Draw:
    procedure DrawLine(pl: tpl; aColor: TColor; aWidth: integer);
    procedure DrawLine2(pl: tpl; aColor: TColor; aWidth: integer);//с проверкой рамки
    procedure DrawArea(pl: tpl; aColor: TColor); overload;//без дырок
    procedure DrawArea(pl: tpl; aColor,aHoleColor: TColor); overload;//с дырками - 2D!!!
    procedure DrawArea(pl: tpl3d; aColor,aHoleColor: TColor); overload;//с дырками - 3D!!!
    procedure DrawArea2(pl: tpl; aColor: TColor);//с проверкой рамки
    procedure DrawBox(aBox: tnum4; aColor: TColor; aWidth: integer);

    //DEBUG, тесты:
    procedure CopyToBitmap(aBitmap: TBitmap);//для показа (FormAreaBmp.Show_Wire_Gabarits)
    procedure GetColors(aColors: tinta);//для проверки

    property Bmp: TBitMap read FBmp;
    property Pixels[i,j: integer]: TColor read GetPixels; default;//FQuickPixels!
  end;


//Взаимосвязь "Индекс-Цвет":
//Color=Index+1 (0 использовать нельзя):
function dmbmp_Index2Color(i: integer): TColor;
function dmbmp_Color2Index(cl: TColor): integer;//m.b. clWhite-1


implementation

uses wcmn;


function dmbmp_Index2Color(i: integer): TColor;
begin
  Result := TColor(i+1);
end;

function dmbmp_Color2Index(cl: TColor): integer;
begin
  Result := integer(cl-1);
end;


{ TDmBmp: }

constructor TDmBmp.Create(aBox: tnum4; aStep: tnum);
var w,h: integer;
begin
  inherited Create;
  GBox  := aBox;
  GStep := aStep;

  imx_get_sizes_from_box(aBox,aStep, GTopLeft,GSize, w,h);

  FBmp := TBitMap.Create;

  //FBmp.PixelFormat := pf24bit;
  FBmp.PixelFormat := pf32bit;

  FBmp.Width  := w;
  FBmp.Height := h;

  FCanvax:=TCanvax.Create(FBmp.Canvas);

  FQuickPixels:=TQuickPixels.Create;
  FQuickPixels.Attach(FBmp);
end;

destructor TDmBmp.Destroy;
begin
  FBmp.Free;
  inherited;
end;

function TDmBmp.Ok: boolean;//w,h>0
begin
  Result := (FBmp.Width>0) and (FBmp.Height>0);
end;

procedure TDmBmp.Clear(aColor: TColor);
var rect: TRect;
//var ix,iy,j: integer;
begin
  rect.Left:=0;
  rect.Top:=0;
  //rect на 1 больше, чем пределы индексов:
  rect.Right:=FBmp.Width;
  rect.Bottom:=FBmp.Height;

  FBmp.Canvas.Brush.Style:=bsSolid;
  FBmp.Canvas.Brush.Color:=aColor;
  FBmp.Canvas.FillRect(rect);
(*
  //DEBUG: проверка, что всё залито:
  if FBmp.Height>0 then for iy:=0 to FBmp.Height-1 do begin//сверху вниз
    if FBmp.Width>0 then for ix:=0 to FBmp.Width-1 do begin//слева направо
      if Pixels[ix,iy]=aColor then continue;
      j:=0;//BREAKPOINT
    end;//for ix
  end;//for iy
*)
end;


function TDmBmp.gp_to_ip(gp: tnum2): TPoint;
begin
  imx_xy_to_ixiy(gp, Result.x,Result.y, gTopLeft,gSize, FBmp.Width,FBmp.Height);
end;

function TDmBmp.ip_to_gp(ix,iy: integer): tnum2;
begin
  imx_ixiy_to_xy(ix,iy, Result, gTopLeft,gSize, FBmp.Width,FBmp.Height);
end;

function TDmBmp.gp_to_color(gp: tnum2; var aColor: TColor): boolean;
var ip: TPoint;
begin
  Result:=false;//default
  ip := gp_to_ip(gp);
  if  (ip.X>=0) and (ip.X<FBmp.Width)
  and (ip.Y>=0) and (ip.Y<FBmp.Height)
  then begin
    Result:=true;
    aColor:=GetPixels(ip.X,ip.Y);
  end;
end;


procedure TDmBmp.DrawLine(pl: tpl; aColor: TColor; aWidth: integer);
begin
  FCanvax.gpl_stroke(pl, gTopLeft,gSize, FBmp.Width,FBmp.Height, aColor, aWidth);
end;

procedure TDmBmp.DrawLine2(pl: tpl; aColor: TColor; aWidth: integer);
begin
  if v_boxes_sec(GBox, pl.Box) then DrawLine(pl, aColor, aWidth);
end;

procedure TDmBmp.DrawArea(pl: tpl; aColor: TColor);
begin
  pl.Close0;
  if pl.Count>3 then FCanvax.gpl_fill(pl, gTopLeft,gSize, FBmp.Width,FBmp.Height, aColor);
end;

procedure TDmBmp.DrawArea(pl: tpl; aColor,aHoleColor: TColor);
var plnext: tpl;
begin
  DrawArea(pl, aColor);
  plnext:=pl.Next;
  while Assigned(plnext) do begin
    DrawArea(plnext, aHoleColor);
    plnext:=plnext.Next;//next дырка
  end;//while
end;

procedure TDmBmp.DrawArea(pl: tpl3d; aColor,aHoleColor: TColor);
var plnext: tpl3d;
begin
  DrawArea(pl.pl, aColor);
  plnext:=pl.Next;
  while Assigned(plnext) do begin
    DrawArea(plnext.pl, aHoleColor);
    plnext:=plnext.Next;//next дырка
  end;//while
end;

procedure TDmBmp.DrawArea2(pl: tpl; aColor: TColor);
begin
  if v_boxes_sec(GBox, pl.Box) then DrawArea(pl, aColor);
end;

procedure TDmBmp.DrawBox(aBox: tnum4; aColor: TColor; aWidth: integer);
begin
  FCanvax.gpl_box(aBox, gTopLeft,gSize, FBmp.Width,FBmp.Height, aColor, aWidth);
end;


function TDmBmp.GetPixels(i,j: integer): TColor;
begin
  //Result := FBmp.Canvas.Pixels[i,j];//медленно! быстрее - через UQPixels.pas
  Result := FQuickPixels.Pixels[i,j];
end;

procedure TDmBmp.CopyToBitmap(aBitmap: TBitmap);
begin
  aBitmap.Assign(FBmp);
end;


procedure TDmBmp.GetColors(aColors: tinta);
var ix,iy,icol,ind: integer;
begin
  aColors.Clear;
  if Bmp.Height>0 then for iy:=0 to Bmp.Height-1 do begin//сверху вниз
    if Bmp.Width>0 then for ix:=0 to Bmp.Width-1 do begin//слева направо
      TColor(icol):=Pixels[ix,iy];
      ind:=aColors.IndexOf(icol);
      if ind<0 then aColors.Add(icol);
    end;//for ix
  end;//for iy
end;

end.
