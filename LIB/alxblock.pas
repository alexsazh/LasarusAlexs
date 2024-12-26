unit alxblock; interface

uses
  alw_use,
  vlib, llib, llibx,
  vlib3d, llib3d;


type
  //PPointItem = ^TPointItem;

  TAlxBlk0 = class
  private
    FInd: integer;//индекс блока
    FPointBlock: TPointBlock;//alw_use
    FPointCount: longint;//Load
    FPointItem0: PPointItem;//первая точка (Load)
    FPointItemLen: integer;//Load - размер меньше, есле нет интенсивностей (alx_Is_Intense)
    function GetCenter2D(_Ave: boolean): tnum2;
    function GetBox2D: tnum4;

    //Point:
    function Get_PPointItem(aInd: integer): PPointItem;
    function GetPointCode(aInd: integer): integer;
    function GetPoint2D(aInd: integer): tnum2;
    function GetPoint3D(aInd: integer): tnum3;
  public
    procedure Load(aInd: integer);//.alx открыт
    function GetPoint3DCode(aInd: integer; var PointCode: integer): tnum3;

    //Расстояние:
    function NearestPointInBox(pl3: tpl3d; aBox: tnum4; aPointCode: integer; var d: double; var p: tnum3): boolean;
    function NearestPointInRect(pl3: tpl3d; aRect: tpl; _AreaSide: boolean; aPointCode: integer; var d: double; var p: tnum3): boolean;

    property Center2D[_Ave: boolean]: tnum2 read GetCenter2D;
    property Box2D: tnum4 read GetBox2D;
    property Point2D[aInd: integer]: tnum2 read GetPoint2D;
    property Point3D[aInd: integer]: tnum3 read GetPoint3D;
  end;


implementation

uses wcmn;


{ TAlxBlk: }

procedure TAlxBlk0.Load(aInd: integer);
begin
  FInd:=aInd;
  FPointItem0:=alx_Get_Block(aInd, @FPointBlock);
  FPointCount:=FPointBlock.N_block;

  if alx_Is_Intense
    then FPointItemLen:=sizeof(TPointItem)
    else FPointItemLen:=sizeof(TPointItem) - sizeof(Byte);//нет интенсивностей

  if not Assigned(FPointItem0) then Tellf('TAlxBlk.Load(%d): FPointItem0=NIL',[aInd]);//нет точек
end;

function TAlxBlk0.GetCenter2D(_Ave: boolean): tnum2;
begin
  if _Ave then begin
    Result.x:=FPointBlock.X_ave;
    Result.y:=FPointBlock.Y_ave;
  end else begin
    Result.x:=(FPointBlock.X_min+FPointBlock.X_max)/2;
    Result.y:=(FPointBlock.Y_min+FPointBlock.Y_max)/2;
  end;
end;

function TAlxBlk0.GetBox2D: tnum4;
begin
  Result.a.x := FPointBlock.X_min;
  Result.a.y := FPointBlock.Y_min;
  Result.b.x := FPointBlock.X_max;
  Result.b.y := FPointBlock.Y_max;
end;


function TAlxBlk0.NearestPointInBox(pl3: tpl3d; aBox: tnum4; aPointCode: integer; var d: double; var p: tnum3): boolean;
var i: integer; pp,pp_prj: tnum3; dd: double;
begin
  Result:=false;

  if FPointCount>0 then for i:=0 to FPointCount-1 do begin
    if GetPointCode(i)<>aPointCode then continue;
    pp:=GetPoint3D(i);

    if not v_inbox(pp.p, aBox) then continue;

    dd:=pl3.DistFromPoint(pp, pp_prj);
    if not Result or (Result and (dd<d)) then begin
      Result:=true;
      d:=dd;
      p:=pp;
    end;
  end;//for i
end;

function TAlxBlk0.NearestPointInRect(pl3: tpl3d; aRect: tpl; _AreaSide: boolean; aPointCode: integer; var d: double; var p: tnum3): boolean;
var i: integer; pp,pp_prj: tnum3; dd: double;
begin
  Result:=false;

  if FPointCount>0 then for i:=0 to FPointCount-1 do begin
    if GetPointCode(i)<>aPointCode then continue;
    pp:=GetPoint3D(i);

    //if not v_inbox(pp.p, aBox) then continue;
    if not v_inbox(pp.p, aRect.Box) then continue;
    if not aRect.PointInConvex(pp.p, _AreaSide, true) then continue;

    dd:=pl3.DistFromPoint(pp, pp_prj);
    if not Result or (Result and (dd<d)) then begin
      Result:=true;
      d:=dd;
      p:=pp;
    end;
  end;//for i
end;


////////////////// POINT: ////////////////////////

function TAlxBlk0.Get_PPointItem(aInd: integer): PPointItem;
begin
  PChar(Result) := PChar(FPointItem0) + aInd*FPointItemLen;
end;


function TAlxBlk0.GetPointCode(aInd: integer): integer;
begin
  Result:=Get_PPointItem(aInd)^.cod;
end;

function TAlxBlk0.GetPoint2D(aInd: integer): tnum2;
var aPPointItem: PPointItem;
begin
  aPPointItem:=Get_PPointItem(aInd);
  Result.x := FPointBlock.X_ave + aPPointItem^.x/100;
  Result.y := FPointBlock.Y_ave + aPPointItem^.y/100;
end;

function TAlxBlk0.GetPoint3D(aInd: integer): tnum3;
var aPPointItem: PPointItem;
begin
  aPPointItem:=Get_PPointItem(aInd);
  Result.p.x := FPointBlock.X_ave + aPPointItem^.x/100;
  Result.p.y := FPointBlock.Y_ave + aPPointItem^.y/100;
  Result.z   := FPointBlock.Z_ave + aPPointItem^.z/100;
end;

function TAlxBlk0.GetPoint3DCode(aInd: integer; var PointCode: integer): tnum3;
var aPPointItem: PPointItem;
begin
  aPPointItem:=Get_PPointItem(aInd);
  Result.p.x := FPointBlock.X_ave + aPPointItem^.x/100;
  Result.p.y := FPointBlock.Y_ave + aPPointItem^.y/100;
  Result.z   := FPointBlock.Z_ave + aPPointItem^.z/100;
  PointCode  := aPPointItem^.cod;
end;


end.
