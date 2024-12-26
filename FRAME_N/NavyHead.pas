unit NavyHead;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, OTypes, dmw_Use, Dmw_ddw,frNavyfun, ComCtrls,
  ExtCtrls, MaskEdit, NevaUtil, LConvEncoding;
type
  TFNavyHead = class(TForm)
    Button5: TButton;
    PageCntr: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    meDateFirst: TMaskEdit;
    MeDateNew: TMaskEdit;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label32: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    MeDateIM: TMaskEdit;
    Label14: TLabel;
    meBSD: TMaskEdit;
    Label21: TLabel;
    meBSM: TMaskEdit;
    Label23: TLabel;
    meBSS: TMaskEdit;
    Label33: TLabel;
    Label13: TLabel;
    meLWD: TMaskEdit;
    Label17: TLabel;
    meLWM: TMaskEdit;
    Label16: TLabel;
    meLWS: TMaskEdit;
    Label15: TLabel;
    Label9: TLabel;
    meBND: TMaskEdit;
    Label10: TLabel;
    meBNM: TMaskEdit;
    Label11: TLabel;
    meBNS: TMaskEdit;
    Label12: TLabel;
    Label34: TLabel;
    meLOD: TMaskEdit;
    Label35: TLabel;
    meLOM: TMaskEdit;
    Label36: TLabel;
    meLOS: TMaskEdit;
    Label37: TLabel;
    Label38: TLabel;
    Label42: TLabel;
    meBMD: TMaskEdit;
    Label41: TLabel;
    meBMM: TMaskEdit;
    Label39: TLabel;
    meBMS: TMaskEdit;
    Label40: TLabel;
    Button4: TButton;
    Label4: TLabel;
    meBStepD: TMaskEdit;
    Label20: TLabel;
    meBStepM: TMaskEdit;
    Label18: TLabel;
    meBstepS: TMaskEdit;
    Label19: TLabel;
    Label5: TLabel;
    meLStepD: TMaskEdit;
    Label3: TLabel;
    meLstepM: TMaskEdit;
    Label1: TLabel;
    meLstepS: TMaskEdit;
    Label2: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    EdAdmir: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    EdInvent: TEdit;
    Label29: TLabel;
    EdObj: TEdit;
    Label26: TLabel;
    EdTer: TEdit;
    EdHead: TEdit;
    CmBxScale: TComboBox;
    EdResol: TEdit;
    Label8: TLabel;
    Label44: TLabel;
    Label22: TLabel;
    CboxTagCrd: TComboBox;
    Label43: TLabel;
    EdGrif: TEdit;
    Label24: TLabel;
    CmBxPrj: TComboBox;
    CmBxProfile: TComboBox;
    EdProdType: TEdit;
    EdIDNumb: TEdit;
    EdRedNumb: TEdit;
    EdIDComment: TEdit;
    EdParScale: TEdit;
    edDepthUnit: TEdit;
    EdParComment: TEdit;
    EdHUnit: TEdit;
    EdSpec: TEdit;
    EdSpecNumb: TEdit;
    EdCountry: TEdit;
    EdAgency: TEdit;
    EdDataCriteria: TEdit;
    EdDataStructure: TEdit;
    EdHistComment: TEdit;
    meS_57: TMaskEdit;
    meS_57_A: TMaskEdit;
    Label54: TLabel;
    MeSostDate: TMaskEdit;
    CmBxIntent: TComboBox;
    MeSpecDate: TMaskEdit;
    ButtGetPassport: TButton;
    Button1: TButton;
    Label68: TLabel;
    EdHorErr: TEdit;
    Label69: TLabel;
    EdVertERR: TEdit;
    Label70: TLabel;
    EdErrComment: TEdit;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    meTagdx: TMaskEdit;
    Label58: TLabel;
    meTagdy: TMaskEdit;
    Label59: TLabel;
    meTagdz: TMaskEdit;
    Label77: TLabel;
    RgScale: TRadioGroup;
    EdScale: TEdit;
    CmBxDepthNULL: TComboBox;
    Label25: TLabel;
    CMbxHeightNULL: TComboBox;
    Label78: TLabel;
    CmbxNavIntent: TComboBox;
    CmbxGeoSys: TComboBox;
    Label79: TLabel;
    Label80: TLabel;
    meBMD2: TMaskEdit;
    Label81: TLabel;
    meBMM2: TMaskEdit;
    Label82: TLabel;
    meBMS2: TMaskEdit;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    meLMD: TMaskEdit;
    Label86: TLabel;
    meLMM: TMaskEdit;
    Label87: TLabel;
    meLMS: TMaskEdit;
    Label88: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ButtGetPassportClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNavyHead: TFNavyHead;
  Bin_dir:String;
  IniFile:TInifile;
  MyFormatSettings : TFormatSettings;

implementation

{$R *.lfm}

procedure TFNavyHead.FormCreate(Sender: TObject);
begin
  Pagecntr.ActivePageIndex:=0;
  MyFormatSettings := DefaultFormatSettings;
  with MyFormatSettings Do begin
     ShortDateFormat:='dd.mm.yy';
     LongDateFormat:='dd.mm.yyyy';
     DateSeparator:='.';
     decimalseparator:='.';
  end;

  Bin_dir:=ExtractFileDir(ParamSTR(0));

IniFile:=TIniFile.Create(make_ini('NavyHead.ini'));
CmBxPrj.ItemIndex:=0;
Height:=IniFile.ReadInteger('SEAFRAME','Form_Height',150);
Width:=IniFile.ReadInteger('SEAFRAME','Form_Width',460);

CBoxTagCrd.ItemIndex:=IniFile.ReadInteger('SEAFRAME','TagCrd',0);
CmBxScale.ItemIndex:=IniFile.ReadInteger('SEAFRAME','SCALE',0);
edScale.Text:=IniFile.ReadString('SEAFRAME','Scale','40000');
RGScale.ItemIndex:=IniFile.ReadInteger('SEAFRAME','RGSCALE',0);

meBnd.EditText:=IniFile.ReadString('SEAFRAME','BND','059');
meBnm.EditText:=IniFile.ReadString('SEAFRAME','BNM','59');
meBns.EditText:=IniFile.ReadString('SEAFRAME','BNS','08');

meBsd.EditText:=IniFile.ReadString('SEAFRAME','BSD','059');
meBsm.EditText:=IniFile.ReadString('SEAFRAME','BSM','54');
meBss.EditText:=IniFile.ReadString('SEAFRAME','BSS','30');

