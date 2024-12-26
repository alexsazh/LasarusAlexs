unit Tree; interface

uses Comctrls, list;


type
  TClassNode = class
  private
  public
    Left, Right, Up , Down: TClassNode;
    ViewNode: TTreeNode;//comctrls(Delphi)
    Data: TObject;
    constructor Create;
    constructor CreateWithObj(o: TObject);//дополнительно к Create
    destructor Destroy; override;
  end;

  TClassNode2 = class(TClassNode)
    destructor Destroy; override;//call Data.Free(!)
  end;

  TActProc = procedure(aNode: TClassNode; var v);
  TChildTestProc = procedure(aParent, aChild: TClassNode; var data);
  TAddToRootProc = procedure(aNode: TClassNode);
  TTreeTestFunc = function(aNode: TClassNode; p: pointer): boolean;


  TClassTree = class
  private
    FRoot: TClassNode; //всегда есть
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    //from aNode:
    procedure ForAllChilds(aNode: TClassNode; aAct: TActProc; var v);//один уровень
    procedure ForAll(aNode: TClassNode; aAct: TActProc; var v);//для aNode и ниже
    function Find(aNode: TClassNode; aTest: TTreeTestFunc; p: pointer): TClassNode;

    procedure ToList(aList: TClassList);

    //goto=false => x не меняется:
    function gotoleft(var x: TClassNode): boolean;
    function gotoright(var x: TClassNode): boolean;
    function gotoup(var x: TClassNode): boolean;
    function gotodown(var x: TClassNode): boolean;
    procedure gotohome(var x: TClassNode);
    procedure gotolast(var x: TClassNode);

    //Add: NewNode.Down сохраняется:
    procedure AddLast(aNode, NewNode: TClassNode);//aNode.Right=nil
    procedure AddFirstChild(aNode, NewNode: TClassNode);//aNode.Down=nil
    procedure AddChild(aNode, NewNode: TClassNode);//в конец детей или первым ребенком

    //aNode и его потомки изымаются из дерева, возвращает aNode.Up, m.b aNode.Up=nil:
    function ExtractSubTree(aNode: TClassNode): TClassNode;

    //data: дополн.данные
    procedure BuildFromList(aList: TClassList; aChildTest: TChildTestProc; aAddToRoot: TAddToRootProc; var data);

    property Root: TClassNode read FRoot;
  end;


implementation

uses SysUtils, wcmn, runline{, opt};

var
  _ActRec: record
    aList: TClassList;
  end;


{ TClassNode: }

constructor TClassNode.Create;
begin
end;

constructor TClassNode.CreateWithObj(o: TObject);
begin
  Create;
  Data:=o;
end;

destructor TClassNode.Destroy;
begin
end;


{ TClassNode2: }

destructor TClassNode2.Destroy;
begin
  Data.Free;
  inherited Destroy;
end;


{ TClassTree: }

constructor TClassTree.Create;
begin
  FRoot:=TClassNode.Create;
end;

destructor TClassTree.Destroy;
begin
  Clear;//root exists
  Froot.Free;
end;

procedure TClassTree.Clear;
var aList: TClassList;
begin
  //free all:
  aList:=TClassList.Create(512);
  ToList(aList);
  aList.Free;
  //new root:
  FRoot:=TClassNode.Create;
end;

procedure TClassTree.ForAllChilds(aNode: TClassNode; aAct: TActProc; var v);
begin
  aNode:=aNode.Down;
  while aNode<>nil do begin
    aAct(aNode,v);
    aNode:=aNode.Right;
  end;
end;

procedure TClassTree.ForAll(aNode: TClassNode; aAct: TActProc; var v);
begin
  aAct(aNode, v);

  aNode:=aNode.Down;//m.b. nil
  while aNode<>nil do begin
    ForAll(aNode, aAct, v);
    aNode:=aNode.Right;
  end;
end;

function TClassTree.Find(aNode: TClassNode; aTest: TTreeTestFunc; p: pointer): TClassNode;
begin
  Result:=nil;
  if aNode=nil then aNode:=Root; {!}

  if aTest(aNode, p) then begin Result:=aNode; exit; end;

  aNode:=aNode.Down;//m.b. nil
  while aNode<>nil do begin
    Result:=Find(aNode, aTest, p);
    if Result<>nil then exit;
    aNode:=aNode.Right;
  end;
