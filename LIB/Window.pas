unit window; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TWin = class(TForm)
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    MaxLines: Integer;
    procedure Scroll(aCount: Integer);
  public
    procedure WriteS(s: string);
  end;

var
  Win: TWin;

implementation

{$R *.DFM}


{ Private methods: }

procedure TWin.Scroll(aCount: Integer);
begin
  if aCount>Memo.Lines.Count then aCount:=Memo.Lines.Count;
  while aCount>0 do begin
    Memo.Lines.Delete(0);
    dec(aCount);
  end;
end;


{ Public methods: }

procedure TWin.WriteS(s: string);
begin
  Memo.Text := Memo.Text + s;
  if Memo.Lines.Count>MaxLines then Scroll(Memo.Lines.Count-MaxLines);
end;


{ Events: }

procedure TWin.FormCreate(Sender: TObject);
begin
  Caption := Application.ExeName;
  MaxLines := 50;
  Memo.Text := '';
end;


end.
