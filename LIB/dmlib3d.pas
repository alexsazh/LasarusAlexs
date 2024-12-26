(*
  1) Функции ОТКРЫТОЙ карты (dmw_use), ha m.b. nil(!)
  2) объекты TDmo3D, TDmo3ID
  3) списки

  все координаты - метры

  см. также: dmlib0.pas

  Дырки - tdmo3d - только чтение(!!!) из .dm
*)
unit dmlib3d; interface

uses
  OTypes, Variants,
  wcmn{twcmn_vartype},
  list, nums, vlib, llib, llibx, vlib3d, llib3d, dmlib0;


var dml3_sys: tsys{OTypes.pas};//dm_Get_sys7 - проекция последней открытой карты


function  dml3_Open(dmpath: string; _edit: Boolean): Boolean;//=>dml3_sys(параметры проекции)
procedure dml3_Close;


//DM ОТКРЫТА:

procedure dml3_XY_BL(xy: tnum2; var bl{grad}: tnum2); overload;

//изменение рамки карты (геодезия => ГРАДУСЫ):
procedure dml3_set_box_BL(Bmin,Lmin,Bmax,Lmax: double);


//установка активного объекта - слой (_clear - очистка слоя):
//RETURN=OFFSET>0 - OK:
function dml3_set_layer(lcode: integer; _clear: boolean): longint; stdcall;//lcode - код слоя
function dml3_set_layer_byobj(ocode: integer; _clear: boolean): longint; overload; stdcall;//ocode - код объекта
function dml3_set_layer_byobj(ocode: integer): longint; overload; stdcall;//_clear=FALSE

//характеристики:

function dml3_read_string(nc: integer): string;//default=''
function dml3_read_integer(nc: integer): integer;//default=0
function dml3_read_real(nc: integer): double;//default=0, dm_Get_Double
//function dml3_read_real(nc: integer; var x: double): boolean;

function dml3_read_dbfstr(nc: integer): string;//default=''
function dml3_read_mdbstr(nc, ncol{>1}: integer): string;//default=''

procedure dml3_write_string(nc: integer; s: string);
procedure dml3_write_integer(nc: integer; i: integer);
procedure dml3_write_real(nc: integer; x: double);
procedure dml3_write_variant(nc: integer; v: variant; vtype: t_vartype);//if not NULL

//полилинии TPL3D: Result=true => count>0:

function dml3_box_read: tnum4;//рамка объекта

function dml3_pl_read(pl: tpl; ha: tnuma): boolean; overload;
function dml3_pl_read(pl3: tpl3d): boolean; overload;
function dml3_pl_read(ofs: integer; pl: tpl; ha: tnuma): boolean; overload;
function dml3_pl_read(ofs: integer; pl3: tpl3d): boolean; overload;

function dml3_pl_write(pl: tpl; ha: tnuma): boolean; overload;
function dml3_pl_write(pl3: tpl3d): boolean; overload;

function dml3_pl_add(code,loc: integer; pl: tpl; ha: tnuma; _down: boolean): integer; overload;
function dml3_pl_add(code,loc: integer; pl3: tpl3d; _down: boolean): integer; overload; stdcall;

function dml3_ab_add(code: integer; a,b: tnum3; _down: boolean): integer;//отрезок, loc=2

procedure dml3_BL_XY(pl{grad}: tpa);//карта открыта
procedure dml3_XY_BL(pl{grad}: tpa); overload;//карта открыта

//РАЗНОЕ:

function dml3_dmo_is_hole(aCode: integer): boolean; overload;//Loc=3 - проверено вовне
function dml3_dmo_is_hole: boolean; overload;

function dml3_get_obj_name(code,loc: integer): string;//Толя утверждает, что карту надо открывать

//выборка:
procedure dml3_get_selection(offsa: tinta; dmo3dlist: tclasslist{of tdmo3d}; _listclear: boolean = true);


//ОБЪЕКТЫ:

