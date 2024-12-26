//Функционал, динам-ое програм-ие:
unit hl_dp;

{$MODE Delphi}

 interface

uses SysUtils, Dialogs, llib, llibx;

//Clear hldp_div_pb, hldp_div_pe:
procedure hldp_init;

//lbase - опорная линия (штрихи вправо),
//lclip - линия концов (не область!)
//пропускаем первый штрих, если в pab уже есть точки:
function hldp_connect(lbase,lclip: tpl; pab,pae: tpa; nsteps: integer): boolean;



var
  //соответствующие точки деления на pab, pae (initialization/finalization):
  //не отсортированные:
  hldp_div_pb, hldp_div_pe: tpa;


//-------------------------------------------------
implementation
//-------------------------------------------------

uses
  Forms,
  Wcmn, vlib, hline, gcx, RUNLINE2,
  Arrayx, List, nums, DLINE;

//-------------------------------------------------


type
  pcell = ^tcell;
  tcell = record
    i: tint;  //позиция точки
    j: tint;  //индекс пред.ячейки
    f: tnum;  //значение функционала
  end;

  tdptab = class
  private
    Fnmin,Fnmax: tint;
    FTab: TClassList;
    FPl0, FPl1: tpl;//Uniform!
    FAOrt: tnuma;//ортогонали к FPl0
    Fkd,Fkcos,Fkcos2: tnum;//коэффициенты при (d1+d2) и cos(da) в функционале
    function NewRow: tarray; //добавляет в FTab
    function LastRow: tarray;

    function calc_new_position(i0,i1: tint; row0: tarray; var cell: tcell): boolean;
    function tab_begin: boolean;
    //i0=1..n0-2 (без первой и последней точек!):
    function next_point(i0: tint; maxdist:double; var imin:tint): boolean;
    function tab_end(pae_rev: tpa): boolean;

  public
    constructor Create;
    destructor Destroy; override;

    function ExecuteOrto(apl0,apl1: tpl; pab,pae: tpa; nsteps: integer): boolean;//if apl0.count=2
    function Execute(apl0,apl1: tpl; pab,pae: tpa; nsteps: integer): boolean;
  end;

//-------------------------------------------------

{ Functions: }


procedure hldp_init;
begin
  hldp_div_pb.Clear;
  hldp_div_pe.Clear;
end;

function hldp_connect0(lbase,lclip: tpl; pab,pae: tpa; nsteps: integer): boolean;
var dptab: tdptab;
begin
  RunForm.Start2(gcx_obj.scode);

  dptab:=tdptab.Create;
  try
    Result:=dptab.Execute(lbase,lclip, pab,pae, nsteps);
    if RunForm.Cancelled then begin pab.Clear; pae.Clear; end;
  finally
    dptab.free;
    RunForm.Finish2;
  end;
end;

function hldp_connect(lbase,lclip: tpl; pab,pae: tpa; nsteps: integer): boolean;
var i: integer; segsb,segse: tclasslist;
begin
  Result:=false;
  if hldp_div_pb.count<>hldp_div_pe.count then exit;//error

  if hldp_div_pb.count>0 then begin

    segsb:=dl_execute(lbase,hldp_div_pb, 0,1*gcx_DmPerMm, false);
    segse:=dl_execute(lclip,hldp_div_pe, 0,1*gcx_DmPerMm, false);

    try
      if segsb.count>0 then for i:=0 to segsb.count-1 do begin
        tobject(lbase):=segsb[i];
        tobject(lclip):=segse[i];
        Result:=hldp_connect0(lbase,lclip, pab,pae, nsteps);
      end;
    finally
      segsb.free;
      segse.free;
    end;

  end else begin

    Result:=hldp_connect0(lbase,lclip, pab,pae, nsteps);

  end;
end;

//-------------------------------------------------


{ tdptab: }

constructor tdptab.Create;
begin
  FTab:=TClassList.Create(256);
end;

destructor tdptab.Destroy;
begin
  FTab.Free;
end;

function tdptab.NewRow: tarray;
begin
  Result := TArray.Create(sizeof(tcell), 1024);
  Ftab.add(Result);
