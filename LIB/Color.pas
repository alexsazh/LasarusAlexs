unit Color;

{$MODE Delphi}

 interface

uses
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, extctrls,
  Arrayx, nums;


type
  TReal2ColorFunc = function(v: double): TColor of object;
  TInt2ColorFunc = function(iv: integer): TColor of object;

  tRGBColor = record r,g,b: real; end;
  tCMYKColor = record c,m,y,k: real; end;

const
  CMYK_red: tCMYKColor =    (c:0; m:1; y:1; k:0);
  CMYK_yellow: tCMYKColor = (c:0; m:0; y:1; k:0);
  CMYK_green: tCMYKColor =  (c:1; m:0; y:1; k:0);
  CMYK_magenta: tCMYKColor =  (c:0; m:1; y:0; k:0);

  //"помидорно-огуречная"(Якуба Слава) раскраска (приглушённые пастельные цвета):
  CMYK_red2: tCMYKColor =    (c:0.00; m:0.30; y:0.33; k:0.25);
  CMYK_yellow2: tCMYKColor = (c:0.00; m:0.00; y:0.70; k:0.20);
  CMYK_green2: tCMYKColor =  (c:0.20; m:0.00; y:0.20; k:0.55);

var
  //initialization:
  COLOR_red: TColor;
  COLOR_yellow: TColor;
  COLOR_green: TColor;
  COLOR_magenta: TColor;

type
  //переход red-green через yellow от vred к vgreen:
  TCMYK_RYG = class(tobject)
  private
    va0,va: tnuma;//va0 - до сортировки!
    cmyka: tarray;
    function Get(v: tnum): tCMYKColor;
  public
    constructor Create(vred,vgreen: tnum);//m.b. vred<vgreen или наоборот
    destructor Destroy; override;
    procedure Set3CMYK(cmyk1,cmyk2,cmyk3: tCMYKColor);//va.count=3(after Create!)

    property tColor[v: tnum]: tCMYKColor read Get; default;
  end;

{ functions: }

procedure SetCMYK(c,m,y,k: real; var cmyk: tcmykcolor);

function RGB2CMYK(rgb: trgbcolor): tcmykcolor;
function CMYK2RGB(cmyk: tcmykcolor): trgbcolor;

function Color2RGB(color: tcolor): trgbcolor;
function RGB2Color(rgb: trgbcolor): tcolor;

function Color2CMYK(color: tcolor): tcmykcolor;
function CMYK2Color(cmyk: tcmykcolor): tcolor;

function Str2CMYK(s: string): tcmykcolor;//s='[c m y k]' || 'c m y k'
function CMYK2Str(cmyk: tcmykcolor): string;//->'c m y k'

//Ini-file:
procedure CMYK2Ini(skey: string; cmyk: tcmykcolor);//current Section
function Ini2CMYK(skey: string; defv: tcmykcolor): tcmykcolor;//current Section

//-----------------------------------------------

function Blank2Op(aBlank: boolean): integer; {true->0; false->1}

//линейная интерполяция:
function Get_CMYK_t(t: real; c0,c1: tcmykcolor): tcmykcolor;//0<=t<=1
function Get_RGB_t(t: real; c0,c1: trgbcolor): trgbcolor;//0<=t<=1

procedure Color_FillImage(aImage: TImage; aColor: tcolor);


type
  TColorDlg = class(TForm)
    ColorDialog1: TColorDialog;
    procedure ColorDialog1Show(Sender: TObject);
  private
    { Private declarations }
  public
    Color: TColor;
    rgb: trgbcolor;
    cmyk: tcmykcolor;
    scmyk: string; {"C M Y K" без []}
    function Execute: boolean;
    function Execute2(aColor: tcolor): boolean;
  end;


var ColorDlg: TColorDlg;


implementation

uses
  Wcmn;

{$R *.lfm}


{ TCMYK_RYG: }

constructor TCMYK_RYG.Create(vred,vgreen: tnum);//m.b. vred<vgreen или наоборот
begin
  inherited Create;
  va0:=tnuma.New;
  va:=tnuma.New;
  cmyka:=tarray.Create(SizeOf(tcmykcolor),3);

  //3 точки (порядок будет зафиксирован в va0!):
  va0.Add(vred); cmyka.Add(cmyk_red2);
  va0.Add((vred+vgreen)/2); cmyka.Add(cmyk_yellow2);
  va0.Add(vgreen); cmyka.Add(cmyk_green2);

  va.AddFrom(va0);
  va.Sort(cmyka);
end;

destructor TCMYK_RYG.Destroy;
begin
  cmyka.Free;
  va.Free;
  va0.Free;
end;

procedure TCMYK_RYG.Set3CMYK(cmyk1,cmyk2,cmyk3: tCMYKColor);//va.count=3(!!!)
begin
  if va0.Count<>3 then exit;//!

  cmyka.Clear;
  cmyka.Add(cmyk1);
  cmyka.Add(cmyk2);
  cmyka.Add(cmyk3);

  va.Clear;
  va.AddFrom(va0);
  va.Sort(cmyka);
end;

function TCMYK_RYG.Get(v: tnum): tCMYKColor;
var t: tnum; var vind: tint; cmyk1,cmyk2: tcmykcolor;
begin
  va.position(v, t,vind);
  cmyka.Get(vind, cmyk1);
  cmyka.Get(vind+1, cmyk2);
  Result:=Get_CMYK_t(t, cmyk1,cmyk2);
end;


{ functions: }

