unit BLgeo; interface
uses
  SysUtils, Otypes;
type
  TDatumIM=record R, Alfa,dX,dY,dZ,wx,wy,wz: Double end;
  pDatumIM=^TDatumIM;
procedure XY_to_BL(x,y, lc,b1,b2: double; elp,prj: byte; var b,l: double);
procedure BL_to_XY(b,l, lc,b1,b2: double; elp,prj: byte; var x,y: double);
procedure BL_gkXY(B,L, L0: double; var X,Y: double);
procedure bl2xy(B, L, L0:double; var X,Y: double);
procedure xy2Bl(X,Y: double; Var B, L:double);

function Geoid_Dist(b1,l1, b2,l2: double; var fi: double): double;

procedure BLH_BLH(b,l,H: extended; elp,elp_: Integer; var b_,l_,H_: double);
procedure BLH_BLH_IM(b,l,H: extended; dtm,dtm_: pDatumIM; var b_,l_,H_: double);

procedure BLH_BLH_7(b,l,H: extended; elp,elp_: Integer; var dtm,dtm_: tDatum7; var b_,l_,H_: double);

//procedure BL_BL(b,l: double; elp,elp_: Integer; var b_,l_: double);
procedure m_XY_BL(X,Y, B0: double; var B,L: double);
procedure m_BL_XY(B,L, B0: double; var X,Y: double);
procedure conus_Init(b1,b2,l1: Extended);
procedure conus_BL_XY(b,l: Double; out x,y: Double);
procedure conus_XY_BL(x,y: Double; out b,l: Double);
procedure SimplePolykon_BL_XY(b,l,L0: Double; out x,y: Double);
function  SimplePolykon_XY_BL(X,Y, L0,eps: double; var B,L: double):integer;
function Calc_RN(Bn: double):extended;
procedure Init_Mcross(BN,R: double);
procedure mCross_BL_XY(B,L:double;  var X,Y: double);
procedure mCross_XY_BL(X,Y: double; var B,L:double);
procedure mCross_kvBL_XY(kvB,kvL:double;  var X,Y: double);
procedure mCross_kvBL_BL(kvB,kvL:double;  var B,L: double);

procedure mCross_XY_kvBL(X,Y: double;  var kvB,kvL:double);

procedure Init_SlantingStereograf(bn,b0,L0:double);
procedure SlantingStereograf_BL_XY(B,L:double;  var X,Y: double);
procedure SlantingStereograf_XY_BL(X,Y:double;  var B,L: double);
procedure Init_PolarSlantingStereograf(bn,b0,L0,R:double);
procedure PolarSlantingStereograf_BL_XY(B,L:double;  var X,Y: double);
procedure PolarSlantingStereograf_XY_BL(X,Y:double;  var B,L: double);

procedure Init_NormStereograf(BN,L0,R: double;mirr:boolean);
procedure NormStereograf_BL_XY(B,L:double;  var X,Y: double);
procedure NormStereograf_XY_BL(X,Y: double; var B,L:double);

procedure Init_CrossStereograf(L0:double);
procedure CrossStereograf_BL_XY(B,L:double;  var X,Y: double);
procedure CrossStereograf_XY_BL(X,Y:double;  var B,L: double);

procedure Init_SlantingGnomon(bn,b0,L0:double);
procedure SlantingGnomon_BL_XY(B,L:double;  var X,Y: double);
procedure SlantingGnomon_XY_BL(X,Y:double;  var B,L: double);
procedure Init_PolarSlantingGnomon(bn,b0,L0,R:double);
procedure PolarSlantingGnomon_BL_XY(B,L:double;  var X,Y: double);
procedure PolarSlantingGnomon_XY_BL(X,Y:double;  var B,L: double);

procedure Init_NormGnomon(Bn,L0,R: double;mirr:boolean);
procedure NormGnomon_BL_XY(B,L:double;  var X,Y: double);
procedure NormGnomon_XY_BL(X,Y: double; var B,L:double);

procedure Init_CrossGnomon(L0:double);
procedure CrossGnomon_BL_XY(B,L:double;  var X,Y: double);
procedure CrossGnomon_XY_BL(X,Y:double;  var B,L: double);

procedure Init_SlantingPostel(bn,b0,L0:double);
procedure SlantingPostel_BL_XY(B,L:double;  var X,Y: double);
procedure SlantingPostel_XY_BL(X,Y:double;  var B,L: double);

procedure Init_PolarSlantingPostel(bn,b0,L0,R:double);
procedure PolarSlantingPostel_BL_XY(B,L:double;  var X,Y: double);
procedure PolarSlantingPostel_XY_BL(X,Y:double;  var B,L: double);

procedure Init_NormPostel(bn,L0,R:double;mirr:boolean);
procedure NormPostel_BL_XY(B,L:double;  var X,Y: double);
procedure NormPostel_XY_BL(X,Y:double;  var B,L: double);

procedure Init_CrossPostel(L0:double);
procedure CrossPostel_BL_XY(B,L:double;  var X,Y: double);
procedure CrossPostel_XY_BL(X,Y:double;  var B,L: double);

procedure Init_SlantingLambert(b0,L0:double);
procedure SlantingLambert_BL_XY(B,L:double;  var X,Y: double);
procedure SlantingLambert_XY_BL(X,Y:double;  var B,L: double);

procedure Init_SlantingPerspCylindr(bn,b0,L0,z0,d:double);

procedure SlantingPerspCylindr_BL_XY(B,L:double;  var X,Y: double);

procedure SlantingPerspCylindr_XY_BL(X,Y:double;  var B,L: double);


procedure rNM_U(phi:double; var N,M,U:extended);
function c_R0(Fi0,E: double): double;

type
  tEllipsoid = record A,Alfa, B,F,Es,e: extended end;
var
   c_: tEllipsoid;
   MercCross: record
   u0,k0,R0:extended;
   end;
  SlantingStereograf: record
   u0,L0,Rn,K0,alf,sinu0,cosu0:extended;
  end;
   NormStereograf: record
     u0,k0,R0,L0:extended;
     mirr:boolean;
   end;
  CrossStereograf: record
   L0,Rn,alf:extended;
  end;

  SlantingGnomon: record
   u0,L0,Rn,K0,alf,sinu0,cosu0:extended;
  end;
  CrossGnomon: record
   L0,Rn,alf:extended;
  end;

   NormGnomon: record
     u0,k0,R0,L0:extended;
      mirr:boolean;
   end;
   SlantingPostel: record
   u0,L0,Rn,K0,alf,sinu0,cosu0:extended;
  end;
  NormPostel: record
   u0,L0,R0,K0:extended;
    mirr:boolean;
  end;
  CrossPostel: record
   L0,Rn,alf:extended;
  end;

  SlantingLambert: record
   L0,RnSQR,Rn,sinu0,cosu0:extended;
  end;

const
  ZR  = 6367558.497;
  E2  = 6.693421623E-3;
  rad = 57.29577951308;


const
  Ellipsoids_Max = 11;

  Ellipsoids: array[0..Ellipsoids_Max-1] of tEllipsoid =

    ((A:6378245;   Alfa:298.3),
     (A:6378245;   Alfa:298.3),          // Красовского-1942 298.2997381
     (A:6378388;   Alfa:297.0),          // WGS-1976

     (A:6378388;   Alfa:297.0),          // Хейфорда-1909
     (A:6378249;   Alfa:293.5),          // Кларка-1880
     (A:6378206;   Alfa:295.0),          // Кларка-1866
     (A:6377276;   Alfa:300.0),          // Эверест-1857
     (A:6377397;   Alfa:299.2),          // Бессель-1841
     (A:6377491;   Alfa:299.3),          // Эри-1830
     (A:6378137;   Alfa:298.257223563),   // WGS-1984
    (A:6378136.0; Alfa:298.257839303)   // ПЗ-90
);

implementation

uses
  Convert,Math,dialogs,minfun;

var
  pi2,pi_4,Pi_2: Extended;
procedure Rad_grad (rad: EXTENDED; var grad,min: integer; var sec: EXTENDED);

   begin
      rad  := rad * 180.0 / pi ;
      grad := trunc (rad) ;
      min  := abs(trunc( ( rad -grad ) * 60 )) ;
      sec  := ( abs(rad) - abs(grad) - min / 60 ) * 3600 ;
   end; {Rad_grad}

procedure Ellipsoids_Init;
var
  i: Integer;
begin
  for i:=0 to Ellipsoids_Max-1 do
  with Ellipsoids[i] do begin
    F:=1/Alfa; B:=A*(1-F);
    Es:=2*F - F*F;
   e:=(Sqrt(Sqr(A)-Sqr(B)))/A;
  end;
  pi2:=2*Pi; pi_4:=0.25*Pi;
  Pi_2:=0.5*Pi;
   c_:=Ellipsoids[1];
end;

{
function c_E: double;
begin
  Result:=(Sqrt(Sqr(c_.A)-Sqr(c_.B)))/c_.A
end;
}

function c_R0(Fi0,E: double): double;
var
  sin,cos: Extended;
begin
  SinCos(Fi0, sin,cos);
  Result:=c_.A* cos / Sqrt(1-Sqr(E)*Sqr(sin))
end;

procedure g_XY_BL(X,Y, L0: double; var B,L: double);
var
  N,N1,B2,B4,B6,F,Z,P,R,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,
  K2,K4,K6,U,V,sp,chp,SinF,TanL: double;
begin
  N:=c_.F/(2-c_.F);
  N1:=Sqr(N); R:=c_.A*(1+N1/4+N1*N1/64)/(1+N);
  B2:=N/2-N1*(2/3)+N*N1*(37/96); B4:=N1/48+N*N1/15;
  B6:=N*N1*17/480; K2:=2*(N-N1/3-N*N1);
  K4:=N1*7/3-N1*N*8/5; K6:=N1*N*56/15;
  U:=X/R; V:=Y/R; a11:=Sin(2*U); b11:=Cos(2*U);
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
  L:=L+L0;
end;

procedure g_BL_XY(B,L, L0: double; var X,Y: double);
var
  N,N1,RAS,A2,A4,A6,F,Z,P,R,ALF,TZ,TZ2,TH,T2,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,
  K2,K4,K6,LL,LLL: double;
begin
  N:=c_.F/(2-c_.F);

  N1:=Sqr(N); R:=c_.A*(1+N1/4+N1*N1/64)/(1+N);
  A2:=N/2-N1*(2/3)+N*N1*(5/16);
  A4:=N1*13/48-N*N1*3/5;
  A6:=N*N1*61/240;
  K2:=2*(N-N1/3-N*N1*2/3);
  K4:=N1*5/3-N1*N*16/15;
  K6:=N1*N*26/15;

  LLL:=ABS(L); IF LLL >= Pi THEN
  begin LLL:=pi2-LLL; L:=-LLL END;
  IF L < 0 THEN LL:=L+pi2 ELSE LL:=L;

  IF Abs(L0) >= Pi THEN L0:=L0-pi2;
  IF L0 < 0 THEN L0:=L0+pi2; RAS:=LL-L0;

  IF B < 0 THEN BEGIN B:=Abs(B);
    F:=K2*SIN(2*B)+K4*SIN(4*B)-K6*SIN(6*B)-B
  END
  ELSE F:=B-K2*SIN(2*B)+K4*SIN(4*B)-K6*SIN(6*B);

  TZ:=(Sin(F)/Cos(F))/Cos(RAS); TZ2:=Sqr(TZ);
  Z:=ArcTan(TZ); TH:=COS(F)*SIN(RAS);
  T2:=Sqr(TH); P:=Ln((1+TH)/(1-TH))/2;
  a11:=2*TZ/(1+TZ2); b11:=(1-TZ2)/(1+TZ2);
  c11:=2*TH/(1-T2); d11:=(1+T2)/(1-T2);
  a21:=2*a11*b11; c21:=2*c11*d11;
  b21:=1-2*Sqr(a11); d21:=1+2*Sqr(c11);
  a31:=a11*b21+a21*b11; c31:=c11*d21+c21*d11;
  b31:=b11*b21-a11*a21; d31:=d11*d21+c11*c21;

  X:=R*(Z+A2*a11*d11+A4*a21*d21+A6*a31*d31);
  Y:=R*(P+A2*b11*c11+A4*b21*c21+A6*b31*c31)