end;

function tdptab.LastRow: tarray;
begin
  TObject(Result) := FTab[FTab.Count-1];
end;


///////////////////////////////////////////////////////////////////////////////

//дочерняя линия - отрезок из 2-х точек (apl0.count=2):
function tdptab.ExecuteOrto(apl0,apl1: tpl; pab,pae: tpa; nsteps: integer): boolean;//if apl0.count=2
var
  n0: integer;//кол-во точек
  i: integer; t0: double; v0,v0orto,a,b,p: tnum2;
  lapl1: tnuma; apl1x: tpl;
begin
  //Result:=TRUE;//default
  Result:=FALSE;//default

  if apl0.Count<>2 then EXIT;//!!!
  if apl0.Length<1 then EXIT;//!!! - координаты карты!
  if apl1.Count<2 then EXIT;//!!!

  //кол-во точек:
  if nsteps>0
  then n0:=nsteps+1
  else n0:=hl_step2n(gcx_hl.step, apl0.Lena.last)+1;
  if n0<2 then EXIT;//!!!

  Result:=TRUE;//!!!-------------------------------------!

  //перпендикулярные отрезки:
  v0:=v_sub(apl0[1],apl0[0]);
  v0orto:=v_rot(v0, -90);

  //пересечение:
  apl1x:=tpl.New;
  lapl1:=tnuma.New;
  try

    //apl1x - расширение apl1:
    apl1x.Add(apl0[0]);
    apl1x.AddFrom(apl1);
    apl1x.Add(apl0[1]);

    apl1x.GetLens(lapl1);

    if n0>1 then for i:=0 to n0 do begin//0..n0 - от края до края!

      t0:=i/n0;//0..1
      a:=v_lt(apl0[0],apl0[1],t0);//нач точка штриха
      b:=v_add(a,v0orto);//a,b - линия штриха

      //пересечение:
      if apl1x.sec(a,b, 1{orient<>0}, p) then begin
        pab.Add(a);
        pae.Add(p);
      end;

    end;//for i
  finally
    lapl1.Free;
    apl1x.Free;
  end;
end;

function tdptab.Execute(apl0,apl1: tpl; pab,pae: tpa; nsteps: integer): boolean;
var
  n0,n1,i, imin: tint;//кол-во точек
  step1: tnum;//шаг на apl1
  maxDist, dist, dd:double;
  notempty: boolean;
  pae_rev: tpa;
  //dt_beg:TDateTime;
begin
  dd:=1/cos(20*Pi/180);
  //dd:=2;
  //dt_beg:=Now();
  Result:=true;

  if apl0.Count=2{отрезок} then begin
    Result:=ExecuteOrto(apl0,apl1, pab,pae, nsteps);
    EXIT;//!!!
  end;
  maxDist:=0;
  for i:=0 to apl0.Count-1 do begin
     dist:=Apl1.DistFromPoint(apl0[i]);
     if dist>maxdist then Maxdist:=dist;
  end;
  maxDist:=dd*maxDist;

  //hl_step2n - кол-во интервалов; n0,n1 - кол-во точек:
  //n0 нечётно, если gcx_hl.hatch2_code>=0
  if nsteps>0 then begin
    n0:=nsteps+1;
    n1:=n0;
  end else begin
    n0:=hl_step2n(gcx_hl.step, apl0.Lena.last)+1;
    n1:=hl_step2n(gcx_hl.step, apl1.Lena.last)+1;
  end;
  if n1<4 then n1:=4;
  n1:=n1*gcx_hl.dp_n;//учащение!
  if n1<3*n0 then n1:=3*n0; //короткая линия концов!
  step1:=apl1.Lena.last/(n1-1);

  //xmin,xmax:
  Fnmin:=Round(gcx_hl.dxmin/step1);
  if 2*n0*Fnmin>n1 then Fnmin:=Round(n1/(2*n0));//уменьшение Fnmin
  if Fnmin<1 then Fnmin:=1;
  Fnmax:=Round(gcx_hl.dxmax/step1);
  if n0*Fnmax<n1*2 then Fnmax:=Round(n1*2/n0);//увеличение Fnmax
  if Fnmax<=Fnmin then Fnmax:=Fnmin+1;

  Fkd:=gcx_hl.hldp_fkd;
  Fkcos:=gcx_hl.hldp_fkcos;
  Fkcos2:=gcx_hl.hldp_fkcos2;

  notempty:=pab.count>0;

  if n0<=1 then exit;
  if n0=2 then begin
      pab.add(apl0.first);
      pae.add(apl1.first);
      pab.add(apl0.last);
      pae.add(apl1.last);
      exit;
  end;

  //n0>2:
  Fpl0 := apl0.NewUniform(n0);
  Fpl1 := apl1.NewUniform(n1);
  FAOrt:=tnuma.new;
  pae_rev:=tpa.new;//reverse
  try
    Fpl0.aort(FAOrt); //FAOrt (0..n0-1)

    //расчет таблицы:
    imin:=0;
    Result:=tab_begin;
    //i0=1..n0-2 (без первой и последней точек!):
    if n0>2 then for i:=1 to n0-2 do begin
      if i mod 100 = 1 then begin
        RunForm.Go2(i/(n0-2));
