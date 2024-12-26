UNIT nevautil;

INTERFACE

USES
  SysUtils, Windows, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ComObj, ActiveX,
  dmw_use,  otypes, blgeo;

type
  lpoint=Tpoint;
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

const
   fl_debug:boolean=false;
   lang_interface:byte=1;


{ОСНОВНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ}

procedure Task_message(mes:string);
{Запись сообщения в файл}

function get_VectorSQR(t: plline):Extended;
function get_VectorSQRPolyLine(t: pPolyLine):Extended;

procedure elm_1(var i: integer);


function elm_distance(var a,b: lpoint): Extended;
{Возвращает расстояние между точками а и b(lpoint)}
function sqr_distance(var a,b: lpoint): Extended;
{Возвращает квадрат расстояния между точками а и b(lpoint)}

function elm_distance2(var a,b: tgauss): Extended;
{Возвращает расстояние между точками а и b(tgauss)}
function elm_distance_pl(var V1,P1,P2: lpoint):Extended;
{Опр-т расстояние от точки V1 до линии (P1,P2)}


procedure elm_get_path(var st,dm: shortString);
{Возвращает: st - путь до каталога, в кот. расположены файлы *.ini и каталог FILTER
             dm - путь до каталога, в кот. расположен файл dmw.exe}


function elm_Point_on_Otrez(var V0,V1,V2: lpoint):Boolean;
{Опр-т лежит ли точка V0 на отрезке (V1,V2)}

function elm_Point_on_Otrez2(var V0,V1,V2: lpoint; porog:double):Boolean;

function elm_Point_on_Line(var V0,V1,V2: lpoint):Boolean;
{Опр-т лежит ли точка V0 на прямой (V1,V2)}


function elm_perpend(var P0,P00,P1,P2: lpoint): Boolean;
{Ф-я опускает перпендикуляр из точки P0 на прямую(P1,P2). Р00 - полученная точка.
   =true  - P00 лежит на отрезке (P1,P2)
   =false - P00 не лежит на отрезке (P1,P2)}


procedure elm_X_to_Y(var st: String;  x: Integer);
{Получает перем-ю(st) и преобразует ее длину в X путем добавления вперед нулей}

procedure elm_X_to_Y2(var st: String;  x: Integer);
{Получает перем-ю(st) и преобразует ее длину в X путем добавления в конец пробелов}




procedure elm_del_end_probel(var st: String);
{Получает строку и отсекает конечные пробелы}


procedure elm_make_perpend_prav(var V1,P1,P2: lpoint);
{(P1,P2) - вектор, направление вектора - от P1 к P2
 V1 - перпендикуляр к точке P2, идущий на право}


procedure elm_make_perpend_levo(var V1,P1,P2: lpoint);
{(P1,P2) - вектор, направление вектора - от P1 к P2
 V1 - перпендикуляр к точке P2, идущий на лево}


//function elm_est_file(st: String): Boolean;
{Опр-т сущ-т ли файл st}


function elm_filter_points( t: plline; V_loc: Byte):Boolean;
function elm_filter_PolyLine( t: pPolyLine; V_loc: Byte):Boolean;
{Отфильтровывает совпадающие точки метрики}


procedure elm_add_point(var t: plline; var V: lpoint;  k1: Integer);
{Добавляет метрике t точку V после точки k1 (с переаллокированием памяти)}
procedure elm_add_point2(var t: plline; var V: lpoint; k1: Integer);
{Добавляет метрике t точку V после точки k1 (без переаллокированием памяти)}

procedure add_point_globalrealloc(var t: plline; var V: lpoint; k1: Integer);
{Добавляет метрике t точку V после точки k1 (с переаллокированием памяти globalrealloc)}


function elm_peresec_otrez(var V1,V2,P1,P2,Tp: lpoint):Boolean;
{Опр-т пересекаются ли отрезки (V1,V2) и (P1,P2). Tp - точка пересечения}
function elm_peresec_otrez2(var V1,V2,P1,P2,Tp: tgauss):Boolean;
{Опр-т пересекаются ли отрезки (V1,V2) и (P1,P2). Tp - точка пересечения}


function elm_peresec_line(var V1,V2,P1,P2,Tp: lpoint):Boolean;
{Опр-т пересекаются ли линии (V1,V2) и (P1,P2). Tp - точка пересечения}


procedure elm_line_leng(var Va,Vb: lpoint;  R: Extended);
{Устанавливает длину отрезка Vа,Vb равную R, путем передвижения точки Vb}
procedure tg_line_leng(var Va,Vb: Tgauss;  R: Extended);


function elm_get_text:String;
{Получение текста для текстового объекта(loc=4)}

function elm_get_text_rus(n:word):String;
{Получение текстовой характеристики с перекодированием OEMtoChar}


procedure elm_make_bound(var t: plline; var Va,Vb: lpoint);
procedure elm_make_boundPolyLine(var t: pPolyLine; var Va,Vb: lpoint);
{Расчет габаритов Va,Vb для метрики t}
procedure elm_make_bound2(var P1,P2,Pa,Pb: lpoint);
{Расчет габаритов Pa,Pb для отрезка (P1,P2)}


function elm_peresec_bound(var V1,V2,P1,P2: lpoint):Boolean;
{Опр-т пересекаются ли габариты (V1,V2) и (P1,P2)}
function elm_peresec_bound2(var V1,V2,P1,P2: tgauss):Boolean;
{Опр-т пересекаются ли габариты (V1,V2) и (P1,P2)}


function elm_get_Length(t: plline):Extended;

function elm_get_Length_corr(t: plline):Extended;


function elm_get_ploshad(t: plline):Extended;
{Расчет площади}
//function elm_get_ploshad_corr(t: plline):Extended;


function elm_Ansi_to_Oem(st: String):String;
{Преобразование текста в DOS-кодировку}
function elm_Oem_to_Ansi(st: String):String;
{Преобразование текста в WIN-кодировку}


function elm_cos(var P1,P2,V1,V2: lpoint):Extended;
{Опр-т cos(a) между отрезками}
function real_cos( P1,P2,V1,V2: lpoint):Extended;
{Опр-т cos(a) между отрезками в местных координатах}

function elm_sin(var P1,P2,V1,V2: lpoint):Extended;
{Опр-т cos(a) между отрезками}

procedure elm_inc_metric_line(var t: plline; var dv: Extended);
{Расширяет метрику линейного объекта на расстояние dv до площадного объекта
 (без переаллокирования памяти)}

procedure elm_inc_metric_levo(t: plline; d: Extended);

procedure elm_inc_metric( t: plline; d: Extended);
{Расширяет метрику площадного объекта на расстояние d
 Метрика идет против часовой стрелки}



function elm_spriam_line(var t: plline):Boolean;
{Спрямляет метрику линии}


procedure elm_obr_poly( t: plline);
procedure elm_obr_polyLine( t: ppolyLine);
{Разворачивает метрику}

function Get_line_dist(a:lpoint;Rneib:Extended;PL:Plline):Extended;
function Get_line_distPolyLine(a:lpoint;Rneib:Extended;PL:PPolyLine):Extended;

function Get_line_dist_back(a,Vpr:lpoint;Rneib:double;PL:Plline):double;
function Get_line_dist_direction(a,Vpr:lpoint;Rneib:double;PL:Plline):double;
function Get_line_dist_dir_param(a,Vpr:lpoint;Rneib, dcos:double;PL:Plline):double;

function Get_line_dist_left(a,Vpr,Vpr2:lpoint;Rneib:double;PL:Plline):double;
function Get_line_dist_right(a,Vpr,Vpr2:lpoint;Rneib:double;PL:Plline):double;
procedure Point_near_line(a:lpoint;Rneib:double;PL:plline;var Vpr:lpoint);
function Point_on_linepoint(a:lpoint;PL:Plline):integer;
function Point_near_line_len(a:lpoint;Rneib:double;PL:plline):Extended;
function Point_near_line_len_cor(a:lpoint;Rneib:double;PL:plline):Extended;

function line_neib_perp(x,y:Extended;
                         PL:plline;
                         Rneib:Extended;
                        var nCurr,nNext:integer):boolean;

Procedure Set_Road_perp(edge:boolean;pTl,pTLpr:plline;nCurr,Nnext:integer);

Procedure Set_Point_perp(Lp:Lpoint;pTLpr:plline;nCurr,Nnext:integer; Var Vpr:Lpoint);

function line_neib(x,y:double;a1,a2:lpoint;PL:Plline;
                    var nn,nNext:integer):double;

Procedure Set_Road_node(edge:Integer;a1,a2:lpoint;pTl,pTLpr:plline;nCURR,Nnext:integer);

Function Encode_date(Year,month,Day:word):longint;

procedure Decode_date(Ldate:longint; Var Year,month,Day:word);

function make_ini(sname:string):string;
function make_obj_dir(sname:string):string;

function elm_dlina_t(var t: plline):Extended;
{Ф-я считает длину метрики}

function Get_dir_onPath(t: plline; Dist:double; Var P1,P2:lpoint):boolean;
{Ф-я определяет вектор на пути по расстоянию}

procedure elm_povorot_vec(var V1,V2: lpoint; Ugol: Extended);
{Ф-я осущ-т поворот вектора (V1,V2) отн-но точки V1 на угол Ugol
 Ugol - величина в градусах, поворот осущ-ся против часовой стрелки}
procedure elm_opr_LH_zn(var V_cod: Longint; var L_zn,H_zn: Extended);
{Расчитывает высоту и длину знака}
function elm_point_in_bound(var P,Va,Vb: lpoint):Boolean;
{Ф-я опр-т попадает ли точка Р в область (Va,Vb)}

function elm_is_point(var t: plline):Boolean;
{Ф-я опр-т является ли метрика одной точкой}

