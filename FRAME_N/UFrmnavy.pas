unit UFrmnavy;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,IniFiles,Dmw_ddw,dmw_Use,win_use,OTypes,geoidnw,mfrmNavy,FrNavyFun,NevaUtil,
  ExtCtrls, MaskEdit,wmPick;

type
  TFFrame = class(TForm)
    Button1: TButton;
    Label4: TLabel;
    MemMaker: TMemo;
    Label10: TLabel;
    CmBxMAMS: TComboBox;
    Label1: TLabel;
    LLang: TLabel;
    CBoxLang: TComboBox;
    Panel1: TPanel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    MemMakerE: TMemo;
    Label17: TLabel;
    ChBNetInterv: TCheckBox;
    meMDM: TMaskEdit;
    Label23: TLabel;
    meMDS: TMaskEdit;
    Label33: TLabel;
    meSmInM: TMaskEdit;
    Label12: TLabel;
    meSmInS: TMaskEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    meSmInD: TMaskEdit;
    Label22: TLabel;
    meIntrD: TMaskEdit;
    Label24: TLabel;
    meIntrM: TMaskEdit;
    Label25: TLabel;
    meIntrS: TMaskEdit;
    Label26: TLabel;
    Label27: TLabel;
    meBigIntrD: TMaskEdit;
    Label28: TLabel;
    meBigIntrM: TMaskEdit;
    Label29: TLabel;
    meBigIntrS: TMaskEdit;
    Label30: TLabel;
    Label31: TLabel;
    meTextIntrD: TMaskEdit;
    Label32: TLabel;
    meTextIntrM: TMaskEdit;
    Label34: TLabel;
    meTextIntrS: TMaskEdit;
    Label35: TLabel;
    Label36: TLabel;
    meShrafD: TMaskEdit;
    Label37: TLabel;
    meShrafM: TMaskEdit;
    Label38: TLabel;
    meShrafS: TMaskEdit;
    Label39: TLabel;
    meMDM_L: TMaskEdit;
    Label40: TLabel;
    meMDS_L: TMaskEdit;
    Label41: TLabel;
    meSmInM_L: TMaskEdit;
    Label42: TLabel;
    meSmInS_L: TMaskEdit;
    Label43: TLabel;
    meSmInD_L: TMaskEdit;
    Label47: TLabel;
    meIntrD_L: TMaskEdit;
    Label48: TLabel;
    meIntrM_L: TMaskEdit;
    Label49: TLabel;
    meIntrS_L: TMaskEdit;
    Label50: TLabel;
    meBigIntrD_L: TMaskEdit;
    Label52: TLabel;
    meBigIntrM_L: TMaskEdit;
    Label53: TLabel;
    meBigIntrS_L: TMaskEdit;
    Label54: TLabel;
    meTextIntrD_L: TMaskEdit;
    Label56: TLabel;
    meTextIntrM_L: TMaskEdit;
    Label57: TLabel;
    meTextIntrS_L: TMaskEdit;
    Label58: TLabel;
    meShrafD_L: TMaskEdit;
    Label60: TLabel;
    meShrafM_L: TMaskEdit;
    Label61: TLabel;
    meShrafS_L: TMaskEdit;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Button2: TButton;
    Button3: TButton;
    ChB1tip: TCheckBox;
    ChB2Tip: TCheckBox;
    Button8: TButton;
    Panel2: TPanel;
    Label44: TLabel;
    ChBNetOrig: TCheckBox;
    meNetDB_B: TMaskEdit;
    Label45: TLabel;
    meNetMB_B: TMaskEdit;
    Label46: TLabel;
    meNetSB_B: TMaskEdit;
    Label51: TLabel;
    meNetDB_L: TMaskEdit;
    Label55: TLabel;
    meNetMB_L: TMaskEdit;
    Label59: TLabel;
    meNetSB_L: TMaskEdit;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Button4: TButton;
    EdOrder: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    EdPrint: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label69: TLabel;
    EdEKuatorScale: TEdit;
    Button9: TButton;
    Button10: TButton;
    Label70: TLabel;
    Label71: TLabel;
    EdINT: TEdit;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Panel3: TPanel;
    ChBLeft: TCheckBox;
    ChbRight: TCheckBox;
    ChbTop: TCheckBox;
    ChBBottom: TCheckBox;
    Label76: TLabel;
    ChBxKM: TCheckBox;
    RgKm_LR: TRadioGroup;
    ChBxKmNormal: TCheckBox;
    RgColorScale: TRadioGroup;
    Button5: TButton;
    Label9: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    meNetCrDB_B: TMaskEdit;
    meNetCrMB_B: TMaskEdit;
    meNetCrSB_B: TMaskEdit;
    meNetCrDB_L: TMaskEdit;
    meNetCrMB_L: TMaskEdit;
    meNetCrSB_L: TMaskEdit;
    Label85: TLabel;
    meMaxDB: TMaskEdit;
    Label86: TLabel;
    meMaxMB: TMaskEdit;
    Label87: TLabel;
    meMaxSB: TMaskEdit;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    meUBigIntrD: TMaskEdit;
    meUBigIntrM: TMaskEdit;
    meUBigIntrS: TMaskEdit;
    meUBigIntrD_L: TMaskEdit;
    meUBigIntrM_L: TMaskEdit;
    meUBigIntrS_L: TMaskEdit;
    meUMDM: TMaskEdit;
    meUMDS: TMaskEdit;
    meUSmInM: TMaskEdit;
    meUSmInS: TMaskEdit;
    meUSmInD: TMaskEdit;
    meUIntrD: TMaskEdit;
    meUIntrM: TMaskEdit;
    meUIntrS: TMaskEdit;
    meUMDM_L: TMaskEdit;
    meUMDS_L: TMaskEdit;
    meUSmInM_L: TMaskEdit;
    meUSmInS_L: TMaskEdit;
    meUSmInD_L: TMaskEdit;
    meUIntrD_L: TMaskEdit;
    meUIntrM_L: TMaskEdit;
    meUIntrS_L: TMaskEdit;
    Label117: TLabel;
    ChCrMercB: TCheckBox;
    ChCrMercL: TCheckBox;
    Button6: TButton;
    Button7: TButton;
    btProdsign: TButton;
    MeColorSign: TMaskEdit;
    Button14: TButton;
    ChbLog: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure btProdsignClick(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 procedure Make_NET_on_Klapan;

var
  FFrame: TFFrame;
  OpenDlg: TOpenDialog;
  DirIni:string;
  MyFormatSettings : TFormatSettings;

implementation

uses UconFrm, uNormstr, UArt;

{$R *.lfm}
procedure TFFrame.Button1Click(Sender: TObject);
var
  ss,ss2:shortstring;
   lcode,Centre,l1,l2,lcode2:longint;
   a,b:lpoint;
   R:lorient;
   Year, Month, Day,i,lDF,lDN:longint;
begin
  FPick.cli.Suspend;
  if mk_frame then begin
    nodecurr:=dm_object;
    root;
    if dm_Get_String(907,255,ss) then begin
      { Гриф }
      tr_bl(ss);
      if ss<>''+#0 then begin
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);
      a:=pcorn[2];
      if ss='ДСП'+#0 then
      ss:='ДЛЯ СЛУЖЕБНОГО ПОЛЬЗОВАНИЯ';
      ss:=ss+#0;
      PL^.n:=0;
      PL.pol[0]:=a;
      lcode:=String2Code('A0400110');
      dm_Text_bound(lcode,@ss[1],pl,pb,8000,0);
      a.x:=tlfr.pol[1].x-pb^.pol[2].x+pb^.pol[1].x-round(140*kf);
      a.y:=TLfr.pol[0].y-round(6.0*kf);
      PL^.n:=0; PL^.pol[0]:=a;
      nodecurr:=dm_Add_Text(lcode,4,0,PL,@ss[1],false);
      root;
      end;
    end;
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);
      { Создание текстов внизу листа }
      a.y:=TLfr.pol[3].y+round(5.2*kf);
      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
        ss:='Система МАМС';
        lcode:=String2Code('A0400212');
        a.x:=tlfr.pol[3].x+round(180*kf);
        a.y:=TLfr.pol[3].y+round(5.2*kf);
        nodecurr:=Add_Text(lcode,a,a,0,ss,false);
        case CmBxMAMS.ItemIndex of
         0:ss:='(регион А-красный слева)';
         1:ss:='(регион Б-красный справа)';
        end;
        lcode:=String2Code('A0400222');
        a.y:=TLfr.pol[3].y+round(8*kf);
        nodecurr:=Add_Text(lcode,a,a,0,ss,false);
      end;
     if (CboxLang.itemindex=1)or(CboxLang.itemindex=2) then begin
      ss:='IALA System';
      lcode:=String2Code('A0400211');
      a.x:=tlfr.pol[3].x+round(180*kf);
    if CboxLang.itemindex=2 then
      a.y:=a.y+round(5.2*kf);
     nodecurr:=Add_Text(lcode,a,a,0,ss,false);
      case CmBxMAMS.ItemIndex of
       0:ss:='Region A (Red to Port)';
       1:ss:='Region B (Red to Starboard)';
      end;
      lcode:=String2Code('A0400221');
      a.y:=a.y+round(3.3*kf);
      nodecurr:=Add_Text(lcode,a,a,0,ss,false);
     end;

       //Подпись "Главное управление..."


     a.y:=TLfr.pol[3].y+round(4.0*kf);
      leftmaker:=pcorn[3].x;
      rightmaker:=pcorn[4].x;

      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
       Centre:= (tlfr.pol[2].x+tlfr.pol[3].x) div 2;
      lcode:=String2Code('A0400510');

      a.x:=Centre;
      for i:=1 to Memmaker.Lines.Count do begin
      ss:=Memmaker.Lines[i-1];
      if i=Memmaker.Lines.Count then
         lcode:=String2Code('A0400530');
      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      b.y:=a.y;
      if a.x<leftmaker then leftmaker:=a.x;
      if b.x>rightmaker then rightmaker:=b.x;
      nodecurr:=Add_Text(lcode,a,b,0,ss,false);
      if i=1 then begin
      dec(a.x,round(3*kf));
      nodecurr:=dm_add_sign(String2Code('A0100004'),a,a,0,false);
      end;
      inc(a.y,round(4*kf))
       end;
       end;
     if (CboxLang.itemindex=1)or(CboxLang.itemindex=2) then begin
      if CboxLang.itemindex=1 then
      a.y:=TLfr.pol[3].y+round(4.0*kf);

      //if CboxLang.itemindex=1 then
        Centre:=(tlfr.pol[2].x+tlfr.pol[3].x) div 2;
      {
      else begin
        leftmakerE:=pcorn[3].x;
        rightmakerE:=pcorn[4].x;
        lcode:=String2Code('A0400511');

      for i:=1 to MemmakerE.Lines.Count do begin
      ss:=MemmakerE.Lines[i-1];
       if i=MemmakerE.Lines.Count then
         lcode:=String2Code('A0400531');

      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      if a.x<leftmakerE then leftmakerE:=a.x;
      if b.x>rightmakerE then rightmakerE:=b.x;
      end;
      Centre:=leftmaker-(rightmakerE-leftmakerE) div 2- round(20*kf)
      end;
       }
       lcode:=String2Code('A0400511');

      a.x:=Centre;
      for i:=1 to MemmakerE.Lines.Count do begin
      ss:=MemmakerE.Lines[i-1];
       if i=MemmakerE.Lines.Count then
         lcode:=String2Code('A0400531');
     Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      b.y:=a.y;
      if CboxLang.itemindex=1 then begin

      if a.x<leftmaker then leftmaker:=a.x;
      if b.x>rightmaker then rightmaker:=b.x;
      end else begin
        if a.x<leftmaker then leftmaker:=a.x;
      end;
      nodecurr:=Add_Text(lcode,a,b,0,ss,false);
      inc(a.y,round(4*kf))
       end;
       end;
       // Издания
     root;

    if dm_Get_long(921,0,lDF) then begin
      { Регионы карты}
      if not dm_get_long(922,0,lDN) then lDN:=0;
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);
      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin

      ss:='Перв.изд.';
      if lDF>10000 then begin
          Year:=lDF div 10000;
          month:=(ldf-Year*10000) div 100;
          Day:=ldf-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDF;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400420');
       a.x:=rightmaker+round(20*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'First edition',false);
       end;
       end else begin
        ss:='First edition';
      if lDF>10000 then begin
          Year:=lDF div 10000;
          month:=(ldf-Year*10000) div 100;
          Day:=ldf-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDF;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400421');
       a.x:=rightmaker+round(20*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;
       if lDN<>0 then begin
       if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin

         ss:='Нов.изд.';
      if lDN>10000 then begin
          Year:=lDN div 10000;
          month:=(ldN-Year*10000) div 100;
          Day:=ldN-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDN;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400420');
       a.x:=b.x+round(7*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'New edition',false);
       end;

       end else begin
          ss:='New edition';
      if lDN>10000 then begin
          Year:=lDN div 10000;
          month:=(ldN-Year*10000) div 100;
          Day:=ldN-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDN;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400421');
       a.x:=b.x+round(7*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);

       end;
       end;
     end;
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);

      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
       ss:='Отпечатано в '+fframe.edPrint.text+'г.';
       lcode:=String2Code('A0400420');
       b.x:=tlfr.pol[2].x-round(50.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.x:=b.x-R[2].x+R[1].x;
       a.y:=b.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'Printed in',false);
       end;
       end else begin
        ss:='Printed in'+fframe.edPrint.text;
       b.x:=tlfr.pol[2].x-round(50.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.x:=b.x-R[2].x+R[1].x;
       a.y:=b.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;

       if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin

         ss:='Заказ';
       lcode:=String2Code('A0400420');
       b.x:=a.x-round(18.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.y:=b.y;
       a.x:=b.x-R[2].x+R[1].x;
       ss:=ss+' '+edOrder.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'Order',false);
       end;

       end else begin
          ss:='Order';
       lcode:=String2Code('A0400421');
        b.x:=a.x-round(18.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.y:=b.y;
       a.x:=b.x-R[2].x+R[1].x;
       ss:=ss+' '+edOrder.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;

       if fframe.edEkuatorScale.text<>'' then begin
       if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
       ss:='Масштаб по экватору 1:'+fframe.edEkuatorScale.text;
       lcode:=String2Code('A0400420');
       a.x:=tlfr.pol[0].x+round(50.0*kf);
       a.y:=tlfr.pol[0].y-round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       dec(a.y,round(3*kf));
       b.y:=a.y;
       ss:='Scale at the Equator 1:'+fframe.edEkuatorScale.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;
       end else begin
       ss:='Scale at the Equator 1:'+fframe.edEkuatorScale.text;
       lcode:=String2Code('A0400421');
       a.x:=tlfr.pol[0].x+round(50.0*kf);
       a.y:=tlfr.pol[0].y-round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;
      end;
       // Надпись утверждаю
       ss:='Утверждаю к изданию';
       lcode:=String2Code('Z0200090');
       a.x:=tlfr.pol[0].x+round(45.0*kf);
       a.y:=tlfr.pol[0].y-round(43.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       Centre:=a.x+(R[2].x-R[1].x) div 2;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);

       ss:='Начальник производства';
       lcode:=String2Code('Z0200110');
       a.y:=tlfr.pol[0].y-round(39.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=Centre+(R[2].x-R[1].x) div 2;;
       a.x:=Centre+(R[1].x-R[2].x) div 2;;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);

       ss:='капитан 1 ранга';
       lcode:=String2Code('Z0200120');
       a.y:=tlfr.pol[0].y-round(34.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       l1:=R[2].x-R[1].x;
       ss2:='Фридман Б.С.';
       Text_Bound(lcode,a,a,R,ss2);
       l2:=R[2].x-R[1].x;
       a.x:=Centre-(l1+l2+round(30*kf)) div 2;;
       b.x:=a.x+l1;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       a.x:=b.x+round(30*kf);
       b.x:=a.x+l2;
       nodecurr:=Add_Text(lcode,a,b,0,ss2,false);
      //Размеры
      Decimalseparator:=',';

      ss:='('+Formatfloat('0.0',(pcorn[2].x-pcorn[1].x) /kf)+'x'+
      Formatfloat('0.0',(pcorn[3].y-pcorn[2].y)/kf)+')';
      lcode:=String2Code('A0400420');
      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(tlfr.pol[2].x-R[2].x+R[1].x-150*kf);
      a.y:=tlfr.pol[2].y+round(4.0*kf);
      Add_Text(lcode,a,a,0,ss,false);
      lcode:=String2Code('A0400410');
      ss:='d='+Formatfloat('0.0',SQRT(SQR((pcorn[2].x-pcorn[1].x)/kf)+
                  SQR((pcorn[3].y-pcorn[2].y)/kf)))+'мм';
      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(tlfr.pol[2].x-R[2].x+R[1].x-160*kf);
      a.y:=tlfr.pol[2].y+round(45*kf);
      Add_Text(lcode,a,a,0,ss,false);

      Decimalseparator:='.';

      //Заготовка схемы
      if B913=9 then begin
        lcode:=String2Code('A0100010');
        lcode2:=String2Code('A0100108');
      end else begin
        lcode:=String2Code('A0100009');
        lcode2:=String2Code('A0100008');
      end;


      TL1.n:=4;
      Tl1.pol[0].x:=tlfr.pol[2].x-round(194*kf);
      Tl1.pol[0].y:=tlfr.pol[2].y+round(4.5*kf);
      Tl1.pol[1].x:=tlfr.pol[2].x-round(185*kf);
      Tl1.pol[1].y:=tlfr.pol[2].y+round(4.5*kf);
      Tl1.pol[2].x:=tlfr.pol[2].x-round(185*kf);
      Tl1.pol[2].y:=tlfr.pol[2].y+round(16.5*kf);
      Tl1.pol[3].x:=tlfr.pol[2].x-round(194*kf);
      Tl1.pol[3].y:=tlfr.pol[2].y+round(16.5*kf);
      Tl1.Pol[4]:= Tl1.Pol[0];
      dm_add_poly(lcode,3,0,@TL1,false);
      dm_add_poly(lcode2,2,0,@TL1,false);

      //цветные плашки
      case RGcolorScale.ItemIndex  of
      0: begin
      lcode:=String2Code('A0100002');
      for i:=1 to 10 do begin
      case i of
       1:lcode2:=String2Code('98800500');
       2:lcode2:=String2Code('98800502');
       3:lcode2:=String2Code('98800501');
       4:lcode2:=String2Code('98800510');
       5:lcode2:=String2Code('98800507');
       6:lcode2:=String2Code('98800509');
       7:lcode2:=String2Code('98800503');
       8:lcode2:=String2Code('98800505');
       9:lcode2:=String2Code('98800514');
      10:lcode2:=String2Code('98800504');
     end;
      TL1.n:=4;
      Tl1.pol[0].x:=tlfr.pol[2].x+round(kf);
      Tl1.pol[0].y:=pcorn[3].y-round((i-1)*6*kf);
      Tl1.pol[1].x:=tlfr.pol[2].x+round(7*kf);
      Tl1.pol[1].y:=pcorn[3].y-round((i-1)*6*kf);
      Tl1.pol[2].x:=tlfr.pol[2].x+round(7*kf);
      Tl1.pol[2].y:=pcorn[3].y-round(i*6*kf);
      Tl1.pol[3].x:=tlfr.pol[2].x+round(kf);
      Tl1.pol[3].y:=pcorn[3].y-round(i*6*kf);
      Tl1.Pol[4]:= Tl1.Pol[0];
      dm_add_poly(lcode2,3,0,@TL1,false);
      dm_add_poly(lcode,2,0,@TL1,false);
      end;
      end;
      1:begin
      lcode:=String2Code('A0100002');
      for i:=1 to 16 do begin
      case i of
       1:lcode2:=String2Code('98800500');
       2:lcode2:=String2Code('98800502');
       3:lcode2:=String2Code('98800501');
       4:lcode2:=String2Code('98800510');
       5:lcode2:=String2Code('98800507');
       6:lcode2:=String2Code('98800509');
       7:lcode2:=String2Code('98800503');
       8:lcode2:=String2Code('98800505');
       9:lcode2:=String2Code('98800514');
      10:lcode2:=String2Code('98800504');
       11:lcode2:=String2Code('98800500');
       12:lcode2:=String2Code('98800502');
       13:lcode2:=String2Code('98800501');
       14:lcode2:=String2Code('98800510');
       15:lcode2:=String2Code('98800507');
       16:lcode2:=String2Code('98800509');

     end;
      TL1.n:=4;
      Tl1.pol[0].x:=tlfr.pol[2].x+round(kf);
      Tl1.pol[0].y:=pcorn[3].y-round((i-1)*6*kf);
      Tl1.pol[1].x:=tlfr.pol[2].x+round(7*kf);
      Tl1.pol[1].y:=pcorn[3].y-round((i-1)*6*kf);
      Tl1.pol[2].x:=tlfr.pol[2].x+round(7*kf);
      Tl1.pol[2].y:=pcorn[3].y-round(i*6*kf);
      Tl1.pol[3].x:=tlfr.pol[2].x+round(kf);
      Tl1.pol[3].y:=pcorn[3].y-round(i*6*kf);
      Tl1.Pol[4]:= Tl1.Pol[0];
      dm_add_poly(lcode2,3,0,@TL1,false);
      dm_add_poly(lcode,2,0,@TL1,false);
      end;
      end;
      2: begin
         Lcode:=String2Code(MeColorSign.EditText);
         a.X:= tlfr.pol[2].x+round(kf);
         b.X:= a.X;
         a.Y:=pcorn[3].y;
         b.Y:=pcorn[3].y-round(kf);
         dm_add_sign(Lcode,a,b,0,false)
      end;
      end;

    dmw_done;
    dmw_ShowWindow(1,1,0,0);
 ShowMessage('Создано оформление');
 end;
 FPick.cli.Resume;
end;

var
 IniFile: TIniFile;
procedure TFFrame.FormCreate(Sender: TObject);
var
   ii:integer;
   ss:shortstring;
begin
MyFormatSettings := DefaultFormatSettings;
  with MyFormatSettings Do begin
     ShortDateFormat:='dd.mm.yy';
     LongDateFormat:='dd.mm.yyyy';
     DateSeparator:='.';
     decimalseparator:='.';
  end;
IniFile:=TIniFile.Create(make_ini('FrameNavy.ini'));
Height:=IniFile.ReadInteger('FRAME','Form_Height',420);
Width:=IniFile.ReadInteger('FRAME','Form_Width',810);
RgColorScale.itemIndex:=IniFile.ReadInteger('FRAME','COLORSCALE',0);
CmBxMAMS.ItemIndex:=IniFile.ReadInteger('FRAME','MAMS',0);
CBoxLang.ItemIndex:=IniFile.ReadInteger('FRAME','LANGUAGE',2);
ChBNetInterv.Checked:=IniFile.ReadBool('FRAME','NETINTERVAL',FALSE);

ChBLeft.Checked:=IniFile.ReadBool('FRAME','CHBLEFT',TRUE);
ChbRight.Checked:=IniFile.ReadBool('FRAME','CHBRIGHT',TRUE);
ChbTop.Checked:=IniFile.ReadBool('FRAME','CHBTOP',TRUE);
ChBBottom.Checked:=IniFile.ReadBool('FRAME','CHBBOTTOM',TRUE);
ChBxKM.Checked:=IniFile.ReadBool('FRAME','KMSCALE',TRUE);
ChCrMercB.Checked:=IniFile.ReadBool('FRAME','ChCrMercB',False);
ChCrMercL.Checked:=IniFile.ReadBool('FRAME','ChCrMercL',False);

ChBxKmNormal.Checked:=IniFile.ReadBool('FRAME','KMSCALENORMAL',TRUE);
ChBLog.Checked:=IniFile.ReadBool('FRAME','LOGARITHM',false);

RGKM_LR.ItemIndex:=IniFile.ReadInteger('FRAME','KM_LR',0);
DirIni:=IniFile.ReadString('FRAME','DIRINI',USR_DIR);
Dirdm:=IniFile.ReadString('FRAME','DIRINI',USR_DIR);


memmaker.Lines.BeginUpdate;
memmakerE.Lines.BeginUpdate;
memmaker.Clear;
memmakerE.Clear;
if IniFile.SectionExists('MAKER') then  begin
 for ii:=1 to 10 do begin
 ss:=ANSITOUTF8(IniFile.ReadString('MAKER','M'+Inttostr(ii),''));
 if ss<>'' then
  MemMAKER.Lines.Add(ss)
 else
 break;
 end;
 for ii:=1 to 10 do begin
 ss:=IniFile.ReadString('MAKER','ME'+Inttostr(ii),'');
 if ss<>'' then
  MemMAKERE.Lines.Add(ss)
 else
 break;
 end;

end else begin
ss:=IniFile.ReadString('MAKER','M1','Главное управление навигации и океанографии');
if ss<>'' then begin
 MemMaker.Lines.Add(ss);
end;
ss:=IniFile.ReadString('MAKER','M2','Министерства обороны Российской Федерации');
if ss<>'' then begin
 MemMaker.Lines.Add(ss);
end;
ss:=IniFile.ReadString('MAKER','M3','Санкт-Петербург');
if ss<>'' then begin
 MemMaker.Lines.Add(ss);
end;

ss:=IniFile.ReadString('MAKER','ME1','Head Department of Navigation and Oceanography,');
if ss<>'' then begin
 MemMakerE.Lines.Add(ss);
end;
ss:=IniFile.ReadString('MAKER','ME2','Russian Federation Ministry of Defence');
if ss<>'' then begin
 MemMakerE.Lines.Add(ss);
end;
ss:=IniFile.ReadString('MAKER','ME3','Sankt-Peterburg');
if ss<>'' then begin
 MemMakerE.Lines.Add(ss);
end;

end;
memmaker.Lines.EndUpdate;
memmakerE.Lines.EndUpdate;


    meMDM.EditText:=IniFile.ReadString('INTERVALS','MDM','00');
    meMDS.EditText:=IniFile.ReadString('INTERVALS','MDS','00');
    meSmInD.EditText:=IniFile.ReadString('INTERVALS','SmInD','00');
    meSmInM.EditText:=IniFile.ReadString('INTERVALS','SmInM','00');
    meSmInS.EditText:=IniFile.ReadString('INTERVALS','SmInS','00');

    meIntrD.EditText:=IniFile.ReadString('INTERVALS','IntrD','00');
    meIntrM.EditText:=IniFile.ReadString('INTERVALS','IntrM','00');
    meIntrS.EditText:=IniFile.ReadString('INTERVALS','IntrDS','00');
    meBigIntrD.EditText:=IniFile.ReadString('INTERVALS','BigIntrD','00');
    meBigIntrM.EditText:=IniFile.ReadString('INTERVALS','BigIntrM','00');
    meBigIntrS.EditText:=IniFile.ReadString('INTERVALS','BigIntrS','00');
    meTextIntrD.EditText:=IniFile.ReadString('INTERVALS','TextIntrD','00');
    meTextIntrM.EditText:=IniFile.ReadString('INTERVALS','TextIntrM','00');
    meTextIntrS.EditText:=IniFile.ReadString('INTERVALS','TextIntrS','00');
    meShrafD.EditText:=IniFile.ReadString('INTERVALS','ShrafD','00');
    meShrafM.EditText:=IniFile.ReadString('INTERVALS','ShrafM','00');
    meShrafS.EditText:=IniFile.ReadString('INTERVALS','ShrafS','00');

    meMDM_L.EditText:=IniFile.ReadString('INTERVALS','MDM_L','00');
    meMDS_L.EditText:=IniFile.ReadString('INTERVALS','MDS_L','00');
    meSmInD_L.EditText:=IniFile.ReadString('INTERVALS','SmInD_L','00');
    meSmInM_L.EditText:=IniFile.ReadString('INTERVALS','SmInM_L','00');
    meSmInS_L.EditText:=IniFile.ReadString('INTERVALS','SmInS_L','00');

    meIntrD_L.EditText:=IniFile.ReadString('INTERVALS','IntrD_L','00');
    meIntrM_L.EditText:=IniFile.ReadString('INTERVALS','IntrM_L','00');
    meIntrS_L.EditText:=IniFile.ReadString('INTERVALS','IntrDS_L','00');
    meBigIntrD_L.EditText:=IniFile.ReadString('INTERVALS','BigIntrD_L','00');
    meBigIntrM_L.EditText:=IniFile.ReadString('INTERVALS','BigIntrM_L','00');
    meBigIntrS_L.EditText:=IniFile.ReadString('INTERVALS','BigIntrS_L','00');
    meTextIntrD_L.EditText:=IniFile.ReadString('INTERVALS','TextIntrD_L','00');
    meTextIntrM_L.EditText:=IniFile.ReadString('INTERVALS','TextIntrM_L','00');
    meTextIntrS_L.EditText:=IniFile.ReadString('INTERVALS','TextIntrS_L','00');
    meShrafD_L.EditText:=IniFile.ReadString('INTERVALS','ShrafD_L','00');
    meShrafM_L.EditText:=IniFile.ReadString('INTERVALS','ShrafM_L','00');
    meShrafS_L.EditText:=IniFile.ReadString('INTERVALS','ShrafS_L','00');

    meNetDB_B.EditText:=IniFile.ReadString('NET','meNetDB_B','000');
    meNetMB_B.EditText:=IniFile.ReadString('NET','meNetMB_B','00');
    meNetSB_B.EditText:=IniFile.ReadString('NET','meNetSB_B','00');
    meNetDB_L.EditText:=IniFile.ReadString('NET','meNetDB_L','000');
    meNetMB_L.EditText:=IniFile.ReadString('NET','meNetMB_L','00');
    meNetSB_L.EditText:=IniFile.ReadString('NET','meNetSB_L','00');
ChBNetOrig.Checked:=IniFile.ReadBool('NET','NETORIGIN',FALSE);
    edOrder.Text:=IniFile.ReadString('MAIN','ORDER','');
    edPrint.Text:=IniFile.ReadString('MAIN','PRINTED','2001');
    EdEKuatorScale.Text:=IniFile.ReadString('MAIN','EKUATOR','');
    edINT.Text:=IniFile.ReadString('MAIN','INT','');
    MeColorSign.EditText:=IniFile.ReadString('MAIN','ColorSign','A0000000');

    meNetCrDB_B.EditText:=IniFile.ReadString('NET','meNetCrDB_B','000');
    meNetCrMB_B.EditText:=IniFile.ReadString('NET','meNetCrMB_B','30');
    meNetCrSB_B.EditText:=IniFile.ReadString('NET','meNetCrSB_B','00');
    meNetCrDB_L.EditText:=IniFile.ReadString('NET','meNetCrDB_L','05');
    meNetCrMB_L.EditText:=IniFile.ReadString('NET','meNetCrMB_L','00');
    meNetCrSB_L.EditText:=IniFile.ReadString('NET','meNetCrSB_L','00');
    meMaxDB.EditText:=IniFile.ReadString('NET','meMaxDB','089');
    meMaxMB.EditText:=IniFile.ReadString('NET','meMaxMB','30');
    meMaxSB.EditText:=IniFile.ReadString('NET','meMaxSB','00');

    meUMDM.EditText:=IniFile.ReadString('NET','MDM','00');
    meUMDS.EditText:=IniFile.ReadString('NET','MDS','01');
    meUSmInD.EditText:=IniFile.ReadString('NET','SmInD','00');
    meUSmInM.EditText:=IniFile.ReadString('NET','SmInM','00');
    meUSmInS.EditText:=IniFile.ReadString('NET','SmInS','06');

    meUIntrD.EditText:=IniFile.ReadString('NET','IntrD','00');
    meUIntrM.EditText:=IniFile.ReadString('NET','IntrM','00');
    meUIntrS.EditText:=IniFile.ReadString('NET','IntrDS','30');

meUBigIntrD.EditText:=IniFile.ReadString('NET','BigIntrD','00');
meUBigIntrM.EditText:=IniFile.ReadString('NET','BigIntrM','00');
meUBigIntrS.EditText:=IniFile.ReadString('NET','BigIntrS','30');

    meUMDM_L.EditText:=IniFile.ReadString('NET','MDM_L','00');
    meUMDS_L.EditText:=IniFile.ReadString('NET','MDS_L','01');
    meUSmInD_L.EditText:=IniFile.ReadString('NET','SmInD_L','00');
    meUSmInM_L.EditText:=IniFile.ReadString('NET','SmInM_L','00');
    meUSmInS_L.EditText:=IniFile.ReadString('NET','SmInS_L','06');

    meUIntrD_L.EditText:=IniFile.ReadString('NET','IntrD_L','00');
    meUIntrM_L.EditText:=IniFile.ReadString('NET','IntrM_L','00');
    meUIntrS_L.EditText:=IniFile.ReadString('NET','IntrDS_L','30');

meUBigIntrD_L.EditText:=IniFile.ReadString('NET','BigIntrD_L','00');
meUBigIntrM_L.EditText:=IniFile.ReadString('NET','BigIntrM_L','00');
meUBigIntrS_L.EditText:=IniFile.ReadString('NET','BigIntrS_L','30');
ChCrMercB.Checked:=IniFile.ReadBool('FRAME','ChCrMercB',False);
ChCrMercL.Checked:=IniFile.ReadBool('FRAME','ChCrMercL',False);

     INIFile.free;
Pi_2:=Pi*0.5;
//dmw_dde.dll_app_handle(handle)
end;

procedure TFFrame.FormDestroy(Sender: TObject);
var
  ii:integer;
  ss:shortstring;
begin
IniFile:=TIniFile.Create(make_ini('FrameNavy.ini'));
IniFile.WriteInteger('FRAME','Form_Height',Height);
IniFile.WriteInteger('FRAME','Form_Width',Width);
IniFile.ReadInteger('FRAME','COLORSCALE',RgColorScale.itemIndex);

IniFile.WriteInteger('FRAME','MAMS',CmBxMAMS.ItemIndex);
IniFile.WriteInteger('FRAME','LANGUAGE',CBoxLang.ItemIndex);
IniFile.WriteString('FRAME','DIRINI',DirIni);
IniFile.WriteBool('FRAME','NETINTERVAL',ChBNetInterv.Checked);

IniFile.WriteBool('FRAME','CHBLEFT',ChBLeft.Checked);
IniFile.WriteBool('FRAME','CHBRIGHT',ChbRight.Checked);
IniFile.WriteBool('FRAME','CHBTOP',ChbTop.Checked);
IniFile.WriteBool('FRAME','CHBBOTTOM',ChBBottom.Checked);
IniFile.WriteBool('FRAME','KMSCALE',ChBxKM.Checked);
IniFile.WriteBool('FRAME','KMSCALENORMAL',ChBxKmNormal.Checked);
IniFile.WriteBool('FRAME','LOGARITHM',ChBLog.Checked);

IniFile.WriteInteger('FRAME','KM_LR',RGKM_LR.ItemIndex);

IniFile.EraseSection('PROD');
IniFile.WriteString('PROD','EX','1');


IniFile.EraseSection('CHISLO');
IniFile.WriteString('CHISLO','EX','1');

IniFile.EraseSection('MAKER');
IniFile.WriteString('MAKER','EX','1');

for ii:=1 to MemMaker.Lines.Count do begin
ss:=UTF8TOANSI(memMaker.Lines.Strings[ii-1]);
if ss<>'' then
IniFile.WriteString('MAKER','M'+Inttostr(ii),ss);
end;
for ii:=1 to MemMakerE.Lines.Count do begin
ss:=memMakerE.Lines.Strings[ii-1];
if ss<>'' then
IniFile.WriteString('MAKER','ME'+Inttostr(ii),ss);
end;


 IniFile.WriteString('INTERVALS','MDM',meMDM.EditText);
 IniFile.WriteString('INTERVALS','MDS',meMDS.EditText);
 IniFile.WriteString('INTERVALS','SmInD',meSmInD.EditText);
 IniFile.WriteString('INTERVALS','SmInM',meSmInM.EditText);
 IniFile.WriteString('INTERVALS','SmInS',meSmInS.EditText);
 IniFile.WriteString('INTERVALS','IntrD', meIntrD.EditText);
 IniFile.WriteString('INTERVALS','IntrM', meIntrM.EditText);
 IniFile.WriteString('INTERVALS','IntrDS',meIntrS.EditText);
 IniFile.WriteString('INTERVALS','BigIntrD',meBigIntrD.EditText);
 IniFile.WriteString('INTERVALS','BigIntrM',meBigIntrM.EditText);
 IniFile.WriteString('INTERVALS','BigIntrS',meBigIntrS.EditText);
 IniFile.WriteString('INTERVALS','TextIntrD',meTextIntrD.EditText);
 IniFile.WriteString('INTERVALS','TextIntrM',meTextIntrM.EditText);
 IniFile.WriteString('INTERVALS','TextIntrS', meTextIntrS.EditText);
 IniFile.WriteString('INTERVALS','ShrafD',meShrafD.EditText);
 IniFile.WriteString('INTERVALS','ShrafM', meShrafM.EditText);
 IniFile.WriteString('INTERVALS','ShrafS',meShrafS.EditText);

 IniFile.WriteString('INTERVALS','MDM_L',meMDM_L.EditText);
 IniFile.WriteString('INTERVALS','MDS_L',meMDS_L.EditText);
 IniFile.WriteString('INTERVALS','SmInD_L',meSmInD_L.EditText);
 IniFile.WriteString('INTERVALS','SmInM_L',meSmInM_L.EditText);
 IniFile.WriteString('INTERVALS','SmInS_L',meSmInS_L.EditText);
 IniFile.WriteString('INTERVALS','IntrD_L', meIntrD_L.EditText);
 IniFile.WriteString('INTERVALS','IntrM_L', meIntrM_L.EditText);
 IniFile.WriteString('INTERVALS','IntrDS_L',meIntrS_L.EditText);
 IniFile.WriteString('INTERVALS','BigIntrD_L',meBigIntrD_L.EditText);
 IniFile.WriteString('INTERVALS','BigIntrM_L',meBigIntrM_L.EditText);
 IniFile.WriteString('INTERVALS','BigIntrS_L',meBigIntrS_L.EditText);
 IniFile.WriteString('INTERVALS','TextIntrD_L',meTextIntrD_L.EditText);
 IniFile.WriteString('INTERVALS','TextIntrM_L',meTextIntrM_L.EditText);
 IniFile.WriteString('INTERVALS','TextIntrS_L', meTextIntrS_L.EditText);
 IniFile.WriteString('INTERVALS','ShrafD_L',meShrafD_L.EditText);
 IniFile.WriteString('INTERVALS','ShrafM_L', meShrafM_L.EditText);
 IniFile.WriteString('INTERVALS','ShrafS_L',meShrafS_L.EditText);
   IniFile.WriteString('NET','meNetDB_B',meNetDB_B.EditText);
   IniFile.WriteString('NET','meNetMB_B',meNetMB_B.EditText);
   IniFile.WriteString('NET','meNetSB_B',meNetSB_B.EditText);
   IniFile.WriteString('NET','meNetDB_L',meNetDB_L.EditText);
   IniFile.WriteString('NET','meNetMB_L',meNetMB_L.EditText);
   IniFile.WriteString('NET','meNetSB_L',meNetSB_L.EditText);
   IniFile.WriteBool('NET','NETORIGIN',ChBNetOrig.Checked);
   IniFile.WriteString('MAIN','ORDER',edOrder.Text);
   IniFile.WriteString('MAIN','PRINTED',edPrint.Text);
   IniFile.WriteString('MAIN','EKUATOR',  EdEKuatorScale.Text);
   IniFile.WriteString('MAIN','INT', edINT.Text);
   IniFile.WriteString('MAIN','ColorSign',MeColorSign.EditText);


   IniFile.WriteString('NET','meNetCrDB_B',meNetCrDB_B.EditText);
   IniFile.WriteString('NET','meNetCrMB_B',meNetCrMB_B.EditText);
   IniFile.WriteString('NET','meNetCrSB_B',meNetCrSB_B.EditText);
   IniFile.WriteString('NET','meNetCrDB_L',meNetCrDB_L.EditText);
   IniFile.WriteString('NET','meNetCrMB_L',meNetCrMB_L.EditText);
   IniFile.WriteString('NET','meNetCrSB_L',meNetCrSB_L.EditText);
   IniFile.WriteString('NET','meMaxDB',meMaxDB.EditText);
   IniFile.WriteString('NET','meMaxMB',meMaxMB.EditText);
   IniFile.WriteString('NET','meMaxSB',meMaxSB.EditText);

 IniFile.WriteString('NET','MDM',meUMDM.EditText);
 IniFile.WriteString('NET','MDS',meUMDS.EditText);
 IniFile.WriteString('NET','SmInD',meUSmInD.EditText);
 IniFile.WriteString('NET','SmInM',meUSmInM.EditText);
 IniFile.WriteString('NET','SmInS',meUSmInS.EditText);
 IniFile.WriteString('NET','IntrD', meUIntrD.EditText);
 IniFile.WriteString('NET','IntrM', meUIntrM.EditText);
 IniFile.WriteString('NET','IntrDS',meUIntrS.EditText);

 IniFile.WriteString('NET','BigIntrD',meUBigIntrD.EditText);
 IniFile.WriteString('NET','BigIntrM',meUBigIntrM.EditText);
 IniFile.WriteString('NET','BigIntrS',meUBigIntrS.EditText);
 IniFile.WriteString('NET','MDM_L',meUMDM_L.EditText);
 IniFile.WriteString('NET','MDS_L',meUMDS_L.EditText);
 IniFile.WriteString('NET','SmInD_L',meUSmInD_L.EditText);
 IniFile.WriteString('NET','SmInM_L',meUSmInM_L.EditText);
 IniFile.WriteString('NET','SmInS_L',meUSmInS_L.EditText);
 IniFile.WriteString('NET','IntrD_L', meUIntrD_L.EditText);
 IniFile.WriteString('NET','IntrM_L', meUIntrM_L.EditText);
 IniFile.WriteString('NET','IntrDS_L',meUIntrS_L.EditText);

 IniFile.WriteString('NET','BigIntrD_L',meUBigIntrD_L.EditText);
 IniFile.WriteString('NET','BigIntrM_L',meUBigIntrM_L.EditText);
 IniFile.WriteString('NET','BigIntrS_L',meUBigIntrS_L.EditText);
 IniFile.WriteBool('FRAME','ChCrMercB',ChCrMercB.Checked);
 IniFile.WriteBool('FRAME','ChCrMercL',ChCrMercL.Checked);


 INIFile.free;
end;

procedure TFFrame.Button2Click(Sender: TObject);
var
 BM:double;
 iscale:longint;
 sName:shortstring;
 nm:pchar;
 deg,min, sec:shortstring;

begin
if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
  end;

dm_Goto_root;
 if dm_get_long(904,0,iscale) then begin
{ if  (iscale<>1000)and (iscale<>2000) and (iscale<>2500) and
    (iscale<>1500)and (iscale<>2000) and (iscale<>3000) and
(iscale<>4000)and (iscale<>5000) and (iscale<>6000) and
(iscale<>7000)and (iscale<>7500) and (iscale<>10000) and
(iscale<>12500)and (iscale<>15000) and (iscale<>20000) and (iscale<>25000) and
// карты
(iscale<>30000)and (iscale<>50000) and (iscale<>75000) and
    (iscale<>100000)and (iscale<>150000) and (iscale<>200000) and
(iscale<>250000)and (iscale<>300000) and (iscale<>500000) and
(iscale<>750000)and (iscale<>1000000) and   (iscale<>1500000) and
(iscale<>2000000)and (iscale<>2500000) and (iscale<>3000000) and
(iscale<>5000000) then begin
   dmw_done;
   Showmessage('Не поддерживаемый масштаб планов или карт');
   exit
 end;
 }
 fltopo:=dm_pps=1;
if fframe.ChBNetInterv.checked then begin
if not dm_get_double(971,0,netintb) then netintb:=0;
if not dm_get_double(972,0,netintl) then netintl:=0;
end;
 if not Dm_GET_double(991,0,BM) then begin
   dmw_done;
   Showmessage('Нет опорной параллели');
   exit
 end;

 BMgr:=abs(BM/PI*180);
 if iscale<=1000 then Nomenkl.scale:=_sc1
 else
 if iscale<=1500 then Nomenkl.scale:=_sc1_5
 else
 if iscale<=2000 then Nomenkl.scale:=_sc2
 else
 if iscale<=2500 then Nomenkl.scale:=_sc2_5
 else
 if iscale<=3000 then Nomenkl.scale:=_sc3
 else
 if iscale<=4000 then Nomenkl.scale:=_sc4
 else
 if iscale<=5000 then Nomenkl.scale:=_sc5
 else
 if iscale<=6000 then Nomenkl.scale:=_sc6
 else
 if iscale<=7000 then Nomenkl.scale:=_sc7
 else
 if iscale<=7500 then Nomenkl.scale:=_sc7_5
 else
 if iscale<=10000 then Nomenkl.scale:=_sc10
 else
 if iscale<=12500 then Nomenkl.scale:=_sc12_5
 else
 if iscale<=15000 then Nomenkl.scale:=_sc15
 else
 if iscale<=17500 then Nomenkl.scale:=_sc17_5
 else
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
  else
 if iscale<=37500 then Nomenkl.scale:=_scM37_5
  else
 if iscale<=40000 then Nomenkl.scale:=_scM40
  else
 if iscale<=50000 then Nomenkl.scale:=_scM50
  else
 if iscale<=75000 then Nomenkl.scale:=_scM75
  else
 if iscale<=100000 then Nomenkl.scale:=_scM100
  else
 if iscale<=150000 then Nomenkl.scale:=_scM150
  else
 if iscale<=200000 then Nomenkl.scale:=_scM200
  else
 if iscale<=250000 then Nomenkl.scale:=_scM250
  else
 if iscale<=300000 then Nomenkl.scale:=_scM300
  else
 if iscale<=500000 then Nomenkl.scale:=_scM500
  else
 if iscale<=750000 then Nomenkl.scale:=_scM750
  else
 if iscale<=1000000 then Nomenkl.scale:=_scM1000
  else
 if iscale<=1500000 then Nomenkl.scale:=_scM1500
  else
 if iscale<=2000000 then Nomenkl.scale:=_scM2000
   else
 if iscale<=2500000 then Nomenkl.scale:=_scM2500
   else
 if iscale<=3000000 then Nomenkl.scale:=_scM3000
   else
 if iscale<=5000000 then Nomenkl.scale:=_scM5000
   else
 if iscale<=10000000 then Nomenkl.scale:=_scM10000
 else
 Nomenkl.scale:=_scM10000;
 scale:=iscale;
 //if dm_Get_String(901,255,ss) then begin    Номенклатура
   ChBxKmNormal.Checked:=(Nomenkl.scale>=_sc20) and (Nomenkl.scale<=_scM5000);
   Chblog.Checked:=Nomenkl.scale>=_sc20;

   Shraf:=0;
   Set_intervals;
   Rad2DMS(minDiv,deg,min,sec);
   memdm.EditText:=min;
   memds.EditText:=sec;

   Rad2DMS(smInterv*minDiv,deg,min,sec);
   meSmInD.EditText:=deg;
   meSmInM.EditText:=min;
   meSmInS.EditText:=sec;

   Rad2DMS(intermInterval*minDiv,deg,min,sec);
   meIntrD.EditText:=deg;
   meIntrM.EditText:=min;
   meIntrS.EditText:=sec;

   Rad2DMS(textinterv*minDiv,deg,min,sec);
   meTextIntrD.EditText:=deg;
   meTextIntrM.EditText:=min;
   meTextIntrS.EditText:=sec;

   Rad2DMS(Biginterval*minDiv,deg,min,sec);
   meBigIntrD.EditText:=deg;
   meBigIntrM.EditText:=min;
   meBigIntrS.EditText:=sec;
   if Shraf<>0 then begin
   meShrafD.Enabled:=true;
   meShrafm.Enabled:=true;
   meShrafs.Enabled:=true;

    Rad2DMS(Shraf*minDiv,deg,min,sec);
   meShrafD.EditText:=deg;
   meShrafM.EditText:=min;
   meShrafS.EditText:=sec;
   end else begin
   meShrafD.Enabled:=false;
   meShrafm.Enabled:=false;
   meShrafs.Enabled:=false;
   end;
   Rad2DMS(minDivL,deg,min,sec);
   memdm_L.EditText:=min;
   memds_L.EditText:=sec;

   Rad2DMS(smIntervL*minDivL,deg,min,sec);
   meSmInD_L.EditText:=deg;
   meSmInM_L.EditText:=min;
   meSmInS_L.EditText:=sec;

   Rad2DMS(intermIntervalL*minDivL,deg,min,sec);
   meIntrD_L.EditText:=deg;
   meIntrM_L.EditText:=min;
   meIntrS_L.EditText:=sec;

   Rad2DMS(textintervL*minDivL,deg,min,sec);
   meTextIntrD_L.EditText:=deg;
   meTextIntrM_L.EditText:=min;
   meTextIntrS_L.EditText:=sec;

   Rad2DMS(BigintervalL*minDivL,deg,min,sec);
   meBigIntrD_L.EditText:=deg;
   meBigIntrM_L.EditText:=min;
   meBigIntrS_L.EditText:=sec;
   if Shrafl<>0 then begin
   meShrafD_L.Enabled:=true;
   meShrafm_L.Enabled:=true;
   meShrafs_L.Enabled:=true;

   Rad2DMS(ShrafL*minDivL,deg,min,sec);
   meShrafD_L.EditText:=deg;
   meShrafM_L.EditText:=min;
   meShrafS_L.EditText:=sec;
   end else begin
   meShrafD_L.Enabled:=false;
   meShrafm_L.Enabled:=false;
   meShrafs_L.Enabled:=false;

   end;
 end else begin
   dmw_done;
   exit
   end;
   dmw_done;

end;

procedure Make_grad_labels_Vert_on_map(atop,abott:lpoint);
var nlb,nlbdiv,codethin,codes,codet,codeBig,Textgrad:integer;
grad,min,sign: integer;
dtg,rctop,rcbott:tgauss;
a,b,lshraf1,lshraf2:lpoint;
sec,kk:extended;
ss:shortstring;
flgrad,flfirst,flten,flend,rightside:boolean;
bf:byte;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  codethin:=String2Code('A0100002');
   codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  with Fframe do
  Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600);

  dm_l_to_R(atop.x,atop.y,rctop.x,rctop.y);
  dm_l_to_R(abott.x,abott.y,rcbott.x,rcbott.y);
  rightside:=rctop.x<rcbott.x;
  if Rightside then begin
  a:=aTop;
  aTop:=aBott;
  abott:=a;
  dtg:=rctop;
  rctop:=rcbott;
  rcbott:=dtg;
  kk:=kf
  end else
  kk:=-kf;
  if Fframe.ChB1tip.checked then
  Tl1.pol[0].y:=atop.y-round(2*kf)
  else
  Tl1.pol[0].y:=atop.y;
  Tl1.pol[0].x:=atop.x+round(kk);

  if Fframe.ChB2tip.checked then
  Tl1.pol[1].y:=abott.y+round(2*kf)
  else
  Tl1.pol[1].y:=aBott.y;
  Tl1.pol[1].x:=abott.x+round(kk);
  dm_Add_Poly(codethin,2,0,@TL1,false);
  inc(Tl1.pol[0].x,round(kk));
  inc(Tl1.pol[1].x,round(kk));
  dm_Add_Poly(codethin,2,0,@TL1,false);

   kk:=minDiv;
    Rad_grad(abs(Rctop.x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if RcTop.x>=0 then
    sign:=1
    else
    sign:=-1;
    flgrad:= Rcbott.x<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcbott.x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcbott.x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if dtg.x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);
    bf:=0;
    //По широте
    dtg.Y:=rcBott.Y;

    repeat
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;


    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=rctop.x-0.25*kk<dtg.x;

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(1.5*kf);
    end;
    if not RightSide then begin

    if nlb mod Biginterval = 0 then begin
      b.Y:=a.Y;
      b.X:=a.X-round(11.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2+5.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin

      b.y:=a.y;
      b.x:=a.x-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2+5.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2+5.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
       if flend or (bf=0) then
        b.x:=a.x-round(2*kf)
      else
      b.x:=a.x-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     end;
     if nlb mod Shraf = 0 then begin
         if RcBott.x>0 then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);

         if nlbdiv mod 2 =1 then begin
           lshraf1.y:=a.y;
           lshraf1.x:=a.x-round(1.5*kf);
         end
         else begin
           if lshraf1.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           if not RightSide then
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.y:=0;
         end;
     end;
     if bf=0 then begin

    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(1.5*kf);
    bf:=1;
    flend:=true
    end;
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     if RightSide then begin
    if nlb mod Biginterval = 0 then begin

      b.y:=a.y;
      b.x:=a.x+round(11.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2-5.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2-5.75*KF);

      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2-5.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
     end else if nlb mod interminterval = 0 then begin

      b.y:=a.y;
      b.x:=a.x+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2-5.75*KF);

      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2-5.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      if flend or (bf=0) then
        b.x:=a.x+round(2*kf)
      else
        b.x:=a.x+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      if nlb mod Shraf = 0 then begin
         if RcBott.x>0 then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(1.5*kf);
         end
         else begin
           if lshraf2.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           lshraf2.y:=0;
         end;
     end;
      end;
       dtg.x:=dtg.x+kk;
        if Rcbott.x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rctop.x+0.25*kk<dtg.x;
      if lshraf1.y<>0 then begin
          dtg.x:=Rctop.x;
          if rightSide then begin
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end else begin
           //dtg.y:=Rcorners[1].y;
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
     end;
end;

procedure Make_grad_labels_Hor_on_map(aleft,aright:lpoint);
var i,nn,nlb,nlbdiv,codethin,codes,codet,codeBig,codemindiv,
codemindiv_blue,lx,lx1,lx2,lx3,TextgradL:integer;
grad,min,sign: integer;
dtg,dtg2, rcleft,rcright:tgauss;
a,aa,b,lpc,l0,lshraf1,lshraf2:lpoint;
sec,kk,dmm:extended;
ss:shortstring;
flgrad,flfirst,flten,flend,topside:boolean;
bmindiv,bf:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  codethin:=String2code('A0100002');
   codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');
  with Fframe do begin
  TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext, MyFormatSettings)/3600);
