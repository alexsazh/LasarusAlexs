unit cmn;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, classes;

var msgs: TStringList;//список для Tell (для перевода)

const cmn_Tiffs_for_Web: boolean = FALSE;

var//FOR MSS_WM EVENTS IMPLEMENTATION:
  cmn_a, cmn_b: TPoint;//прямоугольник на карте
  cmn_lw, cmn_lh, cmn_mscale: longint;
  cmn_k, cmn_zoom, cmn_rpw, cmn_rph, cmn_upm{dm-units per meter}: real;
  cmn_use_map_include: boolean;

const cmn_pick_mode: integer = -1;//0 - port, 1 - вычисление увеличения, 2 - вычисление страницы


function cmn_map_bound(var a,b: TPoint): boolean;


implementation

uses Wcmn, Dmw_ddw, dmw_Use;


function cmn_map_bound(var a,b: TPoint): boolean;
begin
  Result:=FALSE;
  dmw_HideMap;//На всякий случай!

  if dmw_open_dm(false{edit}) then try
    dm_goto_root;
    dm_get_bound(a,b);
    Result:=TRUE;
  finally
    dmw_done;
  end;
end;


initialization
  msgs:=TStringList.Create;

  msgs.Add('Не указан классификатор');//0
  msgs.Add('Неправильно указано увеличение');//1
  msgs.Add('Ошибка в размерах бумаги');//2
  msgs.Add('Нет активной карты');//3
  msgs.Add('Размеры страницы в бланке карты исчезающе малы. Стоп.');//4

  msgs.Add('Удалить?');//5
  msgs.Add('Командный файл "%s" выполнен успешно');//6
  msgs.Add('Ошибки в командном файле "%s"');//7
  msgs.Add('Одинаковые имена:\n%s --> %s');//8
  msgs.Add('Файл %s уже существует.\nЗаменить его?');//9

  msgs.Add('Ошибка открытия карты');//10
  msgs.Add('Страница %d не найдена.');//11
  msgs.Add('Страница на карте исчезающе мала');//12
  msgs.Add('Нет файла');//13
  msgs.Add('Ошибка формата в команде:\n<%s %s>');//14

  msgs.Add('Укажите "Выходной PS-файл" для выбора выходной директории');//15
  msgs.Add('Не найден файл проекта "%s"');//16
  msgs.Add('Ошибка открытия проекта "%s"');//17
  msgs.Add('Неизвестная команда <%s> в файле "%s"');//18
  msgs.Add('Не заполнена характеристика области вставки (имя классификатора)');//19

  msgs.Add('Ошибка в заполнении характеристики вставки (файл не существует):\n%s\n%s\n%s');//20
  msgs.Add('Ошибка загрузки библиотеки <msw.dll>');//21

finalization
  msgs.Free;

end.
