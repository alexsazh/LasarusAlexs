unit matx;

{$MODE Delphi}

 interface

uses nums, vlib;

type
  //позиция:
  TPos2D = record
    p: tnum2;
    fi: tnum;//градусы
  end;

  PMatrix = ^TMatrix;
  TMatrix = record
    a,b,c,d: tnum;
    tx,ty: tnum;
  end;
  {
           a b
           c d
  x_dev := a*x + c*y + tx;
  y_dev := b*x + d*y + ty;
  }
  PMatrix2 = ^TMatrix2;
  TMatrix2 = record
    m: TMatrix;
    m2: TMatrix;//обратная
  end;

{ TMatrix: }

function m_init: TMatrix;//единичная
function m_scale(sx,sy: tnum): TMatrix;
function m_translate(tx,ty: tnum): TMatrix;
function m_rotate(angle: tnum): TMatrix; {a: градусы, X->Y}

function m_mul(pm1,pm2: PMatrix): TMatrix;//сначала pm1, потом pm2
function m_invert(pm,pm2: PMatrix): boolean;

//function m_by_3points(): TMatrix;

function m_transform0(pm: PMatrix; v: tnum2): tnum2;//только линейная часть
function m_transform(pm: PMatrix; v: tnum2): tnum2;//со сдвигом

//TPos2D:

function m_pos(aPos: TPos2D): TMatrix;//((0;0),0)->aPos
function m_pos2(aPos1, aPos2: TPos2D): TMatrix;//aPos1->aPos2

{ TMatrix2: }

function m2_init: TMatrix2;
function m2_scale(sx,sy: tnum): TMatrix2;
function m2_translate(tx,ty: tnum): TMatrix2;
function m2_rotate(angle: tnum): TMatrix2; {a: градусы}

function m2_mul(pm1,pm2: PMatrix2): TMatrix2;//сначала pm1, потом pm2


implementation


{TMatrix:}

function m_init: TMatrix;
begin
  FillChar(Result,sizeof(Result),0);
  Result.a:=1;
  Result.d:=1;
end;

function m_scale(sx,sy: tnum): TMatrix;
begin
  FillChar(Result,sizeof(Result),0);
  Result.a:=sx;
  Result.d:=sy;
end;

function m_translate(tx,ty: tnum): TMatrix;
begin
  FillChar(Result,sizeof(Result),0);
  Result.a:=1;
  Result.d:=1;
  Result.tx:=tx;
  Result.ty:=ty;
end;

function m_rotate(angle: tnum): TMatrix;
var s,c,arad: tnum;
begin
  arad:=angle*PI/180.;
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
var det: tnum;
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
    end;
  end;
end;


function m_transform0(pm: PMatrix; v: tnum2): tnum2;//только линейная часть
begin
  Result.x := pm^.a*v.x + pm^.c*v.y;
  Result.y := pm^.b*v.x + pm^.d*v.y;
end;
function m_transform(pm: PMatrix; v: tnum2): tnum2;//со сдвигом
begin
  Result.x := pm^.a*v.x + pm^.c*v.y + pm^.tx;
  Result.y := pm^.b*v.x + pm^.d*v.y + pm^.ty;
end;

//TPos2D:

function m_pos(aPos: TPos2D): TMatrix;//((0;0),0)->aPos
var m_t,m_r: TMatrix;
begin
  m_r:=m_rotate(aPos.fi);
  m_t:=m_translate(aPos.p.x, aPos.p.y);
  Result:=m_mul(@m_r, @m_t);
end;

function m_pos2(aPos1, aPos2: TPos2D): TMatrix;//aPos1->aPos2
var v: tnum2; m_t,m_r: TMatrix;
begin
  v:=v_mul(aPos1.p, -1);
  m_t:=m_translate(v.x, v.y);
  m_r:=m_rotate(aPos2.fi-aPos1.fi);
  Result:=m_mul(@m_t, @m_r);

  m_t:=m_translate(aPos2.p.x, aPos2.p.y);
  Result:=m_mul(@Result, @m_t);
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

function m2_scale(sx,sy: tnum): TMatrix2;
begin
  FillChar(Result,sizeof(Result),0);
  Result.m.a:=sx;
  Result.m.d:=sy;
  try
    Result.m2.a:=1./sx;
    Result.m2.d:=1./sy;
  except
    Result.m2:=m_init;
    //Ps.Error0('MatrixUndefinedResult');
  end;
end;

function m2_translate(tx,ty: tnum): TMatrix2;
begin
  FillChar(Result,sizeof(Result),0);
  Result.m.a:=1;
  Result.m.d:=1;
  Result.m.tx:=tx;
  Result.m.ty:=ty;
  Result.m2.a:=1;
  Result.m2.d:=1;
  Result.m2.tx:=-tx;
  Result.m2.ty:=-ty;
end;

function m2_rotate(angle: tnum): TMatrix2;
var s,c,arad: tnum;
begin
  arad:=angle*PI/180.;
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
