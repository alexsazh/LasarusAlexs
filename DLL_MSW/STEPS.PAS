unit STEPS;

{$MODE Delphi}

 interface

uses List, nums, llib, llibx;


//pa0 - область; apa1,apa2 - верхн. и нижн. ступени (справа ниже); step - шаг ступеней
//apa2.count=0 => боковые линии - прямолин-ые отрезки
//ступени строятся сверху вниз (apa1->apa2)
//кол-во ступеней("промежутков") nsteps=0 => используется step
//Result: list of tpl
//if not add_first_last => без 1-ой и последней линии ступеней
//steps m.b. nil
function st_execute(pa0,apa1,apa2: tpl; nsteps: tint; step: tnum; steps: tnuma; add_first_last: boolean): tclasslist;


implementation

uses CMN, vlib, Psmat,PSOBJ;


{ private: }


//заполняет массив tx (объединение вершин без first & last):
procedure st_tx(pa1,pa2: tpa; l1,l2: tnuma; tx: tnuma);
var i: tint;
begin
  tx.clear;
  if (pa1.count<=2) or (pa2.count<=2) then EXIT;//!

//  if pa1.count=pa2.count then begin

//    for i:=1 to pa1.count-2 do tx.add( ( l1[i]/l1.last + l2[i]/l2.last )/2 );

//  end else begin

    for i:=1 to pa1.count-2 do tx.add( l1[i]/l1.last );
    for i:=1 to pa2.count-2 do tx.add( l2[i]/l2.last );

//  end;

  tx.Sort(nil);
end;


//подобие: pa1.first->pa1x.first=pxb, pa1.last->pa1x.last=pxe;
//Result = коэф.подобия;
function st_transform(pa0,pa1: tpa; pb,pe: tnum2): tnum;
var
  i: tint;
  a: tnum;//угол
  pb0,pe0: tnum2;
  m,ms,mr,mt1,mt2: tmatrix;//подобие m: pa0->pa1 (tmatrix: psmat.pas)
  x,y: TPsReal;
begin
  pa1.count:=pa0.count;
  pb0:=pa0.first;
  pe0:=pa0.last;

  try
    Result:=v_dist(pb,pe)/v_dist(pb0,pe0);
    a:=v2_fi( v_sub(pe0,pb0), v_sub(pe,pb) );

    //матрицы ms,mr,mt->m:
    x:=Result; y:=Result; ms:=m_scale(x,y);
    x:=a; mr:=m_rotate(x);
    x:=pb0.x; y:=pb0.y; mt1:=m_translate(-x,-y);//pb0->(0,0)
    x:=pb.x; y:=pb.y; mt2:=m_translate(x,y);//(0,0)->pb
    m:=m_mul(@mt1,@ms);
    m:=m_mul(@m,@mr);
    m:=m_mul(@m,@mt2);

    //точки кривой:
    if pa0.count>0 then for i:=0 to pa0.count-1 do begin
      x:=pa0[i].x; y:=pa0[i].y; m_transform(@m, x,y, 1);
      pa1[i]:=v_xy(x,y);
    end;
  except
    Result:=1;
  end;
end;


//Внуеренние точки t-ступеньки - общий случай:
//Result - t-гомотопия pa1->pa2 по точкам x=tx[i];
//совмещение: начало линий - pxb, конец линий - pxe;
function st_new_gomo(pa1,pa2: tpl; pxb,pxe: tnum2; tx: tnuma; t: tnum): tpl;
var
  i: tint;
  pa1x,pa2x: tpa;//transform of pa1,pa2
  l1x,l2x: tnuma;
//  l: tnuma;
  xk1,xk2: tnum;//коэф.подобия
  p1,p2,px: tnum2;
begin
  Result := tpl.new;

  //начало (par):
  Result.add(pxb);

  //внутренние точки (tx[i]=0..1):
  if tx.count>0 then begin

    pa1x:=tpa.new;
    pa2x:=tpa.new;
    l1x:=tnuma.new;
    l2x:=tnuma.new;
//    l:=tnuma.new;
    try
      xk1:=st_transform(pa1,pa1x,pxb,pxe);
      l1x.addfrom(pa1.lena);
      l1x.mul(xk1);
      xk2:=st_transform(pa2,pa2x,pxb,pxe);
      l2x.addfrom(pa2.lena);
      l2x.mul(xk2);
      for i:=0 to tx.count-1 do begin
        p1:=pa1x.xp(tx[i]*l1x.last,l1x);
        p2:=pa2x.xp(tx[i]*l2x.last,l2x);
        px:=v_lt(p1,p2,t);
        Result.add(px);
      end;
    finally
