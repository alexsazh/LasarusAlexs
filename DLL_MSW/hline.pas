//штриховые линии (откосы):
unit hline;

{$MODE Delphi}

 interface

uses nums, vlib, llib, llibx, flib, List;


const steps_mul = 10;


//dx>=0; Result>=1 - кол-во интервалов, не вершин;
//if gcx_hl.hatch2_code>=0 then четный Result
function hl_step2n(step,dx: tnum): tint;

//укорачивание на gcx_hl.dlen
//if gcx_hl.hatch2_code>=0 then короткие нечетные штрихи(!)
//endind=0,1 - индекс неподвижного конца привязки
procedure hl_short(pab,pae: tpa; endind: integer);
procedure hl_short0(pab,pae: tpa; endind: integer);//укорачивание НАЧАЛА(!)



//Input: aclip(область), lbase(опорная линия - часть границы aclip)
//aclip.count>lbase.count>1
//lclip: "параллельная" lbase часть aclip
//Output: pab,pae - начала и концы отрезков - добавление(!) к массивам в hl_connect;
//div_list - список tmsobj: вектора деления, m.b. div_list=nil
function hl_execute(lbase,aclip: tpl; pab,pae: tpa; div_list: tclasslist): boolean;


(*
//hl_connect: если pab.count>0, то первый отрезок не рисуется(!!!):
function hl_connect(lbase,lclip: tpa; pab,pae: tpa): boolean;
*)
(*
function hl_separate_lbase(lbase,lclip: tpa; xb0,xe0: tfun; lb,le: tnuma): boolean;
*)

var do_short_beginning: boolean;//=> вызов hl_short0


//------------------------------------------------------------------
implementation
uses Wcmn, gcx, PSOBJ, Arrayx, hl_dp, Msfile;
//------------------------------------------------------------------


{ private: }


//точка пересечения штриха с lclip: -> hl_separate_lbase
procedure _hl_lsec_i(lbase,lclip: tpa; i: tint; v: tnum2; boxe: tnum4; le: tnuma; xe: tnuma);
var x,t: tnum;
begin
  if not lclip.lsec2(lbase[i], v_add(lbase[i], v), 1, t,x, boxe, le) then begin
    if i=0 then x:=0
    else if i=lbase.count-1 then x:=le.last
    //else x:=xe.last;
    else x:=lclip.xofp(lbase[i] , le);//ближайшая!
    //Tellf('ERROR: Луч без пересечения (i=%d)',[i]);
  end;
  xe.add(x);
end;

//точка пересечения p-v-штриха с lclip: -> hl_separate_lbase
function _hl_lsec_p(lclip: tpa; p,v: tnum2; boxe: tnum4; le: tnuma): tnum;
var x,t: tnum;
begin
  if not lclip.lsec2(p, v_add(p,v), 1, t,x, boxe, le) then begin
    x:=lclip.xofp(p,le);//ближайшая!
    //Tellf('ERROR: Луч без пересечения (i=%d)',[i]);
  end;
  Result:=x;
end;

(*
//точка пересечения 2-х штрихов; output: px,db,de; -> _hl_addsun
procedure _hl_hsec(lbase,lclip: tpa; xb1,xb2,xe1,xe2: tnum; lb,le: tnuma; px: tnum2; var db,de: tnum);
var
  secres: tint;
  t1,t2,xmid: tnum;
  pb1,pb2,pe1,pe2: tnum2;
begin
  pb1:=lbase.xp(xb1,lb);
  pb2:=lbase.xp(xb2,lb);
  db:=v_dist(pb1,pb2);
  pe1:=lclip.xp(xe1,le);
  pe2:=lclip.xp(xe2,le);
  de:=v_dist(pe1,pe2);
  secres:=v_sec_ll(pb1,pe1, pb2,pe2, t1,t2);
  if abs(secres)=1 then begin
    px := v_lt(pb1,pe1,t1);
  end else begin
    xmid:=(xe2+xe1)/2;//середина ???
    px := lclip.xp(xmid,le);
  end;
end;
*)

