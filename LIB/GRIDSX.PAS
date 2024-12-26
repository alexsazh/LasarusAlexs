unit gridsx; interface

uses
  Windows, Grids, Forms, Classes,
  wcmn;

type
{
  TStringGridX - надстройка над TStringGrid.
  Текст в первой строке aGrid должен быть.
  Он переносится в FHeader и выводится с переносом слов
  и центрированием.
  Функция OnDrawCell - реакция на соотв-ее событие в aGrid;
}
  TStringGridX = class
  private
    FGrid: TStringGrid; {VCL}
    FHeader: TStringList; {Header}
    {procedure DrawCellTextStd(aRect: TRect; S: string);}
    procedure DrawCellTextWrap(aRect: TRect; Text: string);
  public
    constructor Create(aGrid: TStringGrid);
    destructor Destroy; override;
    procedure OnDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect;
      aState: TGridDrawState);
  end;


implementation


{ TStringGridX methods: }

constructor TStringGridX.Create(aGrid: TStringGrid);
var i: integer;
begin
  inherited Create;

  FGrid:=aGrid;
  FHeader:=TStringList.Create;

  with FGrid do for i:=0 to ColCount do begin
    FHeader.Add( Cells[i,0] );
    Cells[i,0] := '';
  end;

  FGrid.OnDrawCell := OnDrawCell;
end;

destructor TStringGridX.Destroy;
begin
  FHeader.Free;
end;


{ Draw Cell: }

(*
procedure TStringGridX.DrawCellTextStd(aRect: TRect; S: string);
begin
  ExtTextOut(FGrid.Canvas.Handle, aRect.Left + 2, aRect.Top + 2,
    ETO_CLIPPED or ETO_OPAQUE, @aRect, PChar(S), Length(S), nil);
end;
*)
procedure TStringGridX.DrawCellTextWrap(aRect: TRect; Text: string);
begin
  DrawText(FGrid.Canvas.Handle, PChar(Text), Length(Text), aRect,
    DT_WORDBREAK or DT_CENTER);
end;

procedure TStringGridX.OnDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var S: string;
begin
  if aRow=0 then begin
    S:=FHeader[aCol];
    {DrawCellTextStd(aRect, S);}
    DrawCellTextWrap(aRect, S);
  end;
end;


end.{of unit}
