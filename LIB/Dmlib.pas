{
  use dmw_Use, dm_util;
  тексты (TDmTxt) см. в dmtxt.pas
}
unit Dmlib;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType,
  OTypes, dm_util,
  Arrayx, List, Nums, Vlib, LLIB, llibx, Types;


type
  TDm = class
  public
    FullName: string;
    ShortObjName,FullObjName: string;//903-string, EXEDIR\..\OBJ
    lsc: longint;//масштаб (dm_Scale: longint)
    lpmm: double;//long / мм бумаги
    mpl: double;//м местности / мм бумаги (dm_Resolution)
    constructor Create0;
    constructor Create(aFullName: string);//dm_Open+LoadData; Ok<=>FullName<>''
    destructor Destroy; override;//dm_Done
    function Ok: boolean;//lpmm>0 & FullName<>''
    procedure LoadData(aFullName: string);
    function SetLayer(lcode: longint; ClearLayer: boolean): longint;
    //procedure GetMapBound(pl: tpl);
  end;

  TDmo = class //loc=1,2,3
  protected
    FGauss: boolean;//from Create2 (=> гауссовы координаты)
    FUseGraph: boolean;//from Create2
    FGraph: longint;//from OBJ if FUseGraph (for Draw)
    function GetSCode: string;
    procedure PutSCode(aSCode: string);
  public
    ID1000: integer;//1000-ая хар-ка (Read0)
    dmoffset: longint;//смещение в dm-файле (для 2D-отображения) (Read0, Add)
    Loc: byte;       //0=M; 1=S; 2=L; 3=A; 4=T;
    LCode: longint;
    Points: tpl;     //Path (llibx.pas)
    constructor Create;
    constructor Create2(aGauss: boolean = true; aUseGraph: boolean = false);//default - Гаусс без графики
    constructor CreateCode(aLoc: byte; aLCode: longint);
    constructor CreateCode2(aLoc: byte; aLCode: longint; aGauss: boolean = true; aUseGraph: boolean = false);//default - Гаусс без графики
    //без дырок:
    constructor CreateFromDm0;
    //с дырками(!) (для дырки возвращает пустой объект):
    constructor CreateFromDm;
    constructor CreateFromDm2(aGauss: boolean = true; aUseGraph: boolean = false);//default - Гаусс без графики

    destructor Destroy; override;
    procedure Clear; virtual;
    procedure SetPoints(aPoints: tpa);//CopyFrom!
    function InfoString(ofs: integer): string;//scode (loc) (ofs>0)

    //Functions on dm-File (between dm_Open & dm_Done):
    procedure ReadPoints;//from dm-file; read A,B;
    procedure WritePoints;//to dm-file; Set_Bound - auto!
    procedure Read0; virtual;//from dm-file; use ReadPoints;
    procedure Read; virtual;//с дырками(!)
    procedure Write; virtual;//to dm-file; use WritePoints;
    function Add(down: boolean): longint; virtual;//to dm-file;
    procedure DrawSignAt(a,b: tnum2; dm_open_ok: boolean; aVgmName: PChar);//рисование без добавления в карту, VgmName м.б. nil
    procedure Draw(dm_open_ok: boolean; aVgmName: PChar);//рисование без добавления в карту, VgmName м.б. nil

    procedure DelChildren;
    procedure DelChildren2;//кроме дырок
    //аппроксимация Безье-кривых:
    procedure BezToPl(step: tnum);

    property SCode: string read GetSCode write PutSCode; //<->lcode
    property Graph: integer read FGraph;
  end;

  tdmobj = tdmo;//совместимость

  //выборка:
  tdmofslist = class(tintarray)
  public
    function load_dmw_selection(_msg: boolean): integer; overload;
    procedure load_dmw_selection; overload;
    procedure del_objects;//карта открыта
  end;


var
  //используется в tdmobj.add, tdmtxt.add, если <>nil;
  //New, Free - СНАРУЖИ!,
  dmlib_undo_list: tdmofslist;


{ Functions: }

function dmlib_ReadString(nc: word; var s: string): boolean;//Win-кодировка (default='')
procedure dmlib_WriteString(nc: word; s: string);//Win-кодировка

function dmlib_Open(pFullName: PAnsiChar; _edit: boolean): boolean;//1000 раз!

//----------------------------------------------

procedure DmGetMapBound(pl: tpl);//рамка карты

//min,max широт(lat) и долгот(lon) карты (радианы, южная<0, восточная<0):
procedure DmGetMapLatsLons(var latmin,lonmin, latmax,lonmax: double);
procedure DmGetMapLats(var latmin,latmax: double);
procedure DmGetMapLons(var lonmin,lonmax: double);

function DmObjName(DmName: string): string;//"100" из паспорта (без пути!)
function DmObjDirName(DmName: string): string;//"c:\neva\obj\100" - главная функция!
function DmVgmPath(DmName: string): string;//"c:\neva\obj\100.vgm"

{ dm_util: }

//координаты хранения, dmw_use - закрыта(!)
//LD - лев.нижн. ; RD - прав.нижн. ; LU - лев.верх.
function DmCopyRectRot(dm_in, dm_out: string; LD,RD,LU: tnum2): boolean;

//-------------------------------

//изменение рамки - в мм(!) - увеличение рамки при left,right,up,down>0; карта не открыта нигде(!):
function DmChangeBound0(dmname: string; left,right,up,down: tnum; var box1,box2: tnum4): boolean;
function DmChangeBound(dmname: string; left,right,up,down: tnum): boolean;

//точки привязки - в углах рамки карты:
//первая - лев.верхняя:
function DmMapToPlan1(dmname: string): boolean;
//bl_LD - лев.нижняя точка (в глоб.коорд-ах) -> (0;0) Гаусса на плане
function DmMapToPlan2(dmname: string; g_LD: tnum2): boolean;

