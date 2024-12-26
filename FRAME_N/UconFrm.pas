unit UconFrm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, iniFiles, FrNavyFun,NevaUtil, win_use,Dmw_ddw, dmw_Use, OTypes, geoidnw,
  ExtCtrls, MaskEdit;

type
  TFConus = class(TForm)
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
    Panel3: TPanel;
    ChBLeft: TCheckBox;
    ChbRight: TCheckBox;
    ChbTop: TCheckBox;
    ChBBottom: TCheckBox;
    Label1: TLabel;
    Button3: TButton;
    ChbAddtxt: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EdLeftNumber: TEdit;
    EdBottLetter: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FConus: TFConus;
  IniFile:TiniFile;
  MyFormatSettings : TFormatSettings;

implementation

uses UFrmnavy, nvunzarm;
var
  sadm:shortstring;
{$R *.lfm}

procedure TFConus.FormCreate(Sender: TObject);
begin
  MyFormatSettings := DefaultFormatSettings;
  with MyFormatSettings Do begin
     ShortDateFormat:='dd.mm.yy';
     LongDateFormat:='dd.mm.yyyy';
     DateSeparator:='.';
     decimalseparator:='.';
  end;

  IniFile:=TIniFile.Create(make_ini('FrameNavy.ini'));
  Height:=IniFile.ReadInteger('CONUSFRAME','CONUS_Height',420);
  Width:=IniFile.ReadInteger('CONUSFRAME','CONUS_Width',810);
  ChBLeft.Checked:=IniFile.ReadBool('CONUSFRAME','CHBLEFT',TRUE);
  ChbRight.Checked:=IniFile.ReadBool('CONUSFRAME','CHBRIGHT',TRUE);
  ChbTop.Checked:=IniFile.ReadBool('CONUSFRAME','CHBTOP',TRUE);
  ChBBottom.Checked:=IniFile.ReadBool('CONUSFRAME','CHBBOTTOM',TRUE);
    EdLeftNumber.Text:=IniFile.ReadString('CONUSFRAME','EdLeftNumber','1');
    EdBottLetter.Text:=IniFile.ReadString('CONUSFRAME','EdBottLetter','Т');

    meMDM.EditText:=IniFile.ReadString('CONUSINTERV','MDM','00');
    meMDS.EditText:=IniFile.ReadString('CONUSINTERV','MDS','00');
    meSmInD.EditText:=IniFile.ReadString('CONUSINTERV','SmInD','00');
    meSmInM.EditText:=IniFile.ReadString('CONUSINTERV','SmInM','00');
    meSmInS.EditText:=IniFile.ReadString('CONUSINTERV','SmInS','00');
    
    meIntrD.EditText:=IniFile.ReadString('CONUSINTERV','IntrD','00');
    meIntrM.EditText:=IniFile.ReadString('CONUSINTERV','IntrM','00');
    meIntrS.EditText:=IniFile.ReadString('CONUSINTERV','IntrDS','00');
    meBigIntrD.EditText:=IniFile.ReadString('CONUSINTERV','BigIntrD','00');
    meBigIntrM.EditText:=IniFile.ReadString('CONUSINTERV','BigIntrM','00');
    meBigIntrS.EditText:=IniFile.ReadString('CONUSINTERV','BigIntrS','00');
    meTextIntrD.EditText:=IniFile.ReadString('CONUSINTERV','TextIntrD','00');
    meTextIntrM.EditText:=IniFile.ReadString('CONUSINTERV','TextIntrM','00');
    meTextIntrS.EditText:=IniFile.ReadString('CONUSINTERV','TextIntrS','00');
    meShrafD.EditText:=IniFile.ReadString('CONUSINTERV','ShrafD','00');
    meShrafM.EditText:=IniFile.ReadString('CONUSINTERV','ShrafM','00');
    meShrafS.EditText:=IniFile.ReadString('CONUSINTERV','ShrafS','00');

    meMDM_L.EditText:=IniFile.ReadString('CONUSINTERV','MDM_L','00');
    meMDS_L.EditText:=IniFile.ReadString('CONUSINTERV','MDS_L','00');
    meSmInD_L.EditText:=IniFile.ReadString('CONUSINTERV','SmInD_L','00');
    meSmInM_L.EditText:=IniFile.ReadString('CONUSINTERV','SmInM_L','00');
    meSmInS_L.EditText:=IniFile.ReadString('CONUSINTERV','SmInS_L','00');

    meIntrD_L.EditText:=IniFile.ReadString('CONUSINTERV','IntrD_L','00');
    meIntrM_L.EditText:=IniFile.ReadString('CONUSINTERV','IntrM_L','00');
    meIntrS_L.EditText:=IniFile.ReadString('CONUSINTERV','IntrDS_L','00');
    meBigIntrD_L.EditText:=IniFile.ReadString('CONUSINTERV','BigIntrD_L','00');
    meBigIntrM_L.EditText:=IniFile.ReadString('CONUSINTERV','BigIntrM_L','00');
    meBigIntrS_L.EditText:=IniFile.ReadString('CONUSINTERV','BigIntrS_L','00');
    meTextIntrD_L.EditText:=IniFile.ReadString('CONUSINTERV','TextIntrD_L','00');
    meTextIntrM_L.EditText:=IniFile.ReadString('CONUSINTERV','TextIntrM_L','00');
    meTextIntrS_L.EditText:=IniFile.ReadString('CONUSINTERV','TextIntrS_L','00');
    meShrafD_L.EditText:=IniFile.ReadString('CONUSINTERV','ShrafD_L','00');
    meShrafM_L.EditText:=IniFile.ReadString('CONUSINTERV','ShrafM_L','00');
    meShrafS_L.EditText:=IniFile.ReadString('CONUSINTERV','ShrafS_L','00');
    ChbAddtxt.Checked:=IniFile.ReadBool('CONUSFRAME','ChbAddtxt',true);

IniFile.free
end;

procedure TFConus.FormDestroy(Sender: TObject);
begin
IniFile:=TIniFile.Create(make_ini('FrameNavy.ini'));

