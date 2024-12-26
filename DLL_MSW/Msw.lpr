library Msw;

{$MODE Delphi}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Classes, Forms, Interfaces,
  vlib in '..\LIB\vlib.pas',
  Wcmn in '..\LIB\Wcmn.pas',
  Arrayx in '..\LIB\Arrayx.pas',
  llib in '..\LIB\llib.pas',
  nums in '..\LIB\nums.pas',
  main in 'main.pas',
  Msfile in 'Msfile.pas',
  List in '..\LIB\List.pas',
  Filex in '..\LIB\Filex.pas',
  Progress in '..\LIB\Progress.pas' {ProgressForm},
  Pslib in '..\PSLIB\Pslib.pas',
  Psx in '..\PSLIB\Psx.pas',
  Psobjx in '..\PSLIB\Psobjx.pas',
  Pslogs in '..\PSLIB\Pslogs.pas',
  Psstacks in '..\PSLIB\Psstacks.pas',
  Psvms in '..\PSLIB\Psvms.pas',
  Psnames in '..\PSLIB\Psnames.pas',
  Psscan in '..\PSLIB\Psscan.pas',
  Psobj in '..\PSLIB\Psobj.pas',
  Pso in '..\PSLIB\Pso.pas',
  Psdicts in '..\PSLIB\Psdicts.pas',
  Psarrays in '..\PSLIB\Psarrays.pas',
  Psmat in '..\PSLIB\Psmat.pas',
  Psfiles in '..\PSLIB\Psfiles.pas',
  Psgstate in '..\PSLIB\Psgstate.pas',
  Pspath in '..\PSLIB\Pspath.pas',
  Pscmn in '..\PSLIB\Pscmn.pas',
  Color in '..\LIB\Color.pas' {ColorDlg},
  gcx in 'gcx.pas',
  flib in '..\LIB\flib.pas',
  hline in 'hline.pas',
  sun in 'sun.pas',
  hl_dp in 'hl_dp.pas',
  dline in 'dline.pas',
  kri_dp in 'kri_dp.pas',
  dll_kri in '..\LIB\dll_kri.pas',
  krivizna in '..\LIB\krivizna.pas',
  runline2 in 'runline2.pas' {RunForm},
  steps in 'steps.pas',
  CMN in 'CMN.PAS',
  l2 in 'l2.pas',
  formsx in 'formsx.pas',
  roads in 'roads.pas',
  llibx in '..\LIB\llibx.pas',
  volna in 'volna.pas',
  curve in '..\LIB\curve.pas',
  gradfill in 'gradfill.pas',
  chara in 'chara.pas',
  mosaic in 'mosaic.pas',
  matx in '..\LIB\matx.pas',
  dmw_use in '..\utils\dmw_use.pas',
  OTypes in '..\utils\OTypes.pas',
  Dmlib in '..\LIB\Dmlib.pas',
  dm_util in '..\LIB\dm_util.pas',
  Dmw_ddw in '..\utils\Dmw_ddw.pas',
  dmlib0 in '..\LIB\dmlib0.pas',
  add2dm in 'add2dm.pas',
  dm_expo in 'dm_expo.pas',
  dm_expo_dlgs in 'dm_expo_dlgs.pas' {dm_expo_dlgs1},
  check_dm_xy in '..\LIB\check_dm_xy.pas';

exports
  mscnv_exec,
  mscnv_exec2,
  dm_Export;

begin
  Application.Initialize;
  //Inidll := TIni.Create0(ExeDir+'msw.ini');
end.
