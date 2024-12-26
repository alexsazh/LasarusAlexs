(*
  ������� �� DMW, � �.�. "pick".
  ����� ����� ��� TDmwPick.Create � ������������ "of object".
  TDmwPick - OLD version of TDmwClient - TOL\dmw_wm.pas.

  ������:
    dmwevent_Pick(dmw_wm_object, aReaction);
    � ������� aReaction pntr.po^.code - ��� � �.�

*)
unit dmwevent; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  dmw_wm;

type
  //������� �� ����� ��������� ������� (����� dmw_ShowObject �� ���������)
  tdmwevent_OnActiveObject = procedure(po: pdmw_wm_object) of object;

  //������� �� Pick...:
  //Result=true => �������� Pick ������������, false - �������
  //��������� PickMode � ��������� twm_pointer - ��. dmw_wm.pas
  //��� Cancel �������� ����� (0, nil) - ����� ��������� (������� �� �����)!!!
  tdmwevent_OnPick = function(PickMode: integer; pntr: twm_pointer): boolean of object;

//��������� ������� �� ����� ��������� ������� (m.b.nil):
procedure dmwevent_ActiveObject(aReaction: tdmwevent_OnActiveObject);

//��������� ������� �� "Pick...":
//���� ���� ������ ������ (PickCancel), �� ���������� aReaction(0,p) � �������� p �� ����������(!)
//dmwevent_Pick(0, nil) = Cancel (����������� ��������)
procedure dmwevent_Pick(PickMode: integer; aReaction: tdmwevent_OnPick);


type
  TFormDmwEvent = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDmwPick: TDmwPick;//dmw_wm.pas
    FActiveObjectReaction: tdmwevent_OnActiveObject;
    FPickReaction: tdmwevent_OnPick;
    procedure OnPickOccupe(Sender: TObject; p: twm_pointer);//������� ������
    procedure OnPickCancel(Sender: TObject);//������ ������ - ����� �� Pick
    procedure OnPickObject(Sender: TObject; p: twm_pointer);
    procedure OnPickPoint(Sender: TObject; p: twm_pointer);
    procedure OnPickVector(Sender: TObject; p: twm_pointer);
    procedure OnPickRect(Sender: TObject; p: twm_pointer);
    procedure OnPickPort(Sender: TObject; p: twm_pointer);
  public
  end;

var
  FormDmwEvent: TFormDmwEvent;


implementation

{$R *.dfm}

uses
  dmw_dde,
  wcmn;

procedure dmwevent_ActiveObject(aReaction: tdmwevent_OnActiveObject);
begin
  FormDmwEvent.FActiveObjectReaction:=aReaction;
  dmw_Pick_wm(dmw_wm_occupe, 0,0);
end;

procedure dmwevent_Pick(PickMode: integer; aReaction: tdmwevent_OnPick);
begin
  FormDmwEvent.FPickReaction:=aReaction;
  if PickMode=0 then dmw_Pick_wm(dmw_wm_object, 0,0);//����� ������� ��� ��������� �������
  dmw_Pick_wm(PickMode, 0,0);
end;


{ TFormDmwEvent: }


procedure TFormDmwEvent.OnPickOccupe(Sender: TObject; p: twm_pointer);//������� ������
begin
  if Assigned(FActiveObjectReaction) then FActiveObjectReaction(p.po);
end;


//--------------- OnPick: ----------------------------

procedure TFormDmwEvent.OnPickCancel(Sender: TObject);
var p: twm_pointer;
begin
  if Assigned(FPickReaction) then begin
    pointer(p):=nil;
    FPickReaction(dmw_wm_cancel{0}, p);//����� � maptools/distance
    FPickReaction:=nil;
  end;
  dmw_Pick_wm(dmw_wm_object, 0,0);//����� �������
end;

procedure TFormDmwEvent.OnPickObject(Sender: TObject; p: twm_pointer);
begin
  if Assigned(FPickReaction) then
    if FPickReaction(dmw_wm_object, p) then FPickReaction:=nil
    else dmw_Pick_wm(dmw_wm_object, 0,0);
end;

procedure TFormDmwEvent.OnPickPoint(Sender: TObject; p: twm_pointer);
begin
  if Assigned(FPickReaction) then
    if FPickReaction(dmw_wm_point, p) then FPickReaction:=nil
    else dmw_Pick_wm(dmw_wm_point, 0,0);
end;

procedure TFormDmwEvent.OnPickVector(Sender: TObject; p: twm_pointer);
begin
  if Assigned(FPickReaction) then
    if FPickReaction(dmw_wm_vector, p) then FPickReaction:=nil
    else dmw_Pick_wm(dmw_wm_vector, 0,0);
end;

procedure TFormDmwEvent.OnPickRect(Sender: TObject; p: twm_pointer);
begin
  if Assigned(FPickReaction) then
    if FPickReaction(dmw_wm_rect, p) then FPickReaction:=nil
    else dmw_Pick_wm(dmw_wm_rect, 0,0);
end;

procedure TFormDmwEvent.OnPickPort(Sender: TObject; p: twm_pointer);
begin
  if Assigned(FPickReaction) then
    if FPickReaction(dmw_wm_port, p) then FPickReaction:=nil
    else dmw_Pick_wm(dmw_wm_port, 0,0);
end;


{ Form-Events: }

procedure TFormDmwEvent.FormCreate(Sender: TObject);
begin
  FDmwPick:=TDmwPick.Create(Self);

  FDmwPick.OnPickOccupe:=OnPickOccupe;

  FDmwPick.OnPickCancel:=OnPickCancel;
  FDmwPick.OnPickObject:=OnPickObject;
  FDmwPick.OnPickPoint:=OnPickPoint;
  FDmwPick.OnPickVector:=OnPickVector;
  FDmwPick.OnPickRect:=OnPickRect;
  FDmwPick.OnPickPort:=OnPickPort;
end;

procedure TFormDmwEvent.FormDestroy(Sender: TObject);
begin
  FDmwPick.Free;
end;


end.
