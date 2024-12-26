unit alw_dde; interface

uses
  Windows,OTypes;

function alw_Connect: boolean; stdcall;
procedure alw_Disconnect; stdcall;

//СЕКЦИЯ "ПРОЕКТ":

// Рабочая папка
procedure alw_EnvDir(Dir: PChar); stdcall;

//Вызывать перед dm_Open для активной карты
procedure alw_HideMap; stdcall;

//Активная карта
function alw_Get_ActiveMap(FName: PChar): PChar; stdcall;

//Сменить активную карту
procedure alw_Set_ActiveMap(FName: PChar); stdcall;

//Растр
function alw_Get_Image(FName: PChar): PChar; stdcall;
//Открыть Растр
procedure alw_Set_Image(FName: PChar); stdcall;

//Точки .alx
function alw_Get_Points(FName: PChar): PChar; stdcall;
//Открыть Точки .alx
procedure alw_Set_Points(FName: PChar); stdcall;

//Счетчик карт в проекте
function alw_Get_MapsCount: Integer; stdcall;
// Очистить проект
procedure alw_ClearProject; stdcall;
//Добавить карту в проект
procedure alw_InsertMap(FName: PChar); stdcall;
//Удалить карту из проект
procedure alw_DeleteMap(FName: PChar); stdcall;

// Загрузить проект из "FName"
procedure alw_OpenProject(FName: PChar); stdcall;

// Сохранить текущий проект как "FName"
procedure alw_SaveProject(FName: PChar); stdcall;

// Вернуть имя I-карты из текущего проекта
procedure alw_ProjectMap(I: Integer; FName: PChar); stdcall;

// Добавить в проект рельеф, растры
procedure alw_open_data(List: PChar); stdcall;

// Секция "ОБЪЕКТ":

//Получить параметры активного объекта
procedure alw_OffsObject(out Offs,Code,Loc: Integer;
                         out x1,y1,x2,y2: Integer;
                         Name: PChar); stdcall;

//Снять активность объекта
procedure alw_FreeObject; stdcall;


// Секция "ОКНО":

// scale - масштаб для отображения в окне
// X_пиксел = X_метр * K
// K = 1 / (MetersPerPixel * scale)

//Предъявить в окне и активизировать объект
// cn=0 - id: Offset
// cn=1 - id: Identifier
// (up=-1) & (scale=0) - не двигать окно
// (up=0) & (scale=0) - двигать окно не меняя масштаб
procedure alw_ShowObject(cn, id, up: Integer; scale: Double); stdcall;

// x1,y1,x2,y2 - метры
procedure alw_GetWindow(out x1,y1,x2,y2: Double); stdcall;
procedure alw_SetWindow(x1,y1,x2,y2: Double); stdcall;

// cx,cy - Метры проекции карты
procedure alw_GetCentre(out cx,cy,sc: Double); stdcall;
procedure alw_SetCentre(cx,cy,sc: Double); stdcall;

//Добавить, удалить векторный примитив в список
//Id - номер примитива
//Loc - тип примитива
//Color - графика
//lp = nil  - удалить
//lp <> nil - добавить
//txt - текст подписи
function alw_DrawVector(Id,Loc,Color: Integer;
                        lp: PLLine; txt: PChar): Integer; stdcall;

procedure alw_SetFocus; stdcall;

procedure alw_Indexing; stdcall;

// x,y,z - точка глаза
// teta - наклон, psi - курс -- радианы
// pps =0: (x,y) - метры; =1: (x,y) - радианы
procedure alw_d3_vpt(x,y,z, teta,psi: Double; pps: Integer); stdcall;

// dm - номер карты в проекте
// [dm=-1] - активная карта
// ptr - указатель объекта
// x,y,z - точка на проводе
procedure alw_d3_wire(dm,ptr: Integer; x,y,z: Double);

// vp[0] - первая точка, метры проекции
// vp[1] - вторая точка, метры, метры
// r     - радиус, метры
// z1,z2 - диапазон по высоте
procedure alw_xy_profile(vp: PGPoly; r,z1,z2: Double); stdcall;

//СЕКЦИЯ "ВЫБОРКА":

// Счетчик
function alw_sel_Count: Integer; stdcall;
// Получить объект из выборки
function alw_sel_Object(I: Integer): Integer; stdcall;
// Получить объекты из парной выборки
function alw_sel_Objects(I: Integer;
                         out p1,p2: Integer): Boolean; stdcall;


