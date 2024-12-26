{Buffer : Array of Chars + Read/Write of segments}
unit Buf; interface

uses
  Classes,
  wcmn, arrayx;


type
  TBuf = class(TArray)
  protected
    function Get(Index: integer): Char;
    procedure Put(Index: integer; Item: Char);
  public
    constructor Create(aDelta: integer);

    function Read(var Buffer; aStart, aCount: integer): integer; {Readed count}
    function Write(const Buffer; aStart, aCount: integer): integer;
    function Add(const Buffer; aCount: integer): integer;
    function ReadS(aStart, aCount: integer): string;
    function WriteS(const s: string; aStart: integer): integer;
    function AddS(const s: string): integer;
    function ReadSL(SL: TStrings; aStart: integer; aCount: array of integer): integer;
    procedure ShiftL(aCount: integer);
    procedure ShiftR(aCount: integer);
    function IndexOf(c: Char): integer;
    function FindChar(c: Char): PChar;
    property Items[Index: integer]: Char read Get write Put; default;
    property Capacity;
    property Count;
    property Memory; {: PChar}
  end;


implementation


{ Protected methods: }

function TBuf.Get(Index: integer): Char;
begin
  inherited Get(Index, Result);
end;

procedure TBuf.Put(Index: integer; Item: Char);
begin
  inherited Put(Index, Item);
end;


{ Public methods: }

constructor TBuf.Create(aDelta: integer);
begin
  inherited Create(1, aDelta);
end;

function TBuf.Read(var Buffer; aStart, aCount: integer): integer;
begin
  Result:=0;
  if Status<>0 then Exit;
  if aCount=0 then Exit;
  if aStart>=FCount then Exit;
  if aStart+aCount>FCount then aCount:=FCount-aStart;
  memcpy(@Buffer, FMemory+aStart, aCount);
  Result:=aCount;
end;

function TBuf.Write(const Buffer; aStart, aCount: integer): integer;
begin
  Result:=0;
  if aCount=0 then Exit;
  SetCount(FCount+aCount);
  if Status<>0 then begin
    Exit;
  end;
  if aStart>FCount then FillChar( (FMemory+FCount)^, aCount, 0 );
  memcpy(FMemory+aStart , @Buffer, aCount);
  Result:=aCount;
end;

function TBuf.Add(const Buffer; aCount: integer): integer;
begin
  Result := Write(Buffer, FCount ,aCount);
end;


function TBuf.ReadS(aStart, aCount: integer): string;
begin
  SetLength( Result, aCount ); {for 32 bit}
  SetLength( Result, Read( Result[1], aStart, aCount) );
end;

function TBuf.WriteS(const s: string; aStart: integer): integer;
begin
  Result := Write( s[1], aStart, Length(s) );
end;

function TBuf.AddS(const s: string): integer;
begin
  Result := Add( s[1], Length(s) );
end;

function TBuf.ReadSL(SL: TStrings; aStart: integer; aCount: array of integer): integer;
var i,l: Integer; s: string;
begin
  Result:=0;
  try
    SL.Clear;
    for i:=Low(aCount) to High(aCount) do begin
      l:=aCount[i];
      s:=ReadS(aStart, l);
      SL.Add(s);
      inc(aStart, l);
      inc(Result, l);
    end;
  except ;
  end;
end;


procedure TBuf.ShiftL(aCount: integer);
begin
  if aCount=0 then Exit;
  if aCount>=FCount then
    Clear
  else begin
    memcpy(FMemory, Memory + aCount, FCount-aCount);
    SetCount(FCount-aCount);
  end;
end;

procedure TBuf.ShiftR(aCount: integer);
begin
  if aCount=0 then Exit;
  SetCount(FCount+aCount);
  if Status<>0 then Exit;
  memcpy(FMemory + aCount, Memory, FCount);
  FillChar(FMemory^, aCount, 0);
end;


function TBuf.IndexOf(c: Char): integer;
begin
  Result := inherited IndexOf(c);
end;

function TBuf.FindChar(c: Char): PChar;
begin
  Result := GetP( IndexOf(c) );
end;


end.