procedure SetCMYK(c,m,y,k: real; var cmyk: tcmykcolor);
begin
  cmyk.c:=c;
  cmyk.m:=m;
  cmyk.y:=y;
  cmyk.k:=k;
end;


function RGB2CMYK(rgb: trgbcolor): tcmykcolor;
var c,m,y,k: real;
begin
  c:=1-rgb.r;
  m:=1-rgb.g;
  y:=1-rgb.b;
  k:=min(c,min(m,y));

  Result.c := min(1, max(0, c-k) );
  Result.m := min(1, max(0, m-k) );
  Result.y := min(1, max(0, y-k) );
  Result.k := min(1, max(0, k) );
end;

function CMYK2RGB(cmyk: tcmykcolor): trgbcolor;
begin
  Result.r := 1 - min(1, cmyk.c+cmyk.k );
  Result.g := 1 - min(1, cmyk.m+cmyk.k );
  Result.b := 1 - min(1, cmyk.y+cmyk.k );
end;

function Color2RGB(color: tcolor): trgbcolor;
begin
  Result.r := (color and $0000FF)/255;
  Result.g := ((color and $00FF00) shr 8)/255;
  Result.b := ((color and $FF0000) shr 16)/255;
end;

function RGB2Color(rgb: trgbcolor): tcolor;
begin
  Result := Round(rgb.b*$FF);
  Result := Result shl 8; Result := Result + Round(rgb.g*$FF);
  Result := Result shl 8; Result := Result + Round(rgb.r*$FF);
  //Result := Result + $02000000;//при этом ColorDialog не выставляется на начальный цвет
end;

function Color2CMYK(color: tcolor): tcmykcolor;
var rgb: trgbcolor;
begin
  rgb:=Color2RGB(color);
  Result:=RGB2CMYK(rgb);
end;

function CMYK2Color(cmyk: tcmykcolor): tcolor;
var rgb: trgbcolor;
begin
  rgb:=CMYK2RGB(cmyk);
  Result:=RGB2Color(rgb);
end;

function Str2CMYK(s: string): tcmykcolor;//s='[c m y k]' || 'c m y k'
var s2: string; i,n: integer; c: char;
begin
  n:=Length(s);
  if n>0 then SetLength(s2,n) else s2:=' ';

  //удаление скобок:
  if n>0 then for i:=1 to n do begin
    c:=s[i];
    if (c='[') or (c=']') then c:=' ';
    s2[i]:=c;
  end;

  //чтение компонент цвета:
  Result.c := sread_real(s2);
  Result.m := sread_real(s2);
  Result.y := sread_real(s2);
  Result.k := sread_real(s2);
end;

function CMYK2Str(cmyk: tcmykcolor): string;//->'c m y k'
begin
  Result:=Format('%.2f %.2f %.2f %.2f',[cmyk.c, cmyk.m, cmyk.y, cmyk.k]);
end;

//Ini-file:
procedure CMYK2Ini(skey: string; cmyk: tcmykcolor);//current Section
begin
  Ini.WS(skey, CMYK2Str(cmyk));
end;

function Ini2CMYK(skey: string; defv: tcmykcolor): tcmykcolor;//current Section
var s: string;
begin
  s:=Ini.RS(skey, '-');
  if s='-' then Result := defv
  else Result := Str2CMYK(s);
end;

//-----------------------------------------------

function Blank2Op(aBlank: boolean): integer; {true->0; false->1}
begin
  if aBlank then Result:=0 else Result:=1;
end;


function Get_CMYK_t(t: real; c0,c1: tcmykcolor): tcmykcolor;//0<=t<=1
begin
  Result.c := (1-t)*c0.c + t*c1.c;
  Result.m := (1-t)*c0.m + t*c1.m;
  Result.y := (1-t)*c0.y + t*c1.y;
  Result.k := (1-t)*c0.k + t*c1.k;
end;

function Get_RGB_t(t: real; c0,c1: trgbcolor): trgbcolor;//0<=t<=1
begin
  Result.r := (1-t)*c0.r + t*c1.r;
  Result.g := (1-t)*c0.g + t*c1.g;
  Result.b := (1-t)*c0.b + t*c1.b;
end;

procedure Color_FillImage(aImage: TImage; aColor: tcolor);
begin
  with aImage.Canvas do begin
    Brush.Color:=aColor;
    FillRect( Rect(0,0,aImage.Width,aImage.Height) );
  end;
end;



{ tColorDlg: } //--------------------------------------------

{ public: }

function tColorDlg.Execute: boolean;
begin
  Result := ColorDialog1.Execute;
  if Result then begin
    color := ColorDialog1.Color;
    rgb:=Color2RGB(color);
    cmyk := rgb2cmyk(rgb);
    scmyk := Format('[%.2f %.2f %.2f %.2f]',[cmyk.c,cmyk.m,cmyk.y,cmyk.k]);
  end;
end;

function tColorDlg.Execute2(aColor: tcolor): boolean;
begin
  ColorDialog1.Color:=aColor;
  Result:=Execute;
end;


{ Events: }


procedure TColorDlg.ColorDialog1Show(Sender: TObject);
begin
//  Color:=clBlue;//  ---  не помогает!
end;

initialization
  COLOR_red     :=CMYK2Color(CMYK_red);
  COLOR_yellow  :=CMYK2Color(CMYK_yellow);
  COLOR_green   :=CMYK2Color(CMYK_green);
  COLOR_magenta :=CMYK2Color(CMYK_magenta);


end.
