//
// Vector's Algebra
//
unit Vlib;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, Math,
  Nums, Types;

type
  tnum2 = record x,y: tnum; end;
  pnum2 = ^tnum2;
  tnum4 = record a,b: tnum2; end;//xmin,ymin,xmax,ymax
  pnum4 = ^tnum4;

function v_eq(v1,v2: tnum2): boolean;

function v_rad (v: tnum2): tnum2;
function v_grad(v: tnum2): tnum2;

function v_xy(x,y: tnum): tnum2;//декартовы координаты
function v_point(pi: TPoint): tnum2;
function v_round(pr: tnum2): TPoint;
function v_ceil(pr: tnum2): TPoint;//вправо
function v_floor(pr: tnum2): TPoint;//влево
procedure v_reverse(pp: pnum2);//x<->y

function v_mod2(v: tnum2): tnum;//квадрат модуля
function v_mod(v: tnum2): tnum;//модуль
function v_dist(v1, v2: tnum2): tnum;
function v_add(v1, v2: tnum2): tnum2;
function v_sub(v1, v2: tnum2): tnum2;
function v_mul(v: tnum2; t: tnum): tnum2;
function v_vmul(v1, v2: tnum2): tnum;//3-я координата вект-го пр-ия; |v1|*|v2|*sin, ДЕТЕРМИНАНТ
function v_orient(v1, v2: tnum2): tint;//-1,0,1
function v_scale(v1, v2: tnum2): tnum; //|v1|*|v2|*cos
function v_ort(v: tnum2): tnum2;//(-y,x): Ox->Oy - от X к Y на 90град.
function v_dir(v1,v2: tnum2): boolean;//совпадение направлений

function v_norm(v: tnum2; len: tnum): tnum2;//v_mod(Result)=len
function v_norm1(v: tnum2): tnum2;//v_mod(Result)=1

function v_biss_a(v1,v2: tnum2): tnum;//угол биссектрисы от v1 к v2
function v_biss_v(v1,v2: tnum2): tnum2;//единичная биссектриса от v1 к v2
function v_biss_v0(v1,v2: tnum2): tnum2;//биссектриса МЕЖДУ v1 и v2 (add => где ближе)
function v_biss_v1(v1,v2: tnum2): tnum2;//биссектриса МЕЖДУ v1 и v2 (нормирование v1,v2)  !!!

procedure v_expand(a: tnum2; var b: tnum2; d: tnum);//расширение отрезка: смещение b на d

{ box: }

function v_box_round(aBox: tnum4): TRect;//GAUSS ??????
function v_box_rect(aBox: tnum4): TRect;//image (round)
function v_box_floor(aBox: tnum4): TRect;//image (влево)

function v_box(a,b: tnum2): tnum4; overload;//включая коррекцию!
function v_box(r: TRect): tnum4; overload;

function v_box2(x1,y1,x2,y2: tnum; const _correction: boolean = false): tnum4; overload;
function v_box2(a,b: tnum2; const _correction: boolean = false): tnum4; overload;
function v_box_size(box: tnum4): tnum2;

function v_xbox(a,b: tnum2; x: tnum): tnum4; overload;//box.a-(x,x), box.b+(x,x)
function v_xbox(box: tnum4; x: tnum): tnum4; overload;//box.a-(x,x), box.b+(x,x)
function v_xbox(box: tnum4; dx,dy: tnum): tnum4; overload;//box.a-(dx,dy), box.b+(dx,dy)
function v_box_expand(box,dbox: tnum4): tnum4;
function v_box_sub(box,dbox: tnum4): tnum4;//box.a+(dx,dy), box.b-(dx,dy)

function v_inbox(v: tnum2; box: tnum4): boolean;
function v_inxbox(v: tnum2; box: tnum4; x: tnum): boolean;
procedure v_box_correct(p: tnum2; var box: tnum4);//=> v_inbox(p,box)=true
function v_boxes_sec(b1,b2: tnum4): boolean;//рамки пересекаются
function v_boxes_add(b1,b2: tnum4): tnum4;//расширение рамки

