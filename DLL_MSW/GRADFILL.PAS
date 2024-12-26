unit GRADFILL;

{$MODE Delphi}

 interface

uses Arrayx, List, llibx, nums, vlib, Msfile, Color;


{ public: }

type

  //ColorManager:
  tGfColor = class
  private
    Fp: tpl;//точки цвета - LoadColorPoints
    Ft: tnuma;//точки цвета (Ft.first:=0, Ft.last:=1) - LoadColorLine
    Fc: tArray;//of tcmykcolor: Fc[i]=Color(Ft[i])
    function getcolor0(t: tnum; c0,c1: tcmykcolor): tcmykcolor;//0<=t<=1
    procedure LoadGcxColors;//default!
  public
    constructor Create;
    destructor Destroy; override;

    //загрузка точек цвета:
    procedure LoadColorPoints(mso_list: tclasslist);//Load-1 (=>Fp,Fc)
    procedure LoadColorLine(pl: tpl);//Load-2 (Fp,Fc => Ft => GetColor)

    //использование цвета:
    function GetColor(t: tnum): tcmykcolor;
  end;

var
  GfColor: tGfColor;


//радиус (pl.count=2):
procedure gf_AddColorAreasOnRing(MSG: TMSGroup; pl: tpl; aLev: tint);

//линия в области:
//line - направляющая цвета в области area
procedure gf_AddColorAreasByLine(MSG: TMSGroup; area,line: tpl; aLev,dim: tint);

//3 линии и область:
procedure gf_AddColorAreasBy3Lines(MSG: TMSGroup; pl1,pl2,pl3: tpl; aLev,dim: tint);

//опорная линия и дочерний ортог. отрезок (|vort|>0):
procedure gf_AddColorAreasByWidth(MSG: TMSGroup; line0,lort: tpl; aLev,dim: tint);


{ private: }

//x - вдоль pl0,pl1, y - поперёк pl0,pl1:
//система x-направляющих (tpl) вдоль pl0,pl1, без pl0,pl1:
//if pl0.count=pl1.count - то от вершины к вершине, иначе - "ступени"
function gf_CreateDirectLinesByTwoLines(pl0,pl1: tpl; ystep: tnum): tclasslist;

//система y-областей (tpl) поперёк pl0,pl1:
function gf_CreateColorAreasByTwoLines(pl0,pl1: tpl; xstep,ystep: tnum; pl1_right: boolean): tclasslist;
//система x-областей (tpl) вдоль pl0,pl1:
function gf_CreateColorAreasOnPolosa(pl0,pl1: tpl; step: tnum; pl1_right: boolean): tclasslist;


implementation

uses Wcmn, CMN, STEPS, gcx;


{ TGfColor: }

function TGfColor.getcolor0(t: tnum; c0,c1: tcmykcolor): tcmykcolor;//0<=t<=1
begin
  Result:=Get_CMYK_t(t, c0,c1);
(*
  Result.c := (1-t)*c0.c + t*c1.c;
  Result.m := (1-t)*c0.m + t*c1.m;
  Result.y := (1-t)*c0.y + t*c1.y;
  Result.k := (1-t)*c0.k + t*c1.k;
*)
end;


constructor TGfColor.Create;
begin
  inherited Create;
  Fp:=tpl.New;
  Ft:=tnuma.New;
  Fc:=tArray.Create(sizeof(tcmykcolor), 8);
end;

destructor TGfColor.Destroy;
begin
  Fp.Free;
  Ft.Free;
  Fc.Free;
  inherited Destroy;
end;

//Load Color:

procedure TGfColor.LoadGcxColors;
begin
  Fp.Clear; Ft.Clear; Fc.Clear;

  Ft.Add(0); Fc.Add(gcx_gf.color1);
  Ft.Add(1); Fc.Add(gcx_gf.color2);
end;


procedure TGfColor.LoadColorPoints(mso_list: tclasslist);//Load-1 (Fp,Fc)
var i: integer; cmyk: tcmykcolor; mso: tmsobj; pl: tpl;
begin
  Fp.Clear; Fc.Clear; Ft.Clear;

  pl:=tpl.New;
  try
    if mso_list.Count>0 then for i:=0 to mso_list.Count-1 do begin
      tobject(mso):=mso_list[i];
      if mso.Get_H_cmyk_S(cmyk,true) then begin//S830
        mso.PolyFromLines(pl);
        Fp.Add(pl.First);
        Fc.Add(cmyk);
      end;
    end;
  finally
    pl.free;
  end;
