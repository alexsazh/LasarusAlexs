unit geoidnw;
interface
uses otypes, dmw_use,math,dialogs;

type
MsgStr = string[79];
type
  T_A1_6=array[1..6] of double;

  ab_rec = record a0,ax,ay, b0,bx,by: double end;
  XYZ= record
       X,Y,Z:extended;
       end;
  koeff= record x0,y0,Mc,Ms,Mcy,Msy: EXTENDED; end;
  erd  = (west,east) ;
  pgpoly = ^tgpoly;
  tgpoly = array[0..3] of tgauss;
      Head_map = record
           name   : string;
           scale  : word;
{           ed_plan: EXTENDED;}
           ed_plan: double;
           half   : erd;
           zone   :integer;
      end;
 _geoid=record
         b,l:double
         end;
     Place_map = record
         point_: array [1..4] of lpoint;
         gauss_: array [1..4] of tgauss;
         geoid_: array [1..4] of _geoid;
     end;


var
            head: Head_map;
           L_nul: EXTENDED ;
           place: Place_map;
     point_gauss: koeff;
     gauss_point: koeff;
           ip,op: tgpoly;
           ab: ab_rec;
   RN:record
   alf,C,e,Pi4,Ro1,B_main_S,B_main_N,Bmin,Bmax,
   Lmin,Lmax,Lmain_w,Lmain_O,MS,MC,mcy,msy,X0,Y0,MSb,mcby,msby,MCb,GX0,GY0,
   C2,C4,C6,C8:extended;
   map_a,map_b:lpoint;
   flspec:boolean;
   TLFR:Tlline;

   end;
var
   avia:record
    Bmin,Bmax,Lmin,Lmax,B0,L0:double;
    cosalfa:array[1..6] of extended;
    sinalfa:array[1..6] of extended;
    cosbetta,sinbetta,cosOmega,sinOmega:extended;
    ib:integer;
   end;

{function Get_bl(n,def: word; var b,l: float): boolean;}
function Take_L0:boolean;
procedure BL_XY_main (BL: _geoid;  var XY: tgauss);


 function  Grad_rad (grad,min: integer; sec: EXTENDED): EXTENDED ;
procedure Rad_grad (rad: EXTENDED; var grad,min: integer; var sec: EXTENDED);
procedure XY_BL_main (XY: tgauss; var BL: _geoid);
procedure Direct (t1:_geoid; A1,s: EXTENDED; var t2:_geoid; var A2: EXTENDED);
procedure Koeff_Main_int (t1_old  ,t2_old  : tgauss;
                          t1_new_i,t2_new_i: lpoint ; var pm: koeff);
procedure Koeff_int_Main (t1_old_i,t2_old_i: lpoint;
                          t1_new  ,t2_new  : tgauss; var pm: koeff);
procedure Main_int (pntrel: tgauss; pm: koeff; var pntint: lpoint);
procedure Int_Main (pntint: lpoint; pm: koeff; var pntrel: tgauss);
procedure Back_p (t1,t2: _geoid; var A1,s: EXTENDED);
procedure BL_local (BL:tgauss;  var XY:lpoint);
procedure local_BL (XY:lpoint; var BL:tgauss);
function Init_geoid:boolean;

procedure Init_BL_RNVG(b1,l1,b2:extended);
procedure BL_RNVG(bl:_geoid; var DG:tgauss);
procedure RNVG_BL(DG:tgauss; var bl:_geoid );
function Init_RNVG(Nomenkl:string):boolean;
function Init_RNVG_spesial(Node1,Node2:longint; Bm_S,Bm_N,l_w:double):boolean;

procedure RN_to_L(bl:_geoid; var P:lpoint);

procedure L_to_RN(P:lpoint; var bl:_geoid );
procedure Get_L1_l2_from_B_x(B:extended;var l1,l2:Extended);
procedure Get_L1_L2_from_B_Up(B:extended; var l1,l2:extended);
procedure Get_L1_l2_from_B_x1_x2(B:extended;x1,x2:longint;var l1,l2:Extended);

procedure BL_Avia_main(B,L:extended; var X,Y:double);
procedure BL_Avia_INI(Bc,Lc:double);
procedure BL_avia(B,L:extended;  var XY:lpoint);
procedure Nomenkl_Avia_Main_500(nomenkl:shortstring);
procedure Nomenkl_Avia_Main(nomenkl:shortstring);

Procedure Avia_BL(tg:tgauss; var bl:tgauss; var n_it:integer;eps:extended);
{procedure BL_XY(a: _geoid; lc: float; var g: tgauss);
 }
{____________________________________}
const A1_6: array[1..12] of T_A1_6=
 {0-6}  ((2800.555050, -2776.909277, 2730.080701, -2705.899460,2730.080701, -2776.909277),
 {6-12}  (2491.504705, -2466.374096, 2416.585260, -2390.927665, 2416.585260, -2466.374096),
 {12-18} (1820.770440, -1792.726148, 1737.130548, -1708.580006, 1737.130548, -1792.726148),
 {18-24} (677.4837718, -645.2458051, 581.2981161, -548.5893522, 581.2981161, -645.2458051),
 {24-30} (-1119.504149, 1156.901049, -1231.111799, 1268.924447, -1231.111799, 1156.901049),
 {30-36} (-3844.130296, 3887.064744, -3972.270555, 4015.540438, -3972.270555, 3887.064744),
 {36-42} (-7909.309223, 7957.161717, -8052.093064, 8100.170137, -8052.093064, 7957.161717),
 {42-48} (-13971.55863, 14022.09115, -14122.23838, 14172.85101, -14122.23838, 14022.09115),
 {48-54} (-23175.64719, 23223.95244, -23319.46929, 23367.67850, -23319.46929, 23223.95244),
 {54-60} (-37734.77731, 37771.13883, -37842.57235, 37878.64170, -37842.57235, 37771.13883),
 {60-66} (-563.3463311, 599.2437588, -670.4578399, 706.7713163, -670.4578399, 599.2437588),
 {66-72} (-2775.724496, 2822.250020, -2914.389750, 2961.000608, -2914.389750, 2822.250020));

 implementation

 const
     R     = 6367558.497;
     e2    = 6.693421623E-3;

procedure BL_local (BL:tgauss;  var XY:lpoint);
var
   geoid_:_geoid;
   tg:tgauss;
begin
  geoid_.b:=BL.x;
  geoid_.l:=BL.y;
  BL_XY_main (geoid_,tg);
  Main_int (tg,gauss_point,XY);
end;
procedure local_BL (XY:lpoint; var BL:tgauss);
var
  tt:_geoid;
  tg:tgauss;
begin
  INt_main(XY,point_gauss,tg);
  XY_BL_main (tg,tt);
  BL.x:=tt.b;
  BL.y:=tt.l
end;

{____________________________________________}

function Grad_rad;

begin
 if grad < 0 then Grad_rad := (grad - min / 60.0 - sec / 3600.0) * pi / 180.0
             else Grad_rad := (grad + min / 60.0 + sec / 3600.0) * pi / 180.0 ;
end; {Grad_rad}

{____________________________________________}

procedure Rad_grad ;

   begin
      rad  := rad * 180.0 / pi ;
      grad := trunc (rad) ;
      min  := abs(trunc( ( rad -grad ) * 60 )) ;
      sec  := ( abs(rad) - abs(grad) - min / 60 ) * 3600 ;
   end; {Rad_grad}
{____________________________________________}
 const
  rad = 57.29577951308;
procedure XY_BL_main( xy: tgauss;  var bl: _geoid );
var
  N,N1,B2,B4,B6,F,Z,P,R,ALF, a,alfa,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,
  K2,K4,K6,U,V,sp,chp,SinF,TanL{,ZON}: double;
  neg:boolean;
begin
   XY.Y:=XY.Y-head.zone*1000000-500000;

  with xy,bl do begin
    neg:=X<0;
    X:=ABS(X);
    ALFA:=298.3; A:=6378245;
    {ALFA=A/(A-B);
    ,Ј¤Ґ A - 1 Ї®«г®бм;
         B - 2 Ї®«г®бм
    }
    ALF:=1/ALFA; N:=ALF/(2-ALF);
    N1:=Sqr(N);  R:=A*(1+N1/4+N1*N1/64)/(1+N);
    B2:=N/2-N1*(2/3)+N*N1*(37/96); B4:=N1/48+N*N1/15;
    B6:=N*N1*17/480;
    K2:=2*(N-N1/3-N*N1);
    K4:=N1*7/3-N1*N*8/5; K6:=N1*N*56/15;
    U:=x/R; V:=y/R; a11:=Sin(2*U); b11:=Cos(2*U);
    a21:=2*a11*b11; b21:=1-2*(a11*a11);
    a31:=a11*b21+a21*b11; b31:=b11*b21-a11*a21;
    c11:=(exp(2*V)-exp(-2*V))/2; d11:=sqrt(1+sqr(c11));
    c21:=2*c11*d11; d21:=1+2*sqr(c11);
    c31:=c11*d21+c21*d11; d31:=c11*c21+d11*d21;
    Z:=U-B2*a11*d11-B4*a21*d21-B6*a31*d31;
    P:=V-B2*b11*c11-B4*b21*c21-B6*b31*c31;
    sp:=(exp(P)-exp(-P))/2; chp:=sqrt(1+Sqr(sp));
    SinF:=Sin(Z)/chp; F:=ArcTan((SinF)/(Sqrt(1-Sqr(SinF))));
    TanL:=sp/Cos(Z); L:=ArcTan(TanL);
    B:=F+K2*Sin(2*F)+K4*sin(4*F)+K6*sin(6*F);

    IF B > 88/rad THEN B:=B-Pi;
    IF neg then B:=-B;
    L:=L+l_NUL;
    If L >= Pi THEN L:=Pi+Pi-L;
  end
end;


procedure Bl_kon(bl: _geoid;  var xy: tgauss );
var
   ro,delt,alf,e,esinfi,A,k,r1,r2,U1,U2,fi1,fi2,Ksi:double;
