unit dmtxt; interface

uses
  ComCtrls, Classes,
  Otypes, list, dmlib, nums, vlib, llib, llibx;

//{$DEFINE ExpandOnUnderline}


const
  //����� - ������� �����; ����� ���� - ������� ������(!):
  DmTxt_RightAreaFromBound: boolean = false;

  dmtxt_expand_k = 1.5 ;//for Expanded: ����������� ���������� ���� � ��������

  txa_string = 'LRCD';//functions AlignmentToChar, CharToAlignment

(*
  TDmStr.tag: text alignment:
  0  - left-bottom
  1  - left-center
  2  - left-top
  16 - right-bottom
  17 - right-center
  18 - right-top
  20 - center-bottom
  21 - center-center
  22 - center-top
*)
type
  //������,�����:
  TDmStr = class(TDmObj)
  public
    Str: string;//Win-���������!
    tag: byte;//up-down, � �������� � �.�.
    Width,Height: longint;//<-CalcWidthHeight (������� �������� �����)
    Expanded: boolean;//� �������� (dmtxt_expand_k)
    NoSpace2: boolean;//��� ������� ����� �����
    //for Gauss - use inherited constructors + Points,Str,tag (!!!):
    constructor CreateStr(aLcode: longint; aStr: string); //Point[0]=(0;0), NOT GAUSS!!!
    procedure Clear; override;
    procedure Read; override;
    procedure Write; override;
    function Add(down: boolean): longint; override;
    procedure CalcWidthHeight;//lcode,txt->Width,Height
  end;

type
  //TxAlignment = TParaAttributes.Alignment + txaDouble
  //txaDouble = "Justify" (RTF �� ������������!)
  TxAlignment = (txaLeft, txaRight, txaCenter, txaDouble);
  TyAlignment = (tyaUp, tyaDown, tyaCenter);


function AlignmentToChar(xa: TxAlignment): char;
function CharToAlignment(cxa: char): TxAlignment;


type
  TDmText = class;

  //�������� - ������ ����:
  TDmPara = class(TClassList)//of TDmStr
  public
    Alignment: TxAlignment;
    FirstIndent: integer;//��.������, <0 => "������"
    procedure SetTextCode(aCode: longint);//���� �� ��� �����, �������� �������� ����(!)
    //������ ���������� ������:
    procedure AddLinesx(dmtext: tdmtext; lWidth0,lSpace: longint);
    //ibe - ������ 1-��� ������� pab-pae, � ����� ibe - �� ����-�� �����(!):
    procedure AddLinespp(dmtext: tdmtext; pab,pae: tpa; var ibe: longint; lSpace: longint);
  end;

  TDmTextLine = class
  private
    procedure Draw0(p1,p2: tnum2; lSpace: longint; down0: boolean);
  public
    Para{Words}: TDmPara;  //->TDmPara; ������ �����!
    IndFirst,IndLast: Integer; //in Para; IndFirst>IndLast - ������ ������(!)
    constructor Create(aPara: TDmPara; aIndFirst,aIndLast: Integer);
    procedure Drawx(lp: lpoint; lWidth,lSpace: longint; down: boolean);
    procedure Drawpp(p1,p2: tnum2; lSpace: longint; down: boolean);
  end;


  tt_data = record//uses in LoadFromRichEdit
    code_t: longint;
    code_tb: longint;//Bold
    code_ti: longint;//Italic
    code_tu: longint;//Underline
//    Interval_mm: double;
//    Indent_mm: double;
    Justify: boolean;
//    FirstIndent_mm: double;
  end;

