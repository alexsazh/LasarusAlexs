UNIT win_use;
Interface
uses windows,SysUtils,Otypes;
procedure meshnd(handle:HWnd);
procedure about(window:HWND;s:shortstring);
function Code2string(code:longint):string;
function String2code(scode:string):longint;
function Point_in_Poly( p: lpoint; lp: pLLine ): boolean;
function Point_in_PGPoly( p: Tgauss; lp: pGPoly; nl:integer ): boolean;
function Point_in_PolyLine( p: lpoint; lp: PPolyLine ): boolean;
function Point_in_xPoly( p: tgauss; lp: pXLine ): boolean;stdcall;
function Get_Xline_dist(a:tgauss;Rneib:double;pl: pXLine):double;stdcall;

Function Get_Work_dir(Bin_dir:shortstring):shortstring;
function wait_Execute(cmdline,CurrDir: PChar; wait: Boolean): THandle;
function Isdigit(c:char):boolean;

Implementation

function Isdigit(c:char):boolean;
begin
Result:=(C>='0') and (C<='9');
end;

function wait_Execute(cmdline,CurrDir: PChar; wait: Boolean): THandle;
var
  PROC_INFO: TProcessInformation;
  stinfo: TStartupInfo;
begin
  Result:=0; FillChar(stinfo,Sizeof(stinfo),0);
  if CreateProcess(nil,cmdline,NIL,NIL,false,0,NIL,CurrDir,stinfo,proc_info) then begin
    if wait then
       WaitForSingleObject(proc_info.hProcess,INFINITE);
    Result:=proc_info.hProcess;
 end
end;

Function Get_Work_dir(Bin_dir:shortstring):shortstring;
var
  ss:shortstring;
  pc:pchar;

