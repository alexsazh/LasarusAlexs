(*
  dml2_* - КАРТА ЗАКРЫТА
  dml2_dm_* - КАРТА ОТКРЫТА!
*)
unit Dmlib2; interface

uses Windows, SysUtils, Classes, vlib, OTypes, dmw_use;

//КАРТА ЗАКРЫТА:

function dml2_ActiveDm_s: string;
function dml2_PrjDmList(PathList: TStrings): integer;//активная карта первая

//активный объект (Result = offs>0):
function dml2_ActiveObject: longint; overload;
function dml2_ActiveObject(var Code: longint; var Tag: byte): longint; overload;

function dml2_GetRasterPath: string;


//КАРТА ОТКРЫТА! :

function dml2_dm_find_char_code(nn: integer; id: Id_Tag{ex _int}; i: longint;
                           f: double; s: PChar; lfindcode: integer): longint;

function dml2_dm_get_s_unicode(n: word; _dos,_cut: boolean): string;//defval='', maxlen=65000
procedure dml2_dm_put_s_unicode(n: word; s: string);

//хар-ка #n + перекодировка DOS->WIN(if _dos) + ОБРЕЗАНИЕ $D$A в конце(if _cut):
function dml2_dm_get_s(n: word; _dos,_cut: boolean): string;//defval='', maxlen=1023
procedure dml2_dm_put_s(n: word; s: string; _dos: boolean=TRUE{!});

//1D-продолжение dm_Resolution (mpl = m местности/l карты):
function dml2_dm_lpmm1: double;//l карты/мм бумаги

//2D-продолжение dm_Resolution (mpl = m местности/l карты):
function dml2_dm_mpl2: tnum2;//m местности/l карты - "единица хранения" (0.1=дециметр)
function dml2_dm_lpmm2: tnum2;//l карты/мм бумаги

//w,h mm -> W,H on dm:
procedure dml2_dm_WHmm_to_WHlong1(w,h: double; var lw,lh: longint);//1D
procedure dml2_dm_WHmm_to_WHlong2(w,h: double; var lw,lh: longint);//2D

//W,H on dm -> w,h mm:
function dml2_WHlong_to_dm_WHmm1(lw,lh: longint; var w,h: double): boolean;//1D
function dml2_WHlong_to_dm_WHmm2(lw,lh: longint; var w,h: double): boolean;//2D


implementation

uses wcmn, dos_win_code, dmw_ddw;


//КАРТА ЗАКРЫТА: /////////////////////////////////////////////////////////////

function dml2_ActiveDm_s: string;
var admPath: array[1..1024]of char; pc: PChar;
begin
  pc := dmw_ActiveMap(@admPath[1], 1023);//PChar
  Result := StrPas(pc);
end;

function dml2_PrjDmList(PathList: TStrings): integer;//активная карта первая
var aPath: array[1..1024]of char; pc: PChar;
  fpath: string; ft: TextFile; s: string;
begin
  PathList.Clear;//!
  //Result:=0;//default

  s:=dml2_ActiveDm_s;
  if Length(s)>0 then PathList.Add(s);//активная карта первая

  //pc := dmw_AllProject(@aPath[1], 1023);//PChar --- ВЕСЬ СПИСОК НЕ РАБОТАЕТ!!!
  pc := dmw_AltProject(@aPath[1], 1023);//PChar
  fpath := StrPas(pc);
  if ftopen(ft,fpath,'r') then try
    while not EOF(ft) do begin
      readln(ft,s);
      PathList.Add(s);
    end;
  finally
    ftclose(ft);
  end;

  Result:=PathList.Count;//!
end;


//активный объект (Result = offs>0):
function dml2_ActiveObject: longint;
var Code: longint; Tag: byte;
begin
  Result:=dml2_ActiveObject(Code,Tag);
end;

function dml2_ActiveObject(var Code: longint; var Tag: byte): longint;
var offs: longint; x1,y1,x2,y2: longint; _name: ShortString;
begin
  {pc:=}dmw_OffsObject(offs,Code, Tag, x1,y1,x2,y2, @_name[1], 255);
{Возвращает для выбранного в рабочем окне объекта}
{указатель <offs>, код <Code>, тип <Tag>,        }
{габаритную рамку <x1,y1,x2,y2>, название <p>    }

  if offs>32
  then Result:=offs
  else Result:=0;
end;


function dml2_GetRasterPath: string;
var stmp: string; pc: PChar;
begin
  SetLength(stmp, 1024);
  pc:=dmw_PcxPath(PChar(stmp),1023);
  Result:=StrPas(pc);//if pc=nil then Result='';
end;


//КАРТА ОТКРЫТА! : ///////////////////////////////////////////////////////////


function dml2_dm_find_char_code(nn: integer; id: Id_Tag{ex _int}; i: longint;
                           f: double; s: PChar; lfindcode: integer): longint;
var lcode: integer;
begin
  repeat
    Result := dm_Find_Frst_Char(nn, id, i, f,s);
    if Result>0 then lcode:=dm_get_code else lcode:=0;
  until (Result=0) or (lcode=lfindcode);
end;


