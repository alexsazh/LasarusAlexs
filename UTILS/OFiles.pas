unit OFiles; interface

uses
  Windows,Classes,Sysutils,
  ActiveX,Math,OTypes,OTokens;

const
  fm_OpenRead = fmOpenRead or fmShareDenyWrite;

  str_Update_Index: int = 0;

type
  TReadFile = class
    destructor Destroy; override;

    function Open(Path: PChar): Boolean; virtual;
    procedure Close; virtual;

    procedure Backup(Dest: PChar);         

    function Get_Datetime: Double;

    function ext_Open(Path,Ext: PChar): Boolean;

    function Seek(si,len: DWord): Pointer;

    function IsData(si,len: Integer): Boolean;
    function IsJpeg(si,len: Integer): Boolean;

    function Load(pos: Integer; var rec; len: Integer): Integer;

    function Get_int(pos: Integer; len: Integer): Integer;
    function Get_long(pos: Integer): Integer;
    function Get_word(pos: Integer): Integer;
    function Get_byte(pos: Integer): Integer;
    function Get_string(pos: Integer): String;

  private
    file_h: Integer;
    vm: TMapView;
    fIsUpdate: Boolean;

    function Get_Active: Boolean;

    function GetFileDate: Double;

  protected
    function Is_known_data(Path: PChar): Boolean; virtual;

  public
    property Active: Boolean read Get_Active;

    property Buf: PBytes read vm.p;
    property Size: Int64 read vm.size;

    property IsUpdate: Boolean read fIsUpdate;

    property FileDate: Double read GetFileDate;
  end;

  TUpdateFile = class(TReadFile)
    function Update(Path: PChar): Boolean; virtual;
    function Store(pos: Integer; var rec; len: Integer): Integer;
    function Append(var rec; len: Integer): Integer;
  private
  end;

  TTextFile = class
    constructor Create;
    destructor Destroy; override;

    function Open_ext(fn,ext: PChar): Boolean;
    function Open_name(fn,name: PChar): Boolean;

    function Open_bin(fn: PChar): Boolean;
    function Open_usr(usr,fn: PChar): Boolean;
    function Open_ini(fn: PChar): Boolean;
    function Open_work(fn: PChar): Boolean;
    function Open_intf(fn: PChar): Boolean;

    function Make_bin(fn: PChar): Boolean;
    function Make_lang(fn: PChar): Boolean;
    function Make_work(fn: PChar): Boolean;
    function Make_ini(fn: PChar): Boolean;
    function Make_ext(fn,ext: PChar): Boolean;

    function Open(aPath: PChar): Boolean;
    function Make(aPath: PChar): Boolean;
    function Append(aPath: PChar): Boolean;

    function Open_doc: Boolean; virtual;
    procedure Create_doc; virtual;
    procedure Close_doc; virtual;

    function End_of_file: Boolean;
    function Close: int;

    function LinesCount: int;

    procedure WriteDoc(fn: PChar);

    procedure WriteText(s: PChar);

    procedure WriteStrings(Lines: TStrings);
    procedure WriteFiles(Files: TStrings; fld: PChar);

    procedure WriteLine(ch: Char; len: int);

    procedure OutStr(const s: string);
    procedure WriteStr(const s: string);
    procedure WriteStrA(const s: AnsiString);
    procedure WriteStrW(const s: WideString);
    procedure WriteKey(Key,Val: PChar);
    procedure WriteInt(v: Integer);
    procedure WriteReal(v: Double; M: Integer);

    procedure Write_tr(Id: int; const S: String);

    procedure Write_str(Key: PChar; const S: String);
    procedure Write_str1(Key: PChar; const S: String);
    procedure Write_str2(Key: PChar; S: PChar);

    procedure Write_bool(Key: PChar; V: Boolean);

    procedure Write_int(Key: PChar; V: Integer);
    procedure Write_int64(Key: PChar; V: Int64);
    procedure Write_int2(Key: PChar; V1,V2: int);
    procedure Write_int3(Key: PChar; V1,V2,V3: int);
    procedure Write_point(Key: PChar; const V: TPoint);

    procedure Write_code(Key: PChar; Code: Integer);

    procedure Write_real(Key: PChar; V: Double; M: Integer);
    procedure Write_real2(Key: PChar; V1,V2: Double; M: Integer);
    procedure Write_range(Key: PChar; const r: TRange; M: Integer);
    procedure Write_float(Key: PChar; V: Double; M: Integer);

    procedure Write_xy(Key: PChar; X,Y: Double; M: Integer);
    procedure Write_xyz(Key: PChar; X,Y,Z: Double; M: Integer);
    procedure Write_xyzv(Key: PChar; const V: txyz; M: int);

    procedure Write_reals(Key: PChar; P: PDoubles; N,M: Integer);

    function StrRead(s: PChar): PChar;
    function CmdRead(s: PChar): PChar;
    function KeyRead(Key: PChar): Boolean;

    function ReadMID(line: TLineTokenizer): bool;

    function ReadStr: string;
    function ReadInt: longint;
    function xStrRead: PChar;
    function xStrLine: PChar;
    function lStrLine: PChar;
    function xStrMore: PChar;
    function xStrData: PChar;
    function pStrLine: PChar;
    function cStrLine: PChar;
    function xStrTrim: PChar;
    function pStrTrim: PChar;

    function xStrTrunc(skip: PChar): PChar;
    function lStrTrunc(skip: PChar): PChar;
    function xStrBatch(skip: PChar): PChar;

    function Is_section: Boolean;

    function this_key(fn: PChar): Boolean;
    function x_this_key(fn: PChar): Boolean;

    function x_this_lkey(fn: PChar;
                         out ind: Integer): Boolean;

    function x_key(key: PChar): Boolean;

    function x_key_str(key: PChar; val: PChar): Boolean;
    function x_key_strv(key: PChar; val: PChar; MaxLen: int): Boolean;
    function x_key_str1(key: PChar; val: PChar): Boolean;

    function x_key_bool(key: PChar; out v: Boolean): Boolean;
    function x_key_int(key: PChar; out v: Integer): Boolean;
    function x_key_code(key: PChar; out v: Integer): Boolean;
    function x_key_color(key: PChar; out c: uint): Boolean;
    function x_key_int64(key: PChar; out v: Int64): Boolean;
    function x_key_int2(key: PChar; out v1,v2: Integer): Boolean;
    function x_key_double(key: PChar; out v: Double): Boolean;
    function x_key_float(key: PChar; out v: float): Boolean;
    function x_key_gauss(key: PChar; out p: TGauss): Boolean;
    function x_key_xyz(key: PChar; out v: txyz): Boolean;
    function x_key_rgb(key: PChar; out cl: TColorRef): Boolean;
    function x_key_point(key: PChar; out v: TPoint): Boolean;
    function x_key_vpoint(key: PChar; out v: VPoint): Boolean;

    function x_key_Index(fn: PChar;
                         out ind: Integer): Boolean;

    function AsDouble: Double;

    function x_skip_char(ch: Char): Boolean;

    function x_this_str(Str: PChar): Boolean;

    function x_str(S: PChar): PChar;
    function l_str(S: PChar; sz: Integer): PChar;
    function x_cmd(Cmd: PChar): Boolean;
    function x_Int(out i: int): Boolean;
    function x_Hex(out v: int): Boolean;
    function x_Int16(out i: Int16): Boolean;
    function x_Int64(out i: Int64): Boolean;
    function x_DWord(out v: DWord): Boolean;
    function x_Byte(out b: Byte): Boolean;
    function x_Word(out w: Word): Boolean;
    function x_Code(out code: Integer): Boolean;
    function x_Double(out d: Double): Boolean;
    function x_number(out d: Double): Boolean;
    function x_Single(out f: Single): Boolean;
    function x_Angle(out f: Double): Boolean;
    function x_Point(out p: TPoint): Boolean;
    function x_VPoint(out p: VPoint): Boolean;
    function x_Gauss(out g: tgauss): Boolean;
    function x_Geoid(pps: int; out g: tgauss): Boolean;
    function x_xyz(out v: txyz): Boolean;
    function x_rgb(out cl: TColorRef): Boolean;
    function x_time(out t: Double): Boolean;
    function x_date(out dt: Double): Boolean;
    function x_tick(out t: Double): Boolean;

    function x_Array(P: PDoubles; N: Integer): Boolean;

    function x_Bounds(out lt,rb: TGauss): Boolean;

    function get_cmd(Cmd: PChar): Boolean;
    function get_Int(out i: Integer): Boolean;
    function get_Double(out d: Double): Boolean;
    function get_Point(out p: TPoint): Boolean;
    function get_Gauss(out g: tgauss): Boolean;
    function get_xyz(out v: txyz): Boolean;
    function get_x_y_z(out x,y,z: Double): Boolean;

    procedure skip_section;

  private
    ftxt: text;

    fLineCount: int;

    fActive: bool;
    fUnix: bool;

    fis_Point_Comma: bool;
    fIs_Comma_Delimiter: bool;
    fIs_trim: bool;
    fIs_rw: bool;

    fNoToken: bool;
    fNoKey: bool;

    fdegType: int; // none,lat,lon

    fOnEmptyLine: TNotifyEvent;

    fequ_char: ShortString;
    fComment: ShortString;

    fkey: TShortStr;
    fvalue: TPathStr;

    fIs_time: bool;
    fIs_AbsTime: bool;
    fLogStart: double;

    fPath: TShortstr;

    function GetPath: PChar;

    function Get_key: PChar;
    function Get_value: PChar;
    function Delimiter_char: Char;

    function __StrRead(s: PChar; MaxLen: int): PChar;

  public
    str: TCmdStr;

    property Active: bool read fActive;
    property Unix: bool read fUnix write fUnix;

    property Path: PChar read GetPath;

    property equ_char: ShortString read fequ_char write fequ_char;

    property Comment: ShortString read fComment;

    property is_Point_Comma: bool write fis_Point_Comma;
    property is_Comma_Delimiter: bool write fis_Comma_Delimiter;
    property Is_trim: bool write fIs_trim;
    property Is_rw: bool write fIs_rw;

    property Is_time: bool write fIs_time;
    property Is_AbsTime: bool write fIs_AbsTime;

    property NoToken: bool write fNoToken;
    property NoKey: bool write fNoKey;

    property degType: int write fdegType;

    property Key: PChar read Get_key;
    property Value: PChar read Get_value;

    property LineCount: int read fLineCount;

    property txt: text read ftxt;

    property OnEmptyLine: TNotifyEvent write fOnEmptyLine;
  end;

  TTextOut = class
    constructor Create(Aout: TTextFile; Aproc: TLogProc);
    procedure WriteStr(const Str: String);
  private
    fout: TTextFile;
    fproc: TLogProc;
  end;

  TTextStream = class(TTextFile)

    function NextLine: Boolean; virtual;
    function Get_Line: PChar;
    function LineStr: String;

  private
    fIs_Repeat: bool;
    fLine: TCmdStr;
  public
    property Line: PChar read Get_Line;
    property Is_Repeat: bool write fIs_Repeat;
  end;

  TOutStream = class(TTextStream)
    function NextLine: Boolean; override;
  end;

  TIniStrings = class(TStringList)
    function xInt64(I: Integer): Int64;
    function xString(I: Integer): String;

    function str_Value(key: PChar): String;
    function int_Value(key: PChar): Integer;

    function get_int64(key: PChar; out v: Int64): Boolean;
    function get_int(key: PChar; out v: Integer): Boolean;

    function get_range(key: PChar; min,max: Integer;
                       out v: Integer): Boolean;

    function get_bool(key: PChar; out v: Boolean): Boolean;

    procedure put_int64(key: PChar; v: Int64);
    procedure put_int(key: PChar; v: Integer);

    procedure put_str(key: PChar; const v: String);

  end;

  TSpaceList = class(TStringList)
    constructor Create(ini: PChar);
    procedure Update_Space(Dir: PChar);
    function Get_Space(Dir: PChar): Boolean;
  private
    fPath: TShortStr;

    procedure Update;
  end;

  TTextfileEvent = procedure(Sender: TObject;
                             Text: TTextfile;
                             Name,Path: PChar) of object;

var
  GetAppWnd: TGetHandle;
  exec_without_cmd: bool;

  AppDir: TShortStr;
  BinDir: TShortStr;
  IntfDir: TShortStr;
  WorkDir: TShortStr;
  LangDir: TShortStr;
  SpaceDir: TShortStr;
  env_ini: TNameStr;

function SetFilePointerEx(hFile: THANDLE;
                          liDistanceToMove: Int64;
                          lpNewFilePointer: PInt64;
                          dwMoveMethod: DWord): Boolean; stdcall;

function xFileSeek(h: THandle; pos: Int64): bool;
function xFilePos(h: THandle): int64;
function xFileBot(h: THandle): int64;

function StringOf(List: TStrings; Str: PChar): Integer;

function pack_strings(Text: TStrings): Integer;

function IsModule(Name: PChar): Boolean;
function xGetModuleName: String;

procedure Change_BinDir(Dir: PChar);

procedure Change_IntfDir(Sub: PChar);

procedure SetBinDir(dir: PChar); stdcall;
function SetIntfDir(Dir: PChar): PChar; stdcall;

procedure SetSpaceDir(Dir: PChar); stdcall;
procedure iniSpaceDir(Ini: PChar); stdcall;

procedure Update_SpaceDir(Ini,Dir: PChar);

function TextFileCount(Path: PChar): Integer;

function StrTranslate(Msg,Def,Path: PChar; Id: Integer): PChar;

function xStrTranslate(Msg,Def,Path: PChar;
                       Size,Id: Integer): PChar;

function xLoadMessage(Msg,Path: PChar; Id: Integer): PChar;

function xLoadStrings(List: TStrings; Path: PChar;
                      from_id,last_id: Integer): Integer;

function xLoadText(List: TStrings; Path: PChar): Integer;

function xLoadAnsiString(Path: PChar): AnsiString;

function StrObjects(Str: PChar; Count: Integer): PChar;
function ObjectsStr(Count: Integer): String;

function MsgObjects(Str,Msg: PChar; Count: Integer): PChar;

function Str_Edit_Msg(Msg,Def,Alt: PChar;
                      Count,Id: Integer): PChar;

function str_Update_Msg(Msg: PChar; Count: Integer): PChar;
function str_Found_Msg(Msg: PChar; Count: Integer): PChar;
function str_Create_Msg(Msg: PChar; Count: Integer): PChar;
function str_Delete_Msg(Msg: PChar; Count: Integer): PChar;
function str_Add_Msg(Msg: PChar; Count: Integer): PChar;

function str_Count_Msg(Msg,Msg1,Msg2,Msg3: PChar;
                       Count: Integer): PChar;

function str_Count_Cat(Str,Msg1,Msg2,Msg3: PChar;
                       Count: Integer): PChar;

function str_Object_Cat(Str: PChar; Count: int): PChar;
                       
function str_Count_Msg1(Msg,Msg1,Msg2,Msg3: PChar;
                        Count: Integer): PChar;

function str_Count_Cat1(Str,Msg1,Msg2,Msg3: PChar;
                       Count: Integer): PChar;

function StrMsgCount(Str,Capt: PChar;
                     Msg,Msg1,Msg2,Msg3: PChar;
                     Count: Integer): PChar;

function UsrDir1(Dir,Sub: PChar): bool;

function UsrDir(Dir,Sub: PChar): PChar;
function UsrBinDir(Dir: PChar): PChar;
function IniDir(Dir: PChar): PChar;

function HlpPath(Path,FName: PChar): PChar;
function hlp_Path(fname: PChar): string;

function StrExeName(Name,Alt: PChar): PChar;

function StrPath(Path,Dir,Name: PChar): PChar;
function StrExist(Path,Dir,Name: PChar): bool;
function StrWorkPath(Path,Name: PChar): PChar;
function StrIntfPath(Path,Name: PChar): PChar;
function xStrWorkPath(Path,Name: PChar): PChar;
function StrBinPath(Path,Name: PChar): PChar;
function StrUsrPath(Path,Usr,Name: PChar): PChar;
function StrIniPath(Path,Name: PChar): PChar;
function StrLangPath(Path,Name: PChar): PChar;
function StrDatePath(Path,Dir,Ext: PChar): PChar;
function StrTimePath(Path,Dir,Ext: PChar): PChar;
function StrDir(Dest,Dir: PChar): PChar;

function StrBinFile(Path,Name: PChar): PChar;

function xStrPath(Path,Dir,FName,Ext: PChar): PChar;

function StrExt(Dest,Path: PChar): PChar;
function StrNameExt(Dest,Path: PChar): PChar;
function StrFNameExt(dst: PChar; const FName: WideString): PChar;

function StrTruncPath(Dest,Path,Fld: PChar): PChar;

function StrDirNameExt(Dest,Path: PChar): PChar;

function StrCatNameExt(Dest,Path: PChar): PChar;
function xStrCatNameExt(Dest,Path: PChar): PChar;

function StrFldNameExt(Dest,Path: PChar): PChar;

function StrDirectory(Dir,Path: PChar): PChar;
function ThisDirectory(Path,Dir: PChar): Boolean;
function StrUpdateExt(Dest,Path,Ext: PChar): PChar;
function StrFNameCapt(Capt,Path: PChar; MaxLen: int): PChar;
function xStrFNameCapt(Capt,Path: PChar; MaxLen: int): PChar;

function StrBackupFName(Dest,Path: PChar): PChar;

function StrUpdateName(Dest,Path,Name: PChar): PChar;
function StrUpdateFName(Dest,Path,Name: PChar): PChar;
function StrNextFName(Dest,Path,Alt: PChar): PChar;
function StrNextIndexFName(Dest,Path: PChar): PChar;

function StrWindowsDirectory(Dir: PChar): PChar;

function StrFName(dst: PChar; const FName: WideString): PChar;
function StrFNameCopy(Dst,Src: PChar): PChar;

