unit CMN;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, nums, llib, llibx, PSOBJ, Psdicts, Dmlib, Types;


//Result>=1 - кол-во интервалов, не вершин; chet => четный Result
function cmn_step2n(step,len: tnum; chet: boolean): tint;

var
  cmn_CharaExists: boolean;
  cmn_CharaProc: tpsobj;
  cmn_H_Dict: tpsdict;

//-------------- ЗАПИСЬ в новую DM_GCX: --------------------

const
  //if Assigned(cmn_dm) then НАДО ДОБАВЛЯТЬ новые tmso в cmn_newdm
  cmn_newdm: TDm = NIL;//GCX-карта достроенная (create in main.pas)
  cmn_newdmo_count: integer = 0;
var
  cmn_dm_a, cmn_dm_b: TPoint;//выбранная рамка в карте
  cmn_dm_childs_count: integer;//0 => add to down


//КАРТА cmn_newdm ОТКРЫТА (main.pas): cmn_newdm<>NIL:
function cmn_newdm_add_pl(s9code{A00000000}: string; pl: tpl; down: boolean): boolean;


implementation

uses vlib, dmlib0;


//Result>=1 - кол-во интервалов, не вершин; chet => четный Result
function cmn_step2n(step,len: tnum; chet: boolean): tint;
begin
  if chet then step:=2*step;//двойной шаг для четного результата
  try
    Result:=abs(Round(len/step));
    if Result=0 then Result:=1;
  except
    Result:=1;
  end;
  if chet then Result:=2*Result;//четный результат
end;


//КАРТА cmn_newdm ОТКРЫТА (main.pas): cmn_newdm<>NIL:
function cmn_newdm_add_pl(s9code{A00000000}: string; pl: tpl; down: boolean): boolean;
var i,lcode,loc: integer; p: tnum2; dmo: tdmo;
begin
  Result:=false;//default

  loc := dml0_9String_To_CodeLoc(s9code, lcode);
  if loc<=0 then EXIT;//!

  dmo:=tdmo.CreateCode2(loc, lcode, FALSE{aGauss});
  try
    dmo.Points.Count:=pl.Count;
    if pl.Count>0 then for i:=0 to pl.Count-1 do begin
      //считаем, что в $.ms map = (0,0,bx,by):
      p.x := cmn_dm_a.x + pl[i].x;
      p.y := cmn_dm_b.y - pl[i].y;
      dmo.Points[i]:=p;
    end;//for i

    if pl.Count>0
    then Result := dmo.Add(down)>0//с дырками!
    else Result := TRUE;//!
  finally
    dmo.Free;
  end;

end;


end.
