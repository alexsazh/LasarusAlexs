//
// record "abc"
// построение файла ms.x
// построение строки вызова GS
//
unit Msw_msx;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, SysUtils,Forms,Dialogs, Types;


function MsFileShortName: string;//TmpDir+'$'

procedure MakeGsCmd(var cmd_gs: string; psl: boolean);

procedure MakeMsx(ms_x_name: string; var pic_width: real; prolog,epilog: boolean; ms_msg: string);//pic_width - for GCX


var
  abc: record

  //меняются в msw_xm.pas (MultiCall):
    gc_names: string;//список через ";"
    gcx_name: string;//первый "НЕ GC" в списке на форме

  {Из бланка страницы: in msw_FindPage:}
    rightpage: word; {byte(!) 406: 0=left; 1=right}
  {Общие:}
    pageOk: boolean;

    fai,aiext: string;
    textascurves: boolean;
    mode: byte;  {0-view; 1-print; 2-convert}
    prn,cnv,wprn: boolean;
    colsep : boolean;
  {Страница карты:}
    pn: word;
    pagemap: string;
    pcode: longint;
    cut_m: real;
    pageeps: string;
  {Участок карты:}
    zoom: real;
  {Параметры:}
    mark, markofs, mir, negativ : boolean;
    rot: integer;//1-90,2-180
    lpi: word;
    angle: real;
    pnum, pnup: boolean;
    px0, py0, pw, ph: real;//mm
  {Print/Convert:}
    prndev, cnvdev: string[80];
    prnres, cnvres: word;
    tofile: boolean;
    fname: string;
  {ColorSeparation:}
    cmodel: byte;
  end;


{---------------------------------}
implementation
{---------------------------------}

uses Wcmn, cmn, Dmwlib, cmdfile, MSW_COL, MSW_1, msw_xm, _lnk, MSW_PRN;


function MsFileShortName: string;//TmpDir+'$'
begin
  Result:=TmpDir+'$';
end;


procedure MakeGsCmd(var cmd_gs: string; psl: boolean);
var r: word; sdev,lnk_path: string; WH: TPoint;
begin
     cmd_gs := '';//default
     r:=720;//default

     if abc.prn or abc.cnv then begin
       if abc.prn then begin r:=abc.prnres; sdev:=abc.prndev; end;
       if abc.cnv then begin r:=abc.cnvres; sdev:=abc.cnvdev; end;

       //"tiff for WEB" - добавление привязки растра .@@@:
       if abc.cnv
       and ( (pos('tif',sdev)=1) or (pos('png',sdev)=1) )
       and abc.tofile
       then begin

         lnk_path:=wcmn_file_dirname(FormPrnCnv.OutputFile.Text)+'.@@@';
         WH.X := Round( (abc.pw/wcmn_mmpi){дюймы}*r{dpi} );
         WH.Y := Round( (abc.ph/wcmn_mmpi){дюймы}*r{dpi} );
         if not lnk_make_file2(WH, cmn_a,cmn_b, DMW.ActiveMap,lnk_path)
         then Tell('msw_msx.MakeGsCmd: lnk_make_file2=FALSE');
         cmd_gs:=cmd_gs+Format('-sNOPAUSE -sDEVICE=%s -r%d ',[sdev,r]);

       end
       else cmd_gs:=cmd_gs+Format('-sNOPAUSE -sDEVICE=%s -r%d ',[sdev,r]);//default

     end;//if abc.prn or abc.cnv

     if abc.wprn then begin
       cmd_gs:=cmd_gs+'-sNOPAUSE -sDEVICE=mswinpr2 ';
     end;

     if psl then cmd_gs:=cmd_gs+'@psl.ini ';{!}

     cmd_gs:=cmd_gs+Format('%s ',[TmpDir+'ms.x']);
end;
{-----------------------------------------------------}


procedure _ms_page_params(var f_ms: text; var pic_width: real);//pic_width - for GCX
var
  k,x0,y0,w,h,pw,ph:real;
  pagezoom: double;
