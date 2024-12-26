//Функционал, динам-ое програм-ие:
unit KRI_DP;

{$MODE Delphi}

 interface

uses
  List, llib, llibx, nums;


//del0,del1: true, если этот конец получен из деления (=> пол-штриха)
//Result: list of tpl
function kri_dp_execute(pa0: tpl; delta2,sL: tnum; del0,del1: boolean): tclasslist;


//-------------------------------------------------
implementation
//-------------------------------------------------

uses
  Forms,
  Wcmn, vlib, hline, gcx, RUNLINE2,
  Arrayx, DLINE, KRIVIZNA;

//-------------------------------------------------


type
  pcell = ^tcell;
  tcell = record
    i: tint;  //позиция точки
    j: tint;  //индекс пред.ячейки
    f: tnum;  //значение функционала
  end;

  tdptab = class
  private
    FTab: TClassList;
    Fnmin,Fnmax,Fdn: tint;//step->Fnmin; step2->Fnmax; dlen/2->Fdn;
    Fpl: tpl;
    Fka: tnuma;
    FClosed: boolean;
    FFunc: tnuma;
    function NewRow: tarray; //добавляет в FTab
    function LastRow: tarray;

    function func0(i: tint): tnum;//from Fka
    function func(i: tint): tnum;//from FFunc
    function calc_new_position(i: tint; row0: tarray; var cell: tcell): boolean;
    function tab_begin: boolean;
    //i0=1..n0-2 (без первой и последней точек!):
    function next_point: boolean;
    function tab_end(pae_rev: tpa): boolean;

  public
    constructor Create;
    destructor Destroy; override;
    function Execute(pl: tpl; ka: tnuma; pad: tpa): boolean;
  end;


//-------------------------------------------------

function kri_dp_execute(pa0: tpl; delta2,sL: tnum; del0,del1: boolean): tclasslist;
var
  dptab: tdptab;
  pa1,pa1tmp: tpl;//продолженная линия; tpl - только для удаления совпад-их точек(?!?)
  n_uni: tint;
  pak: tpl;//tpl(FL) for Execute (только для FL[0]!)
  pad: tpa;
  ka: tnuma;
  d: tnum; v: tnum2;
begin
  Result:=nil;
  pa1tmp:=tpl.newfrom(pa0);//продолженная линия будет
  pak:=tpl.new;
  ka:=tnuma.new;
  pad:=tpa.New;
  dptab:=tdptab.Create;

  n_uni:=Round(pa1tmp.Lena.last/sL);
  if n_uni<8 then n_uni:=8; //n>=7 in DLL_KRI!
  if n_uni<=4*pa1tmp.count then n_uni:=4*pa1tmp.count;
  pa1:=pa1tmp.NewUniform(n_uni);
  try
    RunForm.Start2(gcx_obj.scode);
    dptab.FClosed:=pa1.Closed;

    //продолжение линии:
    //начальная точка области - max kriv:
    d:=gcx_kri.step/2;//полуштрих min-ый
    //начало:
    if del0 then begin
      try
        v:=pa1.v[0];
        v:=v_mul(v, d/v_mod(v));
        v:=v_sub(pa1.first, v);
      except
        v:=v_xy(d,0);
      end;
      pa1.insert(0,v);
    end;
    //конец:
    if del1 then begin
      try
        v:=pa1.v[pa1.count-2];
        v:=v_mul(v, d/v_mod(v));
        v:=v_add(pa1.last, v);
      except
        v:=v_xy(d,0);
      end;
      pa1.add(v);
    end;

//    pa1.update;//

    if krivizna_calc0(pa1,pak,ka, sL) then begin//кривизна pa1
//      pak.update;
      if dptab.Execute(pak,ka, pad) then begin
        pad.reverse;//разворот
        //лишние точки на концах:
        pad.DeleteFirst;
        pad.DeleteLast;
        Result:=dl_execute(pa0,pad, delta2,1*gcx_DmPerMm, false);//делим именно pa0!
      end;//if dptab.Execute
    end;//if krivizna

  finally
    RunForm.Finish2;
    pak.free;
    pa1.free;
    pa1tmp.free;
    dptab.free;
    pad.free;
    ka.free;
    if Result=nil
      then Result:=tclasslist.Create(1024);//empty result
  end;
end;


//-------------------------------------------------


{ tdptab: }

constructor tdptab.Create;
begin
  FTab:=TClassList.Create(256);
  FFunc:=tnuma.new;
end;

destructor tdptab.Destroy;
begin
  FTab.Free;
  FFunc.free;
end;

function tdptab.NewRow: tarray;
begin
  Result := TArray.Create(sizeof(tcell), 1024);
  Ftab.add(Result);
end;

function tdptab.LastRow: tarray;
begin
  TObject(Result) := FTab[FTab.Count-1];