//заполнение участка xe штрихами -> hl_connect:
procedure _hl_addlin(lbase,lclip: tpa; step,xb1,xb2,xe1,xe2: tnum; pab,pae: tpa; lb,le: tnuma);
var fb,fe: tfun; n0,n2,i: integer;
begin
  fb:=tfun.New;
  fe:=tfun.New;
  try
    n0:=hl_step2n(step, abs(xb2-xb1));
    if pos('0',gcx_hl.mode)>0 then n0:=1;

    n2:=steps_mul*n0;

    fb.lin(n2+1,xb1,xb2);
    fe.lin(n2+1,xe1,xe2);
    if pab.count>0 then begin
      fb.delete(0);
      fe.delete(0);
    end;

    for i:=0 to fb.count-1 do begin
      pab.add( lbase.xp(fb[i],lb) );
      pae.add( lclip.xp(fe[i],le) );
    end;
  finally
    fb.free;
    fe.free;
  end;
end;


function _hl_xmid(lbase,lclip: tpa;  xb1,xb2: tnum; lb,le: tnuma; boxe: tnum4): tnum;
var pb1,pb2,px,v: tnum2;
begin
  pb1:=lbase.xp(xb1,lb);
  pb2:=lbase.xp(xb2,lb);
  v:=v_rot(v_sub(pb2,pb1),-90);
  px:=v_lt(pb1,pb2,1/2);
  Result:=_hl_lsec_p(lclip, px,v, boxe,le);
end;



(*
//коррекция участка xe[i]; -> _hl_correction
procedure _hl_cor1x(i: tint; lbase,lclip: tpa;  xb,xe: tfun; lb,le: tnuma; boxe: tnum4; irep: tintarray);
var
  db,de,xmid,x1,x2,xmin,xmax: tnum;
  pb1,pb2,px,v: tnum2;
begin
  irep.inc(i);

  pb1:=lbase.xp(xb[i],lb);
  pb2:=lbase.xp(xb[i+1],lb);
  db:=v_dist(pb1,pb2);

  if i>0 then xmin := xe[i-1] else xmin := 0;
  if i<xb.count-2 then xmax := xe[i+2] else xmax := le.last;

  //двойные пересечения:
  if xe[i]>xmax then xe[i]:=xmax-1;
  if xe[i+1]<xmin then xe[i+1]:=xmin+1;

  de:=db/2;//!
  if irep[i]>1 then de:=db/irep[i]; //против зацикливания

  //поиск середины xmid:
  v:=v_rot(v_sub(pb2,pb1),-90);
  px:=v_lt(pb1,pb2,1/2);
  xmid:=_hl_lsec_p(lclip, px,v, boxe,le);

  x1:=xmid-de/2;
  x2:=xmid+de/2;

  if i>0 then xe[i]:=x1;
  if i<xb.count-2 then xe[i+1]:=x2;
end;
*)


//итерационная коррекция самопересечений штрихов xe; -> hl_separate_lbase
procedure _hl_cor1(lbase,lclip: tpa;  xb,xe: tfun; lb,le: tnuma; boxe: tnum4);
var i,n: tint; correct: boolean; step: tnum;
begin
  if xb.count<=2 then exit;//!

  step:=le.last/100; //1% ?

  n:=0;
  repeat
    correct:=true;
    inc(n);
    for i:=0 to xb.count-2 do
      if xe[i+1]<xe[i] then begin
        correct:=false;
        //_hl_cor1x(i, lbase,lclip, xb,xe, lb,le,boxe, irep);
        xe[i+1]:=xe[i+1]+step;
        xe[i]:=xe[i]-step;
      end;
    if n>10000 then begin
      //Tellf('ERROR in _hl_cor1:\nЗацикливание итерационной коррекции',[0]);
      break;
    end;
  until correct;
end;


//линейная коррекция; -> hl_separate_lbase
procedure _hl_cor2(lbase,lclip: tpa;  xb,xe: tfun; lb,le: tnuma);
var i: tint; k: tnum; flin: tfun;
begin
  flin:=tfun.new;
  try
    //построение flin:
    k:=le.last/lb.last;
    if xe.count>0 then for i:=0 to xe.count-1 do flin.add(xb[i]*k);

    //коррекция:
    if xe.count>3 then for i:=1 to xe.count-2 do begin
      xe[i] := (xe[i] + flin[i])/2;
    end;

  finally
    flin.free;
  end;
