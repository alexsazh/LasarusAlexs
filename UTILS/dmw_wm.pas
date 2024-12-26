unit dmw_wm;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, Forms,Controls,Classes, windows,
  Sysutils,Messages,Math,Otypes;

const
  dmw_Exchange   = 'Dmw Data Exchange';
  dmw_Automation = 'Dmw Automation';

  alw_Automation = 'Alw Automation';
  obj_Automation = 'Obj Automation';
  id_Automation  = 'Id Automation';

  rg_Exchange   = 'Rg Data Exchange';
  alw_Exchange  = 'Alw Data Exchange';

  dmw_wm_cancel = 0;
  dmw_wm_object = 1;
  dmw_wm_point  = 2;
  dmw_wm_vector = 3;
  dmw_wm_rect   = 4;
  dmw_wm_port   = 5;
  dmw_wm_geoid  = 6;
  dmw_wm_ring   = 7;
  dmw_wm_draft  = 8;
  dmw_wm_image  = 9;
  dmw_wm_poly   = 10;
  dmw_wm_gauss  = 11;
  dmw_wm_move   = 12;
  dmw_wm_objx   = 13;
  dmw_wm_maps   = 14;
  dmw_wm_key    = 15;
  dmw_wm_hot    = 16;

  dmw_wm_map    = 20;
  dmw_wm_occupe = 21;
  dmw_wm_delete = 22;
  dmw_wm_xpage  = 23;
  dmw_wm_xsync  = 24;
  dmw_wm_undo   = 25;

  dmw_wgs_move  = 26;
  dmw_wm_moved  = 27; 
  dmw_wm_ring1  = 28; 
  dmw_wm_ring6  = 29; 

  dmw_wm_pair   = 30;

  dmw_lib_object = 51;
  dmw_lib_occupe = 52;

  dmw_wm_trk     = 53;
  dmw_wm_trk1    = 54;
  dmw_wm_trk2    = 55;
  dmw_wm_trk3    = 56;
  dmw_wm_trk4    = 57;
  dmw_wm_trk5    = 58;

  dmw_wm_click   = 59;

  cmd_exec        = 100;
  cmd_open_map    = 101;
  cmd_close_map   = 102;
  cmd_open_tdm    = 199;
  cmd_open_pcx    = 103;
  cmd_open_log    = 104;
  cmd_open_prj    = 105;

  cmd_pcx_repaint = 106;
  cmd_map_repaint = 107;
  cmd_map_redraw  = 108;
  cmd_map_refresh = 109;
  cmd_obj_refresh = 110;

  cmd_disp_object = 111;
  cmd_show_object = 112;
  cmd_show_point  = 113;
  cmd_show_draft  = 114;
  cmd_show_window = 115;
  cmd_active_map  = 116;
  cmd_play_map    = 117;
  cmd_set_tool    = 118;
  cmd_grid_google = 119;

  cmd_sel_add     = 121;
  cmd_sel_del     = 122;

  cmd_show_wgs    = 123;
  cmd_show_draft1 = 124;
  cmd_show_draft2 = 125;

  cmd_draw_object = 126;

  cmd_set_focus   = 130;
  cmd_reindexing  = 131;

  cmd_rel_hide    = 140;
  cmd_rel_back    = 141;

  cmd_profile     = 151;
  cmd_d3_vpt      = 152;
  cmd_twr_update  = 153;

  dmw_wm_gps      = 154;

  cmd_pick_object = 201;
  cmd_pick_vector = 202;

  cmd_view_object = 223;

  cmd_auto_exe    = 300;
  cmd_auto_lock   = 301;
  cmd_auto_unlock = 302;
  cmd_obj_close   = 303;
  cmd_win_lock    = 304;

  dmw_wm_param    = 305;

  cmd_win_xy      = 306;

  dmw_wm_user     = 255;
  dmw_wm_lock     = 1000;
  dmw_wm_unlock   = 1001;

  id_show_blank   = 101;
  id_shift_blank  = 102;

  wm_dmw_pick = wm_User+256;

