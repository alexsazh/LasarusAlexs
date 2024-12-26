unit msw_ps;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls,
  Wcmn, GsOpt, Spin;


type
  TPrintDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    mode: TRadioGroup;
    AddShowpage: TCheckBox;
    PreviewRes: TSpinEdit;
    Label_PreviewRes: TLabel;
    FileLabel: TLabel;
    Label1: TLabel;
    ZoomEdit: TEdit;
    TiffRes: TSpinEdit;
    Label_TiffRes: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    //prolog, epilog: string;
  public
    FileName: string;
    OKBtnClickResult: boolean;
  end;

var
  PrintDlg: TPrintDlg;


implementation

uses MSW_1,MSCMN,msw_x,EPS,SysUtils, MSGX,cmdfile, cmn, help;


{$R *.lfm}


{ GhostScript: }


procedure TPrintDlg.OKBtnClick(Sender: TObject);
var
  s,tmpfname,epsfname,tiffname, gslib: string; f: system.text;
  zoom: real;
  {dpi0,dpi: Integer;}
begin
  OKBtnClickResult:=false;
  zoom:=rvaldef(ZoomEdit.Text,1);

  tmpfname:=TmpDir+tmp_ms_file_name;//--- Управляющий файл для GS
  if ftopen_msg(f, tmpfname, 'w') then
  try
    writeln(f,'(def.psl) runlibfile');//epsview0
    writeln(f,'(ai30.psl) runlibfile'); {for AI-files!}

    if Mode.ItemIndex<>0
      then writeln(f,'(',ps_string(wcmn_UTF2System(FileName)),') epsview0')
      else writeln(f,'(',ps_string(wcmn_UTF2System(FileName)),') ',zoom:7:2,' epsview0');

    if AddShowpage.Checked
    or (Mode.ItemIndex=0)//view
    or (Mode.ItemIndex>=4)//Tiff,WebTiffs
    then writeln(f,'showpage');//Иначе НИЧЕГО НЕ БУДЕТ!

    writeln(f,'quit');
  finally
    ftclose(f);
  end
  else EXIT;//!

  gslib:= wcmn_UTF2System(GsOptDlg.GsLabel.Caption);
  case Mode.ItemIndex of

    0:{view:} {%%BoundingBox - in epsview0 (def.psl)}
    begin
      exec_gs2(gslib,msw_GsIncludeDirs(false,false),tmpfname,false);
    end;

    1:{print:} {%%BoundingBox - in epsview0 (def.psl)}
    begin
      exec_gs2(gslib,msw_GsIncludeDirs(false,false),'-dNOPAUSE -sDEVICE=mswinpr2 '+tmpfname,true);
    end;

    2:{add preview:} {@sps - см. ps2eps.ps}
    begin
      epsfname:=wcmn_file_dirname(FileName)+'.eps';
      if epsfname=FileName then begin
        Tellf(msgs[8],[FileName,epsfname]);
        exit;
      end;

      if not ExecuteCmdFile then
        if FileExists(epsfname)
          then if not TellfYN(msgs[9],[epsfname])
            then exit;

      (*
      s:=Format('-dNOPAUSE -sDEVICE=tiff24nc -r%d -sOutputFile=%stmp.tif ps2eps.ps ',[PreviewRes.Value,TmpDir]);
      exec_gs2(gsLib,msw_GsIncludeDirs(false),s+FileName,true);
      *)
      MsgForm.Open('%s --> %s',[FileName,epsfname]);
      s:=Format('-dNOPAUSE -sDEVICE=tiff24nc -r%d -sOutputFile=%stmp.tif ',[PreviewRes.Value,TmpDir]);
      exec_gs2(gslib,msw_GsIncludeDirs(false,false),s+tmpfname,true);
      MsgForm.Close;

      try
        if not AddEpsHeader(TmpDir+'tmp.tif', FileName, epsfname)
        then begin
          Tell('AddPreview ERROR. File Locked?');
          exit;
        end;
      except
        Tell('FileOpen ERROR. Locked?');
        exit;
      end;

    end;{case 2:}

    3://add showpage
    EPS_Add_ShowPage(FileName);

    4://Tiff:
    begin
      tiffname:=wcmn_file_dirname(FileName)+'.tif';
      MsgForm.Open('%s --> %s',[FileName,tiffname]);
      //s:=Format('-dNOPAUSE -sDEVICE=tiff24nc -r%d -sOutputFile=%s ',
      s:=Format('-dNOPAUSE -sDEVICE=tiff24nc -sCompression=lzw -r%d -sOutputFile=%s ',
               [TiffRes.Value,tiffname]);
      exec_gs2(gslib,msw_GsIncludeDirs(false,false),s+tmpfname,true);
      MsgForm.Close;
    end;{case 4}
(*
    5://Web Tif files:
    begin
      WebTif1.ps_to_tifs(FileName, MapScale.Value, Point(0,0),Point(0,0),0,0);//НЕТ map-rect
      //.............................................
    end;
*)

  end; {case}

  OKBtnClickResult:=true;
end;


procedure TPrintDlg.FormCreate(Sender: TObject);
begin
  //language from ExeName.msg:
  if wcmn_language_test('') then wcmn_language_form(Self);

  Ini.RForm(Self);

  Ini.Section:='EPS';
  Mode.ItemIndex := Ini.RI('Mode',0);
  ZoomEdit.Text := Ini.RS('ViewZoom','1');
  PreviewRes.Value := Ini.RI('PreviewRes',48);
end;

procedure TPrintDlg.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);

  Ini.Section:='EPS';
  Ini.WI('Mode',Mode.ItemIndex);
  Ini.WS('ViewZoom',ZoomEdit.Text);
  Ini.WI('PreviewRes',PreviewRes.Value);
end;


procedure TPrintDlg.FormShow(Sender: TObject);
begin
  Font:=FormMain.Font;

  FileLabel.Caption := FileName;
end;

procedure TPrintDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=112{F1} then begin
    Application.HelpCommand(HELP_CONTEXT, _help_psfile);
  end;//F1
end;

end.