end;

procedure bl2xy(B, L, L0:double; var X,Y: double);
	var dl,l2,sinB, sinB2, sinB4, sinB6:Extended;
      zone:integer;
begin

			sinB:= sin(b);
			sinB2:= SQR(sinB);
			sinB4:= sinB2 * sinB2;
			sinB6:= sinB4 * sinB2;
      dl:=L-L0;
			l2:= dl * dl;
      if L0>0 then
        zone:=trunc(30*L0/Pi)+1
      else
        zone:=trunc(30*l0/Pi);

			 x:= 6367558.4968 * b
				- sin(2 * b) * (16002.89 + 66.9607 * sinB2 + 0.3515 * sinB4
				- l2 * (1594561.25 + 5336.535 * sinB2 + 26.79  * sinB4 + 0.149  * sinB6
				+ l2 * (672483.4   - 811219.9 * sinB2 + 5420   * sinB4 - 10.6   * sinB6
				+ l2 * (278194     - 830174   * sinB2 + 572434 * sinB4 - 16010  * sinB6
				+ l2 * (109500     - 574700   * sinB2 + 863700 * sinB4 - 398600 * sinB6 )))));

			y:= (5 + 10 * zone) * 100000.0
				+ dl * cos(b) * (6378245 + 21346.1415 * sinB2 + 107.159 * sinB4 + 0.5977 * sinB6
				+ l2 * (1070204.16 - 2136826.66 * sinB2 + 17.98   * sinB4 - 11.99  * sinB6
				+ l2 * (270806     - 1523417    * sinB2 + 1327645 * sinB4 - 21701  * sinB6
				+ l2 * (79690      - 866190     * sinB2 + 1730360 * sinB4 - 945460 * sinB6 ))));

end;

procedure xy2Bl(X,Y: double; Var B, L:double);
var
  zone:integer;
  Bi, Bo, sinBo2, sinBo4, sinBo6, Zo, Zo2, Ba, Bb, Bc, dB, La,Lb,Lc,Ld, dL:Extended;
begin
    Zone := trunc(Y * 1.e-6);
    Bi := X / 6367558.4968;
    Bo:= Bi + Sin(Bi * 2) * (0.00252588685 - 0.0000149186 * SQR(Sin(Bi)) + 0.00000011904 * SQR(SQR(Sin(Bi))) );
    Zo := (Y - (10 * Zone + 5) * 1.e5) / (6378245 * Cos(Bo));
    Zo2:=SQR(Zo);
    sinBo2:=SQR(Sin(Bo));
    sinBo4:=SQR(sinBo2);
    sinBo6:=sinBo2*SinBo4;
    Ba := Zo2 * (0.01672 - 0.0063 * sinBo2 + 0.01188 * sinBo4 - 0.00328 * sinBo6);
    Bb := Zo2 * (0.042858 - 0.025318 * sinBo2 + 0.014346 * sinBo4 - 0.001264 * sinBo6 - Ba);
    Bc := Zo2 * (0.10500614 - 0.04559916 * sinBo2 + 0.00228901 * SinBo4 - 0.00002987 * sinBo6 - Bb);
    dB := Zo2  * Sin(Bo * 2) * (0.251684631 - 0.003369263 * SinBo2 + 0.000011276 * SinBo4 - Bc);
    B := (Bo - dB);
    La := Zo2 * (0.0038 + 0.0524 * SinBo2 + 0.0482 * SinBo4 + 0.0032 * SinBo6);
    Lb := Zo2 * (0.01225 + 0.09477 * SinBo2 + 0.03282 * SinBo4 - 0.00034 * SinBo6 - La);
    Lc := Zo2 * (0.0420025 + 0.1487407 * SinBo2 + 0.005942 * SinBo4 - 0.000015 * SinBo6 - Lb);
    Ld := Zo2 * (0.16778975 + 0.16273586 * SinBo2 - 0.0005249 * SinBo4 - 0.00000846 * SinBo6 - Lc);
    dL := Zo * (1 - 0.0033467108 * SinBo2 - 0.0000056002 * SinBo4 - 0.0000000187 * SinBo6 - Ld);
    L  := (6 * (zone - 0.5) / 57.29577951 + dL);
END;

procedure BL_gkXY(B,L, L0: double; var X,Y: double);
var
 N, M,e2, sinB2, t, eta2, RAS, dlCosB, temp:Extended;
begin

  e2:=sqr(c_.e);
  E2 := 6.69E-3;
//E2  = 6.693421623E-3;
  sinB2:=sqr(sin(B));
  N := c_.A/sqrt(1-e2*sinB2);

  t := sqr(tan(B));
  eta2 := e2/(1-e2)*sqr(cos(B));
  temp:=c_.A*(1	- e2/4		- 3*SQR(e2)/64	- 5*SQR(e2)*e2/256);
  M := c_.A*((1	- e2/4		- 3*SQR(e2)/64	- 5*SQR(e2)*e2/256)*B
			        	- (3*e2/8	+ 3*SQR(e2)/32	+ 45*SQR(e2)*e2/1024)*sin(2*B)
									+ (15*SQR(e2)/256 + 45*SQR(e2)*e2/1024)*sin(4*B)
									- (35*SQR(e2)*e2/3072)*sin(6*B));
  temp:= (3*e2/8	+ 3*SQR(e2)/32	{+ 45*SQR(e2)*e2/1024})*c_.A;
  RAS:=L-L0;
  dlCosB:=cos(B)*RAS;
   //   SK42BTOX = 6367558.4968 * Bo - Sin(Bo * 2) * (16002.89 + 66.9607 * Sin(Bo) ^ 2 + 0.3515 * Sin(Bo) ^ 4 - Xd)
   //    SK42LTOY = (5 + 10 * No) * 10 ^ 5 + Lo * Cos(Bo) * (6378245 + 21346.1415 * Sin(Bo) ^ 2 + 107.159 * Sin(Bo) ^ 4 + 0.5977 * Sin(Bo) ^ 6 + Yc)

  X:= M+ N*sin(B)*RAS* (dlCosB*0.5+SQR(dlCosB)*dlCosB/24*(5-t+9*eta2+4*SQR(eta2))+
                                  SQR(SQR(dlCosB))*dlCosB/720*(61-58*t+sqr(t)+270*eta2-330*t*eta2)+
                                  SQR(SQR(dlCosB))*SQR(dlCosB)*dlCosB/40320 *(1.385 - 3.111*t + 543*sqr(t) - sqr(t)*t)
                                  );
  Y:= N*dlCosB* (1+ SQR(dlCosB)/6*(1-t+eta2) + SQR(dlCosB)*SQR(dlCosB)/120*(5-18*t+sqr(t)+14*eta2-58*t*eta2)+
                     SQR(SQR(dlCosB))*SQR(dlCosB)/5040*(61-479*t+179*SQR(t)-sqr(t)*t)
                     )+ 500000.0;
end;

procedure m_XY_BL(X,Y, B0: double; var B,L: double);
var
  i: integer; grad,old: double;
   fi, r0, k,k1, x2,dX, u,w: double;
BEGIN
  r0:=c_R0(B0,c_.E);

  fi:=0; grad:=Pi/180; i:=0; dX:=-x;

  for i:=1 to 2048 do begin
    w:=c_.E*Sin(fi);
    w:=ArcTan(w/Sqrt(1-Sqr(w)));
    k:=Pi_4 + 0.5*fi;
    k1:=Pi_4 + 0.5*w;

    u:=tan(k) / Power(Tan(k1),c_.E);

    x2:=r0*Ln(u); Old:=dX; dX:=x2-x;

    if Abs(dX) > 111000 then begin

      if (Old < 0) <> (dX < 0) then
      grad:=grad/2;

      if dX > 0 then fi:=fi-grad
      else fi:=fi+grad
    end else
    if Abs(dX) > 0.1 then
      fi:=fi-(dX/30/36000*grad)
    else
      Break;
  end;

  B:=fi; L:=y/r0
end;

procedure m_BL_XY(B,L, B0: double; var X,Y: double);
var
   r0, k,k1, u, w: double;
BEGIN
  r0:=c_R0(B0,c_.E);

  w:=c_.E*Sin(B);
  w:=ArcTan(w/Sqrt(1-Sqr(w)));

  k:=PI_4+0.5*B;
  k1:=PI_4+0.5*w;
  u:=tan(k) / Power(tan(k1),c_.E);
  X:=r0*Ln(u); Y:=r0*L
end;

procedure rNM_U(phi:double; var N,M,U:extended);
var
  sinphi,w,k,Ubig,tt,tt_2:extended;
begin
    sinphi:=Sin(phi);
    tt:=1.0 - c_.Es * SQR(sinPhi);
    tt_2:=sqrt(tt);
    N:=  c_.a / tt_2;
    M:=  c_.a *(1-c_.Es)/ (tt*tt_2);

  w:=c_.e*Sinphi;
  k:=pi_4+phi*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  u:=Pi_2-2.0*ARCTAN(MercCross.K0/Ubig);
 // u:=2.0*ARCTAN(Ubig/MercCross.K0)-Pi*0.5;
end;
Function m_1(X:double):double;
var
 a1,minm_1,N,m,u:extended;
 i,j,ii:integer;
begin
  minm_1:=0;
  ii:=0;
  for i:=75 to 89 do
  for j:=0 to 99 do begin
   inc(ii);
  rNM_U((i+j*0.01)/180*Pi,N,M,u);
 //  a1:=abs(X*cos(u)/(N*cos((i+j*0.01)/180*Pi))-1);
   a1:=abs((X/N)*(cos(u)/cos((i+j*0.01)/180*Pi))-1);

  //minm_1:=minm_1+a1;
  minm_1:=math.max(minm_1,a1);
  end;
{  rNM_U(Pi*0.5,N,M,u);

  a1:=abs(X/N-1);
  minm_1:=math.max(minm_1,a1);
}
  {rN_U(80/180*Pi,N,u);
  a1:=abs(X*cos(u)/(N*cos(80/180*Pi))-1);
  minm_1:=math.min(minm_1,a1);
  rN_U(85/180*Pi,N,u);
  a1:=abs(X*cos(u)/(N*cos(85/180*Pi))-1);
  minm_1:=math.min(minm_1,a1);
  rN_U(89/180*Pi,N,u);
  a1:=abs(X*cos(u)/(N*cos(89/180*Pi))-1);
  minm_1:=math.min(minm_1,a1); }
//m_1:=minm_1/ii;
m_1:=minm_1;

end;

function Calc_RN(Bn: double):extended;
var
  SinBn,U,bb,w,N:extended;
begin
  If BN=0 then begin
   ShowMessage('Для нулевых значение расчета не требуется');
   exit
  end;
  SinBn:=Sin(Bn);
  MercCross.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
  w:=c_.e*SinBn;
  bb:=PI_4+Bn*0.5;
  U:=tan(bb) * Power((1-w)/(1+w), 0.5*c_.e);
  bb:=PI_4+MercCross.u0*0.5;
  MercCross.k0:=cotan(bb) *U;
  Result:=Fmin(6390000,6500000,@m_1,0.00001); //6397000  , 6399000
end;
procedure Init_Mcross(Bn,R: double);
var
  SinBn,U,bb,w,N:extended;
