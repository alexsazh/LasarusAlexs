UNIT frNavyfun;
INTERFACE
Uses Windows,SysUtils,dialogs,dmw_ddw,dmw_use,Otypes,geoidnw,nevautil, LConvEncoding;
type
    s4=string[4];
    ID_scales=(_sc1,_sc1_5,_sc2,_sc2_5,_sc3,_sc4,_sc5,_sc6,_sc7,_sc7_5,_sc10,_sc12_5,_sc15,_sc17_5,_sc20,_sc25,
                _scM30,_scM37_5,_scM40,_scM50,_scM75,_scM100,_scM150,_scM200,_scM250,_scM300,_scM500,_scM750,
                _scM1000,_scM1500,_scM2000,_scM2500,_scM3000,_scM5000,_scM10000);
 Tdatum=record DX,DY,DZ:longint end;
pDatum=^Tdatum;
const Rmax:double=1.e38;
var
  nodecurr:longint;
  TL,TLint,Tlmain,Tlfr,TL1,tltmp,TLBigframe:Tlline;
  kf,f3min:double;
  lprt:lpoint;
  R,pcorn: lOrient;
  iscale,d_km,l_km, smInterv,intermInterval,textinterv,Biginterval,tmindiv,Shraf,
  smIntervL,intermIntervalL,textintervL,BigintervalL,tmindivL,ShrafL :longint;
  minDiv, minDivL,B991,BMgr,netintB,netintL, Polarnetintb,PolarnetintL:double;
  B992,L993,R994:double;
  b913:word;
  corners,ExtR,Rcorners,RCKv: array [1..4] of tgauss;
  nomenkl:record
    Lt:Char;
    Z:byte;
    list:word;
    list50,list25,list10:byte;
    scale:ID_scales;
  end;
    Top_nnom_len,  Bott_nnom_len, left_nnom_len, Right_nnom_len, left_bott,
    Right_bott1, Right_bott2, Leftmaker, rightmaker,
    LeftmakerE, rightmakerE:longint;
  Pl,pb,Plt,PLmain:plline;
  sost:Shortstring;
  Dirdm:shortstring;
 dkmmindiv,dkm2,dkm4:integer;
   Pi_2:extended;
  ktype,navykind:byte; { navykind- 0 -план
                         navykind- 1 -карта
                                             }
procedure Rad2DMS(BM:double;var deg,min,sec:shortstring);

procedure root;
procedure tr_bl(var s:shortstring);
procedure Calc_grad_min_sec_pr(angl:extended;var sgrad,smin,ssec:s4);
procedure Calc_grad_min_sec(angl:extended;var sgrad,smin,ssec:s4);
procedure Calc_grad_min(angl:extended;var sgrad,smin:s4);
function line_neib(x,y:double;PL1,PL:Plline;
                    var nn,nNext:integer):double;
function line_neib_perp(x,y:double;
                         PL:plline;
                        var nCurr,nNext:integer):boolean;

Procedure Set_Road_node(edge:integer;pTl,pTLpr:plline;nCURR,Nnext:integer);
stdcall;
Procedure Set_Road_perp(edge:boolean;pTl,pTLpr:plline;nCurr,Nnext:integer);

procedure make_lat(n:byte;var s:string);
function Set_Active_Map(n:integer;edt:boolean):boolean;
function Lval(var ss:string;len:byte):longint;
procedure Text_Bound(code:longint;a,b:lpoint; var R:lOrient;ss:string);
procedure Sign_Bound(code:longint;a,b:lpoint; var R:lOrient);

function Add_Text(code:longint;a,b:lpoint;View:word;ss:string; down:boolean):longint;
Procedure Mk_COVER;
procedure LongtRad_grad (rad: EXTENDED; var grad,min: integer; var sec: EXTENDED);
procedure corr_linkpoint;

function Ellipsoids_Count: Integer; stdcall;

procedure XY_to_BL(x,y, lc,b1,b2: double; elp,prj: byte; var b,l: double);stdcall;
procedure BL_to_XY(b,l, lc,b1,b2: double; elp,prj: byte; var x,y: double);stdcall;
function Geoid_Dist(b1,l1, b2,l2: double; var fi: double): double; stdcall;

procedure BL_BL(b,l: double; elp,elp_: Integer;
                v,v_: PDatum; out b_,l_: double); stdcall;
IMPLEMENTATION
uses ufrmNavy;
const
  dll_bl = 'dll_bl.dll';