IniFile.WriteBool('CONUSFRAME','CHBLEFT',ChBLeft.Checked);
IniFile.WriteBool('CONUSFRAME','CHBRIGHT',ChbRight.Checked);
IniFile.WriteBool('CONUSFRAME','CHBTOP',ChbTop.Checked);
IniFile.WriteBool('CONUSFRAME','CHBBOTTOM',ChBBottom.Checked);

IniFile.WriteInteger('FRAME','CONUS_Height',Height);
IniFile.WriteInteger('FRAME','CONUS_Width',Width);
 IniFile.WriteString('CONUSFRAME','EdLeftNumber',EdLeftNumber.Text);
 IniFile.WriteString('CONUSFRAME','EdBottLetter',EdBottLetter.Text);

 IniFile.WriteString('CONUSINTERV','MDM',meMDM.EditText);
 IniFile.WriteString('CONUSINTERV','MDS',meMDS.EditText);
 IniFile.WriteString('CONUSINTERV','SmInD',meSmInD.EditText);
 IniFile.WriteString('CONUSINTERV','SmInM',meSmInM.EditText);
 IniFile.WriteString('CONUSINTERV','SmInS',meSmInS.EditText);
 IniFile.WriteString('CONUSINTERV','IntrD', meIntrD.EditText);
 IniFile.WriteString('CONUSINTERV','IntrM', meIntrM.EditText);
 IniFile.WriteString('CONUSINTERV','IntrDS',meIntrS.EditText);
 IniFile.WriteString('CONUSINTERV','BigIntrD',meBigIntrD.EditText);
 IniFile.WriteString('CONUSINTERV','BigIntrM',meBigIntrM.EditText);
 IniFile.WriteString('CONUSINTERV','BigIntrS',meBigIntrS.EditText);
 IniFile.WriteString('CONUSINTERV','TextIntrD',meTextIntrD.EditText);
 IniFile.WriteString('CONUSINTERV','TextIntrM',meTextIntrM.EditText);
 IniFile.WriteString('CONUSINTERV','TextIntrS', meTextIntrS.EditText);
 IniFile.WriteString('CONUSINTERV','ShrafD',meShrafD.EditText);
 IniFile.WriteString('CONUSINTERV','ShrafM', meShrafM.EditText);
 IniFile.WriteString('CONUSINTERV','ShrafS',meShrafS.EditText);

 IniFile.WriteString('CONUSINTERV','MDM_L',meMDM_L.EditText);
 IniFile.WriteString('CONUSINTERV','MDS_L',meMDS_L.EditText);
 IniFile.WriteString('CONUSINTERV','SmInD_L',meSmInD_L.EditText);
 IniFile.WriteString('CONUSINTERV','SmInM_L',meSmInM_L.EditText);
 IniFile.WriteString('CONUSINTERV','SmInS_L',meSmInS_L.EditText);
 IniFile.WriteString('CONUSINTERV','IntrD_L', meIntrD_L.EditText);
 IniFile.WriteString('CONUSINTERV','IntrM_L', meIntrM_L.EditText);
 IniFile.WriteString('CONUSINTERV','IntrDS_L',meIntrS_L.EditText);
 IniFile.WriteString('CONUSINTERV','BigIntrD_L',meBigIntrD_L.EditText);
 IniFile.WriteString('CONUSINTERV','BigIntrM_L',meBigIntrM_L.EditText);
 IniFile.WriteString('CONUSINTERV','BigIntrS_L',meBigIntrS_L.EditText);
 IniFile.WriteString('CONUSINTERV','TextIntrD_L',meTextIntrD_L.EditText);
 IniFile.WriteString('CONUSINTERV','TextIntrM_L',meTextIntrM_L.EditText);
 IniFile.WriteString('CONUSINTERV','TextIntrS_L', meTextIntrS_L.EditText);
 IniFile.WriteString('CONUSINTERV','ShrafD_L',meShrafD_L.EditText);
 IniFile.WriteString('CONUSINTERV','ShrafM_L', meShrafM_L.EditText);
 IniFile.WriteString('CONUSINTERV','ShrafS_L',meShrafS_L.EditText);
 IniFile.WriteBool('CONUSFRAME','ChbAddtxt',ChbAddtxt.Checked);

 IniFile.free
end;

procedure SET_CONUSINTERVALS;
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
         Shraf:=5;
         textinterv:=25;

         intermInterval:=25;
         Biginterval:=300;
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

procedure TFConus.Button1Click(Sender: TObject);
var
 BM:double;
 iscale:longint;
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
   Set_CONUSintervals;
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



