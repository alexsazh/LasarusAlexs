unit OFiles1; interface {$H-}

uses
  Windows,Classes,OTypes,OFiles;


type
  TCustomFile = class
    destructor Destroy; override;
    procedure Close; virtual;

  private
    fHandle: THandle;
    fActive: Boolean;

    fPath: TShortstr;
    function GetPath: PChar;

  public
    property Active: Boolean read fActive;
    property Path: PChar read GetPath;
  end;

  TTextWrite = class(TCustomFile)
    procedure Close; override;

    procedure Erase;

    function New(APath: PChar): Boolean;
    function Open(APath: PChar): Boolean;

    function logTemp(Alt: PChar): Boolean;
    function NewTemp(Name: PChar): Boolean;
    function OpenTemp(Name: PChar): Boolean;

    procedure Flush;

    procedure WriteLn(Str: PChar);
    procedure WriteText(Str: PChar; Len: int);
    procedure WriteStr(const Str: String);
    procedure WriteStrA(const Str: AnsiString);
    procedure WriteStrW(const Str: WideString);

    procedure WriteMsg(const Str: String);

    procedure Write_ct(Capt: PChar; v: int);
    procedure Write_dt(Capt: PChar; v: int);

    procedure Write_int(Capt: PChar; v: int);
    procedure Write_hex(Capt: PChar; v,l: int);
    procedure Write_real(Capt: PChar; v: double; m: int);
    procedure Write_bool(Capt: PChar; v: bool);
    procedure Write_str(Capt,Str: PChar);
    procedure Write_str1(Capt: PChar; const Str: String);
    procedure Write_strA(Capt: PChar; const Str: AnsiString);

    procedure WriteStrings(List: TStrings);

    procedure inc_tab;
    procedure dec_tab;

  protected
    fShareMode: uint;
    
  private
    fLineCount: int;
    fIsFlush: bool;
    fIsNew: bool;

    ftab: String;

    fBuf: TCmdStr;

  public
    property IsFlush: bool write fIsFlush;
    property LineCount: int read fLineCount;
  end;

  TShareWrite = class(TTextWrite)
    constructor Create;
    procedure SetShareMode(Value: Integer);
  end;

  TShareRead = class(TCustomFile)

    function GetData(APath: PChar): Integer;

  private
    fReadPos: DWord;
    fIOError: Integer;
    fOnLine: TCharProc;

  public
    property IOError: Integer read fIOError;
    property OnLine: TCharProc write fOnLine;
  end;

  TXmlDoc = class
    constructor Create;
    destructor Destroy; override;

    function New(Dest: PChar): bool;
    procedure Close;

    procedure Create_doc; virtual;
    procedure Close_doc; virtual;

    procedure outUTF8;

    function pushTag(Name: PChar): Integer;
    function pushTagv(Name,Val: PChar): Integer;
    function pushTago(Name,Val: PChar): Integer;
    function popTag: Integer;

    procedure outLine(Str: PChar);

    procedure outTagi(Tag: PChar; V: int);
    procedure outTagh(Tag: PChar; V: int; len: int);
    procedure outTagf(Tag: PChar; V: Double; M: Integer);
    function outTags(Tag,Val: PChar): Boolean;

    function valTag(Tag,Val: PChar): Boolean;
    procedure dataTag(Tag: PChar; data: Pointer; size: int);

  protected
    procedure WriteStr(const Str: String);
    procedure WriteAnsi(const Str: AnsiString);

    function TabString: String;

  private
    fHandle: THandle;

    fTags: TStringList;
    fStrings: TStrings;

    function GetLevel: int;

    procedure write(buf: Pointer; size: int);

  public
    property Handle: THandle read fHandle;
    property Level: int read GetLevel;
    property Strings: TStrings write fStrings;
  end;

  TKmlDoc = class(TXmlDoc)
    procedure Create_doc; override;
  end;

  TXmlStrings = class(TXmlDoc)
    constructor Create;
    destructor Destroy; override;
  private
    fLines: TStringList;
  public
    property Lines: TStringList read fLines;
  end;

function xNameThis(Path1,Path2: PChar): Boolean;

function add_ext(List: TStrings; dir,ext: PChar): Integer;

function files_Nameof(files: TStrings;
                      Path,Dest: PChar): Integer;

