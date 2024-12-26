unit PSLIB;

{$MODE Delphi}

 interface

uses classes, forms, comctrls;

function pslib_init(aLogWin: TStrings; aInclude: string): boolean;
procedure pslib_done;

procedure pslib_setlogform(aForm: TForm);
procedure pslib_settreeform(aForm: TForm; aTree: TTreeView);

function pslib_runfile(fname: string): boolean;
function pslib_runcmdline(cmdline: string): boolean;

function pslib_runstring(str: string): boolean;

procedure pslib_savetofile(fname: string);
procedure pslib_loadfromfile(fname: string);


implementation

uses
  SysUtils,
  Wcmn, PSX, Pso, Psstacks ,PSOBJ, PSLOGS, Psdicts;

function pslib_init(aLogWin: TStrings; aInclude: string): boolean;
begin
  Result:=true;
  try
    PS:=TPostScript.Create; {var in psx.pas}
    if Assigned(aLogWin) then PS.LogWinOn(aLogWin);
    PS.IncludeAdd(aInclude);

    Ps.Vm.Global:=true;

    dictstack.Push(psobj_dict); {systemdict}
    dictstack.Push(psobj_dict); {globaldict}

    Ps.Vm.Global:=false;

    dictstack.Push(psobj_dict); {userdict}

    systemdict.Def(PS.Names.Key('statusdict'), psobj_dict);

    pso_create;

    PsLog_WL( '---BEGIN JOB---' );
    PsLog_WL( '' );
  except
    Result:=false;
    Tell('Ошибка инициализации PostScript');
  end;
end;

procedure pslib_done;
begin
  PsLog_WL( '' );
  PsLog_WL( '---END JOB---' );

  PS.free;
end;

procedure pslib_setlogform(aForm: TForm);
begin
  PS.FLogForm:=aForm;
end;

procedure pslib_settreeform(aForm: TForm; aTree: TTreeView);
begin
  PS.TreeForm:=aForm;
  PS.TreeView:=aTree;
end;

function pslib_runfile(fname: string): boolean;
begin
  Result:=false;
  if not Assigned(PS) then exit;
  Ps.Stat:=0;
  Result:=PS.RunFile(fname);
end;

function pslib_runcmdline(cmdline: string): boolean;
var s: string;
begin
  Result:=false;
  if not Assigned(PS) then exit;
  PS.Stat:=0;

  s:=cmdline;
  Result:=PS.RunCmdLine(s);

  PsLog_WL( '' );
  PsLog_WL( Format('---END of Command Line (%s)---',[cmdline]) );
end;


function pslib_runstring(str: string): boolean;
var s: string;
begin
  Result:=false;
  if not Assigned(PS) then exit;
  PS.Stat:=0;

  s:=str;
  Result:=PS.RunString(s);
end;


procedure pslib_savetofile(fname: string);
begin
  if Assigned(PS) then PS.SaveToFile(fname);
end;

procedure pslib_loadfromfile(fname: string);
begin
  if Assigned(PS) then PS.LoadFromFile(fname);
end;


end.
