unit pslogs; interface

uses classes;

type
  TPsLog = class
  private
    FStrings: TStrings;
  public
    constructor Create(aStrings: TStrings);
    procedure WL(sline: string);
  end;

procedure pslog_wl(ln: string);


implementation

uses psx;

const MaxLogLines = 100;


procedure pslog_wl(ln: string);
begin
  if Assigned(Ps.Log) then Ps.Log.WL(ln); 
end;

{TPsLog:}

constructor TPsLog.Create(aStrings: TStrings);
begin
  FStrings:=aStrings;
end;

procedure TPsLog.WL(sline: string);
begin
  if not Assigned(FStrings) then exit;
  if FStrings.Count>MaxLogLines then FStrings.Delete(0);
  FStrings.Add(sline);
  {FStrings.SelStart:=FStrings.SelStart+Length(sline);}
end;

end.