begin
  SinBn:=Sin(Bn);
  MercCross.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
  w:=c_.e*SinBn;
  bb:=PI_4+Bn*0.5;
  U:=tan(bb) * Power((1-w)/(1+w), 0.5*c_.e);
  bb:=PI_4+MercCross.u0*0.5;
  MercCross.k0:=cotan(bb) *U;
  N:=  c_.a /SQRT(1.0 - c_.Es * SQR(sinBn));
  MercCross.r0:=R;//*cos(MercCross.u0);//RN*cos(Bn)/cos(MercCross.u0);
end;

procedure mCross_kvBL_XY(kvB,kvL:double;  var X,Y: double);
BEGIN
  Y:=MercCross.R0*kvL;
  X:=MercCross.R0*ln(Tan(pi_4+0.5*kvB))
end;
procedure mCross_kvBL_BL(kvB,kvL:double;  var B,L: double);
var
  i:integer;
  k, u,U2,db,w,usm,usm2,Phi,tau: extended;
BEGIN
  usm:=arcSin(cos(kvb)*cos(kvl));
  if (abs(kvb)<1.e-12) and (abs(kvL)<1.e-12) then
    L:=0
  else {if (abs(kvb)<1.e-12) then }
    L:=arctan2(sin(kvl),-TAN(kvb));
{  else
    L:=arctan(-COTAN(kvb)*sin(kvl));
}  Phi:=Usm;
  tau:=1;
 i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
//  if abs(k-Pi*0.5)<1.e-12 then begin
    U2:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
  usm2:=2.0*ARCTAN2(1/MercCross.K0, U2)-Pi_2;
{  end else begin
   U2:=tan(k) * power((1-w)/(1+w),0.5*c_.e);
   usm2:=2.0*ARCTAN(U2/MercCross.K0)-Pi_2;
 end;
}
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;


procedure mCross_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL: extended;
BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
 // if abs(k-Pi_2)<1.e-12 then begin
   U:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
   usm:=2.0*ARCTAN2(1/MercCross.K0, U)-Pi*0.5;
 {
  end else begin
  U:=tan(k) * power((1-w))/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(U/MercCross.K0)-Pi*0.5;
  end;
  }
  kvB:=arcSIN(-cos(usm)*cos(L));  //z
//  kvB:=arccos(cos(usm)*cos(L));  //z
  kvL:=ARCTAN(CoTan(Usm)*sin(L)); //a
  Y:=MercCross.R0*kvL;
  X:=MercCross.R0*ln(Tan(pi_4+0.5*kvB))
end;

procedure mCross_XY_kvBL(X,Y: double;  var kvB,kvL:double);
begin
 kvB:=2.0*ARCTAN(EXP(X/MercCross.R0))-Pi_2;
 kvL:=Y/MercCross.R0;
end;

procedure mCross_XY_BL(X,Y: double; var B,L:double);
var
  i:integer;
  k, u,U2,db,w,usm,usm2,kvB,kvL,Phi,tau: extended;
BEGIN
  kvB:=2.0*ARCTAN(EXP(X/MercCross.R0))-Pi_2;
  kvL:=Y/MercCross.R0;
  usm:=arcSin(cos(kvb)*cos(kvl));
  if (abs(kvb)<1.e-12) and (abs(kvL)<1.e-12) then
    L:=0
  else //if (abs(kvb)<1.e-12) then
    L:=arctan2(sin(kvl),-TAN(kvb));
 { else
    L:=arctan(-COTAN(kvb)*sin(kvl));
 } Phi:=Usm;
  tau:=1;
 i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
//  if abs(k-Pi*0.5)<1.e-12 then begin
    U2:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
  usm2:=2.0*ARCTAN2(1/MercCross.K0, U2)-Pi_2;
{  end else begin
   U2:=tan(k) * power((1-w))/(1+w),0.5*c_.e);
   usm2:=2.0*ARCTAN(U2/MercCross.K0)-Pi_2;
 end;
}
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

procedure Init_SlantingStereograf(bn,b0,L0:double);
var
  sinphi,w,k,Ubig,tt,tt_2,n,m,sfern:extended;
begin
  sinphi:=Sin(bn);
  tt:=1.0 - c_.Es * SQR(sinPhi);
  tt_2:=sqrt(tt);
  N:=c_.a / tt_2;
  M:=c_.a *(1-c_.Es)/ (tt*tt_2);

  if bn=0 then begin
  //SlantingStereograf.Rn:=N;
  //SlantingStereograf.alf:=1;
   {SlantingStereograf.Rn:=c_.a;
   w:=sqr(c_.B/c_.A);
   SlantingStereograf.alf:=1-(1-w)/(1+w)*sqr(cos(b0))+ 2*(SQR(c_.A)-SQR(c_.b))/SQR(C_.b)/(1+w)*SQR(SQR(cos(b0)));
  }
  SlantingStereograf.Rn:=c_.a*SQRT(1-c_.Es);
  SlantingStereograf.alf:=1/SQRT(1-c_.Es);//N/SlantingStereograf.Rn

  sfern:=0;
  end
    else  Begin
  SlantingStereograf.Rn:=SQRT(M*N);

  sfern:=arcTan(SlantingStereograf.Rn/N*Tan(bn));
  if sfern=0 then
    SlantingStereograf.alf:=SQRT(1/(1-c_.Es))//N/SlantingStereograf.Rn
  else
    SlantingStereograf.alf:=sinphi/sin(sfern);
  end;
   w:=c_.e*Sin(Bn);
  k:=pi_4+Bn*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);

  // sfern:=2*arctan(sin(B0)/SlantingStereograf.alf);
  SlantingStereograf.K0:=tan(Pi_4+sfern*0.5)/Power(Ubig,SlantingStereograf.alf);

  w:=c_.e*Sin(B0);
  k:=pi_4+B0*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  SlantingStereograf.u0:=2.0*ARCTAN(SlantingStereograf.K0*Power(Ubig,SlantingStereograf.alf))-Pi_2;
  SlantingStereograf.L0:=SlantingStereograf.alf*L0;
  sincos(SlantingStereograf.u0,SlantingStereograf.sinu0,SlantingStereograf.cosu0);
end;

procedure SlantingStereograf_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;

BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(SlantingStereograf.K0*Power(U,SlantingStereograf.alf))-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L*SlantingStereograf.alf-SlantingStereograf.L0,sindw,cosdw);
  Znam:=SlantingStereograf.Rn*2/(1+SlantingStereograf.sinu0*sinu+SlantingStereograf.cosu0*cosu*cosdw);
  X:= (SlantingStereograf.cosu0*sinu-SlantingStereograf.sinu0*cosu*cosdw)*znam;
  Y:= cosu*sindW*znam;

end;
procedure SlantingStereograf_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 tanzet_5:=ro/(2*SlantingStereograf.Rn);
 sinZet:=2*tanzet_5/(1+sqr(tanzet_5));
 cosZet:=(1-sqr(tanzet_5))/(1+sqr(tanzet_5));
 sinPhi:=cosZet*SlantingStereograf.sinu0+sinZet*SlantingStereograf.cosu0*CosA;
 tandw:=sinZet*sinA/(cosZet*SlantingStereograf.cosu0-sinZet*SlantingStereograf.sinu0*CosA);
 L:=(SlantingStereograf.L0+arctan(tandw))/SlantingStereograf.alf;
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(SlantingStereograf.K0*Power(U2,SlantingStereograf.alf))-Pi*0.5;

 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

procedure Init_PolarSlantingStereograf(bn,b0,L0,R:double);
var
  sinBn,w,bb,Ubig,tt,tt_2,n,m,sfern:extended;
begin
 SinBn:=Sin(Bn);
 SlantingStereograf.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
 w:=c_.e*SinBn;
 bb:=PI_4+Bn*0.5;
 UBig:=tan(bb) * Power((1-w)/(1+w), 0.5*c_.e);
 bb:=PI_4+SlantingStereograf.u0*0.5;
 SlantingStereograf.k0:=cotan(bb) *UBig;
 N:=  c_.a /SQRT(1.0 - c_.Es * SQR(sinBn));
 SlantingStereograf.Rn:=R;//N*cos(Bn)/cos(SlantingStereograf.u0);
 SlantingStereograf.L0:=L0;
  w:=c_.e*Sin(B0);
 bb:=pi_4+B0*0.5;
 Ubig:=cotan(bb) * Power((1+w)/(1-w),0.5*c_.e);
 SlantingStereograf.u0:=2.0*ARCTAN2(1/SlantingStereograf.K0, Ubig)-Pi_2;
sincos(SlantingStereograf.u0,SlantingStereograf.sinu0,SlantingStereograf.cosu0);
end;

procedure PolarSlantingStereograf_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;

BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
  usm:=2.0*ARCTAN2(1/SlantingStereograf.K0, U)-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L-SlantingStereograf.L0,sindw,cosdw);
  Znam:=SlantingStereograf.Rn*2/(1+SlantingStereograf.sinu0*sinu+SlantingStereograf.cosu0*cosu*cosdw);
  X:= (SlantingStereograf.cosu0*sinu-SlantingStereograf.sinu0*cosu*cosdw)*znam;
  Y:= cosu*sindW*znam;
end;
procedure PolarSlantingStereograf_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 tanzet_5:=ro/(2*SlantingStereograf.Rn);
 sinZet:=2*tanzet_5/(1+sqr(tanzet_5));
 cosZet:=(1-sqr(tanzet_5))/(1+sqr(tanzet_5));
 sinPhi:=cosZet*SlantingStereograf.sinu0+sinZet*SlantingStereograf.cosu0*CosA;
 tandw:=sinZet*sinA/(cosZet*SlantingStereograf.cosu0-sinZet*SlantingStereograf.sinu0*CosA);
 L:=SlantingStereograf.L0+arctan(tandw);
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
 usm2:=2.0*ARCTAN2(1/SlantingStereograf.K0, U2)-Pi*0.5;
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

procedure Init_CrossStereograf(L0:double);
var
  sinphi,w,k,Ubig,tt,tt_2,n,m,sfern:extended;
begin
  N:=c_.a;
  M:=c_.a *(1-c_.Es);
  CrossStereograf.Rn:=SQRT(M*N);
  CrossStereograf.alf:=1/SQRT(1-c_.Es);
  CrossStereograf.L0:=CrossStereograf.alf*L0;
end;

procedure CrossStereograf_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;
  sign:integer;

BEGIN
  if B>=0  then sign:=1 else begin sign:=-1; B:=abs(B) end;
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(Power(U,CrossStereograf.alf))-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L*CrossStereograf.alf-CrossStereograf.L0,sindw,cosdw);
  Znam:=CrossStereograf.Rn*2/(1+cosu*cosdw);
  X:=Sign*sinu*znam;
  Y:=cosu*sindW*znam;
end;
procedure CrossStereograf_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;
  sign,i:Integer;
begin
 if X>=0  then sign:=1 else begin sign:=-1; X:=abs(X) end;
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 tanzet_5:=ro/(2*CrossStereograf.Rn);
 sinZet:=2*tanzet_5/(1+sqr(tanzet_5));
 cosZet:=(1-sqr(tanzet_5))/(1+sqr(tanzet_5));
 sinPhi:=sinZet*CosA;
 tandw:=sinZet*sinA/cosZet;
 L:=(CrossStereograf.L0+arctan(tandw))/CrossStereograf.alf;
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(Power(U2,CrossStereograf.alf))-Pi*0.5;

 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Sign*Phi;
end;

// Косая гномоническая
procedure Init_SlantingGnomon(bn,b0,L0:double);
var
  sinphi,w,k,Ubig,tt,tt_2,n,m,sfern:extended;