end;



//итерационная коррекция плотности штрихов xe; -> _hl_separate_lbase
procedure _hl_cor3(lbase,lclip: tpa;  xb,xe: tfun; lb,le: tnuma);
var i,n,nloop: tint; correct: boolean; step: tnum; ks: tnum;

  function need_cor3: tint;//i=1..xb.count-2
  var s1,s2: tnum;//обратная плотность, "свобода", расстояние
  begin
    Result := 0;
    try
      s1 := max(xe[i]-xe[i-1], 0)/(xb[i]-xb[i-1]);
      s2 := max(xe[i+1]-xe[i], 0)/(xb[i+1]-xb[i]);
      if s2>ks*s1 then Result := 1
      else if s1>ks*s2 then Result := -1;
    except ;
    end;
  end;

begin//_hl_cor3
  if xb.count<=2 then exit;//!
  ks:=max(gcx_hl.ratio,1);
  step:=le.last/100; //1% ?
  nloop:=maxi(gcx_hl.nloop,10);
  n:=0;
  repeat
    correct:=true;
    inc(n);
    for i:=1 to xb.count-2 do
      if need_cor3<0 then begin
        correct:=false;
        xe[i]:=xe[i]-step;
      end else if need_cor3>0 then begin
        correct:=false;
        xe[i]:=xe[i]+step;
      end;
    if n>nloop then break; //?
  until correct;
end;//_hl_cor3



//------------------------------------------------------------------
{ public: }
//------------------------------------------------------------------


//dx>=0; Result>=1 - кол-во интервалов, не вершин;
//if gcx_hl.hatch2_code>=0 then четный Result
function hl_step2n(step,dx: tnum): tint;
begin
  if gcx_hl.hatch2_code>=0 then step:=2*step;
  try
    Result := Round( dx/step );
    if Result*step<dx then inc(Result); //с учащением (см. ямы) (?)
    if Result=0 then Result:=1;
  except
    Result:=1;
  end;
  if gcx_hl.hatch2_code>=0 then Result:=2*Result;
end;


//укорачивание на gcx_hl.dlen
//if gcx_hl.hatch2_code>=0 then короткие нечетные штрихи(!)
//endind=0,1 - индекс неподвижного конца привязки
procedure hl_short(pab,pae: tpa; endind: integer);
var i: integer; l2,t,d,tl,dl: tnum; p0,p1: tnum2;
begin
  tl:=gcx_hl.tlen;
  dl:=gcx_hl.dlen;

  if pab.count>1 then for i:=0 to pab.count-1 do begin
    d:=v_dist(pab[i],pae[i]);

    if (gcx_hl.hatch2_code>=0) and ((i mod 2)=1)
    then begin
      l2:=d*tl;
      if (gcx_hl.shortlen>0){!} and (l2>gcx_hl.shortlen)
      then l2:=gcx_hl.shortlen;//макс длина короткого штриха, default=0
    end
    else l2:=d-dl;

    if l2>d-dl then l2:=d-dl;
    if l2<0 then l2:=0;
    p0:=pab[i];
    p1:=pae[i];
    try t:=l2/d; except t:=1; end; if t>1 then t:=1;
    if endind=0 then pae[i]:=v_lt(p0,p1,t)
    else pab[i]:=v_lt(p0,p1,1-t);
  end;

  if do_short_beginning then hl_short0(pab,pae, endind);
end;

procedure hl_short0(pab,pae: tpa; endind: integer);
var i: integer; l2,t,d,dl: tnum; p0,p1: tnum2;
begin
  dl:=gcx_hl.dlen;

  if pab.count>1 then for i:=0 to pab.count-1 do begin
    d:=v_dist(pab[i],pae[i]);
    l2:=d-dl;
    if l2<0 then l2:=0;
    p0:=pab[i];
    p1:=pae[i];
    try t:=l2/d; except t:=1; end; if t>1 then t:=1;
    if endind=0 then pab[i]:=v_lt(p0,p1,1-t)
    else pae[i]:=v_lt(p0,p1,t);
  end;
