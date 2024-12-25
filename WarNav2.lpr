program WarNav2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
U_Nav_Warn;// in 'U_Nav_Warn.pas' {FNavWarning};

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFNavWarning, FNavWarning);
  Application.Run;
end.