function xStrUpdateDir(Path,Dir: PChar): PChar;
function xStrUpdateExt(Path,Ext: PChar): PChar;
function StrChangeExt(Path,Ext: PChar): PChar;
function StrChangeDir(Path,Dir: PChar): PChar;

function StrUpdateDir(Dest,Path,Dir: PChar): PChar;
function StrUpdateDirExt(Dest,Path,Dir,Ext: PChar): PChar;

function StrExpand(Path,FName: PChar): PChar;

function StrPageFileName(Dest,Path: PChar; I,J,Len: int): PChar;

function StrNextFileName(Dest,Path: PChar; Ind: int): PChar;
function StrAltFileName(Dest,Path,Alt: PChar): PChar;

function StrTempPath(Temp,Path: PChar): PChar;
function StrTempFileName(Path,Prefix: PChar): PChar;
function wStrTempFileName(Path,Prefix: PChar): PChar;
function wStrTempFileName1(Path,Prefix: PChar): PChar;
function xStrTempFileName(Path,Prefix: PChar): PChar;
function zStrTempFileName(Path,Prefix: PChar): PChar;
procedure xStrTempClear(Prefix,Ext: PChar);

function xStrThis(Dst,Src: PChar): Boolean;

function This_Ext(Path,Ext: PChar): Boolean;
function This_Text(Path,fft: PChar): Boolean;

function xStrNameExt(Path: PChar): string;
function DriveStr(Path: PChar): string;
function StrDefaultDir(Dir: PChar): PChar;

function xNameExtCapt(Capt,Path: PChar): string;

function xRenameFile(old,new: PChar): Boolean;
function xRenameFileEx(old,new,ext: PChar): Boolean;
function xExtFile(Path,Ext: PChar): Boolean;

function FileExist(Path: PChar): Boolean;
function xFileExist(Path,Ext: PChar): Boolean;
function uFileExist(Path,Usr: PChar): Boolean;
function uFileExists(Usr,Name: PChar): Boolean;

function FileErase(Path: PChar): Boolean;
function xWorkErase(Name: PChar): Boolean;
function xFileErase(Path,Ext: PChar): Boolean;
function xFileSize(Path: PChar): Integer;
function xFileCreate(Path: PChar): Integer;

function StrExeDescription(Path,Desc: PChar): PChar;

function winFileSize(Path: PChar): Int64;
function winOpenReadFile(Path: PChar): THandle;
function winOpenUpdateFile(Path: PChar): THandle;

function xFileAge(Path: PChar): Double;

procedure SetFileUpdateTime(Path: PChar);
procedure SetFileCreateTime(Path: PChar; dt: Double);

function FileReadWrite1(Path: PChar): Boolean;
function FileReadWrite(Path: PChar): Boolean;
function FileReadOnly(Path: PChar): Boolean;

function xUsrPath(Path,Sub,Name: PChar): Boolean;

function xAppPath(Path,Sub,Name: PChar): Boolean;

function xWorkDir(Dir,Sub: PChar): PChar;
function xWorkPath(Path,Sub,Name: PChar): Boolean;
function xWorkExist(Sub,Name: PChar): Boolean;
function sWorkFile(Path,Sub: PChar; const Name: String): Boolean;

function ini_Exists(dst,fn: PChar): Boolean;

function bin_Exists(dst,dll: PChar): Boolean;
function tsk_Exists(dst,dll: PChar): Boolean;
function bin_Exec(exe,params: PChar): Boolean;

function Dir_Enabled(Dir,Def: PChar): PChar;
function Dir_Exists(Dir: PChar): Boolean;
function Dir_Create(Dir: PChar): Boolean;

function FolderCreate(Path: PChar): Boolean;

function DirCopy(Dir,Str: PChar): PChar;

function Ch_Dir(Dir: PChar): Boolean;
function Remove_Dir(Dir: PChar): Boolean;

function FolderCopyTo(Src,Dest: PChar): int;

function wait_Execute(cmdline: PChar; wait: Boolean;
                      close: Boolean = false;
                      win: Boolean = false): THandle;

function call_util(cmd,params: PChar): THandle;

function exec_tool(exe,params,dir: PChar): int;

procedure shell_execute(Path: PChar);

function FileUpdate(Path: PChar; buf: Pointer; len: int): Boolean;
function FileCopy(src,dst: PChar): Boolean;
function xFileCopy(src,dst,ext: PChar): Boolean;

function FileBackup(Path: PChar): Boolean;
function xFileBackup(Path,Ext: PChar): Boolean;

function FileCopy1(dir1,dir2,name: PChar): Boolean;
function FileCopy2(src,dst: PChar): Boolean;

procedure _ltrunc(h: Integer);
function _lsize(h: Integer): longint;
function _lpos(h: Integer): longint;

function Disk_Free(Path: PChar): Int64;
function Wait_Free(Path: PChar; Min: Int64): Boolean;

function FileOpenExt(Path,Ext: PChar; rw: Boolean): Integer;
function FileCreateExt(Path,Ext: PChar): Integer;

function xFileImage(Path: PChar; size: Integer): Integer;
function xFileRead(h, buf,size: Integer): Integer;

function xFileDump(Path: PChar; var buf; len: int): Boolean;

procedure dump_wstr(dest,temp: PChar; const S: WideString);

function IsHtmlText(Path: PChar): Boolean;

function magic_FileRead(Path,Magic: PChar;
                        var buf; len: Integer): Boolean;

function magic_FileWrite(Path,Magic: PChar;
                         var buf; len: Integer): Boolean;

function xDropFiles(hDrop: THandle; InClient: Boolean): TStringList;

function Get_Folders(Dir: PChar; Items: TStrings): int;

function Backup_data(Mask,Alt: PChar; bak: Boolean): Integer;

function Add_Files(Mask: PChar; Items: TStrings): int;
function Get_Files(Dir,Mask: PChar; Items: TStrings): int;

function StrFrstFile(Dest,Mask: PChar): Integer;

function Add_FNames(Mask: PChar; Items: TStrings): Integer;
function Get_FNames(Mask: PChar; Items: TStrings): Integer;
function Scan_Files(Dir,Mask: PChar; Items: TStrings): int;

function Erase_FNames(Mask: PChar): Integer;
function Erase_Work_FNames(Mask: PChar): Integer;

function xGetComObject(dll: THandle;
                      const CLSID, IID: TGUID;
                      var Obj): Boolean;

function GetComObject(dll: PChar;
                      const CLSID, IID: TGUID;
                      var Obj): THandle;

function xFreeLibrary(hLib: THandle): THandle;
function wFreeLibrary(hLib: THandle): THandle;

function StrFromText(buf: PChar; size: Integer;
                     Text: TStrings): PChar;

function StrToText(Text: TStrings;
                   const Str: PChar;
                   Ind,Max: Integer): Integer;

procedure reset_dll_app_handle(dll: THandle);
procedure set_dll_app_handle(dll: THandle);

procedure set_dll_app_help(dll: THandle; hlp: PChar);
procedure set_dll_intf_dir(dll: THandle);

procedure set_dll_env_dir(dll: THandle);
procedure set_dll_space_dir(dll: THandle);

function txt_Copy(src,dst: PChar): Integer;

procedure dump_stat(Dest: PChar;
                    stat: PIntegers;
                    n1,n2: int);

function GetAviStartTime(Path: PChar; out t,dt: int): Boolean;
procedure PutAviStartTime(Path: PChar; dt: int);

implementation

uses
  ShellAPI,
  Convert;

const
  kernel32  = 'kernel32.dll';

function SetFilePointerEx(hFile: THANDLE;
                          liDistanceToMove: Int64;
                          lpNewFilePointer: PInt64;
                          dwMoveMethod: DWord): Boolean;
stdcall; external kernel32 name 'SetFilePointerEx';

function xFileSeek(h: THandle; pos: Int64): bool;
begin
  Result:=SetFilePointerEx(h,pos,nil,0)
end;

function xFilePos(h: THandle): int64;
var
  pos: int64;
begin
  Result:=0;
  if SetFilePointerEx(h,0,@pos,1) then
  Result:=pos
end;

function xFileBot(h: THandle): int64;
var
  pos: int64;
begin
  Result:=0;
  if SetFilePointerEx(h,0,@pos,2) then
  Result:=pos
end;

function IsModule(Name: PChar): Boolean;
var
  fn: TPathStr;
begin
  GetModuleFileName(0,fn,Sizeof(fn)-1);
  StrNameExt(fn,fn);

  Result:=StrIComp(fn,Name) = 0
end;

function xGetModuleName: String;
var
  fn: TShortstr;
begin
  GetModuleFileName(0,fn,Sizeof(fn)-1);
  StrNameExt(fn,fn); StrUpdateExt(fn,fn,'');
  Result:=StrPas(fn)
end;

procedure AppData_WorkDir;
var
  l: int; dir,fn: TPathStr;
