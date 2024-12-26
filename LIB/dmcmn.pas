unit dmcmn;

//{$MODE Delphi}
{$mode objfpc}{$H+}
 interface

uses
  Otypes, Arrayx, Wcmn;//,  generics.collections, DynamicArray;


const
  MaxPolyCount=8000;


type
  TDmPoly = class;

  TDmPolyPointMode = (cmNone, cmStart, cmFinish, cmMiddle);

  //PLP: Point on Poly:
  TDmPolyPoint = class
  private
    Fx: longint; //x=-1: cmNone, x=0: cmStart, x=PL.Len: cmFinish, else: cmMiddle
//    FP: lPoint;
    function GetX: longint; //use Reversed
    procedure PutX(ax: longint); //=>P
    function GetP: lpoint;//PL.xPoint(Fx)
  public
    PL: TDmPoly;
    Reversed: boolean;//сравн. с PL.Reversed in Getx
    constructor Create;//x:=-1
    constructor CreateOnPoly(aPL:TDmPoly; ax: longint);
    procedure Reverse; //change Fx,P
    function ConnectStr: string;//No,S,F,M, A!(from PL.loc)
    function Mode: TDmPolyPointMode;

    property x: longint read GetX write Putx;
    property P: lpoint read GetP; //write - через property "x"!
  end;


  TDmPoly = class
  private
    _: TArray; //of lPoint, Count=PolyCount+1=poly^.n+2-;
    function GetCount: integer;
    procedure SetCount(aCount: integer);
    function GetMemory: plong; //@Point[0].x
    function GetPlLine: plline;
    function GetPoint(i: integer): lPoint;
    procedure SetPoint(i: integer; aPoint: lPoint); //without CalcLen!
    function GetFirst: lPoint;
    function GetLast: lPoint;
    function GetVector(i: integer): lVector;//i<=Count-2-первая точка
    function GetxPoint(x: longint): lPoint;
  public
    loc: byte;            //2:L; 3:A
    offs: integer;
    code: longint;
    A,B: lPoint;          //рамка: A=UpLeft, B=DownRight !

    h4: float;           //if loc<>1,3 then -MaxInt;
    Len: longint;        //after CalcLen!
    Reversed: boolean;   //procedure Reverse;
    Modified: boolean;   //точки (SetPoint)

    constructor Create(aCount: integer);
    destructor Destroy; override;
    procedure Clear;
    procedure CorrectBound(aPoint: lPoint);
    procedure CalcBound;
    function CalcLen: longint;
    function xLen: real;
    procedure Add(aPoint: lPoint);

    //если P вне рамки (A,B)+MaxDist then Result:=MaxInt:
    function DistFromPoint(P: lPoint; plp: TDmPolyPoint; MaxDist: longint): longint;
    procedure Proection(P: lPoint; plp: TDmPolyPoint);
    procedure Reverse;

    function SelectPoly: boolean; //указать на карте
    function PickPoly(closed: boolean): boolean; //нарисовать
    function GetFromDm: integer; //dmcmn_begin required
    procedure ShowOnDm(ViewScale: double);

    procedure AddSegment0(PL: TDmPoly; x1,x2: longint); //Add to Self; x2>x1
    procedure AddSegment(PL: TDmPoly; x1,x2: longint); //Add to Self

    function Centr: lPoint; //ср.арифм-ое точек
    procedure Uniform(PL2: TDmPoly; step: double);
    function Closed: boolean;

    property Point[Index: integer]: lPoint read GetPoint write SetPoint; default;
    property First: lPoint read GetFirst;
    property Last: lPoint read GetLast;
    property Vector[Index: integer]: lVector read GetVector;//Index=0..Count-2
    property Poly: plline read GetPlLine;
    property Count: integer read GetCount write SetCount;
    property Memory: plong read GetMemory; //Point[0].x
    property xPoint[x: longint]: lPoint read GetxPoint;
  end;


var lPoint00: lPoint; //initialization


//1S, 0F, 1M;  0S, 1F, 0M;  No;  1A!, 0A!:
function  dmcmn_ConnectStr(PLP: TDmPolyPoint; ConnectInd: integer): string;