begin
   A:=6378245;
   e:=sqrt(0.006693422);
   Fi1:=PI/6; {30 Ја ¤гб®ў}
   FI2:=PI/3; {60 Ја ¤гб®ў}
   r1:=A*cos(fi1);
   r2:=A*cos(Fi2);
   esinfi:=e*sin(fi1);
   ksi:= ArcTan (esinfi/sqrt (1-sqr (esinfi)));
   U1:=(sin(PI/4.0+fi1/2.0)/cos(PI/4.0+Fi1/2.0))/
      exp(e*ln(sin(PI/4.0+ksi/2.0)/cos(PI/4.0+ksi/2.0)));
   esinfi:=e*sin(fi2);
   ksi:= ArcTan (esinfi/sqrt (1-sqr (esinfi)));
   U2:=(sin(PI/4.0+fi2/2.0)/cos(PI/4.0+Fi2/2.0))/
      exp(e*ln(sin(PI/4.0+ksi/2.0)/cos(PI/4.0+ksi/2.0)));
   alf:=(ln(r1)-ln(r2))/(ln(U2)-ln(U1));
   k:=r1*exp(alf*ln(U1))/alf;
   esinfi:=e*sin(bl.b);
   ksi:= ArcTan (esinfi/sqrt (1-sqr (esinfi)));
   U2:=(sin(PI/4.0+bl.b/2.0)/cos(PI/4.0+bl.b/2.0))/
      exp(e*ln(sin(PI/4.0+ksi/2.0)/cos(PI/4.0+ksi/2.0)));
   ro:=k/exp(alf*ln(U2));
   delt:=alf*(bl.l-PI/9);
   XY.x:=k-ro*cos(delt);
   XY.Y:=8000000.0+ro*sin(delt)
end;


(*
procedure XY_BL_merc_heif( xy: tgauss;  var bl: _geoid );
var
  N,N1,A0,b0,B2,B4,B6,F,Z,P,R,ALF, a,alfa,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,
  sinfi,r0,eks2,K2,K4,K6,U,V,sp,chp,SinF,TanL,fi0: double;
begin
    ALFA:=297.0; A:=6378388;

  eks2:=(sqr(6378388.0)-sqr(6356912))/sqr(63783888.0);
  b0:=1+eks2/2+21/96*sqr(eks2)+115/480*Sqr(eks2)*eks2;
  b2:=eks2/2+10/24*sqr(eks2)+7/64*Sqr(eks2)*eks2;
  b4:=7/192*sqr(eks2)+237/960*Sqr(eks2)*eks2;
  {ALF:=1/ALFA; N:=ALF/(2-ALF);
  N1:=Sqr(N);
  A0:=1+N1/4+N1*N1/64; R:=A*A0/(1+N);}
  r0:=6378388{*cos(fi0)};
  U:=exp(XY.x/r0);
  sinfi:=(SQR(U)-1)/(SQR(U)+1);
  sinfi:=sinfi*(b0+b2*(1-2*sqr(sinfi))+b4*(1-8*sqr(sinfi)+8*sqr(sqr(sinfi))));
  BL.b:= ArcTan (sinfi/sqrt (1-sqr (sinfi)));
  BL.l:= -Grad_rad (78,30,00)+(XY.Y-778280)/r0;
end;


procedure XY_BL_trvs_merc_heif( xy: tgauss;  var bl: _geoid );
var
  N,N1,b0,A0,A2,A4,A6,F,Z,P,R,ALF, A,ALFA,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,
  x0,y0,l0,et,ksi,sinfi,r0,eks,K2,K4,K6,U,V,sp,chp,SinF,TanL,fi0: double;
  it:longint;
begin
    ALFA:=297.0; A:=6378388;
    x0:=778280; y0:=10000000;
    l0:= -Grad_rad (78,30,0);
    ALF:=1/ALFA; N:=ALF/(2-ALF);
    N1:=Sqr(N);
    A0:=1+N1/4+N1*N1/64; R:=A*A0/(1+N);
    A2:=3*N/2-N1*(3/16);
    A4:=N1*15/16-N1*N1*15/64;
    A6:=N*N1*35/48;
    et:=2*arctan(exp((XY.X-x0)/R))-Pi/2;
    ksi:=(XY.Y-Y0)/R;
    bl.l:=l0+arctan((sin(et)/cos(et))/cos(ksi));
    V:=sin(ksi)*cos(et);
    U:=  ArcTan (V/sqrt (1-sqr (V)));
    fi0:=U;
    it:=0;
    repeat
    inc(it);
    U:=fi0;
    fi0:=U+A2/A0*sin(2*U)-A4/A0*sin(4*U)+A6/A0*sin(6*U);
    if it>100 then break;
    until abs(fi0-U)<0.000001;
    Bl.b:=fi0;
end;
*)
procedure Direct(t1:_geoid; A1,s: EXTENDED; var t2:_geoid; var A2: EXTENDED);

var
     w,su,cu,sa0,ct1,s21,c21, tga2,
     a,b,c,alfa,beta,sg,su2,tgl,
     sg0,si2,co2,del,lam,c2a0,sina1, b1,l1,b2,l2: EXTENDED;

begin

   b1 := t1.b;   l1 := t1.l;

if a1 > 2*pi then a1 :=  ( a1/(2*pi) -  trunc ( a1 / (2*pi) )) * 2*pi ;
if b1 > 2*pi then b1 :=  ( b1/(2*pi) -  trunc ( b1 / (2*pi) )) * 2*pi ;

   a1 := a1 + 1.0E-20 ;
   b1 := b1 + 1.0E-20 ;

sina1:= sin (a1) ;
w    := sqrt ( 1.0 - e2*sin(b1)*sin(b1) ) + 1.0E-10 ;
su   := sin(b1)* sqrt( 1.0 - e2) / w      ;
cu   := cos (b1) / w                   ;
sa0  := cu * sina1                  ;
ct1  := cu * cos (a1) / su             ;
s21  := 2.0 * ct1 / ( ct1*ct1 + 1.0 )      ;
c21  := ( ct1*ct1 - 1.0 ) / (ct1*ct1 + 1.0 ) ;
c2a0 := 1.0 - sa0*sa0                    ;
a    := 6356863.020 + ( 10708.949 - 13.474 * c2a0 ) * c2a0 ;
b    := ( 5354.469 - 8.978 * c2a0 ) * c2a0 ;
c    := ( 2.238 * c2a0 ) * c2a0 + 0.006 ;
alfa := 3.352329869E-3 - ( 2.8189E-6 -  c2a0*c2a0 * 7.0E-9 ) * c2a0 ;
beta := ( 1.40943E-6 - c2a0*c2a0 * 4.686E-9 ) * c2a0 ;
sg0  := ( s - (b+ c*c21) * s21 ) / a ;
si2  := s21* cos(2*sg0) + c21* sin(2*sg0) ;
co2  := c21* cos(2*sg0) - s21* sin(2*sg0) ;
sg   := sg0 + ( b + 5*c*co2 ) * si2 / a ;
del  := ( alfa*sg + beta* ( si2 - s21 ) ) * sa0 ;
su2  := su* cos(sg) + cu* cos(a1)* sin(sg) ;

b2   := arctan ( su2 / ( sqrt(1.0-e2) * sqrt(1.0 - su2*su2 ) ) );
lam  := arctan ( sina1 * sin(sg) / ( cu* cos(sg)- su* sin(sg)* cos(a1)) ) ;
a2   := arctan ( cu* sina1 / ( cu*cos(sg)*cos(a1) - su*sin(sg) ) ) ;
tgl  := sin(lam) / ( cos(lam) + 1.0E-10 ) ;
tga2 := sin(a2)  / ( cos(a2)  + 1.0E-10 ) ;

  if sina1 >= 0.0 then if tgl >= 0.0 then lam :=      abs(lam)
                                     else lam := pi - abs(lam)
                  else if tgl >= 0.0 then lam := abs(lam) -   pi
                                     else lam := -1.0 * abs(lam);

  if sina1 >= 0.0 then if tga2 >= 0.0 then a2 := pi      + abs(a2)
                                      else a2 := 2.0* pi - abs(a2)
                  else if tga2 >= 0.0 then a2 :=      abs(a2)
                                      else a2 := pi - abs(a2);

l2 := l1 + lam - del ;

  t2.b := b2;   t2.l := l2;

