unit flags; interface



//Флаги позиционирования 3D объекта (можно складывать):
Const ABSOLUTE_Z = 1;
Const ANGLES_FOLLOW_REL = 2;
Const LOOKS_ON_CAMERA = 4;

(*
// Шрифты
Const ARIAL_3D = 0
Const ARIAL_FLAT = 1
Const COURIER_3D = 2
Const COURIER_FLAT = 3
Const TIMES_3D = 4
Const TIMES_FLAT = 5
Const TAHOMA_3D = 6
Const TAHOMA_FLAT = 7

// Флаги текстовой системы
Const SHOW_PLAIN = 0
Const SHOW_PLATE = &H1&
Const SHOW_FRAME = &H2&
Const SHOW_2SIDED = &H4&
Const SHOW_PIKE = &H8&
Const USE_ALPHA = &H10&
Const SHOW_FACED = &H20&
Const SHOW_LIT = &H40&
*)

//Линии и области:
Const
  MOT_LINE = 0;//Loc=2
  MOT_POLY = 1;//Loc=3

  MOT_ABS =  0;//трактовка высоты
  MOT_REL =  2;//трактовка высоты

  MOT_ROOF = 4;//рисовать крышу
  MOT_WALL = 8;//рисовать боковые поверхности

  MOT_ROOF_TEXTURE = $10;//крыша: либо текстура, либо RGB(default)
  MOT_ROOF_COLOR = 0;

  MOT_WALL_TEXTURE = $20;//бок: либо текстура, либо RGB(default)
  MOT_WALL_COLOR = 0;

  MOT_WALL_MULTITEXTURE = $40;//экзотика
  MOT_WALL_SINGLETEXTURE = 0;//default
  

implementation

end.
