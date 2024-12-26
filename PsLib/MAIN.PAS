unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    LibMnu: TMenuItem;
    LibBuildMnu: TMenuItem;
    LibLoadMnu: TMenuItem;
    FileMnu: TMenuItem;
    FileRunMnu: TMenuItem;
    LibSaveMnu: TMenuItem;
    FileMapRunMnu: TMenuItem;
    OpenProjectDlg: TOpenDialog;
    OpenLibDlg: TOpenDialog;
    SaveLibDlg: TSaveDialog;
    OpenFileDlg: TOpenDialog;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LibBuildMnuClick(Sender: TObject);
    procedure LibLoadMnuClick(Sender: TObject);
    procedure LibSaveMnuClick(Sender: TObject);
    procedure FileRunMnuClick(Sender: TObject);
    procedure FileMapRunMnuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

uses pslib, wcmn, pstree;

{$R *.DFM}


procedure TForm1.FormDestroy(Sender: TObject);
begin
  pslib_done;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    pslib_init(Memo1.Lines,'d:\xxx\delphi\pslib;c:\ms\lib;c:\ms\top96.lib;c:\ms\fonts;'+TmpDir);

    pslib_setlogform(Self);
end;

procedure TForm1.LibBuildMnuClick(Sender: TObject);
begin
  if OpenProjectDlg.Execute then begin
    pslib_runcmdline('!.psl '+'@'+OpenProjectDlg.FileName);
  end;
end;

procedure TForm1.LibLoadMnuClick(Sender: TObject);
begin
  if OpenLibDlg.Execute then begin
    pslib_loadfromfile(OpenLibDlg.FileName);
  end;
end;

procedure TForm1.LibSaveMnuClick(Sender: TObject);
begin
  with SaveLibDlg do if Execute then begin
    if wcmn_file_ext(FileName)='' then FileName:=FileName+'.psa';
    pslib_savetofile(FileName);
  end;
end;

procedure TForm1.FileRunMnuClick(Sender: TObject);
begin
  if OpenFileDlg.Execute then begin
    pslib_settreeform(TreeForm, TreeForm.TreeView1);
    pslib_runcmdline({'!!.psl '+}OpenFileDlg.FileName);
  end;
end;

procedure TForm1.FileMapRunMnuClick(Sender: TObject);
{var calln: integer;}
begin
  pslib_runcmdline('!!.psl '+TmpDir+'ms.x');
end;

end.{of unit}

