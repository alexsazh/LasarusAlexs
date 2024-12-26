(*
  ������� ��� �������(tab.dpr) � ��� ������(addrtf.dpr)
*)
unit area; interface

uses dmlib, nums, areapick;

type
  TTTArea = class(tdmo)
  private
  public
    DmName: string;
    ofs: tint;
    procedure Read; override;//� �������(!)
    function sInfo: string; virtual;
    //����� � DMW:
    procedure PickArea(aOnPickArea: TOnPickArea);//=>�������� DMW-Click, ofs(default)=0 (areapick.pas)
    //����� � DLL:
    //function IsCorrectPosition(msg: boolean): boolean;//������� ��� � ������
    function IsCorrectDataDMW(msg: boolean): boolean;
    procedure Del;
  end;

  //�������:
  TTabArea = class(TTTArea)
  private
  public
    //����� � DLL:
    function GetWidth: tint;//������ ����� �������
    procedure GetLinesPositions(xa: tnuma);//x-������� ������-�� �����
    procedure ReDrawArea(lWidth,lHeight: longint);
  end;

  //�����:
  TTxtArea = class(TTTArea)
  private
  public
    line0,line1: integer;//��� ���������� �����
    function sInfo: string; override;
    //����� � DLL:
    procedure Del;//����� �����!
    procedure ReDrawArea(lHeight: longint);//lHeight=0 => ������ �� ��������
  end;


implementation

uses
  SysUtils, Forms,
  dmw_use, otypes,
  dmwlib, wcmn, vlib, llibx, cmn;


{ TTTArea: }

procedure TTTArea.Read;
begin
  inherited Read;
  DmName:=DMW.ActiveMap;
end;

function TTTArea.sInfo: string;
begin
  Result:=Format('%s (%d) (%d)',[scode,loc,ofs]);
end;


procedure TTTArea.PickArea(aOnPickArea: TOnPickArea);
begin
  FormAreaPick.PickObject(aOnPickArea);
end;


function TTTArea.IsCorrectDataDMW(msg: boolean): boolean;
begin
  Result:=false;

  if ofs=0 then begin
    if msg then Tell('Area: ������������ ����� �������');
    exit;
  end;

  if (loc<>3) and (loc<>2) then begin
    if msg then Tell('Area: ������������ �������� ����������� �������');
    exit;
  end;

  if DmName<>DMW.ActiveMap then begin
    if msg then Tell('Area: �� �� �����');
    exit;
  end;

  Result:=true;
end;


procedure TTTArea.Del;
begin
  if dm_goto_node(ofs) then DelChildren;
end;


{ TTabArea: }


function TTabArea.GetWidth: tint;
begin
  Result:=Round( abs(Points.box.b.x-Points.box.a.x) );
end;


//x-������� ������-�� �����:
procedure TTabArea.GetLinesPositions(xa: tnuma);
var ofs0: tint; fi,x: tnum; p1,p2: tnum2; pl: tpl; dmo: tdmo;
begin
  xa.clear;
//  xa.add(Points.box.a.x);//����� ����

  //������� ����� ������-�� �������� ����� pl:
  ofs0:=dm_object;
  pl:=tpl.New;
  dmo:=tdmo.Create;
  try
    //����:
    if dm_goto_down then repeat
      dmo.Read;
      if dmo.Loc<>2 then continue;
      if dmo.Points.Count<>2 then continue;
      p1:=dmo.Points.First;
      p2:=dmo.Points.Last;
      fi:=v_fi( v_sub(p1,p2) );
      if abs(abs(fi)-90)>10 then continue;//���������� �� ��������� <=10 ����.
      if p1.y<p2.y then x:=p1.x else x:=p2.x;//x-���������� ������� �����
      xa.Add(x);
    until not dm_goto_right;
  finally
    pl.Free;
    dm_goto_node(ofs0);
  end;

//  xa.add(Points.box.b.x);//������ ����

  //���������:
  xa.Sort(nil);//!
(*
  if abs(xa.first-Points.box.a.x)>3 then begin
    x:=Points.box.a.x; xa.insert(0,x);//����� ����
  end;
*)  
end;


procedure TTabArea.ReDrawArea(lWidth,lHeight: longint);
var area: tdmo; lp: lpoint;
begin
  if not dm_goto_node(ofs) then exit;
  area:=tdmo.CreateFromDm;
  try
    lp:=Num2ToLp(area.Points.box.a);
    area.Points.Clear;
    area.Points.AddRect(lp.x, lp.y, lp.x+lWidth, lp.y+lHeight);
    area.WritePoints;
  finally
    area.free;
  end;
end;



{ TTxtArea: }


function TTxtArea.sInfo: string;
begin
  Result := inherited sInfo;
end;

procedure TTxtArea.Del;//����� �����!
begin
  if dm_goto_node(ofs) then DelChildren2;
end;

procedure TTxtArea.ReDrawArea(lHeight: longint);//lHeight=0 => ������ �� ��������
var box: tnum4;
begin
  if not dm_goto_node(ofs) then exit;
  box:=Points.Box;
  if lHeight>0 then box.b.y := box.a.y + lHeight;
  Points.Clear;
  Points.AddRect(box.a.x, box.a.y, box.b.x, box.b.y);
  Points.Reverse;
  WritePoints;
end;


end.