{ углы: }

//function angle(x,y): tnum; - in nums.pas
//function angle_correct(a: tnum): tnum; - in nums.pas
function v_ra(r,a: tnum): tnum2;//полярные координаты, a: градусы!
function v_rot(v: tnum2; a: tnum): tnum2;//градусы, против час.стр.(т.е. от X к Y)
function v_fi(v: tnum2): tnum; //угол от оси Ox к оси Oy, -180..180
function v2_fi(v1,v2: tnum2): tnum; //v1->v2, -180..180

{ линия <a,b> и точка p: }

function v_side(a,b: tnum2; p: tnum2): integer;//-1(слева),0(на),+1(справа)
function v_side2(a,b,c: tnum2; p: tnum2): integer;//-1(слева),+-2(на),+1(справа)
//line's point p(t): p(0)=a, p(1)=b
function v_lt(a,b: tnum2; t: tnum): tnum2;
//координата (!) t проекции вектора <ap> на линию <ab>;
//a->0;b->1 if |ab|=0 then t=0:
function v_lp(a,b: tnum2; p: tnum2): tnum;
function v_vp(a,b: tnum2; p: tnum2): tnum;//0<=t<=1
function v_prj(a,b: tnum2; p: tnum2): tnum2;//на ось a,b
//Result: расстояние от p до её проекции на ab:
function v_dist_pl(p: tnum2; a,b: tnum2; var t: tnum): tnum;
function v_dist_pv(p: tnum2; a,b: tnum2; var t: tnum): tnum;//t=0..1

{ 2 линии <a1,b1> и <a2,b2>: }

//расстояние между векторами (uses v_sec_ll!):
function v_dist_vv(a1,b1, a2,b2: tnum2): tnum;

{ пересечения: }

//линии: l1=<a1b1>, l2=<a2b2>
//SecResult: 0 - нет реш., (+-1) - 1 реш., 2 - беск.мн-во реш.
//возможность SecResult=2 зависит от v_zero
//SecResult<>+-1 => t1,t2 не определены (!)
//SecResult=1 => (a1b1)-"наружу", если (a2b2)-часть границы "области" (!):
//В координатах карты (Y вниз): SecResult=-1 => (a1b1)-"наружу"
function v_sec_ll0(a1,b1,a2,b2: tnum2; var t1,t2: tnum; zero: extended): tint;
function v_sec_ll(a1,b1,a2,b2: tnum2; var t1,t2: tnum): tint;//v_zero
function v_sec_lv_exists(a1,b1,a2,b2: tnum2): boolean;//a2,b2 - по разные стороны прямой <a1b1>
function v_sec_lv(a1,b1,a2,b2: tnum2; var tl,tv: tnum): tint;//tv:=0..1; uses v_sec_lv_exists


var v_zero: tnum;


//------------------------------------------------------------
implementation
//------------------------------------------------------------

uses SysUtils, Wcmn;


function v_eq(v1,v2: tnum2): boolean;
begin
  Result := (v1.x=v2.x) and (v1.y=v2.y);
end;


function v_rad (v: tnum2): tnum2;
begin
  Result.x:=rad(v.x);
  Result.y:=rad(v.y);
end;
function v_grad(v: tnum2): tnum2;
begin
  Result.x:=grad(v.x);
  Result.y:=grad(v.y);
end;


function v_xy(x,y: tnum): tnum2;
begin
  Result.x := x;
  Result.y := y;
end;

function v_point(pi: TPoint): tnum2;
begin
  Result.x := pi.x;
  Result.y := pi.y;
end;

function v_round(pr: tnum2): TPoint;
begin
  Result.x := round(pr.x);
  Result.y := round(pr.y);
end;

function v_ceil(pr: tnum2): TPoint;
begin
  Result.x := math.ceil(pr.x);
  Result.y := math.ceil(pr.y);
end;

