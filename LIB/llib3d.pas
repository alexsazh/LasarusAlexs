(*
  Все коорд-ты и расстояния - в метрах
  Дырки (Next) - в части ф-ий (Destroy,Clear)
*)
unit llib3d; interface

uses nums, vlib, llib, llibx, vlib3d;

type
  tpl3d = class
  private
    Fpl: tpl;//Fpl без дырок, дырки - через Next
    Fha: tnuma;
  protected
    function GetCount: longint;
    procedure SetCount(aCount: longint);
    function GetPoint(i: integer): tnum3;
    function GetFirst: tnum3;
    function GetLast: tnum3;
  public
    Next: tpl3d;//дырки
    constructor Create; //overload;
    destructor Destroy; override;
    procedure Clear;
    function Point(i: integer; var x,y,z: double): boolean;//try..except
    procedure Reverse;

    function Add(x,y,z: double): integer; overload;//return count-1
    function Add(p3: tnum3): integer; overload;//return count-1
    procedure AddFrom(pl3: tpl3d);

    function Length: double;
    function iofp(p3: tnum3): integer;//ближайшая вершина

    //РАССТОЯНИЯ: default=-1 (!!!):
    //_bypoints - ускорение, когда Self "близка к прямой":
    //DistFromPoint_bypoints - по точкам + ДВА СОСЕДНИХ ОТРЕЗКА:
    function DistFromPoint(p: tnum3; var p_prj: tnum3): double;//default=-1
    function DistFromPoint_bypoints(p: tnum3; var p_prj: tnum3): double;//default=-1
    function DistFrom_pl3(pl3: tpl3d; var p1,p2: tnum3): double;//default=-1, p1 on Self
    //function DistFrom_pl3_bypoints(pl3: tpl3d; pl3_step: double; var p1,p2: tnum3): double;//default=-1, p1 on Self

    function MaxDistFromLine(a,b: tnum3; var p_prj: tnum3): double;//default=-1

    procedure LeftLine  (pl3: tpl3d; ofs: tnum);//clear pl3
    procedure LineToArea(pl3out: tpl3d; _width: tnum);//clear pl3

    property Count: integer read GetCount write SetCount;
    property _[i: integer]: tnum3 read GetPoint; default;
    property First: tnum3 read GetFirst;
    property Last: tnum3 read GetLast;
    property pl: tpl read Fpl;
    property ha: tnuma read Fha;
  end;



implementation

uses

//  dmlib3d,//DEBUG!!!                                             //DEBUG

  wcmn;


{ tpl3d: }

constructor tpl3d.Create;
begin
  Fpl:=tpl.New;
  Fha:=tnuma.New;
end;

destructor tpl3d.Destroy;
begin
  Next.Free;//уничтожение дырок (рекурсия)
  Fha.Free;
  Fpl.Free;
end;

procedure tpl3d.Clear;
begin
  Fpl.Clear;
  Fha.Clear;
  Next.Free;//уничтожение дырок
  Next:=nil;//!
end;

function tpl3d.GetCount: longint;
begin
  Result:=Fpl.Count;
end;

procedure tpl3d.SetCount(aCount: longint);
begin
  Fpl.Count:=aCount;
  Fha.Count:=aCount;
end;

function tpl3d.Add(x,y,z: double): integer;//return count-1
begin
  Fpl.Add(v_xy(x,y));
  Result:=Fha.Add(z);
end;

function tpl3d.Add(p3: tnum3): integer;//return count-1
begin
  Fpl.Add( p3.p );
  Result:=Fha.Add(p3.z);
end;

function tpl3d.Point(i: integer; var x,y,z: double): boolean;
begin
  Result:=true;
  try
    x:=FPl[i].x;
    y:=FPl[i].y;
    z:=Fha[i];
  except
    Result:=false;
  end;
end;

function tpl3d.GetPoint(i: integer): tnum3;
begin
  Result.p:=FPl[i];
  Result.z:=Fha[i];
end;

function tpl3d.GetFirst: tnum3;
begin
  Result.p:=FPl.First;
  Result.z:=FHa.First;
end;

function tpl3d.GetLast: tnum3;
begin
  Result.p:=FPl.Last;
  Result.z:=FHa.Last;
end;


procedure tpl3d.Reverse;
begin
  pl.Reverse;
  ha.Reverse;
end;


procedure tpl3d.AddFrom(pl3: tpl3d);
begin
  pl.AddFrom(pl3.pl);
  ha.AddFrom(pl3.ha);
end;


function tpl3d.Length: double;
var i: integer;
begin
  Result:=0;
  if Count>=2 then for i:=0 to Count-2 do begin
    Result := Result + v3_dist(GetPoint(i), GetPoint(i+1));
  end;//for i
end;