//lscale - лишний пар-р - опред-ся по номенклатуре(!):
function Create_Dm_BL(spath,sobj,snom: string; lscale: longint): TDm;

//коды с буквой (!!!):
function LCodeToString(code:longint):string;
function StringToLCode(scode:string):longint;


//-------------------------------

//преобраз-ие типа:
function LpToNum2(lp: lpoint): tnum2;
function Num2ToLp(rp: tnum2): lpoint ;

function dmlib_L_to_G(pl: tnum2): tnum2;//карта открыта

function dmlib_L_to_R0(pl: tnum2): tnum2;//РАДИАНЫ - карта открыта
function dmlib_L_to_R(pl: tnum2): tnum2;//градусы - карта открыта!

//Gauss: if dm_open_ok then dm_L_to_G else dmw_L_to_G:
function LpToNum2Gauss(lp: lpoint; dm_open_ok: boolean): tnum2;
function Num2GaussToLp(rp: tnum2; dm_open_ok: boolean): lpoint ;

procedure PaToLBound(pa: tpa; var la,lb: lpoint);//Round(Box)

//pLLine <-> TPa:
function NewDmPoly(count: tint): pLLine; //Result^N:=count-1; точки: (0;0); ---> Free(!)
function NewDmPolyFromPa(pa: tpa): pLLine; //use NewDmPoly; ---> Free(!)
procedure FreeDmPoly(lp: pLLine);
procedure DmPolyToPa(lp: pLLine; pa: tpa); //pa.clear

//Gauss: if dm_open_ok then dm_L_to_G else dmw_L_to_G:
function NewDmPolyFromPa2(pa: tpa; _Gauss, dm_open_ok: boolean): pLLine;
procedure DmPolyToPa2(lp: pLLine; pa: tpa; _Gauss, dm_open_ok: boolean);//pa.clear

//lp уже создана, lp^.Pol должна вместить pa(!):
procedure PaToDmPoly(pa: tpa; lpl: pLLine; _Gauss, dm_open_ok: boolean);

//Functions on dm-File (between dm_Open & dm_Done):

procedure PaToDmFile(pa: tpa);//to current dm-object
procedure PaFromDmFile(pa: tpa);//from current dm-object, pa.clear!
procedure PaToDmFile2(pa: tpa; _Gauss: boolean);//to current dm-object
procedure PaFromDmFile2(pa: tpa; _Gauss: boolean);//from current dm-object, pa.clear!

procedure dmlib_ofs_to_pl(ofs: integer; pl: tpl; _Gauss: boolean);//карта открыта, с дырками!

//Разное:
function DmObjectIsHole: boolean;//code(parent)=code


//DRAW:

var dmlib_draw_ofs: integer;//устанавливается в DmDrawLine

function DmDrawVector(lcode: longint; x1,y1,x2,y2: tnum; down, saveposition: boolean): boolean;
function DmDrawRect0(loc,lcode: integer; x1,y1,x2,y2: tnum; down, saveposition: boolean): boolean;
function DmDrawRect(lcode: longint; x1,y1,x2,y2: tnum; down, saveposition: boolean): boolean;
//down=>saveposition:
function DmDrawLine0(pa: tpa; loc: byte; lcode: longint; down: boolean): boolean;
function DmDrawLine(pa: tpa; lcode: longint; down: boolean): boolean;
function DmDrawArea(pa: tpa; lcode: longint; down: boolean): boolean;

function DmDrawVectorGauss(p1,p2: tnum2; loc: byte; lcode: longint; down: boolean): boolean;
//down=>saveposition:
function DmDrawLineGauss(pa: tpa; loc: byte; lcode: longint; down: boolean): boolean;

//lines: list of tpa; все линии - на 1-ом уровне; down - для первой
//down=true => с возвратом:
function DmDrawList(lines: tclasslist; loc: byte; lcode: longint; down: boolean): boolean;
function DmDrawListGauss(lines: tclasslist; loc: byte; lcode: longint; down: boolean): integer;//кол-во добавленных

//pa - пары точек (2-path), down => все отрезки дочерние (тогда с возвратом):
//ofs_list m.b. =nil:
function DmDrawVectors(pa: tpa; lcode: longint; down: boolean; ofs_list: tintarray): boolean;

function DmSetLayer(lcode: longint; ClearLayer: boolean): longint;//Result=offset
function DmSetObjLayer(obj_lcode: longint): longint;//по первым 2-м буквам

implementation

uses
  SysUtils,
  dmw_Use, Dmw_ddw,
  Wcmn, Curve;


//==========================================================================

{ Functions: }

function dmlib_ReadString(nc: word; var s: string): boolean;//Win-кодировка (default='')
var sShort: ShortString;
begin
  Result:=dm_Get_String(nc,254,sShort);
  //if Result then s:=wcmn_dos2win(sShort) else s:='';//default!
  if Result then s:=sShort else s:='';//default!
end;

procedure dmlib_WriteString(nc: word; s: string);//Win-кодировка
begin
  //dm_Put_String( nc, PChar(wcmn_win2dos(s)) );
  dm_Put_String( nc, PChar(s) );
end;


function dmlib_Open(pFullName: PAnsiChar; _edit: boolean): boolean;
var i: integer;
begin
    for i:=1 to 1000 do begin
      dm_Done;
      Result := dm_Open(pFullName, _edit)>0;
      if Result then break;
    end;
end;


procedure DmGetMapBound(pl: tpl);
var ofs0: integer;
begin
  ofs0:=dm_object;//save
  dm_goto_root;
  PaFromDmFile(pl);//pl.clear
  dm_goto_node(ofs0);//restore
end;


