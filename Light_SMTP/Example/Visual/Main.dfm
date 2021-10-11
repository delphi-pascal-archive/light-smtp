object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Light SMTP 2.2 Example - '#1041#1091#1083#1072#1081' '#1053#1080#1082#1080#1090#1072
  ClientHeight = 487
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 9
    Width = 29
    Height = 13
    Caption = #1050#1086#1084#1091':'
  end
  object Label2: TLabel
    Left = 15
    Top = 54
    Width = 28
    Height = 13
    Caption = #1058#1077#1084#1072':'
  end
  object Label3: TLabel
    Left = 15
    Top = 195
    Width = 71
    Height = 13
    Caption = #1058#1077#1082#1089#1090' '#1087#1080#1089#1100#1084#1072':'
  end
  object Label8: TLabel
    Left = 16
    Top = 98
    Width = 114
    Height = 13
    Caption = #1055#1088#1080#1089#1086#1077#1076#1077#1085#1080#1090#1100' '#1092#1072#1081#1083#1099':'
  end
  object SpeedButton1: TSpeedButton
    Left = 370
    Top = 113
    Width = 23
    Height = 22
    Caption = '+'
    OnClick = SpeedButton1Click
  end
  object Label4: TLabel
    Left = 15
    Top = 322
    Width = 106
    Height = 13
    Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103' '#1089#1077#1088#1074#1077#1088#1072':'
  end
  object Label5: TLabel
    Left = 16
    Top = 405
    Width = 136
    Height = 13
    Caption = #1055#1088#1086#1075#1088#1077#1089#1089' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1092#1072#1081#1083#1072':'
  end
  object Label11: TLabel
    Left = 402
    Top = 9
    Width = 57
    Height = 13
    Caption = #1050#1086#1087#1080#1103' '#1076#1083#1103':'
  end
  object SpeedButton2: TSpeedButton
    Left = 370
    Top = 137
    Width = 23
    Height = 22
    Caption = '-'
    OnClick = SpeedButton2Click
  end
  object Label13: TLabel
    Left = 16
    Top = 453
    Width = 98
    Height = 13
    Caption = 'For all Delphi society'
    Enabled = False
  end
  object Label14: TLabel
    Left = 16
    Top = 466
    Width = 114
    Height = 13
    Caption = #169' '#1041#1091#1083#1072#1081' '#1053#1080#1082#1080#1090#1072', 2010'
    Enabled = False
  end
  object SendToBox: TEdit
    Left = 16
    Top = 27
    Width = 377
    Height = 21
    TabOrder = 0
    Text = 'myfriend@mail.ru'
  end
  object SubjectBox: TEdit
    Left = 15
    Top = 70
    Width = 378
    Height = 21
    TabOrder = 1
    Text = #1050#1083#1072#1089#1089#1085#1099#1081' '#1082#1086#1084#1087#1086#1085#1077#1085#1090
  end
  object SendBtn: TButton
    Left = 239
    Top = 454
    Width = 75
    Height = 25
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    TabOrder = 2
    OnClick = SendBtnClick
  end
  object ExitBtn: TButton
    Left = 319
    Top = 454
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 3
    OnClick = ExitBtnClick
  end
  object ProgressBar: TProgressBar
    Left = 15
    Top = 424
    Width = 378
    Height = 17
    TabOrder = 4
  end
  object LogList: TMemo
    Left = 15
    Top = 341
    Width = 378
    Height = 58
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object GroupBox1: TGroupBox
    Left = 403
    Top = 206
    Width = 170
    Height = 273
    Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '
    TabOrder = 6
    object Label6: TLabel
      Left = 13
      Top = 29
      Width = 68
      Height = 13
      Caption = 'SMTP '#1089#1077#1088#1074#1077#1088':'
    end
    object Label7: TLabel
      Left = 13
      Top = 74
      Width = 29
      Height = 13
      Caption = #1055#1086#1088#1090':'
    end
    object Label9: TLabel
      Left = 13
      Top = 120
      Width = 34
      Height = 13
      Caption = #1051#1086#1075#1080#1085':'
    end
    object Label10: TLabel
      Left = 13
      Top = 165
      Width = 41
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100':'
    end
    object Label12: TLabel
      Left = 13
      Top = 211
      Width = 70
      Height = 13
      Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103':'
    end
    object SmtpServer: TEdit
      Left = 13
      Top = 48
      Width = 144
      Height = 21
      TabOrder = 0
      Text = 'smtp.mail.ru'
    end
    object SmtpPort: TEdit
      Left = 13
      Top = 94
      Width = 144
      Height = 21
      TabOrder = 1
      Text = '2525'
    end
    object LoginBox: TEdit
      Left = 13
      Top = 139
      Width = 144
      Height = 21
      TabOrder = 2
      Text = 'username@mail.ru'
    end
    object PassBox: TEdit
      Left = 13
      Top = 185
      Width = 144
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
      Text = 'password'
    end
    object Auth: TComboBox
      Left = 12
      Top = 230
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 4
      Text = #1051#1086#1075#1080#1085'-'#1055#1072#1088#1086#1083#1100
      Items.Strings = (
        #1053#1077#1090
        'Plain-'#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
        #1051#1086#1075#1080#1085'-'#1055#1072#1088#1086#1083#1100)
    end
  end
  object CopyTo: TMemo
    Left = 402
    Top = 27
    Width = 170
    Height = 158
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object Files: TListBox
    Left = 16
    Top = 114
    Width = 349
    Height = 71
    ItemHeight = 13
    TabOrder = 8
  end
  object MsgBox: TMemo
    Left = 15
    Top = 211
    Width = 378
    Height = 105
    Lines.Strings = (
      #1042' '#1086#1073#1085#1086#1074#1083#1077#1085#1085#1086#1081' '#1074#1077#1088#1089#1080#1080' '#1073#1099#1083#1080' '#1076#1086#1073#1072#1074#1083#1077#1085#1099' '#1088#1072#1079#1083#1080#1095#1085#1099#1077' '#1086#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080' '
      #1080#1089#1082#1083#1102#1095#1077#1085#1080#1081', '#1086#1087#1090#1080#1084#1080#1079#1080#1088#1086#1074#1072#1085' '#1082#1086#1076', '#1072' '#1090#1072#1082' '#1078#1077' '#1085#1086#1074#1099#1081' '#1079#1072#1075#1086#1083#1086#1074#1086#1082' '#1087#1080#1089#1100#1084#1072' '
      '-  X-Mailer'
      ''
      #1055#1080#1096#1080#1090#1077' '#1074#1072#1096#1080' '#1079#1072#1084#1077#1095#1072#1085#1080#1103' '#1080' '#1087#1088#1077#1076#1083#1086#1076#1077#1085#1080#1103' '#1085#1072' bulka@sa-sec.org')
    ScrollBars = ssVertical
    TabOrder = 9
  end
  object AsHtml: TCheckBox
    Left = 96
    Top = 192
    Width = 129
    Height = 17
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1082#1072#1082' HTML'
    TabOrder = 10
  end
  object OpenDialog: TOpenDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' | *.*'
    Left = 488
    Top = 50
  end
  object XPManifest1: TXPManifest
    Left = 520
    Top = 50
  end
  object SMTP: TLightSMTP
    XMailer = 'LighSMTP Mailer'
    Port = 0
    CharSet = 'Windows-1251'
    Authorization = atAuthNone
    ContentType = ctTextHTML
    OnServerReceive = SMTPServerReceive
    OnSendProgress = SMTPSendProgress
    Left = 456
    Top = 48
  end
end