begin
  sinphi:=Sin(bn);
  tt:=1.0 - c_.Es * SQR(sinPhi);
  tt_2:=sqrt(tt);
  N:=c_.a / tt_2;
  M:=c_.a *(1-c_.Es)/ (tt*tt_2);
   if bn=0 then begin
  SlantingGnomon.Rn:=c_.a*SQRT(1-c_.Es);
  SlantingGnomon.alf:=1/SQRT(1-c_.Es);//N/SlantingStereograf.Rn
  sfern:=0;
  end  else begin
  SlantingGnomon.Rn:=SQRT(M*N);
  sfern:=arcTan(SlantingGnomon.Rn/N*Tan(bn));
  SlantingGnomon.alf:=sinphi/sin(sfern);
  end;
  w:=c_.e*Sin(Bn);
  k:=pi_4+Bn*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);

  SlantingGnomon.K0:=tan(Pi_4+sfern*0.5)/Power(Ubig,SlantingGnomon.alf);

  w:=c_.e*Sin(B0);
  k:=pi_4+B0*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  SlantingGnomon.u0:=2.0*ARCTAN(SlantingGnomon.K0*Power(Ubig,SlantingGnomon.alf))-Pi_2;
  SlantingGnomon.L0:=SlantingGnomon.alf*L0;
  sincos(SlantingGnomon.u0,SlantingGnomon.sinu0,SlantingGnomon.cosu0);
end;

procedure SlantingGnomon_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw,sec: extended;
BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(SlantingGnomon.K0*Power(U,SlantingGnomon.alf))-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L*SlantingGnomon.alf-SlantingGnomon.L0,sindw,cosdw);
  Znam:=SlantingGnomon.Rn/(SlantingGnomon.sinu0*sinu+SlantingGnomon.cosu0*cosu*cosdw);
  X:= (SlantingGnomon.cosu0*sinu-SlantingGnomon.sinu0*cosu*cosdw)*znam;
  Y:= cosu*sindW*znam;

end;
procedure SlantingGnomon_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 zet:=ARCTAN(ro/SlantingGnomon.Rn);
 SinCos(zet,sinZet,CosZet);
 sinPhi:=cosZet*SlantingGnomon.sinu0+sinZet*SlantingGnomon.cosu0*CosA;
 tandw:=sinZet*sinA/(cosZet*SlantingGnomon.cosu0-sinZet*SlantingGnomon.sinu0*CosA);
 L:=(SlantingGnomon.L0+arctan(tandw))/SlantingGnomon.alf;
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(SlantingGnomon.K0*Power(U2,SlantingGnomon.alf))-Pi*0.5;

 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

procedure Init_PolarSlantingGnomon(bn,b0,L0,R:double);
var
  sinBn,w,bb,Ubig,tt,tt_2,n,m,sfern:extended;
begin
 SinBn:=Sin(Bn);
 SlantingGnomon.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
 w:=c_.e*SinBn;
 bb:=PI_4+Bn*0.5;
 UBig:=tan(bb) * Power((1-w)/(1+w), 0.5*c_.e);
 bb:=PI_4+SlantingGnomon.u0*0.5;
 SlantingGnomon.k0:=cotan(bb) *UBig;
 N:=  c_.a /SQRT(1.0 - c_.Es * SQR(sinBn));
 SlantingGnomon.Rn:=R;//N*cos(Bn)/cos(SlantingGnomon.u0);
 SlantingGnomon.L0:=L0;
   w:=c_.e*Sin(B0);
 bb:=pi_4+B0*0.5;
 Ubig:=cotan(bb) * Power((1+w)/(1-w),0.5*c_.e);
 SlantingGnomon.u0:=2.0*ARCTAN2(1/SlantingGnomon.K0, Ubig)-Pi_2;
sincos(SlantingGnomon.u0,SlantingGnomon.sinu0,SlantingGnomon.cosu0);
end;

procedure PolarSlantingGnomon_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;

BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
  usm:=2.0*ARCTAN2(1/SlantingGnomon.K0, U)-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L-SlantingGnomon.L0,sindw,cosdw);
  Znam:=SlantingGnomon.Rn/(SlantingGnomon.sinu0*sinu+SlantingGnomon.cosu0*cosu*cosdw);
  X:= (SlantingGnomon.cosu0*sinu-SlantingGnomon.sinu0*cosu*cosdw)*znam;
  Y:= cosu*sindW*znam;
end;
procedure PolarSlantingGnomon_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 zet:=ARCTAN(ro/SlantingGnomon.Rn);
 SinCos(zet,sinZet,CosZet);
 sinPhi:=cosZet*SlantingGnomon.sinu0+sinZet*SlantingGnomon.cosu0*CosA;
 tandw:=sinZet*sinA/(cosZet*SlantingGnomon.cosu0-sinZet*SlantingGnomon.sinu0*CosA);
 L:=SlantingGnomon.L0+arctan(tandw);
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
 usm2:=2.0*ARCTAN2(1/SlantingGnomon.K0, U2)-Pi*0.5;
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;


procedure Init_CrossGnomon(L0:double);
var
  w,k,Ubig,tt,tt_2,n,m:extended;
begin
  N:=c_.a;
  M:=c_.a *(1-c_.Es);
  CrossGnomon.Rn:=SQRT(M*N);
  CrossGnomon.alf:=1/SQRT(1-c_.Es);
  CrossGnomon.L0:=CrossGnomon.alf*L0;
end;

procedure CrossGnomon_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,sinA,cosA,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw,sec: extended;
sign:integer;
BEGIN
  if B>=0  then sign:=1 else begin sign:=-1; B:=abs(B) end;

  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(Power(U,CrossGnomon.alf))-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L*CrossGnomon.alf-CrossGnomon.L0,sindw,cosdw);
  Znam:=CrossGnomon.Rn/(cosu*cosdw);

  X:= Sign*sinu*znam;

  Y:= cosu*sindW*znam;
end;
procedure CrossGnomon_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
  sign:integer;
BEGIN
 if X>=0  then sign:=1 else begin sign:=-1; X:=abs(X) end;
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 zet:=ARCTAN(ro/CrossGnomon.Rn);
 SinCos(zet,sinZet,CosZet);
 sinPhi:=sinZet*CosA;
 tandw:=sinZet*sinA/cosZet;
 L:=(CrossGnomon.L0+arctan(tandw))/CrossGnomon.alf;
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(Power(U2,CrossGnomon.alf))-Pi*0.5;

 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=sign*Phi;
end;



procedure Init_NormStereograf(Bn,L0,R: double;mirr:boolean);
var
  SinBn,U,bb,w,N,M,Zn,tt,tt_2, eSign:extended;
  tgbl1,tgbl2,tg1,tg2:tgauss;
   fi: double;
begin
  if Bn>=0 then
    eSign:=1
  else
    eSign:=-1;
  Bn:=abs(Bn);
  NormStereograf.L0:=L0;
  SinBn:=Sin(Bn);
  NormStereograf.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
  w:=c_.e*SinBn;
  bb:=Pi_4+Bn*0.5;
  U:=tan(bb) * power((1-w)/(1+w),0.5*c_.e);
  bb:=PI_4+NormStereograf.u0*0.5;
  NormStereograf.k0:=cotan(bb) *U;
  {Zn:=cos(u)/(1+sin(u));
  zn:=arctan(zn);
  }
 { zn:=SQR(sec(0.5*(Pi_2- NormStereograf.u0)));
 // N:=  c_.a /SQRT(1.0 - c_.Es * SQR(sinBn));
  sinbn:=Sin(bn);
  tt:=1.0 - c_.Es * SQR(sinbn);
  tt_2:=sqrt(tt);
  N:=c_.a / tt_2;
  M:=c_.a *(1-c_.Es)/ (tt*tt_2);
  }
  //NormStereograf.R0:=SQRT(M*N)/Zn;
 // NormStereograf.r0:=c_.B;   //zn;

  NormStereograf.r0:=R;   //zn;
  NormStereograf.mirr:=mirr;
  NormStereograf.u0:=NormStereograf.u0*eSign;
 { tgbl1.x:=bn;
  tgbl1.y:=l0;
  tgbl2.x:=bn;
  tgbl2.y:=l0+Pi/64800;
  tt:=Geoid_Dist(tgbl1.x,tgbl1.y, tgbl2.x,tgbl2.y,fi);
  NormStereograf_BL_XY(tgbl1.x,tgbl1.y,tg1.x,tg1.y);
  NormStereograf_BL_XY(tgbl2.x,tgbl2.y,tg2.x,tg2.y);
  tt_2:=SQRT(SQR(tg1.x-tg2.x)+SQR(tg1.y-tg2.y));
  NormStereograf.r0:=NormStereograf.r0/tt_2*tt;
 }
end;


procedure NormStereograf_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,dw,ro,eSign: extended;
BEGIN
  if B>=0 then
    eSign:=1
  else
    eSign:=-1;
  B:=Abs(B);
  dw:=L-NormStereograf.L0;
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  //if abs(k-Pi_2)<1.e-12 then begin
   U:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
   usm:=2.0*ARCTAN2(1/NormStereograf.K0, U)-Pi*0.5;
 {
  end else begin
  U:=tan(k) * power((1-w))/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(U/NormStereograf.K0)-Pi*0.5;
  end;
  }
  ro:=2*NormStereograf.R0*cos(usm)/(1+sin(usm));
  Y:=ro*sin(dw);
  X:=eSign*ro*cos(dw);
  if NormStereograf.mirr then X:=-X;

end;

procedure NormStereograf_XY_BL(X,Y: double; var B,L:double);
var
  i:integer;
  k, u,U2,db,w,usm,usm2,Phi,tau,ro,dw: extended;
BEGIN
 if NormStereograf.u0<0 then X:=-X;

 if NormStereograf.mirr then X:=-X;
 ro:=SQRT(SQR(X)+SQR(Y));

 dw:=arctan2(Y,X);
 L:=NormStereograf.L0+dw;
 if ro=0 then
    B:=Pi_2
 else begin
 Usm:=Pi_2-2*arctan(0.5*ro/NormStereograf.R0);
 Phi:=Usm;
  tau:=1;
  i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
  //if abs(k-Pi*0.5)<1.e-12 then begin
    U2:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
  usm2:=2.0*ARCTAN2(1/NormStereograf.K0, U2)-Pi*0.5;
 { end else begin
   U2:=tan(k) * power((1-w))/(1+w),0.5*c_.e);
   usm2:=2.0*ARCTAN(U2/NormStereograf.K0)-Pi*0.5;
 end; }
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;
if NormStereograf.u0<0 then B:=-B;
end;

procedure Init_NormGnomon(Bn,L0,R: double;mirr:boolean);
var
  SinBn,U,bb,w,N:extended;
begin
  NormGnomon.L0:=L0;
  SinBn:=Sin(Bn);
  NormGnomon.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
  w:=c_.e*SinBn;
  bb:=Pi_4+Bn*0.5;
  U:=tan(bb) * power((1-w)/(1+w),0.5*c_.e);
  bb:=PI_4+NormGnomon.u0*0.5;
  NormGnomon.k0:=cotan(bb) *U;
  N:=  c_.a /SQRT(1.0 - c_.Es * SQR(sinBn));
  NormGnomon.r0:=R;//N*cos(Bn)/cos( NormGnomon.u0);
  NormGnomon.mirr:=mirr;
end;


procedure NormGnomon_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,dw,ro: extended;
BEGIN
  dw:=L-NormGnomon.L0;
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
 // if abs(k-Pi_2)<1.e-12 then begin
   U:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
   usm:=2.0*ARCTAN2(1/NormGnomon.K0, U)-Pi*0.5;
 {
  end else begin
  U:=tan(k) * power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(U/NormGnomon.K0)-Pi*0.5;
  end;
  }
  ro:=NormGnomon.R0*cotan(usm);
  Y:=ro*sin(dw);
  X:=ro*cos(dw);
if NormGnomon.mirr then X:=-X;
end;

procedure NormGnomon_XY_BL(X,Y: double; var B,L:double);
var
  i:integer;
  k, u,U2,db,w,usm,usm2,Phi,tau,ro,dw: extended;
