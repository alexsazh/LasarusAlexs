unit _webmaps;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType,  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
{$WARNINGS OFF}
  FileCtrl,//TDirectoryListBox
{$WARNINGS ON}
  StdCtrls, ExtCtrls, LLIB, llibx, Menus, ShellCtrls;

type

  { T_webmaps1 }

  T_webmaps1 = class(TForm)
    PanelDir: TPanel;
    PanelDir1: TPanel;
    FileListBox1: TFileListBox;
    Panel2: TPanel;
    ShellTreeView1: TShellTreeView;
    Splitter1: TSplitter;
    LabelDir1: TLabel;//without '\'
    PanelMaps: TPanel;
    PanelDir2: TPanel;
    LabelDir2: TLabel;
    PanelMaps1: TPanel;
    EditScale: TEdit;
    Label1: TLabel;
    ButtonNewMaps: TButton;
    ButtonRasters: TButton;
    FileListBox2: TFileListBox;
    PopupMenu_Files2: TPopupMenu;
    PopupMenu_Files2_rasters: TMenuItem;
    procedure PopupMenu_Files2_rastersClick(Sender: TObject);
    procedure PopupMenu_Files2Popup(Sender: TObject);
    procedure ButtonRastersClick(Sender: TObject);
    procedure ButtonNewMapsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure set_LabelDir2;//LabelDir1 -> LabelDir2
  public
    procedure _webmaps_process(iselect: integer);//iselect<0 - все карты FileListBox2
  end;

var
  _webmaps1: T_webmaps1;//Form

  _webmaps_region: tpl;//область отбора карт (B,L) - FormCreate

implementation

{$R *.lfm}

uses Dmw_ddw, Dmw_use, Wcmn, Runline, Dmlib, Dmwlib, Vlib,
  _webcmn, _webtif, _webmap,
  MSS_WM{MyPickRect}, cmn{пар-ры}, MSW_1{FormMain};


const MC0_subdirname = 'WEB';
//const IMG_subdirname = 'IMG';


procedure T_webmaps1.set_LabelDir2;
var sdir2: string;
begin
  sdir2 := LabelDir1.Caption + '\' + MC0_subdirname + '\';
  LabelDir2.Caption := sdir2;
  if wcmn.DirExists(sdir2)
  then begin FileListBox2.Directory:=sdir2; FileListBox2.Update; end
  else FileListBox2.Clear;
end;


///////////////////////////////////////////////////
// Подготовка карт:
///////////////////////////////////////////////////

function _webmaps_region_read: boolean;
var
  i: integer; p: tnum2; b,l: double;
  offs,lCode: longint; loc: byte; x1,y1,x2,y2: longint;
  oname: ShortString;
begin
  Result:=FALSE;
  _webmaps_region.Clear;//!

  dmw_OffsObject(offs,lCode, loc, x1,y1,x2,y2, @oname[1],255);

  if dmw_open_dm(FALSE{rw}) then try
    if dm_goto_node(offs) then begin

      loc:=dm_Get_Local;
      if loc=3 then begin
        PaFromDmFile(_webmaps_region);
        for i:=0 to _webmaps_region.Count-1 do begin
          p:=_webmaps_region[i];
          dm_L_to_R(Round(p.x),Round(p.y), b,l);
          p:=v_xy(b,l);
          _webmaps_region[i]:=p;
        end;//for i
        Result:=_webmaps_region.Count>3;//!
      end//loc=3
      else Tell('Активный объект не является областью');

    end;//dm_goto_node
  finally
    dmw_done;
  end;
end;

