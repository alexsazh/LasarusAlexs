unit Dmwlib;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType,
  Forms, Classes,
  List, Dmlib, Nums, llibx, Vlib;


type
  TDMW = class
    private
    public
    constructor Create;
    destructor Destroy; override;
    function CreateActiveDm: tdm;//ERROR=>Result=nil; --> DMW.FreeActiveDm(dm)!!!
    procedure FreeActiveDm(dm: tdm);//m.b. dm=nil
    function OpenDMA: boolean;//DMA:=TDM.Create(активная карта)
    procedure CloseDMA;
    function ActiveMap: string;
    //function PickObject(msg_pick,msg_cancel: boolean): longint;
    procedure Refresh;
    procedure Refresh2;//+setfocus
    procedure GetProjectMaps(list: tstrings);//ActiveMap+dmw_AllProject
  end;

var
  DMW: TDMW; //initialisation
  DMA: TDM; //OpenDMA-CloseDMA


//текущий объект:
function DMWCurrentObject: integer; overload;//default=-1
function DMWCurrentObject(var Loc: byte): integer; overload;//default=-1!

function DMWCurrentID: integer;

procedure DMWShowPoint(gx,gy: double);//новое окно в том же масштабе
procedure DMWShowObject(ofs: integer);//новое окно в том же масштабе (скачка нет, если знак видим!)

function DMWPrjContainsMap(pname: PChar): boolean;

//выбор кода в меню классификатора (для замены s0->s1 в Edit.Text):
function DMWChooseObject1(s0: string; var s1: string; loc_required: byte): boolean;

//текущее окно:
function DMWGetWindowGauss(var x1,y1,x2,y2: double): boolean;

//выборка:
procedure dmwlib_load_selection_offs(offsa: tinta);

//РИСОВАНИЕ: gr - "графика", карта закрыта:
//gr=777 - синий, толстая линия:
function dmwlib_gr_from_current: longint;//графика

procedure dmwlib_draw_pl(pl: tpl; loc: byte; gr: longint);
procedure dmwlib_draw_plgauss(pl: tpl; loc: byte; gr: longint);
procedure dmwlib_draw_plgauss_h(pl: tpl; loc: byte; gr,grh: longint);//карта закрыта, С ДЫРКАМИ!

procedure dmwlib_draw_rect(a,b: tnum2; loc: byte; gr: longint); overload;
procedure dmwlib_draw_rect(a,b: TPoint; loc: byte; gr: longint); overload;
//procedure dmwlib_draw_rectbl(a,b: tnum2; loc: byte; gr: longint);
procedure dmwlib_draw_rectgauss(a,b: tnum2; loc: byte; gr: longint);

procedure dmwlib_draw_plgauss_list(pllist: tclasslist; loc: byte; gr: longint);

procedure dmwlib_draw_marker_gauss(p: tnum2; _wincheck: boolean = false{сдвиг окна});
procedure dmwlib_clear_marker;


implementation

uses
  SysUtils, Dialogs,
  Dmw_ddw, Dmw_use, Otypes,
  Wcmn;


function DMWCurrentID: integer;
var id,Code: longint; Tag: byte;
begin
  if dmi_LinkObject(id,Code, Tag) then Result:=id else Result:=-1;
end;

procedure DMWShowPoint(gx,gy: double);//новое окно в том же масштабе
var agx,agy,scale: double;
begin
  if dmw_GetCentre(agx,agy,scale)
  and dmw_ShowPoint(gx,gy,scale)
  then dmw_SetFocus;
end;

procedure DMWShowObject(ofs: integer);//новое окно в том же масштабе
var agx,agy,scale: double;
begin
  dmw_FreeObject;//?
  if ofs<=0 then exit;//!
  try
    if dmw_GetCentre(agx,agy,scale)
    and dmw_ShowObject(ofs,scale)
    then dmw_SetFocus;
  except
  end;
end;

function DMWPrjContainsMap(pname: PChar): boolean;
var i,n,l: integer; PrjMap: array [0..1023] of char;
begin
  Result:=false;
  try
    n:=dmw_MapsCount;
    l:=StrLen(pname);
    if n>0 then for i:=0 to n-1 do
      if AnsiStrLIComp( dmw_ProjectMap(i, PrjMap, 1023), pname, l)=0 then begin
        Result:=true;
        break;
      end;
  except
  end;
