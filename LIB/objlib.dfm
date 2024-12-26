object FormObjLib: TFormObjLib
  Left = 0
  Top = 0
  Caption = 'FormObjLib'
  ClientHeight = 173
  ClientWidth = 231
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\WORK\'#1062#1048#1055'\to Rdte' +
      'x\'#1041#1062#1041#1050'-'#1042#1099#1076#1088#1080#1085#1086'_export.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 8
    Top = 8
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    Left = 48
    Top = 8
  end
end
