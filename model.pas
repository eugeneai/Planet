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
     SS=13;
     iters=1000;
     timescale=100.0;
     GM=4e14;

type

  { TMainForm }

  TMainForm = class(TForm)
    QuitButton: TButton;
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
    procedure QuitButtonClick(Sender: TObject);
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
    ccol:TColor;
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
  scale:=Screen.Height/(2*RE)/SS;

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
  ccol:=clBlack;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  C:TCanvas;
  dt,ax,ay,r,r3:Double;
  i:integer;
begin
  dt:=1*timescale/iters;
  for i:=1 to iters do
     begin
       r:=sqrt(sqr(X)+sqr(Y));
       r3:=r*r*r;
       ax:=-GM*x/r3;
       ay:=-GM*y/r3;
       Vxs:=Vxs+dt*ax;
       Vys:=Vys+dt*ay;
       X:=X+dt*Vxs;
       Y:=Y+dt*Vys;
       PutPoint(X,Y,ccol);
       if (r<RE) then
         begin
             StartClick(Sender);
             break;
         end;
     end;
   Figure.Repaint;
end;

procedure TMainForm.StartClick(Sender: TObject);
var
  sim:Boolean;
begin
  Timer.Enabled:=not Timer.Enabled;
  sim:=Timer.Enabled;
  If sim Then
    begin
        Y:=RE+StrToFloat(H.Text)*1000;
        X:=0.0;
        Vxs:=StrToFloat(Vx.Text);
        Vys:=StrToFloat(Vy.Text);
        PutPoint(X,Y, ccol);
        Figure.Repaint;
        Start.Caption:='Stop'
    end
  Else
    begin
      Start.Caption:='Start';
      ccol:=RGBToColor(Random(256),Random(128),Random(256));
    end;
end;

procedure TMainForm.QuitButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.PutPoint(pX,pY:Real; col:TColor);
var
  xi,yi:integer;
begin
  xi:=round(Sx+pX*scale);      // As the coordinate system is inverted
  yi:=round(Sy-pY*scale);
  bmp.Canvas.Pixels[xi,yi]:=ccol;
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

