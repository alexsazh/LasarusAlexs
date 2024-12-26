{Queue of Chars}
unit Queue; interface

uses
  Classes,
  wcmn, arrayx, buf;


Type
  TQueue = class(TBuf)
  public
(*
    function Read(var Buffer; aStart, aCount: Cardinal): Cardinal; {Readed count}
    function Write(const Buffer; aStart, aCount: Cardinal): Cardinal;
    function Add(const Buffer; aCount: Cardinal): Cardinal;
    function ReadS(aStart, aCount: Cardinal): string;
    function WriteS(const s: string; aStart: Cardinal): Cardinal;
    function AddS(const s: string): Cardinal;
    function ReadSL(SL: TStrings; aStart: Cardinal; aCount: array of Cardinal): Cardinal;
    procedure ShiftL(aCount: Cardinal);
    procedure ShiftR(aCount: Cardinal);
    function IndexOf(c: Char): TIndex;
    function FindChar(c: Char): PChar;
*)
    {Queue's reading (Read[S]+ShiftL):}
    function QR(var Buffer; aCount: Cardinal): Cardinal; {Readed count}
    function QRS(aCount: Cardinal): string;
    {return strings count:}
    function QRSL(SL: TStrings; aCount: array of Cardinal): Cardinal;

    property Items; {: Char}
    property Capacity;
    property Count;
    property Memory; {: PChar}
  end;


implementation


function TQueue.QR(var Buffer; aCount: Cardinal): Cardinal;
begin
  Result := Read(Buffer, 0, aCount);
  ShiftL( Result );
end;

function TQueue.QRS(aCount: Cardinal): string;
begin
  Result := ReadS(0, aCount);
  ShiftL( Length(Result) );
end;

function TQueue.QRSL(SL: TStrings; aCount: array of Cardinal): Cardinal;
begin
  Result := ReadSL(SL, 0, aCount);
  ShiftL( Result );
end;


end. {of unit}
