(*
  матрицы 3x3 - м.б. ПРОЕКТИВНОЕ преобр-ие
  хранение - по строкам
  воздействие на вектор:
    x' := <x,y,z>*<1-ая строка>
    y' := <x,y,z>*<2-ая строка>
    z' := <x,y,z>*<3-я строка>
*)
unit mat3d; interface

uses Windows,
  nums, vlib, vlib3d;

type
  pmat3d = ^tmat3d;//PDoubles in OTypes
  //pmat3d = ^(array[1..9]of double);//PDoubles in OTypes
  tmat3d = array[1..9]of double;//TDoubles in OTypes


function m3_init: tmat3d;//единичная

function m3_transform(pm: pmat3d; v: tnum3): tnum3;//строки ма-цы * на v-столбец


implementation

//uses wcmn;


function m3_init: tmat3d;//единичная
begin
  FillChar(Result,sizeof(Result),0);
  Result[1]:=1;
  Result[5]:=1;
  Result[9]:=1;
end;


function m3_transform(pm: pmat3d; v: tnum3): tnum3;//строки ма-цы * на v-столбец
begin
  Result.p.x := pm^[1]*v.p.x + pm^[2]*v.p.y + pm^[3]*v.z;
  Result.p.y := pm^[4]*v.p.x + pm^[5]*v.p.y + pm^[6]*v.z;
  Result.z   := pm^[7]*v.p.x + pm^[8]*v.p.y + pm^[9]*v.z;
end;


end.