procedure Make_gauss_net_on_Conus;
var
codeL,codes,codet,codeBig,codeKV:integer;
nHor, grad: integer;
dtg:tgauss;
a,b:lpoint;
kk,netGX,NetgY:extended;
sgrad:shortstring;
litera:char;
begin
//smInterv,intermInterval,Biginterval,tmindiv :longint;
  Tl1.n:=1;
  kk:=minDivL;
  codeL:=String2code('A0100102');
  codes:=String2Code('A0100103');
  codet:=String2Code('A0100050');
  codeBig:=String2Code('A0100060');
  codeKV:=String2Code('A0100030');
  nHor:=Strtoint(Fconus.EdLeftNumber.Text);
  if Fconus.EdBottLetter.text='' then
      litera:=UTF8ToAnsi('Т')[1]
  else
      litera:=Fconus.EdBottLetter.text[1];

    netGX:=50000;
    NetgY:=50000;
    dtg.y:=Corners[1].y;
    grad:=round(trunc(dtg.y/netgy)*netgy);
    dtg.y:=grad;
    //По координате у

    repeat
    dtg.x:=Corners[4].x;
    grad:=round(round(dtg.y/netgy)*netgy);


    dm_g_to_l(dtg.x,dtg.y,a.x,a.y);
    if (a.x>=pcorn[4].x) and (a.x<=pcorn[3].x) then begin
       Tl.Pol[0].X:=a.X;
       if fconus.chbbottom.Checked then begin
         Sgrad:=inttostr((grad div 1000) div 1000);
         Text_Bound(codet,a,a,R,Sgrad);
         b.x:=a.x-(R[2].x-R[1].x)-round(0.4*kf);
         b.y:=a.y+round(8*kf);
         Add_Text(codet,b,b,0,Sgrad,false);
         b.x:=a.x+round(0.2*kf);
         b.y:=a.y+round(9*kf);
         Sgrad:=Format('%3d',[((grad div 1000) mod 1000)]);
         Add_Text(codebig,b,b,0,Sgrad,false);
         Tl.Pol[0].y:=a.y+round(10.6*kf);
         dm_g_to_l(dtg.x,dtg.y+netgy,b.x,b.y);
         if b.x<=pcorn[3].x then begin

         b.y:=b.y+round(6*kf);
         Sgrad:=inttostr(nhor);
         Add_Text(codet,b,b,0,Sgrad,false);
         dm_set_tag(21);
         end;
       end else begin
         Tl.Pol[0].y:=a.y+round(2*kf);
       end;
      dtg.x:=Corners[1].x;
      dm_g_to_l(dtg.x,dtg.y,a.x,a.y);
      Tl.Pol[1].X:=a.X;

      if fconus.chbtop.Checked then begin
         Sgrad:=inttostr((grad div 1000) div 1000);
         Text_Bound(codet,a,a,R,Sgrad);
         b.x:=a.x-(R[2].x-R[1].x)-round(0.4*kf);
         b.y:=a.y-round(6*kf);
         Add_Text(codebig,b,b,0,Sgrad,false);
         b.x:=a.x+round(0.2*kf);
         b.y:=a.y-round(5*kf);
         Sgrad:=inttostr((grad div 1000) mod 1000);
         Add_Text(codebig,b,b,0,Sgrad,false);
         Tl.Pol[1].y:=a.y-round(10.6*kf);
          dm_g_to_l(dtg.x,dtg.y+netgy,b.x,b.y);

        if b.x<=pcorn[3].x then begin

         b.y:=b.y-round(6*kf);
         Sgrad:=inttostr(nhor);
         Add_Text(codet,b,b,0,Sgrad,false);
         dm_set_tag(21);
         end;

       end else begin
         Tl.Pol[1].y:=a.y-round(2*kf);
       end;
       Tl.N:=1;
       dm_add_poly(codel,2,0,@tl,false);

    end;
    dtg.y:=dtg.y+netgy;
    inc(nHor);
    until dtg.y>corners[3].y;

    dtg.x:=Corners[4].x;
    grad:=round(trunc(dtg.x/netgx)*netgx);
    dtg.x:=grad;
    //По координате у

    repeat
    dtg.y:=Corners[4].y;
    grad:=round(round(dtg.x/netgx)*netgx);


    dm_g_to_l(dtg.x,dtg.y,a.x,a.y);
    if (a.y<=pcorn[4].y) and (a.y>=pcorn[1].y) then begin
       Tl.Pol[0].y:=a.y;
       if fconus.chbleft.Checked then begin
         Sgrad:=inttostr((grad div 1000) div 1000);
         //Text_Bound(codet,a,a,R,Smin);
         b.x:=a.x-round(9*kf);
         b.y:=a.y-round(2*kf);
         Add_Text(codet,b,b,0,Sgrad,false);
         b.x:=a.x-round(6*kf);
         b.y:=a.y-round(kf);
         Sgrad:=Format('%3d',[((grad div 1000) mod 1000)]);
         Add_Text(codebig,b,b,0,Sgrad,false);
         Tl.Pol[0].x:=a.x-round(10.6*kf);
         dm_g_to_l(dtg.x+netgx,dtg.y,b.x,b.y);
        if b.y>=pcorn[1].y then begin
           b.x:=b.x-round(6*kf);
           Sgrad:=litera;
           Add_Text(codet,b,b,0,Sgrad,false);
           dm_set_tag(21);
         end;

       end else begin
         Tl.Pol[0].x:=a.x-round(2*kf);
       end;
      dtg.y:=Corners[3].y;
      dm_g_to_l(dtg.x,dtg.y,a.x,a.y);
      Tl.Pol[1].y:=a.y;

      if fconus.chbRight.Checked then begin
         Sgrad:=inttostr((grad div 1000) div 1000);
         //Text_Bound(codet,a,a,R,Smin);
         b.x:=a.x+round(2*kf);
         b.y:=a.y-round(2*kf);
         Add_Text(codet,b,b,0,Sgrad,false);
         b.x:=a.x+round(4.2*kf);
         b.y:=a.y-round(kf);
         Sgrad:=inttostr((grad div 1000) mod 1000);
         Add_Text(codebig,b,b,0,Sgrad,false);
         Tl.Pol[1].x:=a.x+round(10.6*kf);

         dm_g_to_l(dtg.x+netgx,dtg.y,b.x,b.y);

         if b.y>=pcorn[1].y then begin
           b.x:=b.x+round(6*kf);
           Sgrad:=litera;
           Add_Text(codet,b,b,0,Sgrad,false);
           dm_set_tag(21);
         end;
       end else begin
         Tl.Pol[1].x:=a.x+round(2*kf);
       end;
       Tl.N:=1;
       dm_add_poly(codel,2,0,@tl,false);
    end;
    dtg.x:=dtg.x+netgx;
    Litera:=Char(ord(litera)-1);

    until dtg.x>corners[1].x;





end;

procedure Mk_grad_net_on_Conus;
var
  node1,node,i,modI,codes,codet,codeBig, codel,nn,nNext,
  nlbdiv,grad2,Textgrad,TextgradL,sign,{smInterv,intermInterval,smIntervl,intermIntervall,}
  dh, offs,minlX,MaxlX,minlY,MaxlY:longint;
  ss,s:shortstring;
  sgrad,smin,ssec:s4;
  dtg, dtg2, tg:tgauss;
  yl,kk,yy,
  rr, rx,ry,{nlbnetorig_L,mindivl,}minX,MaxX,minY,MaxY:double;
  nlb,ly,lx1,lx2:longint;
  p,a,lp,lshraf1,lshraf2,b:lpoint;
  flend,flfirst,flGradNonEXist,res,flhalf, flten,flgrad,flGradinterv,fldown,flstrL:boolean;
  grad,min:integer;
  sec:extended;
  bmindiv,bf:byte;
  litera:char;
