(*
  зигзаг или волна
*)
unit VOLNA;

{$MODE Delphi}

 interface

uses List,llibx,nums;


//outlist: of tpl;
//inds - in gcx_obj.outcode(!)
procedure volna_execute(pl0: tpl; outlist: tclasslist; inds: tinta);

function volna_pll: tpl;//DEBUG
function volna_plr: tpl;//DEBUG


implementation

uses Wcmn, gcx, vlib, llib, hl_dp, RUNLINE2;


var pll,plr: tpl;//левая и правая параллельные линии

function volna_pll: tpl; begin Result:=pll; end;

function volna_plr: tpl; begin Result:=plr; end;


(*
procedure _add_volna_period(pl: tpl; p1,p2,p3,p4: tnum2);
begin
  //простейший вариант:
  pl.add(p2);
  pl.add(p3);
  pl.add(p4);
end;
//pl = zigzag -> volna
procedure _make_volna_from_zigzag(pl0,pl: tpl);
var
  i,n:tint;
  plz: tpl;//pl->plz - zigzag
  p1,p2,p3,p4: tnum2;//точки периода
  p: tnum2;
begin
  plz:=tpl.new;
  try
    plz.addfrom(pl);
    pl.clear;//будет волна
    pl.add(plz.first);//moveto
    n:=(plz.count-2) div 2;//число периодов

    //периоды волны (curveto - 3 точки):
    if n>0 then for i:=0 to n-1 do begin

      //точки периода:
      p2:=plz[1+i*2];
      p3:=plz[2+i*2];
      if i=0 then p1:=plz.first else begin
        p:=plz[i*2];//p3-2
        if not pl0.sec(p2,p, 0, p1) then p1:=p;
      end;
      if i=n-1 then p4:=plz.last else begin
        p:=plz[3+i*2];//p2+2
        if not pl0.sec(p3,p, 0, p4) then p4:=p;
      end;

      _add_volna_period(pl, p1,p2,p3,p4);

    end;//for i
  finally
    plz.free;
  end;
end;
*)
(*
procedure _make_zigzag(pl0,pl: tpl);
var
  i: tint;
  pll,plr: tpl;//левая и правая параллельные линии
  n: tint;//число периодов
  dl,dr: tnum;//периоды
  xl,xr: tnum;
begin
//  pl.AddFrom(pl0);//DEBUG

  pll:=tpl.new;
  plr:=tpl.new;
  try
    pl0.LeftLine(pll, gcx_volna.width/2);
    pl0.LeftLine(plr, -gcx_volna.width/2);
    try n:=Round(pl0.Lena.Last/gcx_volna.period); except n:=1; end;
    if n<=0 then n:=1;//!
    dl:=pll.Lena.Last/n;
    dr:=plr.Lena.Last/n;

    //угловые точки:
    pl.add(pl0.first);
    for i:=0 to n-1 do begin
      xl:=i*dl+dl/4;
      xr:=i*dr+3*dr/4;
      pl.add( pll.xp(xl) );
      pl.add( plr.xp(xr) );
    end;//for i
    pl.add(pl0.last);

  finally
    pll.free;
    plr.free;
  end;
end;
*)

//pl0 -> pab,pae - через ЧЕТВЕРТЬ периода:
function _make_hl(pl0: tpl; pab,pael,paer: tpa): boolean;
var
  n: tint;//число периодов
  d: tnum;//период
begin
  Result:=true;

  try
    pll.clear;
    plr.clear;    

    pl0.LeftLine(pll, gcx_volna.width/2);
    pl0.LeftLine(plr, -gcx_volna.width/2);
    try n:=Round(pl0.Lena.Last/gcx_volna.period); except n:=1; end;
    if n<=0 then n:=1;//!
    d:=pl0.Lena.Last/n;

    //параметры:
    gcx_hl_load;
    with gcx_hl do begin
      step:=d/4;//четверть периода!
      dxmin:=step/4;
      dxmax:=step*4;
    end;

    hldp_init;
    //вычисление pab,pael (опорная линия - левая!):
    pl0.reverse;
    pll.reverse;
    Result := Result and hldp_connect(pl0,pll, pab,pael, 0);
    pl0.reverse;
    pll.reverse;
    pael.reverse;
    pab.clear;//!
    //вычисление pab,paer (опорная линия - левая!):
    Result := Result and hldp_connect(pl0,plr, pab,paer, 0);

  except
    Result := false;
  end;
