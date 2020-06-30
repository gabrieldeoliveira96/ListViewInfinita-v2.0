unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation,
  FMX.Layouts, FMX.Ani, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Json, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.DBScope;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Rectangle1: TRectangle;
    Circle1: TCircle;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ListView1: TListView;
    Image1: TImage;
    Layout1: TLayout;
    Circle2: TCircle;
    SpeedButton4: TSpeedButton;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    memOcorrencia: TFDMemTable;
    memOcorrenciaID: TFDAutoIncField;
    memOcorrenciaName: TStringField;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTClient1: TRESTClient;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    procedure FormShow(Sender: TObject);
    procedure ListView1ScrollViewChange(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    lAbrirBotao, LPodeExecutar: boolean;
    FPagina,FMax:integer;
    procedure CarregaLista;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses DataSet.Serialize;

{$R *.fmx}
{ TForm1 }

procedure TForm1.CarregaLista;
var
 LJa:TJSONArray;
begin

  RESTClient1.BaseURL:= 'http://localhost:9000/ocorrencia/'+FPagina.ToString+'/'+FMax.ToString;
  RESTRequest1.Method:= TRESTRequestMethod.rmGET;
  RESTRequest1.Execute;

  if RESTResponse1.StatusCode = 200 then
  begin

    LJa := (TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes
      (RESTResponse1.Content), 0) as tJsonArray);

    memOcorrencia.LoadFromJSON(LJa);

    LPodeExecutar:= true;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  lAbrirBotao := true;
  Image1.Visible := false;
  Layout1.Position.X := self.Width;
  FPagina:= 0;
  FMax:= 15;
  CarregaLista;
  LPodeExecutar:= true;

end;

procedure TForm1.ListView1ScrollViewChange(Sender: TObject);
var
  nTop, scrollTot: single;

begin
  nTop := ListView1.GetItemRect(ListView1.ItemCount - 1).top +
    ListView1.ScrollViewPos - ListView1.SideSpace - ListView1.LocalRect.top;
  scrollTot := nTop + ListView1.GetItemRect(ListView1.ItemCount - 1).height -
    ListView1.height;

  if (ListView1.ScrollViewPos = scrollTot) and (LPodeExecutar) then
  begin
    LPodeExecutar:= false;
    if lAbrirBotao then
    begin
      lAbrirBotao := false;
      FloatAnimation1.StartValue := self.Width;
      FloatAnimation1.StopValue := self.Width - Layout1.Width;
      FloatAnimation1.Inverse := false;
      FloatAnimation1.Start;
    end;

    TThread.CreateAnonymousThread(
      procedure
      begin

        TThread.Synchronize(nil,
          procedure
          begin
            inc(FPagina);

            self.CarregaLista;

          end);
      end).Start;

  end;

end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  FloatAnimation2.StartValue := ListView1.ScrollViewPos;
  FloatAnimation2.StopValue := 0;
  FloatAnimation2.Inverse := false;
  FloatAnimation2.Start;
  lAbrirBotao := true;

  FloatAnimation1.Inverse := true;
  FloatAnimation1.Start;

end;

end.
