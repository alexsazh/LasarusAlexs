(*
  Значения разделов Help_ID:

  Значение Help_ID = 0 - СОДЕРЖАНИЕ!!!
  Для строк меню значения - см. procedure help_menu_set_ids
*)
unit help;

{$MODE Delphi}

 interface


//Строки меню (1-100) - значения см. ниже:
procedure help_menu_set_ids;


const
  //Формы (101-200):
  _help_main_general  = 101;//вкладка "Общие"
  _help_main_page     = 102;//вкладка "Страница карты"
  _help_main_rect     = 103;//вкладка "Участок карты"
  _help_main_opt      = 104;//вкладка "Параметры"
  _help_main_size     = 105;//вкладка "Размеры"

  _help_colsep        = 111;//панель "Цветоделение"

  _help_psfile        = 121;//панель "PS-файл"


implementation

uses MSW_1;


procedure help_menu_set_ids;
begin

  //меню "Файл":
  FormMain.PSFileItem.HelpContext   := 11;//меню "Файл"/"PS-файл"
  FormMain.CmdFileItem.HelpContext  := 12;//меню "Файл"/"CMD-файл"
  FormMain.DmRepeatItem.HelpContext := 13;//меню "Файл"/"Dm-повтор"
  FormMain.MsRepeatItem.HelpContext := 14;//меню "Файл"/"Ms-повтор"

  //меню "Параметры":
  FormMain.PsCfgItem.HelpContext      := 21;//меню "Параметры"/"PS"
  FormMain.MapIncludeItem.HelpContext := 22;//меню "Параметры"/"Использовать прозрачность листов"

end;

end.
