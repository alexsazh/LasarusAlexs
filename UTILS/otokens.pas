unit otokens; interface

uses
  OTypes;

type
  TLineTokenizer = class
    constructor Create;
    procedure setDelimiter(aDelimiter: Char);

    function line: PChar;
    function maxLen: int;

    procedure reset;
    function get: PChar;
  private
    fptr: PChar;
    fline: TLongStr;
    fDelimiter: Char;
  end;

implementation

uses
  SysUtils;

constructor TLineTokenizer.Create;
begin
  inherited;
  fDelimiter:=' '
end;

procedure TLineTokenizer.setDelimiter(aDelimiter: Char);
begin
  fDelimiter:=aDelimiter
end;

function TLineTokenizer.line: PChar;
begin
  Result:=fline
end;

function TLineTokenizer.maxLen: int;
begin
  Result:=sizeOf(fline)-1
end;

procedure TLineTokenizer.reset;
begin
  fptr:=fline;
  StrCopy(fline,'')
end;

function TLineTokenizer.get: PChar;
var
  p,q,p1,p2: PChar;
begin
  Result:=nil;
  if fptr = nil then Exit;

  p1:=fptr;
  while p1^ in [' ',#9] do Inc(p1);

  fptr:=p1;
  if p1^ = #0 then Exit;

  if p1 = '"' then begin
    p2:=StrScan(@p1[1],'"');
    if p2 = nil then begin
      fptr:=nil; Exit
    end;

    fptr:=StrScan(@p2[1],fDelimiter);
    if Assigned(fptr) then Inc(fptr);

    Inc(p1);
    while p1 < p2 do begin
      if not (p1^ in [' ',#9]) then Break;
      Inc(p1)
    end
  end
  else begin
    p2:=StrScan(p1,fDelimiter);
    if p2 = nil then begin
      p2:=StrEnd(fline); fptr:=nil;
    end
    else begin
      fptr:=p2; Inc(fptr)
    end
  end;

  p2^:=#0; Dec(p2);
  while p2 > p1 do begin
    if not (p2^ in [' ',#9]) then Break;
    p2^:=#0; Dec(p2)
  end;

  Result:=p1
end;

end.