procedure elm_move_metric(var t: plline; dv: Extended; Flevo: Boolean);

function GetBulkCount:integer;

Procedure GetBulkPoly(plVe:plline);

Procedure GetBulkPolyLine(plVe:pPolyLine);

procedure SetBulk(PL:Plline);
procedure SetBulkPolyLine(PL:PPolyLine);

// переносит ребра дырки. Возвращает номер крайнего ребра основного контура
function MoveHoles(PlSrc, plDest:Plline):integer;

procedure ProcMess;

function SetFOC(hWnd:HWND):boolean;
function ForceFgWindow(hwnd: THandle): boolean;

function Get_linked_Object(nd:integer;pAcr:Pchar):integer;
function CreateGuid: string;

const
 Rmax:double=1.e38;
 Emax:Extended=1.e4800;
 flclose:boolean=false;

var
  TimePred:TDateTime;
  Prov_code: Integer;       {Prov_code     - Переменная используемая для получения кода ошибки}

  Bin_dir: Ansistring;       {Путь до каталога BIN}
  work_dir: Ansistring;       {Путь до каталога, в кот. расположены файлы *.ini и каталог FILTER}

  plGlobaL, plGlobaL2:Plline;
  pFiles:Pchar;
   guid,acronym,pname:Pchar;

IMPLEMENTATION
function make_ini(sname:string):string;
//  var
    //rgst:TregIniFile;
 //   s:shortstring;
