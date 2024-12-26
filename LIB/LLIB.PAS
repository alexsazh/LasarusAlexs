//Lines:
unit LLIB;

{$MODE Delphi}

 interface

uses Arrayx, Nums, vlib;


const aDeltaDefault = 100; //for .New

type
  //пунктир типа [a b] (сложнее - in llibx.pas!):
  tdash0 = record
    steps: array [0..1] of tnum;
    offset: tnum;
  end;

  tpa = class(tarray)  //point's array (of tnum2)
  protected
    function Get(i: integer): tnum2;//mod count
    function GetCl(i: integer): tnum2;////CLOSED, i m.b. сильно <0
    procedure Put(i: integer; px: tnum2);
    function GetFirst: tnum2;
    function GetLast: tnum2;
    function GetV(i: integer): tnum2;//p[i+1]-p[i]; i=0..Count-2
    procedure _GetSegment(x1,x2: tnum; seg: tpa; la: tnuma; find_p1_p2: boolean);
  public
    constructor Create(aDelta: Integer);
    constructor New;
    procedure Add(px: tnum2); overload;
    procedure Add(x,y: double); overload;
    function Insert(i: tint; px: tnum2): tint;

    function next0(i: tint): tnum2; overload;//i+1 - ЗАМКНУТАЯ
    function next0(i,j: tint): tnum2; overload;//i+j - ЗАМКНУТАЯ
    function prev0(i: tint): tnum2;//ЗАМКНУТАЯ

    procedure AddToInt(ai: TIntArray);//округление, ai.count=2*count

    //X,Y - в начале строки, м.б. пустые строки:
    //символы из delims разделяют X и Y и по умолчанию содержат все char<=' ':
    function LoadFromText(aFileName: string; delims: string; CountIgnoreWords: integer): boolean;
    function SaveToText(aFileName: string): boolean;

    //параметры линии (вычисление):
    function Closed: boolean;
    procedure Close;//v_zero
    procedure Close0;//точное совпадение
    function GetBox: tnum4; //default: (0,0,0,0)
    function Centr: tnum2;
    function BoxCentr: tnum2;
    function NextPoint(i1: tint; var p2: tnum2): boolean;//v_zero; учитывает замкнутость!
    function SelfCrossExists: boolean;//самопересечение

    function SideR(pa: tpa): boolean;//true => pa справа    //??? (подозрит-ая ф-ия)

    function Square0: double;//ориентир-ая площадь (>0: от X к Y)
    function Square: double;//площадь

{cross}    function Direction: integer; overload;//-1,0,+1 (>0: от X к Y) (ЗАМЫКАНИЕ)

    function PointIn(px: tnum2): boolean;//включая границу, но не вершины (по сумме углов)

    //ВЫПУКЛЫЕ ОБЛАСТИ:
    function ConvexAreaSide: boolean;//true - слева в правой С.К. (положение центра отн-но 1-го отрезка)
    function PointInConvex(px: tnum2; _AreaSide, _IncludeBound: boolean): boolean;//_AreaSide=true - слева в правой С.К.

    function Reverse: tpa;
    function ReverseXY: tpa;//x<->y

    //сравнение направлений линий по индексам проекций точек - USED in DirectLine:
    function Direction(pa: tpa; var dir: boolean): boolean; overload;//dir=true - направления совпадают
    //USED in DLL_MSW:
    procedure DirectLine(pa: tpa; dir: boolean);//pa.Direction<>dir => reverse

    //сравнение направлений по направлениям одноиндексных отрезков:
