object DbTab1: TDbTab1
  Left = 229
  Top = 173
  Caption = 'DbTab1'
  ClientHeight = 245
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Grid: TDBGrid
    Left = 0
    Top = 0
    Width = 328
    Height = 245
    Align = alClient
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = GridDblClick
    OnTitleClick = GridTitleClick
  end
  object DataSet: TADODataSet
    Filtered = True
    AfterScroll = DataSetAfterScroll
    Parameters = <>
    Left = 32
    Top = 64
  end
  object DataSource: TDataSource
    DataSet = DataSet
    Left = 64
    Top = 64
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 120
    Top = 64
    object pm_FindActiveObj: TMenuItem
      Caption = #1053#1072#1081#1090#1080' '#1072#1082#1090#1080#1074#1085#1099#1081' '#1086#1073#1098#1077#1082#1090
      OnClick = pm_FindActiveObjClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object pm_3Dscene: TMenuItem
      Caption = '3D-'#1089#1094#1077#1085#1072
      OnClick = pm_3DsceneClick
    end
  end
end