end;

  dm_l_to_R(aleft.x,aleft.y,rcleft.x,rcleft.y);
  dm_l_to_R(aright.x,aright.y,rcright.x,rcright.y);

  topside:=rcleft.y>rcright.y;
  if topside then begin
  a:=aleft;
  aleft:=aright;
  aright:=a;
  dtg:=rcleft;
  rcleft:=rcright;
  rcright:=dtg;
  kk:=-kf;
  end else
  kk:=kf;

  if Fframe.ChB1tip.checked then
  Tl1.pol[0].x:=aleft.x-round(2*kf)
  else
  Tl1.pol[0].x:=aleft.x;
  Tl1.pol[0].y:=aleft.y+round(kk);

  if Fframe.ChB2tip.checked then
  Tl1.pol[1].x:=aright.x+round(2*kf)
  else
  Tl1.pol[1].x:=aright.x;
  Tl1.pol[1].y:=aright.y+round(kk);
  dm_Add_Poly(codethin,2,0,@TL1,false);
  inc(Tl1.pol[0].y,round(kk));
  inc(Tl1.pol[1].y,round(kk));
  dm_Add_Poly(codethin,2,0,@TL1,false);

  kk:=minDivL;


    LongtRad_grad(abs(Rcright.y),grad,min,sec);
    if Rcright.y>=0 then sign:=1 else sign:=-1;
   
    flgrad:= Rcleft.y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcleft.y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=RcLeft.y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
      if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if dtg.y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);
    bf:=0;
    //По долготе
    dtg.x:=rcleft.x;

    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcRight.y-0.25*kk<dtg.y;
    if bf=0 then begin
    lshraf1.x:=a.x;
    lshraf1.y:=a.y-round(1.5*kf);
    end;
     if Topside then begin

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
         if bmindiv=0 then bmindiv:=1;

        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)/2);
        b.y:=a.y-round(4.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y-round(11.5*kf);
      b.y:=a.y+round(4.4*kf);
      dm_add_sign(codes,aa,b,0,false);
    end else if nlb mod intermintervall = 0 then begin

     b.x:=a.x;
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
         if bmindiv=0 then bmindiv:=1;

        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)/2);
        b.y:=a.y-round(4.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);

     end else begin
      b.x:=a.x;
      if flend or (bf=0) then
        b.y:=a.y-round(2*kf)
      else
        b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     end;
     if nlb mod ShrafL = 0 then begin
         Make_Shraf_Y(codes,-1.5,dtg.y,mindivl,Lshraf1,a);

     end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(1.5*kf);
    bf:=1;
    flend:=true
    end;
    if not Topside then begin

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      {ss:='E';
      Text_Bound(codebig,a,a,R,ss);
      lx3:=R[2].x-R[1].x;
      }
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y+round(7.3*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y+round(7.3*kf);
      if flfirst then begin
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      ss:=ss+'°'+litera
      end
      else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(7.3*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y+round(11.5*kf);
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,aa,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin


      b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(7.3*kf);
       if flfirst then begin
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      end else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false;
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(7.3*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
       if flend or (bf=0) then
        b.y:=a.y+round(2*kf)
      else
        b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
           Make_Shraf_Y(codes,1.5,dtg.y,mindivl,Lshraf2,a);
     end;

      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*kk*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=a.y+round(8.3*kf);

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin

       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
        Text_Bound(codeMinDiv,a,a,R,ss);
         aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       aa.y:=lpc.y;
       if FFrame.CboxLang.itemindex=2 then
         // aa.y:=aa.y-round(1.2*kf);
       Add_Text(codeMinDiv,aa,aa,0,ss,false);

      {lpc.x:=lpc.x-round((R[2].x-R[1].x)/2);
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y-round(1.2*kf);

      Add_Text(codeMinDiv,lpc,lpc,0,ss,false);
      }
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       if FFrame.CboxLang.itemindex<>2 then begin
        Text_Bound(codeMinDiv_blue,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,aa,aa,0,ss,false);
       end;
     {   Text_Bound(codeMinDiv_blue,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)/2);
      end;
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,lpc,lpc,0,ss,false);
       end;  }
      end;
      bmindiv:=2;
      end;
      end;
        if RcLeft.y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg.y:=dtg.y+kk;
     until rcright.y+0.25*kk<dtg.y;

      if lshraf1.x<>0 then begin
          dtg.y:=Rcright.y;
          if not TopSide then begin
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end else begin
             dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
     end;

end;

procedure Make_grad_labels_Hor_on_Plan(aleft,aright:lpoint);
var nlb,codes,codet,codeBig,codemindiv,codemindiv_blue,lx1,lx2:integer;
grad,min,sign: integer;
dtg,dtg2,rcleft,rcright:tgauss;
a,aa,b,lpc:lpoint;
sec,kk:extended;
ss:shortstring;
flgrad,flfirst,flten,topside:boolean;
bmindiv:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');
   dm_l_to_R(aleft.x,aleft.y,rcleft.x,rcleft.y);
  dm_l_to_R(aright.x,aright.y,rcright.x,rcright.y);
  topside:=rcleft.y>rcright.y;
  if topside then begin
  a:=aleft;
  aleft:=aright;
  aright:=a;
  dtg:=rcleft;
  rcleft:=rcright;
  rcright:=dtg
  end;

    LongtRad_grad(abs(RcRight.y),grad,min,sec);
    if RcRight.y>=0 then sign:=1 else sign:=-1;

    flgrad:= RcLeft.y<=Sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=RcLeft.y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg:=RcLeft;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
  
    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
     if dtg.y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

       //По долготе
    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);
   
    if topside then begin
    dtg.x:=rcleft.x;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;

      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'°';
      Add_Text(codeBig,b,b,0,ss,false);

      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      a.y:=a.y-round(11.5*kf);
      b.y:=a.y+round(4.4*kf);
      dm_add_sign(codes,a,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then
       if nlb mod textintervL = 0 then begin

      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(4.2*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
      b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
  end else begin

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      {ss:='E';
      Text_Bound(codebig,a,a,R,ss);
      lx3:=R[2].x-R[1].x;
      }
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=a.y+round(7.3*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      if (dtg.y>=0) and (dtg.y<=Pi)then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(7.3*kf);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(7.3*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      a.y:=a.y+round(11.5*kf);
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then
      if nlb mod textintervL = 0 then begin
      if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(7.3*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
      b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*kk*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=a.y+round(8.3*kf);
       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin
       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       Text_Bound(codeMinDiv,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       aa.y:=lpc.y;
       if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y-round(1.2*kf);
       Add_Text(codeMinDiv,aa,aa,0,ss,false);
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       Text_Bound(codeMinDiv_blue,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,aa,aa,0,ss,false);
       end;
      bmindiv:=2;
      end;
      end;
      dtg.y:=dtg.y+kk;
      if RcLeft.y>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcRight.y<dtg.y;


end;

procedure Make_grad_labels_Vert_on_Plan(atop,abott:lpoint);
var nlb,codes,codet,codeBig:integer;
grad,min,sign: integer;
dtg,dtg2,rctop,rcbott:tgauss;
a,b:lpoint;
sec:extended;
ss:shortstring;
flgrad,flfirst,flten,Rightside:boolean;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;

  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  dm_l_to_R(atop.x,atop.y,rctop.x,rctop.y);
  dm_l_to_R(abott.x,abott.y,rcbott.x,rcbott.y);
  rightside:=rctop.x<rcbott.x;
  if Rightside then begin
  dtg:=rctop;
  rctop:=rcbott;
  rcbott:=dtg
  end;
  kk:=minDiv;
  dtg:=rcbott;
  Rad_grad(abs(RcTop.x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
      if Rcorners[1].x>=0 then
    sign:=1
    else
    sign:=-1;
      flgrad:= Rcbott.x<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcbott.x<=(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcbott.x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if dtg.x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

    repeat
    dtg.Y:=rcbott.Y;
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod Biginterval = 0 then begin

      b.Y:=a.Y;
      if Rightside then
        b.X:=a.X+round(11.5*kf)
      else
        b.X:=a.X-round(11.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x)*0.5+5.75*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x)*0.5+5.75*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x)*0.5+5.75*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x)*0.5+5.75*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin

      b.y:=a.y;
       if Rightside then
        b.x:=a.x+round(3.5*kf)
      else
        b.x:=a.x-round(3.5*kf);

      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then

      if nlb mod textinterv = 0 then begin
      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round(4.2*kf)
      else
      b.x:=a.x-round((R[2].x-R[1].x)+4.2*kf);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      if Rightside then
      b.x:=a.x+round(2.0*kf)
      else
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      if Rightside then
      b.x:=a.x+round(kf)
      else
      b.x:=a.x-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     dtg2:=dtg;
       dtg.x:=dtg.x+kk;
        if RcBott.x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcTop.x<dtg.x;
end;

//Для врезок
procedure Make_grad_labels_Vert_on_VRZmap(atop,abott:lpoint);
var nlb,nlbdiv,codethin,codes,codet,codeBig:integer;
grad,min,sign: integer;
dtg,rctop,rcbott:tgauss;
a,b,lshraf1,lshraf2:lpoint;
sec,kk:extended;
ss:shortstring;
flgrad,flfirst,flten,flend,rightside:boolean;
bf:byte;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  codethin:=String2Code('A0100002');
   codes:=String2Code('A0100003');
  codet:=String2Code('A0400330');
  codeBig:=String2Code('A0400313');
  dm_l_to_R(atop.x,atop.y,rctop.x,rctop.y);
  dm_l_to_R(abott.x,abott.y,rcbott.x,rcbott.y);
  rightside:=rctop.x<rcbott.x;
  if Rightside then begin
  a:=aTop;
  aTop:=aBott;
  abott:=a;
  dtg:=rctop;
  rctop:=rcbott;
  rcbott:=dtg;
  kk:=kf
  end else
  kk:=-kf;
  if Fframe.ChB1tip.checked then
  Tl1.pol[0].y:=atop.y-round(2*kf)
  else
  Tl1.pol[0].y:=atop.y;
  Tl1.pol[0].x:=atop.x+round(kk);

  if Fframe.ChB2tip.checked then
  Tl1.pol[1].y:=abott.y+round(2*kf)
  else
  Tl1.pol[1].y:=aBott.y;
  Tl1.pol[1].x:=abott.x+round(kk);
  dm_Add_Poly(codethin,2,0,@TL1,false);
  inc(Tl1.pol[0].x,round(kk));
  inc(Tl1.pol[1].x,round(kk));
  dm_Add_Poly(codethin,2,0,@TL1,false);

   kk:=minDiv;
    Rad_grad(abs(Rctop.x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if RcTop.x>=0 then
    sign:=1
    else
    sign:=-1;
    flgrad:= Rcbott.x<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcbott.x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcbott.x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if dtg.x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);
    bf:=0;
    //По широте
    dtg.Y:=rcBott.Y;

    repeat
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;


    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=rctop.x-0.25*kk<dtg.x;

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(1.5*kf);
    end;
    if not RightSide then begin

    if nlb mod Biginterval = 0 then begin
      b.Y:=a.Y;
      b.X:=a.X-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);

      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2+3.35*KF);
      b.y:=a.y-round(0.4*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2+3.35*KF);
      b.y:=a.y+round(2.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2+3.35*KF);
      b.y:=a.y-round(0.4*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2+3.35*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin

      b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);

       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2+3.35*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2+3.35*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
       if flend or (bf=0) then
        b.x:=a.x-round(2*kf)
      else
      b.x:=a.x-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     end;
     if nlb mod Shraf = 0 then begin
         if RcBott.x>0 then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);

         if nlbdiv mod 2 =1 then begin
           lshraf1.y:=a.y;
           lshraf1.x:=a.x-round(1.5*kf);
         end
         else begin
           if lshraf1.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           if not RightSide then
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.y:=0;
         end;
     end;
     if bf=0 then begin

    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(1.5*kf);
    bf:=1;
    flend:=true
    end;
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     if RightSide then begin
    if nlb mod Biginterval = 0 then begin

      b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2-3.35*KF);
      b.y:=a.y-round(0.4*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2-3.35*KF);

      b.y:=a.y+round(2.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2-3.35*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2-3.35*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
     end else if nlb mod interminterval = 0 then begin

      b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2-3.35*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x) div 2-3.35*KF);
      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      if flend or (bf=0) then
        b.x:=a.x+round(2*kf)
      else
        b.x:=a.x+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      if nlb mod Shraf = 0 then begin
         if RcBott.x>0 then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(1.5*kf);
         end
         else begin
           if lshraf2.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           lshraf2.y:=0;
         end;
     end;
      end;
       dtg.x:=dtg.x+kk;
        if Rcbott.x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rctop.x+0.25*kk<dtg.x;
      if lshraf1.y<>0 then begin
          dtg.x:=Rctop.x;
          if rightSide then begin
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end else begin
           //dtg.y:=Rcorners[1].y;
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
     end;
end;

procedure Make_grad_labels_Hor_on_VRZmap(aleft,aright:lpoint);
var i,nn,nlb,nlbdiv,codethin,codes,codet,codeBig,codemindiv,codemindiv_blue,lx,lx1,lx2,lx3:integer;
grad,min,sign: integer;
dtg,dtg2, rcleft,rcright:tgauss;
a,aa,b,lpc,l0,lshraf1,lshraf2:lpoint;
sec,kk,dmm:extended;
ss:shortstring;
flgrad,flfirst,flten,flend,topside:boolean;
bmindiv,bf:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  codethin:=String2code('A0100002');
   codes:=String2Code('A0100003');
  codet:=String2Code('A0400330');
  codeBig:=String2Code('A0400313');
  codemindiv:=String2Code('Z0200123');
  codemindiv_blue:=String2Code('Z0200124');
  dm_l_to_R(aleft.x,aleft.y,rcleft.x,rcleft.y);
  dm_l_to_R(aright.x,aright.y,rcright.x,rcright.y);

  topside:=rcleft.y>rcright.y;
  if topside then begin
  a:=aleft;
  aleft:=aright;
  aright:=a;
  dtg:=rcleft;
  rcleft:=rcright;
  rcright:=dtg;
  kk:=-kf;
  end else
  kk:=kf;

  if Fframe.ChB1tip.checked then
  Tl1.pol[0].x:=aleft.x-round(2*kf)
  else
  Tl1.pol[0].x:=aleft.x;
  Tl1.pol[0].y:=aleft.y+round(kk);

  if Fframe.ChB2tip.checked then
  Tl1.pol[1].x:=aright.x+round(2*kf)
  else
  Tl1.pol[1].x:=aright.x;
  Tl1.pol[1].y:=aright.y+round(kk);
  dm_Add_Poly(codethin,2,0,@TL1,false);
  inc(Tl1.pol[0].y,round(kk));
  inc(Tl1.pol[1].y,round(kk));
  dm_Add_Poly(codethin,2,0,@TL1,false);

  kk:=minDivL;


    LongtRad_grad(abs(Rcright.y),grad,min,sec);
    if Rcright.y>=0 then sign:=1 else sign:=-1;
   
    flgrad:= Rcleft.y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcleft.y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=RcLeft.y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
   
    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if dtg.y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);
    bf:=0;
    //По долготе
    dtg.x:=rcleft.x;

    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcRight.y-0.25*kk<dtg.y;
    if bf=0 then begin
    lshraf1.x:=a.x;
    lshraf1.y:=a.y-round(1.5*kf);
    end;
     if Topside then begin

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(4.1*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-(R[2].x-R[1].x) div 2;
        b.y:=a.y-round(4.1*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(4.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      {b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y-round(11.5*kf);
      b.y:=a.y+round(4.4*kf);
      dm_add_sign(codes,aa,b,0,false);
      }
    end else if nlb mod intermintervall = 0 then begin

     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)/2);
        b.y:=a.y-round(4.1*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-(R[2].x-R[1].x) div 2;
      b.y:=a.y-round(4.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);

     end else begin
      b.x:=a.x;
      if flend or (bf=0) then
        b.y:=a.y-round(2*kf)
      else
        b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     end;
     if nlb mod ShrafL = 0 then begin
          if TopSide then
             Make_Shraf_Y(codes,-1.5,dtg.y,mindivl,Lshraf1,a);
         {
         if RcLeft.y>0 then
         nlbdiv:=abs(nlb div ShrafL)
         else
         nlbdiv:=abs(nlb div ShrafL+1);

         if nlbdiv  mod 2 =1 then begin
           lshraf1.x:=a.x;
           lshraf1.y:=a.y-round(1.5*kf);
         end
         else begin
           if a.x<>lshraf1.x then begin
           b.x:=a.x;
           b.y:=a.y-round(1.5*kf);
           if TopSide then
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           Lshraf1.x:=0;
         end;
         }
     end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(1.5*kf);
    bf:=1;
    flend:=true
    end;
    if not Topside then begin

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      {ss:='E';
      Text_Bound(codebig,a,a,R,ss);
      lx3:=R[2].x-R[1].x;
      }
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y+round(6.5*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(6.5*kf);
      if flfirst then begin
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      ss:=ss+'°'+litera
      end
      else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(6.5*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      {b.x:=a.x;
      aa.x:=a.x;
      aa.y:=a.y+round(11.5*kf);
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,aa,b,0,false);
      }
    end else if nlb mod intermintervalL = 0 then begin


      b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(6.5*kf);
       if flfirst then begin
       if dtg.y>=0 then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      end else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false;
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(6.5*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
       if flend or (bf=0) then
        b.y:=a.y+round(2*kf)
      else
        b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
          Make_Shraf_Y(codes,1.5,dtg.y,mindivl,Lshraf2,a);
         {
          if Rcleft.y>=0 then
          nlbdiv:= abs(nlb div ShrafL)
          else
          nlbdiv:= abs(nlb div ShrafL+1);
         if nlbdiv mod 2 =1 then begin
           lshraf2.x:=a.x;
           lshraf2.y:=a.y+round(1.5*kf);
         end
         else begin
           if lshraf2.x<>a.x then begin
           b.x:=a.x;
           b.y:=a.y+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           Lshraf2.x:=0;
         end;
         }
     end;

      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*kk*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=a.y+round(6.5*kf);

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin

       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
        Text_Bound(codeMinDiv,a,a,R,ss);
         aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       aa.y:=lpc.y;
       if FFrame.CboxLang.itemindex=2 then
         // aa.y:=aa.y-round(1.2*kf);
       Add_Text(codeMinDiv,aa,aa,0,ss,false);

      {lpc.x:=lpc.x-round((R[2].x-R[1].x)/2);
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y-round(1.2*kf);

      Add_Text(codeMinDiv,lpc,lpc,0,ss,false);
      }
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       if FFrame.CboxLang.itemindex<>2 then begin
        Text_Bound(codeMinDiv_blue,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,aa,aa,0,ss,false);
       end;
     {   Text_Bound(codeMinDiv_blue,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)/2);
      end;
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,lpc,lpc,0,ss,false);
       end;  }
      end;
      bmindiv:=2;
      end;
      end;
        if RcLeft.y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg.y:=dtg.y+kk;
     until rcright.y+0.25*kk<dtg.y;

      if lshraf1.x<>0 then begin
          dtg.y:=Rcright.y;
          if not TopSide then begin
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end else begin
             dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
     end;

end;

procedure Make_grad_labels_Hor_on_VRZPlan(aleft,aright:lpoint);
var nlb,codes,codet,codeBig,codemindiv,codemindiv_blue,lx1,lx2:integer;
grad,min,sign: integer;
dtg,dtg2,rcleft,rcright:tgauss;
a,aa,b,lpc:lpoint;
sec,kk:extended;
ss:shortstring;
flgrad,flfirst,flten,topside:boolean;
bmindiv:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400330');
  codeBig:=String2Code('A0400313');
  codemindiv:=String2Code('Z0200123');
  codemindiv_blue:=String2Code('Z0200124');
  dm_l_to_R(aleft.x,aleft.y,rcleft.x,rcleft.y);
  dm_l_to_R(aright.x,aright.y,rcright.x,rcright.y);
  topside:=rcleft.y>rcright.y;
  if topside then begin
  a:=aleft;
  aleft:=aright;
  aright:=a;
  dtg:=rcleft;
  rcleft:=rcright;
  rcright:=dtg
  end;

    LongtRad_grad(abs(RcRight.y),grad,min,sec);
    if RcRight.y>=0 then sign:=1 else sign:=-1;

    flgrad:= RcLeft.y<=Sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=RcLeft.y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg:=RcLeft;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
   
    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
     if dtg.y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

       //По долготе
    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);
   
    if topside then begin
    dtg.x:=rcleft.x;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;

      b.y:=a.y-round(3.0*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(3.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(3.2*kf);
      ss:=ss+'°';
      Add_Text(codeBig,b,b,0,ss,false);

      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-(R[2].x-R[1].x) div 2;
      b.y:=a.y-round(3.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      a.y:=a.y-round(8.7*kf);
      b.y:=a.y+round(2.7*kf);
      dm_add_sign(codes,a,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(3.0*kf);
      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then
       if nlb mod textintervL = 0 then begin

      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y-round(3.2*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
      b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
  end else begin

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod BigintervalL = 0 then begin
      b.x:=a.x;
      b.y:=a.y+round(3.0*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
        if bmindiv=0 then bmindiv:=1;
    
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      {ss:='E';
      Text_Bound(codebig,a,a,R,ss);
      lx3:=R[2].x-R[1].x;
      }
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=a.y+round(5.6*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-(R[2].x-R[1].x) div 2;
      b.y:=a.y+round(5.6*kf);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
        if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-(R[2].x-R[1].x) div 2;
      b.y:=a.y+round(5.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      a.y:=a.y+round(8.7*kf);
      b.y:=a.y-round(2.7*kf);
      dm_add_sign(codes,a,b,0,false);
    end else if nlb mod intermintervalL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(3.0*kf);
      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then
      if nlb mod textintervL = 0 then begin
      if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(5.6*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end else if nlb mod smintervL = 0 then begin
     b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.x:=a.x;
      b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*kk*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=a.y+round(5.6*kf);
       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin
       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       Text_Bound(codeMinDiv,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       aa.y:=lpc.y;
       {if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y-round(1.2*kf);
       }
       Add_Text(codeMinDiv,aa,aa,0,ss,false);
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6:ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10: ss:=ss+'1''';
       11: ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
       Text_Bound(codeMinDiv_blue,a,a,R,ss);
       aa.x:=lpc.x-(R[2].x-R[1].x) div 2;
       if FFrame.CboxLang.itemindex=2 then
          aa.y:=aa.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,aa,aa,0,ss,false);
       end;
      bmindiv:=2;
      end;
      end;
      dtg.y:=dtg.y+kk;
      if RcLeft.y>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcRight.y<dtg.y;


end;

procedure Make_grad_labels_Vert_on_VRZPlan(atop,abott:lpoint);
var nlb,codes,codet,codeBig:integer;
grad,min,sign: integer;
dtg,dtg2,rctop,rcbott:tgauss;
a,b:lpoint;
sec:extended;
ss:shortstring;
flgrad,flfirst,flten,Rightside:boolean;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;

  codes:=String2Code('A0100003');
  codet:=String2Code('A0400330');
  codeBig:=String2Code('A0400313');
  dm_l_to_R(atop.x,atop.y,rctop.x,rctop.y);
  dm_l_to_R(abott.x,abott.y,rcbott.x,rcbott.y);
  rightside:=rctop.x<rcbott.x;
  if Rightside then begin
  dtg:=rctop;
  rctop:=rcbott;
  rcbott:=dtg
  end;
  kk:=minDiv;
  dtg:=rcbott;
  Rad_grad(abs(RcTop.x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
      if Rcorners[1].x>=0 then
    sign:=1
    else
    sign:=-1;
      flgrad:= Rcbott.x<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcbott.x<=(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcbott.x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if dtg.x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

    repeat
    dtg.Y:=rcbott.Y;
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod Biginterval = 0 then begin

      b.Y:=a.Y;
      if Rightside then
        b.X:=a.X+round(8.7*kf)
      else
        b.X:=a.X-round(8.7*kf);
      dm_add_sign(codes,a,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x) div 2+4.35*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x) div 2+4.35*KF);
      b.y:=a.y-round(0.4*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x) div 2+4.35*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x) div 2+4.35*KF);
      b.y:=a.y+round(2.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x) div 2+4.35*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x) div 2+4.35*KF);

      b.y:=a.y-round(0.4*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x) div 2+4.35*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x) div 2+4.35*KF);

      b.y:=a.y-round(0.4*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin

      b.y:=a.y;
       if Rightside then
        b.x:=a.x+round(3.0*kf)
      else
        b.x:=a.x-round(3.0*kf);

      dm_add_sign(codes,a,b,0,false);
      //if tmindiv<4 then

      if nlb mod textinterv = 0 then begin
      ss:=inttostr(round(sec));
      Text_Bound(codet,a,a,R,ss);
       if Rightside then
      b.x:=a.x+round((R[1].x-R[2].x) div 2+4.35*KF)
      else
      b.x:=a.x-round((R[2].x-R[1].x) div 2+4.35*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'"';
      Add_Text(codet,b,b,0,ss,false);
      end;
    end else if nlb mod sminterv = 0 then begin
     b.y:=a.y;
      if Rightside then
      b.x:=a.x+round(2.0*kf)
      else
      b.x:=a.x-round(2.0*kf);
      dm_add_sign(codes,a,b,0,false);
     end else begin
      b.y:=a.y;
      if Rightside then
      b.x:=a.x+round(kf)
      else
      b.x:=a.x-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     dtg2:=dtg;
       dtg.x:=dtg.x+kk;
        if RcBott.x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcTop.x<dtg.x;
end;



procedure TFFrame.Button3Click(Sender: TObject);
var code,Lcode2:longint;
    i,i1,i2:integer;
    offs: longint;
    x1,y1,x2,y2: longint;
    ss:shortstring;
    tga,tgb:tgauss;
    a,b:lpoint;
    kk,dd:double;
    gx,gy: double;
    mn:pchar;
    Tag: byte;
    bVert,bHor:Boolean;
begin
  dmw_PickMessage('Укажи объект рамку клапана');
  if not wm_PickObject(offs,Code,Tag,a,b,ss) then exit;
  if (tag<2) or ((tag>3) and (tag<22)) or (tag>23) then exit;
  dmw_PickMessage('Укажи точку рядом с первой точкой прямого участка рамки');
  if not wm_PickPoint(a,tga) then exit;
  dmw_PickMessage('Укажи точку рядом с последней точкой прямого участка рамки');
  if not wm_PickPoint(b,tgb) then exit;

  dmw_PickMessage('');

  mn:=dmw_activemap(pFiles,65528);
  if not assigned(mn) then begin
    ShowMessage('Нет активной карты');
    exit
  end;
  if dmw_open(mn,true)= 0 then begin
    ShowMessage('Не возможно открыть активную карту');
    exit
  end;

  kf:=dm_dist(1,1);
  dm_Goto_root;
  if dm_get_long(904,0,iscale) then begin

  dm_goto_node(offs);
  dm_get_poly_buf(pb,8000);
  dd:=Rmax;

  for i:=0 to pb^.N do begin
    kk:=sqr_distance(a,pb^.pol[i]);
    if kk< dd then begin
      i1:=i;
      dd:=kk
    end;
  end;
  dd:=Rmax;
  for i:=0 to pb^.N do begin
    kk:=sqr_distance(b,pb^.pol[i]);
    if kk< dd then begin
      i2:=i;
      dd:=kk
    end;
  end;
  a:=pb^.pol[i1];
  b:=pb^.pol[i2];
  dm_l_to_r(a.x,a.y,tga.x,tga.y);
  dm_l_to_r(b.x,b.y,tgb.x,tgb.y);

  bvert:=abs(tga.y-tgb.y)<1.e-8;
  Bhor:=abs(tga.x-tgb.x)<1.e-8;
  if Bvert and bHor then begin
    dmw_done;
    Showmessage('Ошибка: указаны совпадающие точки');
    exit
  end;
  if not(Bvert or bHor) then begin
    dmw_done;
    Showmessage('Ошибка: указан не горизонтальный или вертикальный участок');
    exit
  end;


 end else begin
   dmw_done;
   exit
 end;

   with Fframe do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext, MyFormatSettings)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext, MyFormatSettings)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;

{ if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;
}
if iscale>25000 then NAVYKIND:=1 else
        NAVYKIND:=0;
if NavyKind=0 then begin
 if Bvert then
  Make_grad_labels_Vert_on_Plan(a,b)
 else
  Make_grad_labels_Hor_on_Plan(a,b)
end else begin
 if Bvert then
  Make_grad_labels_Vert_on_Map(a,b)
 else
  Make_grad_labels_Hor_on_Map(a,b)

end;
dmw_done;
dmw_showWindow(1,1,0,0);
Showmessage('Разбивка произведена');
end;

procedure TFFrame.Button8Click(Sender: TObject);
var
   lcode2:integer;
  ss:shortstring;
   lcode,Centre:longint;
   a,b:lpoint;
   R:lorient;
   Year, Month, Day,i,lDF,lDN:longint;
begin
 if mk_frame_plan then begin
    nodecurr:=dm_object;
    root;

    if dm_Get_String(907,255,ss) then begin
      { Гриф }
      tr_bl(ss);
      if ss<>''+#0 then begin
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);
      a:=pcorn[2];
      if ss='ДСП'+#0 then
      ss:='ДЛЯ СЛУЖЕБНОГО ПОЛЬЗОВАНИЯ';
      ss:=ss+#0;
      PL^.n:=0;
      PL.pol[0]:=a;
      lcode:=String2Code('A0400110');
      dm_Text_bound(lcode,@ss[1],pl,pb,8000,0);
      a.x:=tlfr.pol[1].x-pb^.pol[2].x+pb^.pol[1].x-round(140*kf);
      a.y:=TLfr.pol[0].y-round(6.0*kf);
      PL^.n:=0; PL^.pol[0]:=a;
      nodecurr:=dm_Add_Text(lcode,4,0,PL,@ss[1],false);
      root;
      end;
    end;
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);
      { Создание текстов внизу листа }
      a.y:=TLfr.pol[3].y+round(5.2*kf);
      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
        ss:='Система МАМС';
        lcode:=String2Code('A0400212');
        a.x:=tlfr.pol[3].x+round(180*kf);
        a.y:=TLfr.pol[3].y+round(5.2*kf);
        nodecurr:=Add_Text(lcode,a,a,0,ss,false);
        case CmBxMAMS.ItemIndex of
         0:ss:='(Регион А-красный слева)';
         1:ss:='(Регион Б-красный справа)';
        end;
        lcode:=String2Code('A0400222');
        a.y:=TLfr.pol[3].y+round(8*kf);
        nodecurr:=Add_Text(lcode,a,a,0,ss,false);
      end;
     if (CboxLang.itemindex=1)or(CboxLang.itemindex=2) then begin
      ss:='IALA System';
      lcode:=String2Code('A0400211');
      a.x:=tlfr.pol[3].x+round(180*kf);
    if CboxLang.itemindex=2 then
      a.y:=a.y+round(5.2*kf);
     nodecurr:=Add_Text(lcode,a,a,0,ss,false);
      case CmBxMAMS.ItemIndex of
       0:ss:='Region A (red to Port)';
       1:ss:='Region B (red from Port)';
      end;
      lcode:=String2Code('A0400221');
      a.y:=a.y+round(2.8*kf);
      nodecurr:=Add_Text(lcode,a,a,0,ss,false);
     end;

       //Подпись "Главное управление..."


     a.y:=TLfr.pol[3].y+round(4.0*kf);
      leftmaker:=pcorn[3].x;
      rightmaker:=pcorn[4].x;

      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
       Centre:= (tlfr.pol[2].x+tlfr.pol[3].x) div 2;
      lcode:=String2Code('A0400510');

      a.x:=Centre;
      for i:=1 to Memmaker.Lines.Count do begin
      ss:=Memmaker.Lines[i-1];
      if i=Memmaker.Lines.Count then
         lcode:=String2Code('A0400530');
      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      b.y:=a.y;
      if a.x<leftmaker then leftmaker:=a.x;
      if b.x>rightmaker then rightmaker:=b.x;
      nodecurr:=Add_Text(lcode,a,b,0,ss,false);
      inc(a.y,round(4*kf))
       end;
       end;
     if (CboxLang.itemindex=1)or(CboxLang.itemindex=2) then begin
      if CboxLang.itemindex=1 then a.y:=TLfr.pol[3].y+round(4.0*kf);

      //if CboxLang.itemindex=1 then
        Centre:=(tlfr.pol[2].x+tlfr.pol[3].x) div 2;
      { Вычисление расположения слева
      else begin
        leftmakerE:=pcorn[3].x;
        rightmakerE:=pcorn[4].x;
        lcode:=String2Code('A0400511');

      for i:=1 to MemmakerE.Lines.Count do begin
      ss:=MemmakerE.Lines[i-1];
       if i=MemmakerE.Lines.Count then
         lcode:=String2Code('A0400531');

      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      if a.x<leftmakerE then leftmakerE:=a.x;
      if b.x>rightmakerE then rightmakerE:=b.x;
      end;
      Centre:=leftmaker-(rightmakerE-leftmakerE) div 2- round(20*kf)
      end;
       }
       lcode:=String2Code('A0400511');

      a.x:=Centre;
      for i:=1 to MemmakerE.Lines.Count do begin
      ss:=MemmakerE.Lines[i-1];
       if i=MemmakerE.Lines.Count then
         lcode:=String2Code('A0400531');
     Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      b.y:=a.y;
      if CboxLang.itemindex=1 then begin

      if a.x<leftmaker then leftmaker:=a.x;
      if b.x>rightmaker then rightmaker:=b.x;
      end else begin
        if a.x<leftmaker then leftmaker:=a.x;
      end;
      nodecurr:=Add_Text(lcode,a,b,0,ss,false);
      inc(a.y,round(4*kf))
       end;
       end;
       // Издания
     root;

    if dm_Get_long(921,0,lDF) then begin
      { Регионы карты}
      if not dm_get_long(922,0,lDN) then lDN:=0;
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);
      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin

      ss:='Перв.изд.';
      if lDF>10000 then begin
          Year:=lDF div 10000;
          month:=(ldf-Year*10000) div 100;
          Day:=ldf-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDF;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400420');
       a.x:=rightmaker+round(20*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'First edition',false);
       end;
       end else begin
        ss:='First edition';
      if lDF>10000 then begin
          Year:=lDF div 10000;
          month:=(ldf-Year*10000) div 100;
          Day:=ldf-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDF;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400421');
       a.x:=rightmaker+round(20*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;
       if lDN<>0 then begin
       if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin

         ss:='Нов.изд.';
      if lDN>10000 then begin
          Year:=lDN div 10000;
          month:=(ldN-Year*10000) div 100;
          Day:=ldN-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDN;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400420');
       a.x:=b.x+round(7*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'New edition',false);
       end;

       end else begin
          ss:='New edition';
      if lDN>10000 then begin
          Year:=lDN div 10000;
          month:=(ldN-Year*10000) div 100;
          Day:=ldN-Year*10000-month*100 ;
          ss:=ss+Format('%2.2d.%2.2d.%2.2d',[Day,month,Year mod 100])
      end else begin
         Year:=lDN;
         ss:=ss+Inttostr(Year);
      end;
       lcode:=String2Code('A0400421');
       a.x:=b.x+round(7*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);

       end;
       end;
     end;
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);

      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
       ss:='Заказ';
       lcode:=String2Code('A0400420');
       a.x:=tlfr.pol[2].x-round(130.0*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.y:=a.y;
       b.x:=a.x+R[2].x-R[1].x;
       ss:=ss+' '+edOrder.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'Order',false);
       end;

       end else begin
          ss:='Order';
       lcode:=String2Code('A0400421');
       a.x:=tlfr.pol[2].x-round(130.0*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.y:=a.y;
       b.x:=a.x+R[2].x-R[1].x;
       ss:=ss+' '+edOrder.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;
       end;
      if fframe.edPrint.text<>'' then begin
      if (CboxLang.itemindex=0)or(CboxLang.itemindex=2) then begin
       ss:='Отпечатано в '+fframe.edPrint.text+'г.';
       lcode:=String2Code('A0400420');
       a.x:=b.x+round(18.0*kf);
       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if CboxLang.itemindex=2 then begin
       lcode:=String2Code('A0400421');
       inc(a.y,round(3*kf));
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,'Printed in',false);
       end;
       end else begin
        ss:='Printed in'+fframe.edPrint.text;
        a.x:=b.x-round(18.0*kf);

       a.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;


      Decimalseparator:=',';
      ss:='('+Formatfloat('0.0',(pcorn[2].x-pcorn[1].x) /kf)+'x'+
      Formatfloat('0.0',(pcorn[3].y-pcorn[2].y)/kf)+')';
      lcode:=String2Code('A0400420');
      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(tlfr.pol[2].x-R[2].x+R[1].x-150*kf);
      a.y:=tlfr.pol[2].y+round(4.0*kf);
      Add_Text(lcode,a,a,0,ss,false);
      Decimalseparator:='.';
      if B913=9 then begin
        lcode:=String2Code('A0100010');
        lcode2:=String2Code('A0100008');
      end else begin
        lcode:=String2Code('A0100009');
        lcode2:=String2Code('A0100008');
      end;
      TL1.n:=4;
      Tl1.pol[0].x:=tlfr.pol[2].x-round(194*kf);
      Tl1.pol[0].y:=tlfr.pol[2].y+round(4.5*kf);
      Tl1.pol[1].x:=tlfr.pol[2].x-round(185*kf);
      Tl1.pol[1].y:=tlfr.pol[2].y+round(4.5*kf);
      Tl1.pol[2].x:=tlfr.pol[2].x-round(185*kf);
      Tl1.pol[2].y:=tlfr.pol[2].y+round(16.5*kf);
      Tl1.pol[3].x:=tlfr.pol[2].x-round(194*kf);
      Tl1.pol[3].y:=tlfr.pol[2].y+round(16.5*kf);
      Tl1.Pol[4]:= Tl1.Pol[0];
      dm_add_poly(lcode,3,0,@TL1,false);
      dm_add_poly(lcode2,2,0,@TL1,false);

    dmw_done;
 ShowMessage('Создано оформление');
 end
end;

procedure TFFrame.Button4Click(Sender: TObject);
var
  d1,d2:single;
   sdm:shortstring;
   i:longint;
  a0,b0,t:lpoint;
  tg0,tg:tgauss;
  dx,dy,dwd,ll,dmdist:integer;
  st:shortstring;
 SaveDlg: TSaveDialog;
 i995,i996,i997:longint;

  w999,b901,b911:word;
begin
if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
  end;
dm_Goto_root;
 if dm_get_long(904,0,iscale) then begin

 fltopo:=dm_pps=1;
 if fltopo then
 if not Dm_GET_double(991,0,B991) then begin
   dmw_done;
   Showmessage('Нет опорной параллели');
   exit
 end;
 if not  Dm_get_word(999,0,w999) then w999:=1;
 if not  Dm_get_word(901,0,b901) then b901:=1;
if not  Dm_get_word(911,0,b911) then b911:=1;
if not  Dm_get_word(913,0,b913) then b913:=1;

if not  Dm_get_LONG(995,0,I995) then I995:=0;
if not  Dm_get_LONG(996,0,I996) then I996:=0;
if not  Dm_get_LONG(997,0,I997) then I997:=0;

if fframe.ChBNetInterv.checked then begin
if not dm_get_double(971,0,netintb) then netintb:=0;
if not dm_get_double(972,0,netintl) then netintl:=0;
end;
 BMgr:=abs(B991/PI*180);
 if iscale<=1000 then Nomenkl.scale:=_sc1
 else
 if iscale<=1500 then Nomenkl.scale:=_sc1_5
 else
 if iscale<=2000 then Nomenkl.scale:=_sc2
 else
 if iscale<=2500 then Nomenkl.scale:=_sc2_5
 else
 if iscale<=3000 then Nomenkl.scale:=_sc3
 else
 if iscale<=4000 then Nomenkl.scale:=_sc4
 else
 if iscale<=5000 then Nomenkl.scale:=_sc5
 else
 if iscale<=6000 then Nomenkl.scale:=_sc6
 else
 if iscale<=7000 then Nomenkl.scale:=_sc7
 else
 if iscale<=7500 then Nomenkl.scale:=_sc7_5
 else
 if iscale<=10000 then Nomenkl.scale:=_sc10
 else
 if iscale<=12500 then Nomenkl.scale:=_sc12_5
 else
 if iscale<=15000 then Nomenkl.scale:=_sc15
 else
 if iscale<=17500 then Nomenkl.scale:=_sc17_5
 else
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
  else
 if iscale<=37500 then Nomenkl.scale:=_scM37_5
  else
 if iscale<=40000 then Nomenkl.scale:=_scM40
  else
 if iscale<=50000 then Nomenkl.scale:=_scM50
  else
 if iscale<=75000 then Nomenkl.scale:=_scM75
  else
 if iscale<=100000 then Nomenkl.scale:=_scM100
  else
 if iscale<=150000 then Nomenkl.scale:=_scM150
  else
 if iscale<=200000 then Nomenkl.scale:=_scM200
  else
 if iscale<=250000 then Nomenkl.scale:=_scM250
  else
 if iscale<=300000 then Nomenkl.scale:=_scM300
  else
 if iscale<=500000 then Nomenkl.scale:=_scM500
  else
 if iscale<=750000 then Nomenkl.scale:=_scM750
  else
 if iscale<=1000000 then Nomenkl.scale:=_scM1000
  else
 if iscale<=1500000 then Nomenkl.scale:=_scM1500
  else
 if iscale<=2000000 then Nomenkl.scale:=_scM2000
   else
 if iscale<=2500000 then Nomenkl.scale:=_scM2500
   else
 if iscale<=3000000 then Nomenkl.scale:=_scM3000
   else
 if iscale<=5000000 then Nomenkl.scale:=_scM5000
   else
 if iscale<=10000000 then Nomenkl.scale:=_scM10000;
scale:=iscale;
 end else begin
   dmw_done;
   exit
   end;
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 if fltopo then begin
   if dmx_find_frst_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[4].x);
  Dm_Get_double(92,0,Rcorners[4].y);
  dm_Get_Bound(pcorn[4],t);

  {Dm_Get_double(901,0,corners[4].x);
  Dm_Get_double(902,0,corners[4].y);
  }
  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[1].x);
  Dm_Get_double(92,0,Rcorners[1].y);
  {Dm_Get_double(901,0,corners[1].x);
  Dm_Get_double(902,0,corners[1].y);
  }
  dm_Get_Bound(pcorn[1],t);
if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[2].x);
  Dm_Get_double(92,0,Rcorners[2].y);
  {Dm_Get_double(901,0,corners[2].x);
  Dm_Get_double(902,0,corners[2].y);
  }
  dm_Get_Bound(pcorn[2],t);

  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[3].x);
  Dm_Get_double(92,0,Rcorners[3].y);
  dm_Get_Bound(pcorn[3],t);
  corr_linkpoint;

 end;
 SaveDlg:=TSaveDialog.Create(Fframe);
 SaveDlg.Title:='Выбор имени карты оформления';
 SaveDlg.DefaultExt:='dm';
 SaveDlg.Filter := 'Файлы (*.DM)|*.dm';
 SaveDlg.InitialDir:=Dirdm;

 if not SaveDLG.Execute then begin
   dmw_done;
   exit
 end;
 dirdm:=ExtractFileDir(SaveDlg.FileName);
 sdm:=SaveDlg.FileName+#0;
 SaveDlg.Destroy;
 if FileExists(sdm) then
   if MessageDlg('Файл уже существует. Переписать?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNO then begin
    dmw_done;
    exit
   end;

 dmdist:=round(dm_dist(1,0));
 dm_goto_root;
  dm_Get_String(903,255,st);
 st:=st+#0;

 dmw_done;
 if fltopo then begin
 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;

 end  else
 if dm_Frame(@sdm[1],@st[1],0,dmdist,tg.x,tg0.y,tg0.x,tg.y)=0 then
    exit;

  if  dmw_open(@sdm[1],true)=0 then exit;
  dm_goto_root;
  dm_put_long(904,iscale);
 if fltopo then begin
 Dm_Put_word(999,w999);
 dm_put_byte(901,b901);
 Dm_Put_byte(911,b911);
 Dm_Put_byte(913,b913);
 Dm_Put_double(991,B991);
 Dm_put_LONG(995,I995);
 Dm_put_LONG(996,I996);
 Dm_put_LONG(997,I997);

   i:=4;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat

 dm_put_double(91,rcorners[i].x);
 dm_put_double(92,rcorners[i].y);
 if i=4 then
   i:=1
 else
   inc(i);
 until dmx_Find_Next_Code(0,1)=0;

 end;

  dm_goto_root;
  dm_Get_bound(a0,b0);

  dm_Get_poly_buf(PL,8000);
  Move(pl^,pb^,sizeof(smallint)+(PL^.n+1)*sizeof(lpoint));
  ll:=(b0.x-a0.x) div 4;
  elm_inc_metric_levo(pl,ll);
  dm_set_Poly_buf(pl);
  dmw_done;
 if not fltopo then begin
 if  dmw_open(@sdm[1],true)=0 then exit;

 i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_get_bound(pcorn[i],pcorn[i]);
 until dmx_Find_Next_Code(0,1)=0;
 dec(pcorn[1].x,ll);
 inc(pcorn[1].y,ll);
 dec(pcorn[2].x,ll);
 dec(pcorn[2].y,ll);
 inc(pcorn[3].x,ll);
 dec(pcorn[3].y,ll);
 inc(pcorn[4].x,ll);
 inc(pcorn[4].y,ll);
 for i:=1 to 4 do
 dm_l_to_g(pcorn[i].x,pcorn[i].y,ExtR[i].x,ExtR[i].y);
  i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_set_bound(pcorn[i],pcorn[i]);
 dm_put_double(901,ExtR[i].x);
 dm_put_double(902,ExtR[i].y);

 until dmx_Find_Next_Code(0,1)=0;

 dmw_done;
 end;

 if not dmw_InsertMap(@sdm[1]) then exit;
 if not Set_active_map(1,true) then exit;
   kf:=dm_dist(1,1);
   if fltopo then
    for i:=1 to 4 do
     dm_R_to_L(rcorners[i].x,rcorners[i].y,pcorn[i].x,pcorn[i].y)
    else
    for i:=1 to 4 do
     dm_G_to_L(corners[i].x,corners[i].y,pcorn[i].x,pcorn[i].y);



 if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;

   with Fframe do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext, MyFormatSettings)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext, MyFormatSettings)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;

     for i:=1 to 4 do
     Tl.pol[i-1]:=pcorn[i];
     Tl.pol[4]:=Tl.pol[0];
     TL.n:=4;
      dx:=round(9.5*kf);
      dy:=round(9.5*kf);
      dwd:=round(0.8*kf);
     TLfr.n:=4;
     if ChbLeft.Checked then
       TLfr.pol[0].x:=pcorn[1].x-dx
     else
       TLfr.pol[0].x:=pcorn[1].x-dwd;
     if ChbTop.Checked then
       TLfr.pol[0].y:=pcorn[1].y-dy
     else
       TLfr.pol[0].y:=pcorn[1].y-dWd;
     if Chbright.Checked then
       TLfr.pol[1].x:=pcorn[2].x+dx
     else
       TLfr.pol[1].x:=pcorn[2].x+dwd;
     if ChbTop.Checked then
       TLfr.pol[1].y:=pcorn[2].y-dy
     else
       TLfr.pol[1].y:=pcorn[2].y-dWd;
     if Chbright.Checked then
       TLfr.pol[2].x:=pcorn[3].x+dx
     else
       TLfr.pol[2].x:=pcorn[3].x+dwd;
     if Chbbottom.Checked then
       TLfr.pol[2].y:=pcorn[3].y+dy
     else
       TLfr.pol[2].y:=pcorn[3].y+dwd;
     if Chbleft.Checked then
        TLfr.pol[3].x:=pcorn[4].x-dx
     else
        TLfr.pol[3].x:=pcorn[4].x-dwd;
     if ChbBottom.Checked then
       TLfr.pol[3].y:=pcorn[4].y+dy
     else
       TLfr.pol[3].y:=pcorn[4].y+dwd;

     TLfr.pol[4]:=TLfr.pol[0];
    {
         dx:=round(8.7*kf);
         dy:=round(8.7*kf);
     ii[0]:=0;
     TLint.n:=4;
     TLint.pol[0].x:=pcorn[1].x-dx;
     TLint.pol[0].y:=pcorn[1].y-dy;
     TLint.pol[1].x:=pcorn[2].x+dx;
     TLint.pol[1].y:=pcorn[2].y-dy;
     TLint.pol[2].x:=pcorn[3].x+dx;
     TLint.pol[2].y:=pcorn[3].y+dy;
     TLint.pol[3].x:=pcorn[4].x-dx;
     TLint.pol[3].y:=pcorn[4].y+dy;
     TLint.pol[4]:=TLint.pol[0];
     ii[1]:=1;
     ii[2]:=2;
     ii[3]:=3;
     ii[4]:=4;
    }
    dmx_Find_Frst_Code(0,1);
     dm_goto_last;
    Mk_COVER;
        dx:=round(0.4*kf);
        dy:=round(0.4*kf);


     tlBigframe.pol[0].x:=TLfr.pol[0].x+dx;
     tlBigframe.pol[0].y:=TLfr.pol[0].y+dy;
     tlBigframe.pol[1].x:=TLfr.pol[1].x-dx;
     tlBigframe.pol[1].y:=TLfr.pol[1].y+dy;
     tlBigframe.pol[2].x:=TLfr.pol[2].x-dx;
     tlBigframe.pol[2].y:=TLfr.pol[2].y-dy;
     tlBigframe.pol[3].x:=TLfr.pol[3].x+dx;
     tlBigframe.pol[3].y:=TLfr.pol[3].y-dy;
    TLbigFrame.pol[4]:=TLbigFrame.pol[0];
    TLbigFrame.N:=5;
    TLbigFrame.pol[5]:=TLbigFrame.pol[1];
    //Толстая рамка
    dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
    //Внутрення рамка
    dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
    d1:=abs(pcorn[2].x-pcorn[1].x)/kf;
    d2:=abs(pcorn[3].y-pcorn[2].y)/kf;
    if (d1>250) or (d2>250) then
    Make_NET_on_Klapan;
    dmw_done;
   Showmessage('Карта с рамкой для врезки создана')
