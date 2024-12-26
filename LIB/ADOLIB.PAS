unit adolib; interface

uses Classes, DB, AdoDb;


//Соединение (=> ado_servername, ado_dbname):
//mdb-файл:
function ado_Connect0(aConnection: TADOConnection; aDBName, connnectstr0: string): boolean;
function ado_Connect(aConnection: TADOConnection; aDBName: string; _msg: boolean = false): boolean;//ConnectString уже задана!
//SQL-сервер:
function adosql_Connect0(aConnection: TADOConnection; aServername, aDBName, connnectstr0: string): boolean;
function adosql_Connect(aConnection: TADOConnection; aServername, aDBName: string): boolean;//ConnectString уже задана!

procedure ado_Disconnect(aConnection: TADOConnection);

//после соединения:

//Команды:
function ado_execute(xcmd: tADOCommand; scmd: string): boolean;
procedure ado_clear_table(xcmd: tADOCommand; tname: string);

//Таблица:
function  ado_open(xtab: TADOTable; aTabName: string; readonly: boolean; _msg: boolean): boolean; overload;//все записи

function  ado_open(xtab: TADODataSet; qry: string; readonly: boolean): boolean; overload;
function  ado_open_msg(xtab: tAdoDataSet; qry: string; readonly: boolean): boolean;
function  ado_open_write_msg(xtab: tAdoDataSet; aTabName: string): boolean;

procedure ado_close(xtab: tDataSet; readonly: boolean);//сохраняет изменения

procedure ado_post(xtab: tDataSet);
procedure ado_del_msg(xtab: tDataSet);//с вопросом
procedure ado_next_position(xtab: tDataSet);//new position for Delete

function ado_count(xtab: tDataSet): integer;//xtab открыта
function ado_query_count(xtab: tAdoDataSet; qry: string): integer;//ADO-xtab закрыта!
function ado_query_count2(aConnection: TADOConnection; qry: string): integer;

function ado_find_str(xtab: tDataSet; fname: string; s: string; _fullstr: boolean): boolean;
function ado_find_int(xtab: tDataSet; fname: string; value: integer): boolean;
function ado_find_real(xtab: tDataSet; fname: string; value: double): boolean;

function ado_get_int(xtab: tDataSet; fname: string): integer;//default=0
function ado_get_id(xtab: tDataSet): integer;//поле "ID"
function ado_get_str(xtab: tDataSet; fname: string): string;//default=''
function ado_get_name(xtab: tDataSet): string;//поле "NAME"
function ado_get_float(xtab: tDataSet; fname: string): double;//default=0
function ado_get_sfloat(xtab: tDataSet; fname,aFormat: string; _printzero: boolean): string;//default='0.00'||''
procedure ado_put_int(xtab: tDataSet; fname: string; value: integer);
procedure ado_put_str(xtab: tDataSet; fname: string; value: string);

procedure ado_field_to_strings(aConnection: TADOConnection; tname, fname: string; slist: TStrings);

//Разное:

procedure ado_set_float_format(xtab: TDataSet; aFormat: string);//пример: '#.00'


const
  ado_servername: string = '';//если SQL-сервер
  ado_dbname: string = '';//текущая БД (полное имя файла .mdb или БД SQL-сервера)
  ado_TabOpening: boolean = false;

const
  adolib_ConnectedStringMdbEmpty=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=;Persist Security Info=False';


implementation

uses
  SysUtils, Forms,
  wcmn, sqllib;

//------------------------------------------------------------------------

function ado_Connect0(aConnection: TADOConnection; aDBName, connnectstr0: string): boolean;
var s: string; csl: tstringlist;//ConnectionStringList
begin
  Result:=false;
  aConnection.Connected:=false;
  ado_servername:='';
  ado_dbname:='';

  if not FileExists(aDBName) then exit;

  csl:=tstringlist.Create;
  try
    //set DBName in aConnection.ConnectionString:
    if Length(connnectstr0)>0 then aConnection.ConnectionString:=connnectstr0;//!!!
    string2stringlist(aConnection.ConnectionString, csl);

    csl.Values['Data Source']:=aDBName;

    stringlist2string(csl, s);
    aConnection.ConnectionString:=s;

    //соединение:
    aConnection.Connected:=true;
    Result:=aConnection.Connected;
    if Result then ado_dbname:=aDBName;
  finally
    csl.Free;
  end;
end;

function ado_Connect(aConnection: TADOConnection; aDBName: string; _msg: boolean): boolean;//ConnectString уже задана!
begin
  Result:=ado_Connect0(aConnection, aDBName, aConnection.ConnectionString);
  if not Result and _msg then Tellf('Ошибка соединения с БД "%s"',[aDBName]);
end;

