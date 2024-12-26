unit GsOpt;

{$MODE Delphi}

 interface

uses
  SysUtils,LCLIntf, LCLType, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;


{включает "-q -IGSDIR;MSLIBDIR;FONTS;INCLUDE ":}
procedure exec_gs(params: string);
procedure exec_gs_inc(AddIncDirs, params: string; _wait: boolean);

{включает "-q -IGSDIR;IncDirs ":}
function exec_gs2(GsPath, IncDirs, params: string; _wait{ожидание окончания}: boolean): boolean;


type

  { TGsOptDlg }

  TGsOptDlg = class(TForm)
    GsBox: TGroupBox;
    GsPathBtn: TButton;
    GsLabel: TLabel;
    GsOpen: TOpenDialog;
    Label2: TLabel;
    LibBox: TGroupBox;
    LibLabel: TLabel;
    LibPathBtn: TButton;
    LibOpen: TOpenDialog;
    Label1: TLabel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure GsPathBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure LibPathBtnClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Init;//проверка путей
  end;

var GsOptDlg: TGsOptDlg;


implementation

{$R *.lfm}
uses Wcmn;


{ GS: }

{дополнительно к GsDir!}
function make_inc_dirs: string;
var libdir,msdir: string;
begin
  Result:='';

  libdir:=wcmn_file_dir0(GsOptDlg.LibLabel.Caption);
  if libdir<>'' then Result:=libdir+';';
(*
  if xobs then with FormMain.XobList do if Items.Count>0
    then for i:=0 to Items.Count-1 do Result:=Result+wcmn_file_dir0(Items[i])+';';
*)
  msdir:=UpperDir(libdir); {with '\'}
  if msdir<>'' then begin
    if DirExists(msdir+'FONTS') then Result:=Result+msdir+'FONTS'+';';
    if DirExists(msdir+'INCLUDE') then Result:=Result+msdir+'INCLUDE'+';';
  end;

  if Length(Result)>0 then SetLength(Result,Length(Result)-1);
end;

{включает "-q -IGSDIR;MSLIBDIR;FONTS;INCLUDE "}
procedure exec_gs(params: string);
var GsPath, IncDirs: string;
begin
  GsPath:=wcmn_UTF2System(GsOptDlg.GsLabel.Caption);
  IncDirs:=make_inc_dirs;
  exec_gs2(GsPath, IncDirs, params, false);
end;

procedure exec_gs_inc(AddIncDirs, params: string; _wait: boolean);
var GsPath, IncDirs: string;
begin
  GsPath:=wcmn_UTF2System(GsOptDlg.GsLabel.Caption);
  IncDirs:=make_inc_dirs;
  if AddIncDirs<>'' then IncDirs:=IncDirs+';'+AddIncDirs;
  exec_gs2(GsPath, IncDirs, params, _wait);
end;

function exec_gs2(GsPath, IncDirs, params: string; _wait: boolean): boolean;
var GsInc, sexec: string;
begin
  GsInc := wcmn_file_dir0(GsPath);
  if IncDirs<>'' then GsInc := GsInc + ';' + IncDirs;
  sexec := Format('%s -q -I%s %s',[GsPath,GsInc,params]);

  Result:=wcmn_exec2(sexec, _wait{ожидание окончания});
end;


{ TGsOptDlg: }

procedure TGsOptDlg.Init;//проверка путей
label start;
var s, gslib: string;
begin
  //language from ExeName.msg:
  if wcmn_language_test('') then wcmn_language_form(Self);

    Ini.Section:='General';
    GsLabel.Caption := Ini.RS('GsPath','C:\MS\BIN\GSWIN32.EXE');
    LibLabel.Caption := Ini.RS('MsLibPath','C:\MS\LIB\PSL.INI');

start:

    s:='';
    gslib:= GsOptDlg.GsLabel.Caption;
    if not FileExists(gslib) then begin
      s:=s+_EOL_+'"GhostScript" (gswin32.exe)';
    end;
    if not FileExists(gslib) then begin
      s:=s+_EOL_+'"PSL.INI" (MS\LIB)';
    end;
    if s<>'' then begin
      Tellf(telllist[0],[s]);
      if ShowModal=mrOk
      then goto start
      else exit;{директории остались неправильными!}
    end;
end;


{ Events: }

procedure TGsOptDlg.GsPathBtnClick(Sender: TObject);
begin
   GsOpen.FileName := GsLabel.Caption;
   if GsOpen.Execute then GsLabel.Caption := GsOpen.FileName;
end;

procedure TGsOptDlg.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TGsOptDlg.LibPathBtnClick(Sender: TObject);
begin
   LibOpen.FileName := LibLabel.Caption;
   if LibOpen.Execute then LibLabel.Caption := LibOpen.FileName;
end;

procedure TGsOptDlg.FormHide(Sender: TObject);
begin
  try
    Ini.Section:='General';
    Ini.WS('GsPath',GsLabel.Caption);
    Ini.WS('MsLibPath',LibLabel.Caption);
  except
    Tell('TGsOptDlg.FormDestroy: Exception on IniFile');
  end;
end;

procedure TGsOptDlg.OkBtnClick(Sender: TObject);
begin

end;

end.
