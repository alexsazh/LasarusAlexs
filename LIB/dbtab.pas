(*
  TDbTabDataList - описания таблиц - ОПРЕД-СЯ ВОВНЕ
  TDbTabData - описание таблицы из списка
  TDbTab1 - viewer таблицы - TForm
*)
unit dbtab; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, Menus,
  list;


type
  TDBTabModes = (dbm_Edit, dbm_Show);
  TDBTabMode = set of TDBTabModes;

type
  //USEING: Create - имена таблиц и полей - [Add_SubMenu] - DbTabForm_New(показ формы)
  TDbTabData = class
  private
    FList: TClassList;//:TDbTabDataList.Add_Tab
  public
    Form: TForm;//:TDbTab1 (DbTabForm_New), NIL <=> таблица закрыта
    Columns: TStringList;//count=0 => все поля
    FloatFields: TStringList;

    //НАДО ОПРЕДЕЛЯТЬ:
    Connection: TADOConnection;
    Qry: string;//'' => все записи!

    //имена таблиц и полей:
    st: string;
    sf_Id: string;//DbId
    sf_DmId: string;//@1000 - связь с картой (м.б. '')

    st_Parent: string;
    sf_ParentId: string;//m.b.'' - ссылка на DbId верхней таблицы => фильтр

    constructor Create;
    destructor Destroy; override;//DbTabForm_Free=>Form=NIL(Free)

    procedure Set_Parent(ast_Parent, asf_ParentId: string);

    //Menu:
    procedure Add_SubMenu(menu: TMenuItem);//Menu_OnClick -> menu
    procedure Menu_OnClick(Sender: TObject);//TNotifyEvent

    //Создание (показ), удаление формы и запись/чтение ширин столбцов:
    function Form_New: boolean;//MSG, Create Form: TDbTab1
    procedure Form_RParams;//Form_New
    procedure Form_WParams;//FForm.OnDestroy
  end;

type
  //USEING: Create - Add_Tab.Set_Parent - Set_Connections+[Set_SubMenus]
  TDbTabDataList = class(TClassList)
  private
  protected
    function Get(i: Integer): TDbTabData;//m.b. i>=Count
  public
    destructor Destroy; override;

    function Add_Tab: TDbTabData; overload;//пустой элемент!
    function Add_Tab(ast, asf_Id,asf_DmId{m.b.''}, aQry{m.b.''}: string): TDbTabData; overload;//Create,Add,SetParams

    //for all:
    procedure Set_Connections(aConnection: TADOConnection);//TDbTabData.Connection
    procedure Set_SubMenus(menu: TMenuItem);//каждая таблица -> SubMenu
    procedure PutToStrings(sl: TStrings);//with Objects
    procedure Set_Columns_FromIniFile(fname: string);//указание столбцов

    function IndexOf_TabName(ast: string; _parent: boolean; ind0: integer = 0): integer;

    property Items[i: Integer]: TDbTabData read Get; default;
  end;

type
  //USEING: Create - SetTabParent,SetTab - TabOpen - SetFilter...:
  TDbTab1 = class(TForm)
    Grid: TDBGrid;
    DataSet: TADODataSet;
    DataSource: TDataSource;
    PopupMenu1: TPopupMenu;
    pm_FindActiveObj: TMenuItem;
    N2: TMenuItem;
    pm_3Dscene: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure pm_3DsceneClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure pm_FindActiveObjClick(Sender: TObject);
    procedure DataSetAfterScroll(DataSet: TDataSet);
    procedure GridDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure _FormHide(Sender: TObject);//это не реакция(!) - просто процедура!
    procedure GridTitleClick(Column: TColumn);
  private
    //Смена фильтра (Filtered - Create):
    procedure SetFilter(aFilter: string); overload;//=>Caption
    procedure SetFilter(aParentId: integer); overload;//по Parent-таблице
    procedure SetFilter; overload;//по Parent-таблице

    //Смена индекса:
    procedure SetIndexField(aFieldName: string);//список через ";"
  public
    TabData: TDbTabData;//внешняя ссылка (без Free), TabData.Form=Self

    //СВЯЗИ: SetTabParent:
    TabParent: TDbTab1;//Таблицы, определяющие фильтр своими sf_id
    TabChildren: tptrlist;//of TDbTab1 - Таблицы, фильтры к-ых опред-ся Data.sf_id

    function TabDataList: TDbTabDataList;

    //Установка ПАРАМЕТРОВ:
    procedure SetTabData(aTabData: TDbTabData);
    procedure SetTabParent(aTabParent: TDbTab1);

    //OPEN/CLOSE/CHANGE: aQry='' => все записи:
    function TabOpen(aConnection: TADOConnection; aQry: string): boolean; overload;//msg
    function TabOpen: boolean; overload;//msg, Qry-повтор
    procedure TabClose;
    procedure Tab_AfterChange(_close: boolean);//изменение RecordSet

    //Взаимодействие c картой:
    procedure ShowObjectOnAlw(_3D: boolean);//показ объекта на карте
    procedure ShowGabarit;//3D-сцена, перпенд-но проводу
  end;

