unit Wide_str; interface

uses
   Windows,
  SysUtils,
  Classes,
  Math;

Type

TWideString = class 
 private 
   FText: WideString; 
   LenText: Integer; //index of the last char 
   CurrentLenText: Integer; //actual length от FText 
   SpareLen: Integer; 
   function GetText: WideString; 
   procedure SetText(const Text: WideString); 
 public 
   procedure Append(C: WideString); 
   property Text: WideString read GetText write SetText; 
   property Length:Integer read LenText; 
 end; 

function WidePosEx(const SubStr, S: WideString; Offset: Integer): Integer; 
function WdReplaceStr(const Source, oldStr, newStr: WideString): WideString; 

implementation


 function TWideString.GetText: WideString;
 begin
   CurrentLenText := LenText;
   SetLength(FText, CurrentLenText);
   {result}GetText := FText;
 end;

 procedure TWideString.SetText(const Text: WideString);
 begin
   FText := Text;

   LenText := System.length(Text);
   CurrentLenText := LenText;
 end;

 procedure TWideString.Append(C: WideString);
 var i, LenC: integer;
 begin
   LenC := System.Length(C);
   if LenText + LenC > CurrentLenText then
   begin
    SpareLen := max(SpareLen, CurrentLenText); 
    CurrentLenText := LenText + LenC + SpareLen; 
    SetLength(FText, CurrentLenText); 
   end; 
   for i := 1 to LenC do 
   begin 
    inc(LenText); 
    FText[LenText] := C[i]; 
   end; 
 end; 

function WidePosEx(const SubStr, S: WideString; Offset: Integer): Integer; 
 var i, X, Len, LenSubStr, Res: Integer; 
 begin 
   if Offset = 1 then Res := Pos(SubStr, S) else 
   begin 
   i := Offset; 
   LenSubStr := Length(SubStr); 
   Len := Length(S) - LenSubStr + 1; 
   while i <= Len do 
   begin 
    if S[i] = SubStr[1] then 
    begin 
     X := 1; 
     while (X < LenSubStr) and (S[i + X] = SubStr[X + 1]) do Inc(X); 
     if (X = LenSubStr) then 
     begin 
      Res := i; 
      {result}WidePosEx := Res; 
      exit; 
     end; 
    end; 
    Inc(i); 
   end; 
   Res := 0; 
   end; 
   {result}WidePosEx := Res; 
 end;  

function WdReplaceStr(const Source, oldStr, newStr: WideString): WideString; 
 var PosOfOldStr, PosOfNextSearch, LenOldStr: integer; Res: TWideString; 
 begin 
   LenOldStr := Length(oldStr); 
   Res := TWideString.Create; 
   PosOfNextSearch := 1; 
   repeat 
    PosOfOldStr := WidePosEx(oldStr, Source, PosOfNextSearch); 
    if PosOfOldStr = 0 then break; 
    Res.Append(copy(Source, PosOfNextSearch, PosOfOldStr - PosOfNextSearch)); 
    Res.Append(newStr); 
    PosOfNextSearch := PosOfOldStr + LenOldStr; 
   until PosOfOldStr = 0; 
   //till end of line 
   Res.Append(copy(Source, PosOfNextSearch, maxInt)); 
   {result}WdReplaceStr := Res.Text; 
   Res.Destroy; 
 end; 


end.