end;

procedure TFFrame.Button9Click(Sender: TObject);
var
   sdm:shortstring;
   i,ll:longint;
  a0,b0,t:lpoint;
  tg0,tg:tgauss;
 dmdist:integer;
  st,sadm:shortstring;
 SaveDlg: TSaveDialog;
  w999,b901,b911:word;

begin
if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
  end;
dm_Goto_root;
 if dm_get_long(904,0,iscale) then begin
fltopo:=dm_pps=1;
 if fltopo then
 if not Dm_GET_double(991,0,B991) then begin
   dmw_done;
   Showmessage('Нет опорной параллели');
   exit
 end;
 if not  Dm_get_word(999,0,w999) then w999:=1;
 if not  Dm_get_word(901,0,b901) then b901:=1;
if not  Dm_get_word(911,0,b911) then b911:=1;
if not  Dm_get_word(913,0,b913) then b913:=1;
if fframe.ChBNetInterv.checked then begin
if not dm_get_double(971,0,netintb) then netintb:=0;
if not dm_get_double(972,0,netintl) then netintl:=0;
end;
 BMgr:=abs(B991/PI*180);
 if iscale<=1000 then Nomenkl.scale:=_sc1
 else
 if iscale<=1500 then Nomenkl.scale:=_sc1_5
 else
 if iscale<=2000 then Nomenkl.scale:=_sc2
 else
 if iscale<=2500 then Nomenkl.scale:=_sc2_5
 else
 if iscale<=3000 then Nomenkl.scale:=_sc3
 else
 if iscale<=4000 then Nomenkl.scale:=_sc4
 else
 if iscale<=5000 then Nomenkl.scale:=_sc5
 else
 if iscale<=6000 then Nomenkl.scale:=_sc6
 else
 if iscale<=7000 then Nomenkl.scale:=_sc7
 else
 if iscale<=7500 then Nomenkl.scale:=_sc7_5
 else
 if iscale<=10000 then Nomenkl.scale:=_sc10
 else
 if iscale<=12500 then Nomenkl.scale:=_sc12_5
 else
 if iscale<=15000 then Nomenkl.scale:=_sc15
 else
 if iscale<=17500 then Nomenkl.scale:=_sc17_5
 else
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
  else
 if iscale<=37500 then Nomenkl.scale:=_scM37_5
  else
 if iscale<=40000 then Nomenkl.scale:=_scM40
  else
 if iscale<=50000 then Nomenkl.scale:=_scM50
  else
 if iscale<=75000 then Nomenkl.scale:=_scM75
  else
 if iscale<=100000 then Nomenkl.scale:=_scM100
  else
 if iscale<=150000 then Nomenkl.scale:=_scM150
  else
 if iscale<=200000 then Nomenkl.scale:=_scM200
  else
 if iscale<=250000 then Nomenkl.scale:=_scM250
  else
 if iscale<=300000 then Nomenkl.scale:=_scM300
  else
 if iscale<=500000 then Nomenkl.scale:=_scM500
  else
 if iscale<=750000 then Nomenkl.scale:=_scM750
  else
 if iscale<=1000000 then Nomenkl.scale:=_scM1000
  else
 if iscale<=1500000 then Nomenkl.scale:=_scM1500
  else
 if iscale<=2000000 then Nomenkl.scale:=_scM2000
   else
 if iscale<=2500000 then Nomenkl.scale:=_scM2500
   else
 if iscale<=3000000 then Nomenkl.scale:=_scM3000
   else
 if iscale<=5000000 then Nomenkl.scale:=_scM5000
   else
 if iscale<=10000000 then Nomenkl.scale:=_scM10000;
 end else begin
 Nomenkl.scale:=_scM10000;
 end;
 scale:=iscale;
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 if fltopo then begin
   if dmx_find_frst_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[4].x);
  Dm_Get_double(92,0,Rcorners[4].y);
  dm_Get_Bound(pcorn[4],t);

  {Dm_Get_double(901,0,corners[4].x);
  Dm_Get_double(902,0,corners[4].y);
  }
  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[1].x);
  Dm_Get_double(92,0,Rcorners[1].y);
  {Dm_Get_double(901,0,corners[1].x);
  Dm_Get_double(902,0,corners[1].y);
  }
  dm_Get_Bound(pcorn[1],t);
