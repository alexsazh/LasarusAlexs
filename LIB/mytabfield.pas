(*
  //отображаемые поля - не использовать mytab!!!
*)
unit mytabfield; interface

uses arrayx;


type
  TMyTabField = record
    Caption: string;
    FieldName: string;
  end;

  TMyTabFields = class(TArray)
  private
    function Get(i: integer): TMyTabField;
  public
    constructor New;
    procedure Add(aMyField: TMyTabField);
    procedure AddNames(aCaption, aFieldName: string);

    property Items[i: integer]: TMyTabField read Get; default;
    property Count;
  end;


implementation

uses wcmn;


constructor TMyTabFields.New;
begin
  inherited Create( SizeOf(TMyTabField), DeltaDefault);
end;

function TMyTabFields.Get(i: integer): TMyTabField;
begin
  inherited Get(i, Result);
end;

procedure TMyTabFields.Add(aMyField: TMyTabField);
begin
  inherited Add(aMyField);
end;

procedure TMyTabFields.AddNames(aCaption, aFieldName: string);
var aMyField: TMyTabField;
begin
  aMyField.Caption:=aCaption;
  aMyField.FieldName:=aFieldName;
  Add(aMyField);//assign!
end;

end.