(*
  TDmText = list of TDmPara:
  ������������� ������� �� 3-� ��� �� 2-� �����:
  1:    Step1 - Load...
        Step2 - MakeLines...
        Step3 - DrawLines...
  2:    Step1 -  Load...
        Step23 - DrawText...
*)
  TDmText = class(TClassList)//of TDmPara:
  protected
    procedure AddTextLine(dmpara: TDmPara; k0,k1: integer); //->Lines
  public
    ChildText: boolean;//�������� ����� (!)
    Lines: TClassList;//of TDmTextLine
    constructor New;
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: boolean;//��� ����

    procedure AddParaFromStr(Str: string; code: longint);
    procedure SetAlignment(Alignment: TxAlignment);//���� �� ��� ���-��
    procedure SetFirstIndent(FirstIndent: longint);//���� �� ��� ���-��
    procedure SetTextCode(aCode: longint);//���� �� ��� ���-��, �������� �������� ����(!)

    //Step1 - Load:

    //1 ��������:
    procedure LoadFromStr(Str: string; code: longint);
    //������-���������:
    procedure LoadFromStrings(Strings: tstrings; i0,i1: integer; code: longint);

    procedure LoadFromRichEdit(RE: TRichEdit; PixelsPerInch: Integer; lpmm: double; t_data: tt_data);//Clear(!)
    procedure LoadFromRichEdit_Grunt(RE: TRichEdit; PixelsPerInch: Integer; lpmm: double; acode_t,acode_tb,acode_ti: longint; aJustify: boolean);//Clear(!)

    //Step2 - MakeLines:

    //������ ���������� ������:
    procedure MakeLinesx(lWidth0,lSpace: longint);
    //������ ���������� ������:
    //pab,pae - ��������� � �������� ����� ����� ������:
    procedure MakeLinespp(pab,pae: tpa; lSpace: longint);

    //Step3 - DrawLines (����� MakeLines):

    //�������������� ������ ���������� ������:
    //lp - ���.������� ���� ����� ������:
    //bcode>0 => �������� ����� ������ � ����� bcode:
    procedure DrawLinesIndsx(bcode: longint; lp: lpoint; lInterval,lWidth,lSpace: longint; i0,i1: integer);
    procedure DrawLinesAllx(bcode: longint; lp: lpoint; lInterval,lWidth,lSpace: longint);
    //������ ���������� ������:
    //pab,pae - ��������� � �������� ����� ����� ������:
    procedure DrawLinesIndspp(pab,pae: tpa; lSpace: longint; i0,i1: integer);
    procedure DrawLinesAllpp(pab,pae: tpa; lSpace: longint);

    //����������� ��������� aDmPara (�� ������� ������):  //��� ������ �������
    //lp, lWidth - � ������ ������
    //Return: ����� �����
    function DrawParaLinesx(aDmPara: TDmPara; lp: lpoint; lWidth, lSpace,lInterval, bcode: longint): integer;

    //Step23 - DrawText (MakeLines+DrawLines):

    //�������������� ������ ���������� ������:
    //MakeLinesx+DrawLinesAllx � ��������:
    //lp - ���.������� ���� ����� ������:
    //debcode>0 => �������� ��������� ����� ������:
    //���� lInterval=0 � lHeight>0, �� lInterval ����������� �� lHeight(������ ������):
    function DrawTextFromPoint(lp: lpoint; lWidth,lHeight, lSpace,lInterval, lIndent, debcode: longint): boolean;
    //�������������� ������ � ������� � �������, � ��������(lIndent) �� ����:
    //CreateHatchList+MakeLinespp+DrawLinesAllpp:
    //debcode>0 => �������� ��������� ������� � ����� ������:
    procedure AddToPabPaeFromArea(area0: tpl; pab,pae: tpa; lInterval,lIndent,debcode: longint);
    procedure DrawTextInArea(area0: tpl; lSpace,lInterval,lIndent: longint; debcode: longint);

  end;//TDmText


{ Functions: }
//Functions on dm-File (between dm_Open & dm_Done):

function DmTxt_x(x,y: double; lcode: longint; aText: string; xalign: TxAlignment; yalign: TyAlignment; down: boolean): longint;
function DmTxt_xCentered(x,y: double; lcode: longint; aText: string; down: boolean): longint;
function DmTxt_lSpace(lcode: longint): longint;
function DmTxt_Height(lcode: longint): longint;//������ ������� "�" � ��. �����(!)
procedure DmTxt_Box(lcode: longint; txt: PChar; var a,b: lpoint);//txt: DOS(!)
function DmTxt_Height_Gauss(lcode: longint; txt: PChar; dm_open_ok: boolean): tnum;


implementation

uses
  SysUtils,Graphics,
  dmw_use, wcmn;


{ Functions: }


function AlignmentToChar(xa: TxAlignment): char;
begin
  Result:=txa_string[ord(xa)+1];
end;

function CharToAlignment(cxa: char): TxAlignment;
var k: integer;
begin
  k:=pos(cxa,txa_string);
  if k>0 then Result:=TxAlignment(k-1) else Result:=TxAlignment(0);
