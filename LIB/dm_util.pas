unit dm_util;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, OTypes, Types;


function dmw_ErrCode: Integer; stdcall;


//копирование фрагмента, создание MS-файла:
//srcPath - путь к активной карте
//dstPath = TmpDir + '$.DM'
//altPath - путь к файлу с именами остальных карт (dmw_AltProject) - m.b. NIL
//x1,y1,x2,y2 - отображаемый прям-к (в целочисленных координатах хранения)
//rgbp = NIL
//a,b,c - используются лишь при наличии поворота (rotate=TRUE)
procedure dm_Cut(srcPath,dstPath,altPath: pChar; x1,y1,x2,y2: longint;
                 rgbp: pDmwColors; a,b,c:lpoint; rotate:boolean); stdcall;

//Частный случай: без поворота, 1 карта, результат = TmpDir+'$.DM':
procedure my_dm_Cut1(srcPath: pChar; x1,y1,x2,y2: longint); stdcall;


(*
Создание файлов рельефа (.REL, .XY):

dmPath      - карта (имя файла .DM)
altPath     - nil
rlfPath     - выходная матрица (имя файла .REL)
x1,y1,x2,y2 - габарит (Integer)
ed          - шаг в дм(!?!)
dmw         - false
*)
procedure dm_Relief(dmPath,altPath,rlfPath: PChar;
                    x1,y1,x2,y2,ed: Integer; dmw: Boolean); stdcall;

//clu: короткое имя файла x.clu, файл в BIN-директории, перед dm_Relief => RelFileName.gsm
//x.clu: 1-ая строка: 0 <цифра пустоты>, далее в каждой строке: <код> <цифра>
//размер x.clu = (w-1)*(h-1), где w*h = размер матрицы .REL (клетки между точками!)
//<цифра> в .gsm -> WORD(2 байта)
procedure dm_Clutter(clu: PChar); stdcall;


////////////////////////////////////////////////////////////
// Изменение проекции карты
// Path - исх карта
// Dest - новая карта
// sys=sys7(1,3,9, 0,0,0) - (sys7 - function in OTypes: 1 - геодез коорд, 3 - мерк цилинд, 9 - wgs84, 0 - баз широта)
// key=Point(0,0)
////////////////////////////////////////////////////////////
function dm_sys_dm(Path,Dest: PChar;
                   const sys: tsys;
                   const key: TPoint): Boolean; stdcall;

////////////////////////////////////////////////////////////
// карта закрыта
// при mode<>0 переставляет оси xy (mode - из dmw_use.dm_xy_rotate)
// требует после переоткрыть карту (см. check_dm_xy.pas)
////////////////////////////////////////////////////////////
procedure dm_swap_xy(path: PChar; mode: integer); stdcall;


implementation

uses Wcmn;

const dll_util = 'dm_util.dll';


function dmw_ErrCode: Integer; stdcall;
external dll_util;


procedure dm_Cut(srcPath,dstPath,altPath: pChar; x1,y1,x2,y2: longint;
                 rgbp: pDmwColors; a,b,c:lpoint; rotate:boolean);
external dll_util;


procedure my_dm_Cut1(srcPath: pChar; x1,y1,x2,y2: longint);
var sdstPath: string; a,b,c:lpoint;
begin
  sdstPath:=TmpDir+'$.DM';
  dm_Cut(srcPath, PChar(sdstPath), nil, x1,y1,x2,y2, nil, a,b,c, false);
end;


procedure dm_Relief(dmPath,altPath,rlfPath: PChar;
                    x1,y1,x2,y2,ed: Integer; dmw: Boolean);
external dll_util;


procedure dm_Clutter(clu: PChar);
external dll_util;


function dm_sys_dm(Path,Dest: PChar;
                   const sys: tsys;
                   const key: TPoint): Boolean;
external dll_util;


procedure dm_swap_xy(path: PChar; mode: integer);
external dll_util;


end.
