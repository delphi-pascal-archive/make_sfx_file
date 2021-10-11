unit OptPrj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CRC32, OpFichiers, StdCtrls, ExtCtrls, Buttons;

type
  TfrmOptPrj = class(TForm)
    Label1: TLabel;
    edSign: TEdit;
    Shape1: TShape;
    Hint: TLabel;
    Label2: TLabel;                   
    edNomAppl: TEdit;
    Label3: TLabel;
    edRepDft: TEdit;
    rgTaux: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure edSignMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure rgTauxEnter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private

  public
    { Déclarations publiques }
  end;

var
  frmOptPrj: TfrmOptPrj;

implementation

uses uPrincip, Menus;

{$R *.dfm}

procedure TfrmOptPrj.FormCreate(Sender: TObject);
begin

  edSign.Text := Sign;

end;

procedure TfrmOptPrj.edSignMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var Nom: String;
begin

  Nom := TComponent(Sender).Name;

  If Nom = 'frmOptPrj' then
    Hint.Caption := 'Modifiez ici les caractéristiques de votre extracteur.';
  If Nom = 'edSign' then
    Hint.Caption := '[A titre d''information] La signature permettant l''identification de l''extracteur.';
  If Nom = 'edNomAppl' then
    Hint.Caption := 'Nom du projet. Sera affiché dans le titre de l''extracteur (50 caractères max.)';
  If Nom = 'edRepDft' then
    Hint.Caption := 'Répertoire d''extraction proposé par défaut dans l''extracteur (260 caractères max.)';

  Hint.Left := (Width - Hint.Width) div 2;

end;

procedure TfrmOptPrj.SpeedButton2Click(Sender: TObject);
begin

  ModalResult := mrCancel;

end;

procedure TfrmOptPrj.rgTauxEnter(Sender: TObject);
begin

  Hint.Caption := 'Choisissez le taux de compression à utiliser pour tous les fichiers de l''archive.';
  Hint.Left := (Width - Hint.Width) div 2;
  
end;

procedure TfrmOptPrj.SpeedButton1Click(Sender: TObject);
var i: Integer;
    tmp: String;
begin

  If (edNomAppl.Text = '') or (edRepDft.Text = '') then
    begin
      ShowMessage('You should fill all fields!');
      Exit;
    end;

  With OptsPrj Do
    begin
      Sign    := edSign.Text;
      NomAppl := edNomAppl.Text;

      StrPCopy(RepDft, edRepDft.Text);

      TxCmprs := rgTaux.ItemIndex;
    end;

  ModalResult := mrOK;

end;

end.
