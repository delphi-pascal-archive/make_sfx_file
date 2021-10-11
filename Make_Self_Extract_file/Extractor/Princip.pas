{                    AUTO-EXTRACTEUR AVEC COMPRESSION/DECOMPRESSION

Ceci est le programme qui servira � d�compresser les fichiers dans un r�pertoire
donn�. La structure de l'EXE de l'extracteur est la suivante, une fois des
fichiers inclus par le programme principal :

         ___________________
        |       CODE        |
        |                   |  Tout le code de
        |        DE         |
        |                   |  l'EXE d'origine
        |   L'EXTRACTEUR    |
        |===================|
   -->  | Ent�te fichier 1  | ]
  ^     |-------------------| ]
  ^     |    Fichier 1      | ]
  ^     |    compress�      | ]
  ^     |___________________| ]
  ^     | Ent�te fichier 2  | ]
  ^     |-------------------| ]  Ent�te d�crivant chaque fichier (nom, taille...)
  ^     |    Fichier 2      | ]>
  ^     |    compress�      | ]  et le fichier compress� juste apr�s l'ent�te
  ^     |___________________| ]
  ^     | Ent�te fichier n  | ]
  ^     |-------------------| ]
  ^     |    Fichier n      | ]
  ^     |    compress�      | ]
  ^     |_ _ _ _ _ _ _ _ _ _| ]
  ^     |                   |  Ent�te donnant les caract�ristiques g�n�rales
  ^     | Ent�te principale |  et l'adresse de "Ent�te fichier 1"
AdrDeb  |___________________|


  L'extracteur lit les informations dans l'ent�te principale puis, un fois que
l'utilisateur a cliqu� sur "Extraire", il se rend � l'adresse AdrDeb et lit la
premi�re ent�te. Il extrait le premier fichier et le d�compresse, puis se rend
� la deuxi�me ent�te, et ainsi de suite.

>>  Les ent�tes et les op�rations de d�compression avec enregistrement
    dans le r�pertoire donn� sont impl�ment�es dans l'unit� OpFichiers.pas

HISTORIQUE :  02/02/03 : - Cr�ation de l'interface de l'extracteur
              07/02/03 : - D�finition des ent�tes.
                         - Impl�mentation du code de l'extracteur
              08/02/03 : - Modification du code de l'extracteur
                         - Impl�mentation du code de OpFichiers.pas
              14/02/03,
              15/02/03,
              16/02/03 : - Correction d'erreurs et d'oublis !!
              22/02/03 : - Toutes les erreurs sont corrig�es, l'extracteur
                           fonctionne ;o)

Merci � bgK pour son aide !!

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
    { D�clarations priv�es }
  public
    { D�clarations publiques }
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
    //On demande la pr�paration de l'ouverture de l'EXE
    AssignFile(EXE, Application.ExeName);
    //Sauvegarde du mode d'acc�s au fichier...
    FModeOrgn := FileMode;
    //...pour lui donner une nouvelle valeur...
    FileMode := 0;
    //...et pouvoir lire directement l'EXE ouvert
    Reset(EXE, 1);

    Seek(EXE, FileSize(EXE) - SizeOf(TEntetePrincip));
    BlockRead(EXE, Princip, SizeOf(TEntetePrincip));

    //V�rification de la signature :
    If Princip.Sign <> 'Bestiol.EXT' then
      begin
        ErrSign := True;
        MessageDlg('La signature de l''ent�te est invalide !', mtError,
                   [mbOK], 0);
        Exit;
      end;

    //Mise � jour des textes des composants :
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

  If SelectDirectory('S�lectionnez le r�pertoire d''extraction', Root, Rep) then
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
    case MessageDlg('Le r�pertoire s�lectionn� n''existe pas...' + #13 +
                    'Voulez-vous le cr�er ?', mtConfirmation, [mbYes, mbNo], 0) Of

      mrYes: ForceDirectories(edDir.Text);
      mrNo : begin
               ShowMessage('Veuillez s�lectionner un r�pertoire existant');
               Exit;
             end;
    end;

  FModeOrgn := 2;
  NonDcprs := 0;

  Try
    //On demande la pr�paration de l'ouverture de l'EXE
    AssignFile(EXE, Application.ExeName);
    //Sauvegarde du mode d'acc�s au fichier...
    FModeOrgn := FileMode;
    //...pour lui donner une nouvelle valeur...
    FileMode := 0;
    //...et pouvoir lire directement l'EXE ouvert
    Reset(EXE, 1);
    //On se rend � l'adresse de la premi�re ent�te de fichier
    Adresse := AdrDeb;
    Seek(EXE, Adresse);

    For i := 1 to NbrFich Do
      Begin
        Try

          Application.ProcessMessages;

          //On lit l'ent�te de fichier
          If i <> (NbrFich + 1) then BlockRead(EXE, Fichier, SizeOf(TEnteteFichier));
          Inc(Adresse, SizeOf(TEnteteFichier));

         //Affichage du nom du fichier
          If Length(String(Fichier.SousRep) + '\' + String(Fichier.NomFich)) <= 25 then
            lblFichier.Caption := String(Fichier.SousRep) + '\' + String(Fichier.NomFich)
          else lblFichier.Caption := '...\' + String(Fichier.NomFich);

          //Cr�ation d'un stream de m�moire pour le fichier compress�
          CprsFich := TMemoryStream.Create;
          //On initialise sa taille � celle du fichier compress�
          CprsFich.SetSize(Fichier.TailleCprs);

          Seek(EXE, Adresse);

          Total := 0;

          Repeat
            Application.ProcessMessages;
            //Lecture du fichier compress� dans l'EXE
            BlockRead(EXE, Buffer, SizeOf(Buffer), Lus);
            //Et �criture dans un flux de m�moire
            CprsFich.WriteBuffer(Buffer, SizeOf(Buffer));
            Total := Total + Lus;
          until (Total = Fichier.TailleCprs);//On lit jusqu'� la taille du fichier compress�

          Inc(Adresse, Fichier.TailleCprs);

          //On lance la d�compression et l'enregistrement du fichier
          If not Decompresser(CprsFich, Prgrs, Fichier.TailleOrgn, TailleTot, Fichier.CRC,
          ExcludeTrailingBackSlash(edDir.Text) + ExcludeTrailingBackSlash(String(Fichier.SousRep)) +
          '\' + String(Fichier.NomFich))then
            begin
              ShowMessage('Le fichier ' + String(Fichier.NomFich) + ' a mal �t� d�compress�');
              Inc(NonDcprs);
            end;

          //Lib�ration de la m�moire allou�e
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
               + ' (a) ont �t� d�compress�(s) correctement !', mtInformation, [mbOK], 0);
  end;

end;

end.
