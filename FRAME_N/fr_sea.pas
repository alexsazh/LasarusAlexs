{
1.Нормальная равноугольная цилиндрическая проекция Меркатора
2.Азимутальная косая стереографическая  проекция
3.Поперечная равноугольная цилиндрическая проекция Меркатора
4.Нормальная стереографическая  проекция ???
5.Нормальная равноугольная коническая проекция
6.Азимутальная нормальная гномоническая (центральная) проекция
7.Нормальная равнопромежуточная азимутальная проекция Постеля
8.Косая равновеликая азимутальная проекция Ламберта




Поперечная равноугольная цилиндрическая проекция Гаусса
Азимутальная нормальная гномоническая (центральная) проекция
Азимутальная косая гномоническая (центральная) проекция
Азимутальная поперечная стереографическая  проекция
Поперечная равнопромежуточная азимутальная проекция Постеля
Косая равнопромежуточная азимутальная проекция Постеля


}
{0:Нормальная равноугольная цилиндрическая проекция Меркатора
1:Поперечная равноугольная цилиндрическая проекция Меркатора
2:Поперечная равноугольная цилиндрическая проекция Гаусса
3:Нормальная равноугольная коническая проекция
4:Азимутальная нормальная гномоническая (центральная) проекция
5:Азимутальная поперечная гномоническая (центральная) проекция
6:Азимутальная косая гномоническая (центральная) проекция
7:Азимутальная косая гномоническая (центральная) проекция (полярные районы)
8:Азимутальная нормальная стереографическая  проекция
9:Азимутальная поперечная стереографическая  проекция
10:Азимутальная косая стереографическая  проекция
11:Азимутальная косая стереографическая  проекция (полярные районы)
12:Нормальная равнопромежуточная азимутальная проекция Постеля
13:Поперечная равнопромежуточная азимутальная проекция Постеля
14:Косая равнопромежуточная азимутальная проекция Постеля
15:Косая равнопромежуточная азимутальная проекция Постеля (полярные районы)
16:Косая равновеликая азимутальная проекция Ламберта
17:Азимутальная стереографическая (полюс)

0 "не установлена"
1 "Гаусса-Крюгера равноугольная"
2 "Меркатора равноугольная (UTM)"
3 "Меркатора цилиндрическая"
4 "Коническая равноугольная"
5 "Универсальная равноугольная"
6 "Поликоническая простая"
7 "Коническая равнопромежуточная"
8 "Коническая равнопромеж. [ПКО Картография]"
9 "Цилиндрическая поперечная равноугольная Меркатора"
10 "Азимутальная косая стереографическая"
11 "Азимутальная косая стереографическая (полюс)"
12 "Азимутальная нормальная стереографическая"
13 "Азимутальная нормальная гномоническая"
14 "Азимутальная поперечная стереографическая"
15 "Азимутальная поперечная гномоническая"
16 "Азимутальная косая гномоническая"
17 "Азимутальная косая гномоническая (полюс)"
18 "Азимутальная косая равнопромежуточная Постеля"
19 "Азимутальная косая равнопромежуточная Постеля (полюс)"
20 "Азимутальная нормальная равнопромежуточная Постеля"
21 "Азимутальная поперечная равнопромежуточная Постеля"
22 "Азимутальная косая равновеликая Ламберта"

100 "-"
101 "Гаусса-Крюгера равноугольная"
102 "Меркатора равноугольная (UTM)"
103 "Меркатора цилиндрическая"
104 "Коническая равноугольная"
105 "Универсальная равноугольная"
106 "Поликоническая простая"
107 "Коническая равнопромежуточная"
108 "Коническая равнопромеж. [ПКО Картография]"
109 "Цилиндр. поперечная равноугольная Меркатора"
110 "Азимут. косая стереографическая"
111 "Азимут. косая стереографическая (полюс)"
112 "Азимут. нормальная стереографическая"
113 "Азимут. зеркальная стереографическая"
114 "Азимут. нормальная гномоническая"
115 "Азимут. зеркальная гномоническая"
116 "Азимут. поперечная стереографическая"
117 "Азимут. поперечная гномоническая"
118 "Азимут. косая гномоническая"
119 "Азимут. косая гномоническая (полюс)"
120 "Азимут. косая равнопромежут. Постеля"
121 "Азимут. косая равнопромежут. Постеля (полюс)"
122 "Азимут. нормальная равнопромежут. Постеля"
123 "Азимут. зеркальная равнопромежут. Постеля"
124 "Азимут. поперечная равнопромежут. Постеля"
125 "Азимут. косая равновеликая Ламберта"
126 "Цилиндр. косая перспективная ЦНИИГАИК"
127 "Цилиндр. косая перспективная Соловьева"
128 "Коническая равноугольная Ламберта"
129 "Долгота, Широта (доли градуса)"
130 "Куба - север"
131 "Куба - юг"
132 "Google цилиндрическая"
133 "Азимут. стереографическая (полюс)"

}

unit fr_sea;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, MaskEdit, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BLgeo, StdCtrls, INIFiles,OTypes,Dmw_ddw,dmw_Use,geoidnw,mfrmNavy,frNavyfun, NevaUtil,
  win_use, ComCtrls, ExtCtrls, wmPick,Xbl,ConLamb, LazUTF8;
