(*
  tpl - лигнии и области с "дырками" (Next: tpl)
*)
unit llibx;

{$MODE Delphi}

 interface

uses List, nums, vlib, llib, matx;


type

  tpl = class;

  //пунктир:
  //steps, offset - базовая информация
  //Update(xmax) создает массивы x,isteps на [0..xmax]
  //критерий нормальности после Update - isteps.count>0
  //если steps=[x], то после Update steps=[x,x] (odd(isteps[i]) - нечёт. - пробел)
  //tmpseg используется в GetSegment для Result
  tdash = class
  private
    //Update:
    xmax: tnum;//параметр Update
    x: tnuma;//Отрезки пунктира попадающие на линию [0..xmax] (>Update)
    isteps: tinta;//индекс отрезка [x[i],x[i+1]] в steps (>Update)
    tmpseg: tpl;//Segment[i] (!)
    function GetCount: tint;//mini( x.count-1, isteps.count ), после Update;
    function GetSegment(pl: tpl; i: tint): tpl;//Result=tmpseg: tpl, после Update;
    function GetSegmentRev(pl: tpl; i: tint): tpl;//Result=tmpseg.reverse: tpl, после Update;
    function GetDashIndex(i: tint): tint;//isteps[i], >Update;
  public
    steps: tnuma;
    offset: tnum;
    constructor Create(asteps: tnuma; aoffset: tnum);//m.b. asteps=nil
    constructor Create_c(asteps: array of const; aoffset: tnum);
    constructor Create_n(n: tint; axmax,aoffset: tnum);//+Update(!)
    destructor Destroy; override;
    procedure LoadSteps(asteps: tnuma; aoffset: tnum);//clear x,isteps
    procedure LoadStepsFromString(ssteps: string; aoffset: tnum);//clear x,isteps
    procedure Scale(k: tnum);//умножение steps,offset
    procedure Update(axmax: tnum);//=> x,isteps

    //draw_odd=true => нечетные отрезки (дырки), false => четные
    procedure MakeDashLine(pl: tpl; outlist: tclasslist; draw_odd: boolean);//+Update
    procedure MakeDashRects(pl_l,pl_r: tpl; outlist: tclasslist; draw_odd: boolean);//

    property Count: tint read GetCount;//кол-во отрезков на [0..xmax] (после Update)
    property Segment[pl: tpl; i: tint]: tpl read GetSegment; default;//tmpseg: tpl, >Update;
    property SegmentRev[pl: tpl; i: tint]: tpl read GetSegmentRev;//tmpseg: tpl, >Update;
    property DashIndex[i: tint]: tint read GetDashIndex;//isteps[i], >Update;
  end;


  tpl = class(tpa) //PolyLine: box, lens, angles; обновление: Update;
  private
    FBox: tnum4; //Использовать только через property Box (FUpdate)
    FLena: tnuma; //0..count-1; Использовать только через property Lena (FUpdate)
    FNeedUpdate: boolean;
    function FGetBox: tnum4;
    function FGetLena: tnuma;
  protected
    procedure FModify; override;//меняет FNeedUpdate
  public
    Next: tpl; //дырки-дети

    procedure FUpdate; //=> FBox, FLena; меняет FNeedUpdate

    constructor Create(aDelta: Integer);
    constructor New;
    constructor NewFrom(pa: tpa);
    destructor Destroy; override;
    procedure Clear; override;//уничтожение дырок

    function Length: tnum;
    function VLength(i: integer): tnum;//0<=i<=Count-2

    procedure Transform(aMat: pMatrix; pa: tpa);//pa:=aMat(Self); pa=nil => меняется сама линия

    function xofp(px: tnum2): tnum;//xp(Result)=ближайшая точка линии
    function xp(x: tnum): tnum2; overload;//x-point: точка на линии;
    function xinx1x2(x,x1,x2: tnum): boolean;

    //ДЫРКИ: Result=HolesCount:
    function HolesCount: integer;//OLD-compatib
    function Holes_Last(var hole{Self!,if Result=0}: tpl): integer;
    function Holes_Add(hole: tpl): integer;
    function Holes_GetList(holes: TPtrList{Add}; _del: boolean{удалить из Self}): integer;
    function Holes_AddList(holes: TClassList): integer;//disconnect!

    function CreateSegment(x1,x2: tnum; find_p1_p2: boolean): tpl;//use v_zero
    function CreateSegmentPP(p1,p2: tnum2): tpl;
    function NewUniform(n: tint): tpl;

    function PointIn(px: tnum2): boolean;//включая границу, но не вершины (сумма углов)

    //ближайшая к т. a точка пересечения с orient ориентацией (if orient<>0):
    function sec(a,b: tnum2; orient: tint; var p: tnum2): boolean;
    //проекция: ближайшая точка линии; if vertex then ближайшая вершина:
    function prj(a: tnum2; vertex: boolean): tnum2;
    //массив биссектрис:
    procedure aort(ar: tnuma);
    //Result closed всегда! (перемещение начала):
    procedure NewStart(p0: tnum2);
    procedure NewStartInd(i0: tint);

    //в положит. сист.коор-т inds_negative - справа, на карте - слева:
    procedure GetLeftRightParts(a,b: tnum2; inds_negative, inds_0, inds_positive: tinta);

    procedure GetVypukObolo(pl_out: tpl);//pl_out(clear) - выпуклая оболочка
    procedure GetConvex(pl_out: tpl);//pl_out(clear) - выпуклая оболочка = GetVypukObolo

    procedure GetDiametrs(var d_min,d_max: tnum);
    function Diametr: tnum;//abs(box.b-box.a)

    procedure LeftLine(pl: tpl; ofs: tnum); //С ДЫРКАМИ, clear pl.
    //Line -> Area - см. tpa.LineToArea !
    procedure Translate2(v_first,v_last: tnum2);//first->first+v_first; last->last+v_last;

    //пересечение двух ломаных ("базовой" PL0 и ""второй" pl2):

    //xsec - выходной массив положений точек пересечения на базовой PL0 (в порядке возрастания)
    //если совпадают целые отрезки, то включаются концы меньшего