function dmcmn_loc_S(loc: byte): string;
function dmcmn_active_map(msg: boolean): string;
function dmcmn_begin: boolean; //MSG
procedure dmcmn_end;
//function dmcmn_show_region(rgn: word; pl:plline; msg: boolean): boolean;
function dmcmn_get_name: string; //9-ая характеристика
function dmcmn_PolyMemSize(PointsCount: integer): cardinal;

{ IntGeometry: }

function dmcmn_BoundTest(A, B: lPoint): boolean;
function dmcmn_dist_PP(P1, P2: lPoint): longint;
//Result:=P1+t2*P2:
function dmcmn_add_PP(P1,P2: lPoint; t2: double): lPoint;
//A.x<B.x; A.y<B.y!:
function dmcmn_PInRect(P,A,B: lPoint; MaxDist: longint): boolean;
function dmcmn_VInRect(V: lVector; A,B: lPoint; MaxDist: longint): boolean;

//0<=x<=|V|; t=0 <=> P0-ближайшая; t=|V| <=> P1-ближайшая:
function dmcmn_dist_VP0(V: lVector; P: lPoint; var x: longint; var Px: lPoint): longint;
//Расширение: если P вне рамки V+MaxDist then Result:=MaxInt:
function dmcmn_dist_VP(V: lVector; P: lPoint; MaxDist: longint; var x: longint; var Px: lPoint): longint;
function dmcmn_dist_VV(V1: lVector; V2: lVector; MaxDist: longint; var x1: longint; var Px1: lPoint): longint;

//-----------------------------------------------------------------------

function dmcmn_scale(P1,P2: lPoint): real;
function dmcmn_vector(p1,p2: lpoint): lpoint; //p2-p1

function dmcmn_sec_VV(p1,p2: lpoint; q1,q2: lpoint; var px: lpoint): boolean;

//-----------------------------------------------------------------------

{ объекты на карте: }

function dmcmn_CurrentObject: longint;
function dmcmn_PickObjectOffs: longint;
//function dmcmn_show_region(rgn: word; pl:plline; msg: boolean): boolean; --------- OLD

{ единицы измерения: }

function m2dm(m: longint): longint; //метры->DM-координаты
function mm2dm(mm: real): longint; //миллиметры->DM-координаты

implementation


uses SysUtils, Forms, Dmw_ddw, Dmw_use;


{ TDmPolyPoint: }

Function TDmPolyPoint.GetX: longint;
begin
  if Fx>PL.Len then begin
    Tellf('WARNING in TDmPolyPoint.GetX:\nx(%d)>PL.Len(%d)',[Fx,PL.Len]);
    Fx:=PL.Len;
  end;
  if PL.Reversed<>Reversed then Reverse; {!}
  Result:=Fx;
end;

procedure TDmPolyPoint.PutX(ax: longint); //=>P
begin
  Fx:=ax;
//  FP:=PL.xPoint[Fx];
end;

function TDmPolyPoint.GetP: lpoint;//PL.xPoint(Fx)
begin
  Result:=PL.xPoint[Fx];
end;


constructor TDmPolyPoint.Create;//x:=-1
begin
  Fx:=-1;
end;

constructor TDmPolyPoint.CreateOnPoly(aPL:TDmPoly; ax: longint);
begin
  PL:=aPL;
  Reversed:=PL.Reversed;
  x:=ax; //PutX=>Fx,P
end;

procedure TDmPolyPoint.Reverse;
begin
  if Fx>=0 then Fx:=PL.Len-Fx;
  //FP:=PL.xPoint[Fx];
  Reversed:=not Reversed;
end;

function TDmPolyPoint.Mode: TDmPolyPointMode;
begin
  if PL.Reversed<>Reversed then Reverse; {!}

  if Fx<0 then Result:=cmNone
  else if Fx=0 then Result:=cmStart
  else if Fx>=PL.Len then Result:=cmFinish
  else Result:=cmMiddle;
end;

function TDmPolyPoint.ConnectStr: string;//No,S,F,M, A!(from PL.loc)
begin
  if PL.loc=2 then begin

    case Mode of
      cmNone:   Result:='No';
      cmStart:  Result:='S';
      cmFinish: Result:='F';
      cmMiddle: Result:='M';
    end;

  end else begin

    Result:=dmcmn_loc_s(PL.loc)+'!';

  end;
