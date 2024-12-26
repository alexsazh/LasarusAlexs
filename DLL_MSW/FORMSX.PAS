unit FORMSX;

{$MODE Delphi}

 interface

uses Math, nums, llib, llibx, List;


procedure frm_pogreb(pa0: tpa; pab,pae: tpa);
procedure frm_Besedka58(pa0, pab,pae: tpa);

procedure frm_Kran105(pa0, pax: tpa);
procedure frm_Bunker98(pa0, pax: tpa);

procedure frm_Bak76_77(pa0, pa1, pax: tpa; pa1_offset: boolean);
procedure frm_Bak78(pa0, pab, pae: tpa);
procedure frm_Bak79_80(pa0, pax, pab, pae: tpa; _79,_80: boolean);

procedure frm_Krilco35(pa0,pa1: tpl; pax: tpa; perekladina: boolean);
procedure frm_Bak95(pa0,pa1, pax: tpa);
function frm_Stenka(pa0,pa1: tpa; step2: tnum): tclasslist;//of tpl(!)

procedure frm_Priyamok54(pa0, pax: tpl; step: tnum);

{ МОСТЫ: }

procedure frm_BridgeSide(pa: tpa; l,a45: tnum);
procedure frm_Pila(pa1,pa2, pax: tpa);//металлический - 313
procedure frm_Steps(pa1,pa2, pab,pae: tpa);//цепные, канатные - 316
procedure frm_MY(pa0, pax: tpa);//дополн-ая боковая линия справа

{ ЛЭП: }

procedure frm_LEP(pl,stolbs: tpl; pab,pae: tpa);



implementation

uses vlib, hline, hl_dp, gcx;


procedure frm_pogreb(pa0: tpa; pab,pae: tpa);
var paxb,paxe: tpl;
begin
  paxb:=tpl.new;
  paxe:=tpl.new;
  try
    paxb.addfrom(pa0);
    paxb.deletefirst; //=> только дуга (без первого отрезка)
    paxb.leftline(paxe, -gcx_hl.sh_size);
    hldp_connect(paxb,paxe, pab,pae, 0);
    hl_short(pab,pae, 0);
  finally
    paxb.free;
    paxe.free;
  end;
end;

procedure frm_Besedka58(pa0, pab,pae: tpa);
var i: tint; pa1: tpa;
begin
  if pa0.count<=2 then exit;

  pa1:=tpa.new;
  try
    pa0.LeftLine(pa1, gcx_forms.len);
    for i:=0 to pa0.count-2 do begin
      //угловой штрих:
      pab.add(pa0[i]);
      pae.add(pa1[i]);
      //средний штрих:
      if (v_dist(pa0[i],pa0[i+1])>=4*gcx_DmPerMm)
      and (pa0.count-1<8){8-угольник из круга - msfile-415}
      then begin
        pab.add( v_lt(pa0[i],pa0[i+1],0.5) );
        pae.add( v_lt(pa1[i],pa1[i+1],0.5) );
      end;
    end;//for i
  finally
    pa1.free;
  end;
end;

procedure frm_Kran105(pa0, pax: tpa);
var p0,p1,p2: tnum2;
begin
  pax.clear;
  p0:=pa0[0];//острие
  p1:=pa0[1];
  p2:=pa0[pa0.count-2];

  pax.add( v_lt(p0,p2,1/4) );
  pax.add( v_lt(p0,p1,1/3) );

  pax.add( v_lt(p0,p2,2/4) );
  pax.add( v_lt(p0,p1,2/3) );

  pax.add( v_lt(p0,p2,3/4) );
  pax.add( p1 );
  pax.add( p2 );
end;

procedure frm_Bunker98(pa0, pax: tpa);
var
  ind: tint;
  l: tnuma; p0,p1,p2: tnum2; x0,x1,x2: tnum;
begin
  if pa0.count<4 then exit;
  ind:=pa0.iofv_ymax;//ind - индекс верхней стороны

  p0:=pa0[ind];
  p1:=pa0[ind+1];
  pax.Clear;
  pax.add(p0);
  pax.add(p1);

  l:=tnuma.new;
  try
    pa0.GetLens(l);
    x0:=pa0.xofp(p0,l);
    x1:=pa0.xofp(p1,l);
    x2:=mnum(x1,x0,0.5,l.last);
    p2:=pa0.xp(x2,l);
    pax.add(p2);
  finally
    l.free;
  end;

  pax.add( pax.first );
end;

