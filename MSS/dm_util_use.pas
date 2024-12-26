unit dm_util_use; interface

uses Windows, OTypes;


////////////////////////////////////////////////////////////
// Path - исх карта
// Dest - новая карта
// sys=sys7(1,3,9, 0,0,0) - (sys7 - function in OTypes: 1 - геодез коорд, 3 - мерк цилинд, 9 - wgs84, 0 - баз широта)
// key=Point(0,0)
////////////////////////////////////////////////////////////
function dm_sys_dm(Path,Dest: PChar;
                   const sys: tsys;
                   const key: TPoint): Boolean; stdcall;


implementation

const DLL = 'dm_util.dll';


function dm_sys_dm(Path,Dest: PChar;
                   const sys: tsys;
                   const key: TPoint): Boolean;
external dll_dde;


end.
