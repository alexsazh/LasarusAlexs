unit use_idb; interface

uses
  OTypes,//XIntf,
  xlib;

type
  IStrings = interface(IUnknown)
    ['{1DEE5036-A795-4313-A1A8-91FDE8B86CC6}']
    function GetCount: Integer; stdcall;
    function GetItem(Ind: Integer; Str: PChar): Integer; stdcall;
    function SetItem(Ind: Integer; Str: PChar): Integer; stdcall;
    function Add(Str: PChar): Integer; stdcall;
    function Indexof(Str: PChar): Integer; stdcall;
  end;

  idb = interface(IUnknown)
    ['{F7E0E9EC-3C8F-4D69-B212-C1460D73B8DB}']

    function connected: bool; stdcall;

    function open(Path: PChar; rw: Boolean): HResult; stdcall;
    procedure close; stdcall;

    procedure BeginTrans; stdcall;
    procedure CommitTrans; stdcall;
    procedure RollbackTrans; stdcall;

    function containsTable(Name: PChar): HResult; stdcall;

    function executeSql(Cmd: PChar): HResult; stdcall;

    function GetImageInterface(out Obj): HResult; stdcall;

    function GetTableList(out Obj: IStrings): HResult; stdcall;
    function GetTableColumnList(tb: PChar; out Obj: IStrings): HResult; stdcall;
    function GetTableData(tb: PChar; MaxRows: int; out Obj: IStrings): HResult; stdcall;
  end;

  idb_images = interface(IUnknown)
    ['{8610FB67-1715-4517-BAD3-C556DDBD7FB6}']

    function get(tb,key: PChar;
                 tie,proj4,title: PChar; MaxLen: int;
                 bmp: Pointer; maxSize: int): int; stdcall;

    function put(tb,key,tie,proj4,title: PChar;
                 bmp: Pointer; size: int): HResult; stdcall;

    // 0=UNK, 1=BMP, 2= JPG, 3= PNG, 4=GIF, 5=TIF
    function imageType(tb,key: PChar): int; stdcall;

    function upload(tb,key,tie,proj4,title: PChar; Path: PChar): HResult; stdcall;

    function download(tb,key: PChar;
                      tie,proj4,title: PChar; MaxLen: int;
                      Path: PChar): int; stdcall;

  end;

  tdll_db3 = class(tlib)
    constructor Create;
    function openDB(Path: PChar; rw: bool; out Obj): bool;
  end;

implementation

constructor tdll_db3.Create;
begin
  inherited Create('dll_db3.dll')
end;

function tdll_db3.openDB(Path: PChar; rw: bool; out Obj): bool;
type
  tfunc = function(Path: PChar; rw: bool;
                   const IID: TGUID; out Obj): HResult; stdcall;
var
  f: tfunc;
begin
  Result:=false; TPointer(Obj):=0;
  @f:=GetProc('GetExtInterface');
  if Assigned(f) then
  Result:=f(Path,rw,idb,Obj) = S_OK
end;

end.
