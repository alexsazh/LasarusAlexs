{
   Движение 2D + 3D(if used), координаты Гауссовы:
   TMovPos, tMovObj, tMovPic

   РЕГИСТРАЦИЯ:
   Terra3D.exe /regserver (вызвать из каталога "3D")
   RegSvr32 c:\neva\3d\o3d_ocx.ocx

   ФЛАГИ: flags.pas(!)

прямоугольник: pps=0: метры Гаусса:
procedure dmw_Show_Gauss(lt_x,lt_y,rb_x,rb_y: Double; pps: Integer);

линия: show=1 => Show, show=0 => Hide:
procedure dmw_ext_Draft(x1,y1,x2,y2, show: Integer);
}
unit dmmovlib; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  otypes,
  nums, vlib, list, llibx, matx, dmlib, dmlibx,
  dmpiclib, terra3dlib_tlb, DBCtrls{3d};


type
  TScene3Dx = TScene3D;//COM-object from Terra3D.exe

  tMovObj = class;

  TMovMarker = class
  private
    FMO: tMovObj;
    FDMO: tdmox;//точка маркера
  public
    time: TDateTime;
    x: tnum;//положение на цепочке линий
    constructor Create(aMO: tMovObj; aTime: TDateTime; aDMO: tdmox);//x вычисляется
    destructor Destroy; override;

    property DMO: tdmox read FDMO;
    property MO: tMovObj read FMO;
  end;

  TMovMarkers = class(tclasslist{!})//of TMovMarker
  private
    function Get(i: integer): TMovMarker;
  public
    procedure Sort;
    function Add(m: tobject): integer;
    property Items[i: integer]: TMovMarker read Get; default;
  end;

  tMovPic = class;

  //движение объекта TDmDraw по пути FTrace (координаты Гауссовы):
  //жизнь 3D-объекта: Create_3D, Free_3D, PlaceOn3D(FPos)
  tMovObj = class(TDmDraw)
  protected
    F2DID: integer;//DmOffset: после создания dm-объекта в Create_2D
    F3DID: integer;//после создания 3D-объекта в Create_3D
    F3DFlags: integer;//после создания 3D-объекта в Init3D
    FPic: tMovPic;//картинка, в к-ую включается объект
    FTraceInds: tinta;//участки пути (индексы массива FPic.FTraces)
    {!}FTraceLength: double;//суммарная длина пути!
    FPosBeg: TPos2D;//начальная привязка FDMO, меняется в OnChangeFirstTrace(!)
    FPos: TPos2D;//текущая позиция на карте (TPos2D - matx)
    Fx: tnum;//текущая позиция на маршруте
    //FDmPoly: pLLine;//для быстрого Draw (pos_to_dmpoly)
    FTmpPl: tpl;//pos_to_tmppl => PlaceOn2D, PlaceOn3D
    FTimeBeg, FTimeEnd: TDateTime;//время начала и конца пути
    FMarkers: TMovMarkers;
    function _3DOk: boolean;//FPic.F3DOk & F3DID>0
    procedure OnChangeFirstTrace;//=>FPosBeg,FPos,Fx
    //{3D}procedure SetVisible(aVisible: boolean); override;
    procedure points_to_tmppl; virtual;//FDMO.Points -> FTmpPl
    procedure pos_to_tmppl; virtual;//FPos,FPosBeg -> FTmpPl
    //procedure Draw(aVgmName: PChar); override;//в тек-ей позиции FPos (uses FVisible)
    procedure PlaceOn2D; virtual;////карта открыта! (2d-ОТОБРАЖЕНИЕ)
    procedure PlaceOnLine(pl: tpl; ax: tnum);//if pl<>nil then pos_to_tmppl else points_to_tmppl
    //поиск позиции:
    function get_traceind_by_x(x: tnum): integer;
    function get_x_by_p(p0: tnum2): tnum;
    function GetLinePositionByTime(aTime: TDateTime; var pl: tpl; var x: tnum): boolean;//aTime in %(!)
  public
    constructor Create0(aPic: tMovPic; aDMO: TDmOx);//без отображения
    constructor Create(aPic: tMovPic; aDMO: TDmOx; aTraceInd: integer);//отображение, м.б. aTraceInd<0(!)
    destructor Destroy; override;
    procedure ShowFirstTime; virtual;//_2DOpened(!), Create_2D+Create_3D+PlaceOnPoints
    procedure Create_2D; virtual;//_2DOpened(!), =>F2DID, просто создание (без отображения)
    {3D}procedure Create_3D; virtual;//=>F3DID, просто создание (без отображения)
    procedure Free_3D;
    {3D}procedure PlaceOn3D; virtual;//3d-ОТОБРАЖЕНИЕ
    procedure SetTimes(aTimeBeg, aTimeEnd: TDateTime);
    procedure PlaceByTime(aTime: TDateTime);//aTime in [FTimeBeg, FTimeEnd]; call PlaceOnLine

    //aTraceInd - индекс массива FPic.FTraces (элемент массива FTraceInds):
    function AddTrace(aTraceInd: integer): tdmox; virtual;
    function FindTraceInd(aTrace: tdmox): integer;//index in FTraceInds
    procedure RemoveTrace(aTrace: tdmox);
    function GetTrace(aTraceInd: integer; var xTrace: tdmox): boolean;//xTrace:=FPic[aTraceInd]
    function Trace_ID1000(aTraceInd: integer): integer;//from FDMO: tdmox

    //карта закрыта, time=0{!}:
    function AddMarkerFromOfs(ofs: integer): TMovMarker;

    property _2DID: integer read F2DID write F2DID;
    property _3DID: integer read F3DID;
    property Pic: tMovPic read FPic;
    property Pos: TPos2D read FPos write FPos;
    property TraceInds: tinta read FTraceInds;
    property TimeBeg: TDateTime read FTimeBeg write FTimeBeg;
    property TimeEnd: TDateTime read FTimeEnd write FTimeEnd;
    property Markers: TMovMarkers read FMarkers;
    property TraceLength: double read FTraceLength;
  end;

  Type_DmPath =  array [0..1023] of char;

  //картинка - список движений:
  tMovPic = class(TDmPic)
  protected
    FScnDmPath: string;//карта загрузки текущей сцены (Create_2D)
    FPlayDmPath: Type_DmPath;//PChar: временная карта 2D-движения (Create_2D)
    FPlayDms: array[1..3]of Type_DmPath;//переключаемые временные карты 2D-движения
    F2DOpened: boolean;//true: FPlayDmPath-карта открыта (открывается и закрывается по таймеру)
    F2DOk: boolean;//FPlayDmPath создана (Create_2D)
    FTraces: tclasslist;//of tdmox
    FDmCamera: tdmox;//положение текущей 3d-камеры на карте PlayDm
    F3d: TScene3Dx;//COM-object (terra3dlib_tlb.pas, Terra3D.exe, Terra3D.tlb(type library))
    F3DOk: boolean;//Asiigned(F3d)
    function Get(i: integer): tMovObj;
    function GetTrace(i: integer): tdmox;
    procedure SetDmCameraCode(aCode: longint);
  public
    constructor Create(aPlayDmPath: string; aDmCameraCode: longint);
    destructor Destroy; override;
    procedure Clear;
    procedure ShowFirstTimeList_Show;

    function Create_2D(aDmFileName: string): boolean;//=>FPlayDmPath - пустая копия dmfname
    procedure Free_2D;//удаление карты движения FPlayDmPath из проекта

    function MoveDm_Open: boolean;//F2DOpened=true, dm_open(FPlayDmPath)
    procedure MoveDm_Close;//F2DOpened=false, dm_done on FPlayDmPath

    procedure OnTimer(aTime: TDateTime);
    procedure DmCamera_Draw;//PlayDm открыта!
    procedure DmCamera_Free;//PlayDm закрыта!

    procedure Create_3D(aCfgPath: string);//F3d: path='' => 3D не используется
    procedure Free_3D;//F3d: Disconnect, Free;

    //nil, если ID уже есть:
    function AddObjectFromOfs(ofs: integer): TMovObj;//карта закрыта

    //Result>=0 всегда(!), если aTrace.ID есть, то [aTrace.Free, aTrace меняется(!)]:
    function AddTrace(var aTrace: tdmox): integer;
    function AddTraceFromOfs(ofs: integer): integer;//карта закрыта

    property Items[i: integer]: tMovObj read Get; default;
    property ScnDmPath: string read FScnDmPath write FScnDmPath;
    property Trace[Index: integer]: tdmox read GetTrace;
    property _2DOpened: boolean read F2DOpened;
    property _2DOk: boolean read F2DOk;
    property _3DOk: boolean read F3DOk;
    property _3d: TScene3Dx read F3d;
    property DmCamera: tdmox read FDmCamera;
    property DmCameraCode: longint write SetDmCameraCode;
  end;


