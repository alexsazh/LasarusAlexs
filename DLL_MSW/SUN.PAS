unit SUN;

{$MODE Delphi}

 interface

uses List, llib, llibx;


//pab,pae - пустые
//cloc - S,L,A - лок. вершины
//div_list - of tmso
function sun_execute(lbase,aclip: tpl; pab,pae: tpa; cloc: char; div_list: tclasslist): boolean;



implementation

uses Wcmn, gcx, nums, vlib, hline, hl_dp, Msfile;


//добавляет(!) в pab-pae scount+1(!) отрезков: пересечения pc-лучей с линиями lb,le;
//lb m.b. nil(!)
procedure sun_add_lines(lb,le: tpl; pab,pae: tpa; pc: tnum2; a0,da: tnum; suncount: tint);
var i: integer; a: tnum; px,p: tnum2;
begin
  for i:=0 to suncount do begin //scount+1 (!) лучей
    a:=a0+i*da/suncount;
    px:=v_add(pc, v_ra(100,a));
    p:=pc;
    if lb<>nil then if not lb.sec(pc,px, 1,p) then p:=pc;
    pab.add(p);
    if not le.sec(pc,px, 1,p) then p:=pc;
    pae.add(p);
  end;
end;

//формирование векторов деления (hldp_div_pb, hldp_div_pe: tpa)(hl_dp.pas):
procedure _make_hldp_div(lbase,lclip: tpl; div_list: tclasslist);
var i: integer; mso: tmsobj; pl: tpl; t,x: tnum;
begin
  hldp_init;

  pl:=tpl.new;
  try
    if (div_list<>nil) and (div_list.Count>0) then for i:=0 to div_list.Count-1 do begin

      tobject(mso):=div_list[i];
      mso.PolyFromLines(pl);//pl.clear;
      if pl.Count<>2 then continue;//!!!

      //направление:
      if v_dist(lbase.prj(pl[0],false), pl[0])>v_dist(lbase.prj(pl[1],false), pl[1]) then pl.Reverse;

      if lclip.lsec2(pl[0],pl[1], 1, t,x, lclip.box,lclip.lena) then begin
        hldp_div_pb.add( pl[0] );
        hldp_div_pe.add( lclip.xp(x) );
      end;

    end;//for i
  finally
    pl.Free;
  end;
end;

//pab,pae - пустые
function sun_execute(lbase,aclip: tpl; pab,pae: tpa; cloc: char; div_list: tclasslist): boolean;
var
  done, shortdone: boolean;
  suncount: tint;
  a0,da: tnum; //a0-угол оси; da-раствор
  pc: tnum2; //pc-центр
  lb,le: tpl; //from lbase,aclip
  x0,x1,x2,x3: tnum; //концы краевых лучей на le
  lclip: tpl;
  pab2,pae2: tpa;
  pab1,pae1: tpa; //DEBUG
  v,p,q0,q1: tnum2; //проекции концов
  zero: tnum;
  d0,d1: tnum; //DEBUG
