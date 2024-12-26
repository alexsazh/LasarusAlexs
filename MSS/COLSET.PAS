unit COLSET;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TColSetForm = class(TForm)
    ListBox1: TListBox;
    ListBox2: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColSetForm: TColSetForm;

implementation

{$R *.lfm}

end.