end;


{ TDmPoly: private }

function TDmPoly.GetCount: integer;
begin
  Result:=_.Count-1;
end;

procedure TDmPoly.SetCount(aCount: integer);
begin
  _.Count:=aCount+1;  //No CorrectBound
end;

function TDmPoly.GetMemory: plong;
begin
  PChar(Result) := _.Memory + _.ItemSize;
end;

function TDmPoly.GetPlLine: plline;
var p: ^SmallInt;
begin
  PChar(p) := _.Memory + ( _.ItemSize-sizeof(SmallInt) );
  p^ := SmallInt(GetCount-1);
  Result := plline(p);
end;

function TDmPoly.GetPoint(i: integer): lPoint;
begin
  _.Get(i+1, Result);
end;

//without CalcLen!
procedure TDmPoly.SetPoint(i: integer; aPoint: lPoint);
begin
  if (Point[i].x=aPoint.x) and (Point[i].y=aPoint.y) then exit;
  _.Put(i+1, aPoint);
  CorrectBound(aPoint);
  Modified:=true; {!}
end;

procedure TDmPoly.Add(aPoint: lPoint);
begin
  SetPoint(Count,aPoint);
end;

procedure TDmPoly.CorrectBound(aPoint: lPoint);
begin
  if aPoint.x<A.x then A.x:=aPoint.x;
  if aPoint.x>B.x then B.x:=aPoint.x;
  if aPoint.y<A.y then A.y:=aPoint.y;
  if aPoint.y>B.y then B.y:=aPoint.y;
end;

procedure TDmPoly.CalcBound;
var i: integer;
begin
  A:=Point[0];
  B:=Point[0];
  for i:=1 to Count-1 do CorrectBound(Point[i]);
end;

function TDmPoly.CalcLen: longint;
var i: integer; d: longint;
begin
  Result:=0;
  if Count>1 then for i:=1 to Count-1 do begin
    d:=dmcmn_dist_PP(Point[i-1], Point[i]);
    inc(Result, d);
  end;
  Len:=Result;{!}
end;

function TDmPoly.xLen: real;
var i: integer; d: real;
begin
  Result:=0;
  if Count>1 then for i:=1 to Count-1 do begin
    //d:=dmcmn_dist_PP(Point[i-1], Point[i]);
    d := sqrt( sqr(Point[i].x-Point[i-1].x) + sqr(Point[i].y-Point[i-1].y) );
    Result:=Result+d;
  end;
end;

function TDmPoly.GetFirst: lPoint;
begin
  _.Get(1, Result);
end;

function TDmPoly.GetLast: lPoint;
begin
  _.Get(_.Count-1, Result);
end;

function TDmPoly.GetVector(i: integer): lVector;
begin
  _.Get(i+1, Result[0]);
  _.Get(i+2, Result[1]);
end;


function TDmPoly.GetxPoint(x: longint): lPoint;
var i: integer; P0,P1,PV: lPoint; dx,dv: longint;
begin
  Result:=lPoint00; if Count=0 then exit;
  Result:=Point[0]; if Count=1 then exit;
  if x<=0 then exit;
  if x>=Len then begin Result:=Point[Count-1]; exit; end;

  dx:=0;
  P0:=Point[0];
  for i:=1 to Count-1 do begin
    P1:=Point[i];
    dv:=dmcmn_dist_PP(P0,P1);
    inc(dx,dv);

    //вектор найден:
    if dx>=x then begin
      PV:=dmcmn_add_PP(P1, P0, -1);
      dec(dx,dv);
      try
        if dv>0 then Result:=dmcmn_add_PP(P0, PV, (x-dx)/dv)
        else Result:=P0;
      except
        Result:=P0;
      end;
      exit;
    end;

    P0:=P1;//к след.вектору
  end;
end;

procedure TDmPoly.Uniform(PL2: TDmPoly; step: double);
var
  i: integer;
  //n: integer; //DEBUG
  dv,dx,dstep,t: real;
  P0,P1,PV,P2: lPoint;