type

  //базовый класс:
  tdmo3d = class
  protected
  public
    DmOffs: integer;//очистка в Clear!
    DmCode,DmLoc: integer;
    PL3: tpl3d;//Read, очистка в Clear
    constructor Create; virtual;//CreateFromDm вызовет другой Create, если он будет!
    constructor CreateCode(aCode,aLoc: integer); virtual;
    constructor CreateFromDm; virtual;//virtual - для списков!
    destructor Destroy; override;
    procedure Clear; virtual;

    function Read: boolean; virtual;//=> FOffs,FCode,FLoc,FPL3 - с дырками!
    procedure WriteData; virtual;//abstract
    function Add(_down: boolean): integer; virtual;//DmOffs меняется
    function AddTo(offs: integer; _down: boolean): integer;//DmOffs const!

    function sCode: string;
  end;

  tdmo3id = class(tdmo3d)//1000-ая хар-ка
  protected
  public
    DmId: integer;//1000-ая хар-ка
    DbId: integer;//ID в MDB - TEMPORARY!
    //OraId: double{!};//ID в Oracle
    procedure Clear; override;
    function Read: boolean; override;
    procedure WriteData; override;//DmId (Add - DmOffs) меняются
    function AddTo(offs: integer; _down: boolean): integer;//DmId, DmOffs const!
  end;

//СПИСКИ DM-ОБЪЕКТОВ:

  tdmo3dClass = class of tdmo3d;//Любой потомок (Help: class of, class references)

  TDmo3dList = class(TClassList)//of tdmo3d
  private
  protected
    function Get(Index: Integer): tdmo3d;//out of range => nil
    //function CreateItem_FromDm: tobject; virtual;//OLD: for AddFromOffsArray
  public
    //Find:
    function IndexOf_Code(aLoc,aCode: integer): integer;
    function IndexOf_Offs(aOffs: integer): integer;
    function Find_Code(aLoc,aCode: integer): tdmo3d;
    function Find_Offs(aOffs: integer): tdmo3d;

    //карта открыта:
    //procedure AddFromOffsArray(offsa: tinta); overload;//OLD: uses CreateItem_FromDm
    procedure AddFromOffsArray(const aItemType: tdmo3dClass{потомок}; offsa: tinta); overload;//NEW
    //procedure AddFromDm(aLoc,aCode: integer); overload;//OLD: uses CreateItem_FromDm
    procedure AddFromDm(const aItemType: tdmo3dClass{потомок}; aLoc,aCode: integer); overload;//NEW

    //Разное:
    procedure AddFirstPointsTo(pl: tpl3d);
    //procedure AddCodesTo(aCodes: tinta); overload;//Self->aCodes (разные!)
    procedure AddCodesTo(aCodes: tinta; aLoc: integer = -1{NotUsed});//Self->aCodes (разные!)

    property _[Index: Integer]: tdmo3d read Get; default;
  end;

  TDmo3idList = class(TDmo3dList)//of tdmo3id
  private
  protected
    function Get(Index: Integer): tdmo3id;//out of range => nil
    //function CreateItem_FromDm: tobject; override;//OLD: for AddFromOffsArray
  public
    //Find:
    function IndexOf_DmId(aDmId: integer): integer;
    function Find_DmId(aDmId: integer): tdmo3id;

    property _[Index: Integer]: tdmo3id read Get; default;
  end;



implementation

uses
  Types, SysUtils,
  dmw_use,
  objlib;

var dml3_tmp_chars: array[0..2048]of char;



function dml3_Open(dmpath: string; _edit: Boolean): Boolean;
begin
  Result := dm_open(PChar(dmpath), _edit)>0;
  if Result then begin
    dm_Get_sys7(dml3_sys);
  end;
end;

procedure dml3_Close;
begin
  dm_done;
end;



procedure dml3_XY_BL(xy: tnum2; var bl{grad}: tnum2);
begin
  dm_XY_BL(xy.x,xy.y, bl.x{rad},bl.y{rad});
  bl.x:=grad(bl.x);
  bl.y:=grad(bl.y);
end;



procedure dml3_set_box_BL(Bmin,Lmin,Bmax,Lmax: double);
begin
  dm_map_bound(rad(Bmin),rad(Lmin), rad(Bmax),rad(Lmax));//карта открыта!
end;


