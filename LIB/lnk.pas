(*
  @@@ - ïğèâÿçêà ğàñòğà
*)
unit lnk; interface

uses Windows;


function lnk_make_from_Dm(w,h{mm}, dpi: double; dm_path: string; a,b: TPoint; lnk_path: string): boolean;


implementation

uses wcmn, _lnk;


//ÊÀĞÒÀ ÇÀÊĞÛÒÀ:

//default @@@ = '':
function lnk_make_from_Dm(w,h{mm}, dpi: double; dm_path: string; a,b: TPoint; lnk_path: string): boolean;
var tif_WH: TPoint;
begin
    tif_WH.X := Round( (w/wcmn_mmpi){äşéìû}*dpi );
    tif_WH.Y := Round( (h/wcmn_mmpi){äşéìû}*dpi );
    Result := lnk_make_file2(tif_WH, a,b, dm_path, lnk_path);//!
end;


end.
