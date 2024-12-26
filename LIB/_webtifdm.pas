//
//  арта или ѕр€моуг-к на карте --> набор .tif + .@@@
// ¬ариант - PNG вместо TIF
//
//  ажда€ €чейка - в режиме MSS "страница карты"
// выводитс€ в .PS, а затем - в набор .tif + .@@@
//
unit _webtifdm; interface

uses Windows;


function web_dmrect_to_tifs(dmpath: string; la,lb: TPoint): boolean;//dmw_open - dmw_done
function web_dm_to_tifs(dmpath: string): boolean;//dmw_open - dmw_done


implementation

uses wcmn, cmn{MSW\cmn.pas}, vlib, _webtif, dmw_use, dmw_ddw;


//ширина или высота €чейки:
function _webdm_cell_dmsize(x1,x2: integer): integer;
//var n: integer;
begin
  Result:=x2-x1;
end;


//////////////////////////////////////////////////////////////
//
// web_dmrect_to_tifs USES global variables:
//
// cmn_a, cmn_b: TPoint;//пр€моугольник на карте
// cmn_lw, cmn_lh, cmn_mscale: longint;
// cmn_k, cmn_zoom, cmn_rpw, cmn_rph, cmn_upm{dm-units per meter}: real;
// cmn_k - как при вычислении страницы в mss_wm.pas
//
//////////////////////////////////////////////////////////////
function web_dmrect_to_tifs(dmpath: string; la,lb: TPoint): boolean;
(*
var
  ix,iy,nx,ny: integer;//x - слева направо, y - сверху вниз
  ld,gd: double;
  ia,ib: TPoint;
  lwh,lwhmin,lwhmax: TPoint;
  ga,gb: tnum2;
*)
begin
  //параметры DM:
  Result := dmw_open(PChar(dmpath), false{edit})<>0;
  if Result then try
    dm_goto_root;
(*
    if not dm_Get_long(904,0,cmn_mscale) then begin//cmn_mscale
      Result:=FALSE;
      EXIT;//!
    end;
*)
(*
    cmn_mscale:=dm_Scale;//cmn_mscale

    dm_l_to_g(la.x,la.y, ga.x,ga.y);
    dm_l_to_g(lb.x,lb.y, gb.x,gb.y);
    ld:=sqr(lb.x-la.x)+sqr(lb.y-la.y);
    gd:=sqr(gb.x-ga.x)+sqr(gb.y-ga.y);
    cmn_upm := sqrt(ld/gd);//cmn_upm - dm-units per meter
*)
  finally
    dmw_done;
  end;
(*
  //разбиение на €чейки:
  lwhmin.X:=512;//min
  lwhmin.Y:=512;//min
*)
  //ќЅ–јЅќ“ ј я„≈… »:
(*
  cmn_a:=la;
  cmn_b:=lb;
  cmn_lw:=cmn_b.X-cmn_a.X;
  cmn_lh:=cmn_b.Y-cmn_a.Y;
*)
end;


function web_dm_to_tifs(dmpath: string): boolean;
var dma,dmb: TPoint;
begin
  //1. параметры DM:
  Result := dmw_open(PChar(dmpath), false{edit})<>0;
  if Result then
  try
    dm_goto_root;//for dm_Get_Bound
    dm_Get_Bound(dma,dmb);//рамка карты

    if not dm_Get_long(904,0,cmn_mscale) then begin
      Result:=FALSE;
      EXIT;//!
    end;
  finally
    dmw_done;
  end;

//.................................

end;


end.