end;


//Functions on dm-File (between dm_Open & dm_Done):

function DmTxt_x(x,y: double; lcode: longint; aText: string; xalign: TxAlignment; yalign: TyAlignment; down: boolean): longint;
var rp: tnum2; dms: tdmstr;
begin
    dms:=tdmstr.CreateStr(lcode,aText);
    dms.CalcWidthHeight;

  rp.x:=x;//xalign=txaLeft
  rp.y:=y;//yalign=tyaDown
  if xalign=txaRight then rp.x:=x-dms.Width
  else if xalign=txaCenter then rp.x:=x-dms.Width/2;
  if yalign=tyaUp then rp.y:=y+dms.Height
  else if yalign=tyaCenter then rp.y:=y+dms.Height/2;

    dms.Points[0]:=rp;
    Result:=dms.Add(down);
    dms.Free;
end;


//������� ��������(!):
function DmTxt_xCentered(x,y: double; lcode: longint; aText: string; down: boolean): longint;
var rp: tnum2; dms: tdmstr;
begin
    dms:=tdmstr.CreateStr(lcode,aText);
    dms.CalcWidthHeight;
    rp.x := x - dms.Width/2;
    rp.y := y + dms.Height;//������� ��������
    dms.Points[0]:=rp;
    Result:=dms.Add(down);
    dms.Free;
end;


function DmTxt_lSpace(lcode: longint): longint;
var dms: tdmstr;
begin
    dms:=tdmstr.CreateStr(lcode,' ');
    dms.CalcWidthHeight;
    Result:=dms.Width;
    dms.Free;
end;

function DmTxt_Height(lcode: longint): longint;//������ ������� "�" � ��. �����(!)
const char_for_height: pChar = #128; //DOS(!)
var lp,bp: pLLine; pa: tpa;
begin
  Result:=0;
  lp:=NewDmPoly(1); //(0;0) => ��������.�����
  bp:=NewDmPoly(5); //�������������
  pa:=tpa.new;
  try
    dm_Text_Bound(lcode, char_for_height, lp,bp, 4,0); //bp: �� ���.�������(!)
    DmPolyToPa(bp,pa);
    if pa.count=5 then Result:=Round(v_dist(pa[0],pa[1]));
    //Tell('ERROR in DmTxt_Height');
  finally
    FreeDmPoly(lp);
    FreeDmPoly(bp);
    pa.free;
  end;
end;

procedure DmTxt_Box(lcode: longint; txt: PChar; var a,b: lpoint);
const char_for_height: pChar = '�';
var lp,bp: pLLine; pa: tpa;
begin
  lp:=NewDmPoly(1); //(0;0) => ��������.�����
  bp:=NewDmPoly(5); //�������������
  pa:=tpa.new;
  try
    dm_Text_Bound(lcode, txt, lp,bp, 4,0); //bp: �� ���.�������(!)
    DmPolyToPa(bp,pa);
    //if pa.count<>5 then Tell('ERROR in DmTxt_Box');
    PaToLBound(pa, a,b);
  finally
    FreeDmPoly(lp);
    FreeDmPoly(bp);
    pa.free;
  end;
end;

function DmTxt_Height_Gauss(lcode: longint; txt: PChar; dm_open_ok: boolean): tnum;
var a,b: lpoint; ga,gb: tnum2;
begin
  DmTxt_Box(lcode, txt, a,b);
  ga:=LpToNum2Gauss(a, dm_open_ok);
  gb:=LpToNum2Gauss(b, dm_open_ok);

  Result := abs(ga.x-gb.x);
end;


//===============================================================

{ TDmStr: }

constructor TDmStr.CreateStr(aLcode: longint; aStr: string);
begin
  inherited CreateCode(4, aLCode);
  Str:=aStr;
  Points.Add( v_xy(0,0) );
end;

procedure TDmStr.Clear;
begin
  inherited Clear;
  str:='';
end;

procedure TDmStr.Read;
begin
  inherited Read;
  dmlib_ReadString(9, str);
  tag:=dm_Get_Tag;
end;

procedure TDmStr.Write;
begin
  inherited Write;
  dmlib_WriteString(9, str);
end;