var
  ShowFirstTimeList: TPtrList;//для отложенного отображения в 2D,3D


type
  TFrmMov = class(TForm)
  private
  protected
  public
  end;

var
  FrmMov: TFrmMov;


implementation

{$R *.DFM}

uses
  dmw_dde, dmw_use, main,
  wcmn, dmwlib, input, lib3d,
  flags{3D-флаги}, timex, opt;


{ TMovMarker: }

constructor TMovMarker.Create(aMO: tMovObj; aTime: TDateTime; aDMO: tdmox);
begin
  inherited Create;
  FMO:=aMO;
  time:=aTime;
  FDMO:=aDMO;
  if Assigned(FMO) and Assigned(FDMO) then x:=FMO.get_x_by_p(FDMO.Points.First);
end;

destructor TMovMarker.Destroy;
begin
  FDMO.Free;
  inherited Destroy;
end;


{ TMovMarkers: }

function TMovMarkers.Get(i: integer): TMovMarker;
begin
  tobject(Result) := inherited Get(i);
end;

procedure TMovMarkers.Sort;
var tt: tnuma; i: integer;
begin
  if count<2 then exit;

  tt:=tnuma.New;
  try
    for i:=0 to count-1 do tt.Add( Items[i].time );
    tt.Sort(Self);
  finally
    tt.Free;
  end;
