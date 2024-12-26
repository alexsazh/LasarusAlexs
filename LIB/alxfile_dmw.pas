unit alxfile_dmw; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  llib, llibx, llib3d,
  alw_use,
  alxblock;


type
  TAlxFile = class
  private
    FOk: boolean;//file opened
    FFileName: string;
    FBlkCount: integer;//кол-во блоков
    FBlk: TAlxBlk;//блок
  public
    constructor Create;
    destructor Destroy; override;//if Ok then Close
    procedure Open(aFileName: string);//=>Ok=true
    procedure Close;//=>Ok=false

    //if Ok:
    procedure ShowInfo;//Show FormAlx
    procedure LoadBlk(aBlkInd: integer);

    //Расстояния:
    procedure NearestPoint(pl3: tpl3d; aBoxDelta: double; aPointCode: integer);

    //DrawOnDm (карта закрыта):
    procedure DrawOnDm_Blocks;
    procedure DrawOnDm_BlocksCenters(_Ave: boolean);
    procedure DrawOnDm_Points(aPointCode: integer);

    property Ok: boolean read FOk;
    property BlkCount: integer read FBlkCount;
  end;

var ALX: TAlxFile;//initialization/finalization


type
  //Info:
  TFormAlx = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
  end;

var FormAlx: TFormAlx;


implementation

uses
  dmlib,
  wcmn, runline, vlib, vlib3d;

{$R *.dfm}


{ TAlxFile: }

constructor TAlxFile.Create;
begin
  FBlk:=TAlxBlk.Create;
end;

destructor TAlxFile.Destroy;//if Ok then Close
begin
  Close;
  FBlk.Free;
end;

procedure TAlxFile.Open(aFileName: string);//=>Ok
begin
  Close;
  FOk:=alx_open(Pchar(aFileName));
  if FOk then begin
    FFileName:=aFileName;
    FBlkCount:=alx_Get_BlockCount;

  end;//if FOk
  ShowInfo;//=>Clear!
end;

procedure TAlxFile.Close;
begin
  if FOk then alx_close;
  FOk:=false;
end;


procedure TAlxFile.ShowInfo;
begin
  FormAlx.Memo1.Clear;
  FormAlx.Caption:='';
  if not FOk then exit;//!

  FormAlx.Caption:=FFileName;
  with FormAlx.Memo1 do begin
    Lines.Add( Format('Кол-во блоков: %d',[FBlkCount]) );

  end;//with
  FormAlx.Show;
end;

procedure TAlxFile.LoadBlk(aBlkInd: integer);
begin
  if FOk then FBlk.Load(aBlkInd);
end;


procedure TAlxFile.NearestPoint(pl3: tpl3d; aBoxDelta: double; aPointCode: integer);

  function _Create_pl3_rect2d(var _AreaSide: boolean): tpl;//uses pl3,aBoxDelta
  var a,b,pc,vdir: tnum2; w,h: double;
  begin
    Result:=tpl.New;

    a:=pl3.pl.First;
    b:=pl3.pl.Last;
    pc:=v_lt(a,b,0.5);
    vdir:=v_sub(b,a);

    w:=2*aBoxDelta;
    h:=2*aBoxDelta+v_dist(a,b);

    Result.AddRect_cv(pc,vdir, w,h);
    if Result.Count>3 then _AreaSide:=Result.ConvexAreaSide;
  end;

var
  i: integer; pl3_v_min: tpl3d;
  d,dmin: double; p,pmin,p2: tnum3;
//  x1,y1,x2,y2: double;
//  win: tnum4;
  pl3_rect2d: tpl; _AreaSide: boolean;
begin
  if not FOk then begin Tell('Файл точек не открыт'); exit; end;//!
  if pl3.Count<=0 then exit;

  dmin:=-1;
  RunForm.Start('Ближайшая точка');
  SetWaitCursor;
  pl3_v_min:=tpl3d.Create;
  pl3_rect2d:=_Create_pl3_rect2d(_AreaSide);
  try
    //win:=v_box2( x1,y1, x2,y2, false );
    //win:=v_xbox(pl3.pl.Box.a,pl3.pl.Box.b, aBoxDelta);

    //рисование pl3_rect2d:
    dmwlib_draw_plgauss(pl3_rect2d, 2, 5);

      if (pl3_rect2d.Count=5) and (FBlkCount>0) then for i:=0 to FBlkCount-1 do begin
      //if FBlkCount>0 then for i:=1107 to 1107 do begin//DEBUG (aPointCode=5)

        RunForm.Go(i/FBlkCount);
        if RunForm.Cancelled then break;
        LoadBlk(i);//=>FBlk

        if v_boxes_sec(pl3_rect2d.Box, FBlk.Box2D) then
          //if FBlk.NearestPointInBox(pl3, win, aPointCode, d, p) then
          if FBlk.NearestPointInRect(pl3, pl3_rect2d, _AreaSide, aPointCode, d, p) then
            if (dmin<0) or ((d>0) and (dmin>d)) then begin
              dmin:=d;
              pmin:=p;
            end;

      end;//for i

      if dmin>=0 then begin
        pl3.DistFromPoint(pmin, p2);
        pl3_v_min.Add(p2);
        pl3_v_min.Add(pmin);
        dmwlib_draw_plgauss(pl3_v_min.pl, 2, 5);
      end;
  finally
    pl3_rect2d.Free;
    pl3_v_min.Free;
    SetDefCursor;
    RunForm.Finish;

    d := v3_dist(pmin.p.x,pmin.p.y,pmin.z, p2.p.x,p2.p.y,p2.z);//DEBUG
    if dmin>=0 then Tellf('Расстояние: %.2f (%.2f) м',[dmin,d])
    else Tell('Нет точек');
  end;
