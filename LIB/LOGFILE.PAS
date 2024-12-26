unit Logfile; interface

uses Windows, wcmn{TLevel};

(*
{$DEFINE LOGWIN16}  {WinCrt == LogFile}
*)
(*
{$DEFINE LOGWIN32}  {32 bit Window == LogFile}
*)

{
     Log.W(lMIN,...)-самая редкая запись.
     Log.MinLevel:=lMIN-печатать все.
}
const DefaultMinLevel = lMIN; {lMIN: печатать все}

type
  TLog = class
  private
    Status : Integer;
    FMinLevel  : TLevel; {lMIN: печатать все}
    FFile  : TextFile;
    {$IFDEF LOGWIN16}
    FWin   : TextFile;
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;

    procedure W(lev: TLevel; const s: string);
    procedure Wf(lev: TLevel; const Fmt: string; const Args: array of const);
    procedure _(lev: TLevel; const Fmt: string; const Args: array of const); {\n[time] -}

    property MinLevel: TLevel read FMinLevel write FMinLevel;
  end;

var
  Log: TLog;


implementation

uses
  {$IFDEF LOGWIN16} WinCrt, {$ENDIF}
  {$IFDEF LOGWIN32} Window, {$ENDIF}    {xxx\delphi\lib: Win}
  SysUtils, Forms;


constructor TLog.Create;
var name, namebak: string;
begin
  FMinLevel := DefaultMinLevel;

  name := ChangeFileExt(Application.ExeName, '.LOG');
  if FileExists(name) then begin
    namebak := ChangeFileExt(Application.ExeName, '.BAK');
    DeleteFile(namebak);
    RenameFile(name, namebak); {false, if exists "NewName"}
  end;

  if not ftopen(FFile, name, 'w') then Status := E_FileCreate;
  {$IFDEF LOGWIN16}
  AssignCrt(FWin); Rewrite(FWin);
  {$ENDIF}
  {$IFDEF LOGWIN32}
  if Win<>nil then Win.Show;
  {$ENDIF}

  Wf(lMAX, '*** ЖУРНАЛ "%s" ***', [name]);
  _(lMAX, 'НАЧАЛО РАБОТЫ', [0]);
end;

destructor TLog.Destroy;
begin
  if Status<>0 then Exit;
  _(lMAX, 'КОНЕЦ РАБОТЫ', [0]);
  {
  Tell('КОНЕЦ РАБОТЫ');
  }
  ftclose(FFile);
  {$IFDEF LOGWIN16}
  CloseFile(FWin);
  {$ENDIF}
end;

procedure TLog.W(lev: TLevel; const s: string);
begin
  if Status<>0 then Exit;
  if lev<FMinLevel then Exit;

  system.write( FFile, s );
  system.flush( FFile );

  {$IFDEF LOGWIN16}
  system.write( FWin, s );
  system.flush( FWin );
  {$ENDIF}
  {$IFDEF LOGWIN32}
  if Win<>nil then begin
    Win.WriteS( s );
    if not Win.Visible then Win.Show;
  end;
  {$ENDIF}
end;

procedure TLog.Wf(lev: TLevel; const Fmt: string; const Args: array of const);
var s: string;
begin
  s := Formatn( Fmt, Args );
  W( lev, s );
end;

procedure TLog._(lev: TLevel; const Fmt: string; const Args: array of const);
begin
  Wf( lev, '\n[%s] - ', [DateTime_s]);
  Wf( lev, Fmt, Args );
end;

{---------------------------------------------------}
initialization
  Log := TLog.Create;
finalization
  Log.Free;

end.
