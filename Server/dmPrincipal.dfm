object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 267
  Width = 494
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Users\gabri\Documents\Banco_Teste.s3db'
      'DriverID=sQLite')
    Connected = True
    LoginPrompt = False
    Left = 184
    Top = 56
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from Occurrences')
    Left = 376
    Top = 80
    object FDQuery1ID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object FDQuery1Name: TStringField
      FieldName = 'Name'
      Origin = 'Name'
      Size = 100
    end
  end
end