//    pc:pchar;
begin
     {rgst:=TRegIniFile.Create('Software');
     rgst.OpenKey('dmw', True);
     s:=rgst.ReadString('dmw','bin_dir',ExtractFilepath(ParamSTR(0)));
     s[byte(s[0])]:=#0;
     pc:=StrRscan(@s[1],'\');
     pc^:=#0;
     Work_dir:=Strpas(@s[1]);
     }
     result:=Work_dir+'\ini';
     //if not DirectoryExists(result) then
     //   ForceDirectories(result);
     result:=result+'\'+Sname;
  //   rgst.Free;
end;
function make_obj_dir(sname:string):string;
 // var
 //   rgst:TregIniFile;
 //   s:shortstring;
 //   pc:pchar;
begin
    { rgst:=TRegIniFile.Create('Software');
     rgst.OpenKey('dmw', True);
     s:=rgst.ReadString('dmw','bin_dir',ExtractFilepath(ParamSTR(0)))+#0;
     pc:=StrRscan(@s[1],'\');
     (pc+1)^:=#0;
     result:=Strpas(@s[1])+'obj'; }
     result:=Work_dir+'\obj';
     if not DirectoryExists(result) then
        ForceDirectories(result);
     result:=result+'\'+Sname;
end;

Function Encode_date(Year,month,Day:word):longint;
begin
 Result:=Year*10000+month*100+Day;
end;

procedure Decode_date(Ldate:longint; Var Year,month,Day:word);
begin
{If Ldate<10000 then begin
     Year:=Ldate;
     month:=0;
     Day:=0;
end else begin
}     Year:=Ldate div 10000;
     month:=(Ldate- Year*10000) div 100;
     Day:=Ldate-Year*10000-month*100;
//end
end;
function line_neib_perp(x,y:extended;
                         PL:plline;
                         Rneib:Extended;
                        var nCurr,nNext:integer):boolean;
var
  RR,RDist,rd,t,tx,ty, ex, ey:extended;
  i:integer;
begin
 RR:=Emax; nCurr:=-1;
     for i:=0 to PL^.n do with PL^ do begin
            Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
            if Rdist<RR then begin
              RR:=Rdist;
              nCurr:=i;
              nNext:=-1;
            end;
            if i<>0 then with PL^ do begin
         //   if (abs(x-PL^.pol[i].x)>Rneib) AND (abs(y-PL^.pol[i].y)>Rneib)
         //      AND (abs(x-PL^.pol[i-1].x)>Rneib) AND (abs(y-PL^.pol[i-1].y)>Rneib) then continue;
              tx:=pol[i-1].x-pol[i].x;
               ty:=pol[i-1].y-pol[i].y;
               Rd:=sqr(tx)+sqr(ty);
               if Rd<>0 then begin
                  ex:=pol[i].x;
                  ey:=pol[i].y;
                  t:=tx*(x-ex)+
                     ty*(y-ey);
                  //If t>=0 then t:=sqrt(t);
                  if (t>=0) and (t<=Rd) then begin
                    Rdist:=SQR(ty*x -
                               tx*y+
                    pol[i-1].x*ey-
                    pol[i-1].y*ex)/Rd;
                  end
                  else Rdist:=Emax;
               end
               else  Rdist:=Emax;
              if Rdist<RR then begin
               RR:=Rdist;
              { if i<>PL^.n then begin
                  nn:=i; nNext:=i-1
                  end
                else begin} nCurr:=i-1; nNext:=i
               { end }
              end
            end {if i<>0}
     end;  {for i}

if nCurr=(-1) then begin line_neib_perp:=false; exit end;
line_neib_perp:=true
end;

Procedure Set_Road_perp(edge:boolean;pTl,pTLpr:plline;nCurr,Nnext:integer);
var
 nn, i, nc1:integer;
 lp1:lPoint;
 Rdist1, t, tx, ty:double;
label
       Ag,lab2;
begin
  if ((nCurr=0) or (nCurr=pTlpr^.n)) and (nNext=-1) then begin
     if edge then
                  pTl^.pol[pTL^.n]:=pTLpr^.pol[nCurr]
      else
           pTL^.pol[0]:=pTLpr^.pol[nCurr];
  end
  else begin
       if nNext=-1 then begin lp1:=ptlpr^.pol[nCurr]; goto lab2; end;
       if edge then nn:=pTl^.n else nn:=0;
       nc1:=nNext;
        i:=0;
        with pTLpr^ do begin
 Ag:
        tx:=pol[nc1].x-pol[nCurr].x;
        ty:=pol[nc1].y-pol[nCurr].y;
      Rdist1:=sqr(tx)+sqr(ty);
        if Rdist1<>0 then begin
          t:=(tx*(pTL^.Pol[nn].x-pol[nCurr].x) +
                    ty*(pTL^.Pol[nn].y-pol[nCurr].y));
          if (t<0.0) or (t>Rdist1) then begin
           inc(i);
           if nc1=nCurr-1 then nc1:=nCurr+1 else nc1:=nCurr-1;
           if i>1 then begin lp1:=pol[nCurr]; goto lab2 end;
           goto Ag;
          end;
          t:=t/Rdist1;
          lp1.x:=pol[nCurr].x+round(tx*t);
          lp1.y:=pol[nCurr].y+round(ty*t);
       end
       else lp1:=pol[nCurr];
   end; {with}
   lab2:
      if edge then begin
                  pTl^.pol[pTL^.n]:=lp1
    end
    else
           pTL^.pol[0]:= lp1
  end
end;

Procedure Set_Point_perp(Lp:Lpoint;pTLpr:plline;nCurr,Nnext:integer; Var Vpr:Lpoint);
var
 i,nc1:integer;
 lp1:lPoint;
 Rdist1,t,tx,ty:double;
label
       Ag,lab2;
begin
  if ((nCurr=0) or (nCurr=pTlpr^.n)) and (nNext=-1) then begin
     Vpr:=pTLpr^.pol[nCurr]
  end
  else begin
       if nNext=-1 then begin lp1:=ptlpr^.pol[nCurr]; goto lab2; end;
       nc1:=nNext;
        i:=0;
        with pTLpr^ do begin
 Ag:
        tx:=pol[nc1].x-pol[nCurr].x;
        ty:=pol[nc1].y-pol[nCurr].y;
      Rdist1:=sqr(tx)+sqr(ty);
        if Rdist1<>0 then begin
          t:=(tx*(Lp.x-pol[nCurr].x) +
                    ty*(Lp.y-pol[nCurr].y));
          if (t<0.0) or (t>Rdist1) then begin
           inc(i);
           if nc1=nCurr-1 then nc1:=nCurr+1 else nc1:=nCurr-1;
           if i>1 then begin lp1:=pol[nCurr]; goto lab2 end;
           goto Ag;
          end;
          t:=t/Rdist1;
          lp1.x:=pol[nCurr].x+round(tx*t);
          lp1.y:=pol[nCurr].y+round(ty*t);
       end
       else lp1:=pol[nCurr];
   end; {with}
   lab2:
     Vpr:=lp1
  end
end;


function line_neib(x,y:double;a1,a2:lpoint;PL:Plline;
                    var nn,nNext:integer):double;
var
  i:integer;
  RR,RDist,rd,t,tx,ty,x3,x4,det,xc,yc:double;
begin
 RR:=Rmax; nn:=-1; Nnext:=-1;
     for i:=1 to PL^.n do with PL^ do begin
        { iF i<>0 then with PL^ do begin  }
             tx:=pol[i-1].x-pol[i].x;
             ty:=pol[i-1].y-pol[i].y;
       det:= ty*(a1.x-a2.x)+tx*(a2.y-a1.y);
       if det=0 then continue
       else begin
         x3:=a1.x;
         x4:=a2.x;
         xc:=((ty*pol[i].x-tx*pol[i].y)*(x3-x4)+
              tx*(x3*a2.y-x4*a1.y))/det;
         yc:=(ty*(x3*a2.y-x4*a1.y)+
              (ty*pol[i].x-tx*pol[i].y)*(a1.y-a2.y))/det;

               tx:=pol[i-1].x-pol[i].x;
                 ty:=pol[i-1].y-pol[i].y;
               Rd:=sqr(tx)+sqr(ty);
               if Rd<>0 then begin
                      tx:=pol[i].x;
                  ty:=pol[i].y;
                  t:=(pol[i-1].x-pol[i].x)*(xc-tx)+
                     (pol[i-1].y-pol[i].y)*(yc-ty);

                  if (t>=0) and (t<=Rd) then begin
                    Rdist:=sqr(xc-x)+sqr(yc-y)
                  end
                  else Rdist:=Rmax;
               end
               else  Rdist:=Rmax;
              if Rdist<RR then begin
               RR:=Rdist;
                  {if i<>PL^.n then begin
                  nn:=i; nNext:=i-1
                  end
                else }begin nn:=i-1; nNext:=i
                end
              end
              end
           { end {if i<>0}
     end;  {for i}
line_neib:=RR
end;

Procedure Set_Road_node(edge:Integer;a1,a2:lpoint;pTl,pTLpr:plline;nCURR,Nnext:integer);
var
 lp1:lpoint;
 tx,ty,x3,x4,det:double;
 nc1:integer;
 label
       Ag,lab2;
begin
  if ((nCurr=0) or (nCurr=pTlpr^.n)) and (nNext=-1) then begin
     if edge=1 then
                  pTl^.pol[pTL^.n]:=pTLpr^.pol[nCurr]
      else
           pTL^.pol[0]:=pTLpr^.pol[nCurr];
  end
  else begin
        if nNext=-1 then begin lp1:=ptlpr^.pol[nCurr]; goto lab2; end;
       //if edge=1 then nn:=pTl^.n else nn:=0;
       nc1:=nNext;
       with pTLpr^ do begin
       tx:=pol[nc1].x-pol[Ncurr].x;
       ty:=pol[nc1].y-pol[ncurr].y;
       det:= ty*(a1.x-a2.x)+tx*(a2.y-a1.y);
         x3:=a1.x;
         x4:=a2.x;
         lp1.x:=round(((ty*pol[Ncurr].x-tx*pol[Ncurr].y)*(x3-x4)+
              tx*(x3*a2.y-x4*a1.y))/det);
         lp1.y:=round((ty*(x3*a2.y-x4*a1.y)+
              (ty*pol[NCurr].x-tx*pol[nCurr].y)*(a1.y-a2.y))/det);
   end; {with}
   lab2:
      if edge=1 then begin
                  pTl^.pol[pTL^.n]:=lp1
    end
    else
           pTL^.pol[0]:= lp1
  end
end;


procedure Task_message(mes:string);
{Запись сообщения в файл}
var
  ft:textfile;
  s:shortstring;
  //rgst:TregIniFile;
begin
    if not isLibrary then begin
      ShowMessage(mes);
      exit
    end;
   (*  rgst:=TRegIniFile.Create('Software');
     rgst.OpenKey('dmw', True);
    { s:=rgst.CurrentPath;
    }
    // s:=rgst.ReadString('dmw','Working_Directory',Put_to_dmw);
     {Put_to_dmw - путь до директории, где лежит dmw }
     rgst.Free;
     if s[byte(s[0])]='\' then
     s:=s+'task.msg'
     else
     *)
     s:=work_dir+'\task.msg';

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
function SQR_distance(var a,b: lpoint): Extended;
{Возвращает расстояние между точками а и b(lpoint)}
var
dx,dy: Extended;
begin
dx:=a.x-b.x;
dy:=a.y-b.y;
Result:=sqr(dx)+sqr(dy);
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
procedure elm_get_path(var st,dm: shortString);

{Возвращает: st - путь до каталога, в кот. расположены файлы *.ini и каталог FILTER
             dm - путь до каталога, в кот. расположен файл dmw.exe}
var
  k,I,Y: Integer;
begin
  st:=ExtractFilepath(ParamSTR(0));
  dm:='';
  k:=length(st);
  FOR I:=1 TO k-1 DO dm:=dm+st[I];

  k:=length(dm);
  Y:=0;
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

function elm_Point_on_Otrez2(var V0,V1,V2: lpoint; porog:double):Boolean;
{Опр-т лежит ли точка V0 на отрезке (V1,V2)}
var
  P00:lpoint;
begin
Result:=true;
IF ((V0.x=V1.x)and(V0.y=V1.y)) or ((V0.x=V2.x)and(V0.y=V2.y)) THEN EXIT;
if elm_perpend(V0,P00,V1,V2) then begin
  if elm_distance(V0,P00)<porog then exit
end;

{L01:=elm_distance(V0,V1);
L02:=elm_distance(V0,V2);
L12:=elm_distance(V1,V2);
dL:=ABS(L12-(L01+L02));
IF dL<porog THEN EXIT;
}
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
if R_R =0 then begin
  Result:=(abs(P0.x-P1.x)+abs(P0.y-P1.y))=0;
  P00:=P1;
  exit
end;
t:=dx*(P0.x-P2.x)+dy*(P0.y-P2.y);
t:=t/R_R;

Result:=(t>=0)and(t<=1);
P00.x:=P2.x+round(dx*t);
P00.y:=P2.y+round(dy*t);
end;


procedure elm_X_to_Y(var st: String; x: Integer);
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

procedure elm_X_to_Y2(var st: String; x: Integer);
{Получает перем-ю(st) и преобразует ее длину в X путем добавления в конец пробелов}
var
k,I: Integer;
st2: String;
begin
k:=length(st);
IF k=x THEN EXIT;
IF k>x THEN  begin
    st2:='';
    FOR I:=1 TO x DO st2:=st2+st[I];
    st:=st2;
end;
IF k<x THEN begin
    REPEAT
      st:=st+' ';
      k:=length(st);
    UNTIL k=x;
  end;
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


(*
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
*)

function elm_filter_points(t: plline; V_loc: Byte):Boolean;
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
            t^.pol[Y]:=t^.pol[Y+1];
          end;
        dec(t^.N);
        goto L_1;
      end;
  end;
Result:=true;
end;

function elm_filter_PolyLine(t: pPolyLine; V_loc: Byte):Boolean;
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
            t^.pol[Y]:=t^.pol[Y+1];
          end;
        dec(t^.N);
        goto L_1;
      end;
  end;
Result:=true;
end;


procedure add_point_globalrealloc(var t: plline; var V: lpoint; k1: Integer);
{Добавляет метрике t точку V после точки k1}
var
kk,k,I: Integer;
tt: plline;
begin
k:=t^.N;
kk:=t^.N;
IF k1>k THEN Exit;
tt:=GlobalallocPtr(0,8+(k+1)*sizeof(lpoint));
move(t^,tt^,2+(k+1)*sizeof(lpoint));
inc(k);
GlobalFreePtr(t);
t:=GlobalallocPtr(0,24+k*sizeof(lpoint));
t^.N:=k;
FOR I:=0 TO k1 DO
   t^.pol[I]:=tt^.pol[I];
t^.pol[k1+1]:=V;
IF kk<>k1 THEN FOR I:=k1+2 TO k DO
  begin
    t^.pol[I]:=tt^.pol[I-1];
  end;
GlobalFreeptr(tt);
end;


procedure elm_add_point(var t: plline; var V: lpoint; k1: Integer);
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


procedure elm_add_point2(var t: plline; var V: lpoint; k1: Integer);
{Добавляет метрике t точку V после точки k1}
var
kk,k,I: Integer;
tt: plline;
begin
k:=t^.N;
kk:=t^.N;
IF k1>k THEN Exit;
tt:=GlobalAllocPtr(0,262152);
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
GlobalFreePtr(tt);
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
  R1,R2,dx,dy,a1,a2,b1,b2,c2,det: Extended;
begin
  Result:=false;

  a1:=V2.y-V1.y;
  b1:=V1.x-V2.x;
{R1:=V1.y;
R2:=V1.x;
c1:=R1*(-b1)-R2*(a1);
}
  a2:=P2.y-P1.y;
  b2:=P1.x-P2.x;
  R1:=P1.y-V1.Y;
  R2:=P1.x-V1.X;
  c2:=R1*(-b2)-R2*(a2);

  det:=a1*b2-a2*b1;
  IF det=0 THEN Exit;
{
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
}
  dx:=({c1*b2}-c2*b1)/det;
  dy:=(a1*c2{-a2*c1})/det;
  Tp.x:=V1.x-round(dx);
  Tp.y:=V1.y-round(dy);
  Result:=true;
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



procedure elm_line_leng(var Va,Vb: lpoint;  R: Extended);
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

procedure tg_line_leng(var Va,Vb: tgauss;  R: Extended);
{Устанавливает длину отрезка Vа,Vb равную R, путем передвижения точки Vb}
var
L12,k : Extended;
begin
L12:=elm_distance2(Va,Vb);
IF R=L12 THEN EXIT;

IF R<L12 THEN
  begin
    k:=R/(L12-R);
    Vb.x:=(Va.x+k*Vb.x)/(1+k);
    Vb.y:=(Va.y+k*Vb.y)/(1+k);
  end;
IF R>L12 THEN
  begin
    k:=L12/(R-L12);
    Vb.x:=((1+k)*Vb.x-Va.x)/k;
    Vb.y:=((1+k)*Vb.y-Va.y)/k;
  end;
end;

var
  pwintxt : pchar;

function elm_get_text:String;
{Получение текста для текстового объекта(loc=4)}
var
  st : shortString;
begin
  dm_Get_String(9,255,st);
  st:=st+#0;
  OEMtoChar(pChar(@st[1]),pwintxt);
  Result:=StrPas(pwintxt);
end;

function elm_get_text_rus(n:word):String;
{Получение текста для текстового объекта(loc=4)}
var
  st : shortString;
begin
  if dm_Get_String(n,255,st) then begin
    st:=st+#0;
    OEMtoChar(pChar(@st[1]),pwintxt);
    Result:=StrPas(pwintxt);
  end else
    Result:='';
end;


procedure elm_make_bound(var t: plline; var Va,Vb: lpoint);
{Расчет габаритов Va,Vb для метрики t}
var
  I: Integer;
begin
Va:=t^.pol[0];
Vb:=t^.pol[0];
IF t^.N>0 THEN FOR I:=1 TO t^.N DO begin
    IF t^.pol[I].x<Va.x THEN Va.x:=t^.pol[I].x;
    IF t^.pol[I].y<Va.y THEN Va.y:=t^.pol[I].y;
    IF t^.pol[I].x>Vb.x THEN Vb.x:=t^.pol[I].x;
    IF t^.pol[I].y>Vb.y THEN Vb.y:=t^.pol[I].y;
  end;
end;

procedure elm_make_boundPolyLine(var t: pPolyLine; var Va,Vb: lpoint);
{Расчет габаритов Va,Vb для метрики t}
var
I: Integer;
begin
Va:=t^.pol[0];
Vb:=t^.pol[0];
IF t^.N>0 THEN FOR I:=1 TO t^.N DO begin
    IF t^.pol[I].x<Va.x THEN Va.x:=t^.pol[I].x;
    IF t^.pol[I].y<Va.y THEN Va.y:=t^.pol[I].y;
    IF t^.pol[I].x>Vb.x THEN Vb.x:=t^.pol[I].x;
    IF t^.pol[I].y>Vb.y THEN Vb.y:=t^.pol[I].y;
  end;
end;

procedure elm_make_bound2(var P1,P2,Pa,Pb: lpoint);
{Расчет габаритов Pa,Pb для отрезка (P1,P2)}
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




function get_VectorSQR(t: plline):Extended;
{Расчет суммы векторных произведений в локальной системе}
var
I: Integer;
G1,G2: tgauss;
begin
Result:=0;
IF t^.N<1 THEN Exit;
G2.x:=0;//t^.pol[0].x;
G2.y:=0;//t^.pol[0].y;

FOR I:=1 TO t^.N DO begin
    G1:=G2;
    G2.x:=t^.pol[i].x-t^.pol[0].x;
    G2.y:=t^.pol[i].y-t^.pol[0].y;
    Result:=Result+G1.x*G2.y-G1.y*G2.x;
  end;
end;


function get_VectorSQRPolyLine(t: pPolyLine):Extended;
{Расчет суммы векторных произведений в локальной системе}
var
I: Integer;
G1,G2: tgauss;
begin
Result:=0;
IF t^.N<1 THEN Exit;
G2.x:=0;//t^.pol[0].x;
G2.y:=0;//t^.pol[0].y;

FOR I:=1 TO t^.N DO begin
    G1:=G2;
    G2.x:=t^.pol[i].x-t^.pol[0].x;
    G2.y:=t^.pol[i].y-t^.pol[0].y;
    Result:=Result+G1.x*G2.y-G1.y*G2.x;
  end;
end;

function elm_get_Length(t: plline):Extended;
{Расчет площади}
var
I: Integer;
G1,G2: tgauss;
begin
Result:=0;
IF t^.N<1 THEN Exit;
dm_L_to_G(t^.pol[0].x,t^.pol[0].y,G2.x,G2.y);

FOR I:=1 TO t^.N DO begin
    G1:=G2;
    dm_L_to_G(t^.pol[I].x,t^.pol[I].y,G2.x,G2.y);
    Result:=Result+elm_distance2(G1,G2);
  end;
end;

function elm_get_Length_corr(t: plline):Extended;
{Расчет площади}
var
I: Integer;
P1,P2: lpoint;
f:double;
begin
Result:=0;
IF t^.N<1 THEN Exit;
P2:=t^.pol[0];
FOR I:=1 TO t^.N DO begin
    P1:=P2;
    P2:=t^.pol[I];
    Result:=Result+dm_Get_Angle_Length(P1,P2,f);
  end;
end;



function elm_get_ploshad(t: plline):Extended;
{Расчет площади}
var
I: Integer;
G1,G2: tgauss;
begin
Result:=0;
IF t^.N<1 THEN Exit;
dm_L_to_G(t^.pol[0].x,t^.pol[0].y,G2.x,G2.y);

FOR I:=1 TO t^.N DO begin
    G1:=G2;
    dm_L_to_G(t^.pol[I].x,t^.pol[I].y,G2.x,G2.y);
    Result:=Result+G1.x*G2.y-G1.y*G2.x;
  end;

Result:=ABS(Result/2);
end;
(*
function elm_get_ploshad_corr(t: plline):Extended;
{Расчет площади}
var
I: Integer;
G1,G2: tgauss;
L0:double;
begin
Result:=0;
IF t^.N<1 THEN Exit;
L0:=0;
FOR I:=1 TO t^.N DO begin
  dm_L_to_R(t^.pol[i].x,t^.pol[i].y,G2.x,G2.y);
  L0:=L0+G2.y;
end;
L0:=L0/t^.N;
  dm_L_to_R(t^.pol[0].x,t^.pol[0].y,G2.x,G2.y);
  bl2xy(G2.x, G2.y, L0, G2.x, G2.y);

FOR I:=1 TO t^.N DO begin
    G1:=G2;
    dm_L_to_R(t^.pol[i].x,t^.pol[i].y,G2.x,G2.y);
    bl2xy(G2.x, G2.y, L0, G2.x, G2.y);
    Result:=Result+G1.x*G2.y-G1.y*G2.x;
  end;
Result:=ABS(Result/2);
end;
*)



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
begin
st:=st+#0;
OEMtoANSI(pChar(@st[1]),pChar(@st[1]));
Result:=StrPas(pChar(@st[1]));
end;




function elm_cos(var P1,P2,V1,V2: lpoint):Extended;
{Опр-т cos(a) между отрезками}
var
L1,L2,xP,YP,XV,YV: Extended;
begin
L1:=elm_distance(P1,P2);
L2:=elm_distance(V1,V2);
if (L1=0) Or (L2=0) then begin Result:=0; exit end;

Xp:=(p2.x-P1.x)/L1;
yp:=(p2.y-P1.y)/L1;
Xv:=(v2.x-v1.x)/L2;
yv:=(v2.y-v1.y)/L2;

Result:=(xp*xv+yp*yv);
end;

function real_cos( P1,P2,V1,V2: lpoint):Extended;
{Опр-т cos(a) между отрезками}
var
L1,L2,xP,YP,XV,YV: Extended;
gP1,gP2,gV1,gV2:tgauss;
begin
dm_l_to_G(P1.X, P1.Y, gP1.x, gP1.y);
dm_l_to_G(P2.X, P2.Y, gP2.x, gP2.y);
dm_l_to_G(V1.X, V1.Y, gV1.x, gV1.y);
dm_l_to_G(V2.X, V2.Y, gV2.x, gV2.y);

L1:=elm_distance2(gP1,gP2);
L2:=elm_distance2(gV1,gV2);
if (L1=0) Or (L2=0) then begin Result:=0; exit end;

Xp:=(gp2.x-gP1.x)/L1;
yp:=(gp2.y-gP1.y)/L1;
Xv:=(gv2.x-gv1.x)/L2;
yv:=(gv2.y-gv1.y)/L2;

Result:=(xp*xv+yp*yv);
end;

function elm_sin(var P1,P2,V1,V2: lpoint):Extended;
{Опр-т sin(a) между отрезками}
var
L1,L2,xP,YP,XV,YV: Extended;
begin
L1:=elm_distance(P1,P2);
L2:=elm_distance(V1,V2);
if (L1=0) Or (L2=0) then begin Result:=0; exit end;
Xp:=(p2.x-P1.x)/L1;
yp:=(p2.y-P1.y)/L1;
Xv:=(v2.x-v1.x)/L2;
yv:=(v2.y-v1.y)/L2;
Result:=(xp*yv-yp*xv);
end;

procedure elm_inc_metric_levo( t: plline; d: Extended);
{Расширяет метрику площадного объекта на расстояние d
 Метрика идет по часовой стрелки}
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

    elm_make_perpend_prav(PP1,P2,P1);
    elm_make_perpend_levo(PP2,P1,P2);
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


procedure elm_inc_metric(t: plline; d: Extended);
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



procedure elm_obr_poly(t: plline);
{Разворачивает метрику}
var
I: Integer;
t2: plline;
begin
t2:= GlobalallocPtr(0,2+(t^.N+1)*sizeof(lpoint));
move(t^,t2^,2+(t^.N+1)*sizeof(lpoint));

t^.N:=t2^.N;
FOR I:=t2^.N DOWNTO 0 DO t^.pol[t2^.N-I]:=t2^.pol[I];

GlobalFreePtr(t2);
end;

procedure elm_obr_polyLine(t: ppolyLine);
{Разворачивает метрику}
var
I: Integer;
t2: ppolyLine;
begin
t2:= GlobalallocPtr(0,4+(t^.N+1)*sizeof(lpoint));
move(t^,t2^,4+(t^.N+1)*sizeof(lpoint));

t^.N:=t2^.N;
FOR I:=t2^.N DOWNTO 0 DO t^.pol[t2^.N-I]:=t2^.pol[I];

GlobalFreePtr(t2);
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

function Point_on_linepoint(a:lpoint;PL:Plline):integer;
var
  i:integer;
begin
   for i:=0 to PL^.n do begin
       IF (a.x=PL^.pol[i].x) and (a.y=PL^.pol[i].y) THEN BEGIN
         Result:=i;
         exit;
       END;
  End;
  Result:=-1
end;

function Get_line_dist(a:lpoint;Rneib:Extended;PL:Plline):Extended;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y, ex,ey:Extended;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i;
            if rr=0 then break;
         end;
            iF i<>0 then with PL^ do begin
               tx:=pol[i-1].x-pol[i].x;
               ty:=pol[i-1].y-pol[i].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                  ex:=pol[i].x;
                  ey:=pol[i].y;
                  t:=(pol[i-1].x-ex)*(x-ex)+
                     (pol[i-1].y-ey)*(y-ey);
                  //if t>0 then t:=sqrt(t);
                  if (t>0) and (t<Rdist) then begin
                    Rdist:=SQR((pol[i-1].y-pol[i].y)*x -
                    (pol[i-1].x-pol[i].x)*y+
                    pol[i-1].x*ey-
                    pol[i-1].y*ex)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;

function Get_line_distPolyLine(a:lpoint;Rneib:Extended;PL:PPolyLine):Extended;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y, ex,ey:Extended;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i
         end;
            iF i<>0 then with PL^ do begin
               tx:=pol[i-1].x-pol[i].x;
               ty:=pol[i-1].y-pol[i].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                  ex:=pol[i].x;
                  ey:=pol[i].y;
                  t:=(pol[i-1].x-ex)*(x-ex)+
                     (pol[i-1].y-ey)*(y-ey);
                  //if t>0 then t:=sqrt(t);
                  if (t>0) and (t<Rdist) then begin
                    Rdist:=SQR((pol[i-1].y-pol[i].y)*x -
                    (pol[i-1].x-pol[i].x)*y+
                    pol[i-1].x*ey-
                    pol[i-1].y*ex)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;

function Get_line_dist_back(a,Vpr:lpoint;Rneib:double;PL:Plline):double;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y:double;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
       t:=elm_cos( Vpr,PL^.pol[i], Vpr,a);
       if t<0.1 then continue;
        if i<>0 then begin
        t:=elm_cos( PL^.pol[i-1],PL^.pol[i], Vpr,a);
               if abs(t)>0.7 then continue;
        end;
        if i<>PL^.n then begin
        t:=elm_cos( PL^.pol[i],PL^.pol[i+1], Vpr,a);
               if abs(t)>0.7 then continue;
        end;

       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i
         end;
            iF i<>PL^.n then with PL^ do begin
               tx:=pol[i].x-pol[i+1].x;
                 ty:=pol[i].y-pol[i+1].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                      tx:=pol[i+1].x;
                  ty:=pol[i+1].y;
                  t:=(pol[i].x-pol[i+1].x)*(x-tx)+
                     (pol[i].y-pol[i+1].y)*(y-ty);

                  if (t>0) and (t<Rdist) then begin
                    Rdist:=sqr((pol[i].y-pol[i+1].y)*x -
                    (pol[i].x-pol[i+1].x)*y+
                    pol[i].x*ty-
                    pol[i].y*tx)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;

function Get_line_dist_direction(a,Vpr:lpoint;Rneib:double;PL:Plline):double;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y:double;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
        if i<>0 then begin
        t:=elm_cos( PL^.pol[i-1],PL^.pol[i], Vpr,a);
               if t<0.8 then continue;
        end;
        if i<>PL^.n then begin
        t:=elm_cos( PL^.pol[i],PL^.pol[i+1], Vpr,a);
               if t<0.8 then continue;
        end;

       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i
         end;
            iF i<>PL^.n then with PL^ do begin
               tx:=pol[i].x-pol[i+1].x;
                 ty:=pol[i].y-pol[i+1].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                      tx:=pol[i+1].x;
                  ty:=pol[i+1].y;
                  t:=(pol[i].x-pol[i+1].x)*(x-tx)+
                     (pol[i].y-pol[i+1].y)*(y-ty);

                  if (t>0) and (t<Rdist) then begin
                    Rdist:=sqr((pol[i].y-pol[i+1].y)*x -
                    (pol[i].x-pol[i+1].x)*y+
                    pol[i].x*ty-
                    pol[i].y*tx)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;

function Get_line_dist_dir_param(a,Vpr:lpoint;Rneib, dcos:double;PL:Plline):double;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y:double;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
        if i<>0 then begin
        t:=elm_cos( PL^.pol[i-1],PL^.pol[i], Vpr,a);
               if t<dcos then continue;
        end;
        if i<>PL^.n then begin
        t:=elm_cos( PL^.pol[i],PL^.pol[i+1], Vpr,a);
               if t<dcos then continue;
        end;

       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i
         end;
            iF i<>PL^.n then with PL^ do begin
               tx:=pol[i].x-pol[i+1].x;
                 ty:=pol[i].y-pol[i+1].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                      tx:=pol[i+1].x;
                  ty:=pol[i+1].y;
                  t:=(pol[i].x-pol[i+1].x)*(x-tx)+
                     (pol[i].y-pol[i+1].y)*(y-ty);

                  if (t>0) and (t<Rdist) then begin
                    Rdist:=sqr((pol[i].y-pol[i+1].y)*x -
                    (pol[i].x-pol[i+1].x)*y+
                    pol[i].x*ty-
                    pol[i].y*tx)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;

function Get_line_dist_left(a,Vpr,Vpr2:lpoint;Rneib:double;PL:Plline):double;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y:double;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
       t:=elm_cos( Vpr,PL^.pol[i], Vpr,a);
       ty:=elm_cos( Vpr2,PL^.pol[i], Vpr2,a);

       tx:=elm_sin( Vpr,PL^.pol[i], Vpr,a);

       if t<-0.2 then continue;
       if ty<-0.2 then continue;
       if tx<0 then continue;
        if i<>0 then begin
        t:=elm_cos( PL^.pol[i],PL^.pol[i-1], Vpr,a);
               if abs(t)<0.7 then continue;
        end;

        if i<>PL^.n then begin
        t:=elm_cos( PL^.pol[i],PL^.pol[i+1], Vpr,a);
               if abs(t)<0.7 then continue;
        end;

       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i
         end;
            iF i<>PL^.n then with PL^ do begin
               tx:=pol[i].x-pol[i+1].x;
                 ty:=pol[i].y-pol[i+1].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                      tx:=pol[i+1].x;
                  ty:=pol[i+1].y;
                  t:=(pol[i].x-pol[i+1].x)*(x-tx)+
                     (pol[i].y-pol[i+1].y)*(y-ty);

                  if (t>0) and (t<Rdist) then begin
                    Rdist:=sqr((pol[i].y-pol[i+1].y)*x -
                    (pol[i].x-pol[i+1].x)*y+
                    pol[i].x*ty-
                    pol[i].y*tx)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;

function Get_line_dist_right(a,Vpr,Vpr2:lpoint;Rneib:double;PL:Plline):double;
var
  nn,i:integer;
  RR,RDist,t,tx,ty,x,y:double;
begin
  x:=a.x;   y:=a.y;
  RR:=Rneib;
  nn:=-1;
   for i:=0 to PL^.n do begin
       t:=elm_cos( Vpr,PL^.pol[i], Vpr,a);
       ty:=elm_cos( Vpr2,PL^.pol[i], Vpr2,a);

       tx:=elm_sin( Vpr,PL^.pol[i], Vpr,a);

       if t<-0.2 then continue;
       if ty<-0.2 then continue;
       if tx>0 then continue;
       if i<>0 then begin
        t:=elm_cos( PL^.pol[i],PL^.pol[i-1], Vpr,a);
               if abs(t)<0.7 then continue;
        end;

       if i<>PL^.n then begin
        t:=elm_cos( PL^.pol[i],PL^.pol[i+1], Vpr,a);
               if abs(t)<0.7 then continue;
        end;
       Rdist:=sqr(x-PL^.pol[i].x)+
              sqr(y-PL^.pol[i].y);
         if Rdist<RR then begin
            RR:=Rdist;
            nn:=i
         end;
            iF i<>PL^.n then with PL^ do begin
               tx:=pol[i].x-pol[i+1].x;
                 ty:=pol[i].y-pol[i+1].y;
               Rdist:=sqr(tx)+sqr(ty);
               if Rdist<>0 then begin
                      tx:=pol[i+1].x;
                  ty:=pol[i+1].y;
                  t:=(pol[i].x-pol[i+1].x)*(x-tx)+
                     (pol[i].y-pol[i+1].y)*(y-ty);

                  if (t>0) and (t<Rdist) then begin
                    Rdist:=sqr((pol[i].y-pol[i+1].y)*x -
                    (pol[i].x-pol[i+1].x)*y+
                    pol[i].x*ty-
                    pol[i].y*tx)/Rdist;
                  end
                  else Rdist:=Rneib;
               end
               else  Rdist:=Rneib;
              if Rdist<=Rneib then
              if Rdist<RR then begin
               RR:=Rdist;
               nn:=i
              end
            end {if i<>0}
     end;  {for i}
if nn=(-1) then begin Result:=Rneib; exit end;
Result:=RR
end;

procedure Point_near_line(a:lpoint;Rneib:double;PL:plline;var Vpr:lpoint);
var
  dcpr,dc1,dc2:double;
  ii:integer;
begin
Vpr.x:=0;
dcpr:=0;
 for ii:=0 to PL^.n-1 do begin
   if ( PL^.pol[ii].x= PL^.pol[ii+1].x) and
      ( PL^.pol[ii].y= PL^.pol[ii+1].y) then continue;
   dc1:=elm_cos( PL^.pol[ii], PL^.pol[ii+1], PL^.pol[ii],a);
   dc2:=elm_cos( PL^.pol[ii+1], PL^.pol[ii], PL^.pol[ii+1],a);

   if (dc1=0) or (dc2=0) or ((dc1>0) and (dc2>0))  or ((dc1<0) and (dcpr<0))then begin
     if (dc1=0) or (dc2=0) or ((dc1>0) and (dc2>0)) then begin
      elm_perpend(a,Vpr, PL^.pol[ii], PL^.pol[ii+1]);
      end else begin
      Vpr:=Pl^.pol[ii];

     end;
     if elm_distance(Vpr,a)>Rneib then begin
     Vpr.x:=0;
     dcpr:=dc2;
     continue;
     end;
   end;
   dcpr:=dc2;
 end;
end;
function Point_near_line_len(a:lpoint;Rneib:double;PL:plline):Extended;
var
  dcpr,dc1,dc2,ds1,RR,Rm:double;
  ii,LL:integer;
  Vpr:lpoint;
begin
Result:=0;
Vpr.x:=0;
dcpr:=0;
Rm:=Rneib;
 for ii:=0 to PL^.n-1 do begin
   if ( PL^.pol[ii].x= PL^.pol[ii+1].x) and
      ( PL^.pol[ii].y= PL^.pol[ii+1].y) then continue;
   dc1:=elm_cos( PL^.pol[ii], PL^.pol[ii+1], PL^.pol[ii],a);
   dc2:=elm_cos( PL^.pol[ii+1], PL^.pol[ii], PL^.pol[ii+1],a);

   if (dc1=0) or (dc2=0) or ((dc1>0) and (dc2>0))  or ((dc1<0) and (dcpr<0))then begin
     if (dc1=0) or (dc2=0) or ((dc1>0) and (dc2>0)) then begin
      elm_perpend(a,Vpr, PL^.pol[ii], PL^.pol[ii+1]);
      rr:=elm_distance(a,Vpr);
      if rr<rm then begin
        rm:=rr;
        Result:=0;
        for LL:=0 to ii-1 do
          Result:=Result+elm_distance(Pl^.pol[ll],Pl^.pol[ll+1]);
          Result:=Result+elm_distance(Pl^.pol[ii],Vpr);
         ds1:=elm_sin(Pl^.pol[ii],Pl^.pol[ii+1],Pl^.pol[ii],a);
        if ds1<0 then {слева}
          Result:=-Result;
      end;
     end else begin
      Vpr:=Pl^.pol[ii];

      rr:=elm_distance(a,Vpr);
      if rr<rm then begin

       rm:=rr;

       Result:=0;
       for LL:=0 to ii-1 do
        Result:=Result+elm_distance(Pl^.pol[ll],Pl^.pol[ll+1]);
        ds1:=elm_sin(Pl^.pol[ii],Pl^.pol[ii+1],Pl^.pol[ii],a);
       if ds1<0 then {слева}
          Result:=-Result;
       end;
      end;
     if elm_distance(Vpr,a)>Rneib then begin
       dcpr:=dc2;
       continue;
     end;

   end;
   dcpr:=dc2;
 end;

end;

function Point_near_line_len_cor(a:lpoint;Rneib:double;PL:plline):Extended;
var
  dcpr,dc1,dc2,ds1,RR,Rm, f:double;
  ii,LL:integer;
  Vpr:lpoint;
begin
Result:=0;
Vpr.x:=0;
dcpr:=0;
Rm:=Rneib;
 for ii:=0 to PL^.n-1 do begin
   if ( PL^.pol[ii].x= PL^.pol[ii+1].x) and
      ( PL^.pol[ii].y= PL^.pol[ii+1].y) then continue;
   dc1:=elm_cos( PL^.pol[ii], PL^.pol[ii+1], PL^.pol[ii],a);
   dc2:=elm_cos( PL^.pol[ii+1], PL^.pol[ii], PL^.pol[ii+1],a);

   if (dc1=0) or (dc2=0) or ((dc1>0) and (dc2>0))  or ((dc1<0) and (dcpr<0))then begin
     if (dc1=0) or (dc2=0) or ((dc1>0) and (dc2>0)) then begin
      elm_perpend(a,Vpr, PL^.pol[ii], PL^.pol[ii+1]);
      rr:=elm_distance(a,Vpr);
      if rr<rm then begin
      rm:=rr;
      Result:=0;
      for LL:=0 to ii-1 do
        Result:=Result+dm_Get_Angle_Length(Pl^.pol[ll],Pl^.pol[ll+1],f);
        Result:=Result+dm_Get_Angle_Length(Pl^.pol[ii],Vpr,f);
      ds1:=elm_sin(Pl^.pol[ii],Pl^.pol[ii+1],Pl^.pol[ii],a);
      if ds1<0 then {слева}
          Result:=-Result;

      end;
      end else begin
      Vpr:=Pl^.pol[ii];
      rr:=elm_distance(a,Vpr);
      if rr<rm then begin
      rm:=rr;

       Result:=0;
      for LL:=0 to ii-1 do
        Result:=Result+dm_Get_Angle_Length(Pl^.pol[ll],Pl^.pol[ll+1],f);
       ds1:=elm_sin(Pl^.pol[ii],Pl^.pol[ii+1],Pl^.pol[ii],a);
      if ds1<0 then {слева}
          Result:=-Result;
      end;
     end;
     if elm_distance(Vpr,a)>Rneib then begin
     dcpr:=dc2;
     continue;
     end;
   end;
   dcpr:=dc2;
 end;
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

function Get_dir_onPath(t: plline; Dist:double; Var P1,P2:lpoint):boolean;
{Ф-я определяет вектор на пути по расстоянию}
var
I: Integer;
L, l1: Extended;

begin
L:=0;
FOR I:=0 TO t^.N-1 DO begin
  L:=L+elm_distance(t^.pol[I],t^.pol[I+1]);
  if L>Dist then begin
    l1:=L-Dist;
    if l1<2 then L1:=2;
    P1:=t^.pol[I];
    P2:=t^.pol[I+1];
    elm_line_leng(P2,P1,L1);
    Result:=true;
    exit
  end
end;

Result:=false;
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
  Ug:=0;
  V4:=V1;
  L:=Lv*2;
  elm_line_leng(V2,V4,L);
  IF Ugol=180 THEN begin
    V2:=V4;
    Exit;
  end;

  elm_make_perpend_prav(V3,V2,V1);
  elm_line_leng(V1,V3,Lv);
  IF Ugol=90 THEN begin
    V2:=V3;
    Exit;
  end;

  V5:=V1;
  elm_line_leng(V3,V5,L);
  IF Ugol=270 THEN begin
    V2:=V5;
    Exit;
  end;

  IF (Ugol>0)and(Ugol<90) THEN begin
    P2:=V2;
    Ug:=Ugol;
  end;

IF (Ugol>90)and(Ugol<180) THEN begin
    P2:=V3;
    Ug:=Ugol-90;
  end;

IF (Ugol>180)and(Ugol<270) THEN begin
    P2:=V4;
    Ug:=Ugol-180;
  end;

IF (Ugol>270)and(Ugol<360) THEN begin
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

function elm_point_in_bound(var P,Va,Vb: lpoint):Boolean;
{Ф-я опр-т попадает ли точка Р в область (Va,Vb)}
begin
Result:=true;

IF (P.x>=Va.x)and(P.x<=Vb.x)and
   (P.y>=Va.y)and(P.y<=Vb.y) THEN Exit;

Result:=false;;
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

function GetBulkCount:integer;
var
  ii, n:integer;
  plCn, pl:plline;
  lp:lpoint;
  Attr:tlong;
  orient:byte;
begin
 if dm_get_local<10 then
  Result:=dm_get_poly_count
 else begin
 Getmem(plCn,65528);
 Pl:=GloBalAllocPtr(0,256000);
   dm_get_poly_buf(plCn,16000);
   n:=0;
   for ii:=0 to plCn.n  do begin
     dm_get_ve_poly(Cardinal(plcn.Pol[ii].x),pl,nil,16000);
     Attr.i:=plcn.Pol[ii].y;
     orient:=Attr.b[1];
     if n=0 then begin
        if orient=1 then
          lp:=pl.pol[0]
        else
          lp:=pl.pol[pl^.n];
     end;
     inc(n,pl^.n);
     if orient=1 then begin
      if (lp.x=pl.pol[pl^.n].x) and (lp.y=pl.pol[pl^.n].y) then
         break;
     end else begin
      if (lp.x=pl.pol[0].x) and (lp.y=pl.pol[0].y) then
         break;
     end;
   end;
   Freemem(plCn,65528);
   GloBalFreePtr(PL);
   Result:=n;
 end;
end;

Procedure GetBulkPoly(plVe:plline);
var
  ii, j:integer;
  plCn, pl:plline;
  lp:lpoint;
  Attr:tlong;
  orient:byte;
begin
 if dm_get_local<10 then
  dm_get_poly_buf(PlVe,16000)
 else begin
 Getmem(plCn,65528);
 Pl:=GloBalAllocPtr(0,256000);

   dm_get_poly_buf(plCn,16000);
   plve.n:=0;

   for ii:=0 to plCn.n  do begin
     dm_get_ve_poly(Cardinal(plcn.Pol[ii].x),pl,nil,16000);
     Attr.i:=plcn.Pol[ii].y;
     orient:=Attr.b[1];
     if plve.n=0 then begin
        if orient=1 then
          lp:=pl.pol[0]
        else
          lp:=pl.pol[pl^.n];
     end;
     if orient=1 then
       Move(pl.pol[0],plve.Pol[plve.n],(pl.n+1)*sizeof(lpoint))
     else
       for j:=0 to pl.n do
          plve.Pol[plve.n+pl.n-j]:=pl.pol[j];
     inc(plve.n,pl^.n);
     if orient=1 then begin
      if (lp.x=pl.pol[pl^.n].x) and (lp.y=pl.pol[pl^.n].y) then
         break;
     end else begin
      if (lp.x=pl.pol[0].x) and (lp.y=pl.pol[0].y) then
         break;
     end;
   end;

    Freemem(plCn,65528);
    GloBalFreePtr(PL);
 end;
end;

Procedure GetBulkPolyLine(plVe:pPolyLine);
var
  ii, j:integer;
  plCn, pl:plline;
  lp:lpoint;
  Attr:tlong;
  orient:byte;
begin
 if dm_get_local<10 then begin
   Pl:=GloBalAllocPtr(0,262152);
   dm_get_poly_buf(Pl,32000);
   Move(pl.pol[0],plve.Pol[0],(pl.n+1)*sizeof(lpoint));
   plve.n:=pl.N;
   GloBalFreePtr(PL);
 end
 else begin

   Getmem(plCn,65528);
   Pl:=GloBalAllocPtr(0,262152);
   dm_get_poly_buf(plCn,16000);
   plve.n:=0;

   for ii:=0 to plCn.n  do begin
     dm_get_ve_poly(Cardinal(plcn.Pol[ii].x),pl,nil,16000);
     Attr.i:=plcn.Pol[ii].y;
     orient:=Attr.b[1];
     if plve.n=0 then begin
        if orient=1 then
          lp:=pl.pol[0]
        else
          lp:=pl.pol[pl^.n];
     end;
     if orient=1 then
       Move(pl.pol[0],plve.Pol[plve.n],(pl.n+1)*sizeof(lpoint))
     else
       for j:=0 to pl.n do
          plve.Pol[plve.n+pl.n-j]:=pl.pol[j];
     inc(plve.n,pl^.n);
     if orient=1 then begin
      if (lp.x=pl.pol[pl^.n].x) and (lp.y=pl.pol[pl^.n].y) then
         break;
     end else begin
      if (lp.x=pl.pol[0].x) and (lp.y=pl.pol[0].y) then
         break;
     end;
   end;
    lp:=plve.pol[plve^.n];
    lp:=plve.pol[0];

    Freemem(plCn,65528);
    GloBalFreePtr(PL);
 end;
end;


procedure SetBulk(PL:Plline);
 var
  idvc,idve:array[1..4] of Cardinal;
  ii,n,ii2, itl, nm:integer;
  lp:lpoint;
  PlVe, plCn, plCnew:plline;
  v: tcn_rec;
  Attr:tlong;
  orient, bLoc:byte;
 // bRes:boolean;
begin
 Getmem(plCn,65528);
 Getmem(plCnew,65528);
 plve:=GloBalAllocPtr(0,256000);
 nm:=0;
 bLoc:=dm_get_local;
 if PL^.n<=8000 then  begin
   if bLoc=23 then begin
     dm_get_poly_buf(plCn,16000);
     n:=0;
     nm:=0;
    for ii:=0 to plCn.n  do begin
     dm_get_ve_poly(Cardinal(plcn.Pol[ii].x),plve,nil,16000);
     Attr.i:=plcn.Pol[ii].y;
     orient:=Attr.b[1];
     if n=0 then begin
        if orient=1 then
          lp:=plve.pol[0]
        else
          lp:=plve.pol[plve^.n];
     end;
     inc(n,plve^.n);
     if orient=1 then begin
      if (lp.x=plve.pol[plve^.n].x) and (lp.y=plve.pol[plve^.n].y) then begin
         nm:=ii;
         break;
      end;
     end else begin
      if (lp.x=plve.pol[0].x) and (lp.y=plve.pol[0].y) then begin
          nm:=ii;
         break;
      end;
     end;
    end;
   end;
  idvc[1]:=dm_add_vc(0,Pl^.pol[0].x,Pl^.pol[0].y,NIL);
  idve[1]:=dm_add_ve(0, idvc[1],idvc[1],PL,NIL);
  plCnew.pol[0]:=cn_ptr(idve[1],cn_edge,1,1,255);
  plCnew.n:=0;
  if bLoc=23 then begin
    for ii:=nm+1 to plCn.n  do begin
    inc(plCnew.n);
    plCnew.pol[plCnew.n]:=plcn.Pol[ii];
    end;
  end else
    dm_set_local(23);
  dm_set_poly_buf(plCnew);
  if bLoc=23 then begin
    for ii:=0 to nm  do begin
     dm_Get_ve(Cardinal(plcn.Pol[ii].x), v);
     {bRes:=}dm_Delete_ve(Cardinal(plcn.Pol[ii].x));
     {bRes:=}dm_delete_vc(v.vc1);
     {bRes:=}dm_delete_vc(v.vc2);
   end;
  end;
  exit;
 END;
  if bLoc=23 then begin
   n:=0;
   nm:=0;
   dm_get_poly_buf(plCn,16000);
    for ii:=0 to plCn.n  do begin
     dm_get_ve_poly(Cardinal(plcn.Pol[ii].x),plve,nil,16000);
     Attr.i:=plcn.Pol[ii].y;
     orient:=Attr.b[1];
     if n=0 then begin
        if orient=1 then
          lp:=plve.pol[0]
        else
          lp:=plve.pol[plve^.n];
     end;
     inc(n,plve^.n);
     if orient=1 then begin
      if (lp.x=plve.pol[plve^.n].x) and (lp.y=plve.pol[plve^.n].y) then begin
         nm:=ii;
         break;
      end;
     end else begin
      if (lp.x=plve.pol[0].x) and (lp.y=plve.pol[0].y) then begin
          nm:=ii;
         break;
      end;
     end;
   end;
  end;
  n:=PL^.n;
  idvc[1]:=dm_add_vc(0,Pl^.pol[0].x,Pl^.pol[0].y,NIL);
  ii:=8000;
  idvc[2]:=dm_add_vc(0,Pl^.pol[ii].x,Pl^.pol[ii].y,NIL);
  if (Pl^.pol[0].X<>Pl^.pol[PL.n].X) or (Pl^.pol[0].Y<>Pl^.pol[PL.n].Y) then
     idvc[3]:=dm_add_vc(0,Pl^.pol[PL.n].x,Pl^.pol[PL.n].y,NIL)
  else
     idvc[3]:=idvc[1];
  Move(PL^.pol[0],Plve.pol[0],8001*8);

  PLVe.n:=8000;

  idve[1]:=dm_add_ve(0, idvc[1],idvc[2],PLVe,NIL);
  plCnew.pol[0]:=cn_ptr(idve[1],cn_edge,1,1,255);
  plCnew.N:=0;
  ii:=8001;
  itl:=1;
  repeat
  if (n-ii)>8001 then
    ii2:=ii+8000
  else
    ii2:=n;

  Move(PL^.pol[ii],Plve.pol[0],(ii2-ii+1)*8);
  Plve.N:=ii2-ii;
  if ii2=n then
    idve[2]:=dm_add_ve(0, idvc[2],idvc[3],PLve,NIL)
  else begin
    idvc[4]:=dm_add_vc(0,Pl^.pol[ii2].x,Pl^.pol[ii2].y,NIL);

    idve[2]:=dm_add_ve(0, idvc[2],idvc[4],PLve,NIL);
    idvc[2]:=idvc[4];
  end;
  plCnew.pol[itl]:=cn_ptr(idve[2],cn_edge,1,1,255);
  plCnew.n:=itl;
  inc(itl);
  ii:=ii2+1;
  until ii2=n;

  if bLoc=23 then begin
    for ii:=nm+1 to plCn.n  do begin
      inc(plCnew.n);
      plCnew.pol[plCnew.n]:=plcn.Pol[ii];
    end;
  end else
    dm_set_local(23);
   dm_set_poly_buf(plCnew);
   if bLoc=23 then begin
    for ii:=0 to nm  do begin
     dm_Get_ve(Cardinal(plcn.Pol[ii].x), v);
     {bRes:=}dm_Delete_ve(Cardinal(plcn.Pol[ii].x));
     {bRes:=}dm_delete_vc(v.vc1);
     {bRes:=}dm_delete_vc(v.vc2);
    end;
   end;
   Freemem(plCn,65528);
   Freemem(plCnew,65528);
   GloBalFreePtr(plve);
end;


procedure SetBulkPolyLine(PL:PPolyLine);
 var
  idvc,idve:array[1..4] of Cardinal;
  ii,n,ii2, itl, nm:integer;
  lp:lpoint;
  PlVe, plCn, plCnew, Plt:plline;
  v: tcn_rec;
  Attr:tlong;
  orient, bLoc:byte;
 // bRes:boolean;
begin
 Getmem(plCn,65528);
 Getmem(plCnew,65528);
 plve:=GloBalAllocPtr(0,262152);
 Plt:=GloBalAllocPtr(0,262152);
 nm:=0;
 bLoc:=dm_get_local;
 if PL^.n<=8000 then  begin
    move(pl.pol, Plt.pol,(PL^.n+1)*sizeof(lpoint));
    Plt.N:=PL^.n;
   if bLoc=23 then begin
     dm_get_poly_buf(plCn,16000);
     n:=0;
     nm:=0;
    for ii:=0 to plCn.n  do begin
     dm_get_ve_poly(Cardinal(plcn.Pol[ii].x),plve,nil,16000);
     Attr.i:=plcn.Pol[ii].y;
     orient:=Attr.b[1];
     if n=0 then begin
        if orient=1 then
          lp:=plve.pol[0]
        else
          lp:=plve.pol[plve^.n];
     end;
     inc(n,plve^.n);
     if orient=1 then begin
      if (lp.x=plve.pol[plve^.n].x) and (lp.y=plve.pol[plve^.n].y) then begin
         nm:=ii;
         break;
      end;
     end else begin
      if (lp.x=plve.pol[0].x) and (lp.y=plve.pol[0].y) then begin
          nm:=ii;
         break;
      end;
     end;
    end;
   end;
  idvc[1]:=dm_add_vc(0,Pl^.pol[0].x,Pl^.pol[0].y,NIL);
  idve[1]:=dm_add_ve(0, idvc[1],idvc[1],Plt,NIL);
  plCnew.pol[0]:=cn_ptr(idve[1],cn_edge,1,1,255);
  plCnew.n:=0;
  if bLoc=23 then begin
    for ii:=nm+1 to plCn.n  do begin
    inc(plCnew.n);
    plCnew.pol[plCnew.n]:=plcn.Pol[ii];
    end;
  end else
    dm_set_local(23);
    dm_set_poly_buf(plCnew);
  if bLoc=23 then begin
    for ii:=0 to nm  do begin
     dm_Get_ve(Cardinal(plcn.Pol[ii].x), v);
     {bRes:=}dm_Delete_ve(Cardinal(plcn.Pol[ii].x));
     {bRes:=}dm_delete_vc(v.vc1);
     {bRes:=}dm_delete_vc(v.vc2);
   end;
  end;
  exit;
 END;
  if bLoc=23 then begin
   n:=0;
   nm:=0;
   dm_get_poly_buf(plCn,16000);
    for ii:=0 to plCn.n  do begin
     dm_get_ve_poly(Cardinal(plcn.Pol[ii].x),plve,nil,16000);
     Attr.i:=plcn.Pol[ii].y;
     orient:=Attr.b[1];
     if n=0 then begin
        if orient=1 then
          lp:=plve.pol[0]
        else
          lp:=plve.pol[plve^.n];
     end;
     inc(n,plve^.n);
     if orient=1 then begin
      if (lp.x=plve.pol[plve^.n].x) and (lp.y=plve.pol[plve^.n].y) then begin
         nm:=ii;
         break;
      end;
     end else begin
      if (lp.x=plve.pol[0].x) and (lp.y=plve.pol[0].y) then begin
          nm:=ii;
         break;
      end;
     end;
   end;
  end;
  n:=PL^.n;
  idvc[1]:=dm_add_vc(0,Pl^.pol[0].x,Pl^.pol[0].y,NIL);
  ii:=8000;
  idvc[2]:=dm_add_vc(0,Pl^.pol[ii].x,Pl^.pol[ii].y,NIL);
  if (Pl^.pol[0].X<>Pl^.pol[PL.n].X) or (Pl^.pol[0].Y<>Pl^.pol[PL.n].Y) then
     idvc[3]:=dm_add_vc(0,Pl^.pol[PL.n].x,Pl^.pol[PL.n].y,NIL)
  else
     idvc[3]:=idvc[1];
  Move(PL^.pol[0],Plve.pol[0],8001*8);

  PLVe.n:=8000;

  idve[1]:=dm_add_ve(0, idvc[1],idvc[2],PLVe,NIL);
  plCnew.pol[0]:=cn_ptr(idve[1],cn_edge,1,1,255);
  plCnew.N:=0;
  ii:=8001;
  itl:=1;
  repeat
  if (n-ii)>8001 then
    ii2:=ii+8000
  else
    ii2:=n;

  Move(PL^.pol[ii],Plve.pol[0],(ii2-ii+1)*8);
  Plve.N:=ii2-ii;
  if ii2=n then
    idve[2]:=dm_add_ve(0, idvc[2],idvc[3],PLve,NIL)
  else begin
    idvc[4]:=dm_add_vc(0,Pl^.pol[ii2].x,Pl^.pol[ii2].y,NIL);

    idve[2]:=dm_add_ve(0, idvc[2],idvc[4],PLve,NIL);
    idvc[2]:=idvc[4];
  end;
  plCnew.pol[itl]:=cn_ptr(idve[2],cn_edge,1,1,255);
  plCnew.n:=itl;
  inc(itl);
  ii:=ii2+1;
  until ii2=n;

  if bLoc=23 then begin
    for ii:=nm+1 to plCn.n  do begin
      inc(plCnew.n);
      plCnew.pol[plCnew.n]:=plcn.Pol[ii];
    end;
  end else
    dm_set_local(23);
   dm_set_poly_buf(plCnew);
   if bLoc=23 then begin
    for ii:=0 to nm  do begin
     dm_Get_ve(Cardinal(plcn.Pol[ii].x), v);
     {bRes:=}dm_Delete_ve(Cardinal(plcn.Pol[ii].x));
     {bRes:=}dm_delete_vc(v.vc1);
     {bRes:=}dm_delete_vc(v.vc2);
    end;
   end;
   Freemem(plCn,65528);
   Freemem(plCnew,65528);
   GloBalFreePtr(plve);
   GloBalFreePtr(plt);
end;

function MoveHoles(PlSrc, plDest:Plline):integer;
 var
  ii,n, nm:integer;
  lp:lpoint;
  PlVe:plline;
  Attr:tlong;
  orient:byte;
 // bRes:boolean;
begin
 plve:=GloBalAllocPtr(0,256000);

   n:=0;
   nm:=0;
   for ii:=0 to PlSrc.n  do begin
     dm_get_ve_poly(Cardinal(PlSrc.Pol[ii].x),plve,nil,16000);
     Attr.i:=PlSrc.Pol[ii].y;
     orient:=Attr.b[1];
     if n=0 then begin
        if orient=1 then
          lp:=plve.pol[0]
        else
          lp:=plve.pol[plve^.n];
     end;
     inc(n,plve^.n);
     if orient=1 then begin
      if (lp.x=plve.pol[plve^.n].x) and (lp.y=plve.pol[plve^.n].y) then begin
         nm:=ii;
         break;
      end;
     end else begin
      if (lp.x=plve.pol[0].x) and (lp.y=plve.pol[0].y) then begin
          nm:=ii;
         break;
      end;
     end;
   end;
  for ii:=nm+1 to PlSrc.n  do begin
    inc(plDest.n);
    plDest.pol[plDest.n]:=PlSrc.Pol[ii];
  end;
  Result:=nm;
END;

procedure elm_move_metric(var t: plline; dv: Extended; Flevo: Boolean);
{Сдвигает метрику линейного объекта на расстояние dv влево/вправо}
var
  I: Integer;
  PP_1,P1,P2,P3,PP1,PP2: lpoint;
  L: Extended;
  t2,t3: plline;
begin
  IF t^.N<1 THEN Exit;

  Getmem(t2,65528);
  Getmem(t3,65528);

  t2^.N:=t^.N;
  t3^.N:=t^.N;

  FOR I:=0 TO t^.N DO begin
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

procedure ProcMess;
var
  t:TdateTime;
begin
  t:=Now;
  if t-TimePred> 1/86400 then  begin
    //Application.ProcessMessages;
    TimePred:=t;
  end;
end;

function SetFOC(hWnd:HWND):boolean;
 type
  tfunc = procedure(hWnd:Integer; fAltTab:boolean); stdcall;
var
  lib: HModule; func: tfunc;
begin
  Result:=FALSE;
  lib:=LoadLibrary('USER32.dll');
  if lib >= 32 then begin
    @func:=GetProcAddress(lib,'SwitchToThisWindow');
    if Assigned(func) then begin
      func(HWND,true);
      Result:=true;
    end;
  end
end;

function ForceFgWindow(hwnd: THandle): boolean;
const
SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
ForegroundThreadID: DWORD;
ThisThreadID: DWORD;
timeout: DWORD;
begin
if IsIconic(hwnd) then
  ShowWindow(hwnd, SW_RESTORE);

if GetForegroundWindow = hwnd then
  Result := True
else
begin
  // Windows 98/2000 doesn"t want to foreground a window when some other
  // window has keyboard focus
  if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4))
    or
    ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
    ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
    (Win32MinorVersion > 0)))) then
  begin
    // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
    // Converted to Delphi by Ray Lischner
    // Published in The Delphi Magazine 55, page 16
    Result := False;
    ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow,
      nil);
    ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
    if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
      AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
      Result := (GetForegroundWindow = hwnd);
    end;

    if not Result then
    begin
      // Code by Daniel P. Stasinski
      SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
      SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hWnd);
      SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
    end;
  end
  else
  begin
    BringWindowToTop(hwnd); // IE 5.5 related hack
    SetForegroundWindow(hwnd);
  end;

  Result := (GetForegroundWindow = hwnd);
