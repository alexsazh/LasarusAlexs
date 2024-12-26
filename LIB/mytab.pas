(*
  TMyTab: просто таблица с именем aTabName (aConnection, aReadOnly);

  Обработка зависимых таблиц:
  TMyTab2: имеет ссылки (FRefs,FRefsCount) вверх (через "верхнее" поле "ID") и вниз (FDnTbl)

  - Эти ссылки надо задать (AddUpTbl) и все связ-ые таблицы должны иметь тип TMyTab2
  - Таблицы должны иметь поля "ID"(обязательное поле - "счетчик") и "NAME"(order)
  - если имена отличаются, то их надо задать(property)
  - Destroy не вызывает Close (все связанные Close, потом все связанные Destroy)
  - OpenLock, OnScrollLock - запиратели Open, AfterScroll

  Определяются (занимаются) TDataSet-EVENTS:
    OnPostError = TMyTab.DataSet_OnPostError
    AfterScroll = TMyTab2.DataSet_AfterScroll
    OnNewRecord = TMyTab2.DataSet_OnNewRecord

  TMyTab2-EVENTS:
    FAfterScrollEvent: Open,Scroll,Close

  Внешние связи:
    TMyTab.DataSource,DataSet можно получить
    TMyTab2.Open -> OnEnter во внешних TDBGreed

  DB-NOTES:
    - значение ID(счетчик) возникает после "Post"
    - есть вредное событие AfterScroll на DataSet.Open(полей нет), борьба: OnScrollLock in Open
    - после Close НЕТ AfterScroll
*)
unit mytab; interface

uses
  Classes, DB, ADODB,
  mytabfield;


const
  mytab_float_format: string = '#.00';


type
  //типы из DB.PAS:
  //TDataSetNotifyEvent = procedure(DataSet: TDataSet) of object;
  //TDataSetErrorEvent = procedure(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction) of object;
  //TDataAction = (daFail, daAbort, daRetry);

  TMyTab = class;
  TMyTab2 = class;

  TMyTab2NotifyEvent = procedure(aMyTab: TMyTab2) of object;

  TMyTab = class
  protected
    FOpenLock: boolean;//true: Open не работает
    FOnScrollLock: boolean;//true: событие OnScroll не обрабатывается

    FTabCaption: string;//имя таблицы человеческое
    FTabName: string;//имя таблицы в БД
    FReadOnly: boolean;

    FIDFieldName: string;//имя поля 'ID'
    FNameFieldName: string;//имя поля 'Name'
    FDataSource: TDataSource;//create in GetDataSource

    //OnOpen:
    FIDField: TField;
    FNameField: TField;//order field
    FQuery: string;//последний Open

    //DataSet's:
    FDataSet: TDataSet;//всегда есть, д.б. родителем одного из следующих полей:
    FAdoDataSet: TAdoDataSet;

    //MyTab Events:
    FAfterScrollEvent: TMyTab2NotifyEvent;//After Open,Scroll,Close
    procedure OnCreate; virtual;
    procedure OnDestroy; virtual;

    //DataSet Events:
    procedure OnPostError(aDataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);

    function GetTabCaption: string;
    function GetDataSource: TDataSource;//FDataSource.create, if nil
  public
    Fields: TMyTabFields;//Add, AddNames
    constructor Create(aConnection: TCustomConnection;
      aTabName: string; aReadOnly: boolean); overload;
    constructor Create(aConnection: TCustomConnection;
      aTabName,aTabCaption: string; aReadOnly: boolean); overload;

    destructor Destroy; override;

    function OpenQuery(aQuery: string): boolean; overload;//BASE Open
    function OpenQuery: boolean; overload;//ReOpen by FQuery
    function OpenWhere(aWhere: string): boolean; overload;//order by NAME
    function Open: boolean; overload;//All, order by NAME
    procedure Close; virtual;
    procedure DeleteRecord; virtual;//with confirm

    function GetID: integer;//FIDField, default ID=0
    function GetName: string;//FNameField
    function GetInfo: string;//"ID: Name"

    procedure Tell(Fmt: string; const Args: array of const); overload;
    procedure Tell(msg: string); overload;

    function FindID(aID: integer): boolean;

    //READ properties:
    property TabCaption: string read GetTabCaption;
    property TabName: string read FTabName;
    property _ReadOnly: boolean read FReadOnly;

    property DataSource: TDataSource read GetDataSource;//создаётся, если нужно!
    property DataSet: TDataSet read FDataSet;
    property AdoDataSet: TAdoDataSet read FAdoDataSet;

    //WRITE properties:
    property OpenLock: boolean write FOpenLock;

    property IDFieldName: string write FIDFieldName;//задать, если отличается от "ID"
    property NameFieldName: string write FNameFieldName;//задать, если отличается от "NAME"

    property AfterScrollEvent: TMyTab2NotifyEvent write FAfterScrollEvent;
  end;

  //для запросов необх. связь "вверх": Ref.UpTbl.ID = содержимое Ref.FieldName
  TMyTabRef = record
    UpTbl: TMyTab2;//ссылка вверх
    FieldName: string;//имя обязательного integer-поля теущей таблицы, равного UpTbl.GetID
  end;

  TMyTab2 = class(TMyTab)//имеет ссылки вверх и вниз
  protected
    FRefs: array[0..10]of TMyTabRef;//ссылки вверх
    FRefsCount: integer;
    FDnTbl: TMyTab2;//ссылка вниз: имеет ссылку вверх на Self

    //MyTab Events:
    procedure OnCreate; override;

    //DataSet Events:
    procedure DataSet_AfterScroll(aDataSet: TDataSet);//Open with Down tables (m.b.Close)
    procedure DataSet_OnNewRecord(aDataSet: TDataSet);//set referenced fields to upper's ID
  public
    procedure AddUpTbl(aUpTbl: TMyTab2; aFieldName: string);//добавление ссылки вверх
    function Open: boolean; overload;//where FUpTbl, order by NAME, Close при верх.инд.<=0
    procedure Close; override;//вместе с нижними
    procedure DeleteRecord; override;//если нижних нет
  end;


