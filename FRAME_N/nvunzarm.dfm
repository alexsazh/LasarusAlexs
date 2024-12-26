object FtuneZaram: TFtuneZaram
  Left = 294
  Height = 277
  Top = 110
  Width = 644
  Caption = 'Настройка дополнительных текстов'
  ClientHeight = 277
  ClientWidth = 644
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  LCLVersion = '2.2.0.4'
  object Label1: TLabel
    Left = 24
    Height = 13
    Top = 8
    Width = 188
    Caption = 'Элементы зарамочного офромления'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Height = 145
    Top = 24
    Width = 369
    Color = clWindow
    Columns = <    
      item
        Title.Caption = 'КОД'
        Width = 58
        FieldName = 'КОД'
      end    
      item
        Title.Caption = 'ТИП'
        Width = 29
        FieldName = 'ТИП'
      end    
      item
        Title.Caption = 'Размещение'
        Width = 68
        FieldName = 'LOCTYPE'
      end    
      item
        Title.Caption = 'Вертикально'
        Width = 62
        FieldName = 'Вертикально'
      end    
      item
        Title.Caption = 'Горизонтально'
        Width = 39
        FieldName = 'Горизонтально'
      end    
      item
        Title.Caption = 'Выравнивание'
        Width = 78
        FieldName = 'Выравнивание'
      end>
    DataSource = DS_Frame
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowEditor, dgConfirmDelete]
    TabOrder = 0
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
  end
  object DBNavigator1: TDBNavigator
    Left = 64
    Height = 25
    Top = 176
    Width = 234
    BevelOuter = bvNone
    ChildSizing.EnlargeHorizontal = crsScaleChilds
    ChildSizing.EnlargeVertical = crsScaleChilds
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 100
    ClientHeight = 25
    ClientWidth = 234
    DataSource = DS_Frame
    Options = []
    TabOrder = 1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
  end
  object DBMemText: TDBMemo
    Left = 392
    Height = 33
    Top = 32
    Width = 185
    DataField = 'Текст'
    DataSource = DS_Frame
    TabOrder = 2
  end
  object Button1: TButton
    Left = 392
    Height = 25
    Top = 72
    Width = 121
    Caption = 'Выбор кода и типа'
    OnClick = Button1Click
    TabOrder = 3
  end
  object DS_Frame: TDataSource
    DataSet = SQLQuery_Frame
    Left = 304
    Top = 56
  end
  object ODBCConnFrame: TODBCConnection
    Connected = False
    LoginPrompt = False
    KeepConnection = False
    Params.Strings = (
      'DBQ=d:\map\ini\Frame_N.mdb'
      'Locale Identifier=1031'
      'ExtendedAnsiSQL=1'
      'CHARSET=ansi'
    )
    Transaction = SQLTransaction1
    Driver = 'Microsoft Access Driver (*.mdb)'
    Left = 392
    Top = 176
  end
  object SQLQuery_layout: TSQLQuery
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'ID_LAYOUT'
        Attributes = [faReadonly]
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'Выравнивание'
        DataType = ftString
        Precision = -1
        Size = 10
      end>
    Database = ODBCConnFrame
    Transaction = SQLTransaction1
    SQL.Strings = (
      'select * from ТипВыравнивания'
      ''
    )
    Params = <>
    Macros = <>
    UsePrimaryKeyAsKey = False
    Left = 440
    Top = 112
  end
  object SQLQuery_Types: TSQLQuery
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'ID_TYPE'
        Attributes = [faReadonly]
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'ТИП РАСПОЛОЖЕНИЯ'
        DataType = ftString
        Precision = -1
        Size = 32
      end>
    Database = ODBCConnFrame
    Transaction = SQLTransaction1
    SQL.Strings = (
      'select * from Расположение'
      ''
    )
    Params = <>
    Macros = <>
    UsePrimaryKeyAsKey = False
    Left = 464
    Top = 168
  end
  object SQLQuery_Frame: TSQLQuery
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'ID'
        Attributes = [faReadonly]
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'ID_TYPE'
        DataType = ftInteger
        Precision = -1
      end    
      item
        Name = 'ID_LAYOUT'
        DataType = ftInteger
        Precision = -1
      end    
      item
        Name = 'Вертикально'
        DataType = ftFloat
        Precision = -1
      end    
      item
        Name = 'Горизонтально'
        DataType = ftFloat
        Precision = -1
      end    
      item
        Name = 'КОД'
        DataType = ftString
        Precision = -1
        Size = 8
      end    
      item
        Name = 'Текст'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'ТИП'
        DataType = ftWord
        Precision = -1
      end>
    Database = ODBCConnFrame
    Transaction = SQLTransaction1
    SQL.Strings = (
      'select ID, ID_TYPE, ID_LAYOUT, [Вертикально], [Горизонтально], [КОД], [Текст], [ТИП] from [Элементы Оформление]'
      ''
    )
    Params = <>
    Macros = <>
    UsePrimaryKeyAsKey = False
    Left = 504
    Top = 224
  end
  object SQLTransaction1: TSQLTransaction
    Active = False
    Database = ODBCConnFrame
    Left = 577
    Top = 157
  end
end