end;
end; { ForceForegroundWindow }


function Get_linked_Object(nd:integer;pAcr:Pchar):integer;
var
  ilink,itop, id, dir, typ:integer;
begin
  Result:=0;
  ilink:=dm_frst_relation(nd, itop);
  while (ilink>0) do begin
    id:=dm_get_relation(ilink,dir,typ, guid,acronym,pname);
    if (StrComp(acronym,Pacr)=0) and (dir=1) then begin
      Result:=dm_Id_Offset(id);
      break
    end;
  ilink:=dm_next_relation(ilink, itop);
  end;
end;

function CreateGuid: string;
 var
   ID: TGUID;
 begin
   Result := '';
   if CoCreateGuid(ID) = S_OK then
     Result := GUIDToString(ID);
 end;

var

  pc:pchar;
Initialization
 work_dir:=ExtractFilepath(ParamSTR(0));
 Bin_dir:=work_dir;
 work_dir:=ExcludeTrailingBackslash(Work_dir)+#0;
 pc:=StrRscan(@work_dir[1],'\');
 pc^:=#0;
 work_dir:=Strpas(@work_dir[1]);
 plGlobal:=GlobalAllocPtr(0,262152);
 plGlobal2:=GlobalAllocPtr(0,262152);
 TimePred:=Now;
 pFiles:=GlobalAllocPtr(0,65528);
 Getmem(guid,65528);
 Getmem(acronym,65528);
 Getmem(pname,65528);
 Getmem(pwintxt,65528);

Finalization
 GlobalFreePtr(plGlobal);
 GlobalFreePtr(plGlobal2);
 GlobalFreePtr(pFiles);
 Freemem(guid,65528);
 Freemem(acronym,65528);
 Freemem(pname,65528);
 Freemem(pwintxt,65528);
 work_dir:=ExtractFilepath(ParamSTR(0));
 Bin_dir:=work_dir;
 work_dir:=ExcludeTrailingBackslash(Work_dir)+#0;
 pc:=StrRscan(@work_dir[1],'\');
 pc^:=#0;
 work_dir:=Strpas(@work_dir[1]);
END.