procedure corr_linkpoint;
var
 i,xmin,xmax,ymin,ymax,dx,dy:integer;
 tg:tgauss;
 lp:lpoint;
 begin
 xmin:=2147483647;
 xmax:=-2147483647;
 ymin:=2147483647;
 ymax:=-2147483647;

 for i:=1 to 4 do begin
   if pcorn[i].X<xmin then xmin:=pcorn[i].X;
   if pcorn[i].X>xmax then xmax:=pcorn[i].X;
   if pcorn[i].y<ymin then ymin:=pcorn[i].y;
   if pcorn[i].y>ymax then ymax:=pcorn[i].y;
 end;
 dx:=(xmax-xmin) div 4;
 dy:=(ymax-ymin) div 4;
 for i:=1 to 4 do
   if (abs(pcorn[i].X-xmin)<dx) and (abs(pcorn[i].y-ymin)<dy) then begin
   tg:=Rcorners[1];
   Rcorners[1]:=Rcorners[i];
   Rcorners[i]:=tg;
   lp:=pcorn[1];
   pcorn[1]:=pcorn[i];
   pcorn[i]:=lp;
   break
 end;
  for i:=2 to 4 do
   if (abs(pcorn[i].X-xmax)<dx) and (abs(pcorn[i].y-ymin)<dy) then begin
   tg:=Rcorners[2];
   Rcorners[2]:=Rcorners[i];
   Rcorners[i]:=tg;
   lp:=pcorn[2];
   pcorn[2]:=pcorn[i];
   pcorn[i]:=lp;
   break;
 end;
   if (abs(pcorn[4].X-xmax)<dx) and (abs(pcorn[4].y-ymax)<dy) then begin
   tg:=Rcorners[3];
   Rcorners[3]:=Rcorners[4];
   Rcorners[4]:=tg;
   lp:=pcorn[3];
   pcorn[3]:=pcorn[4];
   pcorn[4]:=lp;
 end;
end;

Procedure Mk_COVER;
var
  idvc,idve:array[1..4] of Cardinal;
begin
//if dm_is_cn then begin
{for ii:=1 to 4 do
   idvc[ii]:=dm_add_vc(0,pcorn[ii].x,pcorn[ii].y,NIL);

  idve[1]:=dm_add_ve(0, idvc[1],idvc[2],NIL,NIL);

  idve[2]:=dm_add_ve(0, idvc[2],idvc[3],NIL,NIL);
  idve[3]:=dm_add_ve(0, idvc[3],idvc[4],NIL,NIL);
  idve[4]:=dm_add_ve(0, idvc[4],idvc[1],NIL,NIL);
PL^.pol[0]:=cn_ptr(idve[1],cn_edge,1,1,255);
PL^.pol[1]:=cn_ptr(idve[2],cn_edge,1,1,255);
PL^.pol[2]:=cn_ptr(idve[3],cn_edge,1,1,255);
PL^.pol[3]:=cn_ptr(idve[4],cn_edge,1,1,255);
Pl^.n:=3;
}
  idvc[1]:=dm_add_vc(0,pcorn[1].x,pcorn[1].y,NIL);
  PL^.pol[0]:=pcorn[2];
  PL^.pol[1]:=pcorn[3];
  PL^.pol[2]:=pcorn[4];
  PL^.n:=2;
  idve[1]:=dm_add_ve(0, idvc[1],idvc[1],PL,NIL);
  PL^.pol[0]:=cn_ptr(idve[1],cn_edge,1,1,255);
  PL^.n:=0;
  dm_add_poly(StrToCode('S5703020'),23,0,Pl,false);
  dm_Put_dbase(18,1);
  dm_Put_byte(1023,2);

//end;
end;

procedure Rad2DMS(BM:double;var deg,min,sec:shortstring);
var
 lbm,lm:integer;
 es:double;
begin
BM:=BM/PI*180;
lbm:=Trunc(abs(BM));
  lm:=trunc((abs(BM)-lBm)*60.0);
  es:=((abs(BM)-lBm)*60.0-trunc((abs(BM)-lBm)*60.0))*60.0;
  if es>=59.9 then begin es:=0; inc(lm) end;
  if lm=60 then begin lm:=0; inc(lBm) end;

  deg:=FormatFloat('00',lBm);
  min:=FormatFloat('00',lm);
  sec:=FormatFloat('00.00',es);
end;
procedure Text_Bound(code:longint;a,b:lpoint; var R:lOrient;ss:string);
begin
  PLt^.n:=1;
  PLt^.pol[0]:=a;
  PLt^.pol[1]:=b;
  ss:=UTF8ToCP1251(ss)+#0;
  dm_Text_bound(code,@ss[1],plt,pb,8000,0);
  R[0]:=pb^.pol[0];
  R[1]:=pb^.pol[1];
  R[2]:=pb^.pol[2];
  R[3]:=pb^.pol[3];
  R[4]:=pb^.pol[4];
