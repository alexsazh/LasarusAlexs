//кирпичи, валуны, ...
unit MOSAIC;

{$MODE Delphi}

 interface

uses llibx;

procedure mosaic_make_oval(pl_in,pl_out: tpl);


implementation

uses vlib,gcx;


procedure mosaic_make_oval(pl_in,pl_out: tpl);
var i: integer; p0: tnum2;
  function _add_m(p0,p1: tnum2): tnum2;
  begin
    Result:=v_lt(p0,p1,0.5);//middle
    pl_out.add(Result);
  end;
  function _add_c(pcur,p1,p2: tnum2): tnum2;
  begin
    Result:=v_lt(p1,p2,0.5);//middle
    pl_out.add( v_lt(pcur,p1,gcx_mosaic.oval_k) );
    pl_out.add( v_lt(Result,p1,gcx_mosaic.oval_k) );
    pl_out.add(Result);
  end;
begin
  pl_out.Clear;
  if pl_in.count<3 then exit;//!
  p0:=_add_m(pl_in[0],pl_in[1]);
  for i:=1 to pl_in.count-2 do p0:=_add_c(p0,pl_in[i],pl_in[i+1]);
  _add_c(p0,pl_in[0],pl_in[1]);//замыкание
end;


end.
