UNIT Elm_str;

INTERFACE

USES
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls, registry,
  dmw_use, dmw_ddw, win_use, otypes, st_data;

type

  pGLine = ^tGLine;
  tGLine = record
             N: SmallInt;
             Pol: tGPoly
           end;


  elm_type1=^_elm_type1;
  _elm_type1=record
              P1,P2: lpoint;
              next: elm_type1;    {Ссылка на след-й эл-т списка}
            end;

  TRunLine = class(TForm)
    ProgressBar1: TProgressBar;

  private
    { Private declarations }


  public
    { Public declarations }

    procedure elm_process;
    {Процедура для работы индикатора}

  end;



{ОСНОВНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ}

procedure Task_message(mes:string);
{Запись сообщения в файл}


procedure elm_1(var i: integer);


function elm_distance(var a,b: lpoint): Extended;
{Возвращает расстояние между точками а и b(lpoint)}
function elm_distance2(var a,b: tgauss): Extended;
{Возвращает расстояние между точками а и b(tgauss)}
function elm_distance_pl(var V1,P1,P2: lpoint):Extended;
{Опр-т расстояние от точки V1 до линии (P1,P2)}

procedure elm_get_path(var st,dm: String);
{Возвращает: st - путь до каталога, в кот. расположены файлы *.ini и каталог FILTER
             dm - путь до каталога, в кот. расположен файл dmw.exe}


function elm_Point_on_Otrez(var V0,V1,V2: lpoint):Boolean;
{Опр-т лежит ли точка V0 на отрезке (V1,V2)}


function elm_Point_on_Line(var V0,V1,V2: lpoint):Boolean;
{Опр-т лежит ли точка V0 на прямой (V1,V2)}


function elm_perpend(var P0,P00,P1,P2: lpoint): Boolean;
{Ф-я опускает перпендикуляр из точки P0 на прямую(P1,P2). Р00 - полученная точка.
   =true  - P00 лежит на отрезке (P1,P2)
   =false - P00 не лежит на отрезке (P1,P2)}


procedure elm_X_to_Y(var st: String; const x: Integer);
{Получает перем-ю(st) и преобразует ее длину в X путем добавления вперед нулей}

procedure elm_X_to_Y2(var st: String; const x: Integer);
{Получает перем-ю(st) и преобразует ее длину в X путем добавления в конец пробелов}


procedure elm_Show_Point(var Vg: tgauss; var Mash: longint; var name: pchar);
{Установить для рабочего окна центр <gx,gy> и масштаб <scale> }
{gx,gy - метры; scale - 1:xxxxx                               }


procedure elm_Draw_Sign(var Va: lpoint; name: pchar);
{Рисует знак в точке Vа}


procedure elm_del_end_probel(var st: String);
{Получает строку и отсекает конечные пробелы}


procedure elm_make_perpend_prav(var V1,P1,P2: lpoint);
{(P1,P2) - вектор, направление вектора - от P1 к P2
 V1 - перпендикуляр к точке P2, идущий на право}


procedure elm_make_perpend_levo(var V1,P1,P2: lpoint);
{(P1,P2) - вектор, направление вектора - от P1 к P2
 V1 - перпендикуляр к точке P2, идущий на лево}


function elm_est_file(st: String): Boolean;
{Опр-т сущ-т ли файл st}


function elm_filter_points(var t: plline; V_loc: Byte):Boolean;
{Отфильтровывает совпадающие точки метрики}


procedure elm_add_point(var t: plline; var V: lpoint; var k1: Integer);
{Добавляет метрике t точку V после точки k1 (с переаллокированием памяти)}
procedure elm_add_point2(var t: plline; var V: lpoint; var k1: Integer);
{Добавляет метрике t точку V после точки k1 (без переаллокированием памяти)}


function elm_peresec_otrez(var V1,V2,P1,P2,Tp: lpoint):Boolean;
{Опр-т пересекаются ли отрезки (V1,V2) и (P1,P2). Tp - точка пересечения}
function elm_peresec_otrez2(var V1,V2,P1,P2,Tp: tgauss):Boolean;
{Опр-т пересекаются ли отрезки (V1,V2) и (P1,P2). Tp - точка пересечения}


function elm_peresec_line(var V1,V2,P1,P2,Tp: lpoint):Boolean;
{Опр-т пересекаются ли линии (V1,V2) и (P1,P2). Tp - точка пересечения}


procedure elm_line_leng(var Va,Vb: lpoint; R: Extended);
{Устанавливает длину отрезка Vа,Vb равную R, путем передвижения точки Vb}


function elm_get_text:String;
{Получение текста для текстового объекта(loc=4)}


procedure elm_make_bound(var t: plline; var Va,Vb: lpoint);
{Расчет габаритов Va,Vb для метрики t}
procedure elm_make_bound2(var P1,P2,Pa,Pb: lpoint);
{Расчет габаритов Pa,Pb для отрезка (P1,P2)}


function elm_peresec_bound(var V1,V2,P1,P2: lpoint):Boolean;
{Опр-т пересекаются ли габариты (V1,V2) и (P1,P2)}
function elm_peresec_bound2(var V1,V2,P1,P2: tgauss):Boolean;
{Опр-т пересекаются ли габариты (V1,V2) и (P1,P2)}


procedure elm_Goto_Stack(var Va: lpoint; var Mash: longint; map_name: PChar; var V_ss: Longint);
{Занесение в стек}


function elm_get_ploshad(var t: plline):Extended;
{Расчет площади}


function elm_Ansi_to_Oem(st: String):String;
{Преобразование текста в DOS-кодировку}
function elm_Oem_to_Ansi(st: String):String;
{Преобразование текста в WIN-кодировку}


