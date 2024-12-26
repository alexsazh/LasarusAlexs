unit PSX;

{$MODE Delphi}

 interface

uses
  classes, forms, comctrls,
  PSLOGS, PSNAMES, PSVMS;

type
  TPostScript = class
  private
  public
    Stat: Integer; {>=1: error, -1: exit, -2: stop, -3: quit}
    StoppedContext: boolean;

    Log: TPsLog; {TStrings}
    FLogForm: TForm;

    TreeView: TTreeView;
    TreeForm: TForm;

    Names: TPsName;
    VM: TPsVM;
    Include: string; {for FindFile; separator=';'}

    constructor Create;
    destructor Destroy; override;

    procedure LogWinOn(aLog: TStrings);

    procedure IncludeAdd(aDirList: string);
    procedure SetOption(key: char; val: string);

    function FindFile(fname: string): string;
    function RunFile(fname: string): boolean;
    function RunString(s: string): boolean;

    function RunCmdFile(fname: string): boolean;
    function RunCmdLine(cmdline: string): boolean;

    function CurrentName: string; {execquted now}
    function CurrentFile: string; {execquted now}
    function CurrentLine: Integer; {execquted now}
    procedure Error0(msg: string);
    procedure Error(msg: string; a: array of const);

    procedure SaveToFile(fname: string);
    procedure LoadFromFile(fname: string);

    procedure Tree;
  end;

var PS: TPostScript;

implementation

uses
  SysUtils, LCLIntf, LCLType, LMessages,
  PSOBJ, Pso, PSFILES, Wcmn, PSCMN, Filex,
  Psstacks, PSGSTATE, List, PSPATH;

{TPostScript:}

constructor TPostScript.Create;
const xmax=72000;
begin
  Names:=TPsName.Create;
  VM:=TPsVM.Create;

  operandstack:=TOperandStack.Create;
  dictstack:=TDictStack.Create;
  execstack:=TExecStack.Create;
  namestack:=TPsStack.Create;

  GState:=TGState.Create;
  GStateList:=TClassList.Create(10);

  GState.ClipPath.Rect(PsPoint(-xmax,-xmax), PsPoint(xmax,xmax));
end;

destructor TPostScript.Destroy;
begin
  GStateList.Free;
  GState.Free;

  operandstack.Free;
  dictstack.Free;
  execstack.Free;
  namestack.Free;

  VM.Free;
  Names.Free;
  Log.Free;
end;

procedure TPostScript.LogWinOn(aLog: TStrings);
begin
  Log.Free;
  Log:=TPsLog.Create(aLog);
end;

procedure TPostScript.IncludeAdd(aDirList: string);
begin
  if Length(aDirList)>0 then Include:=Include+';'+aDirList;
end;

procedure TPostScript.SetOption(key: char; val: string);
begin
  case key of
    'I': IncludeAdd(val);
    else Tellf('PS: Unknown Option:\n -%c%s',[key,val]);
  end;{case}
end;


