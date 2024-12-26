unit wmPick;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, dmw_wm,OTypes, Dmw_ddw,
  ExtCtrls;

type
  TFPick = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
  procedure PickPoint(Sender: TObject;
                                p: twm_pointer);
  procedure PickObject(Sender: TObject;
                                 p: twm_pointer);
  procedure PickVector(Sender: TObject;
                                 p: twm_pointer);

  procedure PickRect(Sender: TObject;
                               p: twm_pointer);
  procedure PickPort(Sender: TObject;
                               p: twm_pointer);
  procedure PickGeoid(Sender: TObject;
                               p: twm_pointer);
  procedure PickRing(Sender: TObject;
                               p: twm_pointer);


  procedure PickCancel(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    cli: TDmwPick;

  end;
function wm_Pickpoint(var a:lpoint; var g:tgauss):boolean;
function wm_PickObject(var wmoffs,wmCode: longint; var wmTag: byte;
                        var wmlt,wmrb:lpoint;
                        var name: Shortstring): boolean;
function wm_PickVector(var av,bv:lpoint):boolean;
function wm_PickRect(var ar,br:lpoint):boolean;
function wm_PickPort(w,h: longint; var ap,bp:lpoint): boolean;
function wm_PickGeoid(w,h: longint; var ap,bp:lpoint): boolean;
function wm_PickRing(var x,y,r: longint): boolean;
procedure delay;

var
  FPick: TFPick;
  lp,lt,rb,V1,v2,r1,r2,p1,p2,lg1,lg2,ring1,ring2:lpoint;
 tg:tgauss;
 offs,Code,Ltimer:integer;
 objname:AnsiString;
 Loc:byte;
 fl_exit,fL_cancel, fl_Point,fl_object,fl_vector,fl_rect, fl_port, fl_Geoid, fl_Ring:boolean;

implementation

{$R *.lfm}
procedure delay;
begin
 Ltimer:=0;
 Fpick.Timer1.Enabled:=true;
 while Ltimer<1 do
  application.ProcessMessages;
 Fpick.Timer1.Enabled:=false;
end;
function wm_PickPoint(var a:lpoint; var g:tgauss):boolean;
begin
  fL_cancel:=false;
  fL_Exit:=false;
  fl_Point:=false;
  dmw_Pick_wm(dmw_wm_point,0,0);
  while not (fl_cancel or Fl_point or fL_Exit) do Application.ProcessMessages;
  if fl_cancel or fL_Exit then begin Result:=false; exit end;
  Result:=true;
  a:=lp;
  g:=tg;
end;
procedure TFPick.PickPoint(Sender: TObject;
                                p: twm_pointer);
begin
 lp:=p.pp^.p;
 tg:=p.pp^.g;
 fl_Point:=true;
end;
function wm_PickObject(var wmoffs,wmCode: longint; var wmTag: byte;
                        var wmlt,wmrb:lpoint;
                        var name: Shortstring): boolean;
begin
  fL_cancel:=false;
   fL_Exit:=false;

  fl_Object:=false;
  dmw_Pick_wm(dmw_wm_object,0,0);
  while not (fl_cancel or Fl_Object or fL_Exit) do Application.ProcessMessages;
  if fl_cancel or fL_Exit then begin Result:=false; exit end;
  Result:=true;

  wmoffs:=offs;
  wmCode:=Code;
  wmTag:=Loc;
  wmlt:=lt;
  wmrb:=rb;
  if Length(ObjName) >255 then
  name:=copy(objName,1,255)
  else
    name:=objName;
 delay;
end;

procedure TFPick.PickObject(Sender: TObject;
                                 p: twm_pointer);
begin
  offs:=p.po^.offs;
  Code:=p.po^.Code;
  loc:=p.po^.Loc;
  lt:=p.po^.lt;
  rb:=p.po^.rb;
  objName:=p.po.name;
  fl_object:=true;
end;

function wm_PickVector(var av,bv:lpoint):boolean;
begin
  fL_cancel:=false;
   fL_Exit:=false;

  fl_Vector:=false;
  dmw_Pick_wm(dmw_wm_vector,0,0);
  while not (fl_cancel or Fl_Vector or fL_Exit) do Application.ProcessMessages;
  if fl_cancel or fL_Exit then begin Result:=false; exit end;
  Result:=true;
  av:=V1;
  bv:=V2;
end;

procedure TFPick.PickVector(Sender: TObject;
                                 p: twm_pointer);
begin
  V1.x:=p.pg^.x1;
  V1.y:=p.pg^.y1;
  V2.x:=p.pg^.x2;
  V2.y:=p.pg^.y2;
  fl_vector:=true;
end;

function wm_PickRect(var ar,br:lpoint):boolean;
begin
  fL_cancel:=false;
   fL_Exit:=false;
 
  fl_Rect:=false;
  dmw_Pick_wm(dmw_wm_Rect,0,0);
  while not (fl_cancel or Fl_Rect or fL_Exit) do Application.ProcessMessages;
  if fl_cancel or fL_Exit then begin Result:=false; exit end;
  Result:=true;
  ar:=r1;
  br:=r2;
end;

procedure TFPick.PickRect(Sender: TObject;
                               p: twm_pointer);
begin
  r1.x:=p.pg^.x1;
  r1.y:=p.pg^.y1;
  r2.x:=p.pg^.x2;
  r2.y:=p.pg^.y2;
  fl_Rect:=true;
end;

function wm_PickPort(w,h: longint; var ap,bp:lpoint): boolean;
begin
  fL_cancel:=false;
  fL_Exit:=false;

  fl_Port:=false;
  dmw_Pick_wm(dmw_wm_Port,w,h);
  while not (fl_cancel or Fl_Port or fL_Exit) do Application.ProcessMessages;
  if fl_cancel or fL_Exit then begin Result:=false; exit end;
  Result:=true;
  ap:=p1;
  bp:=p2;
end;

procedure TFPick.PickPort(Sender: TObject;
                               p: twm_pointer);
begin
  p1.x:=p.pg^.x1;
  p1.y:=p.pg^.y1;
  p2.x:=p.pg^.x2;
  p2.y:=p.pg^.y2;
  fl_Port:=true;
end;

function wm_PickGeoid(w,h: longint; var ap,bp:lpoint): boolean;
begin
  fL_cancel:=false;
  fL_Exit:=false;
  fl_Geoid:=false;
  dmw_Pick_wm(dmw_wm_Geoid,w,h);
  while not (fl_cancel or Fl_Geoid or fL_Exit) do Application.ProcessMessages;
  if fl_cancel or fL_Exit then begin Result:=false; exit end;
  Result:=true;
  ap:=lg1;
  bp:=lg2;
end;


procedure TFPick.PickGeoid(Sender: TObject;
                               p: twm_pointer);
begin
  lg1.x:=p.pg^.x1;
  lg1.y:=p.pg^.y1;
  lg2.x:=p.pg^.x2;
  lg2.y:=p.pg^.y2;
  fl_Geoid:=true;
end;

function wm_PickRing(var x,y,r: longint): boolean;
begin
  fL_cancel:=false;
  fL_Exit:=false;
  fl_Ring:=false;
  dmw_Pick_wm(dmw_wm_Ring,0,0);
  while not (fl_cancel or Fl_Ring or fL_Exit) do Application.ProcessMessages;
  if fl_cancel or fL_Exit then begin Result:=false; exit end;
  Result:=true;
  x:=ring1.x;
  y:=ring1.y;
  r:=ring2.x;
end;

procedure TFPick.PickRing(Sender: TObject;
                               p: twm_pointer);
begin
  ring1.x:=p.pg^.x1;
  ring1.y:=p.pg^.y1;
  ring1.x:=p.pg^.x2;
  fl_Ring:=true;
end;


procedure TFPick.PickCancel(Sender: TObject);
begin
  fl_Cancel:=true
end;

procedure TFPick.FormCreate(Sender: TObject);
begin
 cli:=TDmwPick.Create;
 cli.OnPickObject:=PickObject;
 cli.OnPickPoint:=PickPoint;
 cli.OnPickVector:=PickVector;
 cli.OnPickRect:=PickRect;
 cli.OnPickPort:=PickPort;
 cli.OnPickGeoid:=PickGeoid;
 cli.OnPickRing:=PickRing;
 cli.OnPickCancel:=PickCancel;
end;

procedure TFPick.FormDestroy(Sender: TObject);
begin
cli.Free;

end;

procedure TFPick.Timer1Timer(Sender: TObject);
begin
inc(Ltimer);
end;

end.