function elm_cos(var P1,P2,V1,V2: lpoint):Extended;
{Опр-т cos(a) между отрезками}


procedure elm_inc_metric(var t: plline; var d: Extended);
{Расширяет метрику площадного объекта на расстояние d
 Метрика идет против часовой стрелки}
procedure elm_inc_metric_line(var t: plline; var dv: Extended);
{Расширяет метрику линейного объекта на расстояние dv до площадного объекта
 (без переаллокирования памяти)}


procedure elm_move_metric(var t: plline; var dv: Extended; Flevo: Boolean);
{Сдвигает метрику линейного объекта на расстояние dv влево/вправо}



function elm_spriam_line(var t: plline):Boolean;
{Спрямляет метрику линии}


procedure elm_obr_poly(var t: plline);
{Разворачивает метрику}


function elm_dlina_t(var t: plline):Extended;
{Ф-я считает длину метрики}


procedure elm_povorot_vec(var V1,V2: lpoint; Ugol: Extended);
{Ф-я осущ-т поворот вектора (V1,V2) отн-но точки V1 на угол Ugol
 Ugol - величина в градусах, поворот осущ-ся против часовой стрелки}


procedure elm_opr_LH_zn(var V_cod: Longint; var L_zn,H_zn: Extended);
{Расчитывает высоту и длину знака}


procedure elm_start_find;
{Инициализация поиска объектов}
function elm_find_next(var V_ss,V_cod: Longint; var V_loc: Byte):Boolean;
{Ф-я осуществляет поиск следующего объекта в базе}


function elm_point_in_bound(var P,Va,Vb: lpoint):Boolean;
{Ф-я опр-т попадает ли точка Р в область (Va,Vb)}


function elm_is_point(var t: plline):Boolean;
{Ф-я опр-т является ли метрика одной точкой}



var
  RunLine: TRunLine;

  Prov_code: Integer;       {Prov_code     - Переменная используемая для получения кода ошибки}

  put_to_dmw: string;       {Путь до каталога, в кот. расположены файлы *.ini и каталог FILTER}



IMPLEMENTATION

{$R *.DFM}

procedure Task_message(mes:string);
{Запись сообщения в файл}
var
  ft:textfile;
  s:string;
  rgst:TregIniFile;
begin
     rgst:=TRegIniFile.Create('Software');
     rgst.OpenKey('dmw', True);
     s:=rgst.CurrentPath;
     s:=rgst.ReadString('dmw','Working_Directory',Put_to_dmw);
     {Put_to_dmw - путь до директории, где лежит dmw }
     rgst.Free;
     if s[byte(s[0])]='\' then
     s:=s+'task.msg'
     else
     s:=s+'\task.msg';
     assignfile(ft,s);
     {$I-}
     append(ft);
     {$I+}
     if Ioresult<>0 then rewrite(ft);
     writeln(ft,TimeToStr(Time)+' - '+mes);
     closefile(ft);
end;

procedure elm_1(var i: integer);
begin
i:=i+5;
end;


function elm_distance(var a,b: lpoint): Extended;
{Возвращает расстояние между точками а и b(lpoint)}
var
dx,dy: Extended;
begin
dx:=a.x-b.x;
dy:=a.y-b.y;
Result:=sqrt(sqr(dx)+sqr(dy));
end;


function elm_distance2(var a,b: tgauss): Extended;
{Возвращает расстояние между точками а и b(tgauss)}
var
x,y: Extended;
begin
x:=a.x;
y:=a.y;
Result:=sqrt(sqr(x-b.x)+sqr(y-b.y));
end;


procedure TRunLine.elm_process;
{Процедура для работы индикатора}
var
I: Integer;
begin
I:=ProgressBar1.Position;
inc(I,10);
IF I>100 THEN I:=0;
ProgressBar1.Position:=I;
RunLine.update;
end;


procedure elm_get_path(var st,dm: String);
{Возвращает: st - путь до каталога, в кот. расположены файлы *.ini и каталог FILTER
             dm - путь до каталога, в кот. расположен файл dmw.exe}
var
k,I,Y: Integer;
st2: String;
begin
st:=ExtractFilepath(ParamSTR(0));
dm:='';
k:=length(st);
FOR I:=1 TO k-1 DO dm:=dm+st[I];

k:=length(dm);
FOR I:=1 TO k DO IF dm[I]='\' THEN Y:=I;

st:='';
FOR I:=1 TO Y-1 DO st:=st+dm[I];
end;


function elm_Point_on_Otrez(var V0,V1,V2: lpoint):Boolean;
{Опр-т лежит ли точка V0 на отрезке (V1,V2)}
var
dL,L01,L02,L12: Double;
begin
Result:=true;
IF ((V0.x=V1.x)and(V0.y=V1.y)) or ((V0.x=V2.x)and(V0.y=V2.y)) THEN EXIT;
L01:=elm_distance(V0,V1);
L02:=elm_distance(V0,V2);
L12:=elm_distance(V1,V2);
dL:=ABS(L12-(L01+L02));
IF dL<0.005 THEN EXIT;
Result:=false;
end;


function elm_Point_on_Line(var V0,V1,V2: lpoint):Boolean;
{Опр-т лежит ли точка V0 на прямой (V1,V2)}
var
dL1,dL2,L01,L02,L12: Double;
begin
Result:=true;
IF elm_Point_on_Otrez(V0,V1,V2) THEN EXIT;
L01:=elm_distance(V0,V1);
L02:=elm_distance(V0,V2);
L12:=elm_distance(V1,V2);
dL1:=ABS(L01-(L02+L12));
dL2:=ABS(L02-(L01+L12));
IF (dL1<0.005) or (dL2<0.005) THEN EXIT;
Result:=false;
end;


