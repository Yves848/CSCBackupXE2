object fProgress: TfProgress
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Progress'
  ClientHeight = 129
  ClientWidth = 634
  Color = clWindow
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lFileName: TLabel
    Left = 23
    Top = 8
    Width = 592
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = 'lFileName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lFileNum: TLabel
    Left = 23
    Top = 58
    Width = 592
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'lFileNum'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object pbArchive: TAdvSmoothProgressBar
    Left = 23
    Top = 99
    Width = 592
    Height = 17
    Step = 10.000000000000000000
    Maximum = 100.000000000000000000
    Appearance.BackGroundFill.Color = 15724527
    Appearance.BackGroundFill.ColorTo = 14145495
    Appearance.BackGroundFill.ColorMirror = clNone
    Appearance.BackGroundFill.ColorMirrorTo = clNone
    Appearance.BackGroundFill.GradientType = gtVertical
    Appearance.BackGroundFill.GradientMirrorType = gtSolid
    Appearance.BackGroundFill.BorderColor = clSilver
    Appearance.BackGroundFill.Rounding = 6
    Appearance.BackGroundFill.ShadowOffset = 0
    Appearance.BackGroundFill.Glow = gmNone
    Appearance.ProgressFill.Color = 8421631
    Appearance.ProgressFill.ColorTo = clRed
    Appearance.ProgressFill.ColorMirror = clNone
    Appearance.ProgressFill.ColorMirrorTo = 16767936
    Appearance.ProgressFill.GradientType = gtVertical
    Appearance.ProgressFill.GradientMirrorType = gtVertical
    Appearance.ProgressFill.BorderColor = 16765357
    Appearance.ProgressFill.Rounding = 6
    Appearance.ProgressFill.ShadowOffset = 0
    Appearance.ProgressFill.Glow = gmNone
    Appearance.Font.Charset = DEFAULT_CHARSET
    Appearance.Font.Color = clWindowText
    Appearance.Font.Height = -11
    Appearance.Font.Name = 'Tahoma'
    Appearance.Font.Style = []
    Appearance.ProgressFont.Charset = DEFAULT_CHARSET
    Appearance.ProgressFont.Color = clWindowText
    Appearance.ProgressFont.Height = -11
    Appearance.ProgressFont.Name = 'Tahoma'
    Appearance.ProgressFont.Style = []
    Appearance.ValueFormat = '%.0f%%'
    Version = '1.9.0.2'
    TMSStyle = 4
  end
  object pbItemProgress: TAdvSmoothProgressBar
    Left = 23
    Top = 35
    Width = 592
    Height = 17
    Step = 10.000000000000000000
    Maximum = 100.000000000000000000
    Appearance.BackGroundFill.Color = 15724527
    Appearance.BackGroundFill.ColorTo = 14145495
    Appearance.BackGroundFill.ColorMirror = clNone
    Appearance.BackGroundFill.ColorMirrorTo = clNone
    Appearance.BackGroundFill.GradientType = gtVertical
    Appearance.BackGroundFill.GradientMirrorType = gtSolid
    Appearance.BackGroundFill.BorderColor = clSilver
    Appearance.BackGroundFill.Rounding = 6
    Appearance.BackGroundFill.ShadowOffset = 0
    Appearance.BackGroundFill.Glow = gmNone
    Appearance.ProgressFill.Color = 8454016
    Appearance.ProgressFill.ColorTo = clGreen
    Appearance.ProgressFill.ColorMirror = clNone
    Appearance.ProgressFill.ColorMirrorTo = clNone
    Appearance.ProgressFill.GradientType = gtVertical
    Appearance.ProgressFill.GradientMirrorType = gtVertical
    Appearance.ProgressFill.BorderColor = 16765357
    Appearance.ProgressFill.Rounding = 6
    Appearance.ProgressFill.ShadowOffset = 0
    Appearance.ProgressFill.Glow = gmNone
    Appearance.Font.Charset = DEFAULT_CHARSET
    Appearance.Font.Color = clWindowText
    Appearance.Font.Height = -11
    Appearance.Font.Name = 'Tahoma'
    Appearance.Font.Style = []
    Appearance.ProgressFont.Charset = DEFAULT_CHARSET
    Appearance.ProgressFont.Color = clWindowText
    Appearance.ProgressFont.Height = -11
    Appearance.ProgressFont.Name = 'Tahoma'
    Appearance.ProgressFont.Style = []
    Appearance.ValueFormat = '%.0f%%'
    Version = '1.9.0.2'
    TMSStyle = 4
  end
end
