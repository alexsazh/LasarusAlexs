unit gcx;

{$MODE Delphi}

 interface

uses
  Classes,
  List, nums, PSOBJ, Psdicts, Psarrays, Color;


//COMMON:

function gcx_read(fname: string): boolean;
function gcx_knowncode(scode: string): boolean;
procedure ox_begin(cmd_ind: tint);//cmd_ind: всписке gcx_obj_list
procedure ox_end;
function gcx_cmdname: string;

//параметры:
function gcx_iparam(name: string): tint;//int
function gcx_rparam(name: string): tnum;//real
function gcx_mmparam(name: string): tnum;//real в мм
function gcx_sparam(name: string): string;//string

//параметры-массивы:
function gcx_a_param(name: string): tpsarray;//внутренняя ф-ия
procedure gcx_numa_param(name: string; numa: tnuma);//mm!!!
procedure gcx_inta_param(name: string; inta: tinta);
procedure gcx_cmyk_param(name: string; var cmyk: tcmykcolor);


const
  gcx_DmPerMm: tnum = 100;


//---------------------------------------------------------

//COMMAND MOSAIC(mosaic.pas):
var
  gcx_mosaic: record
    imode: tint;// 0-кирпичи, 1-овал1, 1-овал2
    oval_k: tnum;//1 - острые углы
  end;

procedure gcx_mosaic_load;

//---------------------------------------------------------

//COMMAND GF(gradfill.pas):
var
  gcx_gf: record
    mode: tint;// 0 - ox.GF_R(круг); 1 - ox.GF_L1(линия в области); 2 - ox.GF_L3(3 линии)
    colors_count: tint;//0 => xstep
    xstep: tnum;//color_step
    ystep: tnum;//lines_step
    //цвета по умолчанию:
    color1: tcmykcolor;
    color2: tcmykcolor;
  end;

procedure gcx_gf_load;

//---------------------------------------------------------

//COMMAND VOLNA (volna.pas):
var
  gcx_volna: record
    dash_array: tnuma;//initialization!!!
    dash_offset: tnum;
    dash_modes: tinta;//0-просто линия, 1-зигзаг, 2-волна   //initialization!!!
    width: tnum;//ширина зигзага (для волны - огибающего зигзага!)
    period: tnum;//период зигзага или волны
  end;

procedure gcx_volna_load;

//---------------------------------------------------------

//COMMAND DASH:
var
  gcx_dash: record
    dash_array: tnuma;//initialization!!!
    dash_offset: tnum;
  end;

procedure gcx_dash_load;

//---------------------------------------------------------

//COMMAND FORM (formsx.pas):
var
  gcx_forms: record
    name: string; //Pogreb,...
    len: tnum; //мм: длина уса
    dlen: tnum; //мм: выступ за край
    step: tnum; //мм: шаг
  end;

procedure gcx_forms_load;

//---------------------------------------------------------

//COMMAND ROAD (roads.pas):
var
  gcx_r: record
   out_area_ind: tint; //индекс кода белой вытерки
   out_left_ind: tint; //индекс кода левой стороны
   out_right_ind: tint; //индекс кода правой стороны
   out_h_ind: tint; //индекс кода поперечного объекта
   fname: string;
   h_step: tnum;
   h_ofs: tnum;
   h_dlen: tnum;
   h_len: tnum;
   //пунктиры:
   dash_l: tnuma;//initialization!!!
   dash_r: tnuma;//initialization!!!
   //производные:
   out_area_scode: string;
   out_left_scode: string;
   out_right_scode: string;
   out_h_scode: string;
  end;

procedure gcx_r_load;

//---------------------------------------------------------

//COMMAND HL (hline.pas,hl_dp.pas):
var
  gcx_hl: record
    twosides: tint; //for LHL
    dxmin,dxmax: tnum;//ускоряет оптимизацию!
    sh_size: tnum;//размер штриха для tpa.leftline
    zero: tnum;
    mode: string;
    parent_code, child_code, hatch_code, hatch2_code: integer; //индекс кода
    child_code_l: string;
    count: tint; //???
    step: tnum; //расстояние между штрихами
    tlen,dlen: tnum; //доля длины штрихов и отступ штрихов от границы
    shortlen: tnum; //мм - макс длина короткого штриха
    amin,amax: tnum; //0-угол, угол с биссектрисой
    lmax: tnum; //выпрямление
    ratio: tnum; //отн-ие плотностей
    nloop: tint; //max кол-во циклов
    dp_n: tint; //учащение точек концов
    hldp_fkd,hldp_fkcos,hldp_fkcos2 : tnum; //множители в функционале
  end;