type
  tdmw_wm_object = record
    offs,Code,Loc: int;
    lt,rb: TPoint; Id: int;
    name: TShortstr; pt: TPoint;
    where: int; win: LVector;
    pt_on: int
  end;

  pdmw_wm_object1 = ^tdmw_wm_object1;
  tdmw_wm_object1 = record
    obj: tdmw_wm_object;
    map: TShortstr
  end;

  tdmw_wm_point = record
    p: TPoint; g: tgauss; gz: Double;
    sys: tsys; win: LVector
  end;

  tdmw_wm_rect = record
    x1,y1,x2,y2: Integer;
  end;

  tdmw_wm_xpage = record
    g: GOrient; sys: tsys;
    nx,ny: Integer;
  end;

  pdmw_wm_draft = ^tdmw_wm_draft;
  tdmw_wm_draft = record
    x1,y1,x2,y2,id,ind: int;
  end;

  pdmw_wm_draft1 = ^tdmw_wm_draft1;
  tdmw_wm_draft1 = record
    id: int; a,b: TGauss; sys: tsys
  end;

  pdmw_wm_draft2 = ^tdmw_wm_draft2;
  tdmw_wm_draft2 = record
    id: int; g: TGauss3; sys: tsys
  end;

  pdmw_wm_objx = ^tdmw_wm_objx;
  tdmw_wm_objx = record
    id,loc,color: Integer;
  end;

  pdmw_wm_show_object = ^tdmw_wm_show_object;
  tdmw_wm_show_object = record
    cn,id,up: Integer; scale,gx,gy,gz: Double;
  end;

  pdmw_wm_trk = ^tdmw_wm_trk;
  tdmw_wm_trk = record
    id,it: int; v,r: txyz
  end;

  pdmw_wm_trk4 = ^tdmw_wm_trk4;
  tdmw_wm_trk4 = record
    ptr,play: int; v: VPoint;
    frameN: int; frame: TPoints4
  end;

  pdmw_wm_gps = ^tdmw_wm_gps;
  tdmw_wm_gps = record
    t,b,l,h,up: Integer;
  end;

  pdmw_wm_key = ^tdmw_wm_key;
  tdmw_wm_key = record
    shift,key: int; p: TPoint
  end;

  pdmw_wm_pair = ^tdmw_wm_pair;
  tdmw_wm_pair = record
    ptr1,ptr2: int64
  end;

  tdmw_wm_str = TShortstr;

  tdmw_wm_msg = record case integer of
1: (po: tdmw_wm_object);
2: (pp: tdmw_wm_point);
3: (pg: tdmw_wm_rect);
4: (ps: tdmw_wm_str);
5: (ln: TLLine);
6: (po1: tdmw_wm_objx);
  end;

  pdmw_wm_object = ^tdmw_wm_object;
  pdmw_wm_point = ^tdmw_wm_point;
  pdmw_wm_rect = ^tdmw_wm_rect;
  pdmw_wm_xpage = ^tdmw_wm_xpage;

  twm_pointer = record case integer of
0: (p: Pointer);
1: (pi: PInteger);
2: (ps: PChar);
3: (ip: PIntegers);
4: (dp: PDoubles);
5: (po: pdmw_wm_object);
6: (pp: pdmw_wm_point);
7: (pg: pdmw_wm_rect);
8: (px: pdmw_wm_xpage);
9: (lp: PLLine);
10:(gc: ^XGeoid);

11:(po1: pdmw_wm_object1);
12:(po2: pdmw_wm_objx);

13:(trk: pdmw_wm_trk);
14:(gps: pdmw_wm_gps);
15:(key: pdmw_wm_key);
16:(draft: pdmw_wm_draft);
17:(draft1: pdmw_wm_draft1);
18:(draft2: pdmw_wm_draft2);