procedure frm_Bak76_77(pa0, pa1, pax: tpa; pa1_offset: boolean);
var ind: tint; x,x1,x2: tnum; p,p1,p2: tnum2; l1: tnuma; pa_tmp: tpa;
begin
  if pa0.count<4 then exit;

  //pa1: вторая линия:
  if pa1_offset then pa0.LeftLine(pa1, 0.6*gcx_DmPerMm)
  else pa1.addfrom(pa0);

  //Лена Лапина 2014 (на Кубу):
  if pa1.Count=5{прямоуг-к} then begin

    //1-ый отрезок - "нижний",
    //черный треугольник вверху слева:
    pax.add(pa1[0]);
    pax.add(pa1[2]);
    pax.add(pa1[3]);
    pax.add(pa1[0]);//замыкание

  end else begin//if pa1.Count<>5:

    ind:=pa1.iofp_ymax;//ind - индекс верхней точки - по pa1(!)
    l1:=tnuma.new;
    try
      pa1.GetLens(l1);

      p:=pa1[ind];
      x:=pa1.xofp(p,l1);
      x1:=x-l1.last/8; while x1<0 do x1:=x1+l1.last;
      x2:=x+l1.last*3/8; while x1>l1.last do x1:=x1-l1.last;
      p1:=pa1.xp(x1,l1);
      p2:=pa1.xp(x2,l1);
      pa_tmp:=pa1.CreateSegmentPP(p1,p2);
      try
        pax.addfrom(pa_tmp);
        pax.add(pax.first);//замыкание
      finally
        pa_tmp.free;
      end;
    finally
      l1.free;
    end;

  end;//if pa1.Count<>5
end;

////////////////////////////////////////////////////////////////////
//ШТРИХИ по биссектриссе наружу - mm - длина в мм:
////////////////////////////////////////////////////////////////////
  //p - точка полилинии
  //v1 - предыдущий вектор полилинии
  //v2 - следующий вектор полилинии
  procedure ___formsx_add_shtrih(p,v1,v2: tnum2; pab, pae: tpa; mm: double);
  var v: tnum2;
  begin
    v1:=v_rot(v1,-90);
    v2:=v_rot(v2,-90);
    v:=v_biss_v(v1,v2);
    pab.Add(p);
    pae.Add( v_add( p, v_norm(v, mm*gcx_DmPerMm) ) );
  end;
///////////////////////////////////////////////////////////////////

procedure frm_Bak78(pa0, pab, pae: tpa);
//4 УСИКА:
type
  t_inds = array[0..3] of integer;
const
  _inds4:   t_inds = (0,1,2,3);//4-хугольник
  _inds5_7: t_inds = (0,1,3,4);//5,6,7-хугольник
  _inds8:   t_inds = (0,2,4,6);//8-хугольник
var
  _inds: t_inds; i,j: integer; p,v1,v2: tnum2;
begin
  //Заполнение _inds:
  if pa0.count<5 then EXIT;//меньше прямоугольника!
  case pa0.count of
    5:      _inds:=_inds4;
    6,7,8:  _inds:=_inds5_7;
    9:      _inds:=_inds8;
  else
    for i:=0 to 3 do
      //_inds[i] := Round( i*(pa0.count/4) );
      //_inds[i] := math.ceil( i*(pa0.count/4) );//округление ВВЕРХ
      _inds[i] := math.floor( i*(pa0.count/4) );//округление ВНИЗ
  end;//case

  //усики - по массиву _inds (4 УСИКА):
  if pa0.count>=5 then for j:=0 to 3 do begin
    i:=_inds[j];
    p:=pa0[i];
    if i>0 then v1:=pa0.V[i-1] else v1:=pa0.V[pa0.count-2];
    v2:=pa0.V[i];
    ___formsx_add_shtrih(p,v1,v2, pab, pae, 1.3{mm});
  end;//for i
end;

procedure frm_Bak79_80(pa0, pax, pab, pae: tpa; _79,_80: boolean);{м.б.черный треугольник}
//var i: integer; p,v1,v2,
var v13: tnum2;
begin
  if pa0.Count<5 then EXIT;//!

  //pab, pae: горизонт-е штрихи:
  v13 := v_norm( pa0.V[0], 1.3*gcx_DmPerMm );
  pab.Add(pa0[0]);
  pae.Add( v_sub(pa0[0], v13) );
  pab.Add(pa0[1]);
  pae.Add( v_add(pa0[1], v13) );

  //pab, pae: угловые штрихи (2 штуки сверху):
  if _80 then begin
    ___formsx_add_shtrih(pa0[2], pa0.V[1], pa0.V[2], pab, pae, 1.3{mm});
    ___formsx_add_shtrih(pa0[3], pa0.V[2], pa0.V[3], pab, pae, 1.3{mm});
  end;

  //pax: черный 3-угольник:
  if _79 then begin
    pax.add(pa0[0]);
    pax.add(pa0[2]);
    pax.add(pa0[3]);
    pax.add(pa0[0]);//замыкание
  end;

  pa0.DeleteFirst;//БЕЗ 1-ГО ОТРЕЗКА! - в .GC=o.-