end;

function TMovMarkers.Add(m: tobject): integer;
begin
  Result := inherited Add(m);
  Sort;//!
end;


{ tMovObj: }

constructor tMovObj.Create0(aPic: tMovPic; aDMO: TDmOx);//без отображения
begin
  inherited Create(aPic, aDMO);
  FPic:=aPic;//требуется, т.к. теперь FPic типа tMovPic(!)

  FTraceInds:=tinta.New;

  //время:
  FTimeBeg:=0;
  FTimeEnd:=1/24;//1 час - default
  FMarkers:=TMovMarkers.New;

  FTmpPl:=tpl.New;
end;

procedure tMovObj.ShowFirstTime;
begin
  if FPic._2DOpened then begin
    Create_2D;//=>F2DID, просто создание (без отображения)
    Create_3D;//=>F3DID, просто создание (без отображения)
    PlaceOnLine(nil, 0);//отображение OnPoints
  end;
end;

constructor tMovObj.Create(aPic: tMovPic; aDMO: TDmOx; aTraceInd: integer);
begin
  Create0(aPic, aDMO);
  AddTrace(aTraceInd);//=>FPos,FPosBeg
  ShowFirstTimeList.Add(Self);//запоминание
end;

destructor tMovObj.Destroy;
begin
  Free_3D;

  if (F2DID>0) and FPic.MoveDm_Open then try try
    dm_delete_object(0, F2DID);
  finally
    F2DID:=0;//!
    FPic.MoveDm_Close;
  end;
  except
  end;

  FTmpPl.Free;
  FMarkers.Free;
  FTraceInds.Free;

  inherited Destroy;
end;

procedure tMovObj.Create_2D;//=>F2DID, просто создание (без отображения)
var ofs0: integer;
begin
  if F2DID>0 then
    Tellf('tMovObj.Create_2D: повтор 2D-инициализации ID=%d (%s)',[F2DID, FDMO.SCode]);

  F2DID:=-1;//default
  if FPic._2DOpened then begin
    ofs0:=FDMO.dmoffset;//save
    F2DID:=FDMO.Add(false);
    FDMO.dmoffset:=ofs0;//restore
  end;
end;

procedure tMovObj.Create_3D;//=>F3DID
begin
  if F3DID>0 then
    Tellf('tMovObj.Create_3D: повтор 3D-инициализации ID=%d (%s)',[F3DID, FDMO.SCode]);

  F3DID:=-1;//default
  F3DFlags:=0;//default
  if not FPic._3DOk then exit;

  case FDMO.Loc of

  0: ;//!

  1://ЗНАКИ:
    begin
      if (FDMO.H700=1) and (FDMO.H702>0) then try
        F3DID:=FPic.F3d.CreateVGMObject(FDMO.H702);
      except
        F3DID:=-1;
        Tellf('Ошибка генерации 3D VGM-модели "%d".',[FDMO.H702]);
      end;
      if (FDMO.H700=2) and (FDMO.H702>0) then try
        F3DID:=FPic.F3d.CreateLibObject(FDMO.H702);
      except
        F3DID:=-1;
        Tellf('Ошибка генерации 3D-модели "%d".',[FDMO.H702]);
      end;
    end;

  2,3://ЛИНИИ/ОБЛАСТИ:
    if (FDMO.H700=2) or (FDMO.H700=3) then try
      if FDMO.Loc=2 then F3DFlags:=MOT_LINE else F3DFlags:=MOT_POLY;
      inc(F3DFlags, MOT_REL);//высота - от рельефа
      if (FDMO.H702>=0) then inc(F3DFlags, MOT_ROOF);
      if (FDMO.H703>=0) then inc(F3DFlags, MOT_WALL);
      if (FDMO.H700=2) and (FDMO.H702>0) then inc(F3DFlags, MOT_ROOF_TEXTURE);
      if (FDMO.H700=2) and (FDMO.H703>0) then inc(F3DFlags, MOT_WALL_TEXTURE);

      F3DID:=FPic.F3d.CreateMOObject(F3DFlags);
    except
      F3DID:=-1;
      Tellf('Ошибка 3D-генерации линии [%s-%d].',[FDMO.sCode, FDMO.Loc]);
    end;

  4: ; //ТЕКСТЫ

  else//case
    Tellf('tMovObj.Create_3D: Локализация %d в 3D не обрабатывается.',[FDMO.Loc]);
  end;//case
end;

procedure tMovObj.Free_3D;
begin
  if not _3DOk then exit;
  case FDMO.Loc of
    0: ;
    1:
      if FDMO.H700=1 then FPic.F3D.DeleteVGMObject(F3DID)
      else FPic.F3D.DeleteLibObject(F3DID);
    2,3:
      FPic.F3D.DeleteMOObject(F3DID);
    4: ;
  end;//case
  F3DID:=-1;//!
end;


function tMovObj._3DOk: boolean;
begin
  Result := FPic.F3DOk and (F3DID>0);
