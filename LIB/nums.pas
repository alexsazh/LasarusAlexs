(*
  Числа: tnum, tint, преобразавания чисел
  Массивы: tinta, tnuma
  Матрицы: tnuma2
*)
unit Nums;

{$MODE Delphi}

 interface

uses SysUtils, Arrayx;


const aDeltaDefault = 100; //tnuma.new

type

//  tnum = single;//4bytes (32bit)
  tnum = double;//8bytes (64bit)
  pnum = ^tnum;
  tint = integer; //4bytes
  pint = ^tint;

function num(t: extended): tnum;
function rad(g: extended): tnum;//grad->rad
function grad(r: extended): tnum;//rad->grad
procedure grad2gms(grad: extended; out g,m,s: integer);
function grad2sgms(grad: extended; _NS{else _EW}: boolean): string;//64°58'6"N
function sign(t: extended): tint;//-1,0,1
function signz(t,zero: extended): tint;//-1,0,1
function mymod(i,_mod: tint): tint;//с проверкой на отриц-ть

function angle(x,y: tnum): tnum;//от оси OX к оси OY, -180..180
function angle_correct(a: tnum): tnum; //-180<a<=180

//"средние" числа и углы:
function mnum(x1,x2,t,amod: tnum): tnum; //число в середине, amod<=0 не учит-ся
function mangle(a1,a2,t: tnum): tnum;
function bissangle(a1,a2: tnum): tnum;

//увеличивает xt до целого числа dt (по абс-ой величине):
function zcount(var xt,dt: tnum): integer;

type

  tinta = TIntArray;

  tnuma = class(tarray)
  protected
    function Get(Index: Integer): tnum;
    procedure Put(Index: Integer; Item: tnum);
  public
    constructor New;
    constructor Create(aDelta: Integer);
    function Add(Item: tnum): Integer;
    procedure Sort(ar2: tarray);//по возрастанию
    function First: tnum;
    function Last: tnum;
    procedure mul(t: tnum);
    procedure FillBy(v: tnum);

    function min(var ind: tint): tnum; overload;
    function min(i1,i2: tint; var ind: tint): tnum; overload;
    function max(var ind: tint): tnum; overload;
    function max(i1,i2: tint; var ind: tint): tnum; overload;

    //функция на сегменте:
    function min2(ya: tnuma; x1,x2: tnum): tnum;
    function max2(ya: tnuma; x1,x2: tnum): tnum;

    function sum: tnum;
    procedure diff(da: tnuma);//разности: da.count=count-1
    function nearest(x: tnum): tint;

    function cdm(dm: tnuma): tnum;//центр масс; dm[i] - "веса"; dm.count=count;
    function cm(m: tnuma): tnum;//центр масс; m.count=count+1; dm[i]:=m[i+1]-m[i]; m[0]=0; m.last=dm.asum;

    //x на отрезке vind(0..count-2), 0<=t<=1 (массив отсортирован!):
    //Result:=true => действительно внутри массива
    //Result:=false => First or Last
    function position(x: tnum; out t: tnum; out vind: tint): boolean;

    //ФУНКЦИЯ: xa(Self)+ya: массив Self МОНОТОННО возрастает, ya параллелен ему:

    //линейная интерполяция пропусков значений ya[i] в ф-ии ya(Self):
    //nulla[i]=1 - пропуск в ya:
    procedure InterpolFunction(ya: tnuma; nulla: tinta);
    //сужение ОДЗ ф-ии: ya(Self) -> ya2(xa2) на [x1,x2]:
//    procedure CutODZ(ya: tnuma; x1,x2: tnum; xa,ya: tnuma);
    //ya(Self) - функ-ия; x - промежуточное значение:
    //ааппроксимация ф-ии:
    //вне [x1,x2] возвращает y1 или y2:
    function Value(ya: tnuma; x: tnum; var y: tnum): boolean;//false - внутр.ошибка
    //лин.изменение(коррекция) ya на [x1,x2]&[x2,xmax] так, чтобы стало ya(x2)=y2:
    procedure LinCorFun_y2(ya: tnuma; x1,x2, y2: tnum);

    property num[Index: Integer]: tnum read Get write Put; default;
  end;

  //Матрица чисел (по строкам):
  //USEING: New - SetSize - Value2[Value2Corr]
  tnuma2 = class(tnuma)
  protected
    FWidth,FHeight: integer;
    function GetValue(i{столбец},j{строка}: integer): tnum;
    procedure PutValue(i{столбец},j{строка}: integer; v: tnum);
  public
    constructor Create(aWidth,aHeight: integer);
    destructor Destroy; override;
    procedure SetSize(aWidth,aHeight: integer);//Clear+Count

    property Width: integer read FWidth;
    property Height: integer read FHeight;
    property Value2[i{столбец},j{строка}: integer]: tnum read GetValue write PutValue; default;
  end;


