unit sfill; interface

uses otypes, nums, vlib;




//Горизонтальное заполнение знаками текущей области:
//Смещение ds - по Y (!!!)
//RETURN >0 => Ok.
function sfill_x(lp0: lpoint;		//начальная точка
                       dx,dy,ds: double;	//ячейка и сдвиг (мм)
                       lcode: Longint): Integer;//код знака



implementation

uses Windows, wcmn, dmw_use;



function sfill_x(lp0: lpoint; dx,dy,ds: double; lcode: Longint): Integer;
(*
// dll_misc.dll:
function dm_Draw_Signs(p: Integer;			// object pointer
                       top_x,top_y: Double;		// start of vector
                       dir_x,dir_y: Double;		// end of vector
                       dx,dy,ds: double;		// disp_x,y,s
                       code,mm: Integer): Integer;      // code, 0 - m; 1 - mm
*)
type
  Tdm_Draw_Signs = function(p: Integer; top_x,top_y: Double; dir_x,dir_y: Double;
                       dx,dy,ds: double; code,mm: Integer): Integer; stdcall;
var
  Libhandle: Thandle;
  dm_Draw_Signs: Tdm_Draw_Signs;
  lp2: lpoint; x0,y0,x2,y2: Double; ofs: Integer;
begin
  Result:=0;
  ofs:=dm_Object;

  Libhandle:=LoadLibrary('dll_misc');
  if LibHandle<32 then begin
    Tellf('Ошибка загрузки DLL "%s"',['dll_misc']);
    exit;
  end else begin

    @dm_Draw_Signs:=GetProcaddress(Libhandle,'dm_Draw_Signs');
    if Assigned(dm_Draw_Signs) then begin

      //первая точка:
      dm_L_to_G(lp0.x,lp0.y,x0,y0);

      //вторая точка (направление):
      lp2:=lp0;
      lp2.y:=lp0.y+100;//горизонт-ый сдвиг
      dm_L_to_G(lp2.x,lp2.y,x2,y2);

      //горизонтальное заполнение:
      //1 => мм (dx,dy,ds)
      Result:=dm_Draw_Signs(ofs, x0,y0, x2,y2, dy,dx,ds, lcode,1);

    end else begin
      Tellf('Ошибка загрузки функции "%s"',['dm_Draw_Signs']);
    end;
    FreeLibrary(LibHandle);
  end;
end;



end.