meBmd.EditText:=IniFile.ReadString('SEAFRAME','BMD','057');
meBmm.EditText:=IniFile.ReadString('SEAFRAME','BMM','00');
meBms.EditText:=IniFile.ReadString('SEAFRAME','BMS','00');

meBmd2.EditText:=IniFile.ReadString('SEAFRAME','BMD2','000');
meBmm2.EditText:=IniFile.ReadString('SEAFRAME','BMM2','00');
meBms2.EditText:=IniFile.ReadString('SEAFRAME','BMS2','00');

meLmd.EditText:=IniFile.ReadString('SEAFRAME','LMD','0000');
meLmm.EditText:=IniFile.ReadString('SEAFRAME','LMM','00');
meLms.EditText:=IniFile.ReadString('SEAFRAME','LMS','00');

meLWd.EditText:=IniFile.ReadString('SEAFRAME','LWD','0030');
meLWm.EditText:=IniFile.ReadString('SEAFRAME','LWM','08');
meLWs.EditText:=IniFile.ReadString('SEAFRAME','LWS','39');

meLOd.EditText:=IniFile.ReadString('SEAFRAME','LOD','0030');
meLOm.EditText:=IniFile.ReadString('SEAFRAME','LOM','21');
meLOs.EditText:=IniFile.ReadString('SEAFRAME','LOS','11');


edHead.Text:=IniFile.ReadString('SEAFRAME','HEAD','Заголовок карты');
edTer.Text:=IniFile.ReadString('SEAFRAME','TERR','Заголовок карты');

edAdmir.Text:=IniFile.ReadString('SEAFRAME','Admir','28030');
edInvent.Text:=IniFile.ReadString('SEAFRAME','INVENT','1');
edResol.Text:=IniFile.ReadString('SEAFRAME','RESOLUTION','1');
edGrif.Text:=IniFile.ReadString('SEAFRAME','GRIF','');

edObj.Text:=IniFile.ReadString('SEAFRAME','OBJ','marine.obj');
meDateFirst.EditText:=IniFile.ReadString('SEAFRAME','DateFirst','10.01.1957');
meDateNew.EditText:=IniFile.ReadString('SEAFRAME','DateNew','10.01.2001');
meDateIM.EditText:=IniFile.ReadString('SEAFRAME','DateIM','10.01.2001');
meSostDate.EditText:=IniFile.ReadString('SEAFRAME','SostDate','10.01.2001');

meBStepd.EditText:=IniFile.ReadString('SEAFRAME','BStepD','00');
meBStepm.EditText:=IniFile.ReadString('SEAFRAME','BStepM','01');
meBSteps.EditText:=IniFile.ReadString('SEAFRAME','BstepS','00');
meLStepd.EditText:=IniFile.ReadString('SEAFRAME','LStepD','00');
meLStepm.EditText:=IniFile.ReadString('SEAFRAME','LStepM','02');
meLSteps.EditText:=IniFile.ReadString('SEAFRAME','LstepS','00');

CmBxProfile.ItemIndex:=IniFile.ReadInteger('SEAFRAME','PROFILE',0);
EdProdType.Text:=IniFile.ReadString('SEAFRAME','PRODTYPE','');
EdIDNumb.Text:=IniFile.ReadString('SEAFRAME','IDNUMB','');
EdRedNumb.Text:=IniFile.ReadString('SEAFRAME','REDNUMB','');
meS_57.EditText:=IniFile.ReadString('SEAFRAME','S57','10.01.2001');
meS_57_A.EditText:=IniFile.ReadString('SEAFRAME','S57A','10.01.2001');
CmbxIntent.ItemIndex:=IniFile.ReadInteger('SEAFRAME','INTENT',0);
CmbxNavIntent.ItemIndex:=IniFile.ReadInteger('SEAFRAME','NAVINTENT',0);

EdIDComment.Text:=IniFile.ReadString('SEAFRAME','IDCOMMENT','');

CmbxGeoSys.itemindex:=IniFile.ReadInteger('SEAFRAME','GEOSYS',0);
CmbxDepthNULL.itemindex:=IniFile.ReadInteger('SEAFRAME','DEPTHNULL',0);
CmbxHeightNULL.itemindex:=IniFile.ReadInteger('SEAFRAME','HeightNULL',0);
EdParScale.Text:=IniFile.ReadString('SEAFRAME','PARSCALE','');
edDepthUnit.Text:=IniFile.ReadString('SEAFRAME','DEPTHUNIT','');
EdHUnit.Text:=IniFile.ReadString('SEAFRAME','H_UNIT','');
EdParComment.Text:=IniFile.ReadString('SEAFRAME','PARCOMMENT','');

EdSpec.Text:=IniFile.ReadString('SEAFRAME','SPEC','');
EdSpecNumb.Text:=IniFile.ReadString('SEAFRAME','SPECNUMB','');
meSpecDate.EditText:=IniFile.ReadString('SEAFRAME','SPECDATE','10.01.2001');
EdCountry.Text:=IniFile.ReadString('SEAFRAME','COUNTRY','');
EdAgency.Text:=IniFile.ReadString('SEAFRAME','AGENCY','');
EdDataCriteria.Text:=IniFile.ReadString('SEAFRAME','DATACRITERIA','');
EdDataStructure.Text:=IniFile.ReadString('SEAFRAME','DATASTRUCTURE','');
EdHistComment.Text:=IniFile.ReadString('SEAFRAME','HISTCOMMENT','');

EdHorErr.Text:=IniFile.ReadString('SEAFRAME','HORERR','');
EdVertErr.Text:=IniFile.ReadString('SEAFRAME','VertERR','');
EdErrComment.Text:=IniFile.ReadString('SEAFRAME','ERRComment','');
meTagDx.EditText:=IniFile.ReadString('ORIENT','TAGDX','0');
meTagDy.EditText:=IniFile.ReadString('ORIENT','TAGDY','0');
meTagDz.EditText:=IniFile.ReadString('ORIENT','TAGDZ','0');

INIfile.free;
end;

procedure TFNavyHead.FormDestroy(Sender: TObject);
begin
IniFile:=TIniFile.Create(make_ini('NavyHead.ini'));
IniFile.WriteInteger('SEAFRAME','Form_Height',Height);
IniFile.WriteInteger('SEAFRAME','Form_Width',Width);

IniFile.WriteInteger('SEAFRAME','TagCrd',CBoxTagCrd.ItemIndex);
IniFile.WriteInteger('SEAFRAME','SCALE',CmBxScale.ItemIndex);
IniFile.WriteString('SEAFRAME','Scale',edScale.Text);
IniFile.WriteInteger('SEAFRAME','RGSCALE',RGScale.ItemIndex);