procedure DmGetMapLatsLons(var latmin,lonmin, latmax,lonmax: double);
var la,lb: lpoint; pl: tpl;
begin
  pl:=tpl.new;
  try
    DmGetMapBound(pl);
    la:=Num2ToLp(pl.Box.a);
    lb:=Num2ToLp(pl.Box.b);
    dm_L_to_R(la.x,la.y, latmax,lonmin);
    dm_L_to_R(lb.x,lb.y, latmin,lonmax);
  finally
    pl.Free;
  end;
end;

procedure DmGetMapLats(var latmin, latmax: double);
var lonmin, lonmax: double;
begin
  DmGetMapLatsLons(latmin,lonmin, latmax,lonmax);
end;

procedure DmGetMapLons(var lonmin, lonmax: double);
var latmin, latmax: double;
begin
  DmGetMapLatsLons(latmin,lonmin, latmax,lonmax);
end;


function DmObjName(DmName: string): string;
var s: ShortString;
begin
  Result:='';
  if dmlib_open(PChar(DmName), false) then try
    dm_goto_root;
    if dm_get_string(903, 255, s) then Result:=s;
    if Result<>'' then Result:=wcmn_file_name(Result);//!!!
  finally
    dm_done;
  end;
end;

function DmObjDirName(DmName: string): string;
begin
  Result := DmObjName(DmName);//"100"
  if Result<>'' then Result := UpperDir(ExeDir) + 'OBJ\' + Result;
end;

function DmVgmPath(DmName: string): string;
begin
  Result := DmObjDirName(DmName) + '.VGM';
end;


{ dm_util: }

function DmCopyRectRot(dm_in, dm_out: string; LD,RD,LU: tnum2): boolean;
var lp1,lp2,la,lb,lc: lpoint; vw,vh: tnum2; w,h: tnum;
begin
  Result:=true;
  w:=v_dist(LD,RD);
  h:=v_dist(LD,LU);
  vw:=v_xy(w,0);//вправо
  vh:=v_xy(0,-h);//вверх!

  lp1 := Num2ToLp( v_add(LD, vh) );//лев.верх.
  lp2 := Num2ToLp( v_add(LD, vw) );//прав.нижн.

  la := Num2ToLp(LD);
  lb := Num2ToLp(RD);
  lc := Num2ToLp( v_prj(LD, v_add(LD, vw), RD) );//проекция RD на OX
  //lc := Num2ToLp( vw );

  if FileExists(dm_out) then if not DeleteFile(dm_out) then begin
    Result:=false;
    Tellf(telllist[3],[dm_out]);
    exit;//!
  end;

  dm_Cut(PChar(dm_in),PChar(dm_out),NIL, lp1.x,lp1.y,lp2.x,lp2.y, NIL, la,lb,lc, true);
end;

//--------------------------------------------------------------------------


//изменение рамки - в мм(!); карта не открыта нигде(!):
function DmChangeBound0(dmname: string; left,right,up,down: tnum; var box1,box2: tnum4): boolean;
var dm: tdm; pl: tpl;
begin
  Result:=false;
  pl:=tpl.new;
  dm:=tdm.Create(dmname);
  try
    if dm.Ok then begin
      dm_goto_root;
      PaFromDmFile(pl);//экранная С.К.
      box1:=pl.Box;

      box2.a.x:=box1.a.x-left*dm.lpmm;
      box2.a.y:=box1.a.y-up*dm.lpmm;
      box2.b.x:=box1.b.x+right*dm.lpmm;
      box2.b.y:=box1.b.y+down*dm.lpmm;

      pl.clear;
      pl.AddRect(box2.a.x,box2.a.y,box2.b.x,box2.b.y);

      //pl.Reverse;//???
      PaToDmFile(pl);//экранная С.К.
      Result:=true;
    end;
  finally
    dm.Free;
    pl.Free;
  end;
end;
function DmChangeBound(dmname: string; left,right,up,down: tnum): boolean;
var box1,box2: tnum4;
begin
  Result:=DmChangeBound0(dmname, left,right,up,down, box1,box2);
end;


//точки привязки - в углах рамки карты:
//первая - лев.верхняя:
function DmMapToPlan1(dmname: string): boolean;
var dm: tdm; la,lb: lpoint; gx,gy: double; offs,n: longint;
begin
  Result:=false;
  dm:=tdm.Create(dmname);
  try
    if dm.Ok then begin
      dm_goto_root;
      dm_get_bound(la,lb);
      dm_put_byte(901, 0);//0-план, 1-карта

      gx := (lb.y-la.y)*dm.mpl ; //ВВЕРХ!
      gy := (lb.x-la.x)*dm.mpl ; //ВПРАВО!

      //точки привязки:
      n:=0;
      offs:=dm_Find_Frst_Code(0, 1);
      while offs>0 do begin
        inc(n);

        case n of
          1: begin
            dm_put_Real(901, gx);
            dm_put_Real(902, 0);
          end;
          2: begin
            dm_put_Real(901, gx);
            dm_put_Real(902, gy);
          end;
          3: begin
            dm_put_Real(901, 0);
            dm_put_Real(902, gy);
          end;
          4: begin
            dm_put_Real(901, 0);
            dm_put_Real(902, 0);
          end;
          else begin
            //dm_Delete_Object(0, dm_object);
          end;
        end;//case

        offs:=dm_Find_Next_Code(0, 1);
      end;//while

      Result:=true;
    end;
  finally
    dm.Free;
  end;
end;

function DmMapToPlan2(dmname: string; g_LD: tnum2): boolean;
var dm: tdm; LD,la,lb: lpoint; gx,gy: double; offs,n: longint;
begin
  Result:=false;
  dm:=tdm.Create(dmname);
  try
    if dm.Ok then begin
      dm_G_to_L(g_LD.x,g_LD.y, LD.x,LD.y);

      //точки привязки:
      n:=0;
      offs:=dm_Find_Frst_Code(0, 1);
      while offs>0 do begin
        inc(n);

        dm_get_bound(la,lb);

        gx := (LD.y-la.y)*dm.mpl ; //ВВЕРХ!
        gy := (la.x-LD.x)*dm.mpl ; //ВПРАВО!