function tpl3d.iofp(p3: tnum3): integer;
var i: integer; dmin,di: double;
begin
  Result:=-1;//default

  dmin:=-1;//default
  if Count>0 then for i:=0 to Count-1 do begin
    di:=v3_dist(p3, _[i]);
    if (di>=0) and ( (dmin<0) or (di<dmin) ) then begin
      dmin:=di;
      Result:=i;
    end;
  end;//for i
end;


///////////////// DistFrom...:

type
  t_dmin_rec = record
    d: double;//default = -1
    p: tnum3;
    i: integer;//default = -1, //может не использоваться
  end;
var _dmin_rec: t_dmin_rec;

procedure _dmin_set(d: double; p: tnum3; i: integer; var admin_rec: t_dmin_rec);
begin
  admin_rec.d:=d;
  admin_rec.p:=p;
  admin_rec.i:=i;
end;

procedure _dmin_test_begin(var admin_rec: t_dmin_rec);//d:=-1
begin
  _dmin_set(-1{d}, v3_num3_000{p}, -1{i}, admin_rec);
end;

function _dmin_test(d{m.b.<0}: double; p: tnum3; i: integer; var admin_rec: t_dmin_rec): boolean;
begin
  Result:=false;//default
  if (d>=0) and ( (admin_rec.d<0) or (d<admin_rec.d) ) then begin
    Result:=true;
    _dmin_set(d, p, i, admin_rec);
  end;
end;


function tpl3d.DistFromPoint(p: tnum3; var p_prj: tnum3): double;
var i: integer; d: double; a,b,p2: tnum3;
begin
  _dmin_test_begin(_dmin_rec);//!
  try
    if Count=1 then begin
      _dmin_rec.p:=GetPoint(0);
      _dmin_rec.d:=v3_dist(p, _dmin_rec.p);
      _dmin_rec.i:=0;
    end
    else if Count>1 then for i:=0 to Count-2 do begin
      a:=GetPoint(i);
      b:=GetPoint(i+1);
      d:=v3_vp_dist(a,b, p, p2);
      _dmin_test(d, p2, i, _dmin_rec);//->_dmin_rec
    end;//for i
  finally
    Result:=_dmin_rec.d;
    p_prj:=_dmin_rec.p;
  end;
end;


function tpl3d.DistFromPoint_bypoints(p: tnum3; var p_prj: tnum3): double;
var i,i0: integer; d: double; q,px: tnum3;
begin
  _dmin_test_begin(_dmin_rec);//!
  try
    //ближайшая точка линии:
    if Count>0 then for i:=0 to Count-1 do begin
      q:=_[i];
      d:=v3_dist(p,q);
      _dmin_test(d, q, i, _dmin_rec);//->_dmin_rec
    end;//for i

    //2 соседних отрезка:
    if (Count>1){!} and (_dmin_rec.d>=0) then begin
      i0:=_dmin_rec.i;//запомним индекс точки!
      if i0>0 then begin
        i:=i0-1;//=> отрезок ПЕРЕД точкой _[i0]!
        d:=v3_vp_dist(_[i],_[i+1], p, px);
        _dmin_test(d, px, i, _dmin_rec);//->_dmin_rec (d,p,i)
      end;
      if i0<Count-1 then begin
        i:=i0;//=> отрезок ПОСЛЕ точки _[i0]!
        d:=v3_vp_dist(_[i],_[i+1], p, px);
        _dmin_test(d, px, i, _dmin_rec);//->_dmin_rec (d,p,i)
      end;
    end;
  finally
    Result:=_dmin_rec.d;
    p_prj:=_dmin_rec.p;
  end;
end;


function tpl3d.DistFrom_pl3(pl3: tpl3d; var p1,p2: tnum3): double;//default=-1, p1 on Self
var i1,i2: integer; d: double; a1,b1,a2,b2,prj1,prj2: tnum3;
begin
  Result:=-1;//default
  if Count<=0 then EXIT;//!
  if pl3.Count<=0 then EXIT;//!

  //Count>0, pl3.Count>0:
  p1:=_[0];
  p2:=pl3[0];
  Result:=v3_dist(p1,p2);//default

  //Count=1 or pl3.Count=1:
  if Count=1 then Result:=pl3.DistFromPoint(p1,p2);
  if pl3.Count=1 then Result:=DistFromPoint(p2,p1);
  if (Count=1) or (pl3.Count=1) then EXIT;//!

  //Count>1, pl3.Count>1:
  //ПЕРЕБОР ПАР ОТРЕЗКОВ:
  //Result определён:
  for i1:=0 to Count-2{отрезки} do begin
    a1:=_[i1];
    b1:=_[i1+1];
    for i2:=0 to pl3.Count-2{отрезки} do begin
      a2:=pl3[i2];
      b2:=pl3[i2+1];

      d:=v3_vv_dist(a1,b1, a2,b2, prj1,prj2);//m.b.<0
