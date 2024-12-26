unit add2dm;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, Classes, SysUtils, vlib, llib, llibx, List;


type
  //положение знака на линии:
  //+-1 - в начале; 0 - в середине; +-2 - в конце;
  //<0 - обратное направление;
  //
  //КРЕСТЫ НА ПРЯМОУГ_АХ:
  //90-KREST0 - внутренний крест без пересечения (пунктир [2 1])
  //91-KREST1 - внутренний крест с пересечением (пунктир [2 1])
  //92-KREST2 (KREST_l) - внутренний крест (сплошные линии)
  //
  //98-KREST8 - 4 усика по 1мм наружу
  //99-KREST9 - 2 усика внутрь от 1-ых 2-ух вершин
  Tadd2dm_pose = integer;

  //элемент списка:
  Tadd2dm_data = class
    sType: string;//SIGN, KREST, LEP, LINE
    dmcode, dmloc, addcode, addloc: integer;//SIGN, KREST, LEP, LINE
    addcode2, addloc2: integer;//LEP
    addpose: Tadd2dm_pose;//SIGN, KREST
    d1,d2: double;//LINE - отступы от концов

    function _sign_points(line: tpl; var p1,p2: tnum2): boolean;
    function add2dm_sign_to_line(line: tpl{коорд-ты карты}; down: boolean): boolean;//карта открыта!

    function add2dm_lines_to_area(line: tpl{коорд-ты карты}; down: boolean): boolean;//карта открыта!

    function _lep_arrow(p,v: tnum2; down: boolean): boolean;//строит линию и "стрелку"
    function _lep_segment(p1,p2: tnum2; down: boolean): boolean;
    function add2dm_lep(line: tpl{коорд-ты карты}; down: boolean): boolean;//карта открыта!

    //LINE: d1,d2 in use:
    function add2dm_line(line: tpl{коорд-ты карты}; down: boolean): boolean;//карта открыта!

    //MAIN FUNCTTION:
    function add2dm(line: tpl{коорд-ты карты}; down: boolean): boolean;//карта открыта!
  end;

  //список:
  Tadd2dm_list = class(TClasslist)//of Tadd2dm_data
    function load_cod_file: boolean;//чтение mss_acad.cod, с сообщениями
    function add2dm: integer;//карта открыта! Result = кол-во добавл-ых групп об-ов
    //procedure CreateDebugList;
  end;


implementation

uses Wcmn, CMN, nums, Filex, dmlib0, Dmlib, dmw_Use;


{ Tadd2dm_data: }

function Tadd2dm_data._sign_points(line: tpl; var p1,p2: tnum2): boolean;
const sign_vector_len: tnum = 100;
var i: integer; x: tnum; v: tnum2; //d: tnum;
begin
  Result:=FALSE;//default

  if line.Count<=0 then begin p1:=v_xy(0,0); p2:=v_xy(10,0); end;
  if line.Count=1 then begin p1:=line[0]; p2:=v_xy(p1.x+10, p1.y); end;

  //line.Count>1:

  if abs(addpose)=1 then begin
    p1:=line[0];
    p2:=line[1];//прямое направление
    v:=v_sub(p2,p1);
    if addpose=-1 then begin
      p2:=v_sub(p1,v);//обратн направление
    end;
    Result:=v_dist(p1,p2)>v_zero;//!
  end;

  if abs(addpose)=2 then begin
    p1:=line[line.count-1];
    p2:=line[line.count-2];//обратн направление
    v:=v_sub(p2,p1);
    if addpose=2 then begin
      p2:=v_sub(p1,v);//прямое направление
    end;
    Result:=v_dist(p1,p2)>v_zero;//!
  end;

  if addpose=0 then begin
    p1:=line.xp( line.Length/2 );//середина линии
    i:=line.iofp(p1);
    p2:=line[i];
    x:=line.xofp(p2);//коорд-та ближ к p1 вершины
    if x<=line.Length/2 then p2:=line[i+1];
    Result:=v_dist(p1,p2)>v_zero;//!
  end;
(*
  //укорочение:
  if Result then begin
    d:=v_dist(p1,p2);
    if d>sign_vector_len then begin
      v:=v_sub(p2,p1);
      v:=v_norm(v, sign_vector_len);
      p2:=v_add(p1,v);
    end;
  end;
*)
end;