end;  { Direct }
(*
{____________________________________________}

procedure Back ; { ®Ўа в­ § ¤ з  }

var
     w1,w2,su1,cu1,su2,alfa,sinsg,
     cu2,c1,d1,c2,b,d2,beta,cossg,
     lam,sg,l,q,sina0,x,y,del,dl,a, b1,l1,b2,l2: EXTENDED;
begin

b1 := t1.b + 1.0E-20;
l1 := t1.l + 1.0E-20;
b2 := t2.b + 1.0E-20;
l2 := t2.l + 1.0E-20;

if l1 > 2*pi then l1 :=  ( l1/(2*pi) -  trunc(l1 /(2*pi)))*2*pi;
if b1 > 2*pi then b1 :=  ( b1/(2*pi) -  trunc(b1 /(2*pi)))*2*pi;
if l2 > 2*pi then l2 :=  ( l2/(2*pi) -  trunc(l2 /(2*pi)))*2*pi;
if b2 > 2*pi then b2 :=  ( b2/(2*pi) -  trunc(b2 /(2*pi)))*2*pi;

w1    := sqrt ( 1.0 - e2*sin(b1)*sin(b1) ) + 1.0E-10 ;
w2    := sqrt ( 1.0 - e2*sin(b2)*sin(b2) ) + 1.0E-10 ;
su1   := sin(b1)* sqrt( 1.0 - e2) / w1     ;
su2   := sin(b2)* sqrt( 1.0 - e2) / w2     ;
cu1  := cos (b1) / w1  + 1.0E-10           ;
cu2  := cos (b2) / w2  + 1.0E-10           ;

l    := l2-l1                           ;
c1   := su1*su2                         ;
c2   := cu1*cu2                         ;
d1   := cu1*su2                         ;
d2   := su1*cu2                         ;

     del:= 0 ;

     REPEAT

     dl  := del ;
     lam := l + dl ;
     p   := cu2* sin (lam);
     q   := d1 - d2*cos(lam) + 1.0E-10 ;
     a1  := arctan(p/q);

     if p >= 0.0 then if q >= 0.0 then a1 :=      abs(a1)
                                  else a1 := pi - abs(a1)
                 else if q >= 0.0 then a1 := 2.0* pi - abs(a1)
                                  else a1 := pi      + abs(a1);

     sinsg := p* sin(a1) + q* cos(a1) ;
     cossg := c1 + c2* cos(lam) ;
     if cossg >= 0.0 then sg :=      abs (arctan(sinsg/cossg))
                     else sg := pi - abs (arctan(sinsg/cossg));

     sina0 := cu1* sin(a1);
     x     := 2*c1 - cos(sg)*( 1- sina0*sina0 );
     alfa  := 3.352329869E-3 - (2.8189E-6 - 7.0E-9 * ( 1-sina0*sina0) ) *
                                                     ( 1-sina0*sina0);
     beta  := 2.8189E-6 - 9.4E-9 * ( 1- sina0*sina0 ) ;
     del   := (alfa* sg - beta* x* sin(sg) ) * sina0 ;

     UNTIL abs (del - dl) <= 1.0E-10 ;

y := ( sqr ( 1 - sina0*sina0 ) - 2*x*x ) * cos (sg) ;
a := 6356863.020 + (10708.949 - 13.474  * ( 1-sina0*sina0 ) ) *
                                          ( 1-sina0*sina0);
b := 10708.938 - 17.956* (1 - sina0*sina0);
s := a* sg + ( b* x + 4.487* y ) * sinsg ;
p := cu1 * sin(lam) ;
q := d1* cos (lam) - d2 ;
a2 := arctan ( p / q ) ;

     if p >= 0.0 then if q >= 0.0 then a2 := pi +    abs(a2)
                                  else a2 := 2* pi - abs(a2)
                 else if q >= 0.0 then a2 := pi    - abs(a2)
                                  else a2 :=         abs(a2);

end;  { Back }

{____________________________________________}

{__________________________________________}


procedure Orto;

var
     w1,w2,su1,cu1,su2,alfa,sinsg    : EXTENDED ;
     cu2,c1,d1,c2,bb,d2,beta,cossg   : EXTENDED ;
     lam,sg,ll,q,sina0,xx,yy,del,dl  : EXTENDED ;
     b1,l1,b2,l2,a1,s,a              : EXTENDED ;
     sinx,siny,sind                  : EXTENDED ;

begin

 b1 := b0 + 1.0E-20 ;
 l1 := l0 + 1.0E-20 ;
 b2 := b  + 1.0E-20 ;
 l2 := l  + 1.0E-20 ;

 w1    := sqrt ( 1.0 - e2*sin(b1)*sin(b1) ) + 1.0E-10 ;
 w2    := sqrt ( 1.0 - e2*sin(b2)*sin(b2) ) + 1.0E-10 ;
 su1   := sin(b1)* sqrt( 1.0 - e2) / w1;
 su2   := sin(b2)* sqrt( 1.0 - e2) / w2;
 cu1  := cos (b1) / w1  + 1.0E-10;
 cu2  := cos (b2) / w2  + 1.0E-10;

 ll   := l2-l1  ;
 c1   := su1*su2;
 c2   := cu1*cu2;
 d1   := cu1*su2;
 d2   := su1*cu2;

     del:= 0 ;

     repeat

     dl  := del ;
     lam :=ll + dl ;
     p   := cu2* sin (lam);
     q   := d1 - d2*cos(lam) + 1.0E-10 ;
     a1  := arctan(p/q);

     if p >= 0.0 then if q >= 0.0 then a1 :=      abs(a1)
                                  else a1 := pi - abs(a1)
                 else if q >= 0.0 then a1 := 2.0* pi - abs(a1)
                                  else a1 := pi      + abs(a1);

     sinsg := p* sin(a1) + q* cos(a1) ;
     cossg := c1 + c2* cos(lam) + 1.0E-10 ;

     if cossg >= 0.0 then sg :=      abs ( arctan(sinsg/cossg) )
                     else sg := pi - abs ( arctan(sinsg/cossg) ) ;

     sina0 := cu1* sin(a1);
     xx    := 2*c1 - cos(sg)*( 1- sina0*sina0 );
     alfa  := 3.352329869E-3 - (2.8189E-6 - 7.0E-9 * ( 1-sina0*sina0) ) *
                                                     ( 1-sina0*sina0);
     beta  := 2.8189E-6 - 9.4E-9 * ( 1- sina0*sina0 ) ;
     del   := (alfa* sg - beta* xx* sin(sg) ) * sina0 ;

     until abs (del - dl) <= 1.0E-10 ;

 yy := ( sqr ( 1 - sina0*sina0 ) - 2*xx*xx ) * cos (sg) ;
 a := 6356863.020 + (10708.949 - 13.474  * ( 1-sina0*sina0 ) ) *
                                          ( 1-sina0*sina0);
 bb := 10708.938 - 17.956* (1 - sina0*sina0);
 s := a* sg + ( bb* xx + 4.487* yy ) * sinsg ;
 sinx := sin (sg) * cos(a1);
 siny := sin(sg) * sin(a1) / sqrt( 1 - sinx* sinx ) ;
 sind := siny * su1 / cu2 ;

 XX := 5000.0 + arctan ( sinx / sqrt ( 1 - sinx*sinx ) ) * s / sg / 1000.0 ;
 YY := 5000.0 + arctan ( siny / sqrt ( 1 - siny*siny ) ) * s / sg / 1000.0 ;
 X := round ( XX ) ;
 Y := round ( YY ) ;
 delta := arctan ( sind / sqrt ( 1 - sind*sind ) ) ;
 if delta < 0 then delta := delta + 2* pi ;
 delta := delta * 180.0 / pi ;

end;  { Orto }
*)
procedure Main_int   ; { аҐ «м. ў жҐ«лҐ Є®®а¤ }
begin
pntint.x := round( pm.x0 +  pm.Mc * pntrel.x  -  pm.Ms * pntrel.y )  ;
pntint.y := round( pm.y0 +  pm.Msy * pntrel.x  +  pm.Mcy * pntrel.y )  ;
end ;

procedure Koeff_Main_int (t1_old  ,t2_old  : tgauss;
                          t1_new_i,t2_new_i: lpoint ; var pm: koeff);

 type lpoint_r = record x,y: EXTENDED end;

var
  t1_new,t2_new: lpoint_r;
  dx_o,dy_o,
  dx_n,dy_n,rr, Mc,Ms: EXTENDED;
begin
    t1_new.x:= t1_new_i.x; t1_new.y:= t1_new_i.y;
    t2_new.x:= t2_new_i.x; t2_new.y:= t2_new_i.y;

  dx_o := t2_old.x-t1_old.x;
  dy_o := t2_old.y-t1_old.y;
  dx_n := t2_new.x-t1_new.x;
  dy_n := t2_new.y-t1_new.y;
  rr := dx_o*dx_o + dy_o*dy_o;

  Mc := (dx_n*dx_o + dy_n*dy_o)/rr;
  pm.Mc:=mc;
  Ms := (dx_o*dy_n - dy_o*dx_n)/rr;
  pm.Ms := Ms;

  pm.x0 := t1_new.x - pm.Mc*t1_old.x +  pm.Ms*t1_old.y;
  pm.y0 := t1_new.y - pm.Ms*t1_old.x -  pm.Mc*t1_old.y;
end;

{__________________________________________}

procedure Koeff_int_Main (t1_old_i,t2_old_i: lpoint;
                          t1_new  ,t2_new  : tgauss; var pm: koeff);

 type lpoint_r = record x,y: EXTENDED end;
var
  t1_old,t2_old: lpoint_r;
  dx_o,dy_o,
  dx_n,dy_n,rr : EXTENDED;

begin
    t1_old.x:= t1_old_i.x; t1_old.y:= t1_old_i.y;
    t2_old.x:= t2_old_i.x; t2_old.y:= t2_old_i.y;

  dx_o := t2_old.x-t1_old.x;
  dy_o := t2_old.y-t1_old.y;
  dx_n := t2_new.x-t1_new.x;
  dy_n := t2_new.y-t1_new.y;
  rr := dx_o*dx_o + dy_o*dy_o;

  pm.Mc := (dx_n*dx_o + dy_n*dy_o)/rr;
  pm.Ms := (dx_o*dy_n - dy_o*dx_n)/rr;

  pm.x0 := t1_new.x - pm.Mc*t1_old.x +  pm.Ms*t1_old.y;
  pm.y0 := t1_new.y - pm.Ms*t1_old.x -  pm.Mc*t1_old.y;

end;

procedure BL_XY_main( bl: _geoid;  var xy: tgauss );
var
  N,N1,RAS,A2,A4,A6,F,Z,P,RA,R,ALF,TZ,TZ2,TH,T2,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,
  a,alfa, ZON, K2,K4,K6,LL,LLL,l0: double;
  neg:boolean;
begin
  with bl,xy do begin
     l0:=l_nul*rad;
     neg:=b<0;
     b:=abs(b);
    ALFA:=298.3; A:=6378245;

    ALF:=1/ALFA; N:=ALF/(2-ALF);
    N1:=Sqr(N); R:=A*(1+N1/4+N1*N1/64)/(1+N);
    A2:=N/2-N1*(2/3)+N*N1*(5/16);
    A4:=N1*13/48-N*N1*3/5;
    A6:=N*N1*61/240;
    K2:=2*(N-N1/3-N*N1*2/3);
    K4:=N1*5/3-N1*N*16/15;
    K6:=N1*N*26/15;
    LLL:=ABS(L);
    IF LLL >= 180  THEN BEGIN
                           LLL:=360-LLL;L:=LLL*(-1);
                        END;
    IF L<0 THEN LL:=L+360 ELSE LL:=L;

    RAS:=l-l_nul;
    IF B<0 THEN BEGIN
                   B:=Abs(B);
                   F:=(B-K2*SIN(2*B)+K4*SIN(4*B)-K6*SIN(6*B))*(-1);
                   B:=B*(-1);
                END ELSE F:=B-K2*SIN(2*B)+K4*SIN(4*B)-K6*SIN(6*B);
    TZ:=(Sin(F)/Cos(F))/Cos(RAS); TZ2:=Sqr(TZ);
    Z:=ArcTan(TZ); TH:=COS(F)*SIN(RAS);
    T2:=Sqr(TH); P:=Ln((1+TH)/(1-TH))/2;
    a11:=2*TZ/(1+TZ2);b11:=(1-TZ2)/(1+TZ2);
    c11:=2*TH/(1-T2);d11:=(1+T2)/(1-T2);
    a21:=2*a11*b11;c21:=2*c11*d11;
    b21:=1-2*Sqr(a11);d21:=1+2*Sqr(c11);
    a31:=a11*b21+a21*b11;c31:=c11*d21+c21*d11;
    b31:=b11*b21-a11*a21;d31:=d11*d21+c11*c21;
    X:=R*(Z+A2*a11*d11+A4*a21*d21+A6*a31*d31);
    IF neg THEN X:=-X;
    IF X<0 THEN BEGIN
                   X:=ABS(X);
                   X:=((X*1000+0.5)/1000)*(-1);
                END ELSE X:=(X*1000+0.5)/1000;
    Y:=R*(P+A2*b11*c11+A4*b21*c21+A6*b31*c31);

    Y:=((Y*1000+0.5)/1000);
    Y:=Y+head.zone*1000000+500000;
  end
END;

procedure Int_Main   ; { жҐ«лҐ ў аҐ «м­лҐ Є®®а¤ }
begin
pntrel.x := pm.x0 +  pm.Mc * pntint.x  -  pm.Ms * pntint.y ;
pntrel.y := pm.y0 +  pm.Msy * pntint.x  +  pm.Mcy * pntint.y ;
end ;

procedure Back_p ; { ®Ўа в­ § ¤ з  }

var
     w1,w2,su1,cu1,su2,alfa,sinsg,
     cu2,c1,d1,c2,b,d2,beta,cossg,
     lam,sg,l,p,q,sina0,x,y,del,dl,a, b1,l1,b2,l2: EXTENDED;