end;

procedure frm_Krilco35(pa0,pa1: tpl; pax: tpa; perekladina: boolean);
var p0,p1,p2: tnum2; x0,x1,x2: tnum;
begin
  pax.Clear;
  if pa0.count<4 then exit;

  p0:=pa1.first;//левая точка "A"
  p1:=pa1.last;//правая точка "A"
  pax.add(p1);

    x0:=pa0.xofp(p0);
    x1:=pa0.xofp(p1);
    x2:=mnum(x1,x0,0.5,pa0.length);//средняя точка
    p2:=pa0.xp(x2);//вершина "A"
    pax.add(p2);
    pax.add(p0);
    if perekladina then begin
      pax.add( v_lt(p0,p2,0.5) );
      pax.add( v_lt(p1,p2,0.5) );
    end;
end;

procedure frm_Bak95(pa0,pa1, pax: tpa);
var x0,x1,y01,y10: tnum; l: tnuma; pa: tpa;
begin
  if pa0.count<3 then exit;
  pax.Clear;

  l:=tnuma.new;
  try
    pa0.GetLens(l);
    x0:=pa0.xofp(pa1.first,l);
    x1:=pa0.xofp(pa1.last,l);
    y01 := pa0.xp( mnum(x0,x1,0.5,l.last), l ).y;
    y10 := pa0.xp( mnum(x1,x0,0.5,l.last), l ).y;

    if y01>y10 then pa:=pa0.CreateSegment(x0,x1,l,false)
    else pa:=pa0.CreateSegment(x1,x0,l,false);
    try
      pax.AddFrom(pa);
      pax.add(pax.first);
    finally
      pa.free;
    end;

  finally
    l.free;
  end;
end;

function frm_Stenka(pa0,pa1: tpa; step2: tnum): tclasslist;
var
  i,i0,i1,n,j: tint;//n>=1
  d1,d2,step1,d0: tnum;
  pa2: tpa;//линия концов (||pa1)
  pax: tpl;//треугольник
  a1,b1, a2,b2: tnum2;//отрезки на pa1,pa2
  p1,q1,p2: tnum2;

  procedure _AddTriangle;
  begin
    pax:=tpl.new;
    pax.add(p2);
    pax.add(q1);
    pax.add(p1);
    pax.add(p2);
    Result.add(pax);
  end;

begin
  Result:=tclasslist.new;
  if pa1.count<2 then exit;//!

  i0:=pa0.iofp(pa1.First);
  inc(i0); if i0>=pa0.count-1 then dec(i0,pa0.count-1);
  i1:=pa0.iofp(pa1.Last);
  dec(i1); if i1<0 then inc(i1,pa0.count-1);

  pa2:=pa0.CreateSegmentPP(pa0[i0],pa0[i1]);
  try
    if (pa1.count=pa2.count){!} then for i:=0 to pa1.count-2 do begin
      a1:=pa1[i]; b1:=pa1[i+1];//отрезок pa1
      a2:=pa2[i]; b2:=pa2[i+1];//отрезок pa2
      d1:=v_dist(a1,b1);
      d2:=v_dist(a2,b2);
      //длина основания треуг-ков:
      d0:=step2/3;

      //построение треугольников:
      n:=Round(d2/step2); if n<1 then n:=1;//кол-во промеж-ов
      step2:=d2/n;//!
      if i=0 then for j:=0 to n do begin
        p2:=v_lt(a2,b2,step2*j/d2);
        step1:=(d1-d0)/n;
        p1:=v_lt(a1,b1,step1*j/d1);//начало основания
        q1:=v_lt(a1,b1,(step1*j+d0)/d1);//конец основания
        _AddTriangle;
      end else for j:=1 to n do begin
        p2:=v_lt(a2,b2,step2*j/d2);
        step1:=(d1)/n;
        p1:=v_lt(a1,b1,(step1*j-d0)/d1);//начало основания
        q1:=v_lt(a1,b1,step1*j/d1);//конец основания
        _AddTriangle;
      end;

    end;// for i
  finally
    pa2.free;
  end;
end;


procedure frm_Priyamok54(pa0, pax: tpl; step: tnum);
var a0,b0,ax,bx: tnum2;
begin
  pax.clear;
  if step=0 then exit;
  if pa0.count<4 then exit;

  //внутренняя линия pax:
  pa0.LeftLine(pax,step);

  //притягивание к 1-му отрезку внешней линии pa0:
  a0:=pa0[0]; b0:=pa0[1];
  ax:=pax[0]; bx:=pax[1];
  ax:=v_prj(a0,b0,ax);
  bx:=v_prj(a0,b0,bx);
  pax[0]:=ax; pax[1]:=bx;
  pax[pax.count-1]:=ax;
