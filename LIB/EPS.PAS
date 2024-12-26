unit EPS;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtDlgs;


type
  TForm1 = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    MainMenu1: TMainMenu;
    FileItem: TMenuItem;
    FileOpenItem: TMenuItem;
    procedure FileOpenItemClick(Sender: TObject);
  private
    FFileName: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


{ Functions: }

function EPS_Add_ShowPage(PsFileName: string): boolean;
function AddEpsHeader(bitfilename, psfilename, epsfilename: string): boolean;


implementation

{$R *.lfm}

uses Wcmn;


{ Functions: }

function EPS_Add_ShowPage(PsFileName: string): boolean;
var f: TextFile;
begin
  Result:=ftopen(f, PsFileName, 'a');
  if Result then try
    writeln(f,'');
    writeln(f,'showpage');
  finally
    ftclose(f);
  end;
end;

function AddEpsHeader(bitfilename, psfilename, epsfilename: string): boolean;
const
  h0: array[1..4]of char = (#$C5,#$D0,#$D3,#$C6);
var
  hfilename: string;
  bitsize, pssize, l: LongInt;
  w: word;
  hfile: file;
begin
  Result:=false;

  hfilename:=TmpDir+'tmp.eps';

  bitsize:=wcmn_filesize(bitfilename);
  pssize:=wcmn_filesize(psfilename);

  {EPS-Header:}
  assign(hfile,hfilename);
  {$I-} rewrite(hfile,1); {$I+}
  if IOResult<>0 then exit;

  BlockWrite(hfile,h0[1],4);
  l:=30; BlockWrite(hfile,l,4);    {PS-section}
  l:=pssize; BlockWrite(hfile,l,4);
  l:=0; BlockWrite(hfile,l,4);     {WMF-section}
  l:=0; BlockWrite(hfile,l,4);
  l:=30+pssize; BlockWrite(hfile,l,4);  {TIF-section}
  l:=bitsize; BlockWrite(hfile,l,4);
  w:=$FFFF; BlockWrite(hfile,w,2);
  CloseFile(hfile);

  Result := (wcmn_filecopy([hfilename,psfilename,bitfilename],epsfilename)=3);
end;


{ TForm1: }

procedure TForm1.FileOpenItemClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute
  then FFileName:=OpenPictureDialog1.FileName;
end;


end.
