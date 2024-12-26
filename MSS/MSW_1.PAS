unit MSW_1;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Menus, Grids, DBGrids, ExtCtrls, DBCtrls, ComCtrls,
  Buttons,
  Spin,  LConvEncoding, Types;


type

  { TFormMain }

  TFormMain = class(TForm)
    MemoXobInfo: TMemo;
    XobDefault: TMenuItem;
    PopupMenu1: TPopupMenu;
    Rg_mode: TRadioGroup;
    TabbedNotebook1: TPageControl;
    ButtonShow: TButton;
    EditScale: TEdit;
    Label1: TLabel;
    ButtonPage: TButton;
    SpinEditPageNumber: TSpinEdit;
    OpenMpg: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label4: TLabel;
    Mirror: TCheckBox;
    Negativ: TCheckBox;
    ModeGroup: TRadioGroup;
    ColSep: TCheckBox;
    EditZoom: TEdit;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditCut: TEdit;
    EditEps: TEdit;
    Markers: TCheckBox;
    Label10: TLabel;
    lpi: TSpinEdit;
    angle: TSpinEdit;
    Label11: TLabel;
    ButtonScale: TButton;
    px0: TEdit;
    py0: TEdit;
    ph: TEdit;
    pw: TEdit;
    SizeGrid: TStringGrid;
    GetRow: TButton;
    DelRow: TButton;
    PutRow: TButton;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label12: TLabel;
    OpenPs: TOpenDialog;
    MarkersOffset: TCheckBox;
    PortGroup: TRadioGroup;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    BtnAi: TBitBtn;
    OutFileClear: TBitBtn;
    TextAsCurves: TCheckBox;
    MainMenu1: TMainMenu;
    FileItem: TMenuItem;
    PSFileItem: TMenuItem;
    MsRepeatItem: TMenuItem;
    N1: TMenuItem;
    OptItem: TMenuItem;
    HelpItem: TMenuItem;
    AiFileLabel: TLabel;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    ts4: TTabSheet;
    ts5: TTabSheet;
    XobList: TListBox;
    XobMenu: TPopupMenu;
    XobAddItem: TMenuItem;
    XobDelItem: TMenuItem;
    XobClear: TMenuItem;
    XobInsertItem: TMenuItem;
    GroupBox3: TGroupBox;
    PageMapLabel: TLabel;
    ButtonClear1: TButton;
    BtnPageMap: TBitBtn;
    Panel1: TPanel;
    PnumUp: TCheckBox;
    PrintPNum: TCheckBox;
    PsCfgItem: TMenuItem;
    FontDialog1: TFontDialog;
    PageCode: TEdit;
    Label2: TLabel;
    MapIncludeItem: TMenuItem;
    PageSizeFromBln: TCheckBox;
    CmdFileItem: TMenuItem;
    OpenCMD: TOpenDialog;
    N3: TMenuItem;
    DmRepeatItem: TMenuItem;
    RotCheck: TCheckBox;
    EditPageZoom: TEdit;
    Label13: TLabel;
    Rotation: TRadioGroup;
    N4: TMenuItem;
    OpenGc: TOpenDialog;
    MultiMsGroup: TRadioGroup;
    CheckShowPage: TCheckBox;
    Check_dlltest: TCheckBox;
    RastersItem: TMenuItem;
    CheckBoxPNG: TCheckBox;
    Check_GCX_dm: TCheckBox;
    Panel2: TPanel;
    ButtonShowMap: TButton;
    PSFileExport: TMenuItem;
    PSFileExport_pdf: TMenuItem;
    PSFileExport_tif: TMenuItem;
    N5: TMenuItem;
    procedure Rg_modeClick(Sender: TObject);
    procedure XobDefaultClick(Sender: TObject);
    procedure PSFileExport_pdfClick(Sender: TObject);
    procedure PSFileExport_tifClick(Sender: TObject);
    procedure ButtonShowMapClick(Sender: TObject);
    procedure RastersItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonShowClick(Sender: TObject);
    procedure ButtonPageClick(Sender: TObject);
    procedure ButtonClear1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnAiClick(Sender: TObject);
    procedure BtnPageMapClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GetRowClick(Sender: TObject);
    procedure PutRowClick(Sender: TObject);
    procedure DelRowClick(Sender: TObject);
    procedure ButtonScaleClick(Sender: TObject);
    procedure OutFileClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MsRepeatItemClick(Sender: TObject);
    procedure PSFileItemClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure ts5ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure XobClearClick(Sender: TObject);
    procedure XobDelItemClick(Sender: TObject);
    procedure XobAddItemClick(Sender: TObject);
    procedure XobInsertItemClick(Sender: TObject);
    procedure PsCfgItemClick(Sender: TObject);
    procedure MapIncludeItemClick(Sender: TObject);
    procedure CmdFileItemClick(Sender: TObject);
    procedure DmRepeatItemClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure XobListMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
  private
    procedure _Select_Rect(_map{вся карта}: boolean);//указание прям-ка печати
  public
    //MsLibRepeat: boolean;
    DmRepeatItemClickResult: boolean;
    ButtonPageClickResult: boolean;
    MsRepeatItemClickResult: boolean;
