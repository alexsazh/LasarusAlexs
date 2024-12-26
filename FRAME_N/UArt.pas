unit UArt;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Masks, iniFiles, mfrmNavy,FrNavyFun,NevaUtil, win_use,Dmw_ddw, dmw_Use, OTypes, geoidnw, wmPick,
  ExtCtrls, MaskEdit;

type
  TFArt = class(TForm)
    Label23: TLabel;
    Label33: TLabel;
    Label12: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    meMDM: TMaskEdit;
    meMDS: TMaskEdit;
    meSmInM: TMaskEdit;
    meSmInS: TMaskEdit;
    meSmInD: TMaskEdit;
    meIntrD: TMaskEdit;
    meIntrM: TMaskEdit;
    meIntrS: TMaskEdit;
    meBigIntrD: TMaskEdit;
    meBigIntrM: TMaskEdit;
    meBigIntrS: TMaskEdit;
    meTextIntrD: TMaskEdit;
    meTextIntrM: TMaskEdit;
    meTextIntrS: TMaskEdit;
    meShrafD: TMaskEdit;
    meShrafM: TMaskEdit;
    meShrafS: TMaskEdit;
    meMDM_L: TMaskEdit;
    meMDS_L: TMaskEdit;
    meSmInM_L: TMaskEdit;
    meSmInS_L: TMaskEdit;
    meSmInD_L: TMaskEdit;
    meIntrD_L: TMaskEdit;
    meIntrM_L: TMaskEdit;
    meIntrS_L: TMaskEdit;
    meBigIntrD_L: TMaskEdit;
    meBigIntrM_L: TMaskEdit;
    meBigIntrS_L: TMaskEdit;
    meTextIntrD_L: TMaskEdit;
    meTextIntrM_L: TMaskEdit;
    meTextIntrS_L: TMaskEdit;
    meShrafD_L: TMaskEdit;
    meShrafM_L: TMaskEdit;
    meShrafS_L: TMaskEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ChbAddtxt: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdYear: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MeL1D: TMaskEdit;
    Label10: TLabel;
    MeL1M: TMaskEdit;
    Label11: TLabel;
    MeL2D: TMaskEdit;
    Label13: TLabel;
    MeL2M: TMaskEdit;
    Label14: TLabel;
    MeL3D: TMaskEdit;
    Label15: TLabel;
    MeL3M: TMaskEdit;
    Label16: TLabel;
    edD1: TEdit;
    edD2: TEdit;
    edD3: TEdit;
    edG1: TEdit;
    edG2: TEdit;
    edG3: TEdit;
    edOr1: TEdit;
    edOr2: TEdit;
    edOr3: TEdit;
    Button4: TButton;
    Label17: TLabel;
    MeL0: TMaskEdit;
    Label44: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FArt: TFArt;
  IniFile:TiniFile;

implementation

uses UFrmnavy, nvunzarm, UconFrm;
var
  sadm:shortstring;
{$R *.lfm}
Procedure Kabeltov_net;
var
  ss:shortstring;
  code,CodeTextKM,StrichCode,km,ly,dkm2:integer;
  ld,kabmindiv:double;
  t1,t2: _geoid;
  var A1,s,A2: EXTENDED;