(*
  //период - по 4 точки:
  if (pab.count-1) mod 4 <> 0 then begin
//    Result:=false;
    Tellf('volna.pas: недопустимое значение pab.count=%d',[pab.count]);
  end;
*)
end;

procedure _make_zigzag_from_hl(pl0,pl: tpl; pab,pael,paer: tpa);
var i: tint;
begin
  //первая точка:
  pl.add(pl0.first);

  //угловые точки:
  if pab.count>0 then for i:=0 to pab.count-1 do begin
    case i mod 4 of
      0: continue;
      1: if i<pael.Count then pl.add( pael[i] );
      2: continue;
      3: if i<paer.Count then pl.add( paer[i] );
    end;//case
  end;//for i

  //последняя точка:
  pl.add(pl0.last);
end;


//------------------------------------------------------------

procedure _add_curve_to_pl(pl: tpl; p2,p3,p4: tnum2);
begin
  //простейший вариант:
  pl.add(p2);
  pl.add(p3);
  pl.add(p4);
end;

//hl -> volna
procedure _make_volna_from_hl(pl0,pl: tpl; pab,pael,paer: tpa);
var i: tint; up2down: boolean;
begin
  if pab.count<3 then exit;//!
  up2down:=false;//не было ни одной кривой, верхняя точка текущая

  //первая точка (moveto):
  pl.add(pl0.first);

  //первая кривая:
  _add_curve_to_pl(pl, pael.first, pael.first, pael[1]);

  //промежуточные кривые (i=3,5,7...):
  if pab.count>=4 then for i:=3 to pab.count-1 do begin
    if (i mod 2)<>1 then continue;//=>i нечётное>=3
    if i=pab.count-1 then break;//!
    up2down := (i mod 4)=3;
    if up2down and (i<paer.Count) then _add_curve_to_pl(pl, pael[i-1], paer[i-1], paer[i])//сверху вниз
    else if (i<pael.Count) then _add_curve_to_pl(pl, paer[i-1], pael[i-1], pael[i])//снизу вверх

  end;//for i

  //последняя кривая:
  if up2down then _add_curve_to_pl(pl, paer[paer.count-2], paer[paer.count-2], pl0.last)
  else _add_curve_to_pl(pl, pael[pael.count-2], pael[pael.count-2], pl0.last);

end;


//////////////////////////////////////////////////////////////


//pl0 -> участки -> outlist:
procedure _volna_add_pl_to_outlist(pl0: tpl; outlist: tclasslist; mode: tint);
var pl: tpl; pab,pael,paer: tpa;
begin
  pl:=tpl.new;
  pab:=tpa.new;
  pael:=tpa.new;
  paer:=tpa.new;
  try
    case mode of
      0: pl.addfrom(pl0);
      1: begin
        //_make_zigzag(pl0,pl);
        if _make_hl(pl0,pab,pael,paer) then
          _make_zigzag_from_hl(pl0,pl,pab,pael,paer);
      end;
      2: begin
        //_make_zigzag(pl0,pl); _make_volna_from_zigzag(pl0,pl);
        if _make_hl(pl0,pab,pael,paer) then
          _make_volna_from_hl(pl0,pl,pab,pael,paer);
      end;
    end;//case
  finally
    outlist.add(pl);
    pab.free;
    pael.free;
    paer.free;
  end;
end;


procedure volna_execute(pl0: tpl; outlist: tclasslist; inds: tinta);
var
  i,ind: tint;
  dash: tdash;//llibx.pas
begin
  if pl0.Lena.Last<=0 then exit;//!

  if gcx_volna.dash_array.Count=0 then begin

    //нет участков:
    inds.add(0);
    _volna_add_pl_to_outlist(pl0, outlist, gcx_volna.dash_modes[0]);

  end else begin

    //участки:
    dash:=tdash.Create(gcx_volna.dash_array,gcx_volna.dash_offset);
    try
      dash.Update(pl0.Lena.last);
      if dash.Count>0 then for i:=0 to dash.Count-1 do begin
        if RunForm.Cancelled then break;
        ind:=dash.DashIndex[i];
        if dash.steps[ind]>0 then begin
          inds.add(ind);
          _volna_add_pl_to_outlist(dash.Segment[pl0,i], outlist, gcx_volna.dash_modes[ind]);
        end;
      end;//for i
    finally
      dash.free;
    end;

  end;

  if RunForm.Cancelled then outlist.Clear;
end;



initialization
  pll:=tpl.new;
  plr:=tpl.new;
finalization
  pll.free;
  plr.free;

end.
