unit psgstate; interface

uses psmat, color, pspath, psobj, arrayx, list;


type
  TDash = record
    ofs: TPsReal;
    a: TArray;
  end;

  TGState = class
  private
  public
    CTM: TMatrix2;
    Color: TCMYKColor;
    Position: TPsPoint;

    Path: TPsPath;
    ClipPath: TPsPath;

    Width: TPsReal;
    LineCap: Integer;
    LineJoin: Integer;
    MiterLimit: TPsReal;

    Dash: TDash;

    constructor Create;
    destructor Destroy; override;

    procedure Concat(pm: PMatrix2);

    procedure CopyFrom(aGState: TGState);
    procedure GSave;
    procedure GRestore;
  end;


var
  GState: TGState;
  GStateList: TClassList;


implementation

uses wcmn;


constructor TGState.Create;
begin
  CTM:=m2_init;
  Width:=1;
  MiterLimit:=10;

  Path:=TPsPath.Create;
  ClipPath:=TPsPath.Create;

  Dash.a:=TArray.Create(sizeof(TPsReal), 2);
end;

destructor TGState.Destroy;
begin
  Dash.a.Free;

  Path.Free;
  ClipPath.Free;
end;

procedure TGState.Concat(pm: PMatrix2);
begin
  CTM := m2_mul( pm, @CTM );
end;

procedure TGState.CopyFrom(aGState: TGState);
begin
  CTM:=aGState.CTM;
  Color:=aGState.Color;
  Position:=aGState.Position;

  Path.CopyFrom(aGState.Path);
  ClipPath.CopyFrom(aGState.ClipPath);

  Width:=aGState.Width;
  LineCap:=aGState.LineCap;
  LineJoin:=aGState.LineJoin;
  MiterLimit:=aGState.MiterLimit;

  Dash.ofs:=aGState.Dash.ofs;
  Dash.a.count:=aGState.Dash.a.count;
  memcpy(Dash.a.memory, aGState.Dash.a.memory, Dash.a.count*Dash.a.ItemSize);
end;

procedure TGState.GSave;
var gs: TGState;
begin
  gs:=TGState.Create;
  GStateList.Add(gs);
  gs.CopyFrom(GState);
end;

procedure TGState.GRestore;
var gs: TGState;
begin
  if GStateList.Count=0 then exit;
  TObject(gs):=GStateList[GStateList.Count-1]; {верхний}
  GState.CopyFrom(gs);
  GStateList.Count:=GStateList.Count-1;
end;


end.