function dml3_set_layer(lcode: integer; _clear: boolean): longint;
begin
  Result:=0;

  //проверка положения:
  if (dm_get_local=0) and (dm_get_code=lcode)
  then Result:=dm_object;//!

  //поиск:
  if Result=0 then begin
    dm_goto_root;
    if dm_goto_down then repeat
      if (dm_get_local<>0) or (dm_get_code<>lcode) then continue;
      Result:=dm_object;
      break;
    until not dm_goto_right;
  end;

  //_clear (старый слой):
  if (Result>0) and _clear then dm_Delete_Childs(Result{>0});

  if Result=0 then Result:=dm_add_layer(lcode,0);
  if not dm_goto_node(Result) then begin
    Tellf('ERROR in dml3_set_layer(%d)',[Result]);
    Result:=0;//!
  end;
end;

function dml3_set_layer_byobj(ocode: integer; _clear: boolean): longint;
var lcode: integer;
begin
  //lcode:=dm_Get_Layer(ocode);//код слоя
  lcode:=dml0_get_layer_code_byobj(ocode);//код слоя
  Result:=dml3_set_layer(lcode, _clear);
end;

function dml3_set_layer_byobj(ocode: integer): longint;
begin
  Result:=dml3_set_layer_byobj(ocode,FALSE{_clear});
end;


function dml3_read_string(nc: integer): string;
var sShort: ShortString;
begin
  Result:='';
  if dm_Get_String(nc,254,sShort) then
    Result:=wcmn_dos2win(sShort);
end;

function dml3_read_integer(nc: integer): integer;
begin
  if not dm_Get_Long(nc,0, Result) then Result:=0;
end;

function dml3_read_real(nc: integer): double;
begin
  if not dm_Get_Double(nc,0,Result) then Result:=0;
end;


function dml3_read_dbfstr(nc: integer): string;
var pc: PChar;
begin
  Result:='';
  pc:=@dml3_tmp_chars[0];
  StrCopy(pc,'');//!(Толик)
  Result:=StrPas( dm_Str_dbase(pc, nc) );
  //if Length(Result)>0 then Result:=wcmn_dos2win(Result);//НЕ НАДО!
end;

function dml3_read_mdbstr(nc, ncol{>1}: integer): string;//default=''
var dbf_id,ind: integer;
begin
  Result:='';

  dbf_id:=dml3_read_integer(nc);//def=0

  ind:=objl_Mdb751_1.IndexOf(dbf_id);
  if ind<0 then exit;//!

  if ncol=2 then Result:=objl_Mdb751_2[ind]
  else Result:=objl_Mdb751_3[ind];
end;


procedure dml3_write_string(nc: integer; s: string);
var s2: string;
begin
  s2:=wcmn_win2dos(s);
  dm_Put_String(nc, PChar(s2));
end;

procedure dml3_write_integer(nc: integer; i: integer);
begin
  dm_Put_Long(nc, i);
end;

procedure dml3_write_real(nc: integer; x: double);
begin
  dm_Put_Double(nc, x);
end;

procedure dml3_write_variant(nc: integer; v: variant; vtype: t_vartype);
begin
  if v=Null then EXIT;//!
  case vtype of
    tvt_integer: dml3_write_integer(nc, v);
    tvt_real:    dml3_write_real(nc, v);
    tvt_string:  dml3_write_string(nc, v);
  end;//case
end;


/////////////////////// TPL: /////////////////////////

function dml3_box_read: tnum4;
var la,lb: TPoint; a,b: tnum2;
begin
  dm_get_bound(la,lb);
  dm_L_to_G(la.x,la.y, a.x,a.y);
  dm_L_to_G(lb.x,lb.y, b.x,b.y);
  Result := v_box(a,b);//correction!
end;


function _dml3_ll_new(count: tint): pLLine;
begin
  //точки обнуляются:
  Result := pLLine( malloc( (count+2)*sizeof(lpoint) ) );//count+2 - "на всякий случай"(Толик)
  if Result<>nil then Result^.N:=count-1;
end;

procedure _dml3_ll_free(pll: pLLine);
begin
  mfree2(pll);
end;


function dml3_pl_read(pl: tpl; ha: tnuma): boolean;
var
  z_res: double;//1 - м, 100 - см
  pll: pLLine; ia: array of integer;
  count,i: integer; p: tnum2; lp: lpoint;
