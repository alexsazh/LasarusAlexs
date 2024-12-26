unit msw_ps_export;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons;

type

  { TForm_export }

  TForm_export = class(TForm)
    TiffRes: TSpinEdit;
    Label_TiffRes: TLabel;
    BitBtn_Ok: TBitBtn;
    procedure BitBtn_OkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure export_pdf(ps: string);
    procedure export_tif(ps: string);
  end;

var
  Form_export: TForm_export;


implementation

{$R *.lfm}

uses Wcmn, wait, GsOpt, MSCMN, msw_x;


procedure TForm_export.export_pdf(ps: string);
var
  mngpath,outpath,s, gslib, sOut: string;
  f: system.text;
begin
  sOut:= wcmn_UTF2System(ps);
  mngpath:=TmpDir+tmp_ms_file_name;//--- Управляющий файл для GS
  if ftopen_msg(f, mngpath, 'w') then
  try
    writeln(f,'(def.psl) runlibfile');//epsview0
    writeln(f,'(',ps_string(sOut),') epsview0');
    writeln(f,'showpage');//Иначе НИЧЕГО НЕ БУДЕТ!
    writeln(f,'quit');
  finally
    ftclose(f);
  end
  else EXIT;//!

  outpath:=wcmn_file_dirname(sOut)+'.pdf';
  try
     wait_show( ChangeFileExt(wcmn_file_nameext(ps),'.pdf' ));

    gslib:= wcmn_UTF2System(GsOptDlg.GsLabel.Caption);
    s:=Format('-dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=%s ', [outpath]);
    exec_gs2(gslib,msw_GsIncludeDirs(false,false),s+mngpath,true);
  finally
    wait_hide;
  end;

  OpenDocument(PChar(outpath)); { *Преобразовано из ShellExecute* }
end;


procedure TForm_export.export_tif(ps: string);
var
  mngpath,outpath,s, gslib, sOut: string;
  f: system.text;
begin
  sOut:= wcmn_UTF2System(ps);
  Caption:='export tif';
  if not (ShowModal=mrOK) then EXIT;//!

  mngpath:=TmpDir+tmp_ms_file_name;//--- Управляющий файл для GS
  if ftopen_msg(f, mngpath, 'w') then
  try
    writeln(f,'(def.psl) runlibfile');//epsview0
    writeln(f,'(',ps_string(sOut),') epsview0');
    writeln(f,'showpage');//Иначе НИЧЕГО НЕ БУДЕТ!
    writeln(f,'quit');
  finally
    ftclose(f);
  end
  else EXIT;//!

  outpath:=wcmn_file_dirname(sOut)+'.tif';
  try
    wait_show( ChangeFileExt(wcmn_file_nameext(ps),'.tif' ));

    s:=Format('-dNOPAUSE -sDEVICE=tiff24nc -sCompression=lzw -r%d -sOutputFile=%s ',
               [TiffRes.Value,outpath]);
    gslib:= wcmn_UTF2System(GsOptDlg.GsLabel.Caption);

    exec_gs2(gslib,msw_GsIncludeDirs(false,false),s+mngpath,true);

  finally
    wait_hide;
  end;
end;


{ EVENTS: }

procedure TForm_export.FormCreate(Sender: TObject);
begin
  Ini.RForm(Self);
end;

procedure TForm_export.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);
end;

procedure TForm_export.BitBtn_OkClick(Sender: TObject);
begin

end;


end.
