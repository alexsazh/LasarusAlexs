unit ST_DATA; INTERFACE
uses otypes;
type
tgpoly = array[0..1023] of tgauss;
  tgline=record n:integer; pol:tgpoly end;
  ptgline=^tgline;
function PointInTGPoly(lp,a,b:tgauss;PL:Ptgline):boolean;

function PointInPoly(lp,a,b:lpoint;PL:Plline):boolean;
function Read_data(var f:file;ntype:word;NN:longint;var v):boolean;
Procedure SETmaxFiles(COUNT:word);
function Write_data(var f:file;ntype:word;NN:longint;var v):boolean;
Procedure Filter_points(PL,PLs:PLLine; tresh:single);

IMPLEMENTATION

function PointInTGPoly(lp,a,b:tgauss;PL:Ptgline):boolean;
 var
   lp1,lp2:tgauss;
   i,nnl,nnr:integer;
   y,dx1,det,x3,x4,xc,tx,ty,t:extended;
   flcr:boolean;
    Begin
      nnl:=0;
      nnr:=0;
     lp1.y:=lp.y; lp2.y:=lp.y;
     lp1.x:=a.x;  lp2.x:=b.x;
     dx1:=(b.x-a.x);
     y:=lp.y;
     for i:=0 to PL^.n-1 do
            with PL^ do if (not (((lp.y>=pol[i].y) and
                                (lp.y>=pol[i+1].y)) or
                                ((lp.y<=pol[i].y) and
                                (lp.y<=pol[i+1].y)))) or
                                 (lp.y=pol[i].y)then begin
       det:= dx1*(pol[i+1].y-pol[i].y);
       if det=0 then continue
        else begin
         x3:=pol[i].x;
         x4:=pol[i+1].x;
         xc:=(y*(x4-x3)-x4*pol[i].y+x3*pol[i+1].y)*(dx1/det);
         if xc=lp.x then begin PointInTgPOLY:=true; exit end;
         flcr:=true;
         if (x3=xc) and (pol[i].y=lp.y) then
         if i=0 then begin
           if ((pol[1].y>pol[0].y) and (pol[0].y>pol[n-1].y)) or
              ((pol[1].y<pol[0].y) and (pol[0].y<pol[n-1].y)) then
                flcr:=false else
           if pol[0].y=pol[n-1].y then
              if ((pol[1].y>pol[0].y) and (pol[0].y>pol[n-2].y)) or
              ((pol[1].y<pol[0].y) and (pol[0].y<pol[n-2].y)) then
                flcr:=false
         end else
           if ((pol[i+1].y>pol[i].y) and (pol[i].y>pol[i-1].y)) or
              ((pol[i+1].y<pol[i].y) and (pol[i].y<pol[i-1].y)) then
                flcr:=false
           else if i=1 then begin
                  if pol[1].y=pol[0].y then
              if ((pol[2].y>pol[1].y) and (pol[1].y>pol[n-1].y)) or
              ((pol[2].y<pol[1].y) and (pol[1].y<pol[n-1].y)) then
                flcr:=false
           end else if pol[i].y=pol[i-1].y then
              if ((pol[i+1].y>pol[i].y) and (pol[i].y>pol[i-2].y)) or
              ((pol[i+1].y<pol[i].y) and (pol[i].y<pol[i-2].y)) then
                flcr:=false;
         if flcr then
         if (xc>=a.x) and (xc<=b.x) then if xc>lp.x then inc(nnr)
                                 else inc(nnl);
       end;
    end;
    PointInTGPOLY:= ((nnl mod 2)=1) and ((nnr mod 2)=1)
end;


function dist(p1,p2,p3:Lpoint):double;
var d1,d2,dx,dy:double;
begin
   dy:=p1.y;     dx:=p1.x;
 d2:= p3.x*dy- p3.y*dx;
 d1:=(dy-p3.y)*p2.x-
     (dx-p3.x)*p2.y-d2;
     dx:=p3.x-p1.x;
     dy:=p3.y-p1.y;
 d2:=sqrt(sqr(dx)+sqr(dy));
 if d2<>0 then dist:=abs(d1)/d2
  else begin
   dx:=p2.x-p1.x;
     dy:=p2.y-p1.y;
   dist:=sqrt(sqr(dx)+sqr(dy))
  end;
end;

Procedure Filter_points(PL,PLs:PLLine; tresh:single);
var
  i,nn:integer;
  d1,d2:double;
  lpp:lpoint;

begin
if PLs^.n<3 then begin
   MOVE(PLs^,PL^,10+8*word(PLS^.n));
   exit
end;
PL^.n:=0;
PL^.pol[0]:=PLs^.pol[0];
nn:=pls^.n;
lpp:=pls^.pol[0];
For i:=0 to nn-3 do with pls^ do begin
d1:=dist(lpp,pol[i+1],pol[i+2]);
if d1>tresh then begin inc(PL^.n); PL^.POL[PL^.n]:=pol[i+1]; lpp:=pol[i+1];
                       continue
                 end;