//    procedure sec_pl(pl2: tpl; xsec: tnuma);

    //координата первой вдоль PL0 точки пересечения:
    //если её нет - Result<0:
    function sec_pl_x(pl2: tpl): tnum;

    //RESULT: послед-ть [ta1,ta2] координат на (ab) ВНУТРЕННИХ отрезков в области:
    //$.ms: rightXY=true; Карта: rightXY=false(Y вниз)
    function lsec_area(a,b: tnum2; rightXY: boolean; ta0,ta1: tnuma): boolean;
    //без CLEAR & SORT на ta0,ta1:
    function lsec_area0(a,b: tnum2; rightXY: boolean; ta0,ta1: tnuma): boolean;

    //Создание штриховки:
    //Result: List of tpa (четные точки соединены с нечётными):
    //p0 - начальная точка; dp - ортогональный шаг:
    //на карте dx_min=1.5 - игнорирование "двойных точек"
    //i0 - четность линии, проходящей через т.p0:
    function CreateHatchList(p0,dp: tnum2; rightXY: boolean; dx_min: tnum; var i0: tint): TClassList;

    property Box: tnum4 read FGetBox;
    property Lena: tnuma read FGetLena;//Lena[0]=0, Lena[Count-1](Last)=Length
  end;



implementation

uses Wcmn, Arrayx;



{ tdash: }


constructor tdash.Create(asteps: tnuma; aoffset: tnum);
begin
  inherited Create;
  offset:=aoffset;
  steps:=tnuma.New;
  if asteps<>nil then steps.AddFrom(asteps);
  x:=tnuma.New;
  isteps:=tinta.New;
  tmpseg:=tpl.new;
end;

constructor tdash.Create_c(asteps: array of const; aoffset: tnum);
var i,l: tint;
begin
  Create(nil,aoffset);
  l:=Length(asteps);
  if l>0 then for i:=0 to l-1 do steps.add( asteps[i].VExtended^ );
end;

constructor tdash.Create_n(n: tint; axmax,aoffset: tnum);//+Update(!)
var d: tnum;
begin
  Create(nil,aoffset);
  if n<=0 then exit;
  d:=axmax/n;
  steps.add(d);
  Update(axmax);
end;

destructor tdash.Destroy;
begin
  tmpseg.free;
  isteps.free;
  x.free;
  steps.free;
  inherited Destroy;
end;