//Соединение с SQL-сервером:
(*
  XP:
        Provider=SQLOLEDB.1;
     !          Integrated Security=SSPI;
        Persist Security Info=False;
не обяз.             User ID=sa;
     *   Initial Catalog=IMSQL;
     *   Data Source=homesoft
  W98:
        Provider=SQLOLEDB.1;
        Persist Security Info=False;
                User ID=sa;
     *   Initial Catalog=IMSQL;
     *   Data Source=popa
*)
function adosql_Connect0(aConnection: TADOConnection; aServername, aDBName, connnectstr0: string): boolean;
var s: string; csl: tstringlist;//ConnectionStringList
begin
  aConnection.Connected:=false;
  ado_servername:='';
  ado_dbname:='';

  csl:=tstringlist.Create;
  SetWaitCursor;
  try
  try
    if Length(connnectstr0)>0 then aConnection.ConnectionString:=connnectstr0;//!!!
    string2stringlist(aConnection.ConnectionString, csl);

    csl.Values['Data Source']:=aServername;
    csl.Values['Initial Catalog']:=aDBName;

    stringlist2string(csl, s);
    aConnection.ConnectionString:=s;

    //соединение:
    aConnection.Connected:=true;
    Result:=aConnection.Connected;
    if Result then begin
      ado_servername:=aServername;
      ado_dbname:=aDBName;
    end;
  finally
    SetDefCursor;
    csl.Free;
  end;
  except
    Result:=false;
  end;
end;

function adosql_Connect(aConnection: TADOConnection; aServername, aDBName: string): boolean;//ConnectString уже задана!
begin
  Result:=adosql_Connect0(aConnection, aServername,aDBName, aConnection.ConnectionString);
end;


procedure ado_Disconnect(aConnection: TADOConnection);
begin
  ado_dbname:='';//!
  aConnection.Connected:=false;
end;


//------------------------------------------------------------------------

function ado_execute(xcmd: tADOCommand; scmd: string): boolean;
begin
  try
    xcmd.CommandText:=scmd;
    xcmd.Execute;
    Result:=true;
  except
    Tellf('ERROR in ado_execute <%s>',[scmd]);
    Result:=false;
  end;
end;

procedure ado_clear_table(xcmd: tADOCommand; tname: string);
var scmd: string;
begin
  scmd:=Format('delete from [%s] ;',[tname]);
  ado_execute(xcmd, scmd);
end;

//---------------------------------------------------------

function  ado_open(xtab: TADOTable; aTabName: string; readonly: boolean; _msg: boolean): boolean; overload;//все записи
begin
  Application.ProcessMessages;//!
  Result:=false;
  if not xtab.Connection.Connected then EXIT;//!

  if xtab.Active then ado_close(xtab, readonly);
  Application.ProcessMessages;//!

  ado_TabOpening:=true;
  try
    xtab.TableName:=aTabName;
    try xtab.Open; except end;
    if xtab.Active and not readonly then xtab.Edit;
  finally
    ado_TabOpening:=false;
    Result:=xtab.Active;
  end;
  Application.ProcessMessages;//!
  if _msg and not Result
  then Tellf('Ошибка открытия таблицы "%s"',[aTabName]);
end;

function ado_open(xtab: TADODataSet; qry: string; readonly: boolean): boolean;
begin
  Application.ProcessMessages;//!
  Result:=false;
  if not xtab.Connection.Connected then EXIT;//!

  if xtab.Active then ado_close(xtab, readonly);
  Application.ProcessMessages;//!

  ado_TabOpening:=true;
  try
    xtab.CommandText:=qry;
    try xtab.Open; except end;
    if xtab.Active and not readonly then xtab.Edit;
  finally
    ado_TabOpening:=false;
    Result:=xtab.Active;
  end;
  Application.ProcessMessages;//!
end;

function ado_open_msg(xtab: tAdoDataSet; qry: string; readonly: boolean): boolean;
begin
  Result:=ado_open(xtab, qry, readonly);
  if not Result then Tellf('Ошибка открытия таблицы. Запрос:\n%s',[qry]);
end;

function ado_open_write_msg(xtab: tAdoDataSet; aTabName: string): boolean;
var qry: string;
begin
  qry := Format('select * from [%s] ;', [aTabName]);
  Result:=ado_open_msg(xtab, qry, false{readonly});
end;


procedure ado_close(xtab: tDataSet; readonly: boolean);
begin
  if not xtab.Active then exit;
  if not readonly then ado_post(xtab);//сохранение текущей строки
  try
    xtab.Close;
  except
  end;
end;

procedure ado_post(xtab: tDataSet);
begin
  //if xtab.Active and (xtab.RecordCount>0) then try//=> текущая строка есть
  if xtab.Active and xtab.Modified then try
    xtab.Edit;
    xtab.Post;//!
  except
  end;
end;

procedure ado_del_msg(xtab: tDataSet);
begin
  if xtab.Active and TellYN('Удалить запись?') then try
    xtab.Delete;
  except
  end;
end;

function ado_count(xtab: tDataSet): integer;
begin
  if xtab.Active then Result:=xtab.RecordCount else Result:=0;
end;

function ado_query_count(xtab: tAdoDataSet; qry: string): integer;//xtab закрыта!
begin
  Result:=0;
  with xtab do begin
    CommandText:=qry;
    Open;
    if Active then try Result:=RecordCount;
    finally Close;
    end;
  end;//with