(*
        gx := (LD.y-la.y) ; //ВВЕРХ!
        gy := (la.x-LD.x) ; //ВПРАВО!
*)
        dm_put_Real(901, gx);
        dm_put_Real(902, gy);

        if n>4 then begin
          //dm_Delete_Object(0, dm_object);
        end;

        offs:=dm_Find_Next_Code(0, 1);
      end;//while

      //карта->план:
      dm_goto_root;
      dm_put_byte(901, 0);//0-план, 1-карта

      Result:=true;
    end;
  finally
    dm.Free;
  end;
end;


function Create_Dm_BL(spath,sobj,snom: string; lscale: longint): TDm;
const maxcharind=511;
var
  zs_path,zs_obj,zs_nom: array[0..maxcharind]of Char;
  r: double;
begin
  Result:=nil;
  StrPCopy(zs_path,spath);
  StrPCopy(zs_obj,sobj);
  StrPCopy(zs_nom,snom);
  if bl_Make(zs_path,zs_obj,zs_nom)>0 then begin
    Result:=TDm.Create(spath);

    dm_goto_root;
    dm_Put_Long(904,lscale);
    r:=dm_Resolution; //m/l
    try
      Result.lpmm:=lscale/(r*1000);
    except
      Result.Free;
      Result:=nil;
    end;
  end;
end;



function LCodeToString(code:longint):string;
var st:string; sd,lnumb: longint;
begin
  sd:=code div 10000000;
  lnumb:=code mod 10000000;
  st:=Format('%7.7d',[lnumb]);
  Result:=chr(48{ord('0')}+sd)+st;
end;

function StringToLCode(scode:string):longint;
var st:string;
begin
  Result:=0;
  if length(scode) =0 then exit;
  if length(scode) < 8 then begin
    Result := StrToInt(scode);
  end else begin
    st:=Scode+#0;
    Result:=(ord(scode[1])-48{ord('0')})*10000000+ StrToInt(strpas(@st[2]));
  end;
end;

function LpToNum2(lp: lpoint): tnum2;
begin
  Result.x:=lp.x;
  Result.y:=lp.y;
end;
function Num2ToLp(rp: tnum2): lpoint ;
begin
  Result.x:=Round(rp.x);
  Result.y:=Round(rp.y);
end;

function dmlib_L_to_G(pl: tnum2): tnum2;//карта открыта
var lp: TPoint;
begin
  lp := v_round(pl);
  dm_L_to_G(lp.x,lp.y, Result.x,Result.y);
end;


function dmlib_L_to_R0(pl: tnum2): tnum2;//РАДИАНЫ - карта открыта
var lp: TPoint;
begin
  lp := v_round(pl);
  dm_L_to_R(lp.x,lp.y, Result.x,Result.y);
end;

function dmlib_L_to_R(pl: tnum2): tnum2;//градусы - карта открыта
begin
  Result:=dmlib_L_to_R0(pl);
  Result.x := grad(Result.x);//широта B
  Result.y := grad(Result.y);//долгота L
end;


function LpToNum2Gauss(lp: lpoint; dm_open_ok: boolean): tnum2;
begin
  if dm_open_ok then
    dm_L_to_G(lp.x,lp.y, Result.x,Result.y)
  else
    if not dmw_L_to_G(lp.x,lp.y, Result.x,Result.y)
    then Tell('LpToNum2Gauss: dmw_L_to_G = FALSE');
end;
function Num2GaussToLp(rp: tnum2; dm_open_ok: boolean): lpoint ;
begin
  if dm_open_ok then
    dm_G_to_L(rp.x,rp.y, Result.x,Result.y)
  else
    if not dmw_G_to_L(rp.x,rp.y, Result.x,Result.y) then Tell('Num2GaussToLp: dmw_L_to_G = FALSE');
end;

procedure PaToLBound(pa: tpa; var la,lb: lpoint);//Round(Box)
var box: tnum4;
begin
  box:=pa.GetBox;
  la.x:=Round(box.a.x);
  la.y:=Round(box.a.y);
  lb.x:=Round(box.b.x);
  lb.y:=Round(box.b.y);
end;


function NewDmPoly(count: tint): pLLine;
begin
  //точки обнуляются:
  Result := pLLine( malloc( (count+2)*sizeof(lpoint) ) );//на всякий случай!!!
  if Result<>nil then Result^.N:=count-1;
end;

function NewDmPolyFromPa(pa: tpa): pLLine;//---> Free(!)
//var i: tint; rp: tnum2; lp: lpoint;
begin
  Result:=NewDmPolyFromPa2(pa, false, false);
(*
  Result:=NewDmPoly(pa.count);
  if Result=nil then exit;
  if pa.count>0 then for i:=0 to pa.count-1 do begin
    rp:=pa[i];
    lp:=Num2ToLp(rp);
    Result^.Pol[i]:=lp;
  end;
*)
end;

function NewDmPolyFromPa2(pa: tpa; _Gauss, dm_open_ok: boolean): pLLine;
var i: tint; rp: tnum2; lp: lpoint;
begin
  Result:=NewDmPoly(pa.count);
  if Result=nil then exit;
  if pa.count>0 then for i:=0 to pa.count-1 do begin
    rp:=pa[i];

    if _Gauss then lp:=Num2GaussToLp(rp, dm_open_ok)
    else lp:=Num2ToLp(rp);

    Result^.Pol[i]:=lp;
  end;
end;

procedure FreeDmPoly(lp: pLLine);
begin
  mfree2(lp);
