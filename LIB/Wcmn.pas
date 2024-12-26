unit Wcmn;

{$MODE Delphi}

 interface
(*
{$DEFINE VALERRORMSG}
*)
uses
  LCLIntf, LCLType, SysUtils, Forms, IniFiles, Classes, Grids, StdCtrls, ComCtrls,
  Menus, CheckLst, RichMemo, LConvEncoding, windows;

const
  wcmn_secs_in_day = 86400;
  wcmn_mmpi = 25.4;//мм в дюйме

type
  t_vartype = (tvt_integer, tvt_real, tvt_string);

const
  TellTitle: string = '';//можно устанавливать - Title: 1 "t"!
  TmpDirDefault = 'C:\';

const
  E_OutOfMemory       = 1; {malloc, ... in listx, arrayx, ...}
  E_FileCreate        = 10;


const
  _EOL_ = #13#10;
  {MaxStrLen = MaxInt;}

  bool_str: array[0..1]of pchar = ('false','true');
  bool_names: array[0..1]of pchar = ('FALSE','TRUE');

type
   tset_bytes = set of byte;

   PObject = ^TObject; //use in TCmpProc!

   {
     Log.W(lMIN,...)-самая редкая запись.
     Log.MinLevel:=lMIN-печатать все.
   }
   TLevel = (lMIN, lLOW, lNORMAL, lHIGH, lMAX);

   Long = LongInt;
   plong = ^longint;
   psing = ^single;
   ppsing = ^psing;
   pword  = ^word;//word=2*byte

   Bool = Boolean;
   PString = ^String;

//   TRel = real; //arrayx.pas
   TRel = double; //arrayx.pas
   float = single; //=OTypes.pas

   PPoint = ^TPoint; {int x,y}

   rpoint = record x,y: TRel; end;
   prpoint = ^rpoint;


   TChars = array [0..255] of Char;
   TCharsBuf = array [0..2047] of Char;
   {PChars = ^TChars;}

   TName = TChars;
   TMsgS = array [0..79] of Char; {TMsg: конфликт с windows.pas}


type
  TIni = class(TIniFile) //имя "Name" использовать нельзя! (WForm,RForm)
    private
      FSection: string; {current}
    public
    constructor Create0(IniPath: string);//БЕЗ ЗАМЕН!
    constructor Create; overload;//by ExeName (uses Definitions)
    //aPath='' == Create;
    //Для DLL: Указать aPath С РАСШИРЕНИЕМ(!):
    //uses Definitions, aPath.EXT! --- FOR DLL.INI:
    constructor Create(aPath: string); overload;
    destructor Destroy; override;

    function GetIniDir: string;//uses Definitions, m.b.''
    function GetIniPath(aPath: string): string;//uses Definitions, GetIniDir, aPath.EXT(!!!)

    procedure MyClearSection(id: string);
    procedure MyWriteSectionValues(id: string; sl: TStrings{...=...});

    function RS(id, defv: string): string;
    procedure WS(id, v: string);
    function RI(id: string; defv: Long): Long;
    function RI2(id: string; defv,minv,maxv: Long): Long;
    function RR(id: string; defv: real): real;
    procedure WI(id: string; v: Long);
    procedure WR(id: string; v: real);
    function RB(id: string; defv: Bool): Bool;
    procedure WB(id: string; v: Bool);

    procedure WForm0(F: TForm; aSection: string);
    procedure RForm0(F: TForm; aSection: string);
    procedure WForm(F: TForm);
    procedure RForm(F: TForm);

    procedure WCheckList(F: TForm; CL: TCheckListBox);//список с галочками, меняет Section!
    procedure RCheckList(F: TForm; CL: TCheckListBox);//список с галочками, меняет Section!

    //заголовок столбца = ширина столбца:
    procedure WGridColumns(G: TStringGrid; aSection: string);//MyClearSection
    procedure RGridColumns(G: TStringGrid; aSection: string);

    property Section: string read FSection write FSection;
  end;

var
  Ini: TIni;
  Inidll : TIni;//For DLL: Inidll := TIni.Create(ExeDir+'dll_mss.ini');

//SHELL:
function wcmn_show_file(path: string): boolean;//вызов WIN-SHELL по STD-EXT (по расширению!!!!!!!!!!!)

//сравнение:
//arg1>arg2 => 1; arg1<arg2 => -1; arg1=arg2 => 0
function wcmn_cmp_int(i1,i2: integer): integer;
function wcmn_cmp_str(s1,s2: string): integer;

//принадлежность:
function set_bytes_contains1(s: tset_bytes; ba: array of byte): boolean;//s содержит хотя бы один эл-т из ba


/////////////////////////////////////////////////////////////

{ language: }

var telllist: TStringList;//список для Tell (для перевода), меняется из Ini\TellLib in wcmn_language_telllist

//формируется в wcmn_language_test:
// <>'' - критерий "другого языка"
const wcmn_language_file_name: string = '';

//aIniFileName='' => Application.ExeName+'.MSG':
// параметр /t + aIniFileName существует => wcmn_language_file_name<>''
function wcmn_language_test(aIniFileName: string): boolean;

//загрузка другого языка для "Tell":
//if aTellList=nil ,то заменяется wcmn.telllist из секции "TellLib":
//if aTellList<>nil ,то заменяется aTellList из секции "Tell":
procedure wcmn_language_telllist(aTellList: TStringList);

//загрузка другого языка в эл-ты формы:
//вызывать после Application.CreateForm if wcmn_language_test (файл wcmn_language_file_name должен быть доступен!):
//все эл-ты формы - в секции [aForm.Name] (см. пример \MSW\msw.msg):
procedure wcmn_language_form(aForm: TForm);


{ OBJECTS: }

procedure wcmn_list_scroll_to_end(LV: TListView);

//with children, if they exist:
procedure GroupBoxEnabled(gp: TGroupBox; aEnabled: boolean);

function  ObjAssigned(obj: TObject): boolean;
procedure ObjCpy(var dest, src: TObject);

procedure ObjFree(var obj: TObject);//=>Obj:=nil
//procedure ObjFree(var obj: TObject);//=>Obj:=nil

function IndexOf_ObjInList(List: TStrings; Obj: TObject): Integer;
function IndexOf_ObjInGrid(Grid: TStringGrid; Obj: TObject): Integer;
procedure SetComboIndex(Box: TComboBox; i: Integer);

{ CMN: }

function polynom1(a,b,x: Extended): Extended;
function polynom2(a,b,c,x: Extended): Extended;
function polynom3(a,b,c,d,x: Extended): Extended;
//RETURN: кол-во корней (-1,0,1; -1 - бесконечное мн-во):
function equation1(a,b: Extended; var x: Extended): integer;
//RETURN: кол-во корней (-1,0,1,2; -1 - бесконечное мн-во):
function equation2(a,b,c: Extended; var x1,x2: Extended): integer;

//вычисление коэф-ов параболы:
//z(0)=z0, z(1)=z1, sag=(z0+z1)/2-z(0.5) - "провис" в середине:
procedure parabola_abc(z0,sag,z1: double; out a,b,c: double);

function bool2int(b: boolean): Integer; {0/1}
function int2bool(i: Integer): boolean; {0->false}

function wcmn_time1: string;//ДАТА И ВРЕМЯ: yyyy.mm.dd hh:nn:ss
function DateTime_s: string;//dd mmm hh:nn:ss
function DateTime_sDate(aDateTime: TDateTime): string;//dd.mm.yyyy

function ToRange(var v; const minv, maxv: Long): Long;
function sumi(n: array of Long): Long;

function min(a,b: real): real;
function max(a,b: real): real;
function mini(a,b: long): long;
function maxi(a,b: long): long;

//function wcmn_Exec(cmdline: string): boolean;
function run(cmd: string; wait: boolean): boolean;
function wcmn_Exec2(cmdline: string; _wait: boolean): boolean;//wait:=true

procedure SuspendApplication;
procedure SetDefCursor;
procedure SetWaitCursor;

function wcmn_dll_open(dll_name: string): THandle; {0-error}
procedure wcmn_dll_close(Hdll: THandle);
function wcmn_dll_getproc(Hdll: THandle; proc_name: string): TFarProc; {nil-error}


function wcmn_GetEnv(name: string): string;

{ MEMORY: }

{Память обнуляется:}
function malloc(size: Integer): PChar{pointer};
function mrealloc(p0: pointer; size0, size1: Integer): PChar{pointer};
{Можно подавать nil:}
procedure mfree(var p{: pointer}; size: Integer);
procedure mfree2(var p{: pointer});

{области могут перекрываться:}
procedure memcpy(dest, sourc: pchar; count: integer);
function memcmp(p1, p2: pchar; count: integer): integer;

{ STRING: }

{Delphi2009:}
function _StrPas(p: PChar): string; //Delphi2009 требует PAnsiChar

function wcmn_dos2win(s: string): string;//см. dos_win_code.pas!
function wcmn_win2dos(s: string): string;

procedure wcmn_richedit_dos2win(Page: TRichMemo);
procedure wcmn_memo_dos2win(Page: TMemo);

function wcmn_UTF2System(s: string): string;
function wcmn_System2UTF(s: string): string;


procedure SetLengthFill(var S: string; Len: Integer; FillChar: Char; clear: boolean);

function IntToStrFill(num, len: Integer; cfill: char): string;
function Formatn(const Fmt: string; const Args: array of const): string;{'\n'}
function InsertStr(var s: string; const subs: string; start: Integer): string;{start>=1}
function InsertStr2(var s: string; const subs: string; var position: Integer; dposition: Integer): string;{position>=1}

