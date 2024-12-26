unit ROADS;

{$MODE Delphi}

 interface

uses List,llib,llibx;

//mode:
//1: одна попер.линия с шагом h_step и продлением h_dlen - pab,pae
//2: попер.прям-ки с шагом h_step и длиной h_len - outlist(of tpl)
//3: попер. области с шагом h_step и длиной h_len - outlist(of tpl)
procedure roads_hl(pa1,pa2: tpl; mode: integer; pab,pae: tpa; outlist: tclasslist);


implementation

uses nums,vlib,gcx;


procedure roads_hl(pa1,pa2: tpl; mode: integer; pab,pae: tpa; outlist: tclasslist);
var
  h_n,i: tint;
  l,x1,x2,step,d,lam: tnum;
  p1,p2,q1,q2: tnum2;
  pl,seg1,seg2: tpl;
begin
  pab.clear;
  pae.clear;
  outlist.clear;

  try
    l:=(pa1.length+pa2.length)/2.;//средняя длина

    //кол-во промежутков:
//    h_n:=0;
//    step:=0;
    if mode=1 then begin
      h_n:=Round(l/gcx_r.h_step);
      if h_n<2 then h_n:=2;
      step:=l/h_n;
    end else begin
      h_n:=Round((l-gcx_r.h_len)/gcx_r.h_step);
      if h_n<0 then h_n:=0;
      if h_n>0 then step:=(l-gcx_r.h_len)/h_n else step:=0;//0=>ничего не делать!
    end;

    //h_n+1 линий:
    if h_n>0 then for i:=0 to h_n do begin

      lam:=pa1.length/l; x1 := (i*step + gcx_r.h_ofs)*lam;
      lam:=pa2.length/l; x2 := (i*step + gcx_r.h_ofs)*lam;
      if (x1>pa1.length) or (x2>pa2.length) then break;

      p1:=pa1.xp(x1);
      p2:=pa2.xp(x2);

      //удлиннение [p1,p2]:
      if gcx_r.h_dlen>0 then begin
        d:=v_dist(p1,p2);
        q1:=v_lt(p1,p2, -gcx_r.h_dlen/d);
        q2:=v_lt(p1,p2, 1+gcx_r.h_dlen/d);
        p1:=q1;
        p2:=q2;
      end;//удлиннение

      pab.add(p1);
      pae.add(p2);

      //прям-ки:
      if mode=2 then begin
        q1:=pa1.xp(x1+gcx_r.h_len);
        q2:=pa2.xp(x2+gcx_r.h_len);
        pl:=tpl.new;
        pl.add(q1);//правая-верхняя точка
        pl.add(p1);
        pl.add(p2);
        pl.add(q2);
        pl.close;
        outlist.add(pl);
      end;//if mode=2

      //области:
      if mode=3 then begin
        seg1:=pa1.CreateSegment(x1,x1+gcx_r.h_len,false);
        seg2:=pa2.CreateSegment(x2,x2+gcx_r.h_len,false);
        seg2.reverse;
        try
          pl:=tpl.new;
          pl.addfrom(seg1);
          pl.addfrom(seg2);
          pl.close;
          outlist.add(pl);
        finally
          seg1.free;
          seg2.free;
        end;
      end;//if mode=3

    end;//h_n+1 линий

  finally
  end;//try
end;


end.