begin
  codel:=String2code('A0100002');
  codes:=String2Code('A0100003');
  codet:=String2Code('A0400320');
  codeBig:=String2Code('A0400310');
with Fframe do begin
  Textgrad:=round(strtoint(meTextIntrD.edittext)+strtoint(meTextIntrM.edittext)/60+strtoFloat(meTextIntrS.edittext, MyFormatSettings)/3600);
  TextgradL:=round(strtoint(meTextIntrD_l.edittext)+strtoint(meTextIntrM_l.edittext)/60+strtoFloat(meTextIntrS_l.edittext, MyFormatSettings)/3600);
end;
with Fconus do begin
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
    if dtg.y>PI then yl:=abs(dtg.y-2*Pi);
    Calc_grad_min_sec(dtg.y,sgrad,smin,ssec);
    s:=sgrad+smin+ssec;
    i:=0;
    dtg2:=dtg;
    dtg2.y:=dtg2.y-kk/2;
    dtg.x:=minx{rCorners[3].x}+yy;
    fldown:=false;
    node1:=0;
    {if round(dtg.y/(Bigintervall*mindivl)) mod 2=0 then begin
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
      res:= Point_in_Poly(P,@tlmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

          offs:=dm_Add_Poly(codel,2,0,PL,false);
        end;
         PL^.n:=0;
         PL^.pol[0]:=P;
      end;
      if res then
      if i mod Biginterval<>0 then begin
         flstrL:=true;
         modI:=i mod Biginterval;
         if modI=interminterval then dh:=3 else
         if (modI mod smInterv)=0 then dh:=2 else begin
          dh:=1;
          flstrL:=false
         end;
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

        dtg.x:=dtg.x+yy;
        // Конец создания текстов
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
    if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
      end;
     if PL^.n>1 then offs:=dm_Add_Poly(codel,2,0,PL,false);
     {if (Node1<>0) then begin
     dm_Move_Object(offs,node1,true);
        dm_Up_Childs(node1);

        dm_goto_node(offs);
    end; }

   dtg.y:=dtg.y+kk;
  end;


    Rad_grad(abs(Rcorners[2].y),grad,min,sec);
    if Rcorners[2].y>=0 then sign:=1 else sign:=-1;
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    grad2:=grad;
    flgrad:= Rcorners[1].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[1].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[1].y;
    Rad_grad(abs(dtg.y),grad,min,sec);

    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
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
    Rad_grad (abs(dtg.y),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[2].y-0.25*mindivl<dtg.y;

    if bf=0 then begin
    lshraf1.x:=a.x;
    lshraf1.y:=a.y-round(0.8*kf);
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
         ry:=(b.y-ry)/rr;

      if chbTop.checked then begin
        b.x:=a.x+round(rx*1.6*kf);
        b.y:=a.y-round(1.6*kf);
       dm_add_sign(codes,a,b,0,false);
     end;
      if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      if not chbTop.checked then  begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
       dm_add_sign(codes,a,b,0,false);
      end;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
      b.y:=a.y-round(5.2*kf);
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);


      end else if flgrad and (min=0) then begin
         if not chbTop.checked then  begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
       dm_add_sign(codes,a,b,0,false);
      end;

        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);

      end
      else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

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
         ry:=(b.y-ry)/rr;
       if chbTop.checked then begin

      b.x:=a.x+round(rx*1.6*kf);
      b.y:=a.y-round(1.6*kf);
         dm_add_sign(codes,a,b,0,false);
      end;
      if nlb mod textintervL = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if bmindiv=0 then bmindiv:=1;
       if not chbTop.checked then  begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
       dm_add_sign(codes,a,b,0,false);
      end;

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
        if not chbTop.checked then  begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
       dm_add_sign(codes,a,b,0,false);
      end;

        ss:=inttostr(grad);
        Text_Bound(codeBig,a,a,R,ss);
        b.x:=a.x-round((R[2].x-R[1].x)*0.5);
        b.y:=a.y-round(5.2*kf);
        ss:=ss+'°';
        Add_Text(codeBig,b,b,0,ss,false);

      end
      else begin

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y-round(5.2*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);

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
         ry:=(b.y-ry)/rr;
      if chbTop.checked then  begin

      b.x:=a.x+round(rx*1.6*kf);
      b.y:=a.y-round(1.6*kf);
      dm_add_sign(codes,a,b,0,false);
      end;
     end;

     if chbTop.checked and(nlb mod ShrafL = 0) then begin
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
           lshraf1.y:=a.y-round(0.8*kf);
         end
         else begin
           if a.x<>lshraf1.x then begin
           b.x:=a.x;
           b.y:=a.y-round(0.8*kf);

           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           Lshraf1.x:=0;
         end;
     end;
       if Rcorners[1].y>=0 then
      inc(nlb)
      else
      dec(nlb);

      dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivL;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.y:=pcorn[1].y;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg.y+mindivL;
      dtg.x:=dtg2.x;
     until rcorners[2].y+0.25*mindivL<dtg.y;

     if chbTop.checked and (lshraf1.x<>0) then begin
           dtg:=Rcorners[2];
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y-round(0.8*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
     end;

   // Конец верхних текстов


    Rad_grad(abs(Rcorners[3].y),grad,min,sec);
    if Rcorners[3].y>=0 then sign:=1 else sign:=-1;
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
    grad2:=grad;
    flgrad:= Rcorners[4].y<=sign*grad/180*pi;
    if not flgrad then begin
     min:=min - min mod 10;
     flten:=Rcorners[4].y<=sign*(grad+min/60)/180*pi;
    end;
    flfirst:=true;
    bmindiv:=0;
    dtg.y:=Rcorners[4].y;
    Rad_grad(abs(dtg.y),grad,min,sec);

    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;
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
    Rad_grad (abs(dtg.y),grad,min,sec);
    if sec>59.9 then begin sec:=0;
     if min=59 then begin inc(grad); min:=0 end else inc(min) end;

    dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
    flend:=rcorners[3].y-0.25*mindivl<dtg.y;
    if bf=0 then begin
    lshraf2.x:=a.x;
    lshraf2.y:=a.y+round(0.8*kf);
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
         ry:=(b.y-ry)/rr;
     if chbBottom.checked then begin

      b.x:=a.x+round(rx*1.6*kf);
      b.y:=a.y+round(1.6*kf);
      dm_add_sign(codes,a,b,0,false);
     end;
 if flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if not chbBottom.checked then begin

      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
     end;
      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;
      if bmindiv=0 then bmindiv:=1;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=a.y+round(7.6*kf);
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
      if not chbBottom.checked then begin

      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
     end;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y+round(7.6*kf);;
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
      if not chbBottom.checked then begin

      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
     end;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y+round(7.6*kf);;
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
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
      if chbBottom.checked then begin
        b.x:=a.x+round(rx*1.6*kf);
        b.y:=a.y+round(1.6*kf);
        dm_add_sign(codes,a,b,0,false);
      end;
 if nlb mod textintervL = 0 then
       if flGradNonEXist and flfirst and not flgrad  and ((flten and ((min mod 10)=0) or not flten)) then begin
      if bmindiv=0 then bmindiv:=1;
       flfirst:=false;
      if not chbBottom.checked then begin

      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
     end;

      Text_Bound(codebig,a,a,R,inttostr(grad)+'°');
      lx1:=R[2].x-R[1].x;

      Text_Bound(codet,a,a,R,inttostr(min)+'''');
      lx2:=R[2].x-R[1].x;
      b.x:=a.x-(lx1+lx2) div 2;
       b.y:=a.y+round(7.6*kf);;
      Add_Text(codebig,b,b,0,inttostr(grad)+'°',false);
      inc(b.x,lx1);
      Add_Text(codet,b,b,0,inttostr(min)+'''',false);
      inc(b.x,lx2);
      end else begin

      if flgrad and (min=0) then begin
      if bmindiv=0 then bmindiv:=1;
      if not chbBottom.checked then begin

      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
     end;

      ss:=inttostr(grad);
      Text_Bound(codeBig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y+round(7.6*kf);;
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
      if not chbBottom.checked then begin

      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
     end;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5);
      b.y:=a.y+round(7.6*kf);;
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
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
         ry:=(b.y-ry)/rr;
      if chbBottom.checked then begin


      b.x:=a.x+round(rx*1.6*kf);
      b.y:=a.y+round(1.6*kf);
      dm_add_sign(codes,a,b,0,false);
      end;
end;
     if chbBottom.checked and(nlb mod ShrafL = 0) then begin
         if dtg.y-0.5*mindivl>=0 then
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))
         else
         nlbdiv:=round(abs(dtg.y)/ (ShrafL*mindivl))+1;

         if nlbdiv mod 2 =0 then begin
           lshraf2.x:=a.x;
           lshraf2.y:=a.y+round(0.8*kf);
         end
         else begin
           if lshraf2.x<>a.x then begin
           b.x:=a.x;
           b.y:=a.y+round(0.8*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           Lshraf2.x:=0;
         end;
     end;

      if Rcorners[4].y>=0 then
      inc(nlb)
      else
      dec(nlb);
      dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivL;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.y:=pcorn[4].y;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg.y+mindivL;
      dtg.x:=dtg2.x;
  until rcorners[3].y+0.25*mindivl<dtg.y;

     if chbBottom.checked and (lshraf2.x<>0) then begin
          dtg:=Rcorners[3];
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.x:=a.x;
           b.y:=a.y+round(0.8*kf);
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
    // flstrL:=round(dtg.x/(Biginterval*mindiv)) mod 2=0;
    while maxy{rcorners[2].y}-dtg.y>1e-15 do begin
      inc(i);
      dm_R_to_L(dtg.x,dtg.y,P.x,P.y);
      res:= Point_in_Poly(P,@tlmain);
      if res then begin
      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
      if PL^.n=1 then begin
       line_neib(PL^.pol[0].x,PL^.pol[0].y,PL^.pol[0],PL^.pol[1],@Tlmain,nn,nNext);
       Set_Road_node(0,PL^.pol[0],PL^.pol[1],pl,@Tlmain,nn,Nnext);
     end;
      end else begin
        if PL^.N>1 then begin
          line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N-1],PL^.pol[PL^.N],@Tlmain,nn,nNext);
          Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);

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

      if res then
      if i mod BigIntervalL<>0 then begin
         flstrl:=true;
         modI:=i mod BigIntervalL;
         if modI=intermintervall then dh:=3 else
         if (modI mod smIntervl) =0 then dh:=2 else begin
          dh:=1;
          flstrl:=false;
         end;
         if (abs(P.X-pcorn[1].X)< round(kf)) or  (abs(P.X-pcorn[2].X)< round(kf)) then
           flstrl:=false;
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
    if Point_in_Poly(p,@tlmain) then begin

      inc(pl^.n);
      PL^.pol[PL^.n]:=P;
         line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@TlMain,nn,nNext);
         Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@TlMain,nn,Nnext);

      end else  begin
        line_neib(PL^.pol[PL^.N].x,PL^.pol[PL^.N].y,PL^.pol[PL^.N],PL^.pol[PL^.N-1],@Tlmain,nn,nNext);
           Set_Road_node(1,PL^.pol[PL^.N],PL^.pol[PL^.N-1],pl,@Tlmain,nn,Nnext);
