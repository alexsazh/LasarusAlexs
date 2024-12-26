UNIT MinFun;
   INTERFACE
{$F+,B+}
uses dialogs;
type
 REALTYPE=double;
 FUNTYPE=Function(X:REALTYPE):REALTYPE;
FUNCTION Fmin(AX,BX:REALTYPE;F:FUNTYPE;
                 TOL:REALTYPE):REALTYPE;
   IMPLEMENTATION
FUNCTION Sign(a,b:RealType):RealType;
 BEGIN if b<0 then Sign:=-abs(a) else Sign:=abs(a)
 END;
FUNCTION Fmin;
var
  A,B,C,D,E,Eps,
    TOL1,Tol2,XM,P,Q,R,U,V,W,
    FU,FV,FW,FX,X:RealType;
label 20,40,50;
BEGIN
 C:=0.5*(3-sqrt(5));
 Eps:=1; while 1+Eps/2 <> 1 do Eps:=Eps/2;
 Eps:=sqrt(Eps);
 A:=AX;   B:=BX;  V:=A+C*(B-A);
 W:=V;    X:=V;
 E:=0;    FX:=F(X);
 FV:=FX;  FW:=FX;
20: XM:=(A+B)/2;
    Tol1:=Eps*abs(X)+Tol/3;
    Tol2:=2*Tol1;
 if abs(X-XM)<=(Tol2-(B-A)/2) then begin
   Fmin:=X; exit
 end;
  if abs(E)<=Tol1 then goto 40;
    R:=(X-W)*(FX-FV);   Q:=(X-V)*(FX-FW);
    P:=(X-V)*Q-(X-W)*R; Q:=2*(Q-R);
  if Q>0 then P:=-P;
    Q:=abs(Q); R:=E; E:=D;
  if (abs(P)>=abs(Q*R/2)) or (P<=Q*(A-X))
      or (P>=Q*(B-X)) then goto 40;
if Q=0 then begin ShowMessage('—бой из-за возможного делени€ на 0'); exit end;
       D:=P/Q;    U:=X+D;
if (U-A<Tol2) or (B-U<Tol2) then D:=Sign(Tol1,XM-X);
     GOTO 50;
40: if X>=XM then E:=A-X else E:=B-X;
    D:=C*E;
50: if abs(D)>=Tol1 then U:=X+D
          else U:=X+Sign(Tol1,D);
          FU:=F(U);
    if FU<=FX THEN
        begin if U>=X then A:=X else B:=X;
           V:=W;   FV:=FW;
           W:=X;  FW:=FX;
           X:=U;  FX:=FU;
          GOTO 20
        end;
    if U<X then A:=U else B:=U;
    if (FU<=FW) or (W=X) then
        begin V:=W;  FV:=FW;
              W:=U;  FW:=FU
        end
           else if (FU<=FV) or (V=X) or (V=W) then
                 begin V:=U;  FV:=FU end;
               goto 20
   END;
END.