end;


function hl_execute(lbase,aclip: tpl; pab,pae: tpa; div_list: tclasslist): boolean;
var
  i: integer; mso: tmsobj; t,x: tnum;
//  box: tnum4; l: tnuma;
  pl: tpl;//вектор деления
  lclip: tpl;//"параллельная" base часть aclip
begin
  Result:=false;
  if lbase.count<=1 then exit;

  //выделение линии концов lclip||base на границе aclip
  lclip := aclip.createsegmentpp(lbase.first,lbase.last);//направление параллельное
  pl:=tpl.new;
  try

    //"согласование" концов (первый и последний штрихи):
    if lclip.count>0 then lclip.Delete(lclip.count-1);
    if lclip.count>0 then lclip.Delete(0);

    //формирование векторов деления (hldp_div_pb, hldp_div_pe: tpa)(hl_dp.pas): :
    hldp_init;
    if (div_list<>nil) and (div_list.Count>0) then for i:=0 to div_list.Count-1 do begin

      tobject(mso):=div_list[i];
      mso.PolyFromLines(pl);//pl.clear;
      if pl.Count<>2 then continue;

      if lclip.lsec2(pl[0],pl[1], 1, t,x, lclip.box,lclip.lena) then begin
        hldp_div_pb.add( pl[0] );
        hldp_div_pe.add( lclip.xp(x) );
      end;

    end;//for i

    //MAIN: "штрихи" от lbase к lclip:
    //Result:=hl_connect(lbase,lclip, pab,pae);
    if lclip.count>1 then Result:=hldp_connect(lbase,lclip, pab,pae, 0);

  finally
    lclip.free;
    pl.free;
    hldp_init;//!
  end;

  //укорачивание:
  if Result then hl_short(pab,pae, 0);
end;


(*
//соединения lbase.first-lclip.first, lbase.last-lclip.last предопределены:
function hl_connect(lbase,lclip: tpa; pab,pae: tpa): boolean;
var
  i: tint;
  xb,xe: tfun;//координаты
  lb,le: tnuma;//длины
  pab1,pae1: tpa;
begin
  Result:=false;
  if (lbase.count<=1) or (lclip.count<=0) then exit;

  //инициализация:
  xb:=tfun.new; xe:=tfun.new;
  lb:=tnuma.new; le:=tnuma.new;
  pab1:=tpa.new; pae1:=tpa.new;

  //implementation:
  try
    lbase.GetLens(lb); lclip.GetLens(le);

    //разбиение lbase на участки по кривизне:
    Result:=hl_separate_lbase(lbase,lclip, xb,xe, lb,le);

    //xb,xe -> pab,pae (steps_mul!!!):
    if xb.count>1 then for i:=0 to xb.count-2 do begin
        _hl_addlin(lbase,lclip, gcx_hl.step, xb[i],xb[i+1],xe[i],xe[i+1], pab1,pae1, lb,le);
    end;

    //pab1->pab; pae1->pae: прореживание (steps_mul!!!):
    if pab1.count>0 then for i:=0 to pab1.count-1 do begin
      if (i mod steps_mul) <> 0 then continue; //!
      pab.add(pab1[i]); pae.add(pae1[i]);
    end;

  finally
    xb.free; xe.free;
    lb.free; le.free;
    pab1.free; pae1.free;
  end;//try
end;
*)