d2:=dist(pol[i+1],pol[i+2],pol[i+3]);
if d2>tresh then continue;
if d1>d2 then begin inc(PL^.n); PL^.POL[PL^.n]:=pol[i+1]; lpp:=pol[i+1];
                                   continue end;
end;
with pls^ do d1:=dist(pol[nn-2],pol[nn-1],pol[nn]);
if d1>tresh then begin inc(PL^.n); PL^.POL[PL^.n]:=pls^.pol[nn-1]; end;
inc(PL^.n); PL^.POL[PL^.n]:=pls^.pol[nn];
end;

function PointInPoly(lp,a,b:lpoint;PL:Plline):boolean;
 var
   lp1,lp2:lpoint;
   i,nnl,nnr:integer;
   y,dx1,det,x3,x4,xc:double;
   flcr:boolean;
    Begin
      nnl:=0;
      nnr:=0;
     lp1.y:=lp.y; lp2.y:=lp.y;
     lp1.x:=a.x;  lp2.x:=b.x;
     dx1:=b.x-a.x;
     y:=lp.y;
     for i:=0 to PL^.n-1 do
            with PL^ do if (not (((lp.y>=pol[i].y) and
                                (lp.y>=pol[i+1].y)) or
                                ((lp.y<=pol[i].y) and
                                (lp.y<=pol[i+1].y))))
                                or (lp.y=pol[i+1].y)
                                or (lp.y=pol[i].y) then begin
       det:= dx1*(pol[i+1].y-pol[i].y);
       if det=0 then continue
        else begin
         x3:=pol[i].x;
         x4:=pol[i+1].x;
         xc:=dx1*(y*(x4-x3)-x4*pol[i].y+x3*pol[i+1].y)/det;
         if dist(pol[i],lp,pol[i+1])<1 then
          begin PointInPOLY:=true; exit end;
         if round(xc)=lp.x then begin PointInPOLY:=true; exit end;
         flcr:=true;
         if (pol[i].x=round(xc)) and (pol[i].y=lp.y) then
         if i=0 then begin
           if ((pol[1].y>pol[0].y) and (pol[0].y>pol[n-1].y)) or
              ((pol[1].y<pol[0].y) and (pol[0].y<pol[n-1].y)) then
                flcr:=false else
           if pol[0].y=pol[n-1].y then
              if ((pol[1].y>pol[0].y) and (pol[0].y>pol[n-2].y)) or
              ((pol[1].y<pol[0].y) and (pol[0].y<pol[n-2].y)) then
                flcr:=false
         end else
           if ((pol[i+1].y>pol[i].y) and (pol[i].y>pol[i-1].y)) or
              ((pol[i+1].y<pol[i].y) and (pol[i].y<pol[i-1].y)) then
                flcr:=false
           else if i=1 then begin
                  if pol[1].y=pol[0].y then
              if ((pol[2].y>pol[1].y) and (pol[1].y>pol[n-1].y)) or
              ((pol[2].y<pol[1].y) and (pol[1].y<pol[n-1].y)) then
                flcr:=false
           end else if pol[i].y=pol[i-1].y then
              if ((pol[i+1].y>pol[i].y) and (pol[i].y>pol[i-2].y)) or
              ((pol[i+1].y<pol[i].y) and (pol[i].y<pol[i-2].y)) then
                flcr:=false;
          if (pol[i].x=round(xc)) and (pol[i+1].y=lp.y) then
           if ((pol[i+1].y>pol[i].y) and (pol[i].y>pol[i-1].y)) or
              ((pol[i+1].y<pol[i].y) and (pol[i].y<pol[i-1].y)) then
                flcr:=false;
           {else if i=1 then begin
                  if pol[1].y=pol[0].y then
              if ((pol[2].y>pol[1].y) and (pol[1].y>pol[n-1].y)) or
              ((pol[2].y<pol[1].y) and (pol[1].y<pol[n-1].y)) then
                flcr:=false
           end else if pol[i].y=pol[i-1].y then
              if ((pol[i+1].y>pol[i].y) and (pol[i].y>pol[i-2].y)) or
              ((pol[i+1].y<pol[i].y) and (pol[i].y<pol[i-2].y)) then
                flcr:=false;
            }
         if flcr then
         if (xc>=a.x) and (xc<=b.x) then if round(xc)>lp.x then inc(nnr)
                                 else inc(nnl);
       end;
    end;
    PointInPOLY:= ((nnl mod 2)=1) and ((nnr mod 2)=1)
end;

Procedure SETmaxFiles(COUNT:word); assembler;
asm
  MOV AH,67H
  MOV BX,COUNT
  INT 21H
end;
function Read_data(var f:file;ntype:word;NN:longint;var v):boolean;
var      N:integer;
begin
   seek(f,NN);
   BlockRead(f,v,ntype,N);
   Read_data:=N=ntype;
end;
function Write_data(var f:file;ntype:word;NN:longint;var v):boolean;
var      N:integer;
begin
   seek(f,NN);
   BlockWrite(f,v,ntype,N);
   Write_data:=N=ntype;
end;
end.