end;
(*
procedure tMovObj.SetVisible(aVisible: boolean);
begin
  inherited SetVisible(aVisible);
  if not _3DOk then exit;

  case FDMO.Loc of
  0: ;//!
  1:
    begin
      if FDMO.H700=1 then
        if aVisible then FPic.F3d.ShowVGMObject(F3DID)
        else FPic.F3d.HideVGMObject(F3DID);
      if FDMO.H700=2 then
        if aVisible then FPic.F3d.ShowLibObject(F3DID)
        else FPic.F3d.HideLibObject(F3DID);
    end;
  2,3:
    if aVisible then FPic.F3d.ShowMOObject(F3DID)
    else FPic.F3d.HideMOObject(F3DID);
  4: ;
  else
    Tellf('tMovObj.SetVisible: Локализация %d в 3D не обрабатывается.',[FDMO.Loc]);
  end;//case
end;
*)
procedure tMovObj.OnChangeFirstTrace;
var xTrace: tdmox;
begin
  if (FTraceInds.Count>0) and GetTrace(FTraceInds.First, xTrace) then begin
    FPos.p := xTrace.Points.x_p_fi(Fx, xTrace.Points.Lena, FPos.fi);
    FPosBeg := FPos;//для линий
    //PlaceOnLine(xTrace.Points, 0);//PlaceOn2D нельзя!
  end;
end;

function tMovObj.AddTrace(aTraceInd: integer): tdmox;
var xTrace: tdmox;
begin
  Result:=nil;
  if GetTrace(aTraceInd, xTrace) and (FTraceInds.IndexOf(aTraceInd)<0) then begin
    FTraceInds.Add(aTraceInd);
    FTraceLength:=FTraceLength+xTrace.Points.Length;//!
    Result:=xTrace;
  end;

  //первый участок:
  if Assigned(Result) and (FTraceInds.Count=1) then OnChangeFirstTrace;
end;

function tMovObj.FindTraceInd(aTrace: tdmox): integer;
var i: integer;
begin
  Result:=-1;
  if FTraceInds.Count>0 then for i:=0 to FTraceInds.Count-1 do begin
    if FPic.FTraces[ FTraceInds[i] ] = aTrace then begin
      Result:=i;
      break;
    end;
  end;
end;

procedure tMovObj.RemoveTrace(aTrace: tdmox);
begin
  FTraceInds.Delete( FindTraceInd(aTrace) );
end;


procedure tMovObj.points_to_tmppl;//FDMO.Points -> FTmpPl
begin
  FTmpPl.Clear;
  if FDMO.Points.Count<=0 then exit;
  FTmpPl.AddFrom(FDMO.Points);
  case FDMO.Loc of
    1,4:
    begin
      if FTmpPl.Count=1 then FTmpPl.Add(FTmpPl.First);
    end;
  end;//case
end;

procedure tMovObj.pos_to_tmppl;//FPos,FPosBeg -> FTmpPl
var pa,pb: tnum2; mat: TMatrix; v: tnum2;
begin
  FTmpPl.Clear;
  if FDMO.Points.Count<=0 then exit;

  case FDMO.Loc of
    0: ;
    1:
    begin
      pa := FPos.p;
      v := v_xy(100, 0);//базовое направление (м)
      v := v_rot(v, FPos.fi);
      pb := v_add(pa, v);
      FTmpPl.Add(pa);
      FTmpPl.Add(pb);
    end;
    2,3:
    begin
      mat:=m_pos2(FPosBeg, FPos);
      FDMO.Points.Transform(@mat, FTmpPl);
    end;
    4: ;
  end;//case
end;

procedure tMovObj.PlaceOn2D;//карта открыта!
var lpa,lpb: lpoint; xDmPoly: PLline;
begin
  //if not FVisible then exit;
  if FPic._2DOpened and (F2DID>0) then try
    //dm_jump_node(F2DID);
    //if dm_object = F2DID then
    if dm_goto_node(F2DID) then

      case FDMO.Loc of
        0: ;
        1:
        begin
          lpa:=Num2GaussToLp(FTmpPl[0], true);
          lpb:=Num2GaussToLp(FTmpPl[1], true);
          dm_set_bound(lpa, lpb);
        end;
        2,3:
        begin
          xDmPoly:=NewDmPolyFromPa2(FTmpPl, true, true);
          dm_Set_Poly_Buf(xDmPoly);
          FreeDmPoly(xDmPoly);
        end;
        4: ;
      end//case

    else Tell('tMovObj.PlaceOn2D: dm_goto_node(F2DID)=FALSE');

  except
  end;
end;

function tMovObj.GetTrace(aTraceInd: integer; var xTrace: tdmox): boolean;
begin
  xTrace:=FPic.Trace[aTraceInd];
  Result:=Assigned(xTrace);
end;

procedure tMovObj.SetTimes(aTimeBeg, aTimeEnd: TDateTime);
begin
  FTimeBeg:=aTimeBeg;
  FTimeEnd:=aTimeEnd;
end;

