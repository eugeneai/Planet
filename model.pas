unit model;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

const
     defVx=8e3; // 8*10^3 m/s
     defVy=0.0;
     defH =400.0; // In km
     RE=6371000;
     SS=20;

type

  { TMainForm }

  TMainForm = class(TForm)
    Start: TButton;
    H: TEdit;
    Label3: TLabel;
    km: TLabel;
    m_s: TLabel;
    Figure: TPaintBox;
    Vx: TEdit;
    Vy: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Timer:TTimer;
    procedure StartClick(Sender: TObject);
    procedure FigurePaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { private declarations }
    scale:Real;
    bmp:TBitmap;
    Sx,Sy:Integer;
    X,Y:Real;
    Vxs,Vys:Real;
    Sim:Boolean;
    procedure PutPoint(pX,pY:Real; col:TColor);
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
  Sx:=Screen.Width >> 1;
  Sy:=Screen.Height >> 1;
  Sim:=False;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  C:TCanvas;
begin
  X:=X+Vxs;
  Y:=Y+Vys;
  PutPoint(X,Y,clBlack);
  FigurePaint(Sender);
end;

procedure TMainForm.StartClick(Sender: TObject);
begin
  Timer.Enabled:=not Timer.Enabled;
  Sim:=Timer.Enabled;
  If Sim Then
    begin
        Y:=RE+StrToFloat(H.Text)*1000;
        X:=0.0;
        Vxs:=StrToFloat(Vx.Text);
        Vys:=StrToFloat(Vy.Text);
        PutPoint(X,Y, clBlue);
        FigurePaint(Sender);
        Start.Caption:='Stop'
    end
  Else
    Start.Caption:='Start';
end;

procedure TMainForm.PutPoint(pX,pY:Real; col:TColor);
var
  xi,yi:integer;
begin
  xi:=round(Sx+pX*scale);      // As the coordinate system is inverted
  yi:=round(Sy-pY*scale);
  bmp.Canvas.Pixels[xi,yi]:=col;
  bmp.Canvas.Rectangle(xi-2,yi-2,xi+2,yi+2);
end;

procedure TMainForm.FigurePaint(Sender: TObject);
var
  cx,cy:integer;
  C:TCanvas;
begin
  C:=Figure.Canvas;
  Cx:=C.Width >> 1;
  Cy:=C.Height >> 1;
  C.Draw(Cx-Sx,Cy-Sy,bmp);  //TCanvas
end;

end.

