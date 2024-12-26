//DIV command:
unit DLINE;

{$MODE Delphi}

 interface

uses
  Classes,
  Arrayx, List, nums, vlib, llib, llibx;



//pa1: точки-дети; Result<>nil: list of tpa (Create!):
//delta2: сдвиг в т.деления в одну(!) сторону:
//delta0: допуск отклонения точки от линии (нужен для отбора детей)
//if sum_ends and pa0.closed, то 1-ый и посл-ий отрезки объединяются и станов-ся последним отрезком:
//Result: list of tpl
//pl0 может иметь дырки (!):
function dl_execute(pl0: tpl; pa1: tpa; delta2,delta0: tnum; sum_ends: boolean): tclasslist;


var
  //индексы в pa1 1-ой и 2-ой точек отрезков (-1 - концевая точка) (initialization/finalization):
  dline_inds0,dline_inds1: tintarray;


implementation

uses
  SysUtils,
  Wcmn, gcx;


//---------------------------------------------------------


function dl_execute0(pa0: tpl; pa1: tpa; delta2,delta0: tnum; sum_ends: boolean): tclasslist;
var
  i: tint;
  x1,x2,x: tnum;
  xa: tnuma;//массив точек деления
  inds: tintarray;//индексы точек xa в pa1 (после сортировки)
  add_first,add_last: boolean;//концевые сегменты;
  pl: tpl;

  procedure _AddSegment(OutList: TClassList; x1,x2: tnum);
  var paseg: tpl;
  begin
    paseg:=pa0.CreateSegment(x1,x2, false);
    OutList.Add(paseg);
  end;

begin
  Result:=tclasslist.New;

  //случай "pa1.Count=0" будет учтен в "xa.Count=0",
  //т.к. точки деления могут быть удалены от контура (от дырки)

  xa:=tnuma.new;
  inds:=tintarray.new;
  try
    add_first:=false;
    add_last:=false;
    dline_inds0.clear;
    dline_inds1.clear;

    //точки деления xa[i] (отбор детей):
    if pa1.Count>0 then for i:=0 to pa1.Count-1 do begin
      x:=pa0.xofp(pa1[i]);
      if ( v_dist( pa0.xp(x), pa1[i] ) <= delta0 ) then xa.add(x);
    end;
    inds.fill(0,1,xa.count);
    xa.Sort(inds);//!

    //контур без точек деления:
    if xa.Count=0 then begin
      pl:=tpl.newfrom(pa0);
      Result.add(pl);
      dline_inds0.add(-1);
      dline_inds1.add(-1);
    end;

    //далее xa.Count>0 (!):

    //первый крайний отрезок:
    if xa.Count>0 then begin
      x1:=xa.first;//начало
      if x1>delta2 then begin
        _AddSegment(Result, 0, x1-delta2);
        add_first:=true;
        dline_inds0.add(-1);
        dline_inds1.add(inds.first);
      end;
    end;

    //внутренние отрезки:
    if xa.Count>1 then for i:=1 to xa.Count-1 do begin
      x1:=xa[i-1];
      x2:=xa[i];
      if x2-x1>2*delta2 then begin
        _AddSegment(Result, x1+delta2, x2-delta2);
        dline_inds0.add(inds[i-1]);
        dline_inds1.add(inds[i]);
      end;
    end;

    //последний крайний отрезок:
    if xa.Count>0 then begin
      x2:=xa.last; //конец
      if x2<pa0.Lena.last-delta2 then begin
        _AddSegment(Result, x2+delta2, pa0.Lena.last);
        add_last:=true;
        dline_inds0.add(inds.last);
        dline_inds1.add(-1);
      end;
    end;

    //замкнутые линии:
    //нач. точка - не точка деления:
    if (xa.Count>0) and sum_ends and add_first and add_last and pa0.closed then begin

      //объединение крайних отрезков (if sum_ends):
      Result.DeleteFirst;
      Result.DeleteLast;
      dline_inds0.DeleteFirst;
      dline_inds0.DeleteLast;
      dline_inds1.DeleteFirst;
      dline_inds1.DeleteLast;

      //было больше 2-х отрезков или 2:
      if Result.count>0 then begin
        _AddSegment(Result, xa.last+delta2, xa.first-delta2);
        dline_inds0.add(inds.last);
        dline_inds1.add(inds.first);
      end else if pa1.count=1 then begin
        pl:=tpl.newfrom(pa0);
        pl.newstart(pa1.first);
        Result.add(pl);
      end;

    end;//замкнутые линии

  finally
    xa.Free;
    inds.free;
  end;
end;

//pl0 может иметь дырки:
function dl_execute(pl0: tpl; pa1: tpa; delta2,delta0: tnum; sum_ends: boolean): tclasslist;
var pl: tpl; lst: tclasslist;
begin
  Result:=tclasslist.New;

  pl:=pl0;
  while pl<>nil do begin
    lst:=dl_execute0(pl, pa1, delta2,delta0, sum_ends);
    Result.MoveFromList(lst);
    lst.Free;
    pl:=pl.Next;
  end;
end;


initialization
  dline_inds0:=tintarray.new;
  dline_inds1:=tintarray.new;
finalization
  dline_inds0.free;
  dline_inds1.free;

end.
