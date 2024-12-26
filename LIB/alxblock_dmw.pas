unit alxblock_dmw; interface

uses
  alw_use,
  vlib, llib, llibx,
  vlib3d, llib3d,
  alxblock;


type
  PPointItem = ^TPointItem;

  TAlxBlk = class(TAlxBlk0)
  private
  public
    //DrawOnDm (карта закрыта):
    procedure DrawOnDm_Rect(gr: longint; win: tnum4);
    function DrawOnDm_Points(aPointCode: integer; win: tnum4; ObjDirName: string): longint;
  end;


implementation

uses
  Otypes, dmw_dde,
  dmwlib, dmlib,
  wcmn;


{ TAlxBlk: }

procedure TAlxBlk.DrawOnDm_Rect(gr: longint; win: tnum4);
var pl: tpl;
begin
  //рамка:
  if
    (FPointBlock.X_min>win.b.x) or
    (FPointBlock.Y_min>win.b.y) or
    (FPointBlock.X_max<win.a.x) or
    (FPointBlock.Y_max<win.a.y)
  then exit;//!

  pl:=tpl.New;
  try
    pl.AddRect( FPointBlock.X_min,FPointBlock.Y_min, FPointBlock.X_max,FPointBlock.Y_max );
    dmwlib_draw_plgauss(pl, 2, gr);
  finally
    pl.Free;
  end;
end;

function TAlxBlk.DrawOnDm_Points(aPointCode: integer; win: tnum4; ObjDirName: string): longint;
var i: integer; p: tnum2; lp: lpoint; fname: string;
begin
  Result:=0;

  //рамка:
  if
    (FPointBlock.X_min>win.b.x) or
    (FPointBlock.Y_min>win.b.y) or
    (FPointBlock.X_max<win.a.x) or
    (FPointBlock.Y_max<win.a.y)
  then exit;//!

  fname := ObjDirName + '.PGM' + #0;
  try
    if FPointCount>0 then for i:=0 to FPointCount-1 do begin

      if (aPointCode>=0) and (GetPointCode(i)<>aPointCode) then continue;

      p:=GetPoint2D(i);
      if v_inbox(p, win) then begin
        lp:=Num2GaussToLp(p, false);
        if dmw_DrawPgm( lp.x,lp.y, 1, @fname[1] ) then ;
        inc(Result);
      end;

    end;//for i
  finally
  end;
end;

end.