//var DbTab1: TDbTab1;//NOT USED!


implementation

{$R *.dfm}

uses
  dmw_use, alw_dde,
  alwlib, dmlib3d,
  wcmn, cmn, vlib3d, adolib, sqllib, dbcmn;


{ TDbTabData: }

constructor TDbTabData.Create;
begin
  inherited;
  Columns:=TStringList.Create;
  FloatFields:=TStringList.Create;
end;

destructor TDbTabData.Destroy;
begin
  if Assigned(Form) then Tell('TDbTabData.Destroy: Form<>NIL');//DEBUG
  FloatFields.Free;
  Columns.Free;
  inherited;
end;

procedure TDbTabData.Set_Parent(ast_Parent, asf_ParentId: string);
begin
  st_Parent:=ast_Parent;
  sf_ParentId:=asf_ParentId;
end;


function TDbTabData.Form_New: boolean;//создание ФОРМЫ Form: TDbTab1
var i: integer; xForm: TDbTab1; col: TColumn; ff: TFloatField;
begin
  Result:=false;//!

  //Форма уже открыта:
  if Assigned(Form) then begin
    Form.Show;
    Result:=true;
    exit;//!
  end;

  xForm:=nil;//!
  if Connection.Connected and Assigned(FList) then begin
    xForm := TDbTab1.Create(nil);
    xForm.SetTabData(Self);
    Result:=xForm.TabOpen(Connection, Qry);//=>Filter,ChildrenFilter, new Result
  end;

  if Result then Form:=xForm;//!

  //Assigned(Form=xForm):
  if Result and Assigned(Form) then begin

    //Столбцы - до чтения параметров(Form_RParams):
    if Columns.Count>0 then begin
      xForm.Grid.Columns.Clear;
      i:=0;//!
      while i<Columns.Count-1{uses i+1} do begin
        //СТОЛБЕЦ:
        col:=xForm.Grid.Columns.Add;
        col.FieldName:=Columns[i];
        if Columns[i+1]<>'' then col.Title.Caption:=Columns[i+1];//Заголовок: Alignment,Color,...
        inc(i,2);//NEXT i
      end;//while
    end;//Columns.Count>0

    //Ini.RForm0(Form, st);//after Form.SetTabData: OnCreate НЕЛЬЗЯ: Form есть, а TabData.st ещё нет!
    Form_RParams;//after xForm.SetTabData & FForm:=xForm - ширины столбцов

    //Веществ. поля - 2 цифры после запятой:
    if FloatFields.Count>0 then for i:=0 to FloatFields.Count-1 do begin
      tfield(ff):=xForm.DataSet.FieldByName( FloatFields[i] );
      //ff.Precision:=2;
      //ff.DisplayFormat:='#.##';
      ff.DisplayFormat:='0.00';//не менее 2-х цифр после запятой, 0 перед запятой пишется
    end;//for i

    Form.Show;//!
  end else begin
    Tell('TDbTabData.DbTabForm_New=FALSE');//DEBUG
    xForm.Free;//!
  end;
end;

procedure TDbTabData.Form_RParams;
var i,iw: integer; frm: TDbTab1; clmns: TDBGridColumns; clmn: TColumn;
begin
  if not Assigned(Form) then exit;

  Ini.RForm0(Form, st);//=>Section!

  //Столбцы (секция установлена):
  tobject(frm):=Form;
  clmns:=frm.Grid.Columns;
  if clmns.Count>0 then for i:=0 to clmns.Count-1 do begin
    clmn:=clmns.Items[i];
    if clmn.FieldName<>'' then begin
      iw:=Ini.RI(clmn.FieldName, 0);
      if iw>0 then clmn.Width:=iw;
      //if iw=0 then Tell('TDbTabData.Form_RParams: iw=0');//DEBUG
    end;
  end;//for i
end;