end;

procedure DmPolyToPa(lp: pLLine; pa: tpa);
//var count,i: tint; p: tnum2;
begin
  DmPolyToPa2(lp, pa, false, false);
(*
  pa.clear;
  count:=lp^.N+1;
  if count>0 then for i:=0 to count-1 do begin
    p.x:=lp^.Pol[i].x;
    p.y:=lp^.Pol[i].y;
    pa.add(p);
  end;
*)
end;

procedure DmPolyToPa2(lp: pLLine; pa: tpa; _Gauss, dm_open_ok: boolean);//pa.clear
var count,i: tint; p: tnum2;
begin
  pa.clear;
  count:=lp^.N+1;
  if count>0 then for i:=0 to count-1 do begin
    if _Gauss then p:=LpToNum2Gauss(lp^.Pol[i], dm_open_ok)
    else p:=LpToNum2(lp^.Pol[i]);
    pa.add(p);
  end;
end;

procedure PaToDmPoly(pa: tpa; lpl: pLLine; _Gauss, dm_open_ok: boolean);
var i: tint; lp: lpoint;
begin
  lpl^.N:=pa.count-1;
  if pa.count>0 then for i:=0 to pa.count-1 do begin
    if _Gauss then lp:=Num2GaussToLp(pa[i], dm_open_ok)
    else lp:=Num2ToLp(pa[i]);
    lpl^.Pol[i]:=lp;
  end;//for i
end;

procedure PaToDmFile(pa: tpa);//to current dm-object
//var lp: pLLine;
begin
  PaToDmFile2(pa, false);
(*
  lp:=NewDmPolyFromPa(pa);
  if lp=nil then exit;
  dm_Set_Poly_Buf(lp);
  FreeDmPoly(lp);
*)
end;
procedure PaToDmFile2(pa: tpa; _Gauss: boolean);//to current dm-object
var lp: pLLine;
begin
  lp:=NewDmPolyFromPa2(pa, _Gauss, true);
  if lp=nil then exit;
  dm_Set_Poly_Buf(lp);
  FreeDmPoly(lp);
end;

procedure PaFromDmFile(pa: tpa);//from current dm-object, pa.clear
//var count: tint; lp: pLLine;
begin
  PaFromDmFile2(pa, false);
(*
  pa.clear;
  count:=dm_Get_Poly_Count+1;
  lp:=NewDmPoly(count); if lp=nil then exit;
  try
    dm_Get_Poly_Buf(lp, count-1);
    DmPolyToPa(lp,pa);
  finally
    FreeDmPoly(lp);
  end;
*)
end;

procedure PaFromDmFile2(pa: tpa; _Gauss: boolean);//from current dm-object, pa.clear!
var count: tint; lp: pLLine;
begin
  pa.clear;
  count:=dm_Get_Poly_Count+1;
  lp:=NewDmPoly(count); if lp=nil then exit;
  try
    dm_Get_Poly_Buf(lp, count-1);
    DmPolyToPa2(lp,pa, _Gauss, true);
  finally
    FreeDmPoly(lp);
  end;
end;

procedure dmlib_ofs_to_pl(ofs: integer; pl: tpl; _Gauss: boolean);//карта открыта
var dmo: tdmo;
begin
  pl.Clear;
  if dm_goto_node(ofs) then begin
    dmo:=tdmo.CreateFromDm2(_Gauss, false);//с дырками!
    try
      pl.AddFrom(dmo.Points);

      //перенос дырок:
      pl.Next:=dmo.Points.Next;
      dmo.Points.Next:=nil;//!
    finally
      dmo.Free;
    end;
  end;
end;

function DmObjectIsHole: boolean;
var loc,lcode,ofs: integer;
begin
  Result:=false;
  loc:=dm_Get_Local;
  if loc<>3 then exit;
  lcode:=dm_Get_Code;
  ofs:=dm_object;
  if dm_goto_upper then begin
    if (lcode=dm_Get_Code) and (loc=dm_Get_Local) then Result:=true;
    dm_goto_node(ofs);
  end;
end;


function DmDrawVector(lcode: longint; x1,y1,x2,y2: tnum; down, saveposition: boolean): boolean;
var ofs0: integer; dmo: tdmobj;
begin
  Result:=false;
  if lcode<=0 then exit;//!

  if saveposition then ofs0:=dm_object else ofs0:=0;
  dmo:=tdmobj.createcode(2,lcode);
  try
    dmo.points.Add( v_xy(x1,y1) );
    dmo.points.Add( v_xy(x2,y2) );
    dmlib_draw_ofs := dmo.add(down);
    Result := dmlib_draw_ofs>0 ;
  finally
    dmo.free;
    if saveposition then dm_goto_node(ofs0);
  end;
end;

function DmDrawRect0(loc,lcode: integer; x1,y1,x2,y2: tnum; down, saveposition: boolean): boolean;
var ofs0: integer; dmo: tdmobj;
begin
  Result:=false;
  if lcode<=0 then exit;//!

  if saveposition then ofs0:=dm_object else ofs0:=0;

  dmo:=tdmobj.createcode(loc,lcode);
  try
    dmo.points.AddRect(x1,y1,x2,y2);
    dmlib_draw_ofs := dmo.add(down);
    Result := dmlib_draw_ofs>0;
  finally
    dmo.free;
    if saveposition then dm_goto_node(ofs0);
  end;
end;
function DmDrawRect(lcode: longint; x1,y1,x2,y2: tnum; down, saveposition: boolean): boolean;
begin
  Result:=DmDrawRect0(1,lcode, x1,y1,x2,y2, down, saveposition);
end;


