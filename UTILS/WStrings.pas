unit WStrings; interface

uses
  Windows,Classes,
  Sysutils,OTypes;

function WideCharToStr(Src: PWideChar; Dest: PChar; DestSize: int): PChar;

function StrCopyW(Dest: PWideChar; const Source: PWideChar; MaxLen: int): PWideChar;
function StrUCopyW(Dest: PWideChar; const Source: PWideChar; MaxLen: int): PWideChar;
function StrPCopyW(Dest: PWideChar; const Source: WideString; MaxLen: int): PWideChar;

function StrCompW(S1,S2: PWideChar): int;

function StrLenW(Str: PWideChar): int;

function StrPasWW(Str: PWideChar): WideString;
function StrLPasWW(Str: PWideChar; len: int): WideString;
function StrPasAW(Str: PAnsiChar): WideString;
function StrPasSW(const Str: String): WideString;

function StrCatWC(Dest,Str: PWideChar; MaxLen: int): PWideChar;
function PasCatWC(Dest,Str: PWideChar; MaxLen: int): PWideChar;

function PasCatWS(Dest: PWideChar;
                  const Str: WideString;
                  MaxLen: int): PWideChar;

function StrToMemoW(Str: PWideChar; Memo: TStrings): int;

function WideStringToString(const Src: WideString;
                            out Dest: String): boolean;

function TextToStr(const w: WideString): WideString;

function StrReplaceW(const s: WideString; ch1,ch2: WideChar): WideString;

function lstrW(const s: WideString): WideString;

implementation

function WideCharToStr(Src: PWideChar; Dest: PChar; DestSize: int): PChar;
var
  len: int;
begin
  len:=StrLenW(Src);
  len:=WideCharToMultiByte(0,0, Src,len, Dest,DestSize, nil,nil);
  if len < 0 then len:=0; Dest[len]:=#0; Result:=Dest;
end;

function StrCopyW(Dest: PWideChar; const Source: PWideChar; MaxLen: int): PWideChar;
var
  Src: PWideChar;
