(*
  Строятся окошки редактирования aMyTab.Fields на панели aPanel
  Подстройка размеров формы - вовне - используя out dPanelSize in Create
  Ссздание/уничтожение окошек - на TMyTabPanel-Create/Destroy
*)
unit mytabpanel; interface

uses
  Windows, StdCtrls, ExtCtrls, DB, DBCtrls,
  list, mytab;


type
  TMyLabel = TLabel;
  TMyDBEdit = TDBEdit;

  TMyTabPanel = class
  private
    FMyTab: TMyTab;//таблица
    FPanel: TPanel;//пространство расположения окошек
    FLabels: TClassList;//of TMyLabel - заголовки
    FEdits: TClassList;//of TMyDBEdit - значения
    procedure MakeComponents(var dPanelSize: TPoint);//OnCreate: FPanel+FMyTab->новые объекты
  public
    constructor Create(aMyTab: TMyTab; aPanel: TPanel; var dPanelSize: TPoint);//создание окошек
    destructor Destroy; override;//удаление окошек

    property MyTab: TMyTab read FMyTab;
    property Panel: TPanel read FPanel;
  end;


implementation

uses
  Types{func Point},
  wcmn, mytabfield;


procedure TMyTabPanel.MakeComponents(var dPanelSize: TPoint);
const
  Marginx: integer = 20;//поля слева, посередине и справа
  Marginy: integer = 20;//поля сверху и снизу
  EditWidthDefault: integer = 128;//ширина окошка TMyDBEdit
var
  i: integer;
  aLabel: TMyLabel; aEdit: TMyDBEdit;
  xLeft1: integer;//левый край окошек "edits"
  xLeft2: integer;//правый край панели
  dTop: integer;//шаг по Y
begin
  dPanelSize:=Point(0,0);//default

  //dTop:
  aEdit:=TMyDBEdit.Create(nil);
  try
    dTop:=aEdit.Height+3;//default aEdit.Height=19
  finally
    aEdit.Free;
  end;

  //FLabels, xLeft1:
  xLeft1:=0;
  if FMyTab.Fields.Count>0 then for i:=0 to FMyTab.Fields.Count-1 do begin
    aLabel:=TMyLabel.Create(nil);
    FLabels.Add(aLabel);
    with aLabel do begin
      Parent:=FPanel;//движение - вместе
      Caption:=FMyTab.Fields[i].Caption;
      Left:=Marginx;
      Top:=Marginy+i*dTop;
      if Marginx+Width > xLeft1 then xLeft1 := Marginx+Width;//after Width(Caption)
    end;
  end;//for i
  xLeft1 := xLeft1 + Marginx;//+поля

  //FEdits, xLeft2:
  xLeft2:=0;
  if FMyTab.Fields.Count>0 then for i:=0 to FMyTab.Fields.Count-1 do begin
    aEdit:=TMyDBEdit.Create(nil);
    FEdits.Add(aEdit);
    with aEdit do begin
      Parent:=FPanel;//движение - вместе
      DataSource:=FMyTab.DataSource;
      DataField:=FMyTab.Fields[i].FieldName;
      Left:=xLeft1;
      Top:=Marginy+i*dTop;
      Width:=EditWidthDefault;
      if xLeft1+Width > xLeft2 then xLeft2 := xLeft1+Width;//after Width
    end;
  end;//for i
  xLeft2 := xLeft2 + Marginx;//+поля

  //dPanelSize:
  dPanelSize.X := xLeft2 - FPanel.Width;
  dPanelSize.Y := Marginy*2 + dTop*FEdits.Count - FPanel.Height;
end;

//------------------------------------------------------------

constructor TMyTabPanel.Create(aMyTab: TMyTab; aPanel: TPanel; var dPanelSize: TPoint);
begin
  FLabels:=TClassList.New;
  FEdits:=TClassList.New;

  FMyTab:=aMyTab;
  FPanel:=aPanel;
  try
    MakeComponents(dPanelSize);//=>FLabels,FEdits
  except
    Tellf('TMyTabPanel.Create: Ошибка создания окошек для "%s"',[aMyTab.TabCaption]);
    dPanelSize:=Point(0,0);
  end;
end;

destructor TMyTabPanel.Destroy;
var i: integer;
begin
  if FLabels.Count>0 then for i:=0 to FLabels.Count-1 do
    with FLabels[i] as TMyLabel do begin
      Parent:=nil;//=>RemoveControl
      Visible:=false;//!
    end;

  if FEdits.Count>0 then for i:=0 to FEdits.Count-1 do
    with FEdits[i] as TMyDBEdit do begin
      Parent:=nil;//=>RemoveControl
      Visible:=false;//!
    end;

  FEdits.Free;
  FLabels.Free;
end;


end.
