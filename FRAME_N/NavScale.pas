unit NavScale;

{$MODE Delphi}

interface

uses
  Windows, LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, MaskEdit, inifiles, Dmw_ddw, dmw_Use, OTypes,
  Frnavyfun, win_use, NevaUtil, wmPick;

type
  TFnavScale = class(TForm)
    CmbxSc: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    meDistVert: TMaskEdit;
    labmm: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    meKMNumb: TMaskEdit;
    meMileNumb: TMaskEdit;
    Button1: TButton;
    Label5: TLabel;
    memetrval: TMaskEdit;
    Label6: TLabel;
    Label7: TLabel;
    meKabVal: TMaskEdit;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FnavScale: TFnavScale;
  IniFile:TiniFile;
implementation

 {$R *.lfm}

procedure TFnavScale.FormCreate(Sender: TObject);
begin
IniFile:=TIniFile.Create(make_ini('mk_seaFr.ini'));
Height:=IniFile.ReadInteger('NAVSCALE','Form_Height',150);
Width:=IniFile.ReadInteger('NAVSCALE','Form_Width',560);
CmbxSc.ItemIndex:=IniFile.ReadInteger('NAVSCALE','SCALETYPE',0);
meKmNumb.EditText:=IniFile.ReadString('NAVSCALE','KMNUMB','5');
meMileNumb.EditText:=IniFile.ReadString('NAVSCALE','MILENUMB','4');
memetrVal.EditText:=IniFile.ReadString('NAVSCALE','MetrVAL','200');
meKabVal.EditText:=IniFile.ReadString('NAVSCALE','KabVAL','1');
meDistVert.EditText:=IniFile.ReadString('NAVSCALE','DISTVERT','7');
IniFile.free;
end;

procedure TFnavScale.FormDestroy(Sender: TObject);
begin
IniFile:=TIniFile.Create(make_ini('mk_seaFr.ini'));
IniFile.WriteInteger('NAVSCALE','Form_Height',Height);
IniFile.WriteInteger('NAVSCALE','Form_Width',Width);
IniFile.WriteInteger('NAVSCALE','SCALETYPE',CmbxSc.ItemIndex);
IniFile.WriteString('NAVSCALE','KMNUMB',meKmNumb.EditText);
IniFile.WriteString('NAVSCALE','MILENUMB',meMileNumb.EditText);
IniFile.WriteString('NAVSCALE','MetrVAL',memetrVal.EditText);
IniFile.WriteString('NAVSCALE','KabVAL',meKabVal.EditText);
IniFile.WriteString('NAVSCALE','DISTVERT',meDistVert.EditText);
IniFile.free;
end;

procedure TFnavScale.Button1Click(Sender: TObject);
var lx:longint;
    i,codeThick,codeThin,codedigit,CodeStrich,KmNumb,MileNumb:integer;
    ss:shortstring;
    a,b,aMile:lpoint;
    kk,kf,vertDist,metrVal,KabVal,metrmap,Kabmap,dd:double;
    tg:tgauss;
    mn:pchar;
    flKM,flMile:boolean;
begin
if not wm_PickPoint(a,tg) then exit;
 Decimalseparator:='.';
 KmNumb:=Strtoint(mekmnumb.edittext);
 MileNumb:=Strtoint(meMilenumb.edittext);
 vertDist:=Strtofloat(meDistVert.EditText);
 metrVal:=Strtofloat(meMetrVal.EditText);
 flKm:=MetrVal>=1000;
 KabVal:=Strtofloat(meKabVal.EditText);
 Flmile:=KabVal>=10;