//    DmPerMm: real; //fill in msw_DmCopy (msw_x.pas)
    procedure ReadIniFile;
    procedure WriteIniFile;
    function StoreToAbc: boolean;
  end;

var
  FormMain: TFormMain;
  //DmwTlb: IDmw_Auto;

const
  SectionGeneral = 'General';
  SectionMap = 'Map';
  SectionOptions = 'Options';
  SectionSeparation = 'Separation';
  SectionPrint = 'Print';
  SectionPages = 'Pages';
  SectionOBJ = 'OBJ';


{-----------------------------------------------}
implementation
{$R *.lfm}
{-----------------------------------------------}

uses
  OTypes, Dmw_ddw, dmw_wm, Dmwlib,
  msw_x, msw_xm, Msw_msx,
  Wcmn, MSW_PRN, MSW_COL, msw_ps, GsOpt, ABOUT,
  cmdfile, Vlib, Dmlib, Nums,
  cmn, mapprntest,
  help, _webtif, _webmaps, _webcmn, MSS_WM,
  check_dm_xy, msw_ps_export;


{ TFormMain Methods: }

procedure _GridLoadFromFile(grid: TStringGrid);
var s, si: string; n, i: integer;
begin
  with grid do begin
    rowcount:=2;{1-empty}
    i:=0;
    while true do begin
      inc(i);
      si := Format('%d', [i]);  {'1', '2', ...}
      s := Ini.ReadString(SectionPages, si, '');
      if Length(s)=0 then break;
      if i>1 then rowcount:=rowcount+1;  {add new row}
      with rows[rowcount-1] do begin
        n:=1;
        strings[0]:=sgetword(s,n);
        strings[1]:=sgetword(s,n);
        strings[2]:=sgetword(s,n);
        strings[3]:=sgetword(s,n);
      end; {with}
    end; {while TRUE}
    if rowcount=1 then rowcount:=2;{add 1 empty row!}
  end;{with grid}
end;

procedure _GridSaveToFile(grid: TStringGrid);
var s, si: string; i: integer;
begin
  with grid do begin
    if rowcount>1 then for i:=1 to rowcount-1 do begin
      si := Format('%d', [i]);  {'1', '2', ...}
      with rows[i] do s := Format('%s %s %s %s',[ strings[0],strings[1],strings[2],strings[3] ]);
      Ini.WriteString(SectionPages, si, s);
    end; {for}
  end; {with}
  si := Format('%d', [grid.rowcount]);
  Ini.WriteString(SectionPages, si, '');{END}
end;

procedure _XobsLoadFromFile(List: TListBox);
var s, si: string; i: integer;
begin
  List.Clear;
  i:=0;
  while true do begin
    inc(i);
    si := Format('%d', [i]);  {'1', '2', ...}
    s := Ini.ReadString(SectionOBJ, si, '');
    if Length(s)=0 then break;
    if FileExists(s) then List.Items.Add(s);
  end; {while TRUE}
end;

procedure _XobsSaveToFile(List: TListBox);
var si: string; i: integer;
begin
  if List.Items.Count>0 then for i:=1 to List.Items.Count do begin
    si := Format('%d', [i]);  {'1', '2', ...}
    Ini.WriteString(SectionOBJ, si, List.Items[i-1]);
  end; {for}
  si := Format('%d', [List.Items.Count+1]);
  Ini.WriteString(SectionOBJ, si, '');{END}
end;


procedure TFormMain.ReadIniFile;
var s: string; i: integer;
begin
    {General:}
    Ini.Section:=SectionGeneral;