begin

b1 := t1.b + 1.0E-20;
l1 := t1.l + 1.0E-20;
b2 := t2.b + 1.0E-20;
l2 := t2.l + 1.0E-20;

if l1 > 2*pi then l1 :=  ( l1/(2*pi) -  trunc(l1 /(2*pi)))*2*pi;
if b1 > 2*pi then b1 :=  ( b1/(2*pi) -  trunc(b1 /(2*pi)))*2*pi;
if l2 > 2*pi then l2 :=  ( l2/(2*pi) -  trunc(l2 /(2*pi)))*2*pi;
if b2 > 2*pi then b2 :=  ( b2/(2*pi) -  trunc(b2 /(2*pi)))*2*pi;

w1    := sqrt ( 1.0 - e2*sin(b1)*sin(b1) ) + 1.0E-10 ;
w2    := sqrt ( 1.0 - e2*sin(b2)*sin(b2) ) + 1.0E-10 ;
su1   := sin(b1)* sqrt( 1.0 - e2) / w1     ;
su2   := sin(b2)* sqrt( 1.0 - e2) / w2     ;
cu1  := cos (b1) / w1  + 1.0E-10           ;
cu2  := cos (b2) / w2  + 1.0E-10           ;

l    := l2-l1                           ;
c1   := su1*su2                         ;
c2   := cu1*cu2                         ;
d1   := cu1*su2                         ;
d2   := su1*cu2                         ;

     del:= 0 ;

     REPEAT

     dl  := del ;
     lam := l + dl ;
     p   := cu2* sin (lam);
     q   := d1 - d2*cos(lam) + 1.0E-10 ;
     a1  := arctan(p/q);

     if p >= 0.0 then if q >= 0.0 then a1 :=      abs(a1)
                                  else a1 := pi - abs(a1)
                 else if q >= 0.0 then a1 := 2.0* pi - abs(a1)
                                  else a1 := pi      + abs(a1);

     sinsg := p* sin(a1) + q* cos(a1) ;
     cossg := c1 + c2* cos(lam) ;
     if cossg >= 0.0 then sg :=      abs (arctan(sinsg/cossg))
                     else sg := pi - abs (arctan(sinsg/cossg));

     sina0 := cu1* sin(a1);
     x     := 2*c1 - cos(sg)*( 1- sina0*sina0 );
     alfa  := 3.352329869E-3 - (2.8189E-6 - 7.0E-9 * ( 1-sina0*sina0) ) *
                                                     ( 1-sina0*sina0);
     beta  := 2.8189E-6 - 9.4E-9 * ( 1- sina0*sina0 ) ;
     del   := (alfa* sg - beta* x* sin(sg) ) * sina0 ;

     UNTIL abs (del - dl) <= 1.0E-10 ;

y := ( sqr ( 1 - sina0*sina0 ) - 2*x*x ) * cos (sg) ;
a := 6356863.020 + (10708.949 - 13.474  * ( 1-sina0*sina0 ) ) *
                                          ( 1-sina0*sina0);
b := 10708.938 - 17.956* (1 - sina0*sina0);
s := a* sg + ( b* x + 4.487* y ) * sinsg ;
//p := cu1 * sin(lam) ;
//q := d1* cos (lam) - d2 ;

end;  { Back_p }
(*
procedure Orto_p;

var
     w1,w2,su1,cu1,su2,alfa,sinsg    : EXTENDED ;
     cu2,c1,d1,c2,bb,d2,beta,cossg   : EXTENDED ;
     lam,sg,ll,q,sina0,xx,yy,del,dl  : EXTENDED ;
     b1,l1,b2,l2,a1,s,a              : EXTENDED ;
     sinx,siny,sind                  : EXTENDED ;

begin

 b1 := nn.b + 1.0E-20 ;
 l1 := nn.l + 1.0E-20 ;
 b2 := kk.b  + 1.0E-20 ;
 l2 := kk.l  + 1.0E-20 ;

 w1    := sqrt ( 1.0 - e2*sin(b1)*sin(b1) ) + 1.0E-10 ;
 w2    := sqrt ( 1.0 - e2*sin(b2)*sin(b2) ) + 1.0E-10 ;
 su1   := sin(b1)* sqrt( 1.0 - e2) / w1;
 su2   := sin(b2)* sqrt( 1.0 - e2) / w2;
 cu1  := cos (b1) / w1  + 1.0E-10;
 cu2  := cos (b2) / w2  + 1.0E-10;

 ll   := l2-l1  ;
 c1   := su1*su2;
 c2   := cu1*cu2;
 d1   := cu1*su2;
 d2   := su1*cu2;

     del:= 0 ;

     repeat

     dl  := del ;
     lam :=ll + dl ;
     p   := cu2* sin (lam);
     q   := d1 - d2*cos(lam) + 1.0E-10 ;
     a1  := arctan(p/q);

     if p >= 0.0 then if q >= 0.0 then a1 :=      abs(a1)
                                  else a1 := pi - abs(a1)
                 else if q >= 0.0 then a1 := 2.0* pi - abs(a1)
                                  else a1 := pi      + abs(a1);

     sinsg := p* sin(a1) + q* cos(a1) ;
     cossg := c1 + c2* cos(lam) + 1.0E-10 ;

     if cossg >= 0.0 then sg :=      abs ( arctan(sinsg/cossg) )
                     else sg := pi - abs ( arctan(sinsg/cossg) ) ;

     sina0 := cu1* sin(a1);
     xx    := 2*c1 - cos(sg)*( 1- sina0*sina0 );
     alfa  := 3.352329869E-3 - (2.8189E-6 - 7.0E-9 * ( 1-sina0*sina0) ) *
                                                     ( 1-sina0*sina0);
     beta  := 2.8189E-6 - 9.4E-9 * ( 1- sina0*sina0 ) ;
     del   := (alfa* sg - beta* xx* sin(sg) ) * sina0 ;

     until abs (del - dl) <= 1.0E-10 ;

 yy := ( sqr ( 1 - sina0*sina0 ) - 2*xx*xx ) * cos (sg) ;
 a := 6356863.020 + (10708.949 - 13.474  * ( 1-sina0*sina0 ) ) *
                                          ( 1-sina0*sina0);
 bb := 10708.938 - 17.956* (1 - sina0*sina0);
 s := a* sg + ( bb* xx + 4.487* yy ) * sinsg ;
 sinx := sin (sg) * cos(a1);
 siny := sin(sg) * sin(a1) / sqrt( 1 - sinx* sinx ) ;
 sind := siny * su1 / cu2 ;

 XX := 5000.0 + arctan ( sinx / sqrt ( 1 - sinx*sinx ) ) * s / sg / 1000.0 ;
 YY := 5000.0 + arctan ( siny / sqrt ( 1 - siny*siny ) ) * s / sg / 1000.0 ;
 X := round ( XX ) ;
 Y := round ( YY ) ;
 delta := arctan ( sind / sqrt ( 1 - sind*sind ) ) ;
 if delta < 0 then delta := delta + 2* pi ;
 delta := delta * 180.0 / pi ;

end;  {orto_p}

procedure BL_local (BL:tgauss;  var XY:lpoint); {ЈҐ®¤. ў ¬Ґбв­лҐ}
var
   geoid_:_geoid;
   tg:tgauss;
begin
  geoid_.b:=BL.x;
  geoid_.l:=BL.y;
  BL_XY_main (geoid_,tg);
  Main_int (tg,gauss_point,XY);
end;


*)

function Init_geoid:boolean; var b: byte;
var
q : lpoint;
i: integer;
A1,S,dx,dy: EXTENDED;
bs,ls: double;
Begin

if not Take_l0 then begin
           Init_geoid:=false; exit
end;
    dm_Goto_root;
with head do begin
       b:=0;
       if b=0 then half := east
              else half := west;
end;
with place do begin
       dmx_Find_frst_code (0,1);
       //while dm_get_code<>0 do dm_Find_next_code(0,1);
       dm_Get_Bound(point_[1],q);
       dm_Get_double(91,0,bs);
       dm_Get_double(92,0,ls);

(*       if not Get_BL(91,0,bs,ls) then begin
              {About('„«п ®Ї®а­ле в®зҐЄ ­Ґв B,L ');}
           Init_geoid:=false; exit end;*)
           geoid_[1].b:=bs;
           geoid_[1].l:=ls;
       BL_XY_main (geoid_[1],gauss_[1]);

    for i := 2 to 4 do begin
       if dmx_Find_next_code(0,1)=0 then begin
           {About('ЌҐ¤®бв в®з­® ®Ї®а­ле в®зҐЄ');}
           Init_geoid:=false; exit
       end;
       //while dm_get_code<>0 do  dm_Find_next_code(0,1);


       dm_Get_Bound(point_[i],q);
       dm_Get_double(91,0,bs);
       dm_Get_double(92,0,ls);
(*       if not Get_BL(91,0,bs,ls) then begin
           {About('„«п ®Ї®а­ле в®зҐЄ ­Ґв B,L');}
           Init_geoid:=false; exit
       end;*)
           geoid_[i].b:=bs;
           geoid_[i].l:=ls;
       BL_XY_main (geoid_[i],gauss_[i]);
    end;
        for i := 0 to 3 do begin
          ip[i].x:=gauss_[i+1].x;
          ip[i].y:=gauss_[i+1].y;
          op[i].x:=point_[i+1].x;
          op[i].y:=point_[i+1].y;
        end;
   {Calc_Min_Sqr(@op,@ip,4,ab);
        point_gauss.x0:=ab.a0;
        point_gauss.y0:=ab.b0;
        point_gauss.MC:=ab.ax;
        point_gauss.MS:=-ab.ay;
        point_gauss.MCy:=ab.by;
        point_gauss.MSy:=ab.bx;
   Calc_Min_Sqr(@ip,@op,4,ab);
        gauss_point.x0:=ab.a0;
        gauss_point.y0:=ab.b0;
        gauss_point.MCy:=ab.by;
        gauss_point.MSy:=ab.bx;
        gauss_point.MC:=ab.ax;
        gauss_point.MS:=-ab.ay;
    }

 Koeff_Main_int (gauss_[1],gauss_[3],point_[1],point_[3],gauss_point);

 Koeff_int_Main (point_[1],point_[3],gauss_[1],gauss_[3],point_gauss);

       point_gauss.MCy:=point_gauss.MC;
       point_gauss.MSy:=point_gauss.MS;
       gauss_point.MCy:=gauss_point.MC;
       gauss_point.MSy:=gauss_point.MS;
  Back_p (geoid_[1],geoid_[2],A1,s);
  dx:=point_[1].x-point_[2].x;
  dy:=point_[1].y-point_[2].y;
  A1:=sqrt(sqr(dx)+sqr(dy));
  Head.Ed_plan:=s/A1