function TDmStr.Add(down: boolean): longint;
var lp: pLLine; zs: tchars;
begin
  Result:=0;
  if Points.Count<=0 then exit;

  if Loc<>4 then begin
    Result := inherited Add(down);
    exit;//!
  end;

  case Loc of
    4:
    begin
      lp:=NewDmPolyFromPa2(Points, FGauss, true);
      StrPCopy(zs,str);
      Result:=dm_Add_Text(lcode,loc,0,lp,zs,down);
      FreeDmPoly(lp);
      dm_Set_Tag(tag);
    end;
    else
      Tellf('ERROR in TDmStr.Add:\nLoc=%d �� ��������������',[Loc]);
  end;//case

  if (Result>0) and (dmlib_undo_list<>nil) then dmlib_undo_list.Add(Result);
end;

procedure TDmStr.CalcWidthHeight;
var a,b: lpoint; zs: tchars;
begin
  StrPCopy(zs,str);
  DmTxt_Box(lcode, zs, a,b);
  Width:=abs(b.x-a.x);
  Height:=abs(b.y-a.y);

  if Expanded then begin
    Width:=Round(Width*dmtxt_expand_k);
    tag := 4;//"� ��������"
  end;
end;


//=====================================================================

{ TDmPara: }


procedure TDmPara.SetTextCode(aCode: longint);//���� �� ��� �����
var i: tint; dms: tdmstr;
begin
  if count>0 then for i:=0 to count-1 do begin
    dms:=tdmstr(Items[i]);
    dms.lcode:=aCode;
    dms.CalcWidthHeight;//!
  end;
end;


procedure TDmPara.AddLinesx(dmtext: tdmtext; lWidth0,lSpace: longint);
var
  j,j0,j1: integer;
  width: longint;
  dmword: TDmStr;
  lWidth: longint;
begin
    //������ ��������:
    if Count=0 then begin
      dmtext.AddTextLine(Self,0,-1);
      exit;
    end;

    j:=0;//������ ����� ���������
    while (j<Count) do begin

      //������:
      j0:=j;//������ ����� ������
      width:=0;
      //"������� ������":
      if FirstIndent>=0 then begin
        if j=0 then lWidth:=lWidth0-FirstIndent
        else lWidth:=lWidth0;
      end else begin
        if j=0 then lWidth:=lWidth0
        else lWidth:=lWidth0+FirstIndent;
      end;

      while (j<Count) do begin
        TObject(dmword):=Items[j];
        inc(width,dmword.Width);//������� ������
        if (width>lWidth) then break;
        if not dmword.NoSpace2 then inc(width,lSpace);//������� ������
        inc(j);//� ����. �����
      end;//������
      j1:=j-1;//���������� ����� ��� � ������
      if j1<j0 then begin
        j1:=j;//������ ���� �� ���� �����(!)
        inc(j);//� ����. �����
      end;
      dmtext.AddTextLine(Self,j0,j1);

    end;//while j
end;

procedure TDmPara.AddLinespp(dmtext: tdmtext; pab,pae: tpa; var ibe: longint; lSpace: longint);
var
  j,j0,j1: integer;
  width: longint;
  dmword: TDmStr;
  lWidth: longint;
begin
    //������ ��������:
    if Count=0 then begin
      dmtext.AddTextLine(Self,0,-1);
      inc(ibe);//� ����-�� �������
      exit;
    end;

    j:=0;//������ ����� ���������
    while (j<Count) and (ibe<pab.count) do begin

      //������:
      j0:=j;//������ ����� ������
      width:=0;

      lWidth:=Round( v_dist(pab[ibe],pae[ibe]) );//������ ������� ������
      inc(ibe);//� ����-�� �������

      //"������� ������":
      if FirstIndent>=0 then begin
        if j=0 then lWidth:=lWidth-FirstIndent;
      end else begin
        if j>0 then lWidth:=lWidth+FirstIndent;
      end;

      while (j<Count) do begin
        TObject(dmword):=Items[j];
        inc(width,dmword.Width);//������� ������
        if (width>lWidth) then break;
        if not dmword.NoSpace2 then inc(width,lSpace);//������� ������
        inc(j);//� ����. �����
      end;//������

      j1:=j-1;//���������� ����� ��� � ������
