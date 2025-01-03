unit wordx; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleServer, WordXP{Program Files\Borland\BDS\4.0\Ocx\Servers\WordXP.pas}
  //Word2000,
  ;


//������-����� ������ -- FOR USE wordx in DLL: FormW.Create/Free:
function wdx_dll_BeginJob: boolean; stdcall;//FormW.Create
procedure wdx_dll_EndJob; stdcall;//FormW.Free


//����� ������� � Word Application:
type
  TFormW = class(TForm)
    WordApplication1: TWordApplication;
    WordDocument1: TWordDocument;
    WordDocument2: TWordDocument;
  private
    { Private declarations }
  public
    function BeginJob: boolean;
    procedure EndJob;
    function ConnectActive(aWD: TWordDocument): boolean;

    procedure NewDocument;
    function Open(aFileName: string; aReadOnly: boolean): boolean;
    //���� docname<>'', �� tmpname ���������� � docname, � ����������� docname:
    function OpenTemplate(tmpname,docname: string): boolean;

    //��� WordApplication.Disconnect:

    procedure DOC_CopyToClipboard(doc_path: string);//WordDocument1
    procedure DOC_CopyToClipboard2(doc_path: string);//WordDocument2
    procedure Table_CopyToClipboard2(doc_path: string);//WordDocument2

    function Selection: WordSelection;//Start=0, End_=0 � ������ ������

    //�������� Selection � ������� �����:
    //aMode: -1 - toStart, 0 - do Nothing, 1 - toEnd of Selection:
    procedure SelectionCollapse(aCollapseMode{-1,0,1}: integer);

    //�� �������, ���� Selection �����, ����� - ������ Selection(!)
    //������ Selection, ���� TRUE
    //for FindNext: ������������ SelectionCollapse(-1)
    //Selection.Text:='' - ���� ������ for FindNext
    //SelectionCollapse(+1) ��������� �� ����. �������� ������, �� �� ����� ������ � ����. ������
    function FindForward(sFind: string): boolean;//=>Selection
    function ReplaceForward(sFind, sReplace: string; aCollapseMode{-1,0,1}: integer): boolean;//=>Selection, aCollapseMode=-1 for FindNext

    procedure AddImage(aImagePath: string);//Selection.Text:=''; if FileExists


    //--------------------------------

    function FindText(aWD: TWordDocument; s: string): integer; //>=0
    procedure SetText(aWD: TWordDocument; ind,count: integer; s: string); //ind>=0

    //k-�� ������ -> count+1 ����� (����� row-k) (k>=1):
    procedure ExpandTable(var xTable: Table; k,count: integer);

    //������� �� ������� ncell:
    procedure SetRowText(xRow: Row; ncell: integer; sarray: array of string);

    procedure Test;
  end;

var
  FormW: TFormW;


//in Document:
procedure wordx_RepeatRangeInds(aWD: TWordDocument; i1,i2, n: integer);//Range(i1,i2).Copy -> Paste ����� i1 n ���
procedure wordx_SetBold(aWD: TWordDocument; start, length: integer);

//in Range:
function wordx_FindTextInRange(aRange: Range; sFind: string): boolean;//�������������� Range ����������
function wordx_ReplaceTextInRange(aRange: Range; sFind, sReplace: string): boolean;//ok
function wordx_ReplaceAllTextInRange(aRange: Range; sFind, sReplace: string): boolean;


implementation

{$R *.DFM}

uses wcmn, variants;


//������-����� ������ -- FOR DLL:
function wdx_dll_BeginJob: boolean;//FormW.Create
begin
  Result := FALSE;
  FormW := TFormW.Create(NIL);//!
  if Assigned(FormW) then Result := FormW.BeginJob;
end;

procedure wdx_dll_EndJob;//FormW.Free
begin
  FormW.EndJob;//!
  FormW.Free;
end;


//----------------------------------------------------------------------
//----------------------------------------------------------------------

procedure wordx_RepeatRangeInds(aWD: TWordDocument; i1,i2, n: integer);//Range(i1,i2).Copy -> Paste ����� i1 n ���
var i: integer; var Ind1,Ind2,Ind: OleVariant;
begin
  if n<=0 then exit;
  Ind1:=i1;
  Ind2:=i2;
  aWD.Range(Ind1,Ind2).Copy;
  Ind:=i1;
  for i:=1 to n do aWD.Range(Ind,Ind).Paste;
end;

procedure wordx_SetBold(aWD: TWordDocument; start, length: integer);
var Ind1,Ind2: OleVariant;
begin
  if length<=0 then exit;
  Ind1:=start;
  Ind2:=start+length;
