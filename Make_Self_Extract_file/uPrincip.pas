unit uPrincip;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OpFichiers, ComCtrls, Gauges;

type
  TForm1 = class(TForm)
    Liste: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Button1: TButton;
    Label3: TLabel;
    Ouvrir: TOpenDialog;
    Button3: TButton;
    Button4: TButton;
    Sauver: TSaveDialog;
    Prgrs: TGauge;
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListeClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    function TailleTotale: Integer;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  OptsPrj: TEntetePrincip;

const
  Sign: string[20] = 'Bestiol.EXT';

implementation

uses ShellAPI, OptPrj, CRC32;
{$R *.dfm}

procedure TForm1.Label3MouseEnter(Sender: TObject);
begin

  Label3.Font.Color := clBlue;

end;

procedure TForm1.Label3MouseLeave(Sender: TObject);
begin

  Label3.Font.Color := clNavy;

end;

procedure TForm1.Label3Click(Sender: TObject);
begin

  ShellExecute(Handle, 'OPEN', 'mailto:bestiol@cario.fr?subject=Archiveur&body=Une petite remarque ?!', nil,
               nil, SW_SHOW);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  If not Ouvrir.Execute then Exit;

  Liste.Items.AddStrings(Ouvrir.Files);

end;

procedure TForm1.Button1Click(Sender: TObject);
var i: Integer;
begin

  for i := Liste.Count - 1 downto 0 do
    If Liste.Selected[i] then Liste.Items.Delete(i);

  Button1.Enabled := False;

end;

procedure TForm1.ListeClick(Sender: TObject);
begin

  If Liste.SelCount > 0 then Button1.Enabled := True;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  If frmOptPrj.ShowModal = mrCancel then Exit;

  Button4.Enabled := True;

end;

procedure ExtraireEXE(Chemin: String);
var Res: TResourceStream;
    EXE: TFileStream;
begin

  Try
    Res := TResourceStream.Create(hInstance, 'extract', RT_RCDATA);
    EXE := TFileStream.Create(Chemin, fmCreate);
    EXE.CopyFrom(Res, 0);
  Finally
    EXE.Free;
    Res.Free;
  end;

end;

function TForm1.TailleTotale: Integer;
var i: Integer;
    SR: TSearchRec;
begin

  Result := 0;

  for i := 0 to Liste.Count - 1 do
    begin
      FindFirst(Liste.Items[i], faAnyfile, SR);
      Result := Result + SR.Size;
    end;

  FindClose(SR);

end;

procedure TForm1.Button4Click(Sender: TObject);
var i: Integer;
    TailleTot: Integer;
    Entete: TEnteteFichier;
    Chemin: String;
    EXE, Fichier: TFileStream;
    Compresse   : TMemoryStream;

begin

  If not Sauver.Execute then Exit;

  If FileExists(Sauver.FileName) then Exit;

  If LowerCase(ExtractFileExt(Sauver.FileName)) <> '.exe' then
    Chemin := Sauver.FileName + '.exe'
  else
    Chemin := Sauver.FileName;
  ExtraireEXE(Chemin);

  TailleTot := TailleTotale;

  Try
    //Ouverture de l'EXE "archive"
    EXE := TFileStream.Create(Chemin, fmOpenWrite);
    //On se rend tout à la fin du fichier
    EXE.Seek(0, soFromEnd);

    With OptsPrj do
      begin
        NbrFich := Liste.Items.Count;
        Taille  := TailleTot;
        AdrDeb  := EXE.Position;
      end;

    for i := 0 to Liste.Count - 1 Do
      Try
        //Ouverture et compression du fichier i dans la liste
        Fichier := TFileStream.Create(Liste.Items[i], fmOpenRead, fmShareDenyNone);
        Compresse := TMemoryStream.Create;

        Compresser(Fichier, Compresse, Prgrs, Fichier.Size, TailleTot, OptsPrj.TxCmprs);

        //Ici on remplit l'entête du fichier en cours avec les infos nécessaires
        With Entete Do
          Begin
            StrPCopy(NomFich, ExtractFileName(Liste.Items[i]));
            FillChar(SousRep, SizeOf(SousRep), #0);
            TailleCprs := Compresse.Size;
            TailleOrgn := Fichier.Size;
            //Libération du fichier obligatoire pour calculer le CRC32...
            Fichier.Free;
            CRC        := GetCRC32(Liste.Items[i]);
          end;
        //et on place cette entête dans le fichier
        PlacerEnteteFichier(EXE, Entete);

        //Ecriture du fichier compressé dans l'EXE, derrière l'entête
        EXE.CopyFrom(Compresse, 0);

      finally
        //Fichier.Free; Plus besoin...
        Compresse.Free;
      end;

      //Enfin, écriture de l'entête principale de l'archive...
      PlacerEntetePrincip(EXE, OptsPrj);

  finally
    EXE.Free;
  end;

end;

end.