//    function DirectionV(pa: tpa; var dir: boolean): boolean;//dir=true - направления совпадают

    //a=(-90) => биссектриса i-го угла вправо (i>=0):
    //замкнутость учитывается!
    //вектор биссектрисы, повернутый на a:
    function biss_v1(i: tint; a: tnum): tnum2;
    //<угол биссектрисы v[i-1] и v[i-1]> + a;
    function biss(i: tint; a: tnum): tnum;

    //РАССТОЯНИЯ:
    function DistFromPoint(ap: tnum2): tnum;
    function DistFromVector(a,b: tnum2): tnum;
    function dist_p(ap: tnum2; var a,b: tnum2): tnum;//ближайшая точка - на расст-ии Result - на отрезке [a,b]
    function maxdist_from_p(ap: tnum2; var pind: integer): tnum;
    function maxdist_from_l(ap1,ap2: tnum2; var pind: integer): tnum;

    procedure prolong(endind: tint; addlen: tnum);
    procedure trunc_ab(endind: tint; delta: tnum; a,b: tnum2);

    //первым при обходе увеличивается X,W:
    procedure AddRect(x0,y0,x1,y1: tnum); overload;
    procedure AddRect(a,b: tnum2); overload;
    procedure AddRect(b4: tnum4); overload;
    procedure AddRect_cv(center, vdir: tnum2; w,h: tnum);//vdir - вдоль h(высота)

    function iofv_ymax: tint; //ind верхнего отрезка
    function iofp_ymax: tint; //ind верхней точки
    function iofp_tmax(a,b: tnum2): tint; //ind верхней точки по направлению [ab]

    //оснащение линии: Count>1 (!)
    //l,a<>nil; вычисляются в GetLens,GetAngles; требуются в xp,...
    //GetLens удаляет(!) сопад-ие точки;
    //l[0]=0; l.last=line's length;
    //диапазон: v[0..Count-2], a[0..Count-2], l[0..Count-1]
    function GetLen: tnum;
    function GetLens(l: tnuma): tnum;//Result=Len, может изменить Count(!)
    procedure GetAngles(a: tnuma); //0..Count-2
    procedure GetAngles2(a,da: tnuma);//da[i] - угол внутренней точки i (i=1..count-2)

    function xofp(px: tnum2; l: tnuma): tnum;//xp(Result)=ближайшая точка линии
    function iofp(px: tnum2): tint;//p[Result]=ближайшая вершина
    function iofp2(p1,p2: tnum2): tint;//минимум суммы расстояний

    function xp(x: tnum; l: tnuma): tnum2;//x-point: точка на линии;
    function x_p_fi(x: tnum; l: tnuma; var fi: tnum): tnum2;//x-point и угол

    //Result - 2-path (пары точек):
    function CreateDashList0(dash: tdash0; l: tnuma): tpa;

    //m.b. ERROR!!! (-> tpl - Ok):
    function CreateUniform(n: integer; l: tnuma): tpa;

    //use v_zero:
    procedure GetSegment(x1,x2: tnum; seg: tpa; l: tnuma; find_p1_p2: boolean);
    function CreateSegment(x1,x2: tnum; l: tnuma; find_p1_p2: boolean): tpa;

    procedure GetSegmentPP(p1,p2: tnum2; seg: tpa);//seg.clear
    function CreateSegmentPP(p1,p2: tnum2): tpa;//p1->p[i1],p2->p[i2] - ближайшие вершины

    procedure LeftLine(pa: tpa; ofs: tnum);//clear pa
    procedure LeftLine2(pa: tpa; ofs: tnuma);//ofs - переменное отклонение!
    procedure LeftLine3(pa: tpa; ofs1,ofs2: tnum; Lena: tnuma);//постепенное изменение отклонения

    procedure ExpandEnds(d1,d2: tnum);//сдвиг концов, расширение при d>0

    //построение полосы шириной "width":
    //expand => продолжение концов на width/2:
    procedure LineToArea(pa: tpa; _width: tnum; _expand: boolean);//clear pa

    //пересечения с прямой:
    function lsec_exists(a,b: tnum2; box: tnum4): boolean;
    //pa.xp(x) = v_lt(a,b,t) т.пересечения pa с линией (ab):
    //первая (вдоль ломаной) точка пересечения:
    function lsec1(a,b: tnum2; var t,x: tnum; box: tnum4; l: tnuma): boolean;
    //ближайшая к т. a точка пересечения с orient ориентацией (if orient<>0):
    //orient=1 => (ab)-"наружу", если pa-часть границы "области" (!):
    //В координатах карты (Y вниз): orient=-1 => (ab)-"наружу"
    function lsec2(a,b: tnum2; orient: tint; var t,x: tnum; box: tnum4; l: tnuma): boolean;

    property P[Index: integer]: tnum2 read Get write Put; default;//mod count
    property PCl[Index: integer]: tnum2 read GetCl;//Index<0 сильно m.b. - mod
    property First: tnum2 read GetFirst;
    property Last: tnum2 read GetLast;
    property V[Index: integer]: tnum2 read GetV;//0..Count-2
  end;


implementation

uses Wcmn;



{ tpa: }


constructor tpa.Create(aDelta: Integer);
begin
  inherited Create( SizeOf(tnum2), aDelta );
end;

constructor tpa.New;
begin
  Create(aDeltaDefault);
end;

function tpa.Get(i: integer): tnum2;
var i2: integer;
begin
  i2:=i mod Count{!};//4=0 для треуг-ка (count=4!!!), -5 mod 4 = -1(проверено) -> 3
  if i2<0 then i2:=i2+Count;//-> 3
  inherited Get(i2, Result);//4=0 для треуг-ка (count=4!!!)
end;

function tpa.GetCl(i: integer): tnum2;//CLOSED, i m.b. сильно <0
var i2: integer;
begin
  if i>=0 then i2:=i mod (Count-1)//3=0 для треуг-ка (count=4)
  else i2:=Count + (i mod Count) mod (Count-1);//-5 mod 4 = -1(проверено) -> 3 -> 0
  inherited Get(i2, Result);
end;

procedure tpa.Put(i: integer; px: tnum2);
begin
  inherited Put(i, px);
end;

function tpa.GetFirst: tnum2;
begin
  if Count>0 then Result:=Get(0) else Result:=v_xy(0,0);
end;

function tpa.GetLast: tnum2;
begin
  if Count>0 then Result:=Get(Count-1) else Result:=v_xy(0,0);
end;

function tpa.GetV(i: integer): tnum2;
begin
  Result:=v_sub(p[i+1], p[i]);
end;


procedure tpa.Add(px: tnum2);
begin
  inherited Add(px);
end;

procedure tpa.Add(x,y: double);
begin
  Add( v_xy(x,y) );
end;


function tpa.Insert(i: tint; px: tnum2): tint;
begin
  Result:= inherited Insert(i,px);
end;


function tpa.next0(i: tint): tnum2;//i+1 - ЗАМКНУТАЯ
begin
  Result:=P[i+1];//mod - in Get
end;
function tpa.next0(i,j: tint): tnum2;//i+j - ЗАМКНУТАЯ
begin
  Result:=P[i+j];//mod - in Get