(*
      if j1<j0 then begin
        j1:=j;//������ ���� �� ���� �����(!)
        inc(j);//� ����. �����
      end;
*)
      dmtext.AddTextLine(Self,j0,j1);

    end;//while j
end;


//=====================================================================

{ TDmTextLine: }


constructor TDmTextLine.Create(aPara: TDmPara; aIndFirst,aIndLast: Integer);
begin
  inherited Create;
  Para:=aPara;
  IndFirst:=aIndFirst;
  IndLast:=aIndLast;
end;


//private:
procedure TDmTextLine.Draw0(p1,p2: tnum2; lSpace: longint; down0: boolean);
var
  width0,width,dwidth: double;
  i,sp_count: integer; dmword: tdmstr; v0: tnum2; x: tnum;
  ofs0: integer; down: boolean;
begin
  if IndLast<IndFirst then exit; //=>IndLast>=IndFirst �����

  x:=0;//������� ��������� � ������
  width0:=v_dist(p1,p2);
  try
    v0:=v_sub(p2,p1); v0:=v_mul(v0,1/width0);//��������� ������
  except
    v0:=v_xy(1,0);
  end;

  //��������� ������ (� ����������� ���������):
  width:=0;
  sp_count:=0;//���-�� ����������(!) ��������
  for i:=IndFirst to IndLast do begin
    TObject(dmword):=Para[i];
    width:=width+dmword.Width;
    if (i<IndLast) and not dmword.NoSpace2 then begin
      width:=width+lSpace;
      inc(sp_count);
    end;
  end;

  //������� ������ ���������:
  if Para.FirstIndent>=0 then begin
    if (IndFirst=0) then begin
      x:=x+Para.FirstIndent;
      Width0:=Width0-Para.FirstIndent;
    end;
  end else begin
    if (IndFirst>0) then begin
      x:=x-Para.FirstIndent;
      Width0:=Width0+Para.FirstIndent;
    end;
  end;

  //������������:
  dwidth:=0;//���������� �����������
  if Para.Alignment=txaDouble  then begin

    if sp_count>0 then dwidth:= (Width0-width)/sp_count; // >1 �����
//    if (IndLast=Para.Count-1) and (IndFirst>0) then dwidth:=0;//��������� ������ ���������
    if (IndLast=Para.Count-1) then dwidth:=0;//��������� ������ ���������

  end else begin

    if Para.Alignment=txaCenter then x:=x+(Width0-width)/2;
    if Para.Alignment=txaRight then x:=x+(Width0-width);

  end;

  ofs0:=dm_object;//save
  for i:=IndFirst to IndLast do begin
    if i=IndFirst then down:=down0 else down:=false;
    TObject(dmword):=Para[i];
    dmword.Points[0]:=v_add( p1, v_mul(v0, x) );
    dmword.Points[1]:=v_add( p1, v_mul(v0, x+dmword.width) );
    dmword.Add(down);//DRAW!
    x := x + dmword.width;
    if not dmword.NoSpace2 then x := x + lSpace+dwidth;
  end;//for i
  if down0 then dm_goto_node(ofs0);//restore
end;

procedure TDmTextLine.Drawx(lp: lpoint; lWidth,lSpace: longint; down: boolean);
var p1,p2: tnum2;
begin
  p1 := LpToNum2( lp );
  p2 := v_add( p1, v_xy(lWidth,0) );
  Draw0(p1,p2, lSpace, down);
end;

procedure TDmTextLine.Drawpp(p1,p2: tnum2; lSpace: longint; down: boolean);
begin
  Draw0(p1,p2, lSpace, down);
end;

//=====================================================================

{ TDmText: }


constructor TDmText.New;
begin
  inherited New;
  Lines:=TClassList.New;
end;

constructor TDmText.Create;
begin
  New;
end;

destructor TDmText.Destroy;
begin
  Lines.Free;
  inherited Destroy;
end;

procedure TDmText.Clear;
begin
  inherited Clear;
  Lines.Clear;
end;

function TDmText.IsEmpty: boolean;//��� ����
var i: integer;
begin
  Result:=true;
  if Count>0 then for i:=0 to Count-1 do begin
    if TDmPara(Items[i]).Count<>0 then begin Result:=false; break; end;
  end;
end;