//       if RunForm.Cancelled then Result:=false;//<-Application.ProcessMessages
        if RunForm.Cancelled then break;//<-Application.ProcessMessages
      end;
      if not Result then break;
     // maxdist:=dd*Apl1.DistFromPoint(Fpl0[i]);
      Result:=next_point(i, maxdist, imin);

    end;
    if Result then Result:=tab_end(pae_rev);
    if Result then begin

      pae_rev.reverse;//разворот

      //пропускаем первый штрих, если в pab уже есть точки:
      if notempty then begin
        Fpl0.delete(0);
        pae_rev.delete(0);
        //dec(n0);
      end;

      //добавим в pab,pae:
      if not RunForm.Cancelled then begin
        pab.addfrom( Fpl0 );
        pae.addfrom( pae_rev );
      end;
       //dist:=(Now-dt_beg)*86400;
       //showMessage(floatToStr(dist));
    end;//if Result

  finally
    Fpl0.free;
    Fpl1.free;
    FAOrt.free;
    pae_rev.free;
  end;
end;

//--------------------------- Execute: ---------------------------------------

function tdptab.calc_new_position(i0,i1: tint; row0: tarray; var cell: tcell): boolean;
var
  irow: tint;
  da,d,f,t,step1: tnum;
  a,dax: tnum;
  p0,p1,px: tnum2;
  cell0: tcell;
begin
  Result:=false;
  step1:=Fpl1.Lena.last/Fpl0.count;
  p0:=Fpl0[i0];
  p1:=Fpl1[i1];//новая точка
  a := v_fi( v_sub(p1,p0) );
  da := angle_correct( a - Faort[i0] );
  //if abs(da)>90 then da:=90;

  //первая точка (левая):
  if (row0=nil) then begin
      Result:=true;
      cell.f:=Fkcos*cos(rad(da));
      cell.i:=0;
      cell.j:=-1;//нет ссылки влево
      exit;
  end;

  //цикл по точкам, расположенным левее p1 (cell0.i<i1):
  cell.f:=-Fkcos;
  if row0.count>0 then for irow:=0 to row0.count-1 do begin
    row0.get(irow, cell0);
    if cell0.i+Fnmax<i1 then continue;//недопустимое положение
    if cell0.i+Fnmin>i1 then break;//недопустимое положение

    //функционал:
    px:=Fpl1[cell0.i];//предыдущая точка
    d := v_dist_pl(p1, p0,px, t) + v_dist_pl(px, p0,p1, t);
    dax := angle_correct( v_fi( v_sub(px,p0) ) - a );
    f := cell0.f + Fkd*d/step1 + Fkcos*cos(rad(da)) + Fkcos2*cos(rad(dax));

    //запомним максимум:
    if f>cell.f then begin
      Result:=true;
      cell.f:=f;
      cell.i:=i1;
      cell.j:=irow;
    end;
  end;//for irow
end;

