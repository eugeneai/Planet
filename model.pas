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
     RE=6371;
     SS=20;

type

  { TMainForm }

  TMainForm = class(TForm)
    H: TEdit;
    Label3: TLabel;
    km: TLabel;
    m_s: TLabel;
    Figure: TPaintBox;
    Vx: TEdit;
    Vy: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FigureClick(Sender: TObject);
    procedure FigurePaint(Sender: TObject);
    procedure HChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    scale:Real;
    bmp:TBitmap;
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  C:TCanvas;
  R, Cx,Cy:Integer;
begin
     //Vx.SetTextBuf(FloatToStr(defVx));
  Vx.Text:=FloatToStr(defVx);
  Vy.Text:=FloatToStr(defVy);
  H.Text:=FloatToStr(defH);
  m_s.Caption:='m/s';
  scale:=Screen.Width/RE/SS;

  bmp:=TBitmap.Create;
  bmp.SetSize(Screen.Width, Screen.Height);
  C:=bmp.Canvas;
  //C.Brush.Color:=clWhite;
  C.FillRect(0,0,Screen.Width,Screen.Height);
  C.Pen.Color:=clRed;
  R:=trunc(RE * scale);
  Cx:=C.Width >> 1;
  Cy:=C.Height >> 1;
  C.Ellipse(Cx-R,Cy-R,Cx+R,Cy+R);
end;

procedure TMainForm.HChange(Sender: TObject);
begin

end;

procedure TMainForm.FigureClick(Sender: TObject);
begin

end;

procedure TMainForm.FigurePaint(Sender: TObject);
var
  cx,cy:integer;
  sx,sy:integer;
  C:TCanvas;
begin
  C:=Figure.Canvas;
  Cx:=C.Width >> 1;
  Cy:=C.Height >> 1;
  Sx:=Screen.Width >> 1;
  Sy:=Screen.Height >> 1;
  C.Draw(Cx-Sx,Cy-Sy,bmp);  //TCanvas
end;

end.

