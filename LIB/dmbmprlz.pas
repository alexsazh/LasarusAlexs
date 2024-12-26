unit dmbmprlz; interface

uses
  Graphics,
  nums, vlib, vlib3D, llib3d,
  dmbmp, dmrlz;


type
  //USE: Create - Rlz.Open - DrawArea - DistFromPoint - ...
  //ПРОВЕРКА: Rlz.FileName<>''
  TDmBmpRlz = class(TDmBmp)
  protected
  public
    Rlz: TDmRlz;//файл м.б. не открыт!
    constructor Create(aBox: tnum4; aRlzPath: string);//ПРОВЕРКА: Rlz.FileName<>''
    destructor Destroy; override;//Rlz.Close

    //after RlzOpen & DrawArea: default=-1(!!!):
    function ip_to_gp3d(ix,iy: integer; var p3: tnum3): boolean;
    function DistFromPoint(p3d: tnum3; var q3d: tnum3; aColor: TColor): double;
    function DistFromPoints(pl: tpl3d; var p3d,q3d: tnum3; _outrunline2: boolean; aColor: TColor): double;

    property Pixels;
  end;


implementation

uses wcmn, imagex, dll_rlz, runline2;





{ TDmBmpRlz: }

constructor TDmBmpRlz.Create(aBox: tnum4; aRlzPath: string);
begin
  Rlz:=TDmRlz.Create;
  if Rlz.Open(aRlzPath, true{_msg}){=> Rlz.FileName<>''!} then begin
    inherited Create(aBox, Rlz.Step);//!
  end;
end;

destructor TDmBmpRlz.Destroy;
begin
  Rlz.Close;
  Rlz.Free;
  inherited;//!
end;


function TDmBmpRlz.ip_to_gp3d(ix,iy: integer; var p3: tnum3): boolean;
begin
  p3.p := ip_to_gp(ix,iy);
  Result := Rlz.GetValue(p3.p, p3.z);
end;


function TDmBmpRlz.DistFromPoint(p3d: tnum3; var q3d: tnum3; aColor: TColor): double;
var ix,iy: integer; d: double; q: tnum3;
begin
  Result := -1;//!!!
  if FBmp.Height>0 then for iy:=0 to FBmp.Height-1 do begin//сверху вниз
    if FBmp.Width>0 then for ix:=0 to FBmp.Width-1 do begin//слева направо
      if Pixels[ix,iy]<>aColor then continue;
      if not ip_to_gp3d(ix,iy, q) then continue;

      d := v3_dist(p3d, q);
      if (Result<0) or (d>=0) and (d<Result) then begin
        Result:=d;
        q3d:=q;
      end;
    end;//for ix
  end;//for iy
end;

function TDmBmpRlz.DistFromPoints(pl: tpl3d; var p3d,q3d: tnum3; _outrunline2: boolean; aColor: TColor): double;
var ix,iy: integer; d: double; p,q: tnum3;
begin
  Result := -1;//!!!
  if FBmp.Height>0 then for iy:=0 to FBmp.Height-1 do begin//сверху вниз
    if _outrunline2 then RunForm2.Go_t(iy/FBmp.Height);
    if FBmp.Width>0 then for ix:=0 to FBmp.Width-1 do begin//слева направо
      if Pixels[ix,iy]<>aColor then continue;
      if not ip_to_gp3d(ix,iy, q) then continue;

      d := pl.DistFromPoint_bypoints(q,p);
      if (Result<0) or (d>=0) and (d<Result) then begin
        Result:=d;
        p3d:=p;
        q3d:=q;
      end;
    end;//for ix
  end;//for iy
end;

end.