type
  TFSeaFrm = class(TForm)
    Button1: TButton;
    CBoxSrcCrd: TComboBox;
    Label21: TLabel;
    Label22: TLabel;
    CboxTagCrd: TComboBox;
    Button3: TButton;
    Label23: TLabel;
    edH: TEdit;
    CmBxPrj: TComboBox;
    Label24: TLabel;
    CmBxScale: TComboBox;
    Label29: TLabel;
    EdObj: TEdit;
    Button7: TButton;
    meSrcDX: TMaskEdit;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    meSrcDY: TMaskEdit;
    Label31: TLabel;
    meSrcDZ: TMaskEdit;
    Label32: TLabel;
    meTagdx: TMaskEdit;
    Label34: TLabel;
    meTagdy: TMaskEdit;
    Label35: TLabel;
    meTagdz: TMaskEdit;
    Button2: TButton;
    Button5: TButton;
    PgCrdSys: TPageControl;
    TabShBL: TTabSheet;
    TabShGauss: TTabSheet;
    Label2: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label33: TLabel;
    meBND: TMaskEdit;
    meBNM: TMaskEdit;
    meBNS: TMaskEdit;
    meLWD: TMaskEdit;
    meLWM: TMaskEdit;
    meLWS: TMaskEdit;
    meBSD: TMaskEdit;
    meBSM: TMaskEdit;
    meBSS: TMaskEdit;
    meLED: TMaskEdit;
    meLEM: TMaskEdit;
    meLES: TMaskEdit;
    meBMD: TMaskEdit;
    meBMM: TMaskEdit;
    meBMS: TMaskEdit;
    Button4: TButton;
    Label36: TLabel;
    Label40: TLabel;
    Label44: TLabel;
    Label48: TLabel;
    Label52: TLabel;
    Label56: TLabel;
    meXN: TMaskEdit;
    meYW: TMaskEdit;
    meXS: TMaskEdit;
    meYE: TMaskEdit;
    meLMD: TMaskEdit;
    meLMM: TMaskEdit;
    meLMS: TMaskEdit;
    Label54: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    RgScale: TRadioGroup;
    EdScale: TEdit;
    EdListWidth: TEdit;
    Label25: TLabel;
    TabShSlanting: TTabSheet;
    TabShKvasi: TTabSheet;
    Label37: TLabel;
    meBSDKV: TMaskEdit;
    Label38: TLabel;
    meBSMKV: TMaskEdit;
    Label39: TLabel;
    meBSSKV: TMaskEdit;
    Label41: TLabel;
    Label42: TLabel;
    meLWDKV: TMaskEdit;
    Label43: TLabel;
    meLWMKV: TMaskEdit;
    Label45: TLabel;
    meLWSKV: TMaskEdit;
    Label46: TLabel;
    Label47: TLabel;
    meBNDKV: TMaskEdit;
    Label49: TLabel;
    meBNMKV: TMaskEdit;
    Label50: TLabel;
    meBNSKV: TMaskEdit;
    Label51: TLabel;
    Label57: TLabel;
    meLEDKV: TMaskEdit;
    Label58: TLabel;
    meLEMKV: TMaskEdit;
    Label59: TLabel;
    meLESKV: TMaskEdit;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    meBmdkv: TMaskEdit;
    Label63: TLabel;
    meBmMkv: TMaskEdit;
    Label64: TLabel;
    meBmSkv: TMaskEdit;
    Label65: TLabel;
    Label66: TLabel;
    meBMND: TMaskEdit;
    Label67: TLabel;
    meBMNM: TMaskEdit;
    Label68: TLabel;
    meBMNS: TMaskEdit;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    meB0D: TMaskEdit;
    Label72: TLabel;
    meB0M: TMaskEdit;
    Label73: TLabel;
    meB0S: TMaskEdit;
    Label74: TLabel;
    Label75: TLabel;
    meL0D: TMaskEdit;
    Label76: TLabel;
    meL0M: TMaskEdit;
    Label77: TLabel;
    meL0S: TMaskEdit;
    Label78: TLabel;
    EdX0: TEdit;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    EdY0: TEdit;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    edDX: TEdit;
    Label87: TLabel;
    Label88: TLabel;
    edDY: TEdit;
    Label89: TLabel;
    TabSheet1: TTabSheet;
    Label90: TLabel;
    meBNormSWD: TMaskEdit;
    Label91: TLabel;
    meBNormSWM: TMaskEdit;
    Label92: TLabel;
    meBNormSWS: TMaskEdit;
    Label93: TLabel;
    Label94: TLabel;
    meLNorm0D: TMaskEdit;
    Label95: TLabel;
    meLNorm0M: TMaskEdit;
    Label96: TLabel;
    meLNorm0S: TMaskEdit;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    meBNNormD: TMaskEdit;
    Label101: TLabel;
    meBNNormM: TMaskEdit;
    Label102: TLabel;
    meBNNormS: TMaskEdit;
    Label103: TLabel;
    Label108: TLabel;
    eddxNorm: TEdit;
    Label109: TLabel;
    Label110: TLabel;
    edDYNorm: TEdit;
    Label111: TLabel;
    Label104: TLabel;
    meLNormSWD: TMaskEdit;
    Label105: TLabel;
    meLNormSWM: TMaskEdit;
    Label106: TLabel;
    meLNormSWS: TMaskEdit;
    Label107: TLabel;
    TabSheet2: TTabSheet;
    Label112: TLabel;
    meBCrossSWD: TMaskEdit;
    Label113: TLabel;
    meBCrossSWM: TMaskEdit;
    Label114: TLabel;
    meBCrossSWS: TMaskEdit;
    Label115: TLabel;
    Label116: TLabel;
    meL0CrossD: TMaskEdit;
    Label117: TLabel;
    meL0CrossM: TMaskEdit;
    Label118: TLabel;
    meL0CrossS: TMaskEdit;
    Label119: TLabel;
    Label120: TLabel;
    meLCrossSWD: TMaskEdit;
    Label121: TLabel;
    meLCrossSWM: TMaskEdit;
    Label122: TLabel;
    meLCrossSWS: TMaskEdit;
    Label123: TLabel;
    Label124: TLabel;
    EdDXCross: TEdit;
    Label125: TLabel;
    Label126: TLabel;
    edDYCross: TEdit;
    Label127: TLabel;
    Label128: TLabel;
    EdRCrossMerc: TEdit;
    Button6: TButton;
    Label129: TLabel;
    EdRSlant: TEdit;
    Button8: TButton;
    Label130: TLabel;
    EdRNorm: TEdit;
    Button9: TButton;
    TabSheet3: TTabSheet;
    Label131: TLabel;
    meBConSWD: TMaskEdit;
    Label132: TLabel;
    meBConSWM: TMaskEdit;
    Label133: TLabel;
    meBConSWS: TMaskEdit;
    Label134: TLabel;
    Label135: TLabel;
    meLCon0D: TMaskEdit;
    Label136: TLabel;
    meLCon0M: TMaskEdit;
    Label137: TLabel;
    meLCon0S: TMaskEdit;
    Label138: TLabel;
    Label139: TLabel;
    Label140: TLabel;
    meB1ConD: TMaskEdit;
    Label142: TLabel;
    meB1ConM: TMaskEdit;
    Label143: TLabel;
    meB1ConS: TMaskEdit;
    Label144: TLabel;
    Label145: TLabel;
    meLConSWD: TMaskEdit;
    Label146: TLabel;
    meLConSWM: TMaskEdit;
    Label147: TLabel;
    meLConSWS: TMaskEdit;
    Label148: TLabel;
    Label149: TLabel;
    edConDX: TEdit;
    Label150: TLabel;
    Label151: TLabel;
    EdConDY: TEdit;
    Label152: TLabel;
    Label141: TLabel;
    meB2ConD: TMaskEdit;
    Label154: TLabel;
    meB2ConM: TMaskEdit;
    Label155: TLabel;
    meB2ConS: TMaskEdit;
    Label156: TLabel;
    Label153: TLabel;
    meXSConus: TMaskEdit;
    Label157: TLabel;
    meYWConus: TMaskEdit;
    RGConus: TRadioGroup;
    Label158: TLabel;
    edX0Norm: TEdit;
    Label159: TLabel;
    Label160: TLabel;
    edY0Norm: TEdit;
    Label161: TLabel;
    ChBxMirr: TCheckBox;
    ChBXleftbott: TCheckBox;
    Button10: TButton;
    Label162: TLabel;
    Label163: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    Label166: TLabel;
    Label167: TLabel;
    MeSrcWX: TMaskEdit;
    MeSrcWY: TMaskEdit;
    MeSrcWZ: TMaskEdit;
    MeTagWX: TMaskEdit;
    MeTagWY: TMaskEdit;
    MeTagWZ: TMaskEdit;
    Label168: TLabel;
    Label169: TLabel;
    MeSrcM: TMaskEdit;
    MeTagm: TMaskEdit;
    Label170: TLabel;
    ChBxCircle: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CmBxPrjChange(Sender: TObject);
    procedure CBoxSrcCrdChange(Sender: TObject);
    procedure CboxTagCrdChange(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 {Function Find_Frst_Map(B,L:double; base,Pmap:Pchar):boolean;stdcall;
 Function Find_Next_Map(Pmap:Pchar):boolean;stdcall;
 Procedure Find_Close;stdcall;
 Function Show_Map(i:longint; Bindir:pchar):boolean;stdcall;
 }
 var
  FSeaFrm: TFSeaFrm;
  Bin_dir,Dirdm:String;
  MyFormatSettings : TFormatSettings;
implementation

uses UFrmnavy, NavyHead;

{$R *.lfm}
{ Function Find_Frst_Map(B,L:double; base,Pmap:Pchar):boolean; external 'Navymap.dll';
 Function Find_Next_Map(Pmap:Pchar):boolean;external 'Navymap.dll';
 Procedure Find_Close;external 'Navymap.dll';
 Function Show_Map(i:longint; Bindir:pchar):boolean;external 'Navymap.dll';

}
Procedure Mk_COVER_Circle;
var
  idvc,idve:array[1..4] of Cardinal;
  dLon, BSW, sign, dPi_180:double;
  lp:lpoint;
  ii:integer;
begin
with FSeaFrm do begin
 if (MeBNormSWd.edittext[1]='-') or (strtoint(meBNormSWD.edittext)<0)  then sign:=-1 else sign:=1;
    BSW:=(strtoint(meBNormSWD.edittext)+sign*strtoint(meBNormSWM.edittext)/60+sign*strtoFloat(meBNormSWS.edittext, MyFormatSettings)/3600)/180*PI;
   dm_R_to_L(BSW,0,lp.x,lp.y);


  idvc[1]:=dm_add_vc(0,lp.x,lp.y,NIL);
  dPi_180:=Pi/180;
  for ii:=1 to 359 do begin
    dLon:=dPi_180*ii;
    dm_R_to_L(BSW,dLon,PL^.pol[ii-1].x,PL^.pol[ii-1].y);

  end;
  PL^.n:=358;
  idve[1]:=dm_add_ve(0, idvc[1],idvc[1],PL,NIL);
  PL^.pol[0]:=cn_ptr(idve[1],cn_edge,1,1,255);
  PL^.n:=0;
  ii:=dm_add_poly(StrToCode('S5703020'),23,0,Pl,false);
  dm_Put_dbase(18,1);
  dm_Put_byte(1023,2);
end;
end;

procedure TFSeaFrm.Button1Click(Sender: TObject);
var
  dH:double;
  BLNW,BLSO,tg:tgauss;

  Rpnt:array[1..4] of tgauss;
  KvRpnt:array[1..4] of tgauss;

  Gpnt,Gpnt2:array[1..4] of tgauss;
  BM,BMkv,BMSlant,BMNorm,B1,B2,B0,L0,BSW,LSW,LM,dlist,X0,Y0,dx,dy:double;
  BL:_geoid;
  i,sign:integer;

  sdm,sobj,sname:shortstring;
   SaveDlg:TSaveDialog;
   datsrc,dattag:Tdatum7;
   els,elt,initype:byte;
begin
case Cmbxprj.ItemIndex of
  0:initype:=0;
  1:initype:=3;
  2:initype:=1;
  3:initype:=6;   //коническая
  6,7,10,11,14,15,16:initype:=2;   //косые
  4,8,12, 17: initype:=4;  //Нормальные
  5,9,13 :initype:=5  //Поперечные
else
  initype:=0;
end;

 dattag.dx:=StrtoFloat(meTagdx.edittext, MyFormatSettings);
 dattag.dy:=StrtoFloat(meTagdy.edittext, MyFormatSettings);
 dattag.dz:=StrtoFloat(meTagdz.edittext, MyFormatSettings);
 dattag.wx:=StrtoFloat(meTagwx.edittext, MyFormatSettings);
 dattag.wy:=StrtoFloat(meTagwy.edittext, MyFormatSettings);
 dattag.wz:=StrtoFloat(meTagwz.edittext, MyFormatSettings);
 dattag.m:=StrtoFloat(meTagm.edittext, MyFormatSettings);
 elt:=CBoxTagCrd.ItemIndex+1;
 if elt<1 then elt:=1;
 If cmbxprj.ItemIndex<>2 then begin
 els:=CBoxSrcCrd.ItemIndex+1;
 case initype of
 0: begin   // Нормальная меркатора
 if els<1 then els:=1;
 if (MeBnd.edittext[1]='-') or (strtoint(meBND.edittext)<0)  then sign:=-1 else sign:=1;
    BLNW.X:=(strtoint(meBND.edittext)+sign*strtoint(meBNM.edittext)/60+sign*strtoFloat(meBNS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeLWd.edittext[1]='-') or (strtoint(meLwd.edittext)<0)  then sign:=-1 else sign:=1;
    BLNW.Y:=(strtoint(meLWD.edittext)+sign*strtoint(meLWM.edittext)/60+sign*strtofloat(meLWS.edittext, MyFormatSettings)/3600)/180*PI;
 LM:= BLNW.Y;
 if (MeBSd.edittext[1]='-') or (strtoint(meBsd.edittext)<0)  then sign:=-1 else sign:=1;
    BLSO.X:=(strtoint(meBSD.edittext)+sign*strtoint(meBSM.edittext)/60+sign*strtofloat(meBSS.edittext, MyFormatSettings)/3600)/180*PI;
 if (meLED.edittext[1]='-') or (strtoint(meLED.edittext)<0)  then sign:=-1 else sign:=1;
    BLSO.Y:=(strtoint(meLED.edittext)+sign*strtoint(meLEM.edittext)/60+sign*strtofloat(meLES.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeBmd.edittext[1]='-') or (strtoint(meBmd.edittext)<0)  then sign:=-1 else sign:=1;
   BM:=(strtoint(meBMD.edittext)+sign*strtoint(meBMM.edittext)/60+sign*strtofloat(meBMS.edittext, MyFormatSettings)/3600)/180*PI;
   datsrc.dx:=StrtoFloat(meSrcdx.edittext, MyFormatSettings);
   datsrc.dy:=StrtoFloat(meSrcdy.edittext, MyFormatSettings);
   datsrc.dz:=StrtoFloat(meSrcdz.edittext, MyFormatSettings);
   datsrc.wx:=StrtoFloat(meSrcwx.edittext, MyFormatSettings);
   datsrc.wy:=StrtoFloat(meSrcwy.edittext, MyFormatSettings);
   datsrc.wz:=StrtoFloat(meSrcwz.edittext, MyFormatSettings);
   datsrc.m:=StrtoFloat(meSrcM.edittext, MyFormatSettings);
 if (els<>elt) or (datsrc.dx<>dattag.DX)or (datsrc.dy<>dattag.Dy)or (datsrc.dz<>dattag.Dz)
               or (datsrc.wx<>dattag.wX)or (datsrc.wy<>dattag.wy)or (datsrc.wz<>dattag.wz)
               or (datsrc.m<>dattag.m) then begin
   BLH_BLH_7(BLNW.X,BLNW.y,0,els,elt,datsrc,dattag,RPNT[1].X,RPNT[1].y, dH);
   BLH_BLH_7(BLNW.X,BLSO.Y,0,els,elt,datsrc,dattag,RPNT[2].X,RPNT[2].y, dH);
   BLH_BLH_7(BLSO.X,BLSO.Y,0,els,elt,datsrc,dattag,RPNT[3].X,RPNT[3].y, dH);
   BLH_BLH_7(BLSO.X,BLNW.Y,0,els,elt,datsrc,dattag,RPNT[4].X,RPNT[4].y, dH);
   BLH_BLH_7(Bm,Lm,0,els,elt,datsrc,dattag,Bm,Lm, dH);
end ELSE BEGIN
  RPNT[1].X:=BLNW.X;
  RPNT[1].y:=BLNW.y;
  RPNT[2].X:=BLNW.X;
  RPNT[2].y:=BLSO.Y;
  RPNT[3].X:=BLSO.X;
  RPNT[3].y:=BLSO.Y;
  RPNT[4].X:=BLSO.X;
  RPNT[4].y:=BLnw.Y;
END;
end;

2: begin // косые проекции
 if (MeB0d.edittext[1]='-') or (strtoint(meB0D.edittext)<0)  then sign:=-1 else sign:=1;
    B0:=(strtoint(meB0D.edittext)+sign*strtoint(meB0M.edittext)/60+sign*strtoFloat(meB0S.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeL0d.edittext[1]='-') or (strtoint(meL0D.edittext)<0)  then sign:=-1 else sign:=1;
    L0:=(strtoint(meL0D.edittext)+sign*strtoint(meL0M.edittext)/60+sign*strtoFloat(meL0S.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeBmnd.edittext[1]='-') or (strtoint(meBmnd.edittext)<0)  then sign:=-1 else sign:=1;
   BMSlant:=(strtoint(meBMnD.edittext)+sign*strtoint(meBMnM.edittext)/60+sign*strtofloat(meBMnS.edittext, MyFormatSettings)/3600)/180*PI;
  X0:=Strtofloat(edX0.Text, MyFormatSettings);
  Y0:=Strtofloat(edY0.Text, MyFormatSettings);
  DX:=Strtofloat(edDX.Text, MyFormatSettings);
  DY:=Strtofloat(edDY.Text, MyFormatSettings);

end;
3: begin  // поперечная меркатора
 if (MeBndKV.edittext[1]='-') or (strtoint(meBNDKV.edittext)<0)  then sign:=-1 else sign:=1;
    BLNW.X:=(strtoint(meBNDKV.edittext)+sign*strtoint(meBNMKV.edittext)/60+sign*strtoFloat(meBNSKV.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeLWdKV.edittext[1]='-') or (strtoint(meLwdKV.edittext)<0)  then sign:=-1 else sign:=1;
    BLNW.Y:=(strtoint(meLWDKV.edittext)+sign*strtoint(meLWMKV.edittext)/60+sign*strtofloat(meLWSKV.edittext, MyFormatSettings)/3600)/180*PI;
 LM:= BLNW.Y;
 if (MeBSdKV.edittext[1]='-') or (strtoint(meBsdKV.edittext)<0)  then sign:=-1 else sign:=1;
    BLSO.X:=(strtoint(meBSDKV.edittext)+sign*strtoint(meBSMKV.edittext)/60+sign*strtofloat(meBSSKV.edittext, MyFormatSettings)/3600)/180*PI;
 if (meLEDKV.edittext[1]='-') or (strtoint(meLEDKV.edittext)<0)  then sign:=-1 else sign:=1;
    BLSO.Y:=(strtoint(meLEDKV.edittext)+sign*strtoint(meLEMKV.edittext)/60+sign*strtofloat(meLESKV.edittext)/3600)/180*PI;
 if (MeBmdKV.edittext[1]='-') or (strtoint(meBmdKV.edittext)<0)  then sign:=-1 else sign:=1;
  BMKv:=(strtoint(meBMDKV.edittext)+sign*strtoint(meBMMKV.edittext)/60+sign*strtofloat(meBMSKV.edittext)/3600)/180*PI;
  KvRPNT[1].X:=BLNW.X;
  KvRPNT[1].y:=BLNW.y;
  KvRPNT[2].X:=BLNW.X;
  KvRPNT[2].y:=BLSO.Y;
  KvRPNT[3].X:=BLSO.X;
  KvRPNT[3].y:=BLSO.Y;
  KvRPNT[4].X:=BLSO.X;
  KvRPNT[4].y:=BLnw.Y;
end;
4: begin  //нормальные проекции
 if (MeBNormSWd.edittext[1]='-') or (strtoint(meBNormSWD.edittext)<0)  then sign:=-1 else sign:=1;
    BSW:=(strtoint(meBNormSWD.edittext)+sign*strtoint(meBNormSWM.edittext)/60+sign*strtoFloat(meBNormSWS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeLNormSWd.edittext[1]='-') or (strtoint(meLNormSWD.edittext)<0)  then sign:=-1 else sign:=1;
    LSW:=(strtoint(meLNormSWD.edittext)+sign*strtoint(meLNormSWM.edittext)/60+sign*strtoFloat(meLNormSWS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeLNorm0d.edittext[1]='-') or (strtoint(meLNorm0D.edittext)<0)  then sign:=-1 else sign:=1;
    L0:=(strtoint(meLNorm0D.edittext)+sign*strtoint(meLNorm0M.edittext)/60+sign*strtoFloat(meLNorm0S.edittext, MyFormatSettings)/3600)/180*PI;

 if (MeBnNormd.edittext[1]='-') or (strtoint(meBnNormd.edittext)<0)  then sign:=-1 else sign:=1;
   BMNorm:=(strtoint(meBnNormD.edittext)+sign*strtoint(meBnNormM.edittext)/60+sign*strtofloat(meBnNormS.edittext, MyFormatSettings)/3600)/180*PI;
  X0:=Strtofloat(edX0Norm.Text, MyFormatSettings);
  Y0:=Strtofloat(edY0Norm.Text, MyFormatSettings);
  DX:=Strtofloat(edDXNorm.Text, MyFormatSettings);
  DY:=Strtofloat(edDYNorm.Text, MyFormatSettings);
end;
5: begin  //Поперечные проекции
 if (MeBCrossSWd.edittext[1]='-') or (strtoint(meBCrossSWD.edittext)<0)  then sign:=-1 else sign:=1;
    BSW:=(strtoint(meBCrossSWD.edittext)+sign*strtoint(meBCrossSWM.edittext)/60+sign*strtoFloat(meBCrossSWS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeLCrossSWd.edittext[1]='-') or (strtoint(meLCrossSWD.edittext)<0)  then sign:=-1 else sign:=1;
    LSW:=(strtoint(meLCrossSWD.edittext)+sign*strtoint(meLCrossSWM.edittext)/60+sign*strtoFloat(meLCrossSWS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeL0Crossd.edittext[1]='-') or (strtoint(meL0CrossD.edittext)<0)  then sign:=-1 else sign:=1;
    L0:=(strtoint(meL0CrossD.edittext)+sign*strtoint(meL0CrossM.edittext)/60+sign*strtoFloat(meL0CrossS.edittext, MyFormatSettings)/3600)/180*PI;

  DX:=Strtofloat(edDXCross.Text, MyFormatSettings);
  DY:=Strtofloat(edDYCross.Text, MyFormatSettings);
end;
6: begin  //Коническая
 if RGconus.ItemIndex=1 then begin
   if (MeBConSWd.edittext[1]='-') or (strtoint(meBConSWD.edittext)<0)  then sign:=-1 else sign:=1;
      BSW:=(strtoint(meBConSWD.edittext)+sign*strtoint(meBConSWM.edittext)/60+sign*strtoFloat(meBConSWS.edittext, MyFormatSettings)/3600)/180*PI;
   if (MeLConSWd.edittext[1]='-') or (strtoint(meLConSWD.edittext)<0)  then sign:=-1 else sign:=1;
      LSW:=(strtoint(meLConSWD.edittext)+sign*strtoint(meLConSWM.edittext)/60+sign*strtoFloat(meLConSWS.edittext, MyFormatSettings)/3600)/180*PI;
 end;

 if (MeLCon0d.edittext[1]='-') or (strtoint(meLCon0D.edittext)<0)  then sign:=-1 else sign:=1;
    L0:=(strtoint(meLCon0D.edittext)+sign*strtoint(meLCon0M.edittext)/60+sign*strtoFloat(meLCon0S.edittext, MyFormatSettings)/3600)/180*PI;

 if (MeB1Cond.edittext[1]='-') or (strtoint(meB1Cond.edittext)<0)  then sign:=-1 else sign:=1;
   B1:=(strtoint(meB1ConD.edittext)+sign*strtoint(meB1ConM.edittext)/60+sign*strtofloat(meB1ConS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeB2Cond.edittext[1]='-') or (strtoint(meB2Cond.edittext)<0)  then sign:=-1 else sign:=1;
   B2:=(strtoint(meB2ConD.edittext)+sign*strtoint(meB2ConM.edittext)/60+sign*strtofloat(meB2ConS.edittext, MyFormatSettings)/3600)/180*PI;
  DX:=Strtofloat(edConDX.Text);
  DY:=Strtofloat(edConDY.Text);
 if RGconus.ItemIndex=0 then begin
  Gpnt[4].X:=StrtoFloat(meXSConus.edittext, MyFormatSettings);
  Gpnt[4].Y:=StrtoFloat(meYWConus.edittext, MyFormatSettings);
 end;

end;

end;
end;
case cmbxprj.ItemIndex of
0: begin
if RPNT[2].y<RPNT[1].y then begin
  RPNT[2].y:=RPNT[2].y+2*Pi;
  RPNT[3].y:=RPNT[3].y+2*Pi;
end;
for i:=1 to 4 do
  BL_to_XY(RPNT[i].X,RPNT[i].y,0,bm,0,elt,3,Gpnt[i].X,GPNT[i].Y);
{if RPNT[2].y>Pi then begin

  RPNT[2].y:=RPNT[2].y+2*Pi;
  RPNT[3].y:=RPNT[3].y+2*Pi;
end;
}
end;
1: begin //поперечный Меркатор
Init_Mcross(BmKv,Strtofloat(edRCrossMerc.Text, MyFormatSettings));
for i:=1 to 4 do begin
 mCross_kvBL_XY(kvRPNT[i].X,kvRPNT[i].y,Gpnt[i].X,GPNT[i].Y);
 mCross_kvBL_BL(kvRPNT[i].X,kvRPNT[i].y,RPNT[i].X,RPNT[i].y);
end;
end;
2: Begin  //Гаусса
 if (MeLmd.edittext[1]='-') or (strtoint(meLmd.edittext)<0)  then sign:=-1 else sign:=1;

 LM:=(strtoint(meLMD.edittext)+sign*strtoint(meLMM.edittext)/60+sign*strtofloat(meLMS.edittext, MyFormatSettings)/3600)/180*PI;
Gpnt[1].X:=StrtoFloat(meXN.edittext, MyFormatSettings);
Gpnt[4].X:=StrtoFloat(meXS.edittext, MyFormatSettings);
Gpnt[1].Y:=StrtoFloat(meYW.edittext, MyFormatSettings);
Gpnt[2].Y:=StrtoFloat(meYE.edittext, MyFormatSettings);
Gpnt[4].Y:=Gpnt[1].Y;
Gpnt[3].Y:=Gpnt[2].Y;
Gpnt[2].X:=Gpnt[1].X;
Gpnt[3].X:=Gpnt[4].X;
L_nul:=LM;
head.zone:=trunc(30*l_nul/Pi)+1;
if Gpnt[2].y>50000 then begin
XY_BL_main(Gpnt[1],BL);
RPNT[1].X:=Bl.b;
RPNT[1].Y:=Bl.L;
XY_BL_main(Gpnt[2],BL);
RPNT[2].X:=Bl.b;
RPNT[2].Y:=Bl.L;
XY_BL_main(Gpnt[3],BL);
RPNT[3].X:=Bl.b;
RPNT[3].Y:=Bl.L;
XY_BL_main(Gpnt[4],BL);
RPNT[4].X:=Bl.b;
RPNT[4].Y:=Bl.L;
end else begin
XY_to_BL(Gpnt[1].X,Gpnt[1].Y, LM,0,0,elt,1,RPNT[1].X,RPNT[1].y);
XY_to_BL(Gpnt[2].X,Gpnt[2].Y, LM,0,0,elt,1,RPNT[2].X,RPNT[2].y);
XY_to_BL(Gpnt[3].X,Gpnt[3].Y, LM,0,0,elt,1,RPNT[3].X,RPNT[3].y);
XY_to_BL(Gpnt[4].X,Gpnt[4].Y, LM,0,0,elt,1,RPNT[4].X,RPNT[4].y);
end;

end;
3: begin
   Conus_Init(b1,b2,l0);
    case rgScale.ItemIndex of
 0,2:   case CmbxScale.ItemIndex of
         0: iscale:=1000;
         1: iscale:=1500;
         2: Iscale:=2000;
         3: Iscale:=2500;
         4: Iscale:=3000;
         5: Iscale:=4000;
         6: Iscale:=5000;
         7: Iscale:=6000;
         8: Iscale:=7000;
         9: Iscale:=7500;
         10: Iscale:=10000;
         11: Iscale:=12500;
         12: Iscale:=15000;
         13: Iscale:=12500;
         14: Iscale:=20000;
         15: Iscale:=25000;
         16: Iscale:=30000;
         17: Iscale:=37500;
         18: Iscale:=40000;
         19: Iscale:=50000;
         20: Iscale:=75000;
         21: Iscale:=100000;
         22: Iscale:=150000;
         23: Iscale:=200000;
         24: Iscale:=250000;
         25: Iscale:=300000;
         26: Iscale:=500000;
         27: Iscale:=750000;
         28: Iscale:=1000000;
         29: Iscale:=1500000;
         30: Iscale:=2000000;
         31: Iscale:=2500000;
         32: Iscale:=3000000;
         33: Iscale:=5000000;
         34: Iscale:=10000000;
        else
        Iscale:=500
          end;
 1:
 Iscale:=Strtoint(edScale.text);
 end;
 if RGconus.ItemIndex=1 then begin
   Conus_BL_XY(BSW,LSW,GPNT[4].x,GPNT[4].y);
   RPNT[4].x:=BSW;
   RPNT[4].Y:=LSW;
 end;
 GPNT[1].x:=GPNT[4].X+DX*Iscale*0.001;
 GPNT[1].Y:=GPNT[4].Y;
 GPNT[3].x:=GPNT[4].X;
 GPNT[3].Y:=GPNT[4].Y+DY*Iscale*0.001;
 GPNT[2].x:=GPNT[1].X;
 GPNT[2].Y:=GPNT[3].Y;
  if RGconus.ItemIndex=0 then
   Conus_XY_BL(GPNT[4].x,GPNT[4].y,RPNT[4].x,RPNT[4].y);

 for i:=1 to 3 do begin
 Conus_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
 end;
{ RPNT[4].x:=BSW;
 RPNT[4].y:=LSW;
 }

end;
6,7,10,11,14,15,16: begin //Косые проекции
 case cmbxprj.ItemIndex of
   6:Init_SlantingGnomon(BMSlant,b0,L0);
   7:Init_PolarSlantingGnomon(BMSlant,b0,L0,Strtofloat(edRSlant.Text, MyFormatSettings));
   10:Init_SlantingStereograf(BMSlant,b0,L0);
   11:Init_PolarSlantingStereograf(BMSlant,b0,L0,Strtofloat(edRSlant.Text, MyFormatSettings));
   14:Init_SlantingPostel(BMSlant,b0,L0);
   15:Init_PolarSlantingPostel(BMSlant,b0,L0,Strtofloat(edRSlant.Text, MyFormatSettings));
   16:Init_SlantingLambert(b0,L0);
 end;
 case rgScale.ItemIndex of
 0,2:   case CmbxScale.ItemIndex of
         0: iscale:=1000;
         1: iscale:=1500;
         2: Iscale:=2000;
         3: Iscale:=2500;
         4: Iscale:=3000;
         5: Iscale:=4000;
         6: Iscale:=5000;
         7: Iscale:=6000;
         8: Iscale:=7000;
         9: Iscale:=7500;
         10: Iscale:=10000;
         11: Iscale:=12500;
         12: Iscale:=15000;
         13: Iscale:=12500;
         14: Iscale:=20000;
         15: Iscale:=25000;
         16: Iscale:=30000;
         17: Iscale:=37500;
         18: Iscale:=40000;
         19: Iscale:=50000;
         20: Iscale:=75000;
         21: Iscale:=100000;
         22: Iscale:=150000;
         23: Iscale:=200000;
         24: Iscale:=250000;
         25: Iscale:=300000;
         26: Iscale:=500000;
         27: Iscale:=750000;
         28: Iscale:=1000000;
         29: Iscale:=1500000;
         30: Iscale:=2000000;
         31: Iscale:=2500000;
         32: Iscale:=3000000;
         33: Iscale:=5000000;
         34: Iscale:=10000000;
        else
        Iscale:=500
          end;
 1:
 Iscale:=Strtoint(edScale.text);
 end;
 GPNT[4].x:=-X0*Iscale*0.001;
 GPNT[4].Y:=-Y0*Iscale*0.001;
 GPNT[1].x:=GPNT[4].X+DX*Iscale*0.001;
 GPNT[1].Y:=GPNT[4].Y;
 GPNT[3].x:=GPNT[4].X;
 GPNT[3].Y:=GPNT[4].Y+DY*Iscale*0.001;
 GPNT[2].x:=GPNT[1].X;
 GPNT[2].Y:=GPNT[3].Y;
 for i:=1 to 4 do begin
  case cmbxprj.ItemIndex of
   6: SlantingGnomon_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   7: PolarSlantingGnomon_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   10: SlantingStereograf_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   11:PolarSlantingStereograf_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   14:SlantingPostel_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   15:PolarSlantingPostel_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   16:SlantingLambert_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
 end;
{ Rad_grad (RPNT[i].x,grad,min,sec);
  Showmessage('B:'+FormatFloat('0',grad) +
              ' '+FormatFloat('0',Min)+
              ' '+FormatFloat('0.0000',sec));

  Rad_grad (RPNT[i].y,grad,min,sec);
   Showmessage('L:'+FormatFloat('0',grad) +
              ' '+FormatFloat('0',Min)+
              ' '+FormatFloat('0.0000',sec));
 }
 end;
 {if cmbxprj.ItemIndex=15 then
   for i:=1 to 4 do
    PolarSlantingPostel_BL_XY(RPNT[i].x,RPNT[i].y,KvRpnt[i].x,KvRpnt[i].y);
 show;
}
end;
4,8,12, 17: begin //Прямые
   case cmbxprj.ItemIndex of
   4:Init_NormGnomon(BMNorm,L0,Strtofloat(edRNorm.Text, MyFormatSettings),chbxMirr.checked);
   8:Init_NormStereograf(BMNorm,L0,Strtofloat(edRNorm.Text, MyFormatSettings),chbxMirr.checked);
   12:Init_NormPostel(BMNorm,L0,Strtofloat(edRNorm.Text, MyFormatSettings),chbxMirr.checked);
  end;


 case rgScale.ItemIndex of
 0,2:   case CmbxScale.ItemIndex of
         0: iscale:=1000;
         1: iscale:=1500;
         2: Iscale:=2000;
         3: Iscale:=2500;
         4: Iscale:=3000;
         5: Iscale:=4000;
         6: Iscale:=5000;
         7: Iscale:=6000;
         8: Iscale:=7000;
         9: Iscale:=7500;
         10: Iscale:=10000;
         11: Iscale:=12500;
         12: Iscale:=15000;
         13: Iscale:=12500;
         14: Iscale:=20000;
         15: Iscale:=25000;
         16: Iscale:=30000;
         17: Iscale:=37500;
         18: Iscale:=40000;
         19: Iscale:=50000;
         20: Iscale:=75000;
         21: Iscale:=100000;
         22: Iscale:=150000;
         23: Iscale:=200000;
         24: Iscale:=250000;
         25: Iscale:=300000;
         26: Iscale:=500000;
         27: Iscale:=750000;
         28: Iscale:=1000000;
         29: Iscale:=1500000;
         30: Iscale:=2000000;
         31: Iscale:=2500000;
         32: Iscale:=3000000;
         33: Iscale:=5000000;
         34: Iscale:=10000000;
        else
        Iscale:=500
          end;
 1:
 Iscale:=Strtoint(edScale.text);
 end;
 if BMNorm>0 then begin
 GPNT[4].x:=-X0*Iscale*0.001;
 GPNT[4].Y:=-Y0*Iscale*0.001;
 GPNT[1].x:=GPNT[4].X+DX*Iscale*0.001;
 GPNT[1].Y:=GPNT[4].Y;
 GPNT[3].x:=GPNT[4].X;
 GPNT[3].Y:=GPNT[4].Y+DY*Iscale*0.001;
 GPNT[2].x:=GPNT[1].X;
 GPNT[2].Y:=GPNT[3].Y;
 end else begin
   GPNT[1].x:=X0*Iscale*0.001;
   GPNT[1].Y:=-Y0*Iscale*0.001;
   GPNT[4].x:=GPNT[1].X-DX*Iscale*0.001;
   GPNT[4].Y:=GPNT[1].Y;
   GPNT[3].x:=GPNT[4].X;
   GPNT[3].Y:=GPNT[4].Y+DY*Iscale*0.001;
   GPNT[2].x:=GPNT[1].X;
   GPNT[2].Y:=GPNT[3].Y;
 end;
  if ChBXleftbott.Checked then begin
     case cmbxprj.ItemIndex of
       4:begin
         NormGnomon_XY_BL(GPNT[4].x,GPNT[4].y,RPNT[4].x,RPNT[4].y);
         NormGnomon_BL_XY(BSW,RPNT[4].y,tg.x,tg.y);
         NormGnomon.R0:=NormGnomon.R0/sqrt(SQR(tg.x)+SQR(tg.y))*sqrt(SQR(GPNT[4].x)+SQR(GPNT[4].y));
       end;
       8:begin
         NormStereograf_XY_BL(GPNT[4].x,GPNT[4].y,RPNT[4].x,RPNT[4].y);
         NormStereograf_BL_XY(BSW,RPNT[4].y,tg.x,tg.y);
         Normstereograf.R0:=Normstereograf.R0/sqrt(SQR(tg.x)+SQR(tg.y))*sqrt(SQR(GPNT[4].x)+SQR(GPNT[4].y));
       end;
       12:begin
         NormPostel_XY_BL(GPNT[4].x,GPNT[4].y,RPNT[4].x,RPNT[4].y);
         NormPostel_BL_XY(BSW,RPNT[4].y,tg.x,tg.y);
         NormPostel.R0:=NormPostel.R0/sqrt(SQR(tg.x)+SQR(tg.y))*sqrt(SQR(GPNT[4].x)+SQR(GPNT[4].y));
       end;

     end;
 end;

 for i:=1 to 4 do begin
   case cmbxprj.ItemIndex of
     4: NormGnomon_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
     8: NormStereograf_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
     12: NormPostel_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
     17:frNavyfun.XY_to_BL(GPNT[i].x,GPNT[i].y, L0, BMNorm, 0, elt, 33,  RPNT[i].x,RPNT[i].y);
   end;
 end;

 for i:=1 to 4 do begin
   case cmbxprj.ItemIndex of
     4: NormGnomon_BL_XY(RPNT[i].x,RPNT[i].y,gPNT2[i].x,gPNT2[i].y);
     8: NormStereograf_BL_XY(RPNT[i].x,RPNT[i].y,gPNT2[i].x,gPNT2[i].y);
     12: NormPostel_BL_XY(RPNT[i].x,RPNT[i].y,gPNT2[i].x,gPNT2[i].y);
     17: frNavyfun.BL_to_XY(RPNT[i].x,RPNT[i].y, L0, BMNorm, 0, elt, 33,  gPNT2[i].x,gPNT2[i].y);
   end;
 end;


{ case cmbxprj.ItemIndex of
     4: NormGnomon_BL_XY(BSW,LSW,GPNT[4].x,GPNT[4].y);
     8: NormStereograf_BL_XY(BSW,LSW,GPNT[4].x,GPNT[4].y);
     12: NormPostel_BL_XY(BSW,LSW,GPNT[4].x,GPNT[4].y);
   end;
 GPNT[1].x:=GPNT[4].X+DX*Iscale*0.001;
 GPNT[1].Y:=GPNT[4].Y;
 GPNT[3].x:=GPNT[4].X;
 GPNT[3].Y:=GPNT[4].Y+DY*Iscale*0.001;
 GPNT[2].x:=GPNT[1].X;
 GPNT[2].Y:=GPNT[3].Y;
 for i:=1 to 3 do begin
   case cmbxprj.ItemIndex of
     4: NormGnomon_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
     8: NormStereograf_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
     12: NormPostel_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   end;
 end;
 RPNT[4].x:=BSW;
 RPNT[4].y:=LSW;
}
end;
5,9,13: begin //Поперечные
   case cmbxprj.ItemIndex of
   5:Init_CrossGnomon(L0);
   9:Init_CrossStereograf(L0);
   13:Init_CrossPostel(L0);
  end;
 case rgScale.ItemIndex of
 0,2:   case CmbxScale.ItemIndex of
         0: iscale:=1000;
         1: iscale:=1500;
         2: Iscale:=2000;
         3: Iscale:=2500;
         4: Iscale:=3000;
         5: Iscale:=4000;
         6: Iscale:=5000;
         7: Iscale:=6000;
         8: Iscale:=7000;
         9: Iscale:=7500;
         10: Iscale:=10000;
         11: Iscale:=12500;
         12: Iscale:=15000;
         13: Iscale:=12500;
         14: Iscale:=20000;
         15: Iscale:=25000;
         16: Iscale:=30000;
         17: Iscale:=37500;
         18: Iscale:=40000;
         19: Iscale:=50000;
         20: Iscale:=75000;
         21: Iscale:=100000;
         22: Iscale:=150000;
         23: Iscale:=200000;
         24: Iscale:=250000;
         25: Iscale:=300000;
         26: Iscale:=500000;
         27: Iscale:=750000;
         28: Iscale:=1000000;
         29: Iscale:=1500000;
         30: Iscale:=2000000;
         31: Iscale:=2500000;
         32: Iscale:=3000000;
         33: Iscale:=5000000;
         34: Iscale:=10000000;
        else
        Iscale:=500
          end;
 1:
 Iscale:=Strtoint(edScale.text);
 end;
  case cmbxprj.ItemIndex of
     5: CrossGnomon_BL_XY(BSW,LSW,GPNT[4].x,GPNT[4].y);
     9: CrossStereograf_BL_XY(BSW,LSW,GPNT[4].x,GPNT[4].y);
     13: CrossPostel_BL_XY(BSW,LSW,GPNT[4].x,GPNT[4].y);
   end;
 RPNT[4].x:=BSW;
 RPNT[4].y:=LSW;

 GPNT[1].x:=GPNT[4].X+DX*Iscale*0.001;
 GPNT[1].Y:=GPNT[4].Y;
 GPNT[3].x:=GPNT[4].X;
 GPNT[3].Y:=GPNT[4].Y+DY*Iscale*0.001;
 GPNT[2].x:=GPNT[1].X;
 GPNT[2].Y:=GPNT[3].Y;
 for i:=1 to 3 do begin
   case cmbxprj.ItemIndex of
     5: CrossGnomon_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
     9: CrossStereograf_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
     13: CrossPostel_XY_BL(GPNT[i].x,GPNT[i].y,RPNT[i].x,RPNT[i].y);
   end;
 end;
end;
end;

{if cmbxprj.ItemIndex=1 then begin
 Showmessage('dx= '+Formatfloat('0.0000',(Gpnt[1].X-Gpnt[3].X)/5000));
 Showmessage('dy= '+Formatfloat('0.0000',(Gpnt[2].Y-Gpnt[1].Y)/5000));
 exit;
end;
}
 rn.map_a.x:=0;
 rn.map_a.y:=0;
 rn.map_b.x:=round((Gpnt[2].Y-Gpnt[1].Y)*10);
 rn.map_b.y:=round((Gpnt[1].X-Gpnt[3].X)*10);

with rn do begin
   Tlfr.n:=4;
   Tlfr.pol[0].x:=rn.map_a.x;
   Tlfr.pol[0].y:=rn.map_b.y;
   Tlfr.pol[1]:=rn.map_a;
   Tlfr.pol[2].x:=rn.map_b.x;
   Tlfr.pol[2].y:=rn.map_a.y;
   Tlfr.pol[3]:=rn.map_b;
   Tlfr.pol[4]:=TLfr.pol[0];
end;

 SaveDlg:=TSaveDialog.Create(FSeaFrm);
 SaveDlg.Title:='Выбор имени карты';
 SaveDlg.Filter := 'Файлы (*.DM)|*.dm';
 SaveDlg.FilterIndex := 1;
 SaveDlg.DefaultExt:='dm';
 SaveDlg.InitialDir:=dirdm;

 if not SaveDLG.Execute then begin
   exit
 end;
 sdm:=SaveDlg.FileName;

 SaveDlg.Destroy;
 dirdm:=ExtractFileDir(sdm);
 if FileExists(sdm) then
   if MessageDlg('Файл уже существует. Переписать?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNO then begin
    dmw_done;
    exit
 end;
 sdm:=UTF8ToWinCP(sdm);
 case rgScale.ItemIndex of
 0:   case CmbxScale.ItemIndex of
         0: iscale:=1000;
         1: iscale:=1500;
         2: Iscale:=2000;
         3: Iscale:=2500;
         4: Iscale:=3000;
         5: Iscale:=4000;
         6: Iscale:=5000;
         7: Iscale:=6000;
         8: Iscale:=7000;
         9: Iscale:=7500;
         10: Iscale:=10000;
         11: Iscale:=12500;
         12: Iscale:=15000;
         13: Iscale:=12500;
         14: Iscale:=20000;
         15: Iscale:=25000;
         16: Iscale:=30000;
         17: Iscale:=37500;
         18: Iscale:=40000;
         19: Iscale:=50000;
         20: Iscale:=75000;
         21: Iscale:=100000;
         22: Iscale:=150000;
         23: Iscale:=200000;
         24: Iscale:=250000;
         25: Iscale:=300000;
         26: Iscale:=500000;
         27: Iscale:=750000;
         28: Iscale:=1000000;
         29: Iscale:=1500000;
         30: Iscale:=2000000;
         31: Iscale:=2500000;
         32: Iscale:=3000000;
         33: Iscale:=5000000;
         34: Iscale:=10000000;
        else
        Iscale:=500
          end;

 1:
 Iscale:=Strtoint(edScale.text);
 2:
 begin
   try
   dlist:=StrtoFloat(edListWidth.text, MyFormatSettings);
   except
   dlist:=0;
   end;
   if dlist=0 then  begin
     Showmessage('Неправильно указана ширина листа. Создание листа прервано.');
     exit;
   end;
   iscale:=round( sqrt(sqr(Gpnt[2].x-Gpnt[1].x)+ sqr(Gpnt[2].Y-Gpnt[1].Y))/Dlist*1000)
 end
 end;

 sdm:=sdm+#0;
   if edObj.text<>'' then begin
       sobj:=edObj.text;
   end else
       sobj:='s57m.obj';
 sobj:=sobj+#0;
 dm_Frame(@sdm[1],@sobj[1],0,10,0,0,rn.TLfr.pol[3].y/10,rn.TLfr.pol[3].x/10);
 {dm_frame(@sdm[1],@sobj[1],0,10,0,0,5000,5000);
 exit;
 }
 if dm_open(@sdm[1],true)<>0 then begin
 dm_goto_root;
 // Прописывается  габариты карты
 dm_Set_Poly_buf(@rn.TLfr);
// Определяется ,что это карта
 Dm_Put_word(999,1);
 dm_put_byte(901,1);
// Записывается масштаб карты
 Dm_Put_long(904,Iscale);
// Заисывается номер эллипсоида
 Dm_Put_byte(911,elt);
// Записываются параметры эллипсоида
 Dm_Put_double(995,dattag.dx);
 Dm_Put_double(996,dattag.dy);
 Dm_Put_double(997,dattag.dz);
 Dm_Put_double(1015,dattag.wx);
 Dm_Put_double(1016,dattag.wy);
 Dm_Put_double(1017,dattag.wz);
 Dm_Put_double(1018,dattag.m);

 case cmbxprj.ItemIndex of
0: begin    // Нормальная равноугольная цилиндрическая проекция Меркатора
 // Номер проекции в dm
 Dm_Put_byte(913,3);

 // Опорная широта проекции
 Dm_Put_double(991,BM);
end;
1: begin    // Поперечная равноугольная цилиндрическая проекция Меркатора
 // Номер проекции в dm
 Dm_Put_byte(913,9);
 // Опорная широта проекции
 Dm_Put_double(991,BMkv);
 Dm_Put_double(994,Strtofloat(edRCrossMerc.Text, MyFormatSettings));
end;
2: begin  //Поперечная равноугольная цилиндрическая проекция Гаусса
 Dm_Put_byte(913,1);
 Dm_Put_double(993,LM);
end;
3: begin  //Коническая
 Dm_Put_byte(913,4);
 Dm_Put_double(991,B1);
 Dm_Put_double(992,B2);
 Dm_Put_double(993,L0);
end;

6,7,10,11,14,15,16: begin //Косые проекции
 // Номер проекции в dm
 case cmbxprj.ItemIndex of
  10:Dm_Put_byte(913,10);  // Азимутальная косая стереографическая  проекция
  11:Dm_Put_byte(913,11);  // Азимутальная косая стереографическая  проекция (полюс)
  6:Dm_Put_byte(913,18);  // Азимутальная косая гномоническая проекция
  7:Dm_Put_byte(913,19);  // Азимутальная косая гномоническая проекция (полюс)
  14:Dm_Put_byte(913,20);  // Азимутальная косая равнопромежуточная Постеля
  15:Dm_Put_byte(913,21);  // Азимутальная косая равнопромежуточная Постеля (полюс)
  16:Dm_Put_byte(913,25);  // Азимутальная косая равновеликая Ламберта
end;
 // Опорная широта проекции
 Dm_Put_double(991,BMSlant);
 Dm_Put_double(992,B0);
 Dm_Put_double(993,L0);
 case cmbxprj.ItemIndex of
  7,11,15:Dm_Put_double(994,Strtofloat(edRSlant.Text, MyFormatSettings));
 end;
end;
4,8,12, 17: begin    //нормальные проекции
 case cmbxprj.ItemIndex of
  4:if chbxmirr.checked then Dm_Put_byte(913,15) else Dm_Put_byte(913,14);  //  Азимутальная нормальная гномоническая  проекция
  8:if chbxmirr.checked then Dm_Put_byte(913,13) else Dm_Put_byte(913,12);  // Азимутальная нормальная стереографическая  проекция
  12:if chbxmirr.checked then Dm_Put_byte(913,23) else Dm_Put_byte(913,22);  // Азимутальная нормальная равнопромежуточная Постеля
  17: Dm_Put_byte(913,33);  // "Азимут. стереографическая (полюс)"
 end;

 Dm_Put_double(991,BMNorm);
 Dm_Put_double(993,L0);
 case cmbxprj.ItemIndex of
   4:Dm_Put_double(994,NormGnomon.R0);
   8:Dm_Put_double(994,NormStereograf.R0);
  12:Dm_Put_double(994,NormPostel.R0);
 end;
end;
5,9,13: begin    //поперечные проекции
 case cmbxprj.ItemIndex of
  5:Dm_Put_byte(913,17);  //  Азимутальная поперечная гномоническая  проекция
  9:Dm_Put_byte(913,16);  // Азимутальная поперечная стереографическая  проекция
  13:Dm_Put_byte(913,24);  // Азимутальная поперечная равнопромежуточная Постеля
 end;

 Dm_Put_double(993,L0);
end;
end;

   if edObj.text<>'' then begin
     sName:=edObj.text+#0;
     dm_put_string(903,@sname[1]);
   end;
 // Прописываются широты, долготы  в точки привязки
 i:=0;
 if dmx_find_frst_code(0,1)<>0 then
 repeat
 inc(i);
 if i>4 then break;
 case i of
 1: begin
  dm_Put_double(91,RPNT[4].X);
  dm_Put_double(92,RPNT[4].Y);
  if cmbxprj.ItemIndex=1 then begin
   dm_Put_double(93,kvRPNT[4].X);
   dm_Put_double(94,kvRPNT[4].Y);

  end;
  dm_Put_double(901,GPNT[4].X);
  dm_Put_double(902,GPNT[4].Y);
 end;
 2: begin
  dm_Put_double(91,RPNT[1].X);
  dm_Put_double(92,RPNT[1].Y);
   if cmbxprj.ItemIndex=1 then begin
   dm_Put_double(93,kvRPNT[1].X);
   dm_Put_double(94,kvRPNT[1].Y);

  end;

  dm_Put_double(901,GPNT[1].X);
  dm_Put_double(902,GPNT[1].Y);

 end;
 3: begin
  dm_Put_double(91,RPNT[2].X);
  dm_Put_double(92,RPNT[2].Y);
   if cmbxprj.ItemIndex=1 then begin
   dm_Put_double(93,kvRPNT[2].X);
   dm_Put_double(94,kvRPNT[2].Y);
  end;
  dm_Put_double(901,GPNT[2].X);
  dm_Put_double(902,GPNT[2].Y);
 end;
 4: begin
  dm_Put_double(91,RPNT[3].X);
  dm_Put_double(92,RPNT[3].Y);
  if cmbxprj.ItemIndex=1 then begin
   dm_Put_double(93,kvRPNT[3].X);
   dm_Put_double(94,kvRPNT[3].Y);
  end;
  dm_Put_double(901,GPNT[3].X);
  dm_Put_double(902,GPNT[3].Y);
 end;
 end;
 until dmx_find_next_code(0,1)=0;
dm_done;
 dm_open(@sdm[1],true);

dmx_find_frst_code(0,1);

 dm_goto_last;
 for i:=1 to 4 do
   dm_R_to_L(RPNT[i].x,RPNT[i].y,pcorn[i].x,pcorn[i].y);

   case cmbxprj.ItemIndex of
    4,8,12, 17: begin    //нормальные проекции
       if ChBxCircle.Checked then
         Mk_COVER_Circle
       else
         Mk_COVER;
    end;
   else
     Mk_COVER;
   end;
dm_goto_root;
dm_goto_down;
dm_add_layer(String2Code('A0000000'),0);
dm_add_layer(String2Code('B0000000'),0);
dm_add_layer(String2Code('C0000000'),0);
dm_add_layer(String2Code('D0000000'),0);
dm_add_layer(String2Code('E0000000'),0);
dm_add_layer(String2Code('H0000000'),0);
dm_add_layer(String2Code('I0000000'),0);
dm_add_layer(String2Code('J0000000'),0);
dm_add_layer(String2Code('K0000000'),0);
dm_add_layer(String2Code('L0000000'),0);
dm_add_layer(String2Code('M0000000'),0);
dm_add_layer(String2Code('N0000000'),0);
dm_add_layer(String2Code('O0000000'),0);
dm_add_layer(String2Code('P0000000'),0);
dm_add_layer(String2Code('Q0000000'),0);
dm_add_layer(String2Code('R0000000'),0);
dm_add_layer(String2Code('S0000000'),0);
dm_add_layer(String2Code('T0000000'),0);
dm_add_layer(String2Code('Y0000000'),0);
dm_add_layer(String2Code('S5700000'),0);
dm_add_layer(String2Code('W0000000'),0);
dm_add_layer(String2Code('Z0000000'),0);
dm_add_layer(String2Code('Z3000000'),0);
dm_done;
end;
 ShowMessage('Создан лист карты')
end;
var
 // BT:Tbutton;
 IniFile:TInifile;
procedure TFSeaFrm.FormCreate(Sender: TObject);
begin
  MyFormatSettings := DefaultFormatSettings;
  with MyFormatSettings Do begin
     ShortDateFormat:='dd.mm.yy';
     LongDateFormat:='dd.mm.yyyy';
     DateSeparator:='.';
     decimalseparator:='.';
  end;

dmw_connect;
Bin_dir:=ExtractFileDir(ParamSTR(0));
IniFile:=TIniFile.Create(make_ini('mk_seaFr.ini'));
CmBxPrj.ItemIndex:=0;
CmBxScale.ItemIndex:=0;
Height:=IniFile.ReadInteger('SEAFRAME','Form_Height',270);
Width:=IniFile.ReadInteger('SEAFRAME','Form_Width',400);
DirDm:=IniFile.ReadString('SEAFRAME','DIRDM',Bin_Dir);

CBoxSrcCrd.ItemIndex:=IniFile.ReadInteger('SEAFRAME','SrcCrd',1);
CBoxTagCrd.ItemIndex:=IniFile.ReadInteger('SEAFRAME','TagCrd',1);
CmBxScale.ItemIndex:=IniFile.ReadInteger('SEAFRAME','SCALE',0);
edScale.Text:=IniFile.ReadString('SEAFRAME','Scale','40000');
RGScale.ItemIndex:=IniFile.ReadInteger('SEAFRAME','RGSCALE',0);
EdListWidth.Text:=IniFile.ReadString('SEAFRAME','LISTWIDTH','400');
meBnd.EditText:=IniFile.ReadString('SEAFRAME','BND','059');
meBnm.EditText:=IniFile.ReadString('SEAFRAME','BNM','59');
meBns.EditText:=IniFile.ReadString('SEAFRAME','BNS','08');

meBsd.EditText:=IniFile.ReadString('SEAFRAME','BSD','059');
meBsm.EditText:=IniFile.ReadString('SEAFRAME','BSM','54');
meBss.EditText:=IniFile.ReadString('SEAFRAME','BSS','30');

meBmd.EditText:=IniFile.ReadString('SEAFRAME','BMD','057');
meBmm.EditText:=IniFile.ReadString('SEAFRAME','BMM','00');
meBms.EditText:=IniFile.ReadString('SEAFRAME','BMS','00');

meLWd.EditText:=IniFile.ReadString('SEAFRAME','LWD','0030');
meLWm.EditText:=IniFile.ReadString('SEAFRAME','LWM','08');
meLWs.EditText:=IniFile.ReadString('SEAFRAME','LWS','39');

meLED.EditText:=IniFile.ReadString('SEAFRAME','LOD','0030');
meLEM.EditText:=IniFile.ReadString('SEAFRAME','LOM','21');
meLES.EditText:=IniFile.ReadString('SEAFRAME','LOS','11');

meLmd.EditText:=IniFile.ReadString('SEAFRAME','LMD','0000');
meLmm.EditText:=IniFile.ReadString('SEAFRAME','LMM','00');
meLms.EditText:=IniFile.ReadString('SEAFRAME','LMS','00');

meXN.EditText:=IniFile.ReadString('SEAFRAME','XN','0');
meXS.EditText:=IniFile.ReadString('SEAFRAME','XS','0');
meYW.EditText:=IniFile.ReadString('SEAFRAME','YW','0');
meYE.EditText:=IniFile.ReadString('SEAFRAME','YE','0');

meBndkv.EditText:=IniFile.ReadString('SEAFRAME','BNDkv','010');
meBnmkv.EditText:=IniFile.ReadString('SEAFRAME','BNMkv','15');
meBnskv.EditText:=IniFile.ReadString('SEAFRAME','BNSkv','00');

meBsdkv.EditText:=IniFile.ReadString('SEAFRAME','BSDkv','007');
meBsmkv.EditText:=IniFile.ReadString('SEAFRAME','BSMkv','15');
meBsskv.EditText:=IniFile.ReadString('SEAFRAME','BSSkv','00');

meBmdkv.EditText:=IniFile.ReadString('SEAFRAME','BMDkv','080');
meBmmkv.EditText:=IniFile.ReadString('SEAFRAME','BMMkv','00');
meBmskv.EditText:=IniFile.ReadString('SEAFRAME','BMSkv','00');

meLWdkv.EditText:=IniFile.ReadString('SEAFRAME','LWDkv','0001');
meLWmkv.EditText:=IniFile.ReadString('SEAFRAME','LWMkv','35');
meLWskv.EditText:=IniFile.ReadString('SEAFRAME','LWSkv','00');

meLEdkv.EditText:=IniFile.ReadString('SEAFRAME','LEDkv','0005');
meLEmkv.EditText:=IniFile.ReadString('SEAFRAME','LEMkv','45');
meLEskv.EditText:=IniFile.ReadString('SEAFRAME','LESkv','00');

meB0d.EditText:=IniFile.ReadString('SEAFRAME','B0D','069');
meB0m.EditText:=IniFile.ReadString('SEAFRAME','B0M','00');
meB0s.EditText:=IniFile.ReadString('SEAFRAME','B0S','00');


meBmnd.EditText:=IniFile.ReadString('SEAFRAME','BMnD','070');
meBmnm.EditText:=IniFile.ReadString('SEAFRAME','BMnM','00');
meBmns.EditText:=IniFile.ReadString('SEAFRAME','BMnS','00');

meL0d.EditText:=IniFile.ReadString('SEAFRAME','L0D','0033');
meL0m.EditText:=IniFile.ReadString('SEAFRAME','L0M','00');
meL0s.EditText:=IniFile.ReadString('SEAFRAME','L0S','00');
EdX0.Text:=IniFile.ReadString('SEAFRAME','X0','500');
EdY0.Text:=IniFile.ReadString('SEAFRAME','Y0','500');
EdDX.Text:=IniFile.ReadString('SEAFRAME','DX','1000');
EdDY.Text:=IniFile.ReadString('SEAFRAME','DY','1000');

meBNormSWd.EditText:=IniFile.ReadString('SEAFRAME','BNormSWD','088');
meBNormSWm.EditText:=IniFile.ReadString('SEAFRAME','BNormSWM','50');
meBNormSWs.EditText:=IniFile.ReadString('SEAFRAME','BNormSWS','00');
meLNormSWd.EditText:=IniFile.ReadString('SEAFRAME','LNormSWD','0000');
meLNormSWm.EditText:=IniFile.ReadString('SEAFRAME','LNormSWM','00');
meLNormSWs.EditText:=IniFile.ReadString('SEAFRAME','LNormSWS','00');

meLNorm0d.EditText:=IniFile.ReadString('SEAFRAME','LNorm0D','0000');
meLNorm0m.EditText:=IniFile.ReadString('SEAFRAME','LNorm0M','00');
meLNorm0s.EditText:=IniFile.ReadString('SEAFRAME','LNorm0S','00');


meBNNormd.EditText:=IniFile.ReadString('SEAFRAME','BNNormD','080');
meBNNormm.EditText:=IniFile.ReadString('SEAFRAME','BNNormM','00');
meBNNorms.EditText:=IniFile.ReadString('SEAFRAME','BNNormS','00');

EdDXNorm.Text:=IniFile.ReadString('SEAFRAME','DXNorm','1000');
EdDYNorm.Text:=IniFile.ReadString('SEAFRAME','DYNorm','1000');
EdX0Norm.Text:=IniFile.ReadString('SEAFRAME','X0Norm','500');
EdY0Norm.Text:=IniFile.ReadString('SEAFRAME','Y0Norm','500');
ChBxMirr.Checked:=IniFile.ReadBool('SEAFRAME','NormMirror',false);
ChBXleftbott.Checked:=IniFile.ReadBool('SEAFRAME','ChBXleftbott',false);
ChBxCircle.Checked:=IniFile.ReadBool('SEAFRAME','ChBxCircle',false);


meBCrossSWd.EditText:=IniFile.ReadString('SEAFRAME','BCrossSWD','000');
meBCrossSWm.EditText:=IniFile.ReadString('SEAFRAME','BCrossSWM','00');
meBCrossSWs.EditText:=IniFile.ReadString('SEAFRAME','BCrossSWS','00');
meLCrossSWd.EditText:=IniFile.ReadString('SEAFRAME','LCrossSWD','0000');
meLCrossSWm.EditText:=IniFile.ReadString('SEAFRAME','LCrossSWM','00');
meLCrossSWs.EditText:=IniFile.ReadString('SEAFRAME','LCrossSWS','00');

meL0CrossD.EditText:=IniFile.ReadString('SEAFRAME','L0CrossD','0000');
meL0Crossm.EditText:=IniFile.ReadString('SEAFRAME','L0CrossM','00');
meL0Crosss.EditText:=IniFile.ReadString('SEAFRAME','L0CrossS','00');

EdDXCross.Text:=IniFile.ReadString('SEAFRAME','DXCross','1000');
EdDYCross.Text:=IniFile.ReadString('SEAFRAME','DYCross','1000');

EdRCrossMerc.Text:=IniFile.ReadString('SEAFRAME','RCrossMerc','6398412');
EdRSlant.Text:=IniFile.ReadString('SEAFRAME','RSlant','6398412');
EdRNorm.Text:=IniFile.ReadString('SEAFRAME','RNorm','6398412');

meBConSWd.EditText:=IniFile.ReadString('SEAFRAME','BConSWD','030');
meBConSWm.EditText:=IniFile.ReadString('SEAFRAME','BConSWM','00');
meBConSWs.EditText:=IniFile.ReadString('SEAFRAME','BConSWS','00');
meLConSWd.EditText:=IniFile.ReadString('SEAFRAME','LConSWD','0000');
meLConSWm.EditText:=IniFile.ReadString('SEAFRAME','LConSWM','00');
meLConSWs.EditText:=IniFile.ReadString('SEAFRAME','LConSWS','00');

meLCon0D.EditText:=IniFile.ReadString('SEAFRAME','LCon0D','0000');
meLCon0m.EditText:=IniFile.ReadString('SEAFRAME','LCon0M','00');
meLCon0s.EditText:=IniFile.ReadString('SEAFRAME','LCon0S','00');

EdConDX.Text:=IniFile.ReadString('SEAFRAME','DXCon','1000');
EdConDY.Text:=IniFile.ReadString('SEAFRAME','DYCon','1000');

meXSconus.EditText:=IniFile.ReadString('SEAFRAME','XSCONUS','2525000');
meYWconus.EditText:=IniFile.ReadString('SEAFRAME','YWCONUS','0');
RGConus.ItemIndex:=IniFile.Readinteger('SEAFRAME','CONUSCHOICE',0);

meB1Cond.EditText:=IniFile.ReadString('SEAFRAME','B1ConD','030');
meB1Conm.EditText:=IniFile.ReadString('SEAFRAME','B1ConM','00');
meB1Cons.EditText:=IniFile.ReadString('SEAFRAME','B1ConS','00');
meB2Cond.EditText:=IniFile.ReadString('SEAFRAME','B2ConD','060');
meB2Conm.EditText:=IniFile.ReadString('SEAFRAME','B2ConM','00');
meB2Cons.EditText:=IniFile.ReadString('SEAFRAME','B2ConS','00');



//edAdmir.Text:=IniFile.ReadString('SEAFRAME','Admir','28030');
edObj.Text:=IniFile.ReadString('SEAFRAME','OBJ','s57m.obj');
meSrcDx.EditText:=IniFile.ReadString('ORIENT','SRCDX','0');
meSrcDy.EditText:=IniFile.ReadString('ORIENT','SRCDY','0');
meSrcDz.EditText:=IniFile.ReadString('ORIENT','SRCDZ','0');
meTagDx.EditText:=IniFile.ReadString('ORIENT','TAGDX','0');
meTagDy.EditText:=IniFile.ReadString('ORIENT','TAGDY','0');
meTagDz.EditText:=IniFile.ReadString('ORIENT','TAGDZ','0');

meSrcWx.EditText:=IniFile.ReadString('ORIENT','SRCWX','0');
meSrcWy.EditText:=IniFile.ReadString('ORIENT','SRCWY','0');
meSrcWz.EditText:=IniFile.ReadString('ORIENT','SRCWZ','0');
meTagWx.EditText:=IniFile.ReadString('ORIENT','TAGWX','0');
meTagWy.EditText:=IniFile.ReadString('ORIENT','TAGWY','0');
meTagWz.EditText:=IniFile.ReadString('ORIENT','TAGWZ','0');
meSrcM.EditText:=IniFile.ReadString('ORIENT','SRCM','0');
meTagM.EditText:=IniFile.ReadString('ORIENT','TAGM','0');

Cmbxprj.ItemIndex:=IniFile.ReadInteger('SEAFRAME','PROJECTION',0);
CmBxPrjChange(sender);
INIfile.free;
end;

procedure TFSeaFrm.FormDestroy(Sender: TObject);
begin
 IniFile:=TIniFile.Create(make_ini('mk_seaFr.ini'));
IniFile.WriteInteger('SEAFRAME','Form_Height',Height);
IniFile.WriteInteger('SEAFRAME','Form_Width',Width);

IniFile.WriteString('SEAFRAME','DIRDM',DirDm);

IniFile.WriteInteger('SEAFRAME','SrcCrd',CBoxSrcCrd.ItemIndex);
IniFile.WriteInteger('SEAFRAME','TagCrd',CBoxTagCrd.ItemIndex);
IniFile.WriteInteger('SEAFRAME','SCALE',CmBxScale.ItemIndex);
IniFile.WriteString('SEAFRAME','Scale',edScale.Text);
IniFile.WriteInteger('SEAFRAME','RGSCALE',RGScale.ItemIndex);

IniFile.WriteString('SEAFRAME','LISTWIDTH',EdListWidth.Text);

IniFile.WriteString('SEAFRAME','BND',meBnd.EditText);
IniFile.WriteString('SEAFRAME','BNM',meBnm.EditText);
IniFile.WriteString('SEAFRAME','BNS',meBns.EditText);

IniFile.WriteString('SEAFRAME','BSD',meBsd.EditText);
IniFile.WriteString('SEAFRAME','BSM',meBsm.EditText);
IniFile.WriteString('SEAFRAME','BSS',meBss.EditText);

IniFile.WriteString('SEAFRAME','BMD',meBmd.EditText);
IniFile.WriteString('SEAFRAME','BMM',meBmm.EditText);
IniFile.WriteString('SEAFRAME','BMS',meBms.EditText);

IniFile.WriteString('SEAFRAME','LWD',meLWd.EditText);
IniFile.WriteString('SEAFRAME','LWM',meLWm.EditText);
IniFile.WriteString('SEAFRAME','LWS',meLWs.EditText);

IniFile.WriteString('SEAFRAME','LOD',meLED.EditText);
IniFile.WriteString('SEAFRAME','LOM',meLEM.EditText);
IniFile.WriteString('SEAFRAME','LOS',meLES.EditText);

//IniFile.WriteString('SEAFRAME','Admir',edAdmir.Text);
IniFile.WriteString('SEAFRAME','OBJ',edObj.Text);

IniFile.WriteString('ORIENT','SRCDX',meSrcDx.EditText);
IniFile.WriteString('ORIENT','SRCDY',meSrcDy.EditText);
IniFile.WriteString('ORIENT','SRCDZ',meSrcDz.EditText);
IniFile.WriteString('ORIENT','TAGDX',meTagDx.EditText);
IniFile.WriteString('ORIENT','TAGDY',meTagDy.EditText);
IniFile.WriteString('ORIENT','TAGDZ',meTagDz.EditText);

IniFile.WriteString('ORIENT','SRCWX',meSrcWx.EditText);
IniFile.WriteString('ORIENT','SRCWY',meSrcWy.EditText);
IniFile.WriteString('ORIENT','SRCWZ',meSrcWz.EditText);
IniFile.WriteString('ORIENT','TAGWX',meTagWx.EditText);
IniFile.WriteString('ORIENT','TAGWY',meTagWy.EditText);
IniFile.WriteString('ORIENT','TAGWZ',meTagWz.EditText);
IniFile.WriteString('ORIENT','SRCM',meSrcM.EditText);
IniFile.WriteString('ORIENT','TAGM',meTagM.EditText);


IniFile.WriteString('SEAFRAME','LMD',meLmd.EditText);
IniFile.WriteString('SEAFRAME','LMM',meLmm.EditText);
IniFile.WriteString('SEAFRAME','LMS',meLms.EditText);

IniFile.WriteString('SEAFRAME','XN',meXN.EditText);
IniFile.WriteString('SEAFRAME','XS',meXS.EditText);
IniFile.WriteString('SEAFRAME','YW',meYW.EditText);
IniFile.WriteString('SEAFRAME','YE',meYE.EditText);

IniFile.WriteString('SEAFRAME','BNDkv',meBndkv.EditText);
IniFile.WriteString('SEAFRAME','BNMkv',meBnmkv.EditText);
IniFile.WriteString('SEAFRAME','BNSkv',meBnskv.EditText);

IniFile.WriteString('SEAFRAME','BSDkv',meBsdkv.EditText);
IniFile.WriteString('SEAFRAME','BSMkv',meBsmkv.EditText);
IniFile.WriteString('SEAFRAME','BSSkv',meBsskv.EditText);

IniFile.WriteString('SEAFRAME','BMDkv',meBmdkv.EditText);
IniFile.WriteString('SEAFRAME','BMMkv',meBmmkv.EditText);
IniFile.WriteString('SEAFRAME','BMSkv',meBmskv.EditText);

IniFile.WriteString('SEAFRAME','LWDkv',meLWdkv.EditText);
IniFile.WriteString('SEAFRAME','LWMkv',meLWmkv.EditText);
IniFile.WriteString('SEAFRAME','LWSkv',meLWskv.EditText);

IniFile.WriteString('SEAFRAME','LEDkv',meLEdkv.EditText);
IniFile.WriteString('SEAFRAME','LEMkv',meLEmkv.EditText);
IniFile.WriteString('SEAFRAME','LESkv',meLEskv.EditText);


IniFile.WriteString('SEAFRAME','B0D',meB0d.EditText);
IniFile.WriteString('SEAFRAME','B0M',meB0m.EditText);
IniFile.WriteString('SEAFRAME','B0S',meB0s.EditText);


IniFile.WriteString('SEAFRAME','BMnD',meBmnd.EditText);
IniFile.WriteString('SEAFRAME','BMnM',meBmnm.EditText);
IniFile.WriteString('SEAFRAME','BMnS',meBmns.EditText);

IniFile.WriteString('SEAFRAME','L0D',meL0d.EditText);
IniFile.WriteString('SEAFRAME','L0M',meL0m.EditText);
IniFile.WriteString('SEAFRAME','L0S',meL0s.EditText);
IniFile.WriteString('SEAFRAME','X0',EdX0.Text);
IniFile.WriteString('SEAFRAME','Y0',EdY0.Text);
IniFile.WriteString('SEAFRAME','DX',EdDX.Text);
IniFile.WriteString('SEAFRAME','DY',EdDY.Text);

IniFile.WriteString('SEAFRAME','BNormSWD',meBNormSWd.EditText);
IniFile.WriteString('SEAFRAME','BNormSWM',meBNormSWm.EditText);
IniFile.WriteString('SEAFRAME','BNormSWS',meBNormSWs.EditText);
IniFile.WriteString('SEAFRAME','LNormSWD',meLNormSWd.EditText);
IniFile.WriteString('SEAFRAME','LNormSWM',meLNormSWm.EditText);
IniFile.WriteString('SEAFRAME','LNormSWS',meLNormSWs.EditText);

IniFile.WriteString('SEAFRAME','LNorm0D',meLNorm0d.EditText);
IniFile.WriteString('SEAFRAME','LNorm0M',meLNorm0m.EditText);
IniFile.WriteString('SEAFRAME','LNorm0S',meLNorm0s.EditText);

IniFile.WriteString('SEAFRAME','BNNormD',meBNNormd.EditText);
IniFile.WriteString('SEAFRAME','BNNormM',meBNNormm.EditText);
IniFile.WriteString('SEAFRAME','BNNormS',meBNNorms.EditText);

IniFile.WriteString('SEAFRAME','DXNorm',EdDXNorm.Text);
IniFile.WriteString('SEAFRAME','DYNorm',EdDYNorm.Text);
IniFile.WriteString('SEAFRAME','X0Norm',EdX0Norm.Text);
IniFile.WriteString('SEAFRAME','Y0Norm',EdY0Norm.Text);
IniFile.WriteBool('SEAFRAME','NormMirror',ChBxMirr.Checked);
IniFile.WriteBool('SEAFRAME','ChBXleftbott',ChBXleftbott.Checked);
IniFile.WriteBool('SEAFRAME','ChBxCircle',ChBxCircle.Checked);

IniFile.WriteString('SEAFRAME','BCrossSWD',meBCrossSWd.EditText);
IniFile.WriteString('SEAFRAME','BCrossSWM',meBCrossSWm.EditText);
IniFile.WriteString('SEAFRAME','BCrossSWS',meBCrossSWs.EditText);
IniFile.WriteString('SEAFRAME','LCrossSWD',meLCrossSWd.EditText);
IniFile.WriteString('SEAFRAME','LCrossSWM',meLCrossSWm.EditText);
IniFile.WriteString('SEAFRAME','LCrossSWS',meLCrossSWs.EditText);

IniFile.WriteString('SEAFRAME','L0CrossD',meL0Crossd.EditText);
IniFile.WriteString('SEAFRAME','L0CrossM',meL0Crossm.EditText);
IniFile.WriteString('SEAFRAME','L0CrossS',meL0Crosss.EditText);
IniFile.WriteString('SEAFRAME','DXCross',EdDXCross.Text);
IniFile.WriteString('SEAFRAME','DYCross',EdDYCross.Text);

IniFile.WriteString('SEAFRAME','RCrossMerc',EdRCrossMerc.Text);
IniFile.WriteString('SEAFRAME','RSlant',EdRSlant.Text);
IniFile.WriteString('SEAFRAME','RNorm',EdRNorm.Text);

IniFile.WriteString('SEAFRAME','BConSWD',meBConSWd.EditText);
IniFile.WriteString('SEAFRAME','BConSWM',meBConSWm.EditText);
IniFile.WriteString('SEAFRAME','BConSWS',meBConSWs.EditText);
IniFile.WriteString('SEAFRAME','LConSWD',meLConSWd.EditText);
IniFile.WriteString('SEAFRAME','LConSWM',meLConSWm.EditText);
IniFile.WriteString('SEAFRAME','LConSWS',meLConSWs.EditText);

IniFile.WriteString('SEAFRAME','LCon0D',meLCon0D.EditText);
IniFile.WriteString('SEAFRAME','LCon0M',meLCon0m.EditText);
IniFile.WriteString('SEAFRAME','LCon0S',meLCon0s.EditText);

IniFile.WriteString('SEAFRAME','DXCon',EdConDX.Text);
IniFile.WriteString('SEAFRAME','DYCon',EdConDY.Text);
IniFile.WriteString('SEAFRAME','XSCONUS',meXSconus.EditText);
IniFile.WriteString('SEAFRAME','YWCONUS',meYWconus.EditText);
IniFile.Writeinteger('SEAFRAME','CONUSCHOICE',RGConus.ItemIndex);

IniFile.WriteString('SEAFRAME','B1ConD',meB1Cond.EditText);
IniFile.WriteString('SEAFRAME','B1ConM',meB1Conm.EditText);
IniFile.WriteString('SEAFRAME','B1ConS',meB1Cons.EditText);
IniFile.WriteString('SEAFRAME','B2ConD',meB2Cond.EditText);
IniFile.WriteString('SEAFRAME','B2ConM',meB2Conm.EditText);
IniFile.WriteString('SEAFRAME','B2ConS',meB2Cons.EditText);
IniFile.WriteInteger('SEAFRAME','PROJECTION',Cmbxprj.ItemIndex);

INIfile.free;
dmw_disconnect;
end;


procedure TFSeaFrm.Button3Click(Sender: TObject);
var
  BLNW:tgauss;
  Rpnt:array[1..4] of tgauss;
  sign:integer;
// Bm_S,Bm_N,l_w:double;
// H:extended;
 X,Y : Double;

 // smap:shortstring;
  grad,min: integer;
  //rr,sec,n,m,u,sinu,cosu: EXTENDED;
 // els,elt:byte;
begin
 //GeoToPlainCuba((21.5)/180*Pi,77.75/180*Pi,'S', X,Y);

 //Init_BL_Con_Lambert(0.99993602,(22+21/60)/180*Pi,(81)/180*Pi,500000,15800000); //Nord
 Init_BL_Con_Lambert(0.99994848,(20+43/60)/180*Pi,-(76+50/60)/180*Pi,500000,17100000); //Nord

 //BL_to_Con_Lambert((21.5)/180*Pi,77.75/180*Pi,X, Y );
   RPNT[1].x:=(21+30/60)/180*Pi;
   RPNT[1].y:=-77.75/180*Pi;
   BL_to_Con_Lambert(RPNT[1].x,RPNT[1].y,X, Y );

  Con_Lambert_to_BL(X, Y ,BlNW.x, BlNW.y );

  Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600));
  Showmessage('dl:'+FormatFloat('0.000000000',(RPNT[1].y-BlNW.y)/Pi*180*3600));
   exit;

  {els:=CBoxSrcCrd.ItemIndex+1;
  elt:=CBoxTagCrd.ItemIndex+1;
  if els<1 then els:=1;
  if elt<1 then elt:=1;  }
  //H:=StrtoFloat(edh.text, MyFormatSettings);
  if (MeBnd.edittext[1]='-') or (strtoint(meBND.edittext)<0)  then sign:=-1 else sign:=1;
    BLNW.X:=(strtoint(meBND.edittext)+sign*strtoint(meBNM.edittext)/60+sign*strtoFloat(meBNS.edittext, MyFormatSettings)/3600)/180*PI;
  if (MeLWd.edittext[1]='-') or (strtoint(meLwd.edittext)<0)  then sign:=-1 else sign:=1;
 Rad_grad (BLNW.X,grad,min,sec);
  Showmessage('B:'+FormatFloat('0',grad) +
              ' '+FormatFloat('0',Min)+
              ' '+FormatFloat('0.0000000',sec));
exit;

    BLNW.Y:=(strtoint(meLWD.edittext)+sign*strtoint(meLWM.edittext)/60+sign*strtofloat(meLWS.edittext, MyFormatSettings)/3600)/180*PI;
if (MeBmd.edittext[1]='-') or (strtoint(meBmd.edittext)<0)  then sign:=-1 else sign:=1;
   B991:=(strtoint(meBMD.edittext)+sign*strtoint(meBMM.edittext)/60+sign*strtofloat(meBMS.edittext, MyFormatSettings)/3600)/180*PI;
 {
  Init_NormStereograf(bm,33/180*Pi);
  exit;
  }
  {Init_SlantingLambert(40/180*Pi,-35/180*Pi);

  SlantingLambert_BL_XY(BLNW.X,BLNW.y,RPNT[1].X,RPNT[1].y);
  }
//  BL_to_XY(BLNW.X,BLNW.y, 20/180*Pi,30/180*Pi,60/180*Pi,1,4,RPNT[1].X,RPNT[1].y);

 { cGnomon_BL_XY(BLNW.X,BLNW.y,RPNT[1].X,RPNT[1].y);

  Init_CrossGnomon(0);

  CrossGnomon_BL_XY(BLNW.X,BLNW.y,RPNT[1].X,RPNT[1].y);
 }
{  Showmessage('X:'+FormatFloat('0.000000000',RPNT[1].x));
  Showmessage('Y:'+FormatFloat('0.000000000',RPNT[1].y));

  exit;
 }
{ Init_SlantingPerspCylindr(25/180*Pi,25/180*Pi,-80/180*Pi,80/180*Pi,3);

 SlantingPerspCylindr_BL_XY(BLNW.X,BLNW.y,RPNT[1].X,RPNT[1].y);
 Showmessage('X:'+FormatFloat('0.000000000',RPNT[1].x));
  Showmessage('Y:'+FormatFloat('0.000000000',RPNT[1].y));

 SlantingPerspCylindr_XY_BL(RPNT[1].X,RPNT[1].y,RPNT[1].X,RPNT[1].y);
 Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600));
 Showmessage('dl:'+FormatFloat('0.000000000',(RPNT[1].y-BlNW.y)/Pi*180*3600));
 exit;


  Init_SlantingStereograf(70/180*Pi,69/180*Pi,33/180*Pi);

  SlantingStereograf_BL_XY(BLNW.X,BLNW.y,RPNT[1].X,RPNT[1].y);
 Showmessage('X:'+FormatFloat('0.000000000',RPNT[1].x));
  Showmessage('Y:'+FormatFloat('0.000000000',RPNT[1].y));
  RPNT[1].X:=-311230;
  RPNT[1].y:=-362570;
  SlantingStereograf_XY_BL(RPNT[1].X,RPNT[1].y,RPNT[1].X,RPNT[1].y);

  Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600));
  Showmessage('dl:'+FormatFloat('0.000000000',(RPNT[1].y-BlNW.y)/Pi*180*3600));
  exit;

  rr:=Calc_RN(B991);
  Init_PolarSlantingPostel(80/180*Pi,85/180*Pi,15/180*Pi,rr);

  PolarSlantingPostel_BL_XY(BLNW.X,BLNW.y,RPNT[1].X,RPNT[1].y);

  PolarSlantingPostel_XY_BL(RPNT[1].X,RPNT[1].y,RPNT[1].X,RPNT[1].y);

  Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600));
  Showmessage('dl:'+FormatFloat('0.000000000',(RPNT[1].y-BlNW.y)/Pi*180*3600));
  exit;

  rr:=Calc_RN(B991);

  Init_Mcross(B991,rr);
  //mCross_BL_XY(BLNW.X,BLNW.y,RPNT[1].x,RPNT[1].Y);

//  xbl.BL_to_XY(BLNW.X,BLNW.y,0,b991,9,1,9,RPNT[1].x,RPNT[1].Y);


  Showmessage('dB:'+FormatFloat('0.000000000',RPNT[1].x));
  Showmessage('dl:'+FormatFloat('0.000000000',RPNT[1].y));
  exit;
  mCross_XY_BL(RPNT[1].x,RPNT[1].Y,RPNT[1].x,RPNT[1].Y);
   Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600));
  Showmessage('dl:'+FormatFloat('0.000000000',(RPNT[1].y-BlNW.y)/Pi*180*3600));
  exit;
  {
  rr:=Calc_RN((80/180)*Pi);
  Init_Mcross((80/180)*Pi,rr);
  rNM_U((80/180)*Pi,N,M,U);
  h:=rr/(3437.7467707849*500000);
 }
  {rr:=Fmin(6397000,6399000,@m_1,0.00001);
  h:=m_1(rr);
  sec:=m_1(6398412);
  }
 { exit;


  Init_SlantingLambert(40/180*Pi,35/180*Pi);

  SlantingLambert_BL_XY(BLNW.X,BLNW.y,RPNT[1].X,RPNT[1].y);
  SlantingLambert_XY_BL(RPNT[1].X,RPNT[1].y,RPNT[1].X,RPNT[1].y);

   Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600));
  Showmessage('dl:'+FormatFloat('0.000000000',(RPNT[1].y-BlNW.y)/Pi*180*3600));
 exit;
 {  Showmessage('X:'+FormatFloat('0.000000000',RPNT[1].x) +
            ' Y:'+FormatFloat('0.000000000',RPNT[1].Y));
  Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600));
  Showmessage('dl:'+FormatFloat('0.000000000',(RPNT[1].y-BlNW.y)/Pi*180*3600));

 exit;
}
 {Init_Mcross(BM);
  rNM_U(80/180*Pi,N,M,u);
  rr:=(M+N)*0.5;
  rr:=SQRT(M*N);
  rr:=N*cos(80/180*Pi)/cos(u);

 exit;
 }
{  rr:=c_R0(Bm,e);
  rr:=c_R0(u0,e);
  rN_U(80/180*Pi,N,u);
  rr:=n*cos(u0);
  rN_U(75/180*Pi,N,u);
  rr:=N*cos(75/180*Pi)/cos(u);
  rN_U(80/180*Pi,N,u);
  rr:=N*cos(80/180*Pi)/cos(u);

  rN_U(0.5*Pi,N,u);
  rr:=cos(u);
 }
 { mCross_BL_XY(BLNW.X,BLNW.y,RPNT[1].x,RPNT[1].Y);
  mCross_XY_BL(RPNT[1].x,RPNT[1].Y,BLNW.X,BLNW.y);
  Rad_grad (BLNW.X,grad,min,sec);
  Showmessage('B:'+FormatFloat('0',grad) +
              ' '+FormatFloat('0',Min)+
              ' '+FormatFloat('0.0000',sec));

  Rad_grad (BLNW.y,grad,min,sec);
   Showmessage('L:'+FormatFloat('0',grad) +
              ' '+FormatFloat('0',Min)+
              ' '+FormatFloat('0.0000',sec));
 }
{  Showmessage('X:'+FormatFloat('0.000000000',RPNT[1].x) +
            ' Y:'+FormatFloat('0.000000000',RPNT[1].Y));
}
 {
  SimplePolykon_BL_XY(BLNW.X,BLNW.y,0, RPNT[1].X,RPNT[1].y);

  Showmessage('X:'+FormatFloat('0.000000000',RPNT[1].x) +
            ' Y:'+FormatFloat('0.000000000',RPNT[1].Y));


 nit:=SimplePolykon_XY_BL(RPNT[1].X,RPNT[1].y, 0,1.e-12, tgbl.x,tgbl.y);
  showmessage(FormatFloat('00.000000000',tgbl.x/Pi*180)+
               FormatFloat('  00.000000000',tgbl.y/Pi*180)+' It='+IntTostr(nit));
   exit;
   }
  { BLSO.X:=(strtoint(meBSD.edittext)+strtoint(meBSM.edittext)/60+strtoint(meBSS.edittext)/3600)/180*PI;
  BLSO.Y:=(strtoint(meLED.edittext)+strtoint(meLEM.edittext)/60+strtoint(meLES.edittext)/3600)/180*PI;
}
 (*
 if els<>elt then begin
   BLH_BLH(BLNW.X,BLNW.y,H,els,elt,RPNT[1].X,RPNT[1].y,H2[1]);
  { BL_BL(BLNW.X,BLSO.Y,H,els,elt,RPNT[2].X,RPNT[2].y,H2[2]);
   BL_BL(BLSO.X,BLSO.Y,H,els,elt,RPNT[3].X,RPNT[3].y,H2[3]);
   BL_BL(BLSO.X,BLNW.Y,H,els,elt,RPNT[4].X,RPNT[4].y,H2[4]);
  }
  Rad_grad (RPNT[1].x,grad,min,sec);
  Showmessage('B:'+FormatFloat('0',grad) +
              ' '+FormatFloat('0',Min)+
              ' '+FormatFloat('0.0000',sec));

  Rad_grad (RPNT[1].y,grad,min,sec);
   Showmessage('L:'+FormatFloat('0',grad) +
              ' '+FormatFloat('0',Min)+
              ' '+FormatFloat('0.0000',sec));


  Showmessage('B:'+FormatFloat('0.000000000',RPNT[1].x/Pi*180) +
              ' L:'+FormatFloat('0.000000000',RPNT[1].Y/Pi*180)+
              ' H:'+FormatFloat('0.000000000',H2[1]));
  Showmessage('dB:'+FormatFloat('0.000000000',(RPNT[1].x-BlNW.x)/Pi*180*3600) +
             ' dL:'+FormatFloat('0.000000000',(RPNT[1].Y-BLNW.y)/Pi*180*3600)+
         ' dH:'+FormatFloat('0.000000000',H2[1]-H));
  end else
   Showmessage('А тут нечего пересчитывать.')
*)
end;