begin
     x0:=abc.px0; y0:=abc.py0;
     w:=abc.pw;   h:=abc.ph;

     pw := x0*2+w; ph := y0*2+h;

     writeln(f_ms,'/Paper [',pw:7:2,' mm ',ph:7:2,' mm ',abc.rot,'] def');

     pagezoom:=abs( rvaldef(FormMain.EditPageZoom.Text,1) );

     try
       if abc.pageOk then k:=1/pagezoom else k:=1/abc.zoom ;
     except k:=1;
     end;
     x0:=k*abc.px0;
     y0:=k*abc.py0;
     w:= k*abc.pw;
     //h:= k*abc.ph;

     if abc.pageOk then begin
        if abc.rightpage=0 then begin
          if (abc.cut_m>x0) then abc.cut_m:=x0;
          x0:=x0-abc.cut_m;
        end;
        if (abc.cut_m>y0) then abc.cut_m:=y0;
        y0:=y0-abc.cut_m;
        w:=w+abc.cut_m;
     end;
     writeln(f_ms,x0:7:2,' mm',y0:7:2,' mm pcorner');
     writeln(f_ms,w:7:2,' mm pwidth');

     if abc.pageOk then begin
       writeln(f_ms,'/Scale ',pagezoom:7:2,' def');
     end else begin
       writeln(f_ms,'/Scale ',abc.zoom:7:2,' def'); { <- scale=1 if PageOk }
     end;

     pic_width:=w; //!!!
end;

procedure MakeMsx(ms_x_name: string; var pic_width: real; prolog,epilog: boolean; ms_msg: string);//pic_width - for GCX
var
  msmode: word; {0: 1 color; 1: all colors}
  colorn: word; {>=0; 0=Composite}
  r: word;
  outfile,pageeps,spn: string[80]; sdev: string;
  f_ms_x: text; //file 'ms.x'
  s_date: string;

  procedure _WriteColorNames;
  var i: integer; s,s_names,s_exts: string;
  begin
    s_names := '/msxInkNamesCMYK [(Composite) ';
    s_exts := '/msxAiExtensions0 [() ';
    for i:=0 to CMYKChecked.Count-1 do begin
      s:=CMYKChecked[i];
      s_names:=s_names+Format('(%s) ',[sread_word(s)]);
      s_exts:=s_exts+Format('(%s) ',[sread_word(s)]);
    end;
    writeln(f_ms_x,s_names+'];');
    writeln(f_ms_x,s_exts+'];');

    s_names := '/msxInkNamesRGB [(Composite) ';
    s_exts := '/msxAiExtensions1 [() ';
    for i:=0 to RGBChecked.Count-1 do begin
      s:=RGBChecked[i];
      s_names:=s_names+Format('(%s) ',[sread_word(s)]);
      s_exts:=s_exts+Format('(%s) ',[sread_word(s)]);
    end;
    writeln(f_ms_x,s_names+'];');
    writeln(f_ms_x,s_exts+'];');
  end;

