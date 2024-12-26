unit OLists; interface

uses
  Windows,Classes,
  OTypes,OFiles,XList{,XSort};

type
  PValueItem = ^TValueItem;
  TValueItem = record
    Val,Data,Data1,Data2: int;
    Name: String[127]
  end;

  PValueArray = ^TValueArray;
  TValueArray = array[0..255] of TValueItem;

  TValueNameList = class(TCustomList)
    constructor Create;

    function LoadFromMnu(Path: PChar): int;
    function LoadFromCmd(Path: PChar): int;

    function LoadFrom(Path: PChar): Integer; virtual;
    procedure SaveAs(Path: PChar); virtual;

    function LoadMsg(Path: PChar; Id1,Id2: Integer): Integer;
    function LoadTxt(Path: PChar): Integer;

    function xAdd(AName: PChar; AVal: Integer): Integer;
    function xAdd1(AName: PChar; AVal, d1,d2,d3: int): int;
    function xAdd2(AName: PChar; AVal,AData: int): int;

    function sAdd(const AName: String; AVal: int): int;
    function sAdd1(const AName: String; AVal, d1,d2,d3: int): int;
    function hAdd(const AName: String; AVal: int): int;

    function Lookup(Ind: Integer; Str: PChar): Integer;
    function iLookup(Ind: Integer; Str: PChar): Integer;

    function val_Itemof(AVal: Integer): PValueItem;
    function val_Indexof(AVal: Integer): Integer;
    function val1_Indexof(AVal1: Integer): Integer;

    function dat_Indexof(AVal,AData: Integer): Integer;

    function xdt_Indexof(Id: Int64): int;
    function xdt_Itemof(Id: Int64): PValueItem;

    function name_Itemof(AName: PChar): PValueItem;
    function name_Indexof(AName: PChar): Integer;
    function name_Seekof(AName: PChar): Integer;

    function AddItem(AName: PChar; AVal,AData: Integer): Integer;

    function NameByValue(AVal: Integer): ShortString; virtual;
    function ValueByName(AName: PChar): int;
    function ValueByName1(AName: PChar): int;

    function StrByValue(Str: PChar; AVal: Integer): PChar;

    procedure AddMsg(Id: int; Str: PChar);
    function MsgByValue(Msg,Rus: PChar; AVal: Integer): PChar;

    function MsgByVal(Rus: PChar; AVal: Integer): ShortString;

    function xNameByValue(AVal,AData: Integer): ShortString;

    function xDataCount(AData: Integer): Integer;

  protected
    function Up_item(p1,p2: Pointer): Boolean; override;

  private
    fSortSwap: bool;
    fdumpExtended: bool;

    function Get_Name(Ind: Integer): ShortString;
    procedure Set_Name(Ind: Integer; const AName: ShortString);

    function Get_Value(Ind: Integer): Integer;
    procedure Set_Value(Ind,Val: Integer);

    function Get_Data(I,J: Integer): Integer;
    procedure Set_Data(I,J,Val: Integer);

  public
    property Names[Ind: Integer]: ShortString read Get_Name
                                              write Set_Name;

    property Values[Ind: Integer]: Integer read Get_Value
                                           write Set_Value;

    property Data[I,J: Integer]: Integer read Get_Data
                                           write Set_Data;

    property dumpExtended: bool write fdumpExtended;
    property SortSwap: bool read fSortSwap write fSortSwap;
  end;

  TParamNameList = class(TValueNameList)
    function LoadFrom(Path: PChar): Integer; virtual;
    procedure SaveAs(Path: PChar); virtual;
  end;

  TValueNameList2 = class(TValueNameList)
    function LoadFrom(Path: PChar): Integer; override;
    procedure SaveAs(Path: PChar); override;

    function AddItem2(AName: PChar; AVal1,AVal2,AData: Integer): Integer;
  end;

  PEnumRec = ^TEnumRec;
  TEnumRec = record
    Code,Data: int; Name: TNameStr1
  end;

  PEnumArray = ^TEnumArray;
  TEnumArray = array[0..31] of TEnumRec;
  {
  TEnumCustomList = class(TSortList)

    procedure SortList(Index: int);

  private
    fDescIndex: int;
    fShortEnum: bool;

    function GetItem(Ind: int): Pointer;

    function GetCode(Ind: int): int;
    function GetData(Ind: int): int;

  public
    property Items[Ind: int]: Pointer read GetItem; default;

    property Codes[Ind: int]: Integer read GetCode;
    property Data[Ind: int]: Integer read GetData;

    property DescIndex: int write fDescIndex;
    property ShortEnum: bool write fShortEnum;
  end;

  TEnumList = class(TEnumCustomList)
    constructor Create;

    procedure xAdd(Id: int; Str: PChar);

    function xIndexof(Code: Integer): Integer;

    function Lookup(Ind: Integer; Str: PChar): Integer;
    function iLookup(Ind: Integer; Str: PChar): Integer;

    function NameToCode(Str: PChar): Integer;
    procedure UpperNames;

  protected
    function Up_item(p1,p2: Pointer): Boolean; override;

  private
    function GetName(Ind: int): String;

  public
    property Names[Ind: Integer]: ShortString read GetName;
  end;
  }
  PEnumRecW = ^TEnumRecW;
  TEnumRecW = record
    Code,Data: int; Name: TNameStrW1
  end;

  PEnumArrayW = ^TEnumArrayW;
  TEnumArrayW = array[0..31] of TEnumRecW;
  {
  TEnumListW = class(TEnumCustomList)
    constructor Create;

    procedure xAdd(Id: int; Str: PWideChar);
    procedure xAddW(Id: int; const Str: WideString);

    function xIndexof(Code: int): int;

    function Lookup(Ind: int; Str: PWideChar): int;
    function iLookup(Ind: int; Str: PWideChar): int;

  protected
    function Up_item(p1,p2: Pointer): Boolean; override;
  private
    function GetName(Ind: int): WideString;
  public
    property Names[Ind: int]: WideString read GetName;
  end;
  }
  PKeyNameRec = ^TKeyNameRec;
  TKeyNameRec = record
    Hash,Val: uint; Name: TNameStr
  end;

  PKeyNameArray = ^TKeyNameArray;
  TKeyNameArray = array[0..1023] of TKeyNameRec;

