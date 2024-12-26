unit Conlamb;

interface
uses math,BLGEO;

Procedure Init_BL_Con_Lambert(k0,b0,l0,x0,R0Y0:double);
procedure BL_to_Con_Lambert(B, L : Double; var X, Y : Double);
Procedure Con_Lambert_to_BL(X, Y : Double; var B, L : Double);

Implementation

var
  k,p, Lo,Xo,RoYo:extended;

Procedure Init_BL_Con_Lambert(k0,b0,l0,x0,R0Y0:double);
{
 Север
   k0 :=0.99993602
   B0 :=22° 21'
   L0 :=81° W
   x0:= 500 000
   R0Y0:=15 800 000

 Юг
   k0 :=0.99994848
   B0 :=20° 43'
   L0 :=76° 50'W
   x0:= 500 000
   R0Y0:=17 100 000
}
var
  tt,tt_2,N0,R0:extended;
  i:integer;
begin
  c_:=Ellipsoids[5];  // Klark 1866    (A:6378206.4;   Alfa:294.9786982 ),

  p:=Sin(b0);
  tt:=1.0 - c_.Es * SQR(p);
  tt_2:=sqrt(tt);
  N0:=c_.a / tt_2;
  R0:=k0*N0*cotan(b0);
  k:=power(tan(Pi*0.25+b0*0.5)*power((1-c_.E*p)/(1+c_.E*p),c_.E*0.5),p)*R0;
  Lo:=L0;
  Xo:=X0;
  RoYo:=R0Y0;
end;

procedure BL_to_Con_Lambert(B, L : Double; var X, Y : Double);
var
  sinb,deltaL : Double;            //Long Diff
    deltaFi : Double;           //Lat Diff (Min's)
    zita : Double;              //Meridian Convergence
    R : Double;                 //Radius
    Xprima : Double;            //X Displacement
    Yprima : Double;
    Ysegunda : Double;
begin
   sinb:=sin(b);
   R:=k*power(cotan(Pi*0.25+b*0.5)*power((1+c_.E*sinb)/(1-c_.E*sinb),c_.E*0.5),p);
    deltaL := L-Lo;
    zita := deltaL * p;
    Xprima := R * Sin(zita);
    X := Xo + Xprima;
    Ysegunda := Xprima * Tan(zita * 0.5);
    Yprima := RoYo - R;
    Y := Yprima + Ysegunda
end;

Procedure Con_Lambert_to_BL(X, Y : Double; var B, L : Double);
Var
 deltaX, deltaY,
 Fi,    // Meridian convergence
 FiPrima, phi,w,U2, tau , usm2, db,
 Ri,    // Cone Radius in paralell i.
 Ui     // UI Magnitud
 : Double;
 i:integer;
Begin
 deltaX := (X-Xo);
 deltaY := (RoYo-Y);
 // Calculate Meridian convergence
 Fi := ArcTan2(deltaX,deltaY);
 // Calculate geodetic longitude.
 L := Lo + Fi/p;
 // In our case the cone radius untill paralell Bi is obtained by
 Ri := Abs(RoYo -Y)/Cos(Fi);
 // Calculate with this UI їїї ???

 Ui := Power(K/Ri, 1/p);
 // And then isometrica latitud on the elipzoid for the expresion
 FiPrima := (ArcTan(Ui)-Pi/4);
 FiPrima := 2 * FiPrima;
  Phi:=FiPrima;
  tau:=1;
 i:=0;
repeat
 inc(i);
 w:=c_.e*Sin(Phi);
 U2:=tan(pi*0.25+Phi*0.5) * power((1-w)/(1+w),0.5*c_.e);
 usm2:=2.0*ARCTAN(U2)-Pi*0.5;
 db:=tau*(FiPrima-Usm2);
 Phi:=Phi+db;
if i>100000 then break;
until ABS(db)<1.e-12;
 B:=Phi;
End;

end.
