(*
  ��� ������� ������ (���������)
  ������� ���������� � ���������� ������� � ��� "��������� �������" (!!!)

  ��� ������� ����� ������ ����� ����� "Program Reset" ��� "Application Terminate"
*)
unit dmpick; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts,
  dmw_wm;


type
  //������ ��� DMW_CLI (dmw-������ ��� PICK �� dmw_wm.pas):
  TPickMode = (
    //���� PickMode �� ����� _pickmode_idle, �� ��������� �����:
    _pickmode_idle,
    //PickPoint:
    _pickmode_tellpoint//test
    //PickVector:
    //PickObject:
  );

type
  TFormDmPick = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
  private
    DMW_CLI: TDmwPick;//dmw-������ ��� PICK �� dmw_wm.pas
    FPickMode: TPickMode;
    FSender: TWinControl;//�������������� ����� ��������� OnPick... (�.�. nil)
    procedure BeginPick(aMode: TPickMode; aSender: TWinControl);
    procedure EndPick;

    //������� �� ������� "����" �� ����� (Sender �� ������������):
    procedure OnPickPoint(Sender: TObject; p: twm_pointer);
    procedure OnPickVector(Sender: TObject; p: twm_pointer);
    procedure OnPickObject(Sender: TObject; p: twm_pointer);
    procedure OnPickCancel(Sender: TObject);
  public
    //����� ������ �������� ������� OnPick... �� ����� (aSender m.b. NIL):
    procedure PickPoint(aMode: TPickMode; aSender: TWinControl);
    procedure PickVector(aMode: TPickMode; aSender: TWinControl);
    procedure PickObject(aMode: TPickMode; aSender: TWinControl);
  end;

var
  FormDmPick: TFormDmPick;

implementation

{$R *.dfm}

uses
  wcmn, dmw_dde;



procedure TFormDmPick.BeginPick(aMode: TPickMode; aSender: TWinControl);
begin
  FPickMode := aMode;
  FSender:=aSender;
end;

procedure TFormDmPick.EndPick;
begin
  FPickMode := _pickmode_idle;
  Application.BringToFront;
  if Assigned(FSender) then FSender.SetFocus; FSender:=nil;
end;


{ ����� "Pick": }

procedure TFormDmPick.PickPoint(aMode: TPickMode; aSender: TWinControl);
begin
  BeginPick(aMode, aSender);
  dmw_Pick_wm(dmw_wm_point,0,0);
end;

procedure TFormDmPick.PickVector(aMode: TPickMode; aSender: TWinControl);
begin
  BeginPick(aMode, aSender);
  dmw_Pick_wm(dmw_wm_vector,0,0);
end;

procedure TFormDmPick.PickObject(aMode: TPickMode; aSender: TWinControl);
begin
  BeginPick(aMode, aSender);
  dmw_Pick_wm(dmw_wm_object,0,0);
end;


{ ������� �� ���� �� �����: }

//p.pp^. : p: LPoint; g: tgauss
procedure TFormDmPick.OnPickPoint(Sender: TObject; p: twm_pointer);
begin
  try
  try
    case FPickMode of

    _pickmode_tellpoint://test
    begin
      Tellf('x=%.0f  y=%.0f',[p.pp^.g.x, p.pp^.g.y]);
    end;

    end;//case
  finally
    EndPick;
  end;
  except
  end;
end;

//p.pg^. : x1,y1,x2,y2: Integer (���������� ��������):
procedure TFormDmPick.OnPickVector(Sender: TObject; p: twm_pointer);
begin
  try
  try
//    case FPickMode of

//    end;//case
  finally
    EndPick;
  end;
  except
  end;
end;

//p.po^. : offs,Code,Loc: Integer; lt,rb: LPoint; name: TShortstr
procedure TFormDmPick.OnPickObject(Sender: TObject; p: twm_pointer);
begin
  try
  try
    if p.po^.offs<=0 then abort;//!
//    case FPickMode of

//    end;//case
  finally
    EndPick;
  end;
  except
  end;
end;

procedure TFormDmPick.OnPickCancel(Sender: TObject);
begin
  EndPick;
end;


{ Events: }

procedure TFormDmPick.FormCreate(Sender: TObject);
begin
  DMW_CLI:=TDmwPick.Create(Self);
  DMW_CLI.OnPickPoint:=OnPickPoint;
  DMW_CLI.OnPickVector:=OnPickVector;
  DMW_CLI.OnPickObject:=OnPickObject;
  DMW_CLI.OnPickCancel:=OnPickCancel;
end;

procedure TFormDmPick.FormDestroy(Sender: TObject);
begin
  DMW_CLI.Free;
end;

procedure TFormDmPick.ApplicationEvents1Activate(Sender: TObject);
begin
  EndPick;//����� �� ��������!
end;

end.
