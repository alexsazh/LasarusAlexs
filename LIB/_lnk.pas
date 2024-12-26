(*
  TOL: построение файла привязки для растра
*)
unit _lnk;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, Classes, Otypes, SysUtils;


//построение файла привязки растра размером 00-WH:
//g1,g2,g3,g4 - 4 угла от LUp по час стр - в проекции sys:
//path - растр - будет .@@@:
function lnk_make_file(sys: psys; WH: TPoint; g1,g2,g3,g4: PGauss; path: PChar): boolean;

//КАРТА ЗАКРЫТА(!):
function lnk_make_file2(pix_a,pix_b,map_a,map_b: TPoint;
                                    dmpath,lnkpath: string): boolean; overload;
function lnk_make_file2(WH,map_a,map_b: TPoint;
                                    dmpath,lnkpath: string): boolean; overload;


implementation

uses Wcmn, Dmw_ddw, Dmw_use;


type
  //DllGetInterface(Obj=lnk: ILink2) => SetSys + AddPoint... + SaveAs
  ILink2 = interface(IUnknown)
    ['{147182FD-27F7-4592-B202-86FEF081D480}']

    function Open(Path: PChar): Integer; stdcall;
    procedure SaveAs(Path: PChar); stdcall;

    function GetCount: Integer; stdcall;

    function ImageWidth: Integer; stdcall;
    function ImageHeight: Integer; stdcall;

    procedure GetSys(out sys: tsys); stdcall;
    procedure SetSys(sys: psys); stdcall;

    procedure GetPoint(Ind: Integer; out a,b: TGauss); stdcall;
    procedure SetPoint(Ind: Integer; a,b: PGauss); stdcall;

    //в любом порядке:
    procedure AddPoint(a,b: PGauss); stdcall;//a - в BMP, b - в проекции sys

    procedure l_to_g(ix,iy: Double; out ox,oy: Double); stdcall;
    function l_to_r(ix,iy: Double; out ox,oy: Double): Integer; stdcall;

    procedure g_to_l(ix,iy: Double; out ox,oy: Double); stdcall;
    procedure r_to_l(ix,iy: Double; pps: Integer; out ox,oy: Double); stdcall;

    function Containsg(x,y: double): Boolean; stdcall;
  end;

function DllGetInterface(const CLSID,IID: TGUID; var Obj): HResult; stdcall;
external 'dll_lnk.dll';


function DllGetInterface_msg(var lnk: ILink2): boolean;
begin
  Result := DllGetInterface(ILink2,ILink2,lnk)=S_OK;
  if not Result then Tell('FAIL in _lnk.DllGetInterface');
end;


///////////////////////////////////////////////////////////////////////


function lnk_make_file(sys: psys; WH: TPoint; g1,g2,g3,g4: PGauss; path: PChar): boolean;
var
  lnk: ILink2;
  pix1,pix2,pix3,pix4: TGauss;
begin
  Result := DllGetInterface_msg(lnk);
  if Result then begin
    lnk.SetSys(sys);

    pix1.x:=0; pix1.y:=0;       lnk.AddPoint(@pix1,g1);
    pix2.x:=WH.X; pix2.y:=0;    lnk.AddPoint(@pix2,g2);
    pix3.x:=WH.X; pix3.y:=WH.Y; lnk.AddPoint(@pix3,g3);
    pix4.x:=0; pix4.y:=WH.Y;    lnk.AddPoint(@pix4,g4);

    lnk.SaveAs(path);
  end;

  lnk:=nil;//!?
  if not FileExists(path) then begin
    Tellf('Файл "%s" НЕ СОЗДАН',[path]);
    Result:=FALSE;
  end;
end;

function lnk_make_file2(pix_a,pix_b,map_a,map_b: TPoint; dmpath,lnkpath: string): boolean;
var
  lnk: ILink2;
  dmsys: tsys;
  p,ga,gb,g: TGauss;
begin
  dmw_HideMap;//!!!

  Result := (dm_open(PChar(dmpath), false{edit})>0);
  if Result then
  try
    dm_Get_sys7(dmsys);
    dm_L_to_G(map_a.X,map_a.Y, ga.x,ga.y);
    dm_L_to_G(map_b.X,map_b.Y, gb.x,gb.y);
  finally
    dmw_Done;
  end;

  Result := Result and DllGetInterface_msg(lnk);

  if Result then begin
    lnk.SetSys(@dmsys);

    //GAUSS: X-toUP, Y-toRIGHT
    //1:
    p.x:=pix_a.X; p.y:=pix_a.Y;
    g:=ga; lnk.AddPoint(@p,@g);
    //2:
    p.x:=pix_b.X; p.y:=pix_a.Y;
    g.x:=ga.X; g.y:=gb.Y; lnk.AddPoint(@p,@g);
    //3:
    p.x:=pix_b.X; p.y:=pix_b.Y;
    g:=gb; lnk.AddPoint(@p,@g);
    //4:
    p.x:=pix_a.X; p.y:=pix_b.Y;
    g.x:=gb.X; g.y:=ga.Y; lnk.AddPoint(@p,@g);

    lnk.SaveAs(PChar(lnkpath));
  end;

  //без этого @@@-файл может отсутствовать:
  lnk:=nil;
  if not FileExists(lnkpath) then begin
    Tellf('Файл "%s" НЕ СОЗДАН',[lnkpath]);
    Result:=FALSE;
  end;
end;

function lnk_make_file2(WH,map_a,map_b: TPoint; dmpath,lnkpath: string): boolean;
var pix_a: TPoint;
begin
  pix_a:=Point(0,0);//Point - Classes
  Result := lnk_make_file2(pix_a,WH,map_a,map_b, dmpath,lnkpath);
end;

end.