procedure TDbTabData.Form_WParams;
var i,iw: integer; frm: TDbTab1; clmns: TDBGridColumns; clmn: TColumn;
begin
  if not Assigned(Form) then exit;

  Ini.WForm0(Form, st);//=>Section!

  //Столбцы (секция установлена):
  tobject(frm):=Form;
  clmns:=frm.Grid.Columns;
  if clmns.Count>0 then for i:=0 to clmns.Count-1 do begin
    clmn:=clmns.Items[i];
    if clmn.FieldName<>'' then begin
      iw:=clmn.Width;
      if iw<10 then iw:=10;//ОГРАНИЧЕНИЕ: минимальная ширина столбца !?!
      Ini.WI(clmn.FieldName, iw);
    end;
  end;//for i
end;


procedure TDbTabData.Add_SubMenu(menu: TMenuItem);
var mi: TMenuItem;
begin
  mi:=TMenuItem.Create(menu);//SubMenu
  menu.Add(mi);

  if st<>'' then begin
    mi.Caption:=st;
    mi.OnClick:=Menu_OnClick;//!
  end else
    mi.Caption:='-';//разделитель меню
end;

procedure TDbTabData.Menu_OnClick(Sender: TObject);
begin
  if not Form_New{msg} then {?};
end;


{ TDbTabDataList: }

destructor TDbTabDataList.Destroy;
var i: integer; td: TDbTabData;
begin
  //Закрытие открытых форм:
  if Count>0 then for i:=Count-1 downto{!} 0 do begin
    td:=Items[i];
    if Assigned(td.Form) then td.Form.Close;
  end;//for i
  Application.ProcessMessages;//!

  inherited;
end;

function TDbTabDataList.Get(i: Integer): TDbTabData;
begin
  tobject(Result) := inherited Get(i);
end;

function TDbTabDataList.Add_Tab: TDbTabData;//пустой элемент!
begin
  Result:=TDbTabData.Create;
  Result.FList:=Self;//!
  Add(Result);
end;

function TDbTabDataList.Add_Tab(ast, asf_Id, asf_DmId{m.b.''}, aQry{m.b.''}: string): TDbTabData;
begin
  Result:=Add_Tab;

  Result.st:=ast;
  Result.sf_Id:=asf_Id;
  Result.sf_DmId:=asf_DmId;
  Result.Qry:=aQry;
end;


procedure TDbTabDataList.Set_Connections(aConnection: TADOConnection);
var i: integer;
begin
  if Count>0 then for i:=0 to Count-1 do begin
    Items[i].Connection:=aConnection;
  end;//for i
end;

procedure TDbTabDataList.Set_SubMenus(menu: TMenuItem);
var i: integer;
begin
  menu.Clear;//!
  if Count>0 then for i:=0 to Count-1 do begin
    Items[i].Add_SubMenu(menu);
  end;//for i
end;

procedure TDbTabDataList.PutToStrings(sl: TStrings);
var i: integer; td: TDbTabData;
begin
  sl.Clear;//!
  if Count>0 then for i:=0 to Count-1 do begin
    td:=Items[i];
    if td.st<>'' then sl.AddObject(td.st, td);
  end;//for i
end;

procedure TDbTabDataList.Set_Columns_FromIniFile(fname: string);
var i: integer; td: TDbTabData; fini: TIni; sl: TStringList; s: string;
begin
  if not FileExists(fname) then exit;

  fini:=TIni.Create0(fname);
  sl:=TStringList.Create;
  try
    if Count>0 then for i:=0 to Count-1 do begin
      td:=Items[i];
      td.Columns.Clear;//default!
      if td.st='' then continue;//пустой элемент ("-" в меню!)

      s:=fini.ReadString(td.st, 'Columns', '');
      if s='' then continue;//таблицы нет в ini-файле!

      string2stringlist(s, td.Columns)//список имён столбцов
    end;//for i
  finally
    sl.Free;
    fini.Free;
  end;
end;


function TDbTabDataList.IndexOf_TabName(ast: string; _parent: boolean; ind0: integer): integer;
var i: integer; td: TDbTabData;
begin
  Result:=-1;
  if (Count>0) and (ind0<Count) then for i:=ind0 to Count-1 do begin
    td:=Items[i];
    if _parent and (td.st_Parent=ast)
    or not _parent and (td.st=ast)
    then begin
      Result:=i;
      break;
    end;
  end;//for i
end;


{ TDbTab1: }

function TDbTab1.TabDataList: TDbTabDataList;
begin
  tobject(Result) := TabData.FList;
end;