if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[2].x);
  Dm_Get_double(92,0,Rcorners[2].y);
  {Dm_Get_double(901,0,corners[2].x);
  Dm_Get_double(902,0,corners[2].y);
  }
  dm_Get_Bound(pcorn[2],t);

  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[3].x);
  Dm_Get_double(92,0,Rcorners[3].y);
  dm_Get_Bound(pcorn[3],t);
  corr_linkpoint;

 end;{ else begin
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 end;
 }
 SaveDlg:=TSaveDialog.Create(Fframe);
 SaveDlg.Title:='Выбор имени карты оформления';
 SaveDlg.DefaultExt:='dm';
 SaveDlg.Filter := 'Файлы (*.DM)|*.dm';
 SaveDlg.InitialDir:=Dirdm;

 if not SaveDLG.Execute then begin
   dmw_done;
   exit
 end;
  dirdm:=ExtractFileDir(SaveDlg.FileName);
 sdm:=SaveDlg.FileName+#0;
 SaveDlg.Destroy;
 if FileExists(sdm) then
   if MessageDlg('Файл уже существует. Переписать?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNO then begin
    dmw_done;
    exit
   end;
 
 dmdist:=round(dm_dist(1,0));
 dm_Goto_root;

 dm_Get_String(903,255,st);
 st:=st+#0;
 if not dm_get_string(901,255,SAdm) then Sadm:='НОМЕР';
 if Sadm='' then Sadm:='НОМЕР';

 dmw_done;
 if fltopo then begin
 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;

 end  else
 if dm_Frame(@sdm[1],@st[1],0,dmdist,tg.x,tg0.y,tg0.x,tg.y)=0 then
    exit;

  if  dmw_open(@sdm[1],true)=0 then exit;
  dm_goto_root;
  dm_put_long(904,iscale);
 if fltopo then begin
   Dm_Put_word(999,w999);
   dm_put_byte(901,b901);
   Dm_Put_byte(911,b911);
   //c_:=Ellipsoids[B911];
   Dm_Put_byte(913,b913);
   Dm_Put_double(991,B991);
   i:=4;
   if dmx_Find_Frst_Code(0,1)<>0 then
   repeat
    dm_put_double(91,rcorners[i].x);
    dm_put_double(92,rcorners[i].y);
    if i=4 then
      i:=1
    else
     inc(i);
   until dmx_Find_Next_Code(0,1)=0;

 end;

  dm_goto_root;
  dm_Get_bound(a0,b0);

  dm_Get_poly_buf(PL,8000);
  Move(pl^,pb^,sizeof(smallint)+(PL^.n+1)*sizeof(lpoint));
  ll:=(b0.x-a0.x) div 4;
  elm_inc_metric_levo(pl,ll);
  dm_set_Poly_buf(pl);
  dmw_done;
 if not fltopo then begin
   if  dmw_open(@sdm[1],true)=0 then exit;
   i:=0;
   if dmx_Find_Frst_Code(0,1)<>0 then
   repeat
    inc(i);
    dm_get_bound(pcorn[i],pcorn[i]);
   until dmx_Find_Next_Code(0,1)=0;
   dec(pcorn[1].x,ll);
   inc(pcorn[1].y,ll);
   dec(pcorn[2].x,ll);
   dec(pcorn[2].y,ll);
   inc(pcorn[3].x,ll);
   dec(pcorn[3].y,ll);
   inc(pcorn[4].x,ll);
   inc(pcorn[4].y,ll);
   for i:=1 to 4 do
     dm_l_to_g(pcorn[i].x,pcorn[i].y,ExtR[i].x,ExtR[i].y);
   i:=0;
   if dmx_Find_Frst_Code(0,1)<>0 then
     repeat
      inc(i);
      dm_set_bound(pcorn[i],pcorn[i]);
      dm_put_double(901,ExtR[i].x);
      dm_put_double(902,ExtR[i].y);
     until dmx_Find_Next_Code(0,1)=0;
   dmw_done;
 end;

 if not dmw_InsertMap(@sdm[1]) then exit;
 if not Set_active_map(1,true) then exit;
 //if  dmw_open(@sdm[1],true)=0 then exit;
   kf:=dm_dist(1,1);
   if fltopo then
    for i:=1 to 4 do
     dm_R_to_L(rcorners[i].x,rcorners[i].y,pcorn[i].x,pcorn[i].y)
    else
    for i:=1 to 4 do
     dm_G_to_L(corners[i].x,corners[i].y,pcorn[i].x,pcorn[i].y);

 with Fframe do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext, MyFormatSettings)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext, MyFormatSettings)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;

 if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;

     for i:=1 to 4 do
     Tl.pol[i-1]:=pcorn[i];
     Tl.pol[4]:=Tl.pol[0];
     TL.n:=4;
      dx:=round(7*kf);
      dy:=round(7*kf);
     TLfr.n:=4;
     TLfr.pol[0].x:=pcorn[1].x-dx;
     TLfr.pol[0].y:=pcorn[1].y-dy;
     TLfr.pol[1].x:=pcorn[2].x+dx;
     TLfr.pol[1].y:=pcorn[2].y-dy;
     TLfr.pol[2].x:=pcorn[3].x+dx;
     TLfr.pol[2].y:=pcorn[3].y+dy;
     TLfr.pol[3].x:=pcorn[4].x-dx;
     TLfr.pol[3].y:=pcorn[4].y+dy;
     TLfr.pol[4]:=TLfr.pol[0];

         dx:=round(6.4*kf);
         dy:=round(6.4*kf);
     ii[0]:=0;
     TLint.n:=4;
     TLint.pol[0].x:=pcorn[1].x-dx;
     TLint.pol[0].y:=pcorn[1].y-dy;
     TLint.pol[1].x:=pcorn[2].x+dx;
     TLint.pol[1].y:=pcorn[2].y-dy;
     TLint.pol[2].x:=pcorn[3].x+dx;
     TLint.pol[2].y:=pcorn[3].y+dy;
     TLint.pol[3].x:=pcorn[4].x-dx;
     TLint.pol[3].y:=pcorn[4].y+dy;
     TLint.pol[4]:=TLint.pol[0];
     ii[1]:=1;
     ii[2]:=2;
     ii[3]:=3;
     ii[4]:=4;
    dmx_Find_Frst_Code(0,1);
     dm_goto_last;
    Mk_COVER;
        dx:=round(0.3*kf);
        dy:=round(0.3*kf);


    tlBigframe.pol[0].x:=TLfr.pol[0].x+dx;
    tlBigframe.pol[0].y:=TLfr.pol[0].y+dy;
    tlBigframe.pol[1].x:=TLfr.pol[1].x-dx;
    tlBigframe.pol[1].y:=TLfr.pol[1].y+dy;
    tlBigframe.pol[2].x:=TLfr.pol[2].x-dx;
    tlBigframe.pol[2].y:=TLfr.pol[2].y-dy;
    tlBigframe.pol[3].x:=TLfr.pol[3].x+dx;
    tlBigframe.pol[3].y:=TLfr.pol[3].y-dy;
    TLbigFrame.pol[4]:=TLbigFrame.pol[0];
    TLbigFrame.N:=5;
    TLbigFrame.pol[5]:=TLbigFrame.pol[1];
    //Толстая рамка
    dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
    //Внутрення рамка
    dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
        dx:=round(0.6*kf);
        dy:=round(0.6*kf);
     tlBigframe.pol[0].x:=TL.pol[0].x-dx;
     tlBigframe.pol[0].y:=TL.pol[0].y-dy;
     tlBigframe.pol[1].x:=TL.pol[1].x+dx;
     tlBigframe.pol[1].y:=TL.pol[1].y-dy;
     tlBigframe.pol[2].x:=TL.pol[2].x+dx;
     tlBigframe.pol[2].y:=TL.pol[2].y+dy;
     tlBigframe.pol[3].x:=TL.pol[3].x-dx;
     tlBigframe.pol[3].y:=TL.pol[3].y+dy;
    TLbigFrame.pol[4]:=TLbigFrame.pol[0];
    TLbigFrame.N:=5;
    TLbigFrame.pol[5]:=TLbigFrame.pol[1];
    dm_Add_Poly(String2code('A0100002'),2,0,@TLbigFrame,false);
    Make_grad_labels_on_Katalog;
   dmw_done;
   Showmessage('Оформление карты каталога создано')