procedure T_webmaps1.ButtonNewMapsClick(Sender: TObject);
var n,i,scale1: integer; path1,path2: string;
begin
  //FileListBox2.Clear;//!!!!!!!!!!!!!!!!!!!
  //FileListBox2.Directory:='';

  //_webmaps_region:
  //dmw_Pick_wm(dmw_wm_object,0,0);//---> MSS_WM
  if not TellYN('Укажите регион на активной карте и нажмите "Да"')
  or not _webmaps_region_read
  then EXIT;//!

  if wcmn.DirExists(LabelDir2.Caption)
  and (FileListBox2.Items.Count>0)
  then begin
    Tellf('Необходимо удалить файлы в поддиректории "%s"',[MC0_subdirname]);
    EXIT;//!
  end;

  //подготовка карт:
  if not wcmn.DirExists(LabelDir2.Caption)
  and not SysUtils.CreateDir(LabelDir2.Caption)
  then begin
    Tell('false in CreateDir --- EXIT');
    EXIT;//!
  end;

  scale1 := ivaldef(EditScale.Text, -1);
  if scale1<0 then begin
    Tell('Ошибка в окне масштаба');
    EXIT;//!
  end;

  dmw_HideMap;//на всякий случай, dmw_BackMap - не нужно
  n:=FileListBox1.Items.Count;
  RunForm.Start('подготовка карт');
  try
  if n>0 then for i:=0 to n-1 do begin
    RunForm.Go2(i,n);
    if RunForm.Cancelled then BREAK;//!

    path1 := LabelDir1.Caption + '\' + FileListBox1.Items[i];
    path2 := LabelDir2.Caption + wcmn_file_name(FileListBox1.Items[i]) + '_MC0' + '.dm';

    if not _webmap_MC0_scale_region(path1,path2, scale1, _webmaps_region)
    then CONTINUE;//!

    //FileListBox2.Items.Add(wcmn_file_nameext(path2));
  end;//for i
  finally
    RunForm.Finish;
    FileListBox2.Directory:=LabelDir2.Caption;
    FileListBox2.Update;
  end;
end;


///////////////////////////////////////////////////
// Создание растров:
///////////////////////////////////////////////////

procedure T_webmaps1._webmaps_process(iselect: integer);
const __dpix = 130;//перекрытие
var
  mscale,n,i,j: integer; dpimin: double; dmpath: string;
  a,b,lwh,WH: TPoint; page{w,h мм},centr: tnum2;
  mpunit{m/unit}: double; f: TextFile;
begin
  dmw_HideMap;//на всякий случай, dmw_BackMap - не нужно

  //пробная карта для списка уровней:
  n:=FileListBox2.Items.Count; if n=0 then EXIT;//!
  if iselect>=0
  then dmpath := LabelDir2.Caption + FileListBox2.Items[iselect]//для списка уровней
  else dmpath := LabelDir2.Caption + FileListBox2.Items[0];//для списка уровней
  if not _webmap_bound(dmpath, mscale, mpunit, a,b, page) then EXIT;//!

  //список уровней:
  if not WebTif1.show_list('Выбор уровней', mscale, page.x,page.y{мм})
  then EXIT;//!

  //минимальный уровень, dpimin:
  dpimin:=-1;
  for i:=0 to WebTif1.List1.Count-1 do
    if WebTif1.List1.Checked[i] then begin
      dpimin:=WebTif1.levelsdpi[i];
      BREAK;//!
    end;
  if dpimin<=0 then EXIT;//!

  //коэффициенты КОРРЕКЦИИ РАМКИ:
  WH.X := Round( (page.x/wcmn_mmpi){дюймы}*dpimin );
  WH.Y := Round( (page.y/wcmn_mmpi){дюймы}*dpimin );
  _webcmn_expand.x := 1+2*__dpix/WH.X;
  _webcmn_expand.y := 1+2*__dpix/WH.Y;

  //создание растров:
  RunForm.Start('создание растров');
  n:=FileListBox2.Items.Count;
  try
  if n>0 then for i:=0 to n-1 do begin
    RunForm.Go2(i,n);
    if RunForm.Cancelled then BREAK;//!

    if (iselect>=0) and (i<>iselect) then CONTINUE;//только 1 карта!!!!!!!!!!!!!

    _webcmn_dmpath := LabelDir2.Caption + FileListBox2.Items[i];
    _webcmn_pspath := wcmn_file_dirname(_webcmn_dmpath) + '.ps';//рядом с картой

    if not _webmap_bound(_webcmn_dmpath, mscale, mpunit, a,b, page) then begin
      Tellf('_webmap_bound(%s)=FALSE - EXIT!',[_webcmn_dmpath]);
      BREAK;//!!!!!!!!!!!!!!!!!!!
    end;

    //КОРРЕКЦИЯ РАМКИ:
    lwh.x:=abs(b.x-a.x); lwh.y:=abs(b.y-a.y);
    centr.x:=(b.x+a.x)/2.; centr.y:=(b.y+a.y)/2.;
    _webcmn_a.x:=Round( centr.x-(lwh.x/2)*_webcmn_expand.x );
    _webcmn_a.y:=Round( centr.y-(lwh.y/2)*_webcmn_expand.y );
    _webcmn_b.x:=Round( centr.x+(lwh.x/2)*_webcmn_expand.x );
    _webcmn_b.y:=Round( centr.y+(lwh.y/2)*_webcmn_expand.y );
    _webcmn_page.x:=page.x*_webcmn_expand.x;
    _webcmn_page.y:=page.y*_webcmn_expand.y;

    //AltProject:
    if ftopen_msg(f, _webcmn_Altpath, 'w')
    then try
      if n>0 then for j:=0 to n-1 do begin
        if j=i then CONTINUE;//!
        System.writeln(f, LabelDir2.Caption + FileListBox2.Items[j]);
      end;//for j
    finally
      ftclose(f);
    end
    else BREAK;//!

    //ВЫПОЛНЕНИЕ (msw_1 + cmn -> mss_wm):
  //  FormMain.AiFileLabel.Caption:=_webcmn_pspath;
  //  FormMain.EditScale.Text:=IntToStr(mscale);
    cmn_mscale:=mscale;
    cmn_upm:=1/mpunit;
    FormWm.MyPickPage(TRUE{_CalcPage}, _webcmn_a, _webcmn_b);//ВЫПОЛНЕНИЕ

    //BREAK;//DEBUG!!!!!!!!!!!!!!!

  end;//for i
  finally
    RunForm.Finish;
  end;