function files_add(files,list: TStrings): Integer;

function Dump_text(Path: PChar; Lines: TStrings): Boolean;

function IsTextTrack(Path: PChar;
                     cols: PIntegers;
                     out fmt,flags: int): int;

function Is_Text_track(Path: PChar; out fmt: int): Integer;

function FindFileByDateName(Path,Mask: PChar; Date: Double): PChar;

implementation

uses
  Math,Sysutils,Convert;

function TCustomFile.GetPath: PChar;
begin
  Result:=fPath
end;

destructor TCustomFile.Destroy;
begin
  Close; inherited
end;

procedure TCustomFile.Close;
begin
  if fHandle <> 0 then CloseHandle(fHandle);
  fHandle:=0; fActive:=false
end;

procedure TTextWrite.Close;
begin
  ftab:='';

  if Active then begin
    inherited Close;

    if fIsNew and (fLineCount = 0) then
    if FileExist(Path) then FileErase(Path)
  end;

  fLineCount:=0
end;

procedure TTextWrite.Erase;
begin
  fLineCount:=0; Close
end;

function TTextWrite.New(APath: PChar): Boolean;
begin
  Close; fIsNew:=true;

  StrLCopy(fPath,APath,Sizeof(fPath)-1);

  fHandle:=CreateFile(fPath,GENERIC_WRITE,
                      fShareMode,
                      nil,CREATE_ALWAYS,
                      FILE_ATTRIBUTE_NORMAL,
                      0);

  fActive:=fHandle > 0; Result:=fActive
end;

function TTextWrite.Open(APath: PChar): Boolean;
begin
  Close; fIsNew:=false;

  StrLCopy(fPath,APath,Sizeof(fPath)-1);

  fHandle:=CreateFile(fPath,GENERIC_WRITE,
                      fShareMode,
                      nil,OPEN_ALWAYS,
                      FILE_ATTRIBUTE_NORMAL,
                      0);

  if fHandle > 0 then begin
    FileSeek(fHandle,0,2);
    fActive:=true
  end;

  Result:=fActive
end;

function TTextWrite.logTemp(Alt: PChar): Boolean;
var
  fn: TPathstr;
begin
  GetModuleFileName(hInstance,fn,Sizeof(fn)-1);
  StrNameExt(fn,fn);
  StrUpdateExt(fn,fn,'');
  StrCat(StrCat(fn,'_'),Alt);
  Result:=NewTemp(fn)
end;

function TTextWrite.NewTemp(Name: PChar): Boolean;
var
  fn: TShortstr;
begin
  StrWorkPath(fn,Name);
  Result:=New(fn)
end;

function TTextWrite.OpenTemp(Name: PChar): Boolean;
var
  fn: TShortstr;
begin
  StrWorkPath(fn,Name);
  Result:=Open(fn)
end;

procedure TTextWrite.Flush;
begin
  if fActive then
  FlushFileBuffers(fHandle)
end;

procedure TTextWrite.WriteLn(Str: PChar);
var
  l: int; S: TShortstr;
begin
  l:=Strlen(Str); if l > 0 then
  if fActive then begin

    Inc(fLineCount);

    if Length(ftab) > 0 then
    FileWrite(fHandle,ftab[1],Length(ftab));

    if l > Sizeof(S)-1 then begin
      FileWrite(fHandle,Str[0],l);
      S[0]:=#10; FileWrite(fHandle,S,1);
    end
    else begin
      StrLCopy(S,Str,Sizeof(S)-1);
      l:=Strlen(S); if l > 0 then begin
        S[l]:=#10; FileWrite(fHandle,S,l+1);
      end
    end;

    if fIsFlush then Flush
  end
end;

procedure TTextWrite.WriteText(Str: PChar; Len: int);
begin
  if Len > 0 then
  FileWrite(fHandle,Str[0],Len);
end;

procedure TTextWrite.WriteStr(const Str: String);
var
  l: int; buf: tbytes; s: String;
begin
  s:=Str; l:=Length(s);

  if l > 0 then
  if fActive then begin
    Inc(fLineCount);

    if Length(ftab) > 0 then
    FileWrite(fHandle,ftab[1],Length(ftab));

    Move(s[1],buf,l); buf[l]:=10;
    FileWrite(fHandle,buf,l+1);

    if fIsFlush then Flush
  end
