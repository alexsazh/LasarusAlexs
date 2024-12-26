(*
  // арта закрыта:
*)
unit dmlib3d; interface

uses nums, vlib, llib, llibx, llib3d;


//чтение из активной карты:
function dmwl3_read_pl3(offs: longint; pl3: tpl3d): boolean;


implementation

uses
  OTypes, dmw_use, dmw_dde,
  dmlib, dmwlib,
  wcmn;


function dmwl3_read_pl3(offs: longint; pl3: tpl3d): boolean;
begin
  Result:=false;
  pl3.Clear;
  if offs<=0 then exit;
  if dmw_open( PChar(DMW.ActiveMap), false )>0 then try
    if dm_goto_node(offs) then
      Result:=dml3_read_pl3(pl3);
  finally
    dmw_done;
  end;
end;


end.