(*
      //DEBUG:
      if (d>=0) then begin                                               //DEBUG
        if dml3_set_layer(1{code}, false{clear})>0
        then dml3_ab_add(1{code}, prj1,prj2, true{_down});
      end;
*)
      if (d>=0) and (d<Result) then begin//Result определён
        p1:=prj1;
        p2:=prj2;
        Result:=d;//!
      end;//d<Result

    end;//for i2
  end;//for i1
end;

(*
function tpl3d.DistFrom_pl3_bypoints(pl3: tpl3d; pl3_step: double; var p1,p2: tnum3): double;//By points(!), p1 on Self

  procedure _two_segments(i1,i2: integer; var admin_rec: t_dmin_rec);//=>p1,p2
  var d: double; p1x,p2x: tnum3;
  begin
    d := v3_dist_vv_step2(_[i1],_[i1+1], pl3[i2],pl3[i2+1], pl3_step, p1x,p2x);
    if _dmin_test(d, p2x{on pl3}, i1{on Self}, admin_rec) then begin
      p1:=p1x;//!
      p2:=p2x;//!
    end;
  end;

var i1,i2: integer; d: double; p2x: tnum3; dmin_rec2: t_dmin_rec;
begin
  Result := -1;//!
  _dmin_test_begin(dmin_rec2);//!
  try
    i2:=-1;//!
    if Count>0 then for i1:=0 to Count-1 do begin
      d := pl3.DistFromPoint(GetPoint(i1), p2x{on pl3});//uses _dmin_rec!
      if _dmin_test(d, p2x{on pl3}, i1{on Self}, dmin_rec2) then i2:=_dmin_rec.i;//->_dmin_rec
    end;//for i

    //Result, p1,p2 (!!!):
    Result := dmin_rec2.d;//!
    if Result>=0 then begin
      p1 := GetPoint(dmin_rec2.i);
      p2 := dmin_rec2.p;
    end;
            //Result := v3_dist(p1,p2);//DEBUG

    //2*2=4 соседних отрезка -> p1,p2 (!!!):
    if (Count>1){!} and (pl3.Count>1) and (Result>=0){!} and (i2>=0){!} then begin
      if dmin_rec2.i>0 then begin
        i1:=dmin_rec2.i-1;//!
        if i2>0 then _two_segments(i1,i2-1, dmin_rec2);
            //Result := v3_dist(p1,p2);//DEBUG

        if i2<pl3.Count-1 then _two_segments(i1,i2, dmin_rec2);//=>p1,p2
            //Result := v3_dist(p1,p2);//DEBUG
      end;
      if dmin_rec2.i<Count-1 then begin
        i1:=dmin_rec2.i;//!
        if i2>0 then _two_segments(i1,i2-1, dmin_rec2);
            //Result := v3_dist(p1,p2);//DEBUG

        if i2<pl3.Count-1 then _two_segments(i1,i2, dmin_rec2);//=>p1,p2
            //Result := v3_dist(p1,p2);//DEBUG
      end;
    end;
  finally
    //p1,p2 -> Result (!!!):
    if Result>=0 then Result := v3_dist(p1,p2);//!
  end;
end;
*)

function tpl3d.MaxDistFromLine(a,b: tnum3; var p_prj: tnum3): double;
var i: integer; d: double; p,p2: tnum3;
begin
  Result:=-1;//default
  if Count<=0 then exit;

  p_prj:=GetPoint(0);
  if Count>0 then for i:=0 to Count-1 do begin
    p:=GetPoint(i);
    d:=v3_vp_dist(a,b,p, p2);
    if (Result<0) or (d>Result) then begin
      Result:=d;
      p_prj:=p;
    end;
  end;//for i
end;

procedure tpl3d.LeftLine(pl3: tpl3d; ofs: tnum);//clear pl3
var i: integer;
begin
  //pl3.pl:
  pl.LeftLine(pl3.pl, ofs);

  //pl3.ha:
  pl3.ha.Count:=pl3.pl.Count;
  if pl3.ha.Count>0 then for i:=0 to pl3.ha.Count-1 do pl3.ha[i]:=ha[i];
end;

procedure tpl3d.LineToArea(pl3out: tpl3d; _width: tnum);//clear pl3
var pl_l,pl_r: tpl3d; d: tnum;
begin
  pl3out.clear;
  if (Count<=1) then exit;//!

  d:=abs(_width)/2;
  pl_l:=tpl3d.Create;
  pl_r:=tpl3d.Create;
  try
    LeftLine(pl_l, d);
    LeftLine(pl_r, -d);

    //pl3:
    pl3out.AddFrom(pl_r);
    pl_l.Reverse;//!
    pl3out.AddFrom(pl_l);

    pl3out.Add(pl3out.First);//Close, pl3out.count>=4
  finally
    pl_r.Free;
    pl_l.Free;
  end;
end;


end.