procedure TFSeaFrm.Button4Click(Sender: TObject);
var
  BLN,BLS,BM,ebms:extended;
  lBM,sign,lbmm:longint;
begin
     if (MeBnd.edittext[1]='-') or (strtoint(meBND.edittext)<0)  then sign:=-1 else sign:=1;

  BLN:=(strtoint(meBND.edittext)+sign*strtoint(meBNM.edittext)/60+sign*strtoFloat(meBNS.edittext, MyFormatSettings)/3600)/180*PI;
   if (MeBSd.edittext[1]='-') or (strtoint(meBsd.edittext)<0)  then sign:=-1 else sign:=1;
  BLS:=(strtoint(meBSD.edittext)+sign*strtoint(meBSM.edittext)/60+sign*strtofloat(meBSS.edittext, MyFormatSettings)/3600)/180*PI;
  BM:=(BLN+BLS)/Pi*90;{*0.5/PI*180}

   lbm:=Trunc(abs(BM));
   lbmm:=trunc((abs(Bm)-lBm)*60.0);
   ebms:=((abs(Bm)-lBm)*60.0-trunc((abs(Bm)-lBm)*60.0))*60.0;
   if ebms> 59.99 then begin inc(lbmm);  ebms:=0 end;
   if lbmm=60 then begin lbmm:=0; inc(Lbm) end;
  if BM>0 then
  meBmd.EditText:=FormatFloat('000',lBm)
    else
  meBmd.EditText:=FormatFloat('-00',lBm);

  meBmm.EditText:=FormatFloat('00',lbmm);
  meBms.EditText:=FormatFloat('00.00',ebms);