function DmDrawLine0(pa: tpa; loc: byte; lcode: longint; down: boolean): boolean;
var ofs0: integer; dmo: tdmobj;
begin
  Result:=false; if pa.Count<=0 then exit;//!

  ofs0:=dm_object;
  dmo:=tdmobj.createcode(loc,lcode);
  try
    dmo.points.AddFrom(pa);
    dmlib_draw_ofs := dmo.add(down);
    Result := dmlib_draw_ofs>0;
  finally
    dmo.free;
    if down then dm_goto_node(ofs0);
  end;
end;

function DmDrawLine(pa: tpa; lcode: longint; down: boolean): boolean;
begin
  Result:=DmDrawLine0(pa, 2,lcode, down);
end;

function DmDrawArea(pa: tpa; lcode: longint; down: boolean): boolean;
begin
  Result:=DmDrawLine0(pa, 3,lcode, down);
end;


function DmDrawVectorGauss(p1,p2: tnum2; loc: byte; lcode: longint; down: boolean): boolean;
var dmo: tdmobj;
begin
//  Result:=false;
  dmo:=tdmobj.createcode2(loc,lcode, true,false);//Gauss!
  try
    dmo.points.Add(p1);
    dmo.points.Add(p2);
    dmlib_draw_ofs := dmo.add(down);
    Result := dmlib_draw_ofs>0;
  finally
    dmo.free;
  end;
end;

//down=>saveposition:
function DmDrawLineGauss(pa: tpa; loc: byte; lcode: longint; down: boolean): boolean;
var ofs0: integer; dmo: tdmobj;
begin
  Result:=false; if pa.Count<=0 then exit;//!

  ofs0:=dm_object;
  dmo:=tdmobj.createcode2(loc,lcode, true,false);//Gauss!
  try
    dmo.points.AddFrom(pa);
    dmlib_draw_ofs := dmo.add(down);
    Result := dmlib_draw_ofs>0;
  finally
    dmo.free;
    if down then dm_goto_node(ofs0);
  end;
end;

function DmDrawList(lines: tclasslist; loc: byte; lcode: longint; down: boolean): boolean;
var i: integer; pa: tpa;
begin
  Result:=true;
  if lines.count>0 then for i:=0 to lines.count-1 do begin
    tobject(pa):=lines[i];
    Result:=DmDrawLine0(pa, loc,lcode, down);
    if not Result then break;
  end;
end;
function DmDrawListGauss(lines: tclasslist; loc: byte; lcode: longint; down: boolean): integer;
var i: integer; pa: tpa;
begin
  Result:=0;
  if lines.count>0 then for i:=0 to lines.count-1 do begin
    tobject(pa):=lines[i];
    if DmDrawLineGauss(pa, loc,lcode, down) then inc(Result);
  end;
end;

//pa - пары точек, down => все отрезки дочерние (тогда с возвратом):
function DmDrawVectors(pa: tpa; lcode: longint; down: boolean; ofs_list: tintarray): boolean;
var j,ofs0,ofs: integer; dmo: tdmobj; down2: boolean;
begin
  Result:=false;
  ofs0:=dm_object;
  //if ofs_list<>nil then ofs_list.clear; - НЕТ!

  if pa.count>=2 then for j:=0 to pa.count-2 do begin
    if (j mod 2) = 1 then continue;
    if j=0 then down2:=down else down2:=false;
    dmo:=tdmobj.createcode(2,lcode);
    try
      dmo.points[0]:=pa[j];
      dmo.points[1]:=pa[j+1];
      ofs:=dmo.add(down2);
      if (ofs_list<>nil) and (ofs>0) then ofs_list.add(ofs);
      Result:=(ofs>0);
    finally
      dmo.free;
      if down then dm_goto_node(ofs0);
    end;
  end;//for j
end;

function DmSetLayer(lcode: longint; ClearLayer: boolean): longint;
begin
  //поиск:
  Result:=0;
  dm_goto_root;
  if dm_goto_down then repeat
    if (dm_get_local<>0) or (dm_get_code<>lcode) then continue;
    Result:=dm_object;
    break;
  until not dm_goto_right;

  //очистка:
  if (Result>0) and ClearLayer then dm_Delete_Childs(Result);
  //новый слой:
  if Result=0 then Result:=dm_add_layer(lcode,0);

  dm_goto_node(Result);//!
end;

function DmSetObjLayer(obj_lcode: longint): longint;//по первым 2-м буквам
var layer_lcode: longint; obj_scode, layer_scode: string;
begin
  obj_scode:=LCodeToString(obj_lcode);

  SetLength(layer_scode, 8);
  FillChar(layer_scode[1], 8 ,'0');
  layer_scode[1]:=obj_scode[1];
  layer_scode[2]:=obj_scode[2];

  layer_lcode:=StringToLCode(layer_scode);

  Result:=DmSetLayer(layer_lcode, false);
end;

//==========================================================================

{ tdmofslist: }

function tdmofslist.load_dmw_selection(_msg: boolean): integer;
var i: integer;
begin
  Clear;
  Count:=dmw_sel_Objects_Count;
  if Count>0 then for i:=0 to Count-1 do Items[i]:=dmw_sel_Objects(i);
  Result:=Count;
  if _msg and (Count<=0) then Tell('Выборка пуста');
end;

procedure tdmofslist.load_dmw_selection;//OLD
begin
  load_dmw_selection(false);//function: integer
end;


procedure tdmofslist.del_objects;
var i,ofs0: integer;
begin
  ofs0:=dm_object;
  dm_goto_root;//!
  if count>0 then for i:=0 to count-1 do begin
    //if dm_goto_node(items[i]) then //DEBUG
    try dm_Del_Object(0, items[i]);
    //try dm_Delete_Object(0, items[i]);
    except
      ;
    end;
  end;
  dm_goto_node(ofs0);
end;

//==========================================================================

{ TDm: }

constructor TDm.Create0;
begin
  inherited Create;
end;