procedure tMovObj.PlaceOn3D;//3d-ОТОБРАЖЕНИЕ
var i: integer; p: tnum2; A,R,G,B,h: single;

    procedure _get_ARGB(color: longint);//=>A,R,G,B
    begin
      //для 3D: <ARGB>(A-старший байт), в Windows - обратный порядок <BGR>:
      B := (color and $0000FF)/255;
      G := ((color and $00FF00) shr 8)/255;
      R := ((color and $FF0000) shr 16)/255;
      A := 1;//нет прозрачности
    end;

begin
  if not _3DOk then exit;

  try
  case FDMO.Loc of
  0: ;//!
  1:
    begin
      //h := FPic._3d.GetZ(FPos.p.x, FPos.p.y) + 1.0;//DEBUG
      h := FDMO.H104 + 1.0;//иначе в дорогах тонут
      if FDMO.H700=1 then begin
        FPic.F3d.PlaceVGMObject(F3DID,
          FPos.p.x, FPos.p.y, h,
          -FPos.fi, 0, 0,
          FDMO.H703{Scale});
        FPic.F3d.ShowVGMObject(F3DID);//!
      end else if FDMO.H700=2 then begin
        FPic.F3d.PlaceLibObject(F3DID,
          FPos.p.x, FPos.p.y, h,
          -FPos.fi, 0, 0,
          ANGLES_FOLLOW_REL);
        FPic.F3d.ShowLibObject(F3DID);//!
      end;
    end;//1
  2,3:
    begin
      //преобразование 3D-объекта:
      FPic.F3d.ClearMOObject(F3DID);//=>Hide(!)

        FPic.F3d.SetMOLineWidth(F3DID, FDMO.H106);
        if (F3DFlags and MOT_ROOF)>0 then begin
          _get_ARGB(FDMO.H702);
          if (F3DFlags and MOT_ROOF_TEXTURE)>0 then FPic.F3d.SetMOTexture(F3DID, FDMO.H702)
          else FPic.F3d.SetMOColor(F3DID, {FDMO.H702}R,G,B,A);
        end;
        if (F3DFlags and MOT_WALL)>0 then begin
          _get_ARGB(FDMO.H703);
          if (F3DFlags and MOT_WALL_TEXTURE)>0 then FPic.F3d.SetMOSideTexture(F3DID, FDMO.H703)
          else FPic.F3d.SetMOSideColor(F3DID, {FDMO.H703}R,G,B,A);
        end;

      if FTmpPl.Count>0 then begin
        for i:=0 to FTmpPl.Count-1 do begin
          p:=FTmpPl[i];
          FPic.F3d.AddMOVertice(F3DID, p.x, p.y, FDMO.H1);//FDMO.H1: относительная высота верха
        end;

        FPic.F3d.FixMOObject(F3DID);
        FPic.F3d.ShowMOObject(F3DID);//!
      end;//FTmpPl.Count>0
    end;//2,3
  4: ;
  else
    Tellf('tMovObj.PlaceOn3D: Локализация %d в 3D не обрабатывается.',[FDMO.Loc]);
  end;//case
  except
  end;
end;

procedure tMovObj.PlaceOnLine(pl: tpl; ax: tnum);//новое положение
begin
  //FTmpPl:
  if Assigned(pl) then begin
    FPos.p := pl.x_p_fi(ax, pl.Lena, FPos.fi);
    pos_to_tmppl;
  end else begin
    FPos.p := FDMO.Points.First;
    if FDMO.Points.Count>1 then FPos.fi := v_fi(FDMO.Points.V[0]) else FPos.fi := 0;
    points_to_tmppl;
  end;

  PlaceOn2D;
  PlaceOn3D;
end;

function tMovObj.get_traceind_by_x(x: tnum): integer;
var i: integer; tr: tdmox; len: tnum;
begin
  Result:=FTraceInds.Count-1;//default
  len:=0;
  if FTraceInds.Count>0 then for i:=0 to FTraceInds.Count-1 do begin
    if not GetTrace(i,tr) then continue;
    len:=len+tr.Points.Length;
    if len>=x then begin Result:=i; break; end;
  end;//for i
end;

function tMovObj.get_x_by_p(p0: tnum2): tnum;
var i,imin: integer; tr: tdmox; p2: tnum2; d,dmin: tnum;
begin
  Result:=0;
  if FTraceInds.Count=0 then exit;

  imin:=0;
  dmin:=0;
  for i:=0 to FTraceInds.Count-1 do begin
    if not GetTrace(FTraceInds[i], tr) then continue;
    p2:=tr.Points.prj(p0, false);
    d:=v_dist(p0,p2);
    if i=0 then begin
      imin:=0;
      dmin:=d;
    end else begin
      if d<dmin then begin
        imin:=i;
        dmin:=d;
      end;
    end;
  end;//for i

  for i:=0 to imin do begin
    if not GetTrace(FTraceInds[i], tr) then continue;
    if i<imin then Result:=Result+tr.Points.Length
    else Result:=Result+tr.Points.xofp(p0);
  end;//for i
end;

