(*
  TDiagra - моя диаграмма (вместо TChart(chart), TSeries(series))
  Существует на TPaintBox(ExtCtrls)
  TDiagra - одинарные или двойные горизонтальные столбики
  TDiagra состоит из FTitle(tclasslist of TCanvaxStr) и FValues(tclasslist of TDiagraValue)
  TDiagra перебивает события TPaintBox:
    OnPaint
    OnMouseMove
    OnMouseDown
*)
unit diagra; interface

uses
  ExtCtrls{TPaintBox}, Classes{TWndMethod},
  Messages{TMessage}, Types{TRect}, Graphics, Controls{cm_MouseLeave},
  nums, list, canvax, canvaxt, wlib;


type
  TDiagra = class;

  TDiagraValue = class//элемент списка FValues in TDiagra
  private
  protected
    FDiagra: TDiagra;//Create
    FValue: double;
    FCaption: TCanvaxStr;//название
    FMarkStr: TCanvaxStr;//tobject<-aValue(Create)
    FColor: TColor;//цвет прямоуг-ка
    FData: pointer;//соответствующий значению объект (ex. TValMat)
    //FWorld: TWorldi;//maxrect
    //procedure SetWorld(aWorld: TWorldi);
  public
    constructor Create(aDiagra: TDiagra; aValue: double; aCaption: string; aColor: TColor; aData: Pointer=nil);
    destructor Destroy; override;

    //property World: TWorldi read FWorld;
    property Caption: TCanvaxStr read FCaption;
    property MarkStr: TCanvaxStr read FMarkStr;
    property Data: pointer read FData;
  end;

  TDiagra = class
  private
    FRect_Captions: TRect;//названия значений (_Get_Rects_And_Values_ya)
    FRect_Values: TRect;//прямоуг-ки и маркеры (_Get_Rects_And_Values_ya)
    FValues_ya: tinta;//средние линии значений FValues (_Get_Rects_And_Values_ya)
    function _GetValuesCaptionsMaxWidth: integer;
    procedure _Get_Rects_And_Values_ya(maxrect: TRect);//=>FRect_Captions,FRect_Values,FValues_ya
  protected
    FPaintBox: TPaintBox;//подложка диаграммы (Create)
    FCanvax: TCanvax;//Create
    FFont: TFont;//default Font для строковых элементов
    FWindowProcOld: TWndMethod;//исходная процедура обработки сообщений окна FPaintBox
    FTitle: tclasslist;//of TCanvaxStr (добавление - AddTitleString)
    FValues: tclasslist;//of TDiagraValue (добавление - AddValue)
    FValues2: tclasslist;//of TDiagraValue (добавление - AddValue2) - вторые значения(!)
    function GetPaintBoxRect: TRect;//полный прямоуг-к объекта FPaintBox
    function GetValue(i: integer): TDiagraValue;
    function GetValue2(i: integer): TDiagraValue;
    function GetTitleStr(i: integer): TCanvaxStr;
    function GetValueCaption(i: integer): TCanvaxStr;
    function GetValueMarkStr(i: integer): TCanvaxStr;
    function GetValueIndByXY(X, Y: Integer): integer;//uses FRect_Captions,FValues_ya
    //Paints:
    function PaintTitle(maxrect: TRect): integer;//Result=Height, maxrect=PaintBoxRect
    //PaintValues:
    procedure _PaintValuesCaptions(sel_ind: integer);//uses FRect_Captions,FValues_ya
    procedure __PaintValueRectAndMarker(aVal: TDiagraValue; aValRect: TRect);
    procedure _PaintValuesRects;//uses FRect_Values,FValues_ya
    procedure PaintValues(maxrect: TRect);//maxrect - PaintBoxRect без Title's Rect
    //Events:
    procedure WindowProc(var Message: TMessage);
    procedure OnPaint(Sender: TObject); virtual;//OnPaint Event => PaintTitle, PaintValues
    procedure OnMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer); virtual;
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
  public
    constructor Create(aPaintBox: TPaintBox; aFont: TFont);//TFont on aPaintBox может измениться ко 2-му Create
    destructor Destroy; override;
    procedure Clear;
    procedure Paint; virtual;//=>OnPaint

    procedure AddTitleString(s: string);
    function AddValue(aValue: double; aCaption: string; aColor: TColor; aData: Pointer=nil): TDiagraValue;
    function AddValue2(aValue: double; aCaption: string; aColor: TColor; aData: Pointer=nil): TDiagraValue;

    property TitleStr[i: integer]: TCanvaxStr read GetTitleStr;
    property Value[i: integer]: TDiagraValue read GetValue; default;
    property Value2[i: integer]: TDiagraValue read GetValue2;
    property ValueCaption[i: integer]: TCanvaxStr read GetValueCaption;
    property ValueMarkStr[i: integer]: TCanvaxStr read GetValueMarkStr;
  end;