19:(pair: pdmw_wm_pair);
  end;

  TOnPickEvent = procedure(Sender: TObject;
                           p: twm_pointer) of object;

  TPickProc = procedure(Cmd: Integer; wm: twm_pointer) of object;

  TDmwObject = procedure(Ptr,Dbl: Longint); stdcall;

  TPickCallback = procedure(Obj: Pointer;
                            Cmd: int; wm: pointer); stdcall;

  TCommonObject = class

    destructor Destroy; override;

    procedure CloseObject;

    function CreateObject(ASize: Integer;
                          AName: PChar): Boolean;

    function OpenObject(ASize: Integer;
                        AName: PChar): Boolean;

    function Send(Data: Pointer; DataLen: Integer): Boolean;

    function xSend(Cmd: Integer; Data: Pointer;
                   DataLen: Integer): Boolean;

    function sSend(Cmd: Integer; Str: PChar): Boolean;
    function iSend(Cmd,Val: Integer): Boolean;

    function Command(Cmd: Integer): Boolean;

    function Receive(Data: Pointer): Boolean;

  private
    fSize: Integer;
    vm: TMapView;

    fActive: Longbool;
    fIsWait: Longbool;

    fIsTick: Longbool;
    fTick: longint;

    fName: String;

    function Get_Buffer: PBytes;

  protected
    function GetActive: Boolean; virtual;

  public
    property Active: Boolean read GetActive;
    property Name: String read fName;
    property Buffer: PBytes read Get_Buffer;
    property Size: Integer read fSize;
    property IsWait: Longbool write fIsWait;
    property IsTick: Longbool write fIsTick;
    property Tick: int read fTick write fTick;
  end;

  TClientThread = class(TThread)

    constructor Create(ASize: Integer; AName: PChar);
    destructor Destroy; override;

    procedure Execute; override;

    procedure Close;
    procedure Takt;

  private
    obj: TCommonObject;
    sync: TMultiReadExclusiveWriteSynchronizer;

    fData: PBytes;
    fDataSize: DWord;
    fName: TShortstr;

    fOnPickEvent: TPickProc;

    fOnPickCancel: TNotifyEvent;
    fOnPickObject: TOnPickEvent;
    fOnPickPoint: TOnPickEvent;
    fOnPickVector: TOnPickEvent;
    fOnPickRect: TOnPickEvent;
    fOnPickPort: TOnPickEvent;
    fOnPickGeoid: TOnPickEvent;
    fOnPickRing: TOnPickEvent;
    fOnPickDraft: TOnPickEvent;
    fOnPickImage: TOnPickEvent;
    fOnPickPoly: TOnPickEvent;
    fOnSwapMap: TOnPickEvent;
    fOnPickOccupe: TOnPickEvent;
    fOnPickDelete: TOnPickEvent;

    procedure pick_proc;

  public
    property OnPickEvent: TPickProc write fOnPickEvent;

    property OnPickCancel: TNotifyEvent write fOnPickCancel;

    property OnPickObject: TOnPickEvent write fOnPickObject;
    property OnPickPoint: TOnPickEvent write fOnPickPoint;
    property OnPickVector: TOnPickEvent write fOnPickVector;
    property OnPickRect: TOnPickEvent write fOnPickRect;
    property OnPickPort: TOnPickEvent write fOnPickPort;
    property OnPickGeoid: TOnPickEvent write fOnPickGeoid;
    property OnPickRing: TOnPickEvent write fOnPickRing;
    property OnPickDraft: TOnPickEvent write fOnPickDraft;
    property OnPickImage: TOnPickEvent write fOnPickImage;
    property OnPickPoly: TOnPickEvent write fOnPickPoly;
    property OnSwapMap: TOnPickEvent write fOnSwapMap;
    property OnPickOccupe: TOnPickEvent write fOnPickOccupe;
    property OnPickDelete: TOnPickEvent write fOnPickDelete;
  end;

  TDmwServer = class(TCommonObject)
    function xCreateObject: Boolean;
  end;

  TDmwCommand = class(TCommonObject)
    function Connect: Boolean;
    procedure ShowObject(cn,id: Integer; scale: Double);
    procedure ViewObject(cn,id: Integer; scale: Double);
    procedure ShowPoint(gx,gy,scale: Double);

    procedure ShowDraft(x1,y1,x2,y2,id: Integer);

    procedure DispObject(dm: PChar; ptr,mode: int);

    procedure Draft1(id: int;
                     const a,b: TGauss;
                     const s: tsys);

    procedure Draft2(id: int;
                     const g: TGauss3;
                     const s: tsys);

    procedure ShowWindow(x1,y1,x2,y2: Integer);
    procedure ShowWgs(gx,gy,gz,scale: Double);
    procedure Exec(Cmd: PChar);

    procedure open_tdm(Path: PChar);
    procedure close_map(Path: PChar);
  end;

  TDmwClient = class(TClientThread)
    constructor Create(APickProc: TPickProc);
  private
    fOnObject: TDmwObject;
    procedure PickEvent(Cmd: Integer; wm: twm_pointer);
  public
    property OnObject: TDmwObject write fOnObject;
  end;

  TDmwAutoServer = class(TCommonObject)
    function xCreateObject: Boolean;
  end;

  TDmwAutoClient = class(TClientThread)
    constructor Create(APickProc: TPickProc);
  end;

  TObjClient = class(TCommonObject)
    constructor Create;
    procedure OpenDB(Path: PChar);
    procedure ShiftBlank(Path: PChar; ind,delta: int);
  end;

  TAlwServer = class(TCommonObject)
    function xCreateObject: Boolean;
  end;

  TAlwClient = class(TClientThread)
    constructor Create(APickProc: TPickProc;
                       ASuspended: Boolean);
  end;

  TAlwClient1 = class(TAlwClient)
    constructor Create;
    function Query(out wm: twm_pointer): Integer;

  private
    fCmd: Integer;
    fwm: twm_pointer;

    procedure PickProc(ACmd: Integer; Awm: twm_pointer);
  end;

  TDmwPick = class(TDmwClient)
    constructor Create;
  private
    fOnPickCancel: TNotifyEvent;
    fOnPickObject: TOnPickEvent;
    fOnPickOccupe: TOnPickEvent;
    fOnPickPoint: TOnPickEvent;
    fOnPickVector: TOnPickEvent;
    fOnPickRect: TOnPickEvent;
    fOnPickPort: TOnPickEvent;
    fOnPickGeoid: TOnPickEvent;
    fOnPickRing: TOnPickEvent;
    fOnPickDraft: TOnPickEvent;
    fOnPickPoly: TOnPickEvent;
    fOnSwapMap: TOnPickEvent;

    procedure PickProc(Cmd: Integer; wm: twm_pointer);

  public
    property OnPickCancel: TNotifyEvent write fOnPickCancel;

    property OnPickObject: TOnPickEvent write fOnPickObject;
    property OnPickOccupe: TOnPickEvent write fOnPickOccupe;
    property OnPickPoint: TOnPickEvent write fOnPickPoint;
    property OnPickVector: TOnPickEvent write fOnPickVector;
    property OnPickRect: TOnPickEvent write fOnPickRect;
    property OnPickPort: TOnPickEvent write fOnPickPort;
    property OnPickGeoid: TOnPickEvent write fOnPickGeoid;
    property OnPickRing: TOnPickEvent write fOnPickRing;
    property OnPickDraft: TOnPickEvent write fOnPickDraft;
    property OnPickPoly: TOnPickEvent write fOnPickPoly;
    property OnSwapMap: TOnPickEvent write fOnSwapMap;
  end;

  TAlwCommon = class(TCommonObject)
    constructor Create;

    procedure sel_clear;
    procedure sel_add(ptr: Integer);
    procedure sel_del(ptr: Integer);

    procedure sel_lock;
    procedure sel_unlock;

    procedure Show_Object(cn,id,up: Integer; scale: Double);

  private
    finit: Boolean;

    function OpenClient: Boolean;
    function GetActive1: Boolean;

  public
    property Active1: Boolean read GetActive1;
  end;

