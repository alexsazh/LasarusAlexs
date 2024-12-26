(*
  dmpick for area.pas (TTTArea.PickInDmw)
*)
unit areapick; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts,
  dmw_wm;


type
  TOnPickArea = procedure(aOffs: integer) of object;//������� �� DMW-Click

  TFormAreaPick = class(TForm)
    ApplicationEvents1: TApplicationEvents;//������� �� DMW-Click (������������ �����)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
  private
    DMW_CLI: TDmwPick;//dmw-������ ��� PICK �� dmw_wm.pas
    OnPickArea: TOnPickArea;
    procedure EndPick;

    //������� �� ������� "����" �� ����� (Sender �� ������������):
    procedure OnPickObject(Sender: TObject; p: twm_pointer);
    procedure OnPickCancel(Sender: TObject);
  public
    //����� ������ �������� ������� OnPick... �� ����� (aSender m.b. NIL):
    procedure PickObject(aOnPickArea: TOnPickArea);
  end;

var
  FormAreaPick: TFormAreaPick;

implementation

{$R *.dfm}

uses
  wcmn, dmw_ddw, cmn;


procedure TFormAreaPick.EndPick;
begin
  OnPickArea:=nil;
  Application.BringToFront;
end;


{ ����� "Pick": }

procedure TFormAreaPick.PickObject(aOnPickArea: TOnPickArea);
begin
  OnPickArea:=aOnPickArea;
  dmw_Pick_wm(dmw_wm_object,0,0);
end;


{ ������� �� ���� �� �����: }

//p.po^. : offs,Code,Loc: Integer; lt,rb: LPoint; name: TShortstr
procedure TFormAreaPick.OnPickObject(Sender: TObject; p: twm_pointer);
begin
  try
  try
    if Assigned(OnPickArea) then OnPickArea(p.po^.offs);
  finally
    EndPick;
  end;
  except
  end;
end;

procedure TFormAreaPick.OnPickCancel(Sender: TObject);
begin
  EndPick;
end;


{ Events: }

procedure TFormAreaPick.FormCreate(Sender: TObject);
begin
  DMW_CLI:=TDmwPick.Create;
  DMW_CLI.OnPickObject:=OnPickObject;
  DMW_CLI.OnPickCancel:=OnPickCancel;
end;

procedure TFormAreaPick.FormDestroy(Sender: TObject);
begin
  DMW_CLI.Free;
end;

procedure TFormAreaPick.ApplicationEvents1Activate(Sender: TObject);
begin
  EndPick;//����� �� ��������!
end;

end.
