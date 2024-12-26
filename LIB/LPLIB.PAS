//Point on PolyLine (LinePoint):
unit lplib; interface



type

  tlp = class
  private
    Fx: real;
    FP: TP2;
    FPL: TPl;
    FReversed: boolean;
    function GetX: real; //use FReversed
    procedure PutX(ax: real); //=>FP
  public
    constructor Create; //Fx:=-1
    constructor CreateOn(aPL:TPl; ax: long);
    procedure Reverse; //change Fx,FP

    property x: real read GetX write Putx;
    property P: tp2 read FP; //write - Putx
    property Pl: TPl read FPl; //write - in CreateOn
  end;



implementation

{ TDmPolyPoint: }


constructor TPlP.Create;
begin
//  Fx:=0;
end;

constructor TPlP.CreateOn(aPL: TPl; ax: long);
begin
  FPL:=aPL;
  FReversed:=PL.Reversed;
  PutX(ax); //=>Fx,FP
end;

Function TPlP.GetX: long;
begin
  if PL.Reversed<>Reversed then Reverse; {!}
  Result:=Fx;
end;

procedure TPlP.PutX(ax: long); //=>P
begin
  if ax<0 then ax:=0;
  if ax>PL.Len then ax:=PL.Len;

  Fx:=ax;
  FP:=PL.xP(Fx);
end;

procedure TPlP.Reverse;
begin
  x:=PL.Len-x;
  Reversed:=not Reversed;
end;





end.