end;

//------------------------------------------------------

{ МОСТЫ: }

procedure frm_BridgeSide(pa: tpa; l,a45: tnum);
var v,p: tnum2;
begin
  if pa.count<2 then exit;

  try
    v:=pa.v[0];
    v:=v_rot(v,-90-a45);
    v:=v_mul(v, l/v_mod(v));
    p:=v_add(pa.first,v);
    pa.insert(0,p);

    v:=pa.v[pa.count-2];
    v:=v_rot(v,-a45);
    v:=v_mul(v, l/v_mod(v));
    p:=v_add(pa.last,v);
    pa.add(p);
  except ;
  end;
end;

procedure frm_Pila(pa1,pa2, pax: tpa);
var i,n: tint; d,step,step1,step2,x: tnum; l1,l2: tnuma;
begin
  pax.clear;
  pa2.reverse;//разворот
  l1:=tnuma.new; l2:=tnuma.new;
  try
    pa1.GetLens(l1); pa2.GetLens(l2);

    d:=v_dist(pa1.first,pa2.first);
    step:=(3/2)*d; //ориентировочный шаг

    n:=Round( l1.last/step );//кол-во промежутков на pa1
    if n<2 then n:=2;
    step1:=l1.last/n;//реальный шаг
    step2:=l2.last/n;//реальный шаг

    pax.add(pa1.First);
    for i:=1 to n do begin
      x:=step2*(2*i-1)/2; pax.add( pa2.xp(x,l2) );
      x:=step1*i; pax.add( pa1.xp(x,l1) );
    end;
  finally
    l1.free; l2.free;
    pa2.reverse;//восстановление
  end;
end;

procedure frm_Steps(pa1,pa2, pab,pae: tpa);//цепные, канатные - 316
var i,n: tint; step,step1,step2,dlen,x,t: tnum; l1,l2: tnuma; p1,p2: tnum2;
begin
  dlen:=gcx_forms.dlen;
  step:=gcx_forms.step;

  pa2.reverse;//разворот
  l1:=tnuma.new; l2:=tnuma.new;
  try

    pa1.GetLens(l1); pa2.GetLens(l2);
    n:=Round( l1.last/step );//кол-во промежутков на pa1 = кол-во штрихов(!)
    if n<2 then n:=2;//min: 2 штриха(!)
    step1:=l1.last/n;//реальный шаг
    step2:=l2.last/n;//реальный шаг

    pab.clear; pae.clear;
    for i:=1 to n do begin
      x:=step1*i-step1/2; p1:=pa1.xp(x,l1);
      x:=step2*i-step2/2; p2:=pa2.xp(x,l2);

      //расширение:
      try t:=dlen/v_dist(p1,p2); except t:=0; end;

      pab.add( v_lt(p1,p2, -t) );
      pae.add( v_lt(p1,p2, 1+t) );
    end;

  finally
    l1.free; l2.free;
    pa2.reverse;//восстановление
  end;
end;

procedure frm_MY(pa0, pax: tpa);//дополн-ая боковая линия справа
var v,p: tnum2; dlen: tnum;
begin
  pax.clear;
  if pa0.count<2 then exit;

  dlen:=gcx_forms.dlen;
  pa0.LeftLine(pax, -dlen);

  try
    v:=pa0.v[0];
    v:=v_rot(v,-90-45);
    v:=v_mul(v, dlen*sqrt(2)/v_mod(v));
    p:=v_add(pa0.first,v);
    pax.insert(0,p);

    v:=pa0.v[pa0.count-2];
    v:=v_rot(v,-45);
    v:=v_mul(v, dlen*sqrt(2)/v_mod(v));
    p:=v_add(pa0.last,v);
    pax.add(p);
  except ;
  end;
end;

//------------------------------------------------------

{ ЛЭП: }

procedure frm_LEP(pl,stolbs: tpl; pab,pae: tpa);
var i,pind: tint; p,stolb: tnum2;
begin
  if stolbs.count>0 then for i:=0 to stolbs.count-1 do begin

    stolb:=stolbs[i];
    pind:=pl.iofp(stolb);
    p:=pl[pind];//ближайшая к столбу вершина на линии "pl"

    //левая стрелка:
    if pind>0 then begin
      pab.add(p);
      pae.add( pl[pind-1] );
    end;

    //правая стрелка:
    if pind<pl.count-1 then begin
      pab.add(p);
      pae.add( pl[pind+1] );
    end;

  end;//for i
end;

//------------------------------------------------------

end.