end;

procedure TFSeaFrm.Button7Click(Sender: TObject);
var
 OpenDlg:TOpenDialog;
 Usr_dir:string;
 pc:pchar;
begin
OpenDlg:=TOpenDialog.Create(FSeaFrm);
  OpenDlg.Title:='Выбор классификатора';
 OpenDlg.DefaultExt:='obj';
 OpenDlg.Filter:='Файлы классификаторов(*.obj)|*.obj';
 Usr_dir:=Bin_dir+#0;
 pc:=Strrscan(@Usr_dir[1],'\');
 pc^:=#0;
 Usr_dir:=Strpas(@Usr_dir[1])+'\obj';
   OpenDlg.InitialDir:=Usr_dir;
If OpenDLG.Execute then
  edobj.Text:= extractFilename(OpenDLG.FileName);
  OpenDlg.Destroy;
end;

{
Type
 Tdlg_datum = function(elp: PChar; out dx,dy,dz: Integer):boolean;  stdcall;
var
  fdlg_datum:Tdlg_datum;
  dx,dy,dz: Integer;
  s:shortstring;
  Libhandle:Thandle;
begin
if CBoxSrcCrd.ItemIndex<0 then begin
ShowMessage('Выберите эллипсоид');
exit
end;
  Libhandle:=LoadLibrary('dm_util');
  if LibHandle<32 then
    ShowMessage('Ошибка при загрузке DLL dm_util')
  else
    begin
      @fdlg_datum:=GetProcaddress(Libhandle,'dlg_datum');
      s:=CBoxTagCrd.Text;
       s:=Copy(S,1,4)+#0;
      if fdlg_datum(pchar(@s[1]),dx,dy,dz) then begin
        metagDX.EditText:=inttostr(dx);
        metagDy.EditText:=inttostr(dy);
        metagDz.EditText:=inttostr(dz);
      end;
      FreeLibrary(LibHandle)
    end;
end;
}

procedure TFSeaFrm.Button2Click(Sender: TObject);
Type
 Tdial_dat = function(elp: PChar; var geo: TDatum7):boolean;stdcall;
var
  fdlg_datum:Tdial_dat;
  geo7: TDatum7;
  s:shortstring;
  Libhandle:Thandle;
begin
if CBoxSrcCrd.ItemIndex<0 then begin
ShowMessage('Выберите эллипсоид');
exit
end;
  Libhandle:=LoadLibrary('dlg_stg');
  if LibHandle<32 then
    ShowMessage('Ошибка при загрузке DLL dlg_stg')
  else
    begin
      @fdlg_datum:=GetProcaddress(Libhandle,'dial_dat');
      s:=CBoxSrcCrd.Text;
      s:=Copy(S,1,4)+#0;
      if fdlg_datum(pchar(@s[1]),geo7) then begin
        meSrcDX.EditText:=Floattostr(geo7.dx);
        meSrcDy.EditText:=Floattostr(geo7.dy);
        meSrcDz.EditText:=Floattostr(geo7.dz);
        meSrcWX.EditText:=Floattostr(geo7.wx);
        meSrcWy.EditText:=Floattostr(geo7.wy);
        meSrcWz.EditText:=Floattostr(geo7.wz);
        meSrcM.EditText:=Floattostr(geo7.m);
      end;
      FreeLibrary(LibHandle)
    end;
end;

procedure TFSeaFrm.Button5Click(Sender: TObject);
Type
 Tdial_dat = function(elp: PChar; var geo: TDatum7):boolean;stdcall;
var
  fdlg_datum:Tdial_dat;
  geo7: TDatum7;
  s:shortstring;
  Libhandle:Thandle;
begin
if CBoxSrcCrd.ItemIndex<0 then begin
ShowMessage('Выберите эллипсоид');
exit
end;
  Libhandle:=LoadLibrary('dlg_stg');
  if LibHandle<32 then
    ShowMessage('Ошибка при загрузке DLL dlg_stg')
  else
    begin
      @fdlg_datum:=GetProcaddress(Libhandle,'dial_dat');
      s:=CBoxTagCrd.Text;
       s:=Copy(S,1,4)+#0;
      if fdlg_datum(pchar(@s[1]),geo7) then begin
        meTagDX.EditText:=Floattostr(geo7.dx);
        meTagDy.EditText:=Floattostr(geo7.dy);
        meTagDz.EditText:=Floattostr(geo7.dz);
        meTagWX.EditText:=Floattostr(geo7.wx);
        meTagWy.EditText:=Floattostr(geo7.wy);
        meTagWz.EditText:=Floattostr(geo7.wz);
        meTagM.EditText:=Floattostr(geo7.m);
      end;
      FreeLibrary(LibHandle)
    end;
end;

procedure TFSeaFrm.CmBxPrjChange(Sender: TObject);
begin
case Cmbxprj.ItemIndex of
0:pgcrdsys.ActivePageIndex:=0;
1:pgcrdsys.ActivePageIndex:=3;
2:pgcrdsys.ActivePageIndex:=1;
3:pgcrdsys.ActivePageIndex:=6;
6,7,10,11,14,15,16:pgcrdsys.ActivePageIndex:=2;
4,8,12,17:pgcrdsys.ActivePageIndex:=4;
5,9,13:pgcrdsys.ActivePageIndex:=5;
else
pgcrdsys.ActivePageIndex:=0;
end
end;

procedure TFSeaFrm.CBoxSrcCrdChange(Sender: TObject);
begin
if CBoxSrcCrd.ItemIndex=8 then begin
  meSrcdx.EditText:='0';
  meSrcdY.EditText:='0';
  meSrcdZ.EditText:='0';
   button2.Enabled:=false;
end else begin
   button2.Enabled:=true;
end;
end;

procedure TFSeaFrm.CboxTagCrdChange(Sender: TObject);
begin
if CBoxTagCrd.ItemIndex=8 then begin
  meTagdx.EditText:='0';
  meTagdY.EditText:='0';
  meTagdZ.EditText:='0';
   button5.Enabled:=false;
end else begin
   button5.Enabled:=true;
end;

end;

procedure TFSeaFrm.Button6Click(Sender: TObject);
var
  sign:integer;
  BM:extended;
begin
  if (MeBmdKV.edittext[1]='-') or (strtoint(meBmdKV.edittext)<0)  then sign:=-1 else sign:=1;
  BM:=(strtoint(meBMDKV.edittext)+sign*strtoint(meBMMKV.edittext)/60+sign*strtofloat(meBMSKV.edittext, MyFormatSettings)/3600)/180*PI;
  edRcrossMerc.text:=FloatTostr(Calc_RN(Bm));
end;

procedure TFSeaFrm.Button8Click(Sender: TObject);
var
  sign:integer;
  BM:extended;
begin
 if (MeBmNd.edittext[1]='-') or (strtoint(meBmNd.edittext)<0)  then sign:=-1 else sign:=1;
  BM:=(strtoint(meBMND.edittext)+sign*strtoint(meBMNM.edittext)/60+sign*strtofloat(meBMNS.edittext, MyFormatSettings)/3600)/180*PI;
  edRSlant.text:=FloatTostr(Calc_RN(Bm));
end;

procedure TFSeaFrm.Button9Click(Sender: TObject);

var
  sign:integer;
  BM:extended;
begin
  if (MeBNNormd.edittext[1]='-') or (strtoint(meBNNormd.edittext)<0)  then sign:=-1 else sign:=1;
  BM:=(strtoint(meBNNormD.edittext)+sign*strtoint(meBNNormM.edittext)/60+sign*strtofloat(meBNNormS.edittext, MyFormatSettings)/3600)/180*PI;
  edRNorm.text:=FloatTostr(Calc_RN(ABS(Bm)));
end;

procedure TFSeaFrm.Button10Click(Sender: TObject);
var
  BMNorm,L0,BSW,LSW:double;
  tg:tgauss;
  iScale, sign, elt:integer;

begin

 if (MeBNormSWd.edittext[1]='-') or (strtoint(meBNormSWD.edittext)<0)  then sign:=-1 else sign:=1;
    BSW:=(strtoint(meBNormSWD.edittext)+sign*strtoint(meBNormSWM.edittext)/60+sign*strtoFloat(meBNormSWS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeLNormSWd.edittext[1]='-') or (strtoint(meLNormSWD.edittext)<0)  then sign:=-1 else sign:=1;
    LSW:=(strtoint(meLNormSWD.edittext)+sign*strtoint(meLNormSWM.edittext)/60+sign*strtoFloat(meLNormSWS.edittext, MyFormatSettings)/3600)/180*PI;
 if (MeLNorm0d.edittext[1]='-') or (strtoint(meLNorm0D.edittext)<0)  then sign:=-1 else sign:=1;
    L0:=(strtoint(meLNorm0D.edittext)+sign*strtoint(meLNorm0M.edittext)/60+sign*strtoFloat(meLNorm0S.edittext, MyFormatSettings)/3600)/180*PI;

 if (MeBnNormd.edittext[1]='-') or (strtoint(meBnNormd.edittext)<0)  then sign:=-1 else sign:=1;
   BMNorm:=(strtoint(meBnNormD.edittext)+sign*strtoint(meBnNormM.edittext)/60+sign*strtofloat(meBnNormS.edittext, MyFormatSettings)/3600)/180*PI;
 case cmbxprj.ItemIndex of
   4:Init_NormGnomon(BMNorm,L0,Strtofloat(edRNorm.Text, MyFormatSettings),chbxMirr.checked);
   8:Init_NormStereograf(BMNorm,L0,Strtofloat(edRNorm.Text, MyFormatSettings),chbxMirr.checked);
   12:Init_NormPostel(BMNorm,L0,Strtofloat(edRNorm.Text, MyFormatSettings),chbxMirr.checked);
   17: begin elt:=CBoxTagCrd.ItemIndex+1;
                if elt<1 then elt:=1;
          end;
  end;

  case rgScale.ItemIndex of
   0,2:   case CmbxScale.ItemIndex of
         0: iscale:=1000;
         1: iscale:=1500;
         2: Iscale:=2000;
         3: Iscale:=2500;
         4: Iscale:=3000;
         5: Iscale:=4000;
         6: Iscale:=5000;
         7: Iscale:=6000;
         8: Iscale:=7000;
         9: Iscale:=7500;
         10: Iscale:=10000;
         11: Iscale:=12500;
         12: Iscale:=15000;
         13: Iscale:=12500;
         14: Iscale:=20000;
         15: Iscale:=25000;
         16: Iscale:=30000;
         17: Iscale:=37500;
         18: Iscale:=40000;
         19: Iscale:=50000;
         20: Iscale:=75000;
         21: Iscale:=100000;
         22: Iscale:=150000;
         23: Iscale:=200000;
         24: Iscale:=250000;
         25: Iscale:=300000;
         26: Iscale:=500000;
         27: Iscale:=750000;
         28: Iscale:=1000000;
         29: Iscale:=1500000;
         30: Iscale:=2000000;
         31: Iscale:=2500000;
         32: Iscale:=3000000;
         33: Iscale:=5000000;
         34: Iscale:=10000000;
        else
        Iscale:=500
          end;
   1:
     Iscale:=Strtoint(edScale.text);
 end;

  case cmbxprj.ItemIndex of
   4:  NormGnomon_BL_XY(BSW,LSW,tg.x,tg.y);
   8:  NormStereograf_BL_XY(BSW,LSW,tg.x,tg.y);
   12: NormPostel_BL_XY(BSW,LSW,tg.x,tg.y);
   17: frNavyfun.BL_to_XY(BSW,LSW, L0, BMNorm, 0, elt, 33,  tg.x,tg.y);
  end;
  if cmbxprj.ItemIndex=17 then begin
    edX0Norm.Text:=FloatToStr(1000*tg.x/Iscale);
    edY0Norm.Text:=FloatToStr(1000*tg.y/Iscale);
  end
  else begin
   edX0Norm.Text:=FloatToStr(-1000*tg.x/Iscale);
   edY0Norm.Text:=FloatToStr(-1000*tg.y/Iscale);
  end
end;

end.
