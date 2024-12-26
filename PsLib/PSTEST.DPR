program pstest;

uses
  Forms,
  main in 'main.pas' {Form1},
  psx in 'psx.pas',
  psobjx in 'psobjx.pas',
  pslogs in 'pslogs.pas',
  psnames in 'psnames.pas',
  pscmn in 'pscmn.pas',
  psvms in 'psvms.pas',
  List in '..\LIB\List.pas',
  Arrayx in '..\LIB\Arrayx.pas',
  wcmn in '..\LIB\Wcmn.pas',
  runx in '..\LIB\runx.pas',
  psobj in 'psobj.pas',
  psstacks in 'psstacks.pas',
  psarrays in 'psarrays.pas',
  psdicts in 'psdicts.pas',
  psscan in 'psscan.pas',
  pso in 'pso.pas',
  Buf in '..\LIB\Buf.pas',
  filex in '..\LIB\filex.pas',
  progress in '..\LIB\Progress.pas' {ProgressForm},
  psfiles in 'psfiles.pas',
  pslib in 'pslib.pas',
  pstree in 'pstree.pas' {TreeForm},
  psgstate in 'psgstate.pas',
  psmat in 'psmat.pas',
  Color in '..\LIB\color.pas' {ColorDlg},
  pspath in 'pspath.pas';

{$R *.RES}


begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTreeForm, TreeForm);
  Application.CreateForm(TColorDlg, ColorDlg);
  Application.Run;
end.