procedure tdash.LoadSteps(asteps: tnuma; aoffset: tnum);//clear x,isteps
begin
  steps.clear;
  if asteps<>nil then steps.AddFrom(asteps);
  offset:=aoffset;

  x.Clear;
  isteps.Clear;
end;

procedure tdash.LoadStepsFromString(ssteps: string; aoffset: tnum);//clear x,isteps
var s,sw: string; x: tnum;
begin
  LoadSteps(nil,aoffset);//=>steps=empty

  s:=ssteps;
  while true do begin
    sw:=sread_word(s);
    if Length(sw)=0 then break;
    x:=rvaldef(sw,0);
    steps.add(x);
  end;//while
end;

function tdash.GetCount: tint;
begin
  Result := mini( x.count-1, isteps.count );
end;

function tdash.GetSegment(pl: tpl; i: tint): tpl;//tmpseg: tpl, после Update;
begin
  tmpseg.clear;
  Result:=tmpseg;
  if (i>=0) and (i+1<x.Count) then
    pl.GetSegment(x[i],x[i+1], tmpseg, pl.Lena, false);
  if tmpseg.Count=1 then tmpseg.add(tmpseg.First);//всегда >=2 точек (или 0)
end;

function tdash.GetSegmentRev(pl: tpl; i: tint): tpl;//tmpseg: tpl, после Update;
begin
  Result:=GetSegment(pl,i);
  tmpseg.reverse;
end;

function tdash.GetDashIndex(i: tint): tint;//isteps[i], после Update;
begin
  Result:=isteps[i];
end;

procedure tdash.Scale(k: tnum);//умножение steps,offset
begin
  steps.mul(k);
  offset:=offset*k;
end;

procedure tdash.Update(axmax: tnum);
var i: tint; x0,period: tnum;
begin
  xmax:=axmax;
  x.clear;
  isteps.clear;

  //проверки:
  if xmax<=0 then exit;//!
  if steps.count=0 then exit;//!
  if steps.count=1 then steps.add(steps.first);//[d]->[dd]
  period:=steps.sum;//после "if steps.count=1"
  if period<=0 then exit;//!

  //смещение (=> -period<x0<=0):
  x0:=-offset;//знак - как в PS(!)
  while x0>0 do x0:=x0-period;
  while x0<=-period do x0:=x0+period;

  //первая точка (=> x0 - в конце отрезка isteps.first):
  for i:=0 to steps.count-1 do begin
    x0:=x0+steps[i];
    if x0>0 then begin//это случится обязательно!
      x.add(0);
      isteps.add(i);
      break;
    end;
    if i=steps.count-1 then Tell('ERROR in tdash.Calc_xi');
  end;

  //промежуточные точки:
  i := isteps.last;
  while x0<xmax do begin
    i := (i+1) mod steps.count ;
    x.add(x0);
    isteps.add(i);
    x0:=x0+steps[i];
  end;//while

  //последняя точка:
  x.add(xmax);
end;


procedure tdash.MakeDashLine(pl: tpl; outlist: tclasslist; draw_odd: boolean);
var i: integer; seg: tpl;
begin
  outlist.clear;
  if steps.count=0 then exit;//!
  Update(pl.length);//!

  if count>0 then for i:=0 to count-1 do begin
      if draw_odd<>odd( DashIndex[i] ) then continue;
      seg:=tpl.new;
      seg.addfrom( segment[pl,i] );
      outlist.add(seg);
  end;//for i
end;

//"окошки" между пунктирами:
procedure tdash.MakeDashRects(pl_l,pl_r: tpl; outlist: tclasslist; draw_odd: boolean);
var dash_l,dash_r: tdash; pl: tpl; n,i: integer; l: tnum;
begin
  outlist.clear;
  if steps.count=0 then exit;//!
  l:=(pl_l.Length+pl_r.Length)/2;//длина "средней линии"
  if l<=v_zero then exit;

  dash_l:=tdash.Create(steps,offset);
  dash_r:=tdash.Create(steps,offset);
  try
    dash_l.scale(pl_l.Length/l);
    dash_r.scale(pl_r.Length/l);
    dash_l.Update(pl_l.Length);
    dash_r.Update(pl_r.Length);

    n:=mini(dash_l.count,dash_r.count);
    if n>0 then for i:=0 to n-1 do begin
      if draw_odd<>odd( dash_r.DashIndex[i] ) then continue;
      pl:=tpl.new;
      pl.addfrom( dash_r[pl_r,i] );
      pl.addfrom( dash_l.segmentrev[pl_l,i] );
      pl.close;
      outlist.add(pl);
    end;//for i
  finally
    dash_l.free;
    dash_r.free;
  end;
