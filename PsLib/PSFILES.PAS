unit psfiles; interface

uses
  classes,
  filex, psobjx;

type
  TPsFile = class(TPsObjX)
  private
    FLinePost: string;   {остаток строки}
    FLineNum: Integer;   {current line >=1}
    _: TFileX;  {_=nil <=> "closed"}
    function GetName: string;
  public
    constructor Create;
    destructor Destroy; override;

    function Open(aName: string; aMode: word): boolean;
    procedure Close; {m.b. nil}

    function Exec: boolean; override;
    function Token: boolean;
    function ReadLine(var s: string): boolean;

    function WriteString(s: string): boolean;

    function CreateCopy: TPsObjX; override;
    function Print: string; override;

    procedure SaveToStream(st: TStream); override;
    procedure LoadFromStream(st: TStream); override;

    function ReadLnS: string;    
    function EOF: boolean;

    property Name: string read GetName;
    property LineNum: Integer read FLineNum;
  end;


implementation

uses SysUtils, Forms,
  wcmn, psscan, pslogs, psstacks, psx, psobj;

function TPsFile.GetName: string;
begin
  Result:=_.Name;
end;


constructor TPsFile.Create;
begin
  inherited Create;
end;

destructor TPsFile.Destroy;
begin
  {Close;}
  _.Free; {m.b. nil}
  inherited Destroy;
end;

function TPsFile.Open(aName: string; aMode: word): boolean;
begin
  Result:=true;
  _.Free; {m.b. nil}
  try
    _:=TFileX.Create(aName, aMode, false);
  except
    Result:=false;
    _:=nil;
  end;
end;

procedure TPsFile.Close;
begin
  if _=nil then exit;
  _.Free;
  _:=nil;
end;

function TPsFile.Exec: boolean;
var rem: string; proc_lev: integer;
begin
  PsLog_WL(Format('---BEGIN file "%s"---',[Name]));

  Result:=true;
  _.Reset;
  proc_lev:=0;
  FLinePost:='';
  FLineNum:=0;

  try
    repeat
      if PS.Stat<>0 then break; {->true}
      FLinePost := FLinePost + _.ReadLnS;
      inc(FLineNum); {>=1}
      Result:=psscan_execfilestring(FLinePost, rem, proc_lev); {ln changed!}
      Application.ProcessMessages;
    until not Result or _.EOF;
  except
    Tellf('EXCEPTION in Execution file "%s"',[_.Name]);
    proc_lev:=0;
    Result:=false;
  end;
  PsLog_WL(Format('---END file "%s"---',[Name]));
end;

function TPsFile.Token: boolean;
var
  rem: string;
  proc_lev, stackcount: integer;
  EOS: boolean;
begin
  proc_lev:=0;
  stackcount:=operandstack.count;

  try
    repeat
      if FLinePost='' then begin
        FLinePost := _.ReadLnS;
        inc(FLineNum); {>=1}
      end;
      Result:=psscan_token(FLinePost, rem, proc_lev, false, EOS); {ln changed!}
      Application.ProcessMessages;
    until not Result or _.EOF or (proc_lev=0);
  except
    Tellf('EXCEPTION on TOKEN in file "%s"',[_.Name]);
    Result:=false;
    exit;
  end;
  (*
  _.Seek(-Length(FLinePost), soFromCurrent); {!!!}
  FLinePost:='';
  *)
  if not Result then begin
    Tellf('ERROR on TOKEN in file "%s"',[_.Name]);
    exit;
  end;

  if (proc_lev<>0) then begin
    Tellf('ERROR "proc_lev<>0" on TOKEN in file "%s"',[_.Name]);
    Result:=false;
    exit;
  end;

  case (operandstack.count-stackcount) of
    0: Result:=false;
    1: Result:=true;
    else begin
      Tellf('ERROR on TOKEN in file "%s":\ninc(stackcount,%d)',[_.Name,operandstack.count-stackcount]);
      Result:=false;
      exit;
    end;
  end;{case}
end;

function TPsFile.ReadLine(var s: string): boolean;
begin
  Result:=true;

  if FLinePost<>'' then begin
    s:=FLinePost;
    FLinePost:='';
    exit;
  end;

  inc(FLineNum);
  s:=_.ReadLnS;
  if (s='') and _.EOF then Result:=false;
end;

function TPsFile.WriteString(s: string): boolean;
var l,i,lout,iout: integer;
begin
  Result:=true;              {???}
{
  FLinePost:='';
  FLineNum:=0;
}
(*
  _.Write(s[1], Length(s));  {возвращает кол-во запис-ых байт}
*)
  if not Assigned(_) then begin
    Result:=false;
    Tellf('WriteString: FILE CLOSED!',[0]);
    exit;
  end;

  l:=Length(s);
  i:=1;
  lout:=0; {out-length}
  iout:=1;
  while i<=l do begin
    if (s[i]='\') and (i<l) then begin

      inc(i);
      case s[i] of
      'r':
        begin
          if lout>0 then _.Write(s[iout], lout);
          lout:=0;
          iout:=i+1;
          inc(i);
        end;
      'n':
        begin
          if lout>0 then _.WriteLn(s[iout], lout) else _.WriteEOL;
          lout:=0;
          iout:=i+1;
          inc(i);
        end;
      else
        begin
          if lout>0 then _.Write(s[iout], lout);
          lout:=0;
          iout:=i;
        end;
      end;{case}

    end else begin
      inc(i);
      inc(lout);
    end;{if}
  end;{while}

  if lout>0 then _.Write(s[iout], lout); {большинство строк!}
end;

function TPsFile.CreateCopy: TPsObjX;
{var psf: TPsFile;}
begin
  Result:=Self;
  Tell('ERROR: call TPsFile.CreateCopy');
(*
  psf:=TPsFile.Create;
  psf._:=_;
  if (_<>nil) then inc(_.RefCount);
  Result:=psf;
*)
end;

function TPsFile.Print: string;
begin
  if Assigned(_) then Result:=_.Name else Result:='CLOSED';
end;

procedure TPsFile.SaveToStream(st: TStream);
var i,l: integer; s: string; fmode: integer;
begin
  i:=integer(filetype); st.Write(i, sizeof(i));
  if Assigned(_) then begin
    s:=_.Name;
    fmode:=_.Mode;
  end else begin
    s:='';
    fmode:=0;
  end;
  st.Write(fmode, sizeof(fmode));
  l:=Length(s); st.Write(l, sizeof(l));
  if l>0 then st.Write(s[1], l);
end;

procedure TPsFile.LoadFromStream(st: TStream);
var l,fmode: integer; s: string;
begin
  st.Read(fmode, sizeof(fmode));
  st.Read(l, sizeof(l));
  SetLength(s,l);
  if l>0 then begin
    st.Read(s[1], l);
    {
    Open(s, fmode);    ???
    }
  end;
end;

function TPsFile.ReadLnS: string;
begin
  Result:=_.ReadLnS;
end;

function TPsFile.EOF: boolean;
begin
  Result:=_.EOF;
end;


end.