end;
function tpa.prev0(i: tint): tnum2;//ЗАМКНУТАЯ
begin
  Result:=P[i-1+count];//mod - in Get
end;


procedure tpa.AddToInt(ai: TIntArray);
var i,ix: tint;
begin
  if count>0 then for i:=0 to count-1 do begin
    ix:=Round(p[i].x); ai.add(ix);
    ix:=Round(p[i].y); ai.add(ix);
  end;
end;


//delims по умолчанию содержит все char<=' ':
function tpa.LoadFromText(aFileName: string; delims: string; CountIgnoreWords: integer): boolean;

  //function _sgetword

var f: TextFile; sline,sw: string; sn,k: integer; x,y: double;
begin
  Result:=false;
  Clear;
  if ftopen(f, aFileName, 'r') then try
    while not eof(f) do begin
      readln(f, sline);
      if Length(sline)=0 then continue;

      //в каждой строке - пропуск CountIgnoreWords слов:
      sn:=1;
      if CountIgnoreWords>0 then for k:=1 to CountIgnoreWords do begin
        sw:=sgetword3(sline, sn, delims);
        if Length(sw)=0 then continue;
        if sw[1]='%' then continue;
      end;

      sw:=sgetword3(sline, sn, delims); if Length(sw)=0 then continue; if sw[1]='%' then continue;
      if not isdigit2(sw[1]) then continue;//!
      x:=sread_real(sw);
      sw:=sgetword3(sline, sn, delims); if Length(sw)=0 then continue;
      if not isdigit2(sw[1]) then continue;//!
      y:=sread_real(sw);

      Add( v_xy(x,y) );
    end;//while
    Result:=true;
  finally
    ftclose(f);
  end;
end;

function tpa.SaveToText(aFileName: string): boolean;
var f: TextFile; i: integer;
begin
  Result:=false;
  if ftopen(f, aFileName, 'w') then try
    if Count>0 then for i:=0 to Count-1 do begin
      writeln(f, P[i].x, ' ', P[i].y);              //???? формат
    end;//for i
    Result:=true;
  finally
    ftclose(f);
  end;
end;


function tpa.SideR(pa: tpa): boolean;//pa справа
var i,ori: tint;
begin
  Result:=true;
  if count>1 then for i:=0 to count-2 do begin
    ori:=v_orient( v[i], v_sub(pa[i], p[i]));
    if ori=0 then continue;
    if ori>0 then Result:=false;
    break;
  end;
end;


function tpa.Closed: boolean;
begin
  if Count<2 then Result:=false
  else Result := v_dist(First, Last)<v_zero;
end;

procedure tpa.Close;//uses v_zero
begin
  if Count<3 then exit;
  if not Closed then Add(First);
end;

procedure tpa.Close0;//точное совпадение
begin
  if v_dist(First, Last)>0 then Add(First);
end;

function tpa.GetBox: tnum4;//default: (0,0,0,0)
var i: integer; v0: tnum2;
begin
  v0:=First;
  Result:=v_box(v0,v0);
  if Count>1 then for i:=1 to Count-1 do v_box_correct(p[i], Result);
end;

function tpa.Centr: tnum2;
var i,n: integer; xp: tnum2;
begin
  Result:=First;//default
  if Closed then n:=Count-1{без последней вершины = первой} else n:=Count;
  if n>0 then for i:=0 to n-1 do begin
    xp := v_mul( p[i], 1/n );
    if i=0 then Result := xp
    else Result := v_add( Result, xp );
  end;//for i
end;

function tpa.BoxCentr: tnum2;
var B: tnum4;
begin
  B:=GetBox;
  Result.x:=(B.a.x+B.b.x)/2;
  Result.y:=(B.a.y+B.b.y)/2;
end;



function tpa.NextPoint(i1: tint; var p2: tnum2): boolean;//v_zero; учитывает замкнутость!
var i,i2: tint; p1: tnum2;
begin
  Result:=true;
  p1:=P[i1];
  p2:=p1;
  for i:=1 to 1000 do begin
    i2:=i1+i;
    if i2>=count then begin
      if Closed then i2:=(i2 mod (count-1))//3=0 для тр-ка (count=4)
      else break;
    end;
    p2:=P[i2];//mod count
    if v_dist(p1,p2)>v_zero then exit;//Result!
  end;//for i
  Result:=false;
end;

function tpa.SelfCrossExists: boolean;
var i1,i2,secres: integer; t1,t2: tnum;
begin
  Result:=false;
  if Count<5 then exit;//min - 4-хугольник м.б.
  for i1:=0 to Count-4 do
    for i2:=i1+2 to Count-2 do begin
      secres:=v_sec_ll0(P[i1],P[i1+1], P[i2],P[i2+1], t1,t2, 0);
      if (abs(secres)=1) and (t1>0) and (t1<1) and (t2>0) and (t2<1) then begin
        Result:=true;
        exit;
      end;
    end;//for i1,i2
end;


