unit Msw_cmn; interface

const
  mrYes = 6;  {MsgDialog Return values}

  _EOLN_ = #13#10;

type
  tstring = array[0..255]of char;
  long = longint;

procedure MsgInfo(msg: string);
function MsgYesNo(msg: string): boolean;

function boolstr(b: boolean): string;

function dm_Init(dm: string; edit: boolean): boolean;


implementation

uses Dialogs, SysUtils, dmw_use;


procedure MsgInfo(msg: string);
begin
   MessageDlg(msg,mtInformation,[mbOK],0);
end;

function MsgYesNo(msg: string): boolean;
var Reply: word;
begin
   Reply := MessageDlg(msg,mtConfirmation,[mbYes, mbNo],0);
   MsgYesNo := ( Reply = word(mrYes) );
end;

function boolstr(b: boolean): string;
begin
   if b then boolstr := 'TRUE' else boolstr := 'FALSE';
end;


function dm_Init(dm: string; edit: boolean): boolean;
var zs: tstring; nOpen: word;
begin
  dm_Init := false;
  nOpen := dm_Open(StrPCopy(zs,dm), edit);
  if nOpen<=0 then begin
    MsgInfo('DLL: Неверное имя карты'+_EOLN_+dm);
    exit;
  end;
  dm_Init := true;
end;


end. {of unit}

