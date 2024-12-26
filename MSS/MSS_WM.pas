unit MSS_WM;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  dmw_wm;

type
  TFormWm = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    dmw: TDmwClient;
    procedure PickProc(Cmd: Integer; wm: twm_pointer);
  public
    /////////////////////////////////////////////////////////////////////////////
    // MyPickPage -
    // чтобы вызвать PickProc из _webmaps(интернет-растры) или из Msw_1(вся карта)
    // в режиме вычисления страницы (cmd=2) или вычисления увеличения (cmd=1)
    // в обоих случаях Cmd=dmw_wm_rect в PickProc(Cmd, wm)
    /////////////////////////////////////////////////////////////////////////////
    procedure MyPickPage(_CalcPage: boolean; a,b: TPoint);
  end;

var
  FormWm: TFormWm;


implementation

uses Wcmn, cmn, OTypes, msw_x, Msw_msx{abc}, MSW_1;

{$R *.lfm}


procedure TFormWm.MyPickPage(_CalcPage: boolean; a,b: TPoint);
var
  Cmd: Integer;
  wm_rect: tdmw_wm_rect;//x1,y1,x2,y2: Integer;
  wm: twm_pointer;
begin
  wm_rect.x1:=a.X;
  wm_rect.y1:=a.Y;
  wm_rect.x2:=b.X;
  wm_rect.y2:=b.Y;

  wm.pg:=@wm_rect;

  if _CalcPage
  then cmn_pick_mode:=2//вычисление страницы
  else cmn_pick_mode:=1;//вычисление увеличения

  Cmd:=dmw_wm_rect;//одинаково для cmn_pick_mode = 2 и 1

  PickProc(Cmd, wm);
end;


procedure TFormWm.PickProc(Cmd: Integer; wm: twm_pointer);
var dmw_r: tdmw_wm_rect; dmw_o: tdmw_wm_object;

  procedure PickRect(wm: twm_pointer);
  begin
    FormMain.DmRepeatItem.Visible:=true;//!

    dmw_r := wm.pg^;//x1,y1,x2,y2: Integer;
    cmn_a := Point(dmw_r.x1,dmw_r.y1);
    cmn_b := Point(dmw_r.x2,dmw_r.y2);

    if cmn_pick_mode=1{вычисление увеличения} then begin

      cmn_lw:=abs(cmn_b.x-cmn_a.x);
      try cmn_zoom:=cmn_upm*(cmn_mscale/1000)*(cmn_rpw/cmn_lw);
      except on Exception do cmn_zoom := 1;
      end;
      if cmn_zoom>0.5 then FormMain.EditZoom.Text := Format('%.1f',[cmn_zoom])
      else if cmn_zoom>0.05 then FormMain.EditZoom.Text := Format('%.2f',[cmn_zoom])
      else if cmn_zoom>0.005 then FormMain.EditZoom.Text := Format('%.3f',[cmn_zoom])
      else FormMain.EditZoom.Text := Format('%f',[cmn_zoom]);

    end else
    if cmn_pick_mode=2{вычисление страницы} then begin

      cmn_lw:=abs(cmn_b.x-cmn_a.x);
      cmn_lh:=abs(cmn_b.y-cmn_a.y);
      try cmn_k:=(cmn_zoom*1000)/(cmn_upm*cmn_mscale);
      except on Exception do cmn_k := 1;
      end;
      cmn_rpw:=cmn_lw*cmn_k;
      cmn_rph:=cmn_lh*cmn_k;
      FormMain.Pw.Text := Format('%.1f',[cmn_rpw]);
      FormMain.Ph.Text := Format('%.1f',[cmn_rph]);

    end;
  end;

  procedure PickPort(wm: twm_pointer);
  begin
    FormMain.DmRepeatItem.Visible:=true;//!

    dmw_r := wm.pg^;//x1,y1,x2,y2: Integer;
    cmn_a := Point(dmw_r.x1,dmw_r.y1);
    cmn_b := Point(dmw_r.x2,dmw_r.y2);
  end;

  procedure PickRegion(wm: twm_pointer);
  begin
    dmw_o := wm.po^;//tdmw_wm_object
  end;

begin//TFormWm.PickProc:

  if Cmd = dmw_wm_object
  then begin
    PickRegion(wm);
    //...
    EXIT;//!
  end
  else

  if (Cmd = dmw_wm_cancel) or (cmn_pick_mode<0)
  then EXIT//!
  else

  if Cmd = dmw_wm_rect
  then PickRect(wm)
  else

  if Cmd = dmw_wm_port
  then PickPort(wm)
  else

  //Cmd=14 m.b.:
  begin
    //Tellf('TFormWm.PickProc: Cmd=%d - Неизвестная команда', [Cmd]);
    EXIT;//!
  end;

  //DmCopy - if Cmd=dmw_wm_rect or Cmd=dmw_wm_port:
  cmn_pick_mode:=-1;//default
  abc.pageOk:=false;
  if msw_DmCopy(cmn_a, cmn_b, cmn_use_map_include) then
    FormMain.MsRepeatItemClick(NIL{Sender}) {ВЫПОЛНЕНИЕ}
  else
    Tell('DmCopy: False.');

end;


{ EVENTS: }

procedure TFormWm.FormCreate(Sender: TObject);
begin
  dmw := TDmwClient.Create(PickProc);
end;

procedure TFormWm.FormDestroy(Sender: TObject);
begin
  dmw.Free;
end;

end.