begin
  PL2.Clear; if Count<1 then exit;
  PL2[0]:=Point[0]; if Count<2 then exit; //первая точка
  if Len=0 then CalcLen; if Len<step then exit;

  P0:=Point[0];
  dx:=0; //резерв линии
  dstep:=step; //остаток step с пред-го отрезка

  for i:=1 to Count-1 do begin

    P1:=Point[i];
    //PV:=dmcmn_add_PP(P1, P0, -1); //очередной отрезок
    PV.x:=P1.x-P0.x;
    PV.y:=P1.y-P0.y;
    //dv:=dmcmn_dist_PP(P0,P1);     //его длина
    dv := sqrt( sqr(PV.x) + sqr(PV.y) );
    dx:=dx+dv;

    //точки внутри отрезка:
    while dx>=dstep do begin
      dstep:=step;
      dx:=dx-dstep;
      try
        t:=(dv-dx)/dv; //расстояние от P0 - доля dv
        //if (t<0) or (t>1) then n:=0; //DEBUG
        P2:=dmcmn_add_PP(P0, PV, t);
        PL2.Add(P2);
      except ;
      end;
    end;

    //к след.отрезку (dx<dstep):
    P0:=P1;
    dstep:=dstep-dx;

  end;//for
end;


function TDmPoly.Closed: boolean;
begin
  Result:=false;
  if Count<2 then exit;
  Result := ( (Point[0].x=Point[Count-1].x)
          and (Point[0].y=Point[Count-1].y) );
end;


{ TDmPoly: public }

constructor TDmPoly.Create(aCount: integer);
begin
  h4:=-MaxInt;
  loc:=2;
  _:=TArray.Create(sizeof(lPoint), 10);
  SetCount(aCount);
end;

destructor TDmPoly.Destroy;
begin
  _.Free;
end;

procedure TDmPoly.Clear;
begin
  loc:=2;
  SetCount(0);
  A.x:=0; A.y:=0;
  B.x:=0; B.y:=0;
  Reversed:=false;
end;

function TDmPoly.DistFromPoint(P: lPoint; plp: TDmPolyPoint; MaxDist: longint): longint;
var
  i: integer; dist, dx, x: longint;
  V: lVector; Px: lPoint;
begin
  Result:=MaxInt;
  plp.PL:=Self;
  plp.Reversed:=Reversed;{!}
  plp.x:=-1;
  //plp.P:=P;
  dx:=0;

  if not dmcmn_PInRect(P,A,B,MaxDist) then exit;

  if Count>1 then begin

      for i:=0 to Count-2 do begin
        V:=Vector[i];
        dist:=dmcmn_dist_VP(V,P,MaxDist,x,Px);
        if dist<Result then begin
          Result:=dist;
          //plp.P:=Px;
          plp.x:=dx+x;
        end;
        dx:=dx+dmcmn_dist_PP(V[0], V[1]);
      end;

  end else begin

    Result:=dmcmn_dist_PP(Point[0], P);
    //plp.P:=Point[0];
    plp.x:=0;

  end;{if Count>1}
end;

procedure TDmPoly.Proection(P: lPoint; plp: TDmPolyPoint);
var
  i: integer; dist, d,dx, x,xres: longint;
  V: lVector; Px: lPoint;
begin
  plp.PL:=Self;
  plp.Reversed:=Reversed;{!}
  plp.x:=0;

  if Count<=1 then exit;

  dx:=0;
  xres:=0;
  d:=MaxInt;
  for i:=0 to Count-2 do begin
    V:=Vector[i];
    dist:=dmcmn_dist_VP0(V,P,x,Px);
    if dist<d then begin
      d:=dist;
      xres:=dx+x;
    end;
    dx:=dx+dmcmn_dist_PP(V[0], V[1]);
  end;

  plp.x:=xres;
end;


procedure TDmPoly.Reverse;
var i,j: integer;
begin
  i:=0;
  j:=Count-1;
  while i<j do begin
    _.Exchange(i+1, j+1);
    inc(i);
    dec(j);
  end;
  Reversed:=not Reversed;
end;