end;

procedure TTextWrite.WriteStrA(const Str: AnsiString);
begin
  Writeln(StrPLCopy(fBuf,Str,Sizeof(fBuf)-1))
end;

procedure TTextWrite.WriteStrW(const Str: WideString);
begin
  Writeln(StrPLCopy(fBuf,Str,Sizeof(fBuf)-1))
end;

procedure TTextWrite.WriteMsg(const Str: String);
var
  S: TShortstr;
begin
  StrFmt(S,'%s %s',[xTimeStr(Time),Str]);
  Writeln(S)
end;

procedure TTextWrite.Write_ct(Capt: PChar; v: int);
var
  S: TShortstr;
begin
  StrFmt(S,'%s=%d',[Capt,GetTickCount-v]);
  Writeln(S)
end;

procedure TTextWrite.Write_dt(Capt: PChar; v: int);
var
  S: TShortstr;
begin
  StrFmt(S,'%s=%d',[Capt,v]);
  Writeln(S)
end;

procedure TTextWrite.Write_int(Capt: PChar; v: int);
var
  S: TShortstr;
begin
  StrFmt(S,'%s=%d',[Capt,v]);
  Writeln(S)
end;

procedure TTextWrite.Write_hex(Capt: PChar; v,l: int);
begin
  WriteStr(Strpas(Capt)+'=0x'+HexToStr(v,l))
end;

procedure TTextWrite.Write_real(Capt: PChar; v: double; m: int);
begin
  WriteStr(Strpas(Capt)+'='+RealToStr(v,m))
end;

procedure TTextWrite.Write_bool(Capt: PChar; v: bool);
var
  S: TShortstr;
begin
  StrFmt(S,'%s=%d',[Capt,ibool[v]]);
  Writeln(S)
end;

procedure TTextWrite.Write_str(Capt,Str: PChar);
var
  S: TShortstr;
begin
  StrFmt(S,'%s=%s',[Capt,Str]);
  Writeln(S)
end;

procedure TTextWrite.Write_str1(Capt: PChar; const Str: String);
begin
  WriteStr(Format('%s=%s',[Capt,Str]))
end;

procedure TTextWrite.Write_strA(Capt: PChar; const Str: AnsiString);
begin
  WriteStrA(Strpas(Capt)+'='+Str)
end;

procedure TTextWrite.WriteStrings(List: TStrings);
var
  i: int;
begin
  for i:=0 to List.Count-1 do
  WriteStr(List[i])
end;

procedure TTextWrite.inc_tab;
begin
  ftab:=ftab+'  '
end;

procedure TTextWrite.dec_tab;
begin
  SetLength(ftab,Max(0,Length(ftab)-2))
end;

constructor TShareWrite.Create;
begin
  inherited Create;
  SetShareMode(1)
end;

procedure TShareWrite.SetShareMode(Value: Integer);
begin
  if Value = 0 then begin
    fShareMode:=0; fIsFlush:=false
  end
  else begin
    fShareMode:=FILE_SHARE_READ;
    fIsFlush:=true
  end
end;

function TShareRead.GetData(APath: PChar): Integer;
var
  h,len,sz,rc: Integer;
  q,p: PChar; str: TShortstr;
  buf: tbytes;