end;

procedure Sign_Bound(code:longint;a,b:lpoint; var R:lOrient);
begin
  dm_Sign_bound(code,a,b,pb,8000);
  R[0]:=pb^.pol[0];
  R[1]:=pb^.pol[1];
  R[2]:=pb^.pol[2];
  R[3]:=pb^.pol[3];
  R[4]:=pb^.pol[4];
end;

function Add_Text(code:longint;a,b:lpoint;View:word;ss:string; down:boolean):longint;
begin
  PLt^.pol[0]:=a;
  if (a.x=b.x) and (a.y=b.y) then
    PLt^.n:=0
  else begin
   PLt^.n:=1;
   PLt^.pol[1]:=b;
  end;
  ss:=UTF8ToCP1251(ss)+#0;
  Result:=dm_add_text(Code,4,View,PLt,@ss[1],down)
end;

function Ellipsoids_Count: Integer;
external dll_bl;

procedure XY_to_BL(x,y, lc,b1,b2: double; elp,prj: byte; var b,l: double);
external dll_bl;
procedure BL_to_XY(b,l, lc,b1,b2: double; elp,prj: byte; var x,y: double);
external dll_bl;

function Geoid_Dist(b1,l1, b2,l2: double; var fi: double): double;
external dll_bl;

procedure BL_BL(b,l: double; elp,elp_: Integer;
                v,v_: PDatum; out b_,l_: double);
external dll_bl;
function Lval(var ss:string;len:byte):longint;
var
  l:longint;
  code:integer;
  sw:string[255];
  iw,i:byte;
begin
iw:=0;
for i:=1 to len do if ss[i]<>' ' then begin inc(iw); sw[iw]:=ss[i]  end;
byte(sw[0]):=iw;
val(sw,l,code);
LVAL:=L;
end;

function Set_Active_Map(n:integer;edt:boolean):boolean;
var
  pch,pn:pchar;
begin
dmw_done;
Result:=false;
getmem(pch,65528);
pn:=dmw_ProjectMap(n,pch,65528);
if pn=NIL then begin
  Freemem(pch,65528);
  exit;
end;
if dmw_open(pn,edt)=0 then begin
  Freemem(pch,65528);
  exit;
end;
Freemem(pch,65528);
Result:=true;
end;

procedure root;
begin
  Set_active_Map(0,false);
  dm_Goto_root;
end;