end;

procedure Make_grad_labels_Hor_on_Katalog(aleft,aright:lpoint);
var TextgradL,i,nn,nlb,nlbdiv,codethin,codes,codet,codeBig,codeShraf,lx,lx1,lx2,lx3:integer;
grad,min,sign: integer;
dtg,dtg2, rcleft,rcright:tgauss;
a,aa,b,lpc,l0,lshraf1,lshraf2:lpoint;
sec,kk,dmm:extended;
ss:shortstring;
flgrad,flfirst,flten,topside:boolean;
bmindiv,bf:byte;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  with Fframe do begin
    TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext, MyFormatSettings)/3600);
  end;

  Tl1.n:=1;
  codethin:=String2code('A0100002');
  codeShraf:=String2code('A0100004');
  codes:=String2Code('A0100003');
    codet:=String2Code('Z1100080');
  codeBig:=String2Code('Z1100070');
  dm_l_to_R(aleft.x,aleft.y,rcleft.x,rcleft.y);
  dm_l_to_R(aright.x,aright.y,rcright.x,rcright.y);

  topside:=rcleft.y>rcright.y;
  if topside then begin
  a:=aleft;
  aleft:=aright;
  aright:=a;
  dtg:=rcleft;
  rcleft:=rcright;
  rcright:=dtg;
  kk:=-0.6*kf;
  end else
  kk:=0.6*kf;

  if Fframe.ChB1tip.checked then
  Tl1.pol[0].x:=aleft.x-round(abs(kk))
  else
  Tl1.pol[0].x:=aleft.x;
  Tl1.pol[0].y:=aleft.y+round(kk);

  if Fframe.ChB2tip.checked then
  Tl1.pol[1].x:=aright.x+round(abs(kk))
  else
  Tl1.pol[1].x:=aright.x;
  Tl1.pol[1].y:=aright.y+round(kk);
  dm_Add_Poly(codethin,2,0,@TL1,false);
  {inc(Tl1.pol[0].y,round(kk));
  inc(Tl1.pol[1].y,round(kk));
  dm_Add_Poly(codethin,2,0,@TL1,false);
  }
  kk:=minDivL;
    LongtRad_grad(abs(Rcright.y),grad,min,sec);
    if Rcright.y>=0 then sign:=1 else sign:=-1;
    
    flgrad:= Rcleft.y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcleft.y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    dtg.y:=RcLeft.y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
  
    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    if dtg.y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);
    bf:=0;
    //По долготе
    dtg.x:=rcleft.x;

    repeat
     LongtRad_grad (abs(dtg.y),grad,min,sec);
     dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

     if bf=0 then begin
      lshraf1.x:=a.x;
      lshraf1.y:=a.y-round(0.3*kf);
     end;
     if Topside then begin

     if nlb mod BigintervalL = 0 then begin
      aa.x:=a.x;
      aa.y:=a.y-round(0.3*kf);
      b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(2.3*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      end else if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-(R[2].x-R[1].x) div 2;
        b.y:=a.y-round(2.3*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-(R[2].x-R[1].x) div 2 ;
      b.y:=a.y-round(2.3*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      {aa.x:=a.x;
      aa.y:=a.y-round(11.5*kf);
      b.y:=a.y+round(4.4*kf);
      dm_add_sign(codes,aa,b,0,false); }
    end else if nlb mod intermintervall = 0 then begin
       aa.x:=a.x;
      aa.y:=a.y-round(0.6*kf);

     b.x:=a.x;
      b.y:=a.y-round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-(R[2].x-R[1].x) div 2;
        b.y:=a.y-round(2.3*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-(R[2].x-R[1].x) div 2;
      b.y:=a.y-round(2.3*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
      aa.x:=a.x;
      aa.y:=a.y-round(0.6*kf);

     b.x:=a.x;
      b.y:=a.y-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);

     end else begin
      aa.x:=a.x;
      aa.y:=a.y-round(0.6*kf);

      b.x:=a.x;
      b.y:=a.y-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
     end;
     if nlb mod ShrafL = 0 then begin
         {if ((dtg.y>=0) and (Rcleft.y>=0)) or ((dtg.y<=0) and (Rcleft.y<=0)) then
         nlbdiv:=abs(nlb div ShrafL)
         else
         nlbdiv:=abs(nlb div ShrafL+1);
          }
         if dtg.y-mindivl>=0 then
         nlbdiv:=round(abs(dtg.y)/ (Shrafl*mindivl))
         else
         nlbdiv:=round(abs(dtg.y)/ (Shrafl*mindivl))+1;

         if nlbdiv  mod 2 =1 then begin
           lshraf1.x:=a.x;
           lshraf1.y:=a.y-round(0.3*kf);
         end
         else begin
           if (Lshraf1.x<>-999999999) and (a.x<>lshraf1.x) then begin
           if TopSide then begin
             PL^.n:=1;
           PL^.pol[0]:=lshraf1;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y-round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)

           end;
           //dm_add_sign(codes,lshraf1,b,0,false);
           end;

           Lshraf1.x:=-999999999;
         end;
     end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(0.3*kf);
    bf:=1;

    end;
    if not Topside then begin

    if nlb mod BigintervalL = 0 then begin
  //   aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);

      b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      {ss:='E';
      Text_Bound(codebig,a,a,R,ss);
      lx3:=R[2].x-R[1].x;
      }
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y+round(3.9*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      Add_Text(codeBig,b,b,0,litera,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-(R[2].x-R[1].x) div 2;
      b.y:=a.y+round(3.9*kf);
      if flfirst then begin
      if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';
      ss:=ss+'°'+litera
      end
      else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false
      end
      else begin
     //   if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(3.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      b.x:=a.x;
      {aa.x:=a.x;
      aa.y:=a.y+round(11.5*kf);
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,aa,b,0,false);
       }
    end else if nlb mod intermintervalL = 0 then begin

     // if bmindiv=0 then bmindiv:=1;
        aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);

      b.x:=a.x;
      b.y:=a.y+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if nlb mod textintervL = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(3.9*kf);
       if flfirst then begin
       if (dtg.y>=0) and (dtg.y<=Pi) then
        litera:='E'
      else
        litera:='W';

      ss:=ss+'°'+litera;
      end else
      ss:=ss+'°';

      Add_Text(codeBig,b,b,0,ss,false);
      flfirst:=false;
      end
      else begin
   //     if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)/2);
      b.y:=a.y+round(3.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod smintervL = 0 then begin
     aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);

     b.x:=a.x;
      b.y:=a.y+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end else begin
      aa.x:=a.x;
      aa.y:=a.y+round(0.6*kf);

      b.x:=a.x;
      b.y:=a.y+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
        { if ((dtg.y>=0) and (Rcleft.y>=0)) or ((dtg.y<=0) and (Rcleft.y<=0)) then
          nlbdiv:= abs(nlb div ShrafL)
          else
          nlbdiv:= abs(nlb div ShrafL+1);
          }
        if dtg.y-mindivl>=0 then
         nlbdiv:=round(abs(dtg.y)/ (Shrafl*mindivl))
         else
         nlbdiv:=round(abs(dtg.y)/ (Shrafl*mindivl))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.x:=a.x;
           lshraf2.y:=a.y+round(0.3*kf);
         end
         else begin
           if (Lshraf2.x<>-999999999) and (lshraf2.x<>a.x) then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf2;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y+round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)

           //dm_add_sign(codes,lshraf2,b,0,false);
           end;
           Lshraf2.x:=-999999999;
         end;
     end;

    {  if bmindiv=1 then begin
      bmindiv:=2;
      end;
     }
      end;
        if Rcleft.y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg.y:=dtg.y+kk;
     until rcright.y+0.25*kk<dtg.y;

      if lshraf1.x<>-999999999 then begin
          dtg.y:=Rcright.y;
          if not TopSide then begin
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           if lshraf2.x<>a.x then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf2;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y-round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)

           end
           end else begin
             dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           if lshraf1.x<>a.x then begin
            PL^.n:=1;
           PL^.pol[0]:=lshraf1;
           PL^.pol[1].x:=a.x;
           PL^.pol[1].y:=a.y-round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)

           end;
           end;
     end;

