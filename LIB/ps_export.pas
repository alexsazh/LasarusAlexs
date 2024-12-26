unit ps_export; interface

uses Windows, Forms, SysUtils, shellapi{with AnsiChar!!!};


function ps_exp_tif
  (
    gs_path: string;
    ms_libdir: string;//WITH '\'
    ps_path, tif_path: string;
    dpi: double;
    _msg: boolean
  ): boolean;//ps->tif

function ps_exp_tiflnk
  (
    dm_path: string;
    lnk_path: string;
    w,h{mm}: double;
    dpi: double;
    a,b: TPoint;
    _msg: boolean
  ): boolean;


function ps_exp_pdf
  (
    gs_path: string;
    ms_libdir: string;//WITH '\'
    ps_path, pdf_path: string;
    _msg: boolean
  ): boolean;//ps->pdf


implementation

uses wcmn, wait, lnk, gslib, dmlib2;


//Óïðàâëÿþùèé ôàéë äëÿ GS:
//inpath: ps-file:
function __create_mng_file(inpath: string; _showpage: boolean; var mng_path: string): boolean;
const tmp_mng_path_name = 'tmp2112_mng.tmp';
label ___retry;
var f: system.text;
begin
  Result:=FALSE;//!
  mng_path:=TmpDir+tmp_mng_path_name;
___retry:
  if ftopen_msg(f, mng_path, 'w') then
  try
    writeln(f,'(def.psl) runlibfile');//epsview0
    writeln(f,'(',ps_string(inpath),') epsview0');
    if _showpage then
      writeln(f,'showpage');//Äëÿ TIF ÍÅÎÁÕÎÄÈÌÎ!
    writeln(f,'quit');
    Result:=TRUE;//!
  finally
    ftclose(f);
  end
  else begin
    if TellfYN('ps_export: Ôàéë "%s" çàíÿò. Ïîâòîðèòü?',[mng_path])
    then goto ___retry;
  end;
end;


function ps_exp_tif
  (
    gs_path: string;
    ms_libdir: string;//WITH '\'
    ps_path, tif_path: string;
    dpi: double;
    _msg: boolean
  ): boolean;//ps->tif
var mng_path,s: string;
begin
  Result := FALSE;//dwfault
  if not __create_mng_file(ps_path, true{_showpage}, mng_path) then EXIT;//!
  try
    wait_show( wcmn_file_nameext(tif_path) );
    s:=Format('-dNOPAUSE -sDEVICE=tiff24nc -sCompression=lzw -r%f -sOutputFile=%s ',
               [dpi,tif_path]);
    Result := gsl_exec_gs2(gs_path, ms_libdir, s+mng_path, true{use_run});
    if not Result and _msg then Tellf('ERROR in create "%s"',[tif_path]);
  finally
    wait_hide;
  end;
end;

function ps_exp_tiflnk
  (
    dm_path: string;
    lnk_path: string;
    w,h{mm}: double;
    dpi: double;
    a,b: TPoint;
    _msg: boolean
  ): boolean;
begin//ps->@@@
  Result := lnk_make_from_Dm(w,h{mm}, dpi, dm_path, a,b, lnk_path);
  if not Result and _msg then Tellf('ERROR in create "%s"',[lnk_path]);
end;


function ps_exp_pdf
  (
    gs_path: string;
    ms_libdir: string;//WITH '\'
    ps_path, pdf_path: string;
    _msg: boolean
  ): boolean;//ps->pdf
var mng_path,s: string;
begin
  Result := FALSE;//dwfault
  if not __create_mng_file(ps_path, false{_showpage}, mng_path) then EXIT;//!
  try
    wait_show( wcmn_file_nameext(pdf_path) );
    s:=Format('-dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=%s ', [pdf_path]);
    Result := gsl_exec_gs2(gs_path, ms_libdir, s+mng_path, true{use_run});
    if not Result and _msg then Tellf('ERROR in create "%s"',[pdf_path]);
  finally
    wait_hide;
  end;
  ShellExecute(Application.Handle, 'open', PChar(pdf_path), nil, nil, SW_SHOWNORMAL);//shellapi{with AnsiChar!!!}
end;



end.