procedure TDbTab1.SetTabData(aTabData: TDbTabData);
begin
  TabData:=aTabData;
end;

procedure TDbTab1.SetTabParent(aTabParent: TDbTab1);
//var ind: integer;
begin
(*
  //Удаление родителя:
  if Assigned(TabParent){форма открыта} then begin
    ind:=TabParent.TabChildren.IndexOf(Self);
    if ind>=0 then TabParent.TabChildren.Delete(ind);
  end;
*)
  //Добавление родителя:
  TabParent:=aTabParent;//!
  if Assigned(TabParent){форма открыта}
  and (TabParent.TabChildren.IndexOf(Self)<0)
  then TabParent.TabChildren.Add(Self);//!

  SetFilter;//всегда!
end;


//////// FILTER:

procedure TDbTab1.SetFilter(aFilter: string);
begin
  if Assigned(DataSet) then DataSet.Filter:=aFilter;
//  if DataSet.Active then DataSet.Refresh;
end;

procedure TDbTab1.SetFilter(aParentId: integer);
begin
  if (TabData.sf_ParentId<>'')
  then SetFilter( Format('[%s]=%d',[{Dn:}TabData.sf_ParentId, {Up:}aParentId]) )
  else SetFilter('');
end;

procedure TDbTab1.SetFilter;
begin
  //проверки:
  if Assigned(TabParent)
  and TabParent.DataSet.Active//!
//  and DataSet.Active    //SetFilter - перед TabOpen!
//  and (TabParent.DataSet.RecordCount>0)//?: все записи, если верхняя таблица пуста

  //Refresh - in SetFilter:
  then SetFilter(TabParent.DataSet.FieldByName(TabParent.TabData.sf_Id).AsInteger)
  else SetFilter('');//!
end;


procedure TDbTab1.SetIndexField(aFieldName: string);//список через ";"
begin
  //Tellf('SetIndexField: "%s"',[aFieldName]);//DEBUG
  DataSet.IndexFieldNames:=aFieldName;
end;


//////// OPEN/CLOSE/CHANGE:

function TDbTab1.TabOpen(aConnection: TADOConnection; aQry: string): boolean;
var ind: integer; td: TDbTabData;
begin
  TabClose;//перд SetTabParent!

  //Parent: эта таблица - ребёнок - 1 родитель:
  ind:=TabDataList.IndexOf_TabName(TabData.st_Parent, false{_parent}, 0{ind0});
  if ind>=0 then begin
    td:=TabDataList[ind];
    SetTabParent(td.Form as TDbTab1);//m.b. nil!
  end;

  //Children: эта таблица - родитель - м.б. много детей:
  ind:=TabDataList.IndexOf_TabName(TabData.st, true{_parent}, 0{ind0});
  while ind>=0 do begin
    td:=TabDataList[ind];
    if Assigned(td.Form){форма открыта}
    then (td.Form as TDbTab1).SetTabParent(Self);//=>td.FForm.Children
    ind:=TabDataList.IndexOf_TabName(TabData.st, true{_parent}, ind+1);//NEXT
  end;//while

  if aQry='' then aQry := sql_select1('*', TabData.st, ''{swhere}, ''{sortedby});//default!

  SetWaitCursor;//?
  try
    Result := aConnection.Connected;
    if Result then begin
      DataSet.Connection:=aConnection;//!
      Result := ado_open_msg(DataSet, aQry, true{readonly});
      //if Result then SetFilter;//by parent || '' --- SetFilter - in SetTabParent!
    end;
  finally
    SetDefCursor;//?
  end;

  if Result and (ado_count(DataSet)=0){не будет AfterScroll!}
  then Tab_AfterChange(false{_close});//=>Caption
end;

function TDbTab1.TabOpen: boolean;
begin
  Result := TabOpen(DataSet.Connection, DataSet.CommandText);
end;

procedure TDbTab1.TabClose;
begin
  if not DataSet.Active then exit;//!
  if Assigned(TabData.Form){это закрытие окна, а не программы!}
  then Tab_AfterChange(true);//изменение детей
  ado_close(DataSet, true{readonly});
end;

procedure TDbTab1.Tab_AfterChange(_close: boolean);
var i: integer; child: TDbTab1;
begin
  //исключение из TabParent.TabChildren:
  if _close and Assigned(TabParent) then begin
    i:=TabParent.TabChildren.IndexOf(Self);
    if i>=0 then TabParent.TabChildren.Delete(i);
  end;

  if TabChildren.Count>0 then for i:=0 to TabChildren.Count-1 do begin
    tobject(child):=TabChildren[i];
    if _close then child.SetTabParent(nil)//удаление родителя у детей
    else child.SetFilter;//открытие или прокрутка => Filter
