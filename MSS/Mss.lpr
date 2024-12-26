program Mss;

{$MODE Delphi}

uses
  Forms, Interfaces,
  SysUtils,
  MSW_1 in 'MSW_1.PAS' {FormMain},
  MSW_PRN in 'MSW_PRN.PAS' {FormPrnCnv},
  MSW_COL in 'MSW_COL.PAS' {ColSepDlg},
  msw_ps in 'msw_ps.pas' {PrintDlg},
  Msw_msx in 'Msw_msx.pas',
  msw_x in 'msw_x.pas',
  Mscmn in '..\LIB\Mscmn.pas',
  eps in '..\LIB\eps.pas' {Form1},
  Dmw_use in '..\utils\Dmw_use.pas',
  Otypes in '..\utils\Otypes.pas',
  GsOpt in '..\LIB\GsOpt.pas' {GsOptDlg},
  color in '..\LIB\color.pas' {ColorDlg},
  runx in '..\LIB\runx.pas',
  MSGX in '..\LIB\MSGX.PAS' {MsgForm},
  cmdfile in 'cmdfile.pas',
  dmcmn in '..\LIB\dmcmn.pas',
  Arrayx in '..\LIB\Arrayx.pas',
  colset in 'colset.pas' {ColSetForm},
  Wcmn in '..\LIB\Wcmn.pas',
  Vlib in '..\LIB\Vlib.pas',
  nums in '..\LIB\nums.pas',
  Dmlib in '..\LIB\Dmlib.pas',
  llib in '..\LIB\llib.pas',
  List in '..\LIB\List.pas',
  llibx in '..\LIB\llibx.pas',
  Curve in '..\LIB\Curve.pas',
  ABOUT in 'ABOUT.PAS' {AboutForm},
  msw_xm in 'msw_xm.pas' {FormXM},
  Runline in '..\LIB\Runline.pas' {RunForm},
  dm_util in '..\LIB\dm_util.pas',
  matx in '..\LIB\matx.pas',
  cmn in 'cmn.pas',
  mapprntest in 'mapprntest.pas',
  help in 'help.pas',
  Dmw_ddw in '..\utils\Dmw_ddw.pas',
  dmw_wm in '..\utils\dmw_wm.pas',
  _lnk in '..\LIB\_lnk.pas',
  d3_use in '..\utils\d3_use.pas',
  _webtif in '..\LIB\_webtif.pas' {WebTif1},
  wait in '..\LIB\wait.pas' {FormWait},
  dmdist0 in '..\LIB\dmdist0.pas',
  vlib3d in '..\LIB\vlib3d.pas',
  _webmaps in '..\LIB\_webmaps.pas' {_webmaps1},
  _webmap in '..\LIB\_webmap.pas',
  _webcmn in '..\LIB\_webcmn.pas',
  Dmwlib in '..\LIB\Dmwlib.pas',
  check_dm_xy in '..\LIB\check_dm_xy.pas',
  msw_ps_export in 'msw_ps_export.pas' {Form_export},
  MSS_WM in 'MSS_WM.pas' {FormWm};

{$R *.res}

begin
(*
  Application.Title := 'MSS (MapScriptSystem)';
  Application.HelpFile := SysUtils.ChangeFileExt(Application.ExeName, '.hlp');

  //"/t" или "/l" или файл english.ver || english_mss.ver => ENGLISH:
  if wcmn_language_test('')//=> wcmn_language_file_name<>'' - КРИТЕРИЙ ДЛЯ ДР ПРОГРАММ
  then
  begin//перед секцией Application.CreateForm
    wcmn_language_telllist(nil);//LIB\wcmn.pas
    wcmn_language_telllist(msgs{cmn.pas});
  end;
*)
  Application.Initialize;

  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormPrnCnv, FormPrnCnv);
  Application.CreateForm(TColSepDlg, ColSepDlg);
  Application.CreateForm(TPrintDlg, PrintDlg);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TGsOptDlg, GsOptDlg);
  Application.CreateForm(TColorDlg, ColorDlg);
  Application.CreateForm(TMsgForm, MsgForm);
  Application.CreateForm(TColSetForm, ColSetForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TFormXM, FormXM);
  Application.CreateForm(TRunForm, RunForm);
  Application.CreateForm(TFormWm, FormWm);
  Application.CreateForm(TWebTif1, WebTif1);
  Application.CreateForm(TFormWait, FormWait);
  Application.CreateForm(T_webmaps1, _webmaps1);
  Application.CreateForm(TForm_export, Form_export);

  dll_app_handle(FormMain.Handle);

  GsOptDlg.Init;//после language_test

  Application.Run;

end.