function v_floor(pr: tnum2): TPoint;
begin
  Result.x := math.floor(pr.x);
  Result.y := math.floor(pr.y);
end;

procedure v_reverse(pp: pnum2);//x<->y
var xx: tnum;
begin
  xx:=pp^.x; pp^.x:=pp^.y; pp^.y:=xx;
end;

function v_mod2(v: tnum2): tnum;
begin
  Result := 0;
  try Result := sqr(v.x) + sqr(v.y);
  except Tell('Real Overflow in v_mod2');
  end;
end;

function v_mod(v: tnum2): tnum;
begin
  Result := 0;
  try Result := sqrt( sqr(v.x) + sqr(v.y) );
  except Tell('Real Overflow in v_mod');
  end;
end;

function v_dist(v1, v2: tnum2): tnum;
begin
  Result := v_mod( v_sub(v2,v1) );
end;

function v_add(v1, v2: tnum2): tnum2;
begin
  Result.x := v1.x + v2.x;
  Result.y := v1.y + v2.y;
end;

function v_sub(v1, v2: tnum2): tnum2;
begin
  Result.x := v1.x - v2.x;
  Result.y := v1.y - v2.y;
end;

function v_mul(v: tnum2; t: tnum): tnum2;
begin
  Result.x := t*v.x;
  Result.y := t*v.y;
end;

function v_vmul(v1, v2: tnum2): tnum;//3-я координата вект-го пр-ия, ДЕТЕРМИНАНТ
begin
  Result := v1.x*v2.y - v1.y*v2.x;
end;

function v_orient(v1, v2: tnum2): tint;//-1,0,1
var x: tnum;
begin
  //Result:=1;
  x:=v_vmul(v1, v2);
  if x>v_zero then Result:=1
  else if x<-v_zero then Result:=-1
  else Result:=0;
end;

function v_scale(v1, v2: tnum2): tnum;
begin
  Result := v1.x*v2.x + v1.y*v2.y;
end;

function v_ort(v: tnum2): tnum2;//(-y,x): Ox->Oy
begin
  Result.x := -v.y;
  Result.y :=  v.x;
end;

function v_dir(v1,v2: tnum2): boolean;//совпадение направлений
begin
  Result := v_scale(v1,v2)>0;
end;

function v_norm(v: tnum2; len: tnum): tnum2;//v_mod(Result)=len
begin
  try
    Result := v_mul(v, len/v_mod(v));
  except
    Result := v_xy(len,0);                       //???
  end;
end;

function v_norm1(v: tnum2): tnum2;//v_mod(Result)=1
begin
  Result:=v_norm(v,1);
end;


function v_biss_a(v1,v2: tnum2): tnum;//угол биссектрисы от v1 к v2
var a1,a2: tnum;
begin
  a1:=v_fi(v1);
  a2:=v_fi(v2);
  //while a1<0 do a1:=a1+360;
  while a2<a1 do a2:=a2+360;//=> a2>=a1

  Result := angle_correct( (a1+a2)/2 );       //xxx: a1=-179, a2=179 => Result=0  !???!
end;

function v_biss_v(v1,v2: tnum2): tnum2;//единичная биссектриса от v1 к v2
begin
  Result:=v_rot( v_xy(1,0), v_biss_a(v1,v2) );            //см. xxx in v_biss_a  !???!
  //Result:=v_add(v1,v2); Result:=v_norm1(Result);
end;

function v_biss_v0(v1,v2: tnum2): tnum2;//"биссектриса" МЕЖДУ v1 и v2 (add => где ближе)
begin
  Result:=v_add(v1,v2);                                   //это НЕ БИССЕКТ-СА, если v1,v2 РАЗНОЙ ДЛИНЫ !?!
end;

function v_biss_v1(v1,v2: tnum2): tnum2;//биссектриса МЕЖДУ v1 и v2 (нормирование v1,v2)
begin
  Result:=v_add( v_norm1(v1), v_norm1(v2) );              //см. except in v_norm1 !?!
