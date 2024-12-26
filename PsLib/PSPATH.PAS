unit pspath; interface

uses psobj, arrayx, list;

type
  PPsPoint = ^TPsPoint;
  TPsPoint = record
    x,y: TPsReal;
  end;

  function PsPoint(x,y: TPsReal): TPsPoint;


type
  TPsPath0 = class
    Closed: boolean;
    Modes: TIntArray;
    Points: TArray;
    constructor Create;
    destructor Destroy; override;
  end;

  TPsPath = class(TClassList)
    constructor Create;

    procedure closepath;
    procedure moveto(p: TPsPoint);
    procedure lineto(p: TPsPoint);
    procedure curveto(p1,p2,p3: TPsPoint);

    procedure NewPath;
    procedure CopyFrom(aPath: TPsPath); {newpath}
    procedure Rect(p1,p2: TPsPoint);    {add to path}
  end;


implementation

uses psgstate, psx, wcmn;


{TPsPoint:}

function PsPoint(x,y: TPsReal): TPsPoint;
begin
  Result.x:=x;
  Result.y:=y;
end;


{TPsPath0:}

constructor TPsPath0.Create;
begin
  Modes:=TIntArray.Create(100);
  Points:=TArray.Create(sizeof(TPsPoint), 100);
end;

destructor TPsPath0.Destroy;
begin
  Points.Free;
  Modes.Free;
end;


{TPsPath:}

constructor TPsPath.Create;
begin
  inherited Create(10);
end;

procedure TPsPath.closepath;
var path: TPsPath0;
begin
  if Count>0 then begin
    TObject(path):=Items[Count-1];
    path.points.get(0, GState.Position); {первая точка}

    path.Closed:=true;
  end;
end;

procedure TPsPath.moveto(p: TPsPoint);
var path: TPsPath0; i: integer;
begin
  GState.Position:=p;

  path:=TPsPath0.Create;
  Add(path);
  i:=1;
  path.Modes.Add(i);
  path.Points.Add(p);
end;

procedure TPsPath.lineto(p: TPsPoint);
var path: TPsPath0; i: integer;
begin
  if Count=0 then begin Ps.Error0('NoCurrentPoint'); exit; end;
  TObject(path):=Items[Count-1];
  GState.Position:=p;

  i:=2;
  path.Modes.Add(i);
  path.Points.Add(p);
end;

procedure TPsPath.curveto(p1,p2,p3: TPsPoint);
var path: TPsPath0; i: integer;
begin
  if Count=0 then begin Ps.Error0('NoCurrentPoint'); exit; end;
  TObject(path):=Items[Count-1];
  GState.Position:=p3;

  i:=3;
  path.Modes.Add(i);
  path.Points.Add(p1);
  path.Points.Add(p2);
  path.Points.Add(p3);
end;

procedure TPsPath.NewPath;
begin
  Clear;
end;

procedure TPsPath.CopyFrom(aPath: TPsPath); {newpath}
var p1,p2: TPsPath0; i: integer;
begin
  Clear;

  for i:=0 to aPath.Count-1 do begin
    p1:=TPsPath0(aPath.Items[i]);
    p2:=TPsPath0.Create;

    p2.Closed:=p1.Closed;
    p2.Modes.Count:=p1.Modes.Count;
    memcpy( p2.Modes.Memory, p1.Modes.Memory, p2.Modes.Count*p2.Modes.ItemSize );
    p2.Points.Count:=p1.Points.Count;
    memcpy( p2.Points.Memory, p1.Points.Memory, p2.Points.Count*p2.Points.ItemSize );

    Add(p2);
  end;
end;

procedure TPsPath.Rect(p1,p2: TPsPoint);
var a1,a2: TPsPoint;
begin
  a1.x:=p2.x;
  a1.y:=p1.y;
  a2.x:=p1.x;
  a2.y:=p2.y;

  moveto(p1);
  lineto(a1);
  lineto(p2);
  lineto(a2);

  closepath;
end;


end.