//    DmPerMm := Ini.RR('DmPerMm', 1000);

    ModeGroup.ItemIndex := Ini.RI('Mode',0);
    ColSep.Checked := Ini.RB('ColSep',false);
    TextAsCurves.Checked := Ini.RB('TextAsCurves',false);
    CheckShowPage.Checked := Ini.RB('CheckShowPage',true);

    AiFileLabel.Caption := Ini.RS('OutputFile','');
    if not DirExists(wcmn_file_dir(AiFileLabel.Caption)) then AiFileLabel.Caption:='';
    AiFileLabel.Hint := AiFileLabel.Caption;

    {Map:}
    Ini.Section:=SectionMap;

    abc.pageOk := Ini.RB('FromPage',FALSE);
    SpinEditPageNumber.Value := Ini.RI('PN',1);
    EditCut.Text := Ini.RS('CutMargins','0');
    EditEps.Text := Ini.RS('Include','');
    PortGroup.ItemIndex := Ini.RI('PortType',0);
    EditZoom.Text := Ini.RS('Zoom','1');
    EditScale.text:= Ini.RS('Scale','10000');
    PageMapLabel.Caption := Ini.RS('PDM','');
    if not FileExists(PageMapLabel.Caption) then PageMapLabel.Caption:='';
    PageCode.Text := Ini.RS('PageCode','01000003');
    PageSizeFromBln.Checked:=Ini.RB('PageSizeFromBln',false);

    {Options:}
    Ini.Section:=SectionOptions;

    Markers.Checked := Ini.RB('Markers',true);
    MarkersOffset.Checked := Ini.RB('MarkersOffset',false);
    Rotation.ItemIndex := Ini.RI('Rotation',0);
    Mirror.Checked := Ini.RB('Mirror',false);
    Negativ.Checked := Ini.RB('Negativ',false);
    lpi.Value := Ini.RI('LPI',120);
    angle.Value := Ini.RI('Angle10',0);

    s := Ini.RS('PageSize','0 0 210 297');
      i:=1;
      px0.Text := sgetword(s,i);
      py0.Text := sgetword(s,i);
      pw.Text := sgetword(s,i);
      ph.Text := sgetword(s,i);

    _GridLoadFromFile(SizeGrid);
    _XobsLoadFromFile(XobList);
end;

procedure TFormMain.WriteIniFile;
begin
    {General:}
    Ini.Section:=SectionGeneral;

//    Ini.WR('DmPerMm',DmPerMm);

    Ini.WI('Mode',ModeGroup.ItemIndex);
    Ini.WB('ColSep',ColSep.Checked);
    Ini.WS('OutputFile',AiFileLabel.Caption);
    Ini.WB('TextAsCurves',TextAsCurves.Checked);
    Ini.WB('CheckShowPage',CheckShowPage.Checked);

    {Map:}
    Ini.Section:=SectionMap;

    Ini.WB('FromPage',abc.pageOk);
    Ini.WI('PN',SpinEditPageNumber.Value);
    Ini.WS('PDM',PageMapLabel.Caption);
    Ini.WS('CutMargins',EditCut.Text);
    Ini.WS('Include',EditEps.Text);
    Ini.WI('PortType',PortGroup.ItemIndex);
    Ini.WS('Zoom',EditZoom.Text);
    Ini.WS('Scale',EditScale.Text);
    Ini.WS('PageCode',PageCode.Text);
    Ini.WB('PageSizeFromBln',PageSizeFromBln.Checked);

    {Options:}
    Ini.Section:=SectionOptions;

    Ini.WB('Markers',Markers.Checked);
    Ini.WB('MarkersOffset',MarkersOffset.Checked);
    Ini.WI('Rotation',Rotation.ItemIndex);
    Ini.WB('Mirror',Mirror.Checked);
    Ini.WB('Negativ',Negativ.Checked);
    Ini.WI('LPI',lpi.Value);
    Ini.WI('Angle10',angle.Value);
    Ini.WS('PageSize',Format('%s %s %s %s',[px0.Text,py0.Text,pw.Text,ph.Text]));

    _GridSaveToFile(SizeGrid);
    _XobsSaveToFile(XobList);
end;


//abc: Msw_msx.pas
function TFormMain.StoreToAbc: boolean;
var
  i: Integer; s,se: string;
  smap, sobj, gcDir, gcFile:AnsiString;
