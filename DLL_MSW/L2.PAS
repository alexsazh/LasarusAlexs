unit L2;

{$MODE Delphi}

 interface

uses List, nums, llib, llibx;


//pa0 - область; apa1,apa2 - стороны (в одном напр-ии);
//Result: list of tpl
function l2_execute(pa0,apa1,apa2: tpl): tclasslist;


implementation

uses vlib, PSOBJ, hl_dp, gcx, DLINE;


{ private: }

//pax - точки середин штрихов, включая крайние:
procedure l2_add_to_dash_list(pa: tpl; pax: tpa; delta2: tnum; outlist: tclasslist);
var
  i: tint;
  x: tnum;
  lx: tnuma;
  pad: tpa;//точки деления - пробелы между штрихами
  tmplist: tclasslist;
begin
  lx:=tnuma.new;
  pad:=tpa.new;

  try
    pax.GetLens(lx);
    if pax.count>1 then for i:=0 to pax.count-2 do begin
      x:=(lx[i]+lx[i+1])/2;
      pad.add( pa.xp(x) );
    end;

    tmplist:=dl_execute(pa,pad, delta2,1*gcx_DmPerMm, false);
    outlist.addfrom(tmplist);
  finally
    lx.free;
    pad.free;
  end;
end;


{ public: }


function l2_execute(pa0,apa1,apa2: tpl): tclasslist;
var
  pa1,pa2: tpl;//tmp
  pab,pae: tpa;
begin
  Result:=tclasslist.new;
  pa1:=tpl.new;
  pa2:=tpl.new;
  pab:=tpa.new;
  pae:=tpa.new;

  try
    //pa1 - более короткая:
    if apa1.GetLen<=apa2.GetLen then begin
      pa1.addfrom(apa1);
      pa2.addfrom(apa2);
    end else begin
      pa1.addfrom(apa2);
      pa2.addfrom(apa1);
    end;

    //ориентация: pa2 справа от pa1:
    if not pa1.SideR(pa2) then begin
      pa1.reverse;
      pa2.reverse;
    end;

    if hldp_connect(pa1,pa2, pab,pae, 0) then begin
      l2_add_to_dash_list(pa1,pab, gcx_hl.dlen, Result);
      l2_add_to_dash_list(pa2,pae, gcx_hl.dlen, Result);
    end;

  finally
    pa1.free;
    pa2.free;
    pab.free;
    pae.free;
  end;
end;


end.