function elm_perpend(var P0,P00,P1,P2: lpoint): Boolean;
{Ф-я опускает перпендикуляр из точки P0 на прямую(P1,P2). Р00 - полученная точка.
   =true  - P00 лежит на отрезке (P1,P2)
   =false - P00 не лежит на отрезке (P1,P2)}
var
dx,dy,R_R,t: double;
begin
dx:=P1.x-P2.x;
dy:=P1.y-P2.y;
R_R:=sqr(dx)+sqr(dy);
t:=dx*(P0.x-P2.x)+dy*(P0.y-P2.y);
t:=t/R_R;
Result:=(t>=0)and(t<=1);
P00.x:=P2.x+round(dx*t);
P00.y:=P2.y+round(dy*t);
end;


procedure elm_X_to_Y(var st: String; const x: Integer);
{Получает перем-ю(st) и преобразует ее длину в X путем добавления вперед нулей}
var
k,I: Integer;
st2: String;
begin
k:=length(st);
IF k=x THEN EXIT;
IF k>x THEN
  begin
    st2:='';
    FOR I:=1 TO x DO st2:=st2+st[I];
    st:=st2;
  end;
IF k<x THEN
  begin
    REPEAT
      st:='0'+st;
      k:=length(st);
    UNTIL k=x;
  end;
end;


procedure elm_X_to_Y2(var st: String; const x: Integer);
{Получает перем-ю(st) и преобразует ее длину в X путем добавления в конец пробелов}
var
k,I: Integer;
st2: String;
begin
k:=length(st);
IF k=x THEN EXIT;
IF k>x THEN
  begin
    st2:='';
    FOR I:=1 TO x DO st2:=st2+st[I];
    st:=st2;
  end;
IF k<x THEN
  begin
    REPEAT
      st:=st+' ';
      k:=length(st);
    UNTIL k=x;
  end;
end;


procedure elm_Show_Point(var Vg: tgauss; var Mash: longint; var name: pchar);
{Установить для рабочего окна центр <gx,gy> и масштаб <scale> }
{gx,gy - метры; scale - 1:xxxxx                               }
var
ss: Longint;
begin
ss:=dm_Object;
dmw_done;
dmw_ShowPoint(Vg.x,Vg.y,Mash);
dmw_open(name,true);
dm_goto_node(ss);
end;


procedure elm_Draw_Sign(var Va: lpoint; name: pchar);
{Рисует знак в точке Vа}
var
st,put_to: String;
ss: Longint;
begin
elm_get_path(put_to,st);
ss:=dm_Object;
dmw_done;
st:=put_to+'\OBJ\ARR.PGM'+#0;
dmw_DrawPgm(Va.x,Va.y,1,PChar(@st[1]));
dmw_open(name,true);
dm_goto_node(ss);
end;


procedure elm_del_end_probel(var st: String);
{Получает строку и отсекает конечные пробелы}
var
I,I2,k: Integer;
begin
I2:=0;
k:=length(st);
IF k=0 THEN Exit;
FOR I:=1 TO k DO IF st[I]<>' ' THEN I2:=I;
IF I2=0 THEN st:='';
IF (I2<>0)and(I2<k) THEN st:=Copy(st,1,I2);
end;


procedure elm_make_perpend_prav(var V1,P1,P2: lpoint);
{(P1,P2) - вектор, направление вектора - от P1 к P2
 V1 - перпендикуляр к точке P2, идущий на право}
begin
V1.x:=P2.x-(P2.y-P1.y);
V1.y:=P2.y+(P2.x-P1.x);
end;


procedure elm_make_perpend_levo(var V1,P1,P2: lpoint);
{(P1,P2) - вектор, направление вектора - от P1 к P2
 V1 - перпендикуляр к точке P2, идущий на лево}
begin
V1.x:=P2.x+(P2.y-P1.y);
V1.y:=P2.y-(P2.x-P1.x);
end;



function elm_est_file(st: String): Boolean;
{Опр-т сущ-т ли файл st}
var
F: File;
begin
AssignFile(F,st);
{$I-}
Reset(F);
{$I+}
IF IOResult<>0 THEN
  begin
    Result:=false;
    Exit;
  end
ELSE
  begin
    CloseFile(F);
    Result:=true;
  end;
end;


function elm_filter_points(var t: plline; V_loc: Byte):Boolean;
{Отфильтровывает совпадающие точки метрики}
var
I,Y: Integer;
Label L_1;
begin
Result:=false;
L_1: ;
IF V_loc=4 THEN IF t^.N=0 THEN
  begin
    Result:=true;
    Exit;
  end;
IF t^.N<1 THEN Exit;
FOR I:=0 TO (t^.N-1) DO
  begin
    IF (t^.pol[I].x=t^.pol[I+1].x)and(t^.pol[I].y=t^.pol[I+1].y) THEN
      begin
        IF I<>(t^.N-1) THEN FOR Y:=(I+1) TO (t^.N-1) DO
          begin
            t^.pol[Y].x:=t^.pol[Y+1].x;
            t^.pol[Y].y:=t^.pol[Y+1].y;
          end;
        dec(t^.N);
        goto L_1;
      end;
  end;
Result:=true;
end;


procedure elm_add_point(var t: plline; var V: lpoint; var k1: Integer);
{Добавляет метрике t точку V после точки k1}
var
kk,k,I: Integer;
tt: plline;
begin
k:=t^.N;
kk:=t^.N;
IF k1>k THEN Exit;
GetMem(tt,65528);
move(t^,tt^,2+(k+1)*sizeof(lpoint));
FreeMem(t,2+(k+1)*sizeof(lpoint));
inc(k);
Getmem(t,2+(k+1)*sizeof(lpoint));
t^.N:=k;
FOR I:=0 TO k1 DO
  begin
    t^.pol[I].x:=tt^.pol[I].x;
    t^.pol[I].y:=tt^.pol[I].y;
  end;