function TDmPoly.SelectPoly: boolean; //указать на карте
var OldFocus: TForm; objOffs: longint;
begin
  Result:=false;
  Clear;
  OldFocus:=Screen.ActiveForm; {save}
  if not dmw_SetFocus then exit;

  objOffs:=dmcmn_PickObjectOffs;
  if (objOffs>0) and dmcmn_begin then begin
    try
      if dm_Goto_node(objOffs) then begin
        GetFromDm;
        if Count>0 then Result:=true;
      end;
    finally
      dmcmn_end;
    end;
  end;

  OldFocus.SetFocus; {restore}
end;

function TDmPoly.PickPoly(closed: boolean): boolean;
var OldFocus: TForm;
begin
  Result:=false;
  Clear;
  OldFocus:=Screen.ActiveForm; {save}
  if not dmw_SetFocus then exit;

  SetCount(MaxPolyCount);
  if not closed then loc:=2 else loc:=3;
  Result:=dmw_PickPoly(closed, poly, MaxPolyCount-1);

  if Result then begin
    SetCount(poly^.n+1);
    CalcBound;
    CalcLen;
  end else begin
    Clear;
  end;

  OldFocus.SetFocus; {restore}
end;

function TDmPoly.GetFromDm: integer;
var n,n2: integer; AX,BX: lPoint;
begin
  Result:=0;
  Clear;

  loc:=dm_get_local;
  offs:=dm_object;
  code:=dm_get_code;
  if (loc<>2) and (loc<>3) then exit;  //!!!

  dm_Get_Bound(AX,BX);

  //коррекция:
  if dmcmn_BoundTest(AX,BX) then begin
    A:=AX;
    B:=BX;
  end else begin
    A.x:=mini(AX.x,BX.x);
    A.y:=mini(AX.y,BX.y);
    B.x:=maxi(AX.x,BX.x);
    B.y:=maxi(AX.y,BX.y);
  end;

  if (loc=2) or (loc=3) then begin

    n:=dm_Get_Poly_Count;
    if (n>=0) then begin
      SetCount(n+1);
      n2:=dm_Get_Poly_Buf(poly, n);
      if n2<>n then Tellf('ERROR in TDmPoly.LoadPoly:\ndm_Get_Poly_Count=%d\ndm_Get_Poly_Buf=%d',[n, n2]);
    end;

  end else begin

    SetCount(0);

  end;

  if not dm_get_real(4, 0, float(h4)) then h4:=-MaxInt;

  CalcLen;
  Result:=Count;
end;

procedure TDmPoly.ShowOnDm(ViewScale: double);
begin
  if not dmw_SetFocus then begin Tell('No map'); exit; end;
  if not dmw_ShowObject(offs, ViewScale) then Tell('No object');
end;


//------------------------------------------------------------------


//x2>x1:
procedure TDmPoly.AddSegment0(PL: TDmPoly; x1,x2: longint); //Add to Self
var
  i,n: integer; l: longint;
  p0,p1,px1,px2: lpoint;
begin
  n:=PL.Count;
  if n=0 then exit;

  if x1>x2 then exit;//!

  //концы сегмента:
  px1:=PL.xPoint[x1];
  px2:=PL.xPoint[x2];

  //сегмент:
  Add(px1);
  l:=0;
  if n>1 then for i:=0 to n-2 do begin
    p0:=PL[i];
    p1:=PL[i+1];
    inc(l, dmcmn_dist_PP(p0,p1));
    if (l>x1) and (l<x2) then Add(p1);
  end;
  Add(px2)
end;

procedure TDmPoly.AddSegment(PL: TDmPoly; x1,x2: longint); //Add to Self
var
  i,n: integer; l: longint;
  p0,p1,px1,px2: lpoint;
begin
  n:=PL.Count;
  if n=0 then exit;

  if x2>=x1 then begin

    AddSegment(PL,x1,x2);

  end else begin

    PL.CalcLen;
    AddSegment(PL,x2,PL.Len);

    if PL.Closed then PL._.Delete(PL._.Count-1);
    AddSegment(PL,0,x1);

  end;


  //концы сегмента:
  px1:=PL.xPoint[x1];
  px2:=PL.xPoint[x2];

  //сегмент:
  Add(px1);
  l:=0;
  if n>1 then for i:=0 to n-2 do begin
    p0:=PL[i];
    p1:=PL[i+1];
    inc(l, dmcmn_dist_PP(p0,p1));
    if (l>x1) and (l<x2) then Add(p1);
  end;
  Add(px2)