(*
//на корректируемом участке: интервалы выпуклости
function _hl_separate_lbase(lbase,lclip: tpa; xb,xe: tfun; lb,le: tnuma): boolean;
var
  i,j: tint; a,x,x1,x2: tnum;
  v: tnum2;
  boxe: tnum4;
  ab,dab: tnuma;//углы на lbase
  k,k1,k2: tint;//тип выпуклости: -1: влево, +1: вправо, 0==-1 (!) (gcx_hl.damin);
  k_ar,i_ar,bis_ar: tintarray;//k_ar[j]=k(тип) участка, начинающегося с точки с инд. i_ar[j]
begin
  Result:=false;
  if (lbase.count<=1) or (lclip.count<=0) then exit;

  //инициализация:
  ab:=tnuma.new;
  dab:=tnuma.new;
  k_ar:=tintarray.new;
  i_ar:=tintarray.new;
  bis_ar:=tintarray.new;

  //implementation:
  try
    lbase.GetAngles2(ab,dab);//dab.first=dab.last=0 (!)
    boxe:=lclip.Box;

    //STEP1: интервалы выпуклости (k_ar,i_ar):
    if lbase.count>2 then for i:=1 to lbase.count-2 do begin
      k:=signz(dab[i], gcx_hl.amin);
      if k=0 then k:=-1;// !!!
      if i=1 then begin i_ar.add(i); k_ar.add(k); continue; end;
      if k<>k_ar.last then begin i_ar.add(i); k_ar.add(k); end;
    end;//for i

    //STEP2: внутр.точки между интервалами выпуклости (массив биссектрисс bis_ar):
    if k_ar.count>1 then for i:=0 to k_ar.count-2 do begin
      k1:=k_ar[i];
      k2:=k_ar[i+1];
      j:=-1;
      if k1*k2<>0 then begin
        //i_v:=i_ar[i+1]-1;//вектор перед точкой i_ar[i+1]
        if k1>0 then j:=i_ar[i+1]-1 else j:=i_ar[i+1];
      end else begin
        //k<>0!!!
      end;
      if j<>-1 then bis_ar.add(j);
    end;//for i

    //STEP4: сортировка:
    bis_ar.sort(nil);

    //STEP5: штрихи (xb,xe):
    xb.add(0); xe.add(0);//первый штрих
    j:=-1;
    if bis_ar.count>0 then for i:=0 to bis_ar.count-1 do begin
      if bis_ar[i]=j then continue; //пропуск совпадающих
      j:=bis_ar[i];//индекс точки

      xb.add(lb[j]);

      //a := (ab[j-1]+ab[j])/2; //неправильно!
      a := ab[j-1] + dab[j]/2;  //правильно!
      v := v_rot( v_xy(100,0), a-90 );//биссектриса!
      //_hl_lsec_i(lbase,lclip, j,v, boxe,le, xe);
      x:=_hl_lsec_p(lclip, lbase[j],v, boxe,le);

      //коррекция:
      if x<xe.last then begin
        x1:=xb[xb.count-2];
        x2:=xb[xb.count-1];
        x:=_hl_xmid(lbase,lclip, x1,x2, lb,le,boxe);
        xe[xe.count-1]:=x;
      end;

      xe.add(x);

    end;//for i
    xb.add(lb.last); xe.add(le.last);//последний штрих:

    //STEP6: коррекция (xe):
    if pos('1',gcx_hl.mode)=0 then _hl_cor1(lbase,lclip, xb,xe, lb,le,boxe);
    if pos('2',gcx_hl.mode)=0 then _hl_cor2(lbase,lclip, xb,xe, lb,le);
    if pos('3',gcx_hl.mode)=0 then _hl_cor3(lbase,lclip, xb,xe, lb,le);

    Result:=true;
  finally
    ab.free; dab.free;
    k_ar.free; i_ar.free; bis_ar.free;
  end;//try
end;



function hl_separate_lbase(lbase,lclip: tpa; xb0,xe0: tfun; lb,le: tnuma): boolean;
var
  i,j: tint; a,t: tnum;
  p1,p2,p,v: tnum2;
  boxe: tnum4;
  ab,dab: tnuma;//углы на lbase
  bis_ar: tintarray;
  xb1,xe1: tfun;
  lbase2,lclip2: tpa;
  xb2,xe2: tfun;
  lb2,le2: tnuma;
begin
  Result:=false;
  if (lbase.count<=1) or (lclip.count<=0) then exit;

  //инициализация:
  ab:=tnuma.new;
  dab:=tnuma.new;
  bis_ar:=tintarray.new;
  xb1:=tfun.new;
  xe1:=tfun.new;

  //implementation:
  try
    lbase.GetAngles2(ab,dab);//dab.first=dab.last=0 (!)
    boxe:=lclip.Box;

    //STEP3: резкие повороты:
    if lbase.count>2 then for i:=1 to lbase.count-2 do begin
      if abs(dab[i])>gcx_hl.amax then bis_ar.add(i);
    end;//for i

    //STEP4: сортировка:
    bis_ar.sort(nil);

    //STEP5: штрихи (xb1,xe1):
    xb1.add(0); xe1.add(0);//первый штрих
    j:=-1;
    if bis_ar.count>0 then for i:=0 to bis_ar.count-1 do begin
      if bis_ar[i]=j then continue; //пропуск совпадающих
      j:=bis_ar[i];//индекс точки

      xb1.add(lb[j]);

      a := ab[j-1] + dab[j]/2;  //правильно!
      v := v_rot( v_xy(100,0), a-90 );//биссектриса!
      _hl_lsec_i(lbase,lclip, j,v, boxe,le, xe1);

    end;//for i
    xb1.add(lb.last); xe1.add(le.last);//последний штрих:


    //STEP6: прям.участки (после поворотов: bis_ar):
    if lbase.count>1 then for i:=0 to lbase.count-2 do begin
      if lb[i+1]-lb[i]>gcx_hl.lmax then begin
        p1:=lbase[i];
        p2:=lbase[i+1];

        if bis_ar.indexof(i)>=0 then begin
          j:=xb1.nearest(lb[i]);
          p:=lclip.xp(xe1[j],le);//конец штриха
          t:=v_vp(p1,p2,p);
          t := t + gcx_hl.lmax/(lb[i+1]-lb[i])/2;
          if t<0.5 then begin
            p:=v_lt(p1,p2,t);
            xb1.add(lbase.xofp(p, lb));
            xe1.add( _hl_lsec_p(lclip, p, v_rot( v_xy(100,0), ab[i]-90 ), boxe,le) );
          end;
        end;

        j:=i+1;
        if bis_ar.indexof(j)>=0 then begin
          j:=xb1.nearest(lb[i+1]);
          p:=lclip.xp(xe1[j],le);//конец штриха
          t:=v_vp(p1,p2,p);
          t := t - gcx_hl.lmax/(lb[i+1]-lb[i])/2;
          if t>0.5 then begin
            p:=v_lt(p1,p2,t);
            xb1.add(lbase.xofp(p, lb));
            xe1.add( _hl_lsec_p(lclip, p, v_rot( v_xy(100,0), ab[i]-90 ), boxe,le) );
          end;
        end;

      end;//if
    end;//for i

    //STEP6.1: сортировка (из-за прям-ых уч-ов!):
    xb1.sort(xe1);


    //STEP7: коррекция (xe):
    if pos('1',gcx_hl.mode)=0 then _hl_cor1(lbase,lclip, xb1,xe1, lb,le,boxe);


    //STEP8: участки:
    if xb1.count>1 then for i:=0 to xb1.count-2 do begin

      lbase2:=lbase.CreateSegment(xb1[i],xb1[i+1], lb,false);
      lclip2:=lclip.CreateSegment(xe1[i],xe1[i+1], le,false);
      lb2:=tnuma.new;
      le2:=tnuma.new;
      lbase2.GetLens(lb2);
      lclip2.GetLens(le2);
      xb2:=tfun.new;
      xe2:=tfun.new;

      if lb2.last<gcx_hl.step then continue; //!

      try

        Result:=_hl_separate_lbase(lbase2,lclip2, xb2,xe2, lb2,le2);
        if Result then begin
          if xb0.count>0 then xb0.delete(xb0.count-1);//dellast
          if xb2.count>0 then for j:=0 to xb2.count-1 do xb0.add(xb2[j]+xb1[i]);
          if xe0.count>0 then xe0.delete(xe0.count-1);//dellast
          if xe2.count>0 then for j:=0 to xe2.count-1 do xe0.add(xe2[j]+xe1[i]);
        end;//if Result

      finally
        lbase2.free;
        lclip2.free;
        lb2.free;
        le2.free;
        xb2.free;
        xe2.free;
      end;//try

    end;//for i

    Result:=true; //???

  finally
    ab.free; dab.free;
    bis_ar.free;
    xb1.free; xe1.free;
  end;//try
end;
*)

end.