begin
  if not ftopen_msg(f_ms_x, ms_x_name, 'w') then exit;

     s_date := FormatDateTime('dd/mm hh:nn', SysUtils.Now);
     writeln(f_ms_x,'/DateTime ([',s_date,']-) def');

     //управление мультивызовом:
     writeln(f_ms_x,'');
     writeln(f_ms_x,'/OutFile.WriteProlog ',bools(prolog),' def');
     writeln(f_ms_x,'/OutFile.WriteEpilog ',bools(epilog),' def');
     writeln(f_ms_x,'/OutFile.Message (',ms_msg,') def');

     msmode:=0; {0: 1 color; 1: all colors}
     colorn:=0; {>=0; 0=Composite}

     if abc.colsep then begin
        if abc.cmodel=0 then begin //CMYK:
           if CMYKChecked.Count=1 then colorn:=1;
           if CMYKChecked.Count>1 then msmode:=1;
        end else begin //RGB:
           if RGBChecked.Count=1 then colorn:=1;
           if RGBChecked.Count>1 then msmode:=1;
        end;
     end;

     r:=720;
     if abc.prn or abc.cnv then begin
             if abc.prn then sdev:=abc.prndev;
             if abc.cnv then sdev:=abc.cnvdev;
             writeln(f_ms_x,'/Device (',sdev,') def');

             if abc.cnv then r:=abc.cnvres;
             if abc.prn then r:=abc.prnres;
             writeln(f_ms_x,'/Resolution ',r,' def');

             if abc.tofile or abc.cnv then begin
                outfile := abc.fname;
                if (outfile='') then begin
                   outfile := TmpDir+'outfile';
                   Tell('OutputFile='+outfile);
                end;
                writeln(f_ms_x,'/OutputFile (',outfile,') def');
             end;
     end; {abc.print}
     writeln(f_ms_x,'');

     _ms_page_params(f_ms_x, pic_width); {/Paper, pwidth, pheight, /Scale}

     writeln(f_ms_x,'/Screen [',abc.lpi,' ',abc.angle:7:2,'] def');
     writeln(f_ms_x,'');

     writeln(f_ms_x,'/XobFileList (',ps_string(wcmn_UTF2System(abc.gc_names)),') def');
     writeln(f_ms_x,'(',wcmn_UTF2System(abc.fai),') setaifile');
     writeln(f_ms_x,'/AiExt (',abc.aiext,') def');
     writeln(f_ms_x,'/AiTextAsCurves ', abc.textascurves, ' def');
     writeln(f_ms_x,'/DashAsLine ', false, ' def');
     writeln(f_ms_x,'/EpilogAddShowPage ', FormMain.CheckShowPage.checked, ' def');
     writeln(f_ms_x,'');

     _WriteColorNames;
     writeln(f_ms_x,'');

     writeln(f_ms_x,'/MsMode ',msmode,' def');
     if abc.colsep then begin
       writeln(f_ms_x,'/ColorModel ',bool_names[(abc.cmodel+1) mod 2],' def');
     end else begin
       writeln(f_ms_x,'/ColorModel ','TRUE',' def');
     end;

     writeln(f_ms_x,'/ColSepMode ',colorn,' def');
     writeln(f_ms_x,'');

     writeln(f_ms_x,'/Negativ ',abc.negativ,' def');
     writeln(f_ms_x,'/Mirror ',abc.mir,' def');
     writeln(f_ms_x,'/TP_Mark ',abc.mark,' def');
     writeln(f_ms_x,'/TP_MarkOfs ',abc.markofs,' def');
     writeln(f_ms_x,'/TP_N_Print ',abc.pnum,' def');
     writeln(f_ms_x,'/TP_N ',abc.pn:5,' def');
     writeln(f_ms_x,'/TP_N_Up ',abc.pnup,' def');
     writeln(f_ms_x,'/RightPage ',abc.rightpage,' def');
     writeln(f_ms_x,'');

  if abc.pageOk then begin

     pageeps := abc.pageeps;
     if (pageeps<>'') then begin
        str(abc.pn,spn);
        pageeps := pageeps + spn + '.eps';
        writeln(f_ms_x,'/PageEps (',pageeps,') def');
     end;
     writeln(f_ms_x,'/CutMargins ',abc.cut_m:7:2,' mm def');

  end; {page0.Ok}

  //Без <Press ENTER>:
  if ExecuteCmdFile //часть пакета
//  or not epilog //не последняя "вставка"
  or (FormXm.Count>0) //есть "вставки"
  or cmn_Tiffs_for_Web//30.08.2012
  then writeln(f_ms_x,'/NoConfirm true def');

  //окончание:
     writeln(f_ms_x,'');
     writeln(f_ms_x,'MAIN');
     writeln(f_ms_x,'');

  closefile(f_ms_x);
end;    


{---------------------------------}
begin

  with abc do begin
    pageOk := false;
  end;

end.