//    child.Tab_AfterChange(false{_close});//РЕКУРСИЯ ???
  end;//for i

  //Caption:
  if not _close{!}
  then Caption := Format('%s (%d)',[TabData.st, ado_count(DataSet){m.b.closed}])
end;


//////// РАЗНОЕ:

procedure TDbTab1.ShowObjectOnAlw(_3D: boolean);
var dmid: integer;
begin
  //dmid:
  if DataSet.RecordCount<=0 then exit;
  if TabData.sf_DmId='' then exit;//m.b.''
  dmid:=DataSet.FieldByName(TabData.sf_DmId).AsInteger;

  if _3D
  then alwl_show_DmId(dmid, 2)//2: перерисовка, только если нет в окне, С ПРОФИЛЕМ
  else alwl_show_DmId(dmid, 0);//0: перерисовка, только если нет в окне - ПЛАН
end;

procedure TDbTab1.ShowGabarit;//3D-сцена, перпенд-но проводу
var dmid,offs,offs_wire: integer; dmo: tdmo3d; p_wire: tnum3;
begin
  //dmid:
  if DataSet.RecordCount<=0 then exit;
  if TabData.sf_DmId='' then exit;//m.b.''
  dmid:=DataSet.FieldByName(TabData.sf_DmId).AsInteger;

  offs_wire:=0;//!
  dmo:=tdmo3d.Create;
  try
    //пар-ры габарита и род-го провода:
    if alwl_dm_open_read then try
      offs:=dm_Id_Offset(dmid);
      if dm_goto_node(offs) then begin
        dmo.Read;//!
        dm_goto_upper;//провод д.б.

        if (dm_get_local=2)
        then offs_wire:=dm_object
        else Tell('Родительский объект - не линия');
      end;
    finally
      alwl_dm_close;
    end;

    if offs_wire>0{!} then begin

      alwl_show_Offs(offs_wire, 2);//2: С ПРОФИЛЕМ => провод активен (Лев)

      p_wire:=dmo.PL3.First;
      alw_d3_wire(-1{0},offs_wire, p_wire.p.x,p_wire.p.y,p_wire.z);//3D-КУРСОР ортог. проводу
    end;
  finally
    dmo.Free;
  end;
end;


{ Events: }

procedure TDbTab1.DataSetAfterScroll(DataSet: TDataSet);
begin
  Tab_AfterChange(false);
end;


procedure TDbTab1.GridTitleClick(Column: TColumn);
begin
  SetIndexField(Column.FieldName);
end;

procedure TDbTab1.GridDblClick(Sender: TObject);
begin
  ShowObjectOnAlw(true{_3D});
end;



procedure TDbTab1.PopupMenu1Popup(Sender: TObject);
begin
  pm_3Dscene.Enabled := TabData.st=dbcmn_t_gab;
end;

procedure TDbTab1.pm_3DsceneClick(Sender: TObject);
begin
  ShowGabarit;
end;

procedure TDbTab1.pm_FindActiveObjClick(Sender: TObject);
var dmid: integer;
begin
  if DataSet.RecordCount<=0 then exit;
  if TabData.sf_DmId='' then exit;//m.b.''
  if not alwl_dm_id(dmid{@1000}, true{_msg}) then exit;//!

  if not ado_find_int(DataSet, TabData.sf_DmId, dmid)
  then Tellf('Объект DmId=%d в активной таблице не найден',[dmid]);
end;



procedure TDbTab1.FormCreate(Sender: TObject);
begin
  TabChildren:=tptrlist.New;
end;

procedure TDbTab1.FormDestroy(Sender: TObject);
begin
  TabChildren.Free;
end;

procedure TDbTab1.FormShow(Sender: TObject);
begin
  TStringGrid(Grid).DefaultRowHeight:=cmn_DefaultRowHeight;//РАБОТАЕТ!
end;

procedure TDbTab1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;//!
  _FormHide(Sender);//сам не вызывпается!!!
end;

procedure TDbTab1._FormHide(Sender: TObject);
begin
  //Ini.WForm0(Self, TabData.st);//Ini.RForm0 - in TDbTabData.Form_New
  TabData.Form_WParams;//Form_RParams - in TDbTabData.Form_New
  TabClose;//ПОСЛЕ Form_WParams!
  TabData.Form:=nil;//после TabClose!
end;


end.