function isdigit(c: char): boolean; {цифра}
function isdigit2(c: char): boolean; {цифра со знаком}
function isdigitstring(s: string): boolean; {empty s => false}
function isnumstring(s: string; var isreal: boolean): boolean; {+-.,0..9}
function isintstring(s: string): boolean; {+-0..9}
function isdmcode(s: string): boolean; {0..9, 1-ый м.б. буква English}
function isalfa(c: char): boolean;  {буква English}
function isalfa2(c: char): boolean;  {буква}
function isname(s: string): boolean;  {буквы или цифры, 1-ая буква}

function s_get_digitword(s: string; sn{>0}: integer): string;//цифровое слово вокруг позиции sn

function s_toupcase(s:string):string; {no var!}
function s_trunc(s:string):string;  {no var!} //пробелы в конце отсекает

function rvaldef(s: string; defval: real): real;
function ivaldef(s: string; defval: longint): longint;

function bools(b: boolean): string;

//копирует слова, пока Len<=maxlen, меняет s:
function sgetwords_maxlen(var s: string; maxlen: integer): string; overload;
procedure sgetwords_maxlen(s: string; maxlen: integer; strings: tstrings); overload;

//после вызова указатель "sn" стоит на символе-разделителе, sn>=1:
//delims по умолчанию содержит все char<=' ':
function sgetword(s: string; var sn: integer): string;//разделители: <=#32
function sgetword2(s: string; var sn: integer; delims: string): string;//Result - вместе с разделителем(!) м.б.
function sgetword3(s: string; var sn: integer; delims: string): string;//Result - без разделителя в конце

{после вызова "s" начинается с символа-разделителя:}
function sread_word(var s: string): string;
function sread_int(var s: string; defval: longint): longint; overload;
function sread_int(var s: string): longint; overload;//default=0
function sread_real(var s: string): real;//default=0

//TStrings: CLEAR(!) - использовать string2stringlist(!):
//символы <' ' - всегда разделители!
//s0: список через <' ' или "delimeter"
procedure sgetlist0(s0: string; sl: TStrings; delimeter: char);
procedure sgetlist3(s0: string; sl: TStrings; delims: string);//use sgetword3
procedure sgetlist(s0: string; sl: TStrings);//список через ";"
//zstring2stringlist вставляет #0 внутрь строки zs(!), string2stringlist - нет:
procedure zstring2stringlist(zs: pchar; sl: TStrings; delimeter: char);//zs->sl: список через "delimeter"
procedure string2stringlist(s: string; sl: TStrings; delimeter: char = ';'{default});//s->sl: список через ";"
procedure stringlist2string(sl: TStrings; var s: string);//sl->s: список через ";"