t^.pol[k1+1].x:=V.x;
t^.pol[k1+1].y:=V.y;
IF kk<>k1 THEN FOR I:=k1+2 TO k DO
  begin
    t^.pol[I].x:=tt^.pol[I-1].x;
    t^.pol[I].y:=tt^.pol[I-1].y;
  end;
FreeMem(tt,65528);
end;


procedure elm_add_point2(var t: plline; var V: lpoint; var k1: Integer);
{Добавляет метрике t точку V после точки k1}
var
kk,k,I: Integer;
tt: plline;
begin
k:=t^.N;
kk:=t^.N;
IF k1>k THEN Exit;
GetMem(tt,65528);
move(t^,tt^,2+(k+1)*sizeof(lpoint));
inc(k);
t^.N:=k;
FOR I:=0 TO k1 DO
  begin
    t^.pol[I].x:=tt^.pol[I].x;
    t^.pol[I].y:=tt^.pol[I].y;
  end;
t^.pol[k1+1].x:=V.x;
t^.pol[k1+1].y:=V.y;
IF kk<>k1 THEN FOR I:=k1+2 TO k DO
  begin
    t^.pol[I].x:=tt^.pol[I-1].x;
    t^.pol[I].y:=tt^.pol[I-1].y;
  end;
FreeMem(tt,65528);
end;


function elm_peresec_otrez(var V1,V2,P1,P2,Tp: lpoint):Boolean;
{Опр-т пересекаются ли отрезки (V1,V2) и (P1,P2). Tp - точка пересечения}
var
d_x,d_y,R1,R2,dx,dy,a1,a2,b1,b2,c1,c2,det: Extended;
PP1,PP2,VV1,VV2: lpoint;
begin
Result:=false;

a1:=V2.y-V1.y;
b1:=V1.x-V2.x;
R1:=V1.y;
R2:=V1.x;
c1:=R1*(-b1)-R2*(a1);
a2:=P2.y-P1.y;
b2:=P1.x-P2.x;
R1:=P1.y;
R2:=P1.x;
c2:=R1*(-b2)-R2*(a2);
{a1:=V2.y-V1.y;
b1:=V1.x-V2.x;
c1:=V1.y*(V2.x-V1.x)-V1.x*(V2.y-V1.y);
a2:=P2.y-P1.y;
b2:=P1.x-P2.x;
c2:=P1.y*(P2.x-P1.x)-P1.x*(P2.y-P1.y);}

det:=a1*b2-a2*b1;
IF det=0 THEN Exit;

IF P1.x<P2.x THEN
  begin
    PP1.x:=P1.x;
    PP2.x:=P2.x;
  end
ELSE
  begin
    PP1.x:=P2.x;
    PP2.x:=P1.x;
  end;
IF P1.y<P2.y THEN
  begin
    PP1.y:=P1.y;
    PP2.y:=P2.y;
  end
ELSE
  begin
    PP1.y:=P2.y;
    PP2.y:=P1.y;
  end;

IF V1.x<V2.x THEN
  begin
    VV1.x:=V1.x;
    VV2.x:=V2.x;
  end
ELSE
  begin
    VV1.x:=V2.x;
    VV2.x:=V1.x;
  end;
IF V1.y<V2.y THEN
  begin
    VV1.y:=V1.y;
    VV2.y:=V2.y;
  end
ELSE
  begin
    VV1.y:=V2.y;
    VV2.y:=V1.y;
  end;

dx:=(c1*b2-c2*b1)/det;
dy:=(a1*c2-a2*c1)/det;
d_x:=-dx;
d_y:=-dy;
IF (d_x<PP1.x)or(d_x>PP2.x) THEN Exit;
IF (d_y<PP1.y)or(d_y>PP2.y) THEN Exit;
IF (d_x<VV1.x)or(d_x>VV2.x) THEN Exit;
IF (d_y<VV1.y)or(d_y>VV2.y) THEN Exit;
Tp.x:=round(d_x);
Tp.y:=round(d_y);
{IF not elm_Point_on_Otrez(Tp,V1,V2) THEN Exit;
IF not elm_Point_on_Otrez(Tp,P1,P2) THEN Exit;}
Result:=true;
end;


function elm_peresec_otrez2(var V1,V2,P1,P2,Tp: tgauss):Boolean;
{Опр-т пересекаются ли отрезки (V1,V2) и (P1,P2). Tp - точка пересечения}
var
R1,R2,dx,dy,a1,a2,b1,b2,c1,c2,det: Extended;
PP1,PP2,VV1,VV2: tgauss;
begin
Result:=false;

a1:=V2.y-V1.y;
b1:=V1.x-V2.x;
R1:=V1.y;
R2:=V1.x;
c1:=R1*(-b1)-R2*(a1);
a2:=P2.y-P1.y;
b2:=P1.x-P2.x;
R1:=P1.y;
R2:=P1.x;
c2:=R1*(-b2)-R2*(a2);
{a1:=V2.y-V1.y;
b1:=V1.x-V2.x;
c1:=V1.y*(V2.x-V1.x)-V1.x*(V2.y-V1.y);
a2:=P2.y-P1.y;
b2:=P1.x-P2.x;
c2:=P1.y*(P2.x-P1.x)-P1.x*(P2.y-P1.y);}

det:=a1*b2-a2*b1;
IF det=0 THEN Exit;

IF P1.x<P2.x THEN
  begin
    PP1.x:=P1.x;
    PP2.x:=P2.x;
  end