//  aWD.Range(Ind1,Ind2).Bold;
  aWD.Range(Ind1,Ind2).Font.Bold := wdToggle;
end;


function wordx_FindTextInRange(aRange: Range; sFind: string): boolean;
var vaFindText: OleVariant;
begin
  vaFindText:=sFind;
  Result := aRange.Find.Execute(vaFindText,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam{ReplaceWith},
    EmptyParam{Replace},
    EmptyParam, EmptyParam,
    EmptyParam, EmptyParam);
end;

function wordx_ReplaceTextInRange(aRange: Range; sFind, sReplace: string): boolean;
var vaFindText, vaReplaceWith, vaReplace: OleVariant;
begin
  vaFindText:=sFind;

  vaReplaceWith:=sReplace;
  vaReplace:=wdReplaceOne;

  Result := aRange.Find.Execute(vaFindText,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    vaReplaceWith{ReplaceWith},
    vaReplace{Replace},
    EmptyParam, EmptyParam,
    EmptyParam, EmptyParam);
end;

function wordx_ReplaceAllTextInRange(aRange: Range; sFind, sReplace: string): boolean;
var vaFindText, vaReplaceWith, vaReplace: OleVariant;
begin
  vaFindText:=sFind;

  vaReplaceWith:=sReplace;
  vaReplace:=wdReplaceAll;

  Result := aRange.Find.Execute(vaFindText,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    vaReplaceWith{ReplaceWith},
    vaReplace{Replace},
    EmptyParam, EmptyParam,
    EmptyParam, EmptyParam);
end;


//-----------------------------------------------------

procedure TFormW.Test;
//var n: integer; sec: section;
begin
  if not BeginJob then exit;
  try

//    Tellf('%d',[n]);
  finally
    EndJob;
  end;
end;

//-----------------------------------------------------
// TFormW:
//-----------------------------------------------------

function TFormW.BeginJob: boolean;
begin
  try
    WordApplication1.Connect;
    WordApplication1.Visible := True;//DEBUG!
    Result:=true;
  except
    Tell('��� ����� � ����������� "MS Word"');
    WordApplication1.Disconnect;//����������
    Result:=false;
  end;
end;

procedure TFormW.EndJob;
begin
  try
    //WordApplication1.Visible := True;//???
    WordApplication1.Disconnect;
    //WordApplication1.Quit//�� ����! - ������ � ���������� ��������� �� Save
  except
  end;
end;

function TFormW.ConnectActive(aWD: TWordDocument): boolean;
begin
  try
    aWD.ConnectTo( WordApplication1.ActiveDocument );
    Result:=true;
  except
    Tell('��� ��������� ���������');
    Result:=false;
  end;
end;

procedure TFormW.NewDocument;
var
  NewTemplate: OleVariant;
  Visible: OleVariant;
begin
  NewTemplate:=True;
  Visible:=True;
  WordApplication1.Documents.Add(EmptyParam, NewTemplate, EmptyParam, Visible);
end;

function TFormW.Open(aFileName: string; aReadOnly: boolean): boolean;
var
  FileName, ReadOnly: OleVariant;
begin
  try
    FileName:=aFileName;
    ReadOnly:=aReadOnly;

    WordApplication1.Documents.Open
      (
      FileName, EmptyParam, ReadOnly, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
      EmptyParam,
      EmptyParam, EmptyParam, EmptyParam
      );

    Result:=true;
  except
    Result:=false;
  end;
end;

function TFormW.OpenTemplate(tmpname,docname: string): boolean;
begin
  Result:=false;//default

  if Length(docname)=0 then EXIT;//!

  if not FileExists(tmpname) then begin
    Tellf('����������� ���� "%s"',[tmpname]);
    EXIT;//!
  end;

  if FileExists(docname) and not DeleteFile(docname) then begin
    Tellf('���������� �������� ������������ ���� "%s".\n ��������, �� ������ � MS Word.',[docname]);
    EXIT;//!
  end;

  if wcmn_filecopy([tmpname],docname)<=0 then begin
    Tellf('������ ����������� ������� "%s".\n ��������, �� ������ � MS Word.',[tmpname]);
    EXIT;//!
  end;

  if not FormW.Open(docname, false) then begin
    Tellf('MS Word: Open Error on "%s"',[docname]);
    EXIT;//!
  end;

  Result:=true;//OK!
end;



procedure TFormW.DOC_CopyToClipboard(doc_path: string);
begin
    if FormW.Open(doc_path, TRUE{ReadOnly}) then begin//ActiveDocument
      FormW.ConnectActive(FormW.WordDocument1);//WordApplication1
      try
        FormW.WordDocument1.Range.Copy;//Copy with #13!
      finally
        FormW.WordDocument1.Close;//!
        FormW.WordDocument1.Disconnect;
      end;
    end;//FormW.Open