function xSendMessage(Auto: PChar; Cmd: Integer;
                      Data: Pointer; DataLen: Integer;
                      Wait: Boolean): Boolean;

function sSendMessage(Auto: PChar; Cmd: Integer;
                      Data: PChar; Wait: Boolean): Boolean;

function sDmwMessage(Cmd: Integer;
                     Data: PChar; Wait: Boolean): Boolean;

procedure dmw_Draft(x1,y1,x2,y2,id: Integer);

implementation

destructor TCommonObject.Destroy;
begin
  xFreeFile(vm); inherited
end;

function TCommonObject.GetActive: Boolean;
begin
  Result:=fActive
end;

function TCommonObject.Get_Buffer: PBytes;
begin
  Result:=nil; if Assigned(vm.p) then
  Result:=@vm.p[4]
end;

procedure TCommonObject.CloseObject;
begin
  xFreeFile(vm); fActive:=false
end;

function TCommonObject.CreateObject(ASize: Integer;
                                    AName: PChar): Boolean;
begin
  Result:=false; CloseObject;

  if xCreateFileMap(ASize+4,AName,vm) <> nil then begin
    PLongint(vm.p)^:=1; fSize:=ASize;
    fActive:=true; Result:=fActive
  end
end;

function TCommonObject.OpenObject(ASize: Integer;
                                  AName: PChar): Boolean;