ELSE
  begin
    PP1.x:=P2.x;
    PP2.x:=P1.x;
  end;
IF P1.y<P2.y THEN
  begin
    PP1.y:=P1.y;
    PP2.y:=P2.y;
  end
ELSE
  begin
    PP1.y:=P2.y;
    PP2.y:=P1.y;
  end;

IF V1.x<V2.x THEN
  begin
    VV1.x:=V1.x;
    VV2.x:=V2.x;
  end
ELSE
  begin
    VV1.x:=V2.x;
    VV2.x:=V1.x;
  end;
IF V1.y<V2.y THEN
  begin
    VV1.y:=V1.y;
    VV2.y:=V2.y;
  end
ELSE
  begin
    VV1.y:=V2.y;
    VV2.y:=V1.y;
  end;

dx:=(c1*b2-c2*b1)/det;
dy:=(a1*c2-a2*c1)/det;
Tp.x:=-round(dx);
Tp.y:=-round(dy);
IF (Tp.x<PP1.x)or(Tp.x>PP2.x) THEN Exit;
IF (Tp.y<PP1.y)or(Tp.y>PP2.y) THEN Exit;
IF (Tp.x<VV1.x)or(Tp.x>VV2.x) THEN Exit;
IF (Tp.y<VV1.y)or(Tp.y>VV2.y) THEN Exit;
{IF not elm_Point_on_Otrez(Tp,V1,V2) THEN Exit;
IF not elm_Point_on_Otrez(Tp,P1,P2) THEN Exit;}
Result:=true;
end;


function elm_peresec_line(var V1,V2,P1,P2,Tp: lpoint):Boolean;
{Опр-т пересекаются ли линии (V1,V2) и (P1,P2). Tp - точка пересечения}
var
R1,R2,dx,dy,a1,a2,b1,b2,c1,c2,det: Extended;
PP1,PP2,VV1,VV2: lpoint;
begin
Result:=false;

a1:=V2.y-V1.y;
b1:=V1.x-V2.x;
R1:=V1.y;
R2:=V1.x;
c1:=R1*(-b1)-R2*(a1);
a2:=P2.y-P1.y;
b2:=P1.x-P2.x;
R1:=P1.y;
R2:=P1.x;
c2:=R1*(-b2)-R2*(a2);

det:=a1*b2-a2*b1;
IF det=0 THEN Exit;

IF P1.x<P2.x THEN
  begin
    PP1.x:=P1.x;
    PP2.x:=P2.x;
  end
ELSE
  begin
    PP1.x:=P2.x;
    PP2.x:=P1.x;
  end;
IF P1.y<P2.y THEN
  begin
    PP1.y:=P1.y;
    PP2.y:=P2.y;
  end
ELSE
  begin
    PP1.y:=P2.y;
    PP2.y:=P1.y;
  end;

IF V1.x<V2.x THEN
  begin
    VV1.x:=V1.x;
    VV2.x:=V2.x;
  end
ELSE
  begin
    VV1.x:=V2.x;
    VV2.x:=V1.x;
  end;
IF V1.y<V2.y THEN
  begin
    VV1.y:=V1.y;
    VV2.y:=V2.y;
  end
ELSE
  begin
    VV1.y:=V2.y;
    VV2.y:=V1.y;
  end;

dx:=(c1*b2-c2*b1)/det;
dy:=(a1*c2-a2*c1)/det;
Tp.x:=-round(dx);
Tp.y:=-round(dy);
Result:=true;
end;




procedure elm_line_leng(var Va,Vb: lpoint; R: Extended);
{Устанавливает длину отрезка Vа,Vb равную R, путем передвижения точки Vb}
var
L12,k : Extended;
begin
L12:=elm_distance(Va,Vb);
IF R=L12 THEN EXIT;
IF R<L12 THEN
  begin
    k:=R/(L12-R);
    Vb.x:=round((Va.x+k*Vb.x)/(1+k));
    Vb.y:=round((Va.y+k*Vb.y)/(1+k));
  end;
IF R>L12 THEN
  begin
    k:=L12/(R-L12);
    Vb.x:=round(((1+k)*Vb.x-Va.x)/k);
    Vb.y:=round(((1+k)*Vb.y-Va.y)/k);
  end;
end;

function elm_get_text:String;
{Получение текста для текстового объекта(loc=4)}
var
st : String;
wintxt : pchar;
begin
dm_Get_String(9,256,st);
Getmem(wintxt,256);
st:=st+#0;
OEMtoANSI(pChar(@st[1]),wintxt);
Result:=StrPas(wintxt);
Freemem(wintxt,256);
end;

procedure elm_make_bound(var t: plline; var Va,Vb: lpoint);
{Расчет габаритов Va,Vb для метрики t}
var
I: Integer;
begin
Va:=t^.pol[0];
Vb:=t^.pol[0];
IF t^.N>0 THEN FOR I:=1 TO t^.N DO
  begin
    IF t^.pol[I].x<Va.x THEN Va.x:=t^.pol[I].x;
    IF t^.pol[I].y<Va.y THEN Va.y:=t^.pol[I].y;
    IF t^.pol[I].x>Vb.x THEN Vb.x:=t^.pol[I].x;
    IF t^.pol[I].y>Vb.y THEN Vb.y:=t^.pol[I].y;
  end;
end;


procedure elm_make_bound2(var P1,P2,Pa,Pb: lpoint);
{Расчет габаритов Pa,Pb для отрезка (P1,P2)}
var
I: Integer;
begin
IF P1.x<P2.x THEN
  begin
    Pa.x:=P1.x;
    Pb.x:=P2.x;
  end
ELSE
  begin
    Pa.x:=P2.x;
    Pb.x:=P1.x;
  end;