function Tadd2dm_data.add2dm_sign_to_line(line: tpl{коорд-ты карты}; down: boolean): boolean;//карта открыта!
var p1,p2: tnum2; dmo: tdmo;
begin
  Result:=false;//default

  dmo:=tdmo.CreateCode2(addloc, addcode, FALSE{aGauss});
  try
    if _sign_points(line, p1,p2) then begin
      dmo.Points.add(p1);
      dmo.Points.add(p2);
      Result := dmo.Add(down)>0
    end;
  finally
    dmo.Free;
  end;
end;

//-----------------------------

function Tadd2dm_data.add2dm_lines_to_area(line: tpl{коорд-ты карты}; down: boolean): boolean;//карта открыта!
var d0,d1: tnum; p1,p2,v0,v1: tnum2; dmo: tdmo;

  function _add2dm_p1_p2: boolean;
  begin
    dmo:=tdmo.CreateCode2(addloc, addcode, FALSE{aGauss});
    try
      dmo.Points.add(p1);
      dmo.Points.add(p2);
      Result := dmo.Add(down)>0;//стоим на новом dmo!
      if Result and down then dm_goto_upper;//!!!
    finally
      dmo.Free;
    end;
  end;

begin
  Result:=false;//default

  if line.Count=5{прямоуг-к} then begin

    v0:=v_sub(line[2], line[0]);//from line[0] to line[2]
    v1:=v_sub(line[3], line[1]);//from line[1] to line[3]

    //KREST0 - внутренний крест - пунктир [2 1] без пересечения:
    if addpose=90 then begin
      d0:=v_mod(v0)*0.40;//на 10% меньше половины
      d1:=v_mod(v1)*0.40;//на 10% меньше половины
      v0:=v_norm(v0,d0);
      v1:=v_norm(v1,d1);

      //4 отрезка:
      p1:=line[0]; p2:=v_add(line[0],v0); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[1]; p2:=v_add(line[1],v1); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[2]; p2:=v_sub(line[2],v0); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[3]; p2:=v_sub(line[3],v1); if not _add2dm_p1_p2 then EXIT;//!
    end;

    //KREST1 - внутренний крест - пунктир [2 1] c пересечением:
    if addpose=91 then begin
      d0:=v_mod(v0)*0.50;//=половина
      d1:=v_mod(v1)*0.50;//=половина
      v0:=v_norm(v0,d0);
      v1:=v_norm(v1,d1);

      //4 отрезка:
      p1:=line[0]; p2:=v_add(line[0],v0); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[1]; p2:=v_add(line[1],v1); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[2]; p2:=v_sub(line[2],v0); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[3]; p2:=v_sub(line[3],v1); if not _add2dm_p1_p2 then EXIT;//!
    end;

    //KREST2 (KREST_l) - внутренний крест - сплошные линии:
    if addpose=92 then begin
      //2 отрезка:
      p1:=line[0]; p2:=line[2]; if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[1]; p2:=line[3]; if not _add2dm_p1_p2 then EXIT;//!
    end;

    //98-KREST8 - 4 усика по 1мм наружу:
    if addpose=98 then begin
      d0:=1*cmn_newdm.lpmm;//1мм
      d1:=1*cmn_newdm.lpmm;//1мм
      v0:=v_norm(v0,d0);//1мм
      v1:=v_norm(v1,d1);//1мм

      //4 отрезка:
      p1:=line[0]; p2:=v_sub(line[0],v0); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[1]; p2:=v_sub(line[1],v1); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[2]; p2:=v_add(line[2],v0); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[3]; p2:=v_add(line[3],v1); if not _add2dm_p1_p2 then EXIT;//!
    end;

    //99-KREST9 - 2 усика внутрь от 1-ых 2-х вершин:
    if addpose=99 then begin
      d0:=v_mod(v0)*0.17;// 1/3 от половины
      d1:=v_mod(v1)*0.17;// 1/3 от половины
      v0:=v_norm(v0,d0);
      v1:=v_norm(v1,d1);

      //2 отрезка:
      p1:=line[0]; p2:=v_add(line[0],v0); if not _add2dm_p1_p2 then EXIT;//!
      p1:=line[1]; p2:=v_add(line[1],v1); if not _add2dm_p1_p2 then EXIT;//!
    end;

    Result:=TRUE;//!

  end;//if line.Count=5

