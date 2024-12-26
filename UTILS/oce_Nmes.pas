unit Oce_nmes; interface

uses
  windows,SysUtils,dialogs,OTypes,Classes;

type
  tnmes_qu = record
    typ,alt,act, d1,d2: Integer;
    rgn, b1,l1, b2,l2: Integer;
    dm: TShortStr;
  end;

  tnmes_id = record
    typ,nn,yy,po: Integer
  end;

  CString = record
   len: Integer; db2: PChar;
  end;
  pCstring=^Cstring;
{function nmes_db_Exist: Boolean;
function nmes_db_Assigned(db,sl: PChar): Boolean;


function Get_nmes_db: PChar;
function Get_nmes_sl: PChar;
}
{function OCEAN_INITNMES_DB3(len: Integer; db2: PChar): Integer; stdcall;
procedure OCEAN_DEINITNMES_DB3(len: Integer; db2: PChar); stdcall;
Function OCEAN_GETNTMFROM_DB3(lenNumb_year: Integer; plenNumb_year: PChar;rgn,IM_Type,
Act_type: Byte;Frst_date,Last_date:longint; rc_len: Integer; rc_s: PChar):longint; stdcall;
function OCEAN_ITEMNTMFROM_DB3(IM_Type:Byte; IM_numb:Longint;Year:smallint;Punkt_number:Longint;
                                   len_res:integer;Pres:Pchar;
                                   len_Punkt_Osnov:integer;P_Punkt_Osnov:Pchar;
                                   len_Vkleika:integer;P_Vkleika:Pchar):longint; stdcall;
}
function MY_INITNMES_DB3(len: Integer; db2: PChar): Integer; stdcall;
procedure MY_DEINITNMES_DB3(len: Integer; db2: PChar); stdcall;
Function MY_GETNTMFROM_DB3(lenNumb_year: Integer; plenNumb_year: PChar;rgn,IM_Type,
Act_type: Byte;Frst_date,Last_date:longint; rc_len: Integer; rc_s: PChar):longint; stdcall;
function MY_ITEMNTMFROM_DB3(IM_Type:Byte; IM_numb:Longint;Year:smallint;Punkt_number:Longint;
                                   len_res:integer;Pres:Pchar;
                                   len_Punkt_Osnov:integer;P_Punkt_Osnov:Pchar;
                                   len_Vkleika:integer;P_Vkleika:Pchar;Reserv:byte):longint; stdcall;




implementation

uses
  Math;
 { OFiles,Convert,//XPoly,
  OTexts;}//OGauss;

const
  nmes_dll = 'nmes_ocn.dll';
  fl_opened:boolean=false;
  Type
 TOCEAN_INITNMES_DB3=function(len: Integer; db2: PChar): Integer; stdcall;
 TOCEAN_DEINITNMES_DB3=procedure(len: Integer; db2: PChar); stdcall;
 TOCEAN_GETNTMFROM_DB3=Function(lenNumb_year: Integer; plenNumb_year: PChar;rgn,IM_Type,
Act_type: Byte;Frst_date,Last_date:longint; rc_len: Integer; rc_s: PChar):longint; stdcall;
TOCEAN_ITEMNTMFROM_DB3=function(IM_Type:Byte; IM_numb:Longint;Year:word;Punkt_number:Longint;
                                   len_res:integer;Pres:Pchar;
                                   len_Punkt_Osnov:integer;P_Punkt_Osnov:Pchar;
                                   len_Vkleika:integer;P_Vkleika:Pchar;Reserv:byte):longint; stdcall;

 var
  fOCEAN_INITNMES_DB3:TOCEAN_INITNMES_DB3;
  fOCEAN_DEINITNMES_DB3:TOCEAN_DEINITNMES_DB3;
  fOCEAN_GETNTMFROM_DB3:TOCEAN_GETNTMFROM_DB3;
  fOCEAN_ITEMNTMFROM_DB3:TOCEAN_ITEMNTMFROM_DB3;
  Libhandle:Thandle;

function MY_INITNMES_DB3(len: Integer; db2: PChar): Integer; stdcall;

var
  s:string;