const tnuma2_FalseValue = -1000000;


implementation

uses
  Math,
  Wcmn;


function num(t: extended): tnum;
begin
  Result := t;
end;

function rad(g: extended): tnum;
begin
  Result := PI*g/180;
end;

function grad(r: extended): tnum;
begin
  Result := 180*r/PI;
end;

procedure grad2gms(grad: extended; out g,m,s: integer);
var x: extended;
begin
  g := Trunc(grad);//-1.22 -> -1
  x := (grad-g)*60;//-0.22*60 -> -13.2
  m := Trunc(x);//-13
  x := (x-m)*60;//-0.2*60 -> -12
  s := Trunc(x);//-12
end;

function grad2sgms(grad: extended; _NS{else _EW}: boolean): string;//64°58'6"N
var g,m,s: integer;
begin
  grad2gms(abs(grad), g,m,s);//знак -> символы N,S,E,W
  Result:=Format('%d'+#$B0+'%d''%d"',[g,m,s]);
  if _NS then
    if grad>=0 then Result:=Result+'N' else Result:=Result+'S'
  else
    if grad>=0 then Result:=Result+'E' else Result:=Result+'W';
end;

function sign(t: extended): tint;//-1,0,1
begin
  if t>0 then result:=1
  else if t<0 then result:=-1
  else result:=0;
end;

function signz(t,zero: extended): tint;//-1,0,1
begin
  if t>zero then result:=1
  else if t<-zero then result:=-1
  else result:=0;
end;

function mymod(i,_mod: tint): tint;//с проверкой на отриц-ть
begin
  Result := i mod _mod;
  if Result<0 then Result := _mod + Result;
end;


function angle(x,y: tnum): tnum;//-180..180
begin
  try
    Result:=arctan2(y,x);//-pi..pi
    Result:=grad(Result);
  except
    //x=0:
    Result:=90*sign(y);
  end;
end;

function angle_correct(a: tnum): tnum; //-180<a<=180
begin
  while a>180 do a:=a-360;
  while a<=-180 do a:=a+360;
  Result:=a;
end;


//число в середине, amod<=0 не учит-ся:
function mnum(x1,x2,t,amod: tnum): tnum;
begin
  if amod>0 then while x2<x1 do x2:=x2+amod;//=>x2>x1
  Result := x1 + t*(x2-x1);
  if amod>0 then while Result>amod do Result:=Result-amod;//=>Result<=amod
  if amod>0 then while Result<0 do Result:=Result+amod;//=>Result>=0
end;

function mangle(a1,a2,t: tnum): tnum;
begin
  Result := mnum(a1,a2,t,180);
end;

function bissangle(a1,a2: tnum): tnum;
begin
  Result := mangle(a1,a2,0.5);
end;


//увеличивает xt до целого числа dt (по абс-ой величине):
function zcount(var xt,dt: tnum): integer;
begin
  try
    Result:=Trunc(abs(xt)/dt)+1;
  except
    Result:=1;
    xt:=sign(xt)*dt;
  end;
  xt:=sign(xt)*dt*Result;
end;



{ tnuma: }


constructor tnuma.New;
begin
  inherited Create( SizeOf(tnum), aDeltaDefault);
end;

constructor tnuma.Create(aDelta: Integer);
begin
  inherited Create( SizeOf(tnum), aDelta );
end;

function tnuma.Get(Index: Integer): tnum;
begin
  inherited Get( Index, Result );
end;

procedure tnuma.Put(Index: Integer; Item: tnum);
begin
  inherited Put( Index, Item );
end;

function tnuma.Add(Item: tnum): Integer;
begin
  Result := inherited Add(Item);
end;

function _NumCmpFunc(p1,p2: pointer): integer;
var pr1,pr2: ^tNum;
begin
  pr1:=p1;
  pr2:=p2;
  if pr1^>pr2^ then Result:=1
  else if pr1^<pr2^ then Result:=-1
  else Result:=0;
end;

procedure tnuma.Sort(ar2: tarray);//по возрастанию
begin
  inherited Sort(_NumCmpFunc,ar2);
end;


function tnuma.First: tnum;
begin
  if count>0 then result:=num[0] else result:=0;
end;

function tnuma.Last: tnum;
begin
  if count>0 then result:=num[count-1] else result:=0;
end;

procedure tnuma.mul(t: tnum);
var i: tint;
begin
  if Count>0 then for i:=0 to Count-1 do num[i]:=t*num[i];
end;

procedure tnuma.FillBy(v: tnum);//w,h должны быть
var i: tint;
begin
  if Count>0 then for i:=0 to Count-1 do num[i]:=v;
end;

function tnuma.min(var ind: tint): tnum;
var i: tint; x: tnum;
begin
  Result:=0;
  ind:=-1;
  if Count>0 then for i:=0 to Count-1 do begin
    x:=num[i];
    if (i=0) or (i>0) and (x<Result) then begin
      Result:=x;
      ind:=i;
    end;
  end;
end;

function tnuma.min(i1,i2: tint; var ind: tint): tnum;
var i: tint; x: tnum;
begin
  Result:=0;
  ind:=-1;
  if i2>=i1 then for i:=i1 to i2 do begin
    x:=num[i];
    if (i=i1) or (i>i1) and (x<Result) then begin
      Result:=x;
      ind:=i;
    end;
  end;
end;

function tnuma.min2(ya: tnuma; x1,x2: tnum): tnum;
var i,ind: tint; y1,y2: tnum;
begin
  if not Value(ya,x1,y1) then y1:=ya.min(ind);
  if not Value(ya,x2,y2) then y2:=ya.min(ind);
  Result:=math.min(y1,y2);

  if Count>0 then for i:=0 to Count-1 do begin
    if num[i]<=x1 then continue;
    if num[i]>=x2 then break;//!
    if ya[i]<Result then Result:=ya[i];
  end;
end;

function tnuma.max(var ind: tint): tnum;
var i: integer; x: tnum;
begin
  Result:=0;
  ind:=-1;
  if Count>0 then for i:=0 to Count-1 do begin
    x:=num[i];
    if (i=0) or (i>0) and (x>Result) then begin
      Result:=x;
      ind:=i;
    end;
  end;
end;

function tnuma.max(i1,i2: tint; var ind: tint): tnum;
var i: tint; x: tnum;
begin
  Result:=0;
  ind:=-1;
  if i2>=i1 then for i:=i1 to i2 do begin
    x:=num[i];
    if (i=i1) or (i>i1) and (x>Result) then begin
      Result:=x;
      ind:=i;
    end;
  end;
end;

function tnuma.max2(ya: tnuma; x1,x2: tnum): tnum;
var i,ind: tint; y1,y2: tnum;
begin
  if not Value(ya,x1,y1) then y1:=ya.max(ind);
  if not Value(ya,x2,y2) then y2:=ya.max(ind);
  Result:=math.max(y1,y2);

  if Count>0 then for i:=0 to Count-1 do begin
    if num[i]<=x1 then continue;
    if num[i]>=x2 then break;//!
    if ya[i]>Result then Result:=ya[i];
  end;
end;

function tnuma.sum: tnum;
var i: integer;
begin
  Result:=0;
  if Count>0 then for i:=0 to Count-1 do Result:=Result+num[i];
end;

function tnuma.cdm(dm: tnuma): tnum;
var i: integer;
begin
  Result:=0;
  if Count=0 then exit;
  for i:=0 to Count-1 do Result:=Result+num[i]*dm[i];
  try Result:=Result/dm.sum;
  except Result:=0;
  end;
end;

function tnuma.cm(m: tnuma): tnum;
var i: integer;
begin
  Result:=0;
  if Count=0 then exit;
  for i:=0 to Count-1 do Result:=Result+num[i]*(m[i+1]-m[i]);
  try Result:=Result/m.last;
  except Result:=0;
  end;
end;


//разности: da.count=count-1:
procedure tnuma.diff(da: tnuma);
var i: tint;
begin
  da.clear;
  if count>1 then for i:=0 to count-2 do da[i]:=num[i+1]-num[i];
end;


function tnuma.nearest(x: tnum): tint;
var i: tint; dmin,di: tnum; imin: tint;
begin
  Result:=0;
  if Count<=1 then exit;

  dmin:=abs(x-num[0]); //i:=0
  imin:=0;

  if Count>=2 then for i:=1 to Count-1 do begin
    di:=abs(x-num[i]);
    if di<dmin then begin dmin:=di; imin:=i; end;
  end;

  Result := imin;
end;


function tnuma.position(x: tnum; out t: tnum; out vind: tint): boolean;//x на отрезке vind(0..count-2), 0<=t<=1
var i: tint;
begin
  Result:=false;

  vind:=0;
  t:=0;
  if Count<2 then exit;

  if x<First then begin vind:=0; t:=0; exit end;
  if x>Last then begin vind:=Count-2; t:=1; exit end;

  //First<=x<=Last (Count>=2):
  for i:=0 to Count-2 do begin
    if (x>=num[i]) and (x<=num[i+1]) then begin
      Result:=true;
      vind:=i;
      try t:=(x-num[i])/(num[i+1]-num[i]); except t:=0; end;
      break;//!
    end;
  end;//for i
end;

//-----------------------------

procedure InterpolFunction_do_segment(i1,i2: integer; xa,ya: tnuma);
var i: integer; x1,x2,y1,y2: tnum;
begin
  if i1=0 then begin ya[0]:=0; inc(i1) end;//???
  if i2=xa.count-1 then begin ya[xa.count-1]:=0; dec(i2) end;//???
  if i1>i2 then exit;

  //теперь отрезок [i1,i2] - строго внутри [0,count-1] & i1<=i2:
  x1:=xa[i1-1];
  y1:=ya[i1-1];
  x2:=xa[i2+1];
  y2:=ya[i2+1];

  if x2=x1 then begin
    for i:=i1 to i2 do ya[i] := (y1+y2)/2;
  end else begin
    for i:=i1 to i2 do
      try ya[i] := y1 + (xa[i]-x1)*(y2-y1)/(x2-x1);
      except ya[i] := (y1+y2)/2;
      end;
  end;
end;

procedure tnuma.InterpolFunction(ya: tnuma; nulla: tinta);
var i,i1,i2: integer; null_segment: boolean;
begin
  if count<>ya.Count then begin Tell('tnuma.InterpolFunction: different counts'); exit; end;
  if count<3 then exit;

  null_segment:=false;
  i1:=0;
  i:=0;
  while i<count do begin
    if nulla[i]=1 then begin
      if not null_segment then begin
        null_segment:=true;
        i1:=i;//начало null-отрезка
      end;
    end else begin
      if null_segment then begin
        null_segment:=false;
        i2:=i-1;//конец null-отрезка (i>0)
        InterpolFunction_do_segment(i1,i2, Self,ya);
      end;
    end;
    inc(i);
  end;//while
  if null_segment then begin
    i2:=count-1;
    InterpolFunction_do_segment(i1,i2, Self,ya);
  end;
end;
(*
procedure CutODZ(ya: tnuma; x1,x2: tnum; xa,ya: tnuma);
var i: integer;
begin
  xa.Clear; ya.Clear;
  if x1>=x2 then exit;//=>x1<x2

  if xa.Count>0 then for i:=0 to xa.Count-1 do begin
    if xa[i]<x1 then continue
    else

  end;
end;
*)
//ааппроксимация ф-ии:
function tnuma.Value(ya: tnuma; x: tnum; var y: tnum): boolean;
var i: integer;
begin
  Result:=true;
  if x<=First then begin y:=ya.first; exit; end;
  if x>=Last then begin y:=ya.last; exit; end;

  //поиск сегмента:
  if count>1 then for i:=0 to count-2 do begin
    if x>num[i+1] then continue;
    //=> x лежит в [i,i+1]:
    if num[i+1]<>num[i] then
      try y := ya[i] + (x-num[i])*(ya[i+1]-ya[i])/(num[i+1]-num[i]);
      except y := ya[i];
      end
    else y := ya[i];
    exit;//!
  end;

  Result:=false;//не было "exit" в цикле!
  //Tell('ERROR in tnuma.Value: x-array is not monotonous');
  y:=ya.first;
end;

//лин.изменение на [x1,x2]&[x2,xmax]: ya(x2)=y2:
procedure tnuma.LinCorFun_y2(ya: tnuma; x1,x2, y2: tnum);
var i: integer; y1: tnum;
begin
  if not Value(ya, x1,y1) then exit;
  if count>0 then for i:=0 to count-1 do begin
    if num[i]<x1 then continue;
    if num[i]<=x2 then begin//on [x1,x2]:
      try ya[i] :=  y1 + (num[i]-x1)*(y2-y1)/(x2-x1);
      except ya[i] := y2;
      end;
    end else begin//on [x2,xmax]:
      try ya[i] :=  ya.Last + (num[i]-Last)*(y2-ya.Last)/(x2-Last);
      except ya[i] := y2;
      end;
    end;
  end;//for i
end;


{ tnuma2: }

constructor tnuma2.Create(aWidth,aHeight: integer);
begin
  inherited New;//0-матрица
  SetSize(aWidth,aHeight);
end;

destructor tnuma2.Destroy;
begin
  inherited;
end;

procedure tnuma2.SetSize(aWidth,aHeight: integer);
begin
  if Count>0 then Clear;//!
  FWidth:=aWidth;
  FHeight:=aHeight;
  Count:=FHeight*FWidth;
end;

function tnuma2.GetValue(i{столбец},j{строка}: integer): tnum;
begin
  Result := num[ j*FWidth + i ];
end;

procedure tnuma2.PutValue(i{столбец},j{строка}: integer; v: tnum);
begin
  num[ j*FWidth + i ] := v;
end;


end.