begin
  Result:=true;
  done:=false;
  shortdone:=false;
  do_short_beginning:=false;

  lb:=lbase;
  le:=aclip;

  try

    //точечная вершина:
    if not done and (cloc='S') then begin
      do_short_beginning:=true;
      pc:=lb.first;
      a0:=10;
      da:=360;
      suncount:=gcx_hl.count;
      sun_add_lines(lb,le, pab,pae, pc,a0,da,suncount);
      done:=true;
    end;//if cloc='S'

    //площадная вершина:
    if not done and (cloc='A') then begin

      _make_hldp_div(lb,le, div_list);//=>hldp_init

      //q0,q1:
      if hldp_div_pb.Count>0 then begin
        q0:=hldp_div_pb[0];
        q1:=hldp_div_pe[0];
        lb.newstart(q0);
        //первый вектор деления уходит в согласование начал линий:
        hldp_div_pb.DeleteFirst;
        hldp_div_pe.DeleteFirst;
      end else begin
        v:=v_ra(100, lb.biss(0,-90));//ортог.вектор
        q0:=lb.first;
        q1:=v_add(q0, v);
      end;

      if le.sec(q0,q1, 1, p) then begin
        le.newstart(p);//согласование начальных точек
        hldp_connect(lb,le, pab,pae, 0);
      end;
      done:=true;
    end;//if cloc='A'

    //линейная вершина:
    if not done and (cloc='L') then begin

      //лучи:
      pab1:=tpa.new;
      pae1:=tpa.new;
      pab2:=tpa.new;
      pae2:=tpa.new;

      try

        //дамбы: концы линии на границе площади:
        //проекции концов:
        q0 := le.prj(lb.first, true);
        q1 := le.prj(lb.last, true);
        d0 := v_dist(q0, lb.first);
        d1 := v_dist(q1, lb.last);
        zero:=gcx_hl.zero;
        if (d0<zero) and (d1<zero) then begin

          _make_hldp_div(lb,le, div_list);//=>hldp_init

          Result:=hl_execute(lb,le, pab1,pae1, nil);
          lb.Reverse; //!!!
          if Result then Result:=hl_execute(lb,le, pab2,pae2, div_list);
          //добавим в выходные массивы:
          pab.addfrom(pab1); pae.addfrom(pae1);
          pab.addfrom(pab2); pae.addfrom(pae2);
          //прекратим обработку линии:
          shortdone:=true;//!
          done:=true;
        end;//if zero

      //ямы и бугры: линия внутри площади:
      if not done then begin

        do_short_beginning:=true;

        da:=90;
        suncount:=Round(gcx_hl.count/4); //кол-во промежутков!
        if suncount mod 2 <> 0 then inc(suncount); //=>suncount чётный

        //лучи-1:
        pc:=lb.first;
        a0:=v_fi(lb.V[0])+180-da/2;
        sun_add_lines(nil,le, pab1,pae1, pc,a0,da,suncount);

        //лучи-2 (pab2,pae2):
        pc:=lb.last;
        a0:=v_fi(lb.V[lb.count-2])-da/2;
        sun_add_lines(nil,le, pab2,pae2, pc,a0,da,suncount);

        //концы крайних лучей:
        x0:=le.xofp(pae1.First);
        x1:=le.xofp(pae1.Last);
        x2:=le.xofp(pae2.First);
        x3:=le.xofp(pae2.Last);

        //добавим pab1->pab, pae1->pae (=> pab.count>0):
        pab.addfrom(pab1); pae.addfrom(pae1);

        //штрихи-1:
        lclip:=le.CreateSegment( x1,x2, false);
        try
          _make_hldp_div(lb,lclip, div_list);//=>hldp_init
          Result:=hldp_connect(lb,lclip, pab,pae, 0);//add points
          pab.deletelast; pae.deletelast;
        finally
          lclip.free;
        end;

        //добавим pab2->pab, pae2->pae:
        pab.addfrom(pab2); pae.addfrom(pae2);

        //штрихи-2:
        lclip:=le.CreateSegment( x3,x0, false);
        try
          lb.reverse; //!!!
          _make_hldp_div(lb,lclip, div_list);//=>hldp_init
          Result:=hldp_connect(lb,lclip, pab,pae, 0);//add points
          pab.deletelast; pae.deletelast;
        finally
          lclip.free;
        end;

        done:=true;
      end;//if not done

      finally
        pab1.free;
        pae1.free;
        pab2.free;
        pae2.free;
      end;
    end;//if cloc='L'

  finally
  end;

  //укорачивание:
  //(gcx_hl.parent_code>=0): отличие ямы от бугра
  //отрезки рисовались от ребенка к родителю
  if not shortdone then begin
    if gcx_hl.parent_code>=0 then hl_short(pab,pae, 1)
    else hl_short(pab,pae, 0);
  end;

  if not done then Result:=false;
end;



end.