begin
  Result:=false; CloseObject;

  if xOpenFileMap(AName,vm) <> nil then begin
    fActive:=true; fSize:=ASize;
    Result:=fActive
  end
end;

function TCommonObject.Send(Data: Pointer; DataLen: Integer): Boolean;
var
  k: int;
begin
  Result:=false;
  if fActive then begin
    DataLen:=Min(DataLen,fSize);
    Move(Data^,Buffer^,DataLen);

    if fIsTick then
      PLongint(vm.p)^:=GetTickCount64
    else
      PLongint(vm.p)^:=0;

    k:=0; if fIsWait then
    while PLongint(vm.p)^ = 0 do begin
      Sleep(5); Inc(k); if k > 500 then Break
    end;

    Result:=true
  end
end;

function TCommonObject.xSend(Cmd: Integer; Data: Pointer;
                             DataLen: Integer): Boolean;
var
  buf: tbytes; len: Integer;
begin
  len:=Min(Sizeof(buf),DataLen+4);
  Move(Cmd,buf,4); Move(Data^,buf[4],len-4);
  Result:=Send(@buf,len)
end;

function TCommonObject.sSend(Cmd: Integer; Str: PChar): Boolean;
var
  buf: tbytes; len: Integer;
begin
  len:=Strlen(Str)+1+4;
  len:=Min(len,Sizeof(buf));
  Move(Cmd,buf,4); Move(Str^,buf[4],len-4);
  Result:=Send(@buf,len)
end;

function TCommonObject.iSend(Cmd,Val: Integer): Boolean;
var
  buf: tbytes;
begin
  Move(Cmd,buf,4); Move(Val,buf[4],4);
  Result:=Send(@buf,8)
end;

function TCommonObject.Command(Cmd: Integer): Boolean;
var
  buf: tbytes;
begin
  Move(Cmd,buf,4); Result:=Send(@buf,4)
end;

function TCommonObject.Receive(Data: Pointer): Boolean;
begin
  Result:=false;

  if fActive then
  if Assigned(vm.p) then

  if fIsTick then begin

    if PInteger(vm.p)^ <> fTick then begin
      Move(Buffer^,Data^,fSize);
      fTick:=PInteger(vm.p)^;
      Result:=true
    end

  end else
  
  if PLongint(vm.p)^ = 0 then begin
    Move(Buffer^,Data^,fSize);
    PLongint(vm.p)^:=1; Result:=true
  end
end;

constructor TClientThread.Create(ASize: Integer; AName: PChar);
begin
  inherited Create(true);
  Priority:=tpLower;

  sync:=TMultiReadExclusiveWriteSynchronizer.Create;

  obj:=TCommonObject.Create;
  StrCopy(fName,AName);

  if ASize <= 0 then ASize:=1024;
  fData:=xAllocPtr(ASize);
  fDataSize:=ASize
end;

destructor TClientThread.Destroy;
begin
  inherited;
  fData:=xFreePtr(fData);
  FreeAndNil(obj);
  FreeAndNil(sync);
end;

procedure TClientThread.Execute;
begin
  while not Terminated do begin
    Takt; if not Suspended then Sleep(10)
  end
end;

procedure TClientThread.Close;
begin
  obj.CloseObject;
  Terminate;
end;

procedure TClientThread.Takt;
begin
  if obj.Active then begin

    if Assigned(fData) then
    if obj.Receive(fData) then
    if Suspended then
      pick_proc
    else
    if IsLibrary then begin
      sync.BeginWrite;
      pick_proc;
      sync.EndWrite;
    end
    else Synchronize(pick_proc)
  end else

  if Strlen(fName) > 0 then
  obj.OpenObject(fDataSize,fName);
end;

procedure TClientThread.pick_proc;
var
  Id: PInteger; wm: twm_pointer;
begin
  Id:=@fData[0]; wm.p:=@fData[4];

  if Assigned(fOnPickEvent) then
    fOnPickEvent(Id^,wm)
  else
  case Id^ of
dmw_wm_cancel:
    if Assigned(fOnPickCancel) then
    fOnPickCancel(Self);

