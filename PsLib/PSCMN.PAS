unit pscmn; interface


function str2psstr(s: string): string;
function psstr2str(s: string): string;


implementation

function str2psstr(s: string): string;
var l,i2,i: integer; c: char;
begin
  l:=Length(s);
  SetLength(Result,2*l);
  i2:=0;
  for i:=1 to l do begin
    inc(i2);
    c:=s[i];
    case c of
      ')','\': begin Result[i2]:='\'; inc(i2); Result[i2]:=c; end;
      else Result[i2]:=c;
    end;
  end;
  SetLength(Result,i2);
end;

function psstr2str(s: string): string;
var l,i2,i: integer; c: char;
begin
  l:=Length(s);
  SetLength(Result,l);
  i:=0;
  i2:=0;
  while i<l do begin
    inc(i);
    inc(i2);
    c:=s[i];
    if c='\' then begin inc(i); Result[i2]:=s[i]; end
    else Result[i2]:=c;
  end;
  SetLength(Result,i2);
end;



end.
