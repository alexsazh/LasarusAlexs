unit _webcmn;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, Vlib, Types;


const
  _webcmn_webmaps_process: boolean = FALSE;//работа прогр-мы _webmaps1._webmaps_process

  //_webcmn_IMG_dirname: string = '';//with "\" - директория для .@@@, .tif

  _webcmn_Altpath: string = '';//AltProject - файл со списком "остальных" карт
  _webcmn_dmpath: string = '';//текущая карта построения растров
  _webcmn_pspath: string = '';//текущий ps-файл
  _webcmn_expand: tnum2 = (x:1; y:1);//коэф. расширения рамки карты

var
  _webcmn_a,_webcmn_b: TPoint;//рамка вокруг карты
  _webcmn_page: tnum2;//w,h - x,y - мм



implementation


end.