function tMovObj.GetLinePositionByTime(aTime: TDateTime; var pl: tpl; var x: tnum): boolean;//aTime in %(!)
var xTrace: tdmox; x1,x2, len: tnum; i,ind: integer; tim1, tim2: TDateTime;
begin
  Result:=false;
  Fx:=0;
  if FTraceInds.Count=0 then exit;

  if aTime<FTimeBeg then aTime:=FTimeBeg;
  if aTime>FTimeEnd then aTime:=FTimeEnd;

  //x1,x2,tim1,tim2 (FTimeBeg<=aTime<=FTimeEnd):
  tim1:=FTimeBeg; tim2:=FTimeEnd;//default (без маркеров)
  x1:=0; x2:=FTraceLength;//default (без маркеров)

  //маркеры:
  ind:=-1;
  if FMarkers.Count>0 then begin

    for i:=0 to FMarkers.Count-1 do begin
      if FMarkers[i].time>=aTime then begin
        ind:=i;
        tim2:=FMarkers[i].time; x2:=FMarkers[i].x;
        if i>0 then begin tim1:=FMarkers[i-1].time; x1:=FMarkers[i-1].x; end;
        break;
      end;
    end;//for i

    if ind<0 then begin
      ind:=FMarkers.Count-1;
      tim1:=FMarkers[ind].time; x1:=FMarkers[ind].x;//последний участок
    end;

  end;//if FMarkers.Count>0

  //вычисление Fx (tim2>=tim1):
  try
    if tim2<=tim1 then Fx:=x1
    else Fx := x1 + (x2-x1)*(aTime-tim1)/(tim2-tim1);
  except
    Fx:=x1;
  end;

  //вычисление x:
  len:=0;
  x:=-1;
  if Fx=0 then begin
    if GetTrace(FTraceInds.First, xTrace) then x:=0;
  end else if Fx=FTraceLength then begin
    if GetTrace(FTraceInds.Last, xTrace) then x:=xTrace.Points.Length;
  end else if FTraceInds.Count>0 then for i:=0 to FTraceInds.Count-1 do begin
    if not GetTrace(FTraceInds[i], xTrace) then break;
    len := len + xTrace.Points.Length;
    if len>=Fx then begin
      x := Fx - (len-xTrace.Points.Length);
      break;
    end;
  end;

  //результат:
  if x>=0 then begin
    pl:=xTrace.Points;
    Result:=true;
  end;
end;

procedure tMovObj.PlaceByTime(aTime: TDateTime);// aTime in [FTimeBeg, FTimeEnd]
var pl: tpl; x: tnum;
begin
  if not GetLinePositionByTime(aTime, pl, x) then exit;
  //if x<>Fx then PlaceOnLine(pl, x);//новое положение
  PlaceOnLine(pl, x);//новое положение
end;

function tMovObj.Trace_ID1000(aTraceInd: integer): integer;
var xTrace: tdmox;
begin
  if GetTrace(aTraceInd, xTrace) then Result:=xTrace.ID
  else Result:=-1;
end;


function tMovObj.AddMarkerFromOfs(ofs: integer): TMovMarker;//карта закрыта
var dmo: tdmox; mark: TMovMarker;
begin
  Result:=nil;
  if dmw_open( PChar(FPic.FScnDmPath), false )>0 then try
    if dm_goto_node(ofs) then begin
      dmo:=tdmox.CreateFromDm2(true, true);
      mark:=TMovMarker.Create(Self, 0, dmo);
      FMarkers.Add(mark);
      Result:=mark;
    end;//dm_goto_node
  finally
    dmw_done;
  end;
end;



{ TMovPic: }

constructor TMovPic.Create(aPlayDmPath: string; aDmCameraCode: longint);
var dirname: string;
begin
  inherited Create;
  FTraces:=tclasslist.New;

  //PlayDm:
  dirname:=wcmn_file_dirname(aPlayDmPath);
  StrCopy(FPlayDmPath, PChar(aPlayDmPath));
  StrCopy(FPlayDms[1], PChar(dirname+'-1.dm'));
  StrCopy(FPlayDms[2], PChar(dirname+'-2.dm'));
  StrCopy(FPlayDms[3], PChar(dirname+'-3.dm'));

  FDmCamera:=tdmox.CreateCode2(1, aDmCameraCode, true, true);//=>ofs=0
end;

destructor TMovPic.Destroy;
begin
  Free_2D;//!
  try
    FDmCamera.Free;
    FTraces.Free;
    inherited Destroy;//удаление объектов
  except
  end;
  Free_3D;//после удаления объектов!
end;

procedure TMovPic.Clear;
var i: integer;
begin
  //FScnDmPath:='';//для новой сцены карта сохраняется

  if F2DOk and MoveDm_Open then try try
    if FList.Count>0 then for i:=0 to FList.Count-1 do begin
      dm_delete_object(0, Items[i]._2DID);
      Items[i]._2DID:=-1;
    end;
  finally
    MoveDm_Close;
  end;
  except
  end;

  inherited Clear;//удаление объектов
  FTraces.Clear;
end;

procedure TMovPic.ShowFirstTimeList_Show;
//var mo: tmovobj;
begin
  if dm_object>0 then exit;//открыта другая карта
  if ShowFirstTimeList.Count=0 then exit;

  if MoveDm_Open then try
    while ShowFirstTimeList.Count>0 do begin
      TMovObj(ShowFirstTimeList[0]).ShowFirstTime;
      ShowFirstTimeList.DeleteFirst;
    end;
  finally
    MoveDm_Close;
  end;
