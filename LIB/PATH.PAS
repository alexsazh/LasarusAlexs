unit path; interface

uses list, nums, vlib, llib, llibx;

type

  tpath = class(tclasslist) //of tpl
  private
    function Get(i: tint): tpl;
    procedure Put(i: tint; pl: tpl);
    function GetPoint(i,j: tint): tnum2;//i-контур,j-точка
    procedure PutPoint(i,j: tint; p: tnum2);//i-контур,j-точка
  public
    property Items[i: tint]: tpl read Get write Put; default;
    //i-контур,j-точка:
    property P[i,j: tint]: tnum2 read GetPoint write PutPoint;
  end;


implementation


function tpath.Get(i: tint): tpl;
begin
  TObject(Result) := inherited Get(i);
end;

procedure tpath.Put(i: tint; pl: tpl);
begin
  inherited Put(i,pl);
end;

function tpath.GetPoint(i,j: tint): tnum2;
begin
  Result:=Items[i][j];
end;

procedure tpath.PutPoint(i,j: tint; p: tnum2);
begin
  Items[i][j]:=p;
end;


end.