dmw_wm_object:
    if Assigned(fOnPickObject) then
    fOnPickObject(Self,wm);

dmw_wm_point:
    if Assigned(fOnPickPoint) then
    fOnPickPoint(Self,wm);

dmw_wm_vector:
    if Assigned(fOnPickVector) then
    fOnPickVector(Self,wm);

dmw_wm_rect:
    if Assigned(fOnPickRect) then
    fOnPickRect(Self,wm);

dmw_wm_port:
    if Assigned(fOnPickPort) then
    fOnPickPort(Self,wm);

dmw_wm_geoid:
    if Assigned(fOnPickGeoid) then
    fOnPickGeoid(Self,wm);

dmw_wm_ring:
    if Assigned(fOnPickRing) then
    fOnPickRing(Self,wm);

dmw_wm_draft:
    if Assigned(fOnPickDraft) then
    fOnPickDraft(Self,wm);

dmw_wm_image:
    if Assigned(fOnPickImage) then
    fOnPickImage(Self,wm);

dmw_wm_poly:
    if Assigned(fOnPickPoly) then
    fOnPickPoly(Self,wm);

dmw_wm_map:
    if Assigned(fOnSwapMap) then
    fOnSwapMap(Self,wm);

dmw_wm_occupe:
    if Assigned(fOnPickOccupe) then
    fOnPickOccupe(Self,wm);

dmw_wm_delete:
    if Assigned(fOnPickDelete) then
    fOnPickDelete(Self,wm);
  end
end;

function TDmwServer.xCreateObject: Boolean;
begin
  fIsTick:=true;
  Result:=CreateObject(4096*4,dmw_Exchange)
end;

function TDmwCommand.Connect: Boolean;
begin
  if not Active then
  OpenObject(1024,dmw_Automation);
  IsWait:=true; Result:=Active
end;

procedure TDmwCommand.ShowObject(cn,id: Integer; scale: Double);
var
  r: tdmw_wm_show_object;
begin
  ZeroMemory(@r,Sizeof(r));
  r.cn:=cn; r.id:=id; r.scale:=scale;
  xSend(cmd_show_object,@r,Sizeof(r));
end;

procedure TDmwCommand.ViewObject(cn,id: Integer; scale: Double);
var
  r: tdmw_wm_show_object;
begin
  ZeroMemory(@r,Sizeof(r));
  r.cn:=cn; r.id:=id; r.scale:=scale;
  xSend(cmd_view_object,@r,Sizeof(r));
end;

procedure TDmwCommand.ShowPoint(gx,gy,scale: Double);
var
  r: tdmw_wm_show_object;
begin
  ZeroMemory(@r,Sizeof(r));
  r.gx:=gx; r.gy:=gy; r.scale:=scale;
  xSend(cmd_show_point,@r,Sizeof(r));
end;

procedure TDmwCommand.ShowDraft(x1,y1,x2,y2,id: Integer);
var
  r: tdmw_wm_draft;
begin
  ZeroMemory(@r,Sizeof(r));
  r.x1:=x1; r.y1:=y1; r.x2:=x2; r.y2:=y2;
  r.id:=id; xSend(cmd_show_draft,@r,Sizeof(r));
end;

procedure TDmwCommand.DispObject(dm: PChar; ptr,mode: int);
var
  r: tdmw_wm_object;
begin
  ZeroMemory(@r,Sizeof(r));
  r.offs:=ptr; r.Code:=mode;
  StrCopy(r.name,dm);
  xSend(cmd_draw_object,@r,Sizeof(r));
end;

procedure TDmwCommand.Draft1(id: int;
                             const a,b: TGauss;
                             const s: tsys);
var
  r: tdmw_wm_draft1;
begin
  ZeroMemory(@r,Sizeof(r));
  r.id:=id; r.a:=a; r.b:=b; r.sys:=s;
  xSend(cmd_show_draft1,@r,Sizeof(r));
end;

procedure TDmwCommand.Draft2(id: int;
                             const g: TGauss3;
                             const s: tsys);
var
  r: tdmw_wm_draft2;
begin
  ZeroMemory(@r,Sizeof(r));
  r.id:=id; r.g:=g; r.sys:=s;
  xSend(cmd_show_draft2,@r,Sizeof(r));
