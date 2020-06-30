unit uServico;

interface

uses Horse, System.SysUtils, DataSet.Serialize;

procedure Servico(App: THorse);
procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses dmPrincipal;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

  try
    try

      DataModule1 := TDataModule1.Create(nil);
      DataModule1.FDQuery1.Close;
      if req.Params.Count > 0 then
      begin
        DataModule1.FDQuery1.FetchOptions.RecsSkip:= strtointdef(req.Params.Items['pagina'],1) * strtointdef(req.Params.Items['max'],1);
        DataModule1.FDQuery1.FetchOptions.RecsMax:= strtointdef(req.Params.Items['max'],1);

      end;
      DataModule1.FDQuery1.Open();

      Res.Send(DataModule1.FDQuery1.ToJSONArray.ToJSON);

    finally
      Res.Status(200);
      FreeAndNil(DataModule1);

    end;

  except
    on e: exception do
    begin
      Res.Send(e.Message);
      Res.Status(400);

    end;

  end;

end;

procedure Servico(App: THorse);
begin
  App.Get('/ocorrencia/:pagina/:max', Get);

end;

end.