end;

procedure TMovPic.DmCamera_Draw;//PlayDm открыта!
const
  la0: lpoint = (x:0; y:0);
  lb0: lpoint = (x:0; y:0);
var
  x,y,z, firight ,fidown: single;
  la,lb: lpoint; a,b: tnum2; larrow: double;
begin
  if not F3DOk then exit;
  if not _2DOpened then exit;

  _3d.CameraGetValues(x,y,z, firight ,fidown); fidown:=-fidown;
  a := v_xy(x,y);

  larrow:=rvaldef( FormOpt.EditCameraLength.Text, 300 );
  b := v_add( a, v_rot( v_xy(larrow,0), firight ) );

(*
  if dm_goto_node(FDmCamera.dmoffset) then begin
    if dm_Get_Code<>FDmCamera.LCode then dm_Restore_Graphics;//при динамическом изменении кода
    la := Num2GaussToLp(a, true);
    lb := Num2GaussToLp(b, true);
    dm_set_bound(la,lb);
  end else begin
    FDmCamera.Points[0]:=a;
    FDmCamera.Points[1]:=b;
    dm_goto_root; dm_goto_down;
    if FDmCamera.Add(false)<=0 then Tell('ERROR in TMovPic.DmCamera_Draw');//=>FDmCamera.dmoffset
  end;
*)
  la := Num2GaussToLp(a, false);
  lb := Num2GaussToLp(b, false);
  if (la.x<>la0.x) or (la.y<>la0.y) or (lb.x<>lb0.x) or (lb.y<>lb0.y) then begin
    la0:=la;
    lb0:=lb;
    dmw_ext_Draft(la.x,la.y, lb.x,lb.y, 102);//стрелка
  end;
end;

procedure TMovPic.DmCamera_Free;
begin
  if not F2DOk then exit;
  if MoveDm_Open then try try
    dm_delete_object(0, FDmCamera.dmoffset);
    FDmCamera.dmoffset:=0;//!
  finally
    MoveDm_Close;
  end;
  except
  end;
end;


//---------------------------------------------------

//Result>=0 всегда(!), если aTrace.ID есть, то [aTrace.Free, aTrace меняется(!)]:
function TMovPic.AddTrace(var aTrace: tdmox): integer;
var i,ind: integer; tr: tdmox;
begin
  ind:=-1;
  tr:=nil;
  if FTraces.Count>0 then for i:=0 to FTraces.Count-1 do begin
    tobject(tr):=FTraces[i];
    if Assigned(tr) and (tr.ID=aTrace.ID) then begin
      ind:=i;
      break;
    end;
  end;

  if ind>=0 then begin Result:=ind; aTrace.Free;{!} aTrace:=tr; end
  else Result:=FTraces.Add(aTrace);
end;

function TMovPic.AddTraceFromOfs(ofs: integer): integer;
var trace: tdmox;
begin
  Result:=-1;
  if dmw_open( PChar(FScnDmPath), false )>0 then try
    if dm_goto_node(ofs) then begin
      trace:=tdmox.CreateFromDm2(true,true);//gauss
      if (trace.loc=2) or (trace.loc=3) then Result:=AddTrace(trace);
    end;
  finally
    dmw_done;
  end;
end;

function TMovPic.Get(i: integer): tMovObj;
begin
  tobject(Result) := inherited Get(i);
end;

function TMovPic.GetTrace(i: integer): tdmox;
begin
  tobject(Result):=FTraces[i];//если i плохой, то NIL(!)
end;

procedure TMovPic.SetDmCameraCode(aCode: longint);
begin
  FDmCamera.LCode:=aCode;//графика изменится при очередном вызове Camera_Draw(!)
end;


procedure TMovPic.Create_3D(aCfgPath: string);//'' => 3D не используется

  function _load_cfg_file(aPath: string): boolean;
  begin
    Result:=true;

    aPath:=sread_word(aPath);
    if not FileExists(aPath) then begin
      Tellf('3D-загрузка: Файл "%s" не существует.',[aPath]);
      Result:=false;
      exit;
    end;

    try
      aPath:=UpperCase(aPath);
      if pos('.MDB', aPath)>0 then F3d.Load3DLib(aPath)
      else if pos('.LOG', aPath)>0 then F3d.LoadRel(aPath)
      else if pos('.RLZ', aPath)>0 then F3d.LoadRel(aPath)
      else if pos('.VGM', aPath)>0 then F3d.LoadVGMLib(aPath)
      else if pos('.MS',  aPath)>0 then F3d.LoadMS(aPath);
    except
      Result:=TellfYN('Ошибка 3D-загрузки файла "%s". Продолжать?',[aPath]);
    end;
  end;

var
  aCfgDir, s: string;
  //aLibPath, aRelPath, aMSPath: string;
  i: integer; f: TextFile;
