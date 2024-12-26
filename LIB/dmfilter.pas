unit dmfilter; interface

uses arrayx, otypes, list;


(*
poly_region_type:
    0  -  вся карта (poly не исрользуется)
    1  -  прямоугольник, [ poly(0), poly(1) ]
    2  -  круг, poly(0)-центр, poly(1).x-радиус
    3  -  указание полигона "poly"
    4  -  указание объекта, poly-метрика объекта (не обрабатывается)
*)
type
  TDmFilter = class
  private
    FID: integer; //filter index -> file names
    {FMapName: string;}
    dbf_file_name: string;
    txt_file_name: string;
    FObjects: TIntArray;
    poly: plline; //region
    poly_size: integer;

    function GetObjOffs(i: integer): integer;
    function GetCount: integer;
  public
    Status: integer;
    constructor Create(aID: integer); //=>Index in DmFilterList
    destructor Destroy; override;

    procedure ClearRegion;
    function AssignRegion: boolean;

    function SetupDialog: boolean;
    function GetObjects: integer;

    function GoToNode(aInd: integer): boolean;//Msg; dmcmn_begin required

    property Objects: TIntArray read FObjects;
    property Count: integer read GetCount;
    property ObjOffs[Index: integer]: integer read GetObjOffs; default;
    {property MapName: string read FMapName;}
  end;

var
  RegionFilter: TDmFilter;//первый фильтр
  Region_type: byte;

  DmFilterList: TClassList;


implementation

uses
  Windows, Dialogs, Forms, sysUtils,
  wcmn, dmw_use, dmcmn;

{ private: }

function TDmFilter.GetObjOffs(i: integer): integer;
begin
  Result:=FObjects[i];
end;

function TDmFilter.GetCount: integer;
begin
  Result:=FObjects.Count;
end;


{ public: }

constructor TDmFilter.Create(aID: integer);
var dbfdir: string;
begin
  Status:=1;
  FID:=aID;
  if DmFilterList[aID]<>nil then Tellf('ОШИБКА: второй фильтр с индексом %d',[aID]);

  try
    {
    FMapName:=dmcmn_active_map(true);
    if Length(FMapName)=0 then exit; //???
    }

    dbfdir:=UpperDir(ExeDir)+'FILTER\';
    if not DirExists(dbfdir) then dbfdir:=TmpDir;
    dbf_file_name := dbfdir + wcmn_file_name(Application.ExeName) + IntToStr(FID) + '.dbf';
    txt_file_name := TmpDir + wcmn_file_name(Application.ExeName) + IntToStr(FID) + '.txt';

    FObjects:=TIntArray.Create(512);

    poly_size:=dmcmn_PolyMemSize(MaxPolyCount);
    PChar(poly):=malloc(poly_size);
  except
    Tellf('Ошибка создания фильтра Index:=%d',[FID]);
  end;{try}

  DmFilterList[FID]:=Self;
  Status:=0;
end;

destructor TDmFilter.Destroy;
begin
  mfree(poly, poly_size);
  FObjects.Free;
end;

procedure TDmFilter.ClearRegion;
begin
  RegionFilter:=nil;
end;

function TDmFilter.AssignRegion: boolean;
var f: TDmFilter;
begin
  Result:=false;

  if RegionFilter=nil then exit;
  f:=RegionFilter;

  try
    mfree(poly, poly_size);

    poly_size:=f.poly_size;
    PChar(poly):=malloc(poly_size);
    memcpy(PChar(poly), PChar(f.poly), poly_size);
  except ;
  end;{try}

  Result:=true;
end;

function TDmFilter.SetupDialog: boolean;
type
  Tdm_Filter_dial = procedure(dbf_file_name: pchar); stdcall;
var
  dm_Filter_dial: Tdm_Filter_dial;
  HDLL: THandle;
  P: FarProc;
  sdbf: string;
begin
  Result:=false;
  if Status<>0 then exit;
  Status:=2;

  HDLL:=wcmn_dll_open('Filter');
  if HDLL=0 then exit;

  try
    P:=wcmn_dll_getproc(HDLL, 'dm_Filter_Dial');
    if P=nil then exit;
    @dm_Filter_dial:=P;
    sdbf := dbf_file_name + #0;

    try
      dm_Filter_Dial( @sdbf[1] );
    except
      Tell('ERROR in call dm_Filter_Dial; Версия?');
      exit;
    end;

  finally
    wcmn_dll_close(HDLL);
  end;

  Status:=0;
  Result:=true;
end;

function TDmFilter.GetObjects: integer;
label
  Finish;
var
  sdbf, stxt: string;
  x_region_type: byte;
  dm_Filter_return: pchar;
  f: TextFile;
  s: string;
  n: integer;
begin
  Result := 0;
  FObjects.Clear;
  if Status<>0 then exit;
  Status:=3;

  if not FileExists(dbf_file_name) then begin
    Tellf('Нет файла фильтра "%s"',[dbf_file_name]);
    goto Finish;
  end;
  sdbf := dbf_file_name + #0;
  stxt := txt_file_name + #0;

  x_region_type := dm_Filter_region( @sdbf[1] );
  {Tellf('Region %d',[region_type]);}

  if (RegionFilter<>nil) and (Region_type=x_region_type) then begin
    AssignRegion;
  end else begin
    // alexs
    //if not dmcmn_show_region(x_region_type, poly, true) then


    goto Finish;
    RegionFilter:=Self;
    Region_type:=x_region_type;
  end;

  if not dmcmn_begin then exit;
  try
    dm_Filter_return := dm_Filter( @sdbf[1], @stxt[1], poly, region_type);
  finally
    dmcmn_end;
  end;
  if dm_Filter_return=nil then goto Finish; //нет объектов

  if not ftopen_msg(f, txt_file_name, 'r') then exit;
  try
    while not eof(f) do begin
      readln(f, s);
      if Length(s)=0 then continue;
      n:=sread_int(s);
      if FObjects.Status<>0 then begin Tellf('ERROR: FObjects.Status=%d',[FObjects.Status]); break; end;
      if n>0 then FObjects.Add(n)
      else begin Tellf('ERROR: адрес %d\nв файле "%s"',[n, txt_file_name]); break; end;
    end;
  finally
    ftclose(f);
    {DeleteFile(txt_file_name);}
  end;

Finish:
  Status:=0;
  Result := FObjects.Count;
end;

function TDmFilter.GoToNode(aInd: integer): boolean;
begin
  if dm_goto_node( ObjOffs[aInd] ) then Result:=true else Result:=false;
  if not Result then Tellf('Фильтр %d: ошибка адреса %d',[FID, ObjOffs[aInd]]);
end;


initialization
  DmFilterList:=TClassList.Create(1);
  RegionFilter:=nil;

finalization
  DmFilterList.Free;


end.
