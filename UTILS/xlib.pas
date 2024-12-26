unit xlib; interface

uses
  Windows,Contnrs;

type
  tlib = class
    constructor Create(AName: PChar);
    destructor Destroy; override;

    function Reload: bool;

    function dm_exec(Name: PChar; ptr,mode: longint): longint;

    function GetProc(Name: PChar): FARPROC;
    function GetFunc(out func: FARPROC; Name: PChar): Boolean;

  private
    hlib: HModule;
    fName: String;

    function GetActive: bool;

  public
    property Active: bool read GetActive;
    property Handle: HModule read hlib;
    property Name: String read fName;
  end;

  tlibManager = class
    constructor Create;
    destructor Destroy; override;
    function LoadLib(Name: PChar): tlib;
  private
    flist: TObjectList;
  end;

var
  libManager: tlibManager;

implementation

uses
  OTypes,Sysutils;

constructor tlib.Create(AName: PChar);
begin
  inherited Create;
  hlib:=LoadLibrary(AName);
  fName:=Strpas(AName)
end;

destructor tlib.Destroy;
begin
  if hlib >= 32 then
  FreeLibrary(hlib);

  inherited;
end;

function tlib.GetActive: bool;
begin
  Result:=hlib >= 32
end;

function tlib.Reload: bool;
var
  s: TShortstr;
begin
  if hlib >= 32 then
  FreeLibrary(hlib);
  hlib:=LoadLibrary(StrPCopy(s,fName));
  Result:=Active
end;

function tlib.GetProc(Name: PChar): FARPROC;
begin
  Result:=nil;
  if hlib >= 32 then
  Result:=GetProcAddress(hlib,Name)
end;

function tlib.GetFunc(out func: FARPROC; Name: PChar): Boolean;
begin
  func:=GetProc(Name);
  Result:=Assigned(func)
end;

function tlib.dm_exec(Name: PChar; ptr,mode: longint): longint;
type
  tfunc = function(ptr,mode: longint): longint; stdcall;

var
  func: tfunc;
begin
  Result:=0;
  func:=GetProc(Name);
  if Assigned(func) then
  Result:=func(ptr,mode)
end;

constructor tlibManager.Create;
begin
  inherited;
  flist:=TObjectList.Create;
end;

destructor tlibManager.Destroy;
begin
  flist.Free;
  inherited
end;

function tlibManager.LoadLib(Name: PChar): tlib;
var
  i: int; lib: tlib;
begin
  Result:=nil;

  for i:=0 to flist.Count-1 do begin
    lib:=tlib(flist[i]);
    if lib.Name = Strpas(Name) then begin
      Result:=lib; Break
    end
  end;

  if Result = nil then begin
    lib:=tlib.Create(Name);
    try
      if lib.Active then begin
        Result:=lib;
        flist.Add(lib);
        lib:=nil
      end
    finally
      lib.Free
    end
  end
end;

initialization
  libManager:=tlibManager.Create;

finalization
  libManager.Free;

end.