end;

procedure TGfColor.LoadColorLine(pl: tpl);//Load-2 (Fp,Fc => Ft => GetColor)
var Result: boolean; i: tint; len,x,t: tnum; cmyk: tcmykcolor;
begin
  Ft.Clear;
  len:=pl.Lena.Last;
  Result := (Fc.Count>0) and (Fc.Count=Fp.Count) and (len>v_zero) ;

  if Result then begin

    for i:=0 to Fp.Count-1 do begin
      x:=pl.xofp(Fp[i]);
      try Ft[i]:=x/len; except Ft[i]:=0; end;
    end;

    //сортировка и пародолжение до концов линии:
    Ft.Sort(Fc);
    if Ft.First>0 then begin t:=0; Ft.Insert(0,t); Fc.Get(0,cmyk); Fc.Insert(0,cmyk); end;
    if Ft.Last<1  then begin t:=1; Ft.Add(t); Fc.Get(Fc.count-1,cmyk); Fc.Add(cmyk); end;

  end else begin

    LoadGcxColors;//default!

  end;

end;


//Use Color:

function TGfColor.GetColor(t: tnum): tcmykcolor;
var c0,c1: tcmykcolor; tx: tnum; ind: tint;
begin
  Ft.position(t, tx, ind);
  Fc.Get(ind,c0);
  Fc.Get(ind+1,c1);
  Result:=getcolor0(tx, c0,c1);
end;



{ private: }


//без 1-ой и последней линии:
function gf_CreateDirectLinesByTwoLines(pl0,pl1: tpl; ystep: tnum): tclasslist;
var area,plx: tpl; nl,il,np,ip: tint;
begin
  if pl0.Count=pl1.Count then begin

    //одинаковое кол-во точек:
    Result:=tclasslist.New;
    nl:=Round( v_dist(pl0.Last, pl1.Last)/ystep )-1;//кол-во промеж-ых линий
    np:=pl0.Count;
    if (nl>0) and (np>0) then for il:=1 to nl do begin
      plx:=tpl.New;
      Result.Add(plx);
      //точки:
      for ip:=0 to np-1 do plx.Add( v_lt(pl0[ip], pl1[ip], il/(nl+1)) );
    end;//for il

  end else begin

    //разное кол-во точек:
    area:=tpl.new;
    try
      area.Add(pl0.first);
      area.AddFrom(pl1);
      pl0.Reverse;
      area.AddFrom(pl0);
      pl0.Reverse;
      Result:=st_execute(area,pl0,pl1, 0, ystep, nil,false);//без 1-ой и последней линии
    finally
      area.free;
    end;

  end;  
end;



  //создание линии: xLines,t -> yline (0<=t<=1):
  procedure _GetColorLine(xLines: tclasslist; t: tnum; yline: tpl);
  var iy: tint; xline: tpl; p: tnum2;
  begin
    yline.clear;
    if xLines.Count>0 then for iy:=0 to xLines.Count-1 do begin
      TObject(xline):=xLines[iy];
      p:=xline.xp(t*xline.Lena.Last);
      yline.add(p);
    end;
  end;


//шаг по nsteps:
function _get_step(gcx_step: tnum; len: tnum; var n: tint): tnum;
begin
  n:=gcx_gf.colors_count;
  if n<=0 then n:=cmn_step2n(gcx_step,len,false);//кол-во промежутков >0
  Result:=len/n;//новый шаг
end;


function gf_CreateColorAreasByTwoLines(pl0,pl1: tpl; xstep,ystep: tnum; pl1_right: boolean): tclasslist;
var
  n,ix: tint;
  xLines: tclasslist;
  carea,yline1,yline2,plx: tpl;
begin
  Result:=tclasslist.new;
  yline1:=tpl.new;//временная поперечная y-линия
  yline2:=tpl.new;//временная поперечная y-линия
  xLines:=gf_CreateDirectLinesByTwoLines(pl0,pl1, ystep);
  try
//    xstep:=_get_step(xstep, pl0.length, n);//=>n
    _get_step(xstep, pl0.length, n);//=>n