{  TKeyNameList = class(TCustomList)
    constructor Create;
    function xAdd(AVal: uint; AName: PChar): int;
    function xAdd1(AName: PChar): int;
    function Keyof(AName: PChar): PKeyNameRec;
    function nextItem(p: PKeyNameRec; AName: PChar): PKeyNameRec;
  end;
 }
  PLangRec = ^TLangRec;
  TLangRec = record
    Id: int; Msg: TNameStr1
  end;

  PLangArray = ^TLangArray;
  TLangArray = array[0..255] of TLangRec;

  TLangMsgList = class(TCustomList)

    constructor Create(ACapt: PChar);

    procedure xAdd(Msg: PChar; Id: int);
    function StrMsg(Str: PChar; Id: int): PChar;

    procedure Loadfrom(txt: TTextfile);
    procedure Dump(txt: TTextfile);

  private
    fCapt: TShortstr;
    fPageIndex: int;

    function GetCapt: PChar;

  public
    property Capt: PChar read GetCapt;
    property PageIndex: int write fPageIndex;
  end;

  TKeyActionList = class(TValueNameList)
    function LoadFrom(Path: PChar): Integer; override;
    function Keyof(Key: Word; Shift: TShiftState): PValueItem;

  private
    fhint_key: bool;
  public
    property hint_key: bool write fhint_key;
  end;

//function EnumComp(Str1,Str2: PChar): Boolean;

function EnumWindowsProc(wnd: HWND; lParam: DWord): Boolean; stdcall;

implementation

uses
  Sysutils,Convert{,WStrings};

