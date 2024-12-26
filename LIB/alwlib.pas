(*
  Функции редактора (карта закрыта)
*)
unit alwlib; interface

uses
  OTypes,
  nums, dmlib3d;


const alwl_dm_open_count: integer = 0;//>0 - повторное открытие


//MISC (alw_misc.dll):

(*
Green - лес  - ИЗМЕНИТСЯ!
Rlz - рельеф
Rgn: PLPoly; RgnCount: Integer; - полигон
  (X,Y) - дециметры то есть метры * 10          !!!
h1 - минимальное превышение рельефа
dz - приращение
*)
function rlz_dz_green(Green,Rlz: PChar;
                      Rgn: PLPoly; RgnCount: Integer;
                      h1,dz: Float): Boolean; stdcall;


//КАРТА (активная):

function  alwl_dm: string; overload;//путь к активной карте
function  alwl_dm(_msg: boolean; var dmpath: string): boolean; overload;//"
function  alwl_dm_open(_edit: boolean; _msg: boolean = false): boolean;//открыть активную карту
function  alwl_dm_open_read: boolean;//_msg=true
function  alwl_dm_open_write: boolean;//_msg=true
procedure alwl_dm_close;

//ОБЪЕКТ активный:

function  alwl_dm_offs(var offs: integer; _msg: boolean = false): boolean;
function  alwl_dm_id(var id{@1000}: integer; _msg: boolean = false): boolean;//alwl_dm_open!!!

//ВЫБОРКА:

function  alwl_get_selection(offsa: tinta; _msg: boolean = false): integer;//return=count
procedure alwl_put_selection(offsa: tinta; _clear: boolean = false);

//КЛАССИФИКАТОР акт. карты (Loc,Code нужно устанавливать):
//false => Loc,Code,Name не меняются(!):
//карта закрыта(будет временно открываться!):
function alwl_obj_name: string;//из паспорта (не путь)
function alwl_obj_dir0: string;//директория OBJ без "\" (USES "рабочая папка")
function alwl_obj_dirname: string;//путь .OBJ без расширения
function alwl_obj_path: string;//путь .OBJ
function alwl_obj_select(var Loc,Code: Integer; var Name: string): boolean; overload;
function alwl_obj_select(var Loc,Code: Integer): boolean; overload;

//ОКНО:
//mode:
//0 - без перерисовки, если часть в окне;
//1 - центр окна в том же масштабе;
//2 - 3D (с установкой коридора):
procedure alwl_show_DmId(aDmId{@1000}: integer; mode: integer);
procedure alwl_show_Offs(Offs: integer; mode: integer);
procedure alwl_show_OraId(OraID : Double);//type TSOMproc from viewer_dll.pas

//ТОЧКИ (.alx):

function  alwl_alx: string;
function  alwl_alx_Open(_msg: boolean): integer;//BlockCount
procedure alwl_alx_Close;

//СПИСКИ:

type
  TAlwList = class(TDmo3dList)//Items: tdmo3dClass - ПОТОМКИ tdmo3d
  private
  protected
  public
    procedure AddFromSelection(const aItemType: tdmo3dClass{потомок}; _msg: boolean);//карта закрыта
  end;


implementation

uses
  SysUtils,
  dmw_use, dmw_wm,
  alw_dde, alw_use,
  wcmn, wait;


var alwl_tmp_chars: array[0..2048]of char;


//MISC (alw_misc.dll):


function rlz_dz_green(Green,Rlz: PChar;
                      Rgn: PLPoly; RgnCount: Integer;
                      h1,dz: Float): Boolean; stdcall;
external 'alw_misc.dll';


//КАРТА (активная):

function alwl_dm: string;
begin
  Result:=StrPas( alw_Get_ActiveMap(@alwl_tmp_chars[0]) );
end;

function alwl_dm(_msg: boolean; var dmpath: string): boolean;
begin
  Result:=true;
  dmpath:=alwl_dm;
  if Length(dmpath)=0 then begin
    Result:=false;
    if _msg then Tell('Нет активной карты');
  end;