begin
  Result:=false;
  pl.Clear;
  if Assigned(ha) then ha.Clear;

  count:=dm_Get_Poly_Count+1;
  if count>0 then try
    z_res:=dm_z_res;

    if Assigned(ha) then SetLength(ia, count);
    pll:=_dml3_ll_new(count);
    if pll<>nil then try

      if Assigned(ha) then dm_Get_Poly_xyz(pll, @ia[0], count-1)
      else dm_Get_Poly_Buf(pll, count-1);

      for i:=0 to count-1 do begin
        lp:=pll^.Pol[i];
        dm_L_to_G(lp.x,lp.y, p.x,p.y);

        //Добавление в массивы:
        pl.Add(p);
        if Assigned(ha) then ha.Add( ia[i]/z_res );
      end;//for i
    finally
      _dml3_ll_free(pll);
    end;

    Result:=true;
  except
  end;
end;

function dml3_pl_read(pl3: tpl3d): boolean; overload;
begin
  Result := dml3_pl_read(pl3.pl, pl3.ha);
end;

function dml3_pl_read(ofs: integer; pl: tpl; ha: tnuma): boolean;
begin
  Result := dm_goto_node(ofs) and dml3_pl_read(pl, ha);
end;

function dml3_pl_read(ofs: integer; pl3: tpl3d): boolean; overload;
begin
  Result := dm_goto_node(ofs) and dml3_pl_read(pl3.pl, pl3.ha);
end;


function _dml3_pl_to_new_pll(pl: tpl): pLLine;
var i: integer; p: tnum2; lp: lpoint;
begin
  Result:=nil;
  if pl.count<=0 then exit;

  Result:=_dml3_ll_new(pl.count);
  if (Result<>nil) then for i:=0 to pl.count-1 do begin
    p:=pl[i];
    dm_G_to_L(p.x,p.y, lp.x,lp.y);
    Result^.Pol[i]:=lp;
  end;//for i
end;

function _dml3_ha_to_new_integers(ha: tnuma): PIntegers;//mfree2(Result)
var i,size: integer; z_res: double;{1 - м, 100 - см}
begin
  Result:=nil;
  if ha.count<=0 then exit;

  size:=sizeof(integer);
  Result := PIntegers( malloc( ha.count*size ) );
  z_res:=dm_z_res;
  if (Result<>nil) then for i:=0 to ha.count-1 do begin
    Result[i] := Round( ha[i]*z_res );
  end;//for i
end;

function dml3_pl_write(pl: tpl; ha: tnuma): boolean;
var pll: pLLine; pints: PIntegers;
begin
  Result:=false;
  if Assigned(ha) and (ha.Count<>pl.count) then exit;
  if pl.count<=0 then exit;

  pll:=_dml3_pl_to_new_pll(pl);
  if pll=nil then exit;//!
  if Assigned(ha) then pints:=_dml3_ha_to_new_integers(ha) else pints:=nil;//!
  try
    if Assigned(pints) then dm_Set_xyz(pll, pints)
    else dm_Set_Poly_Buf(pll);
  finally
    mfree2(pints);
    _dml3_ll_free(pll);
  end;

  Result:=true;
end;

function dml3_pl_write(pl3: tpl3d): boolean;
begin
  Result := dml3_pl_write(pl3.pl, pl3.ha);
end;


function dml3_pl_add(code,loc: integer; pl: tpl; ha: tnuma; _down: boolean): integer;
var pll: pLLine;
begin
  //Result:=dm_Add_Poly(code,loc, 0{v}, nil, _down);

  pll:=_dml3_ll_new(1);//точка (0,0)
  try
    Result:=dm_Add_Poly(code,loc, 0{v}, pll, _down);
  finally
    _dml3_ll_free(pll);
  end;

  if Result>0 then dml3_pl_write(pl, ha);
  //ha[0]:=999; dml3_pl_read(pl, ha);//DEBUG
end;

function dml3_pl_add(code,loc: integer; pl3: tpl3d; _down: boolean): integer;
begin
  Result := dml3_pl_add(code,loc, pl3.pl,pl3.ha, _down);