end;

//-----------------------------

function Tadd2dm_data._lep_arrow(p,v: tnum2; down: boolean): boolean;
var p2,v2,p3: tnum2; dmo: tdmo;
begin
  Result:=FALSE;//default for EXIT:
  p2:=v_add(p,v);
  v2:=v_mul(v, 0.1);
  if v_mod(v2)<=2 then begin//маленькая стрелка (в коор-ах карты)
    //Tell('ERROR in Tadd2dm_data._lep_arrow: v_mod(v2)<=2');
    EXIT;//Result=FALSE!
  end;

  //линия:
  dmo:=tdmo.CreateCode2(addloc, addcode, FALSE{aGauss});
  try
      dmo.Points.add(p);
      dmo.Points.add(p2);
      Result := dmo.Add(down)>0;//стоим на новом dmo!
      if Result and down then dm_goto_upper;//!!!
  finally
    dmo.Free;
  end;

  //"стрелка":
  dmo:=tdmo.CreateCode2(addloc2, addcode2, FALSE{aGauss});
  try
      dmo.Points.add(p2);
      p3:=v_add(p2, v_norm(v,10));//10 - размер вектора знака в коорд-ах карты - ????????
      dmo.Points.add(p3);
      Result := dmo.Add(down)>0;//стоим на новом dmo!
      if Result and down then dm_goto_upper;//!!!
  finally
    dmo.Free;
  end;

end;

function Tadd2dm_data._lep_segment(p1,p2: tnum2; down: boolean): boolean;
var d12,d12mm,d,dmm: tnum; v12,v21,v1,v2: tnum2;
begin
  Result:=TRUE;//default
  v12:=v_sub(p2,p1);
  v21:=v_sub(p1,p2);
  d12:=v_mod(v12);
  //if d12<=v_zero then EXIT;//!!!

  //d - РАЗМЕР СТРЕЛКИ:
  d12mm:=d12/cmn_newdm.lpmm;//мм!
  if d12mm<2{mm} then EXIT;//!!! - 2 стрелки не уместятся!!!
  if d12mm>=12{mm} then dmm:=4
  else
  if d12mm>=9{mm} then dmm:=d12mm/3
  else
  if d12mm>6.1{mm} then dmm:=3
  else
  dmm:=d12mm/2.3;//меньше 3 мм!?!
  d:=dmm*cmn_newdm.lpmm;//!

  v1:=v_norm(v12, d);
  v2:=v_norm(v21, d);
  {Result:=}_lep_arrow(p1,v1, down);
  {Result:=}_lep_arrow(p2,v2, down);
end;

function Tadd2dm_data.add2dm_lep(line: tpl; down: boolean): boolean;//карта открыта!
var i: integer; p1,p2: tnum2;
begin
  Result:=TRUE;//default

  if line.Count>1 then for i:=0 to line.Count-2{отрезки} do begin
    p1:=line[i];
    p2:=line[i+1];
    {Result:=}_lep_segment(p1,p2, down);
  end;//for i
end;

//-----------------------------

function Tadd2dm_data.add2dm_line(line: tpl; down: boolean): boolean;//d1,d2 in use
var x1,x2: double; line2: tpl; dmo: tdmo;
begin
  Result:=FALSE;//default
  if (d1<0) or (d2<0) or (d1+d2>=line.Length/cmn_newdm.lpmm) then EXIT;//!

  //d1>=0, d2>=0, d1+d2<line.Length/cmn_newdm.lpmm:
  x1:=d1*cmn_newdm.lpmm;//ед. карты
  x2:=line.Length-d2*cmn_newdm.lpmm;//ед. карты
  line2:=line.CreateSegment(x1,x2, false{find_p1_p2});
  try
    if line2.Count>1{!} then begin

      //линия:
      dmo:=tdmo.CreateCode2(addloc, addcode, FALSE{aGauss});
      try
        dmo.Points.AddFrom(line2);
        Result:=dmo.Add(down)>0;//стоим на новом dmo!
      finally
        dmo.Free;
      end;

    end;//line2.Count>1
  finally
    line2.Free;
  end;
end;