function dml2_dm_get_s_unicode(n: word; _dos,_cut: boolean): string;//defval='', maxlen=65528
var pws: PWideChar;
begin
  Result:='';
  Getmem(pws, 65528);
  try
    //if dm_Get_Unicode1(n,1023,@cha[1])
    if dm_Get_Unicode(n,pws) then begin
      Result:=WideCharToString(pws);
    end;
  finally
     Freemem(pws, 65528);
  end;

end;

procedure dml2_dm_put_s_unicode(n: word; s: string);
var l2: integer; pws: PWideChar;
begin
  l2:=Length(s)*2+2;//+2?
  Getmem(pws, l2);
  try
    StringToWideChar(s, pws, l2);
    dm_Put_Unicode(n, pws);
  finally
     Freemem(pws, l2);
  end;

end;


//хар-ка #n + перекодировка DOS->WIN(if _dos) + ОБРЕЗАНИЕ $D$A в конце(if _cut):
function dml2_dm_get_s(n: word; _dos,_cut: boolean): string;//defval='', maxlen=1023
var cha: array[1..1024]of char; l: integer;
//var s: ShortString;
begin
  if dm_get_Ansi(n,1023,@cha[1])//DOS!!!
  //if dm_get_String(n,255, s)//DOS!

  then begin Result:=StrPas(@cha[1]);
  if _dos then Result:=Dos2WinString(Result);
  end
  //then Result:=s
  else Result:='';

  //ОБРЕЗАНИЕ:
  l:=Length(Result);
  if _cut then begin
    while (l>0) and ( (Result[l]=#$D) or (Result[l]=#$A) ) do dec(l);
    if l<Length(Result) then SetLength(Result,l);
  end;
end;

procedure dml2_dm_put_s(n: word; s: string; _dos: boolean=TRUE{!});
var s2: string;
//var s: ShortString;
begin
  if _dos then s2:=Win2DosString(s) else s2:=s;
  dm_Put_String(n, PChar(s2));
end;



function dml2_dm_lpmm1: double;//l карты/мм бумаги
begin
  Result:=dm_Scale/(dm_Resolution*1000);//l/mm
end;

//2D-аналог dm_Resolution:
function dml2_dm_mpl2: tnum2;//m местности/l карты - "единица хранения" (0.1=дециметр)
var p1,p2,pos: TPoint; gx1,gy1,gx2,gy2: double; dist_l,dist_g: tnum2;
begin
  Result:=v_xy(1,1);//default
  dm_Get_Position(pos);//SAVE

  dm_Goto_Root;//!
  dm_Get_Bound(p1,p2);
  dm_L_to_G(p1.x,p1.y, gx1,gy1);
  dm_L_to_G(p2.x,p2.y, gx2,gy2);

  dist_l.x:=abs(p2.x-p1.x);
  dist_l.y:=abs(p2.y-p1.y);

  dist_g.x:=abs(gx2-gx1);
  dist_g.y:=abs(gy2-gy1);

  if (dist_l.x>1) and (dist_l.y>1) then begin
    Result.x:=dist_g.y/dist_l.x;
    Result.y:=dist_g.x/dist_l.y;//G-x ВЕРТИКАЛЕН!
  end;
(*
  dist:=Max(1,Hypot(p2.x-p1.x,p2.y-p1.y));
  if dist > 1 then
  Result:=Hypot(gx2-gx1,gy2-gy1)/dist;
*)
  dm_Set_Position(pos);//RESTORE
end;

function dml2_dm_lpmm2: tnum2;//l карты/мм бумаги
var dm_mpl: tnum2;
begin
  Result:=v_xy(1,1);//default
  dm_mpl:=dml2_dm_mpl2;
  if (dm_mpl.x>0) and (dm_mpl.y>0) then begin
    Result.x:=dm_Scale/(dm_mpl.x*1000);//l/mm on X
    Result.y:=dm_Scale/(dm_mpl.y*1000);//l/mm on Y
  end;
end;


procedure dml2_dm_WHmm_to_WHlong1(w,h: double; var lw,lh: longint);
var dm_lpmm: double;
begin
  dm_lpmm := dml2_dm_lpmm1;
  lw:=Round(w*dm_lpmm);
  lh:=Round(h*dm_lpmm);
end;

procedure dml2_dm_WHmm_to_WHlong2(w,h: double; var lw,lh: longint);
var dm_lpmm: tnum2;
begin
  dm_lpmm := dml2_dm_lpmm2;
  lw:=Round(w*dm_lpmm.x);
  lh:=Round(h*dm_lpmm.y);
end;


function dml2_WHlong_to_dm_WHmm1(lw,lh: longint; var w,h: double): boolean;
var dm_lpmm: double;
begin
  Result:=false;
  dm_lpmm := dml2_dm_lpmm1;
  if dm_lpmm>0 then begin
    w:=lw/dm_lpmm;
    h:=lh/dm_lpmm;
    Result:=true;
  end;
end;

function dml2_WHlong_to_dm_WHmm2(lw,lh: longint; var w,h: double): boolean;
var dm_lpmm: tnum2;
begin
  Result:=false;
  dm_lpmm := dml2_dm_lpmm2;
  if (dm_lpmm.x>0) and (dm_lpmm.y>0) then begin
    w:=lw/dm_lpmm.x;
    h:=lh/dm_lpmm.y;
    Result:=true;
  end;
end;




end.