begin
  Result:=Dest;

  if Assigned(Dest) and (MaxLen > 0) then begin
    Src:=Source; if Assigned(Src) then
    while (MaxLen > 0) and (Src^ <> #0) do begin
      Dest^:=Src^; Inc(Src); Inc(Dest); Dec(MaxLen);
    end;

    Dest^:=#0;
  end;
end;

function StrUCopyW(Dest: PWideChar; const Source: PWideChar; MaxLen: int): PWideChar;
var
  si,di: PWideChar; cx: int;
begin
  Result:=Dest;

  if Assigned(Dest) and (MaxLen > 0) then begin

    si:=Source; di:=Dest; cx:=0;

    if Assigned(si) then
    while (MaxLen > 0) and (si^ <> #0) do begin
      di^:=si^; Inc(si); Inc(di);
      Inc(cx); Dec(MaxLen);
    end;

    di^:=#0; if cx > 0 then
    CharUpperBuffW(Dest,cx);
  end;
end;

function StrPCopyW(Dest: PWideChar; const Source: WideString; MaxLen: int): PWideChar;
var
  len: int;
begin
  Result:=nil;
  if MaxLen = 0 then MaxLen:=255;
  len:=Length(Source);
  if len > MaxLen then len:=MaxLen;

  if len > 0 then begin
    Move(PWideChar(Source)^,Dest^,len+len);
    Result:=Dest
  end;

  Dest[len]:=#0 
end;

function StrCompW(S1,S2: PWideChar): int;
var
  i,c1,c2: int;
begin
  Result:=0;
  for i:=1 to 256 do begin
    c1:=int(S1[0]);
    c2:=int(S2[0]);

    if c1 = 0 then begin
      if c2 <> 0 then Result:=-1;
      Break
    end else
    if c2 = 0 then begin
      Result:=+1; Break
    end else
    if c1 < c2 then begin
      Result:=-1; Break
    end else
    if c1 > c2 then begin
      Result:=+1; Break
    end;

    Inc(S1); Inc(S2)
  end
end;

function StrLenW(Str: PWideChar): int;
var
  i: int;
begin
  Result:=0;
  for i:=1 to 1024*8 do begin
    if Str^ = #0 then Break;
    Inc(Str); Inc(Result)
  end
end;

function StrPasWW(Str: PWideChar): WideString;
begin
  Result:=Str
end;

function StrLPasWW(Str: PWideChar; len: int): WideString;
var
  i: int; w: WideString;
begin
  SetLength(w,len); w:='';
  for i:=0 to len-1 do
  w:=w + Str[i]; Result:=w;
end;

function StrPasAW(Str: PAnsiChar): WideString;
var
  len: int; w: WideString;
begin
  len:=StrLen(Str);
  w:=''; if len > 0 then begin
    SetLength(w,len); w:='';
    while len > 0 do begin
      w:=w+Str^; Dec(len); Inc(Str)
    end
  end;

  Result:=w
end;

function StrPasSW(const Str: String): WideString;
var
  i,len: int; w: WideString;
begin
  len:=Length(Str);
  SetLength(w,len); w:='';

  for i:=1 to len do
  w:=w + WideChar( byte(Str[i]) );

  Result:=w
end;

function StrCatWC(Dest,Str: PWideChar; MaxLen: int): PWideChar;
var
  di,si: PWideChar; len: int;
begin
  Result:=Dest;

  len:=0; di:=Dest;
  while di[0] <> #0 do begin
    Inc(di); Inc(len);
    if len >= MaxLen then Break
  end;

  si:=Str;
  while si[0] <> #0 do begin
    if len < MaxLen then begin
      di[0]:=si[0]; Inc(di); Inc(len);
    end;

    Inc(si)
  end;

  Inc(len); di[len]:=#0
end;

function PasCatWC(Dest,Str: PWideChar; MaxLen: int): PWideChar;
var
  di,si: PWideChar; len: int;
begin
  Result:=Dest;

  di:=Dest;
  len:=Ord(di[0]); Inc(di);
  di:=@di[len];

  si:=Str;
  while si[0] <> #0 do begin
    if len < MaxLen then begin
      di[0]:=si[0]; Inc(di); Inc(len);
    end;

    Inc(si)
  end;

  Dest[0]:=WideChar(len)
end;

function PasCatWS(Dest: PWideChar;
                  const Str: WideString;
                  MaxLen: int): PWideChar;
var
  di: PWideChar; i,len: int;
begin
  Result:=Dest;

  di:=Dest;
  len:=Ord(di[0]); Inc(di);
  di:=@di[len];

  for i:=1 to Length(Str) do
  if len < MaxLen then begin
    di[0]:=Str[i]; Inc(di); Inc(len);
  end;

  Dest[0]:=WideChar(len)
end;

function StrToMemoW(Str: PWideChar; Memo: TStrings): int;
var
  k: int; p: PWideChar; ch: WideChar; s: WideString;
begin
  Memo.Clear;

  k:=0; p:=Str; s:='';
  while p[0] <> #0 do begin

    ch:=p[0]; Inc(p); Inc(k);
    if (ch = #10) or (ch = #13) then begin

      Memo.Add(s); s:='';

      ch:=p[0]; Inc(p); Inc(k);
      if (ch = #10) or (ch = #13) then begin
        ch:=p[0]; Inc(p); Inc(k);
      end
    end;

    if ch = #0 then Break;
    s:=s+ch;

    if k = 10000 then Break;
  end;

  if Length(s) > 0 then
  Memo.Add(s);

  Result:=Memo.Count
end;

function WideStringToString(const Src: WideString;
                            out Dest: String): boolean;
var
  i,n,rc: int; s: String; ch: Char; c1,c2: WideChar;
begin
  Result:=false; Dest:='';

  n:=Length(Src);
  if n < 256 then begin

    s:=''; Result:=true;
    for i:=1 to n do begin
      c1:=Src[i]; Result:=false;

      if WideCharToMultiByte(0, 0, @c1,1, @ch,1, nil,nil) = 1 then
      if MultiByteToWideChar(0,0, @ch,1, @c2,1) = 1 then
      Result:=c1 = c2;

      if not Result then Break;
      s:=s+ch
    end;

    Dest:=s
  end
end;

function TextToStr(const w: WideString): WideString;
var
  i,p: int; s,t: WideString;
begin
  s:=''; t:=w;
  for i:=1 to 256 do begin
    p:=Pos(#13#10,t);
    if p = 0 then Break;
    if p > 1 then
    s:=s+Copy(t,1,p-1);
    s:=s+'^';

    Delete(t,1,p+1);
  end;

  s:=s+t; Result:=s
end;

function StrReplaceW(const s: WideString; ch1,ch2: WideChar): WideString;
var
  i: int; t: WideString;
begin
  t:=s;
  for i:=1 to Length(t) do
  if t[i] = ch1 then t[i]:=ch2;
  Result:=t
end;

function lstrW(const s: WideString): WideString;
var
  i,k: int; t: WideString;
begin
  t:=s; k:=0;

  if length(t) > 0 then
  for i:=1 to 100 do begin
    if length(t) = 0 then Break;
    if not (t[i] in [WideChar(' '),
                     WideChar(10),
                     WideChar(13)]) then Break;
    Inc(k)
  end;

  if k > 0 then
  if k = Length(t) then t:='' else
  Delete(t,1,k);

  Result:=t;
end;

end.