begin
  Result:=0;

  if fl_opened then begin
    Result:=1;
    exit
  end;
    Libhandle:=LoadLibrary(nmes_dll);
  if LibHandle<32 then
    ShowMessage('Ошибка при загрузке DLL '+ nmes_dll)
  else
    begin
      @fOCEAN_INITNMES_DB3:=GetProcaddress(Libhandle,'OCEAN_INITNMES_DB3');

      RESULT:=fOCEAN_INITNMES_DB3(len,db2);
      fl_opened:=true;
    end;
end;
procedure MY_DEINITNMES_DB3(len: Integer; db2: PChar); stdcall;
begin
      if fl_opened then begin
      @fOCEAN_DEINITNMES_DB3:=GetProcaddress(Libhandle,'OCEAN_DEINITNMES_DB3');
      fOCEAN_DEINITNMES_DB3(len,db2);
      FreeLibrary(libHandle);
      fl_opened:=false;
      end;
end;

Function MY_GETNTMFROM_DB3(lenNumb_year: Integer; plenNumb_year: PChar;rgn,IM_Type,
Act_type: Byte;Frst_date,Last_date:longint; rc_len: Integer; rc_s: PChar):longint; stdcall;
begin
     @fOCEAN_GETNTMFROM_DB3:=GetProcaddress(Libhandle,'OCEAN_GETNTMFROM_DB3');
     result:=fOCEAN_GETNTMFROM_DB3(lenNumb_year,plenNumb_year,rgn,IM_Type,
Act_type,Frst_date,Last_date,rc_len,rc_s);
end;
function MY_ITEMNTMFROM_DB3(IM_Type:Byte; IM_numb:Longint;Year:smallint;Punkt_number:Longint;
                                   len_res:integer;Pres:Pchar;
                                   len_Punkt_Osnov:integer;P_Punkt_Osnov:Pchar;
                                   len_Vkleika:integer;P_Vkleika:Pchar;Reserv:byte):longint; stdcall;
begin
     @fOCEAN_ITEMNTMFROM_DB3:=GetProcaddress(Libhandle,'OCEAN_ITEMNTMFROM_DB3');
     result:=fOCEAN_ITEMNTMFROM_DB3(IM_Type,IM_numb,Year,Punkt_number,len_res,Pres,
                                    len_Punkt_Osnov,P_Punkt_Osnov,
                                   len_Vkleika,P_Vkleika,Reserv);
end;
{
function OCEAN_INITNMES_DB3(len: Integer; db2: PChar): Integer; stdcall;
external nmes_dll;

procedure OCEAN_DEINITNMES_DB3(len: Integer; db2: PChar); stdcall;
external nmes_dll;

Function OCEAN_GETNTMFROM_DB3(lenNumb_year: Integer; plenNumb_year: PChar;rgn,IM_Type,
Act_type: Byte;Frst_date,Last_date:longint; rc_len: Integer; rc_s: PChar):longint; stdcall;

external nmes_dll;
(*Cstring,Byte,Byte,Byte,Long,Long,*Cstring),

1 параметр *Cstring: номер книги с годом печати (1200-2000).
	2 параметр Byte: фильтр по типу: 1 - Все ИМ, 2 - постоянные, 3 - Временные , 4 - Предварительные, 5 - Временные  + Предварительные.
	3  параметр Byte тип ИМ: 1 - ИМ ГУНИО, 2 - Приложение, 3 - Все.
4  параметр Byte характер действия 1 - Действующие, 0 - отмененные, 2 - объявленные.
5 параметр Long дата с запроса с и 6 параметр дата запроса по.
Если даты = 0 то запрос выполняется по всей базе.
Стандартная дата - в формате ггггммдд (20000109 -  9 января 2000 года).
7 параметр *Cstring  результат отбора в формате
ResultNM = 1,234,2001,1,,1,В,20001230,19980101;2,234,2001,1,10010.2-A,2,0,19991230
1 (2) - тип ИМ 1 - ИМ ГУНИО МО, 2 - Приложение, далее номер ИМ, год ИМ, пункт ИМ,
Номер огня РТСНО для типа пункта пункта 2 и 3 для лоции пусто;
тип пункта ИМ: 1- лоция; 2 - СНО; 3 - РТСНО;
Характер ИМ - В - временное, П -предварительное, пусто постоянное ИМ,
далее дата отмены если пункт был отменен в формате стандартной даты и дата опубликования этого ИМ,
далее разделитель записи ";".
Функция возвращает TRUE (1) если отбор  выполнен успешно и False (0) если нет.
*)
function OCEAN_ITEMNTMFROM_DB3(IM_Type:Byte; IM_numb:Longint;Year:smallint;Punkt_number:Longint;
                                   len_res:integer;Pres:Pchar;
                                   len_Punkt_Osnov:integer;P_Punkt_Osnov:Pchar;
                                   len_Vkleika:integer;P_Vkleika:Pchar):longint; stdcall;
