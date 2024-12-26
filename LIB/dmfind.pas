(*
  ОБРАЗЕЦ!!!
  Просмотр карты (карта открыта)
*)
unit dmfind; interface

uses
  dmw_use,
  list;


type
(*
  dm_Rec = record  --- from dmw_use.pas
    Code,mind,hind: longint;
    Tag,View: byte; Color: word;
    case Integer of
  0:  (ox1,oy1,ox2,oy2: longint);
  1:  (o_lt,o_rb: LPoint);
  end;
*)
  TDmFind = class
  private
    //Result=false: поиск продолжается; Result=true: поиск окончен:
//    function Test_CharaExists(p: Integer; const dRec: dm_Rec{dmw_use.pas}): Boolean;
  public
//    procedure CharaExists(nchara: integer; dmolist: tclasslist);//dmo:=tdmox.CreateFromDm2(true, false);
  end;


var XDmFind: TDmFind;


implementation

uses wcmn;

(*
function TDmFind.Test_CharaExists(p: Integer; const dRec: dm_Rec): Boolean;
var n: integer; dmo: tdmox;
begin
  if dm_get_long(Fnchara, 0, n) then begin
    dmo:=tdmox.CreateFromDm2(true, false);
    if dmo.Points.Count>0 then Fdmolist.Add(dmo) else dmo.Free;
  end;
  Result:=false;//продолжаем поиск до конца
end;

procedure TDmFind.CharaExists(nchara: integer; dmolist: tclasslist);
begin
  Fnchara:=nchara;
  Fdmolist:=dmolist;

  Fdmolist.Clear;

  dm_goto_root;
  dm_Execute(Test_CharaExists);//procedure
end;
*)

initialization
  XDmFind:=TDmFind.Create;

finalization
  XDmFind.Free;

end.
