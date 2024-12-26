unit complex; interface

uses nums;


procedure z_ab2rf(a,b: tnum; var r,f: tnum);
procedure z_rf2ab(r,f: tnum; var a,b: tnum);
procedure z_rf_add(r1,f1,r2,f2: tnum; var r,f: tnum);
procedure z_rf_mul(r1,f1,r2,f2: tnum; var r,f: tnum);
procedure z_rf_div(r1,f1,r2,f2: tnum; var r,f: tnum);
procedure z_rf_det(r1,f1,r2,f2,r3,f3,r4,f4: tnum; var r,f: tnum);


implementation

uses Math, wcmn;


procedure z_ab2rf(a,b: tnum; var r,f: tnum);
begin
  r:=sqrt( sqr(a) + sqr(b) );
  try
    f:=arctan2(b,a);
  except
    if b>=0 then f:=pi/2 else f:=-pi/2;
  end;
end;

procedure z_rf2ab(r,f: tnum; var a,b: tnum);
begin
  a:=r*cos(f);
  b:=r*sin(f);
end;

procedure z_rf_add(r1,f1,r2,f2: tnum; var r,f: tnum);
var a1,b1,a2,b2,a,b: tnum;
begin
  z_rf2ab(r1,f1,a1,b1);
  z_rf2ab(r2,f2,a2,b2);
  a:=a1+a2;
  b:=b1+b2;
  z_ab2rf(a,b,r,f);
end;

procedure z_rf_mul(r1,f1,r2,f2: tnum; var r,f: tnum);
begin
  r:=r1*r2;
  f:=f1+f2;
end;

procedure z_rf_div(r1,f1,r2,f2: tnum; var r,f: tnum);
begin
  try
    r:=r1/r2;
    f:=f1-f2;
  except
    r:=0;
    Tell('Деление на 0');
  end;
end;

procedure z_rf_det(r1,f1,r2,f2,r3,f3,r4,f4: tnum; var r,f: tnum);
var rx,fx,ry,fy: tnum;
begin
  z_rf_mul(r1,f1,r4,f4,  rx,fx);
  z_rf_mul(r3,f3,r2,f2,  ry,fy);
  z_rf_add(rx,fx,-ry,fy,  r,f);
end;


end.