//-----------------------------
//-----------------------------

function Tadd2dm_data.add2dm(line: tpl; down: boolean): boolean;
begin
  Result:=false;//default

  if sType='SIGN'  then Result:=add2dm_sign_to_line(line, down);
  if sType='KREST' then Result:=add2dm_lines_to_area(line, down);
  if sType='LEP'   then Result:=add2dm_lep(line, down);
  if sType='LINE'  then Result:=add2dm_line(line, down);//d1,d2 in use

end;


{ Tadd2dm_list: }

function Tadd2dm_list.load_cod_file: boolean;
const _file_name = 'mss_acad.cod';
var
  //nok: integer;
  i: integer; _file: TFileX; _file_path: string; isreal: boolean;
  data: Tadd2dm_data;
  fline: String;//строка файла
  sl0: TStringList;//все слова строки файла
  sl: TStringList;//непустые и не %-слова строки файла
begin
  //Result:=TRUE;//!
  Clear;//!

  _file_path:=ExeDir+_file_name;
  if not FileExists(_file_path) then begin
    Tellf('Файл "%s" не найден',[_file_path]);
    Result:=FALSE;//!
    EXIT;//!
  end;

  sl0:=TStringList.Create;
  sl:=TStringList.Create;
  _file:=NIL;
  try
    _file:=TFileX.Create(_file_path, fmOpenRead, true{mes});//m.b. exception!!!

    while not _file.EOF do begin
      //Result:=TRUE;//!!! - для новой строки
      Result:=FALSE;//default!

      fline:=_file.ReadLnS;

      //sl0:
      sgetlist3(fline, sl0, '');//sl0.Clear

      //sl:
      sl.Clear;//!
      if sl0.Count>0 then for i:=0 to sl0.Count-1 do begin
        if sl0[i]='' then CONTINUE;
        if sl0[i][1]='%' then BREAK;//!
        sl.Add(sl0[i]);//не пустая и до %
      end;//for i

      if sl.Count<2 then CONTINUE;//in while => next line

      //NEW FILE FORMAT: dmcode dmloc:
      if not isdmcode(sl[0])
      or not (Length(sl[1])=1) or not isdigit(sl[1][1])//dmloc - NEW FILE FORMAT
      then begin
        if TellfYN('"%s  %s" -\nERROR in "CODE LOCAL" format\n(new version of file MSS_ACAD.COD)\nCONTINUE?',
                 [sl[0],sl[1]])
        then CONTINUE//in while => next line
        else BREAK;//in while => Result:=FALSE
      end;

      data:=Tadd2dm_data.Create;//содержимое строки sl, sl.Count>0

      //первые 2 слова в строке: dmcode dmloc:
      data.dmcode:=dml0_String_To_Code(sl[0]);
      data.dmloc:=ivaldef(sl[1], 2);//LINE?

      //1: добавление знака к линии:
      if (sl.Count=4)
      and isdmcode(sl[2])
      and isintstring(sl[3])
      then begin
        data.sType:='SIGN';
        data.addloc:=1;//ЗНАК
        data.addcode:=dml0_String_To_Code(sl[2]);
        data.addpose:=ivaldef(sl[3], 1);
        Result:=TRUE;//!
      end;

      //2: КРЕСТЫ:
      if (sl.Count=4)
      and isdmcode(sl[2])
      and (Length(sl[3])>5) and (pos('KREST', sl[3])=1)
      then begin
        data.sType:='KREST';
        data.addloc:=2;//LINE
        data.addcode:=dml0_String_To_Code(sl[2]);
        data.addpose:=90+ivaldef(sl[3][6], 1);//90..99
        Result:=TRUE;//!
      end;

      //3: LEP:
      if (sl.Count=5)
      and isdmcode(sl[2]) and isdmcode(sl[3])
      and (sl[4]='LEP')
      then begin
        data.sType:='LEP';

        data.addloc:=2;//LINE
        data.addcode:=dml0_String_To_Code(sl[2]);

        data.addloc2:=1;//ЗНАК
        data.addcode2:=dml0_String_To_Code(sl[3]);

        Result:=TRUE;//!
      end;

      //4: LINE (часть линии):
      if (sl.Count=6)
      and isdmcode(sl[2])
      and isnumstring(sl[3],isreal) and isnumstring(sl[4],isreal)
      and (sl[5]='LINE')
      then begin
        data.sType:='LINE';

        data.addloc:=2;//LINE
        data.addcode:=dml0_String_To_Code(sl[2]);

        data.d1:=rvaldef(sl[3], 0);//отступ от начала
        data.d2:=rvaldef(sl[4], 0);//отступ от конца

        Result:=TRUE;//!
      end;


      if Result then
        Add(data)
      else begin
        data.Free;//!
        //Tellf('mss_acad:\n%s\n- параметры не распознаны\nстрока проигнорирована',[fline]);
        Tellf('mss_acad:\n%s\nERROR in file line\n- will be ignored',[fline]);
      end;

    end;//while not EOF

    //Tellf('add2line_list.count = %d',[Count]);//----------DEBUG
  finally
    _file.Free;
    sl.Free;
    sl0.Free;
  end;

  Result := Count>0;//!