mn:=dmw_activemap(@ss[1],255);
   if not assigned(mn) then begin
   ShowMessage('Нет активной карты');
   exit
   end;
   if dmw_open(mn,true)= 0 then begin
   ShowMessage('Не возможно открыть активную карту');
   exit
   end;
   kf:=dm_dist(1,1);
   metrmap:=dm_dist(metrVal,0);
   Kabmap:=dm_dist(KabVal*185.2,0);
   dmx_find_frst_code(0,1);
   dm_Goto_last;
 {Создание масштабной линейки);
  }
  {????}

    Tl1.n:=1;
    TL1.pol[0]:=a;
    TL1.pol[1].y:=a.y;
    codeThick:=String2code('A0100006');
    codeThin:=String2code('A0100002');
    codedigit:=String2code('A0400630');
    CodeStrich:=String2code('A0100003');

    if (Cmbxsc.ItemIndex=0)or (Cmbxsc.ItemIndex=2) then begin
       TL1.pol[1].x:=a.x+round(kmnumb*metrmap);
       dm_add_poly(codeThick,2,0,@TL1,false);
       if Cmbxsc.ItemIndex=2 then begin
         aMile.x:=a.x+(TL1.pol[1].x-TL1.pol[0].x) div 2-round(0.5*Milenumb*Kabmap);
         aMile.y:=a.y+ Round(vertDist*kf);
         TL1.pol[0]:=aMile;
         TL1.pol[1].y:=aMile.y;
         TL1.pol[1].x:=aMile.x+round(Milenumb*Kabmap);
         dm_add_poly(codeThick,2,0,@TL1,false);
       end;
    end else begin
       TL1.pol[1].x:=a.x+round(milenumb*Kabmap);
       dm_add_poly(codeThick,2,0,@TL1,false);
    end;
    kk:=0.8*kf;
    TL1.pol[0].x:=a.x;
    TL1.pol[0].y:=a.y-round(kk);
    TL1.pol[1].y:= TL1.pol[0].y;
    if (Cmbxsc.ItemIndex=0)or (Cmbxsc.ItemIndex=2) then begin
        TL1.pol[1].x:=a.x+round(kmnumb*MetrMap);
        dm_add_poly(codeThin,2,0,@TL1,false);
        if Cmbxsc.ItemIndex=2 then begin
          TL1.pol[0].x:=aMile.x;
          TL1.pol[0].y:=aMile.y-round(kk);
          TL1.pol[1].y:=TL1.pol[0].y;
          TL1.pol[1].x:=aMile.x+round(Milenumb*Kabmap);
          dm_add_poly(codeThin,2,0,@TL1,false);
        end;
    end else
    begin
        TL1.pol[1].x:=a.x+round(milenumb*Kabmap);
        dm_add_poly(codeThin,2,0,@TL1,false);
    end;


     if (Cmbxsc.ItemIndex=0)or (Cmbxsc.ItemIndex=2) then begin

    b.x:=a.x;
    b.y:=a.y-round(2*kf);
    PL.n:=0;
    PL.pol[0]:=b;
    if Flkm then begin
      dd:=metrVal/1000;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd);
    end else begin
      if abs(metrVal-round(metrVal)) <0.01 then
         ss:=Inttostr(round(metrVal))
      else
         ss:=FormatFloat('0.0',metrVal);
    end;
    ss:=ss+#0;
    dm_Text_bound(codedigit,@ss[1],pl,pb,8000,0);
    lx:=(pb^.pol[3].x-pb^.pol[0].x) div 2;

    b.x:=b.x-lx;
     PL.pol[0]:=b;
    dm_add_text(codedigit,4,0,pl,@ss[1],false);

    TL1.pol[0].y:=a.y;
    Tl1.pol[1].y:=a.y-round(0.8*kf);
    for i:=1 to 9 do
     if i<>5 then begin
       TL1.pol[0].x:=a.x+round(i*0.1*MetrMap);
       TL1.pol[1].x:=TL1.pol[0].x;
       dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);
     end;

    Tl1.pol[1].y:=a.y-round(2*kf);

    TL1.pol[0].x:=a.x+round(0.5*MetrMap);
    TL1.pol[1].x:=TL1.pol[0].x;
    dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);

    for i:=0 to KmNumb do begin
    TL1.pol[0].x:=a.x+round(i*MetrMap);
    TL1.pol[1].x:=TL1.pol[0].x;
    dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);
    if i>0 then begin
      if Flkm then begin
      dd:=(i-1)*metrVal/1000;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd)
    end else begin
      dd:=(i-1)*metrVal;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd);
    end;

   ss:=ss+#0;
   b.x:=TL1.pol[0].x;
    PL.pol[0]:=b;
    dm_Text_bound(codedigit,@ss[1],pl,pb,8000,0);
    b.x:=b.x-(pb^.pol[3].x-pb^.pol[0].x) div 2;
    PL.pol[0]:=b;
    dm_add_text(codedigit,4,0,pl,@ss[1],false);
    end;
    end;
    if flkm then
    Strcat(@ss[1],' км')
    else
    Strcat(@ss[1],' м');
    AnsiToOem(@ss[1],@ss[1]);
    dm_put_string(9,@ss[1]);

    if Cmbxsc.ItemIndex=2 then begin
     b.x:=aMile.x;
    b.y:=aMile.y-round(2*kf);
    PL.n:=0;
    PL.pol[0]:=b;
    if FlMile then begin
      dd:=KabVal/10;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd);
    end else begin
      if abs(KabVal-round(KabVal)) <0.01 then
         ss:=Inttostr(round(KabVal))
      else
         ss:=FormatFloat('0.0',KabVal);
    end;
    ss:=ss+#0;
    dm_Text_bound(codedigit,@ss[1],pl,pb,8000,0);
    lx:=(pb^.pol[3].x-pb^.pol[0].x) div 2;

    b.x:=b.x-lx;
     PL.pol[0]:=b;
    dm_add_text(codedigit,4,0,pl,@ss[1],false);

    TL1.pol[0].y:=aMile.y;
    Tl1.pol[1].y:=aMile.y-round(0.8*kf);
    for i:=1 to 9 do
     if i<>5 then begin
       TL1.pol[0].x:=aMile.x+round(i*0.1*KabMap);
       TL1.pol[1].x:=TL1.pol[0].x;
       dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);
     end;

    Tl1.pol[1].y:=aMile.y-round(2*kf);

    TL1.pol[0].x:=aMile.x+round(0.5*KabMap);
    TL1.pol[1].x:=TL1.pol[0].x;
    dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);

    for i:=0 to MileNumb do begin
    TL1.pol[0].x:=aMile.x+round(i*KabMap);
    TL1.pol[1].x:=TL1.pol[0].x;
    dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);
    if i>0 then begin
      if FlMile then begin
      dd:=(i-1)*KabVal/10;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd)
    end else begin
      dd:=(i-1)*KabVal;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd);
    end;

   ss:=ss+#0;
   b.x:=TL1.pol[0].x;
    PL.pol[0]:=b;
    dm_Text_bound(codedigit,@ss[1],pl,pb,8000,0);
    b.x:=b.x-(pb^.pol[3].x-pb^.pol[0].x) div 2;
    PL.pol[0]:=b;
    dm_add_text(codedigit,4,0,pl,@ss[1],false);
    end;
    end;
    if flkm then
    Strcat(@ss[1],' М')
    else
    Strcat(@ss[1],' кб');
    ANSItoOEM(@ss[1],@ss[1]);
    dm_put_string(9,@ss[1])

    end;
   end else begin
    b.x:=a.x;
    b.y:=a.y-round(2*kf);
    PL.n:=0;
    PL.pol[0]:=b;
    if FlMile then begin
      dd:=KabVal/10;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd);
    end else begin
      if abs(KabVal-round(KabVal)) <0.01 then
         ss:=Inttostr(round(KabVal))
      else
         ss:=FormatFloat('0.0',KabVal);
    end;
    ss:=ss+#0;
    dm_Text_bound(codedigit,@ss[1],pl,pb,8000,0);
    lx:=(pb^.pol[3].x-pb^.pol[0].x) div 2;

    b.x:=b.x-lx;
     PL.pol[0]:=b;
    dm_add_text(codedigit,4,0,pl,@ss[1],false);

    TL1.pol[0].y:=a.y;
    Tl1.pol[1].y:=a.y-round(0.8*kf);
    for i:=1 to 9 do
     if i<>5 then begin
       TL1.pol[0].x:=a.x+round(i*0.1*KabMap);
       TL1.pol[1].x:=TL1.pol[0].x;
       dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);
     end;

    Tl1.pol[1].y:=a.y-round(2*kf);

    TL1.pol[0].x:=a.x+round(0.5*KabMap);
    TL1.pol[1].x:=TL1.pol[0].x;
    dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);

    for i:=0 to MileNumb do begin
    TL1.pol[0].x:=a.x+round(i*KabMap);
    TL1.pol[1].x:=TL1.pol[0].x;
    dm_add_Sign(CodeStrich,TL1.pol[0],TL1.pol[1],0,false);
    if i>0 then begin
      if FlMile then begin
      dd:=(i-1)*KabVal/1000;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd)
    end else begin
      dd:=(i-1)*KabVal;
      if abs(dd-round(dd)) <0.01 then
         ss:=Inttostr(round(dd))
      else
         ss:=FormatFloat('0.0',dd);
    end;

   ss:=ss+#0;
   b.x:=TL1.pol[0].x;
    PL.pol[0]:=b;
    dm_Text_bound(codedigit,@ss[1],pl,pb,8000,0);
    b.x:=b.x-(pb^.pol[3].x-pb^.pol[0].x) div 2;
    PL.pol[0]:=b;
    dm_add_text(codedigit,4,0,pl,@ss[1],false);
    end;
    end;
    if flkm then
    Strcat(@ss[1],' М')
    else
    Strcat(@ss[1],' кб');
    ANSItoOEM(@ss[1],@ss[1]);
    dm_put_string(9,@ss[1])

   end;
 dmw_done
end;

end.