procedure gcx_hl_load;
//---------------------------------------------------------

//COMMAND DIV (dline.pas):
var
  gcx_dl: record
    dlen: tnum; //раздвижка в т.деления
    parent_code,parent_code_a,b_code,m_code,e_code: tint; //индекс кода
  end;

procedure gcx_dl_load;
//---------------------------------------------------------

//COMMAND KRI (kri_dp.pas):
var
  gcx_kri: record
    dlen: tnum; //раздвижка в т.деления
    parent_code: tint; //индекс кода
    step,step2: tnum; //миним. и максим. отрезок
    zero: tnum; //sL,n_uni
  end;

procedure gcx_kri_load;
//---------------------------------------------------------
//COMMAND STEPS (steps.pas):
var
  gcx_st: record
    parent_code: tint; //индекс кода
    dx: tnum; //шаг ступеней
    nsteps: tint;
  end;

procedure gcx_st_load;
//---------------------------------------------------------
//COMMAND L2 (l2.pas) (использует все пар-ры HL(!), особенно dxmin,dxmax(!)):
var
  gcx_l2: record
    parent_code: tint; //индекс кода области
    child_code: tint; //индекс кода штрихов
    middle_code: tint; //индекс кода средней линии
  end;

procedure gcx_l2_load;
//---------------------------------------------------------

type
  //структура /scode - [ox [child] [outcode]]
  //содержимое (для одной команды) определяется в gcx_knowncode (если код найден):
  tgcx_obj = class
    scode: string;//parent code
    ox_psobj: tpsobj;//объект стека, соотв-ий словарю ox_dict
    ox_dict: TPsDict; //dict ox.HL (Params[0])
    child: TStringList;//Params[1]
    outcode: TStringList;//Params[2]
  public
    constructor create;
    destructor Destroy; override;
    function LoadFromPsArray(scod: string; o: tpsobj): boolean;
  end;

var
  gcx_obj: tgcx_obj; //для одной команды (ссылка на эл-т gcx_obj_list)
  gcx_obj_list: tclasslist; //для одного кода (список команд: определяется в gcx_knowncode)

  ProlongLines: tstringlist;
  LinesOnBound: tstringlist;
  LinesOnBoundDelta: tnuma;

implementation

uses
  Wcmn, PSLIB, PSX, PSOBJX, Psstacks, CMN;


var
  gcx_dict: TPsDict; //определяется в gcx_read: sCode-PsArray
  ox_count: integer; //цепочка производных объектов (контекст)


//-------------- PS-COMMON: --------------------------

procedure PsArray2Strings(ar: TPsArray; str: TStrings);
var i: integer; o: tpsobj;
begin
  if ar.count>0 then for i:=0 to ar.count do begin
    ar.get(i,o);
    str.add( psobj_asstring(o) );
  end;
end;


//-------------------- tgcx_obj: -------------------------

constructor tgcx_obj.create;
begin
  inherited create;
  child:=TStringList.Create;
  outcode:=TStringList.Create;
end;

destructor tgcx_obj.Destroy;
begin
  outcode.free;
  child.free;
  inherited destroy;
end;

//загрузка одной команды:
function tgcx_obj.LoadFromPsArray(scod: string; o: tpsobj): boolean;
var ar,ar2: TPsArray;
begin
  Result:=false;
  scode:=scod;
  if o.pstype in arraytypeset then begin

    TPsObjX(ar):=psobj_psobjx(o);
    if ar.count>=3 then begin

      Result:=true;

      ar.get(0, o);//ox.HL
      if o.pstype in dicttypeset then begin
        ox_psobj:=o;
        TPsObjX(ox_dict):=psobj_psobjx(o);
        //operandstack.Push(o);//!!!
      end else Result:=false;

      ar.get(1, o);//[childs]
      if o.pstype in arraytypeset then begin
        TPsObjX(ar2):=psobj_psobjx(o);
        PsArray2Strings(ar2, child);
      end else Result:=false;

      ar.get(2, o);//[outcodes]
      if o.pstype in arraytypeset then begin
        TPsObjX(ar2):=psobj_psobjx(o);
        PsArray2Strings(ar2, outcode);
      end else Result:=false;

    end;//if ar.count>=3

  end;//if o.pstype in arraytypeset
end;


//-------------- GCX-COMMON: --------------------------