procedure TDm.LoadData(aFullName: string);
var _ShortObjName: ShortString; _ObjDir: string;
begin
    FullName:=aFullName;
    mpl:=dm_Resolution; //m/l
    lsc:=dm_Scale;//Long-scale вместо 904-long

    //паспорт:
    dm_goto_root;
    if not dm_get_string(903, 255, _ShortObjName) then _ShortObjName:='';
    ShortObjName:=wcmn_file_name(_ShortObjName);
    //_ObjDir:=wcmn_file_dir(_ShortObjName);{...\ || ''} if Length(_ObjDir)=0 then _ObjDir := UpperDir(ExeDir) + 'OBJ\';
    _ObjDir := UpperDir(ExeDir) + 'OBJ\';
    FullObjName := _ObjDir + ShortObjName + '.OBJ';

    try
      lpmm:=lsc/(mpl*1000);
    except
      FullName:='';
      lpmm:=0;
      Tellf(telllist[5],[aFullName]);
    end;
    if lpmm=0 then Tellf(telllist[6],[aFullName]);
end;

constructor TDm.Create(aFullName: string);
var dm_Open_res: boolean;
begin
  inherited Create;

  dm_Done;
  dm_Open_res:=dmlib_Open(PChar(aFullName),true{edit});

  if dm_Open_res then begin
    LoadData(aFullName);
  end else begin
    dm_Done;
    Tellf('dm_Open error on "%s"',[aFullName]);
    exit;//!
  end;

  if not Ok then begin
    dm_Done;
    Tellf('ERROR in TDm.Create on "%s"',[aFullName]);
  end;
end;

destructor TDm.Destroy;
begin
  dm_Done;
  inherited Destroy;
end;

function TDm.Ok: boolean;//lpmm>0 & FullName<>''
begin
  Result := (lpmm>0) and (lsc>0) and (mpl>0) and (length(FullName)>0);
end;

function TDm.SetLayer(lcode: longint; ClearLayer: boolean): longint;
begin
  Result:=DmSetLayer(lcode,ClearLayer);
end;


//==========================================================================

{ TDmObj: }

constructor TDmObj.Create;
begin
  inherited Create;
  Points:=tpl.new;
end;

constructor TDmObj.Create2(aGauss, aUseGraph: boolean);
begin
  Create;
  FGauss:=aGauss;
  FUseGraph:=aUseGraph;
end;

constructor TDmObj.CreateCode(aLoc: byte; aLCode: longint);
begin
  Create;
  Loc:=aLoc;
  LCode:=aLCode;
end;

constructor TDmObj.CreateCode2(aLoc: byte; aLCode: longint; aGauss, aUseGraph: boolean);
begin
  Create2(aGauss, aUseGraph);
  Loc:=aLoc;
  LCode:=aLCode;
  if FUseGraph then try FGraph:=dm_Get_Graphics(lcode, loc); except FGraph:=0; end;
end;

constructor TDmObj.CreateFromDm0;
begin
  Create;
  Read0;
end;

//для дырки возвращает нулевой объект(!):
constructor TDmObj.CreateFromDm;
begin
  Create;
  Read;
end;

constructor TDmObj.CreateFromDm2(aGauss, aUseGraph: boolean);
begin
  Create2(aGauss, aUseGraph);
  Read;
end;

destructor TDmObj.Destroy;
begin
  Points.free;
  inherited Destroy;
end;

procedure TDmObj.Clear;
begin
  loc:=0;
  lcode:=0;
  dmoffset:=0;
  Points.Clear;
end;

procedure TDmObj.SetPoints(aPoints: tpa);
begin
  Points.Clear;
  Points.AddFrom(aPoints);
end;

function TDmObj.InfoString(ofs: integer): string;//scode (loc) (ofs>0)
begin
  Result := Format('%s (%d)',[sCode, Loc]);
  if ofs>0 then Result := Result + Format(' (%d)',[ofs]);
end;

function TDmObj.GetSCode: string;
begin
  Result:=LCodeToString(lcode);
end;

procedure TDmObj.PutSCode(aSCode: string);
begin
  LCode:=StringToLCode(aSCode);
end;

procedure TDmObj.ReadPoints;
begin
  PaFromDmFile2(Points, FGauss);
end;

procedure TDmObj.WritePoints;
begin
  PaToDmFile2(Points, FGauss);//Bound - auto!
end;

procedure TDmObj.Read0;
var xid: SmallInt;
begin
  dmoffset:=dm_object;
  loc:=dm_Get_Local;
  lcode:=dm_Get_Code;
  if not dm_get_int(1000, 0, xid) then xid:=0; ID1000:=xid;
  if FUseGraph then try FGraph:=dm_Get_Graphics(lcode, loc); except FGraph:=0; end;
  ReadPoints;
end;

//с дырками:
procedure TDmObj.Read;
var ofs: integer; pl1,pl2: tpl;
begin
  Read0;//=>ReadPoints

  //дырки (только у областей):
  if loc<>3 then exit;//а просто дети?
  pl1:=Self.points;
  ofs:=dm_Object; if ofs<=0 then exit;
  try
    if DmObjectIsHole then
      clear
    else if dm_goto_down then
      repeat
        if lcode<>dm_Get_Code then continue;
        if loc<>dm_Get_Local then continue;
        pl2:=tpl.New;
        PaFromDmFile2(pl2, FGauss);
        pl1.Next:=pl2;
        pl1:=pl2;//=>dmo1.next=nil
      until not dm_goto_right;
  finally
    dm_goto_node(ofs);
  end;
end;


procedure TDmObj.Write;
begin
  dm_Set_Local(loc);
  dm_Set_Code(lcode);
  WritePoints;
end;