begin
  Result:=false;

  {Общие:}

  abc.gc_names:='';
  abc.gcx_name:='';
  if Rg_mode.ItemIndex = 1 then begin
    smap:=Dmw.ActiveMap;
    if smap = '' then begin
      Tell('Отсутствует активная карта');
      exit;
     end;
     sobj:=DmObjName(smap);
     gcDir:=UpperDir(wcmn_file_dir0(GsOptDlg.LibLabel.Caption))+sobj;
     gcFile:=ChangeFileExt(gcDir+'\'+sobj, '.gc');
     if not FileExists(gcFile) then begin
      Tell('Не найден классификатор печати:' +gcFile);
      exit;
     end;
     abc.gc_names:=gcFile;
     gcFile:=ChangeFileExt(gcFile, '.gcx');
     abc.gcx_name:=gcFile;
     if FileExists(gcFile) then begin
       abc.gcx_name:=gcFile;
     end;
  end else begin
    if XobList.Items.Count>0 then for i:=0 to XobList.Items.Count-1 do begin
      s:=XobList.Items[i];
      se:=wcmn_file_ext(s);
      if (se<>'.GC') and (se<>'.XOB') and (se<>'.gc') and (se<>'.xob') then begin
        if abc.gcx_name='' then abc.gcx_name:=s;//первый .GCX в списке
      end else begin
        if i>0 then abc.gc_names:=abc.gc_names+';';
        abc.gc_names:=abc.gc_names+s;
      end;
    end;
  end;
  if Length(abc.gc_names)=0 then begin
    Tell(msgs[0]);
    exit;
  end;

  abc.fai := ps_string(wcmn_file_dirname(AiFileLabel.Caption));
  abc.aiext := wcmn_file_ext(AiFileLabel.Caption);
  abc.textascurves := TextAsCurves.Checked;

  abc.mode   := ModeGroup.ItemIndex;
    abc.prn := (abc.mode=1);
    abc.cnv := (abc.mode=2);
    abc.wprn := (abc.mode=3);

  abc.colsep := ColSep.Checked;

  {Страница карты:}
  abc.pn := SpinEditPageNumber.Value;
  abc.pagemap := ps_string(PageMapLabel.Caption);
  abc.pcode := StrToIntDef(PageCode.Text,01000003);
  abc.cut_m := rvaldef(EditCut.Text,0);
  abc.pageeps := ps_string(EditEps.Text);

  {Участок карты:}
  abc.zoom := rvaldef(EditZoom.Text,-1);
  if abc.zoom<=0 then begin
    Tell(msgs[1]);
    exit;
  end;

  {Параметры:}
  abc.mark := Markers.Checked;
  abc.markofs := MarkersOffset.Checked;
  abc.rot := Rotation.ItemIndex;
  abc.mir := Mirror.Checked;
  abc.negativ := Negativ.Checked;

  abc.lpi := lpi.Value;
  abc.angle := angle.Value/10;

  abc.pnum := PrintPNum.Checked;
  abc.pnup := PnumUp.Checked;

  abc.px0 := rvaldef(px0.Text,-1);
  abc.py0 := rvaldef(py0.Text,-1);
  abc.pw := rvaldef(pw.Text,-1);
  abc.ph := rvaldef(ph.Text,-1);
  if (abc.px0<0) or (abc.py0<0) or (abc.pw<=0) or (abc.ph<=0) then begin
    Tell(msgs[2]);
    exit;
  end;

  with FormPrnCnv do begin
    abc.prndev := PrnList.Text;
    abc.prnres := PrnRes.Value;
    abc.cnvdev := CnvList.Text;
    abc.cnvres := CnvRes.Value;
    abc.tofile := ToFile.Checked;
    abc.fname := ps_string(OutputFile.Text);
  end;

  with ColSepDlg do begin
    abc.cmodel := Model.ItemIndex;
  end;

  Result:=true;
end;


{-----------------------------------------------}
//////////////   SHOW (SELECT RECT)  ////////////
{-----------------------------------------------}

//указание прям-ка печати - PRIVAT:
procedure TFormMain._Select_Rect(_map{вся карта}: boolean);
var map_a,map_b: TPoint;
begin

///////// cmn - params - begin: //////////////////////////////////
  cmn_use_map_include:=MapIncludeItem.Checked;

  cmn_mscale := abs(ivaldef(EditScale.Text,1));
  if cmn_mscale=1 then {default value}
  begin
    cmn_mscale := msw_MapScale;
    EditScale.Text := Format('%d',[cmn_mscale]); {тек.карта}
  end;

  cmn_rpw := abs(rvaldef(Pw.Text,210));  {ширина печатн.стр.}
  cmn_rph := abs(rvaldef(Ph.Text,297));  {высота печатн.стр.}

  cmn_zoom := abs(rvaldef(EditZoom.Text,1));
  if cmn_zoom=0 then
  begin
    cmn_zoom := 1;
    EditZoom.Text := Format('%.1f',[cmn_zoom]);
  end;

  cmn_upm := msw_MapUPM; {Units Per Metter in map}
///////// cmn - params - end ////////////////////////////////////

  case PortGroup.ItemIndex of

    {в разм.печатн.стр.}
    0: begin
      cmn_pick_mode:=0;
      if _map then begin
        Tell('Выбор всей карты несовместим с режимом "В размерах печатной страницы"');
        EXIT;//// НИЧЕГО НЕ ДЕЛАЕМ !!!!!!!!!
      end;

      try cmn_k:=cmn_upm*(cmn_mscale/1000)/cmn_zoom;
      except on Exception do cmn_k := 1;
      end;

      cmn_lw:=trunc(cmn_k*cmn_rpw);
      cmn_lh:=trunc(cmn_k*cmn_rph);

      dmw_SetFocus;
      dmw_Pick_wm(dmw_wm_port, cmn_lw, cmn_lh);//!
    end; {case 0}

    {с вычисл. увеличения}
    1: begin
      cmn_pick_mode:=1;
      if _map then begin
        if cmn_map_bound(map_a,map_b)
        then FormWm.MyPickPage(FALSE{_CalcPage}, map_a,map_b);
      end else begin
        dmw_SetFocus;
        dmw_Pick_wm(dmw_wm_rect,0,0);//!
      end;
    end; {case 1}

    {с вычисл.страницы}
    2: begin
      cmn_pick_mode:=2;
      if _map then begin
        if cmn_map_bound(map_a,map_b)
        then FormWm.MyPickPage(TRUE{_CalcPage}, map_a,map_b);
      end else begin
        dmw_SetFocus;
        dmw_Pick_wm(dmw_wm_rect,0,0);//!
      end;
    end; {case 2}

  end; {case}
end;


procedure TFormMain.ButtonShowClick(Sender: TObject);
begin
  if check_prj_xy then Tell('Карты проекта проверены, часть переоткрыта');

  _Select_Rect(FALSE{вся карта});
end;

procedure TFormMain.ButtonShowMapClick(Sender: TObject);
begin
  if check_active_dm_xy then Tell('Активная карта проверена и переоткрыта');

  _Select_Rect(TRUE{вся карта});
end;

{-----------------------------------------------}
{-----------------------------------------------}

procedure TFormMain.ButtonPageClick(Sender: TObject);
var
  a,b: tnum2; rcutm,map_cutm,rpw{,rph}: real;
  npage, pcode: longint; bln_pw,bln_ph: float;
  FindOk: boolean; use_map_include: boolean;
  map_pw,map_ph: tnum;//размеры страницы на карте
  cutm_vw,cutm_vh: tnum2;//вектора сдвига (cutm_vh - вниз!)
//  pagezoom: double;
begin
  ButtonPageClickResult:=false;
  use_map_include:=MapIncludeItem.Checked;//"Использовать прозрачность листов"

  //проверка карты:
  if PageMapLabel.Caption='' then PageMapLabel.Caption := dmw_Active_Map;
  if PageMapLabel.Caption='' then begin
    Tell(msgs[3]);
    exit;
  end;

  //поиск страницы:
  npage := SpinEditPageNumber.Value;
  pcode := StrToIntDef(PageCode.Text,01000003);
  if not msw_dm_Open(PageMapLabel.Caption) then exit; //dmw_Open (dmw_HideMap+dm_Open)
  try
    {Заполняет abc: rightpage, bln_pw, bln_ph:}
    FindOk:=msw_FindPage(npage,pcode, RotCheck.Checked, map_pw,map_ph, a,b, bln_pw,bln_ph);//msw_x.pas
  finally
    dmw_Done;//(dm_Done+dmw_BackMap)
  end;
  if not FindOk then exit;

  //Размер стр. из бланка:
  if PageSizeFromBln.Checked then begin
    if (bln_pw>0.01) and (bln_ph>0.01) then begin
      //запись в панель "Размеры"
      pw.Text:=Format('%.2f',[bln_pw]);
      ph.Text:=Format('%.2f',[bln_ph]);
    end else begin
      Tell(msgs[4]);
      exit;
    end;
  end;

  DmRepeatItem.Visible:=true;//!

  {Begin Cut Margins:}

  //kcutm: обрезные поля в коорд-ах карты:
  rcutm :=  abs( rvaldef(EditCut.Text,0) );
  rpw  :=  abs( rvaldef(Pw.Text,210) );
  try
    map_cutm := (rcutm/rpw)*map_pw;
  except
    map_cutm := 0;
  end;

  //изменение a,b:
  if RotCheck.Checked then begin
    cutm_vw := v_sub( v_lt(a,b, map_cutm/map_pw), a );
    cutm_vh := v_rot(cutm_vw,90);
    a:=v_add(a,cutm_vh);
    b:=v_add(b,cutm_vh);
    if abc.rightpage=1 then b:=v_add(b,cutm_vw) else a:=v_add(a,v_mul(cutm_vw,-1));
  end else begin
    a.y:=a.y-map_cutm;
    b.y:=b.y+map_cutm;
    if abc.rightpage=1 then b.x:=b.x+map_cutm else a.x:=a.x-map_cutm;
  end;
  map_pw:=map_pw+map_cutm;//w: только с одной стороны (abc.rightpage)
  map_ph:=map_ph+2*map_cutm;//h: с обоих сторон

  {End Cut Margins.}

  if not msw_DmCopy2(RotCheck.Checked, map_pw,map_ph, a,b, use_map_include) then begin
    Tell('DmCopy: False.');
    exit;
  end;

  MsRepeatItemClick(Sender);
  if not MsRepeatItemClickResult then exit;

  ButtonPageClickResult:=true;
end;


procedure TFormMain.ButtonClear1Click(Sender: TObject);
begin
   PageMapLabel.Caption := CP1251ToUTF8(dmw_active_map);
   if PageMapLabel.Caption='' then Tell(msgs[3]);
end;


procedure TFormMain.FormShow(Sender: TObject);
begin
  //Tell('FormMain: OnShow');

  if not dmw_connect then Tell('FALSE in dmw_connect');
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmw_disconnect;//!!!
end;


procedure TFormMain.BtnAiClick(Sender: TObject);
var mapname: string;
begin
   with SaveDialog1 do begin
     FileName := AiFileLabel.Caption;
     if FileName='' then begin
       mapname := CP1251ToUTF8(dmw_active_map);
       if mapname<>'' then FileName := wcmn_file_dirname(mapname)+'.PS';
     end;
     if Execute then
       AiFileLabel.Caption := FileName;
       AiFileLabel.Hint := AiFileLabel.Caption;
   end;
end;

procedure TFormMain.BtnPageMapClick(Sender: TObject);
begin
   with OpenMpg do begin
     FileName := PageMapLabel.Caption;
     if FileName='' then FileName:=CP1251ToUTF8(dmw_active_map);
     if Execute then PageMapLabel.Caption := FileName;
   end;
end;


procedure TFormMain.ButtonExitClick(Sender: TObject);
begin
  Close;
end;


procedure TFormMain.FormCreate(Sender: TObject);
begin

  //language from ExeName.msg:
  if wcmn_language_test('') then wcmn_language_form(Self);

  TabbedNotebook1.PageIndex := 0;

  {Если размеры не из файла:}
  SizeGrid.RowCount := 2;
  with SizeGrid.Rows[0] do begin
    if wcmn_language_file_name='' then begin
      Strings[0] := 'Левые';
      Strings[1] := 'Верхние';
      Strings[2] := 'Ширина';
      Strings[3] := 'Высота';
    end else begin
      Strings[0] := 'Left';
      Strings[1] := 'Top';
      Strings[2] := 'Width';
      Strings[3] := 'Height';
    end;
  end;
  with SizeGrid.Rows[1] do begin
    Strings[0] := '0';
    Strings[1] := '0';
    Strings[2] := '210';
    Strings[3] := '297';
  end;

  Ini.RForm(Self);
  ReadIniFile;

  XobDefault.Enabled:= XobList.Items.Count = 0;
  Check_GCX_dm.Checked := FALSE;//default!!!!!
  MemoXobInfo.Visible:=Rg_mode.ItemIndex=1;
  XobList.Visible:=Rg_mode.ItemIndex=0;

  help_menu_set_ids;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  try
    Ini.WForm(Self);
    WriteIniFile;
  except
    Tell('EXCEPTION in FormMain.FormDestroy');
  end;

  dmw_dde_Abort;   //???
end;


procedure TFormMain.GetRowClick(Sender: TObject);
var RowInd: Longint; Row: TStrings;
begin
  RowInd := SizeGrid.Selection.Top;
  if RowInd<=0 then exit;
  Row := SizeGrid.Rows[RowInd];

  px0.text := Row.Strings[0];
  py0.text := Row.Strings[1];
  pw.text  := Row.Strings[2];
  ph.text  := Row.Strings[3];
end;


procedure TFormMain.PutRowClick(Sender: TObject);
var RowInd, i: longint;
begin
  with SizeGrid do begin
    RowCount := RowCount + 1;           {new row}

    RowInd := Selection.Top;            {selected row}
    if RowInd<=0 then RowInd := 1;
    {inc(RowInd);}                        {next row; first=A4}

    if (RowInd<=RowCount-2) then for i:=RowCount-2 downto RowInd do
      Rows[i+1] := Rows[i];

    Rows[RowInd].Strings[0] := px0.text;
    Rows[RowInd].Strings[1] := py0.text;
    Rows[RowInd].Strings[2] := pw.text;
    Rows[RowInd].Strings[3] := ph.text;

  end; {with SizeGrid}
end;


procedure TFormMain.DelRowClick(Sender: TObject);
var RowInd, i: longint;
begin
  with SizeGrid do begin

    RowInd := Selection.Top;            {selected row}
    if RowInd<=0 then exit;

    if (RowInd<=RowCount-2) then for i:=RowInd to RowCount-2 do
      Rows[i] := Rows[i+1];

    RowCount := RowCount - 1;           {del last row}
  end; {with SizeGrid}
end;


procedure TFormMain.ButtonScaleClick(Sender: TObject);
begin
  EditScale.Text := IntToStr(msw_MapScale);
end;


procedure TFormMain.OutFileClearClick(Sender: TObject);
begin
  AiFileLabel.Caption := '';
  AiFileLabel.Hint := AiFileLabel.Caption;
end;


procedure TFormMain.MsRepeatItemClick(Sender: TObject);
var dmpath: string;
begin
  MsRepeatItem.Visible:=TRUE;//!
  MsRepeatItemClickResult:=false;

  if XobList.Items.Count<=0 then begin
    Tell(msgs[0]);
    exit;
  end;

  if (ColSep.Checked) then begin
    if (not ExecuteCmdFile) or CmdFile_Show_ColSepDlg then begin
      CmdFile_Show_ColSepDlg:=false;//!
      if ColSepDlg.ShowModal=mrCancel then exit;
    end;
  end;

  case ModeGroup.ItemIndex of
      0: ;                       {просмотр}
    1,2: if FormPrnCnv.ShowModal=mrCancel then exit; {GS-печать, конвертирование}
      3: ;                        {Win-печать}
      4: ;//Tiffs for Web
  end; {case}

  cmn_Tiffs_for_Web := ModeGroup.ItemIndex=4;//=>ОЖИДАНИЕ в msw_x_render!!!
  try

    //FormXM.Count определено после DmCopyCustom(msw_x.pas):
    if StoreToAbc then begin
      if Check_dlltest.Checked then Tellf('mapprn: %d',[mapprn_dll_test])
      else MsRepeatItemClickResult := msw_xm_render;//=>msw_x_render=>ps-file
    end;

    //ps-file --> Tiffs for Web:
    if MsRepeatItemClickResult
    and (ModeGroup.ItemIndex=4){Tiffs for Web}
    and (AiFileLabel.Caption<>'')
    then begin
      if _webcmn_webmaps_process
      then dmpath:=_webcmn_dmpath
      else dmpath:=DMW.ActiveMap;

      WebTif1.ps_to_tifs(CheckBoxPNG.Checked, dmpath,AiFileLabel.Caption, cmn_mscale,
                                cmn_a,cmn_b, abc.pw,abc.ph, TRUE{_wait});
    end;
  finally
    cmn_Tiffs_for_Web:=FALSE;//default!
  end;
end;

//////////////////////////////////////////////////////////


procedure TFormMain.PSFileExport_pdfClick(Sender: TObject);
begin
  if not OpenPs.Execute then exit;//!
  Form_export.export_pdf(OpenPs.FileName);  
end;

procedure TFormMain.XobDefaultClick(Sender: TObject);
var
 smap, sobj, gcDir, gcFile:AnsiString;
begin
 smap:=Dmw.ActiveMap;
 if smap = '' then begin
  Tell('Отсутствует активная карта');
  exit;
 end;
 sobj:=DmObjName(smap);
 gcDir:=UpperDir(wcmn_file_dir0(GsOptDlg.LibLabel.Caption))+sobj;
 gcFile:=ChangeFileExt(gcDir+'\'+sobj, '.gc');
 if not FileExists(gcFile) then begin
   Tell('Не найден классификатор печати:' +gcFile);
   exit;
 end;

 XobDefault.Enabled:=false;
 XobList.Items.Add(gcFile);
 gcFile:=ChangeFileExt(gcFile, '.gcx');
 if FileExists(gcFile) then begin
   XobList.Items.Add(gcFile);
 end;

end;

procedure TFormMain.Rg_modeClick(Sender: TObject);
begin
  MemoXobInfo.Visible:=Rg_mode.ItemIndex=1;
  XobList.Visible:=Rg_mode.ItemIndex=0;
end;

procedure TFormMain.PSFileExport_tifClick(Sender: TObject);
begin
  if not OpenPs.Execute then exit;//!
  Form_export.export_tif(OpenPs.FileName);
end;

//////////////////////////////////////////////////////////


procedure TFormMain.PSFileItemClick(Sender: TObject);
begin
  if not OpenPs.Execute then exit;//!
  PrintDlg.FileName := OpenPs.FileName;
  PrintDlg.ShowModal; {in "msw_ps.pas"}
end;

procedure TFormMain.ExitItemClick(Sender: TObject);
begin
end;

procedure TFormMain.ts5ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TFormMain.XobClearClick(Sender: TObject);
begin
  if TellYN(msgs[5]) then begin
    XobList.Clear;
    XobDefault.Enabled:=true;
  end
end;

procedure TFormMain.XobDelItemClick(Sender: TObject);
begin
  with XobList do begin
    if ItemIndex<0 then exit;
    if TellYN(msgs[5]) then begin
          Items.Delete(ItemIndex);
          XobDefault.Enabled:=Items.Count = 0;
        end;
  end;
end;

procedure TFormMain.XobAddItemClick(Sender: TObject);
var last_xob: string;
begin
  with XobList do
    if Items.Count>0 then last_xob:=Items[Items.Count-1]
    else last_xob:='';

  with OpenGc do begin
    if last_xob<>'' then InitialDir:=wcmn_file_dir0(last_xob)
    else
      if InitialDir='' then InitialDir:=UpperDir(wcmn_file_dir0(GsOptDlg.LibLabel.Caption));

    if Execute then begin
      XobList.Items.Add(FileName);
      XobDefault.Enabled:=false;
      InitialDir:=wcmn_file_dir0(FileName);
    end;
  end;
end;

procedure TFormMain.XobInsertItemClick(Sender: TObject);
begin
  if XobList.ItemIndex<0 then exit;
  if OpenGc.Execute then XobList.Items.Insert(XobList.ItemIndex, OpenGc.FileName);
end;

procedure TFormMain.PsCfgItemClick(Sender: TObject);
begin
  GsOptDlg.ShowModal;
end;

procedure TFormMain.MapIncludeItemClick(Sender: TObject);
begin
  MapIncludeItem.Checked := not MapIncludeItem.Checked;
end;

procedure TFormMain.CmdFileItemClick(Sender: TObject);
var fcmd: TCmdFile;
begin
  if OpenCmd.Execute then begin
    fcmd:=TCmdFile.Create;
    try
      if fcmd.Execute(OpenCmd.FileName)
      then Tellf(msgs[6],[OpenCmd.FileName])
      else Tellf(msgs[7],[OpenCmd.FileName])
    finally
      fcmd.free;
    end;{try}
  end;
end;

procedure TFormMain.DmRepeatItemClick(Sender: TObject);
begin
  if DmCopyCustom
  then MsRepeatItemClick(Sender)
  else Tell('DmCopy: Fail');
end;


procedure TFormMain.RastersItemClick(Sender: TObject);
begin
  if not (_webmaps1.ShowModal=mrOk) then EXIT;//!

  ////////////////////////////////////////////
  // элементы гл. формы и cmn-параметры:
  ////////////////////////////////////////////
  ModeGroup.ItemIndex:=4;//TiffsForWeb
  CheckBoxPNG.Checked:=FALSE;//tif
  AiFileLabel.Caption:='';//
  MultiMsGroup.ItemIndex:=0;//нет вставок
  ColSep.Checked:=FALSE;//нет цветоделения
  PortGroup.ItemIndex:=2;//с выч. страницы
  EditZoom.Text:='1';//
  cmn_zoom:=1;
  cmn_use_map_include:=FormMain.MapIncludeItem.Checked;//?
  ////////////////////////////////////////////

  _webcmn_webmaps_process:=TRUE;//!
  try
    _webcmn_Altpath:=TmpDir+'Mss_AltProject_Tmp.txt';
    _webmaps1._webmaps_process(-1);
  finally
    AiFileLabel.Caption:='';//!
    _webcmn_webmaps_process:=FALSE;//!
  end;
end;


procedure TFormMain.N4Click(Sender: TObject);
begin
   AboutForm.ShowModal;
end;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=112{F1} then try
(*
    if ActiveControl.ClassName='TMenuItem' then begin
      if ActiveControl.HelpContext>0
      then ;
    end else
*)
(*
    case TabbedNotebook1.PageIndex of
      0: Application.HelpContext(_help_main_general);
      //0: Application.HelpCommand(HELP_CONTEXT, _help_main_general);
      1: Application.HelpCommand(HELP_CONTEXT, _help_main_page);
      2: Application.HelpCommand(HELP_CONTEXT, _help_main_rect);
      3: Application.HelpCommand(HELP_CONTEXT, _help_main_opt);
      4: Application.HelpCommand(HELP_CONTEXT, _help_main_size);
    end;//case
*)
  finally
    Key:=0;//!
  end;//F1
end;

procedure TFormMain.XobListMeasureItem(Control: TWinControl; Index: Integer;
  var AHeight: Integer);
begin

end;

end.