//       Point_near_line(PL^.pol[PL^.n],50*kf,@tlmain,PL^.pol[PL^.n]);
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
     flend:=rcorners[1].x-0.25*kk<dtg.x;

    if bf=0 then begin
    lshraf1.y:=a.y;
    lshraf1.x:=a.x-round(0.8*kf);
    bf:=1;
    end;
    if nlb mod Biginterval = 0 then begin
      dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
      if chbLeft.checked then begin
      b.x:=a.x-round(1.6*kf);
      b.y:=a.y+round(ry*1.6*kf);
      dm_add_sign(codes,a,b,0,false);
      end;

   if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      if not chbLeft.checked then begin
      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
      end;

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

      end else if flgrad and (min=0) then begin
      if not chbLeft.checked then begin
      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
      end;

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

      end else if nlb mod interminterval = 0 then begin
           dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
       if chbLeft.checked then begin
      b.x:=a.x-round(1.6*kf);
      b.y:=a.y+round(ry*1.6*kf);
      dm_add_sign(codes,a,b,0,false);
      end;


  if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      if not chbLeft.checked then begin
      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
      end;

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

      end else begin
      if flgrad and (min=0) then begin
      if not chbLeft.checked then begin
      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
      end;

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      if not chbLeft.checked then begin
      b.x:=a.x+round(rx*5*kf);
      b.y:=a.y+round(ry*5*kf);
      dm_add_sign(codes,a,b,0,false);
      end;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5+6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;

    end else if nlb mod sminterv = 0 then begin
           dtg2.x:=dtg.x;
      dtg2.y:=dtg.y-mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
      if  chbLeft.checked then begin

      b.x:=a.x-round(1.6*kf);
      b.y:=a.y+round(ry*1.6*kf);
      dm_add_sign(codes,a,b,0,false);
      end;