end;

procedure TFormW.DOC_CopyToClipboard2(doc_path: string);
begin
    if FormW.Open(doc_path, TRUE{ReadOnly}) then begin//ActiveDocument
      FormW.ConnectActive(FormW.WordDocument2);//WordApplication1
      try
        FormW.WordDocument2.Range.Copy;//Copy with #13!
      finally
        FormW.WordDocument2.Close;//!
        FormW.WordDocument2.Disconnect;
      end;
    end;//FormW.Open
end;

procedure TFormW.Table_CopyToClipboard2(doc_path: string);
begin
    if FormW.Open(doc_path, TRUE{ReadOnly}) then begin//ActiveDocument
      FormW.ConnectActive(FormW.WordDocument2);//WordApplication1
      try
        FormW.WordDocument2.Range.Tables.Item(1).range.copy;
        //FormW.WordDocument2.Range.Copy;//Copy with #13!
      finally
        FormW.WordDocument2.Close;//!
        FormW.WordDocument2.Disconnect;
      end;
    end;//FormW.Open
end;



function TFormW.Selection: WordSelection;
begin
  Result:=WordApplication1.Selection;
end;

procedure TFormW.SelectionCollapse(aCollapseMode{-1,0,1}: integer);
var ovCollapseDir{start=1, end=0}: OleVariant;
begin
  ovCollapseDir:=0;
  case aCollapseMode of
    -1: ovCollapseDir:=wdCollapseStart;
     1: ovCollapseDir:=wdCollapseEnd;
  end;//case
  if (aCollapseMode=-1) or (aCollapseMode=1) then
    WordApplication1.Selection.Collapse(ovCollapseDir);
end;


function TFormW.FindForward(sFind: string): boolean;
var vaFindText: OleVariant;
begin
  vaFindText:=sFind;
  Result := WordApplication1.Selection.Find.Execute(
    vaFindText,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam, EmptyParam, EmptyParam, EmptyParam,
    EmptyParam{ReplaceWith},
    EmptyParam{Replace},
    EmptyParam, EmptyParam,
    EmptyParam, EmptyParam);
end;

function TFormW.ReplaceForward(sFind, sReplace: string; aCollapseMode{-1,0,1}: integer): boolean;
begin
  Result := FindForward(sFind);//=>Selection
  if Result then begin
    Selection.Text:=sReplace;
    SelectionCollapse(aCollapseMode);
  end;
end;


procedure TFormW.AddImage(aImagePath: string);
var ovLinkToFile, ovSaveWithDocument: OleVariant;
begin
  Selection.Text:='';//������!
  if not FileExists(aImagePath) then exit;

  ovLinkToFile:=False;
  ovSaveWithDocument:=True;

  //function: Result=InlineShape:
  WordApplication1.Selection.InlineShapes.AddPicture(
    aImagePath,
    ovLinkToFile, ovSaveWithDocument,
    EmptyParam);
end;

//-------------------------------------------------------------

function TFormW.FindText(aWD: TWordDocument; s: string): integer; //>=0
var sdoc: string;
begin
  sdoc:=aWD.Range.Text;
  Result:=pos(s,sdoc)-1;    //-1!!!
end;

procedure TFormW.SetText(aWD: TWordDocument; ind,count: integer; s: string);
var Ind1,Ind2: OleVariant;
begin
  Ind1:=ind;
  Ind2:=ind+count; //������ ����-�� ��-��!
  aWD.Range(Ind1,Ind2).Text:=WideString(s);
end;

//k-�� ������ -> count+1 ����� (����� row-k) (k>=1):
procedure TFormW.ExpandTable(var xTable: Table; k,count: integer);
var xn: OleVariant;
begin
  if count<=0 then exit;//!
  xn:=count;
  xTable.Rows.Item(k).Select;
  WordApplication1.Selection.InsertRows(xn);
  xTable:=WordApplication1.Selection.Tables.Item(1);
end;

procedure TFormW.SetRowText(xRow: Row; ncell: integer; sarray: array of string);
var
  n,i: integer;
//  xRange: Range; j: integer; s: WideString;
begin
  n:=Length(sarray);
  if n>0 then for i:=0 to n-1 do begin
    xRow.Cells.Item(ncell+i).Range.Text:=WideString(sarray[i]);
(*
      xRange:=xRow.Cells.Item(ncell+i).Range;
      xRange.Text:='';
//      xRange.InsertAfter( WideString(sarray[i]) );
      s:=WideString(sarray[i]);
      for j:=1 to Length(s) do xRange.InsertAfter( s[j] );
*)
  end;//for i
end;

end.