end;

procedure Make_grad_labels_Vert_on_Katalog(atop,abott:lpoint);
var Textgrad,nlb,nlbdiv,codethin,codes,codet,codeBig,codeShraf,lx1,lx2,lx3:integer;
grad,min,sign: integer;
dtg,dtg2,rctop,rcbott:tgauss;
a,aa,b,lpc,l0,lshraf1,lshraf2:lpoint;
sec,kk,dmm:extended;
ss:shortstring;
flgrad,flfirst,flten,rightside:boolean;
bf:byte;
litera:char;
begin
  with Fframe do begin
    Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600);
  end;
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  codethin:=String2Code('A0100002');
  codeShraf:=String2code('A0100004');
  codes:=String2Code('A0100003');
  codet:=String2Code('Z1100080');
  codeBig:=String2Code('Z1100070');
  dm_l_to_R(atop.x,atop.y,rctop.x,rctop.y);
  dm_l_to_R(abott.x,abott.y,rcbott.x,rcbott.y);
  rightside:=rctop.x<rcbott.x;
  if Rightside then begin
  a:=aTop;
  aTop:=aBott;
  abott:=a;
  dtg:=rctop;
  rctop:=rcbott;
  rcbott:=dtg;
  kk:=0.6*kf
  end else
  kk:=-0.6*kf;
  if Fframe.ChB1tip.checked then
  Tl1.pol[0].y:=atop.y-round(abs(kk))
  else
  Tl1.pol[0].y:=atop.y;
  Tl1.pol[0].x:=atop.x+round(kk);

  if Fframe.ChB2tip.checked then
  Tl1.pol[1].y:=abott.y+round(kk)
  else
  Tl1.pol[1].y:=aBott.y;
  Tl1.pol[1].x:=abott.x+round(kk);
  dm_Add_Poly(codethin,2,0,@TL1,false);
 { inc(Tl1.pol[0].x,round(kk));
  inc(Tl1.pol[1].x,round(kk));
  dm_Add_Poly(codethin,2,0,@TL1,false);
 }
    kk:=minDiv;
    Rad_grad(abs(Rctop.x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if RcTop.x>=0 then
    sign:=1
    else
    sign:=-1;
    flgrad:= Rcbott.x<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcbott.x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcbott.x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;
    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if dtg.x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);
    bf:=0;
    //По широте
    dtg.Y:=rcBott.Y;

    repeat
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(0.3*kf);
    end;
    if not RightSide then begin

    if nlb mod Biginterval = 0 then begin
      aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);

      b.Y:=a.Y;
      b.X:=a.X-round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
        ss:=inttostr(grad);
       // Text_Bound(codebig,a,a,R,ss);
       //b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
       b.x:=a.x-round(4.9*KF);
       b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);
      ss:=inttostr(min);
      {Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      }
      b.x:=a.x-round(4.9*KF);

      b.y:=a.y+round(2.0*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end else if flgrad and (min=0) then begin

      ss:=inttostr(grad);
      {Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      }
       b.x:=a.x-round(4.9*KF);

      b.y:=a.y+round(kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      {Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      }
      b.x:=a.x-round(4.9*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end else if nlb mod interminterval = 0 then begin
      aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);

      b.y:=a.y;
      b.x:=a.x-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      {Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      }
      b.x:=a.x-round(4.9*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      {Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round(R[2].x-R[1].x+2.8*KF);
      }
       b.x:=a.x-round(4.9*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
            aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);

     b.y:=a.y;
      b.x:=a.x-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end else begin
           aa.y:=a.y;
      aa.x:=a.x-round(0.6*kf);

      b.y:=a.y;
      b.x:=a.x-round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
     end;
     if nlb mod Shraf = 0 then begin
         {
         if ((dtg.x>=0)and (RCbott.x>=0)) or ((dtg.x<=0)and (RCbott.x<=0))then
         nlbdiv:=abs(nlb div Shraf)
         else
         nlbdiv:=abs(nlb div Shraf+1);
         }
         if dtg.x-mindiv>=0 then
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
         nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf1.y:=a.y;
           lshraf1.x:=a.x-round(0.3*kf);
         end
         else begin
           if (Lshraf1.y<>-999999999) and (lshraf1.y<>a.y) then begin
           if not RightSide then begin
           PL^.n:=1;
           PL^.pol[0]:=lshraf1;
           PL^.pol[1].y:=a.y;
           PL^.pol[1].x:=a.x-round(0.3*kf);
            dm_add_Poly(CodeShraf,2,0,PL,false)
           end;
           end;
           lshraf1.y:=-999999999
         end;
     end;
     if bf=0 then begin

    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(0.3*kf);
    bf:=1;
    end;
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     if RightSide then begin
    if nlb mod Biginterval = 0 then begin
            aa.y:=a.y;
      aa.x:=a.x+round(0.6*kf);

      b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      {Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      }
      b.x:=a.x+round(2.1*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      {Text_Bound(codet,a,a,R,ss);
      b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      }
      b.x:=a.x+round(2.1*KF);


      b.y:=a.y+round(2.0*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      {Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      }
      b.x:=a.x+round(2.1*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);
      end else begin
      ss:=inttostr(min);
      {Text_Bound(codet,a,a,R,ss);
      b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      }
      b.x:=a.x+round(2.1*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
     end else if nlb mod interminterval = 0 then begin
            aa.y:=a.y;
      aa.x:=a.x+round(0.6*kf);

      b.y:=a.y;
      b.x:=a.x+round(2.0*kf);
      dm_add_sign(codes,aa,b,0,false);
       if nlb mod textinterv = 0 then
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      {Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      }
      b.x:=a.x+round(2.1*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);
      end else begin
      ss:=inttostr(min);
      {Text_Bound(codet,a,a,R,ss);
      b.x:=a.x+round(R[1].x-R[2].x+4.1*KF);
      }
      b.x:=a.x+round(2.1*KF);

      b.y:=a.y+round(0.9*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

    end else if nlb mod sminterv = 0 then begin
            aa.y:=a.y;
      aa.x:=a.x+round(0.6*kf);

     b.y:=a.y;
      b.x:=a.x+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end else begin
            aa.y:=a.y;
      aa.x:=a.x+round(0.6*kf);

      b.y:=a.y;
      b.x:=a.x+round(1.4*kf);
      dm_add_sign(codes,aa,b,0,false);
     end;
      if nlb mod Shraf = 0 then begin
         {if ((dtg.x>=0)and (RCbott.x>=0)) or ((dtg.x<=0)and (RCbott.x<=0))then
           nlbdiv:=abs(nlb div Shraf)
         else
          nlbdiv:=abs(nlb div Shraf+1);
         }
         if dtg.x-mindiv>=0 then
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(0.3*kf);
         end
         else begin
           if  (Lshraf2.y<>-999999999) and (lshraf2.y<>a.y) then begin
                PL^.n:=1;
           PL^.pol[0]:=lshraf2;
           PL^.pol[1].y:=a.y;
           PL^.pol[1].x:=a.x+round(0.3*kf);
           dm_add_Poly(CodeShraf,2,0,PL,false)
           end;
           lshraf2.y:=-999999999;
         end;
     end;
      end;
       dtg.x:=dtg.x+kk;
        if RcBott.x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rctop.x+0.25*kk<dtg.x;
      if  (Lshraf1.y<>-999999999) then begin
          dtg.x:=Rctop.x;
          if rightSide then begin

           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           if (Lshraf2.y<>a.y) then begin
            PL^.n:=1;
            PL^.pol[0]:=lshraf2;
            PL^.pol[1].y:=a.y;
            PL^.pol[1].x:=a.x+round(0.3*kf);
            dm_add_Poly(CodeShraf,2,0,PL,false)
           end;
           end else begin
           //dtg.y:=Rcorners[1].y;
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           if (Lshraf1.y<>a.y) then begin
            PL^.n:=1;
            PL^.pol[0]:=lshraf1;
            PL^.pol[1].y:=a.y;
            PL^.pol[1].x:=a.x-round(0.3*kf);
            dm_add_Poly(CodeShraf,2,0,PL,false)
           end;
           end;
     end;
end;

procedure TFFrame.Button10Click(Sender: TObject);
var code,iscale:longint;
    i,i1,i2:integer;
    offs: longint;
    x1,y1,x2,y2: longint;
    ss:shortstring;
    tga,tgb:tgauss;
    a,b:lpoint;
    kk,dd:double;
    gx,gy: double;
    mn:pchar;
    Tag: byte;
    bVert,bHor:Boolean;
begin

dmw_PickMessage('Укажи объект рамку врезки или клапана');
if not wm_PickObject(offs,Code,Tag,a,b,ss) then exit;
if (tag<2) or ((tag>3) and (tag<22)) or (tag>23) then exit;
dmw_PickMessage('Укажи точку рядом с первой точкой прямого участка рамки');
if not wm_PickPoint(a,tga) then exit;
dmw_PickMessage('Укажи точку рядом с последней точкой прямого участка рамки');
if not wm_PickPoint(b,tgb) then exit;
dmw_PickMessage('');
mn:=dmw_activemap(PFiles,65528);
   if not assigned(mn) then begin
   ShowMessage('Нет активной карты');
   exit
   end;
   if dmw_open(mn,true)= 0 then begin
   ShowMessage('Не возможно открыть активную карту');
   exit
   end;
 kf:=dm_dist(1,1);
 dm_Goto_root;
if dm_get_long(904,0,iscale) then begin
dm_goto_node(offs);
dm_get_poly_buf(pb,8000);
dd:=Rmax;
for i:=0 to pb^.N do begin
   kk:=sqr_distance(a,pb^.pol[i]);
if kk< dd then begin
  i1:=i;
  dd:=kk
end;
end;
dd:=Rmax;
for i:=0 to pb^.N do begin
   kk:=sqr_distance(b,pb^.pol[i]);
if kk< dd then begin
  i2:=i;
  dd:=kk
end;
end;
a:=pb^.pol[i1];
b:=pb^.pol[i2];
dm_l_to_r(a.x,a.y,tga.x,tga.y);
dm_l_to_r(b.x,b.y,tgb.x,tgb.y);
bvert:=abs(tga.y-tgb.y)<1.e-4;
Bhor:=abs(tga.x-tgb.x)<1.e-4;
if Bvert and bHor then begin
  dmw_done;
  Showmessage('Ошибка: указаны совпадающие точки');
  exit
end;
if not(Bvert or bHor) then begin
  dmw_done;
  Showmessage('Ошибка: указан не горизонтальный или вертикальный участок');
  exit
end;
end else begin
   dmw_done;
   exit
end;
   with Fframe do begin
    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext, MyFormatSettings)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
  end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;
if Bvert then
  Make_grad_labels_Vert_on_Katalog(a,b)
else
  Make_grad_labels_Hor_on_Katalog(a,b);
dmw_done;
dmw_showWindow(1,1,0,0);
Showmessage('Разбивка произведена');
end;

procedure TFFrame.Button11Click(Sender: TObject);
begin
ShowMessage('Временно не работает');
(*FUnZaram.ADOConnFrame.Connected:=false;
FUnZaram.ADOConnFrame.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source='+
dmw_dir+'\Frame_N.mdb;Mode=Share Deny None;Extended Properties="";Persist Security Info=False;'+
'Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";'+
'Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;'+
'Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";'+
'Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;'+
'Jet OLEDB:Don''t Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica Repair=False;'+
'Jet OLEDB:SFP=False';
FUnZaram.ADOConnFrame.Connected:=true;
FUnZaram.ADODSTypes.Active:=true;
FUnZaram.ADODS_layout.Active:=true;
FUnZaram.ADODS_Frame.active:=true;
FUnZaram.show
*)
end;


procedure Make_NET_on_Klapan;
var nn,nlb,nlb2,nlbdiv,nlbnetorig_L,nlbnetorig_B, TextgradL,Textgrad,
lx,lx1,lx2,lx3,lnetinterv,lnetintervL:integer;
grad,min,sign,grad2,min2: integer;
dtg,dtg2:tgauss;
a,a2,aa,b,lpc,l0:lpoint;
sec,sec2,kk,dmm,netorgL,netorgB:extended;
ss:shortstring;
flgrad:boolean;
bf:byte;

begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;

with Fframe do begin
  Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600);
  TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext, MyFormatSettings)/3600);
end;

  dtg:=Rcorners[4];
  if fframe.ChBNetInterv.checked and (netintb<>0)then begin
     lnetinterv:=round(netintb/mindiv);
  end else begin
  dtg2.x:=dtg.x+Textinterv*kk;
  dtg2.y:=dtg.y;
  dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
  dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(a.y-b.y)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetinterv:=Textinterv
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetinterv:=2*Textinterv
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetinterv:=4*Textinterv
  else lnetinterv:=8*Textinterv;
  end;


  dtg:=Rcorners[1];
  if fframe.ChBNetInterv.checked and (netintL<>0)then begin
     lnetintervL:=round(netintl/mindivL);
  end else begin
  dtg2.x:=dtg.x;
  dtg2.y:=dtg.y+TextintervL*kk;
  dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
  dm_R_to_l(dtg2.x,dtg2.y,b.x,b.y);
  dmm:=(b.x-a.x)/kf;
  if (dmm>=100) {and (dmm<=200)} then
     lnetintervL:=TextintervL
  else
  if (dmm*2>=100) and (dmm*2<=200) then
     lnetintervL:=2*TextintervL
  else if (dmm*4>=100) and (dmm*4<=200) then
     lnetintervL:=4*TextintervL
  else lnetintervL:=8*TextintervL;
  end;
    LongtRad_grad(abs(Rcorners[2].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    
    flgrad:= Rcorners[1].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
    end;
    dtg.y:=Rcorners[1].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);
   if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if Rcorners[1].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

        with Fframe do
    if ChBNetOrig.Checked then begin
      netorgL:=(abs(strtoint(meNetDB_L.edittext))+strtoint(meNetMB_L.edittext)/60+strtoFloat(meNetSB_L.edittext, MyFormatSettings)/3600)/180*PI;
      nlbnetorig_L:=round((netorgL-grad/180*pi)/mindivl);
    end else begin
    nlbnetorig_L:=0;

    end;
  //По долготе
    repeat
    dtg.x:=rcorners[1].x;
    LongtRad_grad (abs(dtg.y),grad,min,sec);
    
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    if nlb mod BigintervalL = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[1].x+20*kf)
           and (a.x<pcorn[2].x-20*kf) then l0:=a;

    end else if nlb mod intermintervall = 0 then begin
      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[1].x+20*kf) and
          (a.x<pcorn[2].x-20*kf) then l0:=a;
    end;
    dtg.x:=rcorners[4].x;
    dtg2:=dtg;
    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod BigintervalL = 0 then begin
       if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
               Tl1.pol[0]:=a;
        Tl1.n:=0;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;

    end else if nlb mod intermintervalL = 0 then begin

      if ((nlb-nlbnetorig_L) mod lnetintervL=0) and (a.x>pcorn[4].x+20*kf) and (a.x<pcorn[3].x-20*kf) then begin
     Tl1.n:=0;
      Tl1.pol[0]:=a;
        Rad_grad(abs(dtg2.x),grad2,min2,sec2);
    if sec2>59.9 then begin //sec2:=0;
     if min2=59 then begin inc(grad2); {min2:=0 }end {else inc(min2)} end;

    nlb2:=round((abs(dtg2.x)-grad2/180*pi)/mindiv);

        While dtg2.x<rcorners[1].x do begin
         dtg2.x:=dtg2.x+Mindiv;
         if dtg2.x>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_B) mod lnetinterv=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].y<>l0.y then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=l0;
        end;


        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;
    end;
        if Rcorners[1].y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg.y:=dtg.y+kk;
     until rcorners[2].y+0.25*kk<dtg.y;


  kk:=minDiv;
     Rad_grad(abs(Rcorners[1].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if Rcorners[1].x>=0 then
      sign:=1
    else
      sign:=-1;
    flgrad:= Rcorners[4].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
    end;

    dtg.x:=Rcorners[4].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[4].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

     with Fframe do
    if ChBNetOrig.Checked then begin
      netorgB:=((abs(strtoint(meNetDB_B.edittext))+strtoint(meNetMB_B.edittext)/60+strtoFloat(meNetSB_B.edittext, MyFormatSettings)/3600)/180*PI);
      nlbnetorig_B:=round((netorgB-grad/180*pi)/mindiv);
    end else begin
       nlbnetorig_B:=0;
    end;
    //По широте
    repeat
    dtg.Y:=rcorners[4].Y;
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);

    if nlb mod Biginterval = 0 then begin
      if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
      end;

      end else if nlb mod interminterval = 0 then begin
      if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[4].y-20*kf) and (a.y>pcorn[1].y+20*kf) then begin
        l0:=a
      end;
      end;
     dtg2:=dtg;
     dtg.y:=rcorners[2].y;
     dm_R_to_l(dtg.x,dtg.y,a.x,a.y);


    if nlb mod Biginterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and (a.y<pcorn[3].y-20*kf) and (a.y>pcorn[2].y+20*kf) then begin
 Tl1.pol[0]:=l0;
        Tl1.N:=0;
          LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);
   
    nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervl=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;

     end else if nlb mod interminterval = 0 then begin
       if ((nlb-nlbnetorig_B) mod lnetinterv=0) and
          (a.y<pcorn[3].y-20*kf) and
          (a.y>pcorn[2].y+20*kf) then begin
             Tl1.pol[0]:=l0;
        Tl1.N:=0;
        LongtRad_grad(abs(dtg2.y),grad2,min2,sec2);

         nlb2:=round((abs(dtg2.y)-grad2/180*pi)/mindivl);

        While dtg2.y<rcorners[2].y do begin
         dtg2.y:=dtg2.y+Mindivl;
         if dtg2.y>=0 then
          inc(nlb2)
        else
          dec(nlb2);

         if ((nlb2-nlbnetorig_L) mod lnetintervl=0) then begin
         inc(Tl1.n);
         dm_R_to_l(dtg2.x,dtg2.y,a2.x,a2.y);
         Tl1.pol[Tl1.n]:=a2;

         end;
        end;
        if Tl1.pol[Tl1.n].x<>a.x then begin
          inc(Tl1.n);
          Tl1.pol[Tl1.n]:=a;
        end;

        dm_Add_Poly(String2code('A0100002'),2,0,@TL1,false);

       end;

     end;

       dtg.x:=dtg.x+kk;
        if Rcorners[4].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[1].x+0.25*kk<dtg.x;
