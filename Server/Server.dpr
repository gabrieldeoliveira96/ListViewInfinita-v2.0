program Server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  uServico in 'uServico.pas',
  dmPrincipal in 'dmPrincipal.pas' {DataModule1: TDataModule};

var
  App: THorse;

begin
  App := THorse.Create(9000);

  uServico.Servico(App);

  App.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  App.Start;
end.