function tpa.Direction(pa: tpa; var dir: boolean): boolean;//true - направления совпадают
var i,i1,i2,di1,di2: tint; p1,p2: tnum2;
begin
  Result:=false;
  dir:=true;
  if count<2 then exit;

  p1:=first;
  i1:=pa.iofp(p1);
  i2:=i1;
  for i:=1 to count-1 do begin
    //if not NextPoint(0,p2) then exit;
    p2:=P[i];
    i2:=pa.iofp(p2);
    if i2<>i1 then break;
  end;
  if i2=i1 then exit;//!!!

  dir := i2>=i1 ;

  if pa.Closed then begin
    di1:=abs(i2-i1);
    di2:=pa.count-1-di1;
    if di2<di1 then dir := not dir;
  end;

  Result:=true;
end;


function tpa.Square0: double;//ориентир-ая площадь (>0: от X к Y)
var p0: tnum2; i: integer;
begin
  Result:=0;
  if count<3 then exit;

  p0:=P[0];
  for i:=1 to count-2 do
    Result := Result + v_vmul( v_sub(P[i],p0), v_sub(P[i+1],p0) );

  Result := Result/2;
end;
function tpa.Square: double;//площадь
begin
  Result := abs(Square0);
end;


function tpa.Direction: integer;
begin
  Result := sign(Square0);
end;


procedure tpa.DirectLine(pa: tpa; dir: boolean);//pa.Direction<>dir => reverse
var adir: boolean;
begin
  if not Direction(pa,adir) then exit;
  if adir<>dir then reverse;
end;


function tpa.PointIn(px: tnum2): boolean;//включая границу, но не вершины
var i,k: integer; fi: tnum; v1,v2: tnum2;
begin
  fi:=0;
  if FCount>3 then for i:=0 to FCount-2 do begin
    v1 := v_sub(P[i],px);
    v2 := v_sub(P[i+1],px);
    fi := fi + v2_fi(v1,v2);//от v1 к v2, >0: от X к Y
  end;
  k  := Round(fi/360);
  Result := k<>0;
end;


//ВЫПУКЛЫЕ ОБЛАСТИ:

function tpa.ConvexAreaSide: boolean;//true - слева в правой С.К. (положение центра отн-но 1-го отрезка)
var pc,ab,ac: tnum2;
begin
  pc := Centr;
  ab := V[0];//v_sub(P[1], P[0]);
  ac := v_sub(pc, P[0]);
  if v_vmul(ab, ac)>0 then Result:=true else Result:=false;
end;

function tpa.PointInConvex(px: tnum2; _AreaSide, _IncludeBound: boolean): boolean;//_AreaSide=true - слева в правой С.К.
var i: integer; d_vmul: double;
begin
  Result:=false;
  if Count>0 then for i:=0 to Count-2 do begin
    d_vmul:=v_vmul(V[i], v_sub(px, P[i]));
    if _AreaSide then begin
      if (_IncludeBound and (d_vmul<0))
      or (not _IncludeBound and (d_vmul<=0))
      then exit;
    end else
      if (_IncludeBound and (d_vmul>0))
      or (not _IncludeBound and (d_vmul>=0))
      then exit;
  end;
  Result:=true;//совпадение знаков или 0 на всех отрезках
end;


function tpa.Reverse: tpa;
begin
  Result:=Self;
  inherited Reverse;
end;

function tpa.ReverseXY: tpa;//x<->y
var i: integer; pp: pnum2;
begin
  Result:=Self;
  if FCount>0 then for i:=0 to FCount-1 do begin pp:=GetP(i); v_reverse(pp); end;
  FModify;//!
end;

//вектор биссектрисы, повернутый на a:
function tpa.biss_v1(i: tint; a: tnum): tnum2;
var v1,v2,vx: tnum2;
begin
  if count<2 then begin
    Result:=v_rot(v_xy(1,0),a);
    exit;
  end;

  if (i>0) and (i<count-1) then begin
    v1:=v_norm1(v[i-1]);
    v2:=v_norm1(v[i]);
    vx:=v_norm1( v_add(v1,v2) );
  end else if closed then begin
    v1:=v_norm1(v[count-2]);
    v2:=v_norm1(v[0]);
    vx:=v_norm1( v_add(v1,v2) );
  end else begin
    if i=0 then vx:=v[0]
    else vx:=v[count-2];
  end;
  Result:=v_rot(vx,a);
end;

//угол биссектрисы + a:
function tpa.biss(i: tint; a: tnum): tnum;
begin
  Result:=v_fi( biss_v1(i,a) );
end;


//ближайшая точка на расст-ии Result - на отрезке [a,b]:
function tpa.dist_p(ap: tnum2; var a,b: tnum2): tnum;
var i: tint; t,d: tnum;
begin
  Result:=-1;//default

  a:=first;
  b:=first;
  if count=1 then Result:=v_dist(ap,p[0]);
  if count>1 then for i:=0 to count-2 do begin
    d:=v_dist_pv(ap, p[i],p[i+1], t);
    if i=0 then begin
      Result:=d;
      b:=p[1];
    end else begin
      if d<Result then begin
        Result:=d;
        a:=p[i];
        b:=p[i+1];
      end;
    end;
  end;
end;

function tpa.DistFromPoint(ap: tnum2): tnum;//no Box!
var a,b: tnum2;
begin
  Result:=dist_p(ap,a,b);
end;

function tpa.DistFromVector(a,b: tnum2): tnum;
var i: integer; d: double;
begin
  Result:=v_dist_vv(a,b, First,Last);//default or count<3(!)

  if count>2 then for i:=0 to count-2 do begin
    //if v_dist(p[i],p[i+1])=0 then continue;//!
    d:=v_dist_vv(a,b, p[i],p[i+1]);
    if (i=0) or (i>0) and (d<Result) then Result:=d;
  end;//for i