implementation

uses
  SysUtils,
  wcmn, sqllib, adolib;


{ TMyTab: }

constructor TMyTab.Create(aConnection: TCustomConnection;
  aTabName: string; aReadOnly: boolean);
begin
  Fields:=TMyTabFields.New;

  //параметры Create:
  FTabName:=aTabName;
  FReadOnly:=aReadOnly;

  //FDataSet:
  if aConnection is TAdoConnection then begin
    FAdoDataSet:=TAdoDataSet.Create(nil);
    FAdoDataSet.Connection := aConnection as TAdoConnection;
    FDataSet:=FAdoDataSet;//FDataSet - всегда
  end;

  OnCreate;//общее продолжение
end;

constructor TMyTab.Create(aConnection: TCustomConnection;
  aTabName,aTabCaption: string; aReadOnly: boolean);
begin
  FTabCaption:=aTabCaption;
  Create(aConnection, aTabName, aReadOnly);
end;

procedure TMyTab.OnCreate;
begin
  if not Assigned(FDataSet) then Tell('Create ERROR: DataSet=nil');

  FIDFieldName:='ID';//default
  FNameFieldName:='NAME';//default

  //DataSet Events:
  FDataSet.OnPostError:=OnPostError;
end;

destructor TMyTab.Destroy;
begin
  OnDestroy;
  //Close;//НЕЛЬЗЯ: в TMyTab2 м.б. закрытие уже несуществующих нижних таблиц
  FDataSource.Free;
  FDataSet.Free;

  Fields.Free;
end;

procedure TMyTab.OnDestroy;
begin
end;

function TMyTab.GetDataSource: TDataSource;//FDataSource.create, if nil
begin
  if not Assigned(FDataSource) then begin
    FDataSource:=TDataSource.Create(nil);
    FDataSource.DataSet:=FDataSet;
  end;
  Result:=FDataSource;
end;

//OPEN:

function TMyTab.OpenQuery(aQuery: string): boolean;//BASE Open
begin
  Result:=false;
  FQuery:='';
  Close;//вместе с нижними!
  if FOpenLock then exit;
  if not Assigned(FDataSet) then begin Tell('OpenQuery(%s): FDataSet=nil',[aQuery]); exit; end;

  //Один из драйверов DataSet должен открыть:
  if Assigned(FAdoDataSet) then Result:=ado_open(FAdoDataSet, aQuery, FReadOnly);

  if not Result then Tell('ERROR: OpenQuery(%s)',[aQuery]);
  if not Result then exit;//Далее Result=true (FDstsSet.Active):

  FQuery:=aQuery;

  //обязательные поля:
  try
    FIDField:=FDataSet.FieldByName(FIDFieldName);
    FNameField:=FDataSet.FieldByName(FNameFieldName);
  except
    Tell('OpenQuery(%s)\nПоле "%s" или "%s" не существует',[aQuery, FIDFieldName, FNameFieldName]);
  end;
(*
  //проверки (DEBUG):
  try
    GetID;
    GetName;
  except
    Tell('OpenQuery(%s)\DEBUG MSG: nОшибка GetID или GetName',[aQuery]);
  end;
*)
  //разное:
  ado_set_float_format(FDataSet, mytab_float_format);
end;

function TMyTab.OpenQuery: boolean;
begin
  Result:=OpenQuery(FQuery);
end;

function TMyTab.OpenWhere(aWhere: string): boolean;
var qry: string;
begin
  qry:=sql_select1('*', FTabName, aWhere, FNameFieldName);
  Result:=OpenQuery(qry);
end;

function TMyTab.Open: boolean;
begin
  Result:=OpenWhere('');
end;

procedure TMyTab.Close;
begin
 ado_close(FDataSet, FReadOnly);
end;

procedure TMyTab.DeleteRecord;
begin
  if FReadOnly then exit;//!
  ado_del_msg(FDataSet);
end;


function TMyTab.GetTabCaption: string;
begin
  Result:=FTabCaption;
  if Length(Result)=0 then Result:=FTabName;
end;

