(*
  - кривые Безье
  - загрузка из .DM и аппроксимация - TDmo.BezToPl (dmlib.pas) - uses in Fill.dpr
*)
unit Curve;

{$MODE Delphi}

 interface

uses nums, vlib;


type
  tcurve = class
  private
    A,B,C,D: tnum2;//коэффициенты ур-ия; D=P0
    function GetP_t(t: tnum): tnum2;//0<=t<=1
    function GetV_t(t: tnum): tnum2;//касательный вектор, 0<=t<=1
  public
    constructor Create(p0,p1,p2,p3: tnum2);//p0,p1,p2,p3 -> A,B,C,D
    procedure GetPoints(var p0,p1,p2,p3: tnum2);//A,B,C,D -> p0,p1,p2,p3

    //точки максим-го отклонения:
    //RETURN: кол-во корней (0,1,2; 0, если p0=p3):
    function GetMaxt(var t1,t2: tnum): integer;

    property P[t: tnum]: tnum2 read GetP_t; default;//0<=t<=1
    property V[t: tnum]: tnum2 read GetV_t;//0<=t<=1
  end;

implementation

uses Wcmn;



{ tcurve: }


constructor tcurve.Create(p0,p1,p2,p3: tnum2);//p0,p1,p2,p3 -> A,B,C,D
begin
  D := p0;

  C.x := 3*(p1.x-p0.x);
  C.y := 3*(p1.y-p0.y);

  B.x := 3*(p2.x-p1.x) - C.x;
  B.y := 3*(p2.y-p1.y) - C.y;

  A.x := (p3.x-p0.x) - C.x - B.x;
  A.y := (p3.y-p0.y) - C.y - B.y;
end;

procedure tcurve.GetPoints(var p0,p1,p2,p3: tnum2);//A,B,C,D -> p0,p1,p2,p3
begin
  p0 := D;

  p1.x := p0.x + C.x/3;
  p1.y := p0.y + C.y/3;

  p2.x := p1.x + (C.x+B.x)/3;
  p2.y := p1.y + (C.y+B.y)/3;

  p3.x := p0.x + C.x + B.x + A.x;
  p3.y := p0.y + C.y + B.y + A.y;
end;

function tcurve.GetP_t(t: tnum): tnum2;//0<=t<=1
begin
  Result.x:=polynom3(A.x,B.x,C.x,D.x,t);
  Result.y:=polynom3(A.y,B.y,C.y,D.y,t);
end;

function tcurve.GetV_t(t: tnum): tnum2;//касательный вектор, 0<=t<=1
begin
  Result.x:=polynom2(3*A.x,2*B.x,C.x,t);
  Result.y:=polynom2(3*A.y,2*B.y,C.y,t);
end;


function tcurve.GetMaxt(var t1,t2: tnum): integer;
var at,bt,ct,x1,x2: Extended; z: tnum2;
begin
  z.x := A.x + B.x + C.x;
  z.y := A.y + B.y + C.y;

  try
    at := 3*A.x/z.x - 3*A.y/z.y;
    bt := 2*B.x/z.x - 2*B.y/z.y;
    ct := C.x/z.x - C.y/z.y;
    Result := equation2(at,bt,ct, x1,x2);
  except
    Result := 0; //???
  end;

  t1:=x1;
  t2:=x2;

  if Result<0 then Result:=0;//=>Result=0,1,2

  if Result=2 then begin
    if (t2<0) or (t2>1) then begin dec(Result); t2:=t1; end;
    if (t1<0) or (t1>1) then dec(Result);
  end;
  if Result=1 then begin
    if (t1<0) or (t1>1) then dec(Result);
  end;
end;

end.