end;


function tpa.maxdist_from_p(ap: tnum2; var pind: integer): tnum;
var i: integer; d: tnum;
begin
  Result:=0;
  if count>0 then for i:=0 to count-1 do begin
    d:=v_dist(ap, p[i]);
    if i=0 then begin
      Result:=d;
      pind:=i;
    end else begin
      if d>Result then begin
        Result:=d;
        pind:=i;
      end;
    end;
  end;
end;

function tpa.maxdist_from_l(ap1,ap2: tnum2; var pind: integer): tnum;
var i: integer; d,t: tnum;
begin
  Result:=0;
  if count>0 then for i:=0 to count-1 do begin
    d:=v_dist_pl(p[i], ap1,ap2, t);
    if i=0 then begin
      Result:=d;
      pind:=i;
    end else begin
      if d>Result then begin
        Result:=d;
        pind:=i;
      end;
    end;
  end;
end;


procedure tpa.prolong(endind: tint; addlen: tnum);
var p0,p1: tnum2;
begin
  if count<2 then exit;
  if endind=0 then begin
    p0:=p[0];
    p1:=p[1];
    try p[0]:=v_lt(p1,p0,addlen/v_dist(p0,p1)+1); except ; end;
  end else begin
    p0:=p[count-1];
    p1:=p[count-2];
    try p[count-1]:=v_lt(p1,p0,addlen/v_dist(p0,p1)+1); except ; end;
  end;
end;

procedure tpa.trunc_ab(endind: tint; delta: tnum; a,b: tnum2);
var i,ndel: tint; t,d0,d1{,l}: tnum;
begin
  ndel:=0;
  if count>1 then begin
    if endind<>0 then reverse;//=>начало пути
    d0:=v_dist_pv(p[0], a,b, t);
    if d0>=delta then exit;//=>d0<delta
    for i:=0 to count-2 do begin
      d1:=v_dist_pv(p[i+1], a,b, t);
      if d1>=delta then begin
        try
          //l:=v_dist(p[i],p[i+1]);
          t:=(delta-d0)/(d1-d0);
          if (t>=0) and (t<=1) then p[i]:=v_lt(p[i],p[i+1], t);
        except
        end;
        break;
      end else begin
        inc(ndel);
      end;//if
      d0:=d1;
    end;//for
    if ndel>0 then for i:=1 to ndel do deletefirst;
    if endind<>0 then reverse;
  end;
end;


//первым при обходе увеличивается X:
procedure tpa.AddRect(x0,y0,x1,y1: tnum);
begin
  add( v_xy(x0,y0) );
  add( v_xy(x1,y0) );
  add( v_xy(x1,y1) );
  add( v_xy(x0,y1) );
  add( v_xy(x0,y0) );
end;

procedure tpa.AddRect(a,b: tnum2);
begin
  AddRect(a.x,a.y, b.x,b.y);
end;

procedure tpa.AddRect(b4: tnum4);
begin
  AddRect(b4.a, b4.b);
end;

//первым при обходе увеличивается W:
procedure tpa.AddRect_cv(center, vdir: tnum2; w,h: tnum);
var v_w,v_h,v: tnum2;
begin
  v_h := v_norm( vdir,        h/2 );//радиус вперёд
  v_w := v_norm( v_ort(vdir), w/2 );//радиус влево

  //+1,-1 - левый нижний:
  v := v_add( v_mul(v_w,+1), v_mul(v_h,-1) ); Add( v_add(center,v) );
  v := v_add( v_mul(v_w,-1), v_mul(v_h,-1) ); Add( v_add(center,v) );
  v := v_add( v_mul(v_w,-1), v_mul(v_h,+1) ); Add( v_add(center,v) );
  v := v_add( v_mul(v_w,+1), v_mul(v_h,+1) ); Add( v_add(center,v) );

  Add( P[Count-4] );//замыкание 4-хугольника
end;


function tpa.iofv_ymax: tint; //ind верхнего отрезка
var i: tint; ymax,y: tnum;
begin
  Result:=0;
  ymax:=0;
  if count>2 then for i:=0 to count-2 do begin
    if i=0 then begin
      Result:=0;
      ymax := v_lt(p[i],p[i+1],0.5).y;
    end else begin
      y := v_lt(p[i],p[i+1],0.5).y;
      if y>ymax then begin
        Result:=i;
        ymax:=y;
      end;
    end;//i<>0
  end;//for i
end;

function tpa.iofp_ymax: tint; //ind верхней точки
var i: tint; ymax,y: tnum;
begin
  Result:=0;
  ymax:=0;
  if count>1 then for i:=0 to count-1 do begin
    if i=0 then begin
      Result:=0;
      ymax := first.y;
    end else begin
      y := p[i].y;
      if y>ymax then begin
        Result:=i;
        ymax:=y;
      end;
    end;//i<>0
  end;//for i
end;