end;


function tdptab.Execute(pl: tpl; ka: tnuma; pad: tpa): boolean;
var i,n: tint;
begin
  Result:=false;
  if pl.count<3 then exit;

  Fpl:=pl;
  Fka:=ka;
  for i:=0 to Fka.count-1 do FFunc.add(func0(i));

  Fnmin:=Round(gcx_kri.step/Fpl.Lena[1]);
  Fnmax:=Round(gcx_kri.step2/Fpl.Lena[1]);
  Fdn:=Round(gcx_kri.dlen/(2*Fpl.Lena[1]));
  if (Fnmin<=0) or (Fnmax<=Fnmin) then exit;

  n:=Round(gcx_kri.step/Fpl.Lena.last); if n<=0 then n:=1; //max кол-во точек      //???
//  n:=Round(Fpl.Lena.last/gcx_kri.step); if n<=0 then n:=1; //max кол-во точек

  //n>=3:          //???
  try
    i:=0;
    Result:=tab_begin;
    if Result then begin
      while true do begin
        inc(i); if i>n then i:=n; RunForm.Go2(i/n);
        if RunForm.Cancelled then Result:=false;//<-Application.ProcessMessages
        if not Result then break;
        Result:=next_point; //false: конец линии (НЕ ошибка!)
      end;
    Result:=tab_end(pad); //false: не попали на конец линии (ошибка)
    end;
  finally
  end;
end;


//--------------------------- Execute: ---------------------------------------

function tdptab.func0(i: tint): tnum;
var j,i1,i2: tint;
begin
  //Result:=abs(Fka[i]);
  Result:=0;
  i1:=i-Fdn; if i1<0 then i1:=0;
  i2:=i+Fdn; if i2>Fka.count-1 then i2:=Fka.count-1;
  for j:=i1 to i2 do Result:=Result+abs(Fka[j]);
end;

function tdptab.func(i: tint): tnum;
begin
  Result:=FFunc[i];
end;


function tdptab.calc_new_position(i: tint; row0: tarray; var cell: tcell): boolean;
var
  irow: tint;
  f: tnum;
  p: tnum2;
  cell0: tcell;
begin
  Result:=false;
  p:=Fpl[i];

  //первая точка (левая):
  if row0=nil then begin
      Result:=true;
      cell.f:=func(0);
      cell.i:=0;
      cell.j:=-1;//нет ссылки влево
      exit;
  end;

  //цикл по точкам, расположенным левее p (cell0.i<i):
  if row0.count>0 then for irow:=0 to row0.count-1 do begin
    row0.get(irow, cell0);

    //недопустимые положения:
    if cell0.i+Fnmin>i then continue;
    if cell0.i+Fnmax<i then continue;

    //функционал:
    f := cell0.f + func(i);

    //запомним минимум:
    if (irow=0) or (f<cell.f) then begin
      Result:=true;
      cell.f:=f;
      cell.i:=i;
      cell.j:=irow;
    end;
  end;//for irow
end;

function tdptab.tab_begin: boolean;
var row1: tarray; cell: tcell;
begin
  row1:=newrow;
  if calc_new_position(0, nil, cell) then row1.Add(cell);
  Result:=row1.count>0;//false => линия короткая
end;

function tdptab.next_point: boolean;
var
  i: tint;
  cell: tcell;
  row0,row1: tarray;
begin
  row0:=lastrow;
  row1:=newrow;
  //цикл новой точки:
  if Fpl.count>0 then for i:=0 to Fpl.count-1 do begin
    if calc_new_position(i, row0, cell) then row1.Add(cell);
  end;//for i
  Result:=row1.count>0;//false => линия закончилась
end;

function tdptab.tab_end(pae_rev: tpa): boolean;
var
  i,jmin,j: tint;
  fmin: tnum;
  row: tarray;
  cell: tcell;
begin
  Result:=false;
  //последние ячейки:
  jmin:=-1;
  fmin:=0;
  if FTab.count>0 then for i:=0 to FTab.count-1 do begin
    TObject(row):=FTab[i];
    if row.count=0 then continue;
    row.get(row.count-1, cell);
    if cell.i<>Fpl.count-1 then continue;
    //минимум:
    if (jmin<0) or (cell.f<fmin) then begin
      Result:=true;
      fmin:=cell.f;
      jmin:=i;
    end;
  end;

  if not Result then exit;

  //сбор точек (в обратном порядке):
  j:=0;
  if jmin>=0 then for i:=jmin downto 0 do begin
    TObject(row):=FTab[i];
    if i=jmin then j:=row.count-1;
    if j<0 then break;//error
    row.get(j,cell);
    pae_rev.add( Fpl[cell.i] );
    j:=cell.j;//next j
  end;
end;

//-------------------------------------------------------------------------

end.