begin
ss:=Bin_dir+#0;
pc:=strRscan(@ss[1],'\');
pc^:=#0;
Result:=Strpas(@ss[1]);
end;
//
function Point_in_Poly( p: lpoint; lp: pLLine ): boolean;
var
  p1,p2, t1,t2,tt: lpoint;
  fx,fy:double;
  i,k: integer;  dy: boolean;
  s1,s2: longint;
begin
  Result:=false;
  with lp^ do begin

    k:=0; p2:=Pol[0];
    i:=N;
    while (i>0) and (Pol[i].y=Pol[i-1].y) do Dec(i);
    if i=0 then Exit;
    dy:=Pol[i].y-Pol[i-1].y < 0;

    for i:=1 to N do begin
      p1:=p2; p2:=Pol[i]; t1:=p1; t2:=p2; s1:=0; s2:= 0;
      if t2.y < t1.y then
        begin  if dy then s2:=-1; dy:=true; tt:=t1; t1:=t2; t2:=tt  end
      else  if t1.y < t2.y then
        begin  if not dy then s1:=+1; dy:=false end;

      if (p.y >= t1.y+s1) and (p.y <= t2.y+s2) then begin
        if t1.y = t2.y then begin
          if t2.x < t1.x then begin tt:=t1; t1:=t2; t2:=tt end;
          if (p.x >= t1.x) and (p.x <= t2.x) then
          begin Result:=true; Exit end
        end else begin
          fx:=t1.x;
          fy:=t1.y;
          tt.x:=t1.x + Round((t2.x-fx)*((p.y-fy)/(t2.y-fy)));

          if tt.x = p.x then begin Result:=true; Exit end
          else if p.x < tt.x then Inc(k)
        end
      end
    end; Result:=Odd(k)
  end
end;

function Point_in_PGPoly( p: Tgauss; lp: pGPoly; nl:integer ): boolean;
var
  p1,p2, t1,t2,tt: tgauss;
  fx,fy:double;
  i,k: integer;  dy: boolean;
  s1,s2: longint;
begin
  Result:=false;

    k:=0; p2:=lp[0];
    i:=Nl;
    while (i>0) and (lp[i].y=lp[i-1].y) do Dec(i);
    if i=0 then Exit;
    dy:=lp[i].y-lp[i-1].y < 0;

    for i:=1 to Nl do begin
      p1:=p2; p2:=lp[i]; t1:=p1; t2:=p2; s1:=0; s2:= 0;
      if t2.y < t1.y then
        begin  if dy then s2:=-1; dy:=true; tt:=t1; t1:=t2; t2:=tt  end
      else  if t1.y < t2.y then
        begin  if not dy then s1:=+1; dy:=false end;

      if (p.y >= t1.y+s1) and (p.y <= t2.y+s2) then begin
        if t1.y = t2.y then begin
          if t2.x < t1.x then begin tt:=t1; t1:=t2; t2:=tt end;
          if (p.x >= t1.x) and (p.x <= t2.x) then
          begin Result:=true; Exit end
        end else begin
          fx:=t1.x;
          fy:=t1.y;
          tt.x:=t1.x + Round((t2.x-fx)*((p.y-fy)/(t2.y-fy)));

          if tt.x = p.x then begin Result:=true; Exit end
          else if p.x < tt.x then Inc(k)
        end
      end
    end; Result:=Odd(k)
end;

function Point_in_PolyLine( p: lpoint; lp: PPolyLine ): boolean;
var
  p1,p2, t1,t2,tt: lpoint;
  fx,fy:double;
  i,k: integer;  dy: boolean;
  s1,s2: longint;
begin
  Result:=false;
  with lp^ do begin

    k:=0; p2:=Pol[0];
    i:=N;
    while (i>0) and (Pol[i].y=Pol[i-1].y) do Dec(i);
    if i=0 then Exit;
    dy:=Pol[i].y-Pol[i-1].y < 0;

    for i:=1 to N do begin
      p1:=p2; p2:=Pol[i]; t1:=p1; t2:=p2; s1:=0; s2:= 0;
      if t2.y < t1.y then
        begin  if dy then s2:=-1; dy:=true; tt:=t1; t1:=t2; t2:=tt  end
      else  if t1.y < t2.y then
        begin  if not dy then s1:=+1; dy:=false end;

      if (p.y >= t1.y+s1) and (p.y <= t2.y+s2) then begin
        if t1.y = t2.y then begin
          if t2.x < t1.x then begin tt:=t1; t1:=t2; t2:=tt end;
          if (p.x >= t1.x) and (p.x <= t2.x) then
          begin Result:=true; Exit end
        end else begin
          fx:=t1.x;
          fy:=t1.y;
          tt.x:=t1.x + Round((t2.x-fx)*((p.y-fy)/(t2.y-fy)));

          if tt.x = p.x then begin Result:=true; Exit end
          else if p.x < tt.x then Inc(k)
        end
      end
    end; Result:=Odd(k)
  end
end;
//
function Point_in_xPoly( p: tgauss; lp: pXLine ): boolean;stdcall;
var
  p1,p2, t1,t2,tt: tgauss;
  fx,fy:double;
  i,k: integer;  dy: boolean;
  s1,s2: double;
begin
  Result:=false;
  with lp^ do begin

    k:=0; p2:=Pol[0];
    i:=N;
    while (i>0) and (Pol[i].y=Pol[i-1].y) do Dec(i);
    if i=0 then Exit;
    dy:=Pol[i].y-Pol[i-1].y < 0;

    for i:=1 to N do begin
      p1:=p2; p2:=Pol[i]; t1:=p1; t2:=p2; s1:=0; s2:= 0;
      if t2.y < t1.y then
        begin  if dy then s2:=-0.00000001; dy:=true; tt:=t1; t1:=t2; t2:=tt  end
      else  if t1.y < t2.y then
        begin  if not dy then s1:=+0.00000001; dy:=false end;

      if (p.y >= t1.y+s1) and (p.y <= t2.y+s2) then begin
        if t1.y = t2.y then begin
          if t2.x < t1.x then begin tt:=t1; t1:=t2; t2:=tt end;
          if (p.x >= t1.x) and (p.x <= t2.x) then
          begin Result:=true; Exit end
        end else begin
          fx:=t1.x;
          fy:=t1.y;
          tt.x:=t1.x + (t2.x-fx)*((p.y-fy)/(t2.y-fy));

          if tt.x = p.x then begin Result:=true; Exit end
          else if p.x < tt.x then Inc(k)
        end
      end
    end; Result:=Odd(k)
  end
end;

function Get_Xline_dist(a:tgauss;Rneib:double;pl: pXLine):double; stdcall;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y, ex,ey:Extended;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i
         end;
            iF i<>0 then with PL^ do begin
               tx:=pol[i-1].x-pol[i].x;
               ty:=pol[i-1].y-pol[i].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                  ex:=pol[i].x;
                  ey:=pol[i].y;
                  t:=(pol[i-1].x-ex)*(x-ex)+
                     (pol[i-1].y-ey)*(y-ey);
                  //if t>0 then t:=sqrt(t);
                  if (t>0) and (t<Rdist) then begin
                    Rdist:=SQR((pol[i-1].y-pol[i].y)*x -
                    (pol[i-1].x-pol[i].x)*y+
                    pol[i-1].x*ey-
                    pol[i-1].y*ex)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;



procedure about(window:HWND;s:shortstring);
begin
  s[byte(s[0])+1]:=#0;
  MessageBox(window,Pchar(@s[1]),'Инфо',mb_Ok);
end;
procedure meshnd(handle:HWnd);
var
  Msg:Tmsg;
begin
while PeekMessage(Msg,0,0,0,pm_Remove) do
     if not IsDialogMessage(handle,Msg) then begin
       TranslateMessage(Msg);
       DispatchMessage(Msg)
end
end;
function Code2string(code:longint):string;
var
st:string;
sd,lnumb: longint;
begin
  sd:=code div 10000000;
  lnumb:=code mod 10000000;
   st:=Format('%7.7d',[lnumb]);
  Result:=chr(48{ord('0')}+sd)+st;
end;
function String2code(scode:string):longint;
var
st:string;
begin
if scode='' then begin Result:=-1; exit end;
  try
  if length(scode)=8 then begin
  st:=Scode+#0;
  Result:=(ord(scode[1])-48{ord('0')})*10000000+ StrToInt(strpas(@st[2]));
  end else begin
  Result:=StrToInt(Scode);
  end;
  except
  Result:=-1;
  end;
end;

end.