end;



procedure _ToList_Act(aNode: TClassNode; var v);
begin
  _ActRec.aList.Add(aNode);
end;
procedure TClassTree.ToList(aList: TClassList);
var v: integer;
begin
  aList.Clear;
  _ActRec.aList:=aList;
  ForAll(FRoot, _ToList_Act, v);
end;


function TClassTree.gotoleft(var x: TClassNode): boolean;
begin
  if x.left=nil then Result:=false else begin x:=x.left; Result:=true; end;
end;
function TClassTree.gotoright(var x: TClassNode): boolean;
begin
  if x.right=nil then Result:=false else begin x:=x.right; Result:=true; end;
end;
function TClassTree.gotoup(var x: TClassNode): boolean;
begin
  if x.up=nil then Result:=false else begin x:=x.up; Result:=true; end;
end;
function TClassTree.gotodown(var x: TClassNode): boolean;
begin
  if x.down=nil then Result:=false else begin x:=x.down; Result:=true; end;
end;
procedure TClassTree.gotohome(var x: TClassNode);
begin
  while gotoleft(x) do ;
end;
procedure TClassTree.gotolast(var x: TClassNode);
begin
  while gotoright(x) do ;
end;


procedure TClassTree.AddLast(aNode, NewNode: TClassNode);
begin
  aNode.Right:=NewNode;
  NewNode.Left:=aNode;
  NewNode.Right:=nil;
  NewNode.Up:=aNode.Up;
  {if NewNode.Down<>nil then Tell('Warning: TClassTree.AddLast: NewNode.Down<>nil');}
end;
procedure TClassTree.AddFirstChild(aNode, NewNode: TClassNode);
begin
  aNode.Down:=NewNode;
  NewNode.Left:=nil;
  NewNode.Right:=nil;
  NewNode.Up:=aNode;
  {if NewNode.Down<>nil then Tell('Warning: TClassTree.AddFirstChild: NewNode.Down<>nil');}
end;
procedure TClassTree.AddChild(aNode, NewNode: TClassNode);
begin
  if gotodown(aNode) then begin
    gotolast(aNode);
    AddLast(aNode, NewNode);
  end else begin
    AddFirstChild(aNode, NewNode);
  end;
end;

function TClassTree.ExtractSubTree(aNode: TClassNode): TClassNode;
begin
  Result:=aNode.up;
  if aNode.up=nil then exit;

  if aNode.up.down<>aNode then begin//aNode.left<>nil:
    aNode.left.right:=aNode.right;
    if aNode.right<>nil then aNode.right.left:=aNode.left;
  end else begin//aNode.left=nil:
    aNode.up.down:=aNode.right;
    if aNode.right<>nil then aNode.right.left:=nil;
  end;

  aNode.up:=nil;
  aNode.left:=nil;
  aNode.right:=nil;
end;

procedure TClassTree.BuildFromList(aList: TClassList; aChildTest: TChildTestProc; aAddToRoot: TAddToRootProc; var data);
var i,j: integer; xi,xj: TClassNode; xList: TPtrList;
begin
  Clear;

  //initialization:
  RunForm.Start('Построение дерева по списку');//cursor
  xList:=TPtrList.Create(512);
  try

    //список узлов:
    if aList.Count>0 then for i:=0 to aList.Count-1 do
      xList[i]:=TClassNode.CreateWithObj( aList[i] );

    //сбор детей: i: Parent, j: Child:
    if xList.Count>0 then for i:=0 to xList.Count-1 do begin

      if RunForm.Cancelled then break;
      RunForm.Go((i+1)/xList.Count);

      xi:=xList[i];
      if xList.Count>0 then for j:=0 to xList.Count-1 do begin

        if j=i then continue;

        xj:=xList[j];

        aChildTest(xi, xj, data);

      end;{for j}

    end;{for i}

    //целостность дерева:
    if xList.Count>0 then for i:=0 to xList.Count-1 do begin
      xi:=xList[i];
      if xi.up=nil then aAddToRoot(xi);
    end;

  finally
    xList.Free;
    RunForm.Finish;
  end;{try}
end;


end.