end;


procedure v_expand(a: tnum2; var b: tnum2; d: tnum);//расширение отрезка: смещение b на d
var v: tnum2;
begin
  if d=0 then exit;
  v:=v_sub(b,a);
  v:=v_norm(v,d);
  b:=v_add(b,v);
end;


{ box: }

function v_box_round(aBox: tnum4): TRect;//GAUSS ??????
begin
  Result.Left  := Round(aBox.a.y);
  Result.Right := Round(aBox.b.y);
  Result.Top   := Round(aBox.b.x);//x ВВЕРХ!
  Result.Bottom:= Round(aBox.a.x);
end;

function v_box_rect(aBox: tnum4): TRect;//image
begin
  Result.Left  := Round(aBox.a.x);
  Result.Right := Round(aBox.b.x);
  Result.Top   := Round(aBox.a.y);
  Result.Bottom:= Round(aBox.b.y);
end;

function v_box_floor(aBox: tnum4): TRect;
begin
  Result.Left  := Math.Floor(aBox.a.x);
  Result.Right := Math.Floor(aBox.b.x);
  Result.Top   := Math.Floor(aBox.a.y);
  Result.Bottom:= Math.Floor(aBox.b.y);
end;

function v_box(a,b: tnum2): tnum4;
begin
  Result.a := a;
  Result.b := a;//!
  v_box_correct(b,Result);
end;

function v_box(r: TRect): tnum4;
begin
  Result.a := v_point(r.TopLeft);
  Result.b := v_point(r.BottomRight);
end;

function v_box2(x1,y1,x2,y2: tnum; const _correction: boolean = false): tnum4;
begin
  if _correction then begin
    Result:=v_box( v_xy(x1,y1), v_xy(x2,y2) );
  end else begin
    Result.a.x:=x1;
    Result.a.y:=y1;
    Result.b.x:=x2;
    Result.b.y:=y2;
  end;
end;

function v_box2(a,b: tnum2; const _correction: boolean = false): tnum4;
begin
  Result:=v_box2(a.x,a.y, b.x,b.y);
end;

function v_box_size(box: tnum4): tnum2;
begin
  Result.x:=abs(box.b.x-box.a.x);//abs!!!
  Result.y:=abs(box.b.y-box.a.y);//abs!!!
end;

function v_xbox(a,b: tnum2; x: tnum): tnum4;
var vx: tnum2;
begin
  vx := v_xy(x,x);
  Result.a := v_sub(a, vx);
  Result.b := v_add(b, vx);
end;

function v_xbox(box: tnum4; x: tnum): tnum4;
begin
  Result := v_xbox(box.a, box.b, x);
end;

function v_xbox(box: tnum4; dx,dy: tnum): tnum4;
var v: tnum2;
begin
  v := v_xy(dx,dy);
  Result.a := v_sub(box.a, v);
  Result.b := v_add(box.b, v);
end;

function v_box_expand(box,dbox: tnum4): tnum4;
begin
  Result.a := v_sub(box.a, dbox.a);
  Result.b := v_add(box.b, dbox.b);
end;

function v_box_sub(box,dbox: tnum4): tnum4;
begin
  Result.a := v_add(box.a, dbox.a);
  Result.b := v_sub(box.b, dbox.b);
end;

function v_inbox(v: tnum2; box: tnum4): boolean;
begin
  Result := (v.x>=box.a.x) and (v.x<=box.b.x) and (v.y>=box.a.y) and (v.y<=box.b.y);
end;

function v_inxbox(v: tnum2; box: tnum4; x: tnum): boolean;
begin
  Result := v_inbox(v, v_xbox(box.a,box.b,x));
end;

procedure v_box_correct(p: tnum2; var box: tnum4);
begin
  with box do begin
    if p.x<A.x then A.x:=p.x;
    if p.x>B.x then B.x:=p.x;
    if p.y<A.y then A.y:=p.y;
    if p.y>B.y then B.y:=p.y;
  end;
end;