{
function EnumComp(Str1,Str2: PChar): Boolean;
var
  i: Integer; p1,p2: PChar; ch1,ch2: Char;
begin
  Result:=false;

  p1:=Str1; p2:=Str2;
  for i:=0 to 255 do begin
    ch1:=p1[0]; p1:=@p1[1];
    ch2:=p2[0]; p2:=@p2[1];
    if ch1 = #0 then Break;
    if ch2 = #0 then Break;

    if xUpCase(ch1) = xUpCase(ch2) then
      Result:=true
    else
    if (ch1 = '.') and (p1[0] = #0) then
      Break
    else
    if (ch2 = '.') and (p2[0] = #0) then
      Break
    else begin
      Result:=false; Break
    end
  end
end;
}
constructor TValueNameList.Create;
begin
  inherited Create(Sizeof(TValueItem),64)
end;

function TValueNameList.Up_item(p1,p2: Pointer): Boolean;
var
  vp1,vp2: PValueItem; s1,s2: TShortstr;
begin
  Result:=false; vp1:=p1; vp2:=p2;

  if fSortSwap then begin
    vp1:=p2; vp2:=p1;
  end;

  case SortIndex of
0:  Result:=vp1.Val > vp2.Val;
1:  Result:=vp1.Data > vp2.Data;
2:  Result:=vp1.Data1 > vp2.Data1;

3:  if vp1.Data > vp2.Data then
      Result:=true
    else
    if vp1.Data = vp2.Data then
      Result:=vp1.Data1 > vp2.Data1;

4:  begin
      StrPCopy(s1,vp1.Name); xStrUpper(s1);
      StrPCopy(s2,vp2.Name); xStrUpper(s2);
      Result:=StrComp(s1,s2) > 0
    end
  end
end;

function TValueNameList.LoadFromMnu(Path: PChar): int;
var
  txt: TTextfile;
  r: TValueItem; len: int;
  fl: Boolean; s: TShortstr;
begin
  Clear; len:=Sizeof(r.Name)-1;

  fl:=Is_Comma_Delimiter;
  Is_Comma_Delimiter:=false;

  txt:=TTextfile.Create;
  try
    if txt.Open(Path) then
    while txt.xStrLine <> nil do
    if txt.x_Int(r.Val) then begin
      StrCopy(s,txt.str); LStr(s);
      r.Name:=StrLPas(s,len);
      if length(r.Name) > 0 then Add(@r)
    end
  finally
    txt.Free
  end;

  Is_Comma_Delimiter:=fl;
  Result:=Count
end;

function TValueNameList.LoadFromCmd(Path: PChar): int;
var
  txt: TTextfile;
  r: TValueItem; len: int;
  fl: Boolean; s: TShortstr;
begin
  Clear;

  fl:=Is_Comma_Delimiter;
  Is_Comma_Delimiter:=false;

  txt:=TTextfile.Create;
  try
    if txt.Open(Path) then
    while txt.xStrLine <> nil do
    if txt.x_str(s) <> nil then
    if txt.x_Int(r.Val) then begin
      LStr(s);
      r.Name:=StrLPas(s,Sizeof(r.Name)-1);
      Add(@r)
    end
  finally
    txt.Free
  end;

  Is_Comma_Delimiter:=fl;
  Result:=Count
end;

function TValueNameList.LoadFrom(Path: PChar): Integer;
var
  txt: TTextfile;
  r: TValueItem; l: int;
  s: TShortstr; fl: Boolean;
begin
  Clear; l:=Sizeof(r.Name)-1;

  fl:=Is_Comma_Delimiter;
  Is_Comma_Delimiter:=false;

  txt:=TTextfile.Create;
  try
    if txt.Open(Path) then
    while txt.xStrLine <> nil do
    if txt.x_Int(r.Val) then
    if txt.x_Int(r.Data) then begin

      if fdumpExtended then begin
        txt.x_Int(r.Data1);
        txt.x_Int(r.Data2);
      end;

      if txt.x_str(s) <> nil then begin
        r.Name:=StrLPas(s,l);
        if length(r.Name) > 0 then Add(@r)
      end
    end
  finally
    txt.Free
  end;

  Is_Comma_Delimiter:=fl;
  Result:=Count
end;

procedure TValueNameList.SaveAs(Path: PChar);
var
  txt: TTextfile; i: int; lp: PValueArray; s: String;
begin
  lp:=First;

  txt:=TTextfile.Create;
  try
    if Count = 0 then
      FileErase(Path)
    else
    if txt.Make(Path) then
    for i:=0 to Count-1 do begin

      with lp[i] do begin
        s:=Format('%d %d ',[Val,Data]);

        if fdumpExtended then
        s:=s+Format('%d %d ',[Data1,Data2]);

        s:=s+Format('"%s"',[Name])
      end;

      txt.WriteStr(s)
    end
  finally
    txt.Free
  end
end;

function TValueNameList.LoadMsg(Path: PChar; Id1,Id2: Integer): Integer;
var
  txt: TTextFile;
  Id: Integer; s: TShortstr;
  is_comma: Boolean;
begin
  Clear;

  is_comma:=Is_Comma_Delimiter;
  Is_Comma_Delimiter:=false;

  txt:=TTextFile.Create;
  try
    if txt.Open_bin(Path) then
    while not txt.end_of_file do
    if txt.Get_Int(Id) then

    if Id >= Id2 then Break else

    if Id > Id1 then begin
      if StrToken(s,txt.str) <> nil then
      xAdd(s,Id-Id1);
    end;
  finally
    txt.Free;
  end;

  Is_Comma_Delimiter:=is_comma;
  Result:=Count
end;

function TValueNameList.LoadTxt(Path: PChar): Integer;
var
  txt: TTextFile;
  Id: Integer; s: TShortstr;
begin
  Clear;

  txt:=TTextFile.Create;
  try
    if txt.Open(Path) then
    while txt.xStrLine <> nil do
    if txt.x_Int(Id) then
    if txt.x_str(s) <> nil then
    xAdd(s,Id);
  finally
    txt.Free;
  end;

  Result:=Count
end;

function TValueNameList.xAdd(AName: PChar; AVal: Integer): Integer;
begin
  Result:=xAdd1(AName,AVal, 0,0,0)
end;

function TValueNameList.xAdd1(AName: PChar; AVal, d1,d2,d3: int): int;
var
  r: TValueItem;
begin
  Fillchar(r,Sizeof(r),0);
  r.Val:=AVal; r.Data:=d1;
  r.Data1:=d2; r.Data2:=d3;
  r.Name:=StrLPas(AName,127);
  Result:=inherited Add(@r)
end;

function TValueNameList.xAdd2(AName: PChar; AVal,Adata: Integer): Integer;
begin
  Result:=xAdd1(AName,AVal, AData,0,0)
end;

function TValueNameList.sAdd(const AName: String; AVal: Integer): Integer;
var
  s: TShortstr;
begin
  StrPCopy(s,AName);
  Result:=xAdd1(s,AVal,0,0,0)
end;

function TValueNameList.sAdd1(const AName: String; AVal, d1,d2,d3: int): int;
var
  s: TShortstr;
begin
  StrPCopy(s,AName);
  Result:=xAdd1(s,AVal,d1,d2,d3)
end;

function TValueNameList.hAdd(const AName: String; AVal: int): int;
var
  r: TValueItem;
begin
  Fillchar(r,Sizeof(r),0);
  r.Val:=AVal; r.Name:=AName;
  Result:=inherited sAdd(@r)
end;

function TValueNameList.AddItem(AName: PChar; AVal,AData: Integer): Integer;
var
  It: TValueItem;
begin
  It.Val:=AVal; It.Data:=AData;
  It.Data1:=0; It.Name:=Strpas(AName);
  Result:=inherited Add(@It)
end;

function TValueNameList.Get_Name(Ind: Integer): ShortString;
var
  P: PValueItem;
begin
  Result:=''; P:=Items[Ind];
  if Assigned(P) then Result:=P.Name
end;

procedure TValueNameList.Set_Name(Ind: Integer; const AName: ShortString);
var
  P: PValueItem;
begin
  P:=Items[Ind];
  if Assigned(P) then P.Name:=AName
end;

function TValueNameList.Get_Value(Ind: Integer): Integer;
var
  P: PValueItem;
begin
  Result:=-1; P:=Items[Ind];
  if Assigned(P) then Result:=P.Val
end;

procedure TValueNameList.Set_Value(Ind,Val: Integer);
var
  P: PValueItem;
begin
  P:=Items[Ind];
  if Assigned(P) then P.Val:=Val
end;

function TValueNameList.Get_Data(I,J: Integer): Integer;
var
  P: PValueItem;
begin
  Result:=0; P:=Items[I];
  if Assigned(P) then
  if J = 0 then Result:=P.Data
           else Result:=P.Data1
end;

procedure TValueNameList.Set_Data(I,J,Val: Integer);
var
  P: PValueItem;
begin
  P:=Items[I];
  if Assigned(P) then
  if J = 0 then P.Data:=Val
           else P.Data1:=Val
end;

function TValueNameList.Lookup(Ind: Integer; Str: PChar): Integer;
var
  i,n: Integer; p: PValueItem;
  s1,s2: TShortStr;
begin
  Result:=-1; n:=Count-1;

  xStrUpper(StrCopy(s1,Str));

  if (Ind < 0) or (Ind >= Count) then
  begin Ind:=0; Inc(n) end;

  for i:=1 to n do begin
    Inc(Ind);
    if Ind >= Count then Ind:=0;
    p:=Items[Ind];

    if Assigned(p) then begin
      StrPCopy(s2,p.Name); xStrUpper(s2);
      if Str_Compare(s1,nil,s2,3) then
      begin Result:=Ind; Break end
    end;

  end
end;

function TValueNameList.iLookup(Ind: Integer; Str: PChar): Integer;
var
  i,l,n: Integer; p: PValueItem; s: TShortStr;
begin
  Result:=-1; n:=Count-1;

  if (Ind < 0) or (Ind >= Count) then
  begin Ind:=0; Inc(n) end;

  l:=StrLen(Str);

  for i:=1 to n do begin
    Inc(Ind);
    if Ind >= Count then Ind:=0;
    p:=Items[Ind];

    if Assigned(p) then begin
      StrPCopy(s,IntToStr(p.Val));
      if StrLComp(s,Str,l) = 0 then
      begin Result:=Ind; Break end
    end
  end
end;

function TValueNameList.val_Itemof(AVal: Integer): PValueItem;
var
  I: Integer; lp: PValueArray;
begin
  Result:=nil; lp:=First;

  for I:=0 to Count-1 do begin
    if lp[0].Val = AVal then begin
      Result:=@lp[0]; Break
    end; lp:=@lp[1]
  end
end;

function TValueNameList.val_Indexof(AVal: Integer): Integer;
var
  I: Integer; lp: PValueArray;
begin
  Result:=-1; lp:=First;

  for I:=0 to Count-1 do begin
    if lp[0].Val = AVal then begin
      Result:=I; Break
    end; lp:=@lp[1]
  end
end;

function TValueNameList.val1_Indexof(AVal1: Integer): Integer;
var
  I: Integer; lp: PValueArray;
begin
  Result:=-1; lp:=First;

  for I:=0 to Count-1 do begin
    if tlong(lp[0].Val).w[0] = AVal1 then
    begin Result:=I; Break end; lp:=@lp[1]
  end
end;

function TValueNameList.dat_Indexof(AVal,AData: Integer): Integer;
var
  I: Integer; lp: PValueArray;
begin
  Result:=-1; lp:=First;

  for I:=0 to Count-1 do begin
    if (lp[0].Val = AVal) and (lp[0].Data = AData) then
    begin Result:=I; Break end; lp:=@lp[1]
  end
end;

function TValueNameList.xdt_Indexof(Id: Int64): int;
var
  i,v1,v2: int; lp: PValueArray;
begin
  Result:=-1; lp:=First;

  v1:=TInt64(Id).id;
  v2:=TInt64(Id).cn;

  for i:=0 to Count-1 do begin
    if (lp[0].Val = v1) and (lp[0].Data = v2) then
    begin Result:=i; Break end; lp:=@lp[1]
  end
end;

function TValueNameList.xdt_Itemof(Id: Int64): PValueItem;
var
  i: int;
begin
  Result:=nil; i:=xdt_Indexof(Id);
  if i >= 0 then Result:=Items[i]
end;

function TValueNameList.name_Itemof(AName: PChar): PValueItem;
var
  i: Integer; lp: PValueArray; S: String;
begin
  Result:=nil; lp:=First; S:=Strpas(AName);

  for i:=0 to Count-1 do begin
    if lp[0].Name = S then
    begin Result:=@lp[0]; Break end;
    lp:=@lp[1]
  end
end;

function TValueNameList.name_Indexof(AName: PChar): Integer;
var
  i: int; lp: PValueArray; S: String;
begin
  Result:=-1; lp:=First; S:=Strpas(AName);

  for i:=0 to Count-1 do begin
    if lp[0].Name = S then
    begin Result:=i; Break end;
    lp:=@lp[1]
  end
end;

function TValueNameList.name_Seekof(AName: PChar): int;
var
  i,len: int; lp: PValueItem; s1,s2: TShortstr;
begin
  Result:=-1; lp:=First;

  StrCopy(s1,AName);
  xStrUpper(s1); len:=Strlen(s1);

  for i:=0 to Count-1 do begin

    if Length(lp.Name) = len then begin
      StrPCopy(s2,lp.Name);
      xStrUpper(s2);
      if StrIComp(s1,s2) = 0 then
      begin Result:=i; Break end;
    end;

    Inc(lp)
  end
end;

function TValueNameList.NameByValue(AVal: Integer): ShortString;
begin
  Result:=Names[ val_Indexof(AVal) ]
end;

function TValueNameList.ValueByName(AName: PChar): Integer;
var
  i: int;
begin
  Result:=-1;
  i:=name_Indexof(AName);
  if i >= 0 then Result:=Values[i]
end;

function TValueNameList.ValueByName1(AName: PChar): int;
var
  i: int;
begin
  Result:=-1;
  i:=name_Seekof(AName);
  if i >= 0 then Result:=Values[i]
end;

function TValueNameList.StrByValue(Str: PChar; AVal: Integer): PChar;
begin
  Result:=StrPCopy(Str,Names[ val_Indexof(AVal) ])
end;

procedure TValueNameList.AddMsg(Id: int; Str: PChar);
var
  r: TValueItem;
begin
  if id_Indexof(Id) < 0 then begin
    Fillchar(r,Sizeof(r),0);
    r.Val:=Id; r.Name:=Strpas(Str);
    Add(@r)
  end
end;

function TValueNameList.MsgByValue(Msg,Rus: PChar; AVal: Integer): PChar;
var
  str: TShortstr;
begin
  Result:=StrCopy(Msg,Rus);
  if not rus_interface then begin
    StrPCopy(str,Names[ val_Indexof(AVal) ]);
    if Strlen(str) > 0 then StrCopy(Msg,str)
  end
end;

function TValueNameList.MsgByVal(Rus: PChar; AVal: Integer): ShortString;
var
  str: String;
begin
  Result:=StrPas(Rus);
  if not rus_interface then begin
    str:=Names[ val_Indexof(AVal) ];
    if Length(str) > 0 then Result:=str
  end
end;

function TValueNameList.xNameByValue(AVal,AData: Integer): ShortString;
begin
  Result:=Names[ dat_Indexof(AVal,AData) ]
end;

function TValueNameList.xDataCount(AData: Integer): Integer;
var
  I: Integer; lp: PValueArray;
begin
  Result:=0; lp:=First;

  for I:=0 to Count-1 do begin
    if lp[0].Data = AData then
    Inc(Result); lp:=@lp[1]
  end
end;

function TParamNameList.LoadFrom(Path: PChar): Integer;
var
  txt: TTextfile;
  p: PValueItem;
  i,v: int;
begin
  Result:=0;

  txt:=TTextfile.Create;
  try
    if txt.Open(Path) then
    while txt.xStrLine <> nil do
    if txt.x_Int(i) then
    if txt.x_Int(v) then begin
      p:=Items[i];
      if Assigned(p) then begin
        p.Val:=v; Inc(Result)
      end
    end
  finally
    txt.Free
  end;

end;

procedure TParamNameList.SaveAs(Path: PChar);
var
  txt: TTextfile; i: int; lp: PValueArray;
  s: String;
begin
  lp:=First;

  txt:=TTextfile.Create;
  try
    if Count = 0 then
      FileErase(Path)
    else
    if txt.Make(Path) then
    for i:=0 to Count-1 do begin
      with lp[i] do
      s:=Format('%d %d',[i,Val]);
      txt.WriteStr(s)
    end
  finally
    txt.Free
  end
end;

function TValueNameList2.LoadFrom(Path: PChar): Integer;

function val1_Indexof(code: Integer): Integer;
var
  i: Integer; lp: PValueArray;
begin
  Result:=-1; lp:=First;

  for i:=0 to Count-1 do begin
    if tlong(lp[0].Val).w[0] = code then
    begin Result:=i; Break end; lp:=@lp[1]
  end
end;

var
  txt: TTextfile;
  r: TValueItem;
  c1,c2: Integer;
  s: TShortstr;
begin
  Clear;

  txt:=TTextfile.Create;
  try
    if txt.Open(Path) then
    while txt.xStrLine <> nil do
    if txt.x_Int(c1) then
    if txt.x_Int(c2) then
    if txt.x_Int(r.Data) then begin

      tlong(r.Val).w[0]:=c1;
      tlong(r.Val).w[1]:=c2; r.Data1:=0;

      txt.x_str(s); r.Name:=StrLPas(s,31);

      if val1_Indexof(c1) < 0 then
      if length(r.Name) > 0 then
      Add(@r)
    end
  finally
    txt.Free
  end;

  Result:=Count
end;

procedure TValueNameList2.SaveAs(Path: PChar);
var
  txt: TTextfile; i: int; lp: PValueArray;
begin
  lp:=First;

  txt:=TTextfile.Create;
  try
    if Count = 0 then
      FileErase(Path)
    else
    if txt.Make(Path) then
      for i:=0 to Count-1 do with lp[i] do
      txt.WriteStr(Format('%d %d %d "%s"',
      [tlong(Val).w[0],tlong(Val).w[1],Data,Name]));
  finally
    txt.Free
  end
end;

function TValueNameList2.AddItem2(AName: PChar; AVal1,AVal2,AData: Integer): Integer;
var
  It: TValueItem;
begin
  tlong(It.Val).w[0]:=AVal1;
  tlong(It.Val).w[1]:=AVal2;
  It.Data:=AData; It.Data1:=0;
  It.Name:=Strpas(AName);

  Result:=inherited Add(@It)
end;
{
function TEnumCustomList.GetItem(Ind: int): Pointer;
begin
  Result:=nil;

  if Count > 0 then begin
    if IndexList.Count = Count then
    Ind:=IndexList[Ind];

    Result:=inherited Items[Ind]
  end
end;

function TEnumCustomList.GetCode(Ind: int): int;
var
  p: PEnumRec;
begin
  Result:=0; p:=GetItem(Ind);
  if Assigned(p) then Result:=p.Code
end;

function TEnumCustomList.GetData(Ind: int): int;
var
  p: PEnumRec;
begin
  Result:=0; p:=GetItem(Ind);
  if Assigned(p) then Result:=p.Data
end;

procedure TEnumCustomList.SortList(Index: int);
begin
  if Index = SortIndex then
    fDescIndex:=(fDescIndex+1) and 1
  else begin
    SortIndex:=Index; fDescIndex:=0
  end;

  Sort_up(1)
end;

constructor TEnumList.Create;
begin
  inherited Create(Sizeof(TEnumRec),4096);
  IndexList.Enabled:=true
end;

procedure TEnumList.xAdd(Id: int; Str: PChar);
var
  r: TEnumRec;
begin
  Fillchar(r,Sizeof(r),0); r.Code:=Id;
  StrLCopy(r.Name,Str,Sizeof(r.Name)-1);
  Add(@r)
end;

function TEnumList.Up_item(p1,p2: Pointer): Boolean;
var
  r1,r2: PEnumRec;
  s1,s2: TShortstr;
begin
  Result:=false; r1:=p1; r2:=p2;

  case SortIndex of
0:  if fDescIndex = 0 then
      Result:=r2.Code < r1.Code
    else
      Result:=r2.Code > r1.Code;
1:  begin
      StrCopy(s1,r1.Name); xStrUpper(s1);
      StrCopy(s2,r2.Name); xStrUpper(s2);

      if fDescIndex = 0 then
        Result:=StrComp(s2,s1) < 0
      else
        Result:=StrComp(s2,s1) > 0
    end;
  end
end;

function TEnumList.GetName(Ind: Integer): String;
var
  p: PEnumRec;
begin
  Result:=''; p:=GetItem(Ind);
  if Assigned(p) then Result:=Strpas(p.Name)
end;

function TEnumList.xIndexof(Code: Integer): Integer;
var
  i: int; ip: PIntegers; lp: PEnumArray;
begin
  Result:=-1; lp:=First;

  if Count > 0 then

  if IndexList.Count = Count then begin

    ip:=IndexList.First;
    for i:=0 to Count-1 do
    if lp[ip[i]].Code = Code then
    begin Result:=i; Break end;

  end else

  for i:=0 to Count-1 do
  if lp[i].Code = Code then
  begin Result:=i; Break end
end;

function TEnumList.NameToCode(Str: PChar): Integer;
var
  i: Integer; lp: PEnumArray;
begin
  Result:=-1; lp:=First;
  for i:=0 to Count-1 do
  if StrIComp(lp[i].Name,Str) = 0 then
  begin Result:=lp[i].Code; Break end;

  if Result < 0 then
  if fShortEnum then
  for i:=0 to Count-1 do
  if EnumComp(lp[i].Name,Str) then
  begin Result:=lp[i].Code; Break end;
end;

procedure TEnumList.UpperNames;
var
  i: Integer; lp: PEnumArray;
begin
  lp:=First;
  for i:=0 to Count-1 do
  xStrUpper(lp[i].Name)
end;

function TEnumList.Lookup(Ind: Integer; Str: PChar): Integer;
var
  i,n: Integer; p: PEnumRec;
  s1,s2: TShortStr;
begin
  Result:=-1; n:=Count-1;

  xStrUpper(StrCopy(s1,Str));

  if (Ind < 0) or (Ind >= Count) then
  begin Ind:=0; Inc(n) end;

  for i:=1 to n do begin
    Inc(Ind);
    if Ind >= Count then Ind:=0;
    p:=Items[Ind];

    if Assigned(p) then begin
      StrPCopy(s2,p.Name); xStrUpper(s2);
      if Str_Compare(s1,nil,s2,3) then
      begin Result:=Ind; Break end
    end;

  end
end;

function TEnumList.iLookup(Ind: Integer; Str: PChar): Integer;
var
  i,l,n: Integer; p: PEnumRec; s: TShortStr;
begin
  Result:=-1; n:=Count-1;

  if (Ind < 0) or (Ind >= Count) then
  begin Ind:=0; Inc(n) end;

  l:=StrLen(Str);

  for i:=1 to n do begin
    Inc(Ind);
    if Ind >= Count then Ind:=0;
    p:=Items[Ind];

    if Assigned(p) then begin
      StrPCopy(s,IntToStr(p.Code));
      if StrLComp(s,Str,l) = 0 then
      begin Result:=Ind; Break end
    end
  end
end;


constructor TEnumListW.Create;
begin
  inherited Create(Sizeof(TEnumRecW),4096);
  IndexList.Enabled:=true
end;

procedure TEnumListW.xAdd(Id: int; Str: PWideChar);
var
  r: PEnumRecW;
begin
  Fillchar(r,Sizeof(r),0); r.Code:=Id;
  StrCopyW(r.Name,Str,(Sizeof(r.Name) div 2)-1);
  Add(@r)
end;

procedure TEnumListW.xAddW(Id: int; const Str: WideString);
var
  r: TEnumRecW;
begin
  Fillchar(r,Sizeof(r),0); r.Code:=Id;
  StrPCopyW(r.Name,Str,(Sizeof(r.Name) div 2)-1);
  Add(@r)
end;

function TEnumListW.Up_item(p1,p2: Pointer): Boolean;
var
  r1,r2: PEnumRecW;
  s1,s2: TNameStrW1;
begin
  Result:=false; r1:=p1; r2:=p2;

  case SortIndex of
0:  if fDescIndex = 0 then
      Result:=r2.Code < r1.Code
    else
      Result:=r2.Code > r1.Code;
1:  begin
      s1:=r1.Name; s2:=r2.Name;
      CharUpperBuffW(s1,StrLenW(s1));
      CharUpperBuffW(s2,StrLenW(s2));

      if fDescIndex = 0 then
        Result:=StrCompW(s2,s1) < 0
      else
        Result:=StrCompW(s2,s1) > 0
    end;
  end
end;

function TEnumListW.GetName(Ind: int): WideString;
var
  p: PEnumRecW;
begin
  Result:=''; p:=GetItem(Ind);
  if Assigned(p) then Result:=p.Name
end;

function TEnumListW.xIndexof(Code: int): int;
var
  i: int; ip: PIntegers; lp: PEnumArrayW;
begin
  Result:=-1; lp:=First;

  if Count > 0 then

  if IndexList.Count = Count then begin

    ip:=IndexList.First;
    for i:=0 to Count-1 do
    if lp[ip[i]].Code = Code then
    begin Result:=i; Break end;

  end else

  for i:=0 to Count-1 do
  if lp[i].Code = Code then
  begin Result:=i; Break end
end;

function TEnumListW.Lookup(Ind: int; Str: PWideChar): int;
var
  i,n: int; p: PEnumRecW;
  s1,s2: TNameStrW1;
begin
  Result:=-1; n:=Count-1;

  StrUCopyW(s1,Str,(Sizeof(s1) div 2)-1);

  if (Ind < 0) or (Ind >= Count) then
  begin Ind:=0; Inc(n) end;

  for i:=1 to n do begin
    Inc(Ind);
    if Ind >= Count then Ind:=0;
    p:=Items[Ind];

    if Assigned(p) then begin
      StrUCopyW(s2,p.Name,(Sizeof(s2) div 2)-1);

      if StrCompW(s1,s2) = 0 then
      begin Result:=Ind; Break end
    end;

  end
end;

function TEnumListW.iLookup(Ind: int; Str: PWideChar): int;
var
  i,n: int; p: PEnumRecW; s: WideString;
begin
  Result:=-1; n:=Count-1;

  if (Ind < 0) or (Ind >= Count) then
  begin Ind:=0; Inc(n) end;

  s:=Str;

  for i:=1 to n do begin
    Inc(Ind);
    if Ind >= Count then Ind:=0;
    p:=Items[Ind];

    if Assigned(p) then
    if s = IntToStr(p.Code) then
    begin Result:=Ind; Break end
  end
end;
}
{
constructor TKeyNameList.Create;
begin
  inherited Create(Sizeof(TKeyNameRec),1024)
end;

function TKeyNameList.xAdd(AVal: uint; AName: PChar): Integer;
var
  i1,i2,ii: int; h: uint;
  lp: PKeyNameArray;
  r: TKeyNameRec;
begin
  Result:=-1;

  Fillchar(r,Sizeof(r),0);
  r.Hash:=Str_chk(AName); r.Val:=AVal;
  StrLCopy(r.Name,AName,Sizeof(r.Name)-1);

  lp:=First; i1:=0; i2:=Count-1;

  while i1 <= i2 do begin
    ii:=(i1+i2) div 2; h:=lp[ii].Hash;

    if r.Hash < h then i2:=ii-1 else
    if r.Hash > h then i1:=ii+1 else begin
      Result:=Insert_range(@r,ii+1,1);
      Break
    end
  end;

  Inc(i2); if Result < 0 then begin
    if i2 >= Count then Result:=Add(@r)
    else Result:=Insert_range(@r,i2,1);
  end
end;

function TKeyNameList.xAdd1(AName: PChar): int;
var
  i1,i2,ii: int; h: uint;
  lp: PKeyNameArray;
  r,r1: TKeyNameRec;
begin
  Result:=-1;

  Fillchar(r,Sizeof(r),0);
  r.Hash:=Str_chk(AName);
  r.Val:=Count+1;

  StrLCopy(r.Name,AName,Sizeof(r.Name)-1);

  lp:=First; i1:=0; i2:=Count-1;

  while i1 <= i2 do begin
    ii:=(i1+i2) div 2; h:=lp[ii].Hash;

    if r.Hash < h then i2:=ii-1 else
    if r.Hash > h then i1:=ii+1 else begin

      while ii > 0 do begin
        if lp[ii-1].Hash <> r.Hash then
        Break; Dec(ii)
      end;

      while ii < Count do begin
        r1:=lp[ii];
        if r1.Hash <> r.Hash then Break;
        if xStrLIComp(AName,r1.Name,0) = 0 then
        begin Result:=r1.Val; Break end;
        i2:=ii; Inc(ii)
      end;

      Break
    end
  end;

  Inc(i2); if Result < 0 then begin
    if i2 >= Count then Add(@r)
    else Insert_range(@r,i2,1);
    Result:=r.Val
  end
end;

function TKeyNameList.Keyof(AName: PChar): PKeyNameRec;
var
  lp: PKeyNameArray;
  ii,i1,i2: int; key,ikey: uint;
begin
  Result:=nil;

  if Count > 0 then begin

    key:=Str_chk(AName);

    lp:=First; i1:=0; i2:=Count-1;

    while i1 <= i2 do begin
      ii:=(i1+i2) div 2;
      ikey:=lp[ii].Hash;

      if key < ikey then i2:=ii-1 else
      if key > ikey then i1:=ii+1 else begin

        while ii > 0 do begin
          if lp[ii-1].Hash <> key then
          Break; Dec(ii)
        end;

        while ii < Count do begin
          if lp[ii].Hash <> key then Break;
          if xStrLIComp(AName,lp[ii].Name,0) = 0 then
          begin Result:=@lp[ii]; Break end;
          Inc(ii)
        end;

        Break
      end
    end;
  end;
end;

function TKeyNameList.nextItem(p: PKeyNameRec; AName: PChar): PKeyNameRec;
var
  i: int; p1: PKeyNameRec;
begin
  Result:=nil;
  if Assigned(p) then begin

    i:=PtrToIndex(p)+1;
    while i < Count do begin
      p1:=Items[i];
      if p1.Hash <> p.Hash then Break;

      if xStrLIComp(AName,p1.Name,0) = 0 then begin
        Result:=p1; Break
      end;

      Inc(i)
    end
  end
end;
}
constructor TLangMsgList.Create(ACapt: PChar);
begin
  inherited Create(Sizeof(TLangRec),256);
  StrCopy(fCapt,ACapt)
end;

function TLangMsgList.GetCapt: PChar;
begin
  Result:=fCapt
end;

procedure TLangMsgList.xAdd(Msg: PChar; Id: int);
var
  r: TLangRec;
begin
  Fillchar(r,Sizeof(r),0);
  r.Id:=fPageIndex + Id;
  StrLCopy(r.Msg,Msg,Sizeof(r.Msg)-1);
  Add(@r)
end;

function TLangMsgList.StrMsg(Str: PChar; Id: int): PChar;
var
  p: PLangRec;
begin
  Result:=Str;

  p:=id_Itemof(fPageIndex+Id);
  if Assigned(p) then
    StrCopy(Str,p.Msg)
  else
    StrFmt(Str,'@msg%d',[Id])
end;

procedure TLangMsgList.Dump(txt: TTextfile);
var
  i: int; lp: PLangArray;
begin
  if Count > 0 then begin
    txt.WriteStr(Format('#msg "%s"',[fCapt]));
    txt.WriteStr('{');

    lp:=First;
    for i:=0 to Count-1 do with lp[i] do
    txt.WriteStr(Format('  %d "%s"',[Id,Msg]));

    txt.WriteStr('}');
  end
end;

procedure TLangMsgList.Loadfrom(txt: TTextfile);
var
  top,nxt: PLangRec;
  id: int; s: TShortstr;
begin
  top:=First;
  while txt.xStrLine <> nil do
  if txt.str[0] = '}' then Break else
  if txt.x_Int(id) then
  if txt.x_str(s) <> nil then begin
    nxt:=id_Itemof_from(top,id);
    if Assigned(nxt) then begin
      StrLCopy(nxt.Msg,s,Sizeof(nxt.Msg)-1);
      top:=nxt
    end
  end;

  fPageIndex:=0
end;

function TKeyActionList.LoadFrom(Path: PChar): Integer;
var
  txt: TTextfile; v1,v2,v3: int;
  p,p1: PChar; s,s1: TShortstr;
begin
  Clear;

  StrCopy(s,Path);
  if s[0] = '#' then StrIniPath(s,@s[1]);

  txt:=TTextfile.Create;
  try
    if txt.Open(s) then
    while txt.cStrLine <> nil do

    if StrIComp(txt.str,'[cmd]') = 0 then begin

      while txt.cStrLine <> nil do
      if StrComp(txt.str,'#') = 0 then Break else

      if txt.x_Int(v1) then
      if txt.x_str(s) <> nil then begin
        v2:=0;
        while true do begin
          p:=StrScan(s,'+');
          if p = nil then Break;

          p[0]:=#0; v3:=-1;
          if StrIComp(s,'shift') = 0 then v3:=1 else
          if StrIComp(s,'ctrl') = 0 then v3:=2 else
          if StrIComp(s,'alt') = 0 then v3:=4;
          StrCopy(s,@p[1]);

          if v3 < 0 then begin
            v2:=-1; Break
          end;

          v2:=v2 or v3
        end;

        if v2 >= 0 then begin
          v3:=-1; StrCopy(s1,s);

          if Strlen(s) = 1 then begin
            StrFmt(s1,'[%s]',[s]);
            v3:=Ord(s[0])
          end else
          if s[0] = '[' then begin
            p:=@s[1];
            p1:=StrScan(p,']');
            if Assigned(p1) then
            if p1[1] = #0 then begin
              p1[0]:=#0;
              if Strlen(p) = 1 then v3:=Ord(p[0]) else
              if StrIComp(p,'Left') = 0 then v3:=vk_LEFT else
              if StrIComp(p,'Right') = 0 then v3:=vk_RIGHT else
              if StrIComp(p,'Up') = 0 then v3:=vk_UP else
              if StrIComp(p,'Down') = 0 then v3:=vk_DOWN else
              if StrIComp(p,'Home') = 0 then v3:=vk_HOME else
              if StrIComp(p,'End') = 0 then v3:=vk_END else
              if StrIComp(p,'PageUp') = 0 then v3:=vk_PRIOR else
              if StrIComp(p,'PageDn') = 0 then v3:=vk_NEXT else
            end
          end;

          if v3 > 0 then begin
            txt.x_str(s);
            if fhint_key then begin
              StrCat(s1,' ');
              StrLCat(s1,s,255);
              StrCopy(s,s1)
            end;

            xAdd1(s, v1,0,v2,v3)
          end
        end
      end
    end

  finally
    txt.Free
  end;

  Result:=Count
end;

function TKeyActionList.Keyof(Key: Word; Shift: TShiftState): PValueItem;
var
  i,key1,key2: int; vp: PValueArray;
begin
  Result:=nil;

  key1:=0; key2:=Key;
  if ssSHIFT in Shift then Inc(key1,1);
  if ssCTRL in Shift then Inc(key1,2);
  if ssALT in Shift then Inc(key1,3);

  vp:=First;
  for i:=0 to Count-1 do
  if vp[i].Data2 = key2 then
  if vp[i].Data1 = key1 then begin
    Result:=@vp[i]; Break
  end
end;

function EnumWindowsProc(wnd: HWND; lParam: DWord): Boolean; stdcall;
var
  str: TShortstr;
begin
  Result:=true;

  if IsWindowVisible(wnd) then
  if GetClassName(wnd,str,Sizeof(str)) > 0 then

  if rus_interface or (str[0] = 'T') then

  if StrIComp(str,'TApplication') <> 0 then
  if StrIComp(str,'TAppBuilder') <> 0 then
  if StrIComp(str,'TWatchWindow') <> 0 then
  if StrIComp(str,'TWindowsCMD') <> 0 then
  TIntegerList(lParam).AddItem(wnd)
end;

end.