end;


{ tpl: }


procedure tpl.FModify;
begin
  inherited FModify;
  FNeedUpdate:=true;
end;


function tpl.FGetBox: tnum4;
begin
  if FNeedUpdate then FUpdate;
  Result:=FBox;
end;

function tpl.FGetLena: tnuma;
begin
  if FNeedUpdate then FUpdate;
  Result:=FLena;
end;

procedure tpl.FUpdate;
begin
  GetLens(FLena);
  FBox:=GetBox;
  FNeedUpdate:=false;
end;


constructor tpl.Create(aDelta: Integer);
begin
  inherited Create(aDelta);
  FLena:=tnuma.create(aDelta);
  FNeedUpdate:=true;//!
end;

constructor tpl.New;
begin
  Create(aDeltaDefault);
end;

constructor tpl.NewFrom(pa: tpa);
begin
  New;
  AddFrom(pa);
end;

destructor tpl.Destroy;
begin
  Next.Free;//уничтожение дырок (рекурсия)
  //if Assigned(FLena) then FLena.Free;
  FLena.Free;
  inherited Destroy;
end;

procedure tpl.Clear;
begin
  FLena.Clear;
  Next.Free;//уничтожение дырок
  Next:=nil;//!
  inherited Clear;//=>FModify
end;


function tpl.Length: tnum;
begin
  Result:=Lena.Last;
end;

function tpl.VLength(i: integer): tnum;//0<=i<=Count-2
begin
  Result:=Lena[i+1]-Lena[i];
end;


procedure tpl.Transform(aMat: pMatrix; pa: tpa);//pa:=aMat(Self); pa=nil => меняется сама линия
var i: integer;
begin
  if pa<>nil then pa.Clear;
  if Count>0 then for i:=0 to Count-1 do
    if pa<>nil then pa.Add( m_transform(aMat, P[i]) )
    else P[i]:=m_transform(aMat, P[i]);
end;


function tpl.xofp(px: tnum2): tnum;//xp(Result)=ближайшая точка линии
begin
  Result := inherited xofp(px, Lena);
end;

function tpl.xp(x: tnum): tnum2;//x-point: точка на линии;
begin
  Result := inherited xp(x, Lena);
end;

function tpl.xinx1x2(x,x1,x2: tnum): boolean;
begin
  Result := (x>=x1) and (x<=x2);
  if Closed and (x2<x1) then Result := (x>=x1) or (x<=x2);
end;


//ДЫРКИ:

function tpl.HolesCount: integer;
var pl: tpl;
begin
  Result:=0;
  pl:=Self;
  while Assigned(pl.Next) do begin
    inc(Result);
    pl:=pl.Next;
  end;//while
end;

function tpl.Holes_Last(var hole{Self!,if Result=0}: tpl): integer;//Result=HolesCount
begin
  Result:=0;
  hole:=Self;//!
  while Assigned(hole.Next) do begin
    inc(Result);
    hole:=hole.Next;//Result=1 => hole - 1-ая дырка и т.д.
  end;//while
end;

function tpl.Holes_Add(hole: tpl): integer;//Result=HolesCount
var xhole: tpl;
begin
  Result:=Holes_Last(xhole);//Self,if Result=0
  xhole.Next:=hole;
  inc(Result);
end;

function tpl.Holes_GetList(holes: TPtrList{Add}; _del: boolean{удалить из Self}): integer;
var xhole: tpl;
begin
  Result:=0;
  xhole:=Self;//!
  while Assigned(xhole.Next) do begin
    inc(Result);
    holes.Add(xhole.Next);//Result=1 => xhole - 1-ая дырка и т.д.
    xhole:=xhole.Next;//for next
  end;//while
  if _del then Next:=nil;//!
end;

function tpl.Holes_AddList(holes: TClassList): integer;
var i: integer; xhole: tpl;
begin
  Result:=Holes_Last(xhole);//Self,if Result=0
  if holes.Count>0 then for i:=0 to holes.Count-1 do begin
    tobject(xhole.Next) := holes.Disconnect(i);//disconnect!
    inc(Result);
    xhole:=xhole.Next;//for next
  end;
