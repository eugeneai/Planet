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
     iters=1000;
     timescale=100.0;
     GM=4e14;
     SR=6;

type

  { TMainForm }

  TMainForm = class(TForm)
    EV: TEdit;
    ET: TEdit;
    Label4: TLabel;
    Label5: TLabel;
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
    Sx,Sy,Sye:Integer;
    X,Y:Real;
    Vxs,Vys:Real;
    ccol:TColor;
    T:double;
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
  R:Integer;
begin
  Vx.Text:=FloatToStr(defVx);
  Vy.Text:=FloatToStr(defVy);
  H.Text:=FloatToStr(defH);
  m_s.Caption:='m/s';
  scale:=Screen.Height/(2*RE)/SS;

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
   T:=T+dt*i;
   Figure.Repaint;
   EV.Text:=FloatToStr(sqrt(sqr(Vxs)+sqr(Vys)));
   ET.Text:=FloatToStr(T/60.0);
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
        Start.Caption:='Stop';
        T:=0.0;
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

function TMainForm.PutPoint(pX,pY:Real; col:TColor):Boolean;
var
  xi,yi:integer;
begin
  xi:=round(Sx+pX*scale);      // As the coordinate system is inverted
  yi:=round(Sye-pY*scale);
  PutPoint:=bmp.Canvas.Pixels[xi,yi]=col;
  bmp.Canvas.Pixels[xi,yi]:=col;
end;

procedure TMainForm.FigurePaint(Sender: TObject);
var
  cx,cy, by,by1:integer;
  C:TCanvas;
  xi,yi:integer;
begin
  C:=Figure.Canvas;
  Cx:=Figure.ClientWidth >> 1;
  Cy:=Figure.ClientHeight >> 1;
  by:=Cy-Sye;
  by1:=by;
  if by>0 then by:=0;
  C.Draw(Cx-Sx,by,bmp);  //TCanvas
  if (abs(X)>1000) and (abs(Y)>1000) then
    begin
      xi:=round(Cx+X*scale);      // As the coordinate system is inverted
      if by=0 then Cy:=Sye;
      yi:=round(Cy-Y*scale);
      C.Ellipse(xi-SR,yi-SR,xi+SR,yi+SR);
    end;
end;

end.