IF P1.y<P2.y THEN
  begin
    Pa.y:=P1.y;
    Pb.y:=P2.y;
  end
ELSE
  begin
    Pa.y:=P2.y;
    Pb.y:=P1.y;
  end;
end;


function elm_peresec_bound(var V1,V2,P1,P2: lpoint):Boolean;
{Опр-т пересекаются ли габариты (V1,V2) и (P1,P2)}
begin
Result:=false;

IF V2.x<P1.x THEN Exit;

IF V2.y<P1.y THEN Exit;

IF V1.x>P2.x THEN Exit;

IF V1.y>P2.y THEN Exit;

Result:=true;
{Result:=true;

IF (V1.x>=P1.x)and(V1.y>=P1.y)and
   (V1.x<=P2.x)and(V1.y<=P2.y) THEN Exit;

IF (V2.x>=P1.x)and(V2.y>=P1.y)and
   (V2.x<=P2.x)and(V2.y<=P2.y) THEN Exit;

IF (P1.x>=V1.x)and(P1.y>=V1.y)and
   (P1.x<=V2.x)and(P1.y<=V2.y) THEN Exit;

IF (P2.x>=V1.x)and(P2.y>=V1.y)and
   (P2.x<=V2.x)and(P2.y<=V2.y) THEN Exit;

Result:=false;}
end;



function elm_peresec_bound2(var V1,V2,P1,P2: tgauss):Boolean;
{Опр-т пересекаются ли габариты (V1,V2) и (P1,P2)}
begin
Result:=false;

IF V2.x<P1.x THEN Exit;

IF V2.y<P1.y THEN Exit;

IF V1.x>P2.x THEN Exit;

IF V1.y>P2.y THEN Exit;

Result:=true;
end;



procedure elm_Goto_Stack(var Va: lpoint; var Mash: longint; map_name: PChar; var V_ss: Longint);
{Занесение в стек}
var
st: String;
Vg: tgauss;
begin
dm_L_to_G(Va.x,Va.y,Vg.x,Vg.y);
dmw_done;
st:='  '+#0;
dmw_StackPush(Vg.x,Vg.y,Mash,pchar(@st[1]));
dmw_open(map_name,true);
dm_goto_node(V_ss);
end;



function elm_get_ploshad(var t: plline):Extended;
{Расчет площади}
var
I: Integer;
G1,G2: tgauss;
begin
Result:=0;
IF t^.N<1 THEN Exit;
dm_L_to_G(t^.pol[0].x,t^.pol[0].y,G2.x,G2.y);

FOR I:=1 TO t^.N DO
  begin
    G1:=G2;
    dm_L_to_G(t^.pol[I].x,t^.pol[I].y,G2.x,G2.y);
    Result:=Result+G1.x*G2.y-G1.y*G2.x;
  end;

Result:=ABS(Result/2);
end;


function elm_Ansi_to_Oem(st: String):String;
{Преобразование текста в DOS-кодировку}
var
wintxt : pchar;
begin
Getmem(wintxt,256);
st:=st+#0;
ANSItoOEM(pChar(@st[1]),wintxt);
Result:=StrPas(wintxt);
Freemem(wintxt,256);
end;


function elm_Oem_to_Ansi(st: String):String;
{Преобразование текста в WIN-кодировку}
var
wintxt : pchar;
begin
Getmem(wintxt,256);
st:=st+#0;
OEMtoANSI(pChar(@st[1]),wintxt);
Result:=StrPas(wintxt);
Freemem(wintxt,256);
end;




function elm_cos(var P1,P2,V1,V2: lpoint):Extended;
{Опр-т cos(a) между отрезками}
var
L12,L1122: Extended;
P11,P22: lpoint;
begin
elm_perpend(P1,P11,V1,V2);
elm_perpend(P2,P22,V1,V2);

L12:=elm_distance(P1,P2);
L1122:=elm_distance(P11,P22);

Result:=L1122/L12;
end;



procedure elm_inc_metric(var t: plline; var d: Extended);
{Расширяет метрику площадного объекта на расстояние d
 Метрика идет против часовой стрелки}
var
I: Integer;
P,V1,Vn,P1,P2,PP1,PP2: lpoint;
FL: Boolean;

elm_ptm,elm_ptm0,elm_ptmpr,elm_ptmn: elm_type1;

begin
IF t^.N<3 THEN Exit;
IF (t^.pol[0].x<>t^.pol[t^.N].x)or(t^.pol[0].y<>t^.pol[t^.N].y) THEN Exit;

{Создание отрезков, находящихся на расстоянии d от отрезков метрики}
new(elm_ptm);
elm_ptm0:=elm_ptm;
elm_ptmpr:=elm_ptm;
elm_ptm^.next:=nil;

FOR I:=0 TO t^.N-1 DO
  begin
    P1:=t^.pol[I];
    P2:=t^.pol[I+1];

    elm_make_perpend_levo(PP1,P2,P1);
    elm_make_perpend_prav(PP2,P1,P2);
    elm_line_leng(P1,PP1,d);
    elm_line_leng(P2,PP2,d);

    elm_ptm^.P1:=PP1;
    elm_ptm^.P2:=PP2;

    IF I=0 THEN V1:=PP1;
    IF I=t^.N-1 THEN Vn:=PP2;

    elm_ptmpr^.next:=elm_ptm;
    elm_ptmpr:=elm_ptm;
    new(elm_ptm);
    elm_ptm^.next:=nil;
  end;
elm_ptmpr^.next:=nil;
dispose(elm_ptm);