function tpa.iofp_tmax(a,b: tnum2): tint; //ind верхней точки по направлению [ab]
var i: tint; tmax,t: tnum;
begin
  Result:=0;
  tmax:=0;
  if count>1 then for i:=0 to count-1 do begin
    if i=0 then begin
      Result:=0;
      tmax:=v_lp(a,b,first);
    end else begin
      t:=v_lp(a,b,p[i]);
      if t>tmax then begin
        Result:=i;
        tmax:=t;
      end;
    end;//i<>0
  end;//for i
end;


function tpa.GetLen: tnum;
var i: tint;
begin
  Result:=0;
  if Count>1 then for i:=0 to Count-2 do Result:=Result+v_mod(v[i]);
end;

function tpa.GetLens(l: tnuma): tnum;
var i: integer; d: tnum;
begin
  Result:=0;
  l.clear;
  if Count=0 then exit;
  l[0]:=0;//! - l[pa.count-1]=l.last=length
(*
                   //УДАЛЕНИЕ ОТДЕЛЬНЫХ ТОЧЕК НАДО МОДЕРНИЗИРОВАТЬ ДЛЯ 3D !!!!!
  i:=0;
  if Count>1 then while i<=Count-2 do begin
    d:=v_dist( p[i], p[i+1] );
    while (d<v_zero) and (i<=Count-2) do begin
      Delete(i+1); //совпадающие точки, dec(count)
      //м.б.удалена последняя точка => i=Count-1:
      if i<=Count-2 then d:=v_dist( p[i], p[i+1] );
    end;
    if i<=Count-2 then begin
      Result := Result + d;
      l[i+1]:=Result;
    end;
    inc(i);
  end;
*)
  if Count>1 then for i:=1{!} to Count-1 do begin
    d:=v_dist(p[i-1], p[i]);
    Result := Result + d;//ДЛИНА v[i-1]
    l.Add(Result);
  end;

end;


procedure tpa.GetAngles(a: tnuma);
var i: tint;
begin
  a.clear;
  if Count>1 then for i:=0 to Count-2 do a[i]:=v_fi(v[i]);
end;

//da.first=da.last=0; dab.count=count (!)
//при i=1..count-2  da[i] = угол внутренней точки i:
procedure tpa.GetAngles2(a,da: tnuma);
var i: tint;
begin
  GetAngles(a);//a.count=count-1; 0..count-2
  da.clear;
  if count>2 then begin
    da[0]:=0;
    for i:=1 to count-2 do da[i]:=angle_correct(a[i]-a[i-1]);
    da.add(0);
  end;
end;


function tpa.xp(x: tnum; l: tnuma): tnum2;
var i: integer;
begin
  Result:=First;
  if Count<2 then exit;
  if x<=l.First then exit;
  if x>=l.Last then begin Result:=Last; exit; end;

  for i:=0 to Count-2 do begin

    if l[i+1]>=x then begin
      try
        Result:=v_add(p[i], v_mul(v[i], (x-l[i])/(l[i+1]-l[i])));
      except
        Result:=p[i];
      end;
      exit;
    end;

  end;//for
end;

function tpa.x_p_fi(x: tnum; l: tnuma; var fi: tnum): tnum2;
var i: integer;
begin
  Result:=First; fi:=0;
  if Count<2 then exit;
  fi:=v_fi(V[0]);
  if x<=0 then exit;
  if x>=l.last then begin Result:=Last; fi:=v_fi(V[Count-2]); exit; end;

  for i:=0 to Count-2 do begin

    if l[i+1]>=x then begin
      try
        fi:=v_fi(V[i]);
        Result:=v_add(p[i], v_mul(v[i], (x-l[i])/(l[i+1]-l[i])));
      except
        Result:=p[i];
      end;
      exit;
    end;

  end;//for
end;


//Result - 2-path (пары точек):
function tpa.CreateDashList0(dash: tdash0; l: tnuma): tpa;
var x,period: tnum;

  procedure _create_period;
  var p1,p2: tnum2; x1,x2: tnum;
  begin
    x1:=x; p1:=xp(x1,l);//первая точка
    x2:=x+dash.steps[0]; p2:=xp(x2,l);//вторая точка
    if (x2>0) and (x1<l.last) then begin
      Result.Add(p1);
      Result.Add(p2);
    end;
    x:=x2+dash.steps[1];//пропуск
  end;

begin
  Result:=tpa.new;
  period:=dash.steps[0]+dash.steps[1];
  x:=-dash.offset;//знак - как в PS:
  while x>0 do x:=x-period;
  while x<=-period do x:=x+period;
  while x<l.last do _create_period;
end;

function tpa.xofp(px: tnum2; l: tnuma): tnum;//xp(Result)=ближайшая точка
var i: integer; dmin,di,t,tmin: tnum; imin: tint;
begin
  Result:=0;
  if Count<2 then exit;
  dmin:=v_dist_pv(px, p[0],p[1], t); //i:=0
  imin:=0;
  tmin:=t;
  if Count>2 then for i:=1 to Count-2 do begin
    di:=v_dist_pv(px, p[i],p[i+1], t);
    if di<dmin then begin dmin:=di; imin:=i; tmin:=t; end;
  end;
  Result := l[imin] + tmin*(l[imin+1]-l[imin]);
end;


function tpa.iofp(px: tnum2): tint;
var i: tint; dmin,di: tnum; imin: tint;
begin
  Result:=0;
  if Count<2 then exit;
  dmin:=v_dist(px, p[0]); //i:=0
  imin:=0;
  if Count>1 then for i:=1 to Count-1 do begin
    di:=v_dist(px, p[i]);
    if di<dmin then begin dmin:=di; imin:=i; end;
  end;
  Result := imin;