//      Result.GetLens(l);//уберет совпадающие точки(!)
      pa1x.free;
      pa2x.free;
      l1x.free;
      l2x.free;
//      l.free;
    end;

  end;//if tx.count>0

  //конец (pae):
  Result.add(pxe);
end;

//Частный случай ф-ии st_new_gomo:
//Внуеренние точки t-ступеньки - "по точкам", если pa1.Count=pa2.Count:
//Result - t-ступенька;
//начало линии - pxb, конец линии - pxe;
function st_new_gomo_pnts(pa1,pa2: tpl; pxb,pxe: tnum2; t: tnum): tpl;
var
  i: tint;
  p1,p2,px: tnum2;
begin
  Result := tpl.new;

  //начало (на боковой линии par):
  Result.add(pxb);

  //внутренние точки (Result[i] на отрезке [pa1[i], pa2[i]]):
  if (pa1.Count=pa2.Count) and (pa1.Count>2)
  then for i:=1 to pa1.Count-2 do begin
    p1:=pa1[i];
    p2:=pa2[i];
    px:=v_lt(p1,p2,t);
    Result.add(px);
  end;//for i

  //конец (на боковой линии pae):
  Result.add(pxe);
end;


{ public: }


//ступени строятся сверху вниз (apa1->apa2)
function st_execute(pa0,apa1,apa2: tpl; nsteps: tint; step: tnum; steps: tnuma; add_first_last: boolean): tclasslist;
var
  i: tint;
  t,sum: tnum;
  st_count: tint;//кол-во линий ступеней, кроме верх. и нижн. ступени(!)
  pa1,pa2: tpl;//верх. и нижн. ступени (справа ниже)
  pal,par: tpl;//левая и правая стороны
  tx: tnuma;//позиции объединенного набора вершин (0..1); без first & last(!)
  pax: tpl;//ступень

  procedure _add_new_step;//use t,par,pal,pa1,pa2,tx,Result,pax
  var
    pxb,pxe: tnum2;//начало и конец pax
  begin
    pxb:=par.xp(t*par.lena.last);
    pxe:=pal.xp(t*pal.lena.last);

    if (pa1.Count=pa2.Count) and (pa1.Count>2)
    then pax:=st_new_gomo_pnts(pa1,pa2, pxb,pxe,t)//ступень "по точкам"
    else pax:=st_new_gomo(pa1,pa2, pxb,pxe,tx,t);

    Result.Add(pax);
  end;

begin
  Result := tclasslist.new;
  tx:=tnuma.new;
  try
    //построение pa1,pa2,pal,par:
    pa1:=tpl.New; pa1.addfrom(apa1);
    if apa2.count>0 then begin
      pa2:=tpl.New;
      pa2.addfrom(apa2);
    end else begin
      pa2:=pa0.CreateSegmentPP(pa1.first,pa1.last);
      pa2.DeleteFirst;
      pa2.DeleteLast;
    end;
    par:=pa0.CreateSegmentPP(pa1.first,pa2.first);
    pal:=pa0.CreateSegmentPP(pa2.last,pa1.last); pal.reverse;//!
    try
      //кол-во внутренних линий ступеней (>=0):
      st_count := nsteps-1;
      if st_count<=0 then st_count := cmn_step2n(step,par.lena.last,false) - 1;

      step:=1/(st_count+1);//скорректированный приведенный(!) шаг (par!)
      st_tx(pa1,pa2,pa1.lena,pa2.lena, tx);//=> tx(0..1) - объединение точек(!)

      //первая ступень:
      if add_first_last then begin pax:=tpl.new; pax.addfrom(pa1); Result.Add(pax); end;

      //без первой и последней ступеней:
      if (steps<>nil) and (steps.count>0) then begin
        t:=0;
        sum:=steps.sum;
        if (sum>0) and (steps.count>0) then for i:=0 to steps.count-1 do begin
          t:=t+steps[i]/sum; if t>=1 then break;
          _add_new_step;//use t,par,pal,pa1,pa2,tx,Result
        end;
      end else begin//if (steps<>nil)
        if st_count>0 then for i:=1 to st_count do begin
          t:=i*step;
          _add_new_step;//use t,par,pal,pa1,pa2,tx,Result
        end;
      end;//if (steps<>nil)

      //последняя ступень:
      if add_first_last then begin pax:=tpl.new; pax.addfrom(pa2); Result.Add(pax); end;

    finally
      pa1.free;
      pa2.free;
      par.free;
      pal.free;
    end;
  finally
    tx.free;
  end;
end;


end.
