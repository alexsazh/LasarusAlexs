{Data for COMPOSITE PS-objects:}
unit PSOBJX;

{$MODE Delphi}

 interface

uses
  classes;
  {list, arrayx, refobj, psprint, pstree;}

type

  TPsObjX = class  {composite data}
    public
    constructor Create;
    function Exec: boolean; virtual; abstract;
    function CreateCopy: TPsObjX; virtual; abstract;
    function Print: string; virtual; abstract;
    procedure SaveToStream(st: TStream); virtual; abstract;
    procedure LoadFromStream(st: TStream); virtual; abstract;
    procedure CheckOperators; virtual;
  end;

  TPsStr = class(TPsObjX)
    public
    _: string;
    constructor Create;
    function Exec: boolean; override;
    function CreateCopy: TPsObjX; override;
    function Print: string; override;
    procedure SaveToStream(st: TStream); override;
    procedure LoadFromStream(st: TStream); override;
  end;


implementation

uses Wcmn, PSSCAN, PSOBJ;

{TPsObjX:}

constructor TPsObjX.Create; begin end;

procedure TPsObjX.CheckOperators; begin end;


{TPsStr:}

constructor TPsStr.Create;
begin
  inherited Create;
end;

function TPsStr.Exec: boolean;
var s, rem: string; proc_lev: integer;
begin
  s:=_;
  proc_lev:=0;
  Result:=false;
  try
    Result:=psscan_execfilestring(s, rem, proc_lev); {s changed!}
  except
    Tellf('EXCEPTION in Execution string "%s"',[_]);
    proc_lev:=0;
  end;
  if (proc_lev<>0) or (Length(s)<>0) then
    Tellf('ERROR in Execution string "%s"\nResult="%s"; proc_level=%d',[_,s,proc_lev]);
end;

function TPsStr.CreateCopy: TPsObjX;
var pss: TPsStr;
begin
  {Result:=TPsStr.Create;}

  pss:=TPsStr.Create;
  pss._:=_;
  Result:=pss;

end;

function TPsStr.Print: string;
begin
  Result:=_;
end;

procedure TPsStr.SaveToStream(st: TStream);
var i,l: integer;
begin
  i:=integer(stringtype); st.Write(i, sizeof(i));
  l:=Length(_); st.Write(l, sizeof(l));
  if l>0 then st.Write(_[1], l);
end;

procedure TPsStr.LoadFromStream(st: TStream);
var l: integer;
begin
  st.Read(l, sizeof(l));
  SetLength(_, l);
  if l>0 then st.Read(_[1], l);
end;


end.
