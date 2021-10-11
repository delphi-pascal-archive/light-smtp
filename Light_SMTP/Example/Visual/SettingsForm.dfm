object Settings: TSettings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 271
  ClientWidth = 184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 225
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080':'
    TabOrder = 0
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 68
      Height = 13
      Caption = 'SMTP '#1089#1077#1088#1074#1077#1088':'
    end
    object Label5: TLabel
      Left = 16
      Top = 72
      Width = 29
      Height = 13
      Caption = #1055#1086#1088#1090':'
    end
    object Label6: TLabel
      Left = 16
      Top = 120
      Width = 34
      Height = 13
      Caption = #1051#1086#1075#1080#1085':'
    end
    object Label7: TLabel
      Left = 16
      Top = 168
      Width = 41
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100':'
    end
    object _smtpserver: TEdit
      Left = 16
      Top = 40
      Width = 137
      Height = 21
      TabOrder = 0
      Text = 'smtp.mail.ru'
    end
    object _smtpport: TEdit
      Left = 16
      Top = 88
      Width = 137
      Height = 21
      TabOrder = 1
      Text = '2525'
    end
    object _login: TEdit
      Left = 16
      Top = 136
      Width = 137
      Height = 21
      TabOrder = 2
      Text = 'username@domain.ru'
    end
    object _pass: TEdit
      Left = 16
      Top = 184
      Width = 137
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
      Text = 'password'
    end
  end
  object Button1: TButton
    Left = 101
    Top = 239
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
end