end;


procedure TFFrame.Button12Click(Sender: TObject);
var
   sdm:shortstring;
   i:longint;
  a0,b0,t:lpoint;
  tg0,tg:tgauss;
  dx,dy,dwd,ll,dmdist,km,dkmmindiv,dkm2,dkm4,Code,ld, CodeTextKM, lkmmax,
  StrichCode:integer;
  st:shortstring;
 SaveDlg: TSaveDialog;
 i995,i996,i997:longint;
  t1,t2:_geoid;
   bkmmin, bkmmax:double;
  w999,b901,b911:word;
  A1,A2,dd:Extended;
begin
if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
  end;
dm_Goto_root;
 if dm_get_long(904,0,iscale) then begin

 fltopo:=dm_pps=1;
 if fltopo then
 if not Dm_GET_double(991,0,B991) then begin
   dmw_done;
   Showmessage('Нет опорной параллели');
   exit
 end;
 if not  Dm_get_word(999,0,w999) then w999:=1;
 if not  Dm_get_word(901,0,b901) then b901:=1;
if not  Dm_get_word(911,0,b911) then b911:=1;
if not  Dm_get_word(913,0,b913) then b913:=1;

if not  Dm_get_LONG(995,0,I995) then I995:=0;
if not  Dm_get_LONG(996,0,I996) then I996:=0;
if not  Dm_get_LONG(997,0,I997) then I997:=0;

if fframe.ChBNetInterv.checked then begin
if not dm_get_double(971,0,netintb) then netintb:=0;
if not dm_get_double(972,0,netintl) then netintl:=0;
end;
 BMgr:=abs(B991/PI*180);
 if iscale<=1000 then Nomenkl.scale:=_sc1
 else
 if iscale<=1500 then Nomenkl.scale:=_sc1_5
 else
 if iscale<=2000 then Nomenkl.scale:=_sc2
 else
 if iscale<=2500 then Nomenkl.scale:=_sc2_5
 else
 if iscale<=3000 then Nomenkl.scale:=_sc3
 else
 if iscale<=4000 then Nomenkl.scale:=_sc4
 else
 if iscale<=5000 then Nomenkl.scale:=_sc5
 else
 if iscale<=6000 then Nomenkl.scale:=_sc6
 else
 if iscale<=7000 then Nomenkl.scale:=_sc7
 else
 if iscale<=7500 then Nomenkl.scale:=_sc7_5
 else
 if iscale<=10000 then Nomenkl.scale:=_sc10
 else
 if iscale<=12500 then Nomenkl.scale:=_sc12_5
 else
 if iscale<=15000 then Nomenkl.scale:=_sc15
 else
 if iscale<=17500 then Nomenkl.scale:=_sc17_5
 else
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
  else
 if iscale<=37500 then Nomenkl.scale:=_scM37_5
  else
 if iscale<=40000 then Nomenkl.scale:=_scM40
  else
 if iscale<=50000 then Nomenkl.scale:=_scM50
  else
 if iscale<=75000 then Nomenkl.scale:=_scM75
  else
 if iscale<=100000 then Nomenkl.scale:=_scM100
  else
 if iscale<=150000 then Nomenkl.scale:=_scM150
  else
 if iscale<=200000 then Nomenkl.scale:=_scM200
  else
 if iscale<=250000 then Nomenkl.scale:=_scM250
  else
 if iscale<=300000 then Nomenkl.scale:=_scM300
  else
 if iscale<=500000 then Nomenkl.scale:=_scM500
  else
 if iscale<=750000 then Nomenkl.scale:=_scM750
  else
 if iscale<=1000000 then Nomenkl.scale:=_scM1000
  else
 if iscale<=1500000 then Nomenkl.scale:=_scM1500
  else
 if iscale<=2000000 then Nomenkl.scale:=_scM2000
   else
 if iscale<=2500000 then Nomenkl.scale:=_scM2500
   else
 if iscale<=3000000 then Nomenkl.scale:=_scM3000
   else
 if iscale<=5000000 then Nomenkl.scale:=_scM5000
   else
 if iscale<=10000000 then Nomenkl.scale:=_scM10000;
 scale:=iscale;
 end else begin
   dmw_done;
   exit
   end;
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 if fltopo then begin
  if dmx_find_frst_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[4].x);
  Dm_Get_double(92,0,Rcorners[4].y);
  dm_Get_Bound(pcorn[4],t);

  {Dm_Get_double(901,0,corners[4].x);
  Dm_Get_double(902,0,corners[4].y);
  }
  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[1].x);
  Dm_Get_double(92,0,Rcorners[1].y);
  {Dm_Get_double(901,0,corners[1].x);
  Dm_Get_double(902,0,corners[1].y);
  }
  dm_Get_Bound(pcorn[1],t);
if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[2].x);
  Dm_Get_double(92,0,Rcorners[2].y);
  {Dm_Get_double(901,0,corners[2].x);
  Dm_Get_double(902,0,corners[2].y);
  }
  dm_Get_Bound(pcorn[2],t);

  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[3].x);
  Dm_Get_double(92,0,Rcorners[3].y);
  dm_Get_Bound(pcorn[3],t);
  corr_linkpoint;

 end;
 SaveDlg:=TSaveDialog.Create(Fframe);
 SaveDlg.Title:='Выбор имени карты оформления';
 SaveDlg.DefaultExt:='dm';
 SaveDlg.Filter := 'Файлы (*.DM)|*.dm';
 SaveDlg.InitialDir:=Dirdm;

 if not SaveDLG.Execute then begin
   dmw_done;
   exit
 end;
  dirdm:=ExtractFileDir(SaveDlg.FileName);
 sdm:=SaveDlg.FileName+#0;
 SaveDlg.Destroy;
 if FileExists(sdm) then
   if MessageDlg('Файл уже существует. Переписать?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNO then begin
    dmw_done;
    exit
   end;


 dmdist:=round(dm_dist(1,0));
 dm_goto_root;
  dm_Get_String(903,255,st);
 st:=st+#0;

 dmw_done;
 if fltopo then begin
 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;

 end  else
 if dm_Frame(@sdm[1],@st[1],0,dmdist,tg.x,tg0.y,tg0.x,tg.y)=0 then
    exit;

  if  dmw_open(@sdm[1],true)=0 then exit;
  dm_goto_root;
  dm_put_long(904,iscale);
 if fltopo then begin
 Dm_Put_word(999,w999);
 dm_put_byte(901,b901);
 Dm_Put_byte(911,b911);
 Dm_Put_byte(913,b913);
 Dm_Put_double(991,B991);
 Dm_put_LONG(995,I995);
 Dm_put_LONG(996,I996);
 Dm_put_LONG(997,I997);

   i:=4;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat

 dm_put_double(91,rcorners[i].x);
 dm_put_double(92,rcorners[i].y);
 if i=4 then
   i:=1
 else
   inc(i);
 until dmx_Find_Next_Code(0,1)=0;

 end;

  dm_goto_root;
  dm_Get_bound(a0,b0);

  dm_Get_poly_buf(PL,8000);
  Move(pl^,pb^,sizeof(smallint)+(PL^.n+1)*sizeof(lpoint));
  ll:=(b0.x-a0.x) div 4;
  elm_inc_metric_levo(pl,ll);
  dm_set_Poly_buf(pl);
  dmw_done;
 if not fltopo then begin
 if  dmw_open(@sdm[1],true)=0 then exit;

 i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_get_bound(pcorn[i],pcorn[i]);
 until dmx_Find_Next_Code(0,1)=0;
 dec(pcorn[1].x,ll);
 inc(pcorn[1].y,ll);
 dec(pcorn[2].x,ll);
 dec(pcorn[2].y,ll);
 inc(pcorn[3].x,ll);
 dec(pcorn[3].y,ll);
 inc(pcorn[4].x,ll);
 inc(pcorn[4].y,ll);
 for i:=1 to 4 do
 dm_l_to_g(pcorn[i].x,pcorn[i].y,ExtR[i].x,ExtR[i].y);
  i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_set_bound(pcorn[i],pcorn[i]);
 dm_put_double(901,ExtR[i].x);
 dm_put_double(902,ExtR[i].y);

 until dmx_Find_Next_Code(0,1)=0;

 dmw_done;
 end;

 if not dmw_InsertMap(@sdm[1]) then exit;
 if not Set_active_map(1,true) then exit;
 //if  dmw_open(@sdm[1],true)=0 then exit;
   kf:=dm_dist(1,1);
   if fltopo then
    for i:=1 to 4 do
     dm_R_to_L(rcorners[i].x,rcorners[i].y,pcorn[i].x,pcorn[i].y)
    else
    for i:=1 to 4 do
     dm_G_to_L(corners[i].x,corners[i].y,pcorn[i].x,pcorn[i].y);

  with Fframe do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext, MyFormatSettings)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext, MyFormatSettings)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;


 if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;

     for i:=1 to 4 do
     Tl.pol[i-1]:=pcorn[i];
     Tl.pol[4]:=Tl.pol[0];
     TL.n:=4;
      dx:=round(12.5*kf);
      dy:=round(12.5*kf);
      dwd:=round(kf);


     TLfr.n:=4;

     if ChbLeft.Checked then
       TLfr.pol[0].x:=pcorn[1].x-dx
     else
       TLfr.pol[0].x:=pcorn[1].x-dwd;
     if ChbTop.Checked then
       TLfr.pol[0].y:=pcorn[1].y-dy
     else
       TLfr.pol[0].y:=pcorn[1].y-dWd;
     if Chbright.Checked then
       TLfr.pol[1].x:=pcorn[2].x+dx
     else
       TLfr.pol[1].x:=pcorn[2].x+dwd;
     if ChbTop.Checked then
       TLfr.pol[1].y:=pcorn[2].y-dy
     else
       TLfr.pol[1].y:=pcorn[2].y-dWd;
     if Chbright.Checked then
       TLfr.pol[2].x:=pcorn[3].x+dx
     else
       TLfr.pol[2].x:=pcorn[3].x+dwd;
     if Chbbottom.Checked then
       TLfr.pol[2].y:=pcorn[3].y+dy
     else
       TLfr.pol[2].y:=pcorn[3].y+dwd;
     if Chbleft.Checked then
        TLfr.pol[3].x:=pcorn[4].x-dx
     else
        TLfr.pol[3].x:=pcorn[4].x-dwd;
     if ChbBottom.Checked then
       TLfr.pol[3].y:=pcorn[4].y+dy
     else
       TLfr.pol[3].y:=pcorn[4].y+dwd;

     TLfr.pol[4]:=TLfr.pol[0];

    dmx_Find_Frst_Code(0,1);
     dm_goto_last;
    Mk_COVER;
        dx:=round(0.5*kf);
        dy:=round(0.5*kf);
    If chBxKM.Checked then begin
     if RGKM_LR.ItemIndex=0 then begin
       if ChbTop.Checked then
       tlBigframe.pol[0].x:=TLfr.pol[0].x+dx
        else
       tlBigframe.pol[0].x:=TLfr.pol[0].x;

       if ChbTop.Checked then
         tlBigframe.pol[0].y:=TLfr.pol[0].y+round(10.5*kf)
       else
         tlBigframe.pol[0].y:=TLfr.pol[0].y+dy;
       tlBigframe.pol[1].x:=TLfr.pol[0].x+dx;
       tlBigframe.pol[1].y:=TLfr.pol[0].y+dy;
       tlBigframe.pol[2].x:=TLfr.pol[1].x-dx;
       tlBigframe.pol[2].y:=TLfr.pol[1].y+dy;
       tlBigframe.pol[3].x:=TLfr.pol[2].x-dx;
       tlBigframe.pol[3].y:=TLfr.pol[2].y-dy;
       tlBigframe.pol[4].x:=TLfr.pol[3].x+dx;
       tlBigframe.pol[4].y:=TLfr.pol[3].y-dy;
       if ChbBottom.Checked then
       tlBigframe.pol[5].x:=TLfr.pol[3].x+dx
       else
       tlBigframe.pol[5].x:=TLfr.pol[3].x;

       if ChbBottom.Checked then
         tlBigframe.pol[5].y:=TLfr.pol[3].y-round(10.5*kf)
       else
          tlBigframe.pol[5].y:=TLfr.pol[3].y-dy;
       tlBigframe.n:=5
     end else begin

        tlBigframe.pol[0].x:=TLfr.pol[1].x-dx;
       if ChbTop.Checked then
         tlBigframe.pol[0].y:=TLfr.pol[0].y+round(10.5*kf)
       else
         tlBigframe.pol[0].y:=TLfr.pol[0].y+round(kf);
       tlBigframe.pol[1].x:=TLfr.pol[1].x-dx;
       tlBigframe.pol[1].y:=TLfr.pol[0].y+dy;
       tlBigframe.pol[2].x:=TLfr.pol[0].x+dx;
       tlBigframe.pol[2].y:=TLfr.pol[0].y+dy;
       tlBigframe.pol[3].x:=TLfr.pol[3].x+dx;
       tlBigframe.pol[3].y:=TLfr.pol[3].y-dy;
       tlBigframe.pol[4].x:=TLfr.pol[2].x-dx;
       tlBigframe.pol[4].y:=TLfr.pol[2].y-dy;
       tlBigframe.pol[5].x:=TLfr.pol[2].x-dx;
       if ChbBottom.Checked then
         tlBigframe.pol[5].y:=TLfr.pol[2].y-round(10.5*kf)
       else
          tlBigframe.pol[5].y:=TLfr.pol[2].y-round(kf);
       tlBigframe.n:=5
     end;


   end else begin

     tlBigframe.pol[0].x:=TLfr.pol[0].x+dx;
     tlBigframe.pol[0].y:=TLfr.pol[0].y+dy;
     tlBigframe.pol[1].x:=TLfr.pol[1].x-dx;
     tlBigframe.pol[1].y:=TLfr.pol[1].y+dy;
     tlBigframe.pol[2].x:=TLfr.pol[2].x-dx;
     tlBigframe.pol[2].y:=TLfr.pol[2].y-dy;
     tlBigframe.pol[3].x:=TLfr.pol[3].x+dx;
     tlBigframe.pol[3].y:=TLfr.pol[3].y-dy;
     TLbigFrame.pol[4]:=TLbigFrame.pol[0];
     TLbigFrame.N:=5;
     TLbigFrame.pol[5]:=TLbigFrame.pol[1];
 end;
    //Толстая рамка
    dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
    //Внутрення рамка
    dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
   if chBxKM.Checked then begin
   case Nomenkl.scale of
      _sc20,_sc25,_scM30,_scM37_5,_scM40,_scM50:begin dkmmindiv:=100;
                                      dkm2:=10;
                                      dkm4:=50;
                                end;
       _scM75,_scM100:begin dkmmindiv:=200;
                            dkm2:=10;
                            dkm4:=50;
                      end;
       _scM150,_scM200:begin dkmmindiv:=500;
                            dkm2:=10;
                            dkm4:=50;
                      end;
      _scM250,_scM300,_scM500:begin dkmmindiv:=1000;
                            dkm2:=10;
                            dkm4:=50;
                      end;
      _scM750,_scM1000:begin dkmmindiv:=2000;
                             dkm2:=10;
                             dkm4:=50;
                       end;
      _scM1500,_scM2000:begin dkmmindiv:=5000;
                             dkm2:=10;
                             dkm4:=50;
                       end;
      _scM5000:begin dkmmindiv:=10000;
                              dkm2:=10;
                              dkm4:=50;
      end;
      else begin dkmmindiv:=1000;
                            dkm2:=10;
                            dkm4:=50;
      end;
      end;

      // Километры
      if RGKM_lR.itemindex=0 then begin
        TL.pol[0].x:=TLfr.pol[0].x;
        if chbTop.checked then
          TL.pol[0].y:=TLfr.pol[0].y+round(12.5*kf)
        else
          TL.pol[0].y:=TLfr.pol[0].y+round(2*kf);
        TL.pol[1].x:=TLfr.pol[0].x+round(kf);;
        TL.pol[1].y:=TL.pol[0].y;
        TL.pol[2].x:=TL.pol[1].x;
        if chbBottom.checked then
         TL.pol[2].y:=TLfr.pol[3].y-round(12.5*kf)
        else
         TL.pol[2].y:=TLfr.pol[3].y-round(2*kf);
        TL.pol[3].x:=TLfr.pol[0].x;
        TL.pol[3].y:=TL.pol[2].y;
        TL.pol[4]:=TL.pol[0];
      end else begin
        TL.pol[0].x:=TLfr.pol[1].x;
        if chbTop.checked then
          TL.pol[0].y:=TLfr.pol[1].y+round(12.5*kf)
        else
          TL.pol[0].y:=TLfr.pol[1].y+round(2*kf);
        TL.pol[1].x:=TLfr.pol[1].x-round(kf);;
        TL.pol[1].y:=TL.pol[0].y;
        TL.pol[2].x:=TL.pol[1].x;
        if chbBottom.checked then
          TL.pol[2].y:=TLfr.pol[2].y-round(12.5*kf)
        else
          TL.pol[2].y:=TLfr.pol[2].y-round(2*kf);
        TL.pol[3].x:=TLfr.pol[1].x;
        TL.pol[3].y:=TL.pol[2].y;
        TL.pol[4]:=TL.pol[0];
      end;
      TL.n:=4;
      dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then  begin
       Code:=String2code('A0400230');
       ss:='КИЛОМЕТРЫ'
       end
       else begin
       Code:=String2code('A0400231');
       ss:='KILOMETRES';
       end;
       if RGKM_lR.itemindex=0 then begin
        a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+round(25*kf);

        a.x:=TLfr.pol[0].x-round(11*kf);

         b.y:=a.y-round(50*kf)
       end
       else begin
         a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2-round(25*kf);

         a.x:=TLfr.pol[1].x+round(11*kf);

         b.y:=a.y+round(50*kf);
       end;

       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       if FFrame.CboxLang.itemindex=2 then begin
       Code:=String2code('A0400231');

        ss:='KILOMETRES';
       if RGKM_lR.itemindex=0 then begin
        a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+round(25*kf);

        a.x:=TLfr.pol[0].x-round(16*kf);

         b.y:=a.y-round(50*kf)
       end
       else begin
        a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2-round(25*kf);

         a.x:=TLfr.pol[1].x+round(16*kf);

         b.y:=a.y+round(50*kf);
       end;


       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       end;

        t1.b:=0;
       if RGKM_lR.itemindex=0 then begin
         t1.l:=Rcorners[4].y;
         t2.l:=Rcorners[4].y;
       end else begin
         t1.l:=Rcorners[3].y;
         t2.l:=Rcorners[3].y;
       end;
        if (Rcorners[4].x<0) and (Rcorners[1].x>0) then begin

       t1.b:=0;
       bkmmin:=Rcorners[4].x;
       bkmmax:=Rcorners[1].x;
       CodeTextKM:=String2Code('A0400620');
       StrichCode:=String2Code('A0100003');
      if RGKM_lR.itemindex=1 then begin

       A1:=Pi;
       ld:=0;
        lkmmax:=0;

      WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);

       if t2.b<=bkmmin then break;

       km:=ld div dkmmindiv;
       if km mod dkm4 =0 then begin
          ss:=inttostr((ld div 1000) mod 10000);
          Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          ll:=R[2].x-R[1].x;
          if ll>lkmmax then lkmmax:=ll
       end;
       inc(ld,dkmmindiv);
      end;
       A1:=0;
       ld:=0;
       WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);

       if t2.b>=bkmmax then break;

       km:=ld div dkmmindiv;
       if km mod dkm4 =0 then begin
          ss:=inttostr((ld div 1000) mod 10000);
          Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          ll:=R[2].x-R[1].x;
          if ll>lkmmax then lkmmax:=ll
       end;
       inc(ld,dkmmindiv);
      end;
      end;
       A1:=Pi;
       ld:=0;

       WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);
       if t2.b<=bkmmin then break;
       dm_R_to_l(t2.b,t2.l,a.x,a.y);
       if RGKM_lR.itemindex=0 then
         dec(a.x,round(11.5*kf))
       else
         inc(a.x,round(11.5*kf));
       b.y:=a.y;
       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
          if RGKM_lR.itemindex=0 then
            b.x:=a.x-round(3*kf)
          else
            b.x:=a.x+round(3*kf);
          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;


         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          if RGKM_lR.itemindex=0 then begin
            TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
            TL.pol[0].y:=b.y;
          end else begin
           TL.pol[0].x:=b.x+lkmmax+round(0.5*kf)-R[2].x+R[1].x;
           TL.pol[0].y:=b.y;
          end;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         if RGKM_lR.itemindex=0 then
            b.x:=a.x-round(2*kf)
          else
            b.x:=a.x+round(2*kf)
         else
         if RGKM_lR.itemindex=0 then
            b.x:=a.x-round(kf)
         else
            b.x:=a.x+round(kf);
         dm_add_sign(StrichCode,a,b,0,false);
         inc(ld,dkmmindiv);
     end;
       A1:=0;
       ld:=dkmmindiv;
       WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);
       if t2.b>=bkmmax then break;
       dm_R_to_l(t2.b,t2.l,a.x,a.y);
       if RGKM_lR.itemindex=0 then
         dec(a.x,round(11.5*kf))
       else
         inc(a.x,round(11.5*kf));

       b.y:=a.y;
       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
          if RGKM_lR.itemindex=0 then
            b.x:=a.x-round(3*kf)
          else
            b.x:=a.x+round(3*kf);

          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;


         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          if RGKM_lR.itemindex=0 then begin
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          end else begin

           TL.pol[0].x:=b.x+lkmmax+round(0.5*kf)-R[2].x+R[1].x;
           TL.pol[0].y:=b.y;
          end;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         if RGKM_lR.itemindex=0 then
            b.x:=a.x-round(2*kf)
          else
            b.x:=a.x+round(2*kf)
         else
         if RGKM_lR.itemindex=0 then
            b.x:=a.x-round(kf)
          else
            b.x:=a.x+round(kf);


       dm_add_sign(StrichCode,a,b,0,false);

       inc(ld,dkmmindiv);
     end;

       end else begin

       if Rcorners[4].x>=0 then begin
       t2.b:=Rcorners[4].x;

       //dd:=Geoid_Dist(0,Rcorners[4].y,Rcorners[4].x,Rcorners[4].y,azim);
       end else begin
       t2.b:=abs(Rcorners[1].x);

       //dd:=Geoid_Dist(0,Rcorners[4].y,abs(Rcorners[1].x),Rcorners[4].y,azim);

       end;
       Back_p(t1,t2,A1,A2);
       dd:=A2;
       ld:=(trunc(dd/dkmmindiv)+1)*dkmmindiv;
       //if Rcorners[4].x>=0 then
       A1:=0;
       //else
       //A1:=Pi*0.5;

       t1.b:=0;
       if RGKM_lR.itemindex=0 then
       t1.l:=Rcorners[4].y
        else
       t1.l:=Rcorners[3].y;
       if Rcorners[4].x>=0 then begin
         bkmmin:=Rcorners[4].x;
         bkmmax:=Rcorners[1].x
       end else begin
         bkmmin:=abs(Rcorners[1].x);
         bkmmax:=abs(Rcorners[4].x)
       end;
       CodeTextKM:=String2Code('A0400620');
       StrichCode:=String2Code('A0100003');
       lkmmax:=0;

      if RGKM_lR.itemindex=1 then
      WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);

       if abs(t2.b)>=bkmmax then break;
       if abs(t2.b)>bkmmin then begin
       if Rcorners[4].x<0 then t2.b:=-t2.b;

       km:=ld div dkmmindiv;
       if km mod dkm4 =0 then begin
          ss:=inttostr((ld div 1000) mod 10000);
          Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          ll:=R[2].x-R[1].x;
          if ll>lkmmax then lkmmax:=ll
       end;
       inc(ld,dkmmindiv);

      end;
      end;
       ld:=(trunc(dd/dkmmindiv)+1)*dkmmindiv;

      WHILE  true do begin
       Direct (t1,A1,ld,t2,A2);
       if abs(t2.b)>=bkmmax then break;
       if abs(t2.b)>bkmmin then begin
       if Rcorners[4].x<0 then t2.b:=-t2.b;

       dm_R_to_l(t2.b,t2.l,a.x,a.y);
       if RGKM_lR.itemindex=0 then
         dec(a.x,round(11.5*kf))
       else
         inc(a.x,round(11.5*kf));

       b.y:=a.y;
       km:=ld div dkmmindiv;
       if km mod dkm2 =0 then begin
          if RGKM_lR.itemindex=0 then
            b.x:=a.x-round(3*kf)
          else
            b.x:=a.x+round(3*kf);

          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;
          Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);

          if RGKM_lR.itemindex=0 then begin
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          end else begin

           TL.pol[0].x:=b.x+lkmmax+round(0.5*kf)-R[2].x+R[1].x;
           TL.pol[0].y:=b.y;
          end;

          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then begin
          if RGKM_lR.itemindex=0 then
             b.x:=a.x-round(2*kf)
             else
             b.x:=a.x+round(2*kf)
       end else begin
         if RGKM_lR.itemindex=0 then
           b.x:=a.x-round(kf)
         else
           b.x:=a.x+round(kf)

       end;
       dm_add_sign(StrichCode,a,b,0,false);
       end;
       //if Rcorners[4].x>=0 then

       inc(ld,dkmmindiv);
       //else
       //dec(ld,dkmmindiv);
      end;
     end;
     end;
     Make_NET_on_Klapan;
   dmw_done;

   Showmessage('Карта с рамкой для клапанов создана')
