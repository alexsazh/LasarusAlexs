program frame_N;

{$MODE Delphi}

uses
  Forms, Interfaces,
  fr_sea in 'fr_sea.pas' {FSeaFrm},
  UFrmnavy in 'UFrmnavy.pas' {FFrame},
  NavyHead in 'NavyHead.pas' {FNavyHead},
  NavScale in 'NavScale.pas' {FnavScale},
  FR_Nmain in 'FR_Nmain.pas' {FfrmMain},
  wmPick in 'wmPick.pas' {FPick},
  UconFrm in 'UconFrm.pas' {FConus},
  uNormstr in 'uNormstr.pas' {FNormSt},
  UArt in 'UArt.pas' {FArt},
  nvunzarm in 'nvunzarm.pas' {TFtuneZaram};

 {$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFfrmMain, FfrmMain);
  Application.CreateForm(TFSeaFrm, FSeaFrm);
  Application.CreateForm(TFFrame, FFrame);
  Application.CreateForm(TFNavyHead, FNavyHead);
  Application.CreateForm(TFnavScale, FnavScale);
  Application.CreateForm(TFPick, FPick);
  Application.CreateForm(TFConus, FConus);
  Application.CreateForm(TFtuneZaram, FtuneZaram);
  Application.CreateForm(TFNormSt, FNormSt);
  Application.CreateForm(TFArt, FArt);
  Application.Run;
end.