begin
  Free_3D;//для реинициализации

  if Length(aCfgPath)=0 then begin Tell('Не определён файл 3D-конфигурации'); exit; end;

  if ftopen_msg(f, aCfgPath, 'r') then try try

    SetWaitCursor;
    aCfgDir:=wcmn_file_dir(aCfgPath);
(*
    readln(f,s); aLibPath := aCfgDir + s;//1-ая строка - 3dlib.mdb (3D-библиотека)
    readln(f,s); aRelPath := aCfgDir + s;//1-ая строка - test.log (рельеф)

    if not FileExists(aLibPath) then begin Tellf('3D: файл библиотеки "%s" не существует.',[aLibPath]); abort; end;
    if not FileExists(aRelPath) then begin Tellf('3D: файл рельефа "%s" не существует.',[aRelPath]); abort; end;
*)
    F3d:=TScene3Dx.Create(nil);
    F3d.Connect;//=>RUN Terra3D
(*
    //сначала 3DLib, потом REL:
    F3d.Load3DLib(aLibPath);
    F3d.LoadRel(aRelPath);
*)
    //загрузка файлов:
    while not eof(f) do begin
      readln(f,s);
      if Length(s)=0 then break;//!
      if not _load_cfg_file(aCfgDir + s) then begin
        Free_3D;
        abort;//!
      end;
    end;

    F3DOk:=true;//перед отрисовкой!

    //если объекты уже есть:
    if FList.Count>0 then for i:=0 to FList.Count-1 do
      if Assigned(Items[i]) and (Items[i] is TMovObj) then begin
        Items[i].Create_3D;
        Items[i].PlaceOn3D;
      end;

  finally
    SetDefCursor;
    ftclose(f);
  end;
  except
    Tell('Ошибка загрузки 3D.');
  end;
end;

procedure TMovPic.Free_3D;//F3d: Disconnect, Free;
begin
  if Assigned(F3d) then begin
    F3d.Disconnect;
    F3d.Free;
    F3d:=nil;
  end;
end;

//------------------------------------------------------

function TMovPic.Create_2D(aDmFileName: string): boolean;//=>FPlayDmPath - пустая копия dmfname
begin
  F2DOk:=false;
  FScnDmPath:='';
  Free_2D;//=> файл FPlayDmPath свободен
  DmCamera_Free;//!

  try
    if not DeleteFile( FPlayDmPath ) and FileExists( FPlayDmPath ) then begin
      Tellf('Невозможно удалить файл "%s".\nПопробуйте перезагрузиться.',[FPlayDmPath]);
      abort;
    end;
    if dmw_HideMap then try
      if dm_Copy( PChar(aDmFileName), FPlayDmPath, PChar(DmObjName(aDmFileName)) )
      and FileExists( FPlayDmPath )
      then begin
        FScnDmPath:=aDmFileName;
        F2DOk:=true;
      end;
    finally
      dmw_BackMap;
    end;
  except
  end;

  if not F2DOk then Tell('Ошибка инициализации 2D-движения');
  Result:=F2DOk;
end;

procedure TMovPic.Free_2D;
begin
  try
    F2DOk:=false;
    dmw_Movie_dm(0, nil);
  except
  end;
end;

function TMovPic.MoveDm_Open: boolean;//F2DOk
begin
  if F2DOk
    then if not F2DOpened then F2DOpened := dm_open(FPlayDmPath, true)>0
    else MoveDm_Close;

  if F2DOpened then begin
    dm_goto_root;
    dm_goto_down;//слой
    dm_goto_down;//знаки привязки
  end;

  Result := F2DOpened;
end;

procedure TMovPic.MoveDm_Close;
const k: integer =1;
begin
  if F2DOpened then try try
    dm_done;
    if F2DOk then begin
      inc(k); if k>3 then k:=1;
      if wcmn_filecopy0( [StrPas(FPlayDmPath)], StrPas(FPlayDms[k]), true, false)=1 then
        dmw_Movie_dm(Form1.Handle, FPlayDms[k]);
    end;
  finally
    F2DOpened := false;
  end;
  except
  end;
end;


procedure TMovPic.OnTimer(aTime: TDateTime);
var i: integer;
begin
  try
    if FList.Count>0 then for i:=0 to FList.Count-1 do
      if Assigned(Items[i]) and (Items[i] is TMovObj) then
        Items[i].PlaceByTime(aTime);//pos_to_dmpoly, 3d-ОТОБРАЖЕНИЕ
  except
  end;
end;

//-------------------------------------------------------------


function TMovPic.AddObjectFromOfs(ofs: integer): TMovObj;//карта закрыта
var dmo: tdmox; mo: tmovobj;
begin
  Result:=nil;
  if dmw_open( PChar(FScnDmPath), false )>0 then try
    if dm_goto_node(ofs) then begin
      dmo:=tdmox.CreateFromDm2(true,true);//gauss
      mo:=tmovobj.Create(Self, dmo, -1);
      //mo.Visible:=true;
      if AddItem(mo) then Result:=mo else mo.Free;
    end;
  finally
    dmw_done;
  end;
end;


{ TFrmMove: }

{ Events: }


initialization
  ShowFirstTimeList:=TPtrList.New;
finalization
  ShowFirstTimeList.Free;

end.
