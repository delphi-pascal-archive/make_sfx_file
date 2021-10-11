object Form1: TForm1
  Left = 252
  Top = 130
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Make Self-Extract file'
  ClientHeight = 399
  ClientWidth = 571
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC7777CCCCCCC0000CCCC00000000CCCC7777CCCCCCCC
    C0000CCCCCCCCCCCCCC7777CCCCC0CCCCC0000CCCCCCCCCCCC7777CCCCC700CC
    C00CCCC0000000000CCCC77CCC77000C0000CCCC00000000CCCC7777C7770000
    00000CCCC000000CCCC777777777C000C00000CCCC0000CCCC77777C777CCC00
    CC00000CCCCCCCCCC77777CC77CCCCC0CCC000CCCCC00CCCCC777CCC7CCCCCCC
    CCCC0CCCCCCCCCCCCCC7CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC7CCC70CCC
    00CCCCCCCC0CC0CCCCCCCC77CC7700CC000CCCCCC000000CCCCCC777CC7700CC
    0000CCCC00000000CCCC7777CC7700CC0000C0CCC000000CCC7C7777CC7700CC
    0000C0CCC000000CCC7C7777CC7700CC0000CCCC00000000CCCC7777CC7700CC
    000CCCCCC000000CCCCCC777CC7700CC00CCCCCCCC0CC0CCCCCCCC77CC770CCC
    0CCCCCCCCCCCCCCCCCCCCCC7CCC7CCCCCCCC0CCCCCCCCCCCCCC7CCCCCCCCCCC0
    CCC000CCCCC00CCCCC777CCC7CCCCC00CC00000CCCCCCCCCC77777CC77CCC000
    C00000CCCC0000CCCC77777C777C000000000CCCC000000CCCC777777777000C
    0000CCCC00000000CCCC7777C77700CCC00CCCC0000000000CCCC77CCC770CCC
    CC0000CCCCCCCCCCCC7777CCCCC7CCCCC0000CCCCCCCCCCCCCC7777CCCCCCCCC
    0000CCCC00000000CCCC7777CCCCCCC0000CCCC0000000000CCCC7777CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Liste: TListBox
    Left = 185
    Top = 0
    Width = 386
    Height = 399
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = False
    ItemHeight = 16
    MultiSelect = True
    ParentCtl3D = False
    TabOrder = 0
    OnClick = ListeClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 399
    Align = alLeft
    TabOrder = 1
    object Label1: TLabel
      Left = 18
      Top = 5
      Width = 145
      Height = 28
      Caption = 'ARCHIVEUR'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
    end
    object Label2: TLabel
      Left = 21
      Top = 5
      Width = 145
      Height = 28
      Caption = 'ARCHIVEUR'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -20
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 122
      Top = 39
      Width = 41
      Height = 16
      Cursor = crHandPoint
      Caption = 'Bestiol'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label3Click
      OnMouseEnter = Label3MouseEnter
      OnMouseLeave = Label3MouseLeave
    end
    object Prgrs: TGauge
      Left = 8
      Top = 372
      Width = 169
      Height = 20
      Progress = 0
    end
    object Button2: TButton
      Left = 16
      Top = 64
      Width = 153
      Height = 25
      Caption = 'Add files'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 16
      Top = 96
      Width = 153
      Height = 25
      Caption = 'Remove selected files'
      Enabled = False
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 16
      Top = 128
      Width = 153
      Height = 25
      Caption = 'Options ...'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 16
      Top = 160
      Width = 153
      Height = 25
      Caption = 'Create SelfExtract file'
      Enabled = False
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Ouvrir: TOpenDialog
    Filter = 'Tous (*.*)|*.*'
    Options = [ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 24
    Top = 36
  end
  object Sauver: TSaveDialog
    Filter = 'AutoExtractible (*.exe)|*.exe'
    Left = 68
    Top = 36
  end
end