function TPostScript.FindFile(fname: string): string;
begin
  if system.pos('\',fname)>0 then Result:=fname
  else Result:=FileSearch(fname, Include);
end;

function TPostScript.RunFile(fname: string): boolean;
begin
  Result:=false;
  if Stat<>0 then exit;
  fname:=str2psstr(fname);
  if operandstack.push( psobj_str_s(fname) ) then pso_runlibfile;
  Result:=(Stat<=0);
end;

function TPostScript.RunString(s: string): boolean;
begin
  if operandstack.push( psobj_str_s(s) ) then begin
    pso_cvx;
    pso_exec;
  end;
  Result:=(Stat<=0);
end;

function TPostScript.RunCmdFile(fname: string): boolean;
var f: TPsFile; s: string;
begin
  Result:=false;
  if Stat<>0 then exit;
  f:=TPsFile.Create;
  fname:=FindFile(fname);

  if f.Open(fname, fmOpenRead or fmShareDenyNone) then begin
    try
      while not f.EOF do begin
        s:=f.ReadLnS;
        RunCmdLine(s);
      end;
    finally
      f.Close;
    end;
  end else begin
    Error('Unable open file %s',[fname]);
  end;
  Result:=(Stat<=0);
end;

function TPostScript.RunCmdLine(cmdline: string): boolean;
var param: string;
begin
  while Stat=0 do begin
    param:=sread_word(cmdline);
    if param='' then break;

    case param[1] of
      '-': SetOption(param[2], system.copy(param,3,Length(param)-2));
      '@': RunCmdFile( system.copy(param,2,Length(param)-1) );
      else RunFile(param);
    end;{case}

  end;{while}

  Result:=(Stat<=0);
end;

function TPostScript.CurrentName: string; {execquted now}
var po: PPsObj; i: Integer;
begin
  Result:='';
  for i:=0 to namestack.count-1 do begin
    if i>0 then Result:=Result+'\';
    po:=namestack.getp(i);
    Result:=Result+psobj_print(po^);
  end;
end;

function TPostScript.CurrentFile: string; {execquted now}
var n: Integer; f: TPsFile;
begin
  Result:='';
  n:=execstack.CountToType(filetype,true);
  if n<0 then exit;
  f:=TPsFile(psobj_psobjx(execstack.indexp(n)^));
  Result:=f.Name;
end;

function TPostScript.CurrentLine: Integer; {execquted now}
var n: Integer; f: TPsFile;
begin
  Result:=0;
  n:=execstack.CountToType(filetype,true);
  if n<0 then exit;
  f:=TPsFile(psobj_psobjx(execstack.indexp(n)^));
  Result:=f.LineNum;
end;

procedure TPostScript.Error0(msg: string);
var s, sf,sn: string; l: Integer; zs1,zs2: array[0..256]of char;
begin
  if Stat<>0 then Tellf('ERROR???:\nВызов Error0(%s)\nпри статусе %d',[msg,Stat]);

  sf:=CurrentFile;
  l:=CurrentLine;
  sn:=CurrentName;
  s:=Formatn('PostScript ERROR:\n%s\nFILE=(%s)\nLINE=%d\nPROCEDURE=(%s)',[msg,sf,l,sn]);

  Stat:=1;      {один номер ошибки}
  PsLog_Wl(s);
  pso_pstack;
  (*
  if not StoppedContext then begin
    Tell(s);
  end;
  *)
  MessageBox(0, StrPCopy(zs1,s), StrPCopy(zs2,'PS: ERROR'), mb_Ok or mb_IconInformation);
end;

procedure TPostScript.Error(msg: string; a: array of const);
begin
  Error0( Formatn(msg,a) );
end;

procedure TPostScript.SaveToFile(fname: string);
var st: TMemoryStream; po: PPsObj; i: integer;
begin
  PsLog_WL('---Saving...---');

  st:=TMemoryStream.Create;
  try
    i:=123001; st.Write(i, sizeof(i));

    po:=dictstack.GetP(0); st.Write(po^, PsObjSize);
    po:=dictstack.GetP(1); st.Write(po^, PsObjSize);
    po:=dictstack.GetP(2); st.Write(po^, PsObjSize);

    Names.SaveToStream(st);
    VM.SaveToStream(st);

    st.SaveToFile(fname);
  finally
    st.Free;
  end;

  PsLog_WL('---Save - Ok---');
end;

procedure TPostScript.LoadFromFile(fname: string);
var st: TMemoryStream; o0,o1,o2: TPsObj; i: integer;
begin
  PsLog_WL('---Loading...---');

  st:=TMemoryStream.Create;
  try
    st.LoadFromFile(fname);

    st.Read(i, sizeof(i)); {123001}

    dictstack.Count:=0;

    st.Read(o0, PsObjSize);
    st.Read(o1, PsObjSize);
    st.Read(o2, PsObjSize);

    Names.LoadFromStream(st);

    dictstack.Push(o0); {=> KeyIndex}
    dictstack.Push(o1);
    dictstack.Push(o2);

    VM.LoadFromStream(st);



    pso_create; {по старым местам}
    VM.CheckOperators; {!}
  finally
    st.Free;
  end;

  PsLog_WL('---Load - Ok---');
end;

procedure TPostScript.Tree;
begin
  if not Assigned(TreeView) then exit;
  TreeView.Items.Clear;
  TreeForm.Show;
(*

procedure TPsDict.DrawTreeNode(TreeView: TTreeView; faser: TTreeNode);
var i: Integer; s: string; o: TPsObj; tn: TTreeNode;
begin
  tn:=TreeView.Items.AddChildObject(faser,ToStr,Self);

  if _.Count>0 then for i:=0 to _.Count-1 do begin
    TObject(o):=_.Objects[i];

    if o.PsType=PsTypeDict then begin
      TPsDict(o).DrawTreeNode(TreeView,tn);
    end else begin
      s:=_[i]+'='+o.ToStr;
      TreeView.Items.AddChildObject(tn,s,o);
    end;{if}
  end;{for}

end;{DrawTreeNode}

procedure TPsDict.Tree(TreeView: TTreeView);
begin
  TreeView.Items.Clear;
  DrawTreeNode(TreeView,nil);
end;

procedure TPsStack.Tree; {for PsDictStack!}
var i: integer; s: string; o: TPsObj;
begin
  PsTreeForm.Clear;
  if Count>0 then for i:=0 to Count-1 do begin
    o:=Items[i];
    if o.PsType=PsTypeDict then begin
      TPsDict(o).DrawTreeNode(PsTreeForm.Tree1,nil);
    end else begin
      s:=o.ToStr;
      PsTreeForm.Tree1.Items.AddChildObject(nil,s,o);
    end;{if}
  end;
  PsTreeForm.ShowModal;
end;

*)
  TreeForm.Show;
end;


end.
