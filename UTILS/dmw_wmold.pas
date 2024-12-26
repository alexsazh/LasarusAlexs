unit dmw_wmold; interface

uses
  Windows,Forms,Controls,Classes,
  Messages,OTypes,dmw_dde;

const
  dmw_wm_cancel = 0;
  dmw_wm_object = 1;
  dmw_wm_point  = 2;
  dmw_wm_vector = 3;
  dmw_wm_rect   = 4;
  dmw_wm_port   = 5;
  dmw_wm_geoid  = 6;
  dmw_wm_ring   = 7;

type
  tdmw_wm_object = record
    offs,Code,Loc: Integer;
    lt,rb: LPoint; name: TShortstr
  end;

  tdmw_wm_point = record
    p: LPoint; g: tgauss;
  end;

  tdmw_wm_rect = record
    x1,y1,x2,y2: Integer;
  end;

  pdmw_wm_object = ^tdmw_wm_object;
  pdmw_wm_point = ^tdmw_wm_point;
  pdmw_wm_rect = ^tdmw_wm_rect;

  twm_pointer = record case integer of
0: (p: Pointer);
1: (po: pdmw_wm_object);
2: (pp: pdmw_wm_point);
3: (pg: pdmw_wm_rect);
  end;

  TOnPickEvent = procedure(Sender: TObject;
                           p: twm_pointer) of object;

  TDmwPick = class
    constructor Create(AForm: TForm);
    destructor Destroy; override;
  private
    Form: TForm;
    OldWndProc: TWndMethod;

    fOnPickCancel: TNotifyEvent;
    fOnPickObject: TOnPickEvent;
    fOnPickPoint: TOnPickEvent;
    fOnPickVector: TOnPickEvent;
    fOnPickRect: TOnPickEvent;
    fOnPickPort: TOnPickEvent;
    fOnPickGeoid: TOnPickEvent;
    fOnPickRing: TOnPickEvent;

    procedure FormWindowProc(var Msg: TMessage);

  public
    property OnPickCancel: TNotifyEvent write fOnPickCancel;

    property OnPickObject: TOnPickEvent write fOnPickObject;
    property OnPickPoint: TOnPickEvent write fOnPickPoint;
    property OnPickVector: TOnPickEvent write fOnPickVector;
    property OnPickRect: TOnPickEvent write fOnPickRect;
    property OnPickPort: TOnPickEvent write fOnPickPort;
    property OnPickGeoid: TOnPickEvent write fOnPickGeoid;
    property OnPickRing: TOnPickEvent write fOnPickRing;
  end;

implementation

constructor TDmwPick.Create(AForm: TForm);
begin
  inherited Create; Form:=AForm;
  dmw_register_wnd(Form.Handle);

  OldWndProc:=Form.WindowProc;
  Form.WindowProc:=FormWindowProc;
end;

destructor TDmwPick.Destroy;
begin
  Form.WindowProc:=OldWndProc;

  if Assigned(Form) then
  dmw_unregister_wnd(Form.Handle);
  inherited
end;

procedure TDmwPick.FormWindowProc(var Msg: TMessage);

function This_CopyData(ds: PCopyDataStruct; len: Integer): Boolean;
begin
  Result:=false;
  if Assigned(ds) then
  if ds.cbData = len then
  Result:=Assigned(ds.lpData)
end;

var
  ds: PCopyDataStruct;
  p: twm_pointer;
begin
  if Msg.Msg = wm_Copydata then begin

    ds:=Pointer(Msg.lParam);
    p.p:=ds.lpData;

    case ds.dwData of
  dmw_wm_cancel:
      if Assigned(fOnPickCancel) then fOnPickCancel(Self);

  dmw_wm_object:
      if This_CopyData(ds,Sizeof(tdmw_wm_object)) then
      if Assigned(fOnPickObject) then fOnPickObject(Self,p);

  dmw_wm_point:
      if This_CopyData(ds,Sizeof(tdmw_wm_point)) then
      if Assigned(fOnPickPoint) then fOnPickPoint(Self,p);

  dmw_wm_vector:
      if This_CopyData(ds,Sizeof(tdmw_wm_point)) then
      if Assigned(fOnPickVector) then fOnPickVector(Self,p);

  dmw_wm_rect:
      if This_CopyData(ds,Sizeof(tdmw_wm_rect)) then
      if Assigned(fOnPickRect) then fOnPickRect(Self,p);

  dmw_wm_port:
      if This_CopyData(ds,Sizeof(tdmw_wm_rect)) then
      if Assigned(fOnPickPort) then fOnPickPort(Self,p);

  dmw_wm_geoid:
      if This_CopyData(ds,Sizeof(tdmw_wm_rect)) then
      if Assigned(fOnPickGeoid) then fOnPickGeoid(Self,p);

  dmw_wm_ring:
      if This_CopyData(ds,Sizeof(tdmw_wm_rect)) then
      if Assigned(fOnPickring) then fOnPickring(Self,p);

    end
  end;

  OldWndProc(Msg)
end;

end.