begin
      kabmindiv:=182.88;
      dkm2:=10;
      TL.pol[0].x:=TLfr.pol[0].x-round(21*kf);
      TL.pol[0].y:=TLfr.pol[0].y+round(12.5*kf);
      TL.pol[1].x:=TLfr.pol[0].x-round(20*kf);
      TL.pol[1].y:=TL.pol[0].y;
      TL.pol[2].x:=TLfr.pol[3].x-round(20*kf);
      TL.pol[2].y:=TLfr.pol[3].y-round(12.5*kf);
      TL.pol[3].x:=TLfr.pol[3].x-round(21*kf);
      TL.pol[3].y:=TL.pol[2].y;
      TL.pol[4]:=TL.pol[0];
      TL.n:=4;
      dm_Add_Poly(99000010,2,0,@TL,false);
      {Code:=String2code('A0400230');
      ss:='КИЛОМЕТРЫ';
       Text_Bound(Code,TL.pol[0],TL.pol[0],R,ss);
          ly:=(R[2].x-R[1].x) div 2;
      }
      ly:=round(25*kf);
      // if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then  begin
       Code:=99000040;

       ss:='АРТИЛЛЕРИЙСКИЕ';// КАБЕЛЬТОВЫ'
       {end
       else begin
       Code:=String2code('A0400231');

       ss:='KILOMETRES';
       end;
       }

       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2-ly-round(88*kf);
       b.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2-ly-round(10*kf);
       a.x:=(TLfr.pol[0].x+TLfr.pol[3].x) div 2-round(17.8*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       ss:='КАБЕЛЬТОВЫ';
        a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+ly+round(10*kf);
       b.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+ly+round(67*kf);
       a.x:=(TLfr.pol[0].x+TLfr.pol[3].x) div 2-round(17.8*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);


       {if FFrame.CboxLang.itemindex=2 then begin
       Code:=String2code('A0400231');

       ss:='KILOMETRES';
       a.y:=(TLfr.pol[0].y+TLfr.pol[3].y) div 2+round(25*kf);
       b.y:=a.y-round(50*kf);
       a.x:=TLfr.pol[0].x-round(16*kf);
       b.x:=a.x;
       add_text(Code,a,b,0,ss,false);
       dm_set_tag(4);
       end;
       }
      t1.b:=Rcorners[4].x;
      t1.l:=Rcorners[4].y;
       A1:=0;

       CodeTextKM:=99000030;
       StrichCode:=99000020;
       ld:=0;
       WHILE  true do begin
       Direct (t1,A1,kabmindiv,t2,A2);
       dm_R_to_l(t1.b,t1.l,a.x,a.y);
       if a.y<Pcorn[1].y then break;
       t1:=t2;
       //A1:=A2+Pi;
       dec(a.x,round(32.5*kf));
       b.y:=a.y;
       km:=round(ld/kabmindiv);
       if km mod dkm2 =0 then begin
          b.x:=a.x-round(3*kf);
          {
          if km mod dkm4 =0 then
          ss:=inttostr((ld div 1000) mod 10000)
          else begin
          if Nomenkl.scale>_scM1000 then
          ss:=Format('%3.3d',[(ld div 1000) mod 1000])
           else
          ss:=Format('%2.2d',[(ld div 1000) mod 100]);
          end;
          }
          ss:=inttostr(km);

         Text_Bound(CodeTextKM,TL.pol[0],TL.pol[0],R,ss);
          TL.pol[0].x:=b.x-R[2].x+R[1].x-round(0.5*kf);
          TL.pol[0].y:=b.y;
          add_text(CodeTextKM,TL.pol[0],TL.pol[0],0,ss,false);
          dm_set_tag(1);
       end else if km mod dkm2 =5 then
         b.x:=a.x-round(2*kf)
       else
         b.x:=a.x-round(kf);

       dm_add_sign(StrichCode,a,b,0,false);

       ld:=ld+kabmindiv;
     end;

end;

procedure TFArt.FormCreate(Sender: TObject);
begin
IniFile:=TIniFile.Create(make_ini('FrameNavy.ini'));
Height:=IniFile.ReadInteger('ARTFRAME','CONUS_Height',420);
Width :=IniFile.ReadInteger('ARTFRAME','CONUS_Width',810);
    meMDM.EditText:=IniFile.ReadString('ARTINTERV','MDM','00');
    meMDS.EditText:=IniFile.ReadString('ARTINTERV','MDS','12');
    meSmInD.EditText:=IniFile.ReadString('ARTINTERV','SmInD','00');
    meSmInM.EditText:=IniFile.ReadString('ARTINTERV','SmInM','01');
    meSmInS.EditText:=IniFile.ReadString('ARTINTERV','SmInS','00');
    meIntrD.EditText:=IniFile.ReadString('ARTINTERV','IntrD','00');
    meIntrM.EditText:=IniFile.ReadString('ARTINTERV','IntrM','10');
    meIntrS.EditText:=IniFile.ReadString('ARTINTERV','IntrDS','00');
    meBigIntrD.EditText:=IniFile.ReadString('ARTINTERV','BigIntrD','00');
    meBigIntrM.EditText:=IniFile.ReadString('ARTINTERV','BigIntrM','10');
    meBigIntrS.EditText:=IniFile.ReadString('ARTINTERV','BigIntrS','00');
    meTextIntrD.EditText:=IniFile.ReadString('ARTINTERV','TextIntrD','00');
    meTextIntrM.EditText:=IniFile.ReadString('ARTINTERV','TextIntrM','10');
    meTextIntrS.EditText:=IniFile.ReadString('ARTINTERV','TextIntrS','00');
    meShrafD.EditText:=IniFile.ReadString('ARTINTERV','ShrafD','00');
    meShrafM.EditText:=IniFile.ReadString('ARTINTERV','ShrafM','05');
    meShrafS.EditText:=IniFile.ReadString('ARTINTERV','ShrafS','00');

    meMDM_L.EditText:=IniFile.ReadString('ARTINTERV','MDM_L','00');
    meMDS_L.EditText:=IniFile.ReadString('ARTINTERV','MDS_L','12');
    meSmInD_L.EditText:=IniFile.ReadString('ARTINTERV','SmInD_L','00');
    meSmInM_L.EditText:=IniFile.ReadString('ARTINTERV','SmInM_L','01');
    meSmInS_L.EditText:=IniFile.ReadString('ARTINTERV','SmInS_L','00');

    meIntrD_L.EditText:=IniFile.ReadString('ARTINTERV','IntrD_L','00');
    meIntrM_L.EditText:=IniFile.ReadString('ARTINTERV','IntrM_L','10');
    meIntrS_L.EditText:=IniFile.ReadString('ARTINTERV','IntrDS_L','00');
    meBigIntrD_L.EditText:=IniFile.ReadString('ARTINTERV','BigIntrD_L','00');
    meBigIntrM_L.EditText:=IniFile.ReadString('ARTINTERV','BigIntrM_L','10');
    meBigIntrS_L.EditText:=IniFile.ReadString('ARTINTERV','BigIntrS_L','00');
    meTextIntrD_L.EditText:=IniFile.ReadString('ARTINTERV','TextIntrD_L','00');
    meTextIntrM_L.EditText:=IniFile.ReadString('ARTINTERV','TextIntrM_L','10');
    meTextIntrS_L.EditText:=IniFile.ReadString('ARTINTERV','TextIntrS_L','00');
    meShrafD_L.EditText:=IniFile.ReadString('ARTINTERV','ShrafD_L','00');
    meShrafM_L.EditText:=IniFile.ReadString('ARTINTERV','ShrafM_L','05');
    meShrafS_L.EditText:=IniFile.ReadString('ARTINTERV','ShrafS_L','00');
    ChbAddtxt.Checked:=IniFile.ReadBool('ARTFRAME','ChbAddtxt',true);
    MeL0.EditText:=IniFile.ReadString('ARTSKLON','MeL0','27');

    EdYear.Text:=IniFile.ReadString('ARTSKLON','EdYear','2000');
    MeL1D.EditText:=IniFile.ReadString('ARTSKLON','MeL1D','29');
    MeL1M.EditText:=IniFile.ReadString('ARTSKLON','MeL1M','40');
    MeL2D.EditText:=IniFile.ReadString('ARTSKLON','MeL2D','30');
    MeL2M.EditText:=IniFile.ReadString('ARTSKLON','MeL2M','02');
    MeL3D.EditText:=IniFile.ReadString('ARTSKLON','MeL3D','30');
    MeL3M.EditText:=IniFile.ReadString('ARTSKLON','MeL3M','24');
    edD1.Text:=IniFile.ReadString('ARTSKLON','EdD1','+1.6');
    edD2.Text:=IniFile.ReadString('ARTSKLON','EdD2','+1.6');
    edD3.Text:=IniFile.ReadString('ARTSKLON','EdD3','+1.5');
    edG1.Text:=IniFile.ReadString('ARTSKLON','EdG1','+1.3');
    edG2.Text:=IniFile.ReadString('ARTSKLON','EdG2','+1.5');
    edG3.Text:=IniFile.ReadString('ARTSKLON','EdG3','+1.7');
    edOr1.Text:=IniFile.ReadString('ARTSKLON','EdOr1','+0.3');
    edOr2.Text:=IniFile.ReadString('ARTSKLON','EdOr2','+0.1');
    edOr3.Text:=IniFile.ReadString('ARTSKLON','EdOr3','-0.2');

IniFile.free
end;

procedure TFArt.FormDestroy(Sender: TObject);
begin
IniFile:=TIniFile.Create(make_ini('FrameNavy.ini'));


IniFile.WriteInteger('FRAME','CONUS_Height',Height);
IniFile.WriteInteger('FRAME','CONUS_Width',Width);

 IniFile.WriteString('ARTINTERV','MDM',meMDM.EditText);
 IniFile.WriteString('ARTINTERV','MDS',meMDS.EditText);
 IniFile.WriteString('ARTINTERV','SmInD',meSmInD.EditText);
 IniFile.WriteString('ARTINTERV','SmInM',meSmInM.EditText);
 IniFile.WriteString('ARTINTERV','SmInS',meSmInS.EditText);
 IniFile.WriteString('ARTINTERV','IntrD', meIntrD.EditText);
 IniFile.WriteString('ARTINTERV','IntrM', meIntrM.EditText);
 IniFile.WriteString('ARTINTERV','IntrDS',meIntrS.EditText);
 IniFile.WriteString('ARTINTERV','BigIntrD',meBigIntrD.EditText);
 IniFile.WriteString('ARTINTERV','BigIntrM',meBigIntrM.EditText);
 IniFile.WriteString('ARTINTERV','BigIntrS',meBigIntrS.EditText);
 IniFile.WriteString('ARTINTERV','TextIntrD',meTextIntrD.EditText);
 IniFile.WriteString('ARTINTERV','TextIntrM',meTextIntrM.EditText);
 IniFile.WriteString('ARTINTERV','TextIntrS', meTextIntrS.EditText);
 IniFile.WriteString('ARTINTERV','ShrafD',meShrafD.EditText);
 IniFile.WriteString('ARTINTERV','ShrafM', meShrafM.EditText);
 IniFile.WriteString('ARTINTERV','ShrafS',meShrafS.EditText);

 IniFile.WriteString('ARTINTERV','MDM_L',meMDM_L.EditText);
 IniFile.WriteString('ARTINTERV','MDS_L',meMDS_L.EditText);
 IniFile.WriteString('ARTINTERV','SmInD_L',meSmInD_L.EditText);
 IniFile.WriteString('ARTINTERV','SmInM_L',meSmInM_L.EditText);
 IniFile.WriteString('ARTINTERV','SmInS_L',meSmInS_L.EditText);
 IniFile.WriteString('ARTINTERV','IntrD_L', meIntrD_L.EditText);
 IniFile.WriteString('ARTINTERV','IntrM_L', meIntrM_L.EditText);
 IniFile.WriteString('ARTINTERV','IntrDS_L',meIntrS_L.EditText);
 IniFile.WriteString('ARTINTERV','BigIntrD_L',meBigIntrD_L.EditText);
 IniFile.WriteString('ARTINTERV','BigIntrM_L',meBigIntrM_L.EditText);
 IniFile.WriteString('ARTINTERV','BigIntrS_L',meBigIntrS_L.EditText);
 IniFile.WriteString('ARTINTERV','TextIntrD_L',meTextIntrD_L.EditText);
 IniFile.WriteString('ARTINTERV','TextIntrM_L',meTextIntrM_L.EditText);
 IniFile.WriteString('ARTINTERV','TextIntrS_L', meTextIntrS_L.EditText);
 IniFile.WriteString('ARTINTERV','ShrafD_L',meShrafD_L.EditText);
 IniFile.WriteString('ARTINTERV','ShrafM_L', meShrafM_L.EditText);
 IniFile.WriteString('ARTINTERV','ShrafS_L',meShrafS_L.EditText);
 IniFile.WriteBool('ARTFRAME','ChbAddtxt',ChbAddtxt.Checked);

    IniFile.WriteString('ARTSKLON','MeL0',MeL0.EditText);
    IniFile.WriteString('ARTSKLON','EdYear',EdYear.Text);
    IniFile.WriteString('ARTSKLON','MeL1D',MeL1D.EditText);
    IniFile.WriteString('ARTSKLON','MeL1M',MeL1M.EditText);
    IniFile.WriteString('ARTSKLON','MeL2D',MeL2D.EditText);
    IniFile.WriteString('ARTSKLON','MeL2M',MeL2M.EditText);
    IniFile.WriteString('ARTSKLON','MeL3D',MeL3D.EditText);
    IniFile.WriteString('ARTSKLON','MeL3M',MeL3M.EditText);
    IniFile.WriteString('ARTSKLON','EdD1',edD1.Text);
    IniFile.WriteString('ARTSKLON','EdD2',edD2.Text);
    IniFile.WriteString('ARTSKLON','EdD3',edD3.Text);
    IniFile.WriteString('ARTSKLON','EdG1',edG1.Text);
    IniFile.WriteString('ARTSKLON','EdG2',edG2.Text);
    IniFile.WriteString('ARTSKLON','EdG3',edG3.Text);
    IniFile.WriteString('ARTSKLON','EdOr1',edOr1.Text);
    IniFile.WriteString('ARTSKLON','EdOr2',edOr2.Text);
    IniFile.WriteString('ARTSKLON','EdOr3',edOr3.Text);
 IniFile.free
end;

procedure SET_ARTINTERVALS;
begin
 case nomenkl.scale of
     _sc1: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=600;

       end else if BMgr<70 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=600;
       end else
       if BMgr<75 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;
       Biginterval:=600;
       end else begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
        textinterv:=30;
       Biginterval:=300;
       end

       end;
     _sc1_5: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=600;
       end else if BMgr<70 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=600;
       end else
       if BMgr<75 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=600;
       end else begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
       textinterv:=30;

       Biginterval:=300;
       end

       end;
     _sc2,_sc2_5: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=600;
       end else if BMgr<70 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
        textinterv:=30;

       Biginterval:=300;
       end else
       if BMgr<75 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
        textinterv:=30;

       Biginterval:=300;
       end else begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=120;
       end

       end;
      _sc3: begin
       if BMgr<50 then begin
       tmindiv:=1; //0.1"
       minDiv:=Pi/6480000{180*36000 (0.1")};
       smInterv:=10;
       intermInterval:=60;
 textinterv:=60;

       Biginterval:=600;
       end else if BMgr<70 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
 textinterv:=30;

       Biginterval:=300;
       end else
       if BMgr<75 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
        textinterv:=60;

       Biginterval:=120;
       end else begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
 textinterv:=60;
       Biginterval:=120;
       end

       end;
      _sc4: begin
       if BMgr<50 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
 textinterv:=30;
       Biginterval:=300;
       end else if BMgr<70 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
        textinterv:=60;
Biginterval:=120;
       end else
       if BMgr<75 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
  textinterv:=60;
      intermInterval:=60;
       Biginterval:=120;
       end else begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=120;
       end

       end;

     _sc5, _sc6: begin
       if BMgr<50 then begin
       tmindiv:=2; //0.2"
       minDiv:=Pi/3240000{180*18000 (0.2")};
       smInterv:=5;
       intermInterval:=30;
 textinterv:=30;
       Biginterval:=300;
       end else if BMgr<70 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
       textinterv:=60;
 Biginterval:=120;
       end else
       if BMgr<75 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
 textinterv:=60;
       intermInterval:=60;
       Biginterval:=120;
       end else begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=30;
       intermInterval:=30;
       Biginterval:=60;
       end

       end;
     _sc7, _sc7_5: begin
       if BMgr<50 then begin
          tmindiv:=3; //0.5"
          minDiv:=Pi/1296000{180*3600*2 (0.5")};
          smInterv:=12;
           textinterv:=60;
intermInterval:=60;
          Biginterval:=120;
      end else if BMgr<70 then begin
       tmindiv:=3; //1"
       minDiv:=Pi/1296000{180*3600 (1")};
       smInterv:=12;
       textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
       intermInterval:=30;
 textinterv:=60;
       Biginterval:=60;
       end else begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end

       end;

    _sc10,_sc12_5:begin
       if BMgr<50 then begin
       tmindiv:=3; //0.5"
       minDiv:=Pi/1296000{180*3600*2 (0.5")};
       smInterv:=12;
       intermInterval:=60;
       textinterv:=60;
       Biginterval:=120;
       end else if BMgr<70 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
       intermInterval:=30;
       textinterv:=60;
 Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end

       end;
     _sc15,_sc17_5:begin
       if BMgr<50 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else if BMgr<70 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
      textinterv:=60;
  intermInterval:=30;
       Biginterval:=60;
       end else begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end;
       end;
       _sc20,_sc25:begin
       if BMgr<50 then begin
       tmindiv:=4; //1"
       minDiv:=Pi/648000{180*3600 (1")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else if BMgr<70 then begin
       tmindiv:=5; //2"
       minDiv:=Pi/324000{180*3600/2 (2")};
       smInterv:=6;
 textinterv:=60;
       intermInterval:=30;
       Biginterval:=60;
       end else
       if BMgr<75 then begin
       tmindiv:=6; //3"
       minDiv:=Pi/216000{180*3600/3 (3")};
       smInterv:=10;
 textinterv:=60;
       intermInterval:=20;
       Biginterval:=80;
       end else begin
       tmindiv:=6; //3"
       minDiv:=Pi/216000{180*3600/3 (3")};
       smInterv:=10;
 textinterv:=60;
       intermInterval:=20;
       Biginterval:=80;
       end

       end;
       // maps
        _scM30,_scM37_5,_scM40:begin
         tmindiv:=7; //6"
         minDiv:=Pi/108000{180*600 (6")};
         smInterv:=5;
         Shraf:=10;
         intermInterval:=20;
         textinterv:=20;
         Biginterval:=600;
       end;
        _scM50,_scM75:begin
         tmindiv:=7; //6"
         minDiv:=Pi/108000{180*600 (6")};
         smInterv:=5;
         Shraf:=10;
         textinterv:=50;
         intermInterval:=50;
         Biginterval:=600;
       end;
        _scM100,_scM150,_scM200:begin
         tmindiv:=8; //12"
         minDiv:=Pi/54000{180*300 (12")};
         smInterv:=5;
         Shraf:=25;
         textinterv:=50;

         intermInterval:=50;
         Biginterval:=50;
       end;
        _scM250,_scM300:begin
         tmindiv:=9; //30"
         minDiv:=Pi/21600{180*120 (30")};
         smInterv:=2;
         Shraf:=5;
         textinterv:=10;
 intermInterval:=10;
         Biginterval:=120;
       end;
       _scM500,_scM750,_scM1000:begin
         tmindiv:=10; //1'
         minDiv:=Pi/10800{180*60 (1')};
         smInterv:=5;
         Shraf:=5;
         textinterv:=30;

         intermInterval:=10;
         Biginterval:=60;
       end;
        _scM1500,_scM2000:begin
         tmindiv:=11; //2'
         minDiv:=Pi/5400{180*30 (2')};
         smInterv:=5;
         Shraf:=5;
         textinterv:=30;

         intermInterval:=15;
         Biginterval:=30;
       end;
       _scM2500:begin
         tmindiv:=12; //5'
         minDiv:=Pi/2160{180*12 (5')};
         smInterv:=6;
         Shraf:=6;
         textinterv:=24;

         intermInterval:=12;
         Biginterval:=24;
       end;
        _scM3000,_scM5000:begin
         tmindiv:=12; //5'
         minDiv:=Pi/2160{180*12 (5')};
         smInterv:=6;
         Shraf:=6;
         textinterv:=60;

         intermInterval:=12;
         Biginterval:=60;
       end;
       _scM10000:begin
         tmindiv:=13; //10'
         minDiv:=Pi/1080{180*6 (10')};
         smInterv:=6;
         Shraf:=6;
         textinterv:=30;

         intermInterval:=30;
         Biginterval:=30;
       end;
   end;
      minDivL:=minDiv;
      smIntervL:=smInterv;
      intermIntervalL:=intermInterval;
      textintervL:=textinterv;
      BigintervalL:= Biginterval;
      Shrafl:=Shraf
end;

procedure TFArt.Button1Click(Sender: TObject);
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
 {if fframe.ChBNetInterv.checked then begin
 if not dm_get_double(971,0,netintb) then netintb:=0;
 if not dm_get_double(972,0,netintl) then netintl:=0;
 end;
 if not Dm_GET_double(991,0,BM) then begin
   dmw_done;
   Showmessage('Нет опорной параллели');
   exit
 end;
 }
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
 //if dm_Get_String(901,255,ss) then begin    Номенклатура
   Shraf:=0;
   Set_ARTINTERVals;
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
function Fr_line_neib(x,y:double;PL1,PL:Plline;
                    var nn,nNext:integer):double;
var
  i:integer;
  RR,RDist,rd,t,tx,ty,x3,x4,det,xc,yc:double;
begin
 RR:=Rmax; nn:=-1;
     for i:=1 to PL^.n do with PL^ do begin
        { iF i<>0 then with PL^ do begin  }
             tx:=pol[i-1].x-pol[i].x;
             ty:=pol[i-1].y-pol[i].y;
       det:= ty*(PL1^.pol[0].x-PL1^.pol[1].x)+tx*(PL1^.pol[1].y-PL1^.pol[0].y);
       if det=0 then continue
       else begin
         x3:=PL1^.pol[0].x;
         x4:=PL1^.pol[1].x;
         xc:=((ty*pol[i].x-tx*pol[i].y)*(x3-x4)+
              tx*(x3*PL1^.pol[1].y-x4*PL1^.pol[0].y))/det;
         yc:=(ty*(x3*PL1^.pol[1].y-x4*PL1^.pol[0].y)+
              (ty*pol[i].x-tx*pol[i].y)*(PL1^.pol[0].y-PL1^.pol[1].y))/det;

               tx:=pol[i-1].x-pol[i].x;
                 ty:=pol[i-1].y-pol[i].y;
               Rd:=sqr(tx)+sqr(ty);
               if Rd<>0 then begin
                      tx:=pol[i].x;
                  ty:=pol[i].y;
                  t:=(pol[i-1].x-pol[i].x)*(xc-tx)+
                     (pol[i-1].y-pol[i].y)*(yc-ty);

                  if (t>=0) and (t<=Rd) then begin
                    Rdist:=sqr(xc-x)+sqr(yc-y)
                  end
                  else Rdist:=Rmax;
               end
               else  Rdist:=Rmax;
              if Rdist<RR then begin
               RR:=Rdist;
                  {if i<>PL^.n then begin
                  nn:=i; nNext:=i-1
                  end
                else }begin nn:=i-1; nNext:=i
                end
              end
              end
           { end {if i<>0}
     end;  {for i}
Fr_line_neib:=RR
end;

Procedure Fr_Set_Road_node(edge:Integer;pTl,pTLpr:plline;nCURR,Nnext:integer);
stdcall;
var
 lp1,lp2:lpoint;
 Rdist1,Rdist2,t,d1,d2,tx,ty,x3,x4,det:double;
 nn,i,nc1:integer;
 label
       Ag,lab2;
begin
  if ((nCurr=0) or (nCurr=pTlpr^.n)) and (nNext=-1) then begin
     if edge=1 then
                  pTl^.pol[pTL^.n]:=pTLpr^.pol[nCurr]
      else
           pTL^.pol[0]:=pTLpr^.pol[nCurr];
  end
  else begin
        if nNext=-1 then begin lp1:=ptlpr^.pol[nCurr]; goto lab2; end;
       if edge=1 then nn:=pTl^.n else nn:=0;
       nc1:=nNext;
        i:=0;
        with pTLpr^ do begin
       tx:=pol[nc1].x-pol[Ncurr].x;
       ty:=pol[nc1].y-pol[ncurr].y;
       det:= ty*(PtL^.pol[0].x-PtL^.pol[1].x)+tx*(PtL^.pol[1].y-PtL^.pol[0].y);
         x3:=PtL^.pol[0].x;
         x4:=PtL^.pol[1].x;
         lp1.x:=round(((ty*pol[Ncurr].x-tx*pol[Ncurr].y)*(x3-x4)+
              tx*(x3*PtL^.pol[1].y-x4*PtL^.pol[0].y))/det);
         lp1.y:=round((ty*(x3*PtL^.pol[1].y-x4*PtL^.pol[0].y)+
              (ty*pol[NCurr].x-tx*pol[nCurr].y)*(PtL^.pol[0].y-PtL^.pol[1].y))/det);
   end; {with}
   lab2:
      if edge=1 then begin
                  pTl^.pol[pTL^.n]:=lp1
    end
    else
           pTL^.pol[0]:= lp1
  end
end;

procedure Gauss_net_on_Art;
var
codeL,codes,codet,codeBig:integer;
  dtg,dtg2:tgauss;
  fl0,fl1:boolean;
  l_NUL_L,l_NUL_R,LDZ,dx,dy,dist,dl,L12:double;
  i,zoneL,zoneR:smallint;
  l_km:integer;
  point_gauss_L,gauss_point_L,point_gauss_R,gauss_point_R:koeff;
  Plleft,PlRight:PLLine;
  ii_L,ii_R:array[0..4] of integer;

  flDZ:boolean;
begin
 Getmem(Plleft,65528);
 Getmem(PlRight,65528);
 zoneL:=trunc(30*Rcorners[1].y/Pi)+1;
 zoneR:=trunc(30*Rcorners[2].y/Pi)+1;
 flDZ:=zoneL<>zoneR;
 with place do begin
 if flDZ then begin
   l_NUL_L:=zoneL*Pi/30-Pi/60;
   l_NUL_R:=zoneR*Pi/30-Pi/60;
   LDZ:=zoneL*Pi/30;
   L_NUL:=l_NUL_L;
   head.zone:=zoneL;
   geoid_[2].b:=Rcorners[1].x;
   geoid_[2].l:=LDZ;
   BL_XY_main (geoid_[2],gauss_[2]);
   dm_R_to_L(geoid_[2].b,geoid_[2].L,point_[2].x,point_[2].y);
   geoid_[3].b:=Rcorners[4].x;
   geoid_[3].l:=LDZ;
   BL_XY_main (geoid_[3],gauss_[3]);

   dm_R_to_L(geoid_[3].b,geoid_[3].L,point_[3].x,point_[3].y);
   Koeff_Main_int (gauss_[2],gauss_[3],point_[2],point_[3],gauss_point_L);
   Koeff_int_Main (point_[2],point_[3],gauss_[2],gauss_[3],point_gauss_L);
   point_gauss_L.MCy:=point_gauss_L.MC;
   point_gauss_L.MSy:=point_gauss_L.MS;
   gauss_point_L.MCy:=gauss_point_L.MC;
   gauss_point_L.MSy:=gauss_point_L.MS;

   Plleft.pol[0]:=pcorn[1];
   Plleft.n:=1;
   ii_L[0]:=0;
       dtg:=Rcorners[1];
       repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plleft.pol[Plleft.n].x, Plleft.pol[Plleft.n].y);
       inc(Plleft.n);
       until dtg.y>ldz-Mindivl*0.5;
      Plleft.pol[Plleft.n]:=point_[2];
      ii_L[1]:=Plleft.n;
       inc(Plleft.n);
      Plleft.pol[Plleft.n]:=point_[3];
      ii_L[2]:=Plleft.n;
       inc(Plleft.n);
       dtg.x:=Rcorners[3].x;
       dtg.y:=ldz;
       repeat
       dtg.y:=dtg.y-Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plleft.pol[Plleft.n].x, Plleft.pol[Plleft.n].y);
       inc(Plleft.n);
       until dtg.y<Rcorners[4].y+Mindivl*0.5;
       Plleft.pol[Plleft.n]:=pcorn[4];
        ii_L[3]:=Plleft.n;

       inc(Plleft.n);
       Plleft.pol[Plleft.n]:=pcorn[1];
        ii_L[4]:=Plleft.n;
{
   Plleft.Pol[0]:=pcorn[1];
   Plleft.Pol[1]:=point_[2];
   Plleft.Pol[2]:=point_[3];
   Plleft.Pol[3]:=pcorn[4];
   Plleft.Pol[4]:=pcorn[1];
   Plleft.N:=4;
 }
   L_NUL:=l_NUL_R;
   head.zone:=zoneR;
   geoid_[1].b:=Rcorners[1].x;
   geoid_[1].l:=LDZ;
   BL_XY_main (geoid_[1],gauss_[1]);
   dm_R_to_L(geoid_[1].b,geoid_[1].L,point_[1].x,point_[1].y);
   geoid_[4].b:=Rcorners[4].x;
   geoid_[4].l:=LDZ;
   BL_XY_main (geoid_[4],gauss_[4]);
   dm_R_to_L(geoid_[4].b,geoid_[4].L,point_[4].x,point_[4].y);
   Koeff_Main_int (gauss_[1],gauss_[4],point_[1],point_[4],gauss_point_R);
   Koeff_int_Main (point_[1],point_[4],gauss_[1],gauss_[4],point_gauss_R);
   point_gauss_R.MCy:=point_gauss_R.MC;
   point_gauss_R.MSy:=point_gauss_R.MS;
   gauss_point_R.MCy:=gauss_point_R.MC;
   gauss_point_R.MSy:=gauss_point_R.MS;
   {
     dist:=elm_distance2(gauss_[1],gauss_[4]);
   dm_BL_XY(geoid_[1].b,geoid_[1].L,dtg.x,dtg.y);
   dm_BL_XY(geoid_[4].b,geoid_[4].L,dtg2.x,dtg2.y);

   dl:=elm_distance2(dtg,dtg2);
   showmessage(floattostr(dist-dl));
   }
   Plright.pol[0]:=point_[1];
   Plright.n:=1;
   ii_R[0]:=0;
       dtg.x:=Rcorners[1].x;
       dtg.y:=ldz;

      repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plright.pol[plright.n].x, Plright.pol[plright.n].y);
       inc(Plright.n);
      until dtg.y>Rcorners[2].y-Mindivl*0.5;
      Plright.pol[Plright.n]:=pcorn[2];
      ii_R[1]:=Plright.n;
       inc(Plright.n);
      Plright.pol[Plright.n]:=pcorn[3];
      ii_R[2]:=Plright.n;
       inc(Plright.n);
       dtg:=Rcorners[3];
       repeat
       dtg.y:=dtg.y-Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plright.pol[Plright.n].x, Plright.pol[Plright.n].y);
       inc(Plright.n);
       until dtg.y<ldz+Mindivl*0.5;
       Plright.pol[Plright.n]:=point_[4];
        ii_R[3]:=Plright.n;

       inc(Plright.n);
       Plright.pol[Plright.n]:=point_[1];
        ii_R[4]:=Plright.n;
  {
   PlRight.Pol[0]:=point_[1];
   PlRight.Pol[1]:=pcorn[2];
   PlRight.Pol[2]:=pcorn[3];
   PlRight.Pol[3]:=point_[4];
   PlRight.Pol[4]:=point_[1];
   PlRight.N:=4;
  }


 end else begin
   l_NUL_L:=zoneL*Pi/30-Pi/60;
   L_NUL:=l_NUL_L;
   head.zone:=zoneL;
   geoid_[2].b:=Rcorners[1].x;
   geoid_[2].L:=Rcorners[1].Y;

   BL_XY_main (geoid_[2],gauss_[2]);
   dm_R_to_L(geoid_[2].b,geoid_[2].L,point_[2].x,point_[2].y);
   geoid_[3].b:=Rcorners[3].x;
   geoid_[3].l:=Rcorners[3].y;
   BL_XY_main (geoid_[3],gauss_[3]);
   dm_R_to_L(geoid_[3].b,geoid_[3].L,point_[3].x,point_[3].y);
   Koeff_Main_int (gauss_[2],gauss_[3],point_[2],point_[3],gauss_point_L);
   Koeff_int_Main (point_[2],point_[3],gauss_[2],gauss_[3],point_gauss_L);
   point_gauss_L.MCy:=point_gauss_L.MC;
   point_gauss_L.MSy:=point_gauss_L.MS;
   gauss_point_L.MCy:=gauss_point_L.MC;
   gauss_point_L.MSy:=gauss_point_L.MS;

  { dm_BL_XY(Rcorners[1].x,Rcorners[1].y,dtg.x,dtg.y);
   dm_BL_XY(Rcorners[2].x,Rcorners[2].y,dtg2.x,dtg2.y);

   dl:=elm_distance2(dtg,dtg2)/25000;
   }
   { dl:=elm_distance(pcorn[1],pcorn[2])/25000;

   showmessage(floattostr(dl));
   }
   {
   dm_BL_XY(Rcorners[4].x,Rcorners[4].y,dtg.x,dtg.y);
   dm_BL_XY(Rcorners[3].x,Rcorners[3].y,dtg2.x,dtg2.y);

   dl:=elm_distance2(dtg,dtg2)/25000;
   }
   {dl:=elm_distance(pcorn[3],pcorn[4])/25000;

   showmessage(floattostr(dl));
   }
{
    dm_BL_XY(Rcorners[1].x,Rcorners[1].y,dtg.x,dtg.y);
   dm_BL_XY(Rcorners[4].x,Rcorners[4].y,dtg2.x,dtg2.y);

   dl:=elm_distance2(dtg,dtg2)/25000;
 }  { dl:=elm_distance(pcorn[1],pcorn[4])/25000;
   showmessage(floattostr(dl));
   }
    Plleft.pol[0]:=pcorn[1];
     Plleft.n:=1;
   ii_L[0]:=0;
       dtg:=Rcorners[1];
       repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plleft.pol[plLeft.n].x, Plleft.pol[plleft.n].y);
       inc(Plleft.n);
       until dtg.y>Rcorners[2].y-Mindivl*0.5;
      Plleft.pol[Plleft.n]:=pcorn[2];
      ii_L[1]:=Plleft.n;

       inc(Plleft.n);
      Plleft.pol[Plleft.n]:=pcorn[3];
      ii_L[2]:=Plleft.n;

       inc(Plleft.n);
       dtg:=Rcorners[3];
       repeat
       dtg.y:=dtg.y-Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plleft.pol[Plleft.n].x, Plleft.pol[Plleft.n].y);
       inc(Plleft.n);
       until dtg.y<Rcorners[4].y+Mindivl*0.5;
       Plleft.pol[Plleft.n]:=pcorn[4];
       ii_L[3]:=Plleft.n;

       inc(Plleft.n);
       Plleft.pol[Plleft.n]:=pcorn[1];
       ii_L[4]:=Plleft.n;

{
   Plleft.Pol[0]:=pcorn[1];
   Plleft.Pol[1]:=pcorn[2];
   Plleft.Pol[2]:=pcorn[3];
   Plleft.Pol[3]:=pcorn[4];
   Plleft.Pol[4]:=pcorn[1];
   Plleft.N:=4;
}
 end;
 end;
  codeL:=99000010;
  codes:=99000020;
  codet:=99000030;
  codeBig:=99000030;

xxmin:=30000000;
  yymin:=30000000;
  xxmax:=0;
  yymax:=0;
  L_NUL:=l_NUL_L;
  head.zone:=zoneL;

  for i:=0 to Plleft.n-1 do begin
      Int_Main (Plleft.pol[i],point_gauss_L,dtg);
      if dtg.x>xxmax then xxmax:=dtg.x;
      if dtg.y>yymax then yymax:=dtg.y;
      if dtg.x<xxmin then xxmin:=dtg.x;
      if dtg.y<yymin then yymin:=dtg.y;
  end;
 L_km:=2000;
 yy:=(trunc(yymin/l_km)+1)*l_km;
 TL1.n:=1;
 flfirst0:=true;
 flfirst1:=true;
 repeat
   dtg.y:=yy;
   dtg.x:=xxmin;
    Main_int (dtg,gauss_point_L,TL1.pol[0]);
   dtg.x:=xxmax;
   Main_int (dtg,gauss_point_L,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
      fl0:=true;
   if
      (TL1.pol[0].x<Plleft.pol[ii_l[3]].x) or
      (TL1.pol[0].x>Plleft.pol[ii_l[2]].x) or
      (NCurr>ii_l[3]) or (NCurr<ii_l[2]) or
      (Nnext>ii_l[3]) or (Nnext<ii_l[2]) then begin
    fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
      fl1:=true;
   if  (NCurr>ii_l[1]) or (NCurr<ii_l[0]) or
      (Nnext>ii_l[1]) or (Nnext<ii_l[0]) or
   {(abs(TL1.pol[1].y-TLint.pol[0].y)>50) or}
      (TL1.pol[1].x<Plleft.pol[ii_l[0]].x) or
      (TL1.pol[1].x>Plleft.pol[ii_l[1]].x) then begin
      fl1:=false;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
   end;
       dm_Add_Poly(99000010,2,0,@TL1,false);
       if  round(yy/1000) mod 20 =0 then begin
          ncurr:=round(yy/1000) mod 10000;
          str(ncurr,ss);
       end else begin
         ncurr:=round(yy/1000) mod 100;
         str(ncurr,ss);
         if length(ss) = 1 then ss:='0'+ss;
       end;
       Text_Bound(99000030,a,a,R,ss);

   if fl0  then begin

     a.x:=TL1.pol[0].x-(R[2].x-R[1].x) div 2;
     a.y:=round(TL1.pol[0].y+5.8*kf);
     if (TL1.pol[0].x+10*kf<pcorn[3].x) and
        (TL1.pol[0].x-10*kf>pcorn[4].x) then
     Add_Text(99000030,a,a,0,ss,false);

   end;
   if fl1 then begin
     a.x:=TL1.pol[1].x-(R[2].x-R[1].x) div 2;
     a.y:=round(TL1.pol[1].y-3.6*kf);

     if (TL1.pol[1].x+10*kf<pcorn[2].x) and
        (TL1.pol[1].x-10*kf>pcorn[1].x) then
     Add_Text(99000030,a,a,0,ss,false);

   end;
   yy:=yy+l_km;
 until yy>yymax;

 xx:=(trunc(xxmin/l_km)+1)*l_km;
 flfirst0:=true;
 flfirst1:=true;
 repeat
   dtg.x:=xx;
   dtg.y:=yymin;
    Main_int (dtg,gauss_point_L,TL1.pol[0]);
   dtg.y:=yymax;
    Main_int (dtg,gauss_point_L,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
      fl0:=true;
  if  (NCurr>ii_l[4]) or (NCurr<ii_l[3]) or
      (Nnext>ii_l[4]) or (Nnext<ii_l[3]) or
  {(abs(TL1.pol[0].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[0].y-TLint.pol[2].y)<5) or}
      (TL1.pol[0].y<Plleft.pol[ii_l[0]].y) or
      (TL1.pol[0].y>Plleft.pol[ii_l[3]].y) then begin
      fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
      fl1:=true;
 if    (NCurr>ii_l[2]) or (NCurr<ii_l[1]) or
      (Nnext>ii_l[2]) or (Nnext<ii_l[1]) or
      {(abs(TL1.pol[1].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[1].y-TLint.pol[2].y)<5) or }
      (TL1.pol[1].y<Plleft.pol[ii_l[1]].y) or
      (TL1.pol[1].y>Plleft.pol[ii_l[2]].y) then begin
     fl1:=false;
    Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
   end;
    dm_Add_Poly(99000010,2,0,@TL1,false);
    if round(XX/1000) mod 20 =0 then begin
        ncurr:=round(XX/1000) mod 10000;
        str(ncurr,ss);
    end else begin
      ncurr:=round(XX/1000) mod 100;
       str(ncurr,ss);
       if length(ss)=1 then ss:='0'+ss;
    end;
   if fl0{TL1.pol[0].x<pcorn[1].x}and ((TL1.pol[0].y>pcorn[1].y+4*kf) and
      (TL1.pol[0].y+3*kf<pcorn[4].y)) then begin
     Text_Bound(99000030,a,a,R,ss);
     if length(ss)=4 then
       a.x:=round(TL1.pol[0].x-6.75*kf-(R[2].x-R[1].x) div 2)
     else
       a.x:=round(TL1.pol[0].x-3.6*kf-(R[2].x-R[1].x));
     a.y:=TL1.pol[0].y;
     Add_Text(99000030,a,a,0,ss,false);
     dm_set_tag(1);
   end;
   if not flDZ and fl1{TL1.pol[1].x>pcorn[2].x}and ((TL1.pol[1].y>pcorn[2].y+4*kf) and
      (TL1.pol[1].y+3*kf<pcorn[3].y)) then begin
     Text_Bound(99000030,a,a,R,ss);

     if length(ss)=4 then
       a.x:=round(TL1.pol[1].x+6.75*kf-(R[2].x-R[1].x) div 2)
     else
       a.x:=round(TL1.pol[1].x+3.6*kf);
     a.y:=round(TL1.pol[1].y);
     Text_Bound(99000030,a,a,R,ss);
     a.x:=round(TL1.pol[1].x-R[2].x+R[1].x-0.4*kf);
     Add_Text(99000030,a,a,0,ss,false);
        dm_set_tag(1);
   end;
   xx:=xx+l_km;
 until xx>xxmax;

 if flDZ then begin  //Когда 2 зоны
   xxmin:=30000000;
  yymin:=30000000;
  xxmax:=0;
  yymax:=0;
  L_NUL:=l_NUL_R;
  head.zone:=zoneR;

  for i:=0 to PlRight.n-1 do begin
      Int_Main (PlRight.pol[i],point_gauss_R,dtg);
      if dtg.x>xxmax then xxmax:=dtg.x;
      if dtg.y>yymax then yymax:=dtg.y;
      if dtg.x<xxmin then xxmin:=dtg.x;
      if dtg.y<yymin then yymin:=dtg.y;
  end;
 yy:=(trunc(yymin/l_km)+1)*l_km;
 TL1.n:=1;
 repeat
   dtg.y:=yy;
   dtg.x:=xxmin;
    Main_int (dtg,gauss_point_R,TL1.pol[0]);
   dtg.x:=xxmax;
   Main_int (dtg,gauss_point_R,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
      fl0:=true;
   if {(abs(TL1.pol[0].y-TLint.pol[ii_l[2]].y)>50) or}
      (TL1.pol[0].x<PlRight.pol[ii_r[3]].x) or
      (TL1.pol[0].x>PlRight.pol[ii_r[2]].x) or
      (NCurr>ii_r[3]) or (NCurr<ii_r[2]) or
      (Nnext>ii_r[3]) or (Nnext<ii_r[2]) then begin
    fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
      fl1:=true;
   if  (NCurr>ii_r[1]) or (NCurr<ii_r[0]) or
      (Nnext>ii_r[1]) or (Nnext<ii_r[0]) or
   {(abs(TL1.pol[1].y-TLint.pol[0].y)>50) or}
      (TL1.pol[1].x<PlRight.pol[ii_r[0]].x) or
      (TL1.pol[1].x>PlRight.pol[ii_r[1]].x) then begin
      fl1:=false;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
   end;
       dm_Add_Poly(99000010,2,0,@TL1,false);
       if  round(yy/1000) mod 20 =0 then begin
          ncurr:=round(yy/1000) mod 10000;
          str(ncurr,ss);
       end else begin
         ncurr:=round(yy/1000) mod 100;
         str(ncurr,ss);
         if length(ss)=1 then ss:='0'+ss;
       end;
       Text_Bound(99000030,a,a,R,ss);

   if fl0 then begin

     a.x:=TL1.pol[0].x-(R[2].x-R[1].x) div 2;
     a.y:=round(TL1.pol[0].y+5.8*kf);
     if (TL1.pol[0].x+10*kf<pcorn[3].x) and
        (TL1.pol[0].x-10*kf>pcorn[4].x) then
     Add_Text(99000030,a,a,0,ss,false);

   end;
   if fl1 then begin
     a.x:=TL1.pol[1].x-(R[2].x-R[1].x) div 2;
     a.y:=round(TL1.pol[1].y-3.6*kf);

     if (TL1.pol[1].x+10*kf<pcorn[2].x) and
        (TL1.pol[1].x-10*kf>pcorn[1].x) then
     Add_Text(99000030,a,a,0,ss,false);

   end;
   yy:=yy+l_km;
 until yy>yymax;

 xx:=(trunc(xxmin/l_km)+1)*l_km;
 flfirst0:=true;
 flfirst1:=true;
 repeat
   dtg.x:=xx;
   dtg.y:=yymin;
    Main_int (dtg,gauss_point_R,TL1.pol[0]);
   dtg.y:=yymax;
    Main_int (dtg,gauss_point_R,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
      fl0:=true;
  if  (NCurr>ii_r[4]) or (NCurr<ii_r[3]) or
      (Nnext>ii_r[4]) or (Nnext<ii_r[3]) or
  {(abs(TL1.pol[0].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[0].y-TLint.pol[2].y)<5) or}
      (TL1.pol[0].y<PlRight.pol[ii_r[0]].y) or
      (TL1.pol[0].y>PlRight.pol[ii_r[3]].y) then begin
      fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
      fl1:=true;
 if    (NCurr>ii_r[2]) or (NCurr<ii_r[1]) or
      (Nnext>ii_r[2]) or (Nnext<ii_r[1]) or
      {(abs(TL1.pol[1].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[1].y-TLint.pol[2].y)<5) or }
      (TL1.pol[1].y<PlRight.pol[ii_r[1]].y) or
      (TL1.pol[1].y>PlRight.pol[ii_r[2]].y) then begin
     fl1:=false;
    Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
   end;
    dm_Add_Poly(99000010,2,0,@TL1,false);
    if round(XX/1000) mod 20 =0 then begin
        ncurr:=round(XX/1000) mod 10000;
        str(ncurr,ss);
    end else begin
      ncurr:=round(XX/1000) mod 100;
       str(ncurr,ss);
       if length(ss)=1 then ss:='0'+ss;
    end;
  (*
   if fl0{TL1.pol[0].x<pcorn[1].x}and ((TL1.pol[0].y>pcorn[1].y+4*kf) and
      (TL1.pol[0].y+3*kf<pcorn[4].y)) then begin
     Text_Bound(99000030,a,a,R,ss);
     if byte(ss[0])=4 then
     a.x:=round(TL1.pol[0].x-6.75*kf-(R[2].x-R[1].x) div 2)
     else
     a.x:=round(TL1.pol[0].x-3.6*kf-(R[2].x-R[1].x));
     a.y:=TL1.pol[0].y;
     Add_Text(99000030,a,a,0,ss,false);
     dm_set_tag(1);
   end;
   *)
   if fl1{TL1.pol[1].x>pcorn[2].x}and ((TL1.pol[1].y>pcorn[2].y+4*kf) and
      (TL1.pol[1].y+3*kf<pcorn[3].y)) then begin
     Text_Bound(99000030,a,a,R,ss);

     if length(ss)=4 then
       a.x:=round(TL1.pol[1].x+6.75*kf-(R[2].x-R[1].x) div 2)
     else
       a.x:=round(TL1.pol[1].x+3.6*kf);
     a.y:=round(TL1.pol[1].y);
     Add_Text(99000030,a,a,0,ss,false);
     dm_set_tag(1);
   end;
   xx:=xx+l_km;
 until xx>xxmax;


  //Построение координат соседней Зоны слева
  xxmin:=30000000;
  yymin:=30000000;
  xxmax:=0;
  yymax:=0;
  L_NUL:=l_NUL_R;
  head.zone:=zoneR;
  with place do begin
  Plleft.pol[0].X:= pcorn[1].X-round(11.5*kf);
  Plleft.pol[0].y:= pcorn[1].Y-round(11.5*kf);
  Plleft.pol[1].x:=point_[2].x;
  Plleft.pol[1].y:= point_[2].Y-round(11.5*kf);
  Plleft.pol[2].x:= point_[3].x;
  Plleft.pol[2].y:= point_[3].Y+round(11.5*kf);
  Plleft.pol[3].X:= pcorn[4].X-round(11.5*kf);
  Plleft.pol[3].y:= pcorn[4].Y+round(11.5*kf);
  Plleft.pol[4]:=Plleft.pol[0];
  Plleft.n:=4;
  end;
  for i:=0 to Plleft.n-1 do begin
      Int_Main (Plleft.pol[i],point_gauss_R,dtg);
      if dtg.x>xxmax then xxmax:=dtg.x;
      if dtg.y>yymax then yymax:=dtg.y;
      if dtg.x<xxmin then xxmin:=dtg.x;
      if dtg.y<yymin then yymin:=dtg.y;
  end;
 yy:=(trunc(yymin/l_km)+1)*l_km;
 TL1.n:=1;
 repeat
   dtg.y:=yy;
   dtg.x:=xxmin;
    Main_int (dtg,gauss_point_R,TL1.pol[0]);
   dtg.x:=xxmax;
   Main_int (dtg,gauss_point_R,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
      fl0:=true;
   if {(abs(TL1.pol[0].y-TLint.pol[ii[2]].y)>50) or}
      (TL1.pol[0].x<Plleft.pol[3].x) or
      (TL1.pol[0].x>Plleft.pol[2].x) or
      (NCurr>ii[3]) or (NCurr<ii[2]) or
      (Nnext>ii[3]) or (Nnext<ii[2]) then begin
    fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
      fl1:=true;
   if  (NCurr>ii[1]) or (NCurr<ii[0]) or
      (Nnext>ii[1]) or (Nnext<ii[0]) or
   {(abs(TL1.pol[1].y-TLint.pol[0].y)>50) or}
      (TL1.pol[1].x<Plleft.pol[0].x) or
      (TL1.pol[1].x>Plleft.pol[1].x) then begin
      fl1:=false;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
   end;
       if  round(yy/1000) mod 20 =0 then begin
          ncurr:=round(yy/1000) mod 10000;
          str(ncurr,ss);
       end else begin
         ncurr:=round(yy/1000) mod 100;
         str(ncurr,ss);
         if length(ss)=1 then ss:='0'+ss;
       end;
       L12:=elm_distance(Tl1.pol[0],Tl1.pol[1]);

   if fl0 and (TL1.pol[0].x>pcorn[4].x+round(5*kf)) then begin
      a:=TL1.pol[0];
      b.x:=round(a.x+4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y+4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);

     a.x:=TL1.pol[0].x+round(kf);
     a.y:=round(TL1.pol[0].y-kf);
     Add_Text(99000030,a,a,0,ss,false);

   end;
   if fl1 and (TL1.pol[0].x>pcorn[1].x+round(5*kf)) then begin
      a:=TL1.pol[1];
      b.x:=round(a.x-4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y-4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);
      a.x:=TL1.pol[1].x+round(kf);
      a.y:=round(TL1.pol[1].y+3.2*kf);

     Add_Text(99000030,a,a,0,ss,false);

   end;
   yy:=yy+l_km;
 until yy>yymax;

 xx:=(trunc(xxmin/l_km)+1)*l_km;
 repeat
   dtg.x:=xx;
   dtg.y:=yymin;
    Main_int (dtg,gauss_point_R,TL1.pol[0]);
   dtg.y:=yymax;
    Main_int (dtg,gauss_point_R,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
      fl0:=true;
  if  (NCurr>ii[4]) or (NCurr<ii[3]) or
      (Nnext>ii[4]) or (Nnext<ii[3]) or
  {(abs(TL1.pol[0].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[0].y-TLint.pol[2].y)<5) or}
      (TL1.pol[0].y<Plleft.pol[0].y) or
      (TL1.pol[0].y>Plleft.pol[3].y) then begin
      fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
      fl1:=true;
 if    (NCurr>ii[2]) or (NCurr<ii[1]) or
      (Nnext>ii[2]) or (Nnext<ii[1]) or
      {(abs(TL1.pol[1].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[1].y-TLint.pol[2].y)<5) or }
      (TL1.pol[1].y<Plleft.pol[1].y) or
      (TL1.pol[1].y>Plleft.pol[2].y) then begin
     fl1:=false;
    Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
   end;
    if round(XX/1000) mod 20 =0  then begin
        ncurr:=round(XX/1000) mod 10000;
        str(ncurr,ss);
    end else begin
      ncurr:=round(XX/1000) mod 100;
      str(ncurr,ss);
      if length(ss)=1 then ss:='0'+ss;
    end;
       L12:=elm_distance(Tl1.pol[0],Tl1.pol[1]);

   if fl0{TL1.pol[0].x<pcorn[1].x}and ((TL1.pol[0].y>pcorn[1].y+4*kf) and
      (TL1.pol[0].y+3*kf<pcorn[4].y)) then begin
      a:=TL1.pol[0];
      b.x:=round(a.x+4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y+4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);

     a.x:=round(TL1.pol[0].x+3.2*kf);
     a.y:=round(TL1.pol[0].y-kf);
     b.x:=a.X;
     b.y:=round(TL1.pol[0].y-3*kf);
     Add_Text(99000030,a,b,0,ss,false);
   end;

   xx:=xx+l_km;
 until xx>xxmax;

  //Построение координат соседней Зоны справа
   xxmin:=30000000;
  yymin:=30000000;
  xxmax:=0;
  yymax:=0;
  L_NUL:=l_NUL_L;
  head.zone:=zoneL;
  with place do begin
  PlRight.pol[0].y:= point_[1].Y-round(11.5*kf);
  PlRight.pol[0].x:= point_[1].x;
  PlRight.pol[1].x:= pcorn[2].x+round(11.5*kf);
  PlRight.pol[1].y:= pcorn[2].Y-round(11.5*kf);
  PlRight.pol[2].x:= pcorn[3].X+round(11.5*kf);
  PlRight.pol[2].y:= pcorn[3].Y+round(11.5*kf);
  PlRight.pol[3].x:= point_[4].x;
  PlRight.pol[3].y:= point_[4].Y+round(11.5*kf);
  PlRight.pol[4]:=PlRight.pol[0];
   PlRight.N:=4;
 end;

  for i:=0 to PlRight.n-1 do begin
      Int_Main (PlRight.pol[i],point_gauss_L,dtg);
      if dtg.x>xxmax then xxmax:=dtg.x;
      if dtg.y>yymax then yymax:=dtg.y;
      if dtg.x<xxmin then xxmin:=dtg.x;
      if dtg.y<yymin then yymin:=dtg.y;
  end;
 yy:=(trunc(yymin/l_km)+1)*l_km;
 TL1.n:=1;
 repeat
   dtg.y:=yy;
   dtg.x:=xxmin;
   Main_int (dtg,gauss_point_L,TL1.pol[0]);
   dtg.x:=xxmax;
   Main_int (dtg,gauss_point_L,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
      fl0:=true;
   if (TL1.pol[0].x<PlRight.pol[3].x) or
      (TL1.pol[0].x>PlRight.pol[2].x) or
      (NCurr>ii[3]) or (NCurr<ii[2]) or
      (Nnext>ii[3]) or (Nnext<ii[2]) then begin
    fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
      fl1:=true;
   if  (NCurr>ii[1]) or (NCurr<ii[0]) or
      (Nnext>ii[1]) or (Nnext<ii[0]) or
   {(abs(TL1.pol[1].y-TLint.pol[0].y)>50) or}
      (TL1.pol[1].x<PlRight.pol[0].x) or
      (TL1.pol[1].x>PlRight.pol[1].x) then begin
      fl1:=false;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
   end;
       if  round(yy/1000) mod 20 =0 then begin
          ncurr:=round(yy/1000) mod 10000;
          str(ncurr,ss);
       end else begin
         ncurr:=round(yy/1000) mod 100;
         str(ncurr,ss);
         if length(ss)=1 then ss:='0'+ss;
       end;

      L12:=elm_distance(Tl1.pol[0],Tl1.pol[1]);


   if fl0 and (TL1.pol[0].x<pcorn[3].x-round(5*kf)) then begin
          a:=TL1.pol[0];
      b.x:=round(a.x+4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y+4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);
   if TL1.pol[0].x<pcorn[3].x-round(10*kf) then begin
     a.x:=TL1.pol[0].x+round(kf);
     a.y:=round(TL1.pol[0].y-kf);
     if (TL1.pol[0].x+10*kf<pcorn[3].x) and
        (TL1.pol[0].x-10*kf>pcorn[4].x) then
     Add_Text(99000030,a,a,0,ss,false);
   end;

   end;
   if fl1 and (TL1.pol[1].x<pcorn[2].x-round(5*kf)) then begin
        a:=TL1.pol[1];
      b.x:=round(a.x-4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y-4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);
     if (TL1.pol[1].x<pcorn[2].x-round(10*kf)) then begin
     a.x:=TL1.pol[1].x+round(kf);
     a.y:=round(TL1.pol[1].y+3.2*kf);
     Add_Text(99000030,a,a,0,ss,false);
    end;
   end;
   yy:=yy+l_km;
 until yy>yymax;

 xx:=(trunc(xxmin/l_km)+1)*l_km;
 repeat
   dtg.x:=xx;
   dtg.y:=yymin;
    Main_int (dtg,gauss_point_L,TL1.pol[0]);
   dtg.y:=yymax;
    Main_int (dtg,gauss_point_L,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
      fl0:=true;
  if  (NCurr>ii[4]) or (NCurr<ii[3]) or
      (Nnext>ii[4]) or (Nnext<ii[3]) or
  {(abs(TL1.pol[0].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[0].y-TLint.pol[2].y)<5) or}
      (TL1.pol[0].y<PlRight.pol[0].y) or
      (TL1.pol[0].y>PlRight.pol[3].y) then begin
      fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,PlRight,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
      fl1:=true;
 if    (NCurr>ii[2]) or (NCurr<ii[1]) or
      (Nnext>ii[2]) or (Nnext<ii[1]) or
      {(abs(TL1.pol[1].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[1].y-TLint.pol[2].y)<5) or }
      (TL1.pol[1].y<PlRight.pol[1].y) or
      (TL1.pol[1].y>PlRight.pol[2].y) then begin
     fl1:=false;
    Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,PlRight,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,PlRight,nCURR,Nnext);
   end;
    if round(XX/1000) mod 10 = 0 then begin
        ncurr:=round(XX/1000) mod 10000;
        str(ncurr,ss);
    end else begin
      ncurr:=round(XX/1000) mod 100;
       str(ncurr,ss);
       if length(ss)=1 then ss:='0'+ss;
    end;
     L12:=elm_distance(Tl1.pol[0],Tl1.pol[1]);



   if fl1 and ((TL1.pol[1].y>pcorn[1].y+4*kf) and
      (TL1.pol[1].y+3*kf<pcorn[4].y)) then begin
              a:=TL1.pol[1];
      b.x:=round(a.x-4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y-4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);

     a.x:=round(TL1.pol[1].x-3.2*kf);
     a.y:=round(TL1.pol[1].y+kf);
     b.x:=a.X;
     b.y:=round(TL1.pol[1].y+3*kf);
     Add_Text(99000030,a,b,0,ss,false);
   end;
   xx:=xx+l_km;
 until xx>xxmax;

 end else begin
  //Координаты соседней зоны. Зона одна
   if (L_NUL_L< Rcorners[1].x) or (L_NUL_L< Rcorners[2].x) then begin
   l_NUL_R:=l_NUL_L+Pi/30;
   zoneR:=zoneL+1;
   end else begin
   l_NUL_R:=l_NUL_L-Pi/30;
   zoneR:=zoneL+1;

   end;

   L_NUL:=l_NUL_R;
   head.zone:=zoneR;
   with place do begin
   geoid_[1].b:=Rcorners[1].x;
   geoid_[1].L:=Rcorners[1].y;

   BL_XY_main (geoid_[1],gauss_[1]);
   dm_R_to_L(geoid_[1].b,geoid_[1].L,point_[1].x,point_[1].y);
   geoid_[3].b:=Rcorners[3].x;
   geoid_[3].L:=Rcorners[3].y;
   BL_XY_main (geoid_[3],gauss_[3]);
   dm_R_to_L(geoid_[3].b,geoid_[3].L,point_[3].x,point_[3].y);
   Koeff_Main_int (gauss_[1],gauss_[3],point_[1],point_[3],gauss_point_R);
   Koeff_int_Main (point_[1],point_[3],gauss_[1],gauss_[3],point_gauss_R);
   point_gauss_R.MCy:=point_gauss_R.MC;
   point_gauss_R.MSy:=point_gauss_R.MS;
   gauss_point_R.MCy:=gauss_point_R.MC;
   gauss_point_R.MSy:=gauss_point_R.MS;
   end;


  xxmin:=30000000;
  yymin:=30000000;
  xxmax:=0;
  yymax:=0;

  L_NUL:=l_NUL_R;
  head.zone:=zoneR;
   Plleft.pol[0].X:= pcorn[1].X-round(11.5*kf);
  Plleft.pol[0].y:= pcorn[1].Y-round(11.5*kf);
  Plleft.pol[1].x:=pcorn[2].x;
  Plleft.pol[1].y:= pcorn[2].Y-round(11.5*kf);
  Plleft.pol[2].x:= pcorn[3].x;
  Plleft.pol[2].y:= pcorn[3].Y+round(11.5*kf);
  Plleft.pol[3].X:= pcorn[4].X-round(11.5*kf);
  Plleft.pol[3].y:= pcorn[4].Y+round(11.5*kf);
  Plleft.pol[4]:=Plleft.pol[0];
  Plleft.n:=4;

  for i:=0 to Plleft.n-1 do begin
      Int_Main (Plleft.pol[i],point_gauss_R,dtg);
      if dtg.x>xxmax then xxmax:=dtg.x;
      if dtg.y>yymax then yymax:=dtg.y;
      if dtg.x<xxmin then xxmin:=dtg.x;
      if dtg.y<yymin then yymin:=dtg.y;
  end;
 yy:=(trunc(yymin/l_km)+1)*l_km;
 TL1.n:=1;
 repeat
   dtg.y:=yy;
   dtg.x:=xxmin;
    Main_int (dtg,gauss_point_R,TL1.pol[0]);
   dtg.x:=xxmax;
   Main_int (dtg,gauss_point_R,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
      fl0:=true;
   if (TL1.pol[0].x<Plleft.pol[3].x) or
      (TL1.pol[0].x>Plleft.pol[2].x) or
      (NCurr>ii[3]) or (NCurr<ii[2]) or
      (Nnext>ii[3]) or (Nnext<ii[2]) then begin
    fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
      fl1:=true;
   if  (NCurr>ii[1]) or (NCurr<ii[0]) or
      (Nnext>ii[1]) or (Nnext<ii[0]) or
   {(abs(TL1.pol[1].y-TLint.pol[0].y)>50) or}
      (TL1.pol[1].x<Plleft.pol[0].x) or
      (TL1.pol[1].x>Plleft.pol[1].x) then begin
      fl1:=false;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
   end;
       if  round(yy/1000) mod 10 =0 then begin
          ncurr:=round(yy/1000) mod 10000;
          str(ncurr,ss);
       end else begin
         ncurr:=round(yy/1000) mod 100;
         str(ncurr,ss);
         if length(ss)=1 then ss:='0'+ss;
       end;
       Text_Bound(99000030,a,a,R,ss);
      L12:=elm_distance(Tl1.pol[0],Tl1.pol[1]);
   if fl0 and (TL1.pol[0].x>pcorn[4].x+round(5*kf)) and (TL1.pol[0].x<pcorn[3].x-round(5*kf)) then begin
      a:=TL1.pol[0];
      b.x:=round(a.x+4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y+4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);
      if (TL1.pol[0].x+10*kf<pcorn[3].x) then begin
        a.x:=TL1.pol[0].x-(R[2].x-R[1].x) div 2;
        a.y:=round(TL1.pol[0].y-kf);
        Add_Text(99000030,a,a,0,ss,false);
      end;
   end;
   if fl1 and (TL1.pol[0].x>pcorn[1].x+round(5*kf)) and (TL1.pol[0].x<pcorn[2].x-round(5*kf)) then begin
      a:=TL1.pol[1];
      b.x:=round(a.x-4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y-4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);
      if (TL1.pol[1].x+10*kf<pcorn[2].x) then  begin
        a.x:=TL1.pol[1].x-(R[2].x-R[1].x) div 2;
        a.y:=round(TL1.pol[1].y+3.2*kf);
        Add_Text(99000030,a,a,0,ss,false);
      end;
   end;
   yy:=yy+l_km;
 until yy>yymax;

 xx:=(trunc(xxmin/l_km)+1)*l_km;
 repeat
   dtg.x:=xx;
   dtg.y:=yymin;
    Main_int (dtg,gauss_point_R,TL1.pol[0]);
   dtg.y:=yymax;
    Main_int (dtg,gauss_point_R,TL1.pol[1]);
      Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
      fl0:=true;
  if  (NCurr>ii[4]) or (NCurr<ii[3]) or
      (Nnext>ii[4]) or (Nnext<ii[3]) or
  {(abs(TL1.pol[0].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[0].y-TLint.pol[2].y)<5) or}
      (TL1.pol[0].y<Plleft.pol[0].y) or
      (TL1.pol[0].y>Plleft.pol[3].y) then begin
      fl0:=false;
    Fr_line_neib(TL1.pol[0].x,TL1.pol[0].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(0,@TL1,Plleft,nCURR,Nnext);
   end;
      Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
      fl1:=true;
 if    (NCurr>ii[2]) or (NCurr<ii[1]) or
      (Nnext>ii[2]) or (Nnext<ii[1]) or
      {(abs(TL1.pol[1].y-TLint.pol[0].y)<5) or
     (abs(TL1.pol[1].y-TLint.pol[2].y)<5) or }
      (TL1.pol[1].y<Plleft.pol[1].y) or
      (TL1.pol[1].y>Plleft.pol[2].y) then begin
     fl1:=false;
    Fr_line_neib(TL1.pol[1].x,TL1.pol[1].y,@TL1,Plleft,Ncurr,nnext);
      Fr_Set_Road_node(1,@TL1,Plleft,nCURR,Nnext);
   end;
    if round(XX/1000) mod 10 =0  then begin
        ncurr:=round(XX/1000) mod 10000;
        str(ncurr,ss);
    end else begin
      ncurr:=round(XX/1000) mod 100;
       str(ncurr,ss);
       if length(ss)=1 then ss:='0'+ss;
    end;
      L12:=elm_distance(Tl1.pol[0],Tl1.pol[1]);

   if fl0{TL1.pol[0].x<pcorn[1].x}and ((TL1.pol[0].y>pcorn[1].y+4*kf) and
      (TL1.pol[0].y+3*kf<pcorn[4].y)) then begin
      a:=TL1.pol[0];
      b.x:=round(a.x+4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y+4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);

     a.x:=round(TL1.pol[0].x+3.2*kf);
     a.y:=round(TL1.pol[0].y-kf);
     b.x:=a.X;
     b.y:=round(TL1.pol[0].y-3*kf);
     Add_Text(99000030,a,b,0,ss,false);
   end;
    if fl1{TL1.pol[0].x<pcorn[1].x}and ((TL1.pol[1].y>pcorn[1].y+4*kf) and
      (TL1.pol[1].y+3*kf<pcorn[4].y)) then begin
          a:=TL1.pol[1];
      b.x:=round(a.x-4*kf*(Tl1.pol[1].x-Tl1.pol[0].x)/L12);
      b.y:=round(a.y-4*kf*(Tl1.pol[1].y-Tl1.pol[0].y)/L12);
      dm_Add_sign(99000020, a,b,0,false);

     a.x:=round(TL1.pol[1].x-3.2*kf);
     a.y:=round(TL1.pol[1].y+kf);
     b.x:=a.X;
     b.y:=round(TL1.pol[1].y+3*kf);
     Add_Text(99000030,a,b,0,ss,false);
   end;

   xx:=xx+l_km;
 until xx>xxmax;
 end;
 Freemem(Plleft,65528);
 freemem(PlRight,65528);
end;


procedure Mk_grad_net_on_ART;
var
  pch,pn:pchar;
  node1,node,i,j,nmk,l100k,l50k,modI,codes,codet,codeBig, codel,nn,nNext,codemindiv,codemindiv_blue,
  nlbdiv,grad2,Textgrad,TextgradL,sign,{smInterv,intermInterval,smIntervl,intermIntervall,} offs,minlX,MaxlX,minlY,MaxlY:longint;
  ss,s:shortstring;
  sgrad,smin,ssec:s4;
  dtg2,dtg,tg:tgauss;
  yl,kk,kk2,yy,hh,dh,dhL,{Biginterval,Bigintervall,mindiv, }
  rr, rx,ry,{nlbnetorig_L,mindivl,}minX,MaxX,minY,MaxY:double;
  nlb,lx,ly,lx1,lx2,l0,lxsm,signrx:longint;
  p,a,b,lp,lshraf1,lshraf2,lpc:lpoint;
  grad,min:integer;
  sec:extended;
  flend,flfirst,flGradNonEXist,res,flhalf, flten,flgrad,flGradinterv,fldown,flstrL:boolean;
  bmindiv,bf:byte;
  litera:char;
begin
  codel:=String2code('A0100002');
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
  codemindiv:=String2Code('A0400420');
  codemindiv_blue:=String2Code('A0400421');
with FArt do begin
  Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext)/3600);
  TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext)/3600);
end;
flGradinterv:=true;
if (Biginterval=0) or (BigintervalL=0) then begin
 flGradinterv:=false;

end;
if not  flGradinterv then
    ShowMessage('Введены некорректные данные в градусную сетку. Будут использованы значения по умолчания');
      //Начало создания сетки WGS 84
    if flGradinterv then begin
      kk:=Bigintervall*mindivl;
      yy:=mindiv;
    end else begin
    case nomenkl.scale of
  _sc2,_sc5,_sc10:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _sc25:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _scm50:begin kk:=Pi/5400;
           yy:=Pi/54000;
        end;
  _scm100:begin kk:=Pi/2700;
         yy:=Pi/27000;
         end;
  _scm200:begin kk:=Pi/1800;
         yy:=Pi/18000;
         end;
  _scm500:begin kk:=Pi/360;
         yy:=Pi/360;
         end;
   else begin kk:=Pi/180;
         yy:=Pi/180;
         end;

  end;
  smInterv:=1;
  interminterval:=5;
  end;
    minlX:=1000000000;
  MaxlX:=-1000000000;
  minlY:=1000000000;
  MaxlY:=-1000000000;

    for i:=1 to 4 do begin
     if pcorn[i].x>MaxlX then MaxlX:=pcorn[i].x;
     if pcorn[i].y>Maxly then Maxly:=pcorn[i].y;
     if pcorn[i].x<MinlX then MinlX:=pcorn[i].x;
     if pcorn[i].y<MinlY then MinlY:=pcorn[i].y;
   end;
   Maxx:=-100;
    MinX:=100;
    Maxy:=-100;
    Miny:=100;

  for i:=1 to 4 do begin
    if Rcorners[i].x<MinX then MinX:=Rcorners[i].x;
    if Rcorners[i].x>MaxX then MaxX:=Rcorners[i].x;
    if Rcorners[i].y<Miny then Miny:=Rcorners[i].y;
    if Rcorners[i].y>Maxy then Maxy:=Rcorners[i].y;
  end;
  lp.x:=(pcorn[1].x+pcorn[2].x) div 2;
  lp.y:=pcorn[1].y;
  dm_l_to_R(lp.x,lp.y,tg.x,tg.y);
    if tg.x<MinX then MinX:=tg.x;
    if tg.x>MaxX then MaxX:=tg.x;
    if tg.y<Miny then Miny:=tg.y;
    if tg.y>Maxy then Maxy:=tg.y;

  lp.x:=(pcorn[3].x+pcorn[4].x) div 2;
  lp.y:=pcorn[3].y;
  dm_l_to_R(lp.x,lp.y,tg.x,tg.y);
    if tg.x<MinX then MinX:=tg.x;
    if tg.x>MaxX then MaxX:=tg.x;
    if tg.y<Miny then Miny:=tg.y;
    if tg.y>Maxy then Maxy:=tg.y;

  minx:=trunc(minx/(Biginterval*mindiv))*Biginterval*mindiv;
  miny:=trunc(miny/(Bigintervall*mindivl))*Bigintervall*mindivl;

  tltmp.n:=1;
  flhalf:=false;
  dtg.y:=miny;
  while maxY{rcorners[2].y}-dtg.y>1e-15 do begin
   {Линии с черточками внутри карты}
    dtg.x:=minx; //rCorners[3].x;
    dm_R_to_L(dtg.x,dtg.y,pl.pol[0].x,pl.pol[0].y);
    pl.n:=0;
    if dtg.y>PI then yl:=abs(dtg.y-2*Pi) else yl:=dtg.y;
    Calc_grad_min_sec(yl,sgrad,smin,ssec);
    s:=sgrad+smin+ssec;
    i:=0;
    dtg2:=dtg;
    dtg2.y:=dtg2.y-kk/2;
    dtg.x:=minx{rCorners[3].x}+yy;
    {fldown:=false;
    node1:=0;
    if round(dtg.y/(Bigintervall*mindivl)) mod 2=0 then begin
      dhl:=2;
      flstrL:=true;
    end
    else
    begin
      dhl:=1.2;
      flstrL:=false
    end;
    }
    while Maxx{rcorners[1].x}-dtg.x>1.E-15 do begin
      inc(i);
      dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
      res:= Point_in_Poly(P,Plmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],Plmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,Plmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],Plmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,Plmain,nn,Nnext);

          offs:=dm_Add_Poly(codel,2,0,PL,false);
        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;
      (*
      if res then
      if i mod Biginterval<>0 then begin
         modI:=i mod Biginterval;
         if modI=interminterval then dh:=3 else
         if (modI mod smInterv)=0 then dh:=2 else
          dh:=1;
         dtg2.x:=dtg.x;
         dtg2.y:=dtg.y+kk;
         dm_R_to_L(dtg2.x,dtg2.y,tltmp.pol[1].x,tltmp.pol[1].y);
         rx:=PL.pol[pl.n].x;
         ry:=PL.pol[pl.n].y;
         rr:=SQRT(SQR(rx-tltmp.pol[1].x)+SQR(ry-tltmp.pol[1].y));
         rx:=(rx-tltmp.pol[1].x)/rr;
         ry:=(ry-tltmp.pol[1].y)/rr;
        if flstrL then begin
         tltmp.pol[0].x:=PL.pol[pl.n].x-round(dh*kf*rx);
         tltmp.pol[0].y:=PL.pol[pl.n].y-round(dh*kf*ry);
         tltmp.pol[1].x:=PL.pol[pl.n].x+round(dh*kf*rx);
         tltmp.pol[1].y:=PL.pol[pl.n].y+round(dh*kf*ry);

        node:=dm_Add_Poly(codel,2,0,@Tltmp,false{fldown});
        if fldown then fldown:=false;
        if node1=0 then begin
          node1:=node;
          fldown:=true;
        end;
        end;
      end;
      *)
        dtg.x:=dtg.x+yy;

    if (i>8000-Biginterval) and (i mod Biginterval=0) then begin
        dm_goto_node(offs);

        offs:=dm_Add_Poly(codel,2,0,PL,false);
       { if Node1<>0 then begin
          dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

        end;  }
        PL.pol[0]:=PL.pol[PL.n];
        PL.n:=0;
    end;

    end;

    flhalf:=not flhalf;

    dtg.x:=maxx;//rCorners[1].x;
    dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
    if Point_in_Poly(p,Plmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],Plmain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,Plmain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],Plmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,Plmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,Plmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then offs:=dm_Add_Poly(codel,2,0,PL,false);
     {if (Node1<>0) then begin
     dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
    end; }

   dtg.y:=dtg.y+kk;
  end;


    LongtRad_grad(abs(Rcorners[2].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    grad2:=grad;
    flgrad:= Rcorners[1].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[1].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[1].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);

        flGradNonEXist:=grad=grad2;

   if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if Rcorners[1].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

 //if dtg.y<0 then nlb:=-nlb;
    bf:=0;
    //По долготе
    dtg.x:=rcorners[1].x;
    lshraf1.x:=0;
    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[2].y-0.25*mindivl<dtg.y;

    if bf=0 then begin
    lshraf1.x:=a.x;
    lshraf1.y:=a.y-round(1.5*kf);
    bf:=1;
    end;
    if nlb mod BigintervalL = 0 then begin
      dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(3.5*rx*kf);
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if  (flend or flfirst) and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
            Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(5.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      flfirst:=false;


      end else if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
        flfirst:=false;

      end
      else begin
      if (flend or flfirst) then begin
        flfirst:=false;
        Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
        lx1:=R[2].x-R[1].x;
        Text_Bound(codet,a,a,R,inttostr(min)+'''');
        lx2:=R[2].x-R[1].x;
        b.x:=a.x-(lx1+lx2) div 2;
        b.y:=a.y-round(5.2*kf);
        Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
        inc(b.x,lx1);
        Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
      b.x:=a.x;
    end else if nlb mod intermintervall = 0 then begin
      dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(3.5*rx*kf);
      b.y:=a.y-round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
      if nlb mod textintervL = 0 then
      if flGradNonEXist and (flend or flfirst) and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
        flfirst:=false;

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
      end else begin
      if flgrad and (min=0) then begin
        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);
        flfirst:=false;

      end
      else begin
      if (flend or flfirst) then begin
         flfirst:=false;

         Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
         lx1:=R[2].x-R[1].x;
         Text_Bound(codet,a,a,R,inttostr(min)+'''');
         lx2:=R[2].x-R[1].x;
         b.x:=a.x-(lx1+lx2) div 2;
         b.y:=a.y-round(5.2*kf);
         Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
         inc(b.x,lx1);
         Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      end else begin
         ss:=inttostr(min);
         Text_Bound(codet,a,a,R,ss);
         b.x:=a.x-round((R[2].x-R[1].x)*0.5);
         b.y:=a.y-round(5.2*kf);
         ss:=ss+'''';
         Add_Text(codet,b,b,0,ss,false);
       end;
      end;
      end;
    end else if nlb mod smintervL = 0 then begin
     dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;
      b.x:=a.x+round(2*rx*kf);
      b.y:=a.y-round(2*kf);
      dm_add_sign(codes,a,b,0,false);
     if (flend or flfirst) then begin
          flfirst:=false;
       
         Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
         lx1:=R[2].x-R[1].x;
         Text_Bound(codet,a,a,R,inttostr(min)+'''');
         lx2:=R[2].x-R[1].x;
         b.x:=a.x-(lx1+lx2) div 2;
         b.y:=a.y-round(5.2*kf);
         Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
         inc(b.x,lx1);
         Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      end;

     end else begin
     dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;
      b.x:=a.x+round(rx*kf);
      b.y:=a.y-round(kf);
      dm_add_sign(codes,a,b,0,false);
     end;
     if nlb mod ShrafL = 0 then begin
         {if ((dtg.y>=0) and (Rcorners[1].y>=0)) or ((dtg.y<=0) and (Rcorners[1].y<=0)) then
         nlbdiv:=abs(nlb div ShrafL)
         else
         nlbdiv:=abs(nlb div ShrafL+1);
         }
         if dtg.y-0.5*mindivl>=0 then
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))
         else
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))+1;

         if nlbdiv  mod 2 =0 then begin
           lshraf1.x:=a.x;
           lshraf1.y:=a.y-round(1.5*kf);
         end
         else begin
           if a.x<>lshraf1.x then begin
           b.x:=a.x;
           b.y:=a.y-round(1.5*kf);

           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           Lshraf1.x:=0;
         end;
     end;
       if Rcorners[1].y>=0 then
      inc(nlb)
      else
      dec(nlb);

      {dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivL;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.y:=pcorn[1].y;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);
      }
      dtg.y:=dtg.y+mindivL;
      //dtg.x:=dtg2.x;
     until rcorners[2].y+0.25*mindivL<dtg.y;

     if lshraf1.x<>0 then begin
           dtg:=Rcorners[2];
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;

   // Конец верхних текстов


    LongtRad_grad(abs(Rcorners[3].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    grad2:=grad;
    flgrad:= Rcorners[4].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[4].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[4].y;
    LongtRad_grad(abs(dtg.y),grad,min,sec);

        flGradNonEXist:=grad=grad2;

   if textgradL<>0 then
      grad:=(grad div textgradL) *textgradL;

    nlb:=round((abs(dtg.y)-grad/180*pi)/mindivl);
    if Rcorners[4].y>0 then
     dtg.y:=grad/180*pi+nlb*mindivl
    else
     dtg.y:=-(grad/180*pi+nlb*mindivl);

    bf:=0;
     dtg.x:=rcorners[4].x;
    lshraf2.x:=0;
    repeat
    LongtRad_grad (abs(dtg.y),grad,min,sec);

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[3].y-0.25*mindivl<dtg.y;
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(1.5*kf);
    bf:=1;
    end;

    if nlb mod BigintervalL = 0 then begin

     dtg2.x:=dtg.x-mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(3.5*rx*kf);
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);

 if (flend or flfirst) and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      if bmindiv=0 then bmindiv:=1;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(3.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      if flfirst then begin
       if (dtg.y>=0) and (dtg.y<=Pi) then
         litera:='E'
       else
        litera:='W';
       Add_Text(codeBig,b,b,0,litera,false);
       flfirst:=false;
      end;
      end else if flgrad and (min=0) then begin
       if bmindiv=0 then bmindiv:=1;
      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      if  flfirst then begin
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
      if (flend or flfirst) then begin
       Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
       lx1:=R[2].x-R[1].x;
       if bmindiv=0 then bmindiv:=1;
       Text_Bound(codet,a,a,R,inttostr(min)+'''');
       lx2:=R[2].x-R[1].x;
       b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(3.2*kf);
       Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
       inc(b.x,lx1);
       Add_Text(codet,b,b,0,inttostr(min)+'''',false);
       inc(b.x,lx2);
       if flfirst then begin
         if (dtg.y>=0) and (dtg.y<=Pi) then
           litera:='E'
         else
           litera:='W';
         Add_Text(codeBig,b,b,0,litera,false);
       end;
       flfirst:=false;
      end else begin
       ss:=inttostr(min);
       Text_Bound(codet,a,a,R,ss);
       b.x:=a.x-round((R[2].x-R[1].x)*0.5);
       b.y:=Tlint.pol[2].y-round(3.2*kf);
       ss:=ss+'''';
       Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end else if nlb mod intermintervalL = 0 then begin
      dtg2.x:=dtg.x-mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(3.5*rx*kf);
      b.y:=a.y+round(3.5*kf);
      dm_add_sign(codes,a,b,0,false);
 if nlb mod textintervL = 0 then
       if flGradNonEXist and (flend or flfirst) and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;
       flfirst:=false;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(4.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      end else begin

      if flgrad and (min=0) then begin
      if bmindiv=0 then bmindiv:=1;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
       if flfirst then begin
       if (dtg.y>=0) and (dtg.y<=Pi)then
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
       if (flend or flfirst) then begin
       Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
       lx1:=R[2].x-R[1].x;
       if bmindiv=0 then bmindiv:=1;
       Text_Bound(codet,a,a,R,inttostr(min)+'''');
       lx2:=R[2].x-R[1].x;
       b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(3.2*kf);
       Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
       inc(b.x,lx1);
       Add_Text(codet,b,b,0,inttostr(min)+'''',false);
       inc(b.x,lx2);
       if flfirst then begin
         if (dtg.y>=0) and (dtg.y<=Pi) then
          litera:='E'
        else
          litera:='W';
        Add_Text(codeBig,b,b,0,litera,false);
        flfirst:=false;
       end;
      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=Tlint.pol[2].y-round(3.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
    end;
    end else if nlb mod smintervL = 0 then begin
     dtg2.x:=dtg.x-mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(2*rx*kf);
      b.y:=a.y+round(2*kf);
      dm_add_sign(codes,a,b,0,false);
       if (flend or flfirst) then begin
       Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
       lx1:=R[2].x-R[1].x;
       if bmindiv=0 then bmindiv:=1;
       Text_Bound(codet,a,a,R,inttostr(min)+'''');
       lx2:=R[2].x-R[1].x;
       b.x:=a.x-(lx1+lx2) div 2;
       b.y:=Tlint.pol[2].y-round(3.2*kf);
       Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
       inc(b.x,lx1);
       Add_Text(codet,b,b,0,inttostr(min)+'''',false);
       inc(b.x,lx2);
       if flfirst then begin
         if (dtg.y>=0) and (dtg.y<=Pi) then
           litera:='E'
         else
           litera:='W';
          Add_Text(codeBig,b,b,0,litera,false);
          flfirst:=false;
       end;
      end;
end else begin
   dtg2.x:=dtg.x-mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         //ry:=(b.y-ry)/rr;

      b.x:=a.x+round(rx*kf);
      b.y:=a.y+round(kf);
      dm_add_sign(codes,a,b,0,false);

end;
     if nlb mod ShrafL = 0 then begin
         if dtg.y-0.5*mindivl>=0 then
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))
         else
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))+1;

         if nlbdiv mod 2 =0 then begin
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
     end;

      if bmindiv=1 then begin
        dtg2.x:=dtg.x;
        dtg2.y:=dtg.y+0.5*mindivl*textintervL;

        dm_R_to_l(dtg2.x,dtg2.y,lpc.x,lpc.y);
       lpc.y:=Tlint.pol[2].y-round(3.2*kf);

       if (FFrame.CboxLang.itemindex=0)or(FFrame.CboxLang.itemindex=2) then begin

       ss:='Мин.дел.=';
       case tmindiv of
       1: ss:=ss+'0,1"';
       2: ss:=ss+'0,2"';
       3: ss:=ss+'0,5"';
       4: ss:=ss+'1"';
       5: ss:=ss+'2"';
       6: ss:=ss+'3"';
       7: ss:=ss+'6"';
       8: ss:=ss+'12"';
       9: ss:=ss+'30"';
       10:ss:=ss+'1''';
       11:ss:=ss+'2''';
       12:ss:=ss+'5''';
       13:ss:=ss+'10''';
       end;
        Text_Bound(codeMinDiv,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      {if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y-round(1.2*kf);
      }
      Add_Text(codeMinDiv,lpc,lpc,0,ss,false);
      end;
      if (FFrame.CboxLang.itemindex=1)or(FFrame.CboxLang.itemindex=2) then begin
        ss:='Min.div.';
        if FFrame.CboxLang.itemindex=1 then begin
        ss:=ss+'=';
       case tmindiv of
         1: ss:=ss+'0,1"';
         2: ss:=ss+'0,2"';
         3: ss:=ss+'0,5"';
         4: ss:=ss+'1"';
         5: ss:=ss+'2"';
         6: ss:=ss+'3"';
         7: ss:=ss+'6"';
         8: ss:=ss+'12"';
         9: ss:=ss+'30"';
         10:ss:=ss+'1''';
         11:ss:=ss+'2''';
         12:ss:=ss+'5''';
         13:ss:=ss+'10''';
       end;
       end;
       if FFrame.CboxLang.itemindex<>2 then begin
        Text_Bound(codeMinDiv_blue,a,a,R,ss);
      lpc.x:=lpc.x-round((R[2].x-R[1].x)*0.5);
      end;
      if FFrame.CboxLang.itemindex=2 then
      lpc.y:=lpc.y+round(2.3*kf);
      Add_Text(codeMinDiv_blue,lpc,lpc,0,ss,false);
       end;
      bmindiv:=2;
      end;
        if Rcorners[4].y>=0 then
      inc(nlb)
      else
      dec(nlb);
     { dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivL;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.y:=pcorn[4].y;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);
      }
      dtg.y:=dtg.y+mindivL;
     // dtg.x:=dtg2.x;
  until rcorners[3].y+0.25*mindivl<dtg.y;

     if lshraf2.x<>0 then begin
          dtg:=Rcorners[3];
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
     end;

  //Конец расчетов по долготе

  if flGradinterv then begin
      kk:=Biginterval*mindiv;
      yy:=mindivL;
    end else begin
   case nomenkl.scale of
  _sc2,_sc5,_sc10:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _sc25:begin kk:=Pi/10800;
          yy:=Pi/108000;
        end;
  _scm50:begin kk:=Pi/5400;
           yy:=Pi/54000;
        end;
  _scm100:begin kk:=Pi/2700;
         yy:=Pi/27000;
         end;
  _scm200:begin kk:=Pi/1800;
         yy:=Pi/18000;
         end;
  _scm500:begin kk:=Pi/360;
         yy:=Pi/360;
         end;
   else begin kk:=Pi/180;
         yy:=Pi/180;
         end;

  end;
  smIntervL:=1;
  intermintervalL:=5;

  end;

  dtg.x:=minx;//rCorners[3].x;

  flhalf:=false;

  while Maxx{rcorners[1].x}-dtg.x>1e-8 do begin
    i:=0;
    PL.n:=0;
    dtg.y:=miny;//rCorners[1].y;
    dm_R_to_L(dtg.x,dtg.y,PL.pol[0].x,PL.pol[0].y);

    dtg.y:=miny{rCorners[1].y}+yy;
    Calc_grad_min_sec(dtg.x,sgrad,smin,ssec);
    Application.ProcessMessages;
    flDown:=false;
    node1:=0;
    flstrL:=round(dtg.x/(Biginterval*mindiv)) mod 2=0;
    while maxy{rcorners[2].y}-dtg.y>1e-15 do begin
      inc(i);
      dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
      res:= Point_in_Poly(P,Plmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],Plmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,Plmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],Plmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,Plmain,nn,Nnext);

          offs:=dm_Add_Poly(codel,2,0,PL,false);
        {if (Node1<>0) then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
        flDown:=false;
        node1:=0;
        end;
        }
        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;
      (*
      if res then
      if i mod BigIntervalL<>0 then begin
         modI:=i mod BigIntervalL;
         if modI=intermintervall then dh:=3 else
         if (modI mod smIntervl) =0 then dh:=2 else
          dh:=1;
         dtg2.x:=dtg.x+kk;
         dtg2.y:=dtg.y;
         dm_R_to_L(dtg2.x,dtg2.y,tltmp.pol[1].x,tltmp.pol[1].y);
         rx:=PL.pol[pl.n].x;
         ry:=PL.pol[pl.n].y;
         rr:=SQRT(SQR(rx-tltmp.pol[1].x)+SQR(ry-tltmp.pol[1].y));
         rx:=(rx-tltmp.pol[1].x)/rr;
         ry:=(ry-tltmp.pol[1].y)/rr;
       if flstrL then begin

         tltmp.pol[0].x:=PL.pol[pl.n].x-round(dh*kf*rx);
         tltmp.pol[0].y:=PL.pol[pl.n].y-round(dh*kf*ry);
         tltmp.pol[1].x:=PL.pol[pl.n].x+round(dh*kf*rx);
         tltmp.pol[1].y:=PL.pol[pl.n].y+round(dh*kf*ry);
         node:=dm_Add_Poly(codel,2,0,@Tltmp,false {fldown});
        if fldown then fldown:=false;
        if Node1=0 then begin
        node1:=Node;
        fldown:=true;
        end;
     end;
      end;
      *)
      dtg.y:=dtg.y+yy;
        // Создание текстов
      (*
      if res and (((i mod BigIntervalL)=smIntervl) and ((((i div BigIntervalL) mod 2=ord(not fframe.ChCrMercB.Checked))))) {and not flhalf) or
                          (((i div lbigl) mod 2=1) and flhalf)))} then begin

        dm_R_to_L(dtg.x,dtg.y,a.x,a.y);

         a.x:=(a.x+PL.pol[Pl.n].x) div 2;
         a.y:=(a.y+PL.pol[pl.n].y) div 2;
         s:=sgrad;
         Text_Bound(codebig,a,a,R,s);
         lx:=R[2].x-R[1].x;

         if ry>0 then signrx:=1 else signrx:=-1;

         if smin='00''' then begin
          a.x:=a.x-round(signrx*0.5*lx*ry);
          a.y:=a.y+round(-kf+signrx*0.5*lx*rx);
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
         end else begin
          Text_Bound(codet,a,a,R,smin);
          lxsm:=R[2].x-R[1].x;
          a.x:=a.x-round(signrx*0.5*(lx+lxsm)*ry);
          a.y:=a.y+round(-kf+signrx*0.5*(lx+lxsm)*rx);
          b.x:=a.x+round(signrx*lx*ry);
          b.y:=a.y-round(signrx*lx*rx);
          Add_Text(codebig,a,b,0,s,false{fldown});
          //dm_set_tag(21);

          a:=b;
          b.x:=a.x+round(signrx*lxsm*ry);
          b.y:=a.y-round(signrx*lxsm*rx);
          Add_Text(codet,a,b,0,smin,false{fldown});

         end;
         //dm_set_tag(21);

      end;
      *)
         // Конец создания текстов
      if (i>8000-BigIntervalL) and (i mod BigIntervalL=0) then begin
        dm_goto_node(offs);
        offs:=dm_Add_Poly(codel,2,0,PL,false);
        {if node1<>0 then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);
        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

        end;
        }
        PL.pol[0]:=PL.pol[PL.n];
        Pl.n:=0;
      end;


    end;
    flhalf:=not flhalf;
    dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
    if Point_in_Poly(p,Plmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],Plmain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,Plmain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],Plmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,Plmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,Plmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then offs:=dm_Add_Poly(codel,2,0,PL,false);
      {
      if node1<>0 then begin
        dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);
        dm_goto_node(offs);
        node1:=0;
        flDown:=false;

      end;
      }
    dtg.x:=dtg.x+kk;
  end;

  //Создание градусной разметки широт
    Rad_grad(abs(Rcorners[1].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if Rcorners[1].x>=0 then
      sign:=1
    else
      sign:=-1;
     grad2:=grad;
    flgrad:= Rcorners[4].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
      flten:=Rcorners[4].x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcorners[4].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    flGradNonEXist:=grad=grad2;

    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[4].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

    bf:=0;
    //По широте
    dtg.Y:=rcorners[4].Y;
    lshraf1.x:=0;
    repeat
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
     flend:=rcorners[1].x-0.25*mindiv<dtg.x;

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(1.5*kf);
    bf:=1;
    end;
    if nlb mod Biginterval = 0 then begin
      dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;

      b.x:=a.x-round(3.5*kf);
      b.y:=a.y+round(3.5*ry*kf);
      dm_add_sign(codes,a,b,0,false);

   if (flfirst or flend) and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
        ss:=inttostr(grad);
        Text_Bound(codebig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
        b.y:=a.y-round(0.6*kf);
        ss:=ss+'°';
        Add_Text(codebig,b,b,0,ss,false);
        ss:=inttostr(min);
        Text_Bound(codet,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
        b.y:=a.y+round(2.8*kf);
        ss:=ss+'''';
        Add_Text(codet,b,b,0,ss,false);
        flfirst:=false;
      end else if flgrad and (min=0) then begin

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if (flfirst or flend) then begin
         ss:=inttostr(grad);
        Text_Bound(codebig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
        b.y:=a.y-round(0.6*kf);
        ss:=ss+'°';
        Add_Text(codebig,b,b,0,ss,false);
        ss:=inttostr(min);
        Text_Bound(codet,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
        b.y:=a.y+round(2.8*kf);
        ss:=ss+'''';
        Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;

      end else if nlb mod interminterval = 0 then begin
           dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;

      b.x:=a.x-round(3.5*kf);
      b.y:=a.y+round(3.5*ry*kf);
      dm_add_sign(codes,a,b,0,false);

  if nlb mod textinterv = 0 then
      if flGradNonEXist and (flfirst or flend) and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if (flfirst or flend) then begin
       ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
      end;

    end else if nlb mod sminterv = 0 then begin
           dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;

      b.x:=a.x-round(2*kf);
      b.y:=a.y+round(2*ry*kf);
      dm_add_sign(codes,a,b,0,false);
      if (flfirst or flend) then begin
       ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+5.75*KF);
      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end;
end else begin
           dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;

      b.x:=a.x-round(kf);
      b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
end;

     if nlb mod Shraf = 0 then begin
         {if ((dtg.x>=0) and (Rcorners[4].x>=0)) or ((dtg.x<=0) and (Rcorners[4].x<=0)) then
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
           lshraf1.x:=a.x-round(1.5*kf);
         end
         else begin
           if lshraf1.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.x:=0;
         end;
     end;
      {
      dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.x:=pcorn[4].x;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg2.y;
      }
      dtg.x:=dtg.x+mindiv;
        if Rcorners[4].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[1].x+0.25*mindiv<dtg.x;

     if lshraf1.x<>0 then begin
           dtg:=rcorners[1];
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x-round(1.5*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;



      Rad_grad(abs(Rcorners[2].x),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    if Rcorners[2].x>=0 then
      sign:=1
    else
      sign:=-1;
     grad2:=grad;
    flgrad:= Rcorners[3].x<=sign*grad/180*pi;
    if not flgrad then begin
      min:=min - min mod 10;
      flten:=Rcorners[3].x<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;

    dtg.x:=Rcorners[3].x;
    Rad_grad(abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
    if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    flGradNonEXist:=grad=grad2;

    if textgrad<>0 then
      grad:=(grad div textgrad) *textgrad;

    nlb:=round((abs(dtg.X)-grad/180*pi)/mindiv);
    if Rcorners[3].x>0 then
     dtg.x:=grad/180*pi+nlb*mindiv
    else
     dtg.x:=-(grad/180*pi+nlb*mindiv);

    bf:=0;
    //По широте
    dtg.Y:=rcorners[3].Y;
    lshraf2.x:=0;
    repeat
    Rad_grad (abs(dtg.X),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[2].x-0.25*mindiv<dtg.x;

    if bf=0 then begin
    lshraf2.y:=a.y;
    lshraf2.x:=a.x+round(1.5*kf);
    bf:=1;
    end;

    if nlb mod Biginterval = 0 then begin
          dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        b.x:=a.x+round(3.5*kf);
        b.y:=a.y+round(3.5*ry*kf);
      dm_add_sign(codes,a,b,0,false);

  if (flfirst or flend) and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if (flfirst or flend) then begin
        ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end
     end else if nlb mod interminterval = 0 then begin

         dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        b.x:=a.x+round(3.5*kf);
        b.y:=a.y+round(3.5*ry*kf);
      dm_add_sign(codes,a,b,0,false);
     if nlb mod textinterv = 0 then
      if flGradNonEXist and (flfirst or flend) and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-5.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if flgrad and (min=0) then begin
      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);
      flfirst:=false;
      end else begin
      if (flfirst or flend) then begin
        ss:=inttostr(grad);
        Text_Bound(codebig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
        b.y:=a.y-round(0.6*kf);
        ss:=ss+'°';
        Add_Text(codebig,b,b,0,ss,false);
        ss:=inttostr(min);
        Text_Bound(codet,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
        b.y:=a.y+round(2.8*kf);
        ss:=ss+'''';
        Add_Text(codet,b,b,0,ss,false);
        flfirst:=false;
      end else begin
        ss:=inttostr(min);
        Text_Bound(codet,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
        b.y:=a.y+round(1.1*kf);
        ss:=ss+'''';
        Add_Text(codet,b,b,0,ss,false);
      end;
      end;
      end;
    end else if nlb mod sminterv = 0 then begin
          dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        b.x:=a.x+round(2*kf);
        b.y:=a.y+round(2*ry*kf);
      dm_add_sign(codes,a,b,0,false);
      if (flfirst or flend) then begin
        ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(2.8*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      flfirst:=false;
      end
  end else begin
          dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         //rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        b.x:=a.x+round(kf);
        b.y:=a.y+round(ry*kf);
      dm_add_sign(codes,a,b,0,false);
  end;


  if nlb mod Shraf = 0 then begin

         if dtg.x-mindiv>=0 then
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

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
           lshraf2.x:=0;
         end;
     end;
      {
       dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.x:=pcorn[3].x;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg2.y;
      }
      dtg.x:=dtg.x+mindiv;
       if Rcorners[3].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[2].x+0.25*mindiv<dtg.x;
      if lshraf2.x<>0 then begin
          dtg.x:=Rcorners[2].x;
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x+round(1.5*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
      end;
end;


function Frame_art:boolean;
var
  a0,b0,a,b,t:lpoint;
  tg0,tg,tgr:tgauss;
  dtg,dtg2,dkras:tgauss;
  dh,dd,azim,bkmmin,bkmmax:double;
  dx,dy,dxsm,dysm, dwline, dInt,dAdm,i,j,lcode,lcodeINT,res,ll,lx,lAdmlen,lIntLen,dmdist,ld,km,
  CodeTextKM,StrichCode,codelogdigit,codelogtext,codelogHead, codebluelogtext,codeBluelogHead:integer;
  code:longint;
//  t1, t2:_geoid;
  A1,A2: extended;
  xmin,xmax,ymin,ymax,rr:double;
  grad,min: integer;
  sec: extended;
  R:lOrient;
  dg:tgauss;
  sdm:shortstring;
  st,ss,ssec,sINT,src:shortstring;
  SaveDlg: TSaveDialog;
  i995,i996,i997:longint;
  w999,b901,b911:word;
  fl991,fl992,fl993:boolean;
  flhalf:boolean;
  ch,ch0:char;
begin
  Result:=false;
  dmw_activemap(@src[1],255);
  if not Set_Active_map(0,true) then begin
    ShowMessage('Нет активной карты');
    exit;
  end;
  dm_Goto_root;
if dm_get_long(904,0,iscale) then begin
 fl991:=Dm_GET_double(991,0,B991);
 fl992:=Dm_GET_double(992,0,B992);
 fl993:=Dm_GET_double(993,0,L993);

if not  Dm_get_word(999,0,w999) then w999:=1;
if not  Dm_get_word(901,0,b901) then b901:=1;
if not  Dm_get_word(911,0,b911) then b911:=1;
if not  Dm_get_word(913,0,b913) then b913:=1;
if b913<>1 then begin
  showMessage('Карта не проекции Гаусса-Крюгера');
  dmw_done;
  exit
end;

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
 if iscale<=20000 then Nomenkl.scale:=_sc20
 else
 if iscale<=25000 then Nomenkl.scale:=_sc25
 else
 if iscale<=30000 then Nomenkl.scale:=_scM30
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
 //scale:=iscale;
 //if dm_Get_String(901,255,ss) then begin    Номенклатура
 end else begin
   dmw_done;
   exit
 end;


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

  for i:=1 to 4 do
    dm_L_to_G(Pcorn[i].x,Pcorn[i].y,corners[i].x,corners[i].y);
 SaveDlg:=TSaveDialog.Create(Fframe);
 SaveDlg.Title:='Выбор имени карты оформления';
 SaveDlg.DefaultExt:='dm';
 SaveDlg.Filter:='*.dm';
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
    mtConfirmation, [mbYes, mbNo], 0) = 0 then begin
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
{ ShowMessage(floattostr(corners[1].x));
 ShowMessage(floattostr(corners[2].y));
}
 //ShowMessage(floattostr(dmdist));
 dm_Copy(@src[1],@sdm[1],@st[1]);
 {
 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;
  }

if  dmw_open(@sdm[1],true)=0 then exit;

  dm_goto_root;
  dm_Get_bound(a0,b0);

 { ShowMessage(floattostr(b0.x-a0.x));
  ShowMessage(floattostr(b0.y-a0.y));
  }
(*
  dm_put_long(904,iscale);
 Dm_Put_word(999,w999);
 dm_put_byte(901,b901);
 Dm_Put_byte(911,b911);
 //c_:=Ellipsoids[B911];
 Dm_Put_byte(913,b913);
 if fl991 then Dm_Put_double(991,B991);
 if fl992 then Dm_Put_double(992,B992);
 if fl993 then Dm_Put_double(993,l993);
 Dm_put_LONG(995,I995);
 Dm_put_LONG(996,I996);
 Dm_put_LONG(997,I997);

   i:=4;
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 Pl^.Pol[i]:=pcorn[i];

 dm_Set_bound(pcorn[i],pcorn[i]);
 dm_put_double(91,rcorners[i].x);
 dm_put_double(92,rcorners[i].y);
 dm_put_double(901,corners[i].x);
 dm_put_double(902,corners[i].y);

 if i=4 then
   i:=1
 else
   inc(i);
 until dmx_Find_Next_Code(0,1)=0;
 *)

  dm_goto_root;
 dm_get_poly_buf(pl,8000);
 { Pl^.Pol[0]:=pcorn[4];
  Pl^.n:=4;
  }
  ll:=(b0.x-a0.x) div 4;
  elm_inc_metric_levo(pl,ll);
  dm_set_Poly_buf(pl);
  dmw_done;

 if not dmw_InsertMap(@sdm[1]) then exit;
 if not Set_active_map(1,true) then exit;

 //if  dmw_open(@sdm[1],true)=0 then exit;
   kf:=dm_dist(1,1);
   //kf:=5000;
  for i:=1 to 4 do
     dm_R_to_l(rcorners[i].x,rcorners[i].y,pcorn[i].x,pcorn[i].y);
  {
  ShowMessage(floattostr(pcorn[2].x-pcorn[1].x));
  ShowMessage(floattostr(pcorn[4].y-pcorn[1].y));
  ShowMessage(floattostr(kf));
  }

   //Set_intervals;
   with FArt do begin

    mindiv:=(strtoint(memdM.edittext)/60+strtoFloat(memdS.edittext)/3600)/180*PI;
    smInterv:=round(((strtoint(meSminD.edittext)+strtoint(meSminM.edittext)/60+strtoFloat(meSminS.edittext)/3600)/180*PI)/mindiv);
    intermInterval:=round(((strtoint(meIntrD.edittext)+strtoint(meIntrM.edittext)/60+strtoFloat(meIntrS.edittext)/3600)/180*PI)/mindiv);
    TextInterv:=round(((strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext)/3600)/180*PI)/mindiv);
    Biginterval:=round(((strtoint(meBigIntrD.edittext)+strtoint(meBigIntrM.edittext)/60+strtoFloat(meBigIntrS.edittext)/3600)/180*PI)/mindiv);
    Shraf:=round(((strtoint(meShrafD.edittext)+strtoint(meShrafM.edittext)/60+strtoFloat(meShrafS.edittext)/3600)/180*PI)/mindiv);

    mindivL:=(strtoint(memdM_L.edittext)/60+strtoFloat(memdS_L.edittext)/3600)/180*PI;
    smIntervL:=round(((strtoint(meSminD_L.edittext)+strtoint(meSminM_L.edittext)/60+strtoFloat(meSminS_L.edittext)/3600)/180*PI)/mindivL);
    intermIntervalL:=round(((strtoint(meIntrD_L.edittext)+strtoint(meIntrM_L.edittext)/60+strtoFloat(meIntrS_L.edittext)/3600)/180*PI)/mindivL);
    TextIntervL:=round(((strtoint(meTextIntrD_L.edittext)+strtoint(meTextIntrM_L.edittext)/60+strtoFloat(meTextIntrS_L.edittext)/3600)/180*PI)/mindivL);
    BigintervalL:=round(((strtoint(meBigIntrD_L.edittext)+strtoint(meBigIntrM_L.edittext)/60+strtoFloat(meBigIntrS_L.edittext)/3600)/180*PI)/mindivL);
    ShrafL:=round(((strtoint(meShrafD_L.edittext)+strtoint(meShrafM_L.edittext)/60+strtoFloat(meShrafS_L.edittext)/3600)/180*PI)/mindivL);

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
    {
     for i:=1 to 4 do
     Tlmain.pol[i-1]:=pcorn[i];
     TlMain.pol[4]:=Tlmain.pol[0];
     TLmain.n:=4;
    }

     PLmain.pol[0]:=pcorn[1];
     PLmain.n:=1;
       dtg:=Rcorners[1];
       repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plmain.pol[Plmain.n].x, Plmain.pol[Plmain.n].y);
       inc(PLmain.n);
       until dtg.y>Rcorners[2].y-Mindivl*0.5;
      PLmain.pol[PLmain.n]:=pcorn[2];
       inc(Plmain.n);
      Plmain.pol[Plmain.n]:=pcorn[3];
       inc(Plmain.n);
       dtg:=Rcorners[3];
       repeat
       dtg.y:=dtg.y-Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Plmain.pol[Plmain.n].x, Plmain.pol[Plmain.n].y);
       inc(Plmain.n);
       until dtg.y<Rcorners[4].y+Mindivl*0.5;
       Plmain.pol[Plmain.n]:=pcorn[4];
       inc(Plmain.n);
       Plmain.pol[Plmain.n]:=pcorn[1];

     dmx_Find_Frst_Code(0,1);
     dm_goto_last;
       //Внутрення рамка
       dm_Add_Poly(String2code('A0100002'),2,0,Plmain,false);



     dx:=round(12.5*kf);
     dy:=round(12.5*kf);
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

         dx:=round(11.5*kf);
         dy:=round(11.5*kf);
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
     ii[0]:=0;
     ii[1]:=1;
     ii[2]:=2;
     ii[3]:=3;
     ii[4]:=4;


//     Mk_COVER;

     dx:=round(12*kf);
     dy:=round(12*kf);
     dxsm:=round(3*kf);
     dysm:=round(3*kf);
     dwline:=round(0.5*kf);
     tlBigframe.n:=1;

     with fart do begin
         tlBigframe.pol[0].x:=pcorn[1].x-dx-dwline;
       tlBigframe.pol[0].y:=pcorn[1].y-dy;
         tlBigframe.pol[1].x:=pcorn[2].x+dx+dwline;
       tlBigframe.pol[1].y:=pcorn[2].y-dy;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);

         tlBigframe.pol[0].y:=pcorn[2].y-dy-dwline;
       tlBigframe.pol[0].x:=pcorn[2].x+dx;

         tlBigframe.pol[1].y:=pcorn[3].y+dy+dwline;
       tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);

       tlBigframe.pol[0].x:=pcorn[4].x-dx-dwline;
       tlBigframe.pol[0].y:=pcorn[4].y+dy;
       tlBigframe.pol[1].x:=pcorn[3].x+dx+dwline;
       tlBigframe.pol[1].y:=pcorn[3].y+dy;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);

       tlBigframe.pol[0].y:=pcorn[1].y-dy-dwline;
       tlBigframe.pol[0].x:=pcorn[1].x-dx;
       tlBigframe.pol[1].y:=pcorn[1].y-dysm;
       tlBigframe.pol[1].x:=pcorn[1].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);

       tlBigframe.pol[0].y:=pcorn[4].y+dy+dwline;
       tlBigframe.pol[0].x:=pcorn[4].x-dx;
       tlBigframe.pol[1].y:=pcorn[4].y+dysm;
       tlBigframe.pol[1].x:=pcorn[4].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);


     //Тонкая рамка рядом с толстой
    { dx:=round(10*kf);
     dy:=round(10*kf);
     dxsm:=round(3*kf);
     dysm:=round(3*kf);

         tlBigframe.pol[0].x:=pcorn[1].x-dx;
       tlBigframe.pol[0].y:=pcorn[1].y-dy;
         tlBigframe.pol[1].x:=pcorn[2].x+dx;
       tlBigframe.pol[1].y:=pcorn[2].y-dy;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);

         tlBigframe.pol[0].y:=pcorn[2].y-dy;
       tlBigframe.pol[0].x:=pcorn[2].x+dx;

         tlBigframe.pol[1].y:=pcorn[3].y+dy;
       tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);

         tlBigframe.pol[0].x:=pcorn[4].x-dx;
       tlBigframe.pol[0].y:=pcorn[4].y+dy;
         tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.pol[1].y:=pcorn[3].y+dy;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);

         tlBigframe.pol[0].y:=pcorn[1].y-dy;
       tlBigframe.pol[0].x:=pcorn[1].x-dx;

         tlBigframe.pol[1].y:=pcorn[4].y+dy;
       tlBigframe.pol[1].x:=pcorn[4].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
      }

     dx:=round(2*kf);
     dy:=round(2*kf);
       PL.pol[0].x:=pcorn[1].x-dx;
       PL.pol[0].y:=pcorn[1].y-dy;
       PL.n:=1;
       dtg:=Rcorners[1];
       repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Pl.pol[pl.n].x, Pl.pol[pl.n].y);
       Pl.pol[pl.n].y:=Pl.pol[pl.n].y-dy;
       inc(PL.n);
       until dtg.y>Rcorners[2].y-Mindivl*0.5;

       Pl.pol[pl.n].x:=pcorn[2].x+dx;
       Pl.pol[pl.n].y:=pcorn[2].y-dy;
       dm_Add_Poly(string2code('A0100002'),2,0,PL,false);

         tlBigframe.pol[0].y:=pcorn[2].y-dy;
       tlBigframe.pol[0].x:=pcorn[2].x+dx;

         tlBigframe.pol[1].y:=pcorn[3].y+dy;
       tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);

        pl.pol[0].x:=pcorn[4].x-dx;
        pl.pol[0].y:=pcorn[4].y+dy;
        PL.n:=1;
       dtg:=Rcorners[4];
       repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Pl.pol[pl.n].x, Pl.pol[pl.n].y);
       Pl.pol[pl.n].y:=Pl.pol[pl.n].y+dy;

       inc(PL.n);
       until dtg.y>Rcorners[3].y-Mindivl*0.5;
       Pl.pol[pl.n].x:=pcorn[3].x+dx;
       Pl.pol[pl.n].y:=pcorn[3].y+dy;
       dm_Add_Poly(string2code('A0100002'),2,0,PL,false);

       tlBigframe.pol[0].y:=pcorn[1].y-dy;
       tlBigframe.pol[0].x:=pcorn[1].x-dx;
       tlBigframe.pol[1].y:=pcorn[4].y+dy;
       tlBigframe.pol[1].x:=pcorn[4].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
   end;

     dx:=round(kf);
     dy:=round(kf);
       PL.pol[0].x:=pcorn[1].x-2*dx;
       PL.pol[0].y:=pcorn[1].y-dy;
       PL.n:=1;
       dtg:=Rcorners[1];
       repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Pl.pol[pl.n].x, Pl.pol[pl.n].y);
       Pl.pol[pl.n].y:=Pl.pol[pl.n].y-dy;
       inc(PL.n);
       until dtg.y>Rcorners[2].y-Mindivl*0.5;

       Pl.pol[pl.n].x:=pcorn[2].x+2*dx;
       Pl.pol[pl.n].y:=pcorn[2].y-dy;
       dm_Add_Poly(string2code('A0100002'),2,0,PL,false);

       tlBigframe.pol[0].y:=pcorn[2].y-2*dy;
       tlBigframe.pol[0].x:=pcorn[2].x+dx;

       tlBigframe.pol[1].y:=pcorn[3].y+2*dy;
       tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);

       pl.pol[0].x:=pcorn[4].x-2*dx;
       pl.pol[0].y:=pcorn[4].y+dy;
       PL.n:=1;
       dtg:=Rcorners[4];
       repeat
       dtg.y:=dtg.y+Mindivl;
       dm_R_to_L( dtg.x,dtg.y, Pl.pol[pl.n].x, Pl.pol[pl.n].y);
       Pl.pol[pl.n].y:=Pl.pol[pl.n].y+dy;
       inc(PL.n);
       until dtg.y>Rcorners[3].y-Mindivl*0.5;
       Pl.pol[pl.n].x:=pcorn[3].x+2*dx;
       Pl.pol[pl.n].y:=pcorn[3].y+dy;
       dm_Add_Poly(string2code('A0100002'),2,0,PL,false);

       tlBigframe.pol[0].y:=pcorn[1].y-2*dy;
       tlBigframe.pol[0].x:=pcorn[1].x-dx;
       tlBigframe.pol[1].y:=pcorn[4].y+2*dy;
       tlBigframe.pol[1].x:=pcorn[4].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);


 {
     dx:=round(1.6*kf);
     dy:=round(1.6*kf);
     TL.n:=4;
     TL.pol[0].x:=pcorn[1].x-dx;
     TL.pol[0].y:=pcorn[1].y-dy;
     TL.pol[1].x:=pcorn[2].x+dx;
     TL.pol[1].y:=pcorn[2].y-dy;
     TL.pol[2].x:=pcorn[3].x+dx;
     TL.pol[2].y:=pcorn[3].y+dy;
     TL.pol[3].x:=pcorn[4].x-dx;
     TL.pol[3].y:=pcorn[4].y+dy;
     TL.pol[4]:=TL.pol[0];

      res:=dm_Add_Poly(String2code('A0100002'),2,0,@TL,false);
    }
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

    //Номенклатура
      {
      a:=TLfr.pol[3];
      lcode:=String2Code('A0300100');
      lcodeINT:=String2Code('A0300102');
      Sint:=trim(fframe.edINT.Text);
      if Sint<>'' then Sint:='INT'+Sint;
      dint:=round(20*kf);
      dadm:=round(16*kf);
      dh:=12.0;
      a.y:=round(TLfr.pol[3].y+dh*kf);
      //нижний левый
      Add_Text(lcode,a,a,0,sadm,false);

      Text_Bound(lcode,a,a,R,sadm);
      if Sint<>'' then begin
      a.x:=TLfr.pol[3].x+R[2].x-R[1].x+dint;
      Add_Text(lcodeINT,a,a,0,Sint,false);
      end;
      ladmlen:=R[2].x-R[1].x;
      lx:=ladmlen+Dadm;
      a.x:=TLfr.pol[2].x-lx;
      //нижний правый
      Add_Text(lcode,a,a,0,sadm,false);
      if Sint<>'' then begin
      Text_Bound(lcodeInt,a,a,R,sint);
      lIntlen:=R[2].x-R[1].x;

      a.x:=a.x-lIntlen-dint;
      Add_Text(lcodeINT,a,a,0,Sint,false);
      end;

      a.x:=TLfr.pol[0].x+lx;
      a.y:=round(TLfr.pol[0].y-dh*kf);

      b.x:=TLfr.pol[0].x+dadm;
      b.y:=a.y;
      //верхний левый
      Add_Text(lcode,a,b,0,sadm,false);
      if Sint<>'' then begin
       b.x:=a.x+dint;
       a.x:=a.x+lIntlen+dint;
       Add_Text(lcodeINT,a,b,0,Sint,false);
      end;

      a.x:=TLfr.pol[1].x;
      b.x:=TLfr.pol[1].x-ladmlen;
      //верхний правый
      Add_Text(lcode,a,b,0,sadm,false);

      if Sint<>'' then begin
       a.x:=b.x-dint;
       b.x:=a.x-lIntlen;
       Add_Text(lcodeINT,a,b,0,Sint,false);
      end;
      }

       Mk_grad_net_on_Art;
       Kilometr_net;
       Kabeltov_net;
       gauss_net_on_Art;

//  end;
  // Center_bottom_text;
 Result:=true;

end;

procedure TFArt.Button2Click(Sender: TObject);
var
  ss,ss2:shortstring;
   lcode,lcode2,lc2,Centre,l1,l2,lr,dadm,ladmlen:longint;
   i,iscale,ll,dmdist,icode,iloc,itype,ilayout:integer;
   fx,fy,fw,dh:single;

   a,b:lpoint;
   R:lorient;
   Year, Month, Day, lDF, lDN, dx, dy:longint;
   st:shortstring;
   pc:pchar;
begin
 Decimalseparator:='.';
 if Frame_art then begin
  nodecurr:=dm_object;
 //Номенклатура
      a:=TLfr.pol[3];
      lcode:=String2Code('A0300100');
      lc2:=String2Code('A0300102');

      dadm:=round(16*kf);
      dh:=12.0;
      a.y:=round(TLfr.pol[3].y+dh*kf);
      //нижний левый
       Text_Bound(lcode,a,a,R,sadm);
      ladmlen:=R[2].x-R[1].x;

      Add_Text(lcode,a,a,0,sadm,false);
      a.x:=a.X+ladmlen;
      Add_Text(lc2,a,a,0,'-K',false);

      lx:=ladmlen+Dadm;
      a.x:=TLfr.pol[2].x-lx;
      //нижний правый
      Add_Text(lcode,a,a,0,sadm,false);
      a.x:=a.X+ladmlen;
      Add_Text(lc2,a,a,0,'-K',false);

      b.x:=TLfr.pol[0].x+lx;
      a.y:=round(TLfr.pol[0].y-7*kf);

      a.x:=TLfr.pol[0].x+dadm;
      b.y:=a.y;
      //верхний левый
      Add_Text(lcode,b,a,0,sadm,false);
      a.x:=a.X-ladmlen;
      b.x:=b.x-ladmlen;

      Add_Text(lc2,b,a,0,'-K',false);

      b.x:=TLfr.pol[1].x;
      a.x:=TLfr.pol[1].x-ladmlen;
      //верхний правый
      Add_Text(lcode,b,a,0,sadm,false);
      a.x:=a.X-ladmlen;
      b.x:=b.x-ladmlen;

      Add_Text(lc2,b,a,0,'-K',false);
     {
       a.x:=round(TLfr.pol[0].x+51*kf);

       a.y:=round(TLfr.pol[0].y-7*kf);

      lcode:=String2Code('A0400310');
      Add_Text(lcode,a,a,0,'НЕ ДЛЯ НАВИГАЦИОННЫХ ЦЕЛЕЙ',false);
      }

      a.y:=TLfr.pol[3].y+round(4.0*kf);


      leftmaker:=pcorn[3].x;
      rightmaker:=pcorn[4].x;

      if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin
       Centre:= (tlfr.pol[2].x+tlfr.pol[3].x) div 2;
      lcode:=String2Code('A0400510');

      a.x:=Centre;
      for i:=1 to fFrame.Memmaker.Lines.Count do begin
      ss:=fFrame.Memmaker.Lines[i-1];
      if i=fFrame.Memmaker.Lines.Count then
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
     if (fFrame.CboxLang.itemindex=1)or(fFrame.CboxLang.itemindex=2) then begin
      if fFrame.CboxLang.itemindex=1 then
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
      for i:=1 to fFrame.MemmakerE.Lines.Count do begin
      ss:=fFrame.MemmakerE.Lines[i-1];
       if i=fFrame.MemmakerE.Lines.Count then
         lcode:=String2Code('A0400531');
     Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      b.y:=a.y;
      if fFrame.CboxLang.itemindex=1 then begin

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
      if not dm_get_long(922,0,lDN) then lDN:=0;
      Set_active_map(1,true);
      dm_Goto_node(nodecurr);
      if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin

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
       if fFrame.CboxLang.itemindex=2 then begin
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
       if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin

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
       if fFrame.CboxLang.itemindex=2 then begin
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

      if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin
       ss:='Отпечатано в '+fframe.edPrint.text+'г.';
       lcode:=String2Code('A0400420');
       b.x:=tlfr.pol[2].x-round(50.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.x:=b.x-R[2].x+R[1].x;
       a.y:=b.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if fFrame.CboxLang.itemindex=2 then begin
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

       if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin

         ss:='Заказ';
       lcode:=String2Code('A0400420');
       b.x:=a.x-round(18.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.y:=b.y;
       a.x:=b.x-R[2].x+R[1].x;
       ss:=ss+' '+fFrame.edOrder.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if fFrame.CboxLang.itemindex=2 then begin
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
       ss:=ss+' '+fFrame.edOrder.text;
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
      lcode:=String2Code('A0400410');
      ss:='d='+Formatfloat('0.0',SQRT(SQR((pcorn[2].x-pcorn[1].x)/kf)+
                  SQR((pcorn[3].y-pcorn[2].y)/kf)))+'мм';
      Text_Bound(lcode,a,a,R,ss);
      a.x:=round(tlfr.pol[2].x-R[2].x+R[1].x-160*kf);
      a.y:=tlfr.pol[2].y+round(45*kf);
      Add_Text(lcode,a,a,0,ss,false);

      Decimalseparator:='.';

       //цветные плашки
      case FFrame.RGcolorScale.ItemIndex  of
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
         Lcode:=String2Code(FFrame.MeColorSign.EditText);
         a.X:= tlfr.pol[2].x+round(kf);
         b.X:= a.X;
         a.Y:=pcorn[3].y;
         b.Y:=pcorn[3].y-round(kf);
         dm_add_sign(Lcode,a,b,0,false)
      end;
      end;
 {
  if ChbAddtxt.Checked and FtuneZaram.ADOConnFrame.connected then with FtuneZaram do begin
    adods_frame.First;
    while not adods_frame.eof do begin
     fx:=adods_frame.fieldbyname('Горизонтально').asFloat;
     fy:=adods_frame.fieldbyname('Вертикально').asFloat;
     icode:=String2Code(adods_frame.fieldbyname('КОД').asString);
     iloc:=adods_frame.fieldbyname('ТИП').asInteger;
     if iloc=2 then begin
          dx:=round(fx*kf);
         dy:=round(fy*kf);
     TL.n:=4;
     TL.pol[0].x:=pcorn[1].x-dx;
     TL.pol[0].y:=pcorn[1].y-dy;
     TL.pol[1].x:=pcorn[2].x+dx;
     TL.pol[1].y:=pcorn[2].y-dy;
     TL.pol[2].x:=pcorn[3].x+dx;
     TL.pol[2].y:=pcorn[3].y+dy;
     TL.pol[3].x:=pcorn[4].x-dx;
     TL.pol[3].y:=pcorn[4].y+dy;
     TL.pol[4]:=TL.pol[0];
     dm_Add_Poly(icode,2,0,@TL,false);
     end else if iloc=4 then begin
     itype:=adods_frame.fieldbyname('ID_TYPE').asInteger;
     iLayout:=adods_frame.fieldbyname('ID_LAYOUT').asInteger;
     st:=adods_frame.fieldbyname('Текст').asString;
     st[byte(st[0])+1]:=#0;
     pc:=strpos(@st[1],'@N@');
     if assigned(pc) then begin
      st:=stringReplace(st,'@N@',Sadm,[rfReplaceAll])
     end;
     if st<>'' then begin
     a:=Tlfr.pol[0];
     Text_Bound(icode,a,a,R,st);
     lr:=R[2].x-R[1].x;
     case itype of
      0,1: begin //Слева вверху
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x+round(fx*kf);
              a.y:=Tlfr.pol[0].y-round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+lr;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x+round(fx*kf);
              b.y:=Tlfr.pol[0].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x+round(fx*kf)+(lr) div 2;
              b.y:=Tlfr.pol[0].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            end;
           end;
      2:  begin //Справа вверху
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x-round(fx*kf);
              a.y:=Tlfr.pol[1].y-round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+lr;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x-round(fx*kf);
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x-round(fx*kf)+(lr) div 2;
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            end;
           end;
      3:   begin //По центру вверху
            case ilayout of
            0,1: begin a.x:=(Tlfr.pol[0].x+Tlfr.pol[1].x) div 2+round(fx*kf);
              a.y:=Tlfr.pol[1].y-round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+lr;
             end;
            2: begin
              b.x:=(Tlfr.pol[0].x+Tlfr.pol[1].x) div 2+round(fx*kf);
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            3: begin
              b.x:=(Tlfr.pol[0].x+Tlfr.pol[1].x) div 2+round(fx*kf)+(lr) div 2;
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            end;
           end;
      4:  begin //Слева снизу
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[3].x+round(fx*kf);
              a.y:=Tlfr.pol[3].y+round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+lr;
             end;
            2: begin
              b.x:=Tlfr.pol[3].x+round(fx*kf);
              b.y:=Tlfr.pol[3].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x+round(fx*kf)+(lr) div 2;
              b.y:=Tlfr.pol[3].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            end;
           end;
      5:   begin //Справа вверху
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[2].x-round(fx*kf);
              a.y:=Tlfr.pol[2].y+round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+lr;
             end;
            2: begin
              b.x:=Tlfr.pol[2].x-round(fx*kf);
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            3: begin
              b.x:=Tlfr.pol[2].x-round(fx*kf)+(lr) div 2;
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            end;
           end;
      6: begin //По центру внизу
            case ilayout of
            0,1: begin a.x:=(Tlfr.pol[2].x+Tlfr.pol[3].x) div 2+round(fx*kf);
              a.y:=Tlfr.pol[2].y+round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+lr;
             end;
            2: begin
              b.x:=(Tlfr.pol[2].x+Tlfr.pol[3].x) div 2+round(fx*kf);
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            3: begin
              b.x:=(Tlfr.pol[2].x+Tlfr.pol[3].x) div 2+round(fx*kf)+(lr) div 2;
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-lr;
            end;
            end;
           end;
          7: begin //С левого боку внизу вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[3].x-round(fx*kf);
              a.y:=Tlfr.pol[3].y-round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           8: begin //С левого боку вверху вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=Tlfr.pol[0].y+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           9: begin //С левого боку по центру вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;

           10: begin //С левого боку внизу вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[3].x-round(fx*kf);
              a.y:=Tlfr.pol[3].y-round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           11: begin //С левого боку вверху вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=Tlfr.pol[0].y+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           12: begin //С левого боку по центру вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;

           13: begin //С правого боку внизу вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[2].x+round(fx*kf);
              a.y:=Tlfr.pol[2].y-round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[2].x+round(fx*kf);
              b.y:=Tlfr.pol[2].y-round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x+round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           14: begin //С правого боку вверху вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=Tlfr.pol[1].y+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           15: begin //С правого боку по центру вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;

           16: begin //С правого боку внизу вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[2].x+round(fx*kf);
              a.y:=Tlfr.pol[2].y-round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[2].x+round(fx*kf);
              b.y:=Tlfr.pol[2].y-round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[2].x+round(fx*kf);
              b.y:=Tlfr.pol[2].y-round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           17: begin //С правого боку вверху вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=Tlfr.pol[1].y+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           18: begin //С правого боку по центру вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
        end;
             Add_Text(icode,a,b,0,st,false);

     end
     end else if iloc=1 then begin
     itype:=adods_frame.fieldbyname('ID_TYPE').asInteger;
     iLayout:=adods_frame.fieldbyname('ID_LAYOUT').asInteger;
     a:=Tlfr.pol[0];
     Sign_Bound(icode,a,a,R);
     case itype of
      0,1: begin //Слева вверху
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x+round(fx*kf);
              a.y:=Tlfr.pol[0].y-round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+R[2].x-R[1].x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x+round(fx*kf);
              b.y:=Tlfr.pol[0].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x+round(fx*kf)+(R[2].x-R[1].x) div 2;
              b.y:=Tlfr.pol[0].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            end;
           end;
      2:  begin //Справа вверху
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x-round(fx*kf);
              a.y:=Tlfr.pol[1].y-round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+R[2].x-R[1].x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x-round(fx*kf);
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x-round(fx*kf)+(R[2].x-R[1].x) div 2;
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            end;
             end;
      3:   begin //По центру вверху
            case ilayout of
            0,1: begin a.x:=(Tlfr.pol[0].x+Tlfr.pol[1].x) div 2+round(fx*kf);
              a.y:=Tlfr.pol[1].y-round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+R[2].x-R[1].x;
             end;
            2: begin
              b.x:=(Tlfr.pol[0].x+Tlfr.pol[1].x) div 2+round(fx*kf);
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            3: begin
              b.x:=(Tlfr.pol[0].x+Tlfr.pol[1].x) div 2+round(fx*kf)+(R[2].x-R[1].x) div 2;
              b.y:=Tlfr.pol[1].y-round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            end;
          end;
      4:  begin //Слева снизу
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[3].x+round(fx*kf);
              a.y:=Tlfr.pol[3].y+round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+R[2].x-R[1].x;
             end;
            2: begin
              b.x:=Tlfr.pol[3].x+round(fx*kf);
              b.y:=Tlfr.pol[3].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x+round(fx*kf)+(R[2].x-R[1].x) div 2;
              b.y:=Tlfr.pol[3].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            end;
            end;
      5:   begin //Справа вверху
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[2].x-round(fx*kf);
              a.y:=Tlfr.pol[2].y+round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+R[2].x-R[1].x;
             end;
            2: begin
              b.x:=Tlfr.pol[2].x-round(fx*kf);
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            3: begin
              b.x:=Tlfr.pol[2].x-round(fx*kf)+(R[2].x-R[1].x) div 2;
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            end;
           end;
      6: begin //По центру внизу
            case ilayout of
            0,1: begin a.x:=(Tlfr.pol[2].x+Tlfr.pol[3].x) div 2+round(fx*kf);
              a.y:=Tlfr.pol[2].y+round(fy*kf);
              b.y:=a.y;
              b.x:=a.x+R[2].x-R[1].x;
             end;
            2: begin
              b.x:=(Tlfr.pol[2].x+Tlfr.pol[3].x) div 2+round(fx*kf);
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            3: begin
              b.x:=(Tlfr.pol[2].x+Tlfr.pol[3].x) div 2+round(fx*kf)+(R[2].x-R[1].x) div 2;
              b.y:=Tlfr.pol[2].y+round(fy*kf);
              a.y:=b.y;
              a.x:=b.x-R[2].x+R[1].x;
            end;
            end;
           end;
        7: begin //С левого боку внизу вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[3].x-round(fx*kf);
              a.y:=Tlfr.pol[3].y-round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           8: begin //С левого боку вверху вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=Tlfr.pol[0].y+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           9: begin //С левого боку по центру вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;

           10: begin //С левого боку внизу вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[3].x-round(fx*kf);
              a.y:=Tlfr.pol[3].y-round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x-round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           11: begin //С левого боку вверху вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=Tlfr.pol[0].y+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=Tlfr.pol[0].y+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           12: begin //С левого боку по центру вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[0].x-round(fx*kf);
              a.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[0].x-round(fx*kf);
              b.y:=(Tlfr.pol[0].y+Tlfr.pol[3].y) div 2+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;

           13: begin //С правого боку внизу вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[2].x+round(fx*kf);
              a.y:=Tlfr.pol[2].y-round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[2].x+round(fx*kf);
              b.y:=Tlfr.pol[2].y-round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[3].x+round(fx*kf);
              b.y:=Tlfr.pol[3].y-round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           14: begin //С правого боку вверху вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=Tlfr.pol[1].y+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;
           15: begin //С правого боку по центру вверх
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              b.y:=a.y-lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf)-lr div 2;
              a.y:=b.y+lr;
              a.x:=b.x;
            end;
            end;
           end;

           16: begin //С правого боку внизу вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[2].x+round(fx*kf);
              a.y:=Tlfr.pol[2].y-round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[2].x+round(fx*kf);
              b.y:=Tlfr.pol[2].y-round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[2].x+round(fx*kf);
              b.y:=Tlfr.pol[2].y-round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           17: begin //С правого боку вверху вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=Tlfr.pol[1].y+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=Tlfr.pol[1].y+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;
           end;
           18: begin //С правого боку по центру вниз
            case ilayout of
            0,1: begin a.x:=Tlfr.pol[1].x+round(fx*kf);
              a.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              b.y:=a.y+lr;
              b.x:=a.x;
             end;
            2: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf);
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            3: begin
              b.x:=Tlfr.pol[1].x+round(fx*kf);
              b.y:=(Tlfr.pol[1].y+Tlfr.pol[2].y) div 2+round(fy*kf)+lr div 2;
              a.y:=b.y-lr;
              a.x:=b.x;
            end;
            end;

           end;

     end;
     dm_Add_sign(icode,a,b,0,false);

     end;
    adods_frame.next;
    end;
  end;
  }
  (*
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
      if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin
        ss:='Система МАМС';
        lcode:=String2Code('A0400212');
        a.x:=tlfr.pol[3].x+round(180*kf);
        a.y:=TLfr.pol[3].y+round(5.2*kf);
        nodecurr:=Add_Text(lcode,a,a,0,ss,false);
        case fFrame.CmBxMAMS.ItemIndex of
         0:ss:='(регион А-красный слева)';
         1:ss:='(регион Б-красный справа)';
        end;
        lcode:=String2Code('A0400222');
        a.y:=TLfr.pol[3].y+round(8*kf);
        nodecurr:=Add_Text(lcode,a,a,0,ss,false);
      end;
     if (fFrame.CboxLang.itemindex=1)or(fFrame.CboxLang.itemindex=2) then begin
      ss:='IALA System';
      lcode:=String2Code('A0400211');
      a.x:=tlfr.pol[3].x+round(180*kf);
    if fFrame.CboxLang.itemindex=2 then
      a.y:=a.y+round(5.2*kf);
     nodecurr:=Add_Text(lcode,a,a,0,ss,false);
      case fFrame.CmBxMAMS.ItemIndex of
       0:ss:='Region A (Red to Port)';
       1:ss:='Region B (Red from Port)';
      end;
      lcode:=String2Code('A0400221');
      a.y:=a.y+round(3.3*kf);
      nodecurr:=Add_Text(lcode,a,a,0,ss,false);
     end;

       //Подпись "Главное управление..."


     a.y:=TLfr.pol[3].y+round(4.0*kf);
      leftmaker:=pcorn[3].x;
      rightmaker:=pcorn[4].x;

      if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin
       Centre:= (tlfr.pol[2].x+tlfr.pol[3].x) div 2;
      lcode:=String2Code('A0400510');

      a.x:=Centre;
      for i:=1 to fFrame.Memmaker.Lines.Count do begin
      ss:=fFrame.Memmaker.Lines[i-1];
      if i=fFrame.Memmaker.Lines.Count then
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
     if (fFrame.CboxLang.itemindex=1)or(fFrame.CboxLang.itemindex=2) then begin
      if fFrame.CboxLang.itemindex=1 then
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
      for i:=1 to fFrame.MemmakerE.Lines.Count do begin
      ss:=fFrame.MemmakerE.Lines[i-1];
       if i=fFrame.MemmakerE.Lines.Count then
         lcode:=String2Code('A0400531');
     Text_Bound(lcode,a,a,R,ss);
      a.x:=round(centre+(-R[2].x+R[1].x) div 2);
      b.x:=round(centre+(R[2].x-R[1].x) div 2);
      b.y:=a.y;
      if fFrame.CboxLang.itemindex=1 then begin

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
      if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin

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
       if fFrame.CboxLang.itemindex=2 then begin
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
       if (fFrame.CboxLang.itemindex=0)or(fFrame.CboxLang.itemindex=2) then begin

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
       if fFrame.CboxLang.itemindex=2 then begin
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

      if (Fframe.CboxLang.itemindex=0)or(Fframe.CboxLang.itemindex=2) then begin
       ss:='Отпечатано в '+fframe.edPrint.text+'г.';
       lcode:=String2Code('A0400420');
       b.x:=tlfr.pol[2].x-round(50.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.x:=b.x-R[2].x+R[1].x;
       a.y:=b.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if fFrame.CboxLang.itemindex=2 then begin
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

       if (fframe.CboxLang.itemindex=0)or(fframe.CboxLang.itemindex=2) then begin

         ss:='Заказ';
       lcode:=String2Code('A0400420');
       b.x:=a.x-round(18.0*kf);
       b.y:=tlfr.pol[2].y+round(4.0*kf);
       Text_Bound(lcode,b,b,R,ss);
       a.y:=b.y;
       a.x:=b.x-R[2].x+R[1].x;
       ss:=ss+' '+fframe.edOrder.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if fframe.CboxLang.itemindex=2 then begin
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
       ss:=ss+' '+fframe.edOrder.text;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       end;

       if fframe.edEkuatorScale.text<>'' then begin
       if (fframe.CboxLang.itemindex=0)or(fframe.CboxLang.itemindex=2) then begin
       ss:='Масштаб по экватору 1:'+fframe.edEkuatorScale.text;
       lcode:=String2Code('A0400420');
       a.x:=tlfr.pol[0].x+round(50.0*kf);
       a.y:=tlfr.pol[0].y-round(4.0*kf);
       Text_Bound(lcode,a,a,R,ss);
       b.x:=a.x+R[2].x-R[1].x;
       b.y:=a.y;
       nodecurr:=Add_Text(lcode,a,b,0,ss,false);
       if fframe.CboxLang.itemindex=2 then begin
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
      if fframe.RGcolorScale.ItemIndex= 0 then begin
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
      end else begin
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
   *)
    dmw_done;
 ShowMessage('Создано оформление');
 end
end;

procedure TFArt.Button3Click(Sender: TObject);
begin
FtuneZaram.show;
end;

procedure Sklonen(lb:lpoint;XX,YY,Orangle:double);
var
  a,b,ab:lpoint;
  kk:double;
  Tl1:tlline;
  sw:Widestring;
  ww:word;
begin
 if (XX>0) and (yy>0) then
      ab.x:=round(lb.x+5*kf)
    else if (XX<0) and (yy<0) then
      ab.x:=round(lb.x+13*kf)
      else
    ab.x:=round(lb.x+9*kf);
    ab.y:=lb.Y;
   a:=ab;
    b.x:=a.x;
    b.y:=round(a.y-24*kf);
    dm_add_sign(99000034,a,b,0,false);

    xxmax:=XX;
    YYmax:=YY;
    if (XX>0) and (YY<0) then begin
      XX:=Pi/12;
      yy:=-Pi/12;
    end else if (XX>0) and (yy<XX) then begin
      XX:=Pi/9;
      yy:=Pi/12;
      end else if (XX>0) and (yy>=XX) then begin
      YY:=Pi/9;
      XX:=Pi/12;
      end else if (XX<=0) and (yy>0) then begin
       XX:=-Pi/12;
       YY:=Pi/12;
    end else if (XX<=0) and (yy<XX) then begin
       XX:=-Pi/12;
       YY:=-Pi/9;
    end else if (XX<=0) and (yy>=XX) then begin
       XX:=-Pi/9;
       YY:=-Pi/12;
    end;
      kk:=24;
      b.x:=round(a.x+kk*kf*sin(XX));
      b.y:=round(a.y-kk*kf*cos(XX));
    dm_add_sign(99000035,a,b,0,false);

    ss:='D';
    TL1.n:=2;
     TL1.pol[0]:=a;
     TL1.pol[1].x:=a.x;
     if abs(XX)>abs(YY) then
      kk:=12
      else kk:=18;
       TL1.pol[1].y:=round(a.y-kk*kf);
       TL1.pol[2].x:=round(a.x+kk*kf*sin(XX));
       TL1.pol[2].y:=round(a.y-kk*kf*cos(XX));
      dm_Add_Poly(99000100,2,0,@TL1,false);

     if abs(XX)>abs(YY) then
      kk:=12.2
      else kk:=18.2;


     if kk=12.2 then begin
     a.x:=round(a.x+kk*kf*sin(0.33*XX));
     a.y:=round(a.y-kk*kf*cos(0.33*XX));
     end else begin
     a.x:=round(a.x+kk*kf*sin(0.5*XX));
     a.y:=round(a.y-kk*kf*cos(0.5*XX));
     end;
     if kk=12.2 then begin
        b.x:=round(a.x+1000*cos(0.33*XX));
        b.y:=round(a.y+1000*sin(0.33*XX));
     end else begin
        b.x:=round(a.x+1000*cos(XX*0.5));
        b.y:=round(a.y+1000*sin(XX*0.5));
     end;
     Text_Bound(99000080,a,b,R,ss);
     a.x:=a.x-(R[2].x-R[1].x) div 2 ;
     a.y:=a.y-(R[2].y-R[1].y) div 2;
    add_text(99000080,a,b,0,ss,false);
    a:=ab;
    ss:='Y';
    TL1.n:=2;
    TL1.pol[0]:=a;
    TL1.pol[1].x:=a.x;
    if abs(XX)>abs(YY) then
      kk:=18
      else if XX*YY >0 then
      kk:=12 else
      kk:=21;
     TL1.pol[1].y:=round(a.y-kk*kf);
     TL1.pol[2].x:=round(a.x+kk*kf*sin(yy));
     TL1.pol[2].y:=round(a.y-kk*kf*cos(yy));
    dm_Add_Poly(99000100,2,0,@TL1,false);
      kk:=24;

    b.x:=round(a.x+kk*kf*sin(YY));
    b.y:=round(a.y-kk*kf*cos(YY));
    dm_add_sign(99000036,a,b,0,false);
    if abs(XX)>abs(YY) then
      kk:=18.2
      else if XX*YY >0 then
      kk:=12.2 else
      kk:=21.2;


     a.x:=round(a.x+kk*kf*sin(0.5*yy));
     a.y:=round(a.y-kk*kf*cos(0.5*yy));
     lx:=round(1000*cos(yy*0.5));
     ly:=round(1000*sin(yy*0.5));
     b.x:=a.x+lx;
     b.y:=a.y+ly;
     Text_Bound(99000080,a,b,R,ss);
     a.x:=a.x-(R[2].x-R[1].x) div 2;
     a.y:=a.y-(R[2].y-R[1].y) div 2;
    add_text(99000080,a,b,0,ss,false);
    sw:='Y'#0;
    ww:=308;
    move(ww,sw[1],2);
    dm_Put_Unicode(9,@sw[1]);

    a:=ab;
    ss:='A';
    if XX*YY>0 then

    kk:=21
    else
    kk:=13;
    TL1.n:=2;
     TL1.pol[0]:=a;
     TL1.pol[1].x:=round(a.x+kk*kf*sin(xx));
     TL1.pol[1].y:=round(a.y-kk*kf*cos(xx));
     TL1.pol[2].x:=round(a.x+kk*kf*sin(yy));
     TL1.pol[2].y:=round(a.y-kk*kf*cos(yy));
    dm_Add_Poly(99000100,2,0,@TL1,false);
     if XX*YY>0 then

    kk:=21.2
    else
    kk:=13.2;

     if XX*YY<0 then begin
     a.x:=round(a.x+kk*kf*sin(0.5*xx));
     a.y:=round(a.y-kk*kf*cos(0.5*xx));
      lx:=round(1000*cos((xx)*0.5));
      ly:=round(1000*sin((xx)*0.5));

     end else begin
      a.x:=round(a.x+kk*kf*sin(0.5*(xx+yy)));
      a.y:=round(a.y-kk*kf*cos(0.5*(xx+yy)));
      lx:=round(1000*cos((xx+yy)*0.5));
      ly:=round(1000*sin((xx+yy)*0.5));
     end;
     b.x:=a.x+lx;
     b.y:=a.y+ly;
     Text_Bound(99000080,a,b,R,ss);
     a.x:=a.x-(R[2].x-R[1].x) div 2;
     a.y:=a.y-(R[2].y-R[1].y) div 2;
     add_text(99000080,a,b,0,ss,false);
     sw:='A'#0;
    ww:=307;
    move(ww,sw[1],2);
     dm_Put_Unicode(9,@sw[1]);

end;
procedure TFArt.Button4Click(Sender: TObject);
var atb:lpoint;
    g:tgauss;
 codel,lx1,lx2:longint;
 ss,ss2:shortstring;
 pch,pn:pchar;
 sw:widestring;
 ww:word;
begin
getmem(pch,255);
pn:=dmw_ProjectMap(1,pch,80);
if pn=NIL then begin
  Freemem(pch,255);
  exit;
end else begin
  dmw_SwapMap(pch);
end;
if wm_Pickpoint(atb,g) then begin
 dmw_activeMap(pch,255);
 if dmw_open(pch,true)<>0 then begin
  kf:=dm_dist(1,1);
  dmx_find_frst_code(0,1);
  dm_Goto_last;
  codel:=99000010;
  PL^.Pol[0]:=atb;
  PL^.Pol[1].x:=atb.X+round(95*kf);
  PL^.Pol[1].y:=atb.y;
  PL^.Pol[2].x:=atb.X+round(95*kf);
  PL^.Pol[2].y:=atb.y+round(40*kf);
  PL^.Pol[3].x:=atb.X;
  PL^.Pol[3].y:=atb.y+round(40*kf);
  PL^.Pol[4]:= PL^.Pol[0];
  PL^.n:=4;
  dm_add_poly(99000010,2,0,pl,false);
  PL^.n:=1;

  PL^.Pol[0].x:=atb.X+round(18*kf);
  PL^.Pol[0].y:=atb.y;
  PL^.Pol[1].x:=PL^.Pol[0].x;
  PL^.Pol[1].y:=atb.y+round(30*kf);
  dm_add_poly(99000010,2,0,pl,true);

  PL^.Pol[0].x:=atb.X+round(40*kf);
  PL^.Pol[1].x:=PL^.Pol[0].x;
  dm_add_poly(99000010,2,0,pl,false);

  PL^.Pol[0].x:=atb.X+round(66*kf);
  PL^.Pol[1].x:=PL^.Pol[0].x;
  dm_add_poly(99000010,2,0,pl,false);

  PL^.Pol[0].x:=atb.X+round(78*kf);
  PL^.Pol[1].x:=PL^.Pol[0].x;
  dm_add_poly(99000010,2,0,pl,false);

  PL^.Pol[0].x:=atb.X+round(52*kf);
  PL^.Pol[1].x:=PL^.Pol[0].x;
  PL^.Pol[1].y:=atb.y+round(40*kf);

  dm_add_poly(99000010,2,0,pl,false);

  PL^.Pol[0].x:=atb.X+round(18*kf);
  PL^.Pol[0].y:=atb.y+round(7.5*kf);
  PL^.Pol[1].x:=atb.X+round(78*kf);
  PL^.Pol[1].y:=PL^.Pol[0].y;
  dm_add_poly(99000010,2,0,pl,false);

  PL^.Pol[0].y:=atb.y+round(15*kf);
  PL^.Pol[1].y:=PL^.Pol[0].y;
  dm_add_poly(99000010,2,0,pl,false);

  PL^.Pol[0].y:=atb.y+round(22.5*kf);
  PL^.Pol[1].y:=PL^.Pol[0].y;
  dm_add_poly(99000010,2,0,pl,false);

  PL^.Pol[0].x:=atb.X;
  PL^.Pol[0].y:=atb.y+round(30*kf);
  PL^.Pol[1].x:=atb.X+round(95*kf);
  PL^.Pol[1].y:=PL^.Pol[0].y;
  dm_add_poly(99000010,2,0,pl,false);
  ss:=meL0.EditText+'°'#0;
  PL^.n:=0;
  PL^.Pol[0].x:=atb.X+round(47*kf);
  PL^.Pol[0].y:=atb.y-round(3*kf);
  dm_add_Text(99000040,4,0,pl,@ss[1],false);
  dm_set_tag(20);

  PL^.n:=0;
  PL^.Pol[0].x:=atb.X+round(30*kf);
  PL^.Pol[0].y:=atb.y+round(3.75*kf);
  dm_add_Text(99000080,4,0,pl,'Меридианы',false);
  dm_set_tag(21);
   PL^.Pol[0].y:=atb.y+round(8.8*kf);
  dm_add_Text(99000080,4,0,pl,'Магнитное',false);
  dm_set_tag(21);
   PL^.Pol[0].y:=atb.y+round(11*kf);
  dm_add_Text(99000080,4,0,pl,'склонение',false);
  dm_set_tag(21);
  ss:='D('+edYear.Text+'г.)'+#0;
  PL^.Pol[0].y:=atb.y+round(13.5*kf);
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);
  PL^.Pol[0].y:=atb.y+round(16.2*kf);
  dm_add_Text(99000080,4,0,pl,'Сближение',false);
  dm_set_tag(21);

  PL^.Pol[0].y:=atb.y+round(18.5*kf);
  dm_add_Text(99000080,4,0,pl,'меридианов',false);
  dm_set_tag(21);
  PL^.Pol[0].y:=atb.y+round(20.8*kf);
  dm_add_Text(99000080,4,0,pl,'Y',false);
   sw:='Y'#0;
   ww:=308;
    move(ww,sw[1],2);
 dm_Put_Unicode(9,@sw[1]);
  dm_set_tag(21);

  PL^.Pol[0].y:=atb.y+round(23.8*kf);
  dm_add_Text(99000080,4,0,pl,'Ориентирный',false);
  dm_set_tag(21);

  PL^.Pol[0].y:=atb.y+round(26*kf);
  dm_add_Text(99000080,4,0,pl,'угол',false);
  dm_set_tag(21);

  PL^.Pol[0].y:=atb.y+round(28.5*kf);
  dm_add_Text(99000080,4,0,pl,'A = D - y',false);
     sw:='A = D - y'#0;
   ww:=307;
    move(ww,sw[1],2);
    ww:=308;
    move(ww,sw[9],2);

 dm_Put_Unicode(9,@sw[1]);

  dm_set_tag(21);

  ss:=MeL1d.EditText+'°';
  ss2:=MeL1m.EditText+'''';
  Text_Bound(99000080,atb,atb,R,ss);
  lx1:=R[2].x-R[1].x ;
  Text_Bound(99000090,atb,atb,R,ss2);
  lx2:=R[2].x-R[1].x ;

  PL^.Pol[0].x:=atb.X+round(46*kf)- (lx1+lx2) div 2;
  PL^.Pol[0].y:=atb.y+round(5*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  PL^.Pol[0].x:=PL^.Pol[0].x+lx1;
  ss2:=ss2+#0;

  dm_add_Text(99000090,4,0,pl,@ss2[1],false);

  ss:=MeL2d.EditText+'°';
  ss2:=MeL2m.EditText+'''';
  Text_Bound(99000080,atb,atb,R,ss);
  lx1:=R[2].x-R[1].x ;
  Text_Bound(99000090,atb,atb,R,ss2);
  lx2:=R[2].x-R[1].x ;

  PL^.Pol[0].x:=atb.X+round(58*kf)- (lx1+lx2) div 2;
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  PL^.Pol[0].x:=PL^.Pol[0].x+lx1;
  ss2:=ss2+#0;
  dm_add_Text(99000090,4,0,pl,@ss2[1],false);

  ss:=MeL3d.EditText+'°';
  ss2:=MeL3m.EditText+'''';
  Text_Bound(99000080,atb,atb,R,ss);
  lx1:=R[2].x-R[1].x ;
  Text_Bound(99000090,atb,atb,R,ss2);
  lx2:=R[2].x-R[1].x ;

  PL^.Pol[0].x:=atb.X+round(72*kf)- (lx1+lx2) div 2;
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  PL^.Pol[0].x:=PL^.Pol[0].x+lx1;
  ss2:=ss2+#0;
  dm_add_Text(99000090,4,0,pl,@ss2[1],false);



  ss:=edD1.Text+'°';

  PL^.Pol[0].x:=atb.X+round(46*kf);
  PL^.Pol[0].y:=atb.y+round(11.25*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=edD2.Text+'°';

  PL^.Pol[0].x:=atb.X+round(58*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=Edd3.Text+'°';

  PL^.Pol[0].x:=atb.X+round(72*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=edG1.Text+'°';

  PL^.Pol[0].x:=atb.X+round(46*kf);
  PL^.Pol[0].y:=atb.y+round(18.75*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=edG2.Text+'°';

  PL^.Pol[0].x:=atb.X+round(58*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=EdG3.Text+'°';

  PL^.Pol[0].x:=atb.X+round(72*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=edOr1.Text+'°';

  PL^.Pol[0].x:=atb.X+round(46*kf);
  PL^.Pol[0].y:=atb.y+round(26.25*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=edOr2.Text+'°';

  PL^.Pol[0].x:=atb.X+round(58*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);

  ss:=EdOr3.Text+'°';
  PL^.Pol[0].x:=atb.X+round(72*kf);
  ss:=ss+#0;
  dm_add_Text(99000080,4,0,pl,@ss[1],false);
  dm_set_tag(21);
  PL^.Pol[0].x:=atb.X+round(5*kf);
  PL^.Pol[0].y:=atb.y+round(33*kf);
  PL^.Pol[1].x:=atb.X+round(17*kf);
  PL^.Pol[1].y:=PL^.Pol[0].y;
  dm_add_sign(99000034,Pl^.pol[0],Pl^.pol[1],0,false);
  PL^.Pol[0].y:=atb.y+round(35.5*kf);
  PL^.Pol[1].y:=PL^.Pol[0].y;
  dm_add_sign(99000035,Pl^.pol[0],Pl^.pol[1],0,false);
  PL^.Pol[0].y:=atb.y+round(38*kf);
  PL^.Pol[1].y:=PL^.Pol[0].y;
  dm_add_sign(99000036,Pl^.pol[0],Pl^.pol[1],0,false);

  PL^.Pol[0].x:=atb.X+round(21*kf);
  PL^.Pol[0].y:=atb.y+round(33*kf);
  dm_add_Text(99000070,4,0,pl,'Истинный меридиан',false);

  PL^.Pol[0].y:=atb.y+round(35.5*kf);
  dm_add_Text(99000070,4,0,pl,'Магнитный меридиан',false);

  PL^.Pol[0].y:=atb.y+round(38*kf);
  dm_add_Text(99000070,4,0,pl,'Линия килом. сетки',false);

  PL^.Pol[0].x:=atb.X+round(73*kf);
  PL^.Pol[0].y:=atb.y+round(35*kf);
  dm_add_Text(99000070,4,0,pl,'Все величины даны',false);
  dm_set_tag(20);

  PL^.Pol[0].x:=atb.X+round(73*kf);
  PL^.Pol[0].y:=atb.y+round(37*kf);
  dm_add_Text(99000070,4,0,pl,'для средней параллели карты',false);
  dm_set_tag(20);
  a.x:=atb.x;
  a.y:=atb.y+round(28*kf);

  try
  Sklonen(a,strtofloat(edd1.text),strtofloat(edG1.text),strtofloat(edOr1.text));
   except
   end;
 a.x:=atb.x+round(77*kf);
  try
  Sklonen(a,strtofloat(edd3.text),strtofloat(edG3.text),strtofloat(edOr3.text));
   except
   end;
 Showmessage('Таблица склонений создана');
 end;
end;
Freemem(pch,255);
end;

end.
