object FormDir: TFormDir
  Left = 273
  Top = 238
  Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103
  ClientHeight = 276
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object DirectoryListBox1: TDirectoryListBox
    Left = 0
    Top = 35
    Width = 239
    Height = 193
    Align = alClient
    DirLabel = LabelDir
    ItemHeight = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitTop = 45
    ExplicitWidth = 289
    ExplicitHeight = 174
  end
  object Panel1: TPanel
    Left = 0
    Top = 228
    Width = 312
    Height = 48
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 244
    object LabelDir: TLabel
      Left = 16
      Top = 16
      Width = 175
      Height = 13
      Caption = 'C:\Documents and Settings\Andreas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 312
    Height = 35
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 416
    object DriveComboBox1: TDriveComboBox
      Left = 16
      Top = 8
      Width = 145
      Height = 19
      DirList = DirectoryListBox1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 239
    Top = 35
    Width = 73
    Height = 193
    Align = alRight
    TabOrder = 3
    ExplicitLeft = 231
    object BitBtnYes: TBitBtn
      Left = 6
      Top = 32
      Width = 60
      Height = 25
      Caption = #1044#1072
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtnNo: TBitBtn
      Left = 6
      Top = 126
      Width = 60
      Height = 25
      Caption = #1053#1077#1090
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
