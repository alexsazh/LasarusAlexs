Unit MfrmNavy;
interface

uses SysUtils,windows,dialogs,forms, LazUTF8,
  dmw_ddw,dmw_use,Otypes,Win_use,geoidnw,frnavyfun,blgeo,{xbl,}nevautil;
Function mk_frame:boolean;
Function mk_frame_plan:boolean;
procedure Set_intervals;
procedure Make_grad_labels_on_Katalog;
procedure Kilometr_net;
procedure Make_Shraf_Y(codes:integer;shrd,y,mindivl:double;var Lshraf,a:lpoint);

var
  scaleadd,ascaleadd:double;
  tg:tgauss;
  CENTR,dtg,dtg2:tgauss;
  dx,dy,grad,min:integer;
  i,{nn,}nfin:integer;
  ii:array[0..4] of integer;
  lx,ly:longint;
  scale,kk,fugl:double;
  sec:extended;
  a,b,lp,lp0,lp1:lpoint;
  sgrad,smin:s4;
  ss,s,s1:string;
  usr_dir, dmw_dir:string;
  ww:word;
  fltmp,xxmin,xxmax,yymin,yymax,yy,xx:single;
  Ncurr,nnext:integer;
  pch:Pchar;
  ft:text;
  IYNocopy,IXSost,YbottMax:integer;
  flfirst0,flfirst1,flNocopy,fltopo,flsec:boolean;
implementation
 uses UFrmnavy;
procedure Corr_pointx(dx:double;lp:lpoint; var lpEdge:lpoint);
var
  dsc:double;
begin
 dsc:=(abs(lpedge.x-lp.x)+dx)/abs(lpedge.x-lp.x);
 lpedge.x:=lp.x+round((lpedge.x-lp.x)*dsc);
 lpedge.y:=lp.y+round((lpedge.y-lp.y)*dsc);
end;

procedure Kilometr_net;
var
  Code,CodeTextKM,StrichCode,ld,km:integer;
   t1,t2:_geoid;
   bkmmin,bkmmax:double;
   dd,A1,A2:Extended;

begin
 TL.pol[0].x:=TLfr.pol[0].x;
      TL.pol[0].y:=TLfr.pol[0].y+round(12.5*kf);
      TL.pol[1].x:=TLfr.pol[0].x+round(kf);
      TL.pol[1].y:=TL.pol[0].y;
      TL.pol[2].x:=TLfr.pol[3].x+round(kf);
      TL.pol[2].y:=TLfr.pol[3].y-round(12.5*kf);
      TL.pol[3].x:=TLfr.pol[3].x;
      TL.pol[3].y:=TL.pol[2].y;
      TL.pol[4]:=TL.pol[0];
      TL.n:=4;
      dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then  begin
       Code:=String2code('A0400230');
       ss:='КИЛОМЕТРЫ'
       end
       else begin
       Code:=String2code('A0400231');

       ss:='KILOMETRES';
       end;
       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+round(25*kf);
       b.y:=a.y-round(50*kf);
       a.x:=TLfr.pol[0].x-round(11*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       if FFrame.CboxLang.itemindex=2 then begin
       Code:=String2code('A0400231');

       ss:='KILOMETRES';
       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+round(25*kf);
       b.y:=a.y-round(50*kf);
       a.x:=TLfr.pol[0].x-round(16*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       end;

        t1.b:=0;
       t1.l:=Rcorners[4].y;
       t2.l:=Rcorners[4].y;
       if (Rcorners[4].x<0) and (Rcorners[1].x>0) then begin


       t1.b:=0;
       bkmmin:=Rcorners[4].x;
       bkmmax:=Rcorners[1].x;
       CodeTextKM:=String2Code('A0400620');
       StrichCode:=String2Code('A0100003');
       A1:=Pi;
       ld:=0;
       WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);
       if t2.b<=bkmmin then break;
       dm_R_to_l(t2.b,t2.l,a.x,a.y);
       dec(a.x,round(11.5*kf));
       b.y:=a.y;
       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
          b.x:=a.x-round(3*kf);
          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;


         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         b.x:=a.x-round(2*kf)
       else
         b.x:=a.x-round(kf);

       dm_add_sign(StrichCode,a,b,0,false);

       inc(ld,dkmmindiv);

     end;
       A1:=0;
       ld:=dkmmindiv;
       WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);
       if t2.b>=bkmmax then break;
       dm_R_to_l(t2.b,t2.l,a.x,a.y);
       dec(a.x,round(11.5*kf));
       b.y:=a.y;
       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
          b.x:=a.x-round(3*kf);
          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;


         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         b.x:=a.x-round(2*kf)
       else
         b.x:=a.x-round(kf);

       dm_add_sign(StrichCode,a,b,0,false);

       inc(ld,dkmmindiv);
     end;

       end else begin

       if Rcorners[4].x>=0 then begin
       t2.b:=Rcorners[4].x;

       //dd:=Geoid_Dist(0,Rcorners[4].y,Rcorners[4].x,Rcorners[4].y,azim);
       end else begin
       t2.b:=abs(Rcorners[1].x);

       //dd:=Geoid_Dist(0,Rcorners[4].y,abs(Rcorners[1].x),Rcorners[4].y,azim);

       end;
       Back_p(t1,t2,A1,A2);
       dd:=A2;
       ld:=(trunc(dd/dkmmindiv)+1)*dkmmindiv;
       //if Rcorners[4].x>=0 then
       A1:=0;
       //else
       //A1:=Pi*0.5;

       t1.b:=0;
       t1.l:=Rcorners[4].y;
       if Rcorners[4].x>=0 then begin
         bkmmin:=Rcorners[4].x;
         bkmmax:=Rcorners[1].x
       end else begin
         bkmmin:=abs(Rcorners[1].x);
         bkmmax:=abs(Rcorners[4].x)
       end;
       CodeTextKM:=String2Code('A0400620');
       StrichCode:=String2Code('A0100003');
      WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);
       if abs(t2.b)>=bkmmax then break;

       if abs(t2.b)>bkmmin then begin
       if Rcorners[4].x<0 then t2.b:=-t2.b;

       dm_R_to_l(t2.b,t2.l,a.x,a.y);
       dec(a.x,round(11.5*kf));
       b.y:=a.y;
       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
          b.x:=a.x-round(3*kf);
          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;


         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         b.x:=a.x-round(2*kf)
       else
         b.x:=a.x-round(kf);

       dm_add_sign(StrichCode,a,b,0,false);
       end;
       //if Rcorners[4].x>=0 then

       inc(ld,dkmmindiv);
       //else
       //dec(ld,dkmmindiv);
      end;

     end;
end;

Procedure Miles_net;
var
  ss:shortstring;
  code,CodeTextKM,StrichCode,km,ly,dkm2:integer;
  ld,kabmindiv:double;
  t1,t2: _geoid;
  var A1,s,A2: EXTENDED;