begin
  GetModuleFileName(0,fn,Sizeof(fn)-1);
  StrNameExt(fn,fn); StrUpdateExt(fn,fn,'');

  ExpandEnvironmentStrings('%APPDATA%',dir,511);

  l:=Strlen(dir); if l > 0 then
  if dir[l-1] <> '\' then
  StrLCat(dir,'\',511);

  StrLCat(dir,'dmw\',511); Dir_Create(dir);
  StrLCat(dir,'tmp\',511); Dir_Create(dir);

  if Dir_Exists(dir) then
  StrCopy(WorkDir,dir)
end;

procedure Change_BinDir(Dir: PChar);
var
  len: int; wrk: TShortStr;
begin
  if Dir <> nil then
  if StrLen(Dir) > 0 then
  if Dir_Exists(Dir) then begin

    StrCopy(wrk,Dir);
    len:=StrLen(wrk); if len > 0 then
    if wrk[len-1] = '\' then wrk[len-1]:=#0;

    StrCopy(BinDir,wrk);
    StrDirectory(SpaceDir,wrk);

    len:=Strlen(SpaceDir);
    if len > 0 then
    if SpaceDir[len-1] = '\' then
    SpaceDir[len-1]:=#0;

    StrCopy(WorkDir,BinDir);

    if UsrDir(wrk,'\WORK') <> nil then
    if Dir_Exists(wrk) then
    StrCopy(WorkDir,wrk);

    StrCopy(LangDir,BinDir);
    StrPath(wrk,BinDir,'Language');
    if Dir_Exists(wrk) then
    StrCopy(LangDir,wrk);

    StrCopy(IntfDir,WorkDir);
    AppData_WorkDir;
  end
end;

procedure SetBinDir(dir: PChar); stdcall;
begin
  Change_BinDir(Dir);
end;

procedure Change_IntfDir(Sub: PChar);
var
  dir: TShortstr;
begin
  StrCopy(IntfDir,WorkDir);

  if UsrDir(dir,'\WORK') <> nil then
  if Dir_Exists(dir) then
  StrCopy(IntfDir,dir);

  if UsrDir(dir,Sub) <> nil then
  if Dir_Exists(dir) then
  StrCopy(IntfDir,dir);
end;

function SetIntfDir(Dir: PChar): PChar;
begin
  if Dir_Exists(Dir) then
  StrLCopy(IntfDir,Dir,255);
  Result:=IntfDir
end;

destructor TReadFile.Destroy;
begin
  Close; inherited
end;

function TReadFile.Is_known_data(Path: PChar): Boolean;
begin
  Result:=true;
end;

function TReadFile.Get_Active: Boolean;
begin
  Result:=Assigned(Buf)
end;

function TReadFile.GetFileDate: Double;
var
  ft1,ft2,ft3: TFiletime;
  st: TSystemTime;
begin
  Result:=0; if file_h > 0 then
  if GetFileTime(file_h,@ft1,@ft2,@ft3) then
  if FileTimeToSystemTime(ft3,st) then
  Result:=SystemTimeToDateTime(st)
end;

function TReadFile.Open(Path: PChar): Boolean;
begin
  Result:=false; Close;

  if false then
    file_h:=FileOpen(StrPas(Path),fm_OpenRead)
  else
    file_h:=CreateFile(Path,GENERIC_READ,
                       FILE_SHARE_READ,
                       nil,OPEN_EXISTING,
                       0,0);

  if file_h > 0 then
  if xReadOnlyFile(file_h,vm) <> nil then
  Result:=true;

  if Result then
  if not Is_known_data(Path) then begin
    Close; Result:=false
  end
end;

procedure TReadFile.Close;
begin
  xFreeFile(vm); if file_h > 0 then
  FileClose(file_h); file_h:=0;
  fIsUpdate:=false
end;

procedure TReadFile.Backup(Dest: PChar);
var
  h: THandle;
begin
  if Active then begin
    h:=FileCreate(Dest);
    if h <> 0 then begin
      FileWrite(h,Buf^,Size);
      FileClose(h)
    end
  end
end;

function TReadFile.Get_Datetime: Double;
var
  dt: Longint;
begin
  dt:=FileGetDate(file_h);
  Result:=FileDateToDateTime(dt)
end;

function TReadFile.ext_Open(Path,Ext: PChar): Boolean;
var
  fn: TShortStr;
begin
  StrUpdateExt(fn,Path,Ext);
  Result:=Open(fn)
end;

function TReadFile.Seek(si,len: DWord): Pointer;
begin
  Result:=nil;
  if IsData(si,len) then
  Result:=@Buf[si]
end;

function TReadFile.IsData(si,len: Integer): Boolean;
begin
  Result:=false; if si >= 0 then
  Result:=si + len <= Size
end;

function TReadFile.IsJpeg(si,len: Integer): Boolean;
begin
  Result:=false; if len > 4 then
  if IsData(si,len) then
  if Get_word(si) = $D8FF then
  if Get_word(si+len-2) = $D9FF then
  Result:=true
end;

function TReadFile.Load(pos: Integer; var rec; len: Integer): Integer;
begin
  if (pos >= 0) and (pos+len <= Size) then
    Move(Buf[pos],rec,len)
  else
    Fillchar(rec,len,0); Result:=pos+len
end;

function TReadFile.Get_int(pos: Integer; len: Integer): Integer;
var
  ax: Integer;
begin
  ax:=0; if len > 4 then len:=4;
  Load(pos,ax,len); Result:=ax
end;

function TReadFile.Get_long(pos: Integer): Integer;
var
  ax: Integer;
begin
  ax:=0; Load(pos,ax,4); Result:=ax
end;

function TReadFile.Get_word(pos: Integer): Integer;
var
  ax: Integer;
begin
  ax:=0; Load(pos,ax,2); Result:=ax
end;

function TReadFile.Get_byte(pos: Integer): Integer;
var
  ax: Integer;
begin
  ax:=0; Load(pos,ax,1); Result:=ax
end;

function TReadFile.Get_string(pos: Integer): String;
var
  len: int; s: ShortString;
begin
  s:='';
  if pos < Size-1 then begin
    len:=Buf[pos];
    if pos+len <= Size then
    Move(Buf[pos],s,len+1)
  end;

  Result:=s
end;

function TUpdateFile.Update(Path: PChar): Boolean;
begin
  Result:=false; Close;
  file_h:=FileOpen(StrPas(Path),fmOpenReadWrite);

  if file_h > 0 then
  if xUpdateFile(file_h,vm) <> nil then
  Result:=true;

  fIsUpdate:=true; if Result then

  if not Is_known_data(Path) then begin
    Close; Result:=false
  end
end;

function TUpdateFile.Store(pos: int; var rec; len: int): int;
begin
  if (pos >= 0) and (pos+len <= Size) then
  Move(rec,Buf[pos],len); Result:=pos+len
end;

function TUpdateFile.Append(var rec; len: int): int;
begin
  Result:=FileSeek(file_h,0,2);
  FileWrite(file_h,rec,len);
  Inc(vm.size,len)
end;

constructor TTextFile.Create;
begin
  inherited Create;
  fequ_char:='='
end;

destructor TTextFile.Destroy;
begin
  Close; inherited
end;

function TTextFile.GetPath: PChar;
begin
  Result:=fPath
end;

function TTextFile.Open_ext(fn,ext: PChar): Boolean;
var
  Path: TShortStr;
begin
  StrUpdateExt(Path,fn,ext);
  Result:=Open(Path)
end;

function TTextFile.Open_name(fn,name: PChar): Boolean;
var
  Dir,Ext,Path: TShortStr;
begin
  StrDirectory(Dir,fn);
  StrPCopy(Ext,ExtractFileExt(fn));
  StrPath(Path,Dir,Name);
  StrCat(Path,Ext);

  Result:=Open(Path)
end;

function TTextFile.Open_bin(fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Open(StrPath(Path,BinDir,fn))
end;

function TTextFile.Open_usr(usr,fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Open(StrUsrPath(Path,usr,fn))
end;

function TTextFile.Open_ini(fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Open(StrUsrPath(Path,'\INI',fn))
end;

function TTextFile.Open_work(fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Open(StrPath(Path,WorkDir,fn))
end;

function TTextFile.Open_intf(fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Open(StrPath(Path,IntfDir,fn))
end;

function TTextFile.Make_bin(fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Make(StrPath(Path,BinDir,fn))
end;

function TTextFile.Make_lang(fn: PChar): Boolean;
var
  Path: TPathStr;
begin
  Result:=Make(StrPath(Path,LangDir,fn))
end;

function TTextFile.Make_work(fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Make(StrPath(Path,WorkDir,fn))
end;

function TTextFile.Make_ini(fn: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=Make(StrUsrPath(Path,'\INI',fn))
end;

function TTextFile.Make_ext(fn,ext: PChar): Boolean;
var
  Path: TShortStr;
begin
  StrUpdateExt(Path,fn,ext);
  Result:=Make(Path)
end;

function TTextFile.Open(aPath: PChar): Boolean;
var
  i: int;
begin
  Result:=false; Close;

  StrLCopy(fPath,aPath,Sizeof(fPath)-1);

  if Strlen(aPath) > 0 then
  for i:=1 to 2 do begin
    AssignFile(ftxt,StrPas(aPath));
    System.Reset(ftxt);

    if IOResult = 0 then begin
      fActive:=true; Break
    end
  end;

  if fActive then
  Result:=Open_doc
end;

function TTextFile.Make(aPath: PChar): Boolean;
var
  i,rc: int;
begin
  Close; fLogStart:=-1;

  StrLCopy(fPath,aPath,Sizeof(fPath)-1);

  for i:=1 to 2 do begin
    AssignFile(ftxt,Strpas(aPath));

    System.Rewrite(ftxt);
    rc:=IOResult; fActive:=rc = 0;
    if fActive then Break;

    if i = 1 then
    if fIs_rw then
    FileReadWrite1(Path);
  end;

  if not fActive then Create_doc;
  Result:=fActive
end;

function TTextFile.Append(aPath: PChar): Boolean;
var
  i: int;
begin
  Close;

  StrLCopy(fPath,aPath,Sizeof(fPath)-1);

  for i:=1 to 2 do begin
    AssignFile(ftxt,Strpas(aPath));
    System.Append(ftxt);

    fActive:=IOResult = 0;
    if fActive then Break;
  end;

  if fActive then Create_doc;
  Result:=fActive
end;

function TTextFile.Open_doc: Boolean; begin Result:=true end;
procedure TTextFile.Create_doc; begin end;
procedure TTextFile.Close_doc; begin end;

function TTextFile.End_of_file: Boolean;
begin
  if not fActive then
    Result:=true
  else
    Result:=EOF(ftxt)
end;

function TTextFile.Close: int;
begin
  Result:=-1;
  if fActive then begin
    Close_doc;

    CloseFile(ftxt); Result:=IOResult;
    if Result <> 0 then begin
      CloseFile(ftxt);
      Result:=IOResult;
    end;

    fActive:=false;
  end
end;

function TTextFile.Get_key: PChar;
begin
  Result:=@fkey
end;

function TTextFile.Get_value: PChar;
begin
  Result:=@fvalue
end;

function TTextFile.Delimiter_char: Char;
begin
  Result:=' '; if fIs_Comma_Delimiter then Result:=',';
end;

function TTextFile.LinesCount: Integer;
var
  s: string;
begin
  Result:=0;

  while not EOF(ftxt) do begin
    readln(txt,s);
    if length(s) > 0 then
    Inc(Result)
  end
end;

procedure TTextFile.WriteDoc(fn: PChar);
var
  txt: TStringList; i: int;
begin
  txt:=TStringList.Create;
  try
    txt.LoadFromFile(fn);
    for i:=0 to txt.Count-1 do
    WriteStr(txt[i]);
  finally
    txt.Free
  end
end;

procedure TTextFile.WriteText(s: PChar);
var
  txt: TStringList;
  i: Integer;
begin
  txt:=TStringList.Create;
  try
    txt.Text:=StrPas(s);
    for i:=0 to txt.Count-1 do
    WriteStr(txt[i]);
  finally
    txt.Free
  end
end;

procedure TTextFile.WriteStrings(Lines: TStrings);
var
  i: int;
begin
  for i:=0 to Lines.Count-1 do
  WriteStrW(Lines[i])
end;

procedure TTextFile.WriteFiles(Files: TStrings; fld: PChar);
var
  i,len: int; pc: PChar; dir,fn,fn1: TShortstr;
begin
  if Assigned(fld) then begin
    StrCopy(dir,fld);
    xStrUpper(dir);
    len:=Strlen(dir)
  end;

  for i:=0 to Files.Count-1 do
  if fld = nil then
    WriteStr('"'+Files[i]+'"')
  else begin
    StrPCopy(fn,Files[i]);
    StrCopy(fn1,fn);

    xStrUpper(fn1); pc:=@fn1[len];

    if pc[0] = '\' then
    if StrLComp(fn1,dir,len) = 0 then begin
      Inc(pc); StrCopy(fn,pc)
    end;

    WriteStr('"'+Strpas(fn)+'"')
  end
end;

procedure TTextFile.WriteLine(ch: Char; len: Integer);
var
  s: TShortstr;
begin
  Fillchar(s,Sizeof(s),0);
  Fillchar(s,len,ch); writeln(txt,s)
end;

procedure TTextFile.OutStr(const s: string);
begin
  write(txt,s)
end;

procedure TTextFile.WriteStr(const s: string);
var
  t: double; comma: String;
begin
  if fActive then

  if fIs_time then begin
    t:=Time;
    if flogStart < 0 then flogStart:=t;
    if not fIs_AbsTime then t:=t-flogStart;
    writeln(txt,xTimeStr1(t)+' '+s)
  end
  else begin
    comma:=''; if Length(s) > 0 then
    if fIs_Point_Comma then comma:=';';

    if fUnix then write(txt,s,comma,#10)
    else writeln(txt,s,comma)
  end
end;

procedure TTextFile.WriteStrW(const s: WideString);
var
  comma: String;
begin
  if fActive then begin
    comma:=''; if Length(s) > 0 then
    if fIs_Point_Comma then comma:=';';

    if fUnix then write(txt,s,comma,#10)
    else writeln(txt,s,comma)
  end
end;

procedure TTextFile.WriteStrA(const s: AnsiString);
var
  comma: String;
begin
  if fActive then begin
    comma:=''; if Length(s) > 0 then
    if fIs_Point_Comma then comma:=';';

    if fUnix then write(txt,s,comma,#10)
    else writeln(txt,s,comma)
  end
end;

procedure TTextFile.WriteKey(Key,Val: PChar);
begin
  WriteStr(StrPas(Key)+equ_char+StrPas(Val));
end;

procedure TTextFile.WriteInt(v: Integer);
begin
  WriteStr(IntToStr(v))
end;

procedure TTextFile.WriteReal(v: Double; M: Integer);
begin
  WriteStr(RealToStr(v,M)) 
end;

procedure TTextFile.Write_tr(Id: int; const S: String);
begin
  WriteStr(Format('%d "%s"',[Id,S]))
end;

procedure TTextFile.Write_str(Key: PChar; const S: String);
begin
  WriteStr(StrPas(Key)+equ_char+S)
end;

procedure TTextFile.Write_str1(Key: PChar; const S: String);
begin
  Write_str(Key,'"'+S+'"')
end;

procedure TTextFile.Write_str2(Key: PChar; S: PChar);
begin
  Write_str(Key,'"'+Strpas(S)+'"')
end;

procedure TTextFile.Write_bool(Key: PChar; V: Boolean);
begin
  Write_int(Key,ibool[V])
end;

procedure TTextFile.Write_int(Key: PChar; V: Integer);
begin
  Write_str(Key,IntToStr(V))
end;

procedure TTextFile.Write_int64(Key: PChar; V: Int64);
begin
  Write_str(Key,IntToStr(V))
end;

procedure TTextFile.Write_int2(Key: PChar; V1,V2: int);
var
  ch: Char;
begin
  ch:=Delimiter_char;
  Write_str(Key,IntToStr(V1)+ch+IntToStr(V2))
end;

procedure TTextFile.Write_int3(Key: PChar; V1,V2,V3: int);
var
  ch: Char;
begin
  ch:=Delimiter_char;
  Write_str(Key,IntToStr(V1)+ch+IntToStr(V2)+ch+IntToStr(V3))
end;

procedure TTextFile.Write_point(Key: PChar; const V: TPoint);
var
  ch: Char;
begin
  ch:=Delimiter_char;
  Write_str(Key,IntToStr(V.X)+ch+IntToStr(V.Y))
end;

procedure TTextFile.Write_code(Key: PChar; Code: Integer);
begin
  write_str(Key,CodeToStr(Code));
end;

procedure TTextFile.Write_real(Key: PChar; V: Double; M: int);
begin
  write_str(Key,RealToStr(V,M));
end;

procedure TTextFile.Write_real2(Key: PChar; V1,V2: Double; M: int);
begin
  write_str(Key,RealToStr(V1,M)+' '+RealToStr(V2,M));
end;

procedure TTextFile.Write_range(Key: PChar; const r: TRange; M: Integer);
begin
  write_str(Key,RealToStr(r.min,M)+' '+RealToStr(r.max,M));
end;

procedure TTextFile.Write_float(Key: PChar; V: Double; M: Integer);
begin
  write_str(Key,FloatToStr(V,M))
end;

procedure TTextFile.Write_xy(Key: PChar; X,Y: Double; M: Integer);
var
  ch: Char;
begin
  ch:=Delimiter_char;
  write_str(Key,RealToStr(X,M)+ch+RealToStr(Y,M));
end;

procedure TTextFile.Write_xyz(Key: PChar; X,Y,Z: Double; M: Integer);
var
  ch: Char;
begin
  ch:=Delimiter_char;
  write_str(Key,RealToStr(X,M)+ch+
                RealToStr(Y,M)+ch+
                RealToStr(Z,M));
end;

procedure TTextFile.Write_xyzv(Key: PChar; const V: txyz; M: int);
begin
  write_xyz(Key,V.x,V.y,V.z,M)
end;

procedure TTextFile.Write_reals(Key: PChar; P: PDoubles; N,M: Integer);
var
  i: int; ch: Char; S: String;
begin
  ch:=Delimiter_char;

  S:=''; for i:=0 to N do
  if Length(S) <= 236 then begin
    if Length(S) > 0 then S:=S+ch;
    S:=S+RealToStr(P[I],M)
  end;

  Write_str(Key,s)
end;

function TTextFile.__StrRead(s: PChar; MaxLen: int): PChar;
var
  p: PChar; k,len: int; tmp: WideString;
begin
  Result:=nil; StrCopy(s,'');

  readln(txt,tmp);

  len:=length(tmp);
  if len > 0 then begin

    if len >= MaxLen then
    SetLength(tmp,MaxLen);

    StrPCopy(s,tmp);

    if not fIs_trim then
      Result:=s
    else begin
      p:=s; k:=0;
      while p[0] <> #0 do
      if p[0] in [#9,' '] then begin
        p:=@p[1]; Inc(k)
      end
      else begin
        if k > 0 then StrCopy(s,p);
        Result:=s; Break
      end
    end
  end;

  Inc(fLineCount)
end;

function TTextFile.StrRead(s: PChar): PChar;
begin
  Result:=__StrRead(s,255)
end;

function TTextFile.CmdRead(s: PChar): PChar;
begin
  Result:=nil; StrCopy(s,'');

  if xStrRead <> nil then
  if StrToken(s,str) <> nil then
  if StrLen(s) > 0 then
  Result:=StrUpper(s)
end;

function TTextFile.KeyRead(Key: PChar): Boolean;
var
  cmd,line: TShortStr;
begin
  Result:=false;
  if xStrRead <> nil then
  if StrCopy(line,str) <> nil then
  if StrToken(cmd,line) <> nil then
  if StrLen(cmd) > 0 then
  if StrUpper(cmd) <> nil then
  if StrComp(cmd,Key) = 0 then begin
    StrCopy(str,line); Result:=true
  end
end;

function TTextFile.ReadMID(line: TLineTokenizer): bool;
begin
  line.reset;
  Result:=__StrRead(line.line,line.maxLen) <> nil
end;

function TTextFile.ReadStr: string;
begin
  readln(txt,Result)
end;

function TTextFile.ReadInt: longint;
begin
  readln(txt,Result)
end;

function TTextFile.xStrRead: PChar;
var
  p,q: PChar; l: int;
begin
  Result:=__StrRead(str,Sizeof(str)-1);

  StrCopy(fkey,'');
  StrCopy(fvalue,'');

  if not fNoKey then
  if Result <> nil then
  if StrLen(Result) > 0 then begin
    p:=StrScan(Result,'=');
    if p <> nil then begin
      p[0]:=#0; StrCopy(fkey,Result);
      p[0]:='='; StrCopy(fvalue,@p[1]);

      RStr(fkey); LStr(fvalue);

      if fIs_Point_Comma then begin
        p:=StrScan(fvalue,';');
        if p <> nil then p[0]:=#0
      end;

      p:=fvalue;
      if p[0] = '"' then begin
        l:=Strlen(p);
        if l >= 2 then begin
          q:=StrEnd(p); Dec(q);
          while q > p do begin
            if q^ = ' ' then else
            if q^ = '"' then begin
              q^:=#0; StrCopy(p,@p[1])
            end;

            Dec(q)
          end
        end
      end;

      StrUpper(RStr(LStr(fkey)));
    end
  end
end;

function TTextFile.xStrLine: PChar;
begin
  Result:=nil; StrCopy(str,'');

  while not End_of_file do begin
    if xStrRead <> nil then
    if Strlen(str) > 0 then begin
      Result:=str; Break
    end;          

    if Assigned(fOnEmptyLine) then
    fOnEmptyLine(Self)
  end
end;

function TTextFile.lStrLine: PChar;
begin
  Result:=xStrLine; LStr(str)
end;

function TTextFile.xStrMore: PChar;
begin
  if StrLen(str) > 0 then
    Result:=str
  else
    Result:=xStrLine
end;

function TTextFile.xStrData: PChar;
var
  p: PChar;
begin
  while true do begin
    Result:=xStrLine;
    if Result = nil then Break;
    p:=StrPos(str,'--');
    if p = nil then Break; p[0]:=#0;
    if Strlen(str) > 0 then Break
  end;
end;

function TTextFile.pStrLine: PChar;
var
  p: PChar;
begin
  while true do begin
    Result:=xStrLine;
    fComment:='';

    if Result = nil then Break;
    p:=StrPos(str,'//');
    if p = nil then Break;
    p[0]:=#0; Inc(p,2);
    fComment:=Strpas(LStr(p));
    if str[0] <> #0 then Break
  end;
end;

function TTextFile.cStrLine: PChar;
var
  p: PChar;
begin
  while true do begin
    Result:=xStrLine;
    if Result = nil then Break;
    
    p:=StrPos(str,'--');
    if p = nil then
    p:=StrPos(str,'//');

    if p = nil then Break; p[0]:=#0;
    if str[0] <> #0 then Break
  end;
end;

function TTextFile.xStrTrim: PChar;
begin
  Result:=nil;

  while xStrLine <> nil do begin
    LStr(str); RStr(str);
    if Strlen(str) > 0 then begin
      Result:=str; Break
    end
  end
end;

function TTextFile.pStrTrim: PChar;
begin
  Result:=nil;

  while xStrLine <> nil do
  if pTrunc_comment('/',str) <> nil then
  begin Result:=str; Break end
end;

function TTextFile.xStrTrunc(skip: PChar): PChar;
begin
  Result:=xStrRead; if Result <> nil then
  Result:=Trunc_comment(skip,str)
end;

function TTextFile.lStrTrunc(skip: PChar): PChar;
begin
  Result:=xStrLine; if Result <> nil then
  Result:=Trunc_comment(skip,str)
end;

function TTextFile.xStrBatch(skip: PChar): PChar;
begin
  Result:=nil; if xStrRead <> nil then
  if xTrunc_comment(skip,str) <> nil then
  if StrLen(str) > 0 then Result:=str
end;

function TTextFile.Is_section: Boolean;
var
  p: PChar;
begin
  Result:=false;

  LStr(str);
  if str[0] = '[' then begin
    p:=StrScan(str,']');
    if Assigned(p) then p[0]:=#0;
    p:=str; Inc(p);
    StrCopy(str,p);
    Result:=true
  end
end;

function TTextFile.this_key(fn: PChar): Boolean;
begin
  Result:=StrIComp(fkey,fn) = 0
end;

function TTextFile.x_this_key(fn: PChar): Boolean;
begin
  Result:=this_key(fn);
  if Result then StrCopy(str,fvalue)
end;

function TTextFile.x_this_lkey(fn: PChar; out ind: int): Boolean;
var
  l,v,rc: int; s: TShortstr;
begin
  Result:=false; ind:=0;

  l:=Strlen(fn);
  if Strlen(fkey) > l then
  if StrLIComp(fkey,fn,l) = 0 then begin
    StrCopy(s,@fkey[l]); val(s,v,rc);
    if rc = 0 then begin
      ind:=v; StrCopy(str,fvalue);
      Result:=true
    end
  end
end;

function TTextFile.AsDouble: Double;
begin
  RealToken(str,Result)
end;

function TTextFile.x_key(key: PChar): Boolean;
begin
  Result:=false;
  if StrToken(fkey,str) <> nil then
  Result:=StrIComp(fkey,key) = 0
end;

function TTextFile.x_key_str(key: PChar; val: PChar): Boolean;
begin
  Result:=false; StrCopy(val,'');
  if x_this_key(key) then begin
    StrLCopy(val,str,255); Result:=true
  end
end;

function TTextFile.x_key_strv(key: PChar; val: PChar; MaxLen: int): Boolean;
begin
  Result:=false; StrCopy(val,'');
  if x_this_key(key) then begin
    StrLCopy(val,str,MaxLen); Result:=true
  end
end;

function TTextFile.x_key_str1(key: PChar; val: PChar): Boolean;
var
  p: PChar;
begin
  Result:=x_key_str(key,val);
  if Result then begin LStr(val);
    if val[0] = '"' then begin
      RStr(val); p:=StrScan(@val[1],'"');
      if Assigned(p) and (p[1] = #0) then begin
        p[0]:=#0; StrCopy(val,@val[1])
      end
    end
  end
end;

function TTextFile.x_key_bool(key: PChar; out v: Boolean): Boolean;
var
  i: Integer;
begin
  Result:=false; v:=false;
  if x_key_int(key,i) then begin
    Result:=true; v:=i <> 0
  end
end;

function TTextFile.x_key_int(key: PChar; out v: Integer): Boolean;
begin
  Result:=false; v:=0;
  if x_this_key(key) then begin
    IntToken(str,v); Result:=true
  end
end;

function TTextFile.x_key_code(key: PChar; out v: Integer): Boolean;
begin
  Result:=false; v:=0;
  if x_this_key(key) then begin
    CodeToken(str,v); Result:=true
  end
end;

function TTextFile.x_key_color(key: PChar; out c: uint): Boolean;
var
  s: TShortstr;
begin
  Result:=false; c:=0;
  if x_key_str(key,s) then
  Result:=StrToHex(s,c)
end;

function TTextFile.x_key_int64(key: PChar; out v: Int64): Boolean;
begin
  Result:=false; v:=0;
  if x_this_key(key) then begin
    Int64Token(str,v); Result:=true
  end
end;

function TTextFile.x_key_int2(key: PChar; out v1,v2: Integer): Boolean;
begin
  Result:=false; v1:=0; v2:=0;
  if x_this_key(key) then begin
    IntToken(str,v1); IntToken(str,v2);
    Result:=true
  end
end;

function TTextFile.x_key_double(key: PChar; out v: Double): Boolean;
begin
  Result:=false; v:=0;
  if x_this_key(key) then begin
    RealToken(str,v); Result:=true
  end
end;

function TTextFile.x_key_float(key: PChar; out v: float): Boolean;
var
  d: double;
begin
  Result:=false; v:=0;
  if x_this_key(key) then begin
    if RealToken(str,d) then v:=d;
    Result:=true
  end
end;

function TTextFile.x_key_gauss(key: PChar; out p: TGauss): Boolean;
begin
  p.x:=0; p.y:=0;
  Result:=x_this_key(key);
  if Result then x_Gauss(p)
end;

function TTextFile.x_key_xyz(key: PChar; out v: txyz): Boolean;
begin
  v.x:=0; v.y:=0; v.z:=0;
  Result:=x_this_key(key);
  if Result then x_xyz(v)
end;

function TTextFile.x_key_rgb(key: PChar; out cl: TColorRef): Boolean;
begin
  cl:=0;
  Result:=x_this_key(key);
  if Result then x_rgb(cl)
end;

function TTextFile.x_key_point(key: PChar; out v: TPoint): Boolean;
begin
  Result:=false; v:=Point(0,0);

  if x_this_key(key) then begin
    IntToken(str,v.X);
    IntToken(str,v.Y);
    Result:=true
  end
end;

function TTextFile.x_key_vpoint(key: PChar; out v: VPoint): Boolean;
begin
  v.x:=0; v.y:=0; v.z:=0;
  if x_this_key(key) then begin
    IntToken(str,v.x);
    IntToken(str,v.y);
    IntToken(str,v.z);
    Result:=true
  end
end;

function TTextFile.x_key_Index(fn: PChar;
                               out Ind: Integer): Boolean;
var
  P1,P2: PChar; RC: Integer;
begin
  Result:=false; Ind:=0;
  P1:=@fkey; P2:=StrScan(P1,'_');

  if Assigned(P2) then
  if StrLIComp(P1,fn,P2-P1) = 0 then begin
    val(StrPas(@P2[1]),Ind,RC);
    if RC = 0 then begin
      StrCopy(str,fvalue);
      Result:=true
    end
  end
end;

function TTextFile.x_skip_char(ch: Char): Boolean;
begin
  Result:=false;
  if LStr(str) <> nil then
  if xUpCase(str[0]) = ch then begin
    StrCopy(str,@str[1]); Result:=true
  end
end;

function TTextFile.x_this_str(Str: PChar): Boolean;
var
  t: TShortStr;
begin
  Result:=false;
  if x_str(t) <> nil then
  Result:=StrIComp(t,Str) = 0
end;

function TTextFile.x_str(S: PChar): PChar;
var
  t: TShortStr;
begin
  Result:=nil;
  if S = nil then StrToken(t,str)
  else Result:=StrToken(S,str)
end;

function TTextFile.l_str(S: PChar; sz: Integer): PChar;
var
  t: TShortStr;
begin
  Result:=x_str(t);
  StrLCopy(S,t,sz)
end;

function TTextFile.x_cmd(Cmd: PChar): Boolean;
var
  p1,p2: PChar;
begin
  Result:=false;

  if LStr(str) <> nil then begin
    p1:=@str; p2:=xStrScan(p1,#9' ,');
    if p2 = nil then p2:=StrEnd(p1);

    if p2-p1 = StrLen(Cmd) then
    if StrLIComp(p1,Cmd,p2-p1) = 0 then begin
      if p2[0] <> #0 then p2:=@p2[1];
      StrCopy(str,p2); Result:=true
    end
  end
end;

function TTextFile.x_Int(out i: Integer): Boolean;
begin
  i:=0; Result:=IntToken(str,i)
end;

function TTextFile.x_Hex(out v: int): Boolean;
var
  s: TShortstr; x: int64; rc: int;
begin
  Result:=false; v:=0;
  if x_str(s) <> nil then
  if StrLIComp(s,'0x',2) = 0 then begin
    if StrToHex64(@s[2],x) then begin
      v:=x; Result:=true
    end
  end
  else begin
    val(s,v,rc);
    Result:=rc = 0
  end
end;

function TTextFile.x_Int16(out i: Int16): Boolean;
var
  v: int;
begin
  Result:=false; i:=0;
  if IntToken(str,v) then begin
    i:=v; Result:=true
  end
end;

function TTextFile.x_Int64(out i: Int64): Boolean;
begin
  i:=0; Result:=Int64Token(str,i)
end;

function TTextFile.x_DWord(out v: DWord): Boolean;
begin
  v:=0; Result:=DWordToken(str,v)
end;

function TTextFile.x_Byte(out b: Byte): Boolean;
var
  v: Integer;
begin
  Result:=false; b:=0;
  if IntToken(str,v) then
  begin b:=v; Result:=true end
end;

function TTextFile.x_Word(out w: Word): Boolean;
var
  v: Integer;
begin
  Result:=false;
  w:=0; if IntToken(str,v) then
  begin w:=v; Result:=true end
end;

function TTextFile.x_Code(out code: Integer): Boolean;
begin
  code:=0; Result:=CodeToken(str,code)
end;

function TTextFile.x_Double(out d: Double): Boolean;
begin
  d:=0; Result:=RealToken(str,d)
end;

function TTextFile.x_number(out d: Double): Boolean;
var
  p,q: PChar; rc: int;
begin
  Result:=false; d:=0;

  LStr(str);
  if str[0] <> #0 then begin
    p:=StrScan(str,' ');
    if p = nil then p:=StrScan(str,#9);
    if Assigned(p) then p[0]:=#0;

    q:=StrScan(str,',');
    if Assigned(q) then q[0]:='.';

    val(str,d,rc);
    if rc = 0 then begin
      if p = nil then
        StrCopy(str,'')
      else
        StrCopy(str,p+1);

      Result:=true
    end
  end
end;

function TTextFile.x_Single(out f: Single): Boolean;
var
  v: Double;
begin
  Result:=false; f:=0;
  if RealToken(str,v) then
  if Abs(v) < MaxSingle then begin
    Result:=true; f:=v
  end
end;

function TTextFile.x_Angle(out f: Double): Boolean;
var
  g,l,m,rc: int; k,s: Double;
  p1,p2,p3: PChar; ch,ch1,sep: Char;
  t: TShortStr;
begin
  Result:=false; f:=0;

  if fNoToken then begin
    p1:=StrCopy(t,str); LStr(t)
  end
  else p1:=StrToken(t,str);

  if p1 <> nil then begin

    l:=StrLen(t); k:=1;           

    if l > 0 then
    if fdegType > 0 then begin
      ch:=Upcase(t[l-1]);
      ch1:=Upcase(t[0]);

      if fdegType = 1 then begin
        if ch in ['N','S'] then begin
          if ch = 'S' then k:=-1;
          t[l-1]:=#0;
        end else
        if ch1 in ['N','S'] then begin
          if ch1 = 'S' then k:=-1;
          StrCopy(t,@t[1])
        end
      end else
      if fdegType = 2 then begin
        if ch in ['E','W'] then begin
          if ch = 'W' then k:=-1;
          t[l-1]:=#0;
        end else
        if ch1 in ['E','W'] then begin
          if ch1 = 'W' then k:=-1;
          StrCopy(t,@t[1])
        end 
      end
    end;

    p1:=t; sep:='-';
    
    p2:=StrScan(p1,';');
    if Assigned(p2) then
      sep:=';'
    else begin
      p2:=StrScan(p1,' ');
      if Assigned(p2) then sep:=' '
    end;

    p2:=StrScan(p1,sep);
    if p2 = p1 then p2:=nil;

    if p2 = nil then begin
      p2:=StrScan(p1,#176);
      if Assigned(p2) then
        Result:=DegToken(t,f)
      else begin
        val(t,f,rc);
        if rc = 0 then
          Result:=true
        else
        if t[rc-1] = ',' then begin
          t[rc-1]:='.'; val(t,f,rc);
          Result:=rc = 0
        end
      end
    end
    else begin
      p2[0]:=#0; p2:=@p2[1];
      p3:=StrScan(p2,sep);

      if IntToken(p1,g) then begin

        if p3 <> nil then begin
          p3[0]:=#0; p3:=@p3[1]
        end;

        s:=0; if IntToken(p2,m) then
        if (p3 = nil) or RealToken(p3,s) then begin
          f:=g + m/60 + s/3600; Result:=true
        end
      end
    end;

    f:=f*k
  end
end;

function TTextFile.x_Point(out p: TPoint): Boolean;
begin
  p.X:=0; p.Y:=0;
  Result:=IntToken(str,p.X) and IntToken(str,p.Y)
end;

function TTextFile.x_VPoint(out p: VPoint): Boolean;
begin
  p.x:=0; p.y:=0; p.z:=0;
  Result:=IntToken(str,p.x) and IntToken(str,p.y) and IntToken(str,p.z)
end;                                                                   

function TTextFile.x_Gauss(out g: tgauss): Boolean;
begin
  g.x:=0; g.y:=0;
  Result:=GaussToken(str,g)
end;

function TTextFile.x_Geoid(pps: int; out g: tgauss): Boolean;
begin
  if pps = 0 then Result:=GaussToken(str,g)
  else Result:=x_Angle(g.x) and x_Angle(g.y)
end;

function TTextFile.x_xyz(out v: txyz): Boolean;
begin
  Result:=xyzToken(str,v)
end;

function TTextFile.x_rgb(out cl: TColorRef): Boolean;
begin
  Result:=rgbToken(str,cl)
end;

function TTextFile.x_time(out t: Double): Boolean;
var
  s: TShortstr;
begin
  Result:=false; t:=0;
  if x_str(s) <> nil then
  Result:=sTimeToken(s,t)
end;

function TTextFile.x_date(out dt: Double): Boolean;
var
  s: TShortstr;
begin
  Result:=false; dt:=0;
  if x_str(s) <> nil then
  Result:=DateToken(s,0,dt)
end;

function TTextFile.x_tick(out t: Double): Boolean;
var
  mm,rc: Integer; p: PChar;
  ss: Double; s: TShortstr;
  sgn: bool;
begin
  Result:=false; t:=0;

  if x_str(s) <> nil then begin

    sgn:=false;
    if s[0] = '-' then begin
      sgn:=true; StrCopy(s,@s[1])
    end;

    mm:=0; ss:=0;

    p:=s; val(p,mm,rc);
    if rc = 1 then mm:=-1 else
    if (rc > 0) and (p[rc-1] = ':') then begin
      p:=@p[rc]; val(p,ss,rc);
      if rc <> 0 then ss:=-1
    end;

    if (mm >= 0) and (ss >= 0) then begin
      t:=mm*60 + ss;
      if sgn then t:=-t;
      Result:=true
    end
  end;
end;

function TTextFile.x_Array(P: PDoubles; N: Integer): Boolean;
var
  i: Integer;
begin
  Result:=false;
  for i:=1 to N do
  if x_Double(P[0]) then begin
    Result:=true; P:=@P[1]
  end
  else begin
    Result:=false; Break
  end
end;

function TTextFile.x_Bounds(out lt,rb: TGauss): Boolean;
begin
  Result:=false; lt:=_Gauss(0,0); rb:=lt;

  LStr(str); if str[0] = '(' then
  StrCopy(str,@str[1]);

  if x_Gauss(lt) and x_Gauss(rb) then begin
    LStr(str); if str[0] = ')' then
    StrCopy(str,@str[1]); Result:=true
  end
end;

function TTextFile.get_cmd(Cmd: PChar): Boolean;
var
  p1,p2: PChar;
begin
  Result:=false; StrCopy(cmd,'');

  if LStr(str) <> nil then begin
    p1:=@str; p2:=xStrScan(p1,#9' ,');
    if p2 = nil then p2:=StrEnd(p1);

    StrLCopy(cmd,p1,p2-p1);
    StrCopy(str,p2); Result:=true
  end
end;

function TTextFile.get_Int(out i: Integer): Boolean;
begin
  Result:=false; i:=0;
  if xStrRead <> nil then
  Result:=x_Int(i)
end;

function TTextFile.get_Double(out d: Double): Boolean;
begin
  Result:=false; d:=0;
  if xStrRead <> nil then
  Result:=x_Double(d)
end;

function TTextFile.get_point(out p: TPoint): Boolean;
begin
  Result:=false;
  p.x:=0; p.y:=0;
  if xStrRead <> nil then
  Result:=x_point(p)
end;

function TTextFile.get_Gauss(out g: tgauss): Boolean;
begin
  Result:=false;
  g.x:=0; g.y:=0;
  if xStrRead <> nil then
  Result:=x_Gauss(g)
end;

function TTextFile.get_xyz(out v: txyz): Boolean;
begin
  Result:=false;
  v.x:=0; v.y:=0; v.z:=0;
  if xStrRead <> nil then
  Result:=x_xyz(v)
end;

function TTextFile.get_x_y_z(out x,y,z: Double): Boolean;
var
  v: txyz;
begin
  Result:=false;
  x:=0; y:=0; z:=0;
  if xStrRead <> nil then
  if x_xyz(v) then begin
    x:=v.x; y:=v.y; z:=v.z;
    Result:=true
  end
end;

procedure TTextFile.skip_section;
begin
  while xStrLine <> nil do
  if StrLIComp(str,'[end_',5) = 0 then Break;
end;

constructor TTextOut.Create(Aout: TTextFile; Aproc: TLogProc);
begin
  inherited Create;
  fout:=Aout; fproc:=Aproc
end;

procedure TTextOut.WriteStr(const Str: String);
begin
  if Assigned(fout) then fout.WriteStr(Str);
  if Assigned(fproc) then fproc(Str);
end;

function TTextStream.NextLine: Boolean;
begin
  if fIs_Repeat then begin
    StrCopy(str,fLine);
    fIs_Repeat:=false;
    Result:=true;
  end
  else begin
    Result:=xStrLine <> nil;
    StrCopy(fLine,str)
  end
end;

function TTextStream.Get_Line: PChar;
begin
  Result:=fLine
end;

function TTextStream.LineStr: String;
begin
  Result:=Strpas(fLine)
end;

function TOutStream.NextLine: Boolean;
var
  p: PChar;
begin
  Result:=false;

  while inherited NextLine do
  if Trunc_comment(';',str) <> nil then begin

    p:=StrScan(str,'-');
    if p <> nil then if p[1] = '-' then
    p[0]:=#0;

    if Strlen(str) > 0 then begin
      Result:=true; Break
    end
  end
end;

function TIniStrings.xString(I: Integer): String;
var
  s: String; p: Integer;
begin
  Result:='';

  s:=Strings[I];
  if length(s) > 0 then begin
    p:=System.Pos('=',s);
    if p > 0 then begin
      System.Delete(s,1,p);
      Result:=s
    end
  end
end;

function TIniStrings.xInt64(I: Integer): Int64;
var
  s: String; rc: Integer;
begin
  Result:=0;

  s:=xString(I);
  if length(s) > 0 then begin
    val(s,Result,rc);
    if rc <> 0 then Result:=0
  end
end;

function TIniStrings.str_Value(key: PChar): String;
var
  Ind: Integer;
begin
  Result:=''; Ind:=IndexOfName(key);
  if Ind >= 0 then Result:=xString(Ind)
end;

function TIniStrings.int_Value(key: PChar): Integer;
var
  v: Integer;
begin
  Result:=0;
  if get_int(key,v) then
  Result:=v
end;

function TIniStrings.get_int64(key: PChar; out v: Int64): Boolean;
var
  s: String; rc: Integer;
begin
  Result:=false; v:=0;

  s:=Values[StrPas(key)];
  if length(s) > 0 then begin
    val(s,v,rc); Result:=rc = 0
  end
end;

function TIniStrings.get_int(key: PChar; out v: Integer): Boolean;
var
  s: String; rc: Integer;
begin
  Result:=false; v:=0;

  s:=Values[StrPas(key)];
  if length(s) > 0 then begin
    val(s,v,rc); Result:=rc = 0
  end
end;

function TIniStrings.get_range(key: PChar; min,max: Integer;
                               out v: Integer): Boolean;
var
  t: Integer;
begin
  Result:=false; v:=0;

  if get_int(key,t) then
  if (t >= min) and (t <= max) then
  begin v:=t; Result:=true end
end;

function TIniStrings.get_bool(key: PChar; out v: Boolean): Boolean;
var
  t: Integer;
begin
  Result:=false; v:=false;

  if get_range(key,0,1,t) then begin
    v:=t = 1; Result:=true
  end
end;

procedure TIniStrings.put_int64(key: PChar; v: Int64);
begin
  Add(Strpas(key)+'='+IntToStr(v))
end;

procedure TIniStrings.put_int(key: PChar; v: Integer);
begin
  Add(Strpas(key)+'='+IntToStr(v))
end;

procedure TIniStrings.put_str(key: PChar; const v: String);
begin
  Add(Strpas(key)+'='+v)
end;

constructor TSpaceList.Create(ini: PChar);
var
  nm: TShortStr;
begin
  inherited Create;

  StrCopy(nm,'dmw_env.ini');
  if Assigned(ini) then StrCopy(nm,ini);

  StrWorkPath(fPath,nm);

  if FileExist(fPath) then
  xLoadText(Self,fPath)
end;

function TSpaceList.Get_Space(Dir: PChar): Boolean;
begin
  StrPCopy(Dir,Values[StrPas(BinDir)]);
  Result:=Dir_Exists(Dir)
end;

procedure TSpaceList.Update_Space(Dir: PChar);
var
  i: Integer; S: WideString;
  def: TShortStr;
begin
  i:=IndexOfName(StrPas(BinDir));

  StrDirectory(def,BinDir);
  if xStrThis(Dir,def) then begin
    if i >= 0 then Delete(i);
  end
  else begin
    S:=StrPas(BinDir)+'='+StrPas(Dir);
    if i >= 0 then Strings[i]:=S
    else Add(S)
  end;

  Update
end;

procedure TSpaceList.Update;
begin
  if StrLen(fPath) > 0 then

  if Count = 0 then
    FileErase(fPath)
  else
    SaveToFile(StrPas(fPath))
end;

function StringOf(List: TStrings; Str: PChar): Integer;
var
  i: int; s1,s2: TShortstr;
begin
  Result:=-1;

  StrCopy(s1,Str); xStrUpper(s1);

  for i:=0 to List.Count-1 do begin
    StrPCopy(s2,List[i]);
    xStrUpper(s2);

    if StrComp(s1,s2) = 0 then begin
      Result:=i; Break
    end
  end;
end;

function pack_strings(Text: TStrings): Integer;
var
  i: Integer;
begin
  i:=0; while i < Text.Count do begin
    if ClsString(Text[i]) = '' then
    Text.Delete(i) else Inc(i)
  end;

  Result:=Text.Count
end;

procedure sync_WorkDir;
var
  dir: TShortstr;
begin
  UsrDir(dir,'\WORK');
  if not Dir_Exists(dir) then begin
    UsrDir(dir,'\BIN');
    if not Dir_Exists(dir) then
    StrCopy(dir,BinDir);
  end;

  StrCopy(WorkDir,dir);
  StrCopy(IntfDir,dir);
  AppData_WorkDir;
end;

procedure iniSpaceDir(Ini: PChar);
var
  list: TSpaceList;
  dir: TShortStr;
begin
  list:=TSpaceList.Create(Ini);
  try
    if list.Get_Space(dir) then
    SetSpaceDir(dir)
  finally
    list.Free
  end
end;

procedure SetSpaceDir(Dir: PChar);
begin
  if Dir_Exists(Dir) then begin
    StrCopy(SpaceDir,Dir);
    sync_WorkDir;
  end
end;

procedure Update_SpaceDir(Ini,Dir: PChar);
var
  list: TSpaceList;
  fld: TShortStr;
begin
  StrCopy(fld,Dir);

  if not Dir_Exists(fld) then
  StrDirectory(fld,BinDir);

  SetSpaceDir(fld);

  list:=TSpaceList.Create(Ini);
  try
    list.Update_Space(fld);
  finally
    list.Free
  end
end;

function TextFileCount(Path: PChar): Integer;
var
  txt: TTextFile;
begin
  Result:=0;
  txt:=TTextFile.Create;
  try
    if txt.Open(Path) then
    Result:=txt.LinesCount
  finally
    txt.Free
  end
end;

function StrTranslate(Msg,Def,Path: PChar; Id: Integer): PChar;
var
  txt: TTextFile; i: Integer;
  s: TShortStr; fl: Boolean;
begin
  Result:=StrCopy(Msg,Def);

  if Id > 0 then
  if not rus_interface then begin

    fl:=Is_Comma_Delimiter;
    Is_Comma_Delimiter:=false;

    txt:=TTextFile.Create;
    try
      if txt.Open_bin(Path) then
      while not txt.end_of_file do
      if txt.xStrRead <> nil then
      if IntToken(txt.str,i) then
      if i = Id then begin
        if StrString(s,txt.str) <> nil then
        Result:=StrCopy(Msg,s); Break
      end;
    finally
      txt.Free;
    end;

    Is_Comma_Delimiter:=fl
  end
end;

function xStrTranslate(Msg,Def,Path: PChar;
                       Size,Id: Integer): PChar;
var
  txt: TTextFile; i: Integer;
  fl: Boolean; s: TShortStr;
begin
  Result:=StrCopy(Msg,Def);

  fl:=Is_Comma_Delimiter;
  Is_Comma_Delimiter:=false;

  txt:=TTextFile.Create;
  try
    if not rus_interface then
    if txt.Open_bin(Path) then
    while not txt.end_of_file do
    if txt.xStrRead <> nil then
    if IntToken(txt.str,i) then
    if i = Id then begin
      if StrToken(s,txt.str) <> nil then
      if Def <> nil then StrLCopy(Msg,s,Size)
      else StrLCat(Msg,s,Size); Def:=nil
    end else
    if i > Id then Break;
  finally
    txt.Free;
  end;

  Is_Comma_Delimiter:=fl
end;

function xLoadMessage(Msg,Path: PChar; Id: Integer): PChar;
var
  txt: TTextFile; id_: Integer;
begin
  Result:=nil; StrCopy(Msg,'');

  txt:=TTextFile.Create;
  try
    if txt.Open_bin(Path) then
    while not txt.end_of_file do
    if txt.xStrRead <> nil then
    if IntToken(txt.str,id_) then

    if id_ = Id then begin
      Result:=StrToken(Msg,txt.str);
      Break
    end;
  finally
    txt.Free;
  end
end;

function xLoadStrings(List: TStrings; Path: PChar;
                      from_id,last_id: Integer): Integer;
var
  txt: TTextFile; i: Integer;
  is_comma: Boolean; s: TShortStr;
begin
  is_comma:=Is_Comma_Delimiter;
  Is_Comma_Delimiter:=false;

  txt:=TTextFile.Create;
  try
    if txt.Open_bin(Path) then
    while not txt.end_of_file do
    if txt.Get_Int(i) then

    if i > last_Id then Break else

    if i >= from_Id then begin
      if StrToken(s,txt.str) <> nil then
      List.Add(StrPas(s));
    end;
  finally
    txt.Free;
  end;

  Is_Comma_Delimiter:=is_comma;
  Result:=List.Count
end;

function xLoadText(List: TStrings; Path: PChar): Integer;
var
  txt: TTextFile;
begin
  Result:=0;

  txt:=TTextFile.Create;
  try
    if FileExist(Path) then
    if txt.Open(Path) then
    while not txt.end_of_file do
    if txt.xStrRead <> nil then begin
      List.Add(StrPas(txt.str));
      Inc(Result)
    end;
  finally
    txt.Free;
  end
end;

function xLoadAnsiString(Path: PChar): AnsiString;
var
  s: AnsiString; vm: TReadFile;
begin
  s:='';

  vm:=TReadFile.Create;
  try
    if vm.Open(Path) then
    if vm.Size < 4096*4 then
    s:=StrLPas(PChar(vm.Buf),vm.Size);
  finally
    vm.Free
  end;

  Result:=s;
end;

function StrObjects(Str: PChar; Count: Integer): PChar;
var
  ax: Integer; obj: TShortStr;
begin
  if rus_interface then begin

    StrCopy(obj,'объект');
    if Count = 0 then
      StrCat(obj,'ов')
    else
    if Count > 1 then
    if Count <= 4 then
      StrCat(obj,'а')
    else
      StrCat(obj,'ов')
  end
  else begin
    StrCopy(obj,'object');

    if Count <> 1 then
    StrCopy(obj,'objects')
  end;

  Result:=StrFmt(Str,'%d %s',[Count,obj])
end;

function StrItems(Str: PChar; Count: Integer): PChar;
var
  ax: Integer; obj: TShortStr;
begin
  if rus_interface then begin

    StrCopy(obj,'запись');
    if Count = 0 then
      StrCat(obj,'записей')
    else begin
      ax:=Count mod 10;

      if ax = 0 then
        StrCat(obj,'записей')
      else
      if ax > 1 then

      if ax <= 4 then
        StrCopy(obj,'записи')
      else
        StrCopy(obj,'записей')
    end
  end
  else begin
    StrCopy(obj,'item');

    if Count <> 1 then
    StrCopy(obj,'items')
  end;

  Result:=StrFmt(Str,'%d %s',[Count,obj])
end;

function ObjectsStr(Count: Integer): String;
var
  s: TShortstr;
begin
  Result:=Strpas(StrObjects(s,Count))
end;

function MsgObjects(Str,Msg: PChar; Count: Integer): PChar;
var
  tmp: TShortStr;
begin
  StrObjects(tmp,Count);
  Result:=StrFmt(Str,'%s: %s.',[Msg,tmp]);
end;

function Str_Edit_Msg(Msg,Def,Alt: PChar;
                      Count,Id: Integer): PChar;
var
  obj: TShortStr;
begin
  StrTranslate(Msg,Def,'edit.msg',Id);

  if rus_interface and (Count > 1) then
  StrCat(Msg,Alt); StrCat(Msg,' ');

  StrObjects(obj,Count);
  if str_Update_Index = 1 then
  StrItems(obj,Count);

  StrCat(Msg,obj);

  Result:=StrCat(Msg,'.');
end;

function str_Update_Msg(Msg: PChar; Count: Integer): PChar;
begin
  Result:=Str_Edit_Msg(Msg,'Обработан','о', Count,121);
end;

function str_Found_Msg(Msg: PChar; Count: Integer): PChar;
var
  str: TShortstr;
begin
  StrCopy(str,'Found');
  if rus_interface then StrCopy(str,'Найден');
  Result:=Str_Edit_Msg(Msg,str,'о', Count,0);
end;

function str_Create_Msg(Msg: PChar; Count: Integer): PChar;
var
  str: TShortstr;
begin
  StrCopy(str,'Create');
  if rus_interface then StrCopy(str,'Создан');
  Result:=Str_Edit_Msg(Msg,str,'о', Count,0);
end;

function str_Add_Msg(Msg: PChar; Count: Integer): PChar;
var
  str: TShortstr;
begin
  StrCopy(str,'Add');
  if rus_interface then StrCopy(str,'Добавлен');
  Result:=Str_Edit_Msg(Msg,str,'о', Count,0);
end;

function str_Delete_Msg(Msg: PChar; Count: Integer): PChar;
var
  del: TShortstr;
begin
  StrCopy(del,'Delete');
  if rus_interface then StrCopy(del,'Удален');

  Result:=Str_Edit_Msg(Msg,del,'о', Count,0);
end;

function str_Count_Msg(Msg,Msg1,Msg2,Msg3: PChar;
                       Count: Integer): PChar;
begin
  Result:=StrPCopy(Msg,IntToStr(Count)+' ');

  if Count = 0 then StrCat(Msg,Msg3) else
  if Count = 1 then StrCat(Msg,Msg1) else
  if Count < 5 then StrCat(Msg,Msg2) else
                    StrCat(Msg,Msg3)
end;

function str_Count_Cat(Str,Msg1,Msg2,Msg3: PChar;
                       Count: Integer): PChar;
var
  Msg: TShortstr;
begin
  str_Count_Msg(Msg,Msg1,Msg2,Msg3,Count);
  Result:=StrLCat(Str,Msg,255)
end;

function str_Object_Cat(Str: PChar; Count: int): PChar;
var
  Msg: TShortstr;
begin
  StrLCat(Str,' ',255);

  if rus_interface then
    Result:=str_Count_Cat(Str,'объект','объекта','объектов',Count)
  else begin
    StrFmt(Msg,'%d object',[Count]);
    if Count > 0 then StrCat(Msg,',');
    Result:=StrLCat(Str,Msg,255)
  end
end;

function str_Count_Msg1(Msg,Msg1,Msg2,Msg3: PChar;
                        Count: Integer): PChar;
begin
  Result:=StrPCopy(Msg,IntToStr(Count)+' ');

  Count:=Count mod 100;
  if Count in [10..20] then Count:=0
  else Count:=Count mod 10;

  if Count = 0 then StrCat(Msg,Msg3) else
  if Count = 1 then StrCat(Msg,Msg1) else
  if Count < 5 then StrCat(Msg,Msg2) else
                    StrCat(Msg,Msg3)
end;

function str_Count_Cat1(Str,Msg1,Msg2,Msg3: PChar;
                        Count: Integer): PChar;
var
  Msg: TShortstr;
begin
  str_Count_Msg1(Msg,Msg1,Msg2,Msg3,Count);
  Result:=StrLCat(Str,Msg,255)
end;

function StrMsgCount(Str,Capt: PChar;
                     Msg,Msg1,Msg2,Msg3: PChar;
                     Count: Integer): PChar;
var
  s: TShortstr;
begin
  StrPCopy(s,IntToStr(Count)+' ');
  StrCat(s,Msg);

  Count:=Count mod 100;
  if Count in [10..20] then Count:=0
  else Count:=Count mod 10;

  if Count = 0 then StrCat(s,Msg3) else
  if Count = 1 then StrCat(s,Msg1) else
  if Count < 5 then StrCat(s,Msg2) else
                    StrCat(s,Msg3);

  Result:=StrCopy(Str,Capt);
  StrCat(Str,' '); StrCat(Str,s)
end;

function UsrDir1(Dir,Sub: PChar): bool;
var
  l1,l2: int;
begin
  UsrDir(Dir,Sub);
  Result:=dir_Exists(Dir);
  if not Result then begin
    l1:=Strlen(SpaceDir);
    l2:=Strlen(BinDir); if (l1 >= l2)
    or (StrLIComp(SpaceDir,BinDir,l1) <> 0) then begin
      StrDirectory(Dir,binDir);
      if Sub <> nil then StrCat(Dir,Sub);
      Result:=dir_Exists(Dir);
    end
  end;
end;

function UsrDir(Dir,Sub: PChar): PChar;
begin
  Result:=StrCopy(Dir,SpaceDir);
  if Sub <> nil then begin
    if (Sub[0] <> '\') and
       (Sub[0] <> '/') then
    StrCat(Dir,'\');
    StrCat(Dir,Sub)
  end
end;

function UsrBinDir(Dir: PChar): PChar;
begin
  Result:=UsrDir(Dir,'\BIN');
  if Result <> nil then
  if not Dir_Exists(Dir) then
  StrCopy(Dir,BinDir)
end;

function IniDir(Dir: PChar): PChar;
begin
  Result:=UsrDir(Dir,'\INI');
  if not Dir_Exists(Result) then
  Result:=StrCopy(Dir,WorkDir)
end;

function HlpPath(Path,FName: PChar): PChar;
var
  dir,fn: TShortStr;
begin
  Result:=nil; StrCopy(Path,'');

  StrPath(fn,BinDir,FName);

  if not FileExist(fn) then begin
    StrCat(StrDirectory(dir,BinDir),'\HLP');
    StrPath(fn,dir,fname)
  end;

  if FileExist(fn) then
  Result:=StrCopy(Path,fn)
end;

function hlp_Path(FName: PChar): string;
var
  hlp: TShortStr;
begin
  Result:='';
  if HlpPath(hlp,FName) <> nil then
  Result:=Strpas(hlp)
end;

function StrExeName(Name,Alt: PChar): PChar;
var
  fn: TPathstr;
begin
  GetModuleFileName(0,fn,Sizeof(fn)-1);
  StrNameExt(fn,fn);
  StrUpdateExt(Name,fn,'');

  if Assigned(Alt) then
  StrCat(StrCat(Name,'_'),Alt);
  
  Result:=Name
end;

function StrPath(Path,Dir,Name: PChar): PChar;
var
  len: int; fn: TShortStr;
begin
  StrCopy(fn,'');

  if Dir <> nil then begin
    len:=StrLen(Dir);
    if len > 0 then begin
      StrLCopy(fn,Dir,255);
      if Dir[len-1] <> '\' then
      StrLCat(fn,'\',255)
    end
  end;

  Result:=StrLCopy(Path,StrLCat(fn,Name,255),255)
end;

function StrExist(Path,Dir,Name: PChar): bool;
begin
  StrPath(Path,Dir,Name);
  Result:=FileExist(Path)
end;

function StrWorkPath(Path,Name: PChar): PChar;
begin
  Result:=StrPath(Path,WorkDir,Name)
end;

function StrIntfPath(Path,Name: PChar): PChar;
begin
  Result:=StrPath(Path,IntfDir,Name)
end;

function xStrWorkPath(Path,Name: PChar): PChar;
var
  dir,wrk: TShortstr;
begin
  StrDirectory(dir,BinDir);
  StrPath(wrk,dir,'WORK');
  if not dir_Exists(wrk) then
  StrCopy(wrk,BinDir);
  Result:=StrPath(Path,wrk,Name)
end;

function StrBinPath(Path,Name: PChar): PChar;
begin
  Result:=StrPath(Path,BinDir,Name)
end;

function StrUsrPath(Path,Usr,Name: PChar): PChar;
var
  dir: TShortstr;
begin
  UsrDir(dir,Usr);
  Result:=StrPath(Path,dir,Name)
end;

function StrIniPath(Path,Name: PChar): PChar;
var
  dir: TShortstr;
begin
  IniDir(dir);
  Result:=StrPath(Path,dir,Name)
end;

function StrLangPath(Path,Name: PChar): PChar;
begin
  Result:=StrPath(Path,LangDir,Name)
end;

function StrDatePath(Path,Dir,Ext: PChar): PChar;
var
  nm: TShortstr;
begin
  StrPCopy(nm,xDateName(Sysutils.Date));
  if Assigned(Ext) then StrCat(nm,Ext);
  Result:=StrPath(Path,Dir,nm)
end;

function StrTimePath(Path,Dir,Ext: PChar): PChar;
var
  nm: TShortstr;
begin
  StrPCopy(nm,xDateName(Sysutils.Date)+'_'+
              xTimeName(Sysutils.Time));
  if Assigned(Ext) then StrCat(nm,Ext);
  Result:=StrPath(Path,Dir,nm)
end;

function StrDir(Dest,Dir: PChar): PChar;
begin
  Result:=StrCopy(Dest,'');

  if Dir <> nil then
  if Dir_Exists(Dir) then
  Result:=StrCopy(Dest,Dir)
end;

function StrBinFile(Path,Name: PChar): PChar;
var
  fn: TShortStr;
begin
  Result:=nil; xStrCopy(Path,'');
  if StrPath(fn,BinDir,Name) <> nil then
  if FileExist(fn) then
  Result:=xStrCopy(Path,fn)
end;

function xStrPath(Path,Dir,FName,Ext: PChar): PChar;
var
  fn: TShortStr;
begin
  StrUpdateExt(fn,FName,Ext);
  StrPCopy(fn,xStrNameExt(fn));
  Result:=StrPath(Path,Dir,fn)
end;

function StrExt(Dest,Path: PChar): PChar;
begin
  Result:=StrPCopy(Dest,ExtractFileExt(StrPas(Path)))
end;

function StrNameExt(Dest,Path: PChar): PChar;
begin
  Result:=StrPCopy(Dest,ExtractFileName(StrPas(Path)))
end;

function StrFNameExt(dst: PChar; const FName: WideString): PChar;
var
  fn: TShortStr;
begin
  StrPLCopy(fn,FName,255);
  Result:=StrNameExt(dst,fn)
end;

function StrTruncPath(Dest,Path,Fld: PChar): PChar;
var
  len: int; pc: PChar; dir,fn: TShortstr;
begin
  Result:=StrCopy(Dest,Path);

  if Assigned(fld) then begin
    StrCopy(dir,fld);
    xStrUpper(dir);
    len:=Strlen(dir);

    StrCopy(fn,Path);
    xStrUpper(fn); pc:=@fn[len];

    if pc[0] = '\' then
    if StrLComp(fn,dir,len) = 0 then begin
      pc:=@Path[len+1]; StrCopy(Dest,pc)
    end
  end
end;

function StrDirNameExt(Dest,Path: PChar): PChar;
var
  p,q: PChar;
begin
  Result:=StrLCopy(Dest,Path,255);
  p:=StrScan(Result,':');

  while p <> nil do begin
    StrCopy(Result,@p[1]);

    p:=StrScan(Result,'\');
    if p = nil then Break;
    q:=StrScan(@p[1],'\');
    if q = nil then Break;
  end
end;

function StrCatNameExt(Dest,Path: PChar): PChar;
var
  fn: TShortStr;
begin
  Result:=StrCat(Dest, StrNameExt(fn,Path))
end;

function xStrCatNameExt(Dest,Path: PChar): PChar;
begin
  StrCat(Dest,'"');
  StrCatNameExt(Dest,Path);
  Result:=StrCat(Dest,'"')
end;

function StrFldNameExt(Dest,Path: PChar): PChar;
var
  s,t: TShortstr;
begin
  StrDirectory(t,Path);
  StrNameExt(t,t);

  if Strlen(t) = 0 then
    Result:=StrNameExt(Dest,Path)
  else begin
    StrLCat(t,'\',255);
    StrNameExt(s,Path);
    StrLCat(t,s,255);
    Result:=StrCopy(Dest,t)
  end
end;

function StrDirectory(Dir,Path: PChar): PChar;
var
  fn: TFileName;
begin
  fn:=ExpandFileName(StrPas(Path));
  Result:=StrPCopy(Dir,ExtractFileDir(fn))
end;

function ThisDirectory(Path,Dir: PChar): Boolean;
var
  tmp: TShortStr;
begin
  Result:=false; StrDirectory(tmp,Path);
  if StrComp(tmp,Dir) = 0 then Result:=true
end;

function StrUpdateExt(Dest,Path,Ext: PChar): PChar;
var
  fn: TShortStr;
begin
  Result:=nil; if xStrCopy(fn,Path) <> nil then
  Result:=StrPCopy(Dest,ChangeFileExt(StrPas(fn),StrPas(Ext)))
end;

function StrFNameCapt(Capt,Path: PChar; MaxLen: int): PChar;
var
  p,q: PChar;
begin
  Result:=StrCopy(Capt,Path);

  if StrLen(Capt) > MaxLen then begin
    p:=StrScan(Path,'\');
    if p <> nil then begin

      q:=StrScan(@p[1],'\');
      if q <> nil then begin
        p:=StrScan(Capt,'\');
        if p <> nil then begin
          p[1]:=#0; StrCat(Capt,'...');

          while StrLen(Capt)+StrLen(q) > MaxLen do begin
            p:=StrScan(@q[1],'\'); if p <> nil then
            q:=p else Break
          end;

          StrCat(Capt,q)
        end
      end
    end
  end
end;

function xStrFNameCapt(Capt,Path: PChar; MaxLen: int): PChar;
var
  p,q: PChar;
begin
  p:=Path;

  while Strlen(p) > MaxLen do begin
    q:=StrScan(p,'\'); if q = nil then Break;
    p:=@q[1]
  end;

  if Strlen(p) = Strlen(Path) then
    Result:=StrCopy(Capt,Path)
  else begin
    Result:=StrCopy(Capt,'...\');
    StrLCat(Capt,p,255)
  end
end;

function StrBackupFName(Dest,Path: PChar): PChar;
var
  ext: TShortstr;
begin
  StrPCopy(ext,ExtractFileExt(StrPas(Path)));
  if ext[0] = '.' then StrCopy(ext,@ext[1]);
  StrPCopy(ext,'.~'+Strpas(ext));
  Result:=StrUpdateExt(Dest,Path,ext)
end;

function StrUpdateName(Dest,Path,Name: PChar): PChar;
var
  ext: PChar;
begin
  StrCat(StrDirectory(Dest,Path),'\');
  StrCat(Dest,Name); ext:=StrRScan(Path,'.');
  if ext <> nil then StrCat(Dest,ext);
  Result:=Dest
end;

function StrUpdateFName(Dest,Path,Name: PChar): PChar;
var
  dir: TShortstr;
begin
  StrDirectory(dir,Path);
  Result:=StrPath(Dest,dir,Name)
end;

function StrNextFName(Dest,Path,Alt: PChar): PChar;
var
  fn,temp: TShortstr;
begin
  StrNameExt(fn,Path);
  StrChangeExt(fn,''); StrCat(fn,Alt);
  StrUpdateName(temp,Path,fn);
  Result:=StrCopy(Dest,temp)
end;

function StrNextIndexFName(Dest,Path: PChar): PChar;
var
  i: int; fn,tmp: TShortstr;
begin
  Result:=nil;
  for i:=1 to 999 do begin
    StrFmt(fn,'%d',[i]);
    StrUpdateName(tmp,Path,fn);
    if not FileExist(tmp) then begin
      Result:=StrCopy(Dest,tmp);
      Break
    end
  end
end;

function StrWindowsDirectory(Dir: PChar): PChar;
begin
  Result:=nil; StrCopy(Dir,'');
  if GetWindowsDirectory(Dir,SizeOf(TShortStr)-1) > 0 then
  if Dir_Exists(Dir) then Result:=Dir
end;

function StrFName(dst: PChar; const FName: WideString): PChar;
var
  fn: TShortStr;
begin
  Result:=nil; StrCopy(dst,'');
  if StrPLCopy(fn,FName,255) <> nil then
  if FileExist(fn) then Result:=StrCopy(dst,fn)
end;

function StrFNameCopy(Dst,Src: PChar): PChar;
begin
  Result:=StrCopy(Dst,Src);
  if not FileExist(Dst) then
  Result:=StrCopy(Dst,'')
end;

function xStrUpdateDir(Path,Dir: PChar): PChar;
var
  fn: TShortStr;
begin
  Result:=Path;
  if length(ExtractFilePath(StrPas(Path))) = 0 then
  if StrLen(Dir) > 0 then begin StrCopy(fn,Path);
    StrCopy(Path,Dir); if Dir[StrLen(Dir)-1] <> '\' then
    StrCat(Path,'\'); Result:=StrCat(Path,fn)
  end
end;

function xStrUpdateExt(Path,Ext: PChar): PChar;
var
  tmp: TShortStr;
begin
  Result:=Path; if Path <> nil then
  if length(ExtractFileExt(StrPas(Path))) = 0 then
  if StrUpdateExt(tmp,Path,Ext) <> nil then
  Result:=StrCopy(Path,tmp)
end;

function StrChangeExt(Path,Ext: PChar): PChar;
var
  tmp: TShortStr;
begin
  StrCopy(tmp,Path);
  Result:=StrUpdateExt(Path,tmp,Ext)
end;

function StrChangeDir(Path,Dir: PChar): PChar;
var
  fn: TShortStr;
begin
  StrNameExt(fn,Path);
  Result:=StrPath(Path,Dir,fn)
end;

function StrUpdateDir(Dest,Path,Dir: PChar): PChar;
begin
  StrNameExt(Dest,Path);
  Result:=StrPath(Dest,Dir,Dest)
end;

function StrUpdateDirExt(Dest,Path,Dir,Ext: PChar): PChar;
begin
  StrNameExt(Dest,Path);
  StrUpdateExt(Dest,Dest,Ext);
  Result:=StrPath(Dest,Dir,Dest)
end;

function StrExpand(Path,FName: PChar): PChar;
begin
  Result:=StrPLCopy(Path,ExpandFileName(StrPas(FName)),255)
end;

function StrPageFileName(Dest,Path: PChar;
                         I,J,Len: Integer): PChar;
var
  page,ext: TShortStr;
begin
  StrPCopy( ext,ExtractFileExt(StrPas(Path)) );
  StrPCopy( page,'_'+xIdToStr(I,Len,'0')+'x'+xIdToStr(J,Len,'0') );

  StrUpdateExt(Dest,Path,'');
  StrLCat(StrLCat(Dest,page,255),ext,255);
  Result:=Dest
end;

function StrNextFileName(Dest,Path: PChar; Ind: Integer): PChar;
var
  pg,ext: TShortStr;
begin
  StrPCopy(ext,ExtractFileExt(Path));
  StrPCopy(pg,IntToStr(Ind));

  StrUpdateExt(Dest,Path,'');
  StrLCat(StrLCat(Dest,pg,255),ext,255);
  Result:=Dest
end;

function StrAltFileName(Dest,Path,Alt: PChar): PChar;
var
  ext: TShortStr;
begin
  StrPCopy(ext,ExtractFileExt(Path));

  StrUpdateExt(Dest,Path,'');
  StrLCat(StrLCat(Dest,Alt,255),ext,255);
  Result:=Dest
end;

function StrTempPath(Temp,Path: PChar): PChar;
var
  dir,name: TShortStr; I: Integer;
begin
  Result:=nil; StrCopy(Temp,'');

  StrDirectory(dir,Path);
  for I:=1 to 32 do begin
    StrPCopy(name,IntToStr(I)+'.TMP');
    StrPath(Temp,Dir,Name);

    if not FileExist(Temp) then begin
      Result:=Temp; Break
    end
  end
end;

function StrTempFileName(Path,Prefix: PChar): PChar;
var
  Dir: TShortStr;
begin
  StrCopy(Path,'');
  GetTempPath(SizeOf(Dir)-1,Dir);

  if Strlen(Dir) <= 200 then
  GetTempFileName(Dir,Prefix,0,Path);

  Result:=Path
end;

function wStrTempFileName(Path,Prefix: PChar): PChar;
var
  i: int; fn: TShortStr;
begin
  Result:=nil; StrCopy(Path,'');

  for i:=1 to 8 do
  if StrPath(fn,WorkDir,Prefix) <> nil then
  if StrCat(fn,'.') <> nil then
  if iStrCat(fn,i,true) <> nil then

  if not FileExist(fn) then
  Result:=StrCopy(Path,fn)
end;

function wStrTempFileName1(Path,Prefix: PChar): PChar;
var
  i: int; dir,fn: TShortStr;
begin
  Result:=nil; StrCopy(Path,'');

  if UsrDir(dir,'\WORK') <> nil then
  if Dir_Exists(dir) then

  for i:=1 to 8 do
  if StrPath(fn,dir,Prefix) <> nil then
  if StrCat(fn,'.') <> nil then
  if iStrCat(fn,i,true) <> nil then

  if not FileExist(fn) then
  Result:=StrCopy(Path,fn)
end;

function xStrTempFileName(Path,Prefix: PChar): PChar;
begin
  Result:=nil; StrCopy(Path,'');

  if StrTempFileName(Path,Prefix) <> nil then
  if FileExist(Path) then Result:=Path;

  if Result = nil then
  Result:=wStrTempFileName(Path,Prefix)
end;

function zStrTempFileName(Path,Prefix: PChar): PChar;
begin
  Result:=wStrTempFileName(Path,Prefix);

  if Result = nil then
  if StrTempFileName(Path,Prefix) <> nil then
  if FileExist(Path) then Result:=Path;
end;

procedure xStrTempClear(Prefix,Ext: PChar);
var
  i: Integer; list: TStringList;
  fRec: TSearchRec; Dir,Path,Name: TShortStr;
begin
  list:=TStringList.Create;
  try
    if xStrTempFileName(Path,Prefix) <> nil then
    if StrDirectory(Dir,Path) <> nil then begin

      StrCopy(Path,Dir); StrCat(Path,'\');
      StrCat(Path,Prefix); StrCat(Path,'*');

      if Ext = nil then
        StrCat(Path,'.TMP')
      else
        StrCat(Path,Ext);

      if FindFirst(Path, faArchive, fRec) = 0 then begin
        repeat list.Add(fRec.Name)
        until FindNext(fRec) <> 0;

        FindClose(fRec);
      end;

      for i:=0 to list.Count-1 do
      if StrCopy(Path,Dir) <> nil then
      if StrCat(Path,'\') <> nil then
      if StrPCopy(Name,list[i]) <> nil then
      if StrCat(Path,Name) <> nil then

      if FileReadWrite(Path) then
      FileErase(Path);

    end;
  finally
    list.Free
  end
end;

function xStrThis(Dst,Src: PChar): Boolean;
var
  fn1,fn2: TShortStr;
begin
  Result:=false;
  if Assigned(Dst) and Assigned(Src) then begin
    StrUpper(StrPCopy(fn1,ExpandFileName(StrPas(Dst))));
    StrUpper(StrPCopy(fn2,ExpandFileName(StrPas(Src))));
    if StrComp(fn1,fn2) = 0 then Result:=true
  end
end;

function This_Ext(Path,Ext: PChar): Boolean;
var
  fn: TShortStr;
begin
  Result:=false;
  if Assigned(Path) then begin
    StrPCopy(fn,ExtractFileExt(StrPas(Path)));
    Result:=StrIComp(StrUpper(fn),Ext) = 0
  end
end;

function This_Text(Path,fft: PChar): Boolean;
var
  h: Integer; map: TMapView;
  lines,width,ind,cnt: Integer;
  ch: byte; line: TShortStr;
begin
  Result:=false; xStrCopy(fft,'');

  h:=FileOpen(StrPas(Path),fmOpenRead);
  if h > 0 then begin
    if xReadOnlyFile(h,map) <> nil then begin
      lines:=0; width:=0; StrCopy(line,'');

      ind:=0; cnt:=0;
      while ind < map.size do begin

        ch:=map.p[ind];
        if  ch = 10 then begin
          width:=Max(width,cnt); Inc(lines);
          cnt:=0; if lines >= 1024 then Break
        end else

        if lines = 0 then
        if cnt < 255 then
        if ch <> 13 then begin
          line[cnt]:=Char(map.p[ind]);
          line[cnt+1]:=#0
        end;

        Inc(cnt); Inc(ind)
      end;

      if lines > 0 then
      if width > 0 then
      if width < 255 then begin
        xStrCopy(fft,StrUpper(line));
        Result:=true;
      end;

      xFreeFile(map);
    end;

    FileClose(h)
  end
end;

function xStrNameExt(Path: PChar): string;
var
  fn: TShortStr;
begin
  Result:=StrPas(StrNameExt(fn,Path))
end;

function DriveStr(Path: PChar): string;
var
  s: String;
begin
  s:=StrPas(Path);
  if (length(s) < 2) or (s[2] <> ':') then
  s:=ExpandFileName(s);

  if length(s) > 2 then
  if s[2] = ':' then
    SetLength(s,1)
  else
    s:='';

  Result:=s
end;

function StrDefaultDir(Dir: PChar): PChar;
var
  def: String;
begin
  GetDir(0,def);
  Result:=StrPCopy(Dir,def)
end;

function xNameExtCapt(Capt,Path: PChar): string;
begin
  Result:=StrPas(Capt) +' - '+ xStrNameExt(Path)
end;

function xRenameFile(old,new: PChar): Boolean;
begin
  Result:=RenameFile(StrPas(old),StrPas(new))
end;

function xRenameFileEx(old,new,ext: PChar): Boolean;
var
  fn1,fn2: TShortstr;
begin
  StrUpdateExt(fn1,old,ext);
  StrUpdateExt(fn2,new,ext);
  xRenameFile(fn1,fn2);
end;

function xExtFile(Path,Ext: PChar): Boolean;
var
  tmp: TShortstr;
begin
  Result:=false;
  StrPCopy(tmp,ExtractFileExt(Path));
  if StrIComp(tmp,Ext) = 0 then
    Result:=true
  else begin
    StrUpdateExt(tmp,Path,Ext);
    Result:=xRenameFile(Path,tmp)
  end
end;

function xUsrPath(Path,Sub,Name: PChar): Boolean;
var
  dir: TShortstr;
begin
  Result:=false; UsrDir(dir,Sub);

  if Dir_Exists(dir) then
  if Strlen(Name) > 0 then begin
    StrPath(Path,dir,Name);
    Result:=true
  end
end;

function xAppPath(Path,Sub,Name: PChar): Boolean;
var
  dir: TShortstr;
begin
  Result:=false;
  StrCopy(dir,AppDir);

  if Sub <> nil then begin
    if (Sub[0] <> '\') and
       (Sub[0] <> '/') then
    StrLCat(dir,'\',255);
    StrLCat(dir,Sub,255)
  end;

  StrPath(Path,dir,Name);
  Result:=FileExist(Path)
end;

function xWorkDir(Dir,Sub: PChar): PChar;
begin
  Result:=nil;

  if UsrDir(Dir,Sub) <> nil then
  if Dir_Exists(Dir) then
  Result:=Dir;

  if Result = nil then
  Result:=StrCopy(Dir,WorkDir)
end;

function xWorkPath(Path,Sub,Name: PChar): Boolean;
var
  Dir,fn: TShortStr;
begin
  Result:=false; StrCopy(Path,'');

  if Name <> nil then
  if StrLen(Name) > 0 then begin

    if UsrDir(Dir,Sub) <> nil then
    if Dir_Exists(Dir) then

    if StrPath(Path,Dir,Name) <> nil then
    Result:=FileExist(Path);

    if not Result then
    if StrPath(fn,WorkDir,Name) <> nil then begin

      if StrLen(Path) = 0 then StrCopy(Path,fn);

      if FileExist(fn) then begin
        StrCopy(Path,fn); Result:=true
      end
    end
  end
end;

function xWorkExist(Sub,Name: PChar): Boolean;
var
  Path: TShortStr;
begin
  Result:=xWorkPath(Path,Sub,Name)
end;

function sWorkFile(Path,Sub: PChar; const Name: String): Boolean;
var
  fn: TShortStr;
begin
  Result:=false; StrCopy(Path,'');

  if StrPCopy(fn,Name) <> nil then
  if StrLen(fn) > 0 then

  Result:=xWorkPath(Path,Sub,fn)
end;

function FileExist(Path: PChar): Boolean;
var
  h: THandle;
  FindData: TWin32FindData;
begin
  Result:=false;
  if Assigned(Path) then
  if StrLen(Path) > 0 then
  if Path[0] <> '.' then begin
    h:=FindFirstFile(Path,FindData);
    if h <> INVALID_HANDLE_VALUE then begin
      Windows.FindClose(h);
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      Result:=true
    end
  end
end;

function xFileExist(Path,Ext: PChar): Boolean;
var
  fn: TShortStr;
begin
  StrUpdateExt(fn,Path,Ext);
  Result:=FileExist(fn)
end;

function uFileExist(Path,Usr: PChar): Boolean;
var
  dir,fn: TShortstr;
begin
  Result:=FileExist(Path);
  if not Result then begin
    StrChangeDir(fn,UsrDir(dir,Usr));
    if FileExist(fn) then begin
      StrCopy(Path,fn); Result:=true
    end
  end
end;

function uFileExists(Usr,Name: PChar): Boolean;
var
  fn: TShortstr;
begin
  StrUsrPath(fn,Usr,Name);
  Result:=FileExist(fn)
end;

function FileErase(Path: PChar): Boolean;
var
  loop: Integer;
begin
  Result:=false;
  if Assigned(Path) then
  if StrLen(Path) > 0 then
  if FileExist(Path) then
  for loop:=1 to 2 do
  if DeleteFile(Path) then begin
    Result:=true; Break
  end
end;

function xWorkErase(Name: PChar): Boolean;
var
  fn: TShortstr;
begin
  StrWorkPath(fn,Name);
  Result:=FileErase(fn)
end;

function xFileErase(Path,Ext: PChar): Boolean;
var
  fn: TShortstr;
begin
  Result:=FileErase(StrUpdateExt(fn,Path,Ext))
end;

function xFileSize(Path: PChar): Integer;
var
  fRec: TSearchRec;
begin
  Result:=0;
  if FindFirst(StrPas(Path),faAnyFile,fRec) = 0 then begin
    Result:=fRec.Size; FindClose(fRec)
  end
end;

function xFileCreate(Path: PChar): Integer;
var
  Attr: Integer;
begin
  if FileExist(Path) then begin
    Attr:=FileGetAttr(Path); if Attr <> -1 then
    if Attr and faReadOnly <> 0 then
    FileSetAttr(Path,Attr xor faReadOnly)
  end;

  Result:=FileCreate(StrPas(Path))
end;

function StrExeDescription(Path,Desc: PChar): PChar;

type
  PTransRec = ^TTransRec;
  TTransRec = packed record
    Lang,CharSet: Word; // language code, character set (code page)
  end;

var
  cx,Dummy: uint;
  inf: Pointer; pc: PChar;
  TransRec: PTransRec;
  trans,qu: TShortstr;
begin
  Result:=nil; StrCopy(Desc,'');

  cx:=GetFileVersionInfoSize(Path,Dummy);
  if cx > 0 then begin
    inf:=xGetMem(cx);
    if Assigned(inf) then begin
      GetFileVersionInfo(Path,0,cx,inf);

      VerQueryValue(inf,
                    '\VarFileInfo\Translation',
                    Pointer(TransRec), cx);

      if cx > 0 then begin

        StrFmt(trans,'%4.4x%4.4x',[TransRec.Lang,TransRec.CharSet]);

        StrFmt(qu,'\StringFileInfo\%s\FileDescription',[trans]);

        VerQueryValue(inf,qu,Pointer(pc),cx);

        if (cx > 0) and (cx < 128) then
        Result:=StrCopy(desc,pc)
      end;

      FreeMem(inf)
    end
  end
end;

function winFileSize(Path: PChar): Int64;
var
  frec: TWin32FileAttributeData; sz: TInt64;
begin
  Result:=-1;
  if GetFileAttributesEx(Path,GetFileExInfoStandard,@frec) then begin
    sz.c[0]:=frec.nFileSizeLow;
    sz.c[1]:=frec.nFileSizeHigh;
    Result:=sz.x
  end
end;

function winOpenReadFile(Path: PChar): THandle;
begin
  Result:=CreateFile(Path,GENERIC_READ,
                     FILE_SHARE_READ,nil,OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,0)
end;

function winOpenUpdateFile(Path: PChar): THandle;
begin
  Result:=CreateFile(Path,GENERIC_WRITE,
                     0,nil,OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,0)
end;

function xFileAge(Path: PChar): Double;
var
  ft: Integer;
begin
  Result:=-1; ft:=FileAge(Path);
  if ft > 0 then Result:=FileDateToDateTime(ft)
end;

procedure SetFileUpdateTime(Path: PChar);
var
  hfile: THandle;
  st: TSystemTime;
  ft: TFileTime;
begin
  hfile:=FileOpen(StrPas(Path),fmOpenReadWrite);
  if hfile > 0 then begin

    GetSystemTime(st);
    if SystemTimeToFileTime(st,ft) then
    SetFileTime(hfile,nil,nil,@ft);

    FileClose(hfile);
  end
end;

procedure SetFileCreateTime(Path: PChar; dt: Double);
var
  hfile: THandle;
  st: TSystemTime;
  ft: TFileTime;
begin
  hfile:=FileOpen(StrPas(Path),fmOpenReadWrite);
  if hfile > 0 then begin
    DateTimeToSystemTime(dt,st);
    if SystemTimeToFileTime(st,ft) then
    SetFileTime(hfile,@ft,nil,@ft);

    FileClose(hfile);
  end
end;

function FileReadWrite1(Path: PChar): Boolean;
begin
  Result:=false;
  if FileExist(Path) then begin
    Result:=not FileReadOnly(Path);
    if not Result then
    Result:=FileReadWrite(Path)
  end
end;

function FileReadWrite(Path: PChar): Boolean;
var
  Attr: Integer;
begin
  Result:=false; Attr:=FileGetAttr(Path);
  if Attr <> -1 then if Attr and faReadOnly <> 0 then
  if FileSetAttr(Path,Attr xor faReadOnly) = 0 then
  Attr:=FileGetAttr(Path); if Attr and faReadOnly = 0 then
  Result:=true
end;

function FileReadOnly(Path: PChar): Boolean;
var
  Attr: Integer;
begin
  Attr:=FileGetAttr(Path);
  Result:=Attr and faReadOnly <> 0
end;

function ini_Exists(dst,fn: PChar): Boolean;
var
  tmp: TShortstr;
begin
  Result:=false;
  StrIniPath(tmp,fn);
  if FileExist(tmp) then begin
    if Assigned(dst) then
    StrCopy(dst,tmp);
    Result:=true
  end
end;

function bin_Exists(dst,dll: PChar): Boolean;
var
  fn: TShortStr;
begin
  Result:=false;
  if dst <> nil then StrCopy(dst,'');

  if Assigned(dll) then
  if StrBinPath(fn,dll) <> nil then
  Result:=FileExist(fn);

  if Result then
  if dst <> nil then
  StrCopy(dst,fn)
end;

function tsk_Exists(dst,dll: PChar): Boolean;
var
  fn: TShortStr;
begin
  Result:=false;
  if dst <> nil then StrCopy(dst,'');

  if Assigned(dll) then begin
    if StrUsrPath(fn,'\TASK',dll) <> nil then
    Result:=FileExist(fn);

    if not Result then
    if StrBinPath(fn,dll) <> nil then
    Result:=FileExist(fn)
  end;

  if Result then
  if dst <> nil then
  StrCopy(dst,fn)
end;

function bin_Exec(exe,params: PChar): Boolean;
var
  cmd: TCmdStr;
begin
  Result:=false;
  if bin_Exists(cmd,exe) then begin
    if params <> nil then
    StrCat(StrCat(cmd,' '),params);
    Result:=WinExec(cmd,sw_SHOW) >= 32
  end
end;

function Dir_Enabled(Dir,Def: PChar): PChar;
var
  p: PChar;
begin
  Result:=nil; StrCopy(Dir,Def);

  if StrLen(Dir) > 0 then
  while not Dir_Exists(Dir) do begin
    p:=StrRScan(Dir,'\'); if p = nil then
    begin StrCopy(Dir,''); Break end; p[0]:=#0
  end;

  if StrLen(Dir) > 0 then
  Result:=Dir
end;

function Dir_Exists(Dir: PChar): Boolean;
begin
  Result:=false; if Dir <> nil then
  Result:=DirectoryExists(Strpas(Dir))
end;

function Dir_Create(Dir: PChar): Boolean;
begin
  Result:=Dir_Exists(Dir);
  if not Result then begin
    MkDir(Dir); Result:=Dir_Exists(Dir)
  end
end;

function FolderCreate(Path: PChar): Boolean;
var
  dir: TShortstr;
begin
  Result:=false;

  StrDirectory(dir,Path);

  if Strlen(dir) > 0 then
  if Strlen(dir) < Strlen(Path) then begin

    Result:=Dir_Create(dir);
    if not Result then
    if FolderCreate(dir) then
    Result:=Dir_Create(dir);
  end
end;

function Ch_Dir(Dir: PChar): Boolean;
begin
  ChDir(StrPas(Dir));
  Result:=IOResult = 0
end;

function Remove_Dir(Dir: PChar): Boolean;
var
  files: TStringList; i: Integer;
  p: PChar; up: TShortStr;
begin
  Result:=false;

  StrCopy(up,Dir);
  if StrScan(up,':') = nil then
  StrPCopy(up,ExpandFileName(Strpas(Dir)));

  p:=StrRScan(up,'\');
  if StrScan(up,':') <> nil then
  if p <> nil then begin
    p[0]:=#0; if Ch_Dir(up) then begin

      files:=TStringList.Create;
      try
        StrPath(up,Dir,'*.*');
        Add_Files(up,files);
        for i:=0 to files.Count-1 do
        DeleteFile(files[i]);
      finally
        files.Free
      end;

      Result:=RemoveDir(Strpas(Dir))
    end
  end
end;

function FolderCopyTo(Src,Dest: PChar): int;
var
  i: int; files: TStringList; fn1,fn2,fn: TShortstr;
begin
  Result:=0;

  if Dir_Exists(Src) then
  if Dir_Create(Dest) then begin

    files:=TStringList.Create;
    try
      StrPath(fn,Src,'*.*');
      Add_FNames(fn,files);
      for i:=0 to files.Count-1 do begin
        StrPCopy(fn,files[i]);
        StrPath(fn1,Src,fn);
        StrPath(fn2,Dest,fn);

        if FileCopy(fn1,fn2) then
        Inc(Result)
      end
    finally
      files.Free
    end

  end
end;

function DirCopy(Dir,Str: PChar): PChar;
begin
  Result:=nil; StrCopy(Dir,'');
  if Dir_Exists(Str) then
  Result:=StrCopy(Dir,Str)
end;

function wait_Execute(cmdline: PChar; wait,close,win: Boolean): THandle;
var
  flags: int; p: PChar;
  pi: TProcessInformation;
  si: TStartupInfo;
begin
  Result:=0;
  if cmdline = nil then Exit;

  flags:=0;
  if exec_without_cmd then
    flags:=flags or CREATE_NO_WINDOW
  else begin
    p:=StrScan(cmdline,'/');
    while p <> nil do begin
      if StrLIComp(p,'/nocmd',6) = 0 then
      flags:=flags or CREATE_NO_WINDOW;
      p:=StrScan(@p[1],'/')
    end
  end;

  FillChar(si,Sizeof(si),0);
  if CreateProcess(nil,cmdline,NIL,NIL,false,flags,NIL,NIL,si,pi) then
  begin
    if wait then begin
      WaitForSingleObject(pi.hProcess,INFINITE);

      if close then begin
        CloseHandle(pi.hThread);
        CloseHandle(pi.hProcess);
      end
    end;

    Result:=pi.hProcess
  end
end;

function call_util(cmd,params: PChar): THandle;
var
  exe: TCmdStr;
begin
  Result:=0;
  if bin_Exists(exe,cmd) then begin
    if Assigned(params) then
    StrLCat(StrCat(exe,' '),params,sizeOf(exe)-1);
    Result:=wait_Execute(exe,false)
  end
end;

function exec_tool(exe,params,dir: PChar): int;
var
  pi: TProcessInformation; rc: DWord;
  si: TStartupInfo; cmd: TCmdStr;
begin
  Result:=Int_NAN;

  if FileExist(exe) then begin
    StrCopy(cmd,exe); StrCat(cmd,' ');
    StrLCat(cmd,params,512);

    FillChar(si,Sizeof(si),0);
    if CreateProcess(nil,cmd,NIL,NIL,false,CREATE_NO_WINDOW,NIL,dir,si,pi) then
    begin
      WaitForSingleObject(pi.hProcess,INFINITE);
      if GetExitCodeProcess(pi.hProcess,rc) then
      Result:=rc
    end
  end
end;

procedure shell_execute(Path: PChar);
var
  exe: TCmdStr;
begin
  if FindExecutable(Path,nil,exe) > 32 then
  ShellExecute(0,'open',exe,Path,nil,SW_SHOWNORMAL);
end;

function FileUpdate(Path: PChar; buf: pointer; len: int): Boolean;
var
  h: int;
begin
  Result:=false;
  h:=FileCreate(StrPas(Path));
  if h > 0 then begin
    FileWrite(h,buf^,len); FileClose(h);
    Result:=true;
  end
end;

function FileCopy(src,dst: PChar): Boolean;
var
  vm: TReadFile;
begin
  Result:=CopyFile(src,dst,false);

  if not Result then begin
    vm:=TReadFile.Create;
    try
      if vm.Open(src) then
      Result:=FileUpdate(dst,vm.buf,vm.Size);
    finally
      vm.Free
    end
  end
end;

function xFileCopy(src,dst,ext: PChar): Boolean;
var
  fn1,fn2: TShortstr;
begin
  Result:=false;

  StrUpdateExt(fn1,src,ext);
  StrUpdateExt(fn2,dst,ext);

  if FileExist(fn1) then
  Result:=FileCopy(fn1,fn2)
end;

function FileCopy1(dir1,dir2,name: PChar): Boolean;
var
  fn1,fn2: TShortstr;
begin
  Result:=false;
  StrPath(fn1,dir1,name);
  StrPath(fn2,dir2,name);
  if FileExist(fn1) then
  Result:=FileCopy(fn1,fn2)
end;

function FileCopy2(src,dst: PChar): Boolean;
begin
  Result:=false;
  if FolderCreate(dst) then
  Result:=FileCopy(src,dst)
end;

function FileBackup(Path: PChar): Boolean;
var
  dest,ext: TShortstr;
begin
  StrPCopy(ext,ExtractFileExt(Strpas(Path)));
  if ext[0] = '.' then StrCopy(ext,@ext[1]);
  StrPCopy(ext,'.~'+Strpas(ext));
  StrUpdateExt(dest,Path,ext);
  Result:=FileCopy(Path,dest);
end;

function xFileBackup(Path,Ext: PChar): Boolean;
var
  fn: TShortstr;
begin
  StrUpdateExt(fn,Path,Ext);
  Result:=FileBackup(fn)
end;

procedure _ltrunc(h: Integer);
begin
  _lwrite(h,@h,0)
end;

function _lsize(h: Integer): longint;
begin
  Result:=_llseek(h,0,2); _llseek(h,0,0)
end;

function _lpos(h: Integer): longint;
begin
  Result:=_llseek(h,0,1)
end;

function Disk_Free(Path: PChar): Int64;
var
  drive: Integer; drv: TFileName;
begin
  Result:=0;
  if StrLen(Path) > 0 then begin
    drive:=0; drv:=ExtractFileDrive(Path);
    if length(drv) > 1 then if drv[2] = ':' then
    drive:=ord(UpCase(drv[1]))-ord('A')+1;
    Result:=DiskFree(drive)
  end
end;

function Wait_Free(Path: PChar; Min: Int64): Boolean;
begin
  Result:=Disk_Free(Path) >= Min
end;

function FileOpenExt(Path,Ext: PChar; rw: Boolean): Integer;
var
  fn: TShortStr; mode: Integer;
begin
  if Ext = nil then StrCopy(fn,Path)
  else StrUpdateExt(fn,Path,Ext);

  mode:=fmOpenRead; if rw then
  mode:=fmOpenReadWrite;

  Result:=FileOpen(StrPas(fn),mode);

  if Result <= 0 then if rw then
  Result:=FileCreate(StrPas(fn))
end;

function FileCreateExt(Path,Ext: PChar): Integer;
var
  fn: TShortStr;
begin
  if Ext = nil then StrCopy(fn,Path)
  else StrUpdateExt(fn,Path,Ext);
  Result:=FileCreate(StrPas(fn))
end;

function xFileImage(Path: PChar; size: Integer): Integer;
var
  buf: PBytes; page,len,loc: Integer;
begin
  Result:=0; page:=4096*4;

  buf:=xAllocPtr(page);
  if Assigned(buf) then begin

    Result:=FileCreate(StrPas(Path));
    if Result > 0 then begin
      len:=0; while len < size do begin
        loc:=Min(page,size-len); Inc(len,loc);
        FileWrite(Result,buf^,loc)
      end
    end
  end; xFreePtr(buf)
end;

function xFileRead(h, buf,size: Integer): Integer;
var
  p: pointer;
begin
  p:=GlobalLock(buf);
  Result:=FileRead(h,p^,size)
end;

function xFileDump(Path: PChar; var buf; len: int): Boolean;
var
  h: int;
begin
  Result:=false;
  h:=FileCreate(StrPas(Path));
  if h > 0 then begin
    FileWrite(h,buf,len); FileClose(h);
    Result:=true
  end;
end;

procedure dump_wstr(dest,temp: PChar; const S: WideString);
var
  f: THandle; fn: TShortstr;
begin
  if dest = nil then
  dest:=StrWorkPath(fn,temp);

  f:=FileCreate(dest);
  if f <> 0 then begin
    FileWrite(f,PWideChar(S)^,Length(S)*2);
    FileClose(f)
  end
end;

function IsHtmlText(Path: PChar): Boolean;
var
  vm: TReadFile;
begin
  Result:=false;

  vm:=TReadFile.Create;
  try
    if vm.Open(Path) then
    if vm.Size >= 6 then
    Result:=StrLComp(@vm.Buf[0],'<html>',6) = 0
  finally
    vm.Free
  end;
end;

function magic_FileRead(Path,Magic: PChar;
                        var buf; len: Integer): Boolean;
var
  vm: TReadFile; mag: Longint;
begin
  Result:=false;
  Fillchar(buf,Sizeof(buf),0);

  Move(Magic[0],mag,4);

  vm:=TReadFile.Create;
  try
    if vm.Open(Path) then
    if vm.Size = 4+len then
    if vm.Get_long(0) = mag then begin
      vm.Load(4,buf,len); Result:=true
    end;
  finally
    vm.Free
  end;
end;

function magic_FileWrite(Path,Magic: PChar;
                         var buf; len: Integer): Boolean;
var
  h: Integer;
begin
  Result:=false;
  h:=FileCreate(Strpas(Path));
  if h > 0 then begin
    FileWrite(h,Magic[0],4);
    FileWrite(h,buf,len); FileClose(h);
    Result:=true
  end
end;

function xCopyFrom(Dst: PChar; Src: Integer): longint;
var
  f1: THandleStream;
  f2: TFileStream;
begin
  Result:=0;

  if Src > 0 then begin
    f1:=THandleStream.Create(Src);
    try

      f2:=TFileStream.Create(StrPas(Dst),fmCreate);
      try
        if f2.Handle > 0 then
        Result:=f2.CopyFrom(f1,0);
      finally
        f2.Free
      end;

    finally
      f1.Free
    end;
  end
end;

function xDropFiles(hDrop: THandle; InClient: Boolean): TStringList;
var
  Point: TPoint; i,n: Integer; fn: TShortStr;
begin
  Result:=nil;

  if InClient then
{$IFNDEF FPC}
  if not DragQueryPoint(hDrop,Point) then Exit;
{$ELSE}
  if not DragQueryPoint(hDrop,@Point) then Exit;
{$ENDIF}

  n:=DragQueryFile(hDrop,$FFFFFFFF,Nil,0);

  if n > 0 then begin
    Result:=TStringList.Create;

    for i:=0 to n-1 do begin
      DragQueryFile(hDrop,i,fn,SizeOf(fn)-1);

      if StrLen(fn) > 0 then
      Result.Add(StrPas(fn))
    end
  end;

  DragFinish(hDrop)
end;

function Get_Folders(Dir: PChar; Items: TStrings): int;
var
  fRec: TSearchRec; mask: TShortstr;
begin
  Result:=0;

  if Assigned(Items) then begin
    Items.BeginUpdate; Items.Clear
  end;

  StrPath(mask,Dir,'*.*');
  if FindFirst(mask,faDirectory,fRec) = 0 then begin

    repeat
      if fRec.Attr and faDirectory <> 0 then

      if fRec.Name[1] <> '.' then begin
        Inc(Result); if Assigned(Items) then
        Items.Add( UpperCase(ExtractFileName(fRec.Name)) )
      end
    until FindNext(fRec) <> 0;

    FindClose(fRec)
  end;

  if Assigned(Items) then Items.EndUpdate;
end;

function Backup_data(Mask,Alt: PChar; bak: Boolean): Integer;
var
  fRec: TSearchRec;
  dir,fn,fn1,nm: TShortstr;
begin
  Result:=0;

  StrDirectory(dir,Mask); StrCat(dir,'\');

  if FindFirst(mask,faArchive,fRec) = 0 then begin

    repeat
      StrCopy(fn,dir);
      StrCat(fn,StrPCopy(nm,FRec.Name));
      StrNextFName(fn1,fn,Alt);

      if bak then
        FileCopy(fn,fn1)
      else
      if FileCopy(fn1,fn) then
      FileErase(fn1);

    until FindNext(FRec) <> 0;

    FindClose(fRec)
  end
end;

function Add_Files(Mask: PChar; Items: TStrings): int;
var
  fRec: TSearchRec; dir,fn,nm: TShortstr;
begin
  Result:=0;

  if Assigned(Items) then Items.BeginUpdate;

  StrDirectory(dir,Mask); StrCat(dir,'\');

  if FindFirst(mask,faArchive,fRec) = 0 then begin

    repeat Inc(Result);

      if Assigned(Items) then begin
        StrCopy(fn,dir);
        StrCat(fn,StrPCopy(nm,FRec.Name));
        Items.Add(Strpas(fn))
      end

    until FindNext(FRec) <> 0;

    FindClose(fRec)
  end;

  if Assigned(Items) then Items.EndUpdate;
end;

function Get_Files(Dir,Mask: PChar; Items: TStrings): int;
var
  fn: TShortstr;
begin
  Result:=Add_Files(StrPath(fn,Dir,Mask),Items)
end;

function StrFrstFile(Dest,Mask: PChar): Integer;
var
  fRec: TSearchRec; dir,fn,nm: TShortstr;
begin
  Result:=0; StrCopy(fn,'');

  if FindFirst(Mask,faArchive,fRec) = 0 then begin

    StrDirectory(dir,Mask);
    repeat
      if Result = 0 then begin
        StrPCopy(nm,fRec.Name);
        StrPath(fn,dir,nm)
      end; Inc(Result)
    until FindNext(FRec) <> 0;

    FindClose(fRec)
  end;

  StrCopy(Dest,fn)
end;

function Add_FNames(Mask: PChar; Items: TStrings): int;
var
  fRec: TSearchRec;
begin
  Result:=0;

  if Assigned(Items) then Items.BeginUpdate;

  if FindFirst(mask,faArchive,fRec) = 0 then begin

    repeat Inc(Result); if Assigned(Items) then
      Items.Add( UpperCase(ExtractFileName(FRec.Name)) )
    until FindNext(FRec) <> 0;

    FindClose(fRec)
  end;

  if Assigned(Items) then Items.EndUpdate;
end;

function Get_FNames(Mask: PChar; Items: TStrings): int;
begin
  if Assigned(Items) then Items.Clear;
  Result:=Add_FNames(Mask,Items)
end;

function Scan_Files(Dir,Mask: PChar; Items: TStrings): int;

procedure scan_fld(Dir,Mask: PChar; Items: TStrings; Lev: int);
var
  FRec: TSearchRec;
  fn,fname: TShortstr;
begin
  if Strlen(Dir) > 0 then

  if Lev < 32 then begin
    StrLCopy(fn,Dir,255);

    StrLCat(fn,'\',255);

    if Mask = nil then
      StrLCat(fn,'*.*',255)
    else
      StrLCat(fn,Mask,255);

    if FindFirst(fn,faArchive,FRec) = 0 then begin
      repeat
        StrPLCopy(fname,FRec.Name,255);

        if Strlen(fname) > 0 then
        if fname[0] <> '.' then begin

          StrLCopy(fn,Dir,255);
          StrLCat(fn,'\',255);
          StrLCat(fn,fname,255);

          if FRec.Attr and faArchive <> 0 then
          Items.Add(Strpas(fn))
        end;
      until FindNext(FRec) <> 0;

      FindClose(FRec)
    end;

    StrPath(fn,Dir,'*.*');
    if FindFirst(fn,faDirectory,FRec) = 0 then begin
      repeat
        StrPLCopy(fname,FRec.Name,255);

        if Strlen(fname) > 0 then
        if fname[0] <> '.' then begin

          StrLCopy(fn,Dir,255);
          StrLCat(fn,'\',255);
          StrLCat(fn,fname,255);

          if FRec.Attr and faDirectory <> 0 then
            scan_fld(fn,Mask,Items,Lev+1)
        end;
      until FindNext(FRec) <> 0;

      FindClose(FRec)
    end
  end
end;

var
  bx: Integer; fld: TShortstr;
begin
  Items.Clear;

  StrLCopy(fld,Dir,255);
  bx:=Strlen(fld)-1; if bx >= 0 then
  if fld[bx] = '\' then fld[bx]:=#0;

  scan_fld(fld,Mask,Items,0);
  Result:=Items.Count
end;

function Erase_FNames(Mask: PChar): Integer;
var
  Files: TStringList;
  i: Integer; dir,fn: TShortstr;
begin
  Result:=0;

  Files:=TStringList.Create;
  try
    StrDirectory(dir,Mask);
    Result:=Add_FNames(Mask,Files);

    for i:=0 to Files.Count-1 do
    if StrPCopy(fn,Files[i]) <> nil then
    if StrPath(fn,dir,fn) <> nil then
    if FileErase(fn) then Inc(Result);

  finally
    Files.Free
  end
end;

function Erase_Work_FNames(Mask: PChar): Integer;
var
  tmp: TShortstr;
begin
  StrPath(tmp,WorkDir,Mask);
  Erase_FNames(tmp);
end;

function xGetComObject(dll: THandle;
                       const CLSID, IID: TGUID;
                       var Obj): Boolean;
type
  TGetObject = function(const CLSID, IID: TGUID; var Obj): HResult; stdcall;
var
  GetObject: TGetObject;
  Factory: IClassFactory;
begin
  Result:=false; TPointer(Obj):=0;

  if dll >= 32 then begin
    @GetObject:=GetProcAddress(dll,'DllGetClassObject');
    if Assigned(GetObject) then begin
      if GetObject(CLSID,IClassFactory,Factory) = S_OK then
      Result:=Factory.CreateInstance(nil,IID,Obj) = S_OK;
      Factory:=nil
    end
  end
end;

function GetComObject(dll: PChar;
                      const CLSID, IID: TGUID;
                      var Obj): THandle;
begin
  Result:=LoadLibrary(dll); TPointer(Obj):=0;

  if Result >= 32 then
  if not xGetComObject(Result,CLSID,IID,Obj) then begin
    FreeLibrary(Result); Result:=0
  end
end;

function xFreeLibrary(hLib: THandle): THandle;
begin
  if hLib >= 32 then FreeLibrary(hLib);
  Result:=0
end;

function wFreeLibrary(hLib: THandle): THandle;
begin
  if hLib >= 32 then begin
    reset_dll_app_handle(hLib);
    FreeLibrary(hLib);
  end; Result:=0
end;

function StrFromText(buf: PChar; size: Integer;
                     Text: TStrings): PChar;
var
  dst: PChar; i,len: Integer; s: string;
begin
  Result:=nil; StrCopy(buf,'');
  dst:=buf;

  for i:=0 to Text.Count-1 do begin
    s:=Text[i]; len:=length(s);
    if len+1 < size then begin

      if i > 0 then begin
        dst[0]:=#10; dst:=@dst[1]
      end;

      Move(s[1],dst[0],len);
      dst[len]:=#0; dst:=@dst[len]
    end
  end;

  if dst <> buf then
  Result:=buf
end;

function StrToText(Text: TStrings;
                   const Str: PChar;
                   Ind,Max: Integer): Integer;
var
  I,Len: Integer;
  P,Q: PChar; It: TShortStr;
begin
  P:=Str; I:=0;
  while P <> nil do begin

    Q:=StrScan(P,#10);
    if Q = nil then Q:=StrScan(P,#13);

    if Q <> nil then Len:=Q-P
    else Len:=StrLen(P);

    StrCopy(It,'');
    if Len > 0 then
    StrLCopy(It,P,Len);

    if I >= Ind then
    Text.Add(StrPas(It));

    Inc(I); if Max > 0 then
    if (I-Ind) = Max then Break;

    if Q = nil then Break
    else P:=@Q[1]
  end;

  Result:=Text.Count
end;

procedure reset_dll_app_handle(dll: THandle);
type
  tproc = procedure(Wnd: HWnd); stdcall;
var
  proc: tproc;
begin
  if dll >= 32 then
  if not IsLibrary then
  if Assigned(GetAppWnd) then
  if GetAppWnd <> 0 then begin
    @proc:=GetProcAddress(dll,'dll_app_handle');
    if Assigned(proc) then Proc(0)
  end
end;

procedure set_dll_app_handle(dll: THandle);
type
  tproc = procedure(Wnd: HWnd); stdcall;
var
  proc: tproc; Wnd: HWnd;
begin
  if dll >= 32 then
  if not IsOcx then
  if not IsLibrary then
  if Assigned(GetAppWnd) then begin
    Wnd:=GetAppWnd;

    if Wnd <> 0 then begin
      @proc:=GetProcAddress(dll,'dll_app_handle');
      if Assigned(proc) then Proc(Wnd)
    end
  end
end;

procedure set_dll_app_help(dll: THandle; hlp: PChar);
type
  tproc = procedure(Help: PChar); stdcall;
var
  proc: tproc; fn: TShortstr;
begin
  if dll >= 32 then begin
    set_dll_app_handle(dll);

    if HlpPath(fn,hlp) <> nil then begin
      @Proc:=GetProcAddress(dll,'dll_app_help');
      if Assigned(Proc) then Proc(fn)
    end
  end
end;

procedure set_dll_intf_dir(dll: THandle);
type
  tfunc = function(Dir: PChar): PChar; stdcall;
var
  func: tfunc;
begin
  if dll >= 32 then begin
    @func:=GetProcAddress(dll,'SetIntfDir');
    if Assigned(func) then func(IntfDir)
  end
end;

procedure set_dll_env_dir(dll: THandle);
type
  tproc = procedure(env: PChar); stdcall;
var
  proc: tproc;
begin
  if dll >= 32 then begin
    @proc:=GetProcAddress(dll,'iniSpaceDir');
    if Assigned(proc) then proc(env_ini)
  end
end;

procedure set_dll_space_dir(dll: THandle);
type
  tproc = procedure(dir: PChar); stdcall;
var
  proc: tproc;
begin
  if dll >= 32 then begin
    @proc:=GetProcAddress(dll,'SetSpaceDir');
    if Assigned(proc) then proc(SpaceDir)
  end
end;

function txt_Copy(src,dst: PChar): Integer;
var
  _src,_dst: TTextFile;
begin
  Result:=0;

  _src:=TTextFile.Create;
  try
    if _src.Open(src) then begin

      _dst:=TTextFile.Create;
      try
        if _dst.Make(dst) then

        while not _src.End_of_file do
        if _src.xStrRead <> nil then begin
          _dst.WriteStr(StrPas(_src.str));
          Inc(Result)
        end;

      finally
        _dst.Free
      end

    end;
  finally
    _src.Free
  end
end;

procedure dump_stat(Dest: PChar;
                    stat: PIntegers;
                    n1,n2: int);
var
  txt: TTextfile; i: int; ip: PIntegers;
begin
  txt:=TTextfile.Create;
  try
    if txt.Make_work(Dest) then begin

      ip:=stat;
      for i:=0 to n1-1 do begin
        if ip[0] > 0 then
        txt.WriteStr(Format('dt%d=%dms',[i+1,ip[0]]));
        ip:=@ip[1]
      end;

      if n2 > 0 then begin
        txt.WriteStr('');

        for i:=0 to n2-1 do begin
          if ip[0] > 0 then
          txt.WriteStr(Format('v%d=%d',[i+1,ip[0]]));
          ip:=@ip[1]
        end
      end
    end
  finally
    txt.Free
  end
end;

function GetAviStartTime(Path: PChar; out t,dt: int): Boolean;
var
  txt: TTextfile;
begin
  Result:=false; t:=0; dt:=0;

  txt:=TTextfile.Create;
  try
    if txt.Open_ext(Path,'.dt') then
    if txt.xStrLine <> nil then
    if txt.x_Int(t) then begin
      txt.x_Int(dt); Result:=true
    end
  finally
    txt.Free
  end
end;

procedure PutAviStartTime(Path: PChar; dt: int);
var
  txt: TTextfile;
begin
  txt:=TTextfile.Create;
  try
    if Strlen(Path) > 0 then
    if txt.Make_ext(Path,'.dt') then
    txt.WriteStr(IntToStr(dt));
  finally
    txt.Free
  end
end;

procedure Init;
var
  l: int; dir,fn: TPathStr;
begin
  @GetAppWnd:=nil;
  exec_without_cmd:=false;

  StrCopy(env_ini,'dmw_env.ini');

  GetModuleFileName(hInstance,fn,Sizeof(fn)-1);

  if IsLibrary then begin
  end;

  StrDirectory(dir,fn);

  StrDirectory(AppDir,dir);

  StrCopy(IntfDir,'');
  Change_BinDir(dir);

  if bin_Exists(nil,'cubaRus.ver') then
    rus_interface:=false
  else
  if bin_Exists(nil,'english.ver') then begin
    rus_interface:=false;
    ver_english:=true
  end;

  ver_cuba:=bin_Exists(nil,'cuba.ver');
  ver_indian:=bin_Exists(nil,'ind.ver');

  txt_english:=bin_Exists(nil,'english.txt')
end;

begin
  Init
end.
