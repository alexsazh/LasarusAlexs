unit sqllib; interface


function sql_string(s0: string): string;//удваивает кавычки

function sql_Language_Russian: string;
function sql_DateToQry(Date: TDateTime; mdb: boolean): string;//after sql_Language_Russian(!)

function sql_and(s0,s: string): string;//for WHERE: "s0 and s"

//select <sfields> from <stable> where (<swhere>) order by <sorderby> ; :
function sql_select1(sfields,stable,swhere,sortedby: string): string;
function sql_select_join1(sfields, stab1,stab2, skey1,skey2, swhere,sortedby: string): string;

implementation

uses
  Sysutils,
  wcmn;


//удваивает кавычки:
function sql_string(s0: string): string;
var l,i: integer;
begin
  l:=Length(s0);
  Result:=s0;
  i:=1;
  while i<=l do begin
    if Result[i]<>'"' then begin
      inc(i);
    end else begin
      insert('"',Result,i);
      inc(l);
      inc(i,2);
    end;
  end;
end;

function sql_Language_Russian: string;
begin
  Result:='set language N''русский''';
end;

function sql_DateToQry(Date: TDateTime; mdb: boolean): string;
var Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  if mdb then Result:=Format('DateSerial(%d,%d,%d)',[Year, Month, Day])//Access
  else Result:=Format('(''%d.%d.%d'')',[Day,Month,Year]);//SQL server (РУССКИЙ)
end;


function sql_and(s0,s: string): string;//for WHERE: "s0 and s"
begin
  Result:=s0;
  if (length(s0)>0) and (length(s)>0) then Result:=Result+' and ';
  Result:=Result+s;//if s0='' then Result=s(!)
end;

//used in sql_select_join1:
function sql_select_beg(sfields,stable: string; _skobki: boolean): string;
begin
  if _skobki then Result:=Format('select %s from [%s]',[sfields,stable])
  else Result:=Format('select %s from %s',[sfields,stable]);
end;

function sql_select_end(s0, swhere,sortedby: string): string;
begin
  Result:=s0;
  if Length(swhere)>0 then Result:=Format('%s where (%s)',[Result,swhere]);
  if Length(sortedby)>0 then Result:=Format('%s order by [%s]',[Result,sortedby]);
  Result:=Result+' ;';//всегда!
end;

//select <sfields> from [<stable>] where (<swhere>) order by [<sorderby>]; :
function sql_select1(sfields,stable,swhere,sortedby: string): string;
begin
  Result:=sql_select_beg(sfields,stable, true{_skobki});
  Result:=sql_select_end(Result, swhere,sortedby);
end;

function sql_select_join1(sfields, stab1,stab2, skey1,skey2, swhere,sortedby: string): string;
var sjoin: string;
begin
  sjoin:=Format('[%s] inner join [%s] on ([%s].[%s]=[%s].[%s])',
                 [stab1,   stab2, stab1,skey1, stab2,skey2]);
  Result:=sql_select_beg(sfields,sjoin, false{_skobki});
  Result:=sql_select_end(Result, swhere,sortedby);
end;


end.
