unit model;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

const
     defVx=8e3; // 8*10^3
     defVy=0.0;
     defH =400.0; // In km

type

  { TMainForm }

  TMainForm = class(TForm)
    H: TEdit;
    Label3: TLabel;
    km: TLabel;
    m_s: TLabel;
    Vx: TEdit;
    Vy: TEdit;
    Figure: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure HChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure VyChange(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.Label2Click(Sender: TObject);
begin

end;

procedure TMainForm.VyChange(Sender: TObject);
begin

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
     //Vx.SetTextBuf(FloatToStr(defVx));
  Vx.Text:=FloatToStr(defVx);
  Vy.Text:=FloatToStr(defVy);
  H.Text:=FloatToStr(defH);
  m_s.Caption:='m/s';
  Figure.Caption:='';
end;

procedure TMainForm.HChange(Sender: TObject);
begin

end;

procedure TMainForm.Label3Click(Sender: TObject);
begin

end;

end.