BEGIN
 if NormGnomon.mirr then X:=-X;

 ro:=SQRT(SQR(X)+SQR(Y));

 dw:=arctan2(Y,X);
 L:=NormGnomon.L0+dw;
 if ro=0 then
    B:=Pi_2
 else begin
 Usm:=arctan2(NormGnomon.R0,ro);
 Phi:=Usm;
  tau:=1;
  i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 // if abs(k-Pi*0.5)<1.e-12 then begin
  U2:=cotan(k) * Power((1+w)/(1-w),0.5*c_.e);
  usm2:=2.0*ARCTAN2(1/NormGnomon.K0, U2)-Pi_2;
{  end else begin
   U2:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
   usm2:=2.0*ARCTAN(U2/NormGnomon.K0)-Pi*0.5;
 end;
}
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;

if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;
end;

procedure Init_SlantingPostel(bn,b0,L0:double);
var
  sinphi,w,k,Ubig,tt,tt_2,n,m,sfern:extended;
begin
  sinphi:=Sin(bn);
  tt:=1.0 - c_.Es * SQR(sinPhi);
  tt_2:=sqrt(tt);
  N:=c_.a / tt_2;
  M:=c_.a *(1-c_.Es)/ (tt*tt_2);
     if bn=0 then begin
  SlantingGnomon.Rn:=c_.a*SQRT(1-c_.Es);
  SlantingGnomon.alf:=1/SQRT(1-c_.Es);//N/SlantingStereograf.Rn
  sfern:=0;
  end  else begin

  SlantingPostel.Rn:=SQRT(M*N);
  sfern:=arcTan(SlantingPostel.Rn/N*Tan(bn));
  SlantingPostel.alf:=sinphi/sin(sfern);
  end;
  w:=c_.e*Sin(Bn);
  k:=pi_4+Bn*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);

  SlantingPostel.K0:=tan(Pi_4+sfern*0.5)/Power(Ubig,SlantingPostel.alf);

  w:=c_.e*Sin(B0);
  k:=pi_4+B0*0.5;
  Ubig:=tan(k) * power((1-w)/(1+w),0.5*c_.e);
  SlantingPostel.u0:=2.0*ARCTAN(SlantingPostel.K0*Power(Ubig,SlantingPostel.alf))-Pi*0.5;
  SlantingPostel.L0:=SlantingPostel.alf*L0;
  sincos(SlantingPostel.u0,SlantingPostel.sinu0,SlantingPostel.cosu0);

end;

procedure SlantingPostel_BL_XY(B,L:double;  var X,Y: double);
var
  k,  u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,Zet,tt: extended;

BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(SlantingPostel.K0*Power(U,SlantingPostel.alf))-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L*SlantingPostel.alf-SlantingPostel.L0,sindw,cosdw);
  Zet:=ARCCOS(SlantingPostel.sinu0*sinu+SlantingPostel.cosu0*cosu*cosdw);
  Znam:=SlantingPostel.Rn*zet/Sin(zet);
  X:=(SlantingPostel.cosu0*sinu-SlantingPostel.sinu0*cosu*cosdw)*znam;
  Y:=cosu*sindW*znam;
end;

procedure SlantingPostel_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,Zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 Zet:=ro/SlantingPostel.Rn;
 sinZet:=Sin(Zet);
 cosZet:=Cos(zet);
 sinPhi:=cosZet*SlantingPostel.sinu0+sinZet*SlantingPostel.cosu0*CosA;
 tandw:=sinZet*sinA/(cosZet*SlantingPostel.cosu0-sinZet*SlantingPostel.sinu0*CosA);
 L:=(SlantingPostel.L0+arctan(tandw))/SlantingPostel.alf;
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=tan(k) * power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(SlantingPostel.K0*Power(U2,SlantingPostel.alf))-Pi*0.5;

 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

procedure Init_PolarSlantingPostel(bn,b0,L0,R:double);
var
  sinBn,w,bb,Ubig,tt,tt_2,n,m,sfern:extended;
begin
 SinBn:=Sin(Bn);
 SlantingPostel.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
 w:=c_.e*SinBn;
 bb:=PI_4+Bn*0.5;
 UBig:=tan(bb) * Power((1-w)/(1+w), 0.5*c_.e);
 bb:=PI_4+SlantingPostel.u0*0.5;
 SlantingPostel.k0:=cotan(bb) *UBig;
 N:=  c_.a /SQRT(1.0 - c_.Es * SQR(sinBn));
 SlantingPostel.Rn:=R;//N*cos(Bn)/cos(SlantingStereograf.u0);
 SlantingPostel.L0:=L0;
 w:=c_.e*Sin(B0);
 bb:=pi_4+B0*0.5;
 Ubig:=cotan(bb) * Power((1+w)/(1-w),0.5*c_.e);
 SlantingPostel.u0:=2.0*ARCTAN2(1/SlantingPostel.K0, Ubig)-Pi_2;
 sincos(SlantingPostel.u0,SlantingPostel.sinu0,SlantingPostel.cosu0);
end;

procedure PolarSlantingPostel_BL_XY(B,L:double;  var X,Y: double);
var
  k,  u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,Zet,tt: extended;

BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
  usm:=2.0*ARCTAN2(1/SlantingPostel.K0, U)-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L-SlantingPostel.L0,sindw,cosdw);
  Zet:=ARCCOS(SlantingPostel.sinu0*sinu+SlantingPostel.cosu0*cosu*cosdw);
  Znam:=SlantingPostel.Rn*zet/Sin(zet);
  X:=(SlantingPostel.cosu0*sinu-SlantingPostel.sinu0*cosu*cosdw)*znam;
  Y:=cosu*sindW*znam;
end;

procedure PolarSlantingPostel_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,Zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 Zet:=ro/SlantingPostel.Rn;
 sinZet:=Sin(Zet);
 cosZet:=Cos(zet);
 sinPhi:=cosZet*SlantingPostel.sinu0+sinZet*SlantingPostel.cosu0*CosA;
 tandw:=sinZet*sinA/(cosZet*SlantingPostel.cosu0-sinZet*SlantingPostel.sinu0*CosA);
 L:=SlantingPostel.L0+arctan(tandw);
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=cotan(k) *Power((1+w)/(1-w),0.5*c_.e);
 usm2:=2.0*ARCTAN2(1/SlantingPostel.K0, U2)-Pi*0.5;
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

procedure Init_NormPostel(bn,L0,R:double;mirr:boolean);
var
  sinBn,w,bb,Ubig,tt,tt_2,n,m,sfern:extended;
begin
 SinBn:=Sin(Bn);
 NormPostel.u0:=Pi_2-ARCTAN(SQRT((1-SQR(c_.e*sinBn))/(1-SQR(c_.e)))*(COS(Bn)/SINBn));
 w:=c_.e*SinBn;
 bb:=PI_4+Bn*0.5;
 UBig:=tan(bb) * Power((1-w)/(1+w), 0.5*c_.e);
 bb:=PI_4+NormPostel.u0*0.5;
 NormPostel.k0:=cotan(bb) *UBig;
 N:=  c_.a /SQRT(1.0 - c_.Es * SQR(sinBn));
 NormPostel.R0:=R;//N*cos(Bn)/cos(SlantingStereograf.u0);
 NormPostel.L0:=L0;
 NormPostel.mirr:=mirr;
end;

procedure NormPostel_BL_XY(B,L:double;  var X,Y: double);
var
  k,  u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,Zet,tt: extended;

BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=cotan(k) * power((1+w)/(1-w),0.5*c_.e);
  usm:=2.0*ARCTAN2(1/NormPostel.K0, U)-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L-SlantingPostel.L0,sindw,cosdw);
  Zet:=Pi_2-usm;//ARCCOS(sinu);
  Znam:=NormPostel.R0*zet/Sin(zet);
  X:=-cosu*cosdw*znam;
  if NormPostel.mirr then X:=-X;
  Y:=cosu*sindW*znam;
end;

procedure NormPostel_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,Zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 if NormPostel.mirr then X:=-X;
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 Zet:=ro/NormPostel.R0;
 sinZet:=Sin(Zet);
 cosZet:=Cos(zet);
 sinPhi:=cosZet;
 tandw:=sinZet*sinA/(-sinZet*CosA);
 L:=SlantingPostel.L0+arctan(tandw);
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=cotan(k) *Power((1+w)/(1-w),0.5*c_.e);
 usm2:=2.0*ARCTAN2(1/SlantingPostel.K0, U2)-Pi*0.5;
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

procedure Init_CrossPostel(L0:double);
var
  sinphi,w,k,Ubig,tt,tt_2,n,m:extended;
begin
  N:=c_.a;
  M:=c_.a *(1-c_.Es);
  CrossPostel.Rn:=SQRT(M*N);
  CrossPostel.alf:=1/SQRT(1-c_.Es);
  CrossPostel.L0:=CrossPostel.alf*L0;
end;

procedure CrossPostel_BL_XY(B,L:double;  var X,Y: double);
var
  k,  u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,Zet,tt: extended;

sign:integer;
BEGIN
  if B>=0  then sign:=1 else begin sign:=-1; B:=abs(B) end;

  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(Power(U,CrossPostel.alf))-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L*CrossPostel.alf-CrossPostel.L0,sindw,cosdw);
  Zet:=ARCCOS(cosu*cosdw);
  Znam:=CrossPostel.Rn*zet/Sin(zet);
  X:=Sign*sinu*znam;
  Y:=cosu*sindW*znam;
end;

procedure CrossPostel_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,Zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
sign:integer;
BEGIN
  if X>=0  then sign:=1 else begin sign:=-1; X:=abs(X) end;

 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 Zet:=ro/CrossPostel.Rn;
 sinZet:=Sin(Zet);
 cosZet:=Cos(zet);
 sinPhi:=sinZet*CosA;
 tandw:=sinZet*sinA/cosZet;
 L:=(CrossPostel.L0+arctan(tandw))/CrossPostel.alf;
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=tan(k) * power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(Power(U2,CrossPostel.alf))-Pi*0.5;

 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Sign*Phi;
end;
function S(b:extended):extended;
var
  sinb,esinb,rr:extended;
begin
sinb:=sin(b);
esinb:=Sinb*c_.e;
Result:=0.5*SQR(c_.a)*(1-c_.es)*(sinb/(1-sqr(esinb))+ln((1+esinb)/(1-esinb))/(2*c_.e))
//Result:=0.5*SQR(c_.a)*(1-c_.es)*(1/(1-sqr(esinb))+ln((1+esinb)/(1-esinb))/(2*esinb));

//Result:=0.5*SQR(c_.a)*(1-c_.es)*sinb*(1/(1-sqr(esinb))+ln((1+esinb)/(1-esinb))/(2*esinb))

end;

procedure Init_SlantingLambert(b0,L0:double);
begin
  SlantingLambert.RnSQR:=0.5*SQR(c_.a)*(1+(1-c_.Es)*0.5/c_.e*ln((1+c_.e)/(1-c_.e)));
  SlantingLambert.Rn:=SQRT(SlantingLambert.RnSQR);
  SlantingLambert.sinu0:={sin(b0)*}(S(b0)/ SlantingLambert.RnSQR);
  SlantingLambert.cosu0:=SQRT(1-SQR(SlantingLambert.sinu0));
  SlantingLambert.L0:=L0;
end;

procedure SlantingLambert_BL_XY(B,L:double;  var X,Y: double);
var
  k,  u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,Zet,tt,sec: extended;
  grad,min:integer;
BEGIN
  sinu:={sin(b)*}(S(b)/ SlantingLambert.RnSQR);
  cosu:=SQRT(1-SQR(sinu));
  Rad_grad (arcsin(sinu),grad,min,sec);
  sincos(L-SlantingLambert.L0,sindw,cosdw);
  Zet:=ARCCOS(SlantingLambert.sinu0*sinu+SlantingLambert.cosu0*cosu*cosdw);

  Znam:=2*SlantingLambert.Rn*sin(0.5*zet)/Sin(zet);
  X:=(SlantingLambert.cosu0*sinu-SlantingLambert.sinu0*cosu*cosdw)*znam;
  Y:=cosu*sindW*znam;