end;


function tpl.CreateSegment(x1,x2: tnum; find_p1_p2: boolean): tpl;
begin
  Result:=tpl.New;
  GetSegment(x1,x2,Result,Lena,find_p1_p2);
end;

function tpl.CreateSegmentPP(p1,p2: tnum2): tpl;
begin
  Result:=tpl.new;
  if Count=0 then exit;
  GetSegmentPP(p1,p2, Result);
end;

function tpl.NewUniform(n: tint): tpl;
var step: tnum; i: tint;
begin
  Result:=tpl.New;
  Result.Add(First);
  if n<=1 then exit;
  step:=Lena.Last/(n-1);
  if n>2 then for i:=1 to n-2 do Result.Add( xp(i*step) );
  Result.Add(Last);
end;


function tpl.PointIn(px: tnum2): boolean;//включая границу, но не вершины
begin
  if v_inbox(px, Box) then Result := inherited PointIn(px)
  else Result := false;
end;


//ближайшая к т. a точка пересечения с orient ориентацией (if orient<>0):
function tpl.sec(a,b: tnum2; orient: tint; var p: tnum2): boolean;
var t,x: tnum;
begin
  Result:=lsec2(a,b,  orient, t,x, Box,Lena);
  if Result then p:=v_lt(a,b,t);
end;

//проекция:
function tpl.prj(a: tnum2; vertex: boolean): tnum2;
begin
  if vertex then Result := P[ iofp(a) ]
  else Result := xp( xofp(a) );
end;

procedure tpl.aort(ar: tnuma);
var i: tint;
begin
  if count<=1 then exit;
  ar.Clear;
  if count>0 then for i:=0 to count-1 do ar[i]:=biss(i,-90);//(-90) => биссектриса вправо:
end;

procedure tpl.newstart(p0: tnum2);
var s1,s2: tpl; x: tnum;
begin
  x:=xofp(p0);
  s1:=CreateSegment(x, Lena.last, false);
  s2:=CreateSegment(0,x, false);
  try
    if closed then s2.delete(0);
    Clear;
    Addfrom(s1);
    Addfrom(s2);
  finally
    s1.free;
    s2.free;
  end;
end;

procedure tpl.NewStartInd(i0: tint);
var i: integer; pl: tpl;
begin
  pl:=tpl.New;
  try
    if i0<count-1 then for i:=i0 to count-2 do pl.Add(P[i]);
    if (i0<count) and not closed then pl.Add(P[count-1]);//замыкание
    if i0>=0 then for i:=0 to i0 do pl.Add(P[i]);
  finally
    clear;
    AddFrom(pl);
    pl.Free;
  end;
end;

//в положит. сист.коор-т ins_negative - справа, на карте - слева:
procedure tpl.GetLeftRightParts(a,b: tnum2; inds_negative, inds_0, inds_positive: tinta);
var i: integer; v1,v2: tnum2; vm: tnum;
begin
  inds_negative.Clear;
  inds_0.Clear;
  inds_positive.Clear;
  v1:=v_sub(b,a);
  if count>0 then for i:=0 to count-1 do begin
    v2:=v_sub(P[i],a);
    vm:=v_vmul(v1, v2);
    if vm>0 then inds_positive.Add(i)
    else if vm<0 then inds_negative.Add(i)
    else inds_0.Add(i);
  end;
end;

procedure tpl.GetVypukObolo(pl_out: tpl);//pl(clear) - выпуклая оболочка

  //i1<count-1;
  //на последнем шаге Result=count-1 ОБЯЗАТЕЛЬНО:
  function _GetNextPoint(i1: integer; inds_negative, inds_0, inds_positive: tinta; _out_inds: tinta): integer;
  begin
    Result:=i1+1;//default
    while Result<count-1 do begin
      GetLeftRightParts(P[i1],P[Result], inds_negative,inds_0,inds_positive);
      if _out_inds.Count=0 then break;
      inc(Result);//Result<=count-1
    end;//while
  end;