function TMyTab.GetID: integer;
begin
  Result:=0;
  try
    if FDataSet.Active then Result:=FIDField.AsInteger;//default ID=0
  except
    Tell('EXCEPTION in GetID');
    Result:=0;
  end;
end;

function TMyTab.GetName: string;
begin
  Result:='';
  try
    if FDataSet.Active then Result:=FNameField.AsString;
  except
    Tell('EXCEPTION in GetName');
    Result:='';
  end;
end;

function TMyTab.GetInfo: string;
begin
  Result := Format('%d: %s',[GetID, GetName]);
end;

procedure TMyTab.Tell(Fmt: string; const Args: array of const);
begin
  Fmt := Format('Таблица "%s":\n%s',[FTabName, Fmt]);
  wcmn.Tellf(Fmt, Args);
end;

procedure TMyTab.Tell(msg: string);
begin
  Tell(msg, []);
end;


function TMyTab.FindID(aID: integer): boolean;
begin
  if aID>0 then Result:=ado_find_int(FDataSet, FIDFieldName, aID)
  else Result:=false;
end;


{ TMyTab: DataSet-Events: }

procedure TMyTab.OnPostError(aDataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
begin
  Action:=daAbort;
  //if TellYN('Запись ошибочна. Удалить?') then aDataSet.Delete;//если не заполнены обязат.поля
end;


{ TMyTab2: }

procedure TMyTab2.OnCreate;
begin
  inherited OnCreate;

  //DataSet Events:
  FDataSet.AfterScroll:=DataSet_AfterScroll;
  FDataSet.OnNewRecord:=DataSet_OnNewRecord;
end;

procedure TMyTab2.AddUpTbl(aUpTbl: TMyTab2; aFieldName: string);
begin
  aUpTbl.FDnTbl:=Self;

  FRefs[FRefsCount].UpTbl:=aUpTbl;
  FRefs[FRefsCount].FieldName:=aFieldName;
  inc(FRefsCount);
end;

function TMyTab2.Open: boolean;
var i,idup: integer; aWhere: string; FOnScrollLock0: boolean; uptbl: TMyTab2;
begin
  Result:=false;
  Close;//вместе с нижними!

  aWhere:='';
  if FRefsCount>0 then for i:=0 to FRefsCount-1 do begin
    uptbl:=FRefs[i].UpTbl;
    idup := uptbl.GetID;

    //попытка получить верхний ID (предполагается TMyTab2.Open при активации внешней TDBGreed):
    if (idup<=0) and not FReadOnly then begin
      ado_post(uptbl.DataSet);
      idup := uptbl.GetID;
      if (idup>0) and Assigned(FAfterScrollEvent) then FAfterScrollEvent(Self);//!
    end;

    if idup<=0 then exit;//! (Close - вверху)
    if i>0 then aWhere := aWhere + ' and ';
    aWhere := Format('%s([%s]=%d)',[aWhere, FRefs[i].FieldName, idup]);
  end;//for i

  //если будем открывать (Self и все нижние уже закрыты):
  FOnScrollLock0:=FOnScrollLock;//save
  FOnScrollLock:=true;
  try
    Result := inherited OpenWhere(aWhere);
//    if Result{!} and Assigned(FDnTbl) then FDnTbl.Open;//нижние: далее - рекурсивно!
  finally
    FOnScrollLock:=FOnScrollLock0;//restore
  end;

  if Result{!} then DataSet_AfterScroll(FDataSet);//FAfterScrollEvent, открытие нижних
end;

procedure TMyTab2.Close;//вместе с нижними
begin
  inherited Close;
  if Assigned(FAfterScrollEvent) then FAfterScrollEvent(Self);//!
  if Assigned(FDnTbl) then FDnTbl.Close;//далее - рекурсивно!
end;

procedure TMyTab2.DeleteRecord;//если нижних нет
var aDnDataSet: TDataSet;
begin
  if FReadOnly then exit;//!
  if Assigned(FDnTbl) then begin
    aDnDataSet:=FDnTbl.FDataSet;
    if aDnDataSet.Active and (aDnDataSet.RecordCount>0) then begin
      Tell('Сначала удалите записи в связанных таблицах');
      exit;//!
    end;
  end;
  inherited DeleteRecord;//with confirm
end;

{ TMyTab2: DataSet-Events: }

procedure TMyTab2.DataSet_AfterScroll(aDataSet: TDataSet);
begin
  if FOnScrollLock then exit;
  if Assigned(FAfterScrollEvent) then FAfterScrollEvent(Self);//!
  if Assigned(FDnTbl) then FDnTbl.Open;//Close при idup<=0
end;

procedure TMyTab2.DataSet_OnNewRecord(aDataSet: TDataSet);
var i,idup: integer;
begin
  //set referenced fields to upper's ID:
  if FReadOnly then exit;//!
  if FRefsCount>0 then for i:=0 to FRefsCount-1 do begin
    idup := FRefs[i].UpTbl.GetID;
    if idup>0 then ado_put_int(FDataSet, FRefs[i].FieldName, idup);
  end;//for i
end;


end.