{Расчет точек метрики}
I:=1;
elm_ptm:=elm_ptm0;
WHILE elm_ptm^.next<>nil DO
  begin
    elm_ptmn:=elm_ptm^.next;
    FL:=elm_peresec_line(elm_ptm^.P1,elm_ptm^.P2,elm_ptmn^.P1,elm_ptmn^.P2,P);

    IF FL THEN t^.pol[I]:=P
          ELSE t^.pol[I]:=elm_ptm^.P2;

    inc(I);
    elm_ptm:=elm_ptm^.next;
  end;

FL:=elm_peresec_line(V1,t^.pol[1],Vn,t^.pol[t^.N-1],P);

IF FL THEN t^.pol[0]:=P
      ELSE t^.pol[0]:=V1;
t^.pol[t^.N]:=t^.pol[0];


elm_ptm:=elm_ptm0;
WHILE elm_ptm<>nil DO
  begin
    elm_ptmpr:=elm_ptm^.next;
    dispose(elm_ptm);
    elm_ptm:=elm_ptmpr;
  end;
end;


function elm_spriam_line(var t: plline):Boolean;
{Спрямляет метрику линии}
var
I,Y: Integer;
V1,V2,V0: lpoint;

Label L_1;

begin
Result:=false;

L_1: ;
IF t^.N<2 THEN Exit;
FOR I:=0 TO t^.N-2 DO
  begin
    V1:=t^.pol[I];
    V0:=t^.pol[I+1];
    V2:=t^.pol[I+2];
    IF elm_Point_on_Otrez(V0,V1,V2) THEN
      begin
        Result:=true;
        dec(t^.N);
        FOR Y:=I+1 TO t^.N DO t^.pol[Y]:=t^.pol[Y+1];
        goto L_1;
      end;
  end;
end;



procedure elm_obr_poly(var t: plline);
{Разворачивает метрику}
var
I: Integer;
t2: plline;
begin
GetMem(t2,65528);
move(t^,t2^,2+(t^.N+1)*sizeof(lpoint));

t^.N:=t2^.N;
FOR I:=t2^.N DOWNTO 0 DO t^.pol[t2^.N-I]:=t2^.pol[I];

FreeMem(t2,65528);
end;



function elm_distance_pl(var V1,P1,P2: lpoint):Extended;
{Опр-т расстояние от точки V1 до линии (P1,P2)}
var
V11: lpoint;
begin
Result:=0;

IF elm_Point_on_Line(V1,P1,P2) THEN Exit;

elm_perpend(V1,V11,P1,P2);
Result:=elm_distance(V1,V11);
end;


procedure elm_inc_metric_line(var t: plline; var dv: Extended);
{Расширяет метрику линейного объекта на расстояние dv до площадного объекта
 (без переаллокирования памяти)}
var
k,I: Integer;
PP_1,P1,P2,P3,PP1,PP2: lpoint;
L: Extended;
t2,t3: plline;

begin
IF t^.N<1 THEN Exit;

Getmem(t2,65528);
Getmem(t3,65528);

t2^.N:=t^.N;
t3^.N:=t^.N;

FOR I:=0 TO t^.N DO
  begin
    P1:=t^.pol[I];
    IF I<>0 THEN P2:=t^.pol[I-1]
    ELSE
      begin
        L:=elm_distance(P1,t^.pol[I+1]);
        L:=L*2;
        P2:=P1;
        elm_line_leng(t^.pol[I+1],P2,L);
      end;
    IF I<>t^.N THEN P3:=t^.pol[I+1]
    ELSE
      begin
        L:=elm_distance(P1,t^.pol[I-1]);
        L:=L*2;
        P3:=P1;
        elm_line_leng(t^.pol[I-1],P3,L);
      end;


    L:=100;
    elm_make_perpend_levo(PP1,P2,P1);
    elm_line_leng(P1,PP1,L);
    elm_make_perpend_prav(PP2,P3,P1);
    elm_line_leng(P1,PP2,L);


    PP_1:=PP1;
    PP1.x:=round((PP1.x+PP2.x)/2);
    PP1.y:=round((PP1.y+PP2.y)/2);
    IF (PP1.x=P1.x)and(PP1.y=P1.y) THEN PP1:=PP_1;
    elm_line_leng(P1,PP1,dv);
    t2^.pol[I]:=PP1;

    L:=dv*2;
    PP2:=P1;
    elm_line_leng(PP1,PP2,L);
    t3^.pol[I]:=PP2;
  end;


k:=t^.N;
t^.N:=t^.N*2+2;
FOR I:=0 TO k DO t^.pol[I]:=t2^.pol[I];
FOR I:=k+1 TO t^.N-1 DO t^.pol[I]:=t3^.pol[(k+1+k)-I];
t^.pol[t^.N]:=t2^.pol[0];


Freemem(t2,65528);
Freemem(t3,65528);
end;



function elm_dlina_t(var t: plline):Extended;
{Ф-я считает длину метрики}
var
I: Integer;
L: Extended;
begin
L:=0;

FOR I:=0 TO t^.N-1 DO L:=L+elm_distance(t^.pol[I],t^.pol[I+1]);

Result:=L;
end;


procedure elm_povorot_vec(var V1,V2: lpoint; Ugol: Extended);
{Ф-я осущ-т поворот вектора (V1,V2) отн-но точки V1 на угол Ugol
 Ugol - величина в градусах, поворот осущ-ся против часовой стрелки}
var
Ug,L,L2,Lv: Extended;
V3,V4,V5,P2,V22: lpoint;
begin
IF (Ugol>=360)or(Ugol=0) THEN Exit;

Lv:=elm_distance(V1,V2);
IF Lv=0 THEN Exit;

V4:=V1;
L:=Lv*2;
elm_line_leng(V2,V4,L);
IF Ugol=180 THEN
  begin
    V2:=V4;
    Exit;
  end;

