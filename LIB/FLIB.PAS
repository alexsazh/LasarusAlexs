//Functions (FunList: AutoFree!):
unit FLIB;

{$MODE Delphi}

 interface

uses nums;


type
  tfun = class(tnuma)
  private
    function y_lin(i,j1,j2: tint; f1,f2: tnum): tnum;
    function y_add(i,j1,j2: tint; f1,f2: tnum): tnum;
  public
    constructor New; //-> FunList
    procedure lin(xcount: tint; y1,y2: tnum);
    procedure ltransform1(i1,i2: tint; y1,y2: tnum);
    procedure ltransform2(i1,i2: tint; y1,y2: tnum);
  end;



implementation

uses Wcmn, List, Arrayx;

var FunList: TClassList;


{ private: }

function tfun.y_lin(i,j1,j2: tint; f1,f2: tnum): tnum;
begin
  result := (f1)*(i-j2)/(j1-j2) + (f2)*(i-j1)/(j2-j1);
end;

function tfun.y_add(i,j1,j2: tint; f1,f2: tnum): tnum;
begin
  result := (f1-num[j1])*(i-j2)/(j1-j2) + (f2-num[j2])*(i-j1)/(j2-j1);
end;


{ public: }

constructor tfun.New; //-> FunList
begin
  inherited New;
  FunList.Add(Self);
end;


procedure tfun.lin(xcount: tint; y1,y2: tnum);
var i: integer;
begin
  count:=xcount;
  if count>1 then for i:=0 to count-1 do num[i] := y1 + i*(y2-y1)/(count-1)
  else num[0] := y1;
end;


procedure tfun.ltransform1(i1,i2: tint; y1,y2: tnum);
var i: tint;
begin
  if count>0 then for i:=0 to count-1 do begin
    if i<i1 then num[i] := num[i] + y_add(i,0,i1,first,y1)//0..i1-1
    else if i<=i2 then num[i] := y_lin(i,i1,i2,y1,y2)//i1..i2
    else num[i] := num[i] + y_add(i,i2,count-1,y2,last);//i2..count-1
  end;//for
end;

procedure tfun.ltransform2(i1,i2: tint; y1,y2: tnum);
var i: tint;
begin
  i:=i1; while (i>0) and (num[i]>y1) do dec(i); i1:=i;
  i:=i2; while (i<count-1) and (num[i]<y2) do inc(i); i2:=i;
  ltransform1(i1,i2, y1,y2);
end;


initialization
  FunList:=TClassList.Create(100);
finalization
  FunList.Free;

end.