end;

procedure SlantingLambert_XY_BL(X,Y:double;  var B,L: double);
var
  tau,usm,usm2,Phi,U2,k,w,db,sinA,cosA,ro,Zet,sinzet,cosZet,sinPhi,tandw: extended;
  i:Integer;
begin
 ro:=SQRT(SQR(X)+SQR(Y));
 sinA:=Y/ro;
 cosA:=X/ro;
 Zet:=2*arcsin(0.5*ro/SlantingLambert.Rn);
 sinZet:=Sin(Zet);
 cosZet:=Cos(zet);
 sinPhi:=cosZet*SlantingLambert.sinu0+sinZet*SlantingLambert.cosu0*CosA;
 tandw:=sinZet*sinA/(cosZet*SlantingLambert.cosu0-sinZet*SlantingLambert.sinu0*CosA);
 L:=(SlantingLambert.L0+arctan(tandw));
 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 usm2:=arcsin({sin(Phi)*}(S(Phi)/ SlantingLambert.RnSQR));

 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;
var
  SlantingPerspCylindr: record
   Rn,alf,k0,u0,L0,C,d,sinZ0,sinu0,cosu0:extended;
  end;
procedure Init_SlantingPerspCylindr(bn,b0,L0,z0,d:double);
var
  sinphi,w,k,Ubig,tt,tt_2,n,m,sfern:extended;
begin
  sinphi:=Sin(bn);
  tt:=1.0 - c_.Es * SQR(sinPhi);
  tt_2:=sqrt(tt);
  N:=c_.a / tt_2;
  M:=c_.a *(1-c_.Es)/ (tt*tt_2);

  if bn=0 then begin
  SlantingPerspCylindr.Rn:=c_.a*SQRT(1-c_.Es);
  SlantingPerspCylindr.alf:=1/SQRT(1-c_.Es);

  sfern:=0;
  end
    else  Begin
  SlantingPerspCylindr.Rn:=SQRT(M*N);

  sfern:=arcTan(SlantingPerspCylindr.Rn/N*Tan(bn));
  if sfern=0 then
    SlantingPerspCylindr.alf:=SQRT(1/(1-c_.Es))//N/SlantingPerspCylindr.Rn
  else
    SlantingPerspCylindr.alf:=sinphi/sin(sfern);
  end;
   w:=c_.e*Sin(Bn);
  k:=pi_4+Bn*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);

  SlantingPerspCylindr.K0:=tan(Pi_4+sfern*0.5)/Power(Ubig,SlantingPerspCylindr.alf);

  w:=c_.e*Sin(B0);
  k:=pi_4+B0*0.5;
  Ubig:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  SlantingPerspCylindr.u0:=2.0*ARCTAN(SlantingPerspCylindr.K0*Power(Ubig,SlantingPerspCylindr.alf))-Pi_2;
  SlantingPerspCylindr.L0:=SlantingPerspCylindr.alf*L0;
  sincos(SlantingPerspCylindr.u0,SlantingPerspCylindr.sinu0,SlantingPerspCylindr.cosu0);
  SlantingPerspCylindr.d:=d;
  SlantingPerspCylindr.C:=d+sin(z0);
  SlantingPerspCylindr.sinZ0:=sin(z0);

end;

procedure SlantingPerspCylindr_BL_XY(B,L:double;  var X,Y: double);
var
  k, u, w,usm,kvB,kvL,Znam, sinu,cosu,sindW,cosdw,sinA,cosA,A,ro,tanzet_5,sinzet,cosZet,sinPhi,tandw: extended;

BEGIN
  w:=c_.e*Sin(B);
  k:=pi_4+B*0.5;
  U:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
  usm:=2.0*ARCTAN(SlantingPerspCylindr.K0*Power(U,SlantingPerspCylindr.alf))-Pi*0.5;
  sincos(usm,sinu,cosu);
  sincos(L*SlantingPerspCylindr.alf-SlantingPerspCylindr.L0,sindw,cosdw);
  CosZet:=SlantingPerspCylindr.sinu0*sinu+SlantingPerspCylindr.cosu0*cosu*cosdw;
  SinZet:=SQRT(1-SQR(CosZet));
  cosA:=SlantingPerspCylindr.cosu0*sinu-SlantingPerspCylindr.sinu0*cosu*cosdw;
  sinA:=cosu*sindw;
  A:=ARCTAN2(sinA,cosA);

  X:=SlantingPerspCylindr.C*SlantingPerspCylindr.Rn*coszet/(SlantingPerspCylindr.d+sinZet);
  Y:=-SlantingPerspCylindr.Rn*SlantingPerspCylindr.sinZ0*A;
end;

procedure SlantingPerspCylindr_XY_BL(X,Y:double;  var B,L: double);
var
  A,tau,usm,usm2,Phi,U2,X2,Xnorm,k,w,db,sinA,cosA,ro,tanzet_5,sinzet,cosZet,coszet2,sinPhi,tandw,dw: extended;
  i:Integer;
begin
 A:=-Y/(SlantingPerspCylindr.Rn*SlantingPerspCylindr.sinZ0);
 sincos(A,sinA,cosA);
 coszet:=X*SlantingPerspCylindr.d/(SlantingPerspCylindr.C*SlantingPerspCylindr.Rn);
 Xnorm:=X/(SlantingPerspCylindr.C*SlantingPerspCylindr.Rn);

 tau:=1;   i:=0;
repeat
 inc(i);
 SinZet:=SQRT(1-SQR(CosZet));
 X2:=coszEt/(SlantingPerspCylindr.d+sinZet);

 db:=tau*(Xnorm-X2);
 coszet:=coszet+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 SinZet:=SQRT(1-SQR(CosZet));
 sinPhi:=cosZet*SlantingPerspCylindr.sinu0+sinZet*SlantingPerspCylindr.cosu0*CosA;
 dw:=ARCTAN2(sinZet*sinA,(cosZet*SlantingPerspCylindr.cosu0-sinZet*SlantingPerspCylindr.sinu0*CosA));
 if dw<0 then dw:=dw+2*Pi;

 L:=(SlantingPerspCylindr.L0+dw)/SlantingPerspCylindr.alf;

 Phi:=Arcsin(sinPhi);
 usm:=Phi;
 tau:=1;   i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 k:=pi_4+Phi*0.5;
 U2:=tan(k) * Power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(SlantingPerspCylindr.K0*Power(U2,SlantingPerspCylindr.alf))-Pi*0.5;
 db:=tau*(Usm-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
end;

function elp_(elp: byte): byte;
begin
  if elp > 9 then elp:=0;
  Result:=elp
end;

function Geoid_Dist(b1,l1, b2,l2: double; var fi: double): double;
var
  w1,w2,su1,cu1,su2,alfa,sinsg,
  cu2,c1,d1,c2,b,d2,beta,cossg,
  lam,sg,l,p,q,sina0,x_cosa0,
  x,y,del,dl,a: double;
begin
  if Abs(b2-b1) < 0.000000001 then
  if Abs(l2-l1) < 0.000000001 then
  begin fi:=0; Result:=0; Exit end;

  b1:=b1 + 1.0E-20; b2:=b2 + 1.0E-20;
  l1:=l1 + 1.0E-20; l2:=l2 + 1.0E-20;

  if l1 > 2*pi then l1:=(l1/pi2 -  Trunc(l1 /pi2))*pi2;
  if b1 > 2*pi then b1:=(b1/pi2 -  Trunc(b1 /pi2))*pi2;
  if l2 > 2*pi then l2:=(l2/pi2 -  Trunc(l2 /pi2))*pi2;
  if b2 > 2*pi then b2:=(b2/pi2 -  Trunc(b2 /pi2))*pi2;

  w1 :=Sqrt(1.0 - e2*sin(b1)*sin(b1)) + 1.0E-10;
  w2 :=Sqrt(1.0 - e2*sin(b2)*sin(b2)) + 1.0E-10;
  su1:=sin(b1) * Sqrt(1.0 - e2) / w1;
  su2:=sin(b2) * Sqrt(1.0 - e2) / w2;
  cu1:=cos(b1) / w1  + 1.0E-10      ;
  cu2:=cos(b2) / w2  + 1.0E-10      ;

  l  := l2-l1  ;
  c1 := su1*su2;
  c2 := cu1*cu2;
  d1 := cu1*su2;
  d2 := su1*cu2;

  del:=0;

  REPEAT
    dl  := del;
    lam := l + dl ;
    p   := cu2* sin (lam);
    q   := d1 - d2*cos(lam) + 1.0E-10 ;
    fi  := arctan(p/q);

    if p >= 0.0 then if q >= 0.0 then fi :=      abs(fi)
                                 else fi := pi - abs(fi)
                else if q >= 0.0 then fi := 2.0* pi - abs(fi)
                                 else fi := pi      + abs(fi);

    sinsg := p* sin(fi) + q* cos(fi) ;
    cossg := c1 + c2* cos(lam) ;
    if cossg >= 0.0 then sg :=      abs (arctan(sinsg/cossg))
                    else sg := pi - abs (arctan(sinsg/cossg));

    sina0  :=cu1 * sin(fi);
    x_cosa0:=1 - sina0*sina0;

    x   := 2*c1 - cos(sg)*x_cosa0;
    alfa:= 3.352329869E-3 - (2.8189E-6 - 7.0E-9 * x_cosa0) * x_cosa0;
    beta:= 2.8189E-6 - 9.4E-9 * x_cosa0;
    del := (alfa* sg - beta* x* sin(sg)) * sina0;

  UNTIL Abs(del - dl) <= 1.0E-10;

  y:=(Sqr(x_cosa0) - 2*x*x) * cos(sg);

  a:=6356863.020 + (10708.949 - 13.474  * x_cosa0) * x_cosa0;

  b:=10708.938 - 17.956 * x_cosa0;
  Result:=a* sg + (b* x + 4.487* y) * sinsg
end;

type
  tDatum = record dX,dY,dZ,wx,wy,wz,m: Double end;

const
  Datums: array[1..9] of tDatum =
  ( //(dX:27; dY:-135; dZ:-89, wX:0; wY:0; wZ:0; m:0), // Tolik Krasovsky-1942
   // (dX:25; dY:-141; dZ:-79; wX:0; wY:0.35; wZ:0.866; m:0), // Система координат 1942 г.
  (dX:28; dY:-130; dZ:-95;  wX:0; wY:0; wZ:0; m:0),      // PULKOVO 1942
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0),             // WGS-1976
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0),             // Хейфорда-1909
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0),             // Кларка-1880
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0),             // Кларка-1866
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0),             // Эверест-1857
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0),             // Бессель-1841
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0),             // Эри-1830
   (dX:0; dY:0; dZ:0; wX:0; wY:0; wZ:0; m:0)              // WGS-1984
   );

procedure BLH_BLH(b,l,H: extended; elp,elp_: Integer; var b_,l_,H_: double);
var
  from_dat,to_dat,from_idx,to_idx: Integer;
  X1,Y1,Z1,X2,Y2,Z2,dX,dY,dZ, WX, WY, WZ, a1,b1,a2,b2, es1,es2, h1,dm: Extended;

  phi1, lam1, M, N, temp: Extended;
  R2,Teta,sinphi, cosphi, sinlam, coslam: Extended;

 // Dlat, Dlng, Dh, Da, Df: Extended;

