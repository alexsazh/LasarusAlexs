//
// SrcRect<->DestRect
// пропорции w/h сохраняются
// по центру (pc1<->pc2)
//
unit rlib; interface

uses Windows, Graphics, nums, vlib, llib, llibx, lliby;


type
  TRects = class
  private
    SrcExt: double;//коэффициент добавления высоты/ширины к Src
    DstMarg: tnum4;//поля на образе Dst - PIX
    SrcCntr,DestCntr: tnum2;//SrcCntr<->DestCntr
    Zoom: tnum2;//Dest/Src
  public
    DSrc, DSrcNew: tnum4;//double; SrcNew = Dest/Zoom
    Src, SrcNew: TRect;//SrcNew = Dest/Zoom
    Dst, DstNew: TRect;//DstNew = Src*Zoom
    constructor CreateFun(SrcBox: tnum4; DstRect: TRect; aDstMarg{pix}: tnum4);
    constructor Create(SrcRect, DstRect: TRect; const aSrcExt: double = 0);
    destructor Destroy; override;

    function xy_to_dst(x,y: double): tnum2;
    function xy_to_dsti(x,y: double): TPoint;

    function xy_to_src(x,y: double): tnum2;
    function xy_to_srci(x,y: double): TPoint;

    //DRAW:
    //r - радиус
    //r0 - радиус начальной точки (if >0)
    procedure draw_p(Canvas: TCanvas; p: tnum2; cl: TColor; r: integer);
    procedure draw_l(Canvas: TCanvas; p1,p2: tnum2; cl: TColor; w: integer);
    procedure draw_pl(Canvas: TCanvas; pl: tpl; cl: TColor; w,r0: integer);
    procedure draw_pla(Canvas: TCanvas; pla: tpla; cl: TColor; w,r0: integer);

    procedure draw_box(Canvas: TCanvas; box: tnum4; cl: TColor; w: integer);
    procedure draw_fun(Canvas: TCanvas; xa,ya: tnuma; cl: TColor; w: integer);
  end;


function rlib_rect1(cntr: tnum2; dx,dy: double): TRect;


implementation

uses wcmn, rectlib{rectlib_scale_rect};


//dx,dy - радиусы
function rlib_rect1(cntr: tnum2; dx,dy: double): TRect;
begin
  Result.Left := round(cntr.X - dx);
  Result.Right := round(cntr.X + dx);
  Result.Top := round(cntr.Y - dy);
  Result.Bottom := round(cntr.Y + dy);
end;


{TRects:}

constructor TRects.CreateFun(SrcBox: tnum4; DstRect: TRect; aDstMarg{pix}: tnum4);
var w1,w2,h1,h2: double; dstbox,dstbox2: tnum4;
begin
  inherited Create;
  DstMarg:=aDstMarg;

  dstbox:=v_box(DstRect);

  dstbox2:=v_box_sub(dstbox,DstMarg);
  //dstbox2:=dstbox;//DEBUG

  Dst:=v_box_rect(dstbox2);//round
  DSrc:=SrcBox;
  Src:=v_box_floor(DSrc);//floor

  w1:=(DSrc.b.x-DSrc.a.x);
  h1:=(DSrc.b.y-DSrc.a.y);
  SrcCntr.x:=(DSrc.a.x+DSrc.b.x)/2;
  SrcCntr.y:=(DSrc.a.y+DSrc.b.y)/2;

  w2:=Dst.Right-Dst.Left;
  h2:=Dst.Bottom-Dst.Top;
  DestCntr.x:=(Dst.Right+Dst.Left)/2;
  DestCntr.y:=(Dst.Bottom+Dst.Top)/2;

  try
    Zoom.x:=w2/w1;
    Zoom.y:=h2/h1;//НЕТ сохранения пропорции

    DstNew.TopLeft:=xy_to_dsti(DSrc.a.x, DSrc.a.y);
    DstNew.BottomRight:=xy_to_dsti(DSrc.b.x, DSrc.b.y);

    DSrcNew.a:=xy_to_src(Dst.Left, Dst.Top);
    DSrcNew.b:=xy_to_src(Dst.Right, Dst.Bottom);
    SrcNew:=v_box_floor(DSrcNew);//округление
  except
    Tell('EXCEPTION in TRects.Create (rlib)');
  end;
end;

constructor TRects.Create(SrcRect, DstRect: TRect; const aSrcExt: double = 0);
var w1,w2,h1,h2: double;
begin
  inherited Create;
  SrcExt:=aSrcExt;
  Src:=rectlib_scale_rect(SrcRect, 1+SrcExt);//Src = SrcRect*(1+SrcExt)
  Dst:=DstRect;

  try
    w1:=(Src.Right-Src.Left);
    h1:=(Src.Bottom-Src.Top);
    SrcCntr.x:=(Src.Right+Src.Left)/2;
    SrcCntr.y:=(Src.Bottom+Src.Top)/2;

    w2:=Dst.Right-Dst.Left;
    h2:=Dst.Bottom-Dst.Top;
    DestCntr.x:=(Dst.Right+Dst.Left)/2;
    DestCntr.y:=(Dst.Bottom+Dst.Top)/2;

    Zoom.x:=w2/w1;
    Zoom.y:=h2/h1;
    if Zoom.y<Zoom.x
    then Zoom.x:=Zoom.y//по мин растяжению - сохранение пропорции
    else Zoom.y:=Zoom.x;

    DstNew.TopLeft:=xy_to_dsti(Src.Left, Src.Top);
    DstNew.BottomRight:=xy_to_dsti(Src.Right, Src.Bottom);

    SrcNew.TopLeft:=xy_to_srci(Dst.Left, Dst.Top);
    SrcNew.BottomRight:=xy_to_srci(Dst.Right, Dst.Bottom);

  except
    Tell('EXCEPTION in TRects.Create (rlib)');
  end;
