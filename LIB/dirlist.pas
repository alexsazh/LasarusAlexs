unit dirlist; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, Buttons, ExtCtrls;

type
  TFormDir = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    Panel1: TPanel;
    LabelDir: TLabel;
    Panel2: TPanel;
    DriveComboBox1: TDriveComboBox;
    Panel3: TPanel;
    BitBtnYes: TBitBtn;
    BitBtnNo: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function GetDir: string;//без '\' или 'c:\'
    procedure PutDir(Dir: string);
  public
    function Execute(InitDir: string; Title: string): boolean;

    property Dir: string read GetDir write PutDir;
  end;

var
  FormDir: TFormDir;

implementation

uses wcmn;

{$R *.dfm}


function TFormDir.GetDir: string;
begin
  Result := DirectoryListBox1.Directory;
end;

procedure TFormDir.PutDir(Dir: string);
begin
  DirectoryListBox1.Directory := Dir;
end;


function TFormDir.Execute(InitDir: string; Title: string): boolean;
begin
  if Length(Title)>0 then Caption:=Title;
  if (InitDir<>'') and wcmn.DirExists(InitDir) then PutDir(InitDir);
  try
    Result := ShowModal=mrOk;
  except
    ModalResult:=mrAbort;//!
    Result := false;
  end;
end;


{ Events: }

procedure TFormDir.FormCreate(Sender: TObject);
begin
  Ini.RForm(Self);
end;

procedure TFormDir.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);
end;

end.