begin
      kabmindiv:=1852;
      dkm2:=10;
      TL.pol[0].x:=TLfr.pol[0].x-round(17.5*kf);
      TL.pol[0].y:=TLfr.pol[0].y+round(12.5*kf);
      TL.pol[1].x:=TLfr.pol[0].x-round(18.5*kf);
      TL.pol[1].y:=TL.pol[0].y;
      TL.pol[2].x:=TLfr.pol[3].x-round(18.5*kf);
      TL.pol[2].y:=TLfr.pol[3].y-round(12.5*kf);
      TL.pol[3].x:=TLfr.pol[3].x-round(17.5*kf);
      TL.pol[3].y:=TL.pol[2].y;
      TL.pol[4]:=TL.pol[0];
      TL.n:=4;
      dm_Add_Poly(String2code('A0100102'),2,0,@TL,false);
      ly:=round(25*kf);
       Code:=String2code('A0100080');

       ss:='МОРСКИЕ';

       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2-ly-round(50*kf);
       b.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2-ly-round(10*kf);
       a.x:=(TLfr.pol[0].x+TLfr.pol[3].x) div 2-round(15.5*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       ss:='МИЛИ';
       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+ly+round(10*kf);
       b.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+ly+round(30*kf);
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       ss:='(1 миля=1852м)';
       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+ly+round(36*kf);
       b.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+ly+round(63*kf);
       add_text(Code,a,b,0,ss,false);
       t1.b:=Rcorners[4].x;
       t1.l:=Rcorners[4].y;
       mCross_BL_XY(t1.B,t1.L,t2.B,t2.L);
       mCross_XY_kvBL(t2.B,t2.L,t2.B,t2.L);
       t2.b:=t2.b+mindiv;
       mCross_kvBL_BL(t2.B,t2.L,t2.B,t2.L);
       Back_p (t1,t2,A1,s);
       CodeTextKM:=String2code('A0100090');
       StrichCode:=String2code('A0100103');
       ld:=0;
       WHILE  true do begin
       Direct (t1,A1,kabmindiv,t2,A2);
       mCross_BL_XY(t2.B,t2.L,t2.B,t2.L);
       mCross_XY_kvBL(t2.B,t2.L,t2.B,t2.L);
       t2.L:=RCKV[1].y;
       mCross_kvBL_BL(t2.B,t2.L,t2.B,t2.L);
       dm_R_to_l(t1.b,t1.l,a.x,a.y);
       if a.y<Pcorn[1].y then break;
       t1:=t2;
       A1:=A2+Pi;

       //A1:=A2+Pi;
       dec(a.x,round(30*kf));
       b.y:=a.y;
       km:=round(ld/kabmindiv);
       if km mod dkm2 =0 then begin
          b.x:=a.x-round(3*kf);
          {
          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;
          }
          ss:=inttostr(km);

         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         b.x:=a.x-round(2*kf)
       else
         b.x:=a.x-round(kf);

       dm_add_sign(StrichCode,a,b,0,false);

       ld:=ld+kabmindiv;
     end;

end;

procedure Make_dolg;
var
  lcode:longint;
  ss:shortstring;
  sgrad,smin,ssec:s4;
  litera:char;
  i:byte;
begin
  lcode:=string2code('A0400330');
  for i:=1 to 4 do begin
     Calc_grad_min_sec_pr(abs(rcorners[i].y),sgrad,smin,ssec);
     if (rcorners[i].y>=0) and (rcorners[i].y<=Pi) then
      litera:='E'
     else
     litera:='W';
     if flsec then
         ss:=sgrad+smin+ssec+litera
      else
         ss:=sgrad+smin+litera;

    case i of
     1,4: kk:=3.3;
     2,3: kk:=-3.3;
    end;
    a.x:=round(pcorn[i].x+kk*kf);
    a.y:=pcorn[i].y;
     case i of
     1,3: begin    Text_Bound(lcode,a,a,R,ss);
            if i=1 then
             a.y:=pcorn[i].y+round(3.5*kf)+R[2].x-R[1].x
            else
             a.y:=pcorn[i].y-round(3.5*kf)-R[2].x+R[1].x;
          end;
     2:  a.y:=round(pcorn[i].y+3.5*kf);
     4:  a.y:=round(pcorn[i].y-3.5*kf);
    end;
     case i of
     1,4: b.y:=a.y-R[2].x+R[1].x;
     2,3: b.y:=a.y+R[2].x-R[1].x;
    end;
    b.x:= a.x;
    Add_Text(lcode,a,b,0,ss,false);
  end
end;
procedure Make_Brt;
var
   ltext:longint;
   ss:shortstring;
   sgrad,smin,ssec:s4;
  i:byte;
  litera:char;
begin
ltext:=String2code('A0400330');
for i:=1 to 4 do begin
    Calc_grad_min_sec_pr(abs(rcorners[i].x),sgrad,smin,ssec);
    if rcorners[i].x>=0 then
      litera:='N'
    else
     litera:='S';
     if flsec then
         ss:=sgrad+smin+ssec+litera
      else
         ss:=sgrad+smin+litera;
    case i of
     1,2: kk:=3.3;
     3,4: kk:=-1.5;
    end;
    a.y:=pcorn[i].y+round(kk*kf);
    if (i=2) or (i=3) then begin
    a.x:=round(pcorn[i].x);
    Text_Bound(ltext,a,a,R,ss);
    a.x:=round(pcorn[i].x-R[2].x+R[1].x-3.5*kf)
    end
    else
    a.x:=round(pcorn[i].x+3.5*kf);
    Add_Text(ltext,a,a,0,ss,false);
  end;
end;
procedure MK_EDGE_Crist;
var
  lcode:longint;
begin
    lcode:=String2Code('P1601020');
    TLTMP.N:=2;
    tltmp.pol[1]:=pcorn[1];
    tltmp.pol[0].x:=round(pcorn[1].x-12.8*kf);
    tltmp.pol[0].y:=pcorn[1].y;
    tltmp.pol[2].y:=round(pcorn[1].y-12.8*kf);
    tltmp.pol[2].x:=pcorn[1].x;
    dm_Add_Poly(lcode,2,0,@TLtmp,false);
    tltmp.pol[1]:=pcorn[2];
    tltmp.pol[0].x:=round(pcorn[2].x+12.8*kf);
    tltmp.pol[0].y:=pcorn[2].y;
   tltmp.pol[2].y:=round(pcorn[2].y-12.8*kf);
    tltmp.pol[2].x:=pcorn[2].x;
    dm_Add_Poly(lcode,2,0,@TLtmp,false);

    tltmp.pol[1]:=pcorn[3];
    tltmp.pol[0].x:=round(pcorn[3].x+12.8*kf);
    tltmp.pol[0].y:=pcorn[3].y;
    tltmp.pol[2].y:=round(pcorn[3].y+12.8*kf);
    tltmp.pol[2].x:=pcorn[3].x;
    dm_Add_Poly(lcode,2,0,@TLtmp,false);


    tltmp.pol[1]:=pcorn[4];
    tltmp.pol[0].x:=round(pcorn[4].x-12.8*kf);
    tltmp.pol[0].y:=pcorn[4].y;
    tltmp.pol[2].y:=round(pcorn[4].y+12.8*kf);
    tltmp.pol[2].x:=pcorn[4].x;
    dm_Add_Poly(lcode,2,0,@TLtmp,false);
end;
procedure MK_EDGE_Link_Crist;
var
  t1,t2:_geoid;
  dist10:double;
  a2:extended;
begin
     dist10:=scale/100;//10*scale/1000; 10 mm

    TLTMP.N:=2;
    tltmp.pol[1]:=pcorn[1];
    t1.b:=corners[1].x;
    t1.l:=corners[1].y;

    Direct (t1,0.5*Pi,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[0].x,tltmp.pol[0].y);
     Direct (t1,Pi,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[2].x,tltmp.pol[2].y);
    dm_Add_Poly(98800200,2,0,@TLtmp,false);

    tltmp.pol[1]:=pcorn[2];
    t1.b:=corners[2].x;
    t1.l:=corners[2].y;

    Direct (t1,1.5*Pi,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[0].x,tltmp.pol[0].y);
     Direct (t1,Pi,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[2].x,tltmp.pol[2].y);
    dm_Add_Poly(98800200,2,0,@TLtmp,false);

    tltmp.pol[1]:=pcorn[3];
    t1.b:=corners[3].x;
    t1.l:=corners[3].y;
    Direct (t1,1.5*Pi,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[0].x,tltmp.pol[0].y);
     Direct (t1,0,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[2].x,tltmp.pol[2].y);
    dm_Add_Poly(98800200,2,0,@TLtmp,false);

    tltmp.pol[1]:=pcorn[4];
    t1.b:=corners[4].x;
    t1.l:=corners[4].y;
    Direct (t1,0.5*Pi,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[0].x,tltmp.pol[0].y);
     Direct (t1,0,dist10,t2,a2);
    dm_R_to_L(t2.b,t2.l,tltmp.pol[2].x,tltmp.pol[2].y);
    dm_Add_Poly(98800200,2,0,@TLtmp,false);
end;

procedure Make_grad_labels;
var nlb,nlb2,nlbnetorig_B,nlbnetorig_L,codes,codet,codeBig,
    codemindiv,codemindiv_blue,lx1,lx2,lnetinterv,lnetintervL:integer;
grad,min,sign,grad2,min2: integer;
dtg,dtg2:tgauss;
a,aa,a2,b,lpc,l0:lpoint;
sec,sec2,kk,dmm,netorgB,netorgL:extended;
ss:shortstring;
flgrad,flfirst,flten, flGradNonEXist:boolean;
bmindiv:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');

  dtg:=Rcorners[4];
  if fframe.ChBNetInterv.checked and (netintb<>0)then begin
     lnetinterv:=round(netintb/mindiv);
  end else begin
  dtg2.x:=dtg.x+Textinterv*kk;
  dtg2.y:=dtg.y;
  dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
  dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(a.y-b.y)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetinterv:=Textinterv
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetinterv:=2*Textinterv
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetinterv:=4*Textinterv
  else lnetinterv:=8*Textinterv;
  end;


  dtg:=Rcorners[1];
  if fframe.ChBNetInterv.checked and (netintL<>0)then begin
     lnetintervL:=round(netintl/mindivL);
  end else begin
  dtg2.x:=dtg.x;
  dtg2.y:=dtg.y+TextintervL*kk;
  dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
  dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(b.x-a.x)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetintervL:=TextintervL
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetintervL:=2*TextintervL
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetintervL:=4*TextintervL
  else lnetintervL:=8*TextintervL;
  end;

    LongtRad_grad(abs(Rcorners[2].y),grad,min,sec);
    grad2:=grad;
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;

    
    flgrad:= Rcorners[1].y<=Sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[1].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[1].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
    flGradNonEXist:=grad=grad2;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if Rcorners[1].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

    with Fframe do
    if ChBNetOrig.Checked then begin
       netorgB:=((abs(strtoint(meNetDB_B.edittext))+strtoint(meNetMB_B.edittext)/60+strtoFloat(meNetSB_B.edittext)/3600)/180*PI);
       netorgL:=((abs(strtoint(meNetDB_L.edittext))+strtoint(meNetMB_L.edittext)/60+strtoFloat(meNetSB_L.edittext)/3600)/180*PI);
       nlbnetorig_B:=round((netorgB-grad/180*pi)/mindiv);
       nlbnetorig_L:=round((netorgL-grad/180*pi)/mindivl);
    end else begin
       nlbnetorig_B:=0;
       nlbnetorig_L:=0;
    end;
       //По долготе
    repeat
     dtg.x:=rcorners[1].x;
     LongtRad_grad(abs(dtg.y),grad,min,sec);

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod BigintervalL = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and
         (a.x>pcorn[1].x+20*kf) and (a.x<pcorn[2].x-20*kf) then l0:=a;
      b.x:=a.x;
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'°';
      Add_Text(codeBig,b,b,0,ss,false);

      end
      else begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      a.y:=a.y-round(11.5*kf);
      b.y:=a.y+round(4.4*kf);
      dm_add_sign(codes,a,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and
         (a.x>pcorn[1].x+20*kf) and (a.x<pcorn[2].x-20*kf) then l0:=a;

      b.x:=a.x;
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then
       if nlb mod textintervL = 0 then begin
       if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
      b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     dtg.x:=rcorners[4].x;
     dtg2:=dtg;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod BigintervalL = 0 then begin
       if ((nlb-nlbnetorig_L) mod lnetintervL=0) and
          (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
        Tl1.pol[0]:=a;
        Tl1.n:=0;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       // dm_add_sign(codes,a,l0,0,false);
       end;
      b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,Inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      {ss:='E';
      Text_Bound(codebig,a,a,R,ss);
      lx3:=R[2].x-R[1].x;
      }
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(4.2*kf);
      Add_Text(codebig,b,b,0,Inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
       flfirst:=false;
      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;

      ss:=Inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(4.2*kf);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(4.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      a.y:=a.y+round(11.5*kf);
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and
          (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
        Tl1.pol[0]:=a;
        Tl1.n:=0;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       // dm_add_sign(codes,a,l0,0,false);
       end;
     b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then
      if nlb mod textintervL = 0 then begin
      if flGradNonEXist and flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;
      flfirst:=false;

      Text_Bound(codebig,a,a,R,Inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(4.2*kf);
      Add_Text(codebig,b,b,0,Inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      end else begin
      if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=tLINT.POL[2].Y-round(4.2*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
      b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*kk*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=Tlint.pol[2].y-round(3.2*kf);
       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin
       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       Text_Bound(codeMinDiv,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       aa.y:=lpc.y;
       {if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y-round(1.2*kf);
       }
       Add_Text(codeMinDiv,aa,aa,0,ss,false);
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.';
       if FFrame.CboxLang.itemindex=1 then begin
        ss:=ss+'=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       end;

       Text_Bound(codeMinDiv_blue,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,aa,aa,0,ss,false);
       end;
      bmindiv:=2;
      end;
      dtg.y:=dtg.y+kk;
      if Rcorners[1].y>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[2].y+0.25*kk<dtg.y;
     kk:=minDiv;
      dtg:=Rcorners[4];
       Rad_grad(abs(Rcorners[1].x),grad,min,sec);
    grad2:=grad;
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
      if Rcorners[1].x>=0 then
    sign:=1
    else
    sign:=-1;

      flgrad:= Rcorners[4].x<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[4].x<=(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcorners[4].x;
    LongtRad_grad(abs(dtg.X),grad,min,sec);
    flGradNonEXist:=grad=grad2;


    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[4].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

    repeat
    dtg.Y:=rcorners[4].Y;
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod Biginterval = 0 then begin
      if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
       end;

      b.Y:=a.Y;
      b.X:=a.X-round(11.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
       end;

      b.y:=a.y;
      b.x:=a.x-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
     // if tmindiv<4 then
      if nlb mod textinterv = 0 then begin
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else begin
      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)+4.2*kf);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      b.x:=a.x-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     dtg2:=dtg;
     dtg.y:=rcorners[2].y;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod Biginterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[3].y-20*kf) and (a.y>pcorn[2].y+20*kf) then begin
        Tl1.pol[0]:=l0;
        Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);
    
    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervL=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       // dm_add_sign(codes,a,l0,0,false);
       end;

      b.y:=a.y;
      b.x:=a.x+round(11.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
     end else if nlb mod interminterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[3].y-20*kf) and (a.y>pcorn[2].y+20*kf) then begin
        Tl1.pol[0]:=l0;
        Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);
    
    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervL=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       // dm_add_sign(codes,a,l0,0,false);
       end;

      b.y:=a.y;
      b.x:=a.x+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then
      if nlb mod textinterv = 0 then begin
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      flfirst:=false;

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x+round(4.2*kf);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      b.x:=a.x+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
       dtg.x:=dtg.x+kk;
        if Rcorners[4].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[1].x+0.25*kk<dtg.x;
end;

procedure Make_Shraf_Y(codes:integer;shrd,y,mindivl:double;var Lshraf,a:lpoint);
 var
    exY:double;
    b:lpoint;
    nlbdiv:integer;
 begin
         if y>Pi+mindivl then
            exY:=y-2*Pi
         else
            exY:=y;

         if exY-mindivl>=0 then
         nlbdiv:=round(abs(exY)/ (ShrafL*mindivl))
         else
         nlbdiv:=round(abs(exY)/ (ShrafL*mindivl))+1;

         if nlbdiv  mod 2 =1 then begin
           lshraf.x:=a.x;
           lshraf.y:=a.y+round(shrd*kf);
         end
         else begin
           if a.x<>lshraf.x then begin
           b.x:=a.x;
           b.y:=a.y+round(shrd*kf);

           dm_add_sign(codes,lshraf,b,0,false);
           end;
           if abs(Pi)>mindivl then
           Lshraf.x:=0;
         end;
end;

procedure Make_grad_labels_on_map;
var nlb,nlb2,nlbdiv,nlbnetorig_L,nlbnetorig_B, TextgradL,Textgrad,
codes,codet,codeBig,codemindiv,codemindiv_blue,lx1,lx2,lnetinterv,lnetintervL:integer;
grad,min,sign,grad2,min2: integer;
dtg,dtg2:tgauss;
a,a2,aa,b,lpc,l0,lshraf1,lshraf2:lpoint;
sec,sec2,kk,dmm,netorgL,netorgB:extended;
ss:shortstring;
flgrad,flfirst,flten,flend,flGradNonEXist:boolean;
bmindiv,bf:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');
with Fframe do begin
  Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext)/3600);
  TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext)/3600);
end;

  dtg:=Rcorners[4];
  if fframe.ChBNetInterv.checked and (netintb<>0)then begin
     lnetinterv:=round(netintb/mindiv);
  end else begin
  dtg2.x:=dtg.x+Textinterv*kk;
  dtg2.y:=dtg.y;
  dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
  dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(a.y-b.y)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetinterv:=Textinterv
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetinterv:=2*Textinterv
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetinterv:=4*Textinterv
  else lnetinterv:=8*Textinterv;
  end;


  dtg:=Rcorners[1];
  if fframe.ChBNetInterv.checked and (netintL<>0)then begin
     lnetintervL:=round(netintl/mindivL);
  end else begin
  dtg2.x:=dtg.x;
  dtg2.y:=dtg.y+TextintervL*kk;
  dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
  dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(b.x-a.x)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetintervL:=TextintervL
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetintervL:=2*TextintervL
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetintervL:=4*TextintervL
  else lnetintervL:=8*TextintervL;
  end;
    Rad_grad(abs(Rcorners[2].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    grad2:=grad;
    flgrad:= Rcorners[1].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[1].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[1].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);

        flGradNonEXist:=grad=grad2;

   if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if Rcorners[1].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

        with Fframe do
    if ChBNetOrig.Checked then begin
      netorgL:=(abs(strtoint(meNetDB_L.edittext))+strtoint(meNetMB_L.edittext)/60+strtoFloat(meNetSB_L.edittext)/3600)/180*PI;
      nlbnetorig_L:=round((netorgL-grad/180*pi)/mindivl);
    end else begin
    nlbnetorig_L:=0;

    end;

    //if dtg.y<0 then nlb:=-nlb;
    bf:=0;
    //По долготе
    repeat
    dtg.x:=rcorners[1].x;
    LongtRad_grad (abs(dtg.y),grad,min,sec);
    
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[2].y-0.25*kk<dtg.y;
    if bf=0 then begin
    lshraf1.x:=a.x;
    lshraf1.y:=a.y-round(1.5*kf);
    end;
    if nlb mod BigintervalL = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[1].x+20*kf) and (a.x<pcorn[2].x-20*kf) then l0:=a;
      b.x:=a.x;
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin

      Text_Bound(codebig,a,a,R,Inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(5.2*kf);
      Add_Text(codebig,b,b,0,Inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
        ss:=Inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y-round(11.5*kf);
      b.y:=aa.y+round(2*kf);
      dm_add_sign(codes,aa,b,0,false);
    end else if nlb mod intermintervall = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[1].x+20*kf) and (a.x<pcorn[2].x-20*kf) then l0:=a;

      b.x:=a.x;
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,Inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.2*kf);
      Add_Text(codebig,b,b,0,Inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else begin
      if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);

     end else begin
      b.x:=a.x;
      if flend or (bf=0) then
        b.y:=a.y-round(2*kf)
      else
        b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
        Make_Shraf_Y(codes,-1.5,dtg.y,mindivl,Lshraf1,a);

     end;
     dtg.x:=rcorners[4].x;
     dtg2:=dtg;
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(1.5*kf);
    bf:=1;
    flend:=true
    end;

    if nlb mod BigintervalL = 0 then begin
       if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
               Tl1.pol[0]:=a;
        Tl1.n:=0;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;
      b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,Inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      if bmindiv=0 then bmindiv:=1;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(3.2*kf);
      Add_Text(codebig,b,b,0,Inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;
      ss:=Inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      if flfirst then begin
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      ss:=ss+'°'+litera
      end
      else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y+round(11.5*kf);
      b.y:=aa.y-round(2*kf);
      dm_add_sign(codes,aa,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin

      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
     Tl1.n:=0;
      Tl1.pol[0]:=a;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;


        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;


      b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
       if flGradNonEXist and flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;
       flfirst:=false;

      Text_Bound(codebig,a,a,R,Inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(4.2*kf);
      Add_Text(codebig,b,b,0,Inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      end else begin

      if flgrad and (min=0) then begin
      if bmindiv=0 then bmindiv:=1;

      ss:=Inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
       if flfirst then begin
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      end else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false;
      end

      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
       if flend or (bf=0) then
        b.y:=a.y+round(2*kf)
      else
        b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
         Make_Shraf_Y(codes,1.5,dtg.y,mindivl,Lshraf2,a);
     end;

      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*kk*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=Tlint.pol[2].y-round(3.2*kf);

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin

       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6: ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10:ss:=ss+'1''';
       11:ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
        Text_Bound(codeMinDiv,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      {if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y-round(1.2*kf);
      }
      Add_Text(codeMinDiv,lpc,lpc,0,ss,false);
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.';
        if FFrame.CboxLang.itemindex=1 then begin
        ss:=ss+'=';
       case tmindiv of
         1: ss:=ss+'0,1"';
         2: ss:=ss+'0,2"';
         3: ss:=ss+'0,5"';
         4: ss:=ss+'1"';
         5: ss:=ss+'2"';
         6: ss:=ss+'3"';
         7: ss:=ss+'6"';
         8: ss:=ss+'12"';
         9: ss:=ss+'30"';
         10:ss:=ss+'1''';
         11:ss:=ss+'2''';
         12:ss:=ss+'5''';
         13:ss:=ss+'10''';
       end;
       end;
       if FFrame.CboxLang.itemindex<>2 then begin
        Text_Bound(codeMinDiv_blue,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      end;
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,lpc,lpc,0,ss,false);
       end;
      bmindiv:=2;
      end;
        if Rcorners[1].y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg.y:=dtg.y+kk;
     until rcorners[2].y+0.25*kk<dtg.y;

      if lshraf1.x<>0 then begin
          dtg.y:=Rcorners[2].y;
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           dtg.x:=Rcorners[1].x;
             dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;


    kk:=minDiv;
    Rad_grad(abs(Rcorners[1].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if Rcorners[1].x>=0 then
      sign:=1
    else
      sign:=-1;
     grad2:=grad;
    flgrad:= Rcorners[4].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
      flten:=Rcorners[4].x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcorners[4].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    flGradNonEXist:=grad=grad2;

    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[4].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

     with Fframe do
    if ChBNetOrig.Checked then begin
      netorgB:=((abs(strtoint(meNetDB_B.edittext))+strtoint(meNetMB_B.edittext)/60+strtoFloat(meNetSB_B.edittext)/3600)/180*PI);
      nlbnetorig_B:=round((netorgB-grad/180*pi)/mindiv);
    end else begin
       nlbnetorig_B:=0;
    end;
    bf:=0;
    //По широте
    repeat
    dtg.Y:=rcorners[4].Y;
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=rcorners[1].x-0.25*kk<dtg.x;

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(1.5*kf);
    end;
    if nlb mod Biginterval = 0 then begin
      if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
      end;
      b.Y:=a.Y;
      b.X:=a.X-round(11.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin
      if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
      end;

      b.y:=a.y;
      b.x:=a.x-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
       if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else begin
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
       if flend or (bf=0) then
        b.x:=a.x-round(2*kf)
      else
      b.x:=a.x-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod Shraf = 0 then begin
         {if ((dtg.x>=0) and (Rcorners[4].x>=0)) or ((dtg.x<=0) and (Rcorners[4].x<=0)) then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);
         }
         if dtg.x-mindiv>=0 then
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf1.y:=a.y;
           lshraf1.x:=a.x-round(1.5*kf);
         end
         else begin
           if lshraf1.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.y:=0;
         end;
     end;
     dtg2:=dtg;
     dtg.y:=rcorners[2].y;
     dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
      if bf=0 then begin

    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(1.5*kf);
    bf:=1;
    flend:=true
    end;

    if nlb mod Biginterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[3].y-20*kf) and (a.y>pcorn[2].y+20*kf) then begin
 Tl1.pol[0]:=l0;
        Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);
   
    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervl=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       // dm_add_sign(codes,a,l0,0,false);
       end;

      b.y:=a.y;
      b.x:=a.x+round(11.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
     end else if nlb mod interminterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and
          (a.y<pcorn[3].y-20*kf) and
          (a.y>pcorn[2].y+20*kf) then begin
             Tl1.pol[0]:=l0;
        Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);
    
    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervl=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;

      b.y:=a.y;
      b.x:=a.x+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
       if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      flfirst:=false;

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      if flend or (bf=0) then
        b.x:=a.x+round(2*kf)
      else
        b.x:=a.x+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      if nlb mod Shraf = 0 then begin

         if dtg.x-mindiv>=0 then
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(1.5*kf);
         end
         else begin
           if lshraf2.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           lshraf2.y:=0;
         end;
     end;

       dtg.x:=dtg.x+kk;
        if Rcorners[4].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[1].x+0.25*kk<dtg.x;
      if lshraf1.y<>0 then begin
          dtg.x:=Rcorners[1].x;
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           dtg.y:=Rcorners[1].y;
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;
end;

procedure Mk_grad_net_on_Polar;
var
  node1,node,i,lBig,lbigL,modI,codes,codet,codeBig, codel,nn,nNext,
  smInterv, smIntervl, offs,minlX,MaxlX,minlY,MaxlY:longint;
  s:shortstring;
  sgrad,smin,ssec:s4;

  yl,kk,yy,dh,dhL,Biginterval,Bigintervall,mindiv,
  rr, rx,ry,mindivl,minX,MaxX,minY,MaxY, rddLine:double;
  lx,lxsm,signrx:longint;
  p,a:lpoint;
  res,flhalf, flGradinterv,fldown,flstrL:boolean;
begin
try
with fFrame do begin
    mindiv:=(strtoint(meUMDM.edittext)/60+strtoFloat(meUMDS.edittext)/3600)/180*PI;
    smInterv:=round(((strtoint(meUSmInD.edittext)+strtoint(meUSmInM.edittext)/60+strtoFloat(meUSmInS.edittext)/3600)/180*PI)/mindiv);
    mindivL:=(strtoint(meUMDM_L.edittext)/60+strtoFloat(meUMDS_L.edittext)/3600)/180*PI;
    smIntervL:=round(((strtoint(meUSmInD_L.edittext)+strtoint(meUSmInM_L.edittext)/60+strtoFloat(meUSmInS_L.edittext)/3600)/180*PI)/mindivL);

   Biginterval:=((strtoint(meUBigIntrD.edittext)+strtoint(meUBigIntrM.edittext)/60+strtoFloat(meUBigIntrS.edittext)/3600)/180*PI);
   BigintervalL:=((strtoint(meUBigIntrD_L.edittext)+strtoint(meUBigIntrM_L.edittext)/60+strtoFloat(meUBigIntrS_L.edittext)/3600)/180*PI);
   lBig:=round(Biginterval/mindiv);
   lBigl:=round(Bigintervall/mindivl);
end;
 flGradinterv:=true;
except

 flGradinterv:=false;
end;
if (Biginterval=0) or (BigintervalL=0) then begin
 flGradinterv:=false;

end;
if not  flGradinterv then
    ShowMessage('Введены некорректные данные в градусную сетку. Будут использованы значения по умолчания');
      //Начало создания сетки WGS 84
    if flGradinterv then begin
      kk:=Bigintervall;
      yy:=mindiv;
    end else begin
    case nomenkl.scale of
  _sc2,_sc5,_sc10:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _sc25:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _scm50:begin kk:=Pi/5400;
           yy:=Pi/54000;
        end;
  _scm100:begin kk:=Pi/2700;
         yy:=Pi/27000;
         end;
  _scm200:begin kk:=Pi/1800;
         yy:=Pi/18000;
         end;
  _scm500:begin kk:=Pi/360;
         yy:=Pi/360;
         end;
   else begin kk:=Pi/180;
         yy:=Pi/180;
         end;

  end;
  smInterv:=1;
//  interminterval:=5;
  end;
    minlX:=1000000000;
  MaxlX:=-1000000000;
  minlY:=1000000000;
  MaxlY:=-1000000000;

    for i:=1 to 4 do begin
     if pcorn[i].x>MaxlX then MaxlX:=pcorn[i].x;
     if pcorn[i].y>Maxly then Maxly:=pcorn[i].y;
     if pcorn[i].x<MinlX then MinlX:=pcorn[i].x;
     if pcorn[i].y<MinlY then MinlY:=pcorn[i].y;
   end;

    MinX:=100;
  for i:=1 to 4 do
    if Rcorners[i].x<MinX then MinX:=Rcorners[i].x;
  codel:=String2code('A0100002');
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  minx:=trunc(minx/Biginterval)*Biginterval;
  Maxx:=((strtoint(FFrame.meMaxDB.edittext)+strtoint(FFrame.meMaxMB.edittext)/60+strtoFloat(FFrame.meMaxSB.edittext)/3600)/180*PI);
  minY:=0;
  MaxY:=2*PI;
  dtg.y:=minY;
  tltmp.n:=1;
  flhalf:=false;

  while maxY{rcorners[2].y}-dtg.y>1e-15 do begin
   {Линии с черточками внутри карты}
    dtg.x:=minx; //rCorners[3].x;
    dm_R_to_L(dtg.x,dtg.y,pl.pol[0].x,pl.pol[0].y);
    pl.n:=0;
    if dtg.y>PI then yl:=abs(dtg.y-2*Pi)
    else
     yl:=abs(dtg.y);
    Calc_grad_min_sec(yl,sgrad,smin,ssec);
    s:=sgrad+smin+ssec;
    i:=0;
    dtg2:=dtg;
    dtg2.y:=dtg2.y-kk/2;
    dtg.x:=minx{rCorners[3].x}+yy;
    fldown:=false;
    node1:=0;
    if round(dtg.y/Bigintervall) mod 2=0 then begin
      dhl:=2;
      flstrL:=true;
    end
    else
    begin
      dhl:=1.2;
      flstrL:=false
    end;
    while Maxx{rcorners[1].x}-dtg.x>1.E-15 do begin
      inc(i);
      dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
      res:= Point_in_Poly(P,@tlmain);
      if res then begin
        inc(pl^.n);
        PL^.pol[PL^.n]:=P;
        if PL^.n=1 then begin
         line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
          Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
        end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

          offs:=dm_Add_Poly(codel,2,0,PL,false);
          {if Node1<>0 then begin
            dm_Move_Object(offs,node1,true);
            dm_Up_Childs(node1);
            dm_goto_node(offs);
            flDown:=false;
            node1:=0;
          end; }
        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;
      if res then
      if i mod lbig<>0 then begin
         modI:=i mod lbig;
         //if modI=interminterval then dh:=2 else
         if (modI mod smInterv)=0 then dh:=2 else
          dh:=1;
         dtg2.x:=dtg.x;
         dtg2.y:=dtg.y+kk;
         dm_R_to_L(dtg2.x,dtg2.y,tltmp.pol[1].x,tltmp.pol[1].y);
         rx:=PL.pol[pl.n].x;
         ry:=PL.pol[pl.n].y;
         rr:=SQRT(SQR(rx-tltmp.pol[1].x)+SQR(ry-tltmp.pol[1].y));
         rx:=(rx-tltmp.pol[1].x)/rr;
         ry:=(ry-tltmp.pol[1].y)/rr;
        if flstrL then begin
         tltmp.pol[0].x:=PL.pol[pl.n].x-round(dh*kf*rx);
         tltmp.pol[0].y:=PL.pol[pl.n].y-round(dh*kf*ry);
         tltmp.pol[1].x:=PL.pol[pl.n].x+round(dh*kf*rx);
         tltmp.pol[1].y:=PL.pol[pl.n].y+round(dh*kf*ry);

        node:=dm_Add_Poly(codel,2,0,@Tltmp,false{fldown});
        if fldown then fldown:=false;
        if node1=0 then begin
          node1:=node;
          fldown:=true;
        end;
        end;
      end;

        dtg.x:=dtg.x+yy;

      if res and (((i mod lbig) = (lbig div 2)) and ((((i div lbig) mod 2=ord(Fframe.ChCrMercL.Checked))))){ and not flhalf) or
                          (((i div lbigl) mod 2=1) and flhalf))) }
                       then begin
         dm_R_to_L(dtg.x,dtg.y,a.x,a.y);

         a.x:=(a.x+PL.pol[Pl.n].x) div 2;
         a.y:=(a.y+PL.pol[pl.n].y) div 2;
         s:=sgrad;
         Text_Bound(codebig,a,a,R,s);
         if ry>0 then signrx:=1 else signrx:=-1;

         if smin='00''' then begin
          lx:=R[2].x-R[1].x;
          a.x:=a.x-round(signrx*(2*kf*rx+0.5*lx*ry));
          a.y:=a.y+round(signrx*(-2*kf*ry+0.5*lx*rx));
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
         end else begin
          lx:=R[2].x-R[1].x;
          Text_Bound(codet,a,a,R,smin);
          lxsm:=R[2].x-R[1].x;
          a.x:=a.x-round(signrx*(2*kf*rx+0.5*lx*ry));
          a.y:=a.y+round(signrx*(-2*kf*ry+0.5*lx*rx));
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
          //dm_set_tag(21);

          a:=b;
          b.x:=a.x+round(signrx*lxsm*ry);
          b.y:=a.y-round(signrx*lxsm*rx);
          Add_Text(codet,a,b,0,smin,false{fldown});

         end;
         //dm_set_tag(21);

      end;

        // Конец создания текстов
    if (i>8000-lbig) and (i mod lbig=0) then begin
        dm_goto_node(offs);

        offs:=dm_Add_Poly(codel,2,0,PL,false);
       { if Node1<>0 then begin
          dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

        end;  }
        PL.pol[0]:=PL.pol[PL.n];
        PL.n:=0;
    end;

    end;

    flhalf:=not flhalf;

    dtg.x:=maxx;//rCorners[1].x;
    dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
    if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         rr:=line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
         if rr<sqr(5*kf) then
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then offs:=dm_Add_Poly(codel,2,0,PL,false);
     {if (Node1<>0) then begin
     dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
    end; }

   dtg.y:=dtg.y+kk;
  end;

  if flGradinterv then begin
      kk:=Biginterval;
      yy:=mindivL;
    end else begin
   case nomenkl.scale of
  _sc2,_sc5,_sc10:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _sc25:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _scm50:begin kk:=Pi/5400;
           yy:=Pi/54000;
        end;
  _scm100:begin kk:=Pi/2700;
         yy:=Pi/27000;
         end;
  _scm200:begin kk:=Pi/1800;
         yy:=Pi/18000;
         end;
  _scm500:begin kk:=Pi/360;
         yy:=Pi/360;
         end;
   else begin kk:=Pi/180;
         yy:=Pi/180;
         end;

  end;
  smIntervL:=1;
  //intermintervalL:=5;

  end;

  dtg.x:=minx;//rCorners[3].x;
  dtg.y:=miny;//rCorners[1].y;

  flhalf:=false;

  while Maxx{rcorners[1].x}-dtg.x>1e-8 do begin
    i:=0;
    PL.n:=0;
    dtg.y:=miny;//rCorners[1].y;
    dm_R_to_L(dtg.x,dtg.y,PL.pol[0].x,PL.pol[0].y);

    dtg.y:=miny{rCorners[1].y}+yy;

    Calc_grad_min_sec(dtg.x,sgrad,smin,ssec);
    Application.ProcessMessages;
    flDown:=false;
    node1:=0;

    while maxy{rcorners[2].y}-dtg.y>1e-15 do begin
      inc(i);
      dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
      res:= Point_in_Poly(P,@tlmain);
      if res then begin
        inc(pl^.n);
        PL^.pol[PL^.n]:=P;
        if PL^.n=1 then begin
         rddLine:=sqr_distance(PL^.pol[0],PL^.pol[1]);
         if Get_line_dist(PL^.pol[0], rddLine,@Tlmain)<rddLine then begin
           line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
           Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
         end;
        end;
      end else begin
        if PL^.N>1 then begin

          rddLine:=sqr_distance(PL^.pol[PL^.N],PL^.pol[PL^.N-1]);
         if Get_line_dist(PL^.pol[PL^.N], rddLine,@Tlmain)<rddLine then begin

          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
         end;
          offs:=dm_Add_Poly(codel,2,0,PL,false);
        {if (Node1<>0) then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
        flDown:=false;
        node1:=0;
        end;
        }
        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;

      if res then
      if i mod lbigl<>0 then begin
         modI:=i mod lbigl;
         //if modI=intermintervall then dh:=2 else
         if (modI mod smIntervl) =0 then dh:=2 else
          dh:=1;
         dtg2.x:=dtg.x+kk;
         dtg2.y:=dtg.y;
         dm_R_to_L(dtg2.x,dtg2.y,tltmp.pol[1].x,tltmp.pol[1].y);
         rx:=PL.pol[pl.n].x;
         ry:=PL.pol[pl.n].y;
         rr:=SQRT(SQR(rx-tltmp.pol[1].x)+SQR(ry-tltmp.pol[1].y));
         rx:=(rx-tltmp.pol[1].x)/rr;
         ry:=(ry-tltmp.pol[1].y)/rr;
       if round(dtg.x/Biginterval) mod 2=0 then begin

         tltmp.pol[0].x:=PL.pol[pl.n].x-round(dh*kf*rx);
         tltmp.pol[0].y:=PL.pol[pl.n].y-round(dh*kf*ry);
         tltmp.pol[1].x:=PL.pol[pl.n].x+round(dh*kf*rx);
         tltmp.pol[1].y:=PL.pol[pl.n].y+round(dh*kf*ry);
         node:=dm_Add_Poly(codel,2,0,@Tltmp,false {fldown});
        if fldown then fldown:=false;
        if Node1=0 then begin
        node1:=Node;
        fldown:=true;
        end;
     end;
      end;

      dtg.y:=dtg.y+yy;
        // Создание текстов

      if res and (((i mod lbigl)=(lbigl div 2)) and ((((i div lbigl) mod 2=ord(not fframe.ChCrMercB.Checked))))) {and not flhalf) or
                          (((i div lbigl) mod 2=1) and flhalf)))} then begin

        dm_R_to_L(dtg.x,dtg.y,a.x,a.y);

         a.x:=(a.x+PL.pol[Pl.n].x) div 2;
         a.y:=(a.y+PL.pol[pl.n].y) div 2;
         s:=sgrad;
         Text_Bound(codebig,a,a,R,s);
         lx:=R[2].x-R[1].x;

         if ry>0 then signrx:=1 else signrx:=-1;

         if smin='00''' then begin
          a.x:=a.x-round(signrx*0.5*lx*ry);
          a.y:=a.y+round(signrx*0.5*lx*rx);
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
         end else begin
          Text_Bound(codet,a,a,R,smin);
          lxsm:=R[2].x-R[1].x;
          a.x:=a.x-round(signrx*0.5*(lx+lxsm)*ry);
          a.y:=a.y+round(signrx*0.5*(lx+lxsm)*rx);
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
          dm_set_tag(21);

          a:=b;
          b.x:=a.x+round(signrx*lxsm*ry);
          b.y:=a.y-round(signrx*lxsm*rx);
          Add_Text(codet,a,b,0,smin,false{fldown});

         end;
         dm_set_tag(21);

      end;

         // Конец создания текстов
      if (pl.n>8000-lbigl) and (i mod lbigl=0) then begin
        dm_goto_node(offs);
        if pl.n>0 then
        offs:=dm_Add_Poly(codel,2,0,PL,false);
        {if node1<>0 then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);
        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

        end;
        }
        PL.pol[0]:=PL.pol[PL.n];
        Pl.n:=0;
      end;


    end;
    flhalf:=not flhalf;
    dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
    if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      rddLine:=sqr_distance(PL^.pol[PL^.N],PL^.pol[PL^.N-1]);
      if Get_line_dist(PL^.pol[PL^.N], rddLine,@Tlmain)<rddLine then begin

         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@TlMain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@TlMain,nn,Nnext);
      end
    end else  begin
      rddLine:=sqr_distance(PL^.pol[PL^.N],PL^.pol[PL^.N-1]);
      if Get_line_dist(PL^.pol[PL^.N], rddLine,@Tlmain)<rddLine then begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
        Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
       end;
   end;
     if PL^.n>1 then offs:=dm_Add_Poly(codel,2,0,PL,false);
      {
      if node1<>0 then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);
        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

      end;
      }
    dtg.x:=dtg.x+kk;

  end;