end;

Init_geoid:=true;
end;

function Take_L0:boolean; { ўлЎ®а ­г«Ґў®Ј® ¬ҐаЁ¤Ё ­  ¤«п ¬Ґбв­®© ‘Љ }
var
  ls:single;
  L: array [1..15] of EXTENDED;
  done: boolean;
  i,n: word;
begin
  if dm_find_frst_code(0,1)=0 then begin
      Take_L0:=false;
      exit
    end;
  n:=1;
  repeat
    done:=dm_Get_angle(92,0,ls);
    l[n]:=ls;
    if done then Inc(n)
  until (dm_find_next_code(0,1)=0) or (n > 4);
  l_nul:= 0.0;
  for i:=1 to n-1 do l_nul:=l_nul+l[i];
  l_nul := l_nul / (n-1);
  if L_nul>0 then
  head.zone:=trunc(30*l_nul/Pi)+1
  else
  head.zone:=trunc(30*l_nul/Pi);

  l_NUL:=head.zone*Pi/30-Pi/60;
  TAKE_L0:=true;
end;
const
   A=6378245;
procedure Calc_U_R(bl_b:extended;var U,R:extended);
var
  B,Ux,Rx:extended;
begin
   B:=rn.e*sin(bl_b);
   B:=Arctan(B/sqrt(1-sqr(b)));
   Ux:=rn.Pi4+bl_b*0.5;
   Rx:=rn.Pi4+b*0.5;
   Rx:=exp(rn.e*ln(cos(Rx)/Sin(Rx)));
   Ux:=sin(Ux)/cos(Ux);
   U:=Ux*Rx;
   Rx:=A*cos(Bl_b);
   R:=Rx/sqrt(1-sqr(rn.e*sin(BL_b)));
end;

procedure Init_BL_RNVG(b1,l1,b2:extended);
var
   e2,alfr,B,Fx,Ux,Rx,U1,R1,U2,R2:extended;
begin
   alfr:=298.3;
   e2:=2/ alfr-sqr(1/ alfr);
   rn.e:=sqrt(e2);
   rn.Pi4:=Pi/4;
   Calc_U_R(B1,U1,R1);
   Calc_U_R(B2,U2,R2);
   rn.alf:=(ln(R1)-ln(R2))/(ln(U2)-ln(U1));
FX:=arctan(rn.alf/sqrt(1-sqr(rn.alf)));
B:=rn.e*sin(Fx);
B:=arctan(B/sqrt(1-sqr(B)));
Ux:=rn.Pi4+FX*0.5;
Rx:=rn.Pi4+B*0.5;
Rx:=Cos(Rx)/Sin(Rx);
Rx:=exp(ln(Rx)*rn.e);
Ux:=sin(Ux)*Rx/Cos(Ux);
Rx:=A*cos(Fx)/sqrt(1-sqr(rn.e*sin(fx)));
Rn.C:=sqrt(R1*Rx*exp(ln(U1*ux)*rn.alf))/rn.alf;
rn.Ro1:=rn.C/exp(ln(u1)*rn.alf);
end;

procedure BL_RNVG(bl:_geoid; var DG:tgauss);
var
   U,R,RO,delt1:extended;
begin
   Calc_U_R(BL.b,U,R);
   RO:=rn.c/exp(ln(u)*rn.alf);
   delt1:=rn.alf*(Bl.l-rn.lmain_w);
   DG.x:=rn.RO1-RO*cos(Delt1);
   DG.y:=RO*sin(Delt1);
end;

procedure RN_to_L(bl:_geoid; var P:lpoint);
var
  g:tgauss;
begin
   BL_RNVG(bl,g);
   with RN do begin
   P.x:=round(Mc*g.x-Ms*g.y+X0);
   P.y:=round(Ms*g.x+Mc*g.y+Y0);
   //P.y:=round(Msy*g.x+Mcy*g.y+Y0);
   end;
end;

procedure RNVG_BL(DG:tgauss; var bl:_geoid );
var
  U2,PHI1:extended;
begin
  BL.l:=arctan(dg.y/(rn.Ro1-dg.x))/rn.alf+rn.Lmain_w;
  U2:=sqr(exp(ln(rn.c/sqrt( sqr(rn.Ro1-dg.x)+sqr(dg.y)))/rn.alf));
  PHI1:=arcsin((U2-1)/(U2+1));
  BL.B:=Phi1+rn.C2*sin(2*Phi1)+rn.C4*sin(4*Phi1)+rn.C6*sin(6*Phi1)+
        rn.C8*sin(8*Phi1);
end;

procedure L_to_RN(P:lpoint; var bl:_geoid );
var
  g:tgauss;
begin
   with RN do begin
   g.x:=round(Mcb*p.x-Msb*p.y+gX0);
   g.y:=round(Msb*p.x+Mcb*p.y+gY0);
   //  g.y:=round(Msby*p.x+Mcby*p.y+gY0);
   end;
   RNVG_BL(g,BL)
end;

procedure Koeff_RN_int (t1_old  ,t2_old  : tgauss;
                          t1_new,t2_new: lpoint  );

 type lpoint_r = record x,y: EXTENDED end;

var
  dx_o,dy_o,
  dx_n,dy_n,rr : EXTENDED;
begin
  dx_o := t2_old.x-t1_old.x;
  dy_o := t2_old.y-t1_old.y;
  dx_n := t2_new.x-t1_new.x;
  dy_n := t2_new.y-t1_new.y;
  rr := dx_o*dx_o + dy_o*dy_o;

  rn.Mc := (dx_n*dx_o + dy_n*dy_o)/rr;
  rn.Ms := (dx_o*dy_n - dy_o*dx_n)/rr;
  rr:=sqrt(sqr(rn.Mc)+sqr(rn.Ms));
  rn.Mc :=rn.Mc /rr;
  rn.Ms :=rn.Ms /rr;

  rn.x0 := t1_new.x - rn.Mc*t1_old.x +  rn.Ms*t1_old.y;
  rn.y0 := t1_new.y - rn.Ms*t1_old.x -  rn.Mc*t1_old.y;
end;

procedure Koeff_RN_int_special (t1_old  ,t2_old  : tgauss;
                          t1_new,t2_new: lpoint  );

 type lpoint_r = record x,y: EXTENDED end;

var
  dx_o,dy_o,
  dx_n,dy_n,rr : EXTENDED;
begin
  dx_o := t2_old.x-t1_old.x;
  dy_o := t2_old.y-t1_old.y;
  dx_n := t2_new.x-t1_new.x;
  dy_n := t2_new.y-t1_new.y;
  rr := dx_o*dx_o + dy_o*dy_o;

  rn.Mc := (dx_n*dx_o + dy_n*dy_o)/rr;
  rn.Ms := (dx_o*dy_n - dy_o*dx_n)/rr;

  rn.x0 := t1_new.x - rn.Mc*t1_old.x +  rn.Ms*t1_old.y;
  rn.y0 := t1_new.y - rn.Ms*t1_old.x -  rn.Mc*t1_old.y;
end;

procedure Koeff_int_RNVG (t1_old  ,t2_old  : tgauss;
                          t1_new,t2_new: lpoint  );

 type lpoint_r = record x,y: EXTENDED end;

var
  dx_o,dy_o,
  dx_n,dy_n,rr : EXTENDED;
  alfr,e2,e4,e6,e8:extended;

 begin
   alfr:=298.3;
   e2:=2/ alfr-sqr(1/ alfr);
  e4:=sqr(e2);
  e6:=e2*e4;
  e8:=sqr(e4);
  rn.c2:=e2/2+5/24*e4+e6/12+13/360*e8;
  rn.c4:=7/48*e4+29/240*e6+811/11520*e8;
  rn.c6:=7/120*e6+81/1120*e8;
  rn.c8:=4279/161280*e8;
  dx_o := t2_new.x-t1_new.x;
  dy_o := t2_new.y-t1_new.y;
  dx_n := t2_old.x-t1_old.x;
  dy_n := t2_old.y-t1_old.y;
  rr := dx_o*dx_o + dy_o*dy_o;
  rn.Mcb := (dx_n*dx_o + dy_n*dy_o)/rr;
  rn.Msb := (dx_o*dy_n - dy_o*dx_n)/rr;
  rr:=sqrt(sqr(rn.Mcb)+sqr(rn.Msb));
  rn.Mcb :=rn.Mcb/rr;
  rn.Msb :=rn.Msb/rr;
  rn.GX0 := t1_old.x - rn.Mcb*t1_new.x +  rn.Msb*t1_new.y;
  rn.GY0 := t1_old.y - rn.Msb*t1_new.x -  rn.Mcb*t1_new.y;
end;

procedure Koeff_int_RNVG_Special (t1_old  ,t2_old  : tgauss;
                          t1_new,t2_new: lpoint  );

 type lpoint_r = record x,y: EXTENDED end;

var
  dx_o,dy_o,
  dx_n,dy_n,rr : EXTENDED;
  alfr,e2,e4,e6,e8:extended;

 begin
   alfr:=298.3;
   e2:=2/ alfr-sqr(1/ alfr);
  e4:=sqr(e2);
  e6:=e2*e4;
  e8:=sqr(e4);
  rn.c2:=e2/2+5/24*e4+e6/12+13/360*e8;
  rn.c4:=7/48*e4+29/240*e6+811/11520*e8;
  rn.c6:=7/120*e6+81/1120*e8;
  rn.c8:=4279/161280*e8;
  dx_o := t2_new.x-t1_new.x;
  dy_o := t2_new.y-t1_new.y;
  dx_n := t2_old.x-t1_old.x;
  dy_n := t2_old.y-t1_old.y;
  rr := dx_o*dx_o + dy_o*dy_o;
  rn.Mcb := (dx_n*dx_o + dy_n*dy_o)/rr;
  rn.Msb := (dx_o*dy_n - dy_o*dx_n)/rr;
 { rr:=sqrt(sqr(rn.Mcb)+sqr(rn.Msb));
  rn.Mcb :=rn.Mcb /rr;
  rn.Msb :=rn.Msb /rr;
  }
  rn.GX0 := t1_old.x - rn.Mcb*t1_new.x +  rn.Msb*t1_new.y;
  rn.GY0 := t1_old.y - rn.Msb*t1_new.x -  rn.Mcb*t1_new.y;
end;
procedure Calc_Min_Sqr(ip,op: pGPoly; n: Integer; var ab:ab_rec);
var
  i,loop: Integer; ix,iy,ox,oy,
  A,B,C,D,E,F,G,H,T, t0,tx,ty: double;
  FA_BC, EA_BB, BD_HA, CB_FA: double;