(*
    n:=gcx_gf.colors_count;
    if n<=0 then n:=cmn_step2n(xstep,pl0.length,false);//кол-во промежутков
*)
    //создание областей:
    if n>0 then for ix:=0 to n-1 do begin
      carea:=tpl.new;
      try
        //1-ая y-линия:
        _GetColorLine(xLines, (ix)/n, yline1);
        carea.addfrom(yline1);

        //1-ая x-линия:
        plx:=pl1.CreateSegment( pl1.lena.Last*(ix)/n, pl1.lena.Last*(ix+1)/n, false);
        carea.addfrom(plx);

        //2-ая y-линия:
        _GetColorLine(xLines, (ix+1)/n, yline2);
        yline2.reverse; carea.addfrom(yline2);

        //2-ая x-линия:
        plx:=pl0.CreateSegment( pl0.lena.Last*(ix)/n, pl0.lena.Last*(ix+1)/n, false);
        plx.reverse; carea.addfrom(plx);

        //замыкание:
        carea.add(carea.first);
      finally
        if not pl1_right then carea.Reverse;//!
        Result.Add(carea);
      end;
    end;

  finally
    yline1.free;
    yline2.free;
    xLines.Free;
  end;
end;


//система x-областей (tpl) вдоль pl0,pl1:
function gf_CreateColorAreasOnPolosa(pl0,pl1: tpl; step: tnum; pl1_right: boolean): tclasslist;
var narea,i: tint; xLines: tclasslist; carea,plx: tpl;
begin
  Result:=tclasslist.new;
  step:=_get_step(step, v_dist(pl0.First,pl1.First), narea);//=>narea
  xLines:=gf_CreateDirectLinesByTwoLines(pl0,pl1, step);//промежуточные линии без pl0,pl1
  xLines.Insert(0,pl0);
  xLines.Add(pl1);
  try
    //создание областей:
    if xLines.Count>1 then for i:=0 to xLines.Count-2 do begin
      carea:=tpl.new;
      try
        //1-ая x-линия:
        tobject(plx):=xLines[i+1];
        carea.addfrom(plx);

        //2-ая x-линия:
        tobject(plx):=xLines[i];
        plx.reverse; carea.addfrom(plx);

        //замыкание:
        carea.add(carea.first);
      finally
        if pl1_right then carea.Reverse;//по час. стрелке
        Result.Add(carea);
      end;
    end;

  finally
    xLines.Free;
  end;
end;


{ public: }


  //порядок p1,p2 - "вдоль области":
  function _GetTwoPointsOnArea(area,line: tpl; beginning: boolean; var p1,p2: tnum2): boolean;
  var a,b,v: tnum2;
  begin
    if not beginning then line.Reverse;//1

    a:=line.first;
    line.NextPoint(0,b);
    v:=v_ort( v_sub(b,a) );
    b:=v_add(a,v);

    //orient=1 => "наружу" :
    Result := area.sec(a,b, 1, p1) and area.sec(a,b, -1, p2);

    if not beginning then line.Reverse;//2

    if Result and (v_dist(p1,p2)<=v_zero) then Result:=false;

    if not Result then Tell('Градиентная заливка: неопределённый торцевой отрезок (_GetTwoPointsOnArea)');
  end;

  function _GetFourLinesOnArea(area,line: tpl; line_r,line_l,line_b,line_e: tpl): boolean;
  var
    p1,p2,p3,p4: tnum2;//порядок - "вдоль области", p1,p2 - у начала line
    x1,x2,x3,x4: tnum;
    plx: tpl;
  begin
    Result:=false;

    line_r.clear;
    line_l.clear;
    line_b.clear;//торец0
    line_e.clear;//торец1

    if not _GetTwoPointsOnArea(area,line, true, p1,p2) then exit;
    if not _GetTwoPointsOnArea(area,line, false, p3,p4) then exit;

    x1:=area.xofp(p1);
    x2:=area.xofp(p2);
    x3:=area.xofp(p3);
    x4:=area.xofp(p4);

    if area.xinx1x2(x3,x1,x2) or area.xinx1x2(x4,x1,x2) then begin
      Tell('Градиентная заливка: пересечение торцевых отрезков (_GetFourLinesOnArea)');
      exit;
    end;

    plx:=area.CreateSegment( x2, x3, false );
    line_r.addfrom(plx);
    plx.free;

    plx:=area.CreateSegment( x4, x1, false );
    plx.Reverse;//!
    line_l.addfrom(plx);
    plx.free;

    plx:=area.CreateSegment( x1, x2, false );
    line_b.addfrom(plx);
    plx.free;

    plx:=area.CreateSegment( x3, x4, false );
    line_e.addfrom(plx);
    plx.free;

    Result:=true;
  end;