end;
     if chbLeft.checked and (nlb mod Shraf = 0) then begin
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
           lshraf1.x:=a.x-round(0.8*kf);
         end
         else begin
           if lshraf1.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x-round(0.8*kf);
           dm_add_sign(codes,lshraf1,b,0,false);
           end;
           lshraf1.x:=0;
         end;
     end;
      dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.x:=pcorn[4].x;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg2.y;
      dtg.x:=dtg.x+mindiv;
        if Rcorners[4].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[1].x+0.25*mindiv<dtg.x;

     if chbLeft.checked and(lshraf1.x<>0) then begin
           dtg:=rcorners[1];
           dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x-round(0.8*kf);
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
    lshraf2.x:=a.x+round(0.8*kf);
    bf:=1;
    end;

    if nlb mod Biginterval = 0 then begin
          dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        if chbRight.checked  then begin
        b.x:=a.x+round(1.6*kf);
        b.y:=a.y+round(ry*1.6*kf);
        dm_add_sign(codes,a,b,0,false);
      end;

  if flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
       if not chbRight.checked  then begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
        dm_add_sign(codes,a,b,0,false);
      end;

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
      if not chbRight.checked  then begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
        dm_add_sign(codes,a,b,0,false);
      end;

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y-round(0.6*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      if not chbRight.checked  then begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
        dm_add_sign(codes,a,b,0,false);
      end;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y-round(0.6*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;

     end else if nlb mod interminterval = 0 then begin

         dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
       if  chbRight.checked  then begin

        b.x:=a.x+round(1.6*kf);
        b.y:=a.y+round(ry*1.6*kf);
      dm_add_sign(codes,a,b,0,false);
      end;
     if nlb mod textinterv = 0 then
      if flGradNonEXist and flfirst and not flgrad and ((flten and ((min mod 10)=0) or not flten)) then begin
      flfirst:=false;
      if not chbRight.checked  then begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
        dm_add_sign(codes,a,b,0,false);
      end;

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
      if not chbRight.checked  then begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
        dm_add_sign(codes,a,b,0,false);
      end;

      ss:=inttostr(grad);
      Text_Bound(codebig,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);

      b.y:=a.y+round(1.1*kf);
      ss:=ss+'°';
      Add_Text(codebig,b,b,0,ss,false);

      end else begin
      if not chbRight.checked  then begin
        b.x:=a.x+round(rx*5*kf);
        b.y:=a.y+round(ry*5*kf);
        dm_add_sign(codes,a,b,0,false);
      end;

      ss:=inttostr(min);
      Text_Bound(codet,a,a,R,ss);
      b.x:=a.x-round((R[2].x-R[1].x)*0.5-6.75*KF);
      b.y:=a.y+round(1.1*kf);
      ss:=ss+'''';
      Add_Text(codet,b,b,0,ss,false);
      end;
      end;
      
    end else if nlb mod sminterv = 0 then begin
          dtg2.x:=dtg.x;
      dtg2.y:=dtg.y+mindivl;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
         rx:=a.x;
         ry:=a.y;
         rr:=SQRT(SQR(rx-b.x)+SQR(ry-b.y));
         rx:=(b.x-rx)/rr;
         ry:=(b.y-ry)/rr;
        if  chbRight.checked  then begin

        b.x:=a.x+round(1.6*kf);
        b.y:=a.y+round(ry*1.6*kf);
      dm_add_sign(codes,a,b,0,false);
      end;
  end;
  if chbRight.checked and (nlb mod Shraf = 0) then begin

         if dtg.x-mindiv>=0 then
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))
         else
           nlbdiv:=round(abs(dtg.x)/ (Shraf*mindiv))+1;

         if nlbdiv mod 2 =1 then begin
           lshraf2.y:=a.y;
           lshraf2.x:=a.x+round(0.8*kf);
         end
         else begin
           if lshraf2.y<>a.y then begin
           b.y:=a.y;
           b.x:=a.x+round(0.8*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
           end;
           lshraf2.x:=0;
         end;
     end;

       dtg2.x:=dtg.x+mindiv;
      dtg2.y:=dtg.y;
      dm_R_to_L(dtg2.x,dtg2.y,b.x,b.y);
      b.x:=pcorn[3].x;
      dm_L_to_R(b.x,b.y,dtg2.x,dtg2.y);

      dtg.y:=dtg2.y;
      dtg.x:=dtg.x+mindiv;
       if Rcorners[3].x>=0 then
      inc(nlb)
        else
      dec(nlb);

     until rcorners[2].x+0.25*mindiv<dtg.x;
      if chbRight.checked and(lshraf2.x<>0) then begin
          dtg.x:=Rcorners[2].x;
          dm_R_to_l(dtg.x,dtg.y,a.x,a.y);
           b.y:=a.y;
           b.x:=a.x+round(0.8*kf);
           dm_add_sign(codes,lshraf2,b,0,false);
      end;
end;
end;

function Frame_Conus:boolean;
var
  a0,b0:lpoint;
  tg0,tg,tgr:tgauss;
  dx,dy,dxsm,dysm, dwline,i,res,ll,lx,dmdist:longint;
  R:lOrient;
  sdm:shortstring;
  st:shortstring;
  SaveDlg: TSaveDialog;
  i995,i996,i997:longint;
  w999,b901,b911:word;
  fl991,fl992,fl993:boolean;
begin
  Result:=false;
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
if b913<>4 then begin
showMessage('Карта не в конической равноугольной проекции');
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
 dm_Get_bound(a0,b0);
 dm_L_to_G(a0.x,a0.y,tg0.x,tg0.y);
 dm_L_to_G(b0.x,b0.y,tg.x,tg.y);

 corners[1]:=tg0;
 corners[2].x:=tg0.x;
 corners[2].y:=tg.y;

 corners[3]:=tg;
 corners[4].x:=tg.x;
 corners[4].y:=tg0.y;
 dm_L_to_R(a0.x,a0.y,tgr.x,tgr.y);

  if dmx_find_frst_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[4].x);
  Dm_Get_double(92,0,Rcorners[4].y);
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
  if dmx_find_next_code(0,1)=0 then begin
  Showmessage('Нет точек привязки');
   dmw_done;
   exit
  end;
  Dm_Get_double(91,0,Rcorners[3].x);
  Dm_Get_double(92,0,Rcorners[3].y);
 {Dm_Get_double(901,0,corners[3].x);
 Dm_Get_double(902,0,corners[3].y);
 }
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

 if dm_frame(@sdm[1],@st[1],0,dmdist,corners[4].x,corners[4].y,corners[1].x,corners[2].y)=0 then
    exit;


if  dmw_open(@sdm[1],true)=0 then exit;
  dm_goto_root;
 { dm_Get_bound(a0,b0);
  ShowMessage(floattostr(b0.x-a0.x));
  ShowMessage(floattostr(b0.y-a0.y));
  }
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

 dm_put_double(91,rcorners[i].x);
 dm_put_double(92,rcorners[i].y);
 dm_put_double(901,corners[i].x);
 dm_put_double(902,corners[i].y);

 if i=4 then
   i:=1
 else
   inc(i);
 until dmx_Find_Next_Code(0,1)=0;


 {if not fltopo then
 if dmx_Find_Frst_Code(0,1)<>0 then
 repeat
 dm_get_double(901,0,dh);
 dm_put_double(901,dh/10);
 dm_get_double(902,0,dh);
 dm_put_double(902,dh/10);
 until dmx_Find_Next_Code(0,1)=0;
 }

  dm_goto_root;


  dm_Get_poly_buf(PL,8000);
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
   with FConus do begin

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
     Tlmain.pol[i-1]:=pcorn[i];
     TlMain.pol[4]:=Tlmain.pol[0];
     TLmain.n:=4;
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
    // ii[0]:=0;
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
  {   ii[1]:=1;
     ii[2]:=2;
     ii[3]:=3;
     ii[4]:=4;
  }
    dmx_Find_Frst_Code(0,1);
     dm_goto_last;
     Mk_COVER;

     dx:=round(12*kf);
     dy:=round(12*kf);
     dxsm:=round(3*kf);
     dysm:=round(3*kf);
     dwline:=round(0.8*kf);
     tlBigframe.n:=1;

     with fconus do begin
     if chbtop.checked then begin
       if ChbLeft.checked then
         tlBigframe.pol[0].x:=pcorn[1].x-dx-dwline
       else
         tlBigframe.pol[0].x:=pcorn[1].x-dxsm;
       tlBigframe.pol[0].y:=pcorn[1].y-dy;
       if ChbRight.checked then
         tlBigframe.pol[1].x:=pcorn[2].x+dx+dwline
       else
         tlBigframe.pol[1].x:=pcorn[2].x+dxsm;
       tlBigframe.pol[1].y:=pcorn[2].y-dy;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
     end;

     if chbRight.checked then begin
       if ChbTop.checked then
         tlBigframe.pol[0].y:=pcorn[2].y-dy-dwline
       else
         tlBigframe.pol[0].y:=pcorn[2].y-dysm;
       tlBigframe.pol[0].x:=pcorn[2].x+dx;

       if Chbbottom.checked then
         tlBigframe.pol[1].y:=pcorn[3].y+dy+dwline
       else
         tlBigframe.pol[1].y:=pcorn[3].y+dysm;
       tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
     end;

     if chbBottom.checked then begin
       if ChbLeft.checked then
         tlBigframe.pol[0].x:=pcorn[4].x-dx-dwline
       else
         tlBigframe.pol[0].x:=pcorn[4].x-dxsm;
       tlBigframe.pol[0].y:=pcorn[4].y+dy;
       if ChbRight.checked then
         tlBigframe.pol[1].x:=pcorn[3].x+dx+dwline
       else
         tlBigframe.pol[1].x:=pcorn[3].x+dxsm;
       tlBigframe.pol[1].y:=pcorn[3].y+dy;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
     end;

     if chbLeft.checked then begin
       if ChbTop.checked then
         tlBigframe.pol[0].y:=pcorn[1].y-dy-dwline
       else
         tlBigframe.pol[0].y:=pcorn[1].y-dysm;
       tlBigframe.pol[0].x:=pcorn[1].x-dx;

       if Chbbottom.checked then
         tlBigframe.pol[1].y:=pcorn[4].y+dy+dwline
       else
         tlBigframe.pol[1].y:=pcorn[4].y+dysm;
       tlBigframe.pol[1].x:=pcorn[4].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100001'),2,0,@TLbigFrame,false);
     end;

     //Тонкая рамка рядом с толстой
    dx:=round(10*kf);
     dy:=round(10*kf);
     dxsm:=round(3*kf);
     dysm:=round(3*kf);
     if chbtop.checked then begin
       if ChbLeft.checked then
         tlBigframe.pol[0].x:=pcorn[1].x-dx
       else
         tlBigframe.pol[0].x:=pcorn[1].x-dxsm;
       tlBigframe.pol[0].y:=pcorn[1].y-dy;
       if ChbRight.checked then
         tlBigframe.pol[1].x:=pcorn[2].x+dx
       else
         tlBigframe.pol[1].x:=pcorn[2].x+dxsm;
       tlBigframe.pol[1].y:=pcorn[2].y-dy;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;

     if chbRight.checked then begin
       if ChbTop.checked then
         tlBigframe.pol[0].y:=pcorn[2].y-dy
       else
         tlBigframe.pol[0].y:=pcorn[2].y-dysm;
       tlBigframe.pol[0].x:=pcorn[2].x+dx;

       if Chbbottom.checked then
         tlBigframe.pol[1].y:=pcorn[3].y+dy
       else
         tlBigframe.pol[1].y:=pcorn[3].y+dysm;
       tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;

     if chbBottom.checked then begin
       if ChbLeft.checked then
         tlBigframe.pol[0].x:=pcorn[4].x-dx
       else
         tlBigframe.pol[0].x:=pcorn[4].x-dxsm;
       tlBigframe.pol[0].y:=pcorn[4].y+dy;
       if ChbRight.checked then
         tlBigframe.pol[1].x:=pcorn[3].x+dx
       else
         tlBigframe.pol[1].x:=pcorn[3].x+dxsm;
       tlBigframe.pol[1].y:=pcorn[3].y+dy;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;

     if chbLeft.checked then begin
       if ChbTop.checked then
         tlBigframe.pol[0].y:=pcorn[1].y-dy
       else
         tlBigframe.pol[0].y:=pcorn[1].y-dysm;
       tlBigframe.pol[0].x:=pcorn[1].x-dx;

       if Chbbottom.checked then
         tlBigframe.pol[1].y:=pcorn[4].y+dy
       else
         tlBigframe.pol[1].y:=pcorn[4].y+dysm;
       tlBigframe.pol[1].x:=pcorn[4].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;

    //Внутрення рамка
    res:=dm_Add_Poly(String2code('A0100002'),2,0,@TLmain,false);

     dx:=round(1.6*kf);
     dy:=round(1.6*kf);
     dxsm:=0;
     dysm:=0;
     if chbtop.checked then begin
       if ChbLeft.checked then
         tlBigframe.pol[0].x:=pcorn[1].x-dx
       else
         tlBigframe.pol[0].x:=pcorn[1].x-dxsm;
       tlBigframe.pol[0].y:=pcorn[1].y-dy;
       if ChbRight.checked then
         tlBigframe.pol[1].x:=pcorn[2].x+dx
       else
         tlBigframe.pol[1].x:=pcorn[2].x+dxsm;
       tlBigframe.pol[1].y:=pcorn[2].y-dy;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;

     if chbRight.checked then begin
       if ChbTop.checked then
         tlBigframe.pol[0].y:=pcorn[2].y-dy
       else
         tlBigframe.pol[0].y:=pcorn[2].y-dysm;
       tlBigframe.pol[0].x:=pcorn[2].x+dx;

       if Chbbottom.checked then
         tlBigframe.pol[1].y:=pcorn[3].y+dy
       else
         tlBigframe.pol[1].y:=pcorn[3].y+dysm;
       tlBigframe.pol[1].x:=pcorn[3].x+dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;

     if chbBottom.checked then begin
       if ChbLeft.checked then
         tlBigframe.pol[0].x:=pcorn[4].x-dx
       else
         tlBigframe.pol[0].x:=pcorn[4].x-dxsm;
       tlBigframe.pol[0].y:=pcorn[4].y+dy;
       if ChbRight.checked then
         tlBigframe.pol[1].x:=pcorn[3].x+dx
       else
         tlBigframe.pol[1].x:=pcorn[3].x+dxsm;
       tlBigframe.pol[1].y:=pcorn[3].y+dy;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;

     if chbLeft.checked then begin
       if ChbTop.checked then
         tlBigframe.pol[0].y:=pcorn[1].y-dy
       else
         tlBigframe.pol[0].y:=pcorn[1].y-dysm;
       tlBigframe.pol[0].x:=pcorn[1].x-dx;

       if Chbbottom.checked then
         tlBigframe.pol[1].y:=pcorn[4].y+dy
       else
         tlBigframe.pol[1].y:=pcorn[4].y+dysm;
       tlBigframe.pol[1].x:=pcorn[4].x-dx;
       tlBigframe.n:=1;
       dm_Add_Poly(string2code('A0100002'),2,0,@TLbigFrame,false);
     end;
   end;
   
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

       Mk_grad_net_on_Conus;
       Make_gauss_net_on_Conus;

//  end;
  // Center_bottom_text;
 Result:=true;

end;

procedure TFConus.Button2Click(Sender: TObject);
var
  lr:longint;
  i,icode,iloc,itype,ilayout:integer;
  fx,fy,fw:single;
  a,b:lpoint;
  R:lorient;
  dx, dy:longint;
  st:shortstring;
  pc:pchar;
begin
 if Frame_Conus then begin
  nodecurr:=dm_object;
  if ChbAddtxt.Checked and FtuneZaram.ODBCConnFrame.connected then with FtuneZaram do begin
    SQLQuery_frame.First;
    while not SQLQuery_frame.eof do begin
     fx:=SQLQuery_frame.fieldbyname('Горизонтально').asFloat;
     fy:=SQLQuery_frame.fieldbyname('Вертикально').asFloat;
     icode:=String2Code(SQLQuery_frame.fieldbyname('КОД').asString);
     iloc:=SQLQuery_frame.fieldbyname('ТИП').asInteger;
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
     itype:=SQLQuery_frame.fieldbyname('ID_TYPE').asInteger;
     iLayout:=SQLQuery_frame.fieldbyname('ID_LAYOUT').asInteger;
     st:=SQLQuery_frame.fieldbyname('Текст').asString;
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
     itype:=SQLQuery_frame.fieldbyname('ID_TYPE').asInteger;
     iLayout:=SQLQuery_frame.fieldbyname('ID_LAYOUT').asInteger;
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
    SQLQuery_frame.next;
    end;
  end;
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

procedure TFConus.Button3Click(Sender: TObject);
begin
FtuneZaram.show;
end;

end.
