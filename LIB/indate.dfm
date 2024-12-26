object FormDate: TFormDate
  Left = 432
  Top = 348
  Width = 248
  Height = 136
  Caption = 'Дата'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 27
    Height = 13
    Caption = 'День'
  end
  object Label2: TLabel
    Left = 10
    Top = 40
    Width = 33
    Height = 13
    Caption = 'Месяц'
  end
  object Label3: TLabel
    Left = 25
    Top = 64
    Width = 18
    Height = 13
    Caption = 'Год'
  end
  object EditDay: TEdit
    Left = 72
    Top = 16
    Width = 33
    Height = 21
    TabOrder = 0
    Text = '01'
  end
  object EditMonth: TEdit
    Left = 72
    Top = 40
    Width = 33
    Height = 21
    TabOrder = 1
    Text = '01'
  end
  object EditYear: TEdit
    Left = 72
    Top = 64
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '2000'
  end
  object BitBtn1: TBitBtn
    Left = 152
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Да'
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 152
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Нет'
    TabOrder = 4
    Kind = bkCancel
  end
end