procedure gf_AddColorAreasOnRing(MSG: TMSGroup; pl: tpl; aLev: tint);
var  i,n: tint; len,dx,t: tnum; mso: TMSObj; cmyk: tcmykcolor; p0,p1: tnum2;
begin
  GfColor.LoadColorLine(pl);
  p0:=pl.First; p1:=pl.Last;

  len:=v_dist(p0,p1);
  dx:=_get_step(gcx_gf.xstep, len, n);
(*
  n:=gcx_gf.colors_count;
  if n<=0 then n:=cmn_step2n(gcx_gf.xstep,len,false);//кол-во промежутков >0
  dx:=len/n;//новый шаг
*)

  for i:=0 to n-1 do begin
    mso:=TMSObj.Create( gcx_obj.outcode[0], aLev );//0 - индекс COLOR-AREA
    mso.RingToLines(p0, dx*i,dx*(i+1));
    try t:=dx*i/len; except t:=0; end;
    cmyk:=GfColor.GetColor(t);
    mso.Write_H_cmyk(cmyk);
    MSG.Add(mso);
  end;
end;


  procedure _AddAreasToMSG(MSG: TMSGroup; list: tclasslist; aLev,dim: tint; len: tnum);
  var i,n: tint;  mso: TMSObj; pl: tpl; cmyk: tcmykcolor;
  begin
    n:=list.Count;
    if n>0 then for i:=0 to n-1 do begin
      TObject(pl):=list[i];
      mso:=TMSObj.Create( gcx_obj.outcode[0], aLev );//0 - индекс COLOR-AREA
      mso.PolyToLines(pl,dim);
      cmyk:=GfColor.GetColor(i/n);
      mso.Write_H_cmyk(cmyk);
      MSG.Add(mso);
    end;
  end;

  procedure _AddTorecToMSG(MSG: TMSGroup; pl: tpl; aLev,dim: tint; cmyk: tcmykcolor);
  var mso: TMSObj;
  begin
    pl.Add(pl.first);//замыкание
    mso:=TMSObj.Create( gcx_obj.outcode[0], aLev );//0 - индекс COLOR-AREA
    mso.PolyToLines(pl,dim);
    mso.Write_H_cmyk(cmyk);
    MSG.Add(mso);
  end;

procedure gf_AddColorAreasByLine(MSG: TMSGroup; area,line: tpl; aLev,dim: tint);
var
  dx: tnum; n: tint;
  RightResult,LeftResult: tclasslist;
  line_r,line_l: tpl;
  line_b,line_e: tpl;//торцы
begin
  dx:=_get_step(gcx_gf.xstep, line.Length, n);
  GfColor.LoadColorLine(line);

  //line_r справа от line, line_l слева от line:
  line_r:=tpl.new;
  line_l:=tpl.new;
  line_b:=tpl.new;
  line_e:=tpl.new;
  try

    if _GetFourLinesOnArea(area,line, line_r,line_l, line_b,line_e) then begin

      //области цвета:
      RightResult:=gf_CreateColorAreasByTwoLines(line,line_r, dx,gcx_gf.ystep, true);
      LeftResult:=gf_CreateColorAreasByTwoLines(line,line_l, dx,gcx_gf.ystep, false);
      try
        _AddAreasToMSG(MSG,RightResult,aLev,dim, line.lena.last);
        _AddAreasToMSG(MSG,LeftResult,aLev,dim, line.lena.last);
      finally
        RightResult.Free;
        LeftResult.Free;
      end;

      //куски в начале и в конце:
      _AddTorecToMSG(MSG, line_b, aLev,dim, GfColor.GetColor(0));
      _AddTorecToMSG(MSG, line_e, aLev,dim, GfColor.GetColor(1));

    end;//if _GetTwoLinesOnArea

  finally
    line_r.Free;
    line_l.Free;
    line_b.Free;
    line_e.Free;
  end;