begin

  for loop:=1 to 2 do begin

    A:=0; B:=0; C:=0; D:=0;
    E:=0; F:=0; H:=0; G:=0; T:=0;

    for i:=0 to n-1 do begin

      with ip[i] do begin ix:=x; iy:=y end;
      with op[i] do begin ox:=x; oy:=y end;

      if loop = 2 then ox:=oy;

      A:= A + ix*ix;
      B:= B + ix*iy;
      C:= C + ix*1;
      E:= E + iy*iy;
      F:= F + iy*1;
      G:= G + 1*1;
      D:= D - ix*ox;
      H:= H - iy*ox;
      T:= T - ox
    end;

    FA_BC:=F*A-B*C; EA_BB:=E*A-B*B;
    BD_HA:=B*D-H*A; CB_FA:=C*B-F*A;

    t0:=FA_BC*CB_FA + EA_BB*(-C*C+G*A);

    if (t0 = 0) or (EA_BB = 0) or (A = 0) then
      Break
    else begin
      t0:=((A*E-B*B)*(D*C-T*A) + BD_HA*CB_FA) / t0;
      ty:=(BD_HA - t0*FA_BC) / EA_BB;
      tx:=-(D + C*t0 + B*ty) / A;

      if loop = 1 then
        begin ab.a0:=t0; ab.ax:=tx; ab.ay:=ty end
      else
        begin ab.b0:=t0; ab.bx:=tx; ab.by:=ty end
    end
  end
end;

function Init_RNVG(Nomenkl:string):boolean;
var
   pi_180:extended;
   q:lpoint;
   bs,ls:double;
   i:integer;
{   a,b:lpoint;  }
begin
Result:=false;
Pi_180:=Pi/180;
with rn do begin
map_a.x:=0;
map_a.y:=0;
map_b.x:=2000000;
map_b.y:=840000;
end;
IF Nomenkl='6Б' then begin
   with rn do begin
   B_main_S:=37.25*Pi_180;
   B_main_N:=44*Pi_180;
   Bmin:=36.5*Pi_180;
   Bmax:=46*Pi_180;
   Lmain_w:=35.25*Pi_180;
   {Охват 22.5 }
   Lmain_O:=57.75*Pi_180;
   end;
end else IF Nomenkl='7Б' then begin
   with rn do begin
   B_main_S:=37.25*Pi_180;
   B_main_N:=44*Pi_180;
   Bmin:=36.5*Pi_180;
   Bmax:=46*Pi_180;
   Lmain_w:=57.75*Pi_180;
   {Охват 22.5 }
   Lmain_O:=80.25*Pi_180;
   end;
end else IF Nomenkl='6А' then begin
   with rn do begin
   B_main_S:=44*Pi_180;
   B_main_N:=(50+37.2/60{+20/3600})*Pi_180;
   Bmin:=43*Pi_180;
   Bmax:=51.5*Pi_180;
   Lmain_w:=20.75*Pi_180;
      {Охват 25 }
   Lmain_O:=45.75*Pi_180;
   end
end else IF Nomenkl='7А' then begin
   with rn do begin
   B_main_S:=44*Pi_180;
   B_main_N:=(50+37.2/60{+20/3600})*Pi_180;
   Bmin:=43*Pi_180;
   Bmax:=51.5*Pi_180;
   Lmain_w:=45.75*Pi_180;
      {Охват 25 }
   Lmain_O:=70.75*Pi_180;
map_a.x:=0;
map_a.y:=0;
map_b.x:=1980000;
map_b.y:=830000;
   end
end else IF Nomenkl='8Б' then begin
   with rn do begin
   B_main_S:=44*Pi_180;
   B_main_N:=(50+37.2/60{+20/3600})*Pi_180;
   Bmin:=43*Pi_180;
   Bmax:=51.5*Pi_180;
   Lmain_w:=70.75*Pi_180;
      {Охват 25 }
   Lmain_O:=95.75*Pi_180;
   end
end else IF Nomenkl='12Б' then begin
   with rn do begin
   B_main_S:=44*Pi_180;
   B_main_N:=(50+37.2/60{+20/3600})*Pi_180;
   Bmin:=43*Pi_180;
   Bmax:=51.5*Pi_180;
   Lmain_w:=95.75*Pi_180;
      {Охват 25 }
   Lmain_O:=120.75*Pi_180;
   end
end else if Nomenkl='5Б' then begin
with   RN do begin
   B_main_S:=(50+37.2/60{+20/3600})*Pi_180;
   B_main_N:=(57+14.02/60{+2/3600})*Pi_180;
   Bmin:=49.5*Pi_180;
   Bmax:=58.5*Pi_180;
   Lmain_w:=19.75*Pi_180;
   {Охват 28.25}
   Lmain_O:=48*Pi_180;
   end;
end else if Nomenkl='8А' then begin
with   RN do begin
   B_main_S:=(50+37.2/60{+20/3600})*Pi_180;
   B_main_N:=(57+14.02/60{+2/3600})*Pi_180;
   Bmin:=49.5*Pi_180;
   Bmax:=58.5*Pi_180;
   Lmain_w:=48*Pi_180;
   {Охват 28.25}
   Lmain_O:=76.25*Pi_180;
   end;
end else if Nomenkl='11А' then begin
with   RN do begin
   B_main_S:=(50+37.2/60{+20/3600})*Pi_180;
   B_main_N:=(57+14.02/60{+2/3600})*Pi_180;
   Bmin:=49.5*Pi_180;
   Bmax:=58.5*Pi_180;
   Lmain_w:=76.25*Pi_180;
    {Охват 28.25}
   Lmain_O:=104.5*Pi_180;
   end;
end else if Nomenkl='11Б' then begin
with   RN do begin
   B_main_S:=(50+37.2/60{+20/3600})*Pi_180;
   B_main_N:=(57+14.02/60{+2/3600})*Pi_180;
   Bmin:=49.5*Pi_180;
   Bmax:=58.5*Pi_180;
   Lmain_w:=104.5*Pi_180;
   {Охват 28.25}
   Lmain_O:=132.75*Pi_180;
   end;
end else if Nomenkl='12А' then begin
with   RN do begin
   B_main_S:=(50+37.2/60{+20/3600})*Pi_180;
   B_main_N:=(57+14.02/60{+2/3600})*Pi_180;
   Bmin:=49.5*Pi_180;
   Bmax:=58.5*Pi_180;
   Lmain_w:=132.75*Pi_180;
   {Охват 28.25}
   Lmain_O:=161*Pi_180;
   end;
end else if Nomenkl='5А' then begin
with   RN do begin
   B_main_S:=(57+14.02/60{+2/3600})*Pi_180;
   B_main_N:=(63+41.66/60{+66/3600})*Pi_180;
   Bmin:=56*Pi_180;
   Bmax:=65*Pi_180;
   Lmain_w:=19.75*Pi_180;
   {Охват 33}
   Lmain_O:=52.75*Pi_180;
   end;
end else if Nomenkl='9А' then begin
with   RN do begin
   B_main_S:=(57+14.02/60{+2/3600})*Pi_180;
   B_main_N:=(63+41.66/60{+66/3600})*Pi_180;
   Bmin:=56*Pi_180;
   Bmax:=65*Pi_180;
   Lmain_w:=52.75*Pi_180;
   {Охват 33}
   Lmain_O:=85.75*Pi_180;
   end;
end else if Nomenkl='9Б' then begin
with   RN do begin
   B_main_S:=(57+14.02/60{+2/3600})*Pi_180;
   B_main_N:=(63+41.66/60{+66/3600})*Pi_180;
   Bmin:=56*Pi_180;
   Bmax:=65*Pi_180;
   Lmain_w:=85.75*Pi_180;
   {Охват 33}
   Lmain_O:=118.75*Pi_180;
   end;
end else if Nomenkl='10А' then begin
with   RN do begin
   B_main_S:=(57+14.02/60{+2/3600})*Pi_180;
   B_main_N:=(63+41.66/60)*Pi_180;
   Bmin:=56*Pi_180;
   Bmax:=65*Pi_180;
   Lmain_w:=118.75*Pi_180;
   {Охват 33}
   Lmain_O:=151.75*Pi_180;
   end;
end else if Nomenkl='10Б' then begin
with   RN do begin
   B_main_S:=(57+14.02/60{+2/3600})*Pi_180;
   B_main_N:=(63+41.66/60{+66/3600})*Pi_180;
   Bmin:=56*Pi_180;
   Bmax:=65*Pi_180;
   Lmain_w:=151.75*Pi_180;
   {Охват 33}
   Lmain_O:=184.75*Pi_180;
   end;
end else if Nomenkl='3А' then begin
with   RN do begin
   B_main_S:=(63+41.66/60)*Pi_180;
   B_main_N:=70*Pi_180;
   Bmin:=62*Pi_180;
   Bmax:=71.5*Pi_180;
   Lmain_w:=29*Pi_180;
   {Охват 41}
   Lmain_O:=70*Pi_180;
   end;
end else if Nomenkl='3Б' then begin
with   RN do begin
   B_main_S:=(63+41.66/60)*Pi_180;
   B_main_N:=70*Pi_180;
   Bmin:=62*Pi_180;
   Bmax:=71.5*Pi_180;
   Lmain_w:=70*Pi_180;
   {Охват 41}
   Lmain_O:=111*Pi_180;
   end;
end else if Nomenkl='4А' then begin
with   RN do begin
   B_main_S:=(63+41.66/60)*Pi_180;
   B_main_N:=70*Pi_180;
   Bmin:=62*Pi_180;
   Bmax:=71.5*Pi_180;
   Lmain_w:=111*Pi_180;
   {Охват 41}
   Lmain_O:=152*Pi_180;
   end;
end else if Nomenkl='4Б' then begin
with   RN do begin
   B_main_S:=(63+41.66/60)*Pi_180;

   B_main_N:=70*Pi_180;
   Bmin:=62*Pi_180;
   Bmax:=71.5*Pi_180;
   Lmain_w:=152*Pi_180;
   {Охват 41}
   Lmain_O:=193*Pi_180;
   end;
end else if Nomenkl='2А' then begin
with   RN do begin
   B_main_S:=70*Pi_180;;
   B_main_N:=(76+09.89/60)*Pi_180;
   Bmin:=68*Pi_180;
   Bmax:=78*Pi_180;
   Lmain_w:=49*Pi_180;
   {Охват 53}
   Lmain_O:=102*Pi_180;
   end;
end else if Nomenkl='2АО' then begin
with   RN do begin
   B_main_S:=(76+09.89/60)*Pi_180;
   B_main_N:=84*Pi_180;
   Bmin:=74*Pi_180;
   Bmax:=83.6*Pi_180;
   Lmain_w:=54*Pi_180;
   {Охват 54}
   Lmain_O:=108*Pi_180;
   map_a.x:=0;
   map_a.y:=0;
   map_b.x:=1500000;
   map_b.y:=840000;
   end;