function tdptab.tab_begin: boolean;
var row1: tarray; cell: tcell;
begin
  row1:=newrow;
  if calc_new_position(0,0, nil, cell) then row1.Add(cell);
  Result:=row1.count=1;
end;

//i0=1..n0-2 (без первой и последней точек!):
function tdptab.next_point(i0: tint; maxdist:double; var imin:tint): boolean;
var
  iter,i1,{n0,}n1,k0, nmin, nmax: tint;
  cell: tcell;
  row0,row1: tarray;
  p0:tnum2;
  pnt1:^tnum2;
  dist, max2:double;
  label
    lb1;
function dist_max(var p1,p2: tnum2):double;
begin
  Result:= Max(abs(p1.x-p2.x), abs(p1.y-p2.y));
end;

begin
  //n0:=Fpl0.count;
  iter:=0;
  n1:=Fpl1.count;
  k0:=n1-Fpl0.count+i0;          //k0:=n0-(i0+1);//кол-во оставшихся точек
  row0:=lastrow;
  row1:=newrow;
  p0:=Fpl0[i0];
  nmin:=0;
  nmax:=0;
  max2:= 1.5*maxDist;
  //цикл новой точки:
  lb1:
  pnt1:=Fpl1.GetP(imin);
  if n1>0 then for i1:=imin to n1-1 do begin
    //p1:=Fpl1[i1];
    dist:=Max(abs(p0.x-pnt1^.x), abs(p0.y-pnt1^.y));
    if dist<maxDist then begin   //alexs
      if nmin=0 then nmin:=i1;
      if i1>nmax then nmax:=i1;
      if {n1-(i1+1)<k0 }  i1>k0 then begin
         break;//место для след-их точек!
      end;
      if calc_new_position(i0,i1, row0, cell) then begin
        row1.Add(cell);
      end;
    end else begin
       if (nmax>0) and (i1-nMax >10) and (dist>max2) then break;
    end;
    pnt1:=pointer(Pchar(pnt1)+sizeof(tnum2));
  end;//for i1
  if row1.count=0 then begin
     maxDist:=2*maxDist;
     max2:=2*max2;
     imin:=0;
     nmin:=0;
     nmax:=0;
     inc(iter);
     if iter<4 then
        goto lb1;
  end;
  imin:=nmin;
  Result:=row1.count>0;

  //if row1.count=0 then Tellf('tdptab.next_point:\nПустая строка таблицы для точки i0=%d',[i0]);
end;

function tdptab.tab_end(pae_rev: tpa): boolean;
var
  n0,n1,i,j: tint;
  row0,row1,row: tarray;
  p0,p1:tnum2;
  a, da:double;
  cell: tcell;
begin
  n0:=Fpl0.count;
  n1:=Fpl1.count;
  row0:=lastrow;
  row1:=newrow;
  if calc_new_position(n0-1,n1-1, row0, cell) then row1.Add(cell);
  Result:=row1.count=1;
  if not Result then begin
    p0:=Fpl0[n0-1];
    p1:=Fpl1[n1-1];
    a := v_fi( v_sub(p1,p0) );
    da := angle_correct( a - Faort[n0-1] );
    cell.f:=Fkcos*cos(rad(da));
    cell.i:=n1-1;
    cell.j:=0{row0.Count-1};
    row1.Add(cell);
    Result:=true;
  end;
 if FTab.count<>n0 then begin
    Result:=false;
    //Tellf('tdptab.tab_end:\nТочек %d, а строк в таблице %d',[n0, FTab.count]);
  end;

  if not Result then exit;

  //сбор точек (в обратном порядке) (FTab.count=n0):
  j:=0;//в последней строке одна ячейка
  if FTab.count>0 then for i:=FTab.count-1 downto 0 do begin
    TObject(row):=FTab[i];
    row.get(j, cell);
    j:=cell.j;//след.точка(ячейка)
    pae_rev.add( Fpl1[cell.i] );
  end;
end;

//-------------------------------------------------------------------------


initialization
  hldp_div_pb:=tpa.new;
  hldp_div_pe:=tpa.new;
finalization
  hldp_div_pb.free;
  hldp_div_pe.free;


end.