function v_boxes_sec(b1,b2: tnum4): boolean;//рамки пересекаются
begin
  Result:=false;
  if b1.b.x<b2.a.x then exit;//b1 слева от b2
  if b1.a.x>b2.b.x then exit;//b1 справа от b2
  if b1.b.y<b2.a.y then exit;//b1 ниже b2
  if b1.a.y>b2.b.y then exit;//b1 выше b2
  Result:=true;
end;

function v_boxes_add(b1,b2: tnum4): tnum4;
begin
  Result.a.x := min(b1.a.x,b2.a.x);
  Result.a.y := min(b1.a.y,b2.a.y);
  Result.b.x := max(b1.b.x,b2.b.x);
  Result.b.y := max(b1.b.y,b2.b.y);
end;


{ углы: }

function v_ra(r,a: tnum): tnum2;
begin
  Result.x := r*cos(rad(a));
  Result.y := r*sin(rad(a));
end;

function v_rot(v: tnum2; a: tnum): tnum2;//против часовой стрелки
var r: tnum;
begin
  r:=rad(a);
  Result.x := v.x*cos(r) - v.y*sin(r);
  Result.y := v.x*sin(r) + v.y*cos(r);
end;


function v_fi(v: tnum2): tnum; //угол от оси Ox, -180..180
begin
  Result:=angle(v.x,v.y);//-180..180
end;

function v2_fi(v1,v2: tnum2): tnum; //v1->v2, -180..180
begin
  Result := v_fi(v2) - v_fi(v1);
  Result := angle_correct(Result);
end;


{ линия и точка: }

function v_side(a,b: tnum2; p: tnum2): integer;//-1(слева),0(на),+1(справа) (a<>b)
var x: tnum;
begin
  x := v_vmul( v_sub(p,a), v_sub(b,a));
  Result:=sign(x);
  //if (Result=0) and (v_dist(p,b)=0) then Result:=-v_side(b,a,p);//проверка на p=a
end;

function v_side2(a,b,c: tnum2; p: tnum2): integer;//-1(слева),+-2(на),+1(справа)
var p_ab,p_bc,c_ab: integer; x_ab,x_bc: tnum;
begin
  c_ab:=v_side(a,b,c);
  p_ab:=v_side(a,b,p);
  p_bc:=v_side(b,c,p);
  x_ab:=v_lp(a,b,p);
  x_bc:=v_lp(b,c,p);
  if c_ab<=0 then begin
    if (p_ab<0) and (p_bc<0)  then Result:=-1 else
    if (p_ab=0) and (x_ab<1)  then Result:=-2 else
    if (p_bc=0) and (x_bc>=0) then Result:=+2 else
    Result:=+1;
  end else begin//c_ab>0:
    if (p_ab>0) and (p_bc>0)  then Result:=+1 else
    if (p_ab=0) and (x_ab<1)  then Result:=-2 else
    if (p_bc=0) and (x_bc>=0) then Result:=+2 else
    Result:=-1;
  end;
end;

function v_lt(a,b: tnum2; t: tnum): tnum2;//line's point
begin
  Result := v_add(a, v_mul(v_sub(b, a), t));
end;

//координата (!) t проекции вектора <ap> на линию <ab>;
//a->0;b->1 if |ab|=0 then t=0:
function v_lp(a,b: tnum2; p: tnum2): tnum;
var v: tnum2; d2: tnum;
begin
  v := v_sub(b,a);
  d2 := sqr(v.x) + sqr(v.y);//mod^2
  try
    if d2=0
    then Abort;
    Result:=v_scale(v,v_sub(p,a))/d2;
  except
    Result:=0;
  end;
end;

function v_vp(a,b: tnum2; p: tnum2): tnum;
begin
  Result := v_lp(a,b, p);//координата проекции
  if Result<0 then Result:=0;
  if Result>1 then Result:=1;
end;

function v_prj(a,b: tnum2; p: tnum2): tnum2;//на ось a,b
var t: tnum;
begin
  t:=v_lp(a, b, p);
  Result:=v_lt(a, b, t);
