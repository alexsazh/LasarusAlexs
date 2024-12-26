(*
  Функции вдоль 3D-линии
*)
unit llib3df; interface

uses nums, vlib, vlib3d, llib3d;


type
  TL3dFunc_Mode = byte;
(*
  0: t - прямая в плане
  1: t - кривая в плане
*)

  TL3dFunc = class
  private
    ta: tnuma;//0..1
    xa,ya: tnuma;
    za: tnuma;
    procedure _Create(pl3: tpl3d; _mode: TL3dFunc_Mode; a,b: tnum2);
  public
    //_mode: 0: t - прямая в плане; 1: t - кривая в плане:
    constructor Create(pl3: tpl3d; _mode: TL3dFunc_Mode); overload;
    //_mode=0; [a,b] - t-отрезок "рядом":
    constructor Create(pl3: tpl3d; a,b: tnum2); overload;
    destructor Destroy; override;
    //get_*: если a,b выходят за границы проекции pl3 - получим концевые точки:
    function get_z(at: double): double;//at: 0..1
    function get_p3(at: double): tnum3;//at: 0..1
  end;



implementation

uses wcmn;


{ TL3dFunc: }

procedure TL3dFunc._Create(pl3: tpl3d; _mode: TL3dFunc_Mode; a,b: tnum2);
var i: integer; t: double;
begin
  inherited Create;

  ta:=tnuma.New;//0..1
  za:=tnuma.New;
  xa:=tnuma.New;
  ya:=tnuma.New;

  //заполнение массивов ta,...:
  try
    t:=0;
    for i:=0 to pl3.Count-1 do begin

      if _mode=0 then t:=v_lp(a,b, pl3.pl[i])
      else
      if _mode=1 then t:=pl3.pl.Lena[i]/pl3.pl.Length
      else
      Tell('TL3dFunc._Create: unknown _mode');

      ta.Add(t);
      za.Add( pl3.ha[i] );
      xa.Add( pl3.pl[i].x );
      ya.Add( pl3.pl[i].y );
    end;//for i
  except
    Tell('EXCEPTION in TL3dFunc._Create');
  end;
end;

constructor TL3dFunc.Create(pl3: tpl3d; _mode: TL3dFunc_Mode);
var a,b: tnum2;
begin
  //if _mode=1, a,b не используются:
  if _mode=0 then begin
    a:=pl3.pl.First;
    b:=pl3.pl.Last;
  end;
  _Create(pl3, _mode, a,b);
end;

constructor TL3dFunc.Create(pl3: tpl3d; a,b: tnum2);
begin
  _Create(pl3, 0{_mode}, a,b);
end;

destructor TL3dFunc.Destroy;
begin
  ya.Free;
  xa.Free;
  za.Free;
  ta.Free;

  inherited Destroy;
end;

function TL3dFunc.get_z(at: double): double;
var az: double;
begin
  Result:=0;
  if ta.value(za, at, az) then Result:=az
  else Tell('ERROR in TWireFunc.get_z');
end;

function TL3dFunc.get_p3(at: double): tnum3;
var p3: tnum3;
begin
  if ta.value(xa, at, p3.p.x) and ta.value(ya, at, p3.p.y) and ta.value(za, at, p3.z)
  then Result:=p3
  else Tell('ERROR in TWireFunc.get_p3');
end;


end.
