unit myobj; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMyObjForm = class(TForm)
    Button1: TButton;
  private
  public
  end;

type
  TMyObj = class
    procedure Assign(obj: TObject);
  end;

var
  MyObjForm: TMyObjForm;

implementation

{$R *.DFM}

procedure TMyObj.Assign(obj: TObject);
var p0: pchar absolute obj; p1: pchar absolute Self;
begin
  if obj<>nil then StrMove(p1, p0, obj.InstanceSize)
  else Free;{!}
end;

end.{of unit}