IniFile.WriteInteger('SEAFRAME','PROFILE',CmBxProfile.ItemIndex);

IniFile.WriteString('SEAFRAME','BND',meBnd.EditText);
IniFile.WriteString('SEAFRAME','BNM',meBnm.EditText);
IniFile.WriteString('SEAFRAME','BNS',meBns.EditText);

IniFile.WriteString('SEAFRAME','BSD',meBsd.EditText);
IniFile.WriteString('SEAFRAME','BSM',meBsm.EditText);
IniFile.WriteString('SEAFRAME','BSS',meBss.EditText);

IniFile.WriteString('SEAFRAME','BMD',meBmd.EditText);
IniFile.WriteString('SEAFRAME','BMM',meBmm.EditText);
IniFile.WriteString('SEAFRAME','BMS',meBms.EditText);

IniFile.WriteString('SEAFRAME','BMD2',meBmd2.EditText);
IniFile.WriteString('SEAFRAME','BMM2',meBmm2.EditText);
IniFile.WriteString('SEAFRAME','BMS2',meBms2.EditText);

IniFile.WriteString('SEAFRAME','LMD',meLmd.EditText);
IniFile.WriteString('SEAFRAME','LMM',meLmm.EditText);
IniFile.WriteString('SEAFRAME','LMS',meLms.EditText);

IniFile.WriteString('SEAFRAME','LWD',meLWd.EditText);
IniFile.WriteString('SEAFRAME','LWM',meLWm.EditText);
IniFile.WriteString('SEAFRAME','LWS',meLWs.EditText);

IniFile.WriteString('SEAFRAME','LOD',meLOd.EditText);
IniFile.WriteString('SEAFRAME','LOM',meLOm.EditText);
IniFile.WriteString('SEAFRAME','LOS',meLOs.EditText);

IniFile.WriteString('SEAFRAME','HEAD',edHead.Text);
IniFile.WriteString('SEAFRAME','Admir',edAdmir.Text);
IniFile.WriteString('SEAFRAME','TERR',edTer.Text);

IniFile.WriteString('SEAFRAME','INVENT',edInvent.Text);
IniFile.WriteString('SEAFRAME','OBJ',edObj.Text);
IniFile.WriteString('SEAFRAME','RESOLUTION',edResol.Text);
IniFile.WriteString('SEAFRAME','GRIF',edGrif.Text);

IniFile.WriteString('SEAFRAME','DateFirst',meDateFirst.EditText);
IniFile.WriteString('SEAFRAME','DateNew',meDateNew.EditText);
IniFile.WriteString('SEAFRAME','DateIM',meDateIM.EditText);

IniFile.WriteString('SEAFRAME','BStepD',meBStepd.EditText);
IniFile.WriteString('SEAFRAME','BStepM',meBStepm.EditText);
IniFile.WriteString('SEAFRAME','BstepS',meBSteps.EditText);

IniFile.WriteString('SEAFRAME','LStepD',meLStepd.EditText);
IniFile.WriteString('SEAFRAME','LStepM',meLStepm.EditText);
IniFile.WriteString('SEAFRAME','LstepS',meLSteps.EditText);

IniFile.WriteString('SEAFRAME','PRODTYPE','');
IniFile.WriteString('SEAFRAME','IDNUMB',EdIDNumb.Text);
IniFile.WriteString('SEAFRAME','REDNUMB',EdRedNumb.Text);
IniFile.WriteString('SEAFRAME','S57',meS_57.EditText);
IniFile.WriteString('SEAFRAME','S57A',meS_57_A.EditText);
IniFile.WriteInteger('SEAFRAME','INTENT',CmbxIntent.ItemIndex);
IniFile.WriteInteger('SEAFRAME','NAVINTENT',CmbxNAVIntent.ItemIndex);
IniFile.WriteString('SEAFRAME','IDCOMMENT',EdIDComment.Text);

IniFile.WriteInteger('SEAFRAME','GEOSYS',CmbxGeoSys.itemindex);
IniFile.WriteInteger('SEAFRAME','DEPTHNULL',CmbxDepthNULL.ItemIndex);
IniFile.WriteInteger('SEAFRAME','HeightNULL',CmbxHeightNULL.itemindex);

IniFile.WriteString('SEAFRAME','PARSCALE',EdParScale.Text);
IniFile.WriteString('SEAFRAME','DEPTHUNIT',edDepthUnit.Text);
IniFile.WriteString('SEAFRAME','H_UNIT',EdHUnit.Text);
IniFile.WriteString('SEAFRAME','PARCOMMENT',EdParComment.Text);

IniFile.WriteString('SEAFRAME','SPEC',edspec.text);
IniFile.WriteString('SEAFRAME','SPECNUMB',EdSpecNumb.Text);
IniFile.WriteString('SEAFRAME','SPECDATE',meSpecDate.EditText);
IniFile.WriteString('SEAFRAME','COUNTRY',EdCountry.Text);
IniFile.WriteString('SEAFRAME','AGENCY',EdAgency.Text);
IniFile.WriteString('SEAFRAME','DATACRITERIA',EdDataCriteria.Text);
IniFile.WriteString('SEAFRAME','DATASTRUCTURE',EdDataStructure.Text);
IniFile.WriteString('SEAFRAME','HISTCOMMENT',EdHistComment.Text);

IniFile.WriteString('SEAFRAME','HORERR',EdHorErr.Text);
IniFile.WriteString('SEAFRAME','VertERR',EdVertErr.Text);
IniFile.WriteString('SEAFRAME','ERRComment',EdErrComment.Text);

IniFile.WriteString('ORIENT','TAGDX',meTagDx.EditText);
IniFile.WriteString('ORIENT','TAGDY',meTagDy.EditText);
IniFile.WriteString('ORIENT','TAGDZ',meTagDz.EditText);
INIfile.free
end;

procedure TFNavyHead.Button5Click(Sender: TObject);
 var
  sName:shortstring;
  nm:pchar;
  DT:TDatetime;
  BM :double;
  lTime,iscale,sign:longint;
  Year, Month, Day: Word;