end;


function _IdentifyOrderOf3Lines(const pl1,pl2,pl3: tpl; var line_l,line_m,line_r: tpl): boolean;
var
  i,j,i_l,i_m,i_r: tint;
  lines0: array[0..2]of tpl;//pl1,pl2,pl3
  orient: array[0..2,0..2]of integer;//-1,0,1; 1 => (l1-x;l2-y)
begin
  lines0[0]:=pl1; lines0[1]:=pl2; lines0[2]:=pl3;

  //заполнение orient[i,j]:
  for i:=0 to 2 do for j:=0 to 2 do begin
    orient[i,j] := v_orient( lines0[i].V[0], v_sub( lines0[j][0], lines0[i][0] ) );
  end;

  //левая линия (-1):
  i_l:=-1;
  for i:=0 to 2 do
    if (orient[i,(i+1) mod 3]=-1) and (orient[i,(i+2) mod 3]=-1) then begin
      i_l:=i; break;
    end;

  //правая линия (1):
  i_r:=-1;
  for i:=0 to 2 do
    if (orient[i,(i+1) mod 3]=1) and (orient[i,(i+2) mod 3]=1) then begin
      i_r:=i; break;
    end;

  //средняя линия:
  i_m:=-1;
  for i:=0 to 2 do
    if (i<>i_l) and (i<>i_r) then begin
      i_m:=i; break;
    end;

  Result := (i_l>=0) and (i_m>=0) and (i_r>=0);

  if Result then begin
    line_l:=lines0[i_l];
    line_m:=lines0[i_m];
    line_r:=lines0[i_r];
  end else begin
    Tell('Градиентная заливка: невозможно определить порядок 3-х линий (_IdentifyOrder)');
  end;
end;

procedure gf_AddColorAreasBy3Lines(MSG: TMSGroup; pl1,pl2,pl3: tpl; aLev,dim: tint);
var
  dx: tnum; n: tint;
  RightResult,LeftResult: tclasslist;
  line_l,line_m,line_r: tpl;//line_r справа от line_m, line_l слева от line_m
  ok: boolean;
begin
  try
    //идентификация line_l,line_m,line_r:
    ok:=_IdentifyOrderOf3Lines(pl1,pl2,pl3, line_l,line_m,line_r);

    dx:=_get_step(gcx_gf.xstep, line_m.Length, n);
    GfColor.LoadColorLine(line_m);

    if ok then begin
      //области цвета:
      RightResult:=gf_CreateColorAreasByTwoLines(line_m,line_r, dx,gcx_gf.ystep, true);
      LeftResult:=gf_CreateColorAreasByTwoLines(line_m,line_l, dx,gcx_gf.ystep, false);
      try
        _AddAreasToMSG(MSG,RightResult,aLev,dim, line_m.lena.last);
        _AddAreasToMSG(MSG,LeftResult,aLev,dim, line_m.lena.last);
      finally
        RightResult.Free;
        LeftResult.Free;
      end;
    end;//if ok

  finally
  end;
end;

//опорная линия и дочерний ортог. отрезок (|vort|>0):
procedure gf_AddColorAreasByWidth(MSG: TMSGroup; line0,lort: tpl; aLev,dim: tint);
var
  step: tnum; n: tint; ColorResult: tclasslist;
  ori: boolean; line2: tpl; vort: tnum2; d: tnum;
begin
  line2:=tpl.New;
  try
    //сдвиг линии (line0->line2):
    vort:=v_sub(lort.Last, lort.First);
    ori:=v_orient(vort, line0.V[0])=1;//true - вправо
    d:=lort.Length; if ori then d:=-d;
    line0.LeftLine(line2, d);

    step:=_get_step(gcx_gf.xstep, d, n);

    //области цвета:
    GfColor.LoadColorLine(lort);
    ColorResult:=gf_CreateColorAreasOnPolosa(line0,line2, step, ori);
    try
      _AddAreasToMSG(MSG,ColorResult, aLev,dim, d);//+ запись хар-к цвета
    finally
      ColorResult.Free;
    end;
  finally
    line2.Free;
  end;
end;


initialization
  GfColor:=tGfColor.Create;
finalization
  GfColor.Free;


end.