implementation

uses
  SysUtils{Abort}, Math,
  vlib, color;


{ TDiagraValue: }

constructor TDiagraValue.Create(aDiagra: TDiagra; aValue: double; aCaption: string; aColor: TColor; aData: Pointer=nil);
var sMark: string;
begin
  inherited Create;
  FDiagra:=aDiagra;
  FValue:=aValue;
  FColor:=aColor;//цвет прямоуг-ка
  FData:=aData;

  FCaption:=TCanvaxStr.Create(aCaption, FDiagra.FCanvax, ttax_Right, ttay_Center);
  FCaption.Font.Assign(FDiagra.FFont);//default

  //sMark:
  if Int(FValue)=FValue then sMark:=Format('%d',[Round(FValue)])
  else sMark:=Format('%.2f',[FValue]);
  FMarkStr:=TCanvaxStr.Create(sMark, FDiagra.FCanvax, ttax_Left, ttay_Center);
  FMarkStr.Font.Assign(FDiagra.FFont);//default

  //FWorld:=TWorldi.Create(Point(0,0), 100,100);//default
end;

destructor TDiagraValue.Destroy;
begin
  //FWorld.Free;
  FMarkStr.Free;
  FCaption.Free;
  inherited;
end;
(*
procedure TDiagraValue.SetWorld(aWorld: TWorldi);
begin
  FWorld.Free;
  FWorld:=aWorld;
end;
*)

{ TDiagra: }

constructor TDiagra.Create(aPaintBox: TPaintBox; aFont: TFont);
begin
  inherited Create;

  //FPaintBox УЖЕ СОЗДАН:
  FPaintBox:=aPaintBox;
  //Events:
  FWindowProcOld:=FPaintBox.WindowProc;//OLD
  FPaintBox.WindowProc:=WindowProc;//NEW
  FPaintBox.OnPaint:=OnPaint;
  FPaintBox.OnMouseMove:=OnMouseMove;
  FPaintBox.OnMouseDown:=OnMouseDown;

  FCanvax:=TCanvax.Create(FPaintBox.Canvas);
  FTitle:=tclasslist.New;
  FValues:=tclasslist.New;
  FValues2:=tclasslist.New;
  FValues_ya:=tinta.New;

  FFont:=TFont.Create;
  if Assigned(aFont) then FFont.Assign(aFont) else FFont.Assign(FPaintBox.Canvas.Font);
end;

destructor TDiagra.Destroy;
begin
  FFont.Free;

  FValues_ya.Free;
  FValues2.Free;
  FValues.Free;
  FTitle.Free;
  FCanvax.Free;

  //FPaintBox ЕЩЁ НЕ РАЗРУШЕН - Events:
  FPaintBox.OnMouseDown:=nil;
  FPaintBox.OnMouseMove:=nil;
  FPaintBox.OnPaint:=nil;
  FPaintBox.WindowProc:=FWindowProcOld;

  inherited;
end;

procedure TDiagra.Clear;
begin
  FValues_ya.Clear;
  FValues.Clear;
  FValues2.Clear;
  FTitle.Clear;
end;

function TDiagra.GetPaintBoxRect: TRect;
begin
  Result := Bounds( 0,0, FPaintBox.Width, FPaintBox.Height );
end;

function TDiagra.GetValue(i: integer): TDiagraValue;
begin
  tobject(Result):=FValues[i];
end;
function TDiagra.GetTitleStr(i: integer): TCanvaxStr;
begin
  tobject(Result):=FTitle[i];
end;
function TDiagra.GetValueCaption(i: integer): TCanvaxStr;
begin
  Result:=Value[i].Caption;
end;
function TDiagra.GetValueMarkStr(i: integer): TCanvaxStr;
begin
  Result:=Value[i].MarkStr;
end;

function TDiagra.GetValue2(i: integer): TDiagraValue;
begin
  tobject(Result):=FValues2[i];
end;

function TDiagra._GetValuesCaptionsMaxWidth: integer;
var i,w: integer; val: TDiagraValue;
begin
  Result:=0;
  if FValues.Count>0 then for i:=0 to FValues.Count-1 do begin
    tobject(val):=FValues[i];
    w:=val.FCaption.GetStrWidth;
    if w>Result then Result:=w;
  end;//for i
end;