procedure tr_bl(var s:shortstring);
var i,inbl:byte;
begin
 inbl:=0;
 for i:=byte(s[0]) downto 1 do
   if (s[i]<>' ') and (s[i]<>#0) then begin inbl:=i; break end;
 byte(s[0]):=inbl;
 s:=s+#0;
 OEMTOANSI(@s[1],@s[1])
end;

procedure LongtRad_grad (rad: EXTENDED; var grad,min: integer; var sec: EXTENDED);
begin
      rad  := rad / pi * 180.0  ;
     if rad>180 then rad:=360-rad;

      grad := trunc (rad) ;
      min  := abs(trunc( ( rad -grad ) * 60 )) ;
      sec  := ( abs(rad) - abs(grad) - min / 60 ) * 3600 ;
 if sec>59.1 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
end;

procedure Calc_grad_min_sec_pr(angl:extended;var sgrad,smin,ssec:s4);
var
    grad,min: integer;
    sec: extended;
begin
  LongtRad_grad(angl,grad,min,sec);
  sgrad:=inttostr(grad)+#176;
  smin:=format('%2.2d',[min]);
  if byte(smin[0])=1 then
     smin:='0'+smin+''''{#180}
  else
  smin:=smin+'''';{#180;}
  min:=round(sec);
  {if min=0 then ssec:=''
  else }
  begin
  ssec:=format('%2.2d',[min]);
  ssec:=ssec+'"';
  end
end;

procedure Calc_grad_min_sec(angl:extended;var sgrad,smin,ssec:s4);
var
    grad,min: integer;
    sec: extended;
begin
  Rad_grad(angl,grad,min,sec);
  if sec>55 then begin inc(min); sec:=0 end;
  if min=60 then begin
     min:=0;
     inc(grad);
  end;
  str(grad,sgrad);
  sgrad:=sgrad+#176;
  smin:=format('%2.2d',[min]);
  smin:=smin+'''';{#180;}
  min:=round(sec);
  if min=0 then ssec:=''
  else begin
    ssec:=format('%2.2d',[min]);
    ssec:=ssec+'"';
  end
end;

procedure Calc_grad_min(angl:extended;var sgrad,smin:s4);
var
    grad,min: integer;
    sec: extended;
begin
  Rad_grad(angl,grad,min,sec);
  if sec>55 then inc(min);
  if min=60 then begin
     min:=0;
     inc(grad);
  end;
  str(grad,sgrad);
  sgrad:=sgrad+#176;
  str(min,smin);
  if byte(smin[0])=1 then
     smin:='0'+smin+''''
  else
  smin:=smin+{#180}'''';
end;
function line_neib(x,y:double;PL1,PL:Plline;
                    var nn,nNext:integer):double;
var
  i:integer;
  RR,RDist,rd,t,tx,ty,x3,x4,det,xc,yc:double;
begin
 RR:=Rmax; nn:=-1;
     for i:=1 to PL^.n do with PL^ do begin
        { iF i<>0 then with PL^ do begin  }
             tx:=pol[i-1].x-pol[i].x;
             ty:=pol[i-1].y-pol[i].y;
       det:= ty*(PL1^.pol[0].x-PL1^.pol[1].x)+tx*(PL1^.pol[1].y-PL1^.pol[0].y);
       if det=0 then continue
       else begin
         x3:=PL1^.pol[0].x;
         x4:=PL1^.pol[1].x;
         xc:=((ty*pol[i].x-tx*pol[i].y)*(x3-x4)+
              tx*(x3*PL1^.pol[1].y-x4*PL1^.pol[0].y))/det;
         yc:=(ty*(x3*PL1^.pol[1].y-x4*PL1^.pol[0].y)+
              (ty*pol[i].x-tx*pol[i].y)*(PL1^.pol[0].y-PL1^.pol[1].y))/det;

               tx:=pol[i-1].x-pol[i].x;
                 ty:=pol[i-1].y-pol[i].y;
               Rd:=sqr(tx)+sqr(ty);
               if Rd<>0 then begin
                      tx:=pol[i].x;
                  ty:=pol[i].y;
                  t:=(pol[i-1].x-pol[i].x)*(xc-tx)+
                     (pol[i-1].y-pol[i].y)*(yc-ty);

                  if (t>=0) and (t<=Rd) then begin
                    Rdist:=sqr(xc-x)+sqr(yc-y)
                  end
                  else Rdist:=Rmax;
               end
               else  Rdist:=Rmax;
              if Rdist<RR then begin
               RR:=Rdist;
                  {if i<>PL^.n then begin
                  nn:=i; nNext:=i-1
                  end
                else }begin nn:=i-1; nNext:=i
                end
              end
              end
           { end {if i<>0}
     end;  {for i}
line_neib:=RR
end;
function line_neib_perp(x,y:double;
                         PL:plline;
                        var nCurr,nNext:integer):boolean;
var
  RR,RDist,rd,t,tx,ty:double;
  i:integer;
begin
 RR:=Rmax; nCurr:=-1;
     for i:=1 to PL^.n do with PL^ do begin
            {if i<>0 then with PL^ do begin
             }    tx:=pol[i-1].x-pol[i].x;
                 ty:=pol[i-1].y-pol[i].y;
               Rd:=sqr(tx)+sqr(ty);
               if Rd<>0 then begin
                      tx:=pol[i].x;
                  ty:=pol[i].y;
                  t:=(pol[i-1].x-pol[i].x)*(x-tx)+
                     (pol[i-1].y-pol[i].y)*(y-ty);

                  if (t>=0) and (t<=Rd) then begin
                    Rdist:=sqr((pol[i-1].y-pol[i].y)*x -
                    (pol[i-1].x-pol[i].x)*y+
                    pol[i-1].x*ty-
                    pol[i-1].y*tx)/Rd;
                  end
                  else Rdist:=Rmax;
               end
               else  Rdist:=Rmax;
              if Rdist<RR then begin
               RR:=Rdist;
              { if i<>PL^.n then begin
                  nn:=i; nNext:=i-1
                  end
                else begin} nCurr:=i-1; nNext:=i
               { end }
              end
           { end {if i<>0}
     end;  {for i}

if nCurr=(-1) then begin line_neib_perp:=false; exit end;
line_neib_perp:=true
end;

Procedure Set_Road_perp(edge:boolean;pTl,pTLpr:plline;nCurr,Nnext:integer);
var
 nn,i,nc1:integer;
 lp1:lPoint;
 Rdist1, t, tx,ty:double;
label
       Ag,lab2;
begin
  if ((nCurr=0) or (nCurr=pTlpr^.n)) and (nNext=-1) then begin
     if edge then
                  pTl^.pol[pTL^.n]:=pTLpr^.pol[nCurr]
      else
           pTL^.pol[0]:=pTLpr^.pol[nCurr];
  end
  else begin
       if nNext=-1 then begin lp1:=ptlpr^.pol[nCurr]; goto lab2; end;
       if edge then nn:=pTl^.n else nn:=0;
       nc1:=nNext;
        i:=0;
        with pTLpr^ do begin
 Ag:
        tx:=pol[nc1].x-pol[nCurr].x;
        ty:=pol[nc1].y-pol[nCurr].y;
      Rdist1:=sqr(tx)+sqr(ty);
        if Rdist1<>0 then begin
          t:=(tx*(pTL^.Pol[nn].x-pol[nCurr].x) +
                    ty*(pTL^.Pol[nn].y-pol[nCurr].y));
          if (t<0.0) or (t>Rdist1) then begin
           inc(i);
           if nc1=nCurr-1 then nc1:=nCurr+1 else nc1:=nCurr-1;
           if i>1 then begin lp1:=pol[nCurr]; goto lab2 end;
           goto Ag;
          end;
          t:=t/Rdist1;
          lp1.x:=pol[nCurr].x+round(tx*t);
          lp1.y:=pol[nCurr].y+round(ty*t);
       end
       else lp1:=pol[nCurr];
   end; {with}
   lab2:
      if edge then begin
                  pTl^.pol[pTL^.n]:=lp1
    end
    else
           pTL^.pol[0]:= lp1
  end
end;

Procedure Set_Road_node(edge:Integer;pTl,pTLpr:plline;nCURR,Nnext:integer);
stdcall;
var
 lp1:lpoint;
 tx,ty,x3,x4,det:double;
 nc1, nn:integer;
 label
       lab2;
begin
  if ((nCurr=0) or (nCurr=pTlpr^.n)) and (nNext=-1) then begin
     if edge=1 then
                  pTl^.pol[pTL^.n]:=pTLpr^.pol[nCurr]
      else
           pTL^.pol[0]:=pTLpr^.pol[nCurr];
  end
  else begin
        if nNext=-1 then begin lp1:=ptlpr^.pol[nCurr]; goto lab2; end;
       if edge=1 then nn:=pTl^.n else nn:=0;
       nc1:=nNext;
     with pTLpr^ do begin
       tx:=pol[nc1].x-pol[Ncurr].x;
       ty:=pol[nc1].y-pol[ncurr].y;
       det:= ty*(PtL^.pol[0].x-PtL^.pol[1].x)+tx*(PtL^.pol[1].y-PtL^.pol[0].y);
         x3:=PtL^.pol[0].x;
         x4:=PtL^.pol[1].x;
         lp1.x:=round(((ty*pol[Ncurr].x-tx*pol[Ncurr].y)*(x3-x4)+
              tx*(x3*PtL^.pol[1].y-x4*PtL^.pol[0].y))/det);
         lp1.y:=round((ty*(x3*PtL^.pol[1].y-x4*PtL^.pol[0].y)+
              (ty*pol[NCurr].x-tx*pol[nCurr].y)*(PtL^.pol[0].y-PtL^.pol[1].y))/det);
     end; {with}
   lab2:
      if edge=1 then begin
                  pTl^.pol[pTL^.n]:=lp1
    end
    else
           pTL^.pol[0]:= lp1
  end
end;


procedure make_lat(n:byte;var s:string);
begin
 case (n+1) div 10 of
   0: s:='';
   1: s:='X';
   2: s:='XX';
   3: s:='XXX';
 end;
 case n mod 10 of
   1: s:=s+'I';
   2: s:=s+'II';
   3: s:=s+'III';
   4: s:=s+'IV';
   5: s:=s+'V';
   6: s:=s+'VI';
   7: s:=s+'VII';
   8: s:=s+'VIII';
   9: begin
      if length(s)<>0 then setLength(s, length(s)-1);
      s:=s+'IX';
   end;
 end;
end;
initialization
begin
 Getmem(plMain,65528);
 Getmem(pl,65528);
 Getmem(plt,65528);
 Getmem(pb,65528);
end;

finalization
begin
 Freemem(plMain,65528);
 Freemem(pl,65528);
 Freemem(plt,65528);
 Freemem(pb,65528);
end;
end.