var i0,i1,i2: integer; inds_negative,inds_0,inds_positive, _out_inds: tinta; a,b: tnum2;
begin
  pl_out.Clear;
  if count<4 then begin pl_out.AddFrom(Self); exit; end;

  i0:=iofp_ymax;//P[i0] принадлежит вып.об-ке
  NewStartInd(i0);

  //Self: count>3, замкнута, P[0] принадлежит вып.об-ке:
  inds_negative:=tinta.New;
  inds_0:=tinta.New;
  inds_positive:=tinta.New;
  try
    //_out_inds: Self по одну сторону от [a,b]||OY:
    _out_inds:=nil;
    a:=P[0];
    b:=v_add(a, v_xy(100,0));
    GetLeftRightParts(a,b, inds_negative,inds_0,inds_positive);
    if inds_negative.Count=0 then _out_inds:=inds_negative
    else if inds_positive.Count=0 then _out_inds:=inds_positive
    else if inds_0.Count=Count then pl_out.AddFrom(Self)//все точки на 1 линии
    else Tellf('INTERIOR ERROR in GetVypukObolo:\ninds_count: %d %d %d (count=%d)',
      [inds_negative.count,inds_0.count,inds_positive.count, Count]);

    //if _out_inds=nil - то либо "все точки на 1 линии", либо "INTERIOR ERROR":
    if Assigned(_out_inds) then begin

      i1:=0;
      pl_out.Add(P[i1]);
      while i1<count-1 do begin
        //на последнем шаге i2=count-1 ОБЯЗАТЕЛЬНО:
        i2:=_GetNextPoint(i1, inds_negative,inds_0,inds_positive, _out_inds);//=>_out_inds
        pl_out.Add(P[i2]);
        i1:=i2;//for next step
      end;

    end;//if Assigned(_out_inds)
  finally
    inds_positive.Free;
    inds_0.Free;
    inds_negative.Free;
  end;
end;

procedure tpl.GetConvex(pl_out: tpl);//pl_out(clear) - выпуклая оболочка
begin
  GetVypukObolo(pl_out);
  pl_out.Close;
end;


procedure tpl.GetDiametrs(var d_min,d_max: tnum);
var i,pind: integer; dmax: tnum; da: tnuma;
begin
  d_min:=0;
  d_max:=0;
  if Count<=1 then exit;
  if Count=2 then begin d_max:=Length; exit; end;

  //Count>=3:
  da:=tnuma.New;
  try
    for i:=0 to Count-1 do begin
      dmax:=maxdist_from_p(p[i], pind);
      da.Add(dmax);
    end;
    for i:=0 to Count-2 do begin
      dmax:=maxdist_from_l(p[i],p[i+1], pind);
      da.Add(dmax);
    end;
  finally
    d_min:=da.min(i);
    d_max:=da.max(i);
    da.Free;
  end;
end;

function tpl.Diametr: tnum;//abs(box.b-box.a)
begin
  Result := v_dist(box.b, box.a);
end;

procedure tpl.LeftLine(pl: tpl; ofs: tnum); //clear pl
var pl0: tpl;
begin
  inherited LeftLine(pl, ofs);
  pl0:=Self;
  while pl0.next<>nil do begin
    pl0:=pl0.next;
    pl.next:=tpl.new;
    pl:=pl.next;
    (pl0 as tpa).LeftLine(pl, -ofs);
  end;
end;

procedure tpl.Translate2(v_first,v_last: tnum2);//first->first+v_first; last->last+v_last;
var vt: tnum2; t: tnum; i: tint;
begin
  if Length<=v_zero then exit;
  if count>0 then for i:=0 to count-1 do begin
    t:=Lena[i]/Length;
    vt:=v_add( v_mul(v_first,1-t), v_mul(v_last,t) );
    P[i]:=v_add(P[i],vt);
  end;
end;

function tpl.sec_pl_x(pl2: tpl): tnum;
var i: integer; t,x: tnum;
begin
  Result:=-1;
  if not v_boxes_sec( Box, pl2.Box) then exit;

  if pl2.count>1 then for i:=0 to pl2.count-2 do begin
    //x - первая вдоль ломаной т. пересечения:
    if lsec1(pl2[i],pl2[i+1], t,x, box,lena) and (t>=0) and (t<=1) then begin
      if (Result<0) or (x<Result) then Result:=x;
    end;
  end;
end;



