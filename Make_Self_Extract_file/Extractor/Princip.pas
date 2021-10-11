{                    AUTO-EXTRACTEUR AVEC COMPRESSION/DECOMPRESSION

Ceci est le programme qui servira à décompresser les fichiers dans un répertoire
donné. La structure de l'EXE de l'extracteur est la suivante, une fois des
fichiers inclus par le programme principal :

         ___________________
        |       CODE        |
        |                   |  Tout le code de
        |        DE         |
        |                   |  l'EXE d'origine
        |   L'EXTRACTEUR    |
        |===================|
   -->  | Entête fichier 1  | ]
  ^     |-------------------| ]
  ^     |    Fichier 1      | ]
  ^     |    compressé      | ]
  ^     |___________________| ]
  ^     | Entête fichier 2  | ]
  ^     |-------------------| ]  Entête décrivant chaque fichier (nom, taille...)
  ^     |    Fichier 2      | ]>
  ^     |    compressé      | ]  et le fichier compressé juste après l'entête
  ^     |___________________| ]
  ^     | Entête fichier n  | ]
  ^     |-------------------| ]
  ^     |    Fichier n      | ]
  ^     |    compressé      | ]
  ^     |_ _ _ _ _ _ _ _ _ _| ]
  ^     |                   |  Entête donnant les caractéristiques générales
  ^     | Entête principale |  et l'adresse de "Entête fichier 1"
AdrDeb  |___________________|


  L'extracteur lit les informations dans l'entête principale puis, un fois que
l'utilisateur a cliqué sur "Extraire", il se rend à l'adresse AdrDeb et lit la
première entête. Il extrait le premier fichier et le décompresse, puis se rend
à la deuxième entête, et ainsi de suite.

>>  Les entêtes et les opérations de décompression avec enregistrement
    dans le répertoire donné sont implémentées dans l'unité OpFichiers.pas

HISTORIQUE :  02/02/03 : - Création de l'interface de l'extracteur
              07/02/03 : - Définition des entêtes.
                         - Implémentation du code de l'extracteur
              08/02/03 : - Modification du code de l'extracteur
                         - Implémentation du code de OpFichiers.pas
              14/02/03,
              15/02/03,
              16/02/03 : - Correction d'erreurs et d'oublis !!
              22/02/03 : - Toutes les erreurs sont corrigées, l'extracteur
                           fonctionne ;o)

Merci à bgK pour son aide !!

}

unit Princip;

interface

uses
  Windows, Messages, SysUtils, Forms, Dialogs, Buttons, Gauges, OpFichiers, FileCtrl, Classes,
  Controls, StdCtrls;

type
  TfrmPrincip = class(TForm)
    edDir: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    lblNbr: TLabel;
    lblTaux: TLabel;
    Prgrs: TGauge;
    Label4: TLabel;
    lblFichier: TLabel;
    Label5: TLabel;
    lblTaille: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmPrincip: TfrmPrincip;
  AdrDeb    : Cardinal;
  NbrFich, TailleTot: Integer;

implementation

{$R *.dfm}

function WinTemp: String;
var Buff: Array[0..MAX_PATH - 1]Of Char;
begin

  GetTempPath(MAX_PATH, Buff);
  Result := String(Buff);

end;

procedure TfrmPrincip.FormCreate(Sender: TObject);
var EXE: File;
    FModeOrgn: Integer;
    Princip: TEntetePrincip;
    ErrSign: Boolean;
    i      : Integer;
begin

   ErrSign := False;
   FModeOrgn := 2;

  Try
    //On demande la préparation de l'ouverture de l'EXE
    AssignFile(EXE, Application.ExeName);
    //Sauvegarde du mode d'accès au fichier...
    FModeOrgn := FileMode;
    //...pour lui donner une nouvelle valeur...
    FileMode := 0;
    //...et pouvoir lire directement l'EXE ouvert
    Reset(EXE, 1);

    Seek(EXE, FileSize(EXE) - SizeOf(TEntetePrincip));
    BlockRead(EXE, Princip, SizeOf(TEntetePrincip));

    //Vérification de la signature :
    If Princip.Sign <> 'Bestiol.EXT' then
      begin
        ErrSign := True;
        MessageDlg('La signature de l''entête est invalide !', mtError,
                   [mbOK], 0);
        Exit;
      end;

    //Mise à jour des textes des composants :
    Caption           := 'Extracteur : ' + Princip.NomAppl;

    for i := 0 to Length(Princip.RepDft) do
    edDir.Text := edDir.Text + Princip.RepDft[i];

    lblNbr.Caption    := IntToStr(Princip.NbrFich);
    NbrFich           := Princip.NbrFich;
    lblTaille.Caption := IntToStr(Princip.Taille);
    TailleTot         := Princip.Taille;
    lblTaux.Caption   := IntToStr(Princip.TxCmprs);
    AdrDeb            := Princip.AdrDeb;
  finally
    CloseFile(EXE);
    FileMode := FModeOrgn;
    If ErrSign then Application.Terminate;
  end;