procedure TDiagra._Get_Rects_And_Values_ya(maxrect: TRect);
var i,y,dy: integer;
begin
  FRect_Captions:=maxrect;//default
  FRect_Captions.Right := maxrect.Left + _GetValuesCaptionsMaxWidth + 2;//2 - min поля слева

  FRect_Values:=maxrect;//default
  FRect_values.Left:=FRect_Captions.Right+2;//промежуток между Captions and Values

  //FValues_ya:
  FValues_ya.Clear;
  if FValues.Count>0 then begin
    dy:=Round( (maxrect.Bottom-maxrect.Top)/FValues.Count );
    y:=maxrect.Top+Round(dy/2);
    if dy>0 then for i:=0 to FValues.Count-1 do begin
      FValues_ya.Add(y);
      inc(y,dy);//for next line
    end;//for i
  end;//if
end;


procedure TDiagra.AddTitleString(s: string);
var str: TCanvaxStr;
begin
  str:=TCanvaxStr.Create(s, FCanvax, ttax_Center, ttay_Top);
  str.Font.Assign(FFont);//default
  str.Font.Color:=clBlue;
  str.Font.Style:=[fsBold];

  FTitle.Add(str);
end;

function TDiagra.AddValue(aValue: double; aCaption: string; aColor: TColor; aData: Pointer=nil): TDiagraValue;
begin
  Result:=TDiagraValue.Create(Self, aValue, aCaption, aColor, aData);
  FValues.Add(Result);
end;
function TDiagra.AddValue2(aValue: double; aCaption: string; aColor: TColor; aData: Pointer=nil): TDiagraValue;
begin
  Result:=TDiagraValue.Create(Self, aValue, aCaption, aColor, aData);
  FValues2.Add(Result);
end;


{ Paints: }

procedure TDiagra.Paint;//paint all
begin
  OnPaint(Self);
end;

function TDiagra.PaintTitle(maxrect: TRect): integer;
var x_middle,i: integer; str: TCanvaxStr;
begin
  Result:=2;//верхний сдвиг - Result - текущий "y"
  x_middle:=Round( (maxrect.Right-maxrect.Left)/2 );//горизонтальная середина
  //строки:
  if FTitle.Count>0 then for i:=0 to FTitle.Count-1 do begin
    tobject(str):=FTitle[i];

    str.DrawStr(x_middle, maxrect.Top+Result);

    inc( Result, str.GetInterval(1.5) );//полуторный интервал
  end;//for i
  //inc(Result, 2);//нижний сдвиг (+интервальный сдвиг при верхнем выравнивании текста)
end;

procedure TDiagra._PaintValuesCaptions(sel_ind: integer);//uses FRect_Captions,FValues_ya
var i: integer; val: TDiagraValue;
begin
  if FValues.Count<=0 then exit;
  if FValues.Count<>FValues_ya.Count then exit;//неправильный прям-к
  if FRect_Captions.Left>=FRect_Captions.Right then exit;
  for i:=0 to FValues.Count-1 do begin
    val:=Value[i];
    if sel_ind=i then val.Caption.Font.Color:=clWhite
    else val.Caption.Font.Color:=clBlack;
    val.Caption.DrawStr(FRect_Captions.Right, FValues_ya[i]);
  end;
end;


procedure TDiagra.__PaintValueRectAndMarker(aVal: TDiagraValue; aValRect: TRect);
var y: integer; p1,p2: TPoint;
begin
  FCanvax.rect_fillstroke(aValRect, aVal.FColor, clBlack, 1);
  //Маркер:
  y:=Round( (aValRect.Top+aValRect.Bottom)/2 );//y средней линии
  p1:=Point(aValRect.Right+1,y);
  p2:=Point(aValRect.Right+10,y);
  FCanvax.line_stroke(p1,p2,clWhite,1);
  FCanvax.rect_fillstroke( aVal.FMarkStr.GetStrRect(p2.x,y, 2,1), clYellow, clBlack, 1);//поля >1 справа необходимы
  aVal.FMarkStr.DrawStr(p2.x,y);
end;

procedure TDiagra._PaintValuesRects;//uses FRect_Values,FValues_ya
var
  ValHeight,i,xvmin,xvmax,xv1,xv2: integer; vmin,vmax: double;
  val1,val2: TDiagraValue; ValRect,ValRect2: TRect;
