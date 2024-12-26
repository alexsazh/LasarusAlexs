unit dmtabs; interface

uses
  Classes,
  Otypes,
  nums, list, dmtxt;


const
  TxtRectCode=1; //DEBUG


type
  //внешние,внутренние линии столбцов (0-ext,1-int):
  ttablinescodes = array[0..1]of longint;
  //отступ (0-L, 1-R, 2-U, 3-D):
  ttabindent = array[0..3]of longint;


type
  TColumn = class(tdmtext)
  protected
  public
    //параметры столбца устанавливаютс€ извне (tab.exe - в HarForm.Execute):
    textcode: longint;
    Alignment: TxAlignment;
    lColWidth: longint;
  end;


  //таблица - набор столбцов(TDmText)
  //€чейки - параграфы
  TDmTab = class(tclasslist)//of TDmText
  protected
    function GetColumn(i: tint): TColumn;
  public
    indent: ttabindent;
    function GetTabWidth: longint;//сумма столбцов
    function GetDefColWidth(alWidth: longint): longint;

    //Step1 - загрузка:

    //строка Strings = €чейка:
    procedure LoadByRows(Strings: tstrings; ColCount, code: tint);
    //строка Strings = строка таблицы (символ-разделитель):
    procedure LoadByRows2(Strings: tstrings; code: tint; delimeter: char);
    function LoadFromTxtFile(FileName: string; code: tint; delimeter: char): boolean;
    function LoadFromFile(FileName: string; code: tint): boolean;//dbf, doc

    //Step2 - отображение (параметры столбцов должны быть заполнены!):

    //по столбцам (без синхронизации):
    //lcode: линии (пр€моуг-ки столбцов)
    //слова и линии будут дочерними к текущей(!) области
    procedure DrawFromPoint(lp: lpoint; {lWidth,}lHeight,lIndent,lcode: longint);

    //по €чейкам (с синхронизацией высоты €чеек):
    //lInterval вместо lHeight (!)
    //Return: кол-во строк в таблице
    function DrawFromPoint2(lp: lpoint; lInterval: longint; lIndent: ttabindent; lcode: ttablinescodes; var lHeight: longint): integer;

    property Column[i: tint]: TColumn read GetColumn; default;
  end;


implementation

uses
  SysUtils,
  dmw_use,
  wcmn, arrayx, dmlib, tablib,{ dbf,} vlib,
  word;


{ TDmTab: }

function TDmTab.GetTabWidth: longint;//сумма столбцов
var i: integer;
begin
  Result:=0;
  if Count>0 then for i:=0 to Count-1 do Result:=Result+Column[i].lColWidth;
end;

function TDmTab.GetDefColWidth(alWidth: longint): longint;//lTabWidth/Count
begin
  if Count>0 then Result:=Round(alWidth/Count) else Result:=0;
end;


function TDmTab.GetColumn(i: tint): TColumn;
begin
  tobject(Result):=Items[i];
end;


procedure TDmTab.LoadByRows(Strings: tstrings; ColCount, code: tint);
var i,j: tint; dmtxt: tcolumn;
begin
  Clear;

  //пустые столбцы:
  if ColCount>0 then for i:=0 to ColCount-1 do  begin
    dmtxt:=tcolumn.new;
    Add(dmtxt);
    dmtxt.textcode:=code;
  end;

  //€чейки - элементы Strings:
  if Strings.Count>0 then for i:=0 to Strings.Count-1 do begin
    j := i mod ColCount;
    Column[j].AddParaFromStr(Strings[i],code);
  end;
end;

procedure TDmTab.LoadByRows2(Strings: tstrings; code: tint; delimeter: char);
var i,col_i,k: integer; s,cell: string; dmtxt: tcolumn;
begin
  Clear;

  if Strings.Count>0 then for i:=0 to Strings.Count-1 do begin

    //строка таблицы:
    s:=Strings[i];
    col_i:=0;
    while true do begin
      k:=pos(delimeter,s);
      if k>0 then cell:=copy(s,1,k-1) else cell:=s;
      //новый столбец:
      if col_i>Count-1 then begin
        dmtxt:=tcolumn.new;
        Add(dmtxt);
        dmtxt.textcode:=code;
      end;
      Column[col_i].AddParaFromStr(cell,code);
      if (k=0) or (k=Length(s)) then break;
      s:=copy(s, k+1, Length(s)-k);
      inc(col_i);
    end;//while true

  end;//for i
end;

function TDmTab.LoadFromTxtFile(FileName: string; code: tint; delimeter: char): boolean;
var slist: tstringlist;
begin
  Result:=false;
  Clear;

  slist:=tstringlist.Create;
  try
    if FileExists(FileName) then begin
      slist.LoadFromFile(FileName);
      LoadByRows2(slist, code, delimeter);
      Result:=true;
    end;
  finally
    slist.free;
  end;
end;


function TDmTab.LoadFromFile(FileName: string; code{0}: tint): boolean;
var
  _colcount,_rowcount,ir,ic: integer; _ext,s: string; slist: tstringlist;
  Tab: TTab;
  WT: variant{Word-Table};