end;


function TDmPoly.Centr: lPoint; //ср.арифм-ое точек
var i: integer; x,y: longint;
begin
  Result:=lPoint00;

  x:=0;
  y:=0;
  if Count>0 then for i:=0 to Count-1 do begin
    inc(x, Point[i].x);
    inc(y, Point[i].y);
  end;

  Result.x:=Round(x/Count);
  Result.y:=Round(y/Count);
end;



//------------------------------------------------------------------


{ functions: }

function  dmcmn_ConnectStr(plp: TDmPolyPoint; ConnectInd: integer): string;
begin
  Result:='';
  Result:=Result+IntToStr(ConnectInd);
  Result:=Result+plp.ConnectStr;
end;

function dmcmn_loc_S(loc: byte): string;
begin
  case loc of
   0: Result:='M';
   1: Result:='S';
   2: Result:='L';
   3: Result:='A';
   4: Result:='T';
   else Result:='?';
  end;
end;

function dmcmn_active_map(msg: boolean): string;
var namemap: TChars;
begin
  Result:='';
  dmw_ActiveMap(@namemap[0], 255);
  Result:=StrPas(@namemap[0]);
  //Result:=wcmn_dos2win(Result);
  if (Length(Result)=0) and msg then Tell('No active map');
end;

function dmcmn_begin: boolean;
var namemap: string; res: integer;
begin
  Result:=false;
  namemap:=dmcmn_active_map(true);
  if Length(namemap)=0 then exit;

  //if dmw_HideMap then res:=dm_Open( @namemap[1], true);
  //Result:=(res>0);

  res:=dmw_Open( @namemap[1], true);
  Result:=(res>=0);

  if not Result then begin
    try
      dmw_Done;
      res:=dmw_Open( @namemap[1], true);
      Result:=(res>=0);
    except ;
    end;
  end;

  if not Result then begin
    Tellf('Error in open "%s"',[namemap]);
  end;

  //Result:=true; //???
end;

procedure dmcmn_end;
begin
  //dm_Done;
  //if not dmw_BackMap then Tell('ERROR in dmw_BackMap');
  dmw_Done;
end;

(*
function dmcmn_show_region(rgn: word; pl:plline; msg: boolean): boolean;
label
  lend;
var
  OldFocus: TForm;
begin
  Result:=false;
  if rgn>4 then exit;

  OldFocus:=Screen.ActiveForm; {save}

  try

  PL^.n:=1;  {2 точки}
  case rgn of
    0:{вся карта}
    begin
      result:=true;
    end;
    1:{прямоугольник}
    begin
      if msg then Tell('Укажите прямоугольник');
      dmw_SetFocus;
      result:=dmw_PickRect(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[1].x,PL^.pol[1].y);
    end;
    2:{круг}
    begin
      if msg then Tell('Укажите круг');
      dmw_SetFocus;
      result:=dmw_PickRing(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[1].x);
    end;
    3:{полигон}
    begin
      if msg then Tell('Укажите полигон');
      dmw_SetFocus;
      PL^.n:=-1;  {нет точек}
      result:=dmw_PickPoly(true,pl,8000);
    end;
    4:{объект}
    begin
      result:=false;
      Tell('Регион типа 4 ("объект") не обрабатывается');
    end;{4:}
  end;{case}

  finally
    OldFocus.SetFocus; {restore}
  end;{try}
end;
*)
function dmcmn_get_name: string;
var s: ShortString;
begin
  Result:='';
  try
    if not dm_Get_String(9, 255, s) then s:='';
  except
    s:='';
  end;
  Result:=wcmn_dos2win(s);
end;

function dmcmn_PolyMemSize(PointsCount: integer): cardinal;
begin
  Result := sizeof(SmallInt) + PointsCount*sizeof(lPoint);
end;


{ IntGeometry: }

function dmcmn_BoundTest(A, B: lPoint): boolean;
begin
  Result:=true;
  if (A.x>B.x) or (A.y>B.y) then Result:=false;
end;