end;


procedure T_webmaps1.ButtonRastersClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


///////////////////////////////////////////////////
// EVENTS:
///////////////////////////////////////////////////

procedure T_webmaps1.FormCreate(Sender: TObject);
var sdir,sdir2: string;
begin
  Ini.RForm(Self);
  sdir:=Ini.RS('Directory1', '');
  if wcmn.DirExists(sdir) then begin
    ShellTreeView1.Path:=sdir;
    sdir2 := sdir + '\' + MC0_subdirname;
    if wcmn.DirExists(sdir2)
    then begin FileListBox2.Directory:=sdir2; FileListBox2.Update; end
    else begin FileListBox2.Directory:=''; FileListBox2.Clear; end;
  end;

  _webmaps_region:=tpl.New;
end;

procedure T_webmaps1.FormDestroy(Sender: TObject);
begin
  _webmaps_region.Free;

  Ini.WForm(Self);
  Ini.WS('Directory1', ShellTreeView1.Path);
end;

procedure T_webmaps1.FormShow(Sender: TObject);
begin
  set_LabelDir2;
end;


procedure T_webmaps1.DirectoryListBox1Change(Sender: TObject);
begin
  set_LabelDir2;
end;


procedure T_webmaps1.PopupMenu_Files2Popup(Sender: TObject);
begin
  PopupMenu_Files2_rasters.Enabled := (FileListBox2.Items.Count>0);
end;

procedure T_webmaps1.PopupMenu_Files2_rastersClick(Sender: TObject);
var iselect: integer;
begin
  if (FileListBox2.Items.Count<=0) or (FileListBox2.ItemIndex<0)
  then EXIT;

  iselect := FileListBox2.ItemIndex;//выбранная карта (>=0)

with FormMain do begin
  ////////////////////////////////////////////
  // элементы гл. формы и cmn-параметры:
  ////////////////////////////////////////////
{  ModeGroup.ItemIndex:=4;//TiffsForWeb
  CheckBoxPNG.Checked:=FALSE;//tif
  AiFileLabel.Caption:='';//
  MultiMsGroup.ItemIndex:=0;//нет вставок
  ColSep.Checked:=FALSE;//нет цветоделения
  PortGroup.ItemIndex:=2;//с выч. страницы
  EditZoom.Text:='1';//
  }
  cmn_zoom:=1;
 // cmn_use_map_include:=FormMain.MapIncludeItem.Checked;//?
  ////////////////////////////////////////////
end;

  _webcmn_webmaps_process:=TRUE;//!
  try
    _webcmn_Altpath:=TmpDir+'Mss_AltProject_Tmp.txt';
    _webmaps1._webmaps_process(iselect);
  finally
   // FormMain.AiFileLabel.Caption:='';//!
    _webcmn_webmaps_process:=FALSE;//!
  end;

end;


end.
