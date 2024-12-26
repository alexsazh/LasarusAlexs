//
// .ps + пар-ры привязки --> [набор] .tif + .@@@
// Вариант - PNG вместо TIF
//
unit _webtif; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, nums, StdCtrls, CheckLst, Buttons, ExtCtrls;

//mpp0 - метров в пикселе на уровне 0
//mpp1 = mpp0/2, mpp2 = mpp1/2 и т.д.
//mpp0 = 40075016.685578488(экватор,м)/256пикс
const web_level0_mpp = 156543.033928;
const web_maxlevel = 22;

type
  TWebTif1 = class(TForm)
    List1: TCheckListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtnOk: TBitBtn;
    Memo1: TMemo;
    Splitter1: TSplitter;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //levelsdpi.count = web_maxlevel+1 (0..web_maxlevel):
    levelsdpi: tinta;//зависит от масштаба (mapscale_to_levelsdpi)
    procedure mapscale_to_levelsdpi(mapscale: integer);//fill levelsdpi
    procedure levelsdpi_to_List(pagew,pageh{мм}: double);//fill List1
  public
    //.ps -> .tif + .@@@ (Compression=lzw):
    //tifpath m.b. =''(!)
    function ps_to_tif(_png: boolean; pspath,tifpath: string; dpi: integer;
                       map_a,map_b: TPoint; pagew,pageh{мм}: double;
                       _wait: boolean): boolean;

    //.ps -> НАБОР .tif + НАБОР .@@@ (Compression=lzw):
    function ps_to_tifs(_png: boolean; pspath: string; mapscale: integer;
                       map_a,map_b: TPoint; pagew,pageh{мм}: double;
                       _wait: boolean): boolean;
  end;

var
  WebTif1: TWebTif1;


implementation

{$R *.dfm}

uses wcmn, wait, _lnk, gsopt{exec_gs2};


/////////////////////////////////////////////////////////////////

procedure TWebTif1.FormCreate(Sender: TObject);
begin
  levelsdpi:=tinta.New;
  Ini.RForm(Self);
end;

procedure TWebTif1.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);
  levelsdpi.Free;
end;

/////////////////////////////////////////////////////////////////

// Поиск dpi путем округления/изменения mapscale (Mpi):
// Mpi -м местн-ти в инче(дюйме)
// Mpp - м местн-ти в пикселе на уровне 0 (web_level0_mpp)
//Mpi/dpi=Mpp - м местн-ти в пикселе => dpi=Mpi/Mpp:
(*
function _find_dpi(var mapscale,Mpp: double): integer;
var imapscale: integer; Mpi,rdpi: double;
begin
  Mpi := wcmn_mmpi{25.4}*mapscale/1000.;//м местн-ти в инче(дюйме)
  rdpi := Mpi/Mpp;
  imapscale := Round( (Mpp*rdpi*1000)/wcmn_mmpi{25.4} );//округление mapscale




  Mpi := Mpp*rdpi;

  mapscale := wcmn_mmpi{25.4}*1000.;

end;
*)

procedure TWebTif1.mapscale_to_levelsdpi(mapscale: integer);
var
  i,dpi: integer;
  Mpi,Mpp: double;
begin
  levelsdpi.Clear;

  Mpi := wcmn_mmpi{25.4}*mapscale/1000.;//м местн-ти в инче(дюйме)
  //i>=0 - номер уровня
  Mpp:=web_level0_mpp;//уровень 0

  for i:=0 to web_maxlevel do begin

    dpi := Round( Mpi/Mpp );

    levelsdpi.Add(dpi);
    Mpp := Mpp/2;//NEXT LEVEL
  end;//for i
end;

procedure TWebTif1.levelsdpi_to_List(pagew,pageh{мм}: double);
var i,dpi: integer; s: string; WH{pix}: TPoint;
begin
  List1.Items.Clear;

  for i:=0 to web_maxlevel{count-1} do begin
    dpi:=levelsdpi[i];

    WH.X := Round( (pagew/wcmn_mmpi){дюймы}*dpi );
    WH.Y := Round( (pageh/wcmn_mmpi){дюймы}*dpi );

    s := Format('%02d:  dpi=%d (%d*%d)',[i,dpi,WH.X,WH.Y]);
    List1.Items.Add(s);
    if (dpi>100) and (dpi<2000) then List1.Checked[List1.Items.Count-1]:=true;//DEF ?
  end;//for i
end;

/////////////////////////////////////////////////////////////////
// Include Dirs and ms.x для вызова Gswin in ps_to_tif:
/////////////////////////////////////////////////////////////////