end;

procedure TDmwCommand.ShowWindow(x1,y1,x2,y2: Integer);
var
  r: tdmw_wm_rect;
begin
  r.x1:=x1; r.y1:=y1; r.x2:=x2; r.y2:=y2;
  xSend(cmd_show_window,@r,Sizeof(r));
end;

procedure TDmwCommand.ShowWGS(gx,gy,gz,scale: Double);
var
  r: tdmw_wm_show_object;
begin
  ZeroMemory(@r,Sizeof(r));
  r.gx:=gx; r.gy:=gy; r.gz:=gz; r.scale:=scale;
  xSend(cmd_show_wgs,@r,Sizeof(r));
end;

procedure TDmwCommand.Exec(Cmd: PChar);
begin
  sSend(cmd_exec,Cmd)
end;

procedure TDmwCommand.open_tdm(Path: PChar);
begin
  sSend(cmd_open_tdm,Path)
end;

procedure TDmwCommand.close_map(Path: PChar);
begin
  sSend(cmd_close_map,Path)
end;

constructor TDmwClient.Create(APickProc: TPickProc);
begin
  inherited Create(0,dmw_Exchange);

  obj.fIsTick:=true;

  OnPickEvent:=APickProc;
  if not Assigned(fOnPickEvent) then
  OnPickEvent:=PickEvent;

  Resume;
end;

procedure TDmwClient.PickEvent(Cmd: Integer; wm: twm_pointer);
var
  dbl: Integer;
begin
  if Cmd in [dmw_wm_occupe,dmw_wm_object] then
  if Assigned(fOnObject) then begin
    dbl:=ibool[Cmd = dmw_wm_object];
    fOnObject(wm.po.offs,dbl)
  end
end;

function TDmwAutoServer.xCreateObject: Boolean;
begin
  if not OpenObject(1024,dmw_Automation) then
  CreateObject(1024,dmw_Automation); Result:=Active
end;

constructor TDmwAutoClient.Create(APickProc: TPickProc);
begin
  inherited Create(0,dmw_Automation);
  OnPickEvent:=APickProc;
end;

constructor TObjClient.Create;
begin
  inherited Create;
  OpenObject(1024,Obj_Automation)
end;

procedure TObjClient.OpenDB(Path: PChar);
var
  wm: tdmw_wm_object;
begin
  if Active then begin
    ZeroMemory(@wm,Sizeof(wm));
    StrCopy(wm.name,Path);
    xSend(cmd_open_map,@wm,Sizeof(wm));
  end
end;

procedure TObjClient.ShiftBlank(Path: PChar; ind,delta: int);
var
  wm: tdmw_wm_object;
begin
  if Active then begin
    ZeroMemory(@wm,Sizeof(wm));
    StrCopy(wm.name,Path);
    wm.offs:=ind; wm.Code:=delta;
    xSend(id_shift_blank,@wm,Sizeof(wm));
  end
end;

function TAlwServer.xCreateObject: Boolean;
begin
  Result:=CreateObject(Sizeof(tbytes),alw_Exchange)
end;

constructor TAlwClient.Create(APickProc: TPickProc;
                              ASuspended: Boolean);
begin
  inherited Create(1024,alw_Exchange);
  OnPickEvent:=APickProc;

  if not ASuspended then Resume;
end;

constructor TAlwClient1.Create;
begin
  inherited Create(PickProc,true)
end;

procedure TAlwClient1.PickProc(ACmd: Integer; Awm: twm_pointer);
begin
  fCmd:=ACmd; fwm:=Awm
end;

function TAlwClient1.Query(out wm: twm_pointer): Integer;
begin
  fCmd:=-1; Takt; wm:=fwm;
  Result:=fCmd
end;

constructor TDmwPick.Create;
begin
  inherited Create(PickProc)
end;

procedure TDmwPick.PickProc(Cmd: Integer; wm: twm_pointer);
begin
  case Cmd of
dmw_wm_cancel:
    if Assigned(fOnPickCancel) then
    fOnPickCancel(Self);

dmw_wm_object:
    if Assigned(fOnPickObject) then
    fOnPickObject(Self,wm);

dmw_wm_occupe:
    if Assigned(fOnPickOccupe) then
    fOnPickOccupe(Self,wm);