end;

destructor TRects.Destroy;
begin
  inherited Destroy;
end;


function TRects.xy_to_dst(x,y: double): tnum2;
begin
  Result.X := DestCntr.x + Zoom.x*(x-SrcCntr.x);
  Result.Y := DestCntr.y + Zoom.y*(y-SrcCntr.y);
end;

function TRects.xy_to_dsti(x,y: double): TPoint;
begin
  Result := v_floor( xy_to_dst(x,y) );//влево
end;

function TRects.xy_to_src(x,y: double): tnum2;
begin
  Result.X := SrcCntr.x + (x-DestCntr.x)/Zoom.x;
  Result.Y := SrcCntr.y + (y-DestCntr.y)/Zoom.y;
end;

function TRects.xy_to_srci(x,y: double): TPoint;
begin
  Result := v_floor( xy_to_src(x,y) );//влево
end;


/////////////////////////////////////////////////
//DRAW:
/////////////////////////////////////////////////

procedure TRects.draw_p(Canvas: TCanvas; p: tnum2; cl: TColor; r: integer);
var rect: TRect; p2: tnum2;
begin
  with Canvas do begin
    Brush.Style:=bsSolid;//сплошная заливка
    Brush.Color:=cl;
    Pen.Style:=psClear;//нет контура
  end;

  p2:=xy_to_dst(p.x, p.y);
  rect:=rlib_rect1(p2, r,r);
  Canvas.Ellipse(rect);
end;

procedure TRects.draw_l(Canvas: TCanvas; p1,p2: tnum2; cl: TColor; w: integer);
var ip: TPoint;
begin
  with Canvas do begin
    Pen.Mode:=pmCopy;//цвет - из Color
    Pen.Style:=psSolid;//сплошная линия
    Pen.Color:=cl;
    Pen.Width:=w;
  end;

  ip:=xy_to_dsti(p1.x, p1.y); Canvas.MoveTo(ip.X, ip.Y);
  ip:=xy_to_dsti(p2.x, p2.y); Canvas.LineTo(ip.X, ip.Y);
end;

procedure TRects.draw_pl(Canvas: TCanvas; pl: tpl; cl: TColor; w,r0: integer);
var i: integer; ip: TPoint;
begin
  if (pl.Count>0) and (r0>0) then draw_p(Canvas, pl[0], cl, r0);//нач. точка

  with Canvas do begin
    Pen.Mode:=pmCopy;//цвет - из Color
    Pen.Style:=psSolid;//сплошная линия
    Pen.Color:=cl;
    Pen.Width:=w;
  end;

  if pl.Count>0 then for i:=0 to pl.Count-1 do begin
    ip:=xy_to_dsti(pl[i].x, pl[i].y);
    if i=0 then Canvas.MoveTo(ip.X, ip.Y) else Canvas.LineTo(ip.X, ip.Y);
  end;//for i
end;

procedure TRects.draw_pla(Canvas: TCanvas; pla: tpla; cl: TColor; w,r0: integer);
var i: integer;
begin
  with Canvas do begin
    Pen.Mode:=pmCopy;//цвет - из Color
    Pen.Style:=psSolid;//сплошная линия
    Pen.Color:=cl;
    Pen.Width:=w;
  end;

  if pla.Count>0 then for i:=0 to pla.Count-1 do begin
    draw_pl(Canvas, pla[i], cl, w,r0);
  end;
end;

procedure TRects.draw_box(Canvas: TCanvas; box: tnum4; cl: TColor; w: integer);
var ip: TPoint;
begin
  with Canvas do begin
    Pen.Mode:=pmCopy;//цвет - из Color
    Pen.Style:=psSolid;//сплошная линия
    Pen.Color:=cl;
    Pen.Width:=w;
  end;

  ip:=xy_to_dsti(box.a.x, box.a.y); Canvas.MoveTo(ip.X, ip.Y);
  ip:=xy_to_dsti(box.b.x, box.a.y); Canvas.LineTo(ip.X, ip.Y);
  ip:=xy_to_dsti(box.b.x, box.b.y); Canvas.LineTo(ip.X, ip.Y);
  ip:=xy_to_dsti(box.a.x, box.b.y); Canvas.LineTo(ip.X, ip.Y);
  ip:=xy_to_dsti(box.a.x, box.a.y); Canvas.LineTo(ip.X, ip.Y);
end;

procedure TRects.draw_fun(Canvas: TCanvas; xa,ya: tnuma; cl: TColor; w: integer);
var i: integer; ip: TPoint;
begin
  with Canvas do begin
    Pen.Mode:=pmCopy;//цвет - из Color
    Pen.Style:=psSolid;//сплошная линия
    Pen.Color:=cl;
    Pen.Width:=w;
  end;

  if xa.Count>1{!} then for i:=0 to xa.Count-1 do begin
    //ip:=xy_to_dsti(xa[i], DSrc.b.y{max}-ya[i]);
    ip:=xy_to_dsti(xa[i], ya[i]);
    if i=0 then Canvas.MoveTo(ip.X, ip.Y) else Canvas.LineTo(ip.X, ip.Y);
  end;//for i
end;


end.