end;


function dml3_ab_add(code: integer; a,b: tnum3; _down: boolean): integer;//отрезок, loc=2
var pl: tpl3d;
begin
  pl:=tpl3d.Create;
  try
    pl.Add(a);
    pl.Add(b);
    Result:=dml3_pl_add(code,2{loc}, pl, _down);
  finally
    pl.Free;
  end;
end;


procedure dml3_BL_XY(pl: tpa);
var i: integer; p2: tnum2;
begin
  if pl.Count>0 then for i:=0 to pl.Count-1 do begin
    dm_BL_XY(rad(pl[i].x),rad(pl[i].y), p2.x,p2.y);
    pl[i]:=p2;
  end;//for i
end;
procedure dml3_XY_BL(pl: tpa);
var i: integer; p2: tnum2;
begin
  if pl.Count>0 then for i:=0 to pl.Count-1 do begin
    dm_XY_BL(pl[i].x,pl[i].y, p2.x{rad},p2.y{rad});
    p2.x:=grad(p2.x);
    p2.y:=grad(p2.y);
    pl[i]:=p2;
  end;//for i
end;


function dml3_dmo_is_hole(aCode: integer): boolean;
var offs0: integer;
begin
  Result:=false;//default
  offs0:=dm_object;//save
  if dm_goto_upper then try
    Result := (dm_Get_Local=3){сверху - область} and (dm_Get_Code=aCode);
  finally
    dm_goto_node(offs0);//restore
  end;
end;

function dml3_dmo_is_hole: boolean;
begin
  Result := (dm_Get_Local=3) and dml3_dmo_is_hole(dm_Get_Code);
end;


function dml3_get_obj_name(code,loc: integer): string;
begin
  Result:=StrPas( obj_Get_Name(code,loc, @dml3_tmp_chars[0]) );
end;


procedure dml3_get_selection(offsa: tinta; dmo3dlist: tclasslist{of tdmo3d}; _listclear: boolean = true);
var i: integer; dmo: tdmo3d;
begin
  if _listclear then dmo3dlist.Clear;
  if offsa.Count>0 then for i:=0 to offsa.Count-1 do begin
    if not dm_goto_node( offsa[i] ) then continue;
    dmo:=tdmo3d.CreateFromDm;
    dmo3dlist.Add(dmo);
  end;//for i
end;


///////////////////////////// ОБЪЕКТЫ: /////////////////////////////

{ tdmo3d: }

constructor tdmo3d.Create;
begin
  inherited Create;
  PL3:=tpl3d.Create;
end;

constructor tdmo3d.CreateCode(aCode,aLoc: integer);
begin
  Create;//virtual!
  DmCode:=aCode;
  DmLoc:=aLoc;
end;

constructor tdmo3d.CreateFromDm;
begin
  Create;//virtual!
  Read;//boolean???
end;

destructor tdmo3d.Destroy;
begin
  PL3.Free;
  inherited Destroy;
end;

procedure tdmo3d.Clear;
begin
  PL3.Clear;
  DmOffs:=0;//!
end;


function tdmo3d.Read: boolean;
var PL1,PL2: tpl3d;
begin
  Result := false;
  DmOffs := dm_object;
  DmCode := dm_Get_Code;
  DmLoc  := dm_Get_Local;
  if (DmCode>=0) and (DmLoc>0) then Result := dml3_pl_read(PL3);

  //ДЫРКИ - в конце:
  if Result and (DmLoc=3) and dm_goto_down then try
    PL1:=PL3;//контур
    repeat
      if (dm_Get_Local=DmLoc) and (dm_Get_Code=DmCode) then begin

        PL2:=tpl3d.Create;
        if dml3_pl_read(PL2) then begin
          PL1.Next:=PL2;//подсоединение дырки
          //PL1.pl.Next:=PL2.pl;//НЕЛЬЗЯ из-за Destroy!!!
          PL1:=PL2;//next
        end else
          PL2.Free;

      end;//Loc,Code
    until not dm_goto_right;
  finally
    dm_goto_upper;//!
  end;
end;

procedure tdmo3d.WriteData;
begin
//виртуальный шаблон нужен
end;