function TDmText.DrawParaLinesx(aDmPara: TDmPara; lp: lpoint; lWidth, lSpace,lInterval, bcode: longint): integer;
var i,i0: integer; tline: TDmTextLine;
begin
  Result:=0;
  if aDmPara=nil then exit;

  i0:=0;
  if Lines.Count>0 then for i:=0 to Lines.Count-1 do begin
    tline:=TDmTextLine(Lines[i]);
    if tline.Para<>aDmPara then continue;
    inc(Result);
    if Result=1 then i0:=i;//������ ������
  end;

  if Result>0 then DrawLinesIndsx(bcode, lp, lInterval,lWidth,lSpace, i0,i0+Result-1);
end;



procedure TDmText.DrawLinesIndsx(bcode: longint; lp: lpoint; lInterval,lWidth,lSpace: longint; i0,i1: integer);
var
  i: integer; a,b: tnum2; dmo: tdmobj;
  ofs: longint; lp0: lpoint;
begin
  ofs:=dm_Object;//save
  lp0:=lp;

  //�����:
  if (Lines.Count>i1) and (i1>=i0) then for i:=i0 to i1 do begin
    inc(lp.y,lInterval);
    TDmTextLine(Lines[i]).Drawx(lp, lWidth,lSpace, ChildText);
  end;

  dm_GoTo_Node(ofs);//restore (������� ��������������)

  //Bound area:
  if bcode>0 then begin
    a:=LpToNum2(lp0);//LU
    b.x:=a.x+lWidth;
    b.y:=a.y+lInterval*(i1-i0+1);
    dmo:=tdmobj.CreateCode(2,bcode);
    dmo.points.AddRect(a.x,a.y,b.x,b.y);
    dmo.add(ChildText);
    dmo.free;
  end;

  dm_GoTo_Node(ofs);//restore (������� ��������������)
end;

procedure TDmText.DrawLinesAllx(bcode: longint; lp: lpoint; lInterval,lWidth,lSpace: longint);
begin
  if Lines.Count>0 then
    DrawLinesIndsx(bcode, lp, lInterval,lWidth,lSpace, 0,Lines.Count-1);
end;

procedure TDmText.DrawLinesIndspp(pab,pae: tpa; lSpace: longint; i0,i1: integer);
var i: integer;
begin
  if (Lines.Count>i1) and (i1>=i0) then for i:=i0 to i1 do begin
    if i>=pab.count then break;//������� ���������!
    TDmTextLine(Lines[i]).Drawpp(pab[i],pae[i], lSpace, ChildText);
  end;
end;

procedure TDmText.DrawLinesAllpp(pab,pae: tpa; lSpace: longint);
begin
  if Lines.Count>0 then
    DrawLinesIndspp(pab,pae, lSpace, 0,Lines.Count-1);
end;

procedure TDmText.AddTextLine(dmpara: TDmPara; k0,k1: integer); //USE: Result, dmpara
var textline: TDmTextLine;
begin
  textline:=TDmTextLine.Create(dmpara,k0,k1);
  Lines.Add(textline);
end;

procedure TDmText.MakeLinesx(lWidth0,lSpace: longint);
var i: integer; dmpara: TDmPara;
begin
  Lines.Clear;//!
  if Count>0 then for i:=0 to Count-1 do begin
    TObject(dmpara):=Items[i];
    dmpara.AddLinesx(Self, lWidth0,lSpace);
  end;//for i
end;

//������ ���������� ������:
procedure TDmText.MakeLinespp(pab,pae: tpa; lSpace: longint);
var i,j: integer; dmpara: TDmPara;
begin
  Lines.Clear;//!
  j:=0;//������ ������� pab-pae
  if Count>0 then for i:=0 to Count-1 do begin
    TObject(dmpara):=Items[i];
    dmpara.AddLinespp(Self, pab,pae,j, lSpace);//j - �� ����-�� �����(!)
    if j>=pab.count then break;//��������� �����
  end;//for i
end;