function ps_string(s:string):string;  { '\' -> (\\) }

procedure wcmn_ChangeChars(var s: string; c1,c2: char);//c1->c2

{ DIR: }

function TmpDir: string;
function ExeDir: string;
function UpperDir(dir: string): string;  {..\}
function DirExists(dirname: string): boolean; {with '\' OR without}

//dirfiles - файлы из директории - shortnames(имя и расширение без директории!):
//НЕ ЧИТАЕТ: поддиректории, скрытые(h), системные(s) файлы:
procedure wcmn_dir_getfiles(pathmask{c:\*.*}: string; dirfiles{clear}: tstrings);

{ FILE: }

//mode = 'r'-"read"; 'a'-"append"; 'w'-"write"(rewrite,clear):
function ftopen(var f: TextFile; name: string; mode: char):boolean;
function ftopen_msg(var f: TextFile; name: string; mode: char):boolean;
procedure ftclose(var f: TextFile);  {даже на неоткрытом файле}

//mode = 'r'-"read & write"; 'w'-"write":
function fopen(var f: File; name: string; mode: char):boolean;
function fopen_msg(var f: File; name: string; mode: char):boolean;
procedure fclose(var f: File);  {даже на неоткрытом файле}

{возвращает количество скопированных файлов:}
function wcmn_filecopy0(names1: array of string; name2:string; _msg_in,_msg_out: boolean): integer;
function wcmn_filecopy(names1: array of string; name2: string): integer;//_msg_in,_msg_out=TRUE
function wcmn_filecopy1(name1,name2: string): boolean;//_msg_in,_msg_out=FALSE

function wcmn_FileExists_msg(path: string; _exitmsg: boolean): boolean;
function wcmn_filesize(fname:string): longint;

function wcmn_file_dir0(fullname: string): string;//without "\"
function wcmn_file_dir(fullname: string): string;//with "\" || ''
function wcmn_file_nameext(fullname: string): string;//shortname with ext
function wcmn_file_name(fullname: string): string;//shortname without ext
function wcmn_file_dirname(fullname: string): string;//without ext
function wcmn_file_ext0(fullname: string): string;     {without "." || ''}
function wcmn_file_ext(fullname: string): string;     {with "." || ''}

//procedure wcmn_DeleteFile(fname: string);//function SysUtils.DeleteFile - информативнее
function wcmn_DeleteFile(fname: string; _msg: boolean): boolean;
function wcmn_RenameFile(fname1,fname2: string): boolean;//переписывает при наличии
function wcmn_Access(fname: string): boolean;

{ MESSAGE: }

procedure Tell(Msg: string);
procedure Tell2(MsgAr: array of string);
procedure Tellf(const Fmt: string; const Args: array of const);{'\n'}

procedure About(Msg: string);
procedure TellInt(Msg: string; n: longint);
function Warning(Msg: string): boolean;
function TellYN(Msg: string): boolean;
function TellYNC(Msg: string): integer;  {1,0,-1}
function TellYAN(Msg: string): integer;  {1,2,0,-1: close}

function TellfYN(const Fmt: string; const Args: array of const): boolean;
function TellfYNC(const Fmt: string; const Args: array of const): integer;  {1,0,-1}
function TellfYAN(const Fmt: string; const Args: array of const): integer;  {1,2,0,-1: close}

{-------------------------------}
IMPLEMENTATION
{-------------------------------}

uses
  controls{cursors}, Dialogs{MessageDlg}, extctrls, Graphics{colors},
  Spin{TSpinEdit};

{ TIni methods: }

constructor TIni.Create0(IniPath: string);//БЕЗ ЗАМЕН! - PRIVATE!
begin
  inherited Create(IniPath);
  FSection := 'General';  {default}
end;

constructor TIni.Create;
var inipath: string;
begin
  inipath := GetIniPath(''{ExePath});
  Create0(inipath);
end;

//aPath='' == Create;{ExePath}
//Для DLL: Указать aPath С РАСШИРЕНИЕМ(!):
//uses Definitions, aPath.EXT! --- FOR DLL.INI:
constructor TIni.Create(aPath: string);
var inipath: string;
begin
  inipath := GetIniPath(aPath);
  Create0(inipath);
end;

destructor TIni.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------

function TIni.GetIniDir: string;//uses Definitions, m.b.''
var inidirname: string;
begin
  inidirname:='';//default

{$IFDEF _INIDIR}
  inidirname:=UpperDir(ExeDir)+'INI\';
  ForceDirectories(inidirname);//!
{$ENDIF}

{$IFDEF _USERINIDIR}
  inidirname:=wcmn_GetEnv('APPDATA');//без '\': C:\Users\Andreas\AppData\Roaming
  if (inidirname<>'') and DirExists(inidirname)
  then inidirname:=inidirname+'\'//!
  else Tellf('TIni.GetIniDir: NOT FOUND: "%s"',[inidirname]);
{$ENDIF}

{$IFDEF _USERINI_FTM}
  inidirname:=wcmn_GetEnv('APPDATA');
  if (inidirname<>'') and DirExists(inidirname)
  then inidirname:=inidirname+'\FTM_andreas\'
  else Tellf('TIni.GetIniDir: NOT FOUND: "%s"',[inidirname]);
  ForceDirectories(inidirname);//!
{$ENDIF}

  Result:=inidirname;//!
end;

function TIni.GetIniPath(aPath: string): string;//uses Definitions, GetIniDir, aPath.EXT
var inipath, inidirname: string;
begin
  inidirname:=GetIniDir;//uses Definitions!
  if (inidirname<>'') and DirExists(inidirname)
  then begin
    if Length(aPath)>0
    then inipath := inidirname + wcmn_file_nameext(aPath)//nameext!!!
    else inipath := inidirname + wcmn_file_name(Application.ExeName) + '.INI';//if aPath=''
  end else
    inipath := ChangeFileExt(Application.ExeName, '.INI');//default

{$IFDEF _INI_DLL_FTV}
  inipath := ExeDir + 'dll_ftv.ini'//использовано для СПЕЦ.СЛУЧАЯ --- ПЕРЕОПРЕДЕЛЕНИЕ
{$ENDIF}

  Result:=inipath;//!
end;

//-----------------------------------------

procedure TIni.MyClearSection(id: string);
var i: integer; keys: tstringlist;
begin
  keys:=tstringlist.Create;
  try
    ReadSection(id, keys);
    if keys.Count>0 then for i:=0 to keys.Count-1 do DeleteKey(id, keys[i]);
  finally
    keys.Free;
  end;
end;

procedure TIni.MyWriteSectionValues(id: string; sl: TStrings{...=...});
var i: integer;
begin
  Section:=id;
  if sl.Count>0 then for i:=0 to sl.Count-1 do begin
    WS( sl.Names[i], sl.ValueFromIndex[i] );
  end;//for i
end;
                           

function TIni.RS(id, defv: string): string;
begin
  Result := ReadString(FSection, id, defv);
end;

procedure TIni.WS(id, v: string);
begin
  WriteString(FSection, id, v);
end;

function TIni.RI(id: string; defv: Long): Long;
begin
  Result := ReadInteger(FSection, id, defv);
end;

function TIni.RI2(id: string; defv,minv,maxv: Long): Long;
var l: Long;
begin
  l := ReadInteger(FSection, id, defv);
  Result := ToRange(l, minv, maxv );
end;

function TIni.RR(id: string; defv: real): real;
var s: string;
begin
  s:=ReadString(FSection, id, '');
  Result:=rvaldef(s, defv);
end;

procedure TIni.WI(id: string; v: Long);
begin
  WriteInteger(FSection, id, v);
end;

procedure TIni.WR(id: string; v: real);
var s: string;
begin
  s:=Format('%.2f',[v]);
  WriteString(FSection, id, s);
end;

function TIni.RB(id: string; defv: Bool): Bool;
begin
  Result := ReadBool(FSection, id, defv);
end;

procedure TIni.WB(id: string; v: Bool);
begin
  WriteBool(FSection, id, v);
end;


procedure TIni.WForm0(F: TForm; aSection: string);
var n,i: integer; X: TComponent; XC: TControl;
begin
  Section:=aSection;//!

  WI('Top', F.Top);
  WI('Left', F.Left);

  if (F.BorderStyle=bsSizeable)
  or (F.BorderStyle=bsSizeToolWin)
  then begin
    WI('Width', F.Width);
    WI('Height', F.Height);
  end;

  //X: Component:
  n:=F.ComponentCount;
  if n>0 then for i:=0 to n-1 do begin

    X:=F.Components[i];
    if X.ClassName='TEdit' then WS(X.Name, TEdit(X).Text);
    if (X.ClassName='TSpinEdit') and (X.Name<>'') then WI(X.Name, TSpinEdit(X).Value);
    if X.ClassName='TRadioGroup' then WI(X.Name, TRadioGroup(X).ItemIndex);
    if X.ClassName='TCheckBox' then WB(X.Name, TCheckBox(X).Checked);
(*
    if X.ClassName='TSplitter' then begin
      XC:=TSplitter(X);
      if xc.Width>xc.Height{горизонт.} then WI(X.Name, XC.Top)
      else{вертик-ая} WI(X.Name, XC.Left);
    end;
*)
    //if X.ClassName='TSplitter' then WI(X.Name, TSplitter(X).Left);//Splitter лезет на ListBox

    //ЗАПИСЬ ЧЕРЕЗ TAG:
    XC:=TControl(X);
    if x.Tag>100 then
    case x.Tag of
      101: WI(X.Name,XC.Width);
      102: WI(X.Name, XC.Height);
      201: WI(X.Name,XC.Left);
      202: WI(X.Name, XC.Top);
    else Tellf('ERROR in TIni.WForm0: TAG=%d',[x.Tag])
    end;

  end;//for i
end;

procedure TIni.RForm0(F: TForm; aSection: string);
var n,i: integer; X: TComponent; XC: TControl; key_list: tstringlist;
begin
  key_list:=TStringList.Create;
  try
  try
    ReadSection(aSection, key_list);//список имён!
    Section:=aSection;//!

    F.Top:=RI('Top', F.Top);
    F.Left:=RI('Left', F.Left);

    if (F.BorderStyle=bsSizeable)
    or (F.BorderStyle=bsSizeToolWin)
    then begin
      F.Width:=RI('Width', F.Width);
      F.Height:=RI('Height', F.Height);
    end;

    if key_list.Count>0 then begin

      //Section EXISTS:
      n:=F.ComponentCount;
      if n>0 then for i:=0 to n-1 do begin
        X:=F.Components[i];
        if key_list.IndexOf(X.Name)<0 then continue;//эта величина не записывалась!

        //X.Name EXISTS:
        Section:=aSection;//!
        try
          if X.ClassName='TEdit' then TEdit(X).Text:=RS(X.Name,'');
          if X.ClassName='TSpinEdit' then TSpinEdit(X).Value:=RI(X.Name,0);
          if X.ClassName='TRadioGroup' then TRadioGroup(X).ItemIndex:=RI(X.Name,0);
          if X.ClassName='TCheckBox' then TCheckBox(X).Checked:=RB(X.Name,false);
(*
          if X.ClassName='TSplitter' then begin
            if TSplitter(X).Width>TSplitter(X).Height
            then TSplitter(X).Top :=RI(X.Name,0)
            else TSplitter(X).Left:=RI(X.Name,0);
          end;
*)
          //if X.ClassName='TSplitter' then TSplitter(X).Left:=RI(X.Name, 0);//Splitter лезет на ListBox

          //ЧТЕНИЕ ЧЕРЕЗ TAG:
          XC:=TControl(X);
          if x.Tag>100 then
          case x.Tag of
            101: XC.Width:=RI(X.Name,0);
            102: XC.Height:=RI(X.Name,0);
            201: XC.Left:=RI(X.Name,0);
            202: XC.Top:=RI(X.Name,0);
          else Tellf('ERROR in TIni.RForm0: TAG=%d',[x.Tag])
          end;

        except
          ;
        end;

      end;//for i

    end;//key_list.Count>0
  finally
    key_list.free;
  end;
  except
  end;
end;

procedure TIni.WForm(F: TForm);
begin
  WForm0(F, F.Name);
end;

procedure TIni.RForm(F: TForm);
begin
  RForm0(F, F.Name);
end;


procedure TIni.WCheckList(F: TForm; CL: TCheckListBox);//список с галочками, меняет Section!
var i,iv: integer;
begin
  Section := F.Name + '.' + CL.Name;//!
  MyClearSection(Section);//!

  if CL.Count>0 then for i:=0 to CL.Count-1 do begin
    if CL.Checked[i] then iv:=1 else iv:=0;
    if CL.Items[i]<>'' then WI( CL.Items[i], iv );
  end;
end;

procedure TIni.RCheckList(F: TForm; CL: TCheckListBox);//список с галочками, меняет Section!
var i,iv: integer;
begin
  Section := F.Name + '.' + CL.Name;//!

  if CL.Count>0 then for i:=0 to CL.Count-1 do begin
    if CL.Items[i]<>'' then iv := RI( CL.Items[i], 0 ) else iv:=0;
    CL.Checked[i] := iv=1;//!
  end;
end;


procedure TIni.WGridColumns(G: TStringGrid; aSection: string);
var nc,ic: integer;
begin
  MyClearSection(aSection);//!

  Section:=aSection;//!
  nc:=G.ColCount;
  if nc>0 then for ic:=0 to nc-1 do begin
    WI( G.Cols[ic][0], G.ColWidths[ic] );
  end;
end;

procedure TIni.RGridColumns(G: TStringGrid; aSection: string);
var nc,ic,w: integer; colheaders: tstrings;
begin
  Section:=aSection;//!
  colheaders:=G.Rows[0];
  nc:=colheaders.Count;
  if nc>0 then for ic:=0 to nc-1 do begin
    w:=RI(colheaders[ic],-1);
    if w>=0 then begin
      G.ColWidths[ic]:=w;
    end;
  end;
end;


////////////////////////////////////////////////////////////

//SHELL:
function wcmn_show_file(path: string): boolean;//вызов WIN-SHELL по STD-EXT (по расширению!!!!!!!!!!!)
begin
  Result :=  OpenDocument(PChar(path)) { *Преобразовано из ShellExecute* >32};
  if not Result
  then Tellf('ERROR in WIN-function ShellExecute: OPEN file "%s"',[path]);
end;


////////////////////////////////////////////////////////////

function wcmn_cmp_int(i1,i2: integer): integer;
begin
  if i1>i2 then Result:=1 else
  if i1<i2 then Result:=-1 else
  Result:=0;
end;
function wcmn_cmp_str(s1,s2: string): integer;
begin
  if s1>s2 then Result:=1 else
  if s1<s2 then Result:=-1 else
  Result:=0;
end;


function set_bytes_contains1(s: tset_bytes; ba: array of byte): boolean;//s содержит хотя бы один эл-т из ba
var i: integer;
begin
  Result:=false;
  for i:=0 to Length(ba)-1 do begin
    if not (ba[i] in s) then continue;
    Result:=true;
    break;
  end;//for i
end;


////////////////////////////////////////////////////////////

{ language: }

function wcmn_language_test(aIniFileName: string): boolean;
const call_count: integer = 0;
var i: integer; paramok: boolean;
begin
  Result:=false;

  if call_count=0 then begin
    wcmn_language_file_name:='';//default!
  end else begin
    Result := wcmn_language_file_name<>'';
    exit;
  end;

  if Length(aIniFileName)=0 then aIniFileName := ChangeFileExt(Application.ExeName, '.msg');

  //поиск параметра:
  paramok:=false;
  //ParamStr(0)=Application.ExeName всегда, ParamStr(1) - если ParamCount>0 (нумерация с 1 !!!):
  if ParamCount>0 then for i:=1 to ParamCount do begin
    if (ParamStr(i)='/t') or (ParamStr(i)='/l') then begin
      paramok:=true;
      break;
    end;
  end;//for i

  //поиск файла(вместо параметра):
  if FileExists(ExeDir+'english.ver')
  or FileExists(ExeDir+'english_mss.ver')
  then paramok:=true;

  //завершение:
  if paramok and FileExists(aIniFileName) then begin
    wcmn_language_file_name:=aIniFileName;//- КРИТЕРИЙ ДЛЯ ДР ПРОГРАММ
    Result:=true;
  end;

  inc(call_count);//!
end;

//if aTellList=nil ,то заменяется wcmn.telllist из секции "TellLib":
//if aTellList<>nil ,то заменяется aTellList из секции "Tell":
procedure wcmn_language_telllist(aTellList: TStringList);
var i: integer; aIni: TIni;
begin
  if wcmn_language_file_name='' then exit;

  aIni:=TIni.Create0(wcmn_language_file_name);
  try
  try
    aIni.Section:='Tell';
    if aTellList=nil then begin
      aTellList:=telllist;
      aIni.Section:='TellLib';
    end;

    if aTellList.Count>0 then for i:=0 to aTellList.Count-1 do
      aTellList[i]:=aIni.RS(IntToStr(i), aTellList[i]);
  finally
    aIni.free;
  end;
  except
  end;
end;

(*
procedure wcmn_language_form(aForm: TForm);
var aIni: TIni;

  procedure _ReadMenuItems(aMenuItems: TMenuItem);
  var j: integer; MI: TMenuItem;
  begin
    with aMenuItems do if Count>0 then for j:=0 to Count-1 do begin
      MI:= Items[j];
      MI.Caption:=aIni.RS(MI.Name, MI.Caption);
      _ReadMenuItems(MI);//recursion!
    end;
  end;

var
  n,i,j: integer; s: string; X: TComponent;
  RG: TRadioGroup;
  TNB: TTabbedNotebook; TPC: TPageControl;
begin
  if wcmn_language_file_name='' then exit;

  aIni:=TIni.Create0(wcmn_language_file_name);
  try
  try
    //aIni.Section:=aForm.Name;//!
    aIni.Section:=aForm.ClassName;//!

    aForm.Caption:=aIni.RS(aForm.Name, aForm.Caption);

    //MainMenu:
    if Assigned(aForm.Menu) then _ReadMenuItems(aForm.Menu.Items);

    //Components:
    n:=aForm.ComponentCount;
    if n>0 then for i:=0 to n-1 do begin
      X:=aForm.Components[i];
      try

        //TControl: Hint:
        if X is TControl then begin
          if TControl(X).Hint<>'' then
            TControl(X).Hint:=aIni.RS(X.Name+'.Hint', '');//если не указан в .msg, то обнуляется (на всякий случай)
        end;//TControl

        //Caption, PouUpMenu: TLabel, TButton, TCheckBox, TGroupBox, TRadioGroup(+Items):
        if X is TMemo then begin
          if Assigned(TMemo(X).PopupMenu) then _ReadMenuItems(TMemo(X).PopupMenu.Items);
        end else
        if X is TRichEdit then begin
          if Assigned(TRichEdit(X).PopupMenu) then _ReadMenuItems(TRichEdit(X).PopupMenu.Items);
        end else
        if X is TListBox then begin
          if Assigned(TListBox(X).PopupMenu)
            then _ReadMenuItems(TListBox(X).PopupMenu.Items);
        end else
        if X is TLabel then begin
          TLabel(X).Caption:=aIni.RS(X.Name, TLabel(X).Caption);
          if Assigned(TLabel(X).PopupMenu) then _ReadMenuItems(TLabel(X).PopupMenu.Items);
        end else
        if X is TButton then begin
          TButton(X).Caption:=aIni.RS(X.Name, TButton(X).Caption);
          if Assigned(TButton(X).PopupMenu) then _ReadMenuItems(TButton(X).PopupMenu.Items);
        end else
        if X is TCheckBox then begin
          TCheckBox(X).Caption:=aIni.RS(X.Name, TCheckBox(X).Caption);
          if Assigned(TCheckBox(X).PopupMenu) then _ReadMenuItems(TCheckBox(X).PopupMenu.Items);
        end else
        if X is TGroupBox then begin
          TGroupBox(X).Caption:=aIni.RS(X.Name, TGroupBox(X).Caption);
          if Assigned(TGroupBox(X).PopupMenu) then _ReadMenuItems(TGroupBox(X).PopupMenu.Items);
        end else
        if X is TTabSheet then begin
          TTabSheet(X).Caption:=aIni.RS(X.Name, TTabSheet(X).Caption);
          if Assigned(TTabSheet(X).PopupMenu) then _ReadMenuItems(TTabSheet(X).PopupMenu.Items);
        end else

        if X is TRadioGroup then begin
          RG:=TRadioGroup(X);
          RG.Caption:=aIni.RS(X.Name, RG.Caption);
          if Assigned(RG.PopupMenu) then _ReadMenuItems(RG.PopupMenu.Items);
          if RG.Items.Count>0 then for j:=0 to RG.Items.Count-1 do begin
            s:=RG.Name+'.'+IntToStr(j);
            RG.Items[j]:=aIni.RS(s, RG.Items[j]);
          end;//for j
        end else

        if X is TTabbedNotebook then begin
          TNB:=TTabbedNotebook(X);
          if Assigned(TNB.PopupMenu) then _ReadMenuItems(TNB.PopupMenu.Items);
          if TNB.Pages.Count>0 then for j:=0 to TNB.Pages.Count-1 do begin
            s:=TNB.Name+'.'+IntToStr(j);
            TNB.Pages[j]:=aIni.RS(s, TNB.Pages[j]);
          end;//for j

        end;//without else
      except
      end;
    end;//for i (Components)

  finally
    aIni.free;
  end;
  except
  end;
end;
*)
procedure wcmn_language_form(aForm: TForm);
var aIni: TIni;
(*
  procedure _ReadMenuItems(aMenuItems: TMenuItem);
  var j: integer; MI: TMenuItem;
  begin
    with aMenuItems do if Count>0 then for j:=0 to Count-1 do begin
      MI:= Items[j];
      MI.Caption:=aIni.RS(MI.Name, MI.Caption);
      if (MI.Caption='') then begin
        //MI.Enabled:=FALSE;//удаление строки меню!
        MI.Visible:=FALSE;
      end;

      _ReadMenuItems(MI);//recursion!
    end;
  end;
*)
var
  n,i,j: integer; s: string; X: TComponent;
  RG: TRadioGroup;
  TNB: TPageControl;
begin
  if wcmn_language_file_name='' then exit;

  aIni:=TIni.Create0(wcmn_language_file_name);
  try
  try
    aIni.Section:=aForm.ClassName;//!

    aForm.Caption:=aIni.RS(aForm.Name, aForm.Caption);

    //Components:
    n:=aForm.ComponentCount;
    if n>0 then for i:=0 to n-1 do begin
      X:=aForm.Components[i];
      try

        //TControl: Hint:
        if X is TControl then begin
          if TControl(X).Hint<>'' then
            TControl(X).Hint:=aIni.RS(X.Name+'.Hint', '');//если не указан в .msg, то обнуляется (на всякий случай)
        end;//TControl

        //Caption:
        if X is TMenuItem then with TMenuItem(X) do begin
          Caption:=aIni.RS(X.Name, Caption);
          if Caption='' then Visible:=FALSE;//удаление!
        end
        else
        if X is TLabel then with TLabel(X) do Caption:=aIni.RS(X.Name, Caption)
        else
        if X is TButton then with TButton(X) do Caption:=aIni.RS(X.Name, Caption)
        else
        if X is TCheckBox then with TCheckBox(X) do begin
          Caption:=aIni.RS(X.Name, Caption);
          if Caption='' then Visible:=FALSE;//удаление!
        end
        else
        if X is TGroupBox then with TGroupBox(X) do Caption:=aIni.RS(X.Name, Caption)
        else
        if X is TTabSheet then with TTabSheet(X) do Caption:=aIni.RS(X.Name, Caption)
        else

        if X is TRadioGroup then begin
          RG:=TRadioGroup(X);
          RG.Caption:=aIni.RS(X.Name, RG.Caption);
          j:=0;
          //if RG.Items.Count>0 then for j:=0 to RG.Items.Count-1 do begin
          while j<RG.Items.Count do begin
            s:=RG.Name+'.'+IntToStr(j);
            RG.Items[j]:=aIni.RS(s, RG.Items[j]);
            if (RG.Items[j]='') then RG.Items.Delete(j) else inc(j);
          end;//for j
        end else

        if X is TPageControl then begin
          TNB:=TPageControl(X);
          if TNB.PageCount>0 then for j:=0 to TNB.PageCount-1 do begin
            s:=TNB.Name+'.'+IntToStr(j);
            TNB.Pages[j].Caption:=aIni.RS(s, TNB.Pages[j].Caption);
          end;//for j
        end;//without else

      except
      end;
    end;//for i (Components)

  finally
    aIni.free;
  end;
  except
  end;
end;



{ OBJECTS: }

procedure wcmn_list_scroll_to_end(LV: TListView);
var count, newtop, dy: integer;
begin
  count := LV.Items.Count;
  //LV.TopItem := count;
  newtop := count - LV.VisibleRowCount;
  dy := Round(((LV.TopItem.Index - newtop)/LV.VisibleRowCount)*LV.Height);
  LV.ScrollBy(0,dy);
end;

//with children, if they exist:
procedure GroupBoxEnabled(gp: TGroupBox; aEnabled: boolean);
var i,n: integer;
begin
  gp.Enabled:=aEnabled;
  if aEnabled then gp.ParentFont:=true else gp.Font.Color:=clGrayText;
  n:=gp.ControlCount;
  if n>0 then for i:=0 to n-1 do gp.Controls[i].Enabled:=aEnabled;
end;


procedure ObjFree(var obj: TObject); {Obj:=nil}
begin
  if Assigned(obj) then obj.Free;
  obj:=nil;
end;
(*
procedure ObjFree(var obj: Class of TObject); {Obj:=nil}
begin
  if Assigned(obj) then obj.Free;
  obj:=nil;
end;
*)

function  ObjAssigned(obj: TObject): boolean;
begin
  Result:=true;
  if Assigned(obj) then try
    obj.InstanceSize;
  except Result:=false;
  end;
end;

procedure ObjCpy(var dest, src: TObject);
var p0: pchar absolute src; p1: pchar absolute dest;
begin
  if dest=nil then exit;//!
  if src<>nil then StrMove(p1, p0, dest.InstanceSize)
  else ObjFree(dest);
end;

function IndexOf_ObjInList(List: TStrings; Obj: TObject): Integer;
var i: Integer;
begin
  Result:=-1;
  if List.Count=0 then exit;
  if List.Count>0 then for i:=0 to List.Count-1 do begin
    if Obj=List.Objects[i] then begin Result:=i; exit; end;
  end;
end;

function IndexOf_ObjInGrid(Grid: TStringGrid; Obj: TObject): Integer;
var i: Integer;
begin
  Result:=-1;
  if Grid.RowCount=0 then exit;
  if Grid.RowCount>0 then for i:=0 to Grid.RowCount-1 do begin
    if Obj=Grid.Objects[0,i] then begin Result:=i; exit; end;
  end;
end;

procedure SetComboIndex(Box: TComboBox; i: Integer);
begin
  Box.ItemIndex:=i;
  if i>=0 then Box.Text:=Box.Items[i] else Box.Text:='';
end;



{ CMN: }

function polynom1(a,b,x: Extended): Extended;
begin
  Result := a*x+b;
end;

function polynom2(a,b,c,x: Extended): Extended;
begin
  Result := x*( a*x+b ) + c;
end;

function polynom3(a,b,c,d,x: Extended): Extended;
begin
  Result := x*( x*( a*x+b ) + c ) + d;
end;


//RETURN: кол-во корней (-1 - бесконечное мн-во):
function equation1(a,b: Extended; var x: Extended): integer;
begin
  Result:=1;
  try
    x:=-b/a;
  except//a=0
    x:=0;
    if b=0 then Result:=-1 else Result:=0;
  end;
end;

//RETURN: кол-во корней (-1 - бесконечное мн-во):
function equation2(a,b,c: Extended; var x1,x2: Extended): integer;
var D,D2: Extended;
begin
  Result:=0;
  D:=b*b-4*a*c; if D<0 then exit;
  if D=0 then Result:=1 else Result:=2;
  try
    D2:=sqrt(D);
    x1 := (-b - D2)/(2*a);
    x2 := (-b + D2)/(2*a);
  except//a=0
    Result:=equation1(b,c,x1);
    x2:=x1;
  end;
end;


procedure parabola_abc(z0,sag,z1: double; out a,b,c: double);
begin
  a := 4*sag;
  b := (z1-z0)-4*sag;
  c := z0;
end;


function bool2int(b: boolean): Integer;
begin
  if b then Result:=1 else Result:=0;
end;

function int2bool(i: Integer): boolean; {0->false}
begin
  Result := (i<>0);
end;


function wcmn_time1: string;//ДАТА И ВРЕМЯ: yyyy.mm.dd hh:nn:ss
var s: string;
begin
  s:=FormatDateTime('yyyy.mm.dd hh:nn:ss', SysUtils.Now);
  Result := Format('ДАТА И ВРЕМЯ: %s',[s]);
end;

function DateTime_s: string;
begin
  Result := FormatDateTime('dd mmm hh:nn:ss', SysUtils.Now);
end;

function DateTime_sDate(aDateTime: TDateTime): string;//dd.mm.yyyy
begin
  Result := FormatDateTime('dd.mm.yyyy', aDateTime);
end;


function ToRange(var v; const minv, maxv: Long): Long;
begin
  if Long(v)<Long(minv) then Result:=minv
  else
    if Long(v)>Long(maxv) then Result:=maxv
    else Result:=Long(v);
end;

function sumi(n: array of Long): Long;
var i: Long;
begin
  Result:=0;
  for i:=Low(n) to High(n) do inc(Result, n[i]);
end;

function min(a,b: real): real;
begin
  if a<=b then Result := a else Result := b;
end;

function max(a,b: real): real;
begin
  if a>=b then Result := a else Result := b;
end;

function mini(a,b: long): long;
begin
  if a<=b then Result := a else Result := b;
end;

function maxi(a,b: long): long;
begin
  if a>=b then Result := a else Result := b;
end;

(*
function wcmn_Exec(cmdline: string): boolean;
var zs: TCharsBuf; Reply: word;
begin
  wcmn_Exec := false;

  Reply := WinExec(StrPCopy(zs,cmdline), SW_ShowNormal);

  //Application.ProcessMessages;   {?}


  if (Reply>=32) or (Reply=16) then begin
    wcmn_Exec := true;
    exit;
  end;

  case Reply of
     2,3: begin
          Tell(Format('ERROR in program path:%s%s',[_EOL_,cmdline]));
        end;
     8: begin
          Tell('Out of memory.');
        end;
    16: begin  {попытка повторного вызова однократной программы}
          wcmn_Exec := true;
          exit;
        end;
  else
    Tell(Format('Execution error WinExec=%d%s%s',[Reply,_EOL_,cmdline]));
  end; {case}
end;
*)
function run(cmd: string; wait: boolean): boolean;
var
  PROC_INFO: TProcessInformation;
  stinfo: tstartupinfo;
  zs: array [0..512] of Char;
  pc: PChar;
begin
  ZeroMemory(@stinfo, SizeOf(stinfo));         //вход
  ZeroMemory(@PROC_INFO, SizeOf(PROC_INFO));   //выход

  pc := StrPCopy(zs,cmd);
  Result := CreateProcess(
         NIL,           //lpApplicationName
         pc,            //lpCommandLine
         NIL,           //pProcessAttributes
         NIL,           //lpThreadAttributes (security, Windows 95: ignored)
         false{true},     //bInheritHandles
         {0}CREATE_DEFAULT_ERROR_MODE,       //dwCreationFlags
         NIL,       //lpEnvironment
         NIL,       //lpCurrentDirectory
         stinfo,   //lpStartupInfo (window)
         PROC_INFO  //lpProcessInformation
         );

  if Result and wait then
    WaitForSingleObject(PROC_INFO.hProcess, INFINITE);
end;

function wcmn_Exec2(cmdline: string; _wait: boolean): boolean;
begin
  Result := run(cmdline,_wait);

  if not Result then begin
    {erno := GetLastError}
    Tellf('Execution error in cmdline:\n%s',[cmdline]);
  end;
end;

procedure SuspendApplication;
begin
  Application.ProcessMessages;
  WaitMessage;
end;

procedure SetDefCursor;
begin
  Screen.Cursor:=crDefault;
end;

procedure SetWaitCursor;
begin
  Screen.Cursor:=crHourGlass;
end;

function wcmn_dll_open(dll_name: string): THandle; {0-error}
begin
  dll_name := dll_name + #0;
  Result := LoadLibrary( @dll_name[1] );
  if Result<32 then begin //32 - "из примера"
    Result:=0;
    Tellf('ERROR in loading DLL "%s"', [dll_name]);
  end;
end;

procedure wcmn_dll_close(Hdll: THandle);
begin
  if Hdll>0 then FreeLibrary(Hdll);
end;

function wcmn_dll_getproc(Hdll: THandle; proc_name: string): FARPROC; {nil-error}
begin
  proc_name := proc_name + #0;
  Result := GetProcAddress(Hdll, @proc_name[1]);
  if Result=nil then Tellf('ERROR in loading DLL-procedure "%s"', [proc_name]);
end;

function wcmn_GetEnv(name: string): string;
var zs, buf: TCharsBuf; n: word;
begin
  StrPCopy(zs,name);
  n := GetEnvironmentVariable(zs,buf,sizeof(buf));
  buf[n] := #0;
  Result := StrPas( buf );
end;


{ MEMORY: }

function malloc(size: Integer): PChar;
begin
  if size<=0 then begin Result:=nil; exit; end;

  try
    Result := AllocMem(size); {set to 0}
  except
    Result := nil;
  end;

  if Result=nil then Tell('Out Of Memory Exception in "malloc".');
end;

function mrealloc(p0: pointer; size0, size1: Integer): PChar;
begin
  if (p0=nil) or (size0<=0) then begin
    Result:=malloc(size1);
    exit;
  end;

  if size1=0 then begin
    Result:=nil;
    mfree(p0, size0);
    exit;
  end;

  try
    ReAllocMem(p0, size1);  {not set to 0}
    Result:=p0;
    if (Result<>nil) and (size1>size0) then FillChar((Result+size0)^, size1-size0, 0);
  except
    Result := nil;
  end;

  if Result=nil then Tell('Out Of Memory Exception in "mrealloc".');
end;

procedure mfree(var p{: pointer}; size: Integer);
var pt: pointer absolute p;
begin
  if pt=nil then exit;
  if size<=0 then begin pt:=nil; exit; end;

  try
    FreeMem(pt, size);
  except ;
    //Tell('Exception in procedure "mfree"');
  end;

  pt:=nil;
end;
procedure mfree2(var p{: pointer});
var pt: pointer absolute p;
begin
  if pt=nil then exit;
  try
    FreeMem(pt);
  except ;
    Tell('Exception in procedure "mfree2"');
  end;

  pt:=nil;
end;


procedure memcpy(dest, sourc: pchar; count: integer);
begin
  {if count>0 then hmemcpy(dest, sourc, count);}
   if count>0 then StrMove(dest, sourc, count);
end;

function memcmp(p1, p2: pchar; count: integer): integer;
var i: integer;
begin
  Result:=0;
  if count>0 then for i:=0 to count-1 do begin
    if p1^<>p2^ then begin
      if p1^<p2^ then Result:=-1
      else Result:=1;
      exit;
    end;
    inc(p1);
    inc(p2);
  end;
end;


{ STRING: }

{Delphi2009:}
function _StrPas(p: PChar): string; //Delphi2009 требует PAnsiChar
begin
  Result:=StrPas( PAnsiChar(p) );
end;

function wcmn_dos2win(s: string): string;
var i,l: longint; b: byte;
begin
  Result:='';
  l:=Length(s);
  if l=0 then exit;
  SetLength(Result,l);
  for i:=1 to l do begin
    b:=byte(s[i]);
    case b of
      128..175: inc(b,64);
      224..239: inc(b,16);
      240: b:=197;
      241: b:=229;
    end;{case}
    Result[i]:=char(b);
  end;//for i
end;

function wcmn_win2dos(s: string): string;
var i,l: longint; b: byte;
begin
  Result:='';
  l:=Length(s);
  if l=0 then exit;
  SetLength(Result,l);
  for i:=1 to l do begin
    b:=byte(s[i]);
    case b of
      192..239: dec(b,64);
      240..255: dec(b,16);
//      197: b:=240;
//      229: b:=241;
    end;{case}
    Result[i]:=char(b);
  end;
end;


procedure wcmn_richedit_dos2win(Page: TRichMemo);
var i: integer; VisibleOld: boolean;
begin
  VisibleOld:=Page.Visible;{save}
  Page.Visible:=false;
  if Page.Lines.Count>0 then for i:=0 to Page.Lines.Count-1 do begin
    Page.Lines[i]:=wcmn_dos2win(Page.Lines[i]);
  end;
  Page.Visible:=VisibleOld;{restore}
end;

procedure wcmn_memo_dos2win(Page: TMemo);
var i: integer; VisibleOld: boolean;
begin
  VisibleOld:=Page.Visible;{save}
  Page.Visible:=false;
  if Page.Lines.Count>0 then for i:=0 to Page.Lines.Count-1 do begin
    Page.Lines[i]:=wcmn_dos2win(Page.Lines[i]);
  end;
  Page.Visible:=VisibleOld;{restore}
end;

function wcmn_UTF2System(s: string): string;
begin
    Result:=UTF8TOCP1251(s);
end;

function wcmn_System2UTF(s: string): string;
begin
    Result:=CP1251ToUTF8(s);
end;

procedure SetLengthFill(var S: string; Len: Integer; FillChar: Char; clear: boolean);
var i, l0: Integer;
begin
  if clear then l0:=0 else l0:=Length(S);
  SetLength(S, Len);
  if Len>l0 then for i:=l0+1 to Len do S[i]:=FillChar;
end;


function IntToStrFill(num, len: Integer; cfill: char): string;
var s: string; slen: Integer;
begin
  SetLength(Result, len);
  FillChar(Result[1], len, cfill);

  s := IntToStr(num);
  slen := length(s);

  if slen>len then begin
    FillChar(Result[1], len, '*');
    exit;
  end;

  if slen>0 then memcpy(PChar(@Result[1])+(len-slen), @s[1], slen);
end;

function Formatn(const Fmt: string; const Args: array of const): string;
var Fmt2, s: string; n, l: Integer;
begin
  Fmt2 := '';
  s := Fmt;

  while true do begin

    n := System.Pos('\n', s);
    if n=0 then begin Fmt2 := Fmt2 + s; break; end;
    if n>1 then Fmt2 := Fmt2 + System.Copy(s, 1, n-1);
    Fmt2 := Fmt2 + _EOL_;
    l := Length(s) - (n+1);
    if l>0 then s := System.Copy(s, n+2, l)
    else break;

  end;

  Result := Format(Fmt2, Args);
end;

function InsertStr(var s: string; const subs: string; start: Integer): string;
var lnew,lsubs: Integer;
begin
  lsubs:=Length(subs);
  lnew := start-1 + lsubs;
  if lnew>Length(s) then SetLengthFill(s,lnew,' ',false);
  memcpy(@s[start], @subs[1], lsubs);
  Result:=s;
end;

function InsertStr2(var s: string; const subs: string; var position: Integer; dposition: Integer): string;{position>=1}
begin
  InsertStr(s, subs, position);
  inc(position, dposition);//смещение!
  Result:=s;
end;


function isdigit(c: char): boolean; {цифра}
begin
  Result := c in ['0'..'9'];
end;

function isdigit2(c: char): boolean; {цифра со знаком}
begin
  Result := c in ['+','-','0'..'9'];
end;

function isdigitstring(s: string): boolean;
var i,m: Integer;
begin
  Result := false;
  m := Length(s);
  if m=0 then Exit;
  for i:=1 to m do if not isdigit(s[i]) then Exit;
  Result := true;
end;

function isnumstring(s: string; var isreal: boolean): boolean; {+-.,0..9}
var i,m: Integer;
begin
  Result := false;
  isreal := false;
  m := Length(s);
  if m=0 then Exit;
  for i:=1 to m do
    if not (s[i] in ['+','-','0'..'9']) then begin
      if s[i] in ['.',','] then begin
        if isreal then exit {повторение точки}
        else isreal := true;
      end else exit;
    end;
  Result := true;
end;

function isintstring(s: string): boolean; {+-0..9}
var i,m: Integer;
begin
  Result := false;
  m := Length(s);
  if m=0 then Exit;
  for i:=1 to m do if not (s[i] in ['+','-','0'..'9']) then Exit;
  Result := true;
end;

function isdmcode(s: string): boolean; {0..9, 1-ый м.б. буква English}
var i,m: Integer;
begin
  Result := false;
  m := Length(s);
  if m<>8 then Exit;//!
  if not (s[1] in ['0'..'9']) and not isalfa(s[1]) then Exit;
  for i:=2 to m do if not (s[i] in ['0'..'9']) then Exit;
  Result := true;
end;

function isalfa(c: char): boolean;  {буква English}
begin
  Result := c in ['A'..'Z','a'..'z','_'];
end;

function isalfa2(c: char): boolean;  {буква}
begin
  Result := isalfa(c) or (ord(c)>=192);
end;

function isname(s: string): boolean;  {буквы или цифры, 1-ая буква}
var i: integer;
begin
  Result := false;
  if length(s)=0 then exit;
  if not isalfa(s[1]) then exit;
  for i:=1 to length(s) do if not ( isalfa(s[i]) or isdigit(s[i]) ) then exit;
  Result := true;
end;


function s_get_digitword(s: string; sn{>0}: integer): string;//цифровое слово вокруг позиции sn
var n1,n2{positions>=1}: integer;
begin
  Result:='';
  if not isdigit(s[sn]) then EXIT;//курсор - на цифре!
  n1:=sn;
  while (n1>1) and isdigit(s[n1-1]) do dec(n1);
  n2:=sn;
  while (n2<Length(s)) and isdigit(s[n2+1]) do inc(n2);
  Result:=system.Copy(s,n1,n2-n1+1);//>=1 символ
end;

const
  chrRusSmalla: Char = ' ';
  chrRusBigA: Char = ' ';
  chrRusSmallya: Char = ' ';
  chrRusBigYa: Char = ' ';
  chrRusSmally0: Char = ' ';

  SmallLetters : Set of Char = ['a'..'z'];


function s_toupcase(s:string):string; {no var!}
var i:word;
begin
     Result:=s;
     if Length(s)=0 then exit;
     for i:=1 to Length(s) do  begin
       if s[i] in SmallLetters then
          dec(s[i],32)
       else
       if s[i] = chrRusSmally0 then
          dec(s[i],1);
     end;
     Result := s;
end;


function s_trunc(s:string):string; {no var!}
var i,n:word;
begin
     n:=Length(s);
     if length(s)>0 then for i:=length(s) downto 1 do
         if s[i]=#32 then dec(n) else break;
     SetLength(s,n);
     Result := s;
end;


function rvaldef(s: string; defval: real): real;
var r: real; n,valerr: integer;
begin
  n := pos(',',s); if (n>0) then s[n] := '.';
  val(s,r,valerr);
  {$IFDEF VALERRORMSG}
  if valerr>1 then begin
    Tell(Format('RealValueError: Index=%d in "%s"',[valerr,s]));
    s:=copy(s,1,valerr-1);
    val(s,r,valerr);
  end;
  {$ENDIF}
  if valerr=0 then rvaldef:=r else rvaldef:=defval;
end;

function ivaldef(s: string; defval: longint): longint;
var i: longint; valerr: integer;
begin
  val(s,i,valerr);
  {$IFDEF VALERRORMSG}
  if valerr>1 then begin
    Tell(Format('IntegerValueError: Index=%d in "%s"',[valerr,s]));
    s:=copy(s,1,valerr-1);
    val(s,i,valerr);
  end;
  {$ENDIF}
  if valerr=0 then ivaldef:=i else ivaldef:=defval;
end;


function bools(b: boolean): string;
begin
  if b then bools := 'TRUE' else bools := 'FALSE';
end;



//копирует слова, пока Len<=maxlen:
function sgetwords_maxlen(var s: string; maxlen: integer): string;  {n>=1, VAR}
var sn,sn_,sl: integer; sw,s2: string;
begin
  Result:=s;//default
  sn_:=0;//default
  sl:=Length(s);

  sn:=1;
  while TRUE do begin
    sw:=sgetword(s,sn);
    if Length(sw)>0//слово
      then begin
        if sn<=maxlen then sn_:=sn//save
        else BREAK;//sn>maxlen - END!
      end
    else BREAK;//нет слова - END!
  end;//while TRUE

  //строка кончилась:
  if Length(sw)=0 then EXIT;//!

  //sn>maxlen:
  if (sn>maxlen) and (sn_>1{!}) then begin
    Result:=system.Copy(s,1,sn_-1{-1 ?});//начало
    s2:=system.Copy(s,sn_,sl-sn_+1);//конец
    s:=s2;//изменение s!
  end;
end;

procedure sgetwords_maxlen(s: string; maxlen: integer; strings: tstrings);
var s1,s2: string;
begin
  strings.Clear;
  s1:=s;
  s2:='';

  while TRUE do begin
    s2:=sgetwords_maxlen(s1, maxlen);
    if s2<>s1 then strings.Add(s2)
    else BREAK;//!
  end;

  if Length(s2)>0 then strings.Add(s2);
end;



function sgetword(s: string; var sn: integer): string;  {n>=1, VAR}
var wbegin:boolean; i,iw: integer; c: char;
begin
  wbegin:=false;
  Result:='';
  if (sn=0) or (sn>length(s)) then exit;

  i:=sn-1; iw:=i;
  while true do begin
    inc(i); {min=1}
    if (i>length(s)) then break;
    c:=s[i];
    if (c<=' ') then   if wbegin then break else continue;
    if not wbegin then begin iw:=i; wbegin:=true; end;
  end;
  if wbegin then Result:=copy(s,iw,i-iw);
  sn:=i;
end;

//Result - с разделителем в конце:
function sgetword2(s: string; var sn: integer; delims: string): string;  {n>=1, VAR}
var wbegin,wasdelim:boolean; i,iw: integer; c: char;
begin
  wbegin:=false;
  wasdelim:=false;
  Result:='';
  if (sn<=0) or (sn>length(s)) then exit;

  i:=sn-1; iw:=i;
  while true do begin
    inc(i); {min=1}
    if (i>length(s)) then break;
    if wasdelim then break;
    c:=s[i];
    if (c<=' ') then   if wbegin then break else continue;
    if pos(c,delims)>0 then wasdelim:=true;//и к след-му символу ("перенос")
    if not wbegin then begin iw:=i; wbegin:=true; end;
  end;
  if wbegin then Result:=copy(s,iw,i-iw);
  sn:=i;
end;

//Result - без разделителя в конце:
function sgetword3(s: string; var sn: integer; delims: string): string;  {n>=1, VAR}
var l: integer; c: char;
begin
  Result:=sgetword2(s,sn,delims);
  while true do begin
    l:=Length(Result);
    if l<=0 then break;
    c:=Result[l];//последний символ
    if pos(c,delims)>0 then SetLength(Result,l-1) else break;
  end;
end;


procedure sgetlist0(s0: string; sl: TStrings; delimeter: char);//s0->sl: список через "delimeter"
var n: integer; s2: string;
begin
  sl.Clear;
  n:=1;
  while true do begin
    s2:=sgetword2(s0, n, delimeter);//n увеличивается
    if Length(s2)=0 then break;
    if s2[Length(s2)]=delimeter then SetLength(s2,Length(s2)-1);//в конце разделитель м.б.(!)
    if Length(s2)>0 then sl.Add(s2);
  end;
end;

procedure sgetlist3(s0: string; sl: TStrings; delims: string);//s0: список через "delims"
var n: integer; s2: string;
begin
  sl.Clear;//!
  n:=1;
  while true do begin
    s2:=sgetword3(s0, n, delims);//без разделителей в конце, n увеличивается
    if Length(s2)=0 then break;//!
    //if pos(s2[Length(s2)], delims)>0 then SetLength(s2,Length(s2)-1);//в конце разделитель м.б.(!)
    sl.Add(s2);
  end;
end;


procedure sgetlist(s0: string; sl: TStrings);//s0->sl: список через ";"
const delimeter=';';
begin
  sgetlist0(s0, sl, delimeter);
end;

procedure zstring2stringlist(zs: pchar; sl: TStrings; delimeter: char);//zs->sl: список через ";"
var p,p2,pend: pchar;
begin
  sl.Clear;
  p:=zs;
  pend:=StrEnd(zs);//null-char at then end
  while (p<>nil) and (p<pend) do begin
    p2:=StrScan(p, delimeter);
    if p2=nil then p2:=pend;//в конце может не быть разделителя!
    p2^:=#0;//замена(!) очередного разделителя
    if StrLen(p)>0
      then sl.add( StrPas(p) )
      else if p2<pend then sl.add('');//;; - пустой элемент
    p:=p2+1;
  end;//while
end;

procedure string2stringlist(s: string; sl: TStrings; delimeter: char);
var zs: pchar; l: integer;
begin
  sl.Clear;
  l:=length(s); if l=0 then exit;

  zs:=malloc(l+1);
  try
    StrPCopy(zs,s);
    zstring2stringlist(zs, sl, delimeter);//меняет zs
  finally
    mfree2(zs);
  end;
end;

procedure stringlist2string(sl: TStrings; var s: string);//sl->s: список через ";"
const delimeter=';';
var i: integer;
begin
  s:='';//!
  if sl.count>0 then for i:=0 to sl.count-1 do begin
    if i>0 then s:=s+delimeter;
    s:=s+sl[i];
  end;
end;

function sread_word(var s: string): string;
var sn: integer;
begin
  sn:=1;
  Result:=sgetword(s,sn);
  if Length(s)-sn+1<=0 then s:=''
  else s:=system.copy(s,sn,Length(s)-sn+1);
end;


function sread_int(var s: string; defval: longint): longint;
var sw: string;
begin
  sw:=sread_word(s);
  Result:=ivaldef(sw, defval);
end;

function sread_int(var s: string): longint;
begin
  Result:=sread_int(s, 0{defval});
end;


function sread_real(var s: string): real;
var sw: string;
begin
  sw:=sread_word(s);
  Result:=rvaldef(sw,0);
end;


function ps_string(s:string):string;  { '\' -> (\\) }
var ss:string; i,j:word;
begin
     SetLength(ss,255);
     j:=0;
     if length(s)>0 then for i:=1 to Length(s) do begin
         inc(j);
         if s[i]=#92 {\} then begin ss[j]:=#92; inc(j); end;
         ss[j]:=s[i];
     end;
     SetLength(ss,j);
     ps_string:=ss;
end;

procedure wcmn_ChangeChars(var s: string; c1,c2: char);//c1->c2
var i,n: integer;
begin
  n:=Length(s);
  if n>0 then for i:=1 to n do if s[i]=c1 then s[i]:=c2;
end;


{ DIR: }

function TmpDir: string;
var s: string;
begin
  s := wcmn_GetEnv('TEMP');
  if (length(s)=0) then s := wcmn_GetEnv('TMP');
  if (length(s)>0) and (s[length(s)]<>'\') then s := s + '\';
  if (length(s)=0) then s := TmpDirDefault;
  TmpDir := s;
end;

function ExeDir: string;
begin
  ExeDir := wcmn_file_dir(Application.ExeName);
end;

function UpperDir(dir: string): string;  {..\}
var zdir: TCharsBuf; p: pchar;
begin
  Result := '';
  if Length(dir)=0 then exit;
  if dir[Length(dir)]='\' then SetLength(dir, Length(dir)-1);
  StrPCopy(zdir,dir);
  p := StrRScan(zdir,'\'); {последнее вхождение}
  if p<>nil then begin
    (p+1)^:=#0;
    Result := StrPas(zdir);
  end;
end;


function DirExists(dirname: string): boolean; {with '\' OR without}
var fa: integer;
begin
  Result:=false;
  if dirname='' then exit;

  {директория д.б. без '\', а корень - с '\' - так работает FileGetAttr}
  if dirname[ Length(dirname) ] = '\'
    then SetLength( dirname, Length(dirname) - 1 );
  if dirname[ Length(dirname) ] = ':'
    then dirname := dirname + '\';

{$WARNINGS OFF}
  fa := FileGetAttr( dirname );//platform
{$WARNINGS ON}
//  if fa=faDirectory then Result:=true else Result:=false;
  if (fa<>-1) and ((fa and faDirectory)<>0) then Result:=true else Result:=false;
end;


//файлы из директории (shortnames!):
//НЕ ЧИТАЕТ: поддиректории, скрытые(h), системные(s) файлы:
procedure wcmn_dir_getfiles(pathmask{c:\*.*}: string; dirfiles{clear}: tstrings);
var
  sr: TRawByteSearchRec;//SysUtils
  FileAttrs: Integer;
begin
  dirfiles.Clear;

  FileAttrs := 0;//все
  //FileAttrs := faReadOnly;//?

  if FindFirst(pathmask, FileAttrs, sr)=0//=>sr определилась
  then try
    repeat
      //if (sr.Attr and FileAttrs)<>sr.Attr then continue;
      //if (sr.Attr and faDirectory)<>0 then continue;//исключая поддиректории!
      dirfiles.Add(sr.Name);
    until FindNext(sr)<>0;//<>0 - следующий файл не найден
  finally
    SysUtils.FindClose(sr);
  end;
  //Tellf('DirFiles "%s": %d',[pathmask, dirfiles.Count]);//DEBUG
end;


{ FILE: }

function ftopen(var f:TextFile; name:string; mode:char):boolean;
begin
  ftopen:=false;
  if Length(name)=0 then exit;
  AssignFile( f, name );

  case mode of
    'r': begin
           {$I-} system.reset(f); {reset(f);} {$I+}
           if IOResult=0 then ftopen:=true;
         end;
    'a': begin
           {$I-} system.append(f); {append(f);} {$I+}
           if IOResult=0 then ftopen:=true;
         end;
    'w': begin
           {$I-} system.rewrite(f); {$I+}
           if IOResult=0 then ftopen:=true;
         end;
    end; {case}
end;

function ftopen_msg(var f:TextFile; name:string; mode:char):boolean;
begin
   ftopen_msg := true;
   if ftopen(f,name,mode) then exit;
   Tellf(telllist[1], [name]);
   ftopen_msg := false;
end;

procedure ftclose(var f: TextFile);  {даже на неоткрытом файле}
begin
  try
    CloseFile(f);
  except on Exception do ;
  end;
end;


function fopen(var f: File; name: string; mode: char):boolean;
begin
  Result:=false;
  if Length(name)=0 then exit;
  AssignFile( f, name );

  case mode of
    'r': begin
           {$I-} system.reset(f,1); {reset(f);} {$I+}
           if IOResult=0 then Result:=true;
         end;
    'w': begin
           {$I-} system.rewrite(f,1); {$I+}
           if IOResult=0 then Result:=true;
         end;
    end; {case}
end;

function fopen_msg(var f: File; name: string; mode: char):boolean;
begin
   Result := true;
   if fopen(f,name,mode) then exit;
   Tellf(telllist[1], [name]);
   Result := false;
end;

procedure fclose(var f: File);  {даже на неоткрытом файле}
begin
  try
    CloseFile(f);
  except on Exception do ;
  end;
end;

{возвращает количество скопированных файлов:}
function wcmn_filecopy0(names1: array of string; name2:string; _msg_in,_msg_out: boolean): integer;
var f1,f2: TFileStream;
    i,j: Integer; _opened: boolean;
begin
  Result := 0;
  f1:=nil;

  if FileExists(name2) then begin
    SysUtils.DeleteFile(name2);
    Application.ProcessMessages;//!
  end;
  try f2:=TFileStream.Create(name2,fmCreate);
  except
    if _msg_out then
      Tellf(telllist[2],[name2]);
    exit;
  end;

  try
  for i:=Low(names1) to High(names1) do begin
    _opened:=false;
    for j:=1 to 1{1000} do try
      f1:=TFileStream.Create(names1[i],fmOpenRead);
      _opened:=true;
      break;
    except
    end;
    if not _opened then begin
      if _msg_in then
        Tellf(telllist[1],[names1[i]]);
      continue;
    end;

    try f2.CopyFrom(f1,0);
    finally f1.Free;
    end;
    inc(Result);

  end;{for i}
  finally
    f2.Free;
  end;{try}
end;
function wcmn_filecopy(names1: array of string; name2:string): integer;
begin
  Result:=wcmn_filecopy0(names1, name2, true, true);
end;
function wcmn_filecopy1(name1,name2: string): boolean;
var names: array of string;
begin
  SetLength(names,1);
  names[0]:=name1;
  Result := wcmn_filecopy0(names, name2, false, false)>0;
end;


function wcmn_FileExists_msg(path: string; _exitmsg: boolean): boolean;
begin
    Result := FileExists(path);
    if not Result then
    if _exitmsg
    then Tellf('File not found: "%s" - EXIT',[path])
    else Tellf('File not found: "%s"',[path]);
end;

function wcmn_filesize(fname:string): longint;
var f: file;
begin
  Result:=0;
  assign(f,fname);
  {$I-} reset(f,1); {$I+}
  if IOResult<>0 then exit;
  Result:=FileSize(f);
  CloseFile(f);
end;

function wcmn_file_dir0(fullname: string): string;
var s: string; l: integer;
begin
  s := ExtractFilePath(fullname);
  l:=length(s);
  if (l>0) and (s[l]='\') then SetLength(s,l-1);
  Result := s;
end;

function wcmn_file_dir(fullname: string): string;
var s: string; l: integer;
begin
  s := ExtractFilePath(fullname);
  l:=length(s);
  if (l>0) and (s[l]<>'\') then s:=s+'\';
  Result := s;
end;

function wcmn_file_nameext(fullname: string): string;
begin
  Result := ExtractFileName(fullname);
end;

function wcmn_file_name(fullname: string): string;
var s: string; n: byte;
begin
  s := ExtractFileName(fullname);
  n := Pos('.',s);
  if n>0 then s := Copy(s,1,n-1);
  wcmn_file_name := s;
end;

function wcmn_file_dirname(fullname: string): string;
begin
  wcmn_file_dirname := wcmn_file_dir(fullname) + wcmn_file_name(fullname);
end;

function wcmn_file_ext0(fullname: string): string;
var s: string;
begin
  s := ExtractFileExt(fullname);//with '.' or ''
  if (length(s)>0) and (s[1]='.') then s := system.copy(s,2, Length(s)-1);
  Result := s;
end;

function wcmn_file_ext(fullname: string): string;
var s: string;
begin
  s := ExtractFileExt(fullname);//with '.' or ''
  if (length(s)>0) and (s[1]<>'.') then s := '.' + s;
  Result := s;
end;

function wcmn_DeleteFile(fname: string; _msg: boolean): boolean;
begin
  Result:=true;
  if FileExists(fname) then Result:=SysUtils.DeleteFile(fname);
  if not Result and _msg then Tellf('Unable delete file "%s"',[fname]);
end;

function wcmn_RenameFile(fname1,fname2: string): boolean;//переписывает при наличии
begin
  if FileExists(fname2) then SysUtils.DeleteFile(fname2);
  Result:=RenameFile(fname1,fname2);
end;

function wcmn_Access(fname: string): boolean;
var fh: integer;
begin
  Result:=false;
  fh:=FileOpen(fname, fmOpenReadWrite	or fmShareExclusive);
  if fh>=0 then begin//-1 - error
    Result:=true;
    FileClose(fh);
  end;
end;


{ MESSAGE: }

procedure SetTellTitle;
begin
  if Length(TellTitle)=0
    then TellTitle := wcmn_file_name(Application.ExeName);
end;

procedure Tell(Msg: string);
//var zs0, zs1: TCharsBuf;
begin
  MessageBeep(mb_Ok);
  SetTellTitle;

  //MessageDlg(Msg, mtInformation, [mbYes], 0);
  //Application.MessageBox(StrPCopy(zs1,Msg), StrPCopy(zs0,TellTitle), mb_Ok or mb_IconInformation);
  //Application.MainForm.
  Application.MessageBox(PChar(Msg), PChar(TellTitle), mb_Ok or mb_IconInformation);
  //ShowMessage(Msg);
end;

procedure Tell2(MsgAr: array of string);
var s: string; i: integer;
begin
  s:='';
  for i:=Low(MsgAr) to High(MsgAr) do begin
    if i>Low(MsgAr) then s := s + _EOL_;
    s := s + MsgAr[i];
  end;
  Tell(s);
end;

procedure Tellf(const Fmt: string; const Args: array of const);
begin
  Tell( Formatn(Fmt, Args) );
end;

procedure About(Msg: string);
begin
  Tell(Msg);
end;

procedure TellInt(Msg: string; n: longint);
var s: string;
begin
  str(n,s);
  s := Msg + _EOL_ + s;
  Tell(s);
end;

function TellYN(Msg: string): boolean;
var retn: integer; zs0, zs1: TCharsBuf;
begin
   MessageBeep(mb_Ok);
   SetTellTitle;
   Result:=true;
   retn := Application.MessageBox(StrPCopy(zs1,Msg), StrPCopy(zs0,TellTitle), mb_YesNo or MB_ICONQUESTION);
   if (retn=IdNo) or (retn=IdCancel) then Result:=false;
end;

function Warning(Msg: string): boolean;
begin Result := TellYN(Msg); end;

function TellYNC(Msg: string): integer;  {1,0,-1}
var retn: integer; zs0, zs1: TCharsBuf;
begin
   MessageBeep(mb_Ok);
   SetTellTitle;
   Result := -1;
   retn := Application.MessageBox(StrPCopy(zs1,Msg), StrPCopy(zs0,TellTitle), mb_YesNoCancel or MB_ICONQUESTION);
   case retn of
      IdYes: Result:=1;
      IdNo: Result:=0;
      IdCancel: Result:=-1;
      else Tell('Uncnown return in MessageBox: '+IntToStr(retn));
   end;
end;

function TellYAN(Msg: string): integer;  {1,2,0,-1}
var retn: integer;
begin
   MessageBeep(mb_Ok);
   Result := -1;
   retn := MessageDlg(Msg, mtConfirmation, [mbYes,mbAll,mbNo], 0);
   case retn of
      mrYes: Result:=1;
      mrAll: Result:=2;
      mrNo: Result:=0;
      mrCancel: Result:=-1;
      else Tell('Uncnown return in MessageDlg: '+IntToStr(retn));
   end;
end;

function TellfYN(const Fmt: string; const Args: array of const): boolean;
begin Result := TellYN( Formatn(Fmt, Args) ); end;

function TellfYNC(const Fmt: string; const Args: array of const): integer;  {1,0,-1}
begin Result := TellYNC( Formatn(Fmt, Args) ); end;

function TellfYAN(const Fmt: string; const Args: array of const): integer;  {1,2,0,-1: close}
begin Result := TellYAN( Formatn(Fmt, Args) ); end;
{--------------------------------}
initialization
  IniDll:= NIL;
  telllist:=TStringList.Create;

  Ini := TIni.Create;

  DecimalSeparator := Char('.');
  //ThousandSeparator := 0;  // SysUtils's VAR!

  telllist.Add('Укажите правильный путь к %s');//0  //GsOpt
  telllist.Add('Невозможно открыть файл "%s"');//1  //Wcmn
  telllist.Add('Невозможно создать файл "%s"');//2
  telllist.Add('Невозможно удалить файл "%s"');//3
  telllist.Add('');//4

  telllist.Add('Некорректный размер у карты "%s" (dm_Resolution)');//5
  telllist.Add('Некорректный масштаб у карты "%s" (lpmm)');//6
  telllist.Add('Нет активной карты');//7
  telllist.Add('');//8
  telllist.Add('');//9
(*
  telllist.Add('');//0
  telllist.Add('');//1
  telllist.Add('');//2
  telllist.Add('');//3
  telllist.Add('');//4

  telllist.Add('');//5
  telllist.Add('');//6
  telllist.Add('');//7
  telllist.Add('');//8
  telllist.Add('');//9
*)

  chrRusSmalla := UTF8ToAnsi('а')[1];
  chrRusBigA   := UTF8ToAnsi('А')[1];
  chrRusSmallya:= UTF8ToAnsi('я')[1];
  chrRusBigYa  := UTF8ToAnsi('Я')[1];
  chrRusSmally0:= UTF8ToAnsi('ё')[1];
  SmallLetters := SmallLetters + [chrRusSmalla..chrRusSmallya];

finalization
  Ini.Free;
  if Assigned(IniDll) then ObjFree(TObject(IniDll));//!

  telllist.Free;

END.