function tdmo3d.Add(_down: boolean): integer;
begin
  Result:=-1;//default
  DmOffs:=dml3_pl_add(DmCode,DmLoc, Pl3, _down);
  if DmOffs>0 then begin
    Result:=DmOffs;
    WriteData;//!
  end;
end;

function tdmo3d.AddTo(offs: integer; _down: boolean): integer;
var dmoffs0: integer;
begin
  Result:=-1;
  dmoffs0:=dmoffs;//save
  if dm_goto_node(offs) then try
    Result:=Add(_down);//меняет dmoffs
  finally
    dmoffs:=dmoffs0;//restore
  end;
end;

function tdmo3d.sCode: string;
begin
  Result := dml0_Code_To_String(DmCode);
end;


{ tdmo3id: }

procedure tdmo3id.Clear;
begin
  inherited Clear;
  DmId:=0;
  //OraId:=0;
end;

function tdmo3id.Read: boolean;
begin
  DmId  := dml3_read_integer(1000);//default=0
  //OraId := dml3_read_real(1002);//default=0
  Result := inherited Read;//m.b. ДЫРКИ => inherited - в конце Read!!!
end;

procedure tdmo3id.WriteData;
begin
  inherited WriteData;//ЗДЕСЬ НЕТ PL => без перхода на дырках!
  DmId:=dm_Assign_Index(DmOffs);//записывать @1000 уже не надо!!!
  //if OraId>0{!} then dml3_write_real(1002,OraId);
end;

function tdmo3id.AddTo(offs: integer; _down: boolean): integer;
var dmid0: integer;
begin
  Result:=-1;
  dmid0:=dmid;//save
  if dm_goto_node(offs) then try
    Result := inherited AddTo(offs, _down);//меняет dmoffs,dmid(через virtual WriteData!)
  finally
    dmid:=dmid0;//restore
  end;
end;


///////////////////////////// СПИСКИ: /////////////////////////

{ TDmo3dList: }

function TDmo3dList.Get(Index: Integer): tdmo3d;
begin
  tobject(Result) := inherited Get(Index);
end;
(*
function TDmo3dList.CreateItem_FromDm: tobject;
begin
  Result := tdmo3d.CreateFromDm;
end;
*)

function TDmo3dList.IndexOf_Code(aLoc,aCode: integer): integer;
var i: integer; dmo: tdmo3d;
begin
  Result:=-1;
  if Count>0 then for i:=0 to Count-1 do begin
    dmo:=_[i];
    if not Assigned(dmo) then continue;//!
    if dmo.DmLoc<>aLoc then continue;
    if dmo.DmCode<>aCode then continue;
    Result:=i;
    break;
  end;//for i
end;

function TDmo3dList.IndexOf_Offs(aOffs: integer): integer;
var i: integer; dmo: tdmo3d;
begin
  Result:=-1;
  if Count>0 then for i:=0 to Count-1 do begin
    dmo:=_[i];
    if not Assigned(dmo) then continue;//!
    if dmo.DmOffs<>aOffs then continue;
    Result:=i;
    break;
  end;//for i
end;

function TDmo3dList.Find_Code(aLoc,aCode: integer): tdmo3d;
var i: integer; dmo: tdmo3d;
begin
  Result:=nil;
  if Count>0 then for i:=0 to Count-1 do begin
    dmo:=_[i];
    if not Assigned(dmo) then continue;//!
    if dmo.DmLoc<>aLoc then continue;
    if dmo.DmCode<>aCode then continue;
    Result:=_[i];
    break;
  end;//for i
end;

function TDmo3dList.Find_Offs(aOffs: integer): tdmo3d;
var i: integer; dmo: tdmo3d;
begin
  Result:=nil;
  if Count>0 then for i:=0 to Count-1 do begin
    dmo:=_[i];
    if not Assigned(dmo) then continue;//!
    if dmo.DmOffs<>aOffs then continue;
    Result:=_[i];
    break;
  end;//for i
end;

