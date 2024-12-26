unit msw_use; interface

uses Windows, SysUtils;


//������ ������:
function mscnv_exec(
  msname,
  gcxname: PChar;
  picwidth: single
  ): boolean; stdcall;


//1) ��� ������� �������:
  //gclist='marine.gc' ��� ������� ������� --------------------????????????????
  //dmpath=nil => ������� ����� ������, cmn_dm=NIL!
  //a,b = (0,0),(0,0)
//2) ��� ��������:
  //dmpath<>nil => make GCX-dm for Autocad-export, a,b - rect in dm, ��� ������, cmn_dm<>NIL!
  //function dmpath_after_mscnv_exec2 - ���� � ����� ����� (���� dmpath<>nil)
  //a,b - ������������� �� dmpath
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


// 1. ������� $.ms
// 2. ������� ����� ����� dm2 � GCX-������������
// 3. ��������� dm2 (mss_acad.cod)
// 4. �������� z-���������� � dm2
// 5. �������� dm_Export �� dm_dxf.dll: dm2 -> dxf
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