begin
  if FValues.Count<=0 then exit;
  if FValues.Count<>FValues_ya.Count then exit;
  if FRect_Values.Left>=FRect_Values.Right then exit;//неправильный прям-к

  //ValHeight:
  if FValues_ya.Count>1 then ValHeight:=FValues_ya[1]-FValues_ya[0]
  else ValHeight:=FRect_Values.Bottom-FRect_Values.Top;//default for FValues_ya.Count=1
  ValHeight:=Round( ValHeight*0.85 );//сужение

  if ValHeight>0 then begin

    ValRect.Left:=FRect_Values.Left;
    xvmin:=ValRect.Left+30;//30 - под 0
    xvmax:=FRect_Values.Right-40;// 40 - под маркер    ---- ????

    //vmin,vmax (общие для FValues & FValues2):
    vmin:=0;
    vmax:=0;
    val2:=nil;
    if FValues.Count>0 then for i:=0 to FValues.Count-1 do begin
      val1:=Value[i];
      if FValues2.Count=FValues.Count then val2:=Value2[i];
      if i=0 then begin
        vmin:=val1.FValue;
        vmax:=vmin;
      end else begin
        if val1.FValue<vmin then vmin:=val1.FValue;
        if val1.FValue>vmax then vmax:=val1.FValue;
      end;
      if Assigned(val2) then begin
        if val2.FValue<vmin then vmin:=val2.FValue;
        if val2.FValue>vmax then vmax:=val2.FValue;
      end;
    end;//for i

    //РИСОВАНИЕ:
    val2:=nil;
    if FValues.Count>0 then for i:=0 to FValues.Count-1 do begin
      val1:=Value[i];
      if FValues2.Count=FValues.Count then val2:=Value2[i];

      ValRect.Top:=FValues_ya[i]-Round(ValHeight/2);
      ValRect.Bottom:=FValues_ya[i]+Round(ValHeight/2);

      //правая сторона (xv):
      xv1 := xvmin;//default
      xv2 := xvmin;//default
      if (vmax>vmin) and (xvmax>xvmin) then try
        xv1 := xvmin + Round( (xvmax-xvmin)*(val1.FValue-vmin)/((vmax-vmin)) );
        if Assigned(val2) then
          xv2 := xvmin + Round( (xvmax-xvmin)*(val2.FValue-vmin)/((vmax-vmin)) );
      except
      end;

      if Assigned(val2) then begin
        ValRect2:=ValRect;

        ValRect.Right:=xv1;
        ValRect.Bottom:=FValues_ya[i]+1;//верхний прям-к - не знаю почему "+1", но надо
        __PaintValueRectAndMarker(val1, ValRect);

        ValRect2.Right:=xv2;
        ValRect2.Top:=FValues_ya[i];//нижний прям-к
        __PaintValueRectAndMarker(val2, ValRect2);
      end else begin
        ValRect.Right:=xv1;
        __PaintValueRectAndMarker(val1, ValRect);
      end;

    end;//for i

  end;//if ValHeight>0
end;

procedure TDiagra.PaintValues(maxrect: TRect);
begin
  //поля:
  maxrect.Left:=maxrect.Left+2;
  maxrect.Right:=maxrect.Right-2;
  maxrect.Bottom:=maxrect.Bottom-2;

  _Get_Rects_And_Values_ya(maxrect);//=>FRect_Captions,FRect_Values,FValues_ya
  FCanvax.rect_stroke(FRect_Values, clBlack, 1);//прямоугольник прямоугольников
  _PaintValuesCaptions(-1);//uses FRect_Captions, FValues_ya
  _PaintValuesRects;//uses FRect_Values, FValues_ya
end;


function TDiagra.GetValueIndByXY(X,Y: Integer): integer;
var dy: integer;
begin
  Result:=-1;
  if X<FRect_Captions.Left then exit;
  //if X>FRect_Captions.Right then exit;
  if X>FRect_Values.Right then exit;
  if Y<FRect_Captions.Top then exit;
  if Y>FRect_Captions.Bottom then exit;

  if FValues.Count<=0 then exit;
  if FRect_Captions.Bottom<=FRect_Captions.Top then exit;
  dy:=Round( (FRect_Captions.Bottom-FRect_Captions.Top)/FValues.Count );
  Result := ceil( (Y-FRect_Captions.Top)/dy ) - 1;
end;


{ Events: }

procedure TDiagra.WindowProc(var Message: TMessage);
begin
  try
    if Message.Msg = cm_MouseLeave then _PaintValuesCaptions(-1);
  finally
    FWindowProcOld(Message);//call old WindowProc
  end;
end;

procedure TDiagra.OnPaint(Sender: TObject);//OnPaint Event (Msg=15)
var htitle: integer; rectall,rectvalall: TRect;
begin
  try
    //clear:
    rectall:=GetPaintBoxRect;
    FCanvax.rect_fill(rectall, FPaintBox.Color);

    //Title:
    htitle:=PaintTitle(rectall);

    //Values:
    rectvalall:=rectall;
    rectvalall.Top:=htitle;
    if rectvalall.Top<rectvalall.Bottom then PaintValues(rectvalall);
  except
  end;
end;

procedure TDiagra.OnMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var valind: integer;
begin
  valind:=GetValueIndByXY(X,Y);
  _PaintValuesCaptions(valind);
end;

procedure TDiagra.OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

end.
