(*
  TCanvax - расширение свойств существующего объекта TCanvas
*)
unit canvax; interface

uses
  Graphics{TCanvas, TColor}, Types{TRect},
  vlib, llibx;


type
  TCanvax = class
  private
    FPoints: array of TPoint;
    FPointsCount: integer;//Polyline,Polygon
    procedure GPlToPoints(pl: tpl; gTopLeft,gSize: tnum2; aWidth,aHeight: integer);//=>FPoints, FPointsCount
  protected
    FCanvas: TCanvas;
  public
    constructor Create(aCanvas: TCanvas);
    destructor Destroy; override;
    procedure SetSolidBrush(cl: TColor; _NoPen: boolean = true);//TCanvaxText uses
    procedure SetSolidPen(cl: TColor; wd: integer; _NoBrush: boolean = true);
    procedure SetXorPen(cl: TColor; wd: integer);

    //PAINT:
    procedure line_stroke(p1,p2: TPoint; cl: TColor; wd: integer);

    procedure rect_fill(Rect: TRect; cl: TColor);//Rect.Bottom,Right - не попадает
    procedure rect_stroke(Rect: TRect; cl: TColor; wd: integer);
    procedure rect_fillstroke(Rect: TRect; clfill,clstroke: TColor; wd: integer);

    procedure circle_fill(aCentre: tnum2; aDiam: double; cl: TColor);//Rect.Bottom,Right - не попадает
    procedure circle_stroke(aCentre: tnum2; aDiam: double; wd: integer; cl: TColor);

    //Gauss:
    procedure gpl_stroke(pl: tpl;  gTopLeft,gSize: tnum2; aWidth,aHeight: integer; cl: TColor; wd: integer);
    procedure gpl_box(aBox: tnum4; gTopLeft,gSize: tnum2; aWidth,aHeight: integer; cl: TColor; wd: integer);
    procedure gpl_fill(pl: tpl;    gTopLeft,gSize: tnum2; aWidth,aHeight: integer; cl: TColor);

    property Canvas: TCanvas read FCanvas;
  end;


procedure canvax_rect(aCentre: tnum2; aDiam: double; var x1,y1,x2,y2: integer);


implementation

uses
  Math,
  imagex;


procedure canvax_rect(aCentre: tnum2; aDiam: double; var x1,y1,x2,y2: integer);
begin
  x1 := math.ceil(aCentre.X - aDiam/2);
  y1 := math.ceil(aCentre.Y - aDiam/2);
  x2 := math.ceil(x1 + aDiam)+1;
  y2 := math.ceil(y1 + aDiam)+1;
end;


{ TCanvax: }

constructor TCanvax.Create(aCanvas: TCanvas);
begin
  inherited Create;
  FCanvas:=aCanvas;
end;

destructor TCanvax.Destroy;
begin
  inherited;
end;

procedure TCanvax.SetSolidBrush(cl: TColor; _NoPen: boolean);
begin
  with FCanvas do begin
    Brush.Style:=bsSolid;//сплошная заливка
    Brush.Color:=cl;
    if _NoPen then Pen.Style:=psClear;//нет линии
  end;
end;

procedure TCanvax.SetSolidPen(cl: TColor; wd: integer; _NoBrush: boolean);
begin
  with FCanvas do begin
    Pen.Mode:=pmCopy;//цвет - из Color
    Pen.Style:=psSolid;//сплошная линия
    if cl>=0 then Pen.Color:=cl;//else current
    if wd>=0 then Pen.Width:=wd;//else current
    if _NoBrush then Brush.Style:=bsClear;//нет заливки
  end;
end;

procedure TCanvax.SetXorPen(cl: TColor; wd: integer);
begin
  with FCanvas do begin
    Pen.Mode:=pmXor;//цвет - из Color
    Pen.Style:=psSolid;//сплошная линия
    Pen.Color:=cl;
    Pen.Width:=wd;
    Brush.Style:=bsClear;//нет заливки!
  end;