end;

function tpa.iofp2(p1,p2: tnum2): tint;//минимум суммы расстояний
var i: tint; dmin,di: tnum; imin: tint;
begin
  Result:=0;
  if Count<2 then exit;
  dmin:=v_dist(p1, p[0])+v_dist(p2, p[0]); //i:=0
  imin:=0;
  if Count>2 then for i:=1 to Count-1 do begin
    di:=v_dist(p1, p[i])+v_dist(p2, p[i]);
    if di<dmin then begin dmin:=di; imin:=i; end;
  end;
  Result := imin;
end;



function tpa.CreateUniform(n: integer; l: tnuma): tpa;
var i,j: integer; x,step: tnum;
  procedure _add_p_a;
  var t: tnum;
  begin
    try
      t:=(x-l[i])/(l[i+1]-l[i]);
    except
      t:=0;
    end;
    Result[j] := v_lt(p[i],p[i+1],t);
    inc(j);
  end;
begin
  Result:=tpa.New;
  if (count<=1) or (n<=1) then exit;
  step:=l.last/(n-1);

  //основной цикл:
  x:=0;
  j:=0;
  if count>1 then for i:=0 to Count-2 do begin
    while l[i+1]>=x do begin
      _add_p_a;
      x:=x+step;
    end;
  end;//for i

  //последняя точка может не попасть автоматически:
  if Result.count<n then begin
    i:=count-2; x:=l.last;
    _add_p_a;
  end;
end;


//private:  x1<x2
procedure tpa._GetSegment(x1,x2: tnum; seg: tpa; la: tnuma; find_p1_p2: boolean);
var
  i,i1,i2: integer;
  x: tnum;
  px1,px2: tnum2;
begin
  seg.clear;//!

  if Count=0 then exit;
  if (Count=1) and (x1=0) and (x2=0) then begin seg.Add(First); exit; end;

  if x1>x2 then exit;//!

  px1:=xp(x1,la);
  px2:=xp(x2,la);

  if find_p1_p2 then begin

    i1:=iofp(px1);
    i2:=iofp(px2);
    if closed then begin
      if i2=0 then i2:=count-1; //!
      if abs(x2-la.last)<v_zero then i2:=count-1; //!
    end;

    if i2>=i1 then for i:=i1 to i2 do seg.Add(p[i]);

  end else begin

    seg.Add(px1); //первая точка
    if abs(x2-x1)<v_zero then exit;
    if Count>1 then for i:=0 to Count-2 do begin
      x:=la[i+1];
      if (x-x1>v_zero) and (x2-x>v_zero) then seg.Add(p[i+1]);
    end;
    seg.Add(px2); //последняя точка

  end;
end;

procedure tpa.GetSegment(x1,x2: tnum; seg: tpa; l: tnuma; find_p1_p2: boolean);
var len: tnum; s2: tpa;
begin
  len:=l.last;
  s2:=tpa.new;

  if x2>=x1 then begin

    _GetSegment(x1,x2,seg,l,find_p1_p2);

  end else begin //x2<x1:

    _GetSegment(x1,len,seg,l,find_p1_p2);
    _GetSegment(0,x2,s2,l,find_p1_p2);

    if Closed and (s2.count>0) then s2.Delete(0);
    seg.AddFrom(s2);

  end;

  s2.free;
end;

function tpa.CreateSegment(x1,x2: tnum; l: tnuma; find_p1_p2: boolean): tpa; //->Free; l m.b. nil
begin
  Result:=tpa.New;
  GetSegment(x1,x2,Result,l,find_p1_p2);
end;

procedure tpa.GetSegmentPP(p1,p2: tnum2; seg: tpa);
var i,i1,i2: integer;
begin
  seg.clear;
  if Count=0 then exit;

  i1:=iofp(p1);
  i2:=iofp(p2);
  if closed and (i2<i1) then begin
    if (i2=0) then i2:=count-1; //!
    if (i1=count-1) then i1:=0; //!
  end;

  if i2>=i1 then begin
    for i:=i1 to i2 do seg.Add(p[i]);
  end else begin
    for i:=i1 to count-1 do seg.Add(p[i]);
    if closed then seg.deletelast;
    for i:=0 to i2 do seg.Add(p[i]);
  end;
end;

function tpa.CreateSegmentPP(p1,p2: tnum2): tpa;
begin
  Result:=tpa.new;
  if Count=0 then exit;
  GetSegmentPP(p1,p2, Result);
end;


procedure _LeftLine_AddPointToPa(pa0: tpa; i: tint; pa: tpa; ofs: tnum);
var p0,p1,v,px: tnum2; x,t: tnum;
begin
    v:=pa0.biss_v1(i,90);//единичная биссектриса
    p0:=pa0[i];
    if i>0 then px:=pa0[i-1] else px:=pa0[i+1];
    x:=v_dist_pl( v_add(p0,v), p0,px, t);
    try t:=ofs/x; except t:=ofs; end;
    p1:=v_add(p0, v_mul(v,t));
    pa.add(p1);
end;

