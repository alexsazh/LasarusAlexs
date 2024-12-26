////////////////////////////////////////////////////////////
// проверка ориентации осей и переоткрытие карты, если надо
// по проекту
////////////////////////////////////////////////////////////

unit check_dm_xy;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, SysUtils, Forms, Classes;


//проверка активной карты, поворот осей, переоткрытие
function check_active_dm_xy: boolean;

//проверка карт проекта, поворот осей, переоткрытие
function check_prj_xy: boolean;


implementation

uses Wcmn, dm_util, OTypes, Dmw_ddw, dmw_Use;


//private; if Result - нужно переоткрытие карты
function _check_dm_xy(dm: pchar): boolean;
var mode: int;
begin
  Result:=false;

  if dm_open(dm,false) > 0 then begin
    mode:=dm_xy_rotate;//dmw_use - проверяет оси: 0 - всё ок
    dm_done;

    if mode <> 0 then begin
      dm_swap_xy(dm,mode);//dm_util.dll - меняет оси при mode<>0
      Application.ProcessMessages;

      Result:=true;
    end;
  end;
end;


//проверка активной карты, поворот осей, переоткрытие
function check_active_dm_xy: boolean;
var cmd,dm: TShortstr;
begin
  dmw_ActiveMap(dm,255);
  dmw_HideMap;//!

  Result:=_check_dm_xy(dm);

  if Result then begin
    StrLFmt(cmd,255,'dm_refresh "%s"',[dm]);
    dmw_Exec(cmd); Sleep(100);//переоткрытие карты

    dmw_ShowWindow(1,1,0,0);
  end;
end;


//проверка карт проекта, поворот осей, переоткрытие
function check_prj_xy: boolean;
var i,n: int; cmd,dm: TShortstr; _check: boolean;
begin
  Result:=false;

  n:=dmw_MapsCount;
  for i:=0 to n-1 do begin
    dmw_ProjectMap(i,dm,255);
    dmw_HideMap;

    _check:=_check_dm_xy(dm);

    if _check then begin
      StrLFmt(cmd,255,'dm_refresh "%s"',[dm]);
      dmw_Exec(cmd); Sleep(100);//переоткрытие карты
      Result:=true;
    end;
  end;//for i

  if Result//был хотя бы один разворот и переоткрытие
  then dmw_ShowWindow(1,1,0,0);
end;


end.
