object FormW: TFormW
  Left = 438
  Top = 490
  Width = 159
  Height = 117
  Caption = 'Word'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object WordApplication1: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = True
    Left = 4
    Top = 4
  end
  object WordDocument1: TWordDocument
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 36
    Top = 4
  end
  object WordDocument2: TWordDocument
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 36
    Top = 36
  end
end
