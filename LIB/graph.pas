//
// график ф-ии y(x) <xa+ya: tnuma>
// xa возростает монотонно, xa и ya параллельны
//
unit graph; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  nums, vlib;


type
  TFormGraph = class(TForm)
    PaintBox1: TPaintBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    _xa,_ya: tnuma;//y(x) для перерисовки в PaintBox1Paint
    _box: tnum4;
  public
    procedure draw_fun(xa,ya: tnuma);
  end;

var
  FormGraph: TFormGraph;


implementation

{$R *.dfm}

uses wcmn, llib, rlib;


procedure TFormGraph.draw_fun(xa,ya: tnuma);
var ind: integer;
begin
  Visible:=FALSE;

  _xa.Clear; _xa.AddFrom(xa);
  _ya.Clear; _ya.AddFrom(ya);

  _box.a.x:=_xa.First;//_xa возростает
  _box.a.y:=_ya.min(ind);//y вниз!
  _box.b.x:=_xa.Last;//_xa возростает
  _box.b.y:=_ya.max(ind);//y вниз!

  Visible:=TRUE;//=> PaintBox1Paint
end;


{EVENTS:}

procedure TFormGraph.PaintBox1Paint(Sender: TObject);
var dx,dy: double; Rects: TRects; Marg: tnum4;
begin
  dx:=(10{мм}/25.4){inch}*Self.PixelsPerInch;//поля слева
  dy:=dx;//поля снизу
  Marg.a.x:=dx;
  Marg.a.y:=1;
  Marg.b.x:=1;
  Marg.b.y:=dy;
  Rects:=TRects.CreateFun(_box, PaintBox1.ClientRect, Marg);
  try

    Rects.draw_box(PaintBox1.Canvas, _box, clBlack, 1{w});
    Rects.draw_box(PaintBox1.Canvas, Rects.DSrcNew, clBlack, 1{w});
    Rects.draw_fun(PaintBox1.Canvas, _xa,_ya, clRed, 1{w});

  finally
    Rects.Free;
  end;
end;


procedure TFormGraph.FormCreate(Sender: TObject);
begin
  _xa:=tnuma.New;
  _ya:=tnuma.New;

  Ini.RForm(Self);
end;

procedure TFormGraph.FormDestroy(Sender: TObject);
begin
  Ini.WForm(Self);

  _ya.Free;
  _xa.Free;
end;


end.