function TDmObj.Add(down: boolean): longint;
var la,lb: lpoint; lp: pLLine; pl: tpl; i,ofs: integer;
begin
  Result:=0;
  if Points.Count<=0 then exit;

  case Loc of
    1:
    begin
      if FGauss then begin
        la:=Num2GaussToLp(Points[0], true);
        if Points.Count>1 then lb:=Num2GaussToLp(Points[1], true) else lb:=la;
      end else begin
        la:=Num2ToLp(Points[0]);
        if Points.Count>1 then lb:=Num2ToLp(Points[1]) else lb:=la;
      end;
      Result:=dm_Add_Sign(lcode,la,lb,0,down);
      if (Result>0) and (dmlib_undo_list<>nil) then dmlib_undo_list.Add(Result);
    end;
    2,3:
    begin
      lp:=NewDmPolyFromPa2(Points, FGauss, true);
      Result:=dm_Add_Poly(lcode,loc,0,lp,down);
      FreeDmPoly(lp);
      if (Result>0) and (dmlib_undo_list<>nil) then dmlib_undo_list.Add(Result);
      //дырки:
      pl:=Points;
      i:=0;
      ofs:=Result;
      while (ofs>0) and (pl.next<>nil) do begin
        inc(i);
        pl:=pl.next;
        lp:=NewDmPolyFromPa2(Points, FGauss, true);
        ofs:=dm_Add_Poly(lcode,loc,0,lp, i=1 );
        FreeDmPoly(lp);
        if (ofs>0) and (dmlib_undo_list<>nil) then dmlib_undo_list.Add(ofs);
      end;
      if Result>0 then dm_goto_node(Result);
    end;
    //Loc=4 - dmtxt.pas(!)
    else
      Tellf('ERROR in TDmObj.Add:\nLoc=%d',[Loc]);
  end;//case

  dmoffset:=Result;
end;

procedure tDmObj.DrawSignAt(a,b: tnum2; dm_open_ok: boolean; aVgmName: PChar);
var lpa,lpb: lpoint;
begin
  if loc<>1 then exit;
  if FGauss then begin
    lpa:=Num2GaussToLp(a, dm_open_ok);
    lpb:=Num2GaussToLp(b, dm_open_ok);
  end else begin
    lpa:=Num2ToLp(a);
    lpb:=Num2ToLp(b);
  end;
  if aVgmName<>nil then
    dmw_DrawVgm(lpa.x,lpa.y, lpb.x,lpb.y, FGraph, aVgmName);
end;

procedure TDmObj.Draw(dm_open_ok: boolean; aVgmName: PChar);
var a,b: tnum2; lp: pLLine;
begin
  if Points.Count<=0 then exit;

  case Loc of
    1:
    begin
      a:=Points[0];
      if Points.Count>1 then b:=Points[1] else b:=a;
      DrawSignAt(a,b, dm_open_ok, aVgmName);
    end;
    2,3:
    begin
      lp:=NewDmPolyFromPa2(Points, FGauss, dm_open_ok);
      try dmw_DrawPoly(lp, loc, FGraph);
      finally FreeDmPoly(lp);
      end;
    end;
    else//Loc=4 - dmtxt.pas(!):
      Tellf('ERROR in TDmObj.Draw:\nLoc=%d',[Loc]);
  end;//case
end;


procedure TDmo.DelChildren;
var ofs0: tint; ofslist: tdmofslist;
begin
  ofs0:=dm_object;
  ofslist:=tdmofslist.new;
  try
    if dm_goto_node(dmoffset) and dm_goto_down then repeat
      ofslist.add(dm_object);
    until not dm_goto_right;
    ofslist.del_objects;
  finally
    ofslist.free;
    dm_goto_node(ofs0);
  end;
end;

//кроме дырок:
procedure TDmo.DelChildren2;
var ofs0: tint; ofslist: tdmofslist;
begin
  ofs0:=dm_object;
  ofslist:=tdmofslist.new;
  try
    if dm_goto_down then repeat
      if not DmObjectIsHole then ofslist.add(dm_object);
    until not dm_goto_right;
    ofslist.del_objects;
  finally
    ofslist.free;
    dm_goto_node(ofs0);
  end;
end;

//без первой точки (продолжение!):
procedure _AddBezToPl0(p0,p1,p2,p3: tnum2; pl: tpl; step: tnum);
var
  i,n: tint; l0: tnum; p: tnum2; curve: tcurve;
  q0,q1,q2,q3: tnum2;
begin
  //ПРИБЛИЗИТЕЛЬНО:
//  l0:=v_dist(p0,p1)+v_dist(p1,p2)+v_dist(p2,p3);
  l0:=v_dist(p0,p1)+v_dist(p1,p2);//Толик!
  n:=Round(l0/step);
  if n<=1 then n:=3;//!

  //Представление Толика:
  q0:=p0;
  q1:=p1;
  q2 := v_add(p2, v_sub(p2,p3));//!
  q3:=p2;//!

  curve:=tcurve.Create(q0,q1,q2,q3);
  try

    //концы отрезков:
    for i:=1 to n do begin
      p:=curve.P[i/n];
      pl.add(p);
    end;

  finally
    curve.free;
  end;
end;

procedure TDmo.BezToPl(step: tnum);
var bez: tpl; i: tint;
begin
  if Loc<>6 then exit;
  Loc:=2;//!
  if points.count=0 then exit;

  bez:=tpl.new;
  try
    bez.addfrom(points);
    points.clear;
    points.add(bez.first);//первая точка!

    //"тройки" точек:
    //Представление Толика: по 2 точки(!):
    i:=0;
    while i+3<bez.count do begin
      _AddBezToPl0(bez[i],bez[i+1],bez[i+2],bez[i+3], points, step);
      //inc(i,3);
      inc(i,2);//Толик!
    end;
  finally
    bez.free;
  end;
end;


initialization
  dmlib_undo_list:=nil;//default


end.