end;

procedure TFFrame.Button13Click(Sender: TObject);
var code,iscale:longint;
    i,i1,i2:integer;
    offs: longint;
    ss:shortstring;
    tga,tgb:tgauss;
    a,b:lpoint;
    kk,dd:double;
    mn:pchar;
    Tag: byte;
    bVert,bHor:Boolean;
begin
  dmw_PickMessage('Укажи объект рамку клапана');
  if not wm_PickObject(offs,Code,Tag,a,b,ss) then exit;
  if (tag<2) or ((tag>3) and (tag<22)) or (tag>23) then exit;
  dmw_PickMessage('Укажи точку рядом с первой точкой прямого участка рамки');
  if not wm_PickPoint(a,tga) then exit;
  dmw_PickMessage('Укажи точку рядом с последней точкой прямого участка рамки');
  if not wm_PickPoint(b,tgb) then exit;

  dmw_PickMessage('');

  mn:=dmw_activemap(Pfiles,65528);
  if not assigned(mn) then begin
    ShowMessage('Нет активной карты');
    exit
  end;
  if dmw_open(mn,true)= 0 then begin
    ShowMessage('Не возможно открыть активную карту');
    exit
  end;
  kf:=dm_dist(1,1);
  dm_Goto_root;
  if dm_get_long(904,0,iscale) then begin
    dm_goto_node(offs);
    dm_get_poly_buf(pb,8000);
    dd:=Rmax;
  for i:=0 to pb^.N do begin
    kk:=sqr_distance(a,pb^.pol[i]);
    if kk< dd then begin
      i1:=i;
      dd:=kk
    end;
  end;
  dd:=Rmax;
  for i:=0 to pb^.N do begin
    kk:=sqr_distance(b,pb^.pol[i]);
    if kk< dd then begin
      i2:=i;
      dd:=kk
    end;
  end;
  a:=pb^.pol[i1];
  b:=pb^.pol[i2];
  dm_l_to_r(a.x,a.y,tga.x,tga.y);
  dm_l_to_r(b.x,b.y,tgb.x,tgb.y);
  bvert:=abs(tga.y-tgb.y)<1.e-8;
  Bhor:=abs(tga.x-tgb.x)<1.e-8;
  if Bvert and bHor then begin
    dmw_done;
    Showmessage('Ошибка: указаны совпадающие точки');
    exit
  end;
  if not(Bvert or bHor) then begin
    dmw_done;
    Showmessage('Ошибка: указан не горизонтальный или вертикальный участок');
    exit
  end;
 end else begin
   dmw_done;
   exit
 end;

   with Fframe do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext, MyFormatSettings)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext, MyFormatSettings)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;

{ if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;
}
if iscale>25000 then NAVYKIND:=1 else
        NAVYKIND:=0;
if NavyKind=0 then begin
 if Bvert then
  Make_grad_labels_Vert_on_VRZPlan(a,b)
 else
  Make_grad_labels_Hor_on_VRZPlan(a,b)
end else begin
 if Bvert then
  Make_grad_labels_Vert_on_VRZMap(a,b)
 else
  Make_grad_labels_Hor_on_VRZMap(a,b)

end;
dmw_done;
dmw_showWindow(1,1,0,0);
Showmessage('Разбивка произведена');
end;

procedure TFFrame.Button5Click(Sender: TObject);
var
  d1,d2:single;
   sdm:shortstring;
   i,lcode:longint;
  a0,b0,t:lpoint;
  tg0,tg:tgauss;
  dx,dy,dwd,ll,dmdist:integer;
  st:shortstring;
  SaveDlg: TSaveDialog;
  i995,i996,i997:longint;
  sgrad,smin,ssec:s4;
  w999,b901,b911:word;
  litera:char;
begin
if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
  end;
dm_Goto_root;
 if dm_get_long(904,0,iscale) then begin

 fltopo:=dm_pps=1;
 if fltopo then
 if not Dm_GET_double(991,0,B991) then begin
   dmw_done;
   Showmessage('Нет опорной параллели');
   exit
 end;
 if not  Dm_get_word(999,0,w999) then w999:=1;
 if not  Dm_get_word(901,0,b901) then b901:=1;
if not  Dm_get_word(911,0,b911) then b911:=1;
if not  Dm_get_word(913,0,b913) then b913:=1;

if not  Dm_get_LONG(995,0,I995) then I995:=0;
if not  Dm_get_LONG(996,0,I996) then I996:=0;
if not  Dm_get_LONG(997,0,I997) then I997:=0;

if fframe.ChBNetInterv.checked then begin
if not dm_get_double(971,0,netintb) then netintb:=0;
if not dm_get_double(972,0,netintl) then netintl:=0;
end;
 BMgr:=abs(B991/PI*180);
 if iscale<=1000 then Nomenkl.scale:=_sc1
 else
 if iscale<=1500 then Nomenkl.scale:=_sc1_5
 else
 if iscale<=2000 then Nomenkl.scale:=_sc2
 else
 if iscale<=2500 then Nomenkl.scale:=_sc2_5
 else
 if iscale<=3000 then Nomenkl.scale:=_sc3
 else
 if iscale<=4000 then Nomenkl.scale:=_sc4
 else
 if iscale<=5000 then Nomenkl.scale:=_sc5
 else
 if iscale<=6000 then Nomenkl.scale:=_sc6
 else
 if iscale<=7000 then Nomenkl.scale:=_sc7
 else
 if iscale<=7500 then Nomenkl.scale:=_sc7_5
 else
 if iscale<=10000 then Nomenkl.scale:=_sc10
 else
 if iscale<=12500 then Nomenkl.scale:=_sc12_5
 else
 if iscale<=15000 then Nomenkl.scale:=_sc15
 else
 if iscale<=17500 then Nomenkl.scale:=_sc17_5
 else
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
  else
 if iscale<=37500 then Nomenkl.scale:=_scM37_5
  else
 if iscale<=40000 then Nomenkl.scale:=_scM40
  else
 if iscale<=50000 then Nomenkl.scale:=_scM50
  else
 if iscale<=75000 then Nomenkl.scale:=_scM75
  else
 if iscale<=100000 then Nomenkl.scale:=_scM100
  else
 if iscale<=150000 then Nomenkl.scale:=_scM150
  else
 if iscale<=200000 then Nomenkl.scale:=_scM200
  else
 if iscale<=250000 then Nomenkl.scale:=_scM250
  else
 if iscale<=300000 then Nomenkl.scale:=_scM300
  else
 if iscale<=500000 then Nomenkl.scale:=_scM500
  else
 if iscale<=750000 then Nomenkl.scale:=_scM750
  else
 if iscale<=1000000 then Nomenkl.scale:=_scM1000
  else
 if iscale<=1500000 then Nomenkl.scale:=_scM1500
  else
 if iscale<=2000000 then Nomenkl.scale:=_scM2000
   else
 if iscale<=2500000 then Nomenkl.scale:=_scM2500
   else
 if iscale<=3000000 then Nomenkl.scale:=_scM3000
   else
 if iscale<=5000000 then Nomenkl.scale:=_scM5000
   else
 if iscale<=10000000 then Nomenkl.scale:=_scM10000;
scale:=iscale;
 end else begin
   dmw_done;
   exit
   end;
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);
 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 if fltopo then begin
  if dmx_find_frst_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[4].x);
  Dm_Get_double(92,0,Rcorners[4].y);
  dm_Get_Bound(pcorn[4],t);

  {Dm_Get_double(901,0,corners[4].x);
  Dm_Get_double(902,0,corners[4].y);
  }
  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[1].x);
  Dm_Get_double(92,0,Rcorners[1].y);
  {Dm_Get_double(901,0,corners[1].x);
  Dm_Get_double(902,0,corners[1].y);
  }
  dm_Get_Bound(pcorn[1],t);
if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;

  Dm_Get_double(91,0,Rcorners[2].x);
  Dm_Get_double(92,0,Rcorners[2].y);
  {Dm_Get_double(901,0,corners[2].x);
  Dm_Get_double(902,0,corners[2].y);
  }
  dm_Get_Bound(pcorn[2],t);

  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[3].x);
  Dm_Get_double(92,0,Rcorners[3].y);
  dm_Get_Bound(pcorn[3],t);
  corr_linkpoint;

 end;
 SaveDlg:=TSaveDialog.Create(Fframe);
 SaveDlg.Title:='Выбор имени карты оформления';
 SaveDlg.DefaultExt:='dm';
 SaveDlg.Filter := 'Файлы (*.DM)|*.dm';
 SaveDlg.InitialDir:=Dirdm;

 if not SaveDLG.Execute then begin
   dmw_done;
   exit
 end;
  dirdm:=ExtractFileDir(SaveDlg.FileName);
 sdm:=SaveDlg.FileName+#0;
 SaveDlg.Destroy;
 if FileExists(sdm) then
   if MessageDlg('Файл уже существует. Переписать?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNO then begin
    dmw_done;
    exit
   end;

 dmdist:=round(dm_dist(1,0));
 dm_goto_root;
  dm_Get_String(903,255,st);
 st:=st+#0;

 dmw_done;
 if fltopo then begin
 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;

 end  else
 if dm_Frame(@sdm[1],@st[1],0,dmdist,tg.x,tg0.y,tg0.x,tg.y)=0 then
    exit;

  if  dmw_open(@sdm[1],true)=0 then exit;
  dm_goto_root;
  dm_put_long(904,iscale);
 if fltopo then begin
 Dm_Put_word(999,w999);
 dm_put_byte(901,b901);
 Dm_Put_byte(911,b911);
 Dm_Put_byte(913,b913);
 Dm_Put_double(991,B991);
 Dm_put_LONG(995,I995);
 Dm_put_LONG(996,I996);
 Dm_put_LONG(997,I997);

   i:=4;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat

 dm_put_double(91,rcorners[i].x);
 dm_put_double(92,rcorners[i].y);
 if i=4 then
   i:=1
 else
   inc(i);
 until dmx_Find_Next_Code(0,1)=0;

 end;

  dm_goto_root;
  dm_Get_bound(a0,b0);

  dm_Get_poly_buf(PL,8000);
  Move(pl^,pb^,sizeof(smallint)+(PL^.n+1)*sizeof(lpoint));
  ll:=(b0.x-a0.x) div 4;
  elm_inc_metric_levo(pl,ll);
  dm_set_Poly_buf(pl);
  dmw_done;
 if not fltopo then begin
 if  dmw_open(@sdm[1],true)=0 then exit;

 i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_get_bound(pcorn[i],pcorn[i]);
 until dmx_Find_Next_Code(0,1)=0;
 dec(pcorn[1].x,ll);
 inc(pcorn[1].y,ll);
 dec(pcorn[2].x,ll);
 dec(pcorn[2].y,ll);
 inc(pcorn[3].x,ll);
 dec(pcorn[3].y,ll);
 inc(pcorn[4].x,ll);
 inc(pcorn[4].y,ll);
 for i:=1 to 4 do
 dm_l_to_g(pcorn[i].x,pcorn[i].y,ExtR[i].x,ExtR[i].y);
  i:=0;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 inc(i);

 dm_set_bound(pcorn[i],pcorn[i]);
 dm_put_double(901,ExtR[i].x);
 dm_put_double(902,ExtR[i].y);

 until dmx_Find_Next_Code(0,1)=0;

 dmw_done;
 end;

 if not dmw_InsertMap(@sdm[1]) then exit;
 if not Set_active_map(1,true) then exit;
   kf:=dm_dist(1,1);
   if fltopo then
    for i:=1 to 4 do
     dm_R_to_L(rcorners[i].x,rcorners[i].y,pcorn[i].x,pcorn[i].y)
    else
    for i:=1 to 4 do
     dm_G_to_L(corners[i].x,corners[i].y,pcorn[i].x,pcorn[i].y);



 if Nomenkl.scale>_sc25 then
        NAVYKIND:=1 else
        NAVYKIND:=0;

     for i:=1 to 4 do
     Tl.pol[i-1]:=pcorn[i];
     Tl.pol[4]:=Tl.pol[0];
     TL.n:=4;
      dx:=round(9.5*kf);
      dy:=round(9.5*kf);
      dwd:=round(0.8*kf);
     TLfr.n:=4;
     if ChbLeft.Checked then
       TLfr.pol[0].x:=pcorn[1].x-dx
     else
       TLfr.pol[0].x:=pcorn[1].x-dwd;
     if ChbTop.Checked then
       TLfr.pol[0].y:=pcorn[1].y-dy
     else
       TLfr.pol[0].y:=pcorn[1].y-dWd;
     if Chbright.Checked then
       TLfr.pol[1].x:=pcorn[2].x+dx
     else
       TLfr.pol[1].x:=pcorn[2].x+dwd;
     if ChbTop.Checked then
       TLfr.pol[1].y:=pcorn[2].y-dy
     else
       TLfr.pol[1].y:=pcorn[2].y-dWd;
     if Chbright.Checked then
       TLfr.pol[2].x:=pcorn[3].x+dx
     else
       TLfr.pol[2].x:=pcorn[3].x+dwd;
     if Chbbottom.Checked then
       TLfr.pol[2].y:=pcorn[3].y+dy
     else
       TLfr.pol[2].y:=pcorn[3].y+dwd;
     if Chbleft.Checked then
        TLfr.pol[3].x:=pcorn[4].x-dx
     else
        TLfr.pol[3].x:=pcorn[4].x-dwd;
     if ChbBottom.Checked then
       TLfr.pol[3].y:=pcorn[4].y+dy
     else
       TLfr.pol[3].y:=pcorn[4].y+dwd;

     TLfr.pol[4]:=TLfr.pol[0];
    dmx_Find_Frst_Code(0,1);
     dm_goto_last;
    Mk_COVER;
        dx:=round(0.4*kf);
        dy:=round(0.4*kf);


     tlBigframe.pol[0].x:=TLfr.pol[0].x+dx;
     tlBigframe.pol[0].y:=TLfr.pol[0].y+dy;
     tlBigframe.pol[1].x:=TLfr.pol[1].x-dx;
     tlBigframe.pol[1].y:=TLfr.pol[1].y+dy;
     tlBigframe.pol[2].x:=TLfr.pol[2].x-dx;
     tlBigframe.pol[2].y:=TLfr.pol[2].y-dy;
     tlBigframe.pol[3].x:=TLfr.pol[3].x+dx;
     tlBigframe.pol[3].y:=TLfr.pol[3].y-dy;
    TLbigFrame.pol[4]:=TLbigFrame.pol[0];
    TLbigFrame.N:=5;
    TLbigFrame.pol[5]:=TLbigFrame.pol[1];
    //Толстая рамка
    dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
    //Внутрення рамка
    dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);

  lcode:=string2code('A0400332');
  for i:=1 to 4 do begin
     Calc_grad_min_sec_pr(abs(rcorners[i].y),sgrad,smin,ssec);
     if  (rcorners[i].y>=0) and (rcorners[i].y<=Pi_2)then
       litera:='E'
     else
       litera:='W';
     if flsec then
         ss:=sgrad+smin+ssec+litera
     else
         ss:=sgrad+smin+litera;

    case i of
     1,4: kk:=3.3;
     2,3: kk:=-3.3;
    end;
    a.x:=round(pcorn[i].x+kk*kf);
    a.y:=pcorn[i].y;
     case i of
     1,3: begin    Text_Bound(lcode,a,a,R,ss);
            if i=1 then
             a.y:=pcorn[i].y+round(3.5*kf)+R[2].x-R[1].x
            else
             a.y:=pcorn[i].y-round(3.5*kf)-R[2].x+R[1].x;
          end;
     2:  a.y:=round(pcorn[i].y+3.5*kf);
     4:  a.y:=round(pcorn[i].y-3.5*kf);
    end;
     case i of
     1,4: b.y:=a.y-R[2].x+R[1].x;
     2,3: b.y:=a.y+R[2].x-R[1].x;
    end;
    b.x:= a.x;
    Add_Text(lcode,a,b,0,ss,false);
  end;

lcode:=String2code('A0400332');
for i:=1 to 4 do begin
    Calc_grad_min_sec_pr(abs(rcorners[i].x),sgrad,smin,ssec);
    if rcorners[i].x>=0 then
      litera:='N'
    else
     litera:='S';
     if flsec then
         ss:=sgrad+smin+ssec+litera
      else
         ss:=sgrad+smin+litera;
    case i of
     1,2: kk:=3.3;
     3,4: kk:=-1.5;
    end;
    a.y:=pcorn[i].y+round(kk*kf);
    if (i=2) or (i=3) then begin
    a.x:=round(pcorn[i].x);
    Text_Bound(lcode,a,a,R,ss);
    a.x:=round(pcorn[i].x-R[2].x+R[1].x-3.5*kf)
    end
    else
    a.x:=round(pcorn[i].x+3.5*kf);
    Add_Text(lcode,a,a,0,ss,false);
  end;
    //Градусная разбивка
{    var code,iscale:longint;
    i,i1,i2:integer;
    offs: longint;
    x1,y1,x2,y2: longint;
    ss:shortstring;
    tga,tgb:tgauss;
    a,b:lpoint;
    kk,dd:double;
    gx,gy: double;
    mn:pchar;
    lcode:longint;
    sgrad,smin,ssec:s4;
    litera:char;
    i:byte;
    Tag: byte;
    bVert,bHor:Boolean;
}

   with Fframe do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext, MyFormatSettings)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext, MyFormatSettings)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext, MyFormatSettings)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext, MyFormatSettings)/3600)/180*PI)/mindivL);
    end;
    if abs(mindiv -Pi/6480000) < 1e-8 then
    tmindiv:=1
    else
    if abs(mindiv -Pi/3240000) < 1e-8 then
    tmindiv:=2
    else
if abs(mindiv -Pi/1296000) < 1e-8 then
    tmindiv:=3
    else
if abs(mindiv -Pi/648000) < 1e-8 then
    tmindiv:=4
    else
if abs(mindiv -Pi/324000) < 1e-8 then
    tmindiv:=5
    else
if abs(mindiv -Pi/216000) < 1e-8 then
    tmindiv:=6
    else
if abs(mindiv -Pi/108000) < 1e-8 then
    tmindiv:=7
    else
 if abs(mindiv -Pi/54000) < 1e-8 then
    tmindiv:=8
    else

if abs(mindiv -Pi/21600) < 1e-8 then
    tmindiv:=9
    else
if abs(mindiv -Pi/10800) < 1e-8 then
    tmindiv:=10
    else
if abs(mindiv -Pi/5400) < 1e-8 then
    tmindiv:=11
    else
if abs(mindiv -Pi/2160) < 1e-8 then
    tmindiv:=12
    else
if abs(mindiv -Pi/1080) < 1e-8 then
    tmindiv:=13
    else
    tmindiv:=0;

 Make_grad_labels_Vert_on_VRZPlan(pcorn[1],pcorn[4]);
 Make_grad_labels_Vert_on_VRZPlan(pcorn[3],pcorn[2]);
 Make_grad_labels_Hor_on_VRZPlan(pcorn[2],pcorn[1]);
 Make_grad_labels_Hor_on_VRZPlan(pcorn[4],pcorn[3]);
  d1:=abs(pcorn[2].x-pcorn[1].x)/kf;
    d2:=abs(pcorn[3].y-pcorn[2].y)/kf;
    if (d1>250) or (d2>250) then
   
 Make_NET_on_Klapan;
 dmw_done;
 Showmessage('Оформление карт планов создано')

end;

procedure TFFrame.Button6Click(Sender: TObject);
begin
Fconus.show
end;

procedure TFFrame.Button7Click(Sender: TObject);
begin
FNormSt.show;
end;

procedure TFFrame.btProdsignClick(Sender: TObject);
var
cod : longint;
loc: Byte;FL : Boolean;
begin
FL:=dmw_ChooseObject(String2Code(MeColorSign.EditText),1,cod,loc,NIL,0);
IF FL and(loc=1) THEN begin
    MeColorSign.EditText:=Code2String(cod);
  end;
Show;
end;

procedure TFFrame.Button14Click(Sender: TObject);
begin
Fart.show
end;

end.