procedure tpa.LeftLine(pa: tpa; ofs: tnum);
var i: tint;
begin
  pa.clear;
  if (Count=1) then begin pa.add(first); exit; end;

  if Count>1 then for i:=0 to Count-1 do begin
    _LeftLine_AddPointToPa(Self, i, pa, ofs);
  end;

  if closed then begin pa.deletelast; pa.add(pa.first); end;
end;

procedure tpa.LeftLine2(pa: tpa; ofs: tnuma);
var i: tint;
begin
  pa.clear;
  if (Count=1) then begin pa.add(first); exit; end;
  if Count>1 then for i:=0 to Count-1 do begin
    _LeftLine_AddPointToPa(Self, i, pa, ofs[i]);
  end;
//  if closed then begin pa.deletelast; pa.add(pa.first); end;
end;

procedure tpa.LeftLine3(pa: tpa; ofs1,ofs2: tnum; Lena: tnuma);//постепенное изменение отклонения
var i: tint; t,l: tnum; delta: tnuma;
begin
  pa.clear;
  if (Count=1) then begin pa.add(first); exit; end;
  l:=Lena.Last; if l<=0 then begin pa.add(first); exit; end;

  delta:=tnuma.new;
  try
    //построение массива delta:
    delta.Count:=Count;
    if Count>0 then for i:=0 to Count-1 do begin
      t:=Lena[i]/l;
      delta[i] := (1-t)*ofs1 + t*ofs2 ;
    end;
    LeftLine2(pa,delta);
 finally
   delta.free;
 end;
end;

procedure tpa.ExpandEnds(d1,d2: tnum);//сдвиг концов, расширение при d>0
var a,b: tnum2;
begin
  if Count<=1 then exit;
  if d1<>0 then begin
    a:=P[0];
    v_expand(P[1], a, d1);
    P[0]:=a;
  end;
  if d2<>0 then begin
    b:=Last;
    v_expand(P[Count-2], b, d1);
    P[Count-1]:=b;
  end;
end;

procedure tpa.LineToArea(pa: tpa; _width: tnum; _expand: boolean);//clear pa
var pl_l,pl_r: tpa; d: tnum;
begin
  pa.clear;
  if (Count<=1) then exit;

  d:=abs(_width)/2;
  pl_l:=tpa.New;
  pl_r:=tpa.New;
  try
    LeftLine(pl_l, d);
    LeftLine(pl_r, -d);

    //расширение концов:
    if _expand then begin
      pl_l.ExpandEnds(d,d);
      pl_r.ExpandEnds(d,d);
    end;

    //pa:
    pa.AddFrom(pl_r);
    pa.AddFrom(pl_l.Reverse);
    pa.Close;//=>FModify
  finally
    pl_r.Free;
    pl_l.Free;
  end;
end;

function tpa.lsec_exists(a,b: tnum2; box: tnum4): boolean;
var ab,ba: tnum2;//вторая диагональ box
begin
  ab:=v_xy(box.b.x,box.a.y);//RtDn
  ba:=v_xy(box.a.x,box.b.y);//LtUp
  Result := v_sec_lv_exists(a,b, box.a,box.b) or v_sec_lv_exists(a,b, ab,ba);
end;

//pa.xp(x) = т.пересечения pa с линией (ab): x - первая вдоль ломаной:
function tpa.lsec1(a,b: tnum2; var t,x: tnum; box: tnum4; l: tnuma): boolean;
var i,secres: tint; tx: tnum;
begin
  Result:=false;
  if count=0 then exit;
  if not lsec_exists(a,b, box) then exit;
  if count=1 then begin Result:=true; x:=0; t:=v_lp(a,b,first); exit; end;//box.a=box.b

  if count>1 then for i:=0 to count-2 do begin
    secres:=v_sec_lv(a,b, p[i],p[i+1], t,tx);//включает v_sec_lv_exists(a,b, p1,p2)
    case secres of
      0: continue;
      1,-1: begin Result:=true; x:=tx*(l[i+1]-l[i])+l[i]; end;//tx=0..1
      2: begin Result:=true; x:=l[i]; end;//начало отрезка ломаной
    end;
    if Result then exit;//найдена первая точка пересечения
  end;
end;

//ближайшая к т. a точка пересечения с ориентацией:
function tpa.lsec2(a,b: tnum2; orient: tint; var t,x: tnum; box: tnum4; l: tnuma): boolean;
var i,secres,n: tint; tx,tl,dn,dist: tnum;
begin
  Result:=false;
  if count=0 then exit;
  if not lsec_exists(a,b, box) then exit;
  if count=1 then begin Result:=true; x:=0; t:=v_lp(a,b,first); exit; end;//box.a=box.b

  n:=0;//кол-во точек пер-ия:
  dist:=MaxInt;
  if count>1 then for i:=0 to count-2 do begin

    Result:=false;
    secres:=v_sec_lv(a,b, p[i],p[i+1], tl,tx);//включает v_sec_lv_exists(a,b, p1,p2)
    case secres of
       0:;
      -1: if orient<=0 then Result:=true;
       1: if orient>=0 then Result:=true;
       2:;
    end;//case

    if not Result then continue;

    inc(n);//=>n>=1
    dn:=v_dist(a, v_lt(a,b, tl));
    if (n>1) and (dn>=dist) then continue;

    t:=tl;
    x:=tx*(l[i+1]-l[i])+l[i];
    dist:=dn;

  end;//for i

  Result := n>0;
end;


end.
