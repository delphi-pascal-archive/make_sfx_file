object frmOptPrj: TfrmOptPrj
  Left = 523
  Top = 238
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 281
  ClientWidth = 603
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
  OnCreate = FormCreate
  OnMouseMove = edSignMouseMove
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 130
    Top = 207
    Width = 187
    Height = 16
    Caption = 'Signature de l'#39'entete principale:'
  end
  object Shape1: TShape
    Left = 8
    Top = 8
    Width = 585
    Height = 33
    Brush.Color = clBtnHighlight
  end
  object Hint: TLabel
    Left = 154
    Top = 15
    Width = 301
    Height = 16
    Caption = 'Modifiez ici les caracteristiques de votre extracteur.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clActiveCaption
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 52
    Top = 54
    Width = 82
    Height = 16
    Caption = 'Project name:'
  end
  object Label3: TLabel
    Left = 8
    Top = 94
    Width = 130
    Height = 16
    Caption = 'Repertoire par defaut:'
  end
  object edSign: TEdit
    Left = 328
    Top = 200
    Width = 145
    Height = 25
    Color = clBtnFace
    Ctl3D = False
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 3
    OnMouseMove = edSignMouseMove
  end
  object edNomAppl: TEdit
    Left = 144
    Top = 48
    Width = 449
    Height = 25
    Ctl3D = False
    MaxLength = 50
    ParentCtl3D = False
    TabOrder = 0
    OnMouseMove = edSignMouseMove
  end
  object edRepDft: TEdit
    Left = 144
    Top = 88
    Width = 449
    Height = 25
    Ctl3D = False
    MaxLength = 260
    ParentCtl3D = False
    TabOrder = 1
    OnMouseMove = edSignMouseMove
  end
  object rgTaux: TRadioGroup
    Left = 8
    Top = 138
    Width = 585
    Height = 50
    Caption = ' Type of compression '
    Columns = 4
    ItemIndex = 2
    Items.Strings = (
      'None'
      'Fast'
      'Defaut'
      'Maximum')
    TabOrder = 2
    OnEnter = rgTauxEnter
  end
  object BitBtn1: TBitBtn
    Left = 112
    Top = 246
    Width = 153
    Height = 27
    Caption = 'OK'
    Default = True
    ModalResult = 2
    TabOrder = 4
    OnClick = SpeedButton1Click
  end
  object BitBtn2: TBitBtn
    Left = 336
    Top = 246
    Width = 153
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
    OnClick = SpeedButton2Click
  end
end