//СЕКЦИЯ "РАЗНОЕ":

//Выбрать объект в классификаторе Objects
//(ICode,ILoc - нач.значения - м.б. 0,0)
function alw_Dial_Object(Objects: PChar; ICode,ILoc: Integer;
                         out Code,Loc: Integer; Name: PChar): Boolean;
stdcall;

//Указание объекта
function alw_Pick_Object: Boolean; stdcall;

//Указание вектора
function alw_Pick_Vector: Boolean; stdcall;

//Указание прямоугольника
function alw_Pick_Rect: Boolean; stdcall;

function alw_win_Count: Integer; stdcall;
function alw_win_Object(I: Integer): Integer; stdcall;

// Выключить видимость объектов по первой букве кода
procedure alw_disp_codes(Str: PChar); stdcall;

procedure alw_hide_relief; stdcall;
procedure alw_back_relief(Path: PChar); stdcall;

procedure alw_reg_win(H: HWnd); stdcall;

implementation

const
  dll_ole = 'alw_ole.dll';

function alw_Connect: boolean; external dll_ole;
procedure alw_Disconnect; external dll_ole;

procedure alw_EnvDir(Dir: PChar); external dll_ole;

function alw_Get_ActiveMap(FName: PChar): PChar; external dll_ole;
procedure alw_Set_ActiveMap(FName: PChar); external dll_ole;

function alw_Get_Image(FName: PChar): PChar; external dll_ole;
procedure alw_Set_Image(FName: PChar); external dll_ole;

function alw_Get_Points(FName: PChar): PChar; external dll_ole;
procedure alw_Set_Points(FName: PChar); external dll_ole;

function alw_Get_MapsCount: Integer; external dll_ole;
procedure alw_ClearProject; external dll_ole;
procedure alw_InsertMap(FName: PChar); external dll_ole;
procedure alw_DeleteMap(FName: PChar); external dll_ole;

procedure alw_HideMap; external dll_ole;

procedure alw_OffsObject(out Offs,Code,Loc: Integer;
                         out x1,y1,x2,y2: Integer;
                         Name: PChar); external dll_ole;

procedure alw_FreeObject; external dll_ole;

procedure alw_OpenProject(FName: PChar); external dll_ole;
procedure alw_SaveProject(FName: PChar); external dll_ole;
procedure alw_ProjectMap(I: Integer; FName: PChar); external dll_ole;

procedure alw_open_data(List: PChar); external dll_ole;

procedure alw_GetWindow(out x1,y1,x2,y2: Double); external dll_ole;
procedure alw_SetWindow(x1,y1,x2,y2: Double); external dll_ole;
procedure alw_GetCentre(out cx,cy,sc: Double); external dll_ole;
procedure alw_SetCentre(cx,cy,sc: Double); external dll_ole;

function alw_DrawVector(Id,Loc,Color: Integer;
                        lp: PLLine; txt: PChar): Integer;
external dll_ole;

function alw_Dial_Object(Objects: PChar; ICode,ILoc: Integer;
                         out Code,Loc: Integer; Name: PChar): Boolean;
external dll_ole;

function alw_Pick_Object: Boolean; external dll_ole;
function alw_Pick_Vector: Boolean; external dll_ole;
function alw_Pick_Rect: Boolean; external dll_ole;

function alw_sel_Count: Integer; external dll_ole;
function alw_sel_Object(I: Integer): Integer; external dll_ole;

function alw_sel_Objects(I: Integer;
                         out p1,p2: Integer): Boolean;
external dll_ole;

procedure alw_ShowObject(cn, id, up: Integer; scale: Double);
external dll_ole;

procedure alw_SetFocus; external dll_ole;

procedure alw_Indexing; external dll_ole;

procedure alw_d3_vpt(x,y,z, teta,psi: Double; pps: Integer);
external dll_ole;

procedure alw_d3_wire(dm,ptr: Integer; x,y,z: Double);
begin
  alw_d3_vpt(x,y,z, dm,ptr,2);
end;

procedure alw_xy_profile(vp: PGPoly; r,z1,z2: Double);
external dll_ole;

function alw_win_Count: Integer; external dll_ole;
function alw_win_Object(I: Integer): Integer; external dll_ole;

procedure alw_disp_codes(Str: PChar); external dll_ole;

procedure alw_hide_relief; external dll_ole;
procedure alw_back_relief(Path: PChar); external dll_ole;

procedure alw_reg_win(H: HWnd); external dll_ole;

end.


