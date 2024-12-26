unit pstree; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, ExtCtrls;

type
  TTreeForm = class(TForm)
    Panel1: TPanel;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    ListView1: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TreeForm: TTreeForm;

implementation

{$R *.DFM}

end.
