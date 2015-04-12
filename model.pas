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
     RE=6371000.0;
     SS=20;
     GM=4e14;
     iters=1000;

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
    Sx,Sy,Sye:Integer;
    X,Y:Real;
    Vxs,Vys:Real;
    ccol:TColor;
    function PutPoint(pX,pY:Real; col:TColor):Boolean;
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
  Vx.Text:=FloatToStr(defVx);
  Vy.Text:=FloatToStr(defVy);
  H.Text:=FloatToStr(defH);
  m_s.Caption:='m/s';

  bmp:=TBitmap.Create;
  bmp.SetSize(Screen.Width, Screen.Height);
  C:=bmp.Canvas;
  C.FillRect(0,0,Screen.Width,Screen.Height);
  C.Pen.Color:=RGBToColor(100,190,255);
  C.Brush.Color:=RGBToColor(100,150,255);
  Sx:=Screen.Width >> 1;
  Sy:=Screen.Height >> 1;
  Sye:=Sy >> 1;
  scale:=Sy/RE/SS;
  R:=trunc(RE * scale);
  C.Ellipse(Sx-R,Sye-R,Sx+R,Sye+R);
  ccol:=clBlack;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  C:TCanvas;
  ax,ay,r,r3,dt:Real;
  i:integer;
begin
  dt:=1.0;
  for i:=1 to iters do
  begin
    r:=sqrt(sqr(X)+sqr(Y));
    r3:=r*r*r;
    ax:=-GM*X/r3;
    ay:=-GM*Y/r3;
    Vxs:=Vxs+dt*ax;
    Vys:=Vys+dt*ay;
    X:=X+dt*Vxs;
    Y:=Y+dt*Vys;
//    if (r<RE) or (PutPoint(X,Y,ccol)) then
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
  Sim:=Timer.Enabled;
  If Sim Then
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

function TMainForm.PutPoint(pX,pY:Real; col:TColor):Boolean;
var
  xi,yi:integer;
begin
  xi:=round(Sx+pX*scale);      // As the coordinate system is inverted
  yi:=round(Sye-pY*scale);
  PutPoint:=bmp.Canvas.Pixels[xi,yi]=ccol; // Trajectory has fully figured out
  bmp.Canvas.Pixels[xi,yi]:=ccol;
end;

procedure TMainForm.FigurePaint(Sender: TObject);
var
  cx,cy, by:integer;
  C:TCanvas;
begin
  C:=Figure.Canvas;
  Cx:=C.Width >> 1;
  Cy:=C.Height >> 1;
  by:=Cy-Sye;
  if by>0 then by:=0;
  C.Draw(Cx-Sx,by,bmp);  //TCanvas
end;

end.
