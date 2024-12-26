unit dicts; interface

uses Classes;

type
  //имена не повтор€ютс€:
  tsdict = class(tstringlist)
  private
    function GetVal(name: string): string;
    procedure PutVal(name,val: string);
  public
    property Val[name: string]: string read GetVal write PutVal;
  end;


implementation


function tsdict.GetVal(name: string): string;
begin
  Result:=Values[name];
end;

procedure tsdict.PutVal(name,val: string);
var i: integer;
begin
  i:=IndexOfName(name);
  if i>=0 then Strings[i]:=name+'='+val else Values[name]:=val;
end;


end.
