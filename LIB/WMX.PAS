{
  ���������� � TWmxForm.FormCreate �������� � ����,
  ��� ��� WindowsMessages, ���������� � Application
  � ������������� � ������� WMX_FIRST..WMX_LAST,
  ������������ ���� ������ ����������.
  ������ ��������� ��������� - ������� �� WMX_DEBUG (WMXForm).
  ���� TMessage, TMsg � ������������������ ���� ��������� ����.
}
unit wmx; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;


const
  {WM_USER=$0400=1024; WM_USER+100 ������ (messages.pas)}
  {WM_APP =$8000=32768;}
  {message: 1..49151}
  WMX_FIRST = WM_USER+1024+1; {������������}
  WMX_LAST  = WM_APP-1;       {������������}

  WMX_DEBUG = WMX_FIRST; {DEBUG, WMXForm ���������}

  WMX_1 = WMX_FIRST + 1; {used in project msg.dpr}


type
  TWmxForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    procedure OnWMX_DEBUG(var Message: TMessage); message WMX_DEBUG;
    procedure ApplicationOnMessage(var Msg: TMsg; var Handled: Boolean);
  public
    procedure SendToAllForms(MsgID, wParam, lParam: Integer);
    procedure PostToApplication(MsgID, wParam, lParam: Integer);
  end;


(*
  PMessage = ^TMessage;   {messages.pas}
  TMessage = record
    Msg: Cardinal;
    case Integer of
      0: (
        WParam: Longint;
        LParam: Longint;
        Result: Longint);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;

  PMsg = ^TMsg;           {windows.pas}
  TMsg = packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
    pt: TPoint;
  end;
*)

var
  WmxForm: TWmxForm;

implementation

{$R *.DFM}

uses wcmn;


procedure TWmxForm.OnWMX_DEBUG(var Message: TMessage);
begin
  Tell('TWmxForm.OnWMX_DEBUG');
end;

{
  Application.OnMessage handler:
  WMX_FIRST .. WMX_LAST
}
procedure TWmxForm.ApplicationOnMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.Message>=WMX_FIRST) and (Msg.Message<=WMX_LAST)
  then begin
    Handled:=true;{!?!}
    {Tellf('Application.OnMessage: ID=%d',[Msg.message]);}
    {PostMessage ����� �������� ���� ��, ������� SendMessage:}
    with Msg do SendToAllForms(Message, wParam, lParam);
  end;
end;

{
  function SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
  �� ����� ���� ��� ��������� - Integer.
  ��� ������ ������� ���������.
}
procedure TWmxForm.SendToAllForms(MsgID, wParam, lParam: Integer);
var i: integer; C: TComponent;
begin
  with Application do if ComponentCount>0
    then for i:=0 to ComponentCount-1 do begin
        C:=Components[i];
        {Tellf('Application.Components[%d]=<%s> (%s)',[i,C.Name,C.ClassName]);}
        if C is TForm then SendMessage((C as TForm).Handle, MsgID, wParam, lParam);
    end;
end;

{
  ������ � ������� ���������� � ���������� ����������.
  ������������ ������ �����
  Application.OnMessage := ApplicationOnMessage;
  Fail: ������ � �������� ��� ������� ���������.
}
procedure TWmxForm.PostToApplication(MsgID, wParam, lParam: Integer);
begin
  if not PostMessage( 0, MsgID, wParam, lParam)
  then Tell('TWmxForm.PostToApplication Fail!');
  {
    ���� ��� ProcessMessages,
    �� ������ ��������� � ������� �� ��������� ������-��.
  }
  Application.ProcessMessages;
end;


{ Events: }

procedure TWmxForm.FormCreate(Sender: TObject);
begin
  Application.OnMessage := ApplicationOnMessage;
end;


end.{of unit}
