program SFX_archive;

uses
  Forms,
  uPrincip in 'uPrincip.pas' {Form1},
  OptPrj in 'OptPrj.pas' {frmOptPrj};

{$R *.res}
{$R Extracteur.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmOptPrj, frmOptPrj);
  Application.Run;
end.