function gcx_read(fname: string): boolean;
var i,key: integer; s: string;
   o: TPsObj; la: TPsArray; ldict: TPsDict;
   //dict0: TPsDict;
begin
  //ПРОВЕРКА ЦЕЛИ РАБОТЫ (in gcx - /_MSWFORAUTOCAD whereget...)
  if Assigned(cmn_newdm)
  then pslib_runstring('/_MSWFORAUTOCAD true def');//in currentdict !!!!!!!!!!!!!!!!!

  pslib_runstring('/gcxdict 256 dict def gcxdict begin');
  gcx_dict:=currentdict; //!

  Result := pslib_runfile(fname);
  //pslib_runstring('end'); //gcx_dict остаётся открытым!!!!!!!!!

  //load ProlongLines:
  ProlongLines.Clear;
  if gcx_dict.Value( PS.Names.key('ProlongLines'), o, i) then begin
    TPsObjX(la):=psobj_psobjx(o);
    if la.count>0 then for i:=0 to la.count-1 do begin
      la.get(i,o);
      s:=psobj_AsString(o);
      ProlongLines.Add(s);
    end;//for i
  end;//if

  //load LinesOnBound:
  LinesOnBound.Clear;
  LinesOnBoundDelta.Clear;
  if gcx_dict.Value( PS.Names.key('LinesOnBound'), o, i) then begin
    TPsObjX(ldict):=psobj_psobjx(o);
    if ldict.count>0 then for i:=0 to ldict.count-1 do begin
      key:=ldict.getp(i)^.key;
      o:=ldict.getp(i)^.val;
      s:=PS.Names.Name(key);
      LinesOnBound.Add(s);
      LinesOnBoundDelta.Add( psobj_AsReal(o) );
    end;//for i
  end;//if

end;

function gcx_knowncode(scode: string): boolean;
var o: TPsObj; i,key: integer; gcxo: tgcx_obj; arx: TPsArray;
begin
  Result:=false;
  gcx_obj_list.clear;
  key:=PS.Names.key(scode);
  if not gcx_dict.value( key, o, i) then exit; //scode нет в .gcx

  if o.pstype in arraytypeset then begin

    TPsObjX(arx):=psobj_psobjx(o); //массив мвссивов!!!
    i:=0;
    while true do begin
      arx.get(i, o);
      gcxo:=tgcx_obj.create;
      if gcxo.LoadFromPsArray(scode, o) then begin
        gcx_obj_list.add(gcxo);
      end else begin
        gcxo.free;
        break;
      end;
      inc(i);
    end;

    Result:=gcx_obj_list.count>0;

  end;//if o.pstype in arraytypeset

  if not Result then Tellf('Синтаксическая ошибка в файле .GCX\nкод=%s',[scode]);
end;



procedure ox_begin(cmd_ind: tint);
var d: tpsdict; key,i: integer; o: tpsobj;
begin
  tobject(gcx_obj):=gcx_obj_list[cmd_ind];
  operandstack.Push(gcx_obj.ox_psobj);//ox.HL -> стек

  ox_count:=1;//ox.HL уже в стеке!
  key:=PS.Names.key('parent');
  d:=gcx_obj.ox_dict;

  while d.Value(key,o,i) do begin
    TPsObjX(d):=psobj_psobjx(o);
    inc(ox_count);
    operandstack.push(o);
  end;

  for i:=1 to ox_count do begin
    operandstack.index(0,o);
    operandstack.pop;
    dictstack.push(o);//begin
  end;
end;

procedure ox_end;
var i: integer;
begin
  if ox_count>0 then for i:=1 to ox_count do begin
    dictstack.pop;//end
  end;
end;


{ параметры: }


function gcx_a_param(name: string): tpsarray;//внутренняя ф-ия
var key: integer; d,a: tpsobj;
begin
  Result:=nil;
  key:=PS.Names.key(name);
  if dictstack.find(key,d,a) and (a.pstype in arraytypeset)
    then tpsobjx(Result):=psobj_psobjx(a);
end;

procedure gcx_numa_param(name: string; numa: tnuma);
var i: integer; a: tpsarray;
begin
  numa.clear;
  a:=gcx_a_param(name);
  if a=nil then exit;
  if a.Count>0 then for i:=0 to a.Count-1 do numa.Add( psobj_asreal( a[i] )*gcx_DmPerMm );
end;