end;

//выьор кода в меню классификатора (для замены s0->s1 в Edit.Text):
function DMWChooseObject1(s0: string; var s1: string; loc_required: byte): boolean;
var lcode0,lcode1: longint; loc1: byte;
begin
  s1:='';
  lcode0:=StringToLCode(s0);
  Result:=dmw_ChooseObject(lcode0,loc_required, lcode1,loc1, nil,0);
  if Result and (loc1=loc_required) then s1:=LCodeToString(lcode1)
  else Result:=false;
end;

function DMWCurrentObject: integer;//default=-1!
var offs,Code: longint; Tag: byte; x1,y1,x2,y2: longint;
begin
  offs:=-1;
  dmw_OffsObject(offs,Code, Tag, x1,y1,x2,y2, nil,0);//default=0!
  if offs=0 then offs:=-1;//!
  Result:=offs;
end;

function DMWCurrentObject(var Loc: byte): integer;//default=-1!
var offs,Code: longint; x1,y1,x2,y2: longint;
begin
  offs:=-1;
  dmw_OffsObject(offs,Code, Loc, x1,y1,x2,y2, nil,0);//default=0!
  if offs<=0 then offs:=-1;//!
  Result:=offs;
end;

function DMWGetWindowGauss(var x1,y1,x2,y2: double): boolean;
var lx1,ly1,lx2,ly2: longint;
begin
  Result := dmw_GetWindow(lx1,ly1,lx2,ly2);
  if not Result then exit;
  if not dmw_L_to_G(lx1,ly2, x1,y1) or not dmw_L_to_G(lx2,ly1, x2,y2) then Result:=false;
end;


procedure dmwlib_load_selection_offs(offsa: tinta);
var i: integer;
begin
  offsa.Clear;
  offsa.Count:=dmw_sel_Objects_Count;
  if offsa.Count>0 then for i:=0 to offsa.Count-1 do offsa[i]:=dmw_sel_Objects(i);
end;


function dmwlib_gr_from_current: longint;//графика, карта закрыта
var offs,Code: longint; Loc: byte; x1,y1,x2,y2: longint;
begin
  dmw_OffsObject(offs,Code, Loc, x1,y1,x2,y2, nil,0);
  Result:=dm_Get_Graphics(Code, Loc);
end;


procedure dmwlib_draw_pl(pl: tpl; loc: byte; gr: longint);
var dmpl: pLLine;
begin
  if pl.Count<=0 then exit;
  dmpl:=NewDmPolyFromPa2(pl, false{Gauss}, false{dm_opened});
  try
    dmw_DrawPoly(dmpl, loc,gr);
  finally
    FreeDmPoly(dmpl);
  end;
end;

procedure dmwlib_draw_plgauss(pl: tpl; loc: byte; gr: longint);//карта закрыта
var dmpl: pLLine;
begin
  if pl.Count<=0 then exit;
  dmpl:=NewDmPolyFromPa2(pl, true{Gauss}, false{dm_opened});
  try
    dmw_DrawPoly(dmpl, loc,gr);
  finally
    FreeDmPoly(dmpl);
  end;
end;

procedure dmwlib_draw_plgauss_h(pl: tpl; loc: byte; gr,grh: longint);//карта закрыта, С ДЫРКАМИ!
var plh: tpl;
begin
  dmwlib_draw_plgauss(pl, loc, gr);

  //Дырки:
  plh:=pl.Next;
  while (grh>=0){!} and Assigned(plh) do begin
    dmwlib_draw_plgauss(plh, loc, grh);
    plh:=plh.Next;
  end;//while
end;


procedure dmwlib_draw_rect(a,b: tnum2; loc: byte; gr: longint);
var pl: tpl;
begin
  pl:=tpl.New;
  try
    pl.AddRect(a.x,a.y, b.x,b.y);
    dmwlib_draw_pl(pl,loc,gr);
  finally
    pl.Free;
  end;
end;
(*
procedure dmwlib_draw_rectbl(a,b: tnum2; loc: byte; gr: longint);
var ax,bx: tnum2;
begin
  dmw_L_to_R

end;
*)
procedure dmwlib_draw_rect(a,b: TPoint; loc: byte; gr: longint);
var ax,bx: tnum2;
begin
  ax:=v_point(a);
  bx:=v_point(b);
  dmwlib_draw_rect(ax,bx,loc,gr);
