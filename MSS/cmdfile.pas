unit cmdfile;

{$MODE Delphi}

 interface

const
  ExecuteCmdFile: boolean = false;
  CmdFile_Show_ColSepDlg: boolean = true; //1-ый раз TRUE

type
  TCmdFile = class
  private
    function Cmd_p(s0: string; AddHeader: boolean): boolean; {pnum fout}
    function Cmd_prj(s0: string): boolean; {prj_file}
  public
    function Execute(aFile: string): boolean;
  end;

implementation

uses
  SysUtils, Forms,
  Dmw_ddw, Wcmn, MSW_1, MSGX, msw_ps, cmn;

var CmdName: string;

{private:}

function TCmdFile.Cmd_p(s0: string; AddHeader: boolean): boolean;
var pnum: integer; s, foutname, dir: string;
begin
  Result:=false;
  s:=s0;

  pnum:=sread_int(s);
  foutname:=sread_word(s);
  if (pnum<0) or (foutname='') then begin
    Tellf(msgs[14],[CmdName,s0]);
    exit;
  end;

  dir := wcmn_file_dir( foutname );
  if dir='' then begin
    dir := wcmn_file_dir( FormMain.AiFileLabel.Caption );
    if dir='' then begin
      Tell(msgs[15]);
      exit;
    end;
    foutname:=dir+foutname;
  end;

  MsgForm.Open('Команда <%s %s>',[CmdName,s0]);

  FormMain.AiFileLabel.Caption:=foutname;
  FormMain.SpinEditPageNumber.Value:=pnum;
  FormMain.ButtonPageClick(nil);

  MsgForm.Close;
  if not FormMain.ButtonPageClickResult then exit;

  if AddHeader then begin

    PrintDlg.FileName := foutname;
    PrintDlg.Mode.ItemIndex:=2;
    PrintDlg.OKBtnClick(Self);
    if not PrintDlg.OKBtnClickResult then exit;

  end;

  Result:=true;
end;

function TCmdFile.Cmd_prj(s0: string): boolean; {prj_file}
var s,prjname: string; {ws: WideString;} zs: array[0..511]of Char;
begin
  Result:=false;
  s:=s0;

  prjname:=sread_word(s);
  if not FileExists(prjname) then begin
    Tellf(msgs[16],[prjname]);
    exit;
  end;

  MsgForm.Open('Команда <%s %s>',[CmdName,s0]);
  StrPCopy(zs,prjname);
  if dmw_OpenProject(zs) then begin
    dmw_ActiveMap(zs, 500);
    FormMain.PageMapLabel.Caption:=StrPas(zs);
  end else begin
    Tellf(msgs[17],[prjname]);
    exit;
  end;
  MsgForm.Close;

  Result:=true;
end;


{public:}

function TCmdFile.Execute(aFile: string): boolean;
var fcmd: Text; s: string;
begin
  Result:=true;
  if not ftopen_msg(fcmd,aFile,'r') then begin Result:=false; exit; end;

  ExecuteCmdFile:=true;
  CmdFile_Show_ColSepDlg:=true;
  try
    while not eof(fcmd) and Result do begin

      Application.ProcessMessages;//!?

      readln(fcmd,s);
      CmdName:=sread_word(s);

      if CmdName='' then continue
      else if CmdName='p' then Result:=Cmd_p(s,false)
      else if CmdName='ph' then Result:=Cmd_p(s,true)
      else if CmdName='prj' then Result:=Cmd_prj(s)

      else begin
        Tellf(msgs[18],[CmdName,aFile]);
        Result:=false;
      end;{else}

    end;{while}
  finally
    close(fcmd);
    ExecuteCmdFile:=false;
    CmdFile_Show_ColSepDlg:=true;
  end;{try}
end;

end.