function _web_GsIncludeDirs: string;
var libdir,msdir: string;
begin
  Result:='';

  libdir:=wcmn_file_dir0(GsOptDlg.LibLabel.Caption);
  if libdir<>'' then Result:=libdir+';';

  msdir:=UpperDir(libdir); {with '\'}
  if msdir<>'' then begin
    if DirExists(msdir+'FONTS') then Result:=Result+msdir+'FONTS'+';';
    //if DirExists(msdir+'INCLUDE') then Result:=Result+msdir+'INCLUDE'+';';
  end;
  if Length(Result)>0 then SetLength(Result,Length(Result)-1);//обрезание ';' в конце
end;

function _web_mng_file_path(pspath: string): string;
var outpath: string; f: system.text;
begin
  Result:='';//default
  outpath:=TmpDir+'tmp_msx.tmp';//--- Управляющий файл для GS

  if ftopen_msg(f, outpath, 'w') then
  try
    writeln(f,'(def.psl) runlibfile');
    writeln(f,'(',ps_string(pspath),') epsview0');
    writeln(f,'showpage');//Иначе НИЧЕГО НЕ БУДЕТ!
    writeln(f,'quit');

    Result:=outpath;
  finally
    ftclose(f);
  end;
end;

/////////////////////////////////////////////////////////////////


function TWebTif1.ps_to_tif(_png: boolean; pspath,tifpath: string; dpi: integer;
                            map_a,map_b: TPoint; pagew,pageh{мм}: double;
                            _wait: boolean): boolean;
var s,lnkpath,mngpath: string; WH{pix}: TPoint;
begin
  if tifpath='' then begin
    if _png
    then tifpath:=wcmn_file_dirname(pspath)+'.png'
    else tifpath:=wcmn_file_dirname(pspath)+'.tif';
  end;

  lnkpath:=wcmn_file_dirname(tifpath{!})+'.@@@';
  mngpath:=_web_mng_file_path(pspath);//TmpDir+'tmp_msx.tmp'
  Result := mngpath<>'';

  //tif:
  if Result then
  try
    if _wait then wait_show( Format('%s',[tifpath]) );

    if _png
    then
      s:=Format('-dNOPAUSE -sDEVICE=pngalpha -r%d -sOutputFile=%s %s',
             [dpi,tifpath,mngpath])
    else
      s:=Format('-dNOPAUSE -sDEVICE=tiff24nc -sCompression=lzw -r%d -sOutputFile=%s %s',
             [dpi,tifpath,mngpath]);

    exec_gs2(GsOptDlg.GsLabel.Caption,_web_GsIncludeDirs,s,true{ожидание});

  finally
    if _wait then wait_hide;
  end;

  //@@@:
  WH.X := Round( (pagew/wcmn_mmpi){дюймы}*dpi );
  WH.Y := Round( (pageh/wcmn_mmpi){дюймы}*dpi );
  Result := Result and lnk_make_file2(WH, map_a,map_b, lnkpath);
end;

/////////////////////////////////////////////////////////////////


function TWebTif1.ps_to_tifs(_png: boolean; pspath: string; mapscale: integer;
                             map_a,map_b: TPoint; pagew,pageh{мм}: double;
                             _wait: boolean): boolean;
var i,ii,n: integer; tifpath: string;
begin
  mapscale_to_levelsdpi(mapscale);
  levelsdpi_to_List(pagew,pageh);

  Caption := pspath;
  Memo1.Lines.Clear;
  Memo1.Lines.Add(Format('%d масштаб',[mapscale]));

  Result := ShowModal=mrOk;
  if not Result then EXIT;//!

  //After ShowModal:

  //n - "кол-во галочек":
  n:=0;
  if List1.Count>0
  then for i:=0 to List1.Count-1 do if List1.Checked[i] then inc(n);

  try
    ii:=0;
    if n>0
    then for i:=0 to List1.Count-1 do begin//i=уровень
      if not List1.Checked[i] then CONTINUE;//!

      inc(ii);
      if _png
      then tifpath := Format('%s_%d.png', [wcmn_file_dirname(pspath),i])//i=уровень
      else tifpath := Format('%s_%d.tif', [wcmn_file_dirname(pspath),i]);

      if _wait then wait_show( Format('%d/%d:  %s',[ii,n, wcmn_file_nameext(tifpath)]) );
      ps_to_tif(_png, pspath,tifpath, levelsdpi[i], map_a,map_b, pagew,pageh, FALSE{_wait});

    end;//for i
  finally
    if _wait then wait_hide;
  end;
end;

/////////////////////////////////////////////////////////////////


end.