end;

procedure dmwlib_draw_rectgauss(a,b: tnum2; loc: byte; gr: longint);//карта закрыта
var pl: tpl;
begin
  pl:=tpl.New;
  try
    pl.AddRect(a.x,a.y, b.x,b.y);
    dmwlib_draw_plgauss(pl,loc,gr);
  finally
    pl.Free;
  end;
end;


procedure dmwlib_draw_plgauss_list(pllist: tclasslist; loc: byte; gr: longint);//карта закрыта
var i: integer; pl: tpl;
begin
  if pllist.Count>0 then for i:=0 to pllist.Count-1 do begin
    tobject(pl):=pllist[i];
    dmwlib_draw_plgauss(pl, loc,gr);
  end;
end;


procedure dmwlib_draw_marker_gauss(p: tnum2; _wincheck: boolean = false);
var ix,iy,x1,y1,x2,y2: integer; gx,gy,sc: double;
begin
  if not dmw_G_to_L(p.x,p.y, ix,iy) then exit;
  dmw_ext_Draft(ix,iy, ix,iy, 101);
  if _wincheck then begin
    if not dmw_GetWindow(x1,y1,x2,y2) then exit;
    if (ix<=x1) or (ix>=x2) or (iy<=y1) or (iy>=y2) then begin
      if dmw_GetCentre(gx,gy,sc) and dmw_L_to_G(ix,iy, gx,gy)
      then dmw_ShowPoint(gx,gy,sc);
    end;
  end;//_wincheck
end;

procedure dmwlib_clear_marker;
begin
  dmw_ext_Draft(0,0, 0,0, 0);
end;


//========================================================

{ TDmw: }

constructor TDmw.Create;
begin
  inherited Create;
end;

destructor TDmw.Destroy;
begin
  inherited Destroy;
end;

function TDmw.CreateActiveDm: tdm;
var dm_name: string;
begin
  Result:=nil;
  dm_name:=ActiveMap;
  if Length(dm_name)>0 then begin
//    dmw_FreeObject;//=> НЕ БУДЕТ ОШИБКИ dm_Open!!!
    if dmw_HideMap then try
      Result:=tdm.create(dm_name);
      if not Result.Ok then begin
        Result.free;
        Result:=nil;
      end;
    except
    end
    else
      Tell('TDmw.CreateActiveDm: dmw_HideMap=false');
  end else begin
    Tell(telllist[7]);
  end;
end;

procedure TDmw.FreeActiveDm(dm: tdm);
begin
  dm.free;
  dmw_BackMap;
end;


function TDmw.OpenDMA: boolean;//DMA:=TDM.Create(активная карта)
begin
  DMA:=CreateActiveDm;//message!
  Result := DMA<>nil;
end;

procedure TDmw.CloseDMA;
begin
  FreeActiveDm(DMA);
end;

function TDmw.ActiveMap: string;
var zs_active: array[1..1024]of Char;
begin
  Result:='';
  zs_active[1]:=#0;
  try
    if dmw_ActiveMap(@zs_active[1],1023)<>nil then Result:=StrPas(@zs_active[1]);
  except
    Result:='';
  end;
end;

procedure TDmw.Refresh;
begin
  dmw_ShowWindow(1,1,0,0);
end;

procedure TDmw.Refresh2;
begin
  dmw_ShowWindow(1,1,0,0);
  dmw_setfocus;
end;


procedure TDmw.GetProjectMaps(list: tstrings);//ActiveMap+dmw_AllProject
var f: TextFile; fname: array[1..1024]of char; s: string;
begin
  list.Clear;
  if length(ActiveMap)>0 then list.Add(ActiveMap);

  dmw_AltProject(@fname[1],1023);
  if ftopen(f, StrPas(@fname[1]), 'r') then try
    while not eof(f) do begin
      readln(f, s);
      if length(s)>0 then list.Add(s) else break;
    end;//while
  finally
    ftclose(f);
  end;
end;

//====================================================

initialization
  DMW:=TDMW.Create;
finalization
  DMW.Free;

end.
