(*
after rectlib_set_src_rect and rectlib_set_dest_rect
ТРЕБУЕТСЯ rectlib_INIT
*)
unit rectlib; interface

uses Windows,
  vlib;


function rectlib_scale_rect(rect: TRect; sc: double): TRect;//ОТ ЦЕНТРА
function rectlib_rect_around_p(p: TPoint; radius: Integer): TRect;//квадрат ОТ ЦЕНТРА


{TRANS:}

//SET trans:
procedure rectlib_set_src_rect(rect: TRect);
procedure rectlib_set_dest_rect(rect: TRect);
function rectlib_INIT: TRect;//меняет dest_rect =>USE

//USE trans:
function rectlib_hDw: double;//height/width - пропорция
function rectlib_trans_point(x,y: double): TPoint; overload;
function rectlib_trans_point(p: tnum2): TPoint; overload;
function rectlib_trans_point(p: TPoint): TPoint; overload;
function rectlib_trans_rect(rect: TRect): TRect;

implementation

var
  _rect1: TRect;//src
  _rect2: TRect;//dest
  _w1,_h1,_w2,_h2,_xc1,_yc1,_xc2,_yc2,_kx,_ky: double;//after rectlib_INIT;


function rectlib_scale_rect(rect: TRect; sc: double): TRect;//ОТ ЦЕНТРА
var xc,yc,w2,h2: double;
begin
  xc := (rect.Left+rect.Right)/2.;
  yc := (rect.Top+rect.Bottom)/2.;
  w2  := sc*(rect.Right-rect.Left)/2.;
  h2  := sc*(rect.Bottom-rect.Top)/2.;

  Result.Left  := Round(xc-w2);
  Result.Right := Round(xc+w2);
  Result.Top   := Round(yc-h2);
  Result.Bottom:= Round(yc+h2);
end;

function rectlib_rect_around_p(p: TPoint; radius: Integer): TRect;//квадрат ОТ ЦЕНТРА
begin
  Result.Left   := p.X-radius;
  Result.Top    := p.Y-radius;
  Result.Right  := p.X+radius;
  Result.Bottom := p.Y+radius;
end;


{TRANS:}

procedure rectlib_set_src_rect(rect: TRect);
begin
  _rect1:=rect;
end;

procedure rectlib_set_dest_rect(rect: TRect);
begin
  _rect2:=rect;
end;

function rectlib_INIT: TRect;//меняет dest_rect =>USE
var wDh: double;//width/height - пропорция
begin
  _w1:=_rect1.Right-_rect1.Left;
  _h1:=_rect1.Bottom-_rect1.Top;
  _xc1:=_rect1.Left+_w1/2.;
  _yc1:=_rect1.Top+_h1/2.;

  //пропорция:
  wDh:=_w1/_h1;
  _h2:=_rect2.Bottom-_rect2.Top;
  _w2:=_h2*wDh;//проп-ая ширина - из высоты
  _rect2.Right:=Round(_rect2.Left+_w2);//новая ширина

  _xc2:=_rect2.Left+_w2/2.;
  _yc2:=_rect2.Top+_h2/2.;

  _kx:=(_w2/_w1);
  _ky:=(_h2/_h1);

  Result := _rect2;
end;


function rectlib_hDw: double;//height/width - пропорция
begin
  Result := _h1/_w1;
end;

function rectlib_trans_point(x,y: double): TPoint;
begin
  Result.X := Round( _xc2+(x-_xc1)*_kx );
  Result.Y := Round( _yc2+(y-_yc1)*_ky );
end;

function rectlib_trans_point(p: tnum2): TPoint;
begin
  Result := rectlib_trans_point(p.x,p.y);
end;

function rectlib_trans_point(p: TPoint): TPoint;
begin
  Result := rectlib_trans_point(p.x,p.y);
end;

function rectlib_trans_rect(rect: TRect): TRect;
begin
  Result.TopLeft     := rectlib_trans_point(rect.TopLeft);
  Result.BottomRight := rectlib_trans_point(rect.BottomRight);
end;


end.