function TDmText.DrawTextFromPoint(lp: lpoint; lWidth,lHeight, lSpace,lInterval, lIndent, debcode: longint): boolean;
var lWidth2,lHeight2: longint;
begin
  Result:=false;

  //������:
  lp.x := lp.x + lIndent;
  lp.y := lp.y + lIndent;
  lWidth2 := lWidth - 2*lIndent;
  lHeight2 := lHeight - 2*lIndent;
  if (lWidth2<=0) or (lHeight2<=0) then begin
    Tellf('������� �������������� %dX%d � ������ %d ������������',[lWidth,lHeight,lIndent]);
    exit;
  end;

  //������:
  MakeLinesx(lWidth2,lSpace);
  if Lines.Count=0 then exit;

  //��������:
  if (lInterval=0) and (lHeight2>0) then
    lInterval := Round( lHeight2/Lines.Count );

  //�����:
  DrawLinesAllx(debcode, lp, lInterval,lWidth2,lSpace);

  Result:=true;
end;



procedure TDmText.AddToPabPaeFromArea(area0: tpl; pab,pae: tpa; lInterval,lIndent,debcode: longint);
var
  down: boolean;
  dmo: tdmo;
  i,i0,j,ofs0: integer;
  area: tpl;//����� �� area0
  p0,dp: tnum2; pa: tpa;
  HatchList: TClassList;//list of tpa, [i] - 2-PATH(!)
begin
  ofs0:=dm_object;//save

  area:=tpl.new;//��������� ������� ������ <-- area0
  try
    area0.LeftLine(area, -lIndent);//������ ������

    //��� ���������:
    dp := v_xy( 0, lInterval );
    //��������� ����� ���������:
    i0 := area.iofp_tmax( v_xy(0,0), v_xy(0,-100) );
    p0 := area[i0];

    //���������: area --> pab,pae
//    HatchList:=area.CreateHatchList(p0,dp, false, 1.5, i0);
    HatchList:=area.CreateHatchList(p0,dp, DmTxt_RightAreaFromBound, 1.5, i0);
    try
      if HatchList.count>0 then for i:=0 to HatchList.count-1 do begin
        tobject(pa):=HatchList[i];
        if pa.count>1 then for j:=0 to (pa.count div 2)-1 do begin
          pab.add(pa[j*2]);
          pae.add(pa[j*2+1]);
        end;
      end;//for i
    finally
      HatchList.free;
    end;

    //������� � ������� �����:
    if debcode>0 then begin
      dmo:=tdmobj.CreateCode(2,debcode);
      try
        if pab.count>0 then for i:=0 to pab.count-1 do begin
          dmo.Points[0]:=pab[i];
          dmo.Points[1]:=pae[i];
          down:=false;
          if ChildText then down:=i=0;
          dmo.add(down);//������ dmo_area
        end;//for i
        //������� ������:
        dm_goto_node(ofs0);//restore
        dmo.Points.Clear;
        dmo.LCode:=debcode;
        dmo.Points:=area;//������ � �������!
        dmo.add(ChildText);
        dmo.Points:=nil;//����� dmo.free!
      finally
        dmo.free;
      end;
    end;//debcode>0

  finally
    area.free;
    dm_goto_node(ofs0);//restore
  end;
end;

procedure TDmText.DrawTextInArea(area0: tpl; lSpace,lInterval,lIndent: longint; debcode: longint);
var
  pab,pae: tpa;//pab[i]-pae[i] - ������� ������
  ofs0: integer;
begin
  ofs0:=dm_object;//save
  pab:=tpa.New;
  pae:=tpa.New;
  try
    AddToPabPaeFromArea(area0, pab,pae, lInterval,lIndent,debcode);
    MakeLinespp(pab,pae,lSpace);
    DrawLinesAllpp(pab,pae,lSpace);
  finally
    pab.free;
    pae.free;
    dm_goto_node(ofs0);//restore
  end;
end;


procedure TDmText.SetAlignment(Alignment: TxAlignment);//���� �� ��� ���-��
var i: tint;
begin
  if count>0 then for i:=0 to count-1 do
    tdmpara(Items[i]).Alignment:=Alignment;
end;

procedure TDmText.SetFirstIndent(FirstIndent: longint);//���� �� ��� ���-��
var i: tint;
begin
  if count>0 then for i:=0 to count-1 do
    tdmpara(Items[i]).FirstIndent:=FirstIndent;
end;

procedure TDmText.SetTextCode(aCode: longint);//���� �� ��� ���-��
var i: tint;
begin
  if count>0 then for i:=0 to count-1 do
    tdmpara(Items[i]).SetTextCode(aCode);
end;


procedure TDmText.AddParaFromStr(Str: string; code: longint);//1 ��������
var
  sn: integer;
  sword: string;
  dmpara: TDmPara;
  dmword: tdmstr;