end;

procedure Mk_grad_net_on_SlantStereo;
var
  node1,node,i,modI,codes,codet,codeBig, codel,nn,nNext,codemindiv,codemindiv_blue,
  nlbdiv,grad2,Textgrad,TextgradL,sign,{smInterv,intermInterval,smIntervl,intermIntervall,} offs,minlX,MaxlX,minlY,MaxlY:longint;
  ss,s:shortstring;
  sgrad,smin,ssec:s4;
  tg:tgauss;
  yl,kk,yy,dh,dhL,{Biginterval,Bigintervall,mindiv, }
  rr, rx,ry,{nlbnetorig_L,mindivl,}minX,MaxX,minY,MaxY:double;
  nlb,lx,lx1,lx2,lxsm,signrx:longint;
  p,a,lp,lshraf1,lshraf2,lpc:lpoint;
  flend,flfirst,flGradNonEXist,res,flhalf, flten,flgrad,flGradinterv,fldown,flstrL:boolean;
  bmindiv,bf:byte;
  litera:char;
begin
  codel:=String2code('A0100002');
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');
with Fframe do begin
  Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext)/3600);
  TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext)/3600);
end;
flGradinterv:=true;
if (Biginterval=0) or (BigintervalL=0) then begin
 flGradinterv:=false;