end;

function ado_query_count2(aConnection: TADOConnection; qry: string): integer;
var xtab: tAdoDataSet;
begin
  xtab:=tAdoDataSet.Create(nil);
  try
  try
    xtab.Connection:=aConnection;
    Result:=ado_query_count(xtab, qry);
  finally
    xtab.Free;
  end;
  except
    Result:=0;
  end;
end;

procedure ado_next_position(xtab: tDataSet);//new position for Delete
begin
  with xtab do begin Next; if Eof then Prior; end;
end;

function ado_find_str(xtab: tDataSet; fname: string; s: string; _fullstr: boolean): boolean;
var svar: Variant;
begin
  Result:=false;
  if not xtab.Active then exit;
  svar:=s;
  if _fullstr then Result:=xtab.Locate(fname, svar, [])
  else Result:=xtab.Locate(fname, svar, [loPartialKey]);
end;

function ado_find_int(xtab: tDataSet; fname: string; value: integer): boolean;
var ivar: Variant;
begin
  Result:=false;
  if not xtab.Active then exit;
  ivar:=value;
  Result:=xtab.Locate(fname, ivar, []);
end;

function ado_find_real(xtab: tDataSet; fname: string; value: double): boolean;
var rvar: Variant;
begin
  Result:=false;
  if not xtab.Active then exit;
  rvar:=value;
  Result:=xtab.Locate(fname, rvar, []);
end;


//-------------------------------------------------------------

function ado_get_int(xtab: tDataSet; fname: string): integer;
var f: tfield;
begin
  Result:=0;
  if not xtab.Active then exit;
  f:=xtab.FieldByName(fname);
  if Assigned(f) then Result:=f.AsInteger;
end;

function ado_get_str(xtab: tDataSet; fname: string): string;
var f: tfield;
begin
  Result:='';
  if not xtab.Active then exit;
  f:=xtab.FieldByName(fname);
  if Assigned(f) then Result:=f.AsString;
end;

function ado_get_id(xtab: tDataSet): integer;//поле "ID"
begin
  Result:=ado_get_int(xtab, 'ID');
end;

function ado_get_name(xtab: tDataSet): string;//поле "NAME"
begin
  Result:=ado_get_str(xtab, 'NAME');
end;

function ado_get_float(xtab: tDataSet; fname: string): double;//default=0
var f: tfield;
begin
  Result:=0;
  if not xtab.Active then exit;
  f:=xtab.FieldByName(fname);
  if Assigned(f) then Result:=f.AsFloat;
end;

function ado_get_sfloat(xtab: tDataSet; fname,aFormat: string; _printzero: boolean): string;//default='0.00'||''
var d: double;
begin
  d:=ado_get_float(xtab, fname);
  Result:=Format(aFormat,[d]);
  if (d=0) and not _printzero then Result:='';
end;

procedure ado_put_int(xtab: tDataSet; fname: string; value: integer);
var f: tfield;
begin
  if not xtab.Active then exit;
  f:=xtab.FieldByName(fname);
  if Assigned(f) then f.AsInteger:=value;
end;

procedure ado_put_str(xtab: tDataSet; fname: string; value: string);
var f: tfield;
begin
  if not xtab.Active then exit;
  f:=xtab.FieldByName(fname);
  if Assigned(f) then f.AsString:=value;
end;

procedure ado_field_to_strings(aConnection: TADOConnection; tname, fname: string; slist: TStrings);
var xtab: tAdoDataSet; qry: string; i,n: integer; f: tfield;
begin
  slist.Clear;
  if not aConnection.Connected then exit;

  xtab:=tAdoDataSet.Create(nil);
  try
    xtab.Connection:=aConnection;
    qry:=sql_select1(fname, tname, '', fname);
    if ado_open(xtab, qry, true) then begin
      f:=xtab.FieldByName(fname);
      n:=xtab.RecordCount;
      if Assigned(f) and (n>0) then for i:=0 to n-1 do begin
        slist.Add(f.AsString);
        xtab.Next;
      end;
    end;//if ado_open
  finally
    xtab.Free;
  end;
end;


//---------------------------------------------------------

procedure ado_set_float_format(xtab: TDataSet; aFormat: string);//пример: '#.00'
var i,n: integer;
begin
  if not xtab.Active then exit;
  n:=xtab.Fields.Count;
  if n>0 then for i:=0 to n-1 do
    if xtab.Fields[i] is TFloatField then (xtab.Fields[i] as TFloatField).DisplayFormat:=aFormat;
end;

(*
//CustTable_ForAll (перечисление элементов таблицы):
CustTable.DisableControls;
try
  CustTable.First; { Go to first record, which sets EOF False }
  while not CustTable.EOF do { Cycle until EOF is True }
  begin
    { Process each record here }
    ...
    CustTable.Next; { EOF False on success; EOF True when Next fails on last record }
  end;
finally
  CustTable.EnableControls;
end;
*)

end.
