unit Filex;

{$MODE Delphi}

 interface

uses Classes, Progress;

{
  Modes (fmXXX - in SysUtils):
    fmCreate,
    fmOpenRead,
    fmOpenWrite,
    fmOpenReadWrite

  fmCreate - файл может существовать
  fmOpenRead,fmOpenWrite,fmOpenReadWrite - файл должен существовать

  fmOpenRead => Write просто игнорируется
  fmOpenWrite => Read просто игнорируется

  fmOpenWrite & exist => не обнуляется
  fmCreate & exist => обнуляется
  fmCreate => fmOpenWrite (FLUSH нет!)

  fmOpenReadWrite - общая Position;

  Два объекта не могут открыть один файл!
}
type
  TFileX = class(TFileStream)
    private
      FName: string;
      FMode: word;
      FReadProgress: TProgressX; {Read,ReadLn}
      FEOL,FEOF: boolean; {"Reached": ReadLn,GoToNextLine}
      function _Readln(var Buffer; MaxCount: Longint; do_GoToNextLine: boolean): Longint;
    public
      Status: integer;
      constructor Create(aName: string; aMode: word; messages: boolean);
      destructor Destroy; override;
      function ModeS: string;
      function Read(var Buffer; Count: Longint): Longint; override;
      procedure GoToNextLine;
      {Readln Return: кол-во символов, попавших в Buffer, без #13#10}
      function Readln(var Buffer; MaxCount: Longint): Longint; virtual;
      function ReadLnS: string; {EOF_Reached}

      function WriteEOL: Longint;
      function Writeln(const Buffer; Count: Longint): Longint; virtual;
      function WritelnS(const s: string): Longint; virtual;

      procedure ReadProgressOn;
      procedure Reset;

      property Name: string read FName;
      property Mode: word read FMode;
      property EOL: boolean read FEOL;
      property EOF: boolean read FEOF;
  end;

implementation

uses SysUtils, Wcmn;

constructor TFileX.Create(aName: string; aMode: word; messages: boolean);
begin
  FName:=aName;
  FMode:=aMode;

  try
    inherited Create(aName, aMode);
  except
    if messages then Tellf('Unable open file "%s" in mode "%s"',[aName,ModeS]);
    Raise; //для внешней реакции!
    Status:=-1;
  end;
end;

destructor TFileX.Destroy;
begin
  FReadProgress.Free;
  inherited Destroy;
end;

function TFileX.ModeS: string;
begin
  case FMode of
    fmCreate: Result:='Create';
    fmOpenRead: Result:='OpenRead';
    fmOpenWrite: Result:='OpenWrite';
    fmOpenReadWrite: Result:='OpenReadWrite';
    else Result:='UnknownMode';
  end;
end;

function TFileX.Read(var Buffer; Count: Longint): Longint;
begin
  Result := inherited Read(Buffer, Count);
  if Assigned(FReadProgress) then FReadProgress.Go(Round(100*Position/Size));
end;

procedure TFileX.GoToNextLine;
const MaxCount=256;
var s: string;
begin
  SetLength(s,MaxCount);

  while true do begin
    _ReadLn(s[1],MaxCount,false);
    if FEOL then exit;
  end;
end;

function TFileX._Readln(var Buffer; MaxCount: Longint; do_GoToNextLine: boolean): Longint;
var i,j: Integer; p: PChar;
begin
  if MaxCount<=0 then MaxCount:=128;
  p:=@Buffer;
  FEOL:=false;
  FEOF:=false;
  j:=0; {pos of #10}

  Result:=Read(Buffer, MaxCount);
  if Result<MaxCount then FEOF:=true;

  for i:=1 to Result do
    if (p+i-1)^=#10 then begin
    j:=i; break;
  end;

  if j>0 then begin
    Seek(-Result+j, soFromCurrent);
    if (p+j-2)^=#13 then dec(j);
    Result:=j-1;
    FEOL:=true;
    FEOF:=false;
  end else begin
    if not FEOF and do_GoToNextLine then GoToNextLine;//!
  end;

  if FEOF then FEOL:=true;

  if Assigned(FReadProgress) then FReadProgress.Go(Round(100*Position/Size));
end;

function TFileX.Readln(var Buffer; MaxCount: Longint): Longint;
begin
  Result:=_Readln(Buffer, MaxCount, true);
end;

function TFileX.ReadLnS: string; {EOF_Reached}
const MaxCount=256;
var stmp: string; n,l: LongInt;
begin
  SetLength(Result, 0);
  SetLength(stmp, MaxCount);
  l:=0;

  repeat
    n:=_ReadLn(stmp[1], MaxCount, false);
    if l=0 then begin Result:=stmp; SetLength(Result, n); end
    else begin SetLength(Result, l+n); memcpy(@Result[l+1], @stmp[1], n); end;
    inc(l,n);
  until FEOL;
end;

function TFileX.WriteEOL: Longint;
begin
  Result := Write(_EOL_[1],2);
end;

function TFileX.Writeln(const Buffer; Count: Longint): Longint;
begin
  Result := Write(Buffer,Count) + WriteEOL;
end;

function TFileX.WritelnS(const s: string): Longint;
begin
  if s<>'' then Result := Write(s[1],Length(s)) + WriteEOL
  else Result := WriteEOL;
end;

procedure TFileX.ReadProgressOn;
begin
  if Assigned(FReadProgress) then exit;
  FReadProgress:=TProgressX.Create( Format('Read "%s"',[Name]) );
end;

procedure TFileX.Reset;
begin
  FEOF:=false;
  FEOL:=false;
  Seek(0,soFromBeginning);
end;


end.
