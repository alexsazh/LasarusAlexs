program WarNav;

{$IFDEF WINDOWS}
{$MODE Delphi}
{$ENDIF}


{$IFDEF LINUX}
{$mode objfpc}{$H+}
{$ENDIF}

uses
  Forms, Interfaces,
  U_Nav_Warn;// in 'U_Nav_Warn.pas' {FNavWarning};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFNavWarning, FNavWarning);
  Application.Run;
end.
