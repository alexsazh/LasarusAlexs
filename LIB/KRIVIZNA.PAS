unit KRIVIZNA;

{$MODE Delphi}

 interface

uses dll_kri, llib, nums;

//EPS=3*sL (точность)
function krivizna_calc0(pa0,pak: tpa; ka: tnuma; sL: tnum): boolean;


implementation

uses Wcmn, Arrayx, vlib;


//EPS=3*sL (точность)
function krivizna_calc0(pa0,pak: tpa; ka: tnuma; sL: tnum): boolean;
var
  pk2,p2: psing;
  n2: longint;
  plen: psing;
  Pli: TIntArray;
//  s: string;
  i: integer;

  function p2i(i: tint): tnum2;
  begin
    Result.x:=psing(pchar(p2)+2*i*sizeof(single))^;
    Result.y:=psing(pchar(p2)+(2*i+1)*sizeof(single))^;
  end;
  function pk2i(i: tint): tnum;
  begin
    Result:=psing(pchar(pk2)+i*sizeof(single))^;
  end;
begin
  Result:=false;
  if pa0.count<7 then exit;  //7 ???

  Result:=true;
  Pli:=TIntArray.New;
  pa0.AddToInt(Pli);
  pchar(plen):=malloc(pa0.Count*sizeof(single));

  n2:=0;
  _dll_init;
  try
    try
      //p,n,l,  k2,p2,n2,  sL:
      _dll_kri0(plong(Pli.Memory),pa0.Count,plen, @pk2,@p2,@n2, sL);
    except
      Result:=false;
      Tell('Ошибка вычислений в DLL_KRI');
    end;

    //Output:
    if Result and (n2>0) then for i:=0 to n2-1 do begin
      pak.add(p2i(i));
      ka.add(pk2i(i));
    end;
  finally
    _dll_done;
    Pli.Free;
    mfree2(plen);
  end;
end;


end.