function dmcmn_dist_PP(P1, P2: lPoint): longint;
var dist, dx, dy: Extended;
begin
  dx:=P2.x-P1.x;
  dy:=P2.y-P1.y;
  dist := sqrt( dx*dx + dy*dy );
  Result := Round( dist );
end;

function dmcmn_add_PP(P1,P2: lPoint; t2: double): lPoint;
begin
  Result.x := Round( P1.x + t2*P2.x );
  Result.y := Round( P1.y + t2*P2.y );
end;


function dmcmn_PInRect(P,A,B: lPoint; MaxDist: longint): boolean;
begin
  Result:=false;

  try
    if (P.x<A.x-MaxDist) and (P.x<B.x-MaxDist) then exit;
    if (P.x>B.x+MaxDist) and (P.x>A.x+MaxDist) then exit;
    if (P.y<A.y-MaxDist) and (P.y<B.y-MaxDist) then exit;
    if (P.y>B.y+MaxDist) and (P.y>A.y+MaxDist) then exit;
  except ;
  end;

  Result:=true;;
end;


function dmcmn_VInRect(V: lVector; A,B: lPoint; MaxDist: longint): boolean;
begin
  Result:=false;
  if (V[0].x<A.x-MaxDist) and (V[1].x<A.x-MaxDist) then exit;
  if (V[0].y<A.y-MaxDist) and (V[1].y<A.y-MaxDist) then exit;
  if (V[0].x>B.x-MaxDist) and (V[1].x>B.x-MaxDist) then exit;
  if (V[0].y>B.y-MaxDist) and (V[1].y>B.y-MaxDist) then exit;
  Result:=true;;
end;


function dmcmn_dist_VP0(V: lVector; P: lPoint; var x: longint; var Px: lPoint): longint;
var P0,P1,V01,V0P: lPoint; d01: longint;
begin
  P0:=V[0];
  P1:=V[1];
  Px:=P0;
  x:=0;
  d01:=dmcmn_dist_PP(P0,P1);
  V01:=dmcmn_add_PP(P1,P0,-1);
  V0P:=dmcmn_add_PP(P,P0,-1);

  if d01=0 then begin Result:=dmcmn_dist_PP(P0,P); exit; end;
  try
    x:=Round(dmcmn_scale(V01,V0P)/d01); //длина проекции V0P на V01

    if x<=0 then begin x:=0; Px:=P0; end
    else if x>=d01 then begin x:=d01; Px:=P1; end
    else Px:=dmcmn_add_PP(P0,V01,x/d01);

    Result:=dmcmn_dist_PP(Px,P);
  except
    Px:=P0;
    x:=0;
    Result:=dmcmn_dist_PP(P0,P);
  end;
end;

function dmcmn_dist_VP(V: lVector; P: lPoint; MaxDist: longint; var x: longint; var Px: lPoint): longint;
begin
  Result:=MaxInt;
  x:=0;

  if not dmcmn_PInRect(P,V[0],V[1],MaxDist) then exit;
  Result:=dmcmn_dist_VP0(V,P,x,Px);
end;

function dmcmn_dist_VV(V1: lVector; V2: lVector; MaxDist: longint; var x1: longint; var Px1: lPoint): longint;
var d01,dx: longint;
begin
  Result:=MaxInt;
  x1:=0;
  Px1:=V1[0];

  d01:=dmcmn_dist_PP(V1[0],V1[1]);
  if d01=0 then begin
    Result:=dmcmn_dist_VP(V2,V1[0],MaxDist,x1,Px1);
    exit;
  end;

  if not dmcmn_VInRect(V2,V1[0],V1[1],MaxDist) then exit;

  dx:=d01;
  while dx>0 do begin



  end;{while d>0}


end;


//-----------------------------------------------------------------------


function dmcmn_scale(P1,P2: lPoint): real;
begin
  Result := P1.x*P2.x + P1.y*P2.y;
end;

function dmcmn_vector(p1,p2: lpoint): lpoint;
begin
  Result.x:=p2.x-p1.x;
  Result.y:=p2.y-p1.y;
end;

function dmcmn_sec_VV(p1,p2: lpoint; q1,q2: lpoint; var px: lpoint): boolean;
var
  sc,scp,cfi,sfi,cfip,sfip,lx: double;
  vp,vq,vpq: lpoint;
  dp,dq,dpq: integer;
