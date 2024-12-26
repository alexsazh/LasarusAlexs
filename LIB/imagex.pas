unit imagex; interface

uses
  ExtCtrls{TImage}, Graphics{TColor},
  vlib;


{ Functions: }

procedure imx_setsize(im: TImage; w,h: integer);
procedure imx_fill(im: TImage; cl: TColor);
procedure imx_clear(im: TImage);//clWhite

procedure imx_string0(im: TImage; s: string; X,Y: integer);

//праметры дл€ преобр. координат:
procedure imx_get_sizes_from_box(aBox{√аусс}: tnum4; aStep{м}: double; var p0,sz{>0!}: tnum2; var w,h: integer);

//ѕреобр-ие координат Image<->Gauss(x вверх!):
//ix - столбец слева направо, iy - строка сверху вниз ("экран"):
//x,y->ix,iy: p0 - лев.верх. точка; sz - real-размер, w,h - int-размер:
procedure imx_xy_to_ixiy(p: tnum2; var ix,iy: integer; p0,sz{>0!}: tnum2; w,h: integer);
//x,y->ix,iy с прит€гиванием к краю матрицы при выходе за пределы:
procedure imx_xy_to_ixiy2(p: tnum2; var ix,iy: integer; p0,sz{>0!}: tnum2; w,h: integer);
//ix,iy->p:
procedure imx_ixiy_to_xy(ix,iy: integer; var p: tnum2; p0,sz: tnum2; w,h{>1!}: integer);


implementation

uses
  Types,
  wcmn;


{ Functions: }

procedure imx_setsize(im: TImage; w,h: integer);
begin
  Im.Picture.Bitmap.Width:=w;//m.b.=0
  Im.Picture.Bitmap.Height:=h;//m.b.=0
  //Im.Picture.Bitmap.SetSize(w,h);
end;

procedure imx_fill(im: TImage; cl: TColor);
var rect: TRect;
begin
  rect.Left:=0;
  rect.Top:=0;
  //rect на 1 больше, чем пределы индексов:
  rect.Right:=Im.Picture.Bitmap.Width;
  rect.Bottom:=Im.Picture.Bitmap.Height;

  Im.Canvas.Brush.Style:=bsSolid;
  Im.Canvas.Brush.Color:=cl;
  Im.Canvas.FillRect(rect);
end;

procedure imx_clear(im: TImage);
begin
  imx_fill(im, clWhite);
end;

procedure imx_string0(im: TImage; s: string; X,Y: integer);
begin
  Im.Canvas.TextOut(X,Y,s);
end;


//-------------------------------------------------------

procedure imx_get_sizes_from_box(aBox{√аусс}: tnum4; aStep{м}: double; var p0,sz{>0!}: tnum2; var w,h: integer);
begin
  p0.x := aBox.b.x;//top - max x
  p0.y := aBox.a.y;//left - min y
  sz   := v_box_size(aBox);

  w := Round( sz.y/aStep );
  h := Round( sz.x/aStep );
end;

procedure imx_xy_to_ixiy(p: tnum2; var ix,iy: integer; p0,sz{>0!}: tnum2; w,h: integer);
begin
  try
    ix := Round( (w-1)*(p.y-p0.y)/sz.y );
    iy := Round( (h-1)*(p0.x-p.x)/sz.x );
  except
    ix := 0;
    iy := 0;
  end;
(*
  //проверка:
  imx_ixiy_to_xy(ix,iy, p, p0,sz,w,h);
*)  
end;

procedure imx_xy_to_ixiy2(p: tnum2; var ix,iy: integer; p0,sz{>0!}: tnum2; w,h: integer);
begin
  imx_xy_to_ixiy(p, ix,iy, p0,sz,w,h);
  //прит€гивание:
  if ix<0 then ix:=0;
  if iy<0 then iy:=0;
  if ix>=w then ix:=w-1;
  if iy>=h then iy:=h-1;
end;

procedure imx_ixiy_to_xy(ix,iy: integer; var p: tnum2; p0,sz: tnum2; w,h{>1!}: integer);
begin
  try
    if h>1 then p.x := p0.x - sz.x*iy/(h-1) else p.x := p0.x;
    if w>1 then p.y := p0.y + sz.y*ix/(w-1) else p.y := p0.y;
  except
    p:=p0;
  end;
(*
  //проверка:
  imx_xy_to_ixiy(p, ix,iy, p0,sz,w,h);
*)
end;

end.