begin
  b_:=b; l_:=l; H_:=H;
  if elp<1 then elp:=1;
  if elp_<1 then elp_:=1;
  if elp <> elp_ then
  if elp in [1..9] then
  if elp_ in [1..9] then begin

    from_dat:=elp; to_dat:=elp_;

    DX:=Datums[from_dat].dx - Datums[to_dat].dx;
    DY:=Datums[from_dat].dy - Datums[to_dat].dy;
    DZ:=Datums[from_dat].dz - Datums[to_dat].dz;
    WX:=(Datums[from_dat].wx - Datums[to_dat].wx)/3600*pi/180;
    WY:=(Datums[from_dat].wy - Datums[to_dat].wy)/3600*pi/180;
    WZ:=(Datums[from_dat].wz - Datums[to_dat].wz)/3600*pi/180;
    dm:=Datums[from_dat].m - Datums[to_dat].m;

    from_idx:=elp; to_idx:=elp_;

    a1:=Ellipsoids[from_idx].A;
    b1:=Ellipsoids[from_idx].B;
    a2:=Ellipsoids[to_idx].A;
    b2:=Ellipsoids[to_idx].B;

    // get eccentricity squared
    es1:=Ellipsoids[from_idx].Es;
    es2:=Ellipsoids[to_idx].Es;
   (*
    // calculate delta major radius
    Da:= a2 - a1;

    // calculate delta flattening
    Df:=Ellipsoids[to_idx].F - Ellipsoids[from_idx].F;
  *)
    phi1:=b; lam1:=l; h1:=H;

    // calculate sin and cos of lat and lng
    SinCos(phi1, sinphi,cosphi);
    SinCos(lam1, sinlam,coslam);

    // calculate M and N
    temp:= 1.0 - es1 * SQR(sinphi);
    M:= a1 * (1.0 - es1) / Power(temp,1.5);
    N:= a1 / sqrt(temp);
    X1:=(N+h1)*cosphi*coslam;
    Y1:=(N+h1)*cosphi*sinlam;
    if Y1<0.001 then Y1:=0.001;
    Z1:=(N+h1-N*ES1)*sinphi;

    X2:=(X1-wZ*Y1+Wy*Z1)*(1+dm)+DX;
    Y2:=(Y1+wZ*X1-Wx*Z1)*(1+dm)+DY;
    Z2:=(Z1-wy*X1+Wx*Y1)*(1+dm)+DZ;
    R2:=SQRT(SQR(X2)+SQR(Y2));
    TETA:=Arctan(Z2/((1-Ellipsoids[to_idx].f)*r2));
    b_:=Arctan( ((Es2/SQRT(1-ES2))*a2*Power(sin(TETA),3)+Z2)/
                 (R2-A2*es2*Power(cos(TETA),3)) );
    if Y2>0 then
      l_:=Pi*0.5-arctan(X2/Y2)
    else
      l_:=-Pi*0.5+arctan(X2/(-Y2));

    H_:=Z2*sin(b_)+r2*cos(b_)-a2*SQRT(1-es2*sqr(sin(b_)));
    end;
    // calculate delta latitude
    (*
    temp:=Sqrt(1.0 - es1);
    Dlat:=(-DX * sinphi * coslam - DY * sinphi * sinlam +
          DZ * cosphi + Da  * (N * es1 * sinphi * cosphi) / a1 +
          Df * (M / temp + N * temp) * sinphi * cosphi) / (M + h1);

    while Dlat > Pi do Dlat:=Dlat - Pi;

    // calculate delta longitude
    Dlng:=(-DX * sinlam + DY * coslam) / ((N + h1) * cosphi);

    // save new latitude, longitude
    b_:={Norm_Angle}(b + Dlat);
    l_:={Norm_Angle}(l + Dlng);

    // calculate delta height
    Dh:=DX * cosphi * coslam + DY * cosphi * sinlam + DZ * sinphi -
        Da * (a1 / N) + Df * temp * N * sinphi * sinphi;
  end
  *)
end;

procedure BLH_BLH_IM(b,l,H: extended; dtm,dtm_: pDatumIM; var b_,l_,H_: double);
var
  X1,Y1,Z1,X2,Y2,Z2,dX,dY,dZ, WX, WY, WZ, a1,b1,a2,b2, es1,es2, h1,dm: Extended;

  phi1, lam1, M, N, temp, F1, f2: Extended;
  R2,Teta,sinphi, cosphi, sinlam, coslam: Extended;

 // Dlat, Dlng, Dh, Da, Df: Extended;

begin
  b_:=b; l_:=l; H_:=H;
  {if elp <> elp_ then
  if elp in [1..9] then
  if elp_ in [1..9] then begin
  }

    DX:=dtm.dX - dtm_.dx;
    DY:=dtm.dy - dtm_.dy;
    DZ:=dtm.dz - dtm_.dz;
    WX:=(dtm.wx - dtm_.wx)/3600*pi/180;
    WY:=(dtm.wy - dtm_.wy)/3600*pi/180;
    WZ:=(dtm.wz - dtm_.wz)/3600*pi/180;
    dm:=0;//Datums[from_dat].m - Datums[to_dat].m;
    a1:=dtm.R;
    F1:=1/dtm.Alfa;
    b1:=a1*(1-F1);
    Es1:=2*F1 - F1*F1;


    a2:=dtm_.R;
    F2:=1/dtm_.Alfa;
    b2:=a2*(1-F2);
    Es2:=2*F2 - F2*F2;

   (*
    // calculate delta major radius
    Da:= a2 - a1;

    // calculate delta flattening
    Df:=Ellipsoids[to_idx].F - Ellipsoids[from_idx].F;
  *)
    phi1:=b; lam1:=l; h1:=H;

    // calculate sin and cos of lat and lng
    SinCos(phi1, sinphi,cosphi);
    SinCos(lam1, sinlam,coslam);

    // calculate M and N
    temp:= 1.0 - es1 * SQR(sinphi);
    M:= a1 * (1.0 - es1) / Power(temp,1.5);
    N:= a1 / sqrt(temp);
    X1:=(N+h1)*cosphi*coslam;
    Y1:=(N+h1)*cosphi*sinlam;
    if abs(Y1)<0.001 then if Y1>=0 then Y1:=0.001 else Y1:=-0.001;
    Z1:=(N+h1-N*ES1)*sinphi;

    X2:=(X1-wZ*Y1+Wy*Z1)*(1+dm)+DX;
    Y2:=(Y1+wZ*X1-Wx*Z1)*(1+dm)+DY;
    Z2:=(Z1-wy*X1+Wx*Y1)*(1+dm)+DZ;
    R2:=SQRT(SQR(X2)+SQR(Y2));
    TETA:=Arctan(Z2/((1-f2)*r2));
    b_:=Arctan( ((Es2/SQRT(1-ES2))*a2*Power(sin(TETA),3)+Z2)/
                 (R2-A2*es2*Power(cos(TETA),3)) );
    if Y2>0 then
      l_:=Pi*0.5-arctan(X2/Y2)
    else
      l_:=-Pi*0.5+arctan(X2/(-Y2));

    H_:=Z2*sin(b_)+r2*cos(b_)-a2*SQRT(1-es2*sqr(sin(b_)));
  //  end;
    // calculate delta latitude
    (*
    temp:=Sqrt(1.0 - es1);
    Dlat:=(-DX * sinphi * coslam - DY * sinphi * sinlam +
          DZ * cosphi + Da  * (N * es1 * sinphi * cosphi) / a1 +
          Df * (M / temp + N * temp) * sinphi * cosphi) / (M + h1);

    while Dlat > Pi do Dlat:=Dlat - Pi;

    // calculate delta longitude
    Dlng:=(-DX * sinlam + DY * coslam) / ((N + h1) * cosphi);

    // save new latitude, longitude
    b_:={Norm_Angle}(b + Dlat);
    l_:={Norm_Angle}(l + Dlng);

    // calculate delta height
    Dh:=DX * cosphi * coslam + DY * cosphi * sinlam + DZ * sinphi -
        Da * (a1 / N) + Df * temp * N * sinphi * sinphi;
  end
  *)
end;

procedure BLH_BLH_7(b,l,H: extended; elp,elp_: Integer; var dtm,dtm_: tDatum7; var b_,l_,H_: double);
var
  X1,Y1,Z1,X2,Y2,Z2,dX,dY,dZ, WX, WY, WZ, a1,b1,a2,b2, es1,es2, h1,dm: Extended;

  phi1, lam1, M, N, temp: Extended;
  R2,Teta,sinphi, cosphi, sinlam, coslam: Extended;

 // Dlat, Dlng, Dh, Da, Df: Extended;

begin
  b_:=b; l_:=l; H_:=H;
  if elp<1 then elp:=1;
  if elp_<1 then elp_:=1;
  if elp <> elp_ then
  if elp in [1..9] then
  if elp_ in [1..9] then begin

    DX:=dtm.dx - dtm_.dx;
    DY:=dtm.dy - dtm_.dy;
    DZ:=dtm.dz - dtm_.dz;
    WX:=(dtm.wx - dtm_.wx)/3600*pi/180;
    WY:=(dtm.wy - dtm_.wy)/3600*pi/180;
    WZ:=(dtm.wz - dtm_.wz)/3600*pi/180;
    dm:=dtm.m - dtm_.m;

    a1:=Ellipsoids[elp].A;
    b1:=Ellipsoids[elp].B;
    a2:=Ellipsoids[elp_].A;
    b2:=Ellipsoids[elp_].B;

    // get eccentricity squared
    es1:=Ellipsoids[elp].Es;
    es2:=Ellipsoids[elp_].Es;
   (*
    // calculate delta major radius
    Da:= a2 - a1;

    // calculate delta flattening
    Df:=Ellipsoids[to_idx].F - Ellipsoids[from_idx].F;
  *)
    phi1:=b; lam1:=l; h1:=H;

    // calculate sin and cos of lat and lng
    SinCos(phi1, sinphi,cosphi);
    SinCos(lam1, sinlam,coslam);

    // calculate M and N
    temp:= 1.0 - es1 * SQR(sinphi);
    M:= a1 * (1.0 - es1) / Power(temp,1.5);
    N:= a1 / sqrt(temp);
    X1:=(N+h1)*cosphi*coslam;
    Y1:=(N+h1)*cosphi*sinlam;
    if Y1<0.001 then Y1:=0.001;
    Z1:=(N+h1-N*ES1)*sinphi;

    X2:=(X1-wZ*Y1+Wy*Z1)*(1+dm)+DX;
    Y2:=(Y1+wZ*X1-Wx*Z1)*(1+dm)+DY;
    Z2:=(Z1-wy*X1+Wx*Y1)*(1+dm)+DZ;
    R2:=SQRT(SQR(X2)+SQR(Y2));
    TETA:=Arctan(Z2/((1-Ellipsoids[elp_].f)*r2));
    b_:=Arctan( ((Es2/SQRT(1-ES2))*a2*Power(sin(TETA),3)+Z2)/
                 (R2-A2*es2*Power(cos(TETA),3)) );
    if Y2>0 then
      l_:=Pi*0.5-arctan(X2/Y2)
    else
      l_:=-Pi*0.5+arctan(X2/(-Y2));

    H_:=Z2*sin(b_)+r2*cos(b_)-a2*SQRT(1-es2*sqr(sin(b_)));
    end;
    // calculate delta latitude
    (*
    temp:=Sqrt(1.0 - es1);
    Dlat:=(-DX * sinphi * coslam - DY * sinphi * sinlam +
          DZ * cosphi + Da  * (N * es1 * sinphi * cosphi) / a1 +
          Df * (M / temp + N * temp) * sinphi * cosphi) / (M + h1);

    while Dlat > Pi do Dlat:=Dlat - Pi;

    // calculate delta longitude
    Dlng:=(-DX * sinlam + DY * coslam) / ((N + h1) * cosphi);

    // save new latitude, longitude
    b_:={Norm_Angle}(b + Dlat);
    l_:={Norm_Angle}(l + Dlng);

    // calculate delta height
    Dh:=DX * cosphi * coslam + DY * cosphi * sinlam + DZ * sinphi -
        Da * (a1 / N) + Df * temp * N * sinphi * sinphi;
  end
  *)
