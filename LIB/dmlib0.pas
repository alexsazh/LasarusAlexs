(*
  Функции, не требующие ни акт.карты (alw.exe), ни откр.карты:
*)
unit dmlib0;

{$MODE Delphi}

 interface


const
  dmlib0_prj_M_UTM_L0 = 2;//Меркатора равноугольная (UTM), L0=40-ЮГ, L0=105-Байкал
  dmlib0_prj_M_CIL = 3;//Меркатора цилиндрическая, B0=40 по России
  dmlib0_prj_BL = 29;//Широта-Долгота

function dml0_dmdate_to_s1(dmdate: longint): string;//20150512 -> "12.05.2015"

//код объекта: integer <-> string(м.б. короче 8 симв.):
function dml0_Code_To_String(code: integer): string;
function dml0_String_To_Code(scode: string): integer;

//s9code: типа A00000000 - формат GC:
//Result = Loc>0
function dml0_9String_To_CodeLoc(s9code: string; var lcode: integer): integer;

//код слоя: первые 2 знака и нули, ocode - код объекта:
function dml0_get_layer_code_byobj(ocode: integer): integer;

//СОЗДАНИЕ КАРТЫ (карта СТАНОВИТСЯ ОТКРЫТОЙ!!!):
(*
function dm_New(
  Path,Obj: PChar;      //карта и классификатор
  pps,                  //1 - геодезия (не "прямоуг-ые коорд-ты")
  prj,                  //1 - гаусс-крюгер, 2 - UTM, 29 - "широта-долгота"
  elp,                  //1 - Красовский, 9 - WGS-84
  dx,dy,dz: Integer;    //см.паспорт
  b1,b2, lc: Double;    //см.паспорт (lc=L0)
  xmin,ymin,xmax,ymax: double;  //РАМКА - РАДИАНЫ, если углы
  ed: Integer)                  //ed=1 градусы                           //???
  : Integer;                                                             //Result - ???
*)
//pps=1(геодезия), prj=29(широта-долгота), elp=9(WGS-84), ed=1:
function dml0_CreateDm_BL(_projection: integer;
  DmPath,ObjName: string;       //карта(Path) и паспорт-классификатор(ShortName)
  Bmin,Lmin,Bmax,Lmax: double;   //РАМКА - градусы
  _msg: boolean): boolean;
//карта - 1 минута вокруг центра:
function dml0_CreateDm_BL_1min(_projection: integer;
  DmPath,ObjName: string;       //карта(Path) и паспорт-классификатор(ShortName)
  B0,L0: double;                   //ЦЕНТР - градусы
  _msg: boolean): boolean;



implementation

uses
  SysUtils,
  dmw_Use,
  Wcmn, nums;


function dml0_dmdate_to_s1(dmdate: longint): string;//20150512 -> "12.05.2015"
var sdate,sy,sm,sd: string;
begin
  sdate:=IntToStr(dmdate);
  if Length(sdate)=8{!} then begin
    sy:=System.Copy(sdate, 1,4);//20150512 -> 2015
    sm:=System.Copy(sdate, 5,2);//20150512 -> 05
    sd:=System.Copy(sdate, 7,2);//20150512 -> 12
  end else begin
    sy:='yyyy';
    sm:='mm';
    sd:='dd';
  end;
  Result:=Format('%s.%s.%s',[sd,sm,sy]);
end;

function dml0_Code_To_String(code: integer): string;
var st:string; sd,lnumb: longint;
begin
  sd:=code div 10000000;
  lnumb:=code mod 10000000;
  st:=Format('%7.7d',[lnumb]);
  Result:=chr(48{ord('0')}+sd)+st;
end;

function dml0_String_To_Code(scode: string): integer;
var st:string;
begin
  Result:=0;
  if length(scode)=0 then exit;//!
  if length(scode)<8 then begin
    Result := StrToInt(scode);
  end else begin
    st:=Scode+#0;
    Result:=(ord(scode[1])-48{ord('0')})*10000000+ StrToInt(strpas(@st[2]));
  end;
end;


function dml0_9String_To_CodeLoc(s9code: string; var lcode: integer): integer;
var sloc,scode: string;
begin
  Result:=0;
  if Length(s9code)=0 then EXIT;//!

  sloc:=Copy(s9code, 1,1);//1 символ
  Result:=pos(sloc, 'SLAT');//0 - не найден!

  scode:=Copy(s9code, 2,8);//<=8 символов
  lcode:=dml0_String_To_Code(scode);
end;


function dml0_get_layer_code_byobj(ocode: integer): integer;
begin
  Result := (ocode div 1000000) * 1000000;
end;


//////////////////////////////////////////////////////////////////

(*
function dm_New(
  Path,Obj: PChar;      //карта и классификатор
  pps,                  //1 - геодезия (не "прямоуг-ые коорд-ты")
  prj,                  //1 - гаусс-крюгер, 2 - UTM, 29 - "широта-долгота"
  elp,                  //1 - Красовский, 9 - WGS-84
  dx,dy,dz: Integer;    //см.паспорт
  b1,b2,lc: Double;    //см.паспорт (lc=L0)
  xmin,ymin,xmax,ymax: double;  //РАМКА - РАДИАНЫ, если углы
  ed: Integer)                  //ed=1 - метры, 100 - см
  : Integer;                                                             //Result - ???
*)
//pps=1(геодезия), prj=29(широта-долгота), elp=9(WGS-84), ed=1(м):
function dml0_CreateDm_BL(_projection: integer;
  DmPath,ObjName: string;       //карта(Path) и паспорт-классификатор(ShortName)
  Bmin,Lmin,Bmax,Lmax: double;   //РАМКА - градусы
  _msg: boolean): boolean;
var B0{град}: integer;
begin
  B0:=0;
  if _projection=dmlib0_prj_M_CIL then B0:=40;{Россия}

  Result :=
    dm_New(
    PChar(DmPath), PChar(ObjName),
    1{геодезия},
    _projection,
    9{WGS-84},
    0,0,0,{dx,dy,dz}
    rad(B0),0,0,{b1,b2,lc}
    rad(Bmin),rad(Lmin),rad(Bmax),rad(Lmax),
    100{см}
    )>0;                                                          //???

  if not Result and _msg
  then Tellf('FALSE in dml0_CreateDm_BL("%s","%s", %.3f,%.3f,%.3f,%.3f(градусы))',
                                      [DmPath,ObjName, Bmin,Lmin,Bmax,Lmax]);
end;

//карта - 1 минута вокруг центра:
function dml0_CreateDm_BL_1min(_projection: integer;
  DmPath,ObjName: string;       //карта(Path) и паспорт-классификатор(ShortName)
  B0,L0: double;   //ЦЕНТР - градусы
  _msg: boolean): boolean;
const dB=1/60; dL=1/60;//1 минута в поперечнике
var Bmin,Lmin,Bmax,Lmax: double;
begin
  Bmin := B0-dB/2;
  Lmin := L0-dL/2;
  Bmax := B0+dB/2;
  Lmax := L0+dL/2;

  Result := dml0_CreateDm_BL(_projection, DmPath,ObjName, Bmin,Lmin,Bmax,Lmax, _msg);
end;

end.