begin
  Result:=0; fIOError:=0;

  if StrComp(Path,APath) <> 0 then begin
    StrLCopy(fPath,APath,Sizeof(fPath)-1);
    fReadPos:=xFileSize(Path);
  end;

  sz:=xFileSize(Path);
  if sz > fReadPos then begin

    h:=CreateFile(Path,GENERIC_READ,
                  FILE_SHARE_WRITE,
                  nil,OPEN_EXISTING,
                  FILE_ATTRIBUTE_NORMAL,
                  0);

    if h <= 0 then begin
      fIOError:=GetLastError; Result:=-1
    end
    else begin
      FileSeek(h,fReadPos,0);

      while fReadPos < sz do begin

        len:=sz-fReadPos;
        len:=Min(Sizeof(buf)-1,len);
        FileRead(h,buf,len);

        buf[len]:=0; q:=@buf;
        while true do begin
          p:=StrScan(q,#13);
          if p = nil then
            p:=StrScan(q,#10)
          else
          if p[1] = #10 then p:=@p[1];

          if Assigned(p) then p[0]:=#0;

          StrLCopy(str,q,255);
          Inc(Result);

          if Assigned(fOnLine) then
          fOnLine(Self,Str);

          if p = nil then Break;
          q:=@p[1]
        end;

        Inc(fReadPos,len);
      end;

      FileClose(h)
    end
  end
end;

constructor TXmlDoc.Create;
begin
  inherited Create;
  fTags:=TStringList.Create;
end;

destructor TXmlDoc.Destroy;
begin
  Close; fTags.Free;
  fTags:=nil; inherited
end;

function TXmlDoc.New(Dest: PChar): bool;
begin
  Result:=false; Close;

  fHandle:=FileCreate(Dest);
  if fHandle <> 0 then begin
    Create_doc; Result:=true
  end
end;

procedure TXmlDoc.Close;
begin
  if fHandle <> 0 then begin
    Close_doc; FileClose(fHandle)
  end; fHandle:=0
end;

procedure TXmlDoc.Create_doc;
begin
end;

procedure TXmlDoc.Close_doc;
begin
  if Assigned(fTags) then
  while fTags.Count > 0 do
  PopTag;
end;

procedure TXmlDoc.write(buf: Pointer; size: int);
begin
  if fHandle <> 0 then
  FileWrite(fHandle,buf^,size)
end;

procedure TXmlDoc.WriteStr(const Str: String);
const
  _eol: Char2 = #13#10;
var
  len: int;
begin
  len:=Length(Str);
  if len > 0 then
  write(@Str[1],len);
  write(@_eol,2)
end;

procedure TXmlDoc.WriteAnsi(const Str: AnsiString);
const
  _eol: Char2 = #13#10;
var
  len: int;
begin
  len:=Length(Str);
  if len > 0 then
  write(@Str[1],len);
  write(@_eol,2)
end;

procedure TXmlDoc.outUTF8;
begin
  WriteStr('<?xml version="1.0" encoding="UTF-8"?>')
end;

function TXmlDoc.GetLevel: int;
begin
  Result:=fTags.Count
end;

function TXmlDoc.TabString: String;
var
  i: int; s: String;
begin
  s:='';
  for i:=1 to Min(32,fTags.Count) do
  s:=s+#9;

  Result:=s
end;

procedure TXmlDoc.outLine(Str: PChar);
var
  l: Integer; s: TShortstr;
begin
  if Assigned(fStrings) then
    fStrings.Add(Str)
  else begin
    l:=Min(32,fTags.Count);
    if l > 0 then Fillchar(s,l,#9);
    StrLCopy(@s[l],Str,255);
    WriteStr(Strpas(s))
  end
end;

procedure TXmlDoc.outTagi(Tag: PChar; V: int);
var
  s: TShortStr;
begin
  StrFmt(s,'<%s>%d</%s>',[Tag,V,Tag]);
  outLine(s);
end;

procedure TXmlDoc.outTagh(Tag: PChar; V: int; len: int);
var
  s: TShortStr;
begin
  StrFmt(s,'<%s>%s</%s>',[Tag,HexToStr(V,len),Tag]);
  outLine(s);
end;

procedure TXmlDoc.outTagf(Tag: PChar; V: Double; M: Integer);
var
  s: TShortstr;
begin
  StrFmt(s,'<%s>%s</%s>',[Tag,RealToStr(V,M),Tag]);
  outLine(s);
end;

function TXmlDoc.outTags(Tag,Val: PChar): Boolean;
var
  v: AnsiString; s: TShortstr;
begin
  Result:=is_rus(Val);

  v:=Strpas(Val);
  if Result then
  v:=UTF8Encode(v);

  StrLFmt(s,255,'<%s>%s</%s>',[Tag,v,Tag]);
  outline(s)
end;

function TXmlDoc.valTag(Tag,Val: PChar): Boolean;
var
  v: AnsiString; s: TShortstr;
begin
  Result:=is_rus(Val);

  v:=Strpas(Val);
  if Result then
  v:=UTF8Encode(v);

  StrFmt(s,'<%s %s />',[Tag,v]);
  outline(s)
end;

procedure TXmlDoc.dataTag(Tag: PChar; data: Pointer; size: int);
var
  s: String;
begin
  s:=Format('<%s>',[Tag]);
  write(@s[1],Length(s));
  write(data,size);
  WriteStr(Format('</%s>',[Tag]));
end;

function TXmlDoc.pushTag(Name: PChar): Integer;
var
  s: TShortStr;
begin
  StrPCopy(s,'<'+StrPas(Name)+'>');
  outLine(s); Result:=fTags.Add(Name);
end;

function TXmlDoc.pushTagv(Name,Val: PChar): int;
var
  s: TShortStr;
begin
  StrFmt(s,'<%s %s>',[Name,Val]);
  outLine(s); Result:=fTags.Add(Name);
end;

function TXmlDoc.pushTago(Name,Val: PChar): Integer;
var
  s: TShortStr;
begin
  StrFmt(s,'<%s',[Name]);
  
  if Assigned(Val) then
  StrCat(StrCat(s,' '),Val);

  outLine(s); Result:=fTags.Add(Name);
end;

function TXmlDoc.popTag: Integer;
var
  s: TShortStr;
begin
  Result:=fTags.Count-1;
  if Result >= 0 then begin
    StrPCopy(s,'</'+fTags[Result]+'>');
    fTags.Delete(Result); outLine(s)
  end
end;

procedure TKmlDoc.Create_doc;
begin
  outUTF8;
  pushTagv('kml','xmlns="http://earth.google.com/kml/2.1"');
end;

constructor TXmlStrings.Create;
begin
  inherited Create;
  fLines:=TStringList.Create;
  Strings:=fLines
end;

destructor TXmlStrings.Destroy;
begin
  Strings:=nil;
  fLines.Free;
  inherited
end;

function xNameThis(Path1,Path2: PChar): Boolean;
var
  fn1,fn2: TShortstr;
begin
  StrNameExt(fn1,Path1);
  StrUpdateExt(fn1,fn1,'');

  StrNameExt(fn2,Path2);
  StrUpdateExt(fn2,fn2,'');

  Result:=StrIComp(fn1,fn2) = 0
end;

function add_ext(List: TStrings; dir,ext: PChar): Integer;
var
  tmp: TStringList; fn: TShortstr;
begin
  Result:=0;

  tmp:=TStringList.Create;
  try
    tmp.Sorted:=true;

    ChDir(dir);
    StrCopy(fn,'*.');
    StrCat(fn,Ext);

    Add_FNames(fn,tmp);

    List.AddStrings(tmp);
    Result:=tmp.Count
  finally
    tmp.Free
  end
end;

function files_Nameof(files: TStrings;
                      Path,Dest: PChar): Integer;
var
  i: Integer; fn,fn1: TShortstr;
begin
  Result:=-1; StrCopy(Dest,'');

  StrNameExt(fn,Path);
  StrUpdateExt(fn,fn,'');

  for i:=0 to files.Count-1 do begin
    StrPLCopy(Dest,files[i],255);
    StrNameExt(fn1,Dest);
    StrUpdateExt(fn1,fn1,'');

    if StrIComp(fn1,fn) = 0 then begin
      Result:=i; Break
    end
  end
end;

function files_add(files,list: TStrings): Integer;
var
  i: Integer;
begin
  Result:=0; i:=0;
  while i < list.Count do
  if files.IndexOf(list[i]) < 0 then
  Inc(i) else list.Delete(i);

  files.AddStrings(list);
  Result:=list.Count
end;

function Dump_text(Path: PChar; Lines: TStrings): Boolean;
var
  i: int; f: Text;
begin
  Result:=false;

  if Strlen(Path) > 0 then
  if Lines.Count > 0 then begin

    AssignFile(f,Strpas(Path));

    if FileExists(StrPas(Path)) then
      Append(f)
    else
      Rewrite(f);

    if IOResult = 0 then begin

      for i:=0 to Lines.Count-1 do
      writeln(f,Lines[i]);

      Flush(f); CloseFile(f); Result:=true
    end;
  end
end;

function IsTextTrack(Path: PChar;
                     cols: PIntegers;
                     out fmt,flags: int): int;
var
  txt: TTextfile;
  i,k,k1,per: int; p: PChar;
  hist: Array[0..15] of int;
  s,t: TShortstr; fl: bool;
begin
  Result:=0; fmt:=0; flags:=0;

  txt:=TTextfile.Create;
  try
    Fillchar(hist,Sizeof(hist),0); k:=0;

    if txt.Open(Path) then
    while txt.xStrLine <> nil do begin
      k1:=0;

      StrCopy(s,txt.str);

      if StrLComp(s,'# ',2) = 0 then begin

        fl:=Is_Comma_Delimiter;
        Is_Comma_Delimiter:=false;

        StrToken(t,s);
        if StrToken(t,s) <> nil then

        if StrIComp(t,'CoordinateSystem:') = 0 then begin
          if StrPos(s,'WGS 84') <> nil then
          flags:=flags or $8000
        end else
        if StrIComp(t,'Label') = 0 then begin

          for i:=0 to 15 do cols[i]:=0;

          cols[0]:=9; i:=0;
          while StrToken(t,s) <> nil do begin
            Inc(i); if i < 15 then
            if StrIComp(t,'Y/North') = 0    then cols[i]:=1 else
            if StrIComp(t,'X/East') = 0     then cols[i]:=2 else
            if StrIComp(t,'Z/Altitude') = 0 then cols[i]:=3 else

            if (StrIComp(t,'Roll') = 0)
            or (StrIComp(t,'Крен') = 0)   then cols[i]:=4 else

            if (StrIComp(t,'Pitch') = 0)
            or (StrIComp(t,'Тангаж') = 0) then cols[i]:=5 else

            if (StrIComp(t,'Yaw') = 0)
            or (StrIComp(t,'Курс') = 0)   then cols[i]:=6;
          end;

          for i:=0 to 15 do
          if cols[i] > 0 then
          flags:=flags or (1 shl i)
        end;

        Is_Comma_Delimiter:=fl
      end
      else begin
        if StrIComp(s,';sau') = 0 then fmt:=2;

        p:=StrScan(s,';');
        if p = nil then begin
          while StrToken(t,s) <> nil do Inc(k1)
        end
        else begin k1:=1;
          while true do begin
            p:=xStrSkip(@p[1],' '#9);
            if p[0] = #0 then Break; Inc(k1);
            p:=StrScan(@p[1],';');
            if p = nil then Break
          end
        end;

        if k1 > 15 then k1:=15; Inc(hist[k1]); Inc(k);
        if k = 100 then Break
      end
    end;

    if k >= 10 then
    for i:=1 to 15 do begin
      per:=hist[i] * 100 div k;
      if per >= 80 then begin
        Result:=i; Break
      end
    end;

  finally
    txt.Free
  end
end;

function Is_Text_track(Path: PChar; out fmt: int): int;
var
  cols: IValues16; flags: int;
begin
  Result:=IsTextTrack(Path,@cols,fmt,flags)
end;

function FindFileByDateName(Path,Mask: PChar; Date: Double): PChar;

function StrToDate(Str: PChar; out dt: Integer): Boolean;
var
  i,ax,bx,rc: Integer; p: PChar;
begin
  Result:=false; dt:=0;

  ax:=0; p:=Str;
  for i:=1 to 3 do
  if StrLen(p) > 0 then begin
    val(p,bx,rc); ax:=ax*100 + bx;

    if i = 3 then begin
      if (rc = 0) or (p[rc-1] = '.') then
      begin dt:=ax; Result:=true end
    end
    else begin
      if rc = 0 then Break; p:=@p[rc];
    end
  end
end;

var
  fRec: TSearchRec; dir,fn: TShortstr;
  year,month,day: Word; d1,d2,dd,t: Integer;
begin
  Result:=nil; StrCopy(Path,'');

  DecodeDate(Date,year,month,day);
  d1:=(year mod 100);
  d1:=d1 * 100 + month;
  d1:=d1 * 100 + day;

  StrDirectory(dir,Mask);
  if FindFirst(Mask,faArchive,fRec) = 0 then begin

    repeat
      StrPCopy(fn,FRec.Name);
      if StrToDate(fn,d2) then
      if d2 <= d1 then begin t:=d1-d2;
        if (Result = nil) or (t < dd) then begin
          Result:=StrPath(Path,dir,fn);
          if t = 0 then Break; dd:=t
        end
      end
    until FindNext(FRec) <> 0;

    FindClose(fRec)
  end;
end;

end.