begin
  Result:=false;
  _colcount:=0;
  Clear;

  _ext := UpperCase( ExtractFileExt(FileName) );//с точкой!

  slist:=tstringlist.create;
  try

    //DBF:
    if _ext='.DBF' then begin
      Tab:=TTab.Create;//tablib.pas
      try
        if Tab.Open(FileName) then try
          Tab.WriteToStrings(slist);
          _colcount:=Tab.ColCount;//!
        finally
          Tab.Close;
        end;
      finally
        Tab.Free;
      end;
    end;//_ext='.DBF'

    //DOC:
    if _ext='.DOC' then begin
      if word_begin(false{_visible}) then
      try
        //if word_doc_open(FileName, true{aReadOnly}) then
        if word_doc_open(FileName, FALSE{aReadOnly}) then
        try
          if WordApp.ActiveDocument.Tables.Count>=1 then begin
            WT:=WordApp.ActiveDocument.Tables.Item(1);
            _colcount:=WT.Columns.Count;
            _rowcount:=WT.Rows.Count;

            //WT -> slist (по строкам):
            if _rowcount>0 then for ir:=1 to _rowcount do begin
              if _colcount>0 then for ic:=1 to _colcount do begin
                s:=WT.Cell(ir,ic).Range.Text;//почему-то s = '...'#$D#7
                if Length(s)>=2 then SetLength(s, Length(s)-2);//!
                slist.Add(s);
              end;//for ic
            end;//for ir

          end else begin
            Tellf('¬ документе "%s" нет таблиц',[FileName]);
          end;
        finally
          word_doc_close;//!
        end;
      finally
        word_end;
      end;
    end;//_ext='.DOC'

    if _colcount>0 then begin
      LoadByRows(slist, _colcount, code);//!
      Result:=true;
    end;

  finally
    slist.free;
  end;
end;


procedure TDmTab.DrawFromPoint(lp: lpoint; {lWidth,}lHeight,lIndent,lcode: longint);
var
  i: integer;
  lSpace: longint;
  col_p: lpoint;
  dmo: tdmo;
  ofs0: longint;
  col: TColumn;
begin
  if Count=0 then exit;//!
  ofs0:=dm_object;//save

  //отображение:
  col_p:=lp;
  for i:=0 to Count-1 do begin

    //столбец:
    col:=Column[i];
    lSpace:=DmTxt_lSpace(col.TextCode);
    col.ChildText:=true;//!
    col.SetTextCode(col.TextCode);
    col.SetAlignment(col.Alignment);
    if not col.DrawTextFromPoint(col_p, col.lColWidth, lHeight, lSpace, 0{lInterval}, lIndent, TxtRectCode)
      then break;

    //пр€моугольник (после текста!):
    if lcode>0 then begin
      dmo:=tdmo.createcode(2,lcode);
      dmo.points.AddRect(col_p.x, col_p.y, col_p.x+col.lColWidth, col_p.y+lHeight);
      dmo.add(true);
      dmo.free;
    end;
    dm_goto_node(ofs0);//restore

    col_p.x := col_p.x + col.lColWidth;//к след-му столбцу

  end;//for i
end;


function TDmTab.DrawFromPoint2(lp: lpoint; lInterval: longint; lIndent: ttabindent;
              lcode: ttablinescodes; var lHeight: longint): integer;
var
  ix,iy: integer;
  lSpace: array of longint;//вычисл€етс€
  col: TColumn;//столбец
  cell: TDmPara;//€чейка;
  MaxParaCount: integer;//вычисл€етс€
  linescount,maxlinescount: integer;//в строке таблицы
  cell_p,p: lpoint;//лев.верх €чейки
begin
  Result:=0;
  if Count=0 then exit;//!

  //столбцы: разбиение на строки,
  //установка параметров параграфов,
  //вычисление ParaCount, lSpace[]:
  MaxParaCount:=0;
  SetLength(lSpace,Count);
  for ix:=0 to Count-1 do begin
    col:=Column[ix];
    if col.Count>MaxParaCount then MaxParaCount:=col.Count;
    col.ChildText:=true;//!
    col.SetTextCode(col.TextCode);
    col.SetAlignment(col.Alignment);
    lSpace[ix]:=DmTxt_lSpace(Column[ix].TextCode);
    col.MakeLinesx(col.lColWidth-lIndent[0]-lIndent[1],lSpace[ix]);//!
  end;

  if MaxParaCount=0 then exit;//!

  //отображение по строкам:
  //по €чейкам (параграфам) [ix,iy]=Column[ix][iy]:
  cell_p:=lp;
  inc(cell_p.y,lIndent[2]);
  for iy:=0 to MaxParaCount-1 do begin

    //строка таблицы:
    cell_p.x:=lp.x;
    maxlinescount:=0;
    for ix:=0 to Count-1 do begin
      col:=Column[ix];
      cell:=TDmPara(col[iy]);

      p:=cell_p;
      inc(p.x,lIndent[0]);
      linescount:=col.DrawParaLinesx(cell, p, col.lColWidth-lIndent[0]-lIndent[1], lSpace[ix], lInterval, TxtRectCode);
      if linescount>maxlinescount then maxlinescount:=linescount;

      inc(cell_p.x,col.lColWidth);//к след-ей €чейке
    end;//for ix

    inc(Result,maxlinescount);
    inc(cell_p.y,maxlinescount*lInterval);//к след-ей строке таблицы

  end;//for iy

  lHeight:=Result*lInterval+lIndent[2]+lIndent[3];

  //линии внешние:
  p:=lp;
  DmDrawVector(lcode[0], p.x,p.y,p.x,p.y+lHeight, true,true);
  inc(p.x,GetTabWidth);
  DmDrawVector(lcode[0], p.x,p.y,p.x,p.y+lHeight, true,true);
  //линии внутренние:
  p:=lp;
  for ix:=0 to Count-1 do begin
    col:=Column[ix];
    if ix>0 then
      DmDrawVector(lcode[1], p.x,p.y,p.x,p.y+lHeight, true,true);
    inc(p.x,col.lColWidth);//к след-му столбцу
  end;//for ix
end;


end.
