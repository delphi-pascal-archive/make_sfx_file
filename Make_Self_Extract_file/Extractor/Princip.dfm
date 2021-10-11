object frmPrincip: TfrmPrincip
  Left = 244
  Top = 134
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Extractor'
  ClientHeight = 233
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020040000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000011000000000000000000000
    000000000B33333111111111100000000010000000B8B3333333333333000000
    01000000000BFB33333BBBB883100000111000000000BFB33033333338300001
    111111111000B8B33010000000000001111111110000BBB33001000000300011
    111111100000BBB31000100000000013333311000000BBB31000100000000333
    339311111100BBB310001300000003333333333993B0BBB310000100000003B3
    BB333B119333BBB31000010000000BBBBB3377009B33BBB31000010000000BBB
    BB7787001331BBB31000010000000BBBBBFFFF000111BBB31000010000000BBB
    B8FFFF300111BBB310000100000003BBB8FFFFF8B331BBB310000100000003BB
    B8FFF878B311BBB31000100000000BBBB8FFF88B3311BBB3101010000000008B
    BB8FFF8B3331BBB31011000000000008BBB8888B3BBB3BB31011000000000000
    8BBBBBBBBBBBBBB33010000000000000B8BBBBBBBBF8BBBB3000000000000000
    00BBBBBBBBBBBBBBB000000000000000000BBBBBB3BBBBB30000000000000000
    0000003333133000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFE0007FFF80003FF000001FC000001F8000000F0000000E000
    01FEE00000FDC000007FC000007F8000003F8000003F8000003F8000003F8000
    003F8000003F8000003F8000003F8000007F8000007FC00000FFE00000FFF000
    01FFF00003FFFC0007FFFE000FFFFFC07FFFFFFFFFFFFFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 86
    Height = 16
    Caption = 'Path to extract:'
  end
  object SpeedButton1: TSpeedButton
    Left = 248
    Top = 22
    Width = 25
    Height = 23
    Caption = #183#183#183
    Flat = True
    Transparent = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 8
    Top = 56
    Width = 265
    Height = 26
    Caption = 'Extract file'
    Flat = True
    Transparent = False
    OnClick = SpeedButton2Click
  end
  object Prgrs: TGauge
    Left = 5
    Top = 208
    Width = 268
    Height = 22
    Progress = 0
  end
  object Label4: TLabel
    Left = 8
    Top = 190
    Width = 97
    Height = 16
    Caption = 'Fichier en cours:'
  end
  object lblFichier: TLabel
    Left = 112
    Top = 190
    Width = 8
    Height = 16
    Caption = '-'
    FocusControl = edDir
  end
  object edDir: TEdit
    Left = 8
    Top = 22
    Width = 233
    Height = 22
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 89
    Width = 265
    Height = 88
    TabOrder = 1
    object Label2: TLabel
      Left = 59
      Top = 9
      Width = 119
      Height = 16
      Caption = 'Nombre de fichiers :'
    end
    object Label3: TLabel
      Left = 12
      Top = 33
      Width = 171
      Height = 16
      Caption = 'Taille totale decompressee :'
    end
    object lblNbr: TLabel
      Left = 180
      Top = 10
      Width = 7
      Height = 16
      Caption = '0'
    end
    object lblTaux: TLabel
      Left = 180
      Top = 59
      Width = 7
      Height = 16
      Caption = '0'
    end
    object Label5: TLabel
      Left = 43
      Top = 58
      Width = 136
      Height = 16
      Caption = 'Taux de compression :'
    end
    object lblTaille: TLabel
      Left = 180
      Top = 34
      Width = 7
      Height = 16
      Caption = '0'
    end
  end
end