begin
  Result:=true;
  px:=p1;

  //1:
  vp:=dmcmn_vector(p1,p2);
  vq:=dmcmn_vector(q1,q2);
  dp:=dmcmn_dist_PP(p1,p2);
  dq:=dmcmn_dist_PP(q1,q2);

  vpq:=dmcmn_vector(p1,q1);
  dpq:=dmcmn_dist_PP(p1,q1);

  if dpq<2 then exit; //p=q=x - true

  //2:
  sc:=dmcmn_scale(vp,vq);
  try
    cfi:=sc/(dp*dq);
    sfi:=sqrt(1-sqr(cfi));
    if sfi<0.000001 then Result:=false;
  except
    Result:=false;
  end;

  if not Result then exit; // vp||vq - false

  //3:
  scp:=dmcmn_scale(vpq,vp);
  try
    cfip:=scp/(dpq*dp);
    sfip:=sqrt(1-sqr(cfip));
    if sfip<0.000001 then Result:=false;
  except
    Result:=false;
  end;

  if not Result then begin // x=q1 on Lvp - true
    Result:=true;
    px:=q1;
    exit;
  end;

  //4:
  try
    lx:=(dpq/sfi)*sfip;
    px.x:=Round( p1.x+(vp.x/dp)*lx );
    px.y:=Round( p1.y+(vp.y/dp)*lx );
  except
    Tell('ERROR 1 in dmcmn_sec_VV');
  end;
end;


//-----------------------------------------------------------------------


function dmcmn_CurrentObject: longint;
var loc: byte; offs,Code,x1,y1,x2,y2: longint; name: array[0..255]of Char;
begin
  dmw_OffsObject(offs,Code, loc, x1,y1,x2,y2, name, 255);
  Result:=offs;
  //if Result<=0 then Tell('Объект не указан');
end;

function dmcmn_PickObjectOffs: longint;
var loc: byte; offs,Code,x1,y1,x2,y2: longint; name: array[0..255]of Char;
begin
  Result:=0;
  if dmw_PickObject(offs,Code, loc, x1,y1,x2,y2, @name[0], 255)
    then Result:=offs;
    //else Tell('Объект не указан');
end;


(*
function dmcmn_show_region(rgn: word; pl:plline; msg: boolean): boolean;
label
  lend;
var
  OldFocus: TForm;
begin
  Result:=false;
  if rgn>4 then exit;

  OldFocus:=Screen.ActiveForm; {save}

  try

  PL^.n:=1;  {2 точки}
  case rgn of
    0:{вся карта}
    begin
      result:=true;
    end;
    1:{прямоугольник}
    begin
      if msg then Tell('Укажите прямоугольник');
      dmw_SetFocus;
      result:=dmw_PickRect(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[1].x,PL^.pol[1].y);
    end;
    2:{круг}
    begin
      if msg then Tell('Укажите круг');
      dmw_SetFocus;
      result:=dmw_PickRing(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[1].x);
    end;
    3:{полигон}
    begin
      if msg then Tell('Укажите полигон');
      dmw_SetFocus;
      PL^.n:=-1;  {нет точек}
      result:=dmw_PickPoly(true,pl,8000);
    end;
    4:{объект}
    begin
      result:=false;
      Tell('Регион типа 4 ("объект") не обрабатывается');
    end;{4:}
  end;{case}

  finally
    OldFocus.SetFocus; {restore}
  end;{try}
end;
*)


{ единицы измерения: }

function m2dm(m: longint): longint; //метры->DM-координаты
begin
  Result:=0;
  if not dmcmn_begin then exit;
  try
    Result:=Round(m/dm_Resolution);
  finally
    dmcmn_end;
  end;
end;

function mm2dm(mm: real): longint; //миллиметры->DM-координаты
var m: longint;
begin
  Result:=0;
  if not dmcmn_begin then exit;
  try
    m:=Round(dm_Scale*mm/1000);
    Result:=Round(m/dm_Resolution);
  finally
    dmcmn_end;
  end;
end;


initialization
  lPoint00.x:=0;
  lPoint00.y:=0;



end.
