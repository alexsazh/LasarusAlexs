unit ZeroFun;
INTERFACE
type
 REALTYPE=extended;
 FUNTYPE=Function(X:REALTYPE):REALTYPE;
 FUNCTION ZeroIn(AX,BX:REALTYPE;
                 F:FUNTYPE;
                 TOL:REALTYPE):REALTYPE;
    IMPLEMENTATION
FUNCTION ZeroIn(AX,BX:REALTYPE;
                 F:FUNTYPE;TOL:REALTYPE):REALTYPE;
var
   A,B,C,D,E,Eps,FA,FB,
   FC,TOL1,XM,P,Q,R,S:REALTYPE;
 label 30,70;
BEGIN
 Eps:=1.; while 1.+Eps/2. <> 1 do Eps:=Eps/2.;
 A:=AX;    B:=BX;
 FA:=F(A); FB:=F(B);
REPEAT
  C:=A;   FC:=FA;
  D:=B-A; E:=D;
30: if abs(FC) < abs(FB) then
   begin
    A:=B;  B:=C;  C:=A;
    FA:=FB; FB:=FC; FC:=FA;
   end;
Tol1:=2.*Eps*abs(B)+Tol/2.;
XM:=(C-B)/2.;
if (abs(XM) <= Tol1) or (FB=0) then
 begin
   ZeroIN:=B;  exit;
 end;
if (abs(E) <Tol1) or (abs(FA) <= abs(FB)) then goto 70
  else
   begin
  if A=C then
   begin
   S:=FB/FA; P:=2.*XM*S;
   Q:=1.-S;
   end
   else
    begin
     Q:=FA/FB; R:=FB/FC;
     S:=FB/FA;
     P:=S*(2.*XM*Q*(Q-R)-(B-A)*(R-1.0));
     Q:=(Q-1.0)*(R-1.0)*(S-1.0)
    end;
    if P > 0 then Q:=-Q;
    P:=abs(P)
    end;
    if (2.*P<3*XM*Q-abs(Tol1)*Q) and (P<abs(E*Q/2.0)) then
     begin
       E:=D;  D:=P/Q
     end
   else
        begin
 70:     D:=XM;  E:=D
        end;
   A:=B;  FA:=FB;
 if abs(D) > Tol1 then B:=B+D
    else
    if XM < 0 then B:=B-abs(Tol1)
  else B:=B+ABS(Tol1);
    FB:=F(B);
 if FB*(FC/abs(FC)) <= 0 then goto 30
     until false
  END;
END.




