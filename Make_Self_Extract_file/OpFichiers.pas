unit OpFichiers;

interface

uses Windows, Classes, SysUtils, Gauges, CRC32, zLib, Dialogs;

type
  {TEntetePrincip sera placé à la fin de l'extracteur, après les fichiers à
  extraire... C'est pourquoi il y a la propriété AdrDeb, pour localiser
  l'entete du premier fichier à extraire.}
  TEntetePrincip = Packed Record
    Sign   : String[20];   //Signature pour vérifier la validité du fichier
    NomAppl: String[50];   //Nom de l'application utilisant l'extracteur
    RepDft : Array[0..MAX_PATH-1]Of Char;   //Chemin du répertoire d'extraction par défaut
    NbrFich: Cardinal; //Nombre total de fichiers à extraire
    Taille : Cardinal; //Taille totale des fichiers décompressés
    TxCmprs: Integer;  //Taux de compression utilisé pour les fichiers
    AdrDeb : Cardinal; //Adresse de la première entête de fichier à extraire
end;

type
  {TEnteteFichier sera placée avant chaque fichier pour connaitre la taille des
  données à lire et sous quel nom l'enregistrer...}
  TEnteteFichier = Packed Record
    NomFich   : Array[0..MAX_PATH-1]Of Char;//Nom du fichier
    SousRep   : Array[0..MAX_PATH-1]Of Char;//Sous-répertoire de destination. Vide si inutile
    TailleCprs: Cardinal;//Taille à lire dans l'EXE
    TailleOrgn: Cardinal;//Taille du fichier décompressé
    CRC       : Cardinal;//CRC du fichier pour vérifier que tout s'est bien passé !
end;

{Compresser : fonction de compression de fichier.
-Stream est un TFileStream qui doit contenir le fichier à compresser
-Compresse doit être un TMemoryStream déjà créé. Il contiendra le fichier
 compressé
-Gauge est l'indicateur d'avancement, qui sera mis à jour grâce à TailleFich (la
 taille du fichier) et à TailleTot(Taille totale des fichiers)
-Niveau correspond au niveau de compression à utiliser
>> Si tout s'est bien passé, Compresser renvoie True et les données compressées
sont accessibles via la variable Compresse}
function Compresser(var Stream: TFileStream; out Compresse: TMemoryStream;
Gauge: TGauge; TailleFich, TailleTot: Cardinal; Niveau: Integer): Boolean;

{Decompresser : fonction de décompression d'une "archive" dans un fichier
-Stream est un TMemoryStream qui doit contenir les données du fichier à décompresser
-Gauge est l'indicateur d'avancement mis à jour grâce à TailleFich et TailleTot
-CRC correspond au champ CRC de TEnteteFichier. Il servira à la vérification de
 l'intégrité du fichier décompressé
-Dest doit contenir le chemin complet du fichier décompressé
>> Si tout s'est bien passé, Decompresser renvoie True ; false pour n'importe
quelle erreur}
function Decompresser(var Stream: TMemoryStream; Gauge: TGauge; TailleFich,
TailleTot, CRC: Cardinal; Dest: String): Boolean;         

{PlacerEntete******* : Fonction enregistrant dans l'extracteur l'entête spécifiée
dans le paramètre Entete. Stream est un TFileStream qui doit être initialisé en
ouvrant l'extracteur à "compléter" (créer le stream avec fmOpenWrite)
ATTENTION : Stream doit bien sûr être positionné à l'endroit exact où écrire !
>> Renvoie True si l'entête a bien été écrite}
function PlacerEnteteFichier(var Stream: TFileStream; Entete: TEnteteFichier):Boolean;
function PlacerEntetePrincip(var Stream: TFileStream; Entete: TEntetePrincip): Boolean;

implementation

function Compresser(var Stream: TFileStream; out Compresse: TMemoryStream;
Gauge: TGauge; TailleFich, TailleTot: Cardinal; Niveau: Integer): Boolean;
var CprsStream: TCompressionStream;
    Erreur: Boolean;
begin

  Erreur := False;

  Try
    try
      Stream.Position := 0;
      Compresse.Position := 0;
      CprsStream := TCompressionStream.Create(TCompressionLevel(Niveau), Compresse);
      CprsStream.CopyFrom(Stream, TailleFich);

      Gauge.Progress := TailleFich * TailleTot div 100;
    except
      on Exception do Erreur := True;
    end;
  finally
    CprsStream.Free;
    Result := not Erreur;
  end;

end;

function Decompresser(var Stream: TMemoryStream; Gauge: TGauge; TailleFich,
TailleTot, CRC: Cardinal; Dest: String): Boolean;
var Dcprs: TDecompressionStream;
    Source: TMemoryStream;
    DestF: TFileStream;
    Erreur: Boolean;
Begin

  Erreur := False;

  Try
    Try
      Source := TMemoryStream.Create;
      Source.CopyFrom(Stream, 0);
      Source.Position := 0;
      DestF := TFileStream.Create(Dest, fmCreate);

      Dcprs := TDecompressionStream.Create(Source);
      DestF.CopyFrom(Dcprs, TailleFich);
      Gauge.Progress := TailleFich * TailleTot div 100;

    except
      On Exception do Erreur := True;
    end;
  finally
    Dcprs.Free;
    DestF.Free;
    If Erreur then Result := False
    else Result := (GetCRC32(Dest) = CRC);
    ShowMessage('CRC');
  end;

end;

function PlacerEnteteFichier(var Stream: TFileStream; Entete: TEnteteFichier):Boolean;
var Erreur: Boolean;
begin

  Erreur := False;

  Try
    Stream.Write(Entete, SizeOf(Entete));
  except
    on Exception do Erreur := True;
  end;

  Result := not Erreur;

end;

function PlacerEntetePrincip(var Stream: TFileStream; Entete: TEntetePrincip): Boolean;
var Erreur: Boolean;
begin

  Erreur := False;

  Try
    Stream.Write(Entete, SizeOf(Entete));
  except
    on Exception do Erreur := True;
  end;

  Result := not Erreur;

end;

end.
 