elm_make_perpend_prav(V3,V2,V1);
elm_line_leng(V1,V3,Lv);
IF Ugol=90 THEN
  begin
    V2:=V3;
    Exit;
  end;

V5:=V1;
elm_line_leng(V3,V5,L);
IF Ugol=270 THEN
  begin
    V2:=V5;
    Exit;
  end;


IF (Ugol>0)and(Ugol<90) THEN
  begin
    P2:=V2;
    Ug:=Ugol;
  end;

IF (Ugol>90)and(Ugol<180) THEN
  begin
    P2:=V3;
    Ug:=Ugol-90;
  end;

IF (Ugol>180)and(Ugol<270) THEN
  begin
    P2:=V4;
    Ug:=Ugol-180;
  end;

IF (Ugol>270)and(Ugol<360) THEN
  begin
    P2:=V5;
    Ug:=Ugol-270;
  end;


Ug:=Ug*pi/180;
elm_make_perpend_levo(V22,V1,P2);

L2:=ABS(Lv*(sin(Ug))/(cos(Ug)));

elm_line_leng(P2,V22,L2);

elm_line_leng(V1,V22,Lv);

V2:=V22;
end;


procedure elm_opr_LH_zn(var V_cod: Longint; var L_zn,H_zn: Extended);
{Расчитывает высоту и длину знака}
var
max: Word;
VV1,VV2,Va,Vb: lpoint;
t_r: plline;
begin
L_zn:=0;
H_zn:=0;
Getmem(t_r,65528);
t_r^.N:=1024;
max:=1024;
Va.x:=0;
Va.y:=0;
Vb:=Va;
dm_Sign_Bound(V_cod,Va,Vb,t_r,max);
IF t_r^.N>=4 THEN
  begin
    elm_make_bound(t_r,VV1,VV2);
    L_zn:=ABS(VV1.x-VV2.x);
    H_zn:=ABS(VV1.y-VV2.y);
  end;
Freemem(t_r,65528);
end;


procedure elm_start_find;
{Инициализация поиска объектов}
begin
dm_goto_root;
end;


function elm_find_next(var V_ss,V_cod: Longint; var V_loc: Byte):Boolean;
{Ф-я осуществляет поиск следующего объекта в базе}
Label L_1,L_2,L_3;
begin
Result:=true;

L_1: ;
IF dm_goto_down THEN
  begin
   L_3: ;
    V_ss:=dm_object;
    V_cod:=dm_get_code;
    V_loc:=dm_get_local;
    IF (V_loc<>1)and(V_loc<>2)and(V_loc<>3)and(V_loc<>4) THEN goto L_1;
    IF V_cod=0 THEN goto L_1;
    Exit;
  end;

L_2: ;
IF dm_goto_right THEN goto L_3;

IF not dm_goto_upper THEN
  begin
    Result:=false;
    Exit;
  end
ELSE goto L_2;
end;


function elm_point_in_bound(var P,Va,Vb: lpoint):Boolean;
{Ф-я опр-т попадает ли точка Р в область (Va,Vb)}
begin
Result:=true;

IF (P.x>=Va.x)and(P.x<=Vb.x)and
   (P.y>=Va.y)and(P.y<=Vb.y) THEN Exit;

Result:=false;;
end;


procedure elm_move_metric(var t: plline; var dv: Extended; Flevo: Boolean);
{Сдвигает метрику линейного объекта на расстояние dv влево/вправо}
var
k,I: Integer;
PP_1,P1,P2,P3,PP1,PP2: lpoint;
L: Extended;
t2,t3: plline;

begin
IF t^.N<1 THEN Exit;

Getmem(t2,65528);
Getmem(t3,65528);

t2^.N:=t^.N;
t3^.N:=t^.N;

FOR I:=0 TO t^.N DO
  begin
    P1:=t^.pol[I];
    IF I<>0 THEN P2:=t^.pol[I-1]
    ELSE
      begin
        L:=elm_distance(P1,t^.pol[I+1]);
        L:=L*2;
        P2:=P1;
        elm_line_leng(t^.pol[I+1],P2,L);
      end;
    IF I<>t^.N THEN P3:=t^.pol[I+1]
    ELSE
      begin
        L:=elm_distance(P1,t^.pol[I-1]);
        L:=L*2;
        P3:=P1;
        elm_line_leng(t^.pol[I-1],P3,L);
      end;


    L:=100;
    elm_make_perpend_levo(PP1,P2,P1);
    elm_line_leng(P1,PP1,L);
    elm_make_perpend_prav(PP2,P3,P1);
    elm_line_leng(P1,PP2,L);


    PP_1:=PP1;
    PP1.x:=round((PP1.x+PP2.x)/2);
    PP1.y:=round((PP1.y+PP2.y)/2);
    IF (PP1.x=P1.x)and(PP1.y=P1.y) THEN PP1:=PP_1;
    elm_line_leng(P1,PP1,dv);
    t2^.pol[I]:=PP1;

    L:=dv*2;
    PP2:=P1;
    elm_line_leng(PP1,PP2,L);
    t3^.pol[I]:=PP2;
  end;

IF Flevo THEN move(t2^,t^,2+(t2^.N+1)*sizeof(lpoint))
         ELSE move(t3^,t^,2+(t3^.N+1)*sizeof(lpoint));

Freemem(t2,65528);
Freemem(t3,65528);
end;


function elm_is_point(var t: plline):Boolean;
{Ф-я опр-т является ли метрика одной точкой}
var
I: Integer;
begin
Result:=false;

FOR I:=0 TO t^.N DO IF (t^.pol[I].x<>t^.pol[0].x)or(t^.pol[I].y<>t^.pol[0].y) THEN Exit;

Result:=true;
end;


END.

