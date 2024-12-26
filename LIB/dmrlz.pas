unit dmrlz; interface

uses nums, vlib, vlib3d, llib3d;


const DmRlz_FalseValue = -100000;//-100 км

type
  TDmRlz = class
  protected
  public
    FileName: string;//'' <=> не открыт !!!
    Step: double;//шаг матрицы, Гаусс (Open)
    function Open(aFileName: string; _msg: boolean): boolean;
    procedure Close;
    function GetValue(p2d: tnum2; var z: Double): boolean;//false - вне матрицы RLZ(?)

    //mat: по строкам сверху вниз (как BMP), размер получается - как у BMP in TDmBmpRlz:
    procedure SaveValuesToMatrix(aBox{Гаусс}: tnum4; aStep{м}: double; mat: tnuma2; FalseValue: double = DmRlz_FalseValue);

    function GetDistFromLine_ByPoints(aPL3: tpl3d; aBox: tnum4; var p_line,p_rlz: tnum3): double;//def=-1
  end;


implementation

uses wcmn, d3_use, dll_rlz, imagex{размеры матрицы};


function TDmRlz.Open(aFileName: string; _msg: boolean): boolean;
begin
  Result := rel_Open( PChar(aFileName) );
  if Result then begin
    FileName := aFileName;//!
    Step := rlz_get_step;
  end else begin
    FileName := '';//!
    if _msg then Tellf('TDmRlz.Open=FALSE on "%s"',[aFileName]);
  end;
end;

procedure TDmRlz.Close;
begin
  if FileName<>'' then rel_Close;
  FileName:='';//!
end;

function TDmRlz.GetValue(p2d: tnum2; var z: Double): boolean;
begin
  Result := rel_Value(p2d.x,p2d.y, z);
  if Result and (z<-1000{Толик -5000 иногда возвращает})
  then Result := false;//!!!
end;


procedure TDmRlz.SaveValuesToMatrix(aBox{Гаусс}: tnum4; aStep{м}: double; mat: tnuma2; FalseValue: double);
var GTopLeft,GSize,p: tnum2; w,h,i{столбец},j{строка}: integer; v: double;
begin
  imx_get_sizes_from_box(aBox,aStep, GTopLeft,GSize, w,h);

  mat.SetSize(w,h);//clear!
  if mat.Status<>0 then EXIT;//out of memory!

  if h>0 then for j{строка}:=0 to h-1 do begin
    if w>0 then for i{столбец}:=0 to w-1 do begin
      imx_ixiy_to_xy(i,j, p, GTopLeft,GSize, w,h);
      if not GetValue(p, v) then v:=FalseValue;//!
      mat[i,j]:=v;
    end;//for i
  end;//for j
end;


function TDmRlz.GetDistFromLine_ByPoints(aPL3: tpl3d; aBox: tnum4; var p_line,p_rlz: tnum3): double;//def=-1
var d: double; p_prj,pxy: tnum3;
begin
  Result:=-1;
  pxy.p:=aBox.a;//MINx,MINy
  while pxy.p.y<=aBox.b.y do begin
    pxy.p.x:=aBox.a.x;//FIRST X
    while pxy.p.x<=aBox.b.x do begin
      if GetValue(pxy.p, pxy.z) then begin//pxy:

        d := aPL3.DistFromPoint_bypoints(pxy,p_prj);
        if (d>=0) and ( (Result<0) or (d<Result) ) then begin
          Result:=d;
          p_line:=p_prj;
          p_rlz:=pxy;
        end;

      end;//pxy
      pxy.p.x:=pxy.p.x+Step;//NEXT X
    end;//while-X
    pxy.p.y:=pxy.p.y+Step;//NEXT Y
  end;//while-Y
end;


end.