(*
procedure TDmo3dList.AddFromOffsArray(offsa: tinta);//OLD
var i: integer; dmo: tobject;
begin
  if offsa.Count>0 then for i:=0 to offsa.Count-1 do begin
    if not dm_goto_node( offsa[i] ) then continue;
    dmo:=CreateItem_FromDm;//virtual!
    Add(dmo);
  end;//for i
end;
*)
procedure TDmo3dList.AddFromOffsArray(const aItemType: tdmo3dClass{потомок}; offsa: tinta);//NEW
var i: integer; dmox{потомок}: tdmo3d;
begin
  if offsa.Count>0 then for i:=0 to offsa.Count-1 do begin
    if not dm_goto_node( offsa[i] ) then continue;
    dmox:=aItemType.CreateFromDm;//virtual!
    Add(dmox);
  end;//for i
end;
(*
procedure TDmo3dList.AddFromDm(aLoc,aCode: integer);//OLD
var offs: integer; dmo: tobject;
begin
  offs := dm_Find_Frst_Code(aCode,aLoc);
  while offs>0 do begin
    if (aLoc<>3) or not dml3_dmo_is_hole(aCode) then begin//дырка - in dmo.Read
      dmo:=CreateItem_FromDm;//virtual!
      Add(dmo);
    end;
    offs := dm_Find_Next_Code(aCode,aLoc);//NEXT
  end;//while
end;
*)
procedure TDmo3dList.AddFromDm(const aItemType: tdmo3dClass{потомок}; aLoc,aCode: integer);//NEW
var offs: integer; dmox{потомок}: tdmo3d;
begin
  offs := dm_Find_Frst_Code(aCode,aLoc);
  while offs>0 do begin
    if (aLoc<>3) or not dml3_dmo_is_hole(aCode) then begin//дырка - in dmo.Read
      dmox:=aItemType.CreateFromDm;//virtual!
      Add(dmox);
    end;
    offs := dm_Find_Next_Code(aCode,aLoc);//NEXT
  end;//while
end;


procedure TDmo3dList.AddFirstPointsTo(pl: tpl3d);
var i: integer;
begin
  if Count>0 then for i:=0 to Count-1 do
    if _[i].PL3.Count>0 then pl.Add( _[i].PL3.First );
end;

(*
procedure TDmo3dList.AddCodesTo(aCodes: tinta);//разные!
var i,ind: integer;
begin
  if Count>0 then for i:=0 to Count-1 do begin
    if not Assigned(_[i]) then continue;//!
    ind:=aCodes.IndexOf(_[i].Dmcode); if ind>=0 then continue;//код уже есть
    aCodes.Add(_[i].Dmcode);
  end;//for i
end;
*)
procedure TDmo3dList.AddCodesTo(aCodes: tinta; aLoc: integer = -1{NotUsed});//разные!
var i,ind: integer;
begin
  if Count>0 then for i:=0 to Count-1 do begin
    if not Assigned(_[i]) then CONTINUE;//!
    if (aLoc>=0) and (_[i].DmLoc<>aLoc) then CONTINUE;//не та локализация
    ind:=aCodes.IndexOf(_[i].Dmcode); if ind>=0 then CONTINUE;//код уже есть
    aCodes.Add(_[i].Dmcode);
  end;//for i
end;


{ TDmo3idList: }

function TDmo3idList.Get(Index: Integer): tdmo3id;
begin
  tobject(Result) := inherited Get(Index);
end;
(*
function TDmo3idList.CreateItem_FromDm: tobject;
begin
  Result := tdmo3id.CreateFromDm;
end;
*)

function TDmo3idList.IndexOf_DmId(aDmId: integer): integer;
var i: integer;
begin
  Result:=-1;
  if Count>0 then for i:=0 to Count-1 do begin
    if not Assigned(_[i]) then continue;//!
    if _[i].DmId<>aDmId then continue;
    Result:=i;
    break;
  end;//for i
end;

function TDmo3idList.Find_DmId(aDmId: integer): tdmo3id;
var i: integer;
begin
  Result:=nil;
  if Count>0 then for i:=0 to Count-1 do begin
    if not Assigned(_[i]) then continue;//!
    //if not (_[i] is tdmo3id) then continue;//!
    if _[i].DmId<>aDmId then continue;
    Result:=_[i];
    break;
  end;//for i
end;


end.
