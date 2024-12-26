unit Psmat;

{$MODE Delphi}

 interface

uses PSOBJ;


type
  PMatrix = ^TMatrix;
  TMatrix = record
    a,b,c,d: TPsReal;
    tx,ty: TPsReal;
  end;

  {
           a b
           c d
  x_dev := a*x + c*y + tx;
  y_dev := b*x + d*y + ty;
  }

  PMatrix2 = ^TMatrix2;
  TMatrix2 = record
    m: TMatrix;  {from USER space to DEVICE space}
    m2: TMatrix; {обратная}
  end;


function m_init: TMatrix;
function m_scale(sx,sy: TPsReal): TMatrix;
function m_translate(tx,ty: TPsReal): TMatrix;
function m_rotate(a: TPsReal): TMatrix; {a: градусы}

function m_mul(pm1,pm2: PMatrix): TMatrix;//сначала pm1, потом pm2
function m_invert(pm,pm2: PMatrix): boolean;
procedure m_transform(pm: PMatrix; var x,y: TPsReal; Mode: Integer);

procedure mat2psmat(pm: PMatrix; po: PPsObj);
procedure psmat2mat(po: PPsObj; pm: PMatrix);

function m2_init: TMatrix2;
function m2_scale(sx,sy: TPsReal): TMatrix2;
function m2_translate(tx,ty: TPsReal): TMatrix2;
function m2_rotate(a: TPsReal): TMatrix2; {a: градусы}

function m2_mul(pm1,pm2: PMatrix2): TMatrix2;


implementation

uses PSX, Psarrays, PSOBJX;


{TMatrix:}

function m_init: TMatrix;
begin
  FillChar(Result,sizeof(Result),0);
  Result.a:=1;
  Result.d:=1;
end;

function m_scale(sx,sy: TPsReal): TMatrix;
begin
  FillChar(Result,sizeof(Result),0);
  Result.a:=sx;
  Result.d:=sy;
end;

function m_translate(tx,ty: TPsReal): TMatrix;
begin
  FillChar(Result,sizeof(Result),0);
  Result.a:=1;
  Result.d:=1;
  Result.tx:=tx;
  Result.ty:=ty;
end;

function m_rotate(a: TPsReal): TMatrix;
var s,c,arad: TPsReal;
begin
  arad:=a*PI/180.;
  s:=sin(arad);
  c:=cos(arad);

  FillChar(Result,sizeof(Result),0);
  Result.a:=c;
  Result.b:=s;
  Result.c:=-s;
  Result.d:=c;
end;

function m_mul(pm1,pm2: PMatrix): TMatrix;
begin
  Result.a := pm1^.a*pm2^.a + pm1^.b*pm2^.c;
  Result.b := pm1^.a*pm2^.b + pm1^.b*pm2^.d;
  Result.c := pm1^.c*pm2^.a + pm1^.d*pm2^.c;
  Result.d := pm1^.c*pm2^.b + pm1^.d*pm2^.d;

  Result.tx := pm1^.tx*pm2^.a + pm1^.ty*pm2^.c + pm2^.tx;
  Result.ty := pm1^.tx*pm2^.b + pm1^.ty*pm2^.d + pm2^.ty;
end;

function m_invert(pm, pm2: PMatrix): boolean;
var det: TPsReal;
begin
  Result:=true;
  with pm^ do begin
    det:=a*d-b*c;
    try
      pm2^.a:=d/det;
      pm2^.b:=-b/det;
      pm2^.c:=-c/det;
      pm2^.d:=a/det;
      pm2^.tx:=(c*ty-d*tx)/det;
      pm2^.ty:=(b*tx-a*ty)/det;
    except
      Result:=false;
      Ps.Error0('MatrixUndefinedResult');
    end;
  end;
end;

procedure m_transform(pm: PMatrix; var x,y: TPsReal; Mode: Integer);
var x2,y2: TPsReal;
begin
  x2 := pm^.a*x + pm^.c*y;
  y2 := pm^.b*x + pm^.d*y;

  if Mode=1 then begin
    x2 := x2 + pm^.tx;
    y2 := y2 + pm^.ty;
  end;

  x:=x2;
  y:=y2;
end;

procedure mat2psmat(pm: PMatrix; po: PPsObj);
var a: TPsArray;
begin
  TPsObjX(a):=psobj_psobjx(po^);

  a.put(0, psobj_real(pm^.a));
  a.put(1, psobj_real(pm^.b));
  a.put(2, psobj_real(pm^.c));
  a.put(3, psobj_real(pm^.d));
  a.put(4, psobj_real(pm^.tx));
  a.put(5, psobj_real(pm^.ty));
end;

procedure psmat2mat(po: PPsObj; pm: PMatrix);
var a: TPsArray;
begin
  TPsObjX(a):=psobj_psobjx(po^);

  pm^.a:=a.getp(0)^.r;
  pm^.b:=a.getp(1)^.r;
  pm^.c:=a.getp(2)^.r;
  pm^.d:=a.getp(3)^.r;
  pm^.tx:=a.getp(4)^.r;
  pm^.ty:=a.getp(5)^.r;
end;


{TMatrix2:}

function m2_init: TMatrix2;
begin
  FillChar(Result,sizeof(Result),0);
  Result.m.a:=1;
  Result.m.d:=1;
  Result.m2.a:=1;
  Result.m2.d:=1;
end;

function m2_scale(sx,sy: TPsReal): TMatrix2;
begin
  FillChar(Result,sizeof(Result),0);
  Result.m.a:=sx;
  Result.m.d:=sy;
  try
    Result.m2.a:=1./sx;
    Result.m2.d:=1./sy;
  except
    Result.m2:=m_init;
    Ps.Error0('MatrixUndefinedResult');
  end;
end;

function m2_translate(tx,ty: TPsReal): TMatrix2;
begin
  FillChar(Result,sizeof(Result),0);
  Result.m.tx:=tx;
  Result.m.ty:=ty;
  Result.m2.tx:=-tx;
  Result.m2.ty:=-ty;
end;

function m2_rotate(a: TPsReal): TMatrix2;
var s,c,arad: TPsReal;
begin
  arad:=a*PI/180.;
  s:=sin(arad);
  c:=cos(arad);

  FillChar(Result,sizeof(Result),0);
  Result.m.a:=c;
  Result.m.b:=s;
  Result.m.c:=-s;
  Result.m.d:=c;
  Result.m2.a:=c;
  Result.m2.b:=-s;
  Result.m2.c:=s;
  Result.m2.d:=c;
end;

function m2_mul(pm1,pm2: PMatrix2): TMatrix2;
begin
  Result.m := m_mul( @(pm1^.m), @(pm2^.m) );
  Result.m2 := m_mul( @(pm2^.m2), @(pm1^.m2) );
end;


end.