end;


var
  RN: record
     alf,C,e,Ro1,Bmin,Bmax,
     Lmin,Lmax,Lmain_O,MS,MC,X0,Y0,MSb,MCb,GX0,GY0,
     C2,C4,C6,C8, _B1,_B2,_L1: Extended;
   end;

procedure Calc_U_R(bl_b: Extended; var U,R: Extended);
var
  B,Ux,Rx: Extended;
begin
  B:=RN.e*sin(bl_b);
  B:=Arctan(B/Sqrt(1-Sqr(B)));
  Ux:=pi_4+bl_b*0.5;
  Rx:=pi_4+b*0.5;
  Rx:=exp(RN.e*ln(cos(Rx)/Sin(Rx)));
  Ux:=sin(Ux)/cos(Ux);
  U:=Ux*Rx;
  Rx:=c_.A*cos(Bl_b);
  R:=Rx/Sqrt(1-Sqr(RN.e*sin(BL_b)));
end;

procedure conus_Init(b1,b2,l1: Extended);
var
   B,Fx,Ux,Rx,U1,R1,U2,R2: Extended;
   e2,e4,e6,e8: Extended;
begin
  if (RN._B1 <> b1)
  or (RN._B2 <> b2)
  or (RN._L1 <> l1) then begin
    RN._B1:=b1; RN._B2:=b2; RN._L1:=l1;
    RN.e:=Sqrt(c_.Es);
    Calc_U_R(B1,U1,R1);
    Calc_U_R(B2,U2,R2);
    RN.alf:=(Ln(R1)-Ln(R2))/(Ln(U2)-Ln(U1));

    FX:=Arctan(RN.alf/Sqrt(1-Sqr(RN.alf)));
    B:=RN.e*sin(Fx);
    B:=arctan(B/Sqrt(1-Sqr(B)));
    Ux:=pi_4+FX*0.5;
    Rx:=pi_4+B*0.5;
    Rx:=Cos(Rx)/Sin(Rx);
    Rx:=exp(ln(Rx)*RN.e);
    Ux:=sin(Ux)*Rx/Cos(Ux);
    Rx:=c_.A*cos(Fx)/sqrt(1-sqr(RN.e*sin(fx)));
    RN.C:=sqrt(R1*Rx*exp(ln(U1*ux)*RN.alf))/RN.alf;
    RN.Ro1:=RN.C/exp(ln(u1)*RN.alf);

    e2:=c_.Es; e4:=sqr(e2);
    e6:=e2*e4; e8:=sqr(e4);

    RN.c2:=e2/2+5/24*e4+e6/12+13/360*e8;
    RN.c4:=7/48*e4+29/240*e6+811/11520*e8;
    RN.c6:=7/120*e6+81/1120*e8;
    RN.c8:=4279/161280*e8;
  end
end;

procedure conus_BL_XY(b,l: Double; out x,y: Double);
var
   U,R,RO, sin,cos: Extended;
begin
   Calc_U_R(b,U,R);
   RO:=RN.c/exp(ln(u)*RN.alf);

   SinCos(RN.alf*(l-RN._L1), sin,cos);
   x:=RN.RO1-RO*cos; y:=RO*sin;
end;

procedure conus_XY_BL(x,y: Double; out b,l: Double);
var
  u2,fi: Extended;
begin
  x:=RN.Ro1-x;
  L:=Arctan2(y,x)/RN.alf+RN._L1;
  u2:=sqr(exp(ln(RN.c/ Hypot(x,y) )/RN.alf));
  fi:=arcsin((u2-1)/(u2+1));
  B:=fi+RN.C2*sin(2*fi)+RN.C4*sin(4*fi)+
        RN.C6*sin(6*fi)+RN.C8*sin(8*fi)
end;


procedure SimplePolykon_BL_XY(b,l,L0: Double; out x,y: Double);
var
  temp,dX, NR, ro, sinphi,cosphi, delt, N,N1,A2,A4,A6,F,Z,P,R,ALF,TZ,TZ2,TH,T2,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,bb,
  K2,K4,K6: extended;
begin
  // вычисление расстояния от экватора
  N:=c_.F/(2-c_.F);

  N1:=Sqr(N); R:=c_.A*(1+N1/4+N1*N1/64)/(1+N);
  A2:=N/2-N1*(2/3)+N*N1*(5/16);
  A4:=N1*13/48-N*N1*3/5;
  A6:=N*N1*61/240;
  K2:=2*(N-N1/3-N*N1*2/3);
  K4:=N1*5/3-N1*N*16/15;
  K6:=N1*N*26/15;

  IF B < 0 THEN BEGIN bb:=Abs(B);
    F:=K2*SIN(2*Bb)+K4*SIN(4*Bb)-K6*SIN(6*Bb)-Bb
  END
  ELSE F:=B-K2*SIN(2*B)+K4*SIN(4*B)-K6*SIN(6*B);

  TZ:=(Sin(F)/Cos(F));{/Cos(RAS);} TZ2:=Sqr(TZ);
  //Z:=ArcTan(TZ); // TH:=COS(F)*SIN(RAS); =0
  //T2:=Sqr(TH); =0 P:=Ln((1+TH)/(1-TH))/2;  =0
  a11:=2*TZ/(1+TZ2); b11:=(1-TZ2)/(1+TZ2);
  {c11:=0; 2*TH/(1-T2);} //d11:=1;//(1+T2)/(1-T2);
  a21:=2*a11*b11; //c21:=2*c11*d11; =0
  b21:=1;//-2*Sqr(a11); d21:=1; //+2*Sqr(c11);
  a31:=a11*b21+a21*b11; //c31:=0;//c11*d21+c21*d11;
  b31:=b11*b21-a11*a21; //d31:=1;//d11*d21+c11*c21;

  //DX:=R*(Z+A2*a11*d11+A4*a21*d21+A6*a31*d31);
  // формула упрощена вследствие обнуления и равенства единице некоторых коэффициэнтов
  DX:=R*(F+A2*a11+A4*a21+A6*a31);

    SinCos(b, sinphi,cosphi);
    temp:= 1.0 - c_.Es * SQR(sinPhi);
    NR:=  c_.a / sqrt(temp);
   if abs(b)<0.00001 then begin
   X:=DX;
   Y:=NR*(L-L0);
   end else begin
    ro:=NR*cosphi/sinPhi;
    delt:=(L-L0)*sinphi;
    X:=DX+ro*(1-cos(delt));
    Y:=ro*sin(Delt)
   end;
end;

function  SimplePolykon_XY_BL(X,Y, L0,eps: double; var B,L: double):integer;
var
  i: integer;
  tgc:tgauss;
  tau,grad,old,e, fi, lpr,r0, k,k1, x2,dX, u, db,dl: double;
  N,N1,B2,B4,B6,F,Z,P,R,
  a11,a21,a31,b11,b21,b31,c11,c21,c31,d11,d21,d31,
  K2,K4,K6,V,sp,chp,SinF,TanL: double;
begin
  N:=c_.F/(2-c_.F);

  N1:=Sqr(N); R:=c_.A*(1+N1/4+N1*N1/64)/(1+N);
  B2:=N/2-N1*(2/3)+N*N1*(37/96); B4:=N1/48+N*N1/15;
  B6:=N*N1*17/480; K2:=2*(N-N1/3-N*N1);
  K4:=N1*7/3-N1*N*8/5; K6:=N1*N*56/15;
  U:=X/R; V:=Y/R; a11:=Sin(2*U); b11:=Cos(2*U);
  a21:=2*a11*b11; b21:=1-2*(a11*a11);
  a31:=a11*b21+a21*b11; b31:=b11*b21-a11*a21;
  c11:=(exp(2*V)-exp(-2*V))/2; d11:=sqrt(1+sqr(c11));
  c21:=2*c11*d11; d21:=1+2*sqr(c11);
  c31:=c11*d21+c21*d11; d31:=c11*c21+d11*d21;
  Z:=U-B2*a11*d11-B4*a21*d21-B6*a31*d31;
  P:=V-B2*b11*c11-B4*b21*c21-B6*b31*c31;
  sp:=(exp(P)-exp(-P))/2; chp:=sqrt(1+Sqr(sp));
  SinF:=Sin(Z)/chp; F:=ArcTan((SinF)/(Sqrt(1-Sqr(SinF))));
  TanL:=sp/Cos(Z);
  Lpr:=ArcTan(TanL);
  fi:=F+K2*Sin(2*F)+K4*sin(4*F)+K6*sin(6*F);
   tau:=1.9e-7;
 i:=0;
repeat
 inc(i);
SimplePolykon_BL_XY(fi,Lpr,0,tgc.x,tgc.y);
 dl:=tau*(y-tgc.y);
 Lpr:=Lpr+dl;

 db:=tau*(x-tgc.x);
 fi:=fi+db;
if i>100000 then break;
until max(ABS(db),ABS(dl))<eps;

  B:=fi; L:=Lpr+L0;
  Result:=i;
end;

procedure CrossCylMerc_BL_XY(b,l,BN: Double; out x,y: Double);
var
  kvB,kvL,temp,dX, NR,NN,MN, un, Ubn, u, Ub,ro, sinphi,cosphi, Kobr: extended;
begin
    SinCos(bN, sinphi,cosphi);

    // calculate M and N
    temp:= 1.0 - c_.Es * SQR(sinPhi);
    MN:= c_.a * (1.0 - c_.Es) / Power(temp,1.5);
    NN:=  c_.a / sqrt(temp);
    un:=SQRT(NN/Mn)*cosphi/sinphi;
    un:=arctan(1/un);
    temp:= (1.0 - c_.Es * sinPhi)/(1.0 +c_.Es * sinPhi);
    Ubn:=Tan(Pi*0.25+Bn*0.5)*Power(temp,c_.Es*0.5);
    Kobr:=tan(Pi*0.25+un*0.5)/Ubn;
    SinCos(bN, sinphi,cosphi);
    temp:= (1.0 - c_.Es * sinPhi)/(1.0 +c_.Es * sinPhi);
    Ub:=Tan(Pi*0.25+B*0.5)*Power(temp,c_.Es*0.5);
    U:=2*(arctan(Ub*kobr)-Pi_4);
    KvB:=ArcSIN(-Cos(U)*cos(L));
    KvL:=Arctan(sin(L)/tan(U));

end;


procedure XY_to_BL(x,y, lc,b1,b2: double; elp,prj: byte; var b,l: double);  
begin
  c_:=Ellipsoids[elp_(elp)];

  case prj of
0,
1:  g_XY_BL(x,y,lc,b,l);
2:  begin
      x:=x/0.9996; y:=y/0.9996;
      g_XY_BL(x,y,lc,b,l);
    end;
3:  m_XY_BL(x,y,b1,b,l);

4:  begin
      conus_Init(b1,b2,lc);
      conus_XY_BL(x,y, b,l);
    end;

5:  begin
      b:=x/180000;
      l:=y/120000
    end
  end
end;

procedure BL_to_XY  (b,l, lc,b1,b2: double; elp,prj: byte; var x,y: double);
begin
  c_:=Ellipsoids[elp_(elp)];

  case prj of
0,
1:  g_BL_XY(b,l,lc,x,y);
2:  begin
      g_BL_XY(b,l,lc,x,y);
      x:=x*0.9996; y:=y*0.9996;
    end;

3:  m_BL_XY(b,l,b1,x,y);

4:  begin
      conus_Init(b1,b2,lc);
      conus_BL_XY(b,l, x,y);
    end;

5:  begin
      x:=b*180000;
      y:=l*120000;
    end
  end
end;

begin
  Ellipsoids_Init;
  FillChar(RN,SizeOf(RN),0);
//  conus_Init(1.11,1.22,0.5)
end.
