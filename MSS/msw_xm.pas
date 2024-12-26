(*
  MULTI CALL GCX+GC для набора файлов "$.ms, .gcx, .gc"
*)
unit msw_xm;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  List;


//MAIN:
function msw_xm_render: boolean;//$.ms и вставки


type
  tXmItem = class //record "abc" - in msw_msx.pas
  private
    ms_fname: string;//->$.ms
    gc_name: string;//->abc.gc_names
    gcx_name: string;//->abc.gcx_name
  public
    //запуск GCX+GC:
    //ms_fname -> ms_tmp_name=$.ms:
    function Render(ms_tmp_name: string; prolog,epilog: boolean; ms_msg: string): boolean;
  end;

  TFormXM = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FList: tclasslist;//of tXmItem
  public
    function Count: integer;
    procedure Clear;

    //управл.файл: <ms_fname dir\gc_name dir\gcx_name>:
    //вызов - in DmCopyCustom(msw_x.pas):
    //mng_fname='' => Clear(!):
    procedure LoadFromMngFile(mng_fname, psl_ini_name: string);

    //вызов: MsRepeatItemClick -> msw_xm_render:
    function Render(ms_tmp_name: string; before_main_ms: boolean): boolean;
  end;

var
  FormXM: TFormXM;



implementation

{$R *.lfm}

uses Wcmn, Msw_msx, msw_x, Runline, MSW_1, cmn;


//строка не должна содержать ')','\':
function msw_xm_get_ms_msg(i: integer): string;//i>=0
begin
  Result := Format(
    '<<< MS-files count = %d  Current number = %d >>>',
    [FormXM.Count+1, i+1]);
end;


function msw_xm_render: boolean;//$.ms и вставки
var s_gc_names, s_gcx_name: string;
begin
  Result := true;

  //ВСТАВКИ:
  case FormMain.MultiMsGroup.ItemIndex of

    //нет:
    0:  Result := msw_x_render(MsFileShortName+'.ms',
        true, true, false, msw_xm_get_ms_msg(0) );          {msw_x.pas}

    //сверху:
    1:
        begin
          Result := (wcmn_filecopy([MsFileShortName+'.ms'], MsFileShortName+'.ms0')=1);//save for debug
          if Result then Result := msw_x_render(MsFileShortName+'.ms',
            true, (FormXM.Count=0), false, msw_xm_get_ms_msg(0) );        {msw_x.pas}
          if Result then Result := FormXM.Render(MsFileShortName+'.ms', false);{msw_xm.pas}
        end;

    //снизу:
    2:
        begin
          //save:
          Result := (wcmn_filecopy([MsFileShortName+'.ms'], MsFileShortName+'.ms0')=1);//copy for render!!!
          s_gc_names:=abc.gc_names;//save
          s_gcx_name:=abc.gcx_name;//save

          if Result then Result := FormXM.Render(MsFileShortName+'.ms', true);                 {msw_xm.pas}

          //restore:
          abc.gc_names:=s_gc_names;
          abc.gcx_name:=s_gcx_name;
          if Result then Result := (wcmn_filecopy([MsFileShortName+'.ms0'], MsFileShortName+'.ms')=1);//copy for render!!!
          if Result then Result := msw_x_render(MsFileShortName+'.ms',
            (FormXM.Count=0), true, False,
            msw_xm_get_ms_msg(FormXM.Count) );   {msw_x.pas}
        end;

  end;//case
end;


{ tXmItem: }

function tXmItem.Render(ms_tmp_name: string; prolog,epilog: boolean; ms_msg: string): boolean;
begin
  Result:=false;

  //$.ms:
  if wcmn_filecopy([ms_fname], ms_tmp_name)<>1 then exit;

  //CALL old variant on $.ms:
  abc.gcx_name:=gcx_name;
  abc.gc_names:=gc_name;
  Result:=msw_x_render(ms_tmp_name, prolog, epilog, true, ms_msg);
end;


{ TFormXM: }

function TFormXM.Count: integer;
begin
  Result:=FList.Count;
end;

procedure TFormXM.Clear;
begin
  FList.Clear;
end;


//"ms_dir" with '\':
function _correct_full_name(var s: string; const ms_dir: string): boolean;
begin
  if pos(':', s)<=0 then s := ms_dir + s;
  Result:=FileExists(s);
end;

//управл.файл: <ms_fname dir\gc_name dir\gcx_name>:
//вызов - in DmCopyCustom(msw_x.pas):
//mng_fname='' => Clear(!):
procedure TFormXM.LoadFromMngFile(mng_fname, psl_ini_name: string);
var
  f: TextFile; fline, fline0, w0, wgc0, wgcx0, wgc, wgcx, ms_dir: string;
  XmItem: tXmItem; ok: boolean;
begin
  Clear;//!
  if not FileExists(mng_fname) then exit;//!
  ms_dir := UpperDir( wcmn_file_dir(psl_ini_name) );//with '\'

  if ftopen_msg(f, mng_fname, 'r') then try
    while not eof(f) do begin
      readln(f, fline0); if Length(fline0)=0 then break;

      //разбор строки:
      ok:=true;
      fline:=fline0;
      w0:=sread_word(fline);
      if ok and not FileExists(w0) then ok:=false;

      wgc0:=sread_word(fline); wgc:=wgc0;
      wgcx0:=sread_word(fline); wgcx:=wgcx0;
      if ok and (Length(wgc)=0) then begin
        Tell(msgs[19]);
        ok:=false;
      end;

      if ok and not _correct_full_name(wgc, ms_dir) then ok:=false;
      if ok and (Length(wgcx)>0) and not _correct_full_name(wgcx, ms_dir) then ok:=false;

      //данные корректны => в список:
      if ok then begin
        XmItem:=tXmItem.Create;
        FList.Add(XmItem);
        XmItem.ms_fname:=w0;
        XmItem.gc_name:=wgc;
        XmItem.gcx_name:=wgcx;
      end else begin
        Tellf(msgs[20],[w0,wgc0,wgcx0]);
        break;
      end;
    end;//while
  finally
    ftclose(f);
  end;
end;

function TFormXM.Render(ms_tmp_name: string; before_main_ms: boolean): boolean;//tXmItem.render FORALL
var i,ind: integer; XmItem: tXmItem; prolog,epilog: boolean;
begin
  Result:=true;//список м.б. пустым!
  if FList.Count=0 then exit;//!

  try
    for i:=0 to FList.Count-1 do begin
      prolog := before_main_ms and (i=0);
      epilog := not before_main_ms and (i = FList.Count-1);
      if before_main_ms then ind:=i else ind:=i+1;

      tobject(XmItem):=FList[i];
      Result:=XmItem.render(ms_tmp_name, prolog, epilog, msw_xm_get_ms_msg(ind) );

      if not Result then break;
    end;//for i
  finally
  end;
end;


{ Events: }

procedure TFormXM.FormCreate(Sender: TObject);
begin
  FList:=tclasslist.New;
end;

procedure TFormXM.FormDestroy(Sender: TObject);
begin
  FList.Free;
end;

end.