end;

function alwl_dm_open(_edit: boolean; _msg: boolean = false): boolean;
var dmpath: string;
begin
  Result:=alwl_dm(TRUE{_msg}, dmpath);
  if Result then begin
    alw_HideMap;//alw_BackMap - отсутствует!!!
    Result:=dml3_Open(dmpath, _edit);
  end;

    if Result then begin
      inc(alwl_dm_open_count);
      if alwl_dm_open_count>1
      then Tellf('WARNING in alwl_dm_open: alwl_dm_open_count=%d',[alwl_dm_open_count]);
    end;

  if _msg and not Result then Tell('Невозможно открыть активную карту');
end;

function  alwl_dm_open_read: boolean;//_msg=true
begin
  Result := alwl_dm_open(false{_edit}, true{_msg});
end;

function  alwl_dm_open_write: boolean;//_msg=true
begin
  Result := alwl_dm_open(true{_edit}, true{_msg});
end;

procedure alwl_dm_close;
begin
  dml3_Close;
  //dec(alwl_dm_open_count);//!
  alwl_dm_open_count:=0;//!
end;


function  alwl_dm_offs(var offs: integer; _msg: boolean = false): boolean;
var Code,Loc,x1,y1,x2,y2: Integer;
begin
  offs:=0;
  alw_OffsObject(Offs,Code,Loc, x1,y1,x2,y2, @alwl_tmp_chars[0]);
  Result := offs>0;
  if _msg and not Result then Tell('На карте нет активного объекта');
end;

function  alwl_dm_id(var id{@1000}: integer; _msg: boolean = false): boolean;
var offs: integer;
begin
  Result:=alwl_dm_offs(offs, true{_msg});
  if not Result then EXIT;

  if alwl_dm_open(false{_edit}, true{_msg}) then try
    //if dm_goto_node(offs) then
    id:=dm_Id_Object(offs);
    Result := id>0;
  finally
    alwl_dm_close;
  end;
end;


function alwl_get_selection(offsa: tinta; _msg: boolean = false): integer;
var i: integer;
begin
  offsa.Clear;
  Result:=alw_sel_Count; if Result<0 then Result:=0;
  if Result>0 then for i:=0 to Result-1 do offsa[i]:=alw_sel_Object(i);
  if _msg and (Result<=0) then Tell('Выборка пуста');
end;

procedure alwl_put_selection(offsa: tinta; _clear: boolean);
var i: integer; alwl_Common: TAlwCommon;//объект для создания выборки
begin
  alwl_Common:=TAlwCommon.Create;
  try
    alwl_Common.IsWait:=true;//!!!(Толя)
    alwl_Common.sel_lock;//stop redraw
    if _clear then alwl_Common.sel_clear;

    if offsa.Count>0 then for i:=0 to offsa.Count-1 do
      alwl_Common.sel_add(offsa[i]);

  finally
    alwl_Common.sel_unlock;//redraw
    alwl_Common.Free;
  end;
end;


function alwl_obj_name: string;
var sShort: ShortString;
begin
  Result:='';//default
  if alwl_dm_open(false{_edit}, true{_msg}) then try
    if (dm_goto_root>0)
    and dm_Get_String(903,254,sShort)
    then Result:=sShort;//классификатор - WIN-кодировка!
  finally
    alwl_dm_close;
  end;
  Result := wcmn_file_name(Result);//короткое имя, даже если в паспорте указан путь! (это использовано!)
end;

function alwl_obj_dir0: string;//директория OBJ без "\" (USES "рабочая папка")
begin
  //Result := 'd:\neva_work\obj';//DEBUG
  alw_EnvDir( @alwl_tmp_chars[0] );//рабочая папка
  Result := StrPas( @alwl_tmp_chars[0] ) + '\obj';
end;

function alwl_obj_dirname: string;//путь без расширения
var objname: string;
begin
  objname:=alwl_obj_name;//m.b.''
  if objname<>''
  then Result := alwl_obj_dir0 + '\' + objname
  else Result := '';//default
