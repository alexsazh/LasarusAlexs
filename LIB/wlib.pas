(*
  TWorld,TWorldi - системы координат
*)
unit wlib; interface

uses
  Types{TRect},
  nums, vlib;


type
  TWorld = class
  protected
    FLeftTop: tnum2;
    FWidth, FHeight: tnum;
  public
    constructor Create(aLeftTop: tnum2; aWidth, aHeight: tnum); overload;
  end;

  TWorldi = class
  protected
    FLeftTop: TPoint;
    FWidth, FHeight: integer;
    function GetRightBottom: TPoint;
  public
    constructor Create(aLeftTop: TPoint; aWidth, aHeight: integer); overload;
    constructor Create(aRect: TRect); overload;

    //(0,0)->FLeftTop, (1,1)->RightBottom:
    function X_From01(x01: tnum): integer;
    function Y_From01(y01: tnum): integer;
    function Point_From01(p01: tnum2): TPoint;
    function Rect_From01(LeftTop01,RightBottom01: tnum2): TRect;


    property LeftTop: TPoint read FLeftTop;
    property RightBottom: TPoint read GetRightBottom;
  end;


implementation


{ TWorld: }

constructor TWorld.Create(aLeftTop: tnum2; aWidth, aHeight: tnum);
begin
  FLeftTop:=aLeftTop;
  FWidth:=aWidth;
  FHeight:=aHeight;
end;


{ TWorldi: }

constructor TWorldi.Create(aLeftTop: TPoint; aWidth, aHeight: integer);
begin
  FLeftTop:=aLeftTop;
  FWidth:=aWidth;
  FHeight:=aHeight;
end;

constructor TWorldi.Create(aRect: TRect);
begin
  FLeftTop:=aRect.TopLeft;
  FWidth:=aRect.Right-aRect.Left;
  FHeight:=aRect.Bottom-aRect.Top;
end;

function TWorldi.GetRightBottom: TPoint;
begin
  Result.X:=FLeftTop.X+FWidth;
  Result.Y:=FLeftTop.Y+FHeight;
end;

function TWorldi.X_From01(x01: tnum): integer;
begin
  Result := FLeftTop.X + Round( FWidth*x01 );
end;
function TWorldi.Y_From01(y01: tnum): integer;
begin
  Result := FLeftTop.Y + Round( FHeight*y01 );
end;
function TWorldi.Point_From01(p01: tnum2): TPoint;
begin
  Result.X:=X_From01(p01.x);
  Result.Y:=Y_From01(p01.y);
end;
function TWorldi.Rect_From01(LeftTop01,RightBottom01: tnum2): TRect;
begin
  Result.TopLeft:=Point_From01(LeftTop01);
  Result.BottomRight:=Point_From01(RightBottom01);
end;


end.