end;

function v_dist_pl(p: tnum2; a,b: tnum2; var t: tnum): tnum;
begin
  t := v_lp(a,b, p);//координата проекции
  Result := v_dist(p, v_lt(a,b, t));
end;

function v_dist_pv(p: tnum2; a,b: tnum2; var t: tnum): tnum;
begin
  t := v_lp(a,b, p);//координата проекции
  if t<0 then t:=0;
  if t>1 then t:=1;
  Result := v_dist(p, v_lt(a,b, t));
end;


{ 2 линии <a1,b1> и <a2,b2>: }

function v_dist_vv(a1,b1, a2,b2: tnum2): tnum;
var secres: integer; d,t1,t2: double;
begin
  //1: пересечение отрезков => dist=0:
  secres:=v_sec_ll(a1,b1, a2,b2, t1,t2);
  if (abs(secres)=1) and (t1>=0) and (t1<=1) and (t2>=0) and (t2<=1)
  then Result:=0
  else Result:=v_dist(a1,a2);//default
  if Result=0 then exit;//!

  //2: 4 расстояния концов до др. отрезка:
  d := v_dist_pv(a1, a2,b2, t2); if d<Result then Result:=d;
  d := v_dist_pv(b1, a2,b2, t2); if d<Result then Result:=d;
  d := v_dist_pv(a2, a1,b1, t1); if d<Result then Result:=d;
  d := v_dist_pv(b2, a1,b1, t1); if d<Result then Result:=d;
end;


{ пересечения: }


//SecResult: 0 - нет реш., (+-1) - 1 реш., 2 - беск.мн-во реш.
//возможность SecResult=2 зависит от v_zero
//SecResult<>1 => t1,t2 не определены
function v_sec_ll0(a1,b1,a2,b2: tnum2; var t1,t2: tnum; zero: extended): tint;
var v1,v2,u: tnum2; t,v12,uv1,uv2: tnum;
begin
  v1  := v_sub (b1, a1);
  v2  := v_sub (b2, a2);
  u   := v_sub (a2, a1);
  v12 := v_vmul(v1, v2);
  uv1 := v_vmul(u, v1);
  uv2 := v_vmul(u, v2);

  try
    if v12=0 then
      Abort;
    t := 1/v12;
    t1 := uv2*t;
    t2 := uv1*t;
    Result:=signz(v12,zero);//+-1,0, m.b. zero=0
  except//=>параллельны:
    Result:=0
  end;

  if (Result=0) and (abs(uv1)<=zero) and (abs(uv2)<=zero) then//m.b. zero=0
    Result:=2;
end;

function v_sec_ll(a1,b1,a2,b2: tnum2; var t1,t2: tnum): tint;
begin
  Result := v_sec_ll0(a1,b1,a2,b2, t1,t2, v_zero);
end;

function v_sec_lv_exists(a1,b1,a2,b2: tnum2): boolean;
var v: tnum2; ma,mb: tnum;
begin
  v:=v_sub(b1,a1);//линия
  ma:=v_vmul(v, v_sub(a2,a1));
  mb:=v_vmul(v, v_sub(b2,a1));
  Result := (ma*mb<0) or ( (ma=0) and (mb=0) ); //m.b. a2=b2 lies on (a1b1)
end;

//Result<>+-1 => tl,tv не определены
function v_sec_lv(a1,b1,a2,b2: tnum2; var tl,tv: tnum): tint;//tv:=0..1
begin
  if not v_sec_lv_exists(a1,b1,a2,b2) then begin Result:=0; exit; end;//быстрее
  Result:=v_sec_ll(a1,b1, a2,b2, tl,tv);
  if abs(Result)=1 then if (tv<0) or (tv>1) then Result:=0;
end;



//------------------------------------------------------------


initialization
  v_zero:=Power(10,-10);//double: 15-16 Significant digits, single: 7-8 Significant digits


end.