external nmes_dll;

{функция чтения заданного пункта ИМ из базы данных корректуры книг.
1 параметр Byte:  1 -ИМ ГУНИО, 2 -Приложение.
2 параметр Long: Номер ИМ.
3 параметр  Short год ИМ (гггг).
4 параметр Long: номер пункта ИМ.
5 параметр *Cstring: результат - текст ИМ в виде строки.
6 параметр *Cstring: результат - основание пункта ИМ.
7 параметр *Cstring: результат - путь к извлеченной вклейке ИМ если таковая есть в базе данных.
Вклейки в формате pdf помещаются в каталог переменной PATH_OUT описанной в секции ini файла.
Если несколько вклеек то пути перечисляются через разделитель";" (D:\OCEAN\OUT\1_2000_123_1_1;
D:\OCEAN\OUT\1_2000_123_1_2).
Имя положенной вклейки кодируется следующим образом: 0_2000_123_1_1.pdf - разделители "_" 1 - тип ИМ (ГУНИО или Приложение) далее год (гггг), номер ИМ (123), номер пункта ИМ (1), порядковый номер вклейки если их несколько в одном пункте.
7 параметр Byte (0 если надо прочитать пункт для корректуры лоции в виде сводной книги c элементами технического редактирования, 1 обычная форма для чтения любого пункта ИМ)
Функция возвращает TRUE (1) если такой пункт ИМ найден в базе данных и False (0) если не найден.
}
{
var
  nmes_db_Active: Boolean;

  nmes_ini: TShortStr;
  sdb_db: TShortStr;
  sdb_sl: TShortStr;

  sdx_db: TShortStr;

procedure Assign_sdx_db(db: PChar);
begin
  StrCopy(sdx_db,'');
  if FileExist(db) then
  StrCopy(sdx_db,db);
end;

function This_sdx_db(db: PChar): Boolean;
begin
  Result:=false;
  if FileExist(sdx_db) then
  Result:=xStrThis(db,sdx_db)
end;

procedure sdx_db_restore(db: PChar);
begin
  if FileExist(db) then begin
    FileErase(sdx_db);
    xRenameFile(db,sdx_db)
  end
end;

function db_Exist(db,sl: PChar): Boolean;
begin
  Result:=Dir_Exists(db) and Dir_Exists(sl)
end;

function nmes_db_Exist: Boolean;
begin
  Result:=db_Exist(sdb_db,sdb_sl)
end;

function Get_nmes_db: PChar;
begin
  Result:=nil;
  if nmes_db_Exist then
  Result:=sdb_db
end;

function Get_nmes_sl: PChar;
begin
  Result:=nil;
  if nmes_db_Exist then
  Result:=sdb_sl
end;

function nmes_db_Assigned(db,sl: PChar): Boolean;
var
  txt: TTextFile;
begin
  Result:=false;

  txt:=TTextFile.Create;
  try
    if db_Exist(db,sl) then
    if txt.Make(nmes_ini) then begin
      txt.WriteStr('[Path_NMES]');

      txt.WriteKey('PATH_DB_2',db);
      txt.WriteKey('PATH_SL_2',sl);

      StrCopy(sdb_db,db);
      StrCopy(sdb_sl,sl);

      Result:=true
    end;
  finally
    txt.Free
  end
end;
}
initialization

 // nmes_db_Active:=false;




end.