dmw_wm_point:
    if Assigned(fOnPickPoint) then
    fOnPickPoint(Self,wm);

dmw_wm_vector:
    if Assigned(fOnPickVector) then
    fOnPickVector(Self,wm);

dmw_wm_rect:
    if Assigned(fOnPickRect) then
    fOnPickRect(Self,wm);

dmw_wm_port:
    if Assigned(fOnPickPort) then
    fOnPickPort(Self,wm);

dmw_wm_geoid:
    if Assigned(fOnPickGeoid) then
    fOnPickGeoid(Self,wm);

dmw_wm_ring:
    if Assigned(fOnPickRing) then
    fOnPickRing(Self,wm);

dmw_wm_draft:
    if Assigned(fOnPickDraft) then
    fOnPickDraft(Self,wm);

dmw_wm_poly:
    if Assigned(fOnPickPoly) then
    fOnPickPoly(Self,wm);

dmw_wm_map:
    if Assigned(fOnSwapMap) then
    fOnSwapMap(Self,wm);
  end
end;

constructor TAlwCommon.Create;
begin
  inherited Create; OpenClient
end;

function TAlwCommon.OpenClient: Boolean;
begin
  Result:=OpenObject(1024,alw_Automation);
end;

function TAlwCommon.GetActive1: Boolean;
begin
  if not Active and not finit then OpenClient;
  finit:=true; Result:=Active
end;

procedure TAlwCommon.sel_clear;
begin
  sel_del(-1)
end;

procedure TAlwCommon.sel_add(ptr: Integer);
begin
  xSend(cmd_sel_add,@ptr,4)
end;

procedure TAlwCommon.sel_del(ptr: Integer);
begin
  xSend(cmd_sel_del,@ptr,4)
end;

procedure TAlwCommon.sel_lock;
begin
  sel_add(-1000)
end;

procedure TAlwCommon.sel_unlock;
begin
  sel_add(-1001)
end;

procedure TAlwCommon.Show_Object(cn,id,up: Integer; scale: Double);
var
  obj: tdmw_wm_show_object;
begin
  ZeroMemory(@obj,Sizeof(obj));
  obj.cn:=cn; obj.id:=id; obj.up:=up;
  obj.scale:=scale;
  xSend(cmd_show_object,@obj,Sizeof(obj))
end;

function xSendMessage(Auto: PChar; Cmd: Integer;
                      Data: Pointer; DataLen: Integer;
                      Wait: Boolean): Boolean;
var
  com: TCommonObject; v: Longint;
begin
  Result:=false;

  if Strlen(Auto) > 0 then begin

    com:=TCommonObject.Create;
    try
      com.OpenObject(1024,Auto);
      if com.Active then begin

        com.IsWait:=Wait;

        if Assigned(Data) then
          com.xSend(Cmd,Data,DataLen)
        else begin
          v:=0; com.xSend(Cmd,@v,4)
        end;

        Result:=true
      end;
    finally
      com.Free
    end

  end
end;

function sSendMessage(Auto: PChar; Cmd: Integer;
                      Data: PChar; Wait: Boolean): Boolean;
begin
  Result:=xSendMessage(Auto,Cmd,Data,Strlen(Data)+1,Wait)
end;

function iSendMessage(Auto: PChar; Cmd,Val: Integer;
                      Wait: Boolean): Boolean;
begin
  Result:=xSendMessage(Auto,Cmd,@Val,4,Wait)
end;

function sDmwMessage(Cmd: Integer;
                     Data: PChar; Wait: Boolean): Boolean;
var
  com: TDmwCommand; v: Integer;
begin
  Result:=false;

  com:=TDmwCommand.Create;
  try
    if com.Connect then begin
      com.IsWait:=Wait;

      if Assigned(Data) then
        com.xSend(Cmd,Data,StrLen(Data)+1)
      else begin
        v:=0; com.xSend(Cmd,@v,4)
      end;

      Result:=true
    end;
  finally
    com.Free
  end
end;

procedure dmw_Draft(x1,y1,x2,y2,id: Integer);
var
  cmd: TDmwCommand;
begin
  cmd:=TDmwCommand.Create;
  try
    if cmd.Connect then
    cmd.ShowDraft(x1,y1,x2,y2,id)
  finally
    cmd.Free
  end
end;

end.