procedure gcx_inta_param(name: string; inta: tinta);
var i: integer; a: tpsarray;
begin
  inta.clear;
  a:=gcx_a_param(name);
  if a=nil then exit;
  if a.Count>0 then for i:=0 to a.Count-1 do inta.Add( psobj_asint( a[i] ) );
end;

procedure gcx_cmyk_param(name: string; var cmyk: tcmykcolor);
var a: tpsarray;
begin
  a:=gcx_a_param(name);
  if a=nil then exit;
  if a.Count<>4 then exit;
  cmyk.c:=psobj_asreal( a[0] );
  cmyk.m:=psobj_asreal( a[1] );
  cmyk.y:=psobj_asreal( a[2] );
  cmyk.k:=psobj_asreal( a[3] );
end;

function gcx_cmdname: string;
begin
  Result:=gcx_sparam('name')
end;

function gcx_iparam(name: string): tint;
var key: integer; val,d: tpsobj;
begin
  Result:=-1;//!
  key:=PS.Names.key(name);
  if dictstack.find(key, d, val)
  then Result:=psobj_AsInt(val);
end;

function gcx_rparam(name: string): tnum;
var key: integer; val,d: tpsobj;
begin
  Result:=0;
  key:=PS.Names.key(name);
  //if gcx_obj.ox.value( key, val, i)
  if dictstack.find(key, d, val)
  then Result:=psobj_AsReal(val);
end;

function gcx_mmparam(name: string): tnum;
var key: integer; val,d: tpsobj;
begin
  Result:=0;
  key:=PS.Names.key(name);
  //if gcx_obj.ox.value( key, val, i)
  if dictstack.find(key, d, val)
  then Result:=psobj_AsReal(val)*gcx_DmPerMm;
end;

function gcx_sparam(name: string): string;
var key: integer; val,d: tpsobj;
begin
  Result:='';
  key:=PS.Names.key(name);
  //if gcx_obj.ox.value( key, val, i)
  if dictstack.find(key, d, val)
  then Result:=psobj_AsString(val);
end;

//---------------------------------------------------------
//COMMAND MOSAIC(mosaic.pas):
procedure gcx_mosaic_load;
begin
  with gcx_mosaic do begin
    imode:=gcx_iparam('imode');
    oval_k:=gcx_rparam('oval_k');
  end;
end;

//---------------------------------------------------------
//COMMAND GF(gradfill.pas):
procedure gcx_gf_load;
begin
  with gcx_gf do begin
    mode:=gcx_iparam('mode');
    colors_count:=gcx_iparam('colors_count');
    xstep:=gcx_mmparam('color_step');
    ystep:=gcx_mmparam('lines_step');
    gcx_cmyk_param('color1',color1);
    gcx_cmyk_param('color2',color2);
  end;
end;

//---------------------------------------------------------
//COMMAND VOLNA (volna.pas):
procedure gcx_volna_load;
begin
  with gcx_volna do begin
    gcx_numa_param('dash_array',dash_array);
    dash_offset:=gcx_mmparam('dash_offset');
    gcx_inta_param('dash_modes',dash_modes);
    width:=gcx_mmparam('width');
    period:=gcx_mmparam('period');
  end;//with
end;

//---------------------------------------------------------
//COMMAND DASH:
procedure gcx_dash_load;
begin
  with gcx_dash do begin
    gcx_numa_param('dash_array',dash_array);
    dash_offset:=gcx_mmparam('dash_offset');
  end;//with
end;

//---------------------------------------------------------
//COMMAND FORMS (formsx.pas):
procedure gcx_forms_load;
begin
  with gcx_forms do begin
    name:=gcx_sparam('formname');
    len:=gcx_mmparam('len');
    dlen:=gcx_mmparam('dlen');
    step:=gcx_mmparam('step');
  end;//with
end;
//---------------------------------------------------------
//COMMAND ROAD (roads.pas):
procedure gcx_r_load;
begin
  with gcx_r do begin
   out_area_ind:=gcx_iparam('out_area_ind');
   out_left_ind:=gcx_iparam('out_left_ind');
   out_right_ind:=gcx_iparam('out_right_ind');
   out_h_ind:=gcx_iparam('out_h_ind');

   fname:=gcx_sparam('fname');
   h_step:=gcx_mmparam('h_step');
   h_ofs:=gcx_mmparam('h_ofs');
   h_dlen:=gcx_mmparam('h_dlen');
   h_len:=gcx_mmparam('h_len');

   gcx_numa_param('dash_l',dash_l);
   gcx_numa_param('dash_r',dash_r);

   //производные:
   if out_area_ind>=0 then out_area_scode:=gcx_obj.outcode[out_area_ind] else out_area_scode:='';
   if out_left_ind>=0 then out_left_scode:=gcx_obj.outcode[out_left_ind] else out_left_scode:='';
   if out_right_ind>=0 then out_right_scode:=gcx_obj.outcode[out_right_ind] else out_right_scode:='';
   if out_h_ind>=0 then out_h_scode:=gcx_obj.outcode[out_h_ind] else out_h_scode:='';
  end;//with