end;

procedure TfrmPrincip.SpeedButton1Click(Sender: TObject);
var Root, Rep: String;
begin

  If edDir.Text <> '' then Root := edDir.Text
  else Root := ExtractFileDrive(Application.ExeName);

  If SelectDirectory('Sélectionnez le répertoire d''extraction', Root, Rep) then
  edDir.Text := Rep;

end;

procedure TfrmPrincip.SpeedButton2Click(Sender: TObject);
var EXE: File;
    CprsFich: TMemoryStream;
    Fichier: TEnteteFichier;
    FModeOrgn, i, Lus, Total, NonDcprs: Integer;
    Adresse: Int64;
    Buffer: Char;
begin

  If not DirectoryExists(edDir.Text) then
    case MessageDlg('Le répertoire sélectionné n''existe pas...' + #13 +
                    'Voulez-vous le créer ?', mtConfirmation, [mbYes, mbNo], 0) Of

      mrYes: ForceDirectories(edDir.Text);
      mrNo : begin
               ShowMessage('Veuillez sélectionner un répertoire existant');
               Exit;
             end;
    end;

  FModeOrgn := 2;
  NonDcprs := 0;

  Try
    //On demande la préparation de l'ouverture de l'EXE
    AssignFile(EXE, Application.ExeName);
    //Sauvegarde du mode d'accès au fichier...
    FModeOrgn := FileMode;
    //...pour lui donner une nouvelle valeur...
    FileMode := 0;
    //...et pouvoir lire directement l'EXE ouvert
    Reset(EXE, 1);
    //On se rend à l'adresse de la première entête de fichier
    Adresse := AdrDeb;
    Seek(EXE, Adresse);

    For i := 1 to NbrFich Do
      Begin
        Try

          Application.ProcessMessages;

          //On lit l'entête de fichier
          If i <> (NbrFich + 1) then BlockRead(EXE, Fichier, SizeOf(TEnteteFichier));
          Inc(Adresse, SizeOf(TEnteteFichier));

         //Affichage du nom du fichier
          If Length(String(Fichier.SousRep) + '\' + String(Fichier.NomFich)) <= 25 then
            lblFichier.Caption := String(Fichier.SousRep) + '\' + String(Fichier.NomFich)
          else lblFichier.Caption := '...\' + String(Fichier.NomFich);

          //Création d'un stream de mémoire pour le fichier compressé
          CprsFich := TMemoryStream.Create;
          //On initialise sa taille à celle du fichier compressé
          CprsFich.SetSize(Fichier.TailleCprs);

          Seek(EXE, Adresse);

          Total := 0;

          Repeat
            Application.ProcessMessages;
            //Lecture du fichier compressé dans l'EXE
            BlockRead(EXE, Buffer, SizeOf(Buffer), Lus);
            //Et écriture dans un flux de mémoire
            CprsFich.WriteBuffer(Buffer, SizeOf(Buffer));
            Total := Total + Lus;
          until (Total = Fichier.TailleCprs);//On lit jusqu'à la taille du fichier compressé

          Inc(Adresse, Fichier.TailleCprs);

          //On lance la décompression et l'enregistrement du fichier
          If not Decompresser(CprsFich, Prgrs, Fichier.TailleOrgn, TailleTot, Fichier.CRC,
          ExcludeTrailingBackSlash(edDir.Text) + ExcludeTrailingBackSlash(String(Fichier.SousRep)) +
          '\' + String(Fichier.NomFich))then
            begin
              ShowMessage('Le fichier ' + String(Fichier.NomFich) + ' a mal été décompressé');
              Inc(NonDcprs);
            end;

          //Libération de la mémoire allouée
          CprsFich.Free;

          Application.ProcessMessages;

        except
          On e: Exception Do
            Begin
              ShowMessage('Erreur : ' + e.Message);
              If Assigned(CprsFich) then CprsFich.Free;
            end;
        end;
      end;

  finally
    FileMode := FModeOrgn;
    CloseFile(EXE);
    MessageDlg('Sur ' + IntToStr(NbrFich) + ' fichier(s), ' + IntToStr(NbrFich - NonDcprs)
               + ' (a) ont été décompressé(s) correctement !', mtInformation, [mbOK], 0);
  end;

end;

end.