end else if Nomenkl='2Б' then begin
with   RN do begin
   B_main_S:=70*Pi_180;;
   B_main_N:=(76+09.89/60)*Pi_180;
   Bmin:=68*Pi_180;
   Bmax:=78*Pi_180;
   Lmain_w:=102*Pi_180;
   {Охват 53}
   Lmain_O:=155*Pi_180;
   end;
end else exit;
with rn do begin
   Tlfr.n:=4;
   Tlfr.pol[0].x:=rn.map_a.x;
   Tlfr.pol[0].y:=rn.map_b.y;
   Tlfr.pol[1]:=rn.map_a;
   Tlfr.pol[2].x:=rn.map_b.x;
   Tlfr.pol[2].y:=rn.map_a.y;
   Tlfr.pol[3]:=rn.map_b;
   Tlfr.pol[4]:=TLfr.pol[0];
end;
with rn do Init_BL_RNVG(b_main_S,lmain_w,B_main_N);
 {bl.b:=rn.B_main_S;
 bl.l:=rn.Lmain_w;
 BL_RNVG(bl,g1);
 bl.l:=rn.Lmain_O;
 BL_RNVG(bl,g2);
 bl.l:=(rn.Lmain_W+rn.Lmain_O)/2 ;
 BL_RNVG(bl,g3);
 bl.b:=rn.Bmax;
 BL_RNVG(bl,g4);
  }
 {dm_goto_root;
 dm_Get_bound(a,b);
 }
 (*
  rn.MS:={(B.x-a.x)}2000000*(1-0.5*(g2.x-g1.x)/(g2.x-g3.x))/
       ((g2.y-g3.y)*((g2.x-g1.x)/(g2.x-g3.x))+g1.y-g2.y);
  rn.MC:={(B.x-a.x)}2000000*(1-0.5*(g2.y-g1.y)/(g2.y-g3.y))/
       ((g3.x-g2.x)*((g2.y-g1.y)/(g2.y-g3.y))+g2.x-g1.x);
  rn.X0:={a.x}-rn.MC*g1.x+rn.MS*g1.y;
  rn.Y0:={a.y}-rn.MS*g4.x-rn.MC*g4.y;
  *)
   with place do begin
      if dmx_Find_frst_code (0,1) =0 then exit;

{ if dm_Find_frst_code(10000001,1)=0 then exit;
 }
       dm_Get_Bound(point_[1],q);
       if not dm_Get_double(91,0,bs) then exit;
       if not dm_Get_double(92,0,ls) then exit;

           geoid_[1].b:=bs;
           geoid_[1].l:=ls;
      BL_RNVG (geoid_[1],gauss_[1]);
      for i:=2 to 4 do begin
      if dmx_Find_next_code(0,1)=0 then break;

{       if dm_Find_next_code(10000001,1)=0 then exit;
 }
       dm_Get_Bound(point_[i],q);
       if not dm_Get_double(91,0,bs) then exit;
       if not dm_Get_double(92,0,ls) then exit;

           geoid_[i].b:=bs;
           geoid_[i].l:=ls;
      BL_RNVG (geoid_[i],gauss_[i]);
      end;

 for i := 0 to 3 do begin
          ip[i].x:=gauss_[i+1].x;
          ip[i].y:=gauss_[i+1].y;
          op[i].x:=point_[i+1].x;
          op[i].y:=point_[i+1].y;
        end;
 { Calc_Min_Sqr(@ip,@op,4,ab);
  rn.x0:=ab.a0;
  rn.y0:=ab.b0;
  rn.Mc :=ab.ax;
  rn.Ms :=-ab.ay;
  rn.Mcy :=ab.by;
  rn.Msy :=ab.bx;

  rr:=sqrt(sqr(rn.Mc)+sqr(rn.Ms));
  rn.Mc :=rn.Mc /rr;
  rn.Ms :=rn.Ms /rr;
  Calc_Min_Sqr(@op,@ip,4,ab);
  rn.gx0:=ab.a0;
  rn.gy0:=ab.b0;
  rn.Mcb :=ab.ax;
  rn.Msb :=-ab.ay;
  rn.Mcby :=ab.by;
  rn.Msby :=ab.bx;
  rr:=sqrt(sqr(rn.Mcb)+sqr(rn.Msb));
  rn.Mcb :=rn.Mcb /rr;
  rn.Msb :=rn.Msb /rr;
}
 Koeff_rn_int (gauss_[1],gauss_[2],point_[1],point_[2]);
 Koeff_int_RNVG(gauss_[1],gauss_[2],point_[1],point_[2]);

end;

 rn.flspec:=false;
 Result:=true;
 end;
function Init_RNVG_spesial(Node1,Node2:longint; Bm_S,Bm_N,l_w:double):boolean;
var
   q:lpoint;
   bs,ls:single;
{   a,b:lpoint;  }
begin
Result:=false;
rn.flspec:=true;

 with rn do begin
   B_main_S:=Bm_S;
   B_main_N:=Bm_N;
  // Bmin:=Bmn;
  // Bmax:=Bmx;
   Lmain_w:=L_w;
   {Охват 22.5 }
//   Lmain_O:=57.75*Pi_180;
   end;
with rn do Init_BL_RNVG(b_main_S,lmain_w,B_main_N);
   with place do begin
        dm_jump_node(Node1);

{ if dm_Find_frst_code(10000001,1)=0 then exit; }
       dm_Get_Bound(point_[1],q);
       if not dm_Get_Angle(91,0,bs) then exit;
       if not dm_Get_Angle(92,0,ls) then exit;

           geoid_[1].b:=bs;
           geoid_[1].l:=ls;
      BL_RNVG (geoid_[1],gauss_[1]);
        dm_jump_node(Node2);
{  if dm_Find_next_code(10000001,1)=0 then exit; }
       dm_Get_Bound(point_[2],q);
       if not dm_Get_Angle(91,0,bs) then exit;
       if not dm_Get_Angle(92,0,ls) then exit;

           geoid_[2].b:=bs;
           geoid_[2].l:=ls;
      BL_RNVG (geoid_[2],gauss_[2]);
 Koeff_rn_int_special (gauss_[1],gauss_[2],point_[1],point_[2]);
 Koeff_int_RNVG_special(gauss_[1],gauss_[2],point_[1],point_[2]);
 end;
 Result:=true;
 end;
procedure Get_L1_l2_from_B_x(B:extended;var l1,l2:Extended);
var M,U,R,RO,tcos:extended;
begin
M:=sqrt(sqr(rn.Mc)+sqr(rn.Ms));
Calc_U_R(b,U,R);
RO:=rn.c/exp(ln(u)*rn.alf);
tcos:=(rn.Mc*rn.Ro1+rn.X0-rn.map_a.x)/(RO*M);
if tcos>1 then tcos:=1;
if tcos<-1 then tcos:=-1;
l1:=rn.Lmain_w+
        (-arccos(rn.Mc/M)+arccos(tcos))/rn.alf;
tcos:=(rn.Mc*rn.Ro1+rn.X0-rn.map_b.x)/(RO*M);
if tcos>1 then tcos:=1;
if tcos<-1 then tcos:=-1;
l2:=rn.Lmain_w+
        (-arccos(rn.Mc/M)+arccos(tcos))/rn.alf
end;

procedure Get_L1_l2_from_B_x1_x2(B:extended;x1,x2:longint;var l1,l2:Extended);
var M,U,R,RO,tcos:extended;
begin
M:=sqrt(sqr(rn.Mc)+sqr(rn.Ms));
Calc_U_R(b,U,R);
RO:=rn.c/exp(ln(u)*rn.alf);
tcos:=(rn.Mc*rn.Ro1+rn.X0-X1)/(RO*M);
if tcos>1 then tcos:=1;
if tcos<-1 then tcos:=-1;
l1:=rn.Lmain_w+
        (-arccos(rn.Mc/M)+arccos(tcos))/rn.alf;
tcos:=(rn.Mc*rn.Ro1+rn.X0-x2)/(RO*M);
if tcos>1 then tcos:=1;
if tcos<-1 then tcos:=-1;
l2:=rn.Lmain_w+
        (-arccos(rn.Mc/M)+arccos(tcos))/rn.alf
end;

procedure Get_L1_L2_from_B_Up(B:extended; var l1,l2:extended);
var M,U,R,RO,tsin:extended;
begin
  M:=sqrt(sqr(rn.Mc)+sqr(rn.Ms));
  Calc_U_R(b,U,R);
  RO:=rn.c/exp(ln(u)*rn.alf);
tsin:=(rn.Ms*rn.Ro1+rn.Y0)/(RO*M);
if tsin>1 then tsin:=1;
if tsin<-1 then tsin:=-1;
  l1:=rn.Lmain_w+
        (-arccos(rn.Mc/M)-arcsin(tsin))/rn.alf;
tsin:=(rn.Ms*rn.Ro1+rn.Y0)/(RO*M);
if tsin>1 then tsin:=1;
if tsin<-1 then tsin:=-1;
  l2:=rn.Lmain_w+
        (-arccos(rn.Mc/M)+arcsin(tsin)+Pi)/rn.alf
end;

function B_to_Phi(B:extended):extended;
begin
  result:=B-0.003356073*sin(2*B)-0.000004693*sin(4*B);
end;

procedure make_xyz(Phi,Lambda:extended; var src_crd:XYZ);
begin
src_crd.x:=cos(Phi)*cos(Lambda);
src_crd.y:=cos(Phi)*sin(Lambda);
src_crd.z:=sin(Phi);
end;
{procedure XYZ_XYZ1(alfa,betta,Omega:extended; src_crd:XYZ; var dest_crd:XYZ);
begin
dest_crd.x:=cos(betta)*cos(Omega)*src_crd.x+
            cos(betta)*sin(Omega)*src_crd.y+
            sin(betta)*src_crd.z;
dest_crd.y:=(-cos(alfa)*sin(Omega)+sin(alfa)*sin(betta)*cos(Omega))*src_crd.x+
            (cos(alfa)*cos(Omega)+sin(alfa)*sin(betta)*sin(Omega))*src_crd.y
            -sin(alfa)*cos(betta)*src_crd.z;
dest_crd.z:=(-sin(alfa)*sin(Omega)-cos(alfa)*sin(betta)*cos(Omega))*src_crd.x+
            (sin(alfa)*cos(Omega)-cos(alfa)*sin(betta)*sin(Omega))*src_crd.y
            +cos(alfa)*cos(betta)*src_crd.z;
end;
}
procedure XYZ_XYZ1(cosbetta,sinbetta,cosOmega,sinOmega:extended; src_crd:XYZ; var dest_crd:XYZ);
begin
dest_crd.x:=cosbetta*cosOmega*src_crd.x+
            cosbetta*sinOmega*src_crd.y+
            sinbetta*src_crd.z;