end;

function Tadd2dm_list.add2dm: integer;
var i,ofs: integer; data: Tadd2dm_data; dmline: tdmo;

  procedure Tadd2dm_list_add2dm(const _loc: integer; _signrepeat: boolean; var _result: integer);
  var _addResult: boolean; char303: Word; del_list: tinta; idel: integer;
  begin
    del_list:=tinta.New;
    try

      ofs := dm_Find_Frst_Code(data.dmcode, _loc);
      while ofs>0 do begin

        dmline:=tdmo.CreateFromDm0;
        //if (_loc<>1)
        //or (_loc=1) and _signrepeat and (dmline.Points.Count>1)// OLD format of mss_acad
        //or (_loc=1) and (dmline.Points.Count>1)
        if dmline.Points.Count>1
        then//---ТОЛЬКО ЕСЛИ ЛИНИЯ/ВЕКТОР из 2-х точек!
        try

          if data.sType='LEP'
          then begin
            _addResult := data.add2dm(dmline.Points, FALSE{down});//'LEP' - стрелки НЕ ДОЧЕРНИЕ!!!
            dm_goto_node(dmline.dmoffset);//на всякий случай

            if dm_get_word(303, 0, char303)//хар-ка 303=2 - "частичное отображение"
            and (char303=2)
            then del_list.Add(dmline.dmoffset);//на застроенной территории

          end else begin
            _addResult := data.add2dm(dmline.Points, TRUE{down});
            dm_goto_node(dmline.dmoffset);//на всякий случай
          end;

          if _addResult then inc(Result);

        finally
          dmline.Free;
        end;

        ofs := dm_Find_Next_Code(data.dmcode, _loc);//Next line
      end;//while

    finally
      //удаление линий ЛЭП:
      if del_list.Count>0 then for idel:=0 to del_list.Count-1
      do
        try dm_Del_Object(0, del_list[idel]);
        except
          ;
        end;
      del_list.Free;
    end;
  end;

begin
  Result:=0;
  if Count>0 then for i:=0 to Count-1 do begin
    TObject(data):=Items[i];

    Tadd2dm_list_add2dm(data.dmloc, FALSE, Result);
(*
    if data.dmloc=2{line}
    then
    Tadd2dm_list_add2dm(1{sign}, TRUE, Result);//---ПОВТОР ДЛЯ ЗНАКОВ ИЗ 2-х точек
*)
  end;
end;

(*
procedure Tadd2line_list.CreateDebugList;
var data: Tadd2line_data;
begin

  data:=Tadd2line_data.Create;
  data.linecode := dml0_String_To_Code('G0105000');//оттяжка
  data.addloc := 1;
  data.addcode := dml0_String_To_Code('00000901');//столбик
  data.addpose := 2;//в конце
  Add(data);

  data:=Tadd2line_data.Create;
  data.linecode := dml0_String_To_Code('P1103000');//лоток
  data.addloc := 1;
  data.addcode := dml0_String_To_Code('00000902');//штрих лотка
  data.addpose := 1;//в начале
  Add(data);

  data:=Tadd2line_data.Create;
  data.linecode := dml0_String_To_Code('P1103000');//лоток
  data.addloc := 1;
  data.addcode := dml0_String_To_Code('00000902');//штрих лотка
  data.addpose := 2;//в конце
  Add(data);

end;
*)

end.