end;
//---------------------------------------------------------
//COMMAND HL (hline.pas):
procedure gcx_hl_load;
begin
  with gcx_hl do begin
    twosides:=gcx_iparam('twosides');
    dxmin:=gcx_mmparam('dxmin');
    dxmax:=gcx_mmparam('dxmax'); if dxmax=0 then dxmax:=1000;//мм
    sh_size:=gcx_mmparam('sh_size');

    mode:=gcx_sparam('mode');
    zero:=gcx_mmparam('zero');

    parent_code:=gcx_iparam('parent_code');
    child_code:=gcx_iparam('child_code');
    hatch_code:=gcx_iparam('hatch_code');
    hatch2_code:=gcx_iparam('hatch2_code');
    child_code_l:=gcx_sparam('child_code_l');

    count:=gcx_iparam('count');
    step:=gcx_mmparam('step');
    tlen:=gcx_rparam('tlen');
    dlen:=gcx_mmparam('dlen');

    shortlen:=gcx_mmparam('shortlen');//default=0 (!)

    amin:=gcx_rparam('amin');
    amax:=gcx_rparam('amax');
    lmax:=gcx_mmparam('lmax');
    ratio:=gcx_rparam('ratio');
    nloop:=gcx_iparam('nloop');
    dp_n:=gcx_iparam('dp_n');
    hldp_fkd:=gcx_rparam('hldp_fkd');
    hldp_fkcos:=gcx_rparam('hldp_fkcos');
    hldp_fkcos2:=gcx_rparam('hldp_fkcos2');
  end;//with
end;
//---------------------------------------------------------
//COMMAND DIV (dline.pas):
procedure gcx_dl_load;
begin
  with gcx_dl do begin
    dlen:=gcx_mmparam('dlen');
    parent_code:=gcx_iparam('parent_code');
    parent_code_a:=gcx_iparam('parent_code_a');
    b_code:=gcx_iparam('b_code');
    m_code:=gcx_iparam('m_code');
    e_code:=gcx_iparam('e_code');
  end;//with
end;
//---------------------------------------------------------
//COMMAND KRI (kri_dp.pas):
procedure gcx_kri_load;
begin
  with gcx_kri do begin
    dlen:=gcx_mmparam('dlen');
    parent_code:=gcx_iparam('parent_code');
    step:=gcx_mmparam('step');
    step2:=gcx_mmparam('step2');
    zero:=gcx_mmparam('zero');
  end;//with
end;
//---------------------------------------------------------
//COMMAND STEPS (steps.pas):
procedure gcx_st_load;
begin
  with gcx_st do begin
    parent_code:=gcx_iparam('parent_code');
    dx:=gcx_mmparam('dx');
    nsteps:=gcx_iparam('nsteps');
  end;//with
end;
//---------------------------------------------------------
//COMMAND L2 (l2.pas):
procedure gcx_l2_load;
begin
  with gcx_l2 do begin
    parent_code:=gcx_iparam('parent_code');
    child_code:=gcx_iparam('child_code');
    middle_code:=gcx_iparam('middle_code');
  end;//with
end;
//---------------------------------------------------------

initialization
  gcx_obj_list:=tclasslist.create(16);
  ProlongLines:=tstringlist.create;
  LinesOnBound:=tstringlist.create;
  LinesOnBoundDelta:=tnuma.new;

  gcx_volna.dash_array:=tnuma.new;
  gcx_volna.dash_modes:=tinta.new;

  gcx_dash.dash_array:=tnuma.new;

  gcx_r.dash_l:=tnuma.new;
  gcx_r.dash_r:=tnuma.new;

finalization
  gcx_obj_list.free;
  ProlongLines.free;
  LinesOnBound.free;
  LinesOnBoundDelta.free;

  gcx_volna.dash_array.free;
  gcx_volna.dash_modes.free;

  gcx_dash.dash_array.free;

  gcx_r.dash_l.Free;
  gcx_r.dash_r.Free;

end.