begin

  nm:=dmw_activemap(@sname[1],255);
  if not assigned(nm) then begin
   Showmessage('Отсутствует карта');
   exit
  end;
  dmw_open(nm,true);
   dm_goto_root;
    if edadmir.text<>'' then begin
     sName:=UTF8ToCP866(edAdmir.text)+#0;
     //ANSItoOem(@sname[1],@sname[1]);
     dm_put_string(901,@sname[1]);
   end else
   dm_Del_hf(901,_string);
   if edHead.text<>'' then begin
     sName:=UTF8ToCP866(edHead.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(902,@sname[1]);
   end else
   dm_Del_hf(902,_string);
   if edter.text<>'' then begin
     sName:=UTF8ToCP866(edTer.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(904,@sname[1]);
   end else
   dm_Del_hf(904,_string);

   if edObj.text<>'' then begin
     sName:=edObj.text+#0;
     dm_put_string(903,@sname[1]);
   end else
     dm_Del_hf(903,_string);

   if Trim(meDateFirst.EditText)<>'' then begin
     try
       dt:=StrToDate(trim(meDateFirst.EditText),MyFormatSettings);
       DecodeDate(dt,Year, Month, Day);
       lTime:=Year*10000+month*100+Day;
       dm_put_long(921,ltime);
     except
       dm_Del_hf(921,_long);
       meDateFirst.EditText:='';
       Showmessage('Неправильный формат даты первого источника');
     end
   end else
     dm_Del_hf(921,_long);

   if Trim(meDateNew.EditText)<>'' then begin
     try
       dt:=StrToDate(Trim(meDateNew.EditText), MyFormatSettings);
       DecodeDate(dt,Year, Month, Day);
       lTime:=Year*10000+month*100+Day;
       dm_put_long(922,ltime);
     except
       dm_Del_hf(922,_long);
       meDateNew.EditText:='';
       Showmessage('Неправильный формат даты последнего источника');
     end

   end else
     dm_Del_hf(922,_long);
    if (MeBmd.edittext[1]='-') or (strtoint(meBmd.edittext)<0)  then sign:=-1 else sign:=1;

    BM:=(strtoint(meBMD.edittext)+sign*strtoint(meBMM.edittext)/60+sign*strtofloat(meBMS.edittext, MyFormatSettings)/3600)/180*PI;
    dm_Put_double(991,BM);
    if (MeBmd2.edittext[1]='-') or (strtoint(meBmd2.edittext)<0)  then sign:=-1 else sign:=1;

    BM:=(strtoint(meBMD2.edittext)+sign*strtoint(meBMM2.edittext)/60+sign*strtofloat(meBMS2.edittext, MyFormatSettings)/3600)/180*PI;
    dm_Put_double(992,BM);

    if (MeLmd.edittext[1]='-') or (strtoint(meLmd.edittext)<0)  then sign:=-1 else sign:=1;

    BM:=(strtoint(meLMD.edittext)+sign*strtoint(meLMM.edittext)/60+sign*strtofloat(meLMS.edittext, MyFormatSettings)/3600)/180*PI;
    dm_Put_double(993,BM);

    Day:=CBoxTagCrd.ItemIndex+1;
    Dm_Put_byte(911,day);

   if edInvent.text<>'' then begin
     sName:=UTF8ToCP866(edInvent.text)+#0;
      //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(801,@sname[1]);
   end else
    dm_Del_hf(801,_string);
    netintB:=(strtoint(meBStepD.edittext)+strtoint(meBStepM.edittext)/60+strtoFloat(meBStepS.edittext, MyFormatSettings)/3600)/180*PI;
    netintL:=(strtoint(meLStepD.edittext)+strtoint(meLStepM.edittext)/60+strtoFloat(meLStepS.edittext, MyFormatSettings)/3600)/180*PI;
    if netintB<>0 then
      dm_put_double(971,netintB)
    else
      dm_Del_hf(971,_double);

   if netintL<>0 then
     dm_put_double(972,netintL)
    else
   dm_Del_hf(972,_double);

   if edGrif.text<>'' then begin
     sName:=UTF8ToCP866(edGrif.text)+#0;
      //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(907,@sname[1]);
   end else
    dm_Del_hf(907,_string);
     if rgScale.ItemIndex=0 then begin
 case CmbxScale.ItemIndex of
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
 13: Iscale:=17500;
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
 end else begin
 Iscale:=Strtoint(edScale.text);
 end;
 Dm_Put_long(904,Iscale);
 if edResol.text<>'' then begin
     sName:=edResol.text+#0;
     dm_put_string(804,@sname[1]);
   end else
    dm_Del_hf(804,_string);
  if CmbxProfile.ItemIndex>0 then begin
     dm_put_dbase(805,CmbxProfile.ItemIndex);
   end else
    dm_Del_hf(805,_Dbase);
   if edProdType.text<>'' then begin
     sName:=UTF8ToCP866(edProdType.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(806,@sname[1]);
   end else
    dm_Del_hf(806,_string);

   if edIdNumb.text<>'' then begin
     sName:=UTF8ToCP866(edIdNumb.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(807,@sname[1]);
   end else
    dm_Del_hf(807,_string);

   if edRedNumb.text<>'' then begin
     sName:=UTF8ToCP866(edRedNumb.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(808,@sname[1]);
   end else
    dm_Del_hf(808,_string);
   if  trim(meSostDate.EditText)<>'' then begin
     try
       dt:=StrToDate(trim(meSostDate.EditText), MyFormatSettings);
       DecodeDate(dt,Year, Month, Day);
       lTime:=Year*10000+month*100+Day;
       dm_put_long(809,ltime);
     except
       dm_Del_hf(809,_long);
       meSostDate.EditText:='';
       Showmessage('Неправильный формат даты первого источника');
     end

   end else
     dm_Del_hf(809,_long);

   if  trim(meDateIM.EditText)<>'' then begin
     try
       dt:=StrToDate(trim(meDateIM.EditText), MyFormatSettings);
       DecodeDate(dt,Year, Month, Day);
       lTime:=Year*10000+month*100+Day;
       dm_put_long(810,ltime);
     except
       dm_Del_hf(810,_long);
       meDateIM.EditText:='';
       Showmessage('Неправильный формат даты ИМ');
     end

   end else
     dm_Del_hf(810,_long);

   if  trim(meS_57.EditText)<>'' then begin
     try
       dt:=StrToDate(trim(meS_57.EditText), MyFormatSettings);
       DecodeDate(dt,Year, Month, Day);
       lTime:=Year*10000+month*100+Day;
       dm_put_long(811,ltime);
     except
       dm_Del_hf(811,_long);
       meS_57.EditText:='';
       Showmessage('Неправильный формат даты издания S-57');
     end

   end else
     dm_Del_hf(811,_long);

   if  trim(meS_57_A.EditText)<>'' then begin
     try
       dt:=StrToDate(trim(meS_57_A.EditText), MyFormatSettings);
       DecodeDate(dt,Year, Month, Day);
       lTime:=Year*10000+month*100+Day;
       dm_put_long(812,ltime);
     except
       dm_Del_hf(812,_long);
       meS_57_A.EditText:='';
       Showmessage('Неправильный формат даты издания S-57 (приложение А)');
     end

   end else
     dm_Del_hf(812,_long);
  if CmbxIntent.ItemIndex>0 then begin
     dm_put_Dbase(813,CmbxIntent.ItemIndex);
   end else
    dm_Del_hf(813,_Dbase);
   if edIdComment.text<>'' then begin
     sName:=UTF8ToCP866(edIdComment.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(814,@sname[1]);
   end else
     dm_Del_hf(814,_string);
   if CmbxGeoSys.itemindex>0 then begin
     dm_put_Dbase(815,CmbxGeoSys.itemindex);
   end else
     dm_Del_hf(815,_Dbase);

   if CmBxDepthNULL.itemIndex>0 then begin
     dm_put_Dbase(816,CmBxDepthNULL.itemIndex);
   end else
     dm_Del_hf(816,_dbase);
   if edParScale.text<>'' then begin
     sName:=UTF8ToCP866(edParScale.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(817,@sname[1]);
   end else
     dm_Del_hf(817,_string);
   if edDepthUnit.text<>'' then begin
     sName:=UTF8ToCP866(edDepthUnit.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(818,@sname[1]);
   end else
    dm_Del_hf(818,_string);
   if edHUnit.text<>'' then begin
     sName:=UTF8ToCP866(edHUnit.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(819,@sname[1]);
   end else
    dm_Del_hf(819,_string);
   if edParComment.text<>'' then begin
     sName:=UTF8ToCP866(edParComment.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(820,@sname[1]);
   end else
    dm_Del_hf(820,_string);
   if edSpec.text<>'' then begin
     sName:=UTF8ToCP866(edSpec.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(821,@sname[1]);
   end else
    dm_Del_hf(821,_string);
   if edSpecNumb.text<>'' then begin
     sName:=UTF8ToCP866(edSpecNumb.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(822,@sname[1]);
   end else
    dm_Del_hf(822,_string);
    if edSpecNumb.text<>'' then begin
     sName:=UTF8ToCP866(edSpecNumb.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(822,@sname[1]);
   end else
    dm_Del_hf(822,_string);
   if  trim(meSpecDate.EditText)<>'' then begin
     try
       dt:=StrToDate(trim(meSpecDate.EditText), MyFormatSettings);
       DecodeDate(dt,Year, Month, Day);
       lTime:=Year*10000+month*100+Day;
       dm_put_long(823,ltime);
     except
       dm_Del_hf(823,_long);
       meSpecDate.EditText:='';
       Showmessage('Неправильный формат даты спецификации продукта');
     end
   end else
   dm_Del_hf(823,_long);
    if edCountry.text<>'' then begin
     sName:=UTF8ToCP866(edCountry.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(824,@sname[1]);
   end else
    dm_Del_hf(824,_string);
   if edAgency.text<>'' then begin
     sName:=UTF8ToCP866(edAgency.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(825,@sname[1]);
   end else
    dm_Del_hf(825,_string);
   if edDataCriteria.text<>'' then begin
     sName:=UTF8ToCP866(edDataCriteria.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(826,@sname[1]);
   end else
    dm_Del_hf(826,_string);
  if edDataStructure.text<>'' then begin
     sName:=UTF8ToCP866(edDataStructure.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(827,@sname[1]);
   end else
    dm_Del_hf(827,_string);
   if edHistComment.text<>'' then begin
     sName:=UTF8ToCP866(edHistComment.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(828,@sname[1]);
   end else
    dm_Del_hf(828,_string);

   if edHorErr.text<>'' then begin
     sName:=UTF8ToCP866(edHorErr.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(829,@sname[1]);
   end else
    dm_Del_hf(829,_string);
   if edVertErr.text<>'' then begin
     sName:=UTF8ToCP866(edVertErr.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(830,@sname[1]);
   end else
    dm_Del_hf(830,_string);
   if edErrComment.text<>'' then begin
     sName:=UTF8ToCP866(edErrComment.text)+#0;
     //AnsitoOem(@sname[1],@sname[1]);
     dm_put_string(831,@sname[1]);
   end else
    dm_Del_hf(831,_string);
   if CmBxHEIGHTNULL.itemIndex>0 then begin
     dm_put_Dbase(832,CmBxHEIGHTNULL.itemIndex);
   end else
    dm_Del_hf(832,_dbase);

   if CmbxNAVIntent.ItemIndex>0 then begin
    dm_put_Dbase(833,CmbxNavIntent.ItemIndex);
   end else
    dm_Del_hf(833,_Dbase);

  dmw_done;
end;

procedure TFNavyHead.Button4Click(Sender: TObject);
var
  BLN,BLS,BM,es:extended;
  lBM,lm,sign:longint;
begin
    if (MeBnd.edittext[1]='-') or (strtoint(meBND.edittext)<0)  then sign:=-1 else sign:=1;

  BLN:=(strtoint(meBND.edittext)+sign*strtoint(meBNM.edittext)/60+sign*strtoFloat(meBNS.edittext, MyFormatSettings)/3600)/180*PI;
   if (MeBSd.edittext[1]='-') or (strtoint(meBsd.edittext)<0)  then sign:=-1 else sign:=1;
  BLS:=(strtoint(meBSD.edittext)+sign*strtoint(meBSM.edittext)/60+sign*strtofloat(meBSS.edittext, MyFormatSettings)/3600)/180*PI;
  BM:=(BLN+BLS)/Pi*90;{*0.5/PI*180}

  lbm:=Trunc(abs(BM));
  lm:=trunc((abs(BM)-lBm)*60.0);
  es:=((abs(BM)-lBm)*60.0-trunc((abs(BM)-lBm)*60.0))*60.0;
  if es>=59.9 then begin es:=0; inc(lm) end;
  if lm=60 then begin lm:=0; inc(lBm) end;

   if BM>0 then
  meBmd.EditText:=FormatFloat('0000',lBm)
    else
  meBmd.EditText:=FormatFloat('-000',lBm);
  meBmm.EditText:=FormatFloat('00',lm);
  meBms.EditText:=FormatFloat('00.00',es);
end;

procedure TFNavyHead.ButtGetPassportClick(Sender: TObject);
var
  sName:shortstring;
  nm:pchar;
  es:extended;
  t:lpoint;
  lTime,iscale,lbm,lm:longint;
  dattag:Tdatum;
  Year, Month, Day: Word;
begin
  nm:=dmw_activemap(@sname[1],255);
  if not assigned(nm) then begin
   Showmessage('Отсутствует карта');
   exit
  end;
  dmw_open(nm,true);
  es:=dm_dist(1,1);
  if es<>0 then es:=1/es;
  edResol.Text:=FormatFloat('0.###',es);
  dm_goto_root;

   if dm_Get_string(901,255,Sname) then begin
     edadmir.text:=CP866ToUTF8(sname);
   end else
     edadmir.text:='';
   if dm_Get_string(902,255,Sname) then begin
     edHead.text:=CP866ToUTF8(sname);
   end else
    edHead.text:='';
   if dm_Get_string(903,255,sName) then begin
     edobj.text:=sName;
   end else
     edObj.text:='';

   if dm_Get_string(904,255,Sname) then begin
     edter.text:=CP866ToUTF8(sname);
   end else
     edter.text:='';


   if dm_Get_long(921,0,ltime) then begin
     if Ltime<>0 then begin
       Year:=Ltime div 10000;
       month:=(Ltime- Year*10000) div 100;
       Day:=Ltime-Year*10000-month*100;
       meDateFirst.EditText:=Format('%2d.%2d.%4d',[Day,month,Year]);
     end else
       meDateFirst.EditText:=''
   end else
     meDateFirst.EditText:='';

   if dm_Get_long(922,0,ltime) then begin
     if Ltime<>0 then begin
       Year:=Ltime div 10000;
       month:=(Ltime- Year*10000) div 100;
       Day:=Ltime-Year*10000-month*100;
       meDateNew.EditText:=Format('%2d.%2d.%4d',[Day,month,Year]);
     end else
       meDateNew.EditText:=''
   end else
     meDateNew.EditText:='';

   if dm_Get_string(801,255,Sname) then begin
     edInvent.text:=CP866ToUTF8(sname);
    end else
     edInvent.text:='';

   if dm_Get_double(991,0,netintb) then begin
       netintB:=netintB/pi*180;

     lbm:=Trunc(abs(netintB));
    lm:=trunc((abs(netintB)-lBm)*60.0);
    es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
    if es>=59.9 then begin es:=0; inc(lm) end;
    if lm=60 then begin lm:=0; inc(lBm) end;

    if netintB>=0 then
      meBmd.EditText:=FormatFloat('000',lBm)
    else
      meBmd.EditText:=FormatFloat('-00',lBm);
    meBmm.EditText:=FormatFloat('00',lm);
    meBms.EditText:=FormatFloat('00.00',es);
  end else begin
     meBmD.edittext:='000';
     meBmM.edittext:='0';
     meBmS.edittext:='0';
  end;

  if dm_Get_double(992,0,netintb) then begin
       netintB:=netintB/pi*180;

     lbm:=Trunc(abs(netintB));
    lm:=trunc((abs(netintB)-lBm)*60.0);
    es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
    if es>=59.9 then begin es:=0; inc(lm) end;
    if lm=60 then begin lm:=0; inc(lBm) end;

    if netintB>=0 then
      meBmd2.EditText:=FormatFloat('000',lBm)
    else
      meBmd2.EditText:=FormatFloat('-00',lBm);
    meBmm2.EditText:=FormatFloat('00',lm);
    meBms2.EditText:=FormatFloat('00.00',es);
  end else begin
     meBmD2.edittext:='000';
     meBmM2.edittext:='0';
     meBmS2.edittext:='0';
  end;

  if dm_Get_double(993,0,netintb) then begin
       netintB:=netintB/pi*180;

     lbm:=Trunc(abs(netintB));
    lm:=trunc((abs(netintB)-lBm)*60.0);
    es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
    if es>=59.9 then begin es:=0; inc(lm) end;
    if lm=60 then begin lm:=0; inc(lBm) end;

    if netintB>=0 then
      meLmd.EditText:=FormatFloat('000',lBm)
    else
      meLmd.EditText:=FormatFloat('-00',lBm);
    meLmm.EditText:=FormatFloat('00',lm);
    meLms.EditText:=FormatFloat('00.00',es);
  end else begin
     meLmD.edittext:='0000';
     meLmM.edittext:='0';
     meLmS.edittext:='0';
  end;

   if dm_Get_word(911,0,day) then
     CBoxTagCrd.ItemIndex:=day-1
   else
     CBoxTagCrd.ItemIndex:=-1;

   if Dm_Get_long(995,0,dattag.dx) then begin
     meTagdx.EditText:=Inttostr(dattag.dx)
   end
   else
     meTagdx.EditText:='0';
   if Dm_Get_long(996,0,dattag.dy) then begin
     meTagdy.EditText:=Inttostr(dattag.dy)
   end
   else
     meTagdy.EditText:='0';
   if Dm_Get_long(997,0,dattag.dz) then begin
     meTagdz.EditText:=Inttostr(dattag.dz)
   end
   else
     meTagdz.EditText:='0';

   if dm_Get_word(913,0,day) then begin
     case day of
     1:  CmBxprj.ItemIndex:=2;  //Поперечная равноугольная цилиндрическая проекция Гаусса
     3:  CmBxprj.ItemIndex:=0;  // Нормальная равноугольная цилиндрическая проекция Меркатора
     4:  CmBxprj.ItemIndex:=3;  // Коническая
     9:  CmBxprj.ItemIndex:=1;  // Поперечный Меркатор
     10: CmBxprj.ItemIndex:=6;  // Азимутальная косая стереографическая  проекция
     11: CmBxprj.ItemIndex:=7;  // Азимутальная косая стереографическая  проекция (полюс)
     12,13: CmBxprj.ItemIndex:=8;  // Азимутальная нормальная стереографическая  проекция
     14,15: CmBxprj.ItemIndex:=4;  //  Азимутальная нормальная гномоническая  проекция
     16: CmBxprj.ItemIndex:=9;  // Азимутальная поперечная стереографическая  проекция
     17: CmBxprj.ItemIndex:=5;  //  Азимутальная поперечная гномоническая  проекция
     18: CmBxprj.ItemIndex:=10; // Азимутальная косая гномоническая проекция
     19: CmBxprj.ItemIndex:=11; // Азимутальная косая гномоническая проекция (полюс)
     20: CmBxprj.ItemIndex:=14; // Азимутальная косая равнопромежуточная Постеля
     21: CmBxprj.ItemIndex:=15; // Азимутальная косая равнопромежуточная Постеля (полюс)
     22,23: CmBxprj.ItemIndex:=12; // Азимутальная нормальная равнопромежуточная Постеля
     24: CmBxprj.ItemIndex:=13; // Азимутальная поперечная равнопромежуточная Постеля
     25: CmBxprj.ItemIndex:=16; // Азимутальная косая равновеликая Ламберта

   else
     CmBxprj.ItemIndex:=17;
     end
   end
   else
     CmBxprj.ItemIndex:=-1;

   if dm_Get_double(971,0,netintb) then begin
      netintB:=netintB/pi*180;
      lbm:=trunc(netintB);

    lm:=trunc((abs(netintB)-lBm)*60.0);
    es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
    if es>=59.9 then begin es:=0; inc(lm) end;
    if lm=60 then begin lm:=0; inc(lBm) end;
      meBStepD.edittext:=Inttostr(lbm);
      meBStepM.edittext:=Inttostr(lm);
      meBStepS.edittext:=Inttostr(round(es));
   end else begin
     meBStepD.edittext:='00';
     meBStepM.edittext:='0';
     meBStepS.edittext:='0';
   end;

  if dm_Get_double(972,0,netintL) then begin
   netintB:=netintL/pi*180;
   lbm:=trunc(netintB);
   lm:=trunc((abs(netintB)-lBm)*60.0);
   es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
   if es>=59.9 then begin es:=0; inc(lm) end;
   if lm=60 then begin lm:=0; inc(lBm) end;
      meLStepD.edittext:=Inttostr(lbm);
      meLStepM.edittext:=Inttostr(lm);
      meLStepS.edittext:=Inttostr(round(es));
   end else begin
     meLStepD.edittext:='00';
     meLStepM.edittext:='0';
     meLStepS.edittext:='0';
   end;

   if dm_Get_string(907,255,Sname) then begin
     edGrif.text:=CP866ToUTF8(sname);
    end else
     edGrif.text:='';
 if dm_get_long(904,0,iscale) then begin
   RgScale.ItemIndex:=0;
   if iscale=1000 then CmbxScale.ItemIndex:=0
   else
   if iscale=1500 then CmbxScale.ItemIndex:=1
   else
   if iscale=2000 then CmbxScale.ItemIndex:=2
   else
   if iscale=2500 then CmbxScale.ItemIndex:=3
   else
   if iscale=3000 then CmbxScale.ItemIndex:=4
   else
   if iscale=4000 then CmbxScale.ItemIndex:=5
   else
   if iscale=5000 then CmbxScale.ItemIndex:=6
   else
   if iscale=6000 then CmbxScale.ItemIndex:=7
   else
   if iscale=7000 then CmbxScale.ItemIndex:=8
   else
   if iscale=7500 then CmbxScale.ItemIndex:=9
   else
   if iscale=10000 then CmbxScale.ItemIndex:=10
   else
   if iscale=12500 then CmbxScale.ItemIndex:=11
   else
   if iscale=15000 then CmbxScale.ItemIndex:=12
   else
   if iscale=17500 then CmbxScale.ItemIndex:=13
   else
   if iscale=20000 then CmbxScale.ItemIndex:=14
   else
   if iscale=25000 then CmbxScale.ItemIndex:=15
   else
   if iscale=30000 then CmbxScale.ItemIndex:=16
   else
   if iscale=37500 then CmbxScale.ItemIndex:=17
   else
   if iscale=40000 then CmbxScale.ItemIndex:=18
   else
   if iscale=50000 then CmbxScale.ItemIndex:=19
   else
   if iscale=75000 then CmbxScale.ItemIndex:=20
   else
   if iscale=100000 then CmbxScale.ItemIndex:=21
   else
   if iscale=150000 then CmbxScale.ItemIndex:=22
   else
   if iscale=200000 then CmbxScale.ItemIndex:=23
   else
   if iscale=250000 then CmbxScale.ItemIndex:=24
   else
   if iscale=300000 then CmbxScale.ItemIndex:=25
   else
   if iscale=500000 then CmbxScale.ItemIndex:=26
   else
   if iscale=750000 then CmbxScale.ItemIndex:=27
   else
   if iscale=1000000 then CmbxScale.ItemIndex:=28
   else
   if iscale=1500000 then CmbxScale.ItemIndex:=29
   else
   if iscale=2000000 then CmbxScale.ItemIndex:=30
   else
   if iscale=2500000 then CmbxScale.ItemIndex:=31
   else
   if iscale=3000000 then CmbxScale.ItemIndex:=32
   else
   if iscale=5000000 then CmbxScale.ItemIndex:=33
   else
   if iscale=10000000 then CmbxScale.ItemIndex:=34
   else begin
     Rgscale.ItemIndex:=1;
     edscale.Text:=Inttostr(iscale)
   end;
 end else
  CmbxScale.ItemIndex:=0;

   if dm_Get_string(804,255,Sname) then begin
     edResol.text:=sname
    end else
     edResol.text:='';

    if dm_get_word(805,0,Day) then
       CmbxProfile.ItemIndex:=Day
    else
       CmbxProfile.ItemIndex:=0;
    if dm_Get_string(806,255,Sname) then begin
     edProdType.text:=CP866ToUTF8(sname);
    end else
     edProdType.text:='';

    if dm_Get_string(807,255,Sname) then begin
     edIdNumb.text:=CP866ToUTF8(sname);
    end else
     edIdNumb.text:='';

    if dm_Get_string(808,255,Sname) then begin
     edRedNumb.text:=CP866ToUTF8(sname);
    end else
     edRedNumb.text:='';

   if dm_Get_long(809,0,ltime) then begin
     Year:=Ltime div 10000;
     month:=(Ltime- Year*10000) div 100;
     Day:=Ltime-Year*10000-month*100;
     meSostDate.EditText:=Format('%2d.%2d.%4d',[Day,month,Year]);
   end else
     meSostDate.EditText:='';

   if dm_Get_long(810,0,ltime) then begin
     Year:=Ltime div 10000;
     month:=(Ltime- Year*10000) div 100;
     Day:=Ltime-Year*10000-month*100;
     meDateIM.EditText:=Format('%2d.%2d.%4d',[Day,month,Year]);
   end else
     meDateIM.EditText:='';

   if dm_Get_long(811,0,ltime) then begin
     Year:=Ltime div 10000;
     month:=(Ltime- Year*10000) div 100;
     Day:=Ltime-Year*10000-month*100;
     meS_57.EditText:=Format('%2d.%2d.%4d',[Day,month,Year]);
   end else
     meS_57.EditText:='';

   if dm_Get_long(812,0,ltime) then begin
     Year:=Ltime div 10000;
     month:=(Ltime- Year*10000) div 100;
     Day:=Ltime-Year*10000-month*100;
     meS_57_A.EditText:=Format('%2d.%2d.%4d',[Day,month,Year]);
   end else
     meS_57_A.EditText:='';

    if dm_get_word(813,0,Day) then
       CmbxIntent.ItemIndex:=Day
    else
       CmbxIntent.ItemIndex:=0;

   if dm_Get_string(814,255,Sname) then begin
     edIdComment.text:=CP866ToUTF8(sname);
    end else
    edIdComment.text:='';
    if dm_get_word(815,0,Day) then
       CmbxGeoSys.itemindex:=Day
    else
       CmbxGeoSys.itemindex:=0;
   if not dm_Get_Long(816,0,Ltime) then begin
     CMbxDepthNULL.ItemIndex:=Ltime;
   end
   else
     CMbxDepthNULL.ItemIndex:=0;

   if dm_Get_string(817,255,Sname) then begin
     edParScale.text:=CP866ToUTF8(sname);
    end else
     edParScale.text:='';

   if dm_Get_string(818,255,Sname) then begin
     edDepthUnit.text:=CP866ToUTF8(sname);
    end else
     edDepthUnit.text:='';

   if dm_Get_string(819,255,Sname) then begin
     edhUnit.text:=CP866ToUTF8(sname);
    end else
     edhUnit.text:='';

   if dm_Get_string(820,255,Sname) then begin
     edParComment.text:=CP866ToUTF8(sname);
    end else
     edParComment.text:='';

   if dm_Get_string(821,255,Sname) then begin
     edSpec.text:=CP866ToUTF8(sname);
    end else
     edSpec.text:='';

   if dm_Get_string(822,255,Sname) then begin
     edSpecNumb.text:=CP866ToUTF8(sname);
    end else
     edSpecNumb.text:='';

   if dm_Get_long(823,0,ltime) then begin
     Year:=Ltime div 10000;
     month:=(Ltime- Year*10000) div 100;
     Day:=Ltime-Year*10000-month*100;
     meSpecDate.EditText:=Format('%2d.%2d.%4d',[Day,month,Year]);
   end else
     meSpecDate.EditText:='';

   if dm_Get_string(824,255,Sname) then begin
     edCountry.text:=CP866ToUTF8(sname);
    end else
     edCountry.text:='';

   if dm_Get_string(825,255,Sname) then begin
     edAgency.text:=CP866ToUTF8(sname);
    end else
     edAgency.text:='';

   if dm_Get_string(826,255,Sname) then begin
     edDataCriteria.text:=CP866ToUTF8(sname);
    end else
     edDataCriteria.text:='';

    if dm_Get_string(827,255,Sname) then begin
     edDataStructure.text:=CP866ToUTF8(sname);
    end else
     edDataStructure.text:='';

   if dm_Get_string(828,255,Sname) then begin
     edHistComment.text:=CP866ToUTF8(sname);
    end else
     edHistComment.text:='';

   if dm_Get_string(829,255,Sname) then begin
     edHorErr.text:=CP866ToUTF8(sname);
    end else
    edHorErr.text:='';

   if dm_Get_string(830,255,Sname) then begin
     edVertErr.text:=CP866ToUTF8(sname);
   end else
     edVertErr.text:='';


   if dm_Get_string(831,255,Sname) then begin
     edErrComment.text:=CP866ToUTF8(sname);
   end else
     edErrComment.text:='';

   if not dm_Get_Long(832,0,Ltime) then begin
     CMbxHEIGHTNULL.ItemIndex:=Ltime;
   end
   else
     CMbxHeightNULL.ItemIndex:=0;
    if dm_get_word(833,0,Day) then
       CmbxNavIntent.ItemIndex:=Day
    else
       CmbxNavIntent.ItemIndex:=0;

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

  netintB:=Rcorners[4].x/pi*180;
  lbm:=Trunc(abs(netintB));
  lm:=trunc((abs(netintB)-lBm)*60.0);
  es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
  if es>=59.9 then begin es:=0; inc(lm) end;
  if lm=60 then begin lm:=0; inc(lBm) end;

   if netintB>0 then
  meBSd.EditText:=FormatFloat('0000',lBm)
    else
  meBSd.EditText:=FormatFloat('-000',lBm);
  meBSm.EditText:=FormatFloat('00',lm);
  meBSs.EditText:=FormatFloat('00.00',es);

  netintB:=Rcorners[1].x/pi*180;
  lbm:=Trunc(abs(netintB));
  lm:=trunc((abs(netintB)-lBm)*60.0);
  es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
  if es>=59.9 then begin es:=0; inc(lm) end;
  if lm=60 then begin lm:=0; inc(lBm) end;
   if netintB>0 then
  meBNd.EditText:=FormatFloat('0000',lBm)
    else
  meBNd.EditText:=FormatFloat('-000',lBm);
  meBNm.EditText:=FormatFloat('00',lm);
  meBNs.EditText:=FormatFloat('00.00',es);
  netintB:=Rcorners[1].y/pi*180;
  lbm:=Trunc(abs(netintB));
    lm:=trunc((abs(netintB)-lBm)*60.0);
  es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
  if es>=59.9 then begin es:=0; inc(lm) end;
  if lm=60 then begin lm:=0; inc(lBm) end;

   if netintB>0 then
  meLWd.EditText:=FormatFloat('0000',lBm)
    else
  meLWd.EditText:=FormatFloat('-000',lBm);
  meLWm.EditText:=FormatFloat('00',lm);
  meLWs.EditText:=FormatFloat('00.00',es);
  netintB:=Rcorners[2].y/pi*180;

  lbm:=Trunc(abs(netintB));
    lm:=trunc((abs(netintB)-lBm)*60.0);
  es:=((abs(netintB)-lBm)*60.0-trunc((abs(netintB)-lBm)*60.0))*60.0;
  if es>=59.9 then begin es:=0; inc(lm) end;
  if lm=60 then begin lm:=0; inc(lBm) end;

   if netintB>0 then
  meLOd.EditText:=FormatFloat('0000',lBm)
    else
  meLOd.EditText:=FormatFloat('-000',lBm);
  meLOm.EditText:=FormatFloat('00',lm);
  meLOs.EditText:=FormatFloat('00.00',es);
   dmw_done
end;

procedure TFNavyHead.Button1Click(Sender: TObject);
var
OpenDlg:TOpenDialog;
Usr_dir:string;
pc:pchar;
begin
OpenDlg:=TOpenDialog.Create(FNavyHead);
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

end.
