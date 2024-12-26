unit msw_use; interface

uses Windows, SysUtils;


//Старая версия:
function mscnv_exec(
  msname,
  gcxname: PChar;
  picwidth: single
  ): boolean; stdcall;


//1) ПРИ ОБЫЧНОМ ЗАПУСКЕ:
  //gclist='marine.gc' при ОБЫЧНОМ ЗАПУСКЕ --------------------????????????????
  //dmpath=nil => обычный режим печати, cmn_dm=NIL!
  //a,b = (0,0),(0,0)
//2) ДЛЯ АВТОКАДА:
  //dmpath<>nil => make GCX-dm for Autocad-export, a,b - rect in dm, БЕЗ ПЕЧАТИ, cmn_dm<>NIL!
  //function dmpath_after_mscnv_exec2 - путь к НОВОЙ КАРТЕ (если dmpath<>nil)
  //a,b - прямоугольник на dmpath
function mscnv_exec2(
  msname,                 //Users\AppData\Local\Temp\$.ms = TmpDir+'$.ms'
  gcxname,                //MS\marine.lib\marine.gcx
  gclist,                 //MS\marine.lib\marine.gc------------????????????????
  mslibdir,               //MS\lib\ with '\' for LIB\gcx\ini
  flags: PChar;           //NIL
  picwidth: single;       //double (mm)
  dmpath: PChar;          //NIL
  a,b: TPoint             //(0,0),(0,0)
  ): boolean; stdcall;


// 1. создает $.ms
// 2. создает новую карту dm2 с GCX-построениями
// 3. коррекция dm2 (mss_acad.cod)
// 4. удаление z-координаты в dm2
// 5. вызывает dm_Export из dm_dxf.dll: dm2 -> dxf
procedure dm_Export(dm: PChar); stdcall;


implementation

const _DLL = 'msw.dll';


function mscnv_exec(
  msname,
  gcxname: PChar;
  picwidth: single
  ): boolean;
external _DLL;

function mscnv_exec2(
  msname,
  gcxname,
  gclist,
  mslibdir,
  flags: PChar;
  picwidth: single;
  dmpath: PChar;
  a,b: TPoint
  ): boolean;
external _DLL;

procedure dm_Export(dm: PChar);
external _DLL;


end.