begin
//  Clear;
  dmpara:=TDmPara.New;
  Add(dmpara);

  //����� ���������:
  sn:=1;
  while true do begin
    sword:=sgetword(str, sn);
    if Length(sword)=0 then break;
    dmword:=tdmstr.CreateStr(code,sword);
    dmword.CalcWidthHeight;
    dmpara.add(dmword);
  end;//while
end;

procedure TDmText.LoadFromStr(Str: string; code: longint);//1 ��������
begin
  Clear;
  AddParaFromStr(Str, code);
end;

procedure TDmText.LoadFromStrings(Strings: tstrings; i0,i1: integer; code: longint);
var i: integer;
begin
  Clear;
  if (i1>=i0) and (i1<Strings.Count) then for i:=i0 to i1 do
    AddParaFromStr(Strings[i],code);
end;

procedure TDmText.LoadFromRichEdit(RE: TRichEdit; PixelsPerInch: Integer; lpmm: double; t_data: tt_data);
const delims='-';//����������� � NoSpace2=true
var
  i,sn,parastart,wordfinish: integer;
  spara,sword: string;
  dmpara: TDmPara;
  dmword: tdmstr;
  oldwordwrap: boolean;
//  xx,yy: integer;//DEBUG
begin
  Clear;
  with t_data do begin
    if code_tb<=0 then code_tb:=code_t;
    if code_ti<=0 then code_ti:=code_t;
    if code_tu<=0 then code_tu:=code_t;
  end;
  oldwordwrap:=RE.WordWrap;//save
  RE.WordWrap:=false;

  parastart:=0;
  if RE.Lines.Count>0 then for i:=0 to RE.Lines.Count-1 do begin

    //��������:
    dmpara:=TDmPara.New;
    Add(dmpara);
    spara := RE.Lines[i];

    //��������� ���������:
    RE.SelStart:=parastart;
    dmpara.Alignment := TxAlignment( RE.Paragraph.Alignment );
    if t_data.Justify then dmpara.Alignment := txaDouble;//��������� �� ���� �����

    if PixelsPerInch>0 then begin
      dmpara.FirstIndent := Round( lpmm*25.4*(RE.Paragraph.FirstIndent/PixelsPerInch) );
//      xx:=RE.Paragraph.LeftIndent;
//      yy:=RE.Paragraph.RightIndent;
    end;

    //����� ���������:
    sn:=1;
    while true do begin

      //sword:=sgetword(spara, sn);
      sword:=sgetword2(spara, sn, delims);
      if Length(sword)=0 then break;

      //����������� ����:
      wordfinish:=parastart+(sn-1)-1;//��������� ������ ��������� �����
      RE.SelStart:=wordfinish;
      dmword:=tdmstr.CreateStr(t_data.code_t,sword);
      //Bold,Italic,Underline:
      if fsBold in RE.SelAttributes.Style then dmword.lcode:=t_data.code_tb;
      if fsItalic in RE.SelAttributes.Style then dmword.lcode:=t_data.code_ti;
      if fsUnderline in RE.SelAttributes.Style then dmword.lcode:=t_data.code_tu;

      {$IFDEF ExpandOnUnderline}//Expanded:
      if fsUnderline in RE.SelAttributes.Style then dmword.Expanded:=true;
      {$ENDIF}

      //NoSpace2 (����� � �����):
      if pos( dmword.Str[Length(dmword.Str)], delims )>0 then dmword.NoSpace2:=true;
      dmword.CalcWidthHeight;
      dmpara.add(dmword);

    end;//while

    inc(parastart, Length(spara)+2); //...#$D#DA
  end;//for i

  RE.WordWrap:=oldwordwrap;//restore
end;

procedure TDmText.LoadFromRichEdit_Grunt(RE: TRichEdit; PixelsPerInch: Integer; lpmm: double; acode_t,acode_tb,acode_ti: longint; aJustify: boolean);//Clear(!)
var t_data: tt_data;
begin
  t_data.code_t:=acode_t;
  t_data.code_tb:=acode_tb;
  t_data.code_ti:=acode_ti;
  t_data.Justify:=aJustify;
  LoadFromRichEdit(RE, PixelsPerInch, lpmm, t_data);
end;


end.