//без CLEAR & SORT на ta0,ta1, без дырок:
function tpl.lsec_area0(a,b: tnum2; rightXY: boolean; ta0,ta1: tnuma): boolean;
var i,secres: tint; tx,tl: tnum;
begin
  Result:=true;
  if count<=1 then exit;
  if not lsec_exists(a,b, box) then exit; //проверка "на рамку"

  try

    if count>1 then for i:=0 to count-2 do begin

      secres:=v_sec_lv(a,b, p[i],p[i+1], tl,tx);//включает v_sec_lv_exists(a,b, p1,p2)

      if rightXY then begin
        case secres of
           0: ;//нет пересечения
           2: ;//совпадение - изменение ситуации игнорируется!
          -1: ta0.add(tl);//внутрь
           1: ta1.add(tl);//наружу
        end;//case
      end else begin
        case secres of
           0: ;//нет пересечения
           2: ;//совпадение - изменение ситуации игнорируется!
           1: ta0.add(tl);//внутрь
          -1: ta1.add(tl);//наружу
        end;//case
      end;

    end;//for i

  except
    Result:=false;
  end;

  //Проверка парности точек:
  if ta0.count<>ta1.count then begin
//    Tellf('ERROR in tpa.lsec_area0: \nta0.count=%d <> ta1.count=%d',[ta0.count,ta1.count]);
    ta0.count:=mini(ta0.count,ta1.count);
    ta1.count:=ta0.count;
    Result:=false;
  end;
end;

function tpl.lsec_area(a,b: tnum2; rightXY: boolean; ta0,ta1: tnuma): boolean;
var pl: tpl;
begin
  ta0.clear;
  ta1.clear;

  Result:=lsec_area0(a,b, rightXY, ta0,ta1);

  //дырки:
  pl:=Self;
  while Result and (pl.next<>nil) do begin
    pl:=pl.next;
    Result:=pl.lsec_area0(a,b, not rightXY, ta0,ta1);
  end;

  ta0.Sort(nil);
  ta1.Sort(nil);
end;


//Создание штриховки:
//Result: List of tpa (четные точки соединены с нечётными):
//p0 - начальная точка; dp - ортогональный шаг:
//на карте dx_min=1.5 - игнорирование "двойных точек"
//i0 - четность линии, проходящей через т.p0:
function tpl.CreateHatchList(p0,dp: tnum2; rightXY: boolean; dx_min: tnum; var i0: tint): TClassList;
var
  p1,pmin,pmax,a,b,dl,ph: tnum2; tmin,tmax,step: tnum;
  ta0,ta1: tnuma; i: tint; pah: tpa;
  nmin,nmax,n: integer;
begin
  Result:=TClassList.New;

  dl:=v_rot(dp,-90);//направление линий
  step:=v_mod(dp);

  //[p0p1]-ортонаправление, t(p0)=0, t(p1)=1:
  p1:=v_add(p0,dp);
  i:=iofp_tmax(p0,p1);
  pmax:=P[i];
  i:=iofp_tmax(p1,p0);
  pmin:=P[i];
  tmax:=v_lp(p0,p1,pmax);
  tmin:=v_lp(p0,p1,pmin);

  ta0:=tnuma.new;
  ta1:=tnuma.new;
  try

    nmin:=Trunc(tmin); if tmin<0 then dec(nmin);
    nmax:=Trunc(tmax); if tmax>0 then inc(nmax);
    //точка p0 - при n=0, i0 - четность:
    i0 := abs(-nmin) mod 2;

    for n:=nmin to nmax do begin
    //for n:=0 to 0 do begin //DEBUG: одна линия

      a:=v_lt(p0,p1,n);
      b:=v_add(a,dl);

      if lsec_area(a,b, rightXY, ta0,ta1) then begin

        //2-PATH:
        if ta0.count>0 then begin
          pah:=tpa.new;

          for i:=0 to ta0.count-1 do begin
            if abs(ta1[i]-ta0[i])*step<dx_min then continue;//"двойные точки"
            ph:=v_lt(a,b,ta0[i]);
            pah.add(ph);
            ph:=v_lt(a,b,ta1[i]);
            pah.add(ph);
          end;//for i

          if pah.count>0 then Result.Add(pah) else pah.free;
        end;//if ta0.count>0

      end;//if lsec_area

    end;//for n

  finally
    ta0.free;
    ta1.free;
  end;//try
end;



end.