end;

function alwl_obj_path: string;//путь .OBJ
var objdirname: string;
begin
  objdirname:=alwl_obj_dirname;
  if objdirname<>''
  then Result := objdirname + '.obj'
  else Result := '';//default
end;


function alwl_obj_select(var Loc,Code: Integer; var Name: string): boolean;
var ObjName: string; xCode,xLoc: integer;
begin
  Result := false;//default
  xLoc:=0;
  xCode:=0;

  ObjName:=alwl_obj_name;//карта откр/закр
  if ObjName<>'' then
    Result:=alw_Dial_Object(PChar(ObjName), Code,Loc, xCode,xLoc, @alwl_tmp_chars[0]);

  if Result and (xLoc>=0) and (xCode>0) then begin
    Loc:=xLoc;
    Code:=xCode;
    Name:=StrPas( @alwl_tmp_chars[0] );
  end else
    Result := false;//!
end;

function alwl_obj_select(var Loc,Code: Integer): boolean;
var Name: string;
begin
  Result := alwl_obj_select(Loc,Code, Name);
end;


//ОКНО:

procedure alwl_show_DmId(aDmId{@1000}: integer; mode: integer);
begin
  if aDmId<=0 then exit;//!
  case mode of
    0: alw_ShowObject(1,aDmId, 8,-1);//"8,-1" - перерисовка, только если нет в окне
    1: alw_ShowObject(1,aDmId, 0,0);//"0,0" - центр окна в том же масштабе
    2: alw_ShowObject(1,aDmId, 8+128,-1);//"8,-1" + ПРОФИЛЬ
  end;//case
  alw_SetFocus;//!
end;

procedure alwl_show_Offs(Offs: integer; mode: integer);
begin
  if offs<=0 then exit;//!
  case mode of
    0: alw_ShowObject(0,Offs, 8,-1);//"8,-1" - перерисовка, только если нет в окне
    1: alw_ShowObject(0,Offs, 0,0);//"0,0" - центр окна в том же масштабе
    2: alw_ShowObject(0,Offs, 8+128,-1);//"8,-1" + ПРОФИЛЬ
  end;//case
  alw_SetFocus;//!
end;

procedure alwl_show_OraId(OraID : Double);
var offs: longint;
begin
  offs:=0;//default

  if alwl_dm_open(false{_edit}, false{_msg}) then try
    offs:=dm_Find_Frst_Char(1002, _double, 0,OraID,nil);
  finally
    alwl_dm_close;
  end;

  if offs>0
  then alwl_show_Offs(offs, 2);
  //else Tell('Объект не найден в активной карте'); - НЕ НАДО (Дима)
end;


//ТОЧКИ:

function  alwl_alx: string;
begin
  Result:=string( alw_Get_Points(@alwl_tmp_chars[0]) );
end;

function  alwl_alx_Open(_msg: boolean): integer;
var pc: pchar;
begin
  Result:=-1;
  pc:=alw_Get_Points(@alwl_tmp_chars[0]);
  if Length(pc)>0 then begin
    if alx_open(pc) then Result:=alx_Get_BlockCount;
  end;
  if _msg and (Result<0) then Tell('Нет файла точек');
end;

procedure alwl_alx_Close;
begin
  alx_close;
end;


//СПИСКИ:

{ TAlwList: }

procedure TAlwList.AddFromSelection(const aItemType: tdmo3dClass{потомок}; _msg: boolean);
var offsa: tinta;
begin
  //wait_show('Набор из выборки ...');
  offsa:=tinta.New;
  try
    if (alwl_get_selection(offsa, _msg)>0)
    and alwl_dm_open(false{_edit}, true{_msg}) then try
      AddFromOffsArray(aItemType, offsa);//NEW
    finally
      alwl_dm_close;
    end;
  finally
    offsa.Free;
    //wait_hide;
  end;
end;


end.