end;
if not  flGradinterv then
    ShowMessage('Введены некорректные данные в градусную сетку. Будут использованы значения по умолчания');
      //Начало создания сетки WGS 84
    if flGradinterv then begin
      kk:=Bigintervall*mindivl;
      yy:=mindiv;
    end else begin
    case nomenkl.scale of
  _sc2,_sc5,_sc10:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _sc25:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _scm50:begin kk:=Pi/5400;
           yy:=Pi/54000;
        end;
  _scm100:begin kk:=Pi/2700;
         yy:=Pi/27000;
         end;
  _scm200:begin kk:=Pi/1800;
         yy:=Pi/18000;
         end;
  _scm500:begin kk:=Pi/360;
         yy:=Pi/360;
         end;
   else begin kk:=Pi/180;
         yy:=Pi/180;
         end;

  end;
  smInterv:=1;
  interminterval:=5;
  end;
    minlX:=1000000000;
  MaxlX:=-1000000000;
  minlY:=1000000000;
  MaxlY:=-1000000000;

    for i:=1 to 4 do begin
     if pcorn[i].x>MaxlX then MaxlX:=pcorn[i].x;
     if pcorn[i].y>Maxly then Maxly:=pcorn[i].y;
     if pcorn[i].x<MinlX then MinlX:=pcorn[i].x;
     if pcorn[i].y<MinlY then MinlY:=pcorn[i].y;
   end;
   Maxx:=-100;
    MinX:=100;
    Maxy:=-100;
    Miny:=100;

  for i:=1 to 4 do begin
    if Rcorners[i].x<MinX then MinX:=Rcorners[i].x;
    if Rcorners[i].x>MaxX then MaxX:=Rcorners[i].x;
    if Rcorners[i].y<Miny then Miny:=Rcorners[i].y;
    if Rcorners[i].y>Maxy then Maxy:=Rcorners[i].y;
  end;
  lp.x:=(pcorn[1].x+pcorn[2].x) div 2;
  lp.y:=pcorn[1].y;
  dm_l_to_R(lp.x,lp.y,tg.x,tg.y);
    if tg.x<MinX then MinX:=tg.x;
    if tg.x>MaxX then MaxX:=tg.x;
    if tg.y<Miny then Miny:=tg.y;
    if tg.y>Maxy then Maxy:=tg.y;

  lp.x:=(pcorn[3].x+pcorn[4].x) div 2;
  lp.y:=pcorn[3].y;
  dm_l_to_R(lp.x,lp.y,tg.x,tg.y);
    if tg.x<MinX then MinX:=tg.x;
    if tg.x>MaxX then MaxX:=tg.x;
    if tg.y<Miny then Miny:=tg.y;
    if tg.y>Maxy then Maxy:=tg.y;

  minx:=trunc(minx/(Biginterval*mindiv))*Biginterval*mindiv;
  miny:=trunc(miny/(Bigintervall*mindivl))*Bigintervall*mindivl;
  tltmp.n:=1;
  flhalf:=false;
  dtg.y:=miny;
  while maxY{rcorners[2].y}-dtg.y>1e-15 do begin
   {Линии с черточками внутри карты}
    dtg.x:=minx; //rCorners[3].x;
    dm_R_to_L(dtg.x,dtg.y,pl.pol[0].x,pl.pol[0].y);
    pl.n:=0;
    if dtg.y>PI then yl:=abs(dtg.y-2*Pi);
    Calc_grad_min_sec(dtg.y,sgrad,smin,ssec);
    s:=sgrad+smin+ssec;
    i:=0;
    dtg2:=dtg;
    dtg2.y:=dtg2.y-kk/2;
    dtg.x:=minx{rCorners[3].x}+yy;
    fldown:=false;
    node1:=0;
    if round(dtg.y/(Bigintervall*mindivl)) mod 2=0 then begin
      dhl:=2;
      flstrL:=true;
    end
    else
    begin
      dhl:=1.2;
      flstrL:=false
    end;
    while Maxx{rcorners[1].x}-dtg.x>1.E-15 do begin
      inc(i);
      dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
      res:= Point_in_Poly(P,@tlmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

          offs:=dm_Add_Poly(codel,2,0,PL,false);
        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;
      if res then
      if i mod Biginterval<>0 then begin
         modI:=i mod Biginterval;
         if modI=interminterval then dh:=3 else
         if (modI mod smInterv)=0 then dh:=2 else
          dh:=1;
         dtg2.x:=dtg.x;
         dtg2.y:=dtg.y+kk;
         dm_R_to_L(dtg2.x,dtg2.y,tltmp.pol[1].x,tltmp.pol[1].y);
         rx:=PL.pol[pl.n].x;
         ry:=PL.pol[pl.n].y;
         rr:=SQRT(SQR(rx-tltmp.pol[1].x)+SQR(ry-tltmp.pol[1].y));
         rx:=(rx-tltmp.pol[1].x)/rr;
         ry:=(ry-tltmp.pol[1].y)/rr;
        if flstrL then begin
         tltmp.pol[0].x:=PL.pol[pl.n].x-round(dh*kf*rx);
         tltmp.pol[0].y:=PL.pol[pl.n].y-round(dh*kf*ry);
         tltmp.pol[1].x:=PL.pol[pl.n].x+round(dh*kf*rx);
         tltmp.pol[1].y:=PL.pol[pl.n].y+round(dh*kf*ry);

        node:=dm_Add_Poly(codel,2,0,@Tltmp,false{fldown});
        if fldown then fldown:=false;
        if node1=0 then begin
          node1:=node;
          fldown:=true;
        end;
        end;
      end;

        dtg.x:=dtg.x+yy;
      (*
      if res and (((i mod lbig) = (lbig div 2)) and ((((i div lbig) mod 2=ord(Fframe.ChCrMercL.Checked))))){ and not flhalf) or
                          (((i div lbigl) mod 2=1) and flhalf))) }
                       then begin
         dm_R_to_L(dtg.x,dtg.y,a.x,a.y);

         a.x:=(a.x+PL.pol[Pl.n].x) div 2;
         a.y:=(a.y+PL.pol[pl.n].y) div 2;
         s:=sgrad;
         Text_Bound(codebig,a,a,R,s);
         if ry>0 then signrx:=1 else signrx:=-1;

         if smin='00''' then begin
          lx:=R[2].x-R[1].x;
          a.x:=a.x-round(signrx*(2*kf*rx+0.5*lx*ry));
          a.y:=a.y+round(signrx*(-2*kf*ry+0.5*lx*rx));
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
         end else begin
          lx:=R[2].x-R[1].x;
          Text_Bound(codet,a,a,R,smin);
          lxsm:=R[2].x-R[1].x;
          a.x:=a.x-round(signrx*(2*kf*rx+0.5*lx*ry));
          a.y:=a.y+round(signrx*(-2*kf*ry+0.5*lx*rx));
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
          //dm_set_tag(21);

          a:=b;
          b.x:=a.x+round(signrx*lxsm*ry);
          b.y:=a.y-round(signrx*lxsm*rx);
          Add_Text(codet,a,b,0,smin,false{fldown});

         end;
         //dm_set_tag(21);

      end;
      *)
        // Конец создания текстов
    if (i>8000-Biginterval) and (i mod Biginterval=0) then begin
        dm_goto_node(offs);

        offs:=dm_Add_Poly(codel,2,0,PL,false);
       { if Node1<>0 then begin
          dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

        end;  }
        PL.pol[0]:=PL.pol[PL.n];
        PL.n:=0;
    end;

    end;

    flhalf:=not flhalf;

    dtg.x:=maxx;//rCorners[1].x;
    dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
    if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then offs:=dm_Add_Poly(codel,2,0,PL,false);
     {if (Node1<>0) then begin
     dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
    end; }

   dtg.y:=dtg.y+kk;
  end;


    LongtRad_grad(abs(Rcorners[2].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    grad2:=grad;
    flgrad:= Rcorners[1].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[1].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[1].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);

        flGradNonEXist:=grad=grad2;

   if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if Rcorners[1].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

    {with Fframe do
    if ChBNetOrig.Checked then begin
      netorgL:=(abs(strtoint(meNetDB_L.edittext))+strtoint(meNetMB_L.edittext)/60+strtoFloat(meNetSB_L.edittext)/3600)/180*PI;
      nlbnetorig_L:=round((netorgL-grad/180*pi)/mindivl);
    end else begin

    nlbnetorig_L:=0;
        end;
    }
    //if dtg.y<0 then nlb:=-nlb;
    bf:=0;
    //По долготе
    dtg.x:=rcorners[1].x;
    lshraf1.x:=0;
    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);
    
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[2].y-0.25*mindivl<dtg.y;

    if bf=0 then begin
    lshraf1.x:=a.x;
    lshraf1.y:=a.y-round(0.5*kf);
    bf:=1;
    end;
    if nlb mod BigintervalL = 0 then begin
      dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(rx*kf);
      b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(5.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
    end else if nlb mod intermintervall = 0 then begin
      dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(rx*kf);
      b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      end else begin
      if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod smintervL = 0 then begin
     dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(rx*kf);
      b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);

     end;
     if nlb mod ShrafL = 0 then begin
         Make_Shraf_Y(codes,-0.5,dtg.y,mindivl,Lshraf1,a);
     end;
       if Rcorners[1].y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivL;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.y:=pcorn[1].y;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg.y+mindivL;
      dtg.x:=dtg2.x;
     until rcorners[2].y+0.25*mindivL<dtg.y;

     if lshraf1.x<>0 then begin
           dtg:=Rcorners[2];
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y-round(0.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;

   // Конец верхних текстов


    LongtRad_grad(abs(Rcorners[3].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    grad2:=grad;
    flgrad:= Rcorners[4].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[4].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[4].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);

        flGradNonEXist:=grad=grad2;

   if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if Rcorners[4].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

    bf:=0;
     dtg.x:=rcorners[4].x;
    lshraf2.x:=0;
    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);
   
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[3].y-0.25*mindivl<dtg.y;
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(0.5*kf);
    bf:=1;
    end;

    if nlb mod BigintervalL = 0 then begin

     dtg2.x:=dtg.x-mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(rx*kf);
      b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);

 if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      if bmindiv=0 then bmindiv:=1;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(3.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      if flfirst then begin
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      ss:=ss+'°'+litera
      end
      else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end else if nlb mod intermintervalL = 0 then begin
      dtg2.x:=dtg.x-mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(rx*kf);
      b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
 if nlb mod textintervL = 0 then
       if flGradNonEXist and flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;
       flfirst:=false;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(4.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      end else begin

      if flgrad and (min=0) then begin
      if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
       if flfirst then begin
       if (dtg.y>=0) and (dtg.y<=Pi)then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      end else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false;
      end

      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end;
    end else if nlb mod smintervL = 0 then begin
     dtg2.x:=dtg.x-mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(rx*kf);
      b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
end;
     if nlb mod ShrafL = 0 then begin

        Make_Shraf_Y(codes,0.5,dtg.y,mindivl,Lshraf2,a);
         
     end;

      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*mindivl*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=Tlint.pol[2].y-round(3.2*kf);

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin

       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6: ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10:ss:=ss+'1''';
       11:ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
        Text_Bound(codeMinDiv,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      {if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y-round(1.2*kf);
      }
      Add_Text(codeMinDiv,lpc,lpc,0,ss,false);
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.';
        if FFrame.CboxLang.itemindex=1 then begin
        ss:=ss+'=';
       case tmindiv of
         1: ss:=ss+'0,1"';
         2: ss:=ss+'0,2"';
         3: ss:=ss+'0,5"';
         4: ss:=ss+'1"';
         5: ss:=ss+'2"';
         6: ss:=ss+'3"';
         7: ss:=ss+'6"';
         8: ss:=ss+'12"';
         9: ss:=ss+'30"';
         10:ss:=ss+'1''';
         11:ss:=ss+'2''';
         12:ss:=ss+'5''';
         13:ss:=ss+'10''';
       end;
       end;
       if FFrame.CboxLang.itemindex<>2 then begin
        Text_Bound(codeMinDiv_blue,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      end;
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,lpc,lpc,0,ss,false);
       end;
      bmindiv:=2;
      end;
        if Rcorners[4].y>=0 then
      inc(nlb)
      else
      dec(nlb);
      dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivL;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.y:=pcorn[4].y;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg.y+mindivL;
      dtg.x:=dtg2.x;
  until rcorners[3].y+0.25*mindivl<dtg.y;

     if lshraf2.x<>0 then begin
          dtg:=Rcorners[3];
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y+round(0.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
     end;

  //Конец расчетов по долготе

  if flGradinterv then begin
      kk:=Biginterval*mindiv;
      yy:=mindivL;
    end else begin
   case nomenkl.scale of
  _sc2,_sc5,_sc10:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _sc25:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _scm50:begin kk:=Pi/5400;
           yy:=Pi/54000;
        end;
  _scm100:begin kk:=Pi/2700;
         yy:=Pi/27000;
         end;
  _scm200:begin kk:=Pi/1800;
         yy:=Pi/18000;
         end;
  _scm500:begin kk:=Pi/360;
         yy:=Pi/360;
         end;
   else begin kk:=Pi/180;
         yy:=Pi/180;
         end;

  end;
  smIntervL:=1;
  intermintervalL:=5;

  end;

  dtg.x:=minx;//rCorners[3].x;

  flhalf:=false;

  while Maxx{rcorners[1].x}-dtg.x>1e-8 do begin
    i:=0;
    PL.n:=0;
    dtg.y:=miny;//rCorners[1].y;
    dm_R_to_L(dtg.x,dtg.y,PL.pol[0].x,PL.pol[0].y);

    dtg.y:=miny{rCorners[1].y}+yy;
    Calc_grad_min_sec(dtg.x,sgrad,smin,ssec);
    Application.ProcessMessages;
    flDown:=false;
    node1:=0;
    flstrL:=round(dtg.x/(Biginterval*mindiv)) mod 2=0;
    while maxy{rcorners[2].y}-dtg.y>1e-15 do begin
      inc(i);
      dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
      res:= Point_in_Poly(P,@tlmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

          offs:=dm_Add_Poly(codel,2,0,PL,false);
        {if (Node1<>0) then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
        flDown:=false;
        node1:=0;
        end;
        }
        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;

      if res then
      if i mod BigIntervalL<>0 then begin
         modI:=i mod BigIntervalL;
         if modI=intermintervall then dh:=3 else
         if (modI mod smIntervl) =0 then dh:=2 else
          dh:=1;
         dtg2.x:=dtg.x+kk;
         dtg2.y:=dtg.y;
         dm_R_to_L(dtg2.x,dtg2.y,tltmp.pol[1].x,tltmp.pol[1].y);
         rx:=PL.pol[pl.n].x;
         ry:=PL.pol[pl.n].y;
         rr:=SQRT(SQR(rx-tltmp.pol[1].x)+SQR(ry-tltmp.pol[1].y));
         rx:=(rx-tltmp.pol[1].x)/rr;
         ry:=(ry-tltmp.pol[1].y)/rr;
       if flstrL then begin

         tltmp.pol[0].x:=PL.pol[pl.n].x-round(dh*kf*rx);
         tltmp.pol[0].y:=PL.pol[pl.n].y-round(dh*kf*ry);
         tltmp.pol[1].x:=PL.pol[pl.n].x+round(dh*kf*rx);
         tltmp.pol[1].y:=PL.pol[pl.n].y+round(dh*kf*ry);
         node:=dm_Add_Poly(codel,2,0,@Tltmp,false {fldown});
        if fldown then fldown:=false;
        if Node1=0 then begin
        node1:=Node;
        fldown:=true;
        end;
     end;
      end;

      dtg.y:=dtg.y+yy;
        // Создание текстов

      if res and (((i mod BigIntervalL)=smIntervl) and ((((i div BigIntervalL) mod 2=ord(not fframe.ChCrMercB.Checked))))) {and not flhalf) or
                          (((i div lbigl) mod 2=1) and flhalf)))} then begin

        dm_R_to_L(dtg.x,dtg.y,a.x,a.y);

         a.x:=(a.x+PL.pol[Pl.n].x) div 2;
         a.y:=(a.y+PL.pol[pl.n].y) div 2;
         s:=sgrad;
         Text_Bound(codebig,a,a,R,s);
         lx:=R[2].x-R[1].x;

         if ry>0 then signrx:=1 else signrx:=-1;

         if smin='00''' then begin
          a.x:=a.x-round(signrx*0.5*lx*ry);
          a.y:=a.y+round(-kf+signrx*0.5*lx*rx);
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
         end else begin
          Text_Bound(codet,a,a,R,smin);
          lxsm:=R[2].x-R[1].x;
          a.x:=a.x-round(signrx*0.5*(lx+lxsm)*ry);
          a.y:=a.y+round(-kf+signrx*0.5*(lx+lxsm)*rx);
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
          //dm_set_tag(21);

          a:=b;
          b.x:=a.x+round(signrx*lxsm*ry);
          b.y:=a.y-round(signrx*lxsm*rx);
          Add_Text(codet,a,b,0,smin,false{fldown});

         end;
         //dm_set_tag(21);

      end;

         // Конец создания текстов
      if (i>8000-BigIntervalL) and (i mod BigIntervalL=0) then begin
        dm_goto_node(offs);
        offs:=dm_Add_Poly(codel,2,0,PL,false);
        {if node1<>0 then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);
        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

        end;
        }
        PL.pol[0]:=PL.pol[PL.n];
        Pl.n:=0;
      end;


    end;
    flhalf:=not flhalf;
    dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
    if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@TlMain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@TlMain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then offs:=dm_Add_Poly(codel,2,0,PL,false);
      {
      if node1<>0 then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);
        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

      end;
      }
    dtg.x:=dtg.x+kk;
  end;

  //Создание градусной разметки широт
    Rad_grad(abs(Rcorners[1].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if Rcorners[1].x>=0 then
      sign:=1
    else
      sign:=-1;
     grad2:=grad;
    flgrad:= Rcorners[4].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
      flten:=Rcorners[4].x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcorners[4].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    flGradNonEXist:=grad=grad2;

    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[4].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

    { with Fframe do
    if ChBNetOrig.Checked then begin
      netorgB:=((abs(strtoint(meNetDB_B.edittext))+strtoint(meNetMB_B.edittext)/60+strtoFloat(meNetSB_B.edittext)/3600)/180*PI);
      nlbnetorig_B:=round((netorgB-grad/180*pi)/mindiv);
    end else begin

       nlbnetorig_B:=0;
    end;
    }
    bf:=0;
    //По широте
    dtg.Y:=rcorners[4].Y;
    lshraf1.y:=0;
    repeat
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=rcorners[1].x-0.25*kk<dtg.x;

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(0.5*kf);
    bf:=1;
    end;
    if nlb mod Biginterval = 0 then begin
      dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;

      b.x:=a.x-round(kf);
      b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
   {
   if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      }
      end else if nlb mod interminterval = 0 then begin
           dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;

      b.x:=a.x-round(kf);
      b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
  {
  if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else begin
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    }
    end else if nlb mod sminterv = 0 then begin
           dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;

      b.x:=a.x-round(kf);
      b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
end;
     if nlb mod Shraf = 0 then begin
         if dtg.x-mindiv>=0 then
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf1.y:=a.y;
           lshraf1.x:=a.x-round(0.5*kf);
         end
         else begin
           if lshraf1.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x-round(0.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.y:=0;
         end;
     end;
      dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.x:=pcorn[4].x;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg2.y;
      dtg.x:=dtg.x+mindiv;
        if Rcorners[4].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[1].x+0.25*mindiv<dtg.x;

     if lshraf1.y<>0 then begin
           dtg:=rcorners[1];
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x-round(0.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;



      Rad_grad(abs(Rcorners[2].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if Rcorners[2].x>=0 then
      sign:=1
    else
      sign:=-1;
     grad2:=grad;
    flgrad:= Rcorners[3].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
      flten:=Rcorners[3].x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcorners[3].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    flGradNonEXist:=grad=grad2;

    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[3].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

    { with Fframe do
    if ChBNetOrig.Checked then begin
      netorgB:=((abs(strtoint(meNetDB_B.edittext))+strtoint(meNetMB_B.edittext)/60+strtoFloat(meNetSB_B.edittext)/3600)/180*PI);
      nlbnetorig_B:=round((netorgB-grad/180*pi)/mindiv);
    end else begin

       nlbnetorig_B:=0;
    end;
    }
    bf:=0;
    //По широте
    dtg.Y:=rcorners[3].Y;
    lshraf2.x:=0;
    repeat
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=rcorners[2].x-0.25*mindiv<dtg.x;

    if bf=0 then begin
    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(0.5*kf);
    bf:=1;
    end;

    if nlb mod Biginterval = 0 then begin
          dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        b.x:=a.x+round(kf);
        b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
   {
  if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
     }
     end else if nlb mod interminterval = 0 then begin

         dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        b.x:=a.x+round(kf);
        b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
     {if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      flfirst:=false;

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
      }
    end else if nlb mod sminterv = 0 then begin
          dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        b.x:=a.x+round(kf);
        b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
  end; if nlb mod Shraf = 0 then begin

         if dtg.x-mindiv>=0 then
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(0.5*kf);
         end
         else begin
           if lshraf2.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x+round(0.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           lshraf2.x:=0;
         end;
     end;

       dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.x:=pcorn[3].x;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg2.y;
      dtg.x:=dtg.x+mindiv;
       if Rcorners[3].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[2].x+0.25*mindiv<dtg.x;
      if lshraf2.x<>0 then begin
          dtg.x:=Rcorners[2].x;
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x+round(0.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
      end;
end;

Procedure KV_to_l(kvB,kvL:double; var x,y:integer);
begin
 mCross_kvBL_XY(kvB,kvL,kvB,kvL);
 dm_G_to_l(kvB,kvL,x,y);
end;

procedure Make_grad_labels_on_KVAZI;
var
nlb,nlb2,nlbdiv,nlbnetorig_L,nlbnetorig_B, TextgradL,Textgrad,
codeL,codes,codet,codeBig,codeKV,codemindiv,codemindiv_blue,lx1,lx2,lnetinterv,lnetintervL:integer;
grad,min,sign,grad2,min2: integer;
dtg,dtg2:tgauss;
a,a2,b,l0,lshraf1,lshraf2:lpoint;
sec,sec2,kk,dmm,netorgL,netorgB:extended;
sgrad,Smin:shortstring;
flgrad,flfirst,flten,flend,flGradNonEXist:boolean;
bmindiv,bf:byte;
grsign:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;
  codeL:=String2code('A0100102');
  codes:=String2Code('A0100103');
  codet:=String2Code('A0100050');
  codeBig:=String2Code('A0100060');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');
  codeKV:=String2Code('A0100030');

with Fframe do begin
  Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext)/3600);
  TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext)/3600);
end;

  dtg:=RcKV[4];
  if fframe.ChBNetInterv.checked and (netintb<>0)then begin
     lnetinterv:=round(netintb/mindiv);
  end else begin
  dtg2.x:=dtg.x+Textinterv*kk;
  dtg2.y:=dtg.y;
  kv_to_l(dtg.x,dtg.y,a.x,a.y);
  kv_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(a.y-b.y)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetinterv:=Textinterv
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetinterv:=2*Textinterv
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetinterv:=4*Textinterv
  else lnetinterv:=8*Textinterv;
  netintb:=lnetinterv*mindiv
  end;


  dtg:=RcKV[1];
  if fframe.ChBNetInterv.checked and (netintL<>0)then begin
     lnetintervL:=round(netintl/mindivL);
  end else begin
  dtg2.x:=dtg.x;
  dtg2.y:=dtg.y+TextintervL*kk;
  kv_to_l(dtg.x,dtg.y,a.x,a.y);
  kv_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(b.x-a.x)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetintervL:=TextintervL
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetintervL:=2*TextintervL
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetintervL:=4*TextintervL
  else lnetintervL:=8*TextintervL;
    netintl:=lnetintervl*mindivL

  end;
    LongtRad_grad(abs(RcKV[2].y),grad,min,sec);
    if RcKV[2].y>=0 then sign:=1 else sign:=-1;
    grad2:=grad;
    flgrad:= RcKV[1].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=RcKV[1].y<=sign*(grad+min/60)/180*pi;
    end;
    // Создание текста Квазидолготы

    dtg.y:=(RcKV[1].y+RcKV[2].y)*0.5;
    dtg.y:=trunc(dtg.y/netintl)*netintl+netintl*0.5;
    dtg.x:=RcKV[4].x;
    kv_to_l(dtg.x,dtg.y,a.x,a.y);
    a.y:=a.y+round(8.3*kf);
    b.y:=a.y;
    b.x:=a.x+round(41*kf);
    a.x:=a.x-round(41*kf);
    add_text(codeKV,a,b,0,'Квазидолготы',false);
    dm_set_tag(4);

    dtg.x:=RcKV[1].x;
    kv_to_l(dtg.x,dtg.y,a.x,a.y);
    a.y:=a.y-round(6*kf);
    b.y:=a.y;
    b.x:=a.x+round(41*kf);
    a.x:=a.x-round(41*kf);
    add_text(codeKV,a,b,0,'Квазидолготы',false);
    dm_set_tag(4);

    flfirst:=true;
    bmindiv:=0;
    dtg.y:=RcKV[1].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);

        flGradNonEXist:=grad=grad2;

   if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if RcKV[1].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

        with Fframe do
    if ChBNetOrig.Checked then begin
      netorgL:=(abs(strtoint(meNetDB_L.edittext))+strtoint(meNetMB_L.edittext)/60+strtoFloat(meNetSB_L.edittext)/3600)/180*PI;
      nlbnetorig_L:=round((netorgL-grad/180*pi)/mindivl);
    end else begin
    nlbnetorig_L:=0;

    end;

    //if dtg.y<0 then nlb:=-nlb;
    bf:=0;
    //По долготе

    repeat
    dtg.x:=RcKV[1].x;
    LongtRad_grad (abs(dtg.y),grad,min,sec);
    if dtg.y>0 then grSign:='+' else grSign:='-';
   
    kv_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=RcKV[2].y-0.25*kk<dtg.y;
    if bf=0 then begin
    lshraf1.x:=a.x;
    lshraf1.y:=a.y-round(1.5*kf);
    end;
    if nlb mod BigintervalL = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[1].x+20*kf) and (a.x<pcorn[2].x-20*kf) then l0:=a;
      b.x:=a.x;
      b.y:=a.y-round(2*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      Sgrad:=grSign+inttostr(grad)+'°';
      Text_Bound(codebig,a,a,R,Sgrad);
      lx1:=R[2].x-R[1].x;
      Smin:=inttostr(min)+'''';
      Text_Bound(codet,a,a,R,Smin);
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(5.2*kf);
      Add_Text(codebig,b,b,0,Sgrad,false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,Smin,false);


      end else if flgrad and (min=0) then begin
        Sgrad:=grSign+inttostr(grad);
        Text_Bound(codeBig,a,a,R,sgrad);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        sgrad:=sgrad+'°';
        Add_Text(codeBig,b,b,0,sgrad,false);
      end
      else begin
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
      {b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y-round(11.5*kf);
      b.y:=aa.y+round(2*kf);
      dm_add_sign(codes,aa,b,0,false);
      }
    end else if nlb mod intermintervall = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[1].x+20*kf) and (a.x<pcorn[2].x-20*kf) then l0:=a;

      b.x:=a.x;
      b.y:=a.y-round(2*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;
      Sgrad:=grSign+inttostr(grad)+'°';
      Text_Bound(codebig,a,a,R,Sgrad);
      lx1:=R[2].x-R[1].x;
      Smin:=inttostr(min)+'''';
      Text_Bound(codet,a,a,R,Smin);
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.2*kf);
      Add_Text(codebig,b,b,0,Sgrad,false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,Smin,false);
      end else begin
      if flgrad and (min=0) then begin
        sgrad:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,sgrad);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        sgrad:=sgrad+'°';
        Add_Text(codeBig,b,b,0,sgrad,false);
      end
      else begin
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);

     end else begin
      b.x:=a.x;
      if flend or (bf=0) then
        b.y:=a.y-round(2*kf)
      else
        b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
           Make_Shraf_Y(codes,-1.5,dtg.y,mindivl,Lshraf1,a);
     end;
     dtg.x:=RcKV[4].x;
     dtg2:=dtg;
    kv_to_l(dtg.x,dtg.y,a.x,a.y);
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(1.5*kf);
    bf:=1;
    flend:=true
    end;

    if nlb mod BigintervalL = 0 then begin
       if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
               Tl1.pol[0]:=a;
        Tl1.n:=0;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);

    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<RcKV[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         kv_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;

        dm_Add_Poly(codeL,2,0,@TL1,false);

       end;
      b.x:=a.x;
      b.y:=a.y+round(2*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      Sgrad:=grSign+inttostr(grad)+'°';
      Text_Bound(codebig,a,a,R,Sgrad);
      lx1:=R[2].x-R[1].x;
      if bmindiv=0 then bmindiv:=1;
      Smin:=inttostr(min)+'''';
      Text_Bound(codet,a,a,R,Smin);
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(3.2*kf);
      Add_Text(codebig,b,b,0,sgrad,false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,smin,false);
      inc(b.x,lx2);
      { if dtg.y>=0 then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      }
      flfirst:=false;
      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;
      Sgrad:=grSign+inttostr(grad);
      Text_Bound(codeBig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      {if flfirst then begin
      if dtg.y>=0 then
        litera:='E'
      else
        litera:='W';
      ss:=ss+'°'+litera
      end
      else
      }
      sgrad:=sgrad+'°';

      Add_Text(codeBig,b,b,0,sgrad,false);
      flfirst:=false
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
      {b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y+round(11.5*kf);
      b.y:=aa.y-round(2*kf);
      dm_add_sign(codes,aa,b,0,false);
      }
    end else if nlb mod intermintervalL = 0 then begin

      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
     Tl1.n:=0;
      Tl1.pol[0]:=a;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<RcKV[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         kv_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;


        dm_Add_Poly(codeL,2,0,@TL1,false);

       end;


      b.x:=a.x;
      b.y:=a.y+round(2*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
       if flGradNonEXist and flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;
       flfirst:=false;
      Sgrad:=grSign+inttostr(grad)+'°';
      Text_Bound(codebig,a,a,R,Sgrad);
      lx1:=R[2].x-R[1].x;
      Smin:=inttostr(min)+'''';
      Text_Bound(codet,a,a,R,Smin);
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(4.2*kf);
      Add_Text(codebig,b,b,0,sgrad,false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,smin,false);
      inc(b.x,lx2);
      end else begin

      if flgrad and (min=0) then begin
      if bmindiv=0 then bmindiv:=1;
       Sgrad:=grSign+inttostr(grad);
      Text_Bound(codeBig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
       {if flfirst then begin
       if dtg.y>=0 then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      end else
      }
      sgrad:=sgrad+'°';

      Add_Text(codeBig,b,b,0,sgrad,false);
      flfirst:=false;
      end

      else begin
        if bmindiv=0 then bmindiv:=1;
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
    end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
       if flend or (bf=0) then
        b.y:=a.y+round(2*kf)
      else
        b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
         Make_Shraf_Y(codes,1.5,dtg.y,mindivl,Lshraf2,a);

     end;

      if bmindiv=1 then begin
     (*   dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*kk*textintervL;

        kv_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=Tlint.pol[2].y-round(3.2*kf);

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin

       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6: ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10:ss:=ss+'1''';
       11:ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
        Text_Bound(codeMinDiv,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      Add_Text(codeMinDiv,lpc,lpc,0,ss,false);
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.';
        if FFrame.CboxLang.itemindex=1 then begin
        ss:=ss+'=';
       case tmindiv of
         1: ss:=ss+'0,1"';
         2: ss:=ss+'0,2"';
         3: ss:=ss+'0,5"';
         4: ss:=ss+'1"';
         5: ss:=ss+'2"';
         6: ss:=ss+'3"';
         7: ss:=ss+'6"';
         8: ss:=ss+'12"';
         9: ss:=ss+'30"';
         10:ss:=ss+'1''';
         11:ss:=ss+'2''';
         12:ss:=ss+'5''';
         13:ss:=ss+'10''';
       end;
       end;
       if FFrame.CboxLang.itemindex<>2 then begin
        Text_Bound(codeMinDiv_blue,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      end;
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,lpc,lpc,0,ss,false);
       end;
       *)
      bmindiv:=2;
      end;
        if RcKV[1].y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg.y:=dtg.y+kk;
     until RcKV[2].y+0.25*kk<dtg.y;

      if lshraf1.x<>0 then begin
          dtg.y:=RcKV[2].y;
          kv_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           dtg.x:=RcKV[1].x;
             kv_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;
  kk:=minDiv;
     Rad_grad(abs(RcKV[1].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if RcKV[1].x>=0 then
      sign:=1
    else
      sign:=-1;
     grad2:=grad;
    flgrad:= RcKV[4].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
      flten:=RcKV[4].x<=sign*(grad+min/60)/180*pi;
    end;
    // Создание текста Квазишироты

    dtg.x:=(RcKV[3].x+RcKV[2].x)*0.5;
    dtg.x:=trunc(dtg.x/netintb)*netintb+netintb*0.5;
    dtg.y:=RcKV[2].y;
    kv_to_l(dtg.x,dtg.y,a.x,a.y);
    a.x:=a.x+round(5.6*kf);
    b.y:=a.y+round(40*kf);
    a.y:=a.y-round(40*kf);
    b.x:=a.x;
    add_text(codeKV,a,b,0,'Квазишироты',false);
    dm_set_tag(4);

    dtg.y:=RcKV[1].y;
    kv_to_l(dtg.x,dtg.y,a.x,a.y);
    a.x:=a.x-round(5.6*kf);
    b.y:=a.y-round(40*kf);
    a.y:=a.y+round(40*kf);
    b.x:=a.x;
    add_text(codeKV,a,b,0,'Квазишироты',false);
    dm_set_tag(4);

    flfirst:=true;

    dtg.x:=RcKV[4].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    flGradNonEXist:=grad=grad2;

    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if RcKV[4].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

     with Fframe do
    if ChBNetOrig.Checked then begin
      netorgB:=((abs(strtoint(meNetDB_B.edittext))+strtoint(meNetMB_B.edittext)/60+strtoFloat(meNetSB_B.edittext)/3600)/180*PI);
      nlbnetorig_B:=round((netorgB-grad/180*pi)/mindiv);
    end else begin
       nlbnetorig_B:=0;
    end;
    bf:=0;
    //По широте
    repeat
    dtg.Y:=RcKV[4].Y;
    Rad_grad (abs(dtg.X),grad,min,sec);
    if dtg.X>0 then grSign:='+' else grSign:='-';

    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    kv_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=RcKV[1].x-0.25*kk<dtg.x;

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(1.5*kf);
    end;
    if nlb mod Biginterval = 0 then begin
      if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
      end;
      b.Y:=a.Y;
      b.X:=a.X-round(2*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      sGrad:=grSign+inttostr(grad);
      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(2.8*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);

      end else if flgrad and (min=0) then begin
      sGrad:=grSign+inttostr(grad);

      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.5*kf);
      //b.y:=a.y-round(0.6*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      end else begin
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      //b.y:=a.y-round(0.6*kf);
       b.y:=a.y+round(1.1*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
      end else if nlb mod interminterval = 0 then begin
      if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
      end;

      b.y:=a.y;
      b.x:=a.x-round(2*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      sgrad:=grSign+inttostr(grad);
      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      sMin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);

      end else begin
      if flgrad and (min=0) then begin
      sgrad:=grSign+inttostr(grad);
      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.5*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      end else begin
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
       if flend or (bf=0) then
        b.x:=a.x-round(2*kf)
      else
      b.x:=a.x-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod Shraf = 0 then begin
         {if ((dtg.x>=0) and (RcKV[4].x>=0)) or ((dtg.x<=0) and (RcKV[4].x<=0)) then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);
         }
         if dtg.x-mindiv>=0 then
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf1.y:=a.y;
           lshraf1.x:=a.x-round(1.5*kf);
         end
         else begin
           if lshraf1.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.y:=0;
         end;
     end;
     dtg2:=dtg;
     dtg.y:=RcKV[2].y;
     kv_to_l(dtg.x,dtg.y,a.x,a.y);
      if bf=0 then begin

    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(1.5*kf);
    bf:=1;
    flend:=true
    end;

    if nlb mod Biginterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[3].y-20*kf) and (a.y>pcorn[2].y+20*kf) then begin
 Tl1.pol[0]:=l0;
        Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);
   
    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<RcKV[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervl=0) then begin
         inc(Tl1.n);
         kv_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(codeL,2,0,@TL1,false);

       // dm_add_sign(codes,a,l0,0,false);
       end;

      b.y:=a.y;
      b.x:=a.x+round(2*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      sgrad:=grSign+inttostr(grad);
      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(2.8*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      sgrad:=grSign+inttostr(grad);
      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y+round(1.5*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      end else begin
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y+round(1.1*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
     end else if nlb mod interminterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and
          (a.y<pcorn[3].y-20*kf) and
          (a.y>pcorn[2].y+20*kf) then begin
             Tl1.pol[0]:=l0;
        Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);

    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<RcKV[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervl=0) then begin
         inc(Tl1.n);
         kv_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(codeL,2,0,@TL1,false);

       end;

      b.y:=a.y;
      b.x:=a.x+round(2*kf);
      dm_add_sign(codes,a,b,0,false);
       if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      flfirst:=false;

      sgrad:=grSign+inttostr(grad);
      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);

      b.y:=a.y+round(2.8*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      flfirst:=false;
      end else begin
      if flgrad and (min=0) then begin
      sgrad:=grSign+inttostr(grad);
      Text_Bound(codebig,a,a,R,sgrad);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(1.5*kf);
      sgrad:=sgrad+'°';
      Add_Text(codebig,b,b,0,sgrad,false);

      end else begin
      smin:=inttostr(min);
      Text_Bound(codet,a,a,R,smin);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y+round(1.1*kf);
      smin:=smin+'''';
      Add_Text(codet,b,b,0,smin,false);
      end;
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      if flend or (bf=0) then
        b.x:=a.x+round(2*kf)
      else
        b.x:=a.x+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      if nlb mod Shraf = 0 then begin

         if dtg.x-mindiv>=0 then
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(1.5*kf);
         end
         else begin
           if lshraf2.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           lshraf2.y:=0;
         end;
     end;

       dtg.x:=dtg.x+kk;
        if RcKV[4].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until RcKV[1].x+0.25*kk<dtg.x;
      if lshraf1.y<>0 then begin
          dtg.x:=RcKV[1].x;
          kv_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           dtg.y:=RcKV[1].y;
           kv_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;
end;

Procedure Mk_grad_labels_on_Polar;
var
  b1,l1,l2,Bmin,Bmax:extended;
 i,nn,codes,codet,codeBig,codemindiv,
 codemindiv_blue,lnetinterv,lnetintervL:integer;
  bl:_geoid;
  P:lpoint;
  nNext:integer;
  res:boolean;
begin
  Bmin:=100;
  for i:=1 to 4 do
    if Rcorners[i].x<Bmin then Bmin:=Rcorners[i].x;
  kk:=minDivL;
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');

  lnetinterv:=round( PolarnetintB/mindiv);
  lnetintervL:=round(PolarnetintB/mindivL);
  Bmax:=((strtoint(FFrame.meMaxDB.edittext)+strtoint(FFrame.meMaxMB.edittext)/60+strtoFloat(FFrame.meMaxSB.edittext)/3600)/180*PI);
  b1:=(trunc(bmin/ PolarnetintB))* PolarnetintB;
  TL1.n:=1;
  while b1< Bmax do begin
     l1:=0;
     l2:=2*Pi;
     bl.b:=b1;
     bl.l:=l1;
     Pl^.n:=0;
     dm_R_to_l(bl.b,bl.l,Pl^.pol[0].x,Pl^.pol[0].y);
     while l1<l2 do begin
      bl.l:=l1;
     dm_R_to_l(bl.b,bl.l,P.x,P.y);

     res:= Point_in_Poly(P,@tlmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

          dm_Add_Poly(String2code('A0100002'),2,0,PL,false);

        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;
      l1:=l1+mindivl;
     end;
      bl.l:=l2;
     dm_R_to_l(bl.b,bl.l,P.x,P.y);
      if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then dm_Add_Poly(String2code('A0100002'),2,0,PL,false);

    b1:=b1+PolarnetintB;
   end;

     l1:=0;
     l2:=2*Pi;
    while l1<L2 do begin
     bl.b:=Bmin;
     B1:=Bmin;

     bl.l:=l1;
     dm_R_to_l(bl.b,bl.l,PL^.pol[0].x,PL^.pol[0].y);
      while b1<bmax do begin
      bl.b:=b1;
     dm_R_to_l(bl.b,bl.l,P.x,P.y);

     res:= Point_in_Poly(P,@tlmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

          dm_Add_Poly(String2code('A0100002'),2,0,PL,false);

        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;
      b1:=b1+mindiv;
     end;
      bl.b:=bmax;
     dm_R_to_l(bl.b,bl.l,P.x,P.y);
      if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@TlMain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@TlMain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then dm_Add_Poly(String2code('A0100002'),2,0,PL,false);

       l1:=l1+PolarnetintL
    end;


end;

procedure Make_grad_labels_on_Katalog;
var Textgrad,TextgradL,Shrafgrad,Shrafgradl,nlb,nlb2,nlbdiv,nlbnetorig_L,nlbnetorig_B,
codeshraf,codes,codet,codeBig,lx1,lx2,lnetinterv:integer;
grad,min,sign,grad2,min2: integer;
dtg,dtg2:tgauss;
a,a2,aa,b,l0,lshraf1,lshraf2:lpoint;
sec,sec2,kk,dmm,netorgL,netorgB:extended;
ss:shortstring;
flgrad,flfirst,flten,flend:boolean;
bmindiv,bf,bfstr:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;
   codes:=String2Code('A0100003');
  codeshraf:=String2Code('A0100004');
  codet:=String2Code('Z1100080');
  codeBig:=String2Code('Z1100070');
  with Fframe do begin
    Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext)/3600);
    TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext)/3600);
  end;
  Shrafgrad:=round(Shraf*mindiv/PI*180);
  Shrafgradl:=round(Shrafl*mindivl/PI*180);
  dtg:=Rcorners[1];
  if fframe.ChBNetInterv.checked and (netintL<>0)then begin
    lnetinterv:=round(netintl/mindivL);
  end else begin
    dtg2.x:=dtg.x;
    dtg2.y:=dtg.y+TextintervL*kk;
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
    dmm:=(b.x-a.x)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetinterv:=TextintervL
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetinterv:=2*TextintervL
  else if (dmm*4>=100) and (dmm*4<=200) then
      lnetinterv:=4*TextintervL
  else lnetinterv:=8*TextintervL;
 end;

    Rad_grad(abs(Rcorners[2].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    flgrad:= Rcorners[1].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[1].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[1].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
    if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;
    {if (2*ShrafGradl) >= textgradL then
      if dtg.y>=0 then
      grad:=(grad div (2*ShrafGradl)) *2*ShrafGradl
      else
      grad:=(grad div (2*ShrafGradl)) *2*ShrafGradl+ShrafGradl;
    }
    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);

    if Rcorners[1].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

        with Fframe do
    if ChBNetOrig.Checked then begin
     netorgL:=(abs(strtoint(meNetDB_L.edittext))+strtoint(meNetMB_L.edittext)/60+strtoFloat(meNetSB_L.edittext)/3600)/180*PI;
     nlbnetorig_L:=round((netorgL-grad/180*pi)/mindivl);
    end else begin
     nlbnetorig_L:=0;
    end;


    bf:=0;
    bfstr:=0;
    //По долготе
    repeat
    dtg.x:=rcorners[1].x;
    LongtRad_grad (abs(dtg.y),grad,min,sec);
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[2].y-0.25*kk<dtg.y;
    if (ShrafL<>0) AND (bf=0) then begin
      lshraf1.x:=a.x;
      lshraf1.y:=a.y-round(0.3*kf);
    end;
    if nlb mod BigintervalL = 0 then begin
      if nlb=nlbnetorig_L  then l0:=a;
      if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y)then
        aa:=a
      else begin
        aa.x:=a.x;
        aa.y:=a.y-round(0.6*kf);
      end;
      b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(2.3*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
    end else if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(2.3*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(2.3*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      {aa.x:=a.x;
      aa.y:=a.y-round(11.5*kf);
      b.y:=a.y+round(4.4*kf);
      dm_add_sign(codes,aa,b,0,false);
      }
    end else if nlb mod intermintervall = 0 then begin
      if nlb=nlbnetorig_L then l0:=a;
      if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y) then
        aa:=a
      else begin
      aa.x:=a.x;
      aa.y:=a.y-round(0.6*kf);
      end;
      b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(2.3*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(2.3*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
     if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y) then
         aa:=a
      else begin

     aa.x:=a.x;
     aa.y:=a.y-round(0.6*kf);
     end;
     b.x:=a.x;
      b.y:=a.y-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);

     end else begin
      if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y) then
        aa:=a
      else begin

     aa.x:=a.x;
      aa.y:=a.y-round(0.6*kf);
      end;
      b.x:=a.x;
        b.y:=a.y-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
     if (ShrafL<>0) AND (nlb mod ShrafL = 0) then begin
         {if ((dtg.y>=0) and (Rcorners[1].y>=0)) or ((dtg.y<=0) and (Rcorners[1].y<=0)) then
         nlbdiv:=abs(nlb div ShrafL)
         else
         nlbdiv:=abs(nlb div ShrafL+1);
         }
         if dtg.y-mindivl>=0 then
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))
         else
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))+1;

         if nlbdiv  mod 2 =1 then begin
           lshraf1.x:=a.x;
           lshraf1.y:=a.y-round(0.3*kf);
         end
         else begin
           if (Lshraf1.x<>-999999999) and (a.x<>lshraf1.x) then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf1;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y-round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)

           //dm_add_sign(codes,lshraf1,b,0,false);
           end;
           Lshraf1.x:=-999999999;
         end;
     end;
     dtg.x:=rcorners[4].x;
     dtg2:=dtg;
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(0.3*kf);
    bf:=1;
    flend:=true
    end;

    if nlb mod BigintervalL = 0 then begin
       if nlb=nlbnetorig_L  then begin
               Tl1.pol[0]:=a;
        Tl1.n:=0;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;
    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);
        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;
      if bmindiv=0 then bmindiv:=1;
       if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y) then
       aa:=a
      else begin

      aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);
      end;
      b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=Tlint.pol[2].y-round(1.5*kf);
       Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(1.5*kf);
      if flfirst then begin
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      ss:=ss+'°'+litera
      end
      else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(1.5*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      end else if nlb mod intermintervalL = 0 then begin

    if nlb=nlbnetorig_L then begin
       Tl1.n:=0;
       Tl1.pol[0]:=a;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;


        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;

      if bmindiv=0 then bmindiv:=1;
      if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y) then
        aa:=a
      else begin
      aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);
      end;
      b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(1.5*kf);
       if flfirst then begin
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      end else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false;
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(1.5*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
     if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y) then
        aa:=a
      else begin

     aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);
      end;
     b.x:=a.x;
      b.y:=a.y+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end else begin
     if (bfstr=0) or (rcorners[2].y-0.25*kk<dtg.y) then
        aa:=a
      else begin
      aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);
      end;
      b.x:=a.x;
        b.y:=a.y+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
     if (ShrafL<>0) AND (nlb mod ShrafL = 0 ) then begin
          {if ((dtg.y>=0) and (Rcorners[1].y>=0)) or ((dtg.y<=0) and (Rcorners[1].y<=0)) then
          nlbdiv:= abs(nlb div ShrafL)
          else
          nlbdiv:= abs(nlb div ShrafL+1);
         }
         if dtg.y-mindivl>=0 then
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))
         else
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.x:=a.x;
           lshraf2.y:=a.y+round(0.3*kf);
         end
         else begin
           if (Lshraf2.x<>-999999999) and (lshraf2.x<>a.x) then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf2;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y+round(0.3*kf);

           dm_add_Poly(CodeShraf,2,0,PL,false)

           //dm_add_sign(codes,lshraf2,b,0,false);
           end;
           Lshraf2.x:=-999999999
         end;
     end;

      if bmindiv=1 then
         bmindiv:=2;

      if Rcorners[1].y>=0 then
        inc(nlb)
      else
        dec(nlb);
      dtg.y:=dtg.y+kk;
      bfstr:=1;
     until rcorners[2].y+0.25*kk<dtg.y;

      if (ShrafL<>0) AND (lshraf1.x<>-999999999)  then begin
          dtg.y:=Rcorners[2].y;
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
          if lshraf2.x<>a.x then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf2;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y+round(0.3*kf);

           dm_add_Poly(CodeShraf,2,0,PL,false)

           //dm_add_sign(codes,lshraf2,b,0,false);
           end;
           dtg.x:=Rcorners[1].x;
             dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           if lshraf1.x<>a.x then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf1;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y-round(0.3*kf);

           dm_add_Poly(CodeShraf,2,0,PL,false)

           //dm_add_sign(codes,lshraf1,b,0,false);
           end;
     end;
  kk:=minDiv;
  dtg:=Rcorners[4];
  if fframe.ChBNetInterv.checked and (netintb<>0)then begin
     lnetinterv:=round(netintb/mindiv);
  end else begin
  dtg2.x:=dtg.x+Textinterv*kk;
  dtg2.y:=dtg.y;
  dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
  dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(a.y-b.y)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetinterv:=Textinterv
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetinterv:=2*Textinterv
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetinterv:=4*Textinterv
  else
     lnetinterv:=8*Textinterv;
  end;
     Rad_grad(abs(Rcorners[1].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if Rcorners[1].x>=0 then
      sign:=1
    else
      sign:=-1;
    flgrad:= Rcorners[4].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
      flten:=Rcorners[4].x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcorners[4].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;
    {
    if (2*Shrafgrad) >= textgrad then
    if dtg.X>=0 then
      grad:=(grad div (2*Shrafgrad)) *2*Shrafgrad
     else
       grad:=(grad div (2*Shrafgrad)) *2*Shrafgrad+Shrafgrad;
    }
    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[4].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

     with Fframe do
    if ChBNetOrig.Checked then begin
      netorgB:=((abs(strtoint(meNetDB_B.edittext))+strtoint(meNetMB_B.edittext)/60+strtoFloat(meNetSB_B.edittext)/3600)/180*PI);
      nlbnetorig_B:=round((netorgB-grad/180*pi)/mindiv);
    end else begin
       nlbnetorig_B:=0;
    end;
    bf:=0;
    bfstr:=0;
    //По широте
    repeat
    dtg.Y:=rcorners[4].Y;
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=rcorners[1].x-0.25*kk<dtg.x;

    if (Shraf<>0) and (bf=0) then begin
      lshraf1.y:=a.y;
      lshraf1.x:=a.x-round(0.3*kf);
    end;
    if nlb mod Biginterval = 0 then begin
      if nlb=nlbnetorig_B  then begin
        l0:=a
      end;
      if (bfstr=0) or (rcorners[1].x-0.25*kk<dtg.x) then
        aa:=a
      else begin

      aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);
      end;
      b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      b.y:=a.y+round(2.0*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin
      if nlb=nlbnetorig_B then begin
        l0:=a
      end;
      if (bfstr=0)or(rcorners[1].x-0.25*kk<dtg.x) then
        aa:=a
      else begin
      aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);
      end;
      b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
      if (bfstr=0)or(rcorners[1].x-0.25*kk<dtg.x) then
        aa:=a
      else begin
      aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);
      end;
      b.y:=a.y;
      b.x:=a.x-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end else begin
      if (bfstr=0)or(rcorners[1].x-0.25*kk<dtg.x) then
        aa:=a
      else begin
      aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);
      end;
      b.y:=a.y;
        b.x:=a.x-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
     if (Shraf<>0) AND (nlb mod Shraf = 0) then begin
         {if ((dtg.x>=0) and (Rcorners[4].x>=0)) or ((dtg.x<=0) and (Rcorners[4].x<=0)) then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);
         }
         if dtg.x-mindiv>=0 then
          nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
           else
          nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;
         if nlbdiv mod 2 =1 then begin
           lshraf1.y:=a.y;
           lshraf1.x:=a.x-round(0.3*kf);
         end
         else begin
           if (Lshraf1.y<>-999999999) and (lshraf1.y<>a.y) then begin
               PL^.n:=1;
           PL^.pol[0]:=lshraf1;
           PL^.pol[1].y:=a.y;
           PL^.pol[1].x:=a.x-round(0.3*kf);

           dm_add_Poly(CodeShraf,2,0,PL,false)

           //dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.y:=-999999999
         end;
     end;
     dtg2:=dtg;
     dtg.y:=rcorners[2].y;
     dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     if bf=0 then begin

    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(0.3*kf);
    bf:=1;
    flend:=true
    end;

    if nlb mod Biginterval = 0 then begin
       if nlb=nlbnetorig_B then begin
         Tl1.pol[0]:=l0;
          Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);

    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       // dm_add_sign(codes,a,l0,0,false);
       end;
      if (bfstr=0)or(rcorners[1].x-0.25*kk<dtg.x) then
        aa:=a
      else begin
        aa.y:=a.y;
        aa.x:=a.x+round(0.6*kf);
      end;
      b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad and
         ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      //Text_Bound(codebig,a,a,R,ss);
      //b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      b.x:=a.x+round(2.4*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      //Text_Bound(codet,a,a,R,ss);
      //b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      b.x:=a.x+round(2.4*KF);

      b.y:=a.y+round(2.0*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        //Text_Bound(codebig,a,a,R,ss);
        //b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
        b.x:=a.x+round(2.4*KF);

        b.y:=a.y+round(0.9*kf);
        ss:=ss+'°';
        Add_Text(codebig,b,b,0,ss,false);
      end else begin
        ss:=inttostr(min);
        //Text_Bound(codet,a,a,R,ss);
        //b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
        b.x:=a.x+round(2.4*KF);

        b.y:=a.y-round(0.9*kf);
        ss:=ss+'''';
        Add_Text(codet,b,b,0,ss,false);
      end;
     end else if nlb mod interminterval = 0 then begin
       if (nlb=nlbnetorig_B) then begin
         Tl1.pol[0]:=l0;
         Tl1.N:=0;
         LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);

         nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;
       if (bfstr=0)or(rcorners[1].x-0.25*kk<dtg.x) then
        aa:=a
      else begin
        aa.y:=a.y;
        aa.x:=a.x+round(0.6*kf);
      end;
      b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        //Text_Bound(codebig,a,a,R,ss);
        //b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
        b.x:=a.x+round(2.4*KF);

        b.y:=a.y+round(kf);
        ss:=ss+'°';
        Add_Text(codebig,b,b,0,ss,false);
      end else begin
        ss:=inttostr(min);
        //Text_Bound(codet,a,a,R,ss);
        //b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
        b.x:=a.x+round(2.4*KF);

        b.y:=a.y+round(0.9*kf);
        ss:=ss+'''';
        Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
      if (bfstr=0)or(rcorners[1].x-0.25*kk<dtg.x) then
        aa:=a
      else begin
        aa.y:=a.y;
        aa.x:=a.x+round(0.6*kf);
      end;
      b.y:=a.y;
      b.x:=a.x+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end else begin
      aa.y:=a.y;
      aa.x:=a.x+round(0.6*kf);

      b.y:=a.y;
      b.x:=a.x+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
      if (Shraf<>0) AND (nlb mod Shraf = 0) then begin
         {f ((dtg.x>=0) and (Rcorners[4].x>=0)) or ((dtg.x<=0) and (Rcorners[4].x<=0)) then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);
         }
         if dtg.x-mindiv>=0 then
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(0.3*kf);
         end
         else begin
           if (Lshraf2.y<>-999999999) and (lshraf2.y<>a.y) then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf2;
           PL^.pol[1].y:=a.y;
           PL^.pol[1].x:=a.x+round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)

       //    dm_add_sign(codes,lshraf2,b,0,false);
           end;
           lshraf2.y:=-999999999
         end;
     end;

      dtg.x:=dtg.x+kk;
      if Rcorners[4].x>=0 then
       inc(nlb)
      else
       dec(nlb);
      bfstr:=1
     until rcorners[1].x+0.25*kk<dtg.x;
      if (Shraf<>0) AND (Lshraf1.y<>-999999999) then begin
          dtg.x:=Rcorners[1].x;
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           if lshraf2.y<>a.y then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf2;
           PL^.pol[1].y:=a.y;
           PL^.pol[1].x:=a.x+round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)

           //dm_add_sign(codes,lshraf2,b,0,false);
           end;
           dtg.y:=Rcorners[1].y;
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           if lshraf2.y<>a.y then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf1;
           PL^.pol[1].y:=a.y;
           PL^.pol[1].x:=a.x-round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)
           //dm_add_sign(codes,lshraf1,b,0,false);
           end;
     end;
end;

procedure SET_INTERVALS;
begin
 case nomenkl.scale of
     _sc1: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=600;

       end else if BMgr<70 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=600;
       end else
       if BMgr<75 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;
       Biginterval:=600;
       end else begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
        textinterv:=30;
       Biginterval:=300;
       end

       end;
     _sc1_5: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=600;
       end else if BMgr<70 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=600;
       end else
       if BMgr<75 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=600;
       end else begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
       textinterv:=30;

       Biginterval:=300;
       end

       end;
     _sc2,_sc2_5: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=600;
       end else if BMgr<70 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
        textinterv:=30;

       Biginterval:=300;
       end else
       if BMgr<75 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
        textinterv:=30;

       Biginterval:=300;
       end else begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=120;
       end

       end;
      _sc3: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
 textinterv:=60;

       Biginterval:=600;
       end else if BMgr<70 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
 textinterv:=30;

       Biginterval:=300;
       end else
       if BMgr<75 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=120;
       end else begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
 textinterv:=60;
       Biginterval:=120;
       end

       end;
      _sc4: begin
       if BMgr<50 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
 textinterv:=30;
       Biginterval:=300;
       end else if BMgr<70 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
        textinterv:=60;
Biginterval:=120;
       end else
       if BMgr<75 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
  textinterv:=60;
      intermInterval:=60;
       Biginterval:=120;
       end else begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=120;
       end

       end;

     _sc5, _sc6: begin
       if BMgr<50 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
 textinterv:=30;
       Biginterval:=300;
       end else if BMgr<70 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
       textinterv:=60;
 Biginterval:=120;
       end else
       if BMgr<75 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
 textinterv:=60;
       intermInterval:=60;
       Biginterval:=120;
       end else begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=30;
       intermInterval:=30;
       Biginterval:=60;
       end

       end;
     _sc7, _sc7_5: begin
       if BMgr<50 then begin
          tmindiv:=3; //0.5"
          minDiv:=Pi/1296000{180*3600*2 (0.5")};
          smInterv:=12;
           textinterv:=60;
intermInterval:=60;
          Biginterval:=120;
      end else if BMgr<70 then begin
       tmindiv:=3; //1"
       minDiv:=Pi/1296000{180*3600 (1")};
       smInterv:=12;
       textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
       intermInterval:=30;
 textinterv:=60;
       Biginterval:=60;
       end else begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end

       end;

    _sc10,_sc12_5:begin
       if BMgr<50 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=120;
       end else if BMgr<70 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
       intermInterval:=30;
       textinterv:=60;
 Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end

       end;
     _sc15,_sc17_5:begin
       if BMgr<50 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else if BMgr<70 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
      textinterv:=60;
  intermInterval:=30;
       Biginterval:=60;
       end else begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end;
       end;
       _sc20,_sc25:begin
       if BMgr<50 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else if BMgr<70 then begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=6; //3"
       minDiv:=Pi/216000{180*3600/3 (3")};
       smInterv:=10;
 textinterv:=60;
       intermInterval:=20;
       Biginterval:=80;
       end else begin
       tmindiv:=6; //3"
       minDiv:=Pi/216000{180*3600/3 (3")};
       smInterv:=10;
 textinterv:=60;
       intermInterval:=20;
       Biginterval:=80;
       end

       end;
       // maps
        _scM30,_scM37_5,_scM40:begin
         tmindiv:=7; //6"
         minDiv:=Pi/108000{180*600 (6")};
         smInterv:=5;
         Shraf:=10;
         intermInterval:=20;
         textinterv:=20;
         Biginterval:=600;
       end;
        _scM50,_scM75:begin
         tmindiv:=7; //6"
         minDiv:=Pi/108000{180*600 (6")};
         smInterv:=5;
         Shraf:=10;
         textinterv:=50;
         intermInterval:=50;
         Biginterval:=600;
       end;
        _scM100,_scM150,_scM200:begin
         tmindiv:=8; //12"
         minDiv:=Pi/54000{180*300 (12")};
         smInterv:=5;
         Shraf:=5;
         textinterv:=25;

         intermInterval:=25;
         Biginterval:=300;
       end;
        _scM250,_scM300:begin
         tmindiv:=9; //30"
         minDiv:=Pi/21600{180*120 (30")};
         smInterv:=2;
         Shraf:=5;
         textinterv:=10;
 intermInterval:=10;
         Biginterval:=120;
       end;
       _scM500,_scM750,_scM1000:begin
         tmindiv:=10; //1'
         minDiv:=Pi/10800{180*60 (1')};
         smInterv:=5;
         Shraf:=5;
         textinterv:=30;

         intermInterval:=10;
         Biginterval:=60;
       end;
        _scM1500,_scM2000:begin
         tmindiv:=11; //2'
         minDiv:=Pi/5400{180*30 (2')};
         smInterv:=5;
         Shraf:=5;
         textinterv:=30;

         intermInterval:=15;
         Biginterval:=30;
       end;
       _scM2500:begin
         tmindiv:=12; //5'
         minDiv:=Pi/2160{180*12 (5')};
         smInterv:=6;
         Shraf:=6;
         textinterv:=24;

         intermInterval:=12;
         Biginterval:=24;
       end;
        _scM3000,_scM5000:begin
         tmindiv:=12; //5'
         minDiv:=Pi/2160{180*12 (5')};
         smInterv:=6;
         Shraf:=6;
         textinterv:=60;

         intermInterval:=12;
         Biginterval:=60;
       end;
       _scM10000:begin
         tmindiv:=13; //10'
         minDiv:=Pi/1080{180*6 (10')};
         smInterv:=6;
         Shraf:=6;
         textinterv:=30;

         intermInterval:=30;
         Biginterval:=30;
       end;
   end;
      minDivL:=minDiv;
      smIntervL:=smInterv;
      intermIntervalL:=intermInterval;
      textintervL:=textinterv;
      BigintervalL:= Biginterval;
      Shrafl:=Shraf
end;


Procedure Kilometr_net_From_bottom_onCrossMerc;
var
  ss:shortstring;
  code,CodeTextKM,StrichCode,ld,km:integer;
  t1,t2: _geoid;
  var A1,s,A2: EXTENDED;
begin

      TL.pol[0].x:=TLfr.pol[0].x;
      TL.pol[0].y:=TLfr.pol[0].y+round(12.5*kf);
      TL.pol[1].x:=TLfr.pol[0].x+round(kf);;
      TL.pol[1].y:=TL.pol[0].y;
      TL.pol[2].x:=TL.pol[1].x;
      TL.pol[2].y:=TLfr.pol[3].y-round(12.5*kf);
      TL.pol[3].x:=TLfr.pol[0].x;
      TL.pol[3].y:=TL.pol[2].y;
      TL.pol[4]:=TL.pol[0];
      TL.n:=4;
      dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then  begin
       Code:=String2code('A0400230');

       ss:='КИЛОМЕТРЫ'
       end
       else begin
       Code:=String2code('A0400231');

       ss:='KILOMETRES';
       end;
       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+round(25*kf);
       b.y:=a.y-round(50*kf);
       a.x:=TLfr.pol[0].x-round(11*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       if FFrame.CboxLang.itemindex=2 then begin
       Code:=String2code('A0400231');

       ss:='KILOMETRES';
       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+round(25*kf);
       b.y:=a.y-round(50*kf);
       a.x:=TLfr.pol[0].x-round(16*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       end;
      t1.b:=Rcorners[4].x;
      t1.l:=Rcorners[4].y;
      mCross_BL_XY(t1.B,t1.L,t2.B,t2.L);
      mCross_XY_kvBL(t2.B,t2.L,t2.B,t2.L);
      t2.b:=t2.b+mindiv;
      mCross_kvBL_BL(t2.B,t2.L,t2.B,t2.L);

      Back_p (t1,t2,A1,s);


       CodeTextKM:=String2Code('A0400620');
       StrichCode:=String2Code('A0100003');
       ld:=0;
       WHILE  true do begin
       Direct (t1,A1,dkmmindiv,t2,A2);
       mCross_BL_XY(t2.B,t2.L,t2.B,t2.L);
       mCross_XY_kvBL(t2.B,t2.L,t2.B,t2.L);
       t2.L:=RCKV[1].y;
       mCross_kvBL_BL(t2.B,t2.L,t2.B,t2.L);
       dm_R_to_l(t1.b,t1.l,a.x,a.y);
       if a.y<Pcorn[1].y then break;
       t1:=t2;
       A1:=A2+Pi;
       dec(a.x,round(11.5*kf));
       b.y:=a.y;
       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
          b.x:=a.x-round(3*kf);
          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;


         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         b.x:=a.x-round(2*kf)
       else
         b.x:=a.x-round(kf);

       dm_add_sign(StrichCode,a,b,0,false);

       inc(ld,dkmmindiv);
     end;


end;


Procedure Kilometr_net_From_bottom_onSlantStereo;
var
  ss:shortstring;
  code,CodeTextKM,StrichCode,ld,km:integer;
  rx,ry,rr,rxb,ryb,rrb:double;
  t1,t2: _geoid;
  lp0:lpoint;
  var A1,s,A2: EXTENDED;

begin
      TL.pol[0]:=pcorn[1];
      TL.pol[1]:=pcorn[3];
      TL.n:=1;
      dm_Add_Poly(String2code('A0100006'),2,0,@TL,false);
      rx:=TL.pol[1].x-TL.pol[0].x;
      ry:=TL.pol[1].y-TL.pol[0].y;
      rr:=sqrt(sqr(rx)+SQR(RY));
      rx:=rx/rr;
      ry:=ry/rr;

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then  begin
       Code:=String2code('A0100081');

       ss:='КИЛОМЕТРЫ'
       end
       else begin
       Code:=String2code('A0100082');

       ss:='KILOMETRES';
       end;
       a.x:= pcorn[1].x+round(17*kf*rx-4*kf*ry);
       a.y:= pcorn[1].y+round(17*kf*ry+4*kf*rx);
       b.x:=a.x+round(50*kf*rx);
       b.y:=a.y+round(50*kf*ry);
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       if FFrame.CboxLang.itemindex=2 then begin
       Code:=String2code('A0100082');

       ss:='KILOMETRES';
       a.x:= pcorn[1].x+round(17*kf*rx-8*kf*ry);
       a.y:= pcorn[1].y+round(17*kf*ry+8*kf*rx);
       b.x:=a.x+round(50*kf*rx);
       b.y:=a.y+round(50*kf*ry);
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       end;

      t1.b:=Rcorners[1].x;
      t1.l:=Rcorners[1].y;
      b.x:= pcorn[1].x+round(kf*rx);
      b.y:= pcorn[1].y+round(kf*ry);
      //b:=pcorn[3];
      dm_l_to_R(b.x,b.y,t2.b,t2.l);
      Back_p (t1,t2,A1,s);
      //showMessage(Floattostr(s));
       CodeTextKM:=String2Code('A0400620');
       StrichCode:=String2Code('A0100003');
       ld:=dkmmindiv;
       WHILE  true do begin
       Direct (t1,A1,dkmmindiv,t2,A2);
       dm_R_to_l(t2.b,t2.l,b.x,b.y);
       rxb:=b.x-pcorn[1].x;
       ryb:=b.y-pcorn[1].y;
       rrb:=SQRT(SQR(rxb)+SQR(ryb));

       //rrb:=ld/iscale*kf*1000;

       b.x:=pcorn[1].x+round(rx*rrb);
       b.y:=pcorn[1].y+round(ry*rrb);
       dm_L_to_R(b.x,b.y,t2.b,t2.l);
       if b.y>Pcorn[3].y then break;
       t1:=t2;
       a.x:= b.x+round(kf*rx);
       a.y:= b.y+round(kf*ry);
       //a:=pcorn[3];
       dm_l_to_R(a.x,a.y,t2.b,t2.l);

       Back_p (t1,t2,A1,s);

       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
       a.x:=b.x+round(3.5*kf*ry);
       a.y:=b.y-round(3.5*kf*rx);
         { if km mod dkm4 =0 then
          ss:=inttostr(ld d 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          }
          ss:=inttostr(ld div 1000);
          //end;


         //Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          //TL.n:=1;
          TL.pol[0].x:=b.x+round(4*kf*ry);
          TL.pol[0].y:=b.y-round(4*kf*rx);
          TL.pol[1].x:=b.x+round(7*kf*ry);
          TL.pol[1].y:=b.y-round(7*kf*rx);

          add_text(CodeTextKM,TL.pol[0],TL.pol[1],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then begin
       a.x:=b.x+round(2.5*kf*ry);
       a.y:=b.y-round(2.5*kf*rx);
       end
       else begin
         a.x:=b.x+round(2*kf*ry);
         a.y:=b.y-round(2*kf*rx);
       end;
       dm_add_sign(StrichCode,b,a,0,false);

       inc(ld,dkmmindiv);
     end;
      // от Центральной точки

      dm_R_to_L(B992,L993,lp0.x,lp0.y);
      TL.pol[0]:=lp0;
      TL.pol[1]:=pcorn[2];
      TL.n:=1;
      dm_Add_Poly(String2code('A0100006'),2,0,@TL,false);
      rx:=TL.pol[1].x-TL.pol[0].x;
      ry:=TL.pol[1].y-TL.pol[0].y;
      rr:=sqrt(sqr(rx)+SQR(RY));
      rx:=rx/rr;
      ry:=ry/rr;

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then  begin
       Code:=String2code('A0100081');

       ss:='КИЛОМЕТРЫ'
       end
       else begin
       Code:=String2code('A0100082');

       ss:='KILOMETRES';
       end;
       a.x:= lp0.x+round(17*kf*rx-4*kf*ry);
       a.y:= lp0.y+round(17*kf*ry+4*kf*rx);
       b.x:=a.x+round(50*kf*rx);
       b.y:=a.y+round(50*kf*ry);
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       if FFrame.CboxLang.itemindex=2 then begin
       Code:=String2code('A0100082');

       ss:='KILOMETRES';
       a.x:= lp0.x+round(17*kf*rx-8*kf*ry);
       a.y:= lp0.y+round(17*kf*ry+8*kf*rx);
       b.x:=a.x+round(50*kf*rx);
       b.y:=a.y+round(50*kf*ry);
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       end;

      t1.b:=B992;
      t1.l:=L993;
      b.x:= lp0.x+round(kf*rx);
      b.y:= lp0.y+round(kf*ry);
      dm_l_to_R(b.x,b.y,t2.b,t2.l);
      Back_p (t1,t2,A1,s);

       CodeTextKM:=String2Code('A0400620');
       StrichCode:=String2Code('A0100003');
       ld:=dkmmindiv;
       WHILE  true do begin
       Direct (t1,A1,dkmmindiv,t2,A2);
       dm_R_to_l(t2.b,t2.l,b.x,b.y);
       rxb:=b.x-lp0.x;
       ryb:=b.y-lp0.y;
       rrb:=SQRT(SQR(rxb)+SQR(ryb));

       //rrb:=ld/iscale*kf*1000;
       b.x:=lp0.x+round(rx*rrb);
       b.y:=lp0.y+round(ry*rrb);
       dm_L_to_R(b.x,b.y,t2.b,t2.l);
       if b.y<Pcorn[2].y then break;
       t1:=t2;
       a.x:= b.x+round(kf*rx);
       a.y:= b.y+round(kf*ry);
       dm_l_to_R(a.x,a.y,t2.b,t2.l);
       Back_p (t1,t2,A1,s);

       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
       a.x:=b.x+round(3.5*kf*ry);
       a.y:=b.y-round(3.5*kf*rx);
         { if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          {if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          }
          //ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          //end;
          ss:=inttostr(ld div 1000);


         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          //TL.n:=1;
          TL.pol[0].x:=b.x+round((R[2].x-R[1].x+4*kf)*ry);
          TL.pol[0].y:=b.y-round((R[2].x-R[1].x+4*kf)*rx);
          TL.pol[1].x:=b.x+round(4*kf*ry);
          TL.pol[1].y:=b.y-round(4*kf*rx);

          add_text(CodeTextKM,TL.pol[0],TL.pol[1],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then begin
       a.x:=b.x+round(2.5*kf*ry);
       a.y:=b.y-round(2.5*kf*rx);
       end
       else begin
         a.x:=b.x+round(2*kf*ry);
         a.y:=b.y-round(2*kf*rx);
       end;
       dm_add_sign(StrichCode,b,a,0,false);

       inc(ld,dkmmindiv);
     end;
end;


Function mk_frame:boolean;
var
  a0,b0,a,b,t:lpoint;
  tg0,tg,tgr:tgauss;
  dh, rr:double;
  dInt,dAdm,i,j,lcode,lcodeINT,ll,lx,lAdmlen,lIntLen,dmdist, res,
  StrichCode,codelogdigit,codelogtext,codelogHead, codebluelogtext,codeBluelogHead:integer;
  code:longint;
  grad,min: integer;
  sec: extended;
  R:lOrient;
  sdm:AnsiString;
  st,ss,sadm,sINT:shortstring;
 SaveDlg: TSaveDialog;
 i995,i996,i997:longint;
 w999,b901,b911:word;
 fl991,fl992,fl993:boolean;
begin

mk_frame:=false;
if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
  end;

dm_Goto_root;
 if dm_get_long(904,0,iscale) then begin
 {if  (iscale<>1000)and (iscale<>2000) and (iscale<>2500) and
    (iscale<>1500)and (iscale<>2000) and (iscale<>3000) and
(iscale<>4000)and (iscale<>5000) and (iscale<>6000) and
(iscale<>7000)and (iscale<>7500) and (iscale<>10000) and
(iscale<>12500)and (iscale<>15000) and (iscale<>20000) and (iscale<>25000) and
// карты
(iscale<>30000)and (iscale<>50000) and (iscale<>75000) and
    (iscale<>100000)and (iscale<>150000) and (iscale<>200000) and
(iscale<>250000)and (iscale<>300000) and (iscale<>500000) and
(iscale<>750000)and (iscale<>1000000) and   (iscale<>1500000) and
(iscale<>2000000)and (iscale<>2500000) and (iscale<>3000000) and
(iscale<>5000000) then begin
   dmw_done;
   Showmessage('Не поддерживаемый масштаб планов или карт');
   exit
 end;
 }
 fltopo:=dm_pps=1;
 fl991:=Dm_GET_double(991,0,B991);
 fl992:=Dm_GET_double(992,0,B992);
 fl993:=Dm_GET_double(993,0,L993);

if not  Dm_get_word(999,0,w999) then w999:=1;
if not  Dm_get_word(901,0,b901) then b901:=1;
if not  Dm_get_word(911,0,b911) then b911:=1;
if not  Dm_get_word(913,0,b913) then b913:=1;

if not  Dm_get_LONG(995,0,I995) then I995:=0;
if not  Dm_get_LONG(996,0,I996) then I996:=0;
if not  Dm_get_LONG(997,0,I997) then I997:=0;

if fframe.ChBNetInterv.checked then begin
if not dm_get_double(971,0,netintb) then netintb:=0;
if not dm_get_double(972,0,netintl) then netintl:=0;
end;
 BMgr:=abs(B991/PI*180);
 if iscale<=1000 then Nomenkl.scale:=_sc1
 else
 if iscale<=1500 then Nomenkl.scale:=_sc1_5
 else
 if iscale<=2000 then Nomenkl.scale:=_sc2
 else
 if iscale<=2500 then Nomenkl.scale:=_sc2_5
 else
 if iscale<=3000 then Nomenkl.scale:=_sc3
 else
 if iscale<=4000 then Nomenkl.scale:=_sc4
 else
 if iscale<=5000 then Nomenkl.scale:=_sc5
 else
 if iscale<=6000 then Nomenkl.scale:=_sc6
 else
 if iscale<=7000 then Nomenkl.scale:=_sc7
 else
 if iscale<=7500 then Nomenkl.scale:=_sc7_5
 else
 if iscale<=10000 then Nomenkl.scale:=_sc10
 else
 if iscale<=12500 then Nomenkl.scale:=_sc12_5
 else
 if iscale<=15000 then Nomenkl.scale:=_sc15
 else
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
  else
 if iscale<=50000 then Nomenkl.scale:=_scM50
  else
 if iscale<=75000 then Nomenkl.scale:=_scM75
  else
 if iscale<=100000 then Nomenkl.scale:=_scM100
  else
 if iscale<=150000 then Nomenkl.scale:=_scM150
  else
 if iscale<=200000 then Nomenkl.scale:=_scM200
  else
 if iscale<=250000 then Nomenkl.scale:=_scM250
  else
 if iscale<=300000 then Nomenkl.scale:=_scM300
  else
 if iscale<=500000 then Nomenkl.scale:=_scM500
  else
 if iscale<=750000 then Nomenkl.scale:=_scM750
  else
 if iscale<=1000000 then Nomenkl.scale:=_scM1000
  else
 if iscale<=1500000 then Nomenkl.scale:=_scM1500
  else
 if iscale<=2000000 then Nomenkl.scale:=_scM2000
   else
 if iscale<=2500000 then Nomenkl.scale:=_scM2500
   else
 if iscale<=3000000 then Nomenkl.scale:=_scM3000
   else
 if iscale<=5000000 then Nomenkl.scale:=_scM5000
   else
 if iscale<=10000000 then Nomenkl.scale:=_scM10000
 else
 Nomenkl.scale:=_scM10000;
 scale:=iscale;
 //if dm_Get_String(901,255,ss) then begin    Номенклатура
 end else begin
   dmw_done;
   exit
 end;
 if fltopo then begin
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);

 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 dm_L_to_R(a0.x,a0.y,tgr.x,tgr.y);

  if dmx_find_frst_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[4].x);
  Dm_Get_double(92,0,Rcorners[4].y);
  dm_Get_Bound(pcorn[4],t);

  {Dm_Get_double(901,0,corners[4].x);
  Dm_Get_double(902,0,corners[4].y);
  }
  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[1].x);
  Dm_Get_double(92,0,Rcorners[1].y);
  {Dm_Get_double(901,0,corners[1].x);
  Dm_Get_double(902,0,corners[1].y);
  }
  dm_Get_Bound(pcorn[1],t);
if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[2].x);
  Dm_Get_double(92,0,Rcorners[2].y);
  {Dm_Get_double(901,0,corners[2].x);
  Dm_Get_double(902,0,corners[2].y);
  }
  dm_Get_Bound(pcorn[2],t);

  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[3].x);
  Dm_Get_double(92,0,Rcorners[3].y);
  dm_Get_Bound(pcorn[3],t);
  corr_linkpoint;

 {Dm_Get_double(901,0,corners[3].x);
 Dm_Get_double(902,0,corners[3].y);
 }
 end else begin
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 end;

 SaveDlg:=TSaveDialog.Create(Fframe);
 SaveDlg.Title:='Выбор имени карты оформления';
 SaveDlg.DefaultExt:='dm';
 SaveDlg.Filter := 'Файлы (*.DM)|*.dm';
 SaveDlg.InitialDir:=Usr_dir;

 if not SaveDLG.Execute then begin
   dmw_done;
   exit
 end;
 sdm:=SaveDlg.FileName+#0;
 SaveDlg.Destroy;

 if FileExists(sdm) then
   if MessageDlg('Файл уже существует. Переписать?',
    mtConfirmation, [mbYes, mbNo], 0) = 0 then begin
    dmw_done;
    exit
   end;
 sdm:=UTF8ToWinCP(sdm);
 dmdist:=round(dm_dist(1,0));
 dm_Goto_root;
 dm_Get_String(903,255,st);
 st:=st+#0;
 if not dm_get_string(901,255,SAdm) then Sadm:='НОМЕР';
 if Sadm='' then Sadm:='НОМЕР';


 dmw_done;
{ ShowMessage(floattostr(corners[1].x));
 ShowMessage(floattostr(corners[2].y));
}
 //ShowMessage(floattostr(dmdist));

 if fltopo then begin
 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;

 end  else
 if dm_Frame(@sdm[1],@st[1],0,dmdist,tg.x,tg0.y,tg0.x,tg.y)=0 then
    exit;

  if  dmw_open(@sdm[1],true)=0 then exit;
  dm_goto_root;
 { dm_Get_bound(a0,b0);
  ShowMessage(floattostr(b0.x-a0.x));
  ShowMessage(floattostr(b0.y-a0.y));
  }
  dm_put_long(904,iscale);
 if fltopo then begin
 Dm_Put_word(999,w999);
 dm_put_byte(901,b901);
 Dm_Put_byte(911,b911);
 //c_:=Ellipsoids[B911];
 Dm_Put_byte(913,b913);
 if fl991 then Dm_Put_double(991,B991);
 if fl992 then Dm_Put_double(992,B992);
 if fl993 then Dm_Put_double(993,l993);
 Dm_put_LONG(995,I995);
 Dm_put_LONG(996,I996);
 Dm_put_LONG(997,I997);

   i:=4;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat

 dm_put_double(91,rcorners[i].x);
 dm_put_double(92,rcorners[i].y);
 dm_put_double(901,corners[i].x);
 dm_put_double(902,corners[i].y);

 if i=4 then
   i:=1
 else
   inc(i);
 until dmx_Find_Next_Code(0,1)=0;

 end;



  dm_goto_root;
  if B913=9 then begin
  rr:=Calc_RN(b991);
  Init_Mcross(b991,rr);
  for i:=1 to 4 do begin

   mCross_BL_XY(Rcorners[i].x,Rcorners[i].Y,corners[i].x,corners[i].y);
   mCross_XY_kvBL(corners[i].x,corners[i].y,RCKV[i].x,RCKV[i].y);
  end;
  //  mCross_XY_kvBL(corners[i].x,corners[i].Y,RCKV[i].x,RCKV[i].y);
  end;
{  ShowMessage(floattostr(corners[1].x));
 ShowMessage(floattostr(corners[2].y));
}


  dm_Get_poly_buf(PL,8000);
  ll:=(b0.x-a0.x) div 4;
  elm_inc_metric_levo(pl,ll);
  dm_set_Poly_buf(pl);
  dmw_done;
 if not fltopo then begin
 if  dmw_open(@sdm[1],true)=0 then exit;

 i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_get_bound(pcorn[i],pcorn[i]);
 until dmx_Find_Next_Code(0,1)=0;
 dec(pcorn[1].x,ll);
 inc(pcorn[1].y,ll);
 dec(pcorn[2].x,ll);
 dec(pcorn[2].y,ll);
 inc(pcorn[3].x,ll);
 dec(pcorn[3].y,ll);
 inc(pcorn[4].x,ll);
 inc(pcorn[4].y,ll);
 for i:=1 to 4 do
 dm_l_to_g(pcorn[i].x,pcorn[i].y,ExtR[i].x,ExtR[i].y);
  i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_set_bound(pcorn[i],pcorn[i]);
 dm_put_double(901,ExtR[i].x);
 dm_put_double(902,ExtR[i].y);

 until dmx_Find_Next_Code(0,1)=0;

 dmw_done;
 end;

 if not dmw_InsertMap(@sdm[1]) then exit;
 if not Set_active_map(1,true) then exit;

 //if  dmw_open(@sdm[1],true)=0 then exit;
   kf:=dm_dist(1,1);
   //kf:=5000;
   if fltopo then
    for i:=1 to 4 do
     dm_R_to_l(rcorners[i].x,rcorners[i].y,pcorn[i].x,pcorn[i].y)
    else
   for i:=1 to 4 do
     dm_G_to_L(corners[i].x,corners[i].y,pcorn[i].x,pcorn[i].y);
  {
  ShowMessage(floattostr(pcorn[2].x-pcorn[1].x));
  ShowMessage(floattostr(pcorn[4].y-pcorn[1].y));
  ShowMessage(floattostr(kf));
  }

   //Set_intervals;
   with Fframe do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext)/3600)/180*PI)/mindivL);

    PolarnetintB:=((strtoint(meNetCrDB_B.edittext)+strtoint(meNetCrMB_B.edittext)/60+strtoFloat(meNetCrSB_B.edittext)/3600)/180*PI);
    PolarnetintL:=((strtoint(meNetCrDB_L.edittext)+strtoint(meNetCrMB_L.edittext)/60+strtoFloat(meNetCrSB_L.edittext)/3600)/180*PI);


    end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;

 if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;

     for i:=1 to 4 do
     Tlmain.pol[i-1]:=pcorn[i];
     TlMain.pol[4]:=Tlmain.pol[0];
     TLmain.n:=4;
     dx:=round(12.5*kf);
     dy:=round(12.5*kf);
     TLfr.n:=4;
     TLfr.pol[0].x:=pcorn[1].x-dx;
     TLfr.pol[0].y:=pcorn[1].y-dy;
     TLfr.pol[1].x:=pcorn[2].x+dx;
     TLfr.pol[1].y:=pcorn[2].y-dy;
     TLfr.pol[2].x:=pcorn[3].x+dx;
     TLfr.pol[2].y:=pcorn[3].y+dy;
     TLfr.pol[3].x:=pcorn[4].x-dx;
     TLfr.pol[3].y:=pcorn[4].y+dy;
     TLfr.pol[4]:=TLfr.pol[0];

         dx:=round(11.5*kf);
         dy:=round(11.5*kf);
     ii[0]:=0;
     TLint.n:=4;
     TLint.pol[0].x:=pcorn[1].x-dx;
     TLint.pol[0].y:=pcorn[1].y-dy;
     TLint.pol[1].x:=pcorn[2].x+dx;
     TLint.pol[1].y:=pcorn[2].y-dy;
     TLint.pol[2].x:=pcorn[3].x+dx;
     TLint.pol[2].y:=pcorn[3].y+dy;
     TLint.pol[3].x:=pcorn[4].x-dx;
     TLint.pol[3].y:=pcorn[4].y+dy;
     TLint.pol[4]:=TLint.pol[0];
     ii[1]:=1;
     ii[2]:=2;
     ii[3]:=3;
     ii[4]:=4;
    dmx_Find_Frst_Code(0,1);
     dm_goto_last;
     Mk_COVER;

        dx:=round(0.5*kf);
        dy:=round(0.5*kf);

     if fFrame.ChBxKmNormal.Checked and (b913=3) then begin
     tlBigframe.pol[0].x:=TLfr.pol[0].x+dx;
     tlBigframe.pol[0].y:=TLfr.pol[0].y+round(10.5*kf);
     tlBigframe.pol[1].x:=TLfr.pol[0].x+dx;
     tlBigframe.pol[1].y:=TLfr.pol[0].y+dy;
     tlBigframe.pol[2].x:=TLfr.pol[1].x-dx;
     tlBigframe.pol[2].y:=TLfr.pol[1].y+dy;
     tlBigframe.pol[3].x:=TLfr.pol[2].x-dx;
     tlBigframe.pol[3].y:=TLfr.pol[2].y-dy;
     tlBigframe.pol[4].x:=TLfr.pol[3].x+dx;
     tlBigframe.pol[4].y:=TLfr.pol[3].y-dy;
     tlBigframe.pol[5].x:=TLfr.pol[3].x+dx;
     tlBigframe.pol[5].y:=TLfr.pol[3].y-round(10.5*kf);
     tlBigframe.n:=5
     end else begin

     tlBigframe.pol[0].x:=TLfr.pol[0].x+dx;
     tlBigframe.pol[0].y:=TLfr.pol[0].y+dy;
     tlBigframe.pol[1].x:=TLfr.pol[1].x-dx;
     tlBigframe.pol[1].y:=TLfr.pol[1].y+dy;
     tlBigframe.pol[2].x:=TLfr.pol[2].x-dx;
     tlBigframe.pol[2].y:=TLfr.pol[2].y-dy;
     tlBigframe.pol[3].x:=TLfr.pol[3].x+dx;
     tlBigframe.pol[3].y:=TLfr.pol[3].y-dy;
    TLbigFrame.pol[4]:=TLbigFrame.pol[0];
    TLbigFrame.N:=5;
    TLbigFrame.pol[5]:=TLbigFrame.pol[1];
    end;
    //Толстая рамка
    dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
    //Внутрення рамка
    if b913<>9 then
      res:=dm_Add_Poly(String2code('A0100002'),2,0,@TLmain,false)
    else
      res:=dm_Add_Poly(String2code('A0100102'),2,0,@TLmain,false);
    dx:=round(2*kf);
    dy:=round(2*kf);
     TL.n:=4;
     TL.pol[0].x:=pcorn[1].x-dx;
     TL.pol[0].y:=pcorn[1].y-dy;
     TL.pol[1].x:=pcorn[2].x+dx;
     TL.pol[1].y:=pcorn[2].y-dy;
     TL.pol[2].x:=pcorn[3].x+dx;
     TL.pol[2].y:=pcorn[3].y+dy;
     TL.pol[3].x:=pcorn[4].x-dx;
     TL.pol[3].y:=pcorn[4].y+dy;
     TL.pol[4]:=TL.pol[0];

    if Navykind=1 then begin
     if b913<>9 then
      res:=dm_Add_Poly(String2code('A0100002'),2,0,@TL,false)
      else
      res:=dm_Add_Poly(String2code('A0100102'),2,0,@TL,false);

      //Линии в рамке
      dx:=round(kf);
      dy:=round(kf);
      TL.n:=1;
      TL.pol[0].x:=pcorn[1].x-2*dx;
      TL.pol[0].y:=pcorn[1].y-dy;
      TL.pol[1].x:=pcorn[2].x+2*dx;
      TL.pol[1].y:=pcorn[2].y-dy;
      if b913<>9 then
     dm_Add_Poly(String2code('A0100002'),2,0,@TL,false)
       else
      res:=dm_Add_Poly(String2code('A0100102'),2,0,@TL,false);
     TL.pol[0].x:=pcorn[2].x+dx;
      TL.pol[0].y:=pcorn[2].y-2*dy;
      TL.pol[1].x:=pcorn[3].x+dx;
      TL.pol[1].y:=pcorn[3].y+2*dy;
      if b913<>9 then
     dm_Add_Poly(String2code('A0100002'),2,0,@TL,false)
       else
      res:=dm_Add_Poly(String2code('A0100102'),2,0,@TL,false);
      TL.pol[0].x:=pcorn[3].x+2*dx;
      TL.pol[0].y:=pcorn[3].y+dy;
      TL.pol[1].x:=pcorn[4].x-2*dx;
      TL.pol[1].y:=pcorn[4].y+dy;
      if b913<>9 then
     dm_Add_Poly(String2code('A0100002'),2,0,@TL,false)
       else
      res:=dm_Add_Poly(String2code('A0100102'),2,0,@TL,false);
      TL.pol[0].x:=pcorn[4].x-dx;
      TL.pol[0].y:=pcorn[4].y+2*dy;
      TL.pol[1].x:=pcorn[1].x-dx;
      TL.pol[1].y:=pcorn[1].y-2*dy;
      if b913<>9 then
     dm_Add_Poly(String2code('A0100002'),2,0,@TL,false)
       else
      res:=dm_Add_Poly(String2code('A0100102'),2,0,@TL,false);
    end;
    if fFrame.ChBxKmNormal.Checked then begin
      case Nomenkl.scale of
      _sc20,_sc25,_scM30,_scM37_5,_scM40,_scM50:begin dkmmindiv:=100;
                                      dkm2:=10;
                                      dkm4:=50;
                                end;
       _scM75,_scM100:begin dkmmindiv:=200;
                            dkm2:=10;
                            dkm4:=50;
                      end;
       _scM150,_scM200:begin dkmmindiv:=500;
                            dkm2:=10;
                            dkm4:=50;
                      end;
      _scM250,_scM300,_scM500:begin dkmmindiv:=1000;
                            dkm2:=10;
                            dkm4:=50;
                      end;
      _scM750,_scM1000:begin dkmmindiv:=2000;
                             dkm2:=10;
                             dkm4:=50;
                       end;
      _scM1500,_scM2000:begin dkmmindiv:=5000;
                             dkm2:=10;
                             dkm4:=50;
                       end;
      _scM5000:begin dkmmindiv:=10000;
                              dkm2:=10;
                              dkm4:=50;
      end;
      else begin dkmmindiv:=1000;
                            dkm2:=10;
                            dkm4:=50;
      end;
      end;

      // Километры
   if b913=3 then  begin   //Километровая сетка для нормального Меркатора
     Kilometr_net
   end else begin //Километровая сетка для других проекций

      if B913=9 then begin
        Kilometr_net_From_bottom_onCrossMerc;
        Miles_net;
      end;
      if B913=10 then Kilometr_net_From_bottom_onSlantStereo;

   end;
   end;
     if Fframe.ChbLog.checked then begin
       codelogdigit:=String2code('A0400630');
       codelogtext:=String2code('Z0200140');
       codebluelogtext:=String2code('Z0200141');
       StrichCode:=String2Code('A0100003');
       //Логарифмическая шкала
       a.x:=tlfr.pol[1].x+round(3*kf);
       a.y:=(pcorn[2].y+pcorn[3].y) div 2 -round(162*kf);
       TL.Pol[0]:=a;
       TL.Pol[1].x:=a.x;
       rr:=90/ln(10)*kf;
       TL.Pol[1].y:=a.y+round(ln(60)*rr);
                TL.n:=1;
        dm_Add_Poly(String2code('A0100006'),2,0,@TL,false);
       inc(TL.pol[0].x,round(kf));
       inc(TL.pol[1].x,round(kf));
       dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
       codelogHead:=String2code('A0400610');
       codeBluelogHead:=String2code('Z0700101');
       if Fframe.CBoxLang.ItemIndex=1 then begin
       ss:='LOGARITHMIC  SPEED  SCALE';
       code:=codeBluelogHead;
       end
         else begin
       ss:='ЛОГАРИФМИЧЕСКАЯ  ШКАЛА  СКОРОСТИ';
       code:=codelogHead
       end;
       Text_Bound(code,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=tlfr.pol[1].x+round(11*kf);
          TL.pol[0].y:=(TL.pol[0].y+TL.pol[1].y) div 2+(R[1].x-R[2].x) div 2;
          TL.pol[1].x:=TL.pol[0].x;
          TL.pol[1].y:=TL.pol[0].y+(R[2].x-R[1].x) div 2;
          add_text(code,TL.pol[0],TL.pol[1],0,ss,false);
       if Fframe.CBoxLang.ItemIndex=2 then begin
       ss:='LOGARITHMIC  SPEED  SCALE';
        Text_Bound(codeBluelogHead,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=tlfr.pol[1].x+round(15*kf);
          TL.pol[0].y:=a.y+round(0.5*ln(60)*rr)+(R[1].x-R[2].x) div 2;
          TL.pol[1].x:=TL.pol[0].x;
          TL.pol[1].y:=TL.pol[0].y+(R[2].x-R[1].x) div 2;
          add_text(codeBluelogHead,TL.pol[0],TL.pol[1],0,ss,false);
       end;


       t.x:=a.x;
       for i:=1 to 4 do begin
          t.y:=a.y+round(ln(i)*rr);
          b.y:=t.y;
          b.x:=a.x+round(2.5*kf);
          dm_add_sign(StrichCode,t,b,0,false);
          ss:=inttostr(i);
          TL.pol[0].x:=b.x+round(0.4*kf);
          TL.pol[0].y:=b.y;
          add_text(codelogdigit,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
          for j:=1 to 9 do begin
          t.y:=a.y+round(ln(i+j/10)*rr);
          b.y:=t.y;
          if J=5 then
            b.x:=a.x+round(1.5*kf)
          else
            b.x:=a.x+round(kf);
          dm_add_sign(StrichCode,t,b,0,false);

          end
        end;
       for i:=5 to 9 do begin
          t.y:=a.y+round(ln(i)*rr);
          b.y:=t.y;
          b.x:=a.x+round(2.5*kf);
          dm_add_sign(StrichCode,t,b,0,false);
          ss:=inttostr(i);
          TL.pol[0].x:=b.x+round(0.4*kf);
          TL.pol[0].y:=b.y;
          add_text(codelogdigit,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);

          t.y:=a.y+round(ln(i+0.5)*rr);
          b.y:=t.y;
          b.x:=a.x+round(1.5*kf);
          dm_add_sign(StrichCode,t,b,0,false);
        end;
        for i:=0 to 1 do begin
          t.y:=a.y+round(ln(10+i*5)*rr);
          b.y:=t.y;
          b.x:=a.x+round(2.5*kf);
          dm_add_sign(StrichCode,t,b,0,false);
          ss:=inttostr(10+i*5);
          TL.pol[0].x:=b.x+round(0.4*kf);
          TL.pol[0].y:=b.y;
          add_text(codelogdigit,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);

          for j:=1 to 4 do begin
          t.y:=a.y+round(ln(10+i*5+j)*rr);
          b.y:=t.y;
          b.x:=a.x+round(kf);
          dm_add_sign(StrichCode,t,b,0,false);
          end
        end;
         for i:=2 to 5 do begin
          t.y:=a.y+round(ln(i*10)*rr);
          b.y:=t.y;
          b.x:=a.x+round(2.5*kf);
          dm_add_sign(StrichCode,t,b,0,false);
          ss:=inttostr(i*10);
          TL.pol[0].x:=b.x+round(0.4*kf);
          TL.pol[0].y:=b.y;
          add_text(codelogdigit,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);

          for j:=1 to 9 do begin
          t.y:=a.y+round(ln(i*10+j)*rr);
          b.y:=t.y;
          if J=5 then
            b.x:=a.x+round(1.5*kf)
          else
            b.x:=a.x+round(kf);
          dm_add_sign(StrichCode,t,b,0,false);
          end
        end;
          t.y:=a.y+round(ln(60)*rr);
          b.y:=t.y;
          b.x:=a.x+round(2.5*kf);
          dm_add_sign(StrichCode,t,b,0,false);
          ss:='60';
          TL.pol[0].x:=b.x+round(0.4*kf);
          TL.pol[0].y:=b.y;
          add_text(codelogdigit,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
          if Fframe.CBoxLang.ItemIndex=1 then begin
          ss:='To find SPEED, place one point of dividers on nautical miles run and the other on minutes run. '+
              'Without changing dividers spread, place';
          Code:=codeBluelogtext;
          end
          else begin
          ss:='Для определения скорости в узлах по пройденному расстоянию в милях и времени в минутах необходимо одну иглу циркуля-измерителя';
          Code:=codelogtext;
          end;
          Text_Bound(code,TL.pol[0],TL.pol[0],R,ss);

          TL.pol[0].x:=t.x+round(5.8*kf);
          TL.pol[0].y:=t.y+round(5*kf);
          TL.pol[1].x:=TL.pol[0].x;
          TL.pol[1].y:=t.y+R[2].x-R[1].x;
          add_text(Code,TL.pol[0],TL.pol[1],0,ss,false);
          if Fframe.CBoxLang.ItemIndex=1 then
          ss:='right point on 60 and left point will then indicate speed in knots.'
          else
          ss:='установить на деление шкалы, равное числу миль, а другую - на деление, равное числу минут. После этого, не меняя раствора циркуля,';
          Text_Bound(code,TL.pol[0],TL.pol[0],R,ss);

          TL.pol[0].x:=t.x+round(2.9*kf);
          TL.pol[1].x:=TL.pol[0].x;
          TL.pol[1].y:=t.y+R[2].x-R[1].x;

          add_text(code,TL.pol[0],TL.pol[1],0,ss,false);
          if Fframe.CBoxLang.ItemIndex<>1 then begin

          ss:='одну иглу установить на отметку шкалы 60, тогда вторая игла на шкале укажет скорость.';
          Text_Bound(code,TL.pol[0],TL.pol[0],R,ss);

          TL.pol[0].x:=t.x;
          TL.pol[1].x:=t.x;
          TL.pol[1].y:=t.y+R[2].x-R[1].x;

          add_text(code,TL.pol[0],TL.pol[1],0,ss,false);
          end;

          if Fframe.CBoxLang.ItemIndex=2 then begin
          ss:='To find speed, place one point of dividers on nautical miles run and the other on minutes run. '+
              'Without changing dividers spread, place';
          Text_Bound(codeBluelogtext,TL.pol[0],TL.pol[0],R,ss);

          TL.pol[0].x:=t.x+round(11.6*kf);
          TL.pol[0].y:=t.y+round(5*kf);
          TL.pol[1].x:=TL.pol[0].x;
          TL.pol[1].y:=t.y+R[2].x-R[1].x;
          //TL.pol[1].y:=t.y+round(120*kf);
          add_text(codeBluelogtext,TL.pol[0],TL.pol[1],0,ss,false);
          ss:='right point on 60 and left point will then indicate speed in knots.';
           Text_Bound(codeBluelogtext,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=t.x+round(8.7*kf);
          TL.pol[1].x:=TL.pol[0].x;
          TL.pol[1].y:=t.y+R[2].x-R[1].x;
            add_text(codeBluelogtext,TL.pol[0],TL.pol[1],0,ss,false);
          end;
     end;

    //Номенклатура
      a:=TLfr.pol[3];
      lcode:=String2Code('A0300100');
      lcodeINT:=String2Code('A0300102');
      Sint:=trim(fframe.edINT.Text);
      if Sint<>'' then Sint:='INT'+Sint;
      dint:=round(20*kf);
      dadm:=round(16*kf);
      dh:=12.0;
      a.y:=round(TLfr.pol[3].y+dh*kf);
      //нижний левый
      Add_Text(lcode,a,a,0,sadm,false);

      Text_Bound(lcode,a,a,R,sadm);
      if Sint<>'' then begin
      a.x:=TLfr.pol[3].x+R[2].x-R[1].x+dint;
      Add_Text(lcodeINT,a,a,0,Sint,false);
      end;
      ladmlen:=R[2].x-R[1].x;
      lx:=ladmlen+Dadm;
      a.x:=TLfr.pol[2].x-lx;
      //нижний правый
      Add_Text(lcode,a,a,0,sadm,false);
      if Sint<>'' then begin
      Text_Bound(lcodeInt,a,a,R,sint);
      lIntlen:=R[2].x-R[1].x;

      a.x:=a.x-lIntlen-dint;
      Add_Text(lcodeINT,a,a,0,Sint,false);
      end;

      a.x:=TLfr.pol[0].x+lx;
      a.y:=round(TLfr.pol[0].y-dh*kf);

      b.x:=TLfr.pol[0].x+dadm;
      b.y:=a.y;
      //верхний левый
      Add_Text(lcode,a,b,0,sadm,false);
      if Sint<>'' then begin
       b.x:=a.x+dint;
       a.x:=a.x+lIntlen+dint;
       Add_Text(lcodeINT,a,b,0,Sint,false);
      end;

      a.x:=TLfr.pol[1].x;
      b.x:=TLfr.pol[1].x-ladmlen;
      //верхний правый
      Add_Text(lcode,a,b,0,sadm,false);

      if Sint<>'' then begin
       a.x:=b.x-dint;
       b.x:=a.x-lIntlen;
       Add_Text(lcodeINT,a,b,0,Sint,false);
      end;


    {Градусы долготы в углах рамки}
  if navykind=0 then
     flsec:=true
  else begin
  flsec:=false;
  for i:=1 to 4 do begin
  case i of
  1: sec:=abs(rcorners[1].x);
  2: sec:=abs(rcorners[1].y);
  3: sec:=abs(rcorners[3].x);
  4: sec:=abs(rcorners[3].y);
  end;
  LongtRad_grad(sec,grad,min,sec);
  if round(sec)>0 then begin
    flsec:=true;
    break
  end;
  end;
  end;
  if b913=3 then begin

     make_dolg;
     //  { Широта по углам }
     make_Brt;
  end;

  case b913 of
  3:case navykind of   //Цилиндрический Меркатор
    0:make_grad_labels;
    1:make_grad_labels_on_map;
  end;

  9:  begin  //Поперечный Меркатор
  //Квазикоординатная сетка
       Make_grad_labels_on_KVAZI;
       Mk_grad_net_on_Polar;
    end;
  10:  begin  //Косая Стереографическая
       Mk_grad_net_on_SlantStereo;
    end;
  end;
  // Center_bottom_text;
 mk_frame:=true;

end;

Function mk_frame_Plan:boolean;
var
  a0,b0,a,b,t:lpoint;
  tg0,tg:tgauss;
  dh:double;
  dint,dadm,ladmlen,lIntlen,i,lcode,lcodeINT,ll,lx,dmdist:integer;
  R:lOrient;
  sdm:msgstr;
  st,sadm,sINT:shortstring;
 SaveDlg: TSaveDialog;
  w999,b901,b911:word;
  d981,d982,d983,d984:double;
  n981,n982,n983,n984:double;
  i995,i996,i997:longint;
  flmm:boolean;

begin

mk_frame_plan:=false;
if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
end;

dm_Goto_root;
 if dm_get_long(904,0,iscale) then begin
{ if  (iscale<>1000)and (iscale<>2000) and (iscale<>2500) and
    (iscale<>1500)and (iscale<>2000) and (iscale<>3000) and
(iscale<>4000)and (iscale<>5000) and (iscale<>6000) and
(iscale<>7000)and (iscale<>7500) and (iscale<>10000) and
(iscale<>12500)and (iscale<>15000) and (iscale<>20000) and (iscale<>25000) and
// карты
(iscale<>30000)and (iscale<>50000) and (iscale<>75000) and
    (iscale<>100000)and (iscale<>150000) and (iscale<>200000) and
(iscale<>250000)and (iscale<>300000) and (iscale<>500000) and
(iscale<>750000)and (iscale<>1000000) and   (iscale<>1500000) and
(iscale<>2000000)and (iscale<>2500000) and (iscale<>3000000) and
(iscale<>5000000) then begin
   dmw_done;
   Showmessage('Не поддерживаемый масштаб планов или карт');
   exit
 end;
}
fltopo:=dm_pps=1;
if fltopo then begin
 if not Dm_GET_double(991,0,B991) then begin
   dmw_done;
   Showmessage('Нет опорной параллели');
   exit
 end;
 if not  Dm_get_LONG(995,0,I995) then I995:=0;
if not  Dm_get_LONG(996,0,I996) then I996:=0;
if not  Dm_get_LONG(997,0,I997) then I997:=0;


 if not  Dm_get_word(999,0,w999) then w999:=1;
 if not  Dm_get_word(901,0,b901) then b901:=1;
if not  Dm_get_word(911,0,b911) then b911:=1;
if not  Dm_get_word(913,0,b913) then b913:=1;
if fframe.ChBNetInterv.checked then begin
if not dm_get_double(971,0,netintb) then netintb:=0;
if not dm_get_double(972,0,netintl) then netintl:=0;
end;
end;
flmm:=dm_get_double(981,0,d981);
if flmm then flmm:=dm_get_double(982,0,d982);
if flmm then flmm:=dm_get_double(983,0,d983);
if flmm then flmm:=dm_get_double(984,0,d984);

 BMgr:=abs(B991/PI*180);
 if iscale<=1000 then Nomenkl.scale:=_sc1
 else
 if iscale<=1500 then Nomenkl.scale:=_sc1_5
 else
 if iscale<=2000 then Nomenkl.scale:=_sc2
 else
 if iscale<=2500 then Nomenkl.scale:=_sc2_5
 else
 if iscale<=3000 then Nomenkl.scale:=_sc3
 else
 if iscale<=4000 then Nomenkl.scale:=_sc4
 else
 if iscale<=5000 then Nomenkl.scale:=_sc5
 else
 if iscale<=6000 then Nomenkl.scale:=_sc6
 else
 if iscale<=7000 then Nomenkl.scale:=_sc7
 else
 if iscale<=7500 then Nomenkl.scale:=_sc7_5
 else
 if iscale<=10000 then Nomenkl.scale:=_sc10
 else
 if iscale<=12500 then Nomenkl.scale:=_sc12_5
 else
 if iscale<=15000 then Nomenkl.scale:=_sc15
 else
 if iscale<=17500 then Nomenkl.scale:=_sc17_5
 else
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
  else
 if iscale<=37500 then Nomenkl.scale:=_scM37_5
  else
 if iscale<=40000 then Nomenkl.scale:=_scM40
  else
 if iscale<=50000 then Nomenkl.scale:=_scM50
  else
 if iscale<=75000 then Nomenkl.scale:=_scM75
  else
 if iscale<=100000 then Nomenkl.scale:=_scM100
  else
 if iscale<=150000 then Nomenkl.scale:=_scM150
  else
 if iscale<=200000 then Nomenkl.scale:=_scM200
  else
 if iscale<=250000 then Nomenkl.scale:=_scM250
  else
 if iscale<=300000 then Nomenkl.scale:=_scM300
  else
 if iscale<=500000 then Nomenkl.scale:=_scM500
  else
 if iscale<=750000 then Nomenkl.scale:=_scM750
  else
 if iscale<=1000000 then Nomenkl.scale:=_scM1000
  else
 if iscale<=1500000 then Nomenkl.scale:=_scM1500
  else
 if iscale<=2000000 then Nomenkl.scale:=_scM2000
   else
 if iscale<=2500000 then Nomenkl.scale:=_scM2500
   else
 if iscale<=3000000 then Nomenkl.scale:=_scM3000
   else
 if iscale<=5000000 then Nomenkl.scale:=_scM5000
   else
 if iscale<=10000000 then Nomenkl.scale:=_scM10000
 else
 Nomenkl.scale:=_scM10000;
 scale:=iscale;
 //if dm_Get_String(901,255,ss) then begin    Номенклатура
 end else begin
   dmw_done;
   exit
   end;
  dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;

 if fltopo then begin
   if dmx_find_frst_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[4].x);
  Dm_Get_double(92,0,Rcorners[4].y);
  dm_Get_Bound(pcorn[4],t);

  {Dm_Get_double(901,0,corners[4].x);
  Dm_Get_double(902,0,corners[4].y);
  }
  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[1].x);
  Dm_Get_double(92,0,Rcorners[1].y);
  {Dm_Get_double(901,0,corners[1].x);
  Dm_Get_double(902,0,corners[1].y);
  }
  dm_Get_Bound(pcorn[1],t);
if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[2].x);
  Dm_Get_double(92,0,Rcorners[2].y);
  {Dm_Get_double(901,0,corners[2].x);
  Dm_Get_double(902,0,corners[2].y);
  }
  dm_Get_Bound(pcorn[2],t);

  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[3].x);
  Dm_Get_double(92,0,Rcorners[3].y);
  dm_Get_Bound(pcorn[3],t);
  corr_linkpoint;

 end;{ else begin
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 end;
 }
 SaveDlg:=TSaveDialog.Create(Fframe);
 SaveDlg.Title:='Выбор имени карты оформления';
 SaveDlg.DefaultExt:='dm';
 SaveDlg.Filter := 'Файлы (*.DM)|*.dm';
 SaveDlg.InitialDir:=Usr_dir;

 if not SaveDLG.Execute then begin
   dmw_done;
   exit
 end;
 sdm:=SaveDlg.FileName+#0;
 SaveDlg.Destroy;
 if FileExists(sdm) then
   if MessageDlg('Файл уже существует. Переписать?',
    mtConfirmation, [mbYes, mbNo], 0) = 0 then begin
    dmw_done;
    exit
   end;
 sdm:=UTF8ToWinCP(sdm);
 dmdist:=round(dm_dist(1,0));
 dm_Goto_root;

 dm_Get_String(903,255,st);
 st:=st+#0;
 if not dm_get_string(901,255,SAdm) then Sadm:='НОМЕР';
 if Sadm='' then Sadm:='НОМЕР';

 dmw_done;
 if fltopo then begin
 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;

 end  else
 if dm_Frame(@sdm[1],@st[1],0,dmdist,tg.x,tg0.y,tg0.x,tg.y)=0 then
    exit;

  if  dmw_open(@sdm[1],true)=0 then exit;
  dm_goto_root;
  dm_put_long(904,iscale);
 if fltopo then begin
 Dm_Put_word(999,w999);
 dm_put_byte(901,b901);
 Dm_Put_byte(911,b911);
 //c_:=Ellipsoids[B911];
 Dm_Put_byte(913,b913);
 Dm_Put_double(991,B991);
  Dm_put_LONG(995,I995);
  Dm_put_LONG(996,I996);
  Dm_put_LONG(997,I997);

   i:=4;

 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat

 dm_put_double(91,rcorners[i].x);
 dm_put_double(92,rcorners[i].y);
 if i=4 then
   i:=1
 else
   inc(i);
 until dmx_Find_Next_Code(0,1)=0;

 end;

  dm_goto_root;
  dm_Get_bound(a0,b0);

  dm_Get_poly_buf(PL,8000);
  ll:=(b0.x-a0.x) div 4;
  elm_inc_metric_levo(pl,ll);
  dm_set_Poly_buf(pl);
  if flmm then begin
    if (d983<>0) and (d984<>0) then begin
      n981:=d981-d983*0.25;
      n983:=d983*1.5;
      n982:=d982-d983*0.25;
      n984:=d984+d983*0.5;
      dm_Put_double(981,n981);
      dm_Put_double(982,n982);
      dm_Put_double(983,n983);
      dm_Put_double(984,n984);
    end;

  end;
  dmw_done;
 if not fltopo then begin
 if  dmw_open(@sdm[1],true)=0 then exit;

 i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_get_bound(pcorn[i],pcorn[i]);
 until dmx_Find_Next_Code(0,1)=0;
 dec(pcorn[1].x,ll);
 inc(pcorn[1].y,ll);
 dec(pcorn[2].x,ll);
 dec(pcorn[2].y,ll);
 inc(pcorn[3].x,ll);
 dec(pcorn[3].y,ll);
 inc(pcorn[4].x,ll);
 inc(pcorn[4].y,ll);
 for i:=1 to 4 do
 dm_l_to_g(pcorn[i].x,pcorn[i].y,ExtR[i].x,ExtR[i].y);
  i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_set_bound(pcorn[i],pcorn[i]);
 dm_put_double(901,ExtR[i].x);
 dm_put_double(902,ExtR[i].y);

 until dmx_Find_Next_Code(0,1)=0;

 dmw_done;
 end;

 if not dmw_InsertMap(@sdm[1]) then exit;
 if not Set_active_map(1,true) then exit;
 //if  dmw_open(@sdm[1],true)=0 then exit;
   kf:=dm_dist(1,1);
   if fltopo then
    for i:=1 to 4 do
     dm_R_to_l(rcorners[i].x,rcorners[i].y,pcorn[i].x,pcorn[i].y)
    else
    for i:=1 to 4 do
     dm_G_to_L(corners[i].x,corners[i].y,pcorn[i].x,pcorn[i].y);



 if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;

     for i:=1 to 4 do
     Tl.pol[i-1]:=pcorn[i];
     Tl.pol[4]:=Tl.pol[0];
     TL.n:=4;

      dx:=round(12.5*kf);
      dy:=round(12.5*kf);
     TLfr.n:=4;
     TLfr.pol[0].x:=pcorn[1].x-dx;
     TLfr.pol[0].y:=pcorn[1].y-dy;
     TLfr.pol[1].x:=pcorn[2].x+dx;
     TLfr.pol[1].y:=pcorn[2].y-dy;
     TLfr.pol[2].x:=pcorn[3].x+dx;
     TLfr.pol[2].y:=pcorn[3].y+dy;
     TLfr.pol[3].x:=pcorn[4].x-dx;
     TLfr.pol[3].y:=pcorn[4].y+dy;
     TLfr.pol[4]:=TLfr.pol[0];

         dx:=round(11.5*kf);
         dy:=round(11.5*kf);
     ii[0]:=0;
     TLint.n:=4;
     TLint.pol[0].x:=pcorn[1].x-dx;
     TLint.pol[0].y:=pcorn[1].y-dy;
     TLint.pol[1].x:=pcorn[2].x+dx;
     TLint.pol[1].y:=pcorn[2].y-dy;
     TLint.pol[2].x:=pcorn[3].x+dx;
     TLint.pol[2].y:=pcorn[3].y+dy;
     TLint.pol[3].x:=pcorn[4].x-dx;
     TLint.pol[3].y:=pcorn[4].y+dy;
     TLint.pol[4]:=TLint.pol[0];
     ii[1]:=1;
     ii[2]:=2;
     ii[3]:=3;
     ii[4]:=4;
    dmx_Find_Frst_Code(0,1);
     dm_goto_last;
     Mk_COVER;
     dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
        dx:=round(0.5*kf);
        dy:=round(0.5*kf);
     tlBigframe.pol[0].x:=TLfr.pol[0].x+dx;
     tlBigframe.pol[0].y:=TLfr.pol[0].y+dy;
     tlBigframe.pol[1].x:=TLfr.pol[1].x-dx;
     tlBigframe.pol[1].y:=TLfr.pol[1].y+dy;
     tlBigframe.pol[2].x:=TLfr.pol[2].x-dx;
     tlBigframe.pol[2].y:=TLfr.pol[2].y-dy;
     tlBigframe.pol[3].x:=TLfr.pol[3].x+dx;
     tlBigframe.pol[3].y:=TLfr.pol[3].y-dy;
    TLbigFrame.pol[4]:=TLbigFrame.pol[0];
    TLbigFrame.N:=5;
    TLbigFrame.pol[5]:=TLbigFrame.pol[1];
    //Толстая рамка
    dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);


    //Номенклатура
       a:=TLfr.pol[3];
      lcode:=String2Code('A0300100');
      lcodeINT:=String2Code('A0300102');
      Sint:=trim(fframe.edINT.Text);
      if Sint<>'' then Sint:='INT'+Sint;
      dint:=round(20*kf);
      dadm:=round(16*kf);
      dh:=12.0;
      a.y:=round(TLfr.pol[3].y+dh*kf);
      //нижний левый
      Add_Text(lcode,a,a,0,sadm,false);

      Text_Bound(lcode,a,a,R,sadm);
      if Sint<>'' then begin
      a.x:=TLfr.pol[3].x+R[2].x-R[1].x+dint;
      Add_Text(lcodeINT,a,a,0,Sint,false);
      end;
      ladmlen:=R[2].x-R[1].x;
      lx:=ladmlen+Dadm;
      a.x:=TLfr.pol[2].x-lx;
      //нижний правый
      Add_Text(lcode,a,a,0,sadm,false);
      if Sint<>'' then begin
      Text_Bound(lcodeInt,a,a,R,sint);
      lIntlen:=R[2].x-R[1].x;

      a.x:=a.x-lIntlen-dint;
      Add_Text(lcodeINT,a,a,0,Sint,false);
      end;

      a.x:=TLfr.pol[0].x+lx;
      a.y:=round(TLfr.pol[0].y-dh*kf);

      b.x:=TLfr.pol[0].x+dadm;
      b.y:=a.y;
      //верхний левый
      Add_Text(lcode,a,b,0,sadm,false);
      if Sint<>'' then begin
       b.x:=a.x+dint;
       a.x:=a.x+lIntlen+dint;
       Add_Text(lcodeINT,a,b,0,Sint,false);
      end;

      a.x:=TLfr.pol[1].x;
      b.x:=TLfr.pol[1].x-ladmlen;
      //верхний правый
      Add_Text(lcode,a,b,0,sadm,false);

      if Sint<>'' then begin
       a.x:=b.x-dint;
       b.x:=a.x-lIntlen;
       Add_Text(lcodeINT,a,b,0,Sint,false);
      end;


      (*a:=TLfr.pol[3];
      lcode:=String2Code('A0300100');
      dh:=12.0;
      a.y:=round(TLfr.pol[3].y+dh*kf);
      //нижний левый
      Add_Text(lcode,a,a,0,sadm,false);

      Text_Bound(lcode,a,a,R,sadm);
      lx:=R[2].x-R[1].x+round(16*kf);
      a.x:=TLfr.pol[2].x-lx;
      //нижний правый
      Add_Text(lcode,a,a,0,sadm,false);

      a.x:=TLfr.pol[0].x+lx;
      a.y:=round(TLfr.pol[0].y-dh*kf);

      b.x:=TLfr.pol[0].x+round(16*kf);
      b.y:=a.y;
      //верхний левый
      Add_Text(lcode,a,b,0,sadm,false);

      a.x:=TLfr.pol[1].x;
      b.x:=TLfr.pol[1].x-R[2].x+R[1].x;
      //верхний правый
      Add_Text(lcode,a,b,0,sadm,false);
      *)
      mk_frame_plan:=true;
end;

end.
