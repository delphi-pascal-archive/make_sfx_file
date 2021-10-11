unit OpFichiers;

interface

uses Windows, Classes, SysUtils, Gauges, CRC32, zLib, Dialogs;

type
  {TEntetePrincip sera plac� � la fin de l'extracteur, apr�s les fichiers �
  extraire... C'est pourquoi il y a la propri�t� AdrDeb, pour localiser
  l'entete du premier fichier � extraire.}
  TEntetePrincip = Packed Record
    Sign   : String[20];   //Signature pour v�rifier la validit� du fichier
    NomAppl: String[50];   //Nom de l'application utilisant l'extracteur
    RepDft : Array[0..MAX_PATH-1]Of Char;   //Chemin du r�pertoire d'extraction par d�faut
    NbrFich: Cardinal; //Nombre total de fichiers � extraire
    Taille : Cardinal; //Taille totale des fichiers d�compress�s
    TxCmprs: Integer;  //Taux de compression utilis� pour les fichiers
    AdrDeb : Cardinal; //Adresse de la premi�re ent�te de fichier � extraire
end;

type
  {TEnteteFichier sera plac�e avant chaque fichier pour connaitre la taille des
  donn�es � lire et sous quel nom l'enregistrer...}
  TEnteteFichier = Packed Record
    NomFich   : Array[0..MAX_PATH-1]Of Char;//Nom du fichier
    SousRep   : Array[0..MAX_PATH-1]Of Char;//Sous-r�pertoire de destination. Vide si inutile
    TailleCprs: Cardinal;//Taille � lire dans l'EXE
    TailleOrgn: Cardinal;//Taille du fichier d�compress�
    CRC       : Cardinal;//CRC du fichier pour v�rifier que tout s'est bien pass� !
end;

{Compresser : fonction de compression de fichier.
-Stream est un TFileStream qui doit contenir le fichier � compresser
-Compresse doit �tre un TMemoryStream d�j� cr��. Il contiendra le fichier
 compress�
-Gauge est l'indicateur d'avancement, qui sera mis � jour gr�ce � TailleFich (la
 taille du fichier) et � TailleTot(Taille totale des fichiers)
-Niveau correspond au niveau de compression � utiliser
>> Si tout s'est bien pass�, Compresser renvoie True et les donn�es compress�es
sont accessibles via la variable Compresse}
function Compresser(var Stream: TFileStream; out Compresse: TMemoryStream;
Gauge: TGauge; TailleFich, TailleTot: Cardinal; Niveau: Integer): Boolean;

{Decompresser : fonction de d�compression d'une "archive" dans un fichier
-Stream est un TMemoryStream qui doit contenir les donn�es du fichier � d�compresser
-Gauge est l'indicateur d'avancement mis � jour gr�ce � TailleFich et TailleTot
-CRC correspond au champ CRC de TEnteteFichier. Il servira � la v�rification de
 l'int�grit� du fichier d�compress�
-Dest doit contenir le chemin complet du fichier d�compress�
>> Si tout s'est bien pass�, Decompresser renvoie True ; false pour n'importe
quelle erreur}
function Decompresser(var Stream: TMemoryStream; Gauge: TGauge; TailleFich,
TailleTot, CRC: Cardinal; Dest: String): Boolean;         

{PlacerEntete******* : Fonction enregistrant dans l'extracteur l'ent�te sp�cifi�e
dans le param�tre Entete. Stream est un TFileStream qui doit �tre initialis� en
ouvrant l'extracteur � "compl�ter" (cr�er le stream avec fmOpenWrite)
ATTENTION : Stream doit bien s�r �tre positionn� � l'endroit exact o� �crire !
>> Renvoie True si l'ent�te a bien �t� �crite}
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
 