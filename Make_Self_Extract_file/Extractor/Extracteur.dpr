program Extracteur;

uses
  Forms,
  Princip in 'Princip.pas' {frmPrincip},
  OpFichiers in 'OpFichiers.pas',
  CRC32 in 'CRC32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Extracteur';
  Application.CreateForm(TfrmPrincip, frmPrincip);
  Application.Run;
end.
