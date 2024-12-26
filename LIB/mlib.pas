(*
  матрицы nx*ny
  построчно слева направо (x) и сверху вниз (y) - как Image(bmp) и Relief
  Ok: if Count>0
*)
unit mlib; interface

uses
  ExtCtrls{TImage},
  nums, relief, color;


type
  tnuma2 = class(tnuma)
  protected
    FWidth: integer;//кол-во эл-ов в строке (count=Width*Height)
    function GetIndex(ix,iy: Integer): Integer;//ix+FWidth*iy
    function Get2(ix,iy: Integer): tnum;
    procedure Put2(ix,iy: Integer; aItem: tnum);
    function GetHeight: Integer;
    procedure SetWidth(aWidth: Integer);//просто изменение FWidth       //???
    procedure SetHeight(aHeight: Integer);//изменение count
  public
    Data: pointer;//для любой информации можно использовать
    constructor New2(aWidth, aHeight: Integer);//New + SetWidth + SetHeight
    procedure Clear; override;//count=0, FWidth=0
    procedure SetSizes(w,h: integer);//SetWidth + SetHeight
    //размеры Image устанавливаются; aRunTitle<>''=>RunLine used:
    procedure DrawImage(im: TImage; aColorFunc: TReal2ColorFunc; aRunTitle: string);
    procedure LoadFromRelief(rel: TRelief); virtual;//Clear; ok<=>(count>0)
    //Файл x.GSM возникает вместе с x.REL в соответствии с кодами в файле .CLU (clutter.pas):
    //Размер x.GSM - (w-1)*(h-1), где w*h - размер матрицы файла x.REL; элемент - WORD:
    //aWidth=(w-1); получится м-ца aWidth*(h-1); FileSize=aWidth*(h-1)*2 bytes:
    //aWidth=0 => размеры уже установлены(!):
    function LoadFromGsmFile(GsmFileName: string; aWidth: integer): boolean;

    property Val[ix,iy: Integer]: tnum read Get2 write Put2; default;
    property Count: integer read FCount;//ReadOnly!
    property Width: integer read FWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
  end;


implementation

uses
  Math, SysUtils,
  wcmn, runline;


{ tnuma2: }

constructor tnuma2.New2(aWidth, aHeight: Integer);//New + SetWidth,SetHeight
begin
  New;
  SetWidth(aWidth);//=>FWidth
  SetHeight(aHeight);//=>Count
end;

procedure tnuma2.Clear;//count=0, FWidth=0
begin
  FWidth:=0;
  inherited Clear;
end;

procedure tnuma2.SetSizes(w,h: integer);
begin
  SetWidth(w);
  SetHeight(h);
end;

function tnuma2.GetIndex(ix,iy: Integer): Integer;
begin
  Result:=ix+FWidth*iy;
end;

function tnuma2.Get2(ix,iy: Integer): tnum;
begin
  Result:=Get( GetIndex(ix,iy) );
end;

procedure tnuma2.Put2(ix,iy: Integer; aItem: tnum);
begin
  Put( GetIndex(ix,iy), aItem);
end;

function tnuma2.GetHeight: Integer;
begin
  if FWidth>0 then Result:=Ceil(FCount/FWidth) else Result:=0;
end;

procedure tnuma2.SetWidth(aWidth: Integer);
begin
  FWidth:=aWidth;
end;

procedure tnuma2.SetHeight(aHeight: Integer);//изменение count
begin
  SetCount(FWidth*aHeight);
end;

procedure tnuma2.DrawImage(im: TImage; aColorFunc: TReal2ColorFunc; aRunTitle: string);
var ix,iy,w,h: integer; runline,im_visible: boolean;
begin
  runline:=aRunTitle<>'';
  w:=Width;
  h:=Height;
  Im.Picture.Bitmap.Width:=w;//m.b.=0
  Im.Picture.Bitmap.Height:=h;//m.b.=0

  if FCount=0 then exit;

  //w,h>0:
  im_visible:=Im.Visible;
  Im.Visible:=false;//!
  if runline then RunForm.Start(aRunTitle);
  try
  try
    for iy:=0 to h-1 do begin
      if runline then begin
        RunForm.Go(iy/h);
        if RunForm.Cancelled then break;
      end;
      for ix:=0 to w-1 do
        Im.Canvas.Pixels[ix,iy] := aColorFunc( Val[ix,iy] );
    end;//for iy
  finally
    if runline then RunForm.Finish;
    Im.Visible:=im_visible;//!
  end;
  except
  end;
end;

procedure tnuma2.LoadFromRelief(rel: TRelief);
var w,h,ix,iy: integer;
begin
  Clear;//!
  if not rel.Ok then exit;//пустая матрица
  rel.GetWidthHeight(w,h);
  SetSizes(w,h);//=>FWidth,FCount
  if FCount>0 then try//=>w,h>0:
    for iy:=0 to h-1 do
      for ix:=0 to w-1 do
        Put2(ix,iy, rel.Value(ix,iy));
  except
  end;
end;

//Файл x.GSM возникает вместе с x.REL в соответствии с кодами в файле .CLU (clutter.pas):
//Размер x.GSM - (w-1)*(h-1), где w*h - размер матрицы файла x.REL; элемент - WORD:
//aWidth=(w-1); получится м-ца aWidth*(h-1); FileSize=aWidth*(h-1)*2 bytes:
function tnuma2.LoadFromGsmFile(GsmFileName: string; aWidth: integer): boolean;
var f: file; aHeight,aCount,ix,iy: integer; pc0,pc1: PChar; b1,b2: byte;
begin
  Result:=false;
  if aWidth>0 then Clear;//aWidth=0 => размеры уже установлены!

  if not FOpen_msg(f, GsmFileName, 'r') then exit;
  try
    aCount:=FileSize(f) div 2;//in WORDS
    if aWidth=0 then aWidth:=Width;//уже задана ранее!
    aHeight:=aCount div aWidth;//высоту надо пересчитать на всякий случай!
    SetSizes(aWidth, aHeight);//=>FCount

    if (aWidth>0) and (aHeight>0) and (aCount=FCount) and (aCount mod aWidth =0) then begin
      pc0:=malloc(aCount*2);
      if Assigned(pc0) then try
        BlockRead(f, pc0^, aCount*2);
        for iy:=0 to aHeight-1 do
          for ix:=0 to aWidth-1 do begin
            pc1:=pc0+ix*2+iy*aWidth*2;
            b1:=byte(pc1^);
            b2:=byte((pc1+1)^);
            Val[ix,iy]:=b2+b1*256;
          end;
        Result:=true;
      finally
         mfree2(pc0);
      end;
    end else begin
      Tellf('Размер (%d words) файла "%s" несовместим с шириной матрицы %d',[aCount, GsmFileName, FWidth]);
    end;
  finally
    FClose(f);
  end;
end;

end.