end;


procedure TCanvax.GPlToPoints(pl: tpl; gTopLeft,gSize: tnum2; aWidth,aHeight: integer);//=>FPoints, FPointsCount
var i: integer;
begin
  FPointsCount:=pl.Count;
  SetLength(FPoints, FPointsCount);
  if pl.Count>0 then for i:=0 to pl.Count-1 do
    imx_xy_to_ixiy(pl[i], FPoints[i].x,FPoints[i].y, gTopLeft,gSize, aWidth,aHeight);
end;


//------------ PAINT:

procedure TCanvax.line_stroke(p1,p2: TPoint; cl: TColor; wd: integer);
begin
  SetSolidPen(cl,wd);//нет заливки!
  with FCanvas do begin
    MoveTo(p1.x, p1.y);
    LineTo(p2.x, p2.y);
  end;
end;


procedure TCanvax.rect_fill(Rect: TRect; cl: TColor);
begin
  SetSolidBrush(cl);
  FCanvas.FillRect(rect);
end;

procedure TCanvax.rect_stroke(Rect: TRect; cl: TColor; wd: integer);
begin
  SetSolidPen(cl,wd);//нет заливки!
  with FCanvas do begin
    Rectangle(rect);
  end;
end;

procedure TCanvax.rect_fillstroke(Rect: TRect; clfill,clstroke: TColor; wd: integer);
begin
  SetSolidBrush(clfill, false{_NoPen});
  SetSolidPen(clstroke,wd, false{_NoBrush});
  FCanvas.Rectangle(rect);
end;


procedure TCanvax.circle_fill(aCentre: tnum2; aDiam: double; cl: TColor);//Rect.Bottom,Right - не попадает
var x1,y1,x2,y2: integer;
begin
  canvax_rect(aCentre, aDiam, x1,y1,x2,y2);
  SetSolidBrush(cl);
  with FCanvas do begin
    Ellipse(x1,y1,x2,y2);
  end;
end;

procedure TCanvax.circle_stroke(aCentre: tnum2; aDiam: double; wd: integer; cl: TColor);
var x1,y1,x2,y2: integer;
begin
  canvax_rect(aCentre, aDiam, x1,y1,x2,y2);
  SetSolidPen(cl,wd);
  with FCanvas do begin
    Ellipse(x1,y1,x2,y2);
  end;
end;


procedure TCanvax.gpl_stroke(pl: tpl; gTopLeft,gSize: tnum2; aWidth,aHeight: integer; cl: TColor; wd: integer);
begin
  SetSolidPen(cl,wd);//нет заливки!
  //SetSolidBrush(cl);//нет контура!

  GPlToPoints(pl, gTopLeft,gSize, aWidth,aHeight);//=>FPoints, FPointsCount

  FCanvas.Polyline(FPoints);//не работает!
  //FCanvas.Polygon(FPoints);
end;

procedure TCanvax.gpl_box(aBox: tnum4; gTopLeft,gSize: tnum2; aWidth,aHeight: integer; cl: TColor; wd: integer);
var aRect: TRect;
begin
  SetSolidPen(cl,wd);//нет заливки!
  imx_xy_to_ixiy(aBox.a, aRect.Left,aRect.Bottom, gTopLeft,gSize, aWidth,aHeight);
  imx_xy_to_ixiy(aBox.b, aRect.Right,aRect.Top,   gTopLeft,gSize, aWidth,aHeight);

  rect_stroke(aRect, cl, wd);
end;

procedure TCanvax.gpl_fill(pl: tpl; gTopLeft,gSize: tnum2; aWidth,aHeight: integer; cl: TColor);
begin
  SetSolidBrush(cl);//нет контура!
  GPlToPoints(pl, gTopLeft,gSize, aWidth,aHeight);//=>FPoints, FPointsCount
  FCanvas.Polygon(FPoints);
end;


end.
