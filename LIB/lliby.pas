// 2012
//
// tpls - набор tpl
//
unit lliby; interface

uses Windows, list, vlib, llib, llibx;

type
  tpla = class(TClassList)//of tpl
  private
  protected
  public
    constructor New;
    destructor Destroy; override;
    function Get(i: integer): tpl;
    function GetBox(var box: tnum4): boolean;
    procedure CloseAndAdd(pl: tpl);

    property Items[i: integer]: tpl read Get; default;
  end;


implementation


constructor tpla.New;
begin
  inherited New;
end;

destructor tpla.Destroy;
begin
  inherited Destroy;
end;

function tpla.Get(i: integer): tpl;
begin
  TObject(Result):=inherited Get(i);
end;

function tpla.GetBox(var box: tnum4): boolean;
var i: integer; //box2: tnum4;
begin
  Result:=FALSE;
  if Count=0 then EXIT;
  if (Count>0) and (Items[0].Count=0) then EXIT;

  Result:=TRUE;
  if Count>0 then box:=Items[0].Box;
  if Count>1 then for i:=1 to Count-1 do begin
    box:=v_boxes_add(box, Items[i].Box);
    //box:=box2;
  end;
end;

procedure tpla.CloseAndAdd(pl: tpl);
begin
  pl.Close;//llib
  Add(pl);
end;



end.
