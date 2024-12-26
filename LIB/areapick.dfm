object FormAreaPick: TFormAreaPick
  Left = 362
  Top = 269
  Caption = 'FormAreaPick'
  ClientHeight = 156
  ClientWidth = 258
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
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    Left = 32
    Top = 24
  end
end