end;


/////////////////////// DrawOnDm: ///////////////////////////

procedure TAlxFile.DrawOnDm_Blocks;
var i: integer; x1,y1,x2,y2: double; win: tnum4;
begin
  if not FOk then begin Tell('Файл точек не открыт'); exit; end;//!
  RunForm.Start('Блоки файла .alx');
  SetWaitCursor;
  try
    if DMWGetWindowGauss(x1,y1,x2,y2) then begin
      win:=v_box2( x1,y1, x2,y2, false );
      if FBlkCount>0 then for i:=0 to FBlkCount-1 do begin
        RunForm.Go(i/FBlkCount);
        if RunForm.Cancelled then break;
        LoadBlk(i);//=>FBlk
        FBlk.DrawOnDm_Rect(3, win);
      end;//for i
    end;//if DMWGetWindowGauss
  finally
    SetDefCursor;
    RunForm.Finish;
  end;
end;

procedure TAlxFile.DrawOnDm_BlocksCenters(_Ave: boolean);

  procedure _Draw(pl: tpl);
  begin
    if pl.Count=0 then exit;
    dmwlib_draw_plgauss(pl, 2, 5);
    pl.Clear;
  end;

var
  i: integer; x1,y1,x2,y2: double; p: tnum2; win: tnum4; pl: tpl;
//  _pout: boolean; pout: tnum2;
begin
  if not FOk then begin Tell('Файл точек не открыт'); exit; end;//!
  RunForm.Start('Центры блоков файла .alx');
  SetWaitCursor;
  pl:=tpl.New;
  try
//    _pout:=false;//!
    if DMWGetWindowGauss(x1,y1,x2,y2) then begin
      win:=v_box2( x1,y1, x2,y2, false );
      if FBlkCount>0 then for i:=0 to FBlkCount-1 do begin
        RunForm.Go(i/FBlkCount);
        if RunForm.Cancelled then break;
        LoadBlk(i);//=>FBlk
        p:=FBlk.Center2D[_Ave];
(*
        if v_inbox(p, win) then begin
          if (pl.Count=0) and (_pout=true) then pl.Add(pout);
          _pout:=false;
          pl.Add(p);
        end else begin
          _pout:=true;
          pout:=p;
          if pl.Count>0 then pl.Add(p);//!
          _Draw(pl);//=>pl.Clear!
        end;
*)
        pl.Add(p);
      end;//for i
    end;
  finally
    _Draw(pl);//перед pl.Free!
    pl.Free;
    SetDefCursor;
    RunForm.Finish;
  end;
end;

procedure TAlxFile.DrawOnDm_Points(aPointCode: integer);
var i,nb,n: integer; x1,y1,x2,y2: double; win: tnum4; ObjDirName: string;
begin
  n:=0;
  if not FOk then begin Tell('Файл точек не открыт'); exit; end;//!

  RunForm.Start('Точки с кодом');
  SetWaitCursor;
  try
    if DMWGetWindowGauss(x1,y1,x2,y2) then begin
      if dmw_HideMap then begin
        ObjDirName:=DmObjDirName(DMW.ActiveMap);
        dmw_BackMap;
      end else
        ObjDirName:='';
      win:=v_box2( x1,y1, x2,y2, false );
      if FBlkCount>0 then for i:=0 to FBlkCount-1 do begin
        RunForm.Go(i/FBlkCount);
        if RunForm.Cancelled then break;
        LoadBlk(i);//=>FBlk
        nb:=FBlk.DrawOnDm_Points(aPointCode, win, ObjDirName);
        inc(n,nb);
      end;//for i
    end;
  finally
    SetDefCursor;
    RunForm.Finish;
    Tellf('Точек с кодом %d: %d',[aPointCode, n]);
  end;
end;


///////////////////////////////////////////////////////////////////////////////

{ TFormAlx: }

procedure TFormAlx.FormCreate(Sender: TObject);
begin
  Ini.RForm(Self);
end;

procedure TFormAlx.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);
end;


initialization
  ALX:=TAlxFile.Create;

finalization
  ALX.Free;

end.
