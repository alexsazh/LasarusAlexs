unit tests; interface

uses
  Classes, SysUtils,
  filex, progress, main;

procedure ps_test;


implementation

uses pslib;

procedure ps_test;
begin
  if not pslib_init(Form1.Memo1.Lines,'d:\xxx\delphi\pslib;c:\ms\lib;c:\temp') then exit;
  try
    (*
    pslib_runfile('1.ps'{'ps_test.ps'});
    *)
    pslib_runcmdline('!.psl @psl.ini ms.x');
  finally
    pslib_done;
  end;
end;


end.{of unit}