dest_crd.y:=-sinOmega*src_crd.x+
            cosOmega*src_crd.y;
dest_crd.z:=-sinbetta*cosOmega*src_crd.x-
             sinbetta*sinOmega*src_crd.y
            +cosbetta*src_crd.z;
end;

procedure XYZ_XYZ2(cosalfa,sinalfa:extended; src_crd:XYZ; var dest_crd:XYZ);
begin
dest_crd.x:=src_crd.x;

dest_crd.y:=cosalfa*src_crd.y-sinalfa*src_crd.z;
dest_crd.z:=sinalfa*src_crd.y+cosalfa*src_crd.z;
end;

procedure BL_Avia_INI(Bc,Lc:double);
var
  Betta:extended;
  alfa:extended;
  ii:integer;
begin
  with Avia do begin
  Betta:=B_to_Phi(Bc);
  cosbetta:=cos(Betta);
  sinbetta:=sin(Betta);
  cosOmega:=cos(Lc);
  sinOmega:=sin(Lc);
  ib:=trunc(Bc/(Pi/30))+1;
  for ii:=1 to 6 do begin
   alfa:=(ii-1)*Pi/6;
   cosalfa[ii]:=cos(alfa);
   sinalfa[ii]:=sin(alfa);
  end;
   end;
end;

procedure BL_Avia_main(B,L:extended; var X,Y:double);
var
  Phi:extended;
  SRC_CRD,crd1,dest_crd:XYZ;
  ii:integer;
begin
  Phi:=B_to_Phi(B);
  make_xyz(Phi,L,src_crd);
  X:=0;
  Y:=0;
   with avia do XYZ_XYZ1(cosbetta,sinbetta,cosOmega,sinOmega,src_crd,crd1);

  for ii:=1 to 6 do with avia do begin
   XYZ_XYZ2(Cosalfa[ii],sinalfa[ii],crd1,dest_crd);
   X:=X+A1_6[avia.ib][ii]*(cosalfa[ii]*arctan(dest_crd.z/dest_crd.x)-
             0.5*sinalfa[ii]*ln((1+dest_crd.y)/(1-dest_crd.y)) );
   Y:=Y+A1_6[avia.ib][ii]*(sinalfa[ii]*arctan(dest_crd.z/dest_crd.x)+
                              0.5*cosalfa[ii]*ln((1+dest_crd.y)/(1-dest_crd.y)) );
  end;
X:=X*A;
Y:=Y*A;

end;
procedure BL_avia (B,L:extended;  var XY:lpoint);
var
   tg:tgauss;
begin
  BL_Avia_main(B,L,tg.x,tg.y);
  Main_int (tg,gauss_point,XY);
end;
procedure Nomenkl_Avia_Main_500(nomenkl:shortstring);
begin
with avia do begin
{Level 1: 4 000 000}
 case nomenkl[2] of
 'A': B0:={12/180}PI/15;
 'B': B0:={36/180}0.2*PI;
 'C': B0:={60/180}PI/3;
 end;
 L0:=(ord(nomenkl[5])-ord('1'))*0.2*Pi+Pi*0.1;
 if L0>Pi then L0:=-2*Pi+L0;
if Nomenkl[1]<>'N' then begin
B0:=-B0;
end;

 {Level 1: 2 000 000}
 case nomenkl[7] of
 '1':  begin
        B0:=B0-{6/180}Pi/30;
        L0:=L0-{9/180}Pi/20;
       end;
 '2':  begin
        B0:=B0-{6/180}Pi/30;
        L0:=L0+{9/180}Pi/20;
       end;
 '3':  begin
        B0:=B0+{6/180}Pi/30;
        L0:=L0-{9/180}Pi/20;
       end;
 '4':  begin
        B0:=B0+{6/180}Pi/30;
        L0:=L0+{9/180}Pi/20;
       end;
  end;
{Level 1: 1 000 000, Level 1: 500 000}

   case nomenkl[9] of
 '1':  begin
        B0:=B0-{3/180}Pi/60;
        L0:=L0-{4.5/180}Pi/40;
       end;
 '2':  begin
        B0:=B0-{3/180}Pi/60;
        L0:=L0+{4.5/180}Pi/40;
       end;
 '3':  begin
        B0:=B0+{3/180}Pi/60;
        L0:=L0-{4.5/180}Pi/40;
       end;
 '4':  begin
        B0:=B0+{3/180}Pi/60;
        L0:=L0+{4.5/180}Pi/40;
       end;
 end;
{Level 1: 500 000}
   case nomenkl[11] of
 '1':  begin
        BMax:=B0;
        LMax:=L0;
        BMin:=B0-{3/180}Pi/60;
        LMin:=L0-{4.5/180}Pi/40;
       end;
 '2':  begin
        BMax:=B0;
        LMin:=L0;
        BMin:=B0-{3/180}Pi/60;
        LMax:=L0+{4.5/180}Pi/40;
       end;
 '3':  begin
        BMin:=B0;
        LMax:=L0;
        BMax:=B0+{3/180}Pi/60;
        LMin:=L0-{4.5/180}Pi/40;
       end;
 '4':  begin
        BMin:=B0;
        LMin:=L0;
        BMax:=B0+{3/180}Pi/60;
        LMax:=L0+{4.5/180}Pi/40;
        end;
 end;
end;
end;


procedure Nomenkl_Avia_Main(nomenkl:shortstring);
begin
with avia do begin
{Level 1: 4 000 000}
 case nomenkl[2] of
 'A': B0:={12/180}PI/15;
 'B': B0:={36/180}0.2*PI;
 'C': B0:={60/180}PI/3;
 end;
 L0:=(ord(nomenkl[5])-ord('1'))*0.2*Pi+Pi*0.1;
 if L0>Pi then L0:=-2*Pi+L0;
if Nomenkl[1]<>'N' then begin
B0:=-B0;
end;
 if (length(nomenkl)<7) then begin
        BMin:=B0-{12/180}Pi/15;
        LMin:=L0-{18/180}Pi*0.1;
        BMax:=B0+{12/180}Pi/15;
        LMax:=L0+{18/180}Pi*0.1;
 exit;
 end;
 {Level 1: 2 000 000}
 case nomenkl[7] of
 '1':  begin
        B0:=B0-{6/180}Pi/30;
        L0:=L0-{9/180}Pi/20;
       end;
 '2':  begin
        B0:=B0-{6/180}Pi/30;
        L0:=L0+{9/180}Pi/20;
       end;
 '3':  begin
        B0:=B0+{6/180}Pi/30;
        L0:=L0-{9/180}Pi/20;
       end;
 '4':  begin
        B0:=B0+{6/180}Pi/30;
        L0:=L0+{9/180}Pi/20;
       end;
  end;
  if (length(nomenkl)<9) then begin
        BMin:=B0-{12/180}Pi/30;
        LMin:=L0-{18/180}Pi*0.05;
        BMax:=B0+{12/180}Pi/30;
        LMax:=L0+{18/180}Pi*0.05;
  end;

  {Level 1: 1 000 000, Level 1: 500 000}

   case nomenkl[9] of
 '1':  begin
        B0:=B0-{3/180}Pi/60;
        L0:=L0-{4.5/180}Pi/40;
       end;
 '2':  begin
        B0:=B0-{3/180}Pi/60;
        L0:=L0+{4.5/180}Pi/40;
       end;
 '3':  begin
        B0:=B0+{3/180}Pi/60;
        L0:=L0-{4.5/180}Pi/40;
       end;
 '4':  begin
        B0:=B0+{3/180}Pi/60;
        L0:=L0+{4.5/180}Pi/40;
       end;
 end;
 if (length(nomenkl)<11) then begin
        BMin:=B0-{3/180}Pi/60;
        LMin:=L0-{4.5/180}Pi*0.025;
        BMax:=B0+{12/180}Pi/60;
        LMax:=L0+{18/180}Pi*0.025;
 exit
 end;

 {Level 1: 500 000}
   case nomenkl[11] of
 '1':  begin
        BMax:=B0;
        LMax:=L0;
        BMin:=B0-{3/180}Pi/60;
        LMin:=L0-{4.5/180}Pi/40;
       end;
 '2':  begin
        BMax:=B0;
        LMin:=L0;
        BMin:=B0-{3/180}Pi/60;
        LMax:=L0+{4.5/180}Pi/40;
       end;
 '3':  begin
        BMin:=B0;
        LMax:=L0;
        BMax:=B0+{3/180}Pi/60;
        LMin:=L0-{4.5/180}Pi/40;
       end;
 '4':  begin
        BMin:=B0;
        LMin:=L0;
        BMax:=B0+{3/180}Pi/60;
        LMax:=L0-{4.5/180}Pi/40;
        end;
 end;
end;
end;

Procedure Avia_BL(tg:tgauss; var bl:tgauss; var n_it:integer; eps :extended);
var
    Corners,C_avia:array[1..5] of tgauss;
   Centr,tgc:tgauss;
   tau,db,dl:extended;
  LC,BC:extended;
   i:integer;
 begin
 tau:=2.02e-7;
  with avia do begin
Corners[1].x:=Bmax;//54/180*Pi;
Corners[1].y:=Lmin;//27/180*Pi;
Corners[2].x:=Bmax;//54/180*Pi;
Corners[2].y:=Lmax;//31.5/180*Pi;
Corners[3].x:=Bmin;//51/180*Pi;
Corners[3].y:=Lmax;//31.5/180*Pi;
Centr.x:=B0;//51/180*Pi;
Centr.y:=(Lmin+Lmax)*0.5;//29.25/180*Pi;
end;
 BL_avia_main(Corners[1].x,corners[1].y,C_avia[1].x,C_avia[1].y);
 BL_avia_main(Corners[2].x,corners[2].y,C_avia[2].x,C_avia[2].y);
 BL_avia_main(Corners[3].x,corners[3].y,C_avia[3].x,C_avia[3].y);
 BC:=Corners[3].x+(tg.x-c_avia[3].x)/(c_avia[1].x-c_avia[3].x)*(Corners[1].x-Corners[3].x);
 LC:=Corners[1].y+(tg.y-c_avia[1].y)/(c_avia[2].y-c_avia[1].y)*(Corners[2].y-Corners[1].y);
i:=0;
repeat
 inc(i);
 BL_avia_main(BC,LC,tgc.x,tgc.y);
  dl:=tau*(tg.y-tgc.y);
 Lc:=Lc+dl;
 //BL_avia_main(BC,LC,tgc.x,tgc.y);

 db:=tau*(tg.x-tgc.x);
 Bc:=Bc+db;
if i>100000 then break;
until max(ABS(db),ABS(dl))<eps;
bl.x:=bc;
bl.y:=lc;
n_it:=i;
end;


End.

