unit U_Nav_Warn;

{$MODE Delphi}

interface

uses
  {$ifdef windows}
    windows,
  {$endif}
  LCLIntf, LCLType, SysUtils, Classes, Controls, Forms,
  Dialogs, IniFiles, StdCtrls,
  NevaUtil,
  {$ifdef windows}
    Dmw_ddw, dmw_Use,
  {$endif}
  OTypes, win_use, ExtCtrls, Convert,
  LazUTF8, LConvEncoding;

type
  TFNavWarning = class(TForm)
    OpenDlg: TOpenDialog;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    LB_Log: TListBox;
    Button3: TButton;
    Edit1: TEdit;
    Mem_NW: TMemo;
    LB_NW: TListBox;
    Button4: TButton;
    SaveDlg: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LB_NWDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LB_LogDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
   //  procedure WM_VScroll(var Msg: TWMVScroll); message WM_VSCROLL;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNavWarning: TFNavWarning;
  iniFile:TIniFile;
  s_Dir, sFile:AnsiString;
  fl_err:boolean;
implementation

{$R *.lfm}
{procedure TFNavWarning.WM_VScroll(var Msg: TWMVScroll);
begin

  ShowMessage('VScroll');

end;
}
procedure TFNavWarning.FormCreate(Sender: TObject);
var
  i:integer;
begin
 iniFile:=Tinifile.Create(Make_ini('WarNav.ini'));
 s_Dir:=IniFile.ReadString('Paths','NW_Path',Work_dir);
  i:=IniFile.ReadInteger('N','F_L',Left);
  if (i>=0) and (i<Screen.Width-100) then  Left:=i;
  i:=IniFile.ReadInteger('N','F_T',Top);
  if (i>=0) and (i<Screen.Height-100) then  Top:=i;
   i:=IniFile.ReadInteger('N','F_W',width);
  if (i>=800) and (i<Screen.Width) then  width:=i;
  i:=IniFile.ReadInteger('N','F_H',Height);
  if (i>=600) and (i<Screen.Height) then  Height:=i;
 Inifile.Free;
 dmw_connect;
end;

procedure TFNavWarning.FormDestroy(Sender: TObject);
begin
 iniFile:=Tinifile.Create(Make_ini('WarNav.ini'));
  IniFile.WriteString('Paths','NW_Path',s_Dir);
  IniFile.WriteInteger('N','F_L',Left);
  IniFile.WriteInteger('N','F_T',Top);
  IniFile.WriteInteger('N','F_W',width);
  IniFile.WriteInteger('N','F_H',Height);
 Inifile.Free;
 dmw_disconnect;
end;

procedure TFNavWarning.Button1Click(Sender: TObject);
var
  L : TStringList;
begin
  OpenDlg.InitialDir:=s_dir;
  if OpenDlg.Execute then begin
    Caption:='Навигационные предупреждения (режим просмотра)';
    //Mem_NW.lines.LoadFromFile(OpenDlg.FileName);

    L := TStringList.Create;
    L.LoadFromFile(OpenDlg.FileName, TEncoding.ANSI);
    Mem_NW.lines.Text := AnsiToUTF8(L.Text); // и вызываешь эту функцию для конвертирования в UTF8
    L.Free;
    LB_NW.items.Text:=Mem_NW.lines.Text;
    sFile:=ExtractFileName(OpenDlg.FileName)+#0;
//    CharToOEM(@sFile[1],@sFile[1]);
    sFile:=UTF8ToCP866(sFile);
    LB_Log.Items.Clear;
  end;
end;

function Define_PRIP(ibeg:integer; var ip, ifrst:integer):integer;
var
  ss:Shortstring;
  ii, i1,i2:integer;
  pc:Pchar;
  fDos:Boolean;
begin
  ifrst:=-1;
  fDos:=false;
  For ii:=ibeg to FNavWarning.Mem_NW.lines.Count-1 do begin
     ss:=FNavWarning.Mem_NW.lines[ii]+#0;
     pc:=StrPos(@ss[1],'ПЕРЕДАЧА');
     if assigned(pc) AND (pc=@ss[1])then begin
       ip:=ii;
       break;
     end else begin
       OEMTOChar(@ss[1],@ss[1]);
       pc:=StrPos(@ss[1],'ПЕРЕДАЧА');
       if assigned(pc) AND (pc=@ss[1]) then begin
         ip:=ii;
         fDos:=true;
         break;
       end
     end;
  end;
  if ip=-1 then begin
    Result:=-1;
    exit;
  end;
  if fDos then
    For ii:=0 to FNavWarning.Mem_NW.lines.Count-1 do begin
      ss:=FNavWarning.Mem_NW.lines[ii]+#0;
      OEMTOChar(@ss[1],@ss[1]);
      FNavWarning.Mem_NW.lines[ii]:=StrPas(@ss[1]);
    end;
   if ibeg=0 then begin
      i1:=ip+1;
      i2:=ip+4;
   end else begin
      i1:=ibeg;
      i2:=FNavWarning.Mem_NW.lines.Count-1
   end;
   Result:=-1;
   For ii:=i1 to i2 do begin
     ss:=FNavWarning.Mem_NW.lines[ii]+#0;
     pc:=StrPos(@ss[1],'ПРИП');
     if assigned(pc) AND (pc=@ss[1])then begin
       ifrst:=ii;
       Result:=3;
       exit;
     end;
     pc:=StrPos(@ss[1],'НАВИП');
     if assigned(pc) AND (pc=@ss[1]) then begin
       ifrst:=ii;
       Result:=2;
       exit;
     end;
     pc:=StrPos(@ss[1],'НАВАРЕА');
     if assigned(pc) AND (pc=@ss[1]) then begin
       ifrst:=ii;
       Result:=1;
       exit;
     end;
     pc:=StrPos(@ss[1],'ИСПРАВЛЕНИЕ НАВАРЕА');
     if assigned(pc) AND (pc=@ss[1]) then begin
       ifrst:=ii;
       Result:=4;
       exit;
     end;
   end;
end;

function Get_longDate(sTransf:string):longint;
var
  Year,Month, day, Y,M,D:word;
begin
  Year:=StrToInt(copy(stransf,5,2));
  DecodeDate(Now, Y,M,D);
  Year:=(Y div 100) * 100+ Year;
  Month:=StrToInt(copy(stransf,3,2));
  day:=StrToInt(copy(stransf,1,2));
  Result:=Year*10000 + Month*100 + Day;
end;

Function Get_DateTime(sdt,sY:string; var sres:ShortString; var  dt:TdateTime; var ldate, ltime:integer):boolean;
var
  s, sYear:shortstring;
  Year,Month, day, hh, min, Y,M,D:word;
  pc:Pchar;
begin
 try
  Month:=0;
  if AnsiPos('ЯНВ',sdt)>0 then Month:=1
  else if AnsiPos('ФЕВ',sdt)>0 then Month:=2
  else if AnsiPos('МАРТ',sdt)>0 then Month:=3
  else if AnsiPos('АПР',sdt)>0 then Month:=4
  else if AnsiPos('МАЙ',sdt)>0 then Month:=5
  else if AnsiPos('ИЮНЬ',sdt)>0 then Month:=6
  else if AnsiPos('ИЮЛЬ',sdt)>0 then Month:=7
  else if AnsiPos('АВГ',sdt)>0 then Month:=8
  else if AnsiPos('СЕНТ',sdt)>0 then Month:=9
  else if AnsiPos('ОКТ',sdt)>0 then Month:=10
  else if AnsiPos('НОЯБ',sdt)>0 then Month:=11
  else if AnsiPos('ДЕК',sdt)>0 then Month:=12;
  s:=Copy(sdt,1,2);
  day:=StrToInt(s);
  if (sdt[3]>='0') AND (sdt[3]<='9') then begin
    s:=Copy(sdt,3,2);
    hh:=StrToInt(s);
    s:=Copy(sdt,5,2);
    min:=StrToInt(s);
  end else begin
    hh:=0;
    min:=0;
  end;
  s:=sdt;
  pc:=StrRScan(@s[1],' ');
  if ((pc+1)^>='0') AND ((pc+1)^<='9') then begin
    sYear:=StrPas(pc+1);
    Year:=StrToInt(sYear);
    if Year<100 then begin
      dt:=Now;
      DecodeDate(dt, Y,M,D);
      Year:=(Y div 100) * 100+ Year
    end;
  end else begin
    Year:=StrToInt(sY);
    dt:=Now;
    DecodeDate(dt, Y,M,D);
    Year:=(Y div 100) * 100+ Year;
  end;
  dt:= EncodeDate(Year,Month,Day)+EnCodeTime(hh,min,0,0);
  sres:=FormatDateTime( 'dd.mm.yyyy hh:nn',dt);
  ldate:=Year*10000 + Month*100 + Day;
  lTime:=hh*3600 + min*60;

  Result:=true;
 Except
    Result:=false;
 end
end;

function Isdigit(c:Widechar):boolean;
begin
  Result:=(c>='0') and (c<='9');
end;

function Isdig(c:char):boolean;
begin
  Result:=(c>='0') and (c<='9');
end;

function mk_txt(tg:Tgauss):string;
var
  sht:shortstring;
  cLat, cLon:char;
begin
    if tg.x>0 then cLat:='N' else cLat:='S';
    if tg.y>0 then cLon:='E' else cLon:='W';
    Result:=StrPas(StrAngle(@sht[1],abs(tg.x),3))+cLat+'   '+StrPas(StrAngle(@sht[1],Abs(tg.y),3))+cLon;
end;

const
  doubleQout : Char = ' ';
  degree : Char = ' ';
  rusC : WideChar =  ' ';
  rusYu : WideChar = ' ';
  rusZ : WideChar =  ' ';
  rusV : WideChar = ' ';

function Get_coords(scoords:wideString; var tgRes:tgauss; var iEnd:Integer; var s_err:shortstring):boolean;
var
    sln, sdig: WideString;
    ss:Ansistring;
    icnt_dig, q_dig, Q_b, Q_L, ii, idig,ind_dig, icnt_def:integer;
    dig_array:array[1..256] of integer;
    ind_array:array[1..256] of integer;
    qnt_array:array[1..256] of integer;
    fl_sec, fl_N, fl_E:boolean;

procedure proc_dig;
var
  DD, dv,  dB, dL:double;
  i:integer;
begin
  DD:=dig_array[1]+dig_array[2]/60;
  if fl_sec then  begin
    DD:=dd+dig_array[3]/3600;
    if Q_b=4 then begin
      dv:=1;
      for i:=1 to qnt_array[4] do
        dv:=dv*10;
      DD:=dd+dig_array[4]/3600/dv;
    end;
  end else begin
    if Q_b=3 then begin
     dv:=1;
      for i:=1 to qnt_array[3] do
        dv:=dv*10;
      DD:=dd+dig_array[3]/60/dv;
    end
  end;
  dB:=dd*PI/180;
  if not fl_N then
    db:=-db;

  DD:=dig_array[Q_b+1]+dig_array[Q_b+2]/60;
  if fl_sec then  begin
    DD:=dd+dig_array[Q_b+3]/3600;
    if Q_l=4 then begin
      dv:=1;
      for i:=1 to qnt_array[Q_b+4] do
        dv:=dv*10;
      DD:=dd+dig_array[Q_b+4]/3600/dv;
    end;
  end else begin
    if Q_l=3 then begin
     dv:=1;
      for i:=1 to qnt_array[Q_b+3] do
        dv:=dv*10;
      DD:=dd+dig_array[Q_b+3]/60/dv;
    end
  end;
  if dd>180 then begin
     s_err:='Долгота больше 180';
     Result:=false;
     exit;
  end;
  dL:=dd*PI/180;
  if not fl_E then
    dl:=-dl;
  fl_sec:=false;
  q_dig:=9;
  q_b:=3;
  icnt_dig:=0;
  sdig:='';
   tgRes.x:=db;
   tgRes.y:=dl;
   Result:=true;
end;

begin
  s_err:='';
  icnt_def:=0;
  iEnd:=1;
  Result:=false;
  sln:=trim(scoords);
  ss:=sln;
  sdig:='';
  fl_sec:=false;
  q_dig:=9;
  q_b:=3;
  icnt_dig:=0;
  ind_dig:=0;
  for ii:=1 to Length(sln) do begin
     if isdigit(sln[ii]) then begin
       if sdig='' then
       ind_dig:=ii;
       sdig:=sdig+sln[ii];
     end else begin
       if sdig<>'' then begin
         if ((sln[ii]=WideChar($2033)) OR (sln[ii]=')') OR(sln[ii]=']') OR (sln[ii]='”') OR (sln[ii]='"') OR (sln[ii]='/')) and (icnt_dig<2) then begin
           fl_sec:=false;
           q_dig:=9;
           q_b:=3;
           icnt_dig:=0;
           sdig:='';
            continue;
         end;
         if (icnt_dig<q_b) and ((sln[ii]='°') or (sln[ii]='-')) then begin
                    if (sln[ii]='-') then
                    inc(icnt_def);
                    if icnt_def=1 then begin
                      fl_sec:=false;
                      q_dig:=9;
                      q_b:=3;
                      icnt_dig:=0;
                    end;
         end;
         idig:=StrToInt(sdig);
         if (icnt_dig=0) and (idig>90) then begin
             s_err:='Широта больше 90';
             exit;
         end;
         if (icnt_dig=q_b) and (idig>180) then begin
             s_err:='Долгота больше 180';
             exit;
         end;
         if ((icnt_dig<>0) OR (idig<90)) and (idig<1000) then begin
           if icnt_dig=0 then begin
                     icnt_dig:=1;
                     dig_array[1]:=idig;
                     ind_array[1]:=ii-1;
                     qnt_array[1]:=Length(sdig);
            end else begin
              if ind_dig-ind_array[icnt_dig]>6 then begin
                       icnt_dig:=1;
                       dig_array[icnt_dig]:=idig;
                       ind_array[icnt_dig]:=ii-1;
                       qnt_array[icnt_dig]:=Length(sdig);
              end else if (icnt_dig<>q_b) and (ind_dig-ind_array[icnt_dig]>3) then begin
                       dig_array[icnt_dig]:=idig;
                       ind_array[icnt_dig]:=ii-1;
                       qnt_array[icnt_dig]:=Length(sdig);
              end else begin
                       inc(icnt_dig);
                       dig_array[icnt_dig]:=idig;
                       ind_array[icnt_dig]:=ii-1;
                       qnt_array[icnt_dig]:=Length(sdig);
              end
            end;
         end;
         sdig:='';
       end;
       if (icnt_dig= 2) OR (icnt_dig= 3) OR (icnt_dig= 4)  then begin
         
         if (sln[ii]='N') or (sln[ii]='S') or (sln[ii]=rusC) or (sln[ii]='C') or (sln[ii]=rusYu) then begin
                fl_N:=(sln[ii]='N') or (ss[ii]=rusC) or (ss[ii]='C') ;
                Q_b:=icnt_dig;
                if icnt_dig=2 then dec(q_dig);
         end
       end;
       if icnt_dig>3 then
         if (sln[ii]='W') or (sln[ii]='E') or (sln[ii]=rusZ) or (sln[ii]=rusV) then begin
           fl_E:=(sln[ii]='E') or (ss[ii]=rusV);
           Q_L:=icnt_dig-Q_b;
           q_dig:=icnt_dig;
           iEnd:=ii;
         end;
         if (sln[ii]=WideChar($2033)) OR (sln[ii]='"') OR (sln[ii]='”') OR (icnt_def>1) then
           fl_sec:=true;
         if icnt_dig=q_dig then begin
           proc_dig;
           break
         end;
     end;
  end;
  if not Result then begin
     if s_err='' then begin
        s_err:='Ошибка в написании координат'
     end;
  end;
end;


function Proc_Crd(ws:WideString):string;
var
  ii, iEnd, jj, J_Lon:Integer;
  wss:WideString;
  s_s:shortstring;
  sln:Ansistring;
  tgRes:tgauss;
  fl_crd, fl_gr, fl_bad:boolean;
begin
  Result:='';
  ii:=1;
  plGlobal.N:=-1;
  sln:=ws;
  while ii<Length(ws) do begin
    if isdigit(ws[ii]) then begin
       jj:=ii+1;
       fl_crd:=false;
       fl_gr:=false;
       fl_bad:=false;
       if ii+12<Length(ws) then
       while (jj<ii+12) do begin
          if ((ws[jj]='°') or (ws[jj]='-')) then begin
            fl_gr:=true;
          end else
          if not isdigit(ws[jj]) then
          if (ws[jj]='N') or (ws[jj]='S') or (WS[jj]=rusC)  or (WS[jj]='C') or (WS[jj]=rusYu) then begin
            fl_crd:=true;
            J_Lon:=jj;
            break
          end else              //  '”'  '°'
            if  not (WS[jj] in['"', doubleQout, '''', '.', ' ', '-', degree]) then
              fl_bad:=true;

          inc(jj);
       end;
       if not fl_crd and fl_gr then begin
         plGlobal.N:=-1;
         Result:='Некорректное значение  или отсутствует признак полушария широты';
         exit;
       end;
       if fl_crd and fl_gr and  isdigit(ws[ii+1]) and not((ws[ii+2]='°') or (ws[ii+2]='-')) then begin
         plGlobal.N:=-1;
         Result:='Некорректное значение градусов широты';
         exit;
       end else begin
         if fl_crd and fl_gr  and fl_bad AND isdigit(ws[ii+1]) then begin
           plGlobal.N:=-1;
           Result:='Некорректные  символы в значение широты';
           exit;
        end
       end;
       if fl_crd and fl_gr then begin
       jj:=J_lon+1;
       fl_crd:=false;
       fl_gr:=false;
       fl_bad:=false;
       if J_lon+13<Length(ws) then
       while jj<J_lon+13 do begin
          if ((ws[jj]='°') or (ws[jj]='-')) then begin
            fl_gr:=true;
          end else
          if not isdigit(ws[jj]) then
          if (ws[jj]='W') or (ws[jj]='E') or (sln[jj]=rusZ)  or (sln[jj]=rusV) then begin
            fl_crd:=true;
            break;
          end else
            if  not (sln[jj] in['"', doubleQout, '''', '.', ' ']) then
              fl_bad:=true;

          inc(jj);
       end;
       if not fl_crd and fl_gr then begin
         plGlobal.N:=-1;
         Result:='Некорректное значение  или отсутствует признак полушария долготы';
         exit;
       end;
       if fl_crd and fl_gr  and fl_bad  then begin
           plGlobal.N:=-1;
           Result:='Некорректные  символы в значение долготы';
           exit;
       end
       end;
    end;
    if isdigit(ws[ii]) AND ((ws[ii+2]='°') or (ws[ii+2]='-'))  then begin
       wss:=Copy(ws,ii, Length(ws)-ii+1);

       if Get_coords(wss, tgRes, iEnd, s_s) then begin
         inc(plGlobal.N);
         dm_R_to_L(tgRes.x, tgRes.y, plGlobal.pol[plGlobal.N].X, plGlobal.pol[plGlobal.N].Y);
         ii:=ii+iEnd;
       end else begin
         plGlobal.N:=-1;
         Result:=s_s;
         exit
       end
    end;
    inc(ii)
  end;
end;

procedure TFNavWarning.Button2Click(Sender: TObject);
var
 st, ss, s_err,  s_errCrd, sTransf, sarea, sn, sOsnov, s1, s2, s3:AnsiString;
 dt:TdateTime;
 st1, st2, sRegPrip, s725, s725eng, sRus, sEng:shortstring;
 l714, i746, i733, inodecnt, icnt, ii, jj, ip, itype, NodeP, NodeMetric,
 NodePNext, NodeP2, NodeP2Next,
 ifrst, iend, ifrstPunkt, ipunkt, ipunktNext, ipunktNew, iOsnov, NodeNW,
 lcode, lcodeP, lcodePP, lCodeMetric, i_err, ipos, NodeCurr, jpos,
 lCodeCanc, NodeCancel, nd1, nd2, ldate, ldate_tr, l_dt, ltime, l_Y, Iter,
 i_Eng, iend_Eng:integer;
 pmap, pc, pc2:Pchar;
 pnodes, plines:array[1..100] of integer;
 pPoolBuff:pPool;
 ws, wsHead:WideString;
 chnext, ch2, ch2next, slink, stt, sReg, sReg2:shortstring;
 ww:word;
 Year, Month, Day: Word;
 Label
   Lab0, lCanc;

function get_eng_Numb(st:shortstring; var sRes:shortstring):boolean;
var
  pc_t:pChar;
  itEng:integer;
  sRegPripEng, sReg_eng:shortstring;
begin
  result:=false;
  itEng:=-1;
  pc:=StrPos(@ss[1],'COASTAL WARNING');
     if assigned(pc) AND (pc=@ss[1])then begin
       itEng:=3;
       pc_t:=pc+16;
       Result:=true;
     end;
     pc:=StrPos(@ss[1],'NAVAREA');
     if assigned(pc) AND (pc=@ss[1]) then begin
       itEng:=1;
       pc_t:=pc+8;
       Result:=true;
     end;

 if result then begin
  if itEng=3 then begin
        pc:=StrScan(pc_t,' ');
        pc^:=#0;
        sRegPripEng:=StrPas(pc_t);
        pc2:=StrScan(pc+1,'/');
        if Not assigned(pc2) then begin
          sRes:=StrPas(pc+1)+'/'+ copy(stransf,5,2)+#0;
          s_err:=s_err+'Добавлен год к номеру ПРИП; ';
          inc(i_err);
        end else
          sRes:=StrPas(pc+1);
    end else begin
        pc:=StrScan(pc_t,' ');
        pc^:=#0;
        sReg_eng:=StrPas(pc_t);
        pc2:=StrScan(pc+1,'/');
        if Not assigned(pc2) then begin
          sRes:=StrPas(pc+1)+'/'+ copy(stransf,5,2)+#0;
          s_err:=s_err+'Добавлен год к номеру ПРИП; ';
          inc(i_err);
        end else
          sRes:=StrPas(pc+1);
    end;
 end
end;

begin
  Getmem(pPoolBuff, 65528);
  fl_err:=false;

  i_err:=0;
  icnt:=0;
  if Mem_NW.lines.Count<1 then begin
    ShowMessage('Нет открытых предупреждений');
    exit;
  end;
  ip:=-1;
  itype:=Define_PRIP(0, ip,ifrst);
  if itype=-1 then begin
    ShowMessage('Не верный формат: отсутствует ПЕРЕДАЧА или ПРИП/НАВАРЕА/НАВИП');
    exit;
  end;
  pmap:=dmw_ActiveMap(pFiles, 65528);
  if not assigned(pMap) then  begin
    ShowMessage('Нет карты');
    exit;
  end;
  for Iter:=0 to 1 do begin
   ip:=-1;
   itype:=Define_PRIP(0, ip,ifrst);

   LB_log.Items.Clear;
   for ii:= 1 to Mem_NW.lines.count  do
     LB_log.Items.Add(' ');
  if dmw_open(pMap,true)>0 then begin
    dmx_find_frst_code(0,1);
    dm_Goto_last;
    wsHead:='';
    Lab0:
    inodecnt:=0;
    case itype of
      1:lcode:=String2Code('X3110000');
      2:lcode:=String2Code('X3120000');
      3:lcode:=String2Code('X3130000');
      4:lcode:=String2Code('X3140000');
    end;
    case itype of
      1:lcodeMetric:=String2Code('X9510000');
      2:lcodeMetric:=String2Code('X9520000');
      3:lcodeMetric:=String2Code('X9530000');
      4:lcodeMetric:=String2Code('X9510000');
    end;

    s_err:='';
    inc(Icnt);
    if Iter=1 then begin
      NodeNW:=dm_Add_Object(lcode,loc_info,0,NIL,NIL,NIL, false);
      dm_Put_Dbase(753,1);
    end;
    //dm_Put_String(713,@sFile[1]);
    //sAnsi := UTF8ToAnsi(Mem_NW.lines[ip]);
    sTransf:=UTF8copy(Mem_NW.lines[ip],10,255)+#0;
    ldate_tr:=Get_longDate(sTransf);
    l_Y:=ldate_tr div 10000;
    Decodedate(now, Year, Month, Day);

    If l_Y<Year then  begin
       fl_err:=true;
       lb_log.Items[ip]:='Ошибка в формате даты передачи. Год передачи меньше текущего: '+sTransf+'; '
    end
    else begin
      l_dt:=Year*10000 + Month*100 + Day;
      If ldate_tr>l_dt then begin
        fl_err:=true;
        lb_log.Items[ip]:='Ошибка в формате даты передачи. Дата передачи больше текущей: '+sTransf+'; '
      end;
    end;
    if Iter=1 then begin
      dm_put_date(760,ldate_tr);
      //dm_Put_String(200,@sTransf[1]);
    end;
    if (ip>0) AND (wsHead='') then begin
      st:='';
      for ii:=0 to ip-1 do begin
        st:=st+Mem_NW.lines[ii]+#$0D#$0A;
      end;
      wsHead:=trim(st);
    end;
    if Iter=1 then begin
      if wsHead<>'' then
        dm_Put_Text(201,wsHead);
    end;
    if itype=3 then begin
        st:=copy(Mem_NW.lines[ifrst],6,255)+#0;
        pc:=StrScan(@st[1],' ');
        pc^:=#0;
        ss:=StrPas(@st[1])+#0;
        //CharToOEM(@ss[1],@ss[1]);
        ss:=UTF8ToCP866(ss);

        sRegPrip:=StrPas(@ss[1]);
        if Iter=1 then begin
          i746:=dm_enum_Indexof(dm_ind_Blank,746, @ss[1]);
          //dm_Put_String(733,@ss[1]);
          dm_Put_Dbase(746,i746);
        end;
        //dm_Put_String(746,@ss[1]);
        st:=StrPas(pc+1)+#0;

        pPoolBuff^.Len:=0;

        pc:=StrPos(@st[1],'КАРТ');

        if assigned(pc) then begin
          stt:=StrPas(pc+6)+#0;
          //CharToOEM(@stt[1],@stt[1]);
          stt:=UTF8ToCP866(stt);
          // dm_Put_String(727,@ss[1]);
          dm_hf_Pool_Put(pPoolBuff,65528,727, _string, pBytes(@stt));

        end else begin
          pc:=StrPos(@st[1],'КНИГ');
          if assigned(pc) then begin
            stt:=StrPas(pc+6)+#0;
            //CharToOEM(@stt[1],@stt[1]);
            stt:=UTF8ToCP866(stt);

            //dm_Put_String(728,@ss[1]);
            dm_hf_Pool_Put(pPoolBuff,65528,728, _string, pBytes(@stt));
        end else begin
             pc:=StrPos(@st[1],'ЭНК');
             if assigned(pc) then begin
               stt:=StrPas(pc+4)+#0;
               //CharToOEM(@stt[1],@stt[1]);
               stt:=UTF8ToCP866(stt);

               //dm_Put_String(729,@ss[1]);
             dm_hf_Pool_Put(pPoolBuff,65528,729, _string, pBytes(@stt));
           end
          end;
        end;
        if Iter=1 then begin
          dm_Add_DataType(751,pPoolBuff);
        end;
        if assigned(pc) then pc^:=#0;
        ss:=TRIM(StrPas(@st[1]))+#0;
        pc2:=StrScan(@ss[1],'/');
        if Not assigned(pc2) then begin
          sn:=StrPas(@ss[1]);
          ss:=StrPas(@ss[1])+'/'+ copy(stransf,5,2)+#0;
          s_err:=s_err+'Добавлен год к номеру ПРИП; ';
          inc(i_err);
        end else begin
          sn:=copy(ss, 1, (pc2-pchar(@ss[1])));
        end;
        if Iter=1 then begin
         // CharToOEM(@ss[1],@ss[1]);
          ss:=UTF8ToCP866(ss);
          dm_Put_String(725,@ss[1]);
        end;
        s725:=ss;

    end else begin
        st:=Mem_NW.lines[ifrst]+#0;
        pc:=StrScan(@st[1],' ');
        st:=StrPas(pc+1)+#0;
        pc:=StrScan(@st[1],' ');
        pc^:=#0;
        ss:=StrPas(@st[1])+#0;
        //CharToOEM(@ss[1],@ss[1]);
        if Iter=1 then begin
          i733:=dm_enum_Indexof(dm_ind_Blank,733, @ss[1]);
          //dm_Put_String(733,@ss[1]);
          dm_Put_Dbase(733,i733);
        end;
        sarea:=StrPas(@ss[1]);
        st:=StrPas(pc+1)+#0;

        pPoolBuff^.Len:=0;

        pc:=StrPos(@st[1],'КАРТ');
        if assigned(pc) then begin
          stt:=StrPas(pc+6)+#0;
          //CharToOEM(@stt[1],@stt[1]);
          stt:=UTF8ToCP866(stt);

          // dm_Put_String(727,@ss[1]);
          dm_hf_Pool_Put(pPoolBuff,65528,727, _string, pBytes(@stt));

        end else begin
          pc:=StrPos(@st[1],'КНИГ');
          if assigned(pc) then begin
            stt:=StrPas(pc+6)+#0;
            //CharToOEM(@stt[1],@stt[1]);
             stt:=UTF8ToCP866(stt);

            //dm_Put_String(728,@ss[1]);
            dm_hf_Pool_Put(pPoolBuff,65528,728, _string, pBytes(@stt));
        end else begin
             pc:=StrPos(@st[1],'ЭНК');
             if assigned(pc) then begin
              stt:=StrPas(pc+4)+#0;
              //CharToOEM(@stt[1],@stt[1]);
               stt:=UTF8ToCP866(stt);

              //dm_Put_String(729,@ss[1]);
             dm_hf_Pool_Put(pPoolBuff,65528,729, _string, pBytes(@stt));
           end
          end;
        end;
        if Iter=1 then begin
          dm_Add_DataType(751,pPoolBuff);
        end;
        if assigned(pc) then pc^:=#0;
        ss:=TRIM(StrPas(@st[1]))+#0;
        pc2:=StrScan(@ss[1],'/');
        if Not assigned(pc2) then begin
          sn:=sarea+' '+StrPas(@ss[1]);
          ss:=StrPas(@ss[1])+'/'+ copy(stransf,5,2)+#0;
          s_err:=s_err+'Добавлен год к номеру предупреждения; ';
          inc(i_err);
        end else begin
          sn:=sarea+' '+copy(ss, 1, (pc2-pchar(@ss[1])));
        end;
        if Iter=1 then begin
          //CharToOEM(@ss[1],@ss[1]);
           ss:=UTF8ToCP866(ss);

          dm_Put_String(725,@ss[1]);
        end;
        s725:=ss;
    end;
    if Iter=1 then begin
      dm_Put_dBase(753,1);
    end;
    st:='';
    iend:=0;
    ifrstPunkt:=0;
    sReg:='';
    sReg2:='';
    for ii:=ifrst+1 to Mem_NW.lines.Count-1 do begin

       ss:=TRIM(Mem_NW.lines[ii]);
       if copy(ss,1,2)='1.' then
         ifrstPunkt:=ii;
       if (ss='НННН') OR (ss='NNNN') then begin
          iend:=ii;
          break;
       end;
       ss:=ss+#0;
       if (ii=ifrst+1) AND (copy(ss,1,2)<>'1.') then begin
          sReg:=TRIM(Mem_NW.lines[ii])
        end;
       if (sReg<>'') AND(ii=ifrst+2) AND (copy(ss,1,2)<>'1.') then begin
          sReg2:=TRIM(Mem_NW.lines[ii])
       end;
     if AnsiPos('ПРИП',ss)=1 then begin
       iend:=ii;
       break
     end;
     if AnsiPos('НАВИП',ss)=1 then begin
       iend:=ii;
       break
     end;
     if AnsiPos('НАВАРЕА',ss)=1 then begin
       iend:=ii;
       break
     end;
     if AnsiPos('ВЫПУСК',ss)=1 then begin
       iend:=ii;
       break
     end;

       st:=st+Mem_NW.lines[ii]+#$0D#$0A;

    end;
    if ifrstPunkt=0 then begin
      sReg2:='';
      ifrstPunkt:=ifrst+2;
    end;
  //  stt:=st+#0;
  //  CharToOEM(@stt[1],@stt[1]);
    //ws:=trim(st);
    //dm_Put_Text(730,ws);
    if (sReg<>'') THEN begin
      pPoolBuff^.Len:=0;
  //
      stt:=sReg+#0;
      //CharToOEM(@stt[1],@stt[1]);
      stt:=UTF8ToCP866(stt);

      dm_hf_Pool_Put(pPoolBuff,65528,748, _string, pBytes(@stt));
      if (sReg2<>'') THEN begin
        stt:=sReg2+#0;
        //CharToOEM(@stt[1],@stt[1]);
        stt:=UTF8ToCP866(stt);
        dm_hf_Pool_Put(pPoolBuff,65528,749, _string, pBytes(@stt));
      end;
      if Iter=1 then begin
        dm_Add_DataType(750,pPoolBuff);
      end;
    end;
    iOsnov:=0;

    for ii:=iend+1  to Mem_NW.lines.Count-1 do begin
       ss:=TRIM(Mem_NW.lines[ii])+#0;
       pc:=StrPos(@ss[1],'ОСНОВАНИЕ');
       if assigned(pc) then begin
         iOsnov:=ii;
         break
       end;
    end;

    if iOsnov<>0 then begin
      sOsnov:='';
      for ii:=iOsnov+1  to Mem_NW.lines.Count-1 do begin
        ss:=TRIM(Mem_NW.lines[ii])+#0;
        ipos:=AnsiPos(sn,ss);
        if ipos=1 then begin
           pc:=StrScan(@ss[1],'-');
           if assigned(pc) then begin
             sOsnov:=StrPas(pc+1);
             if sOsnov[Length(sOsnov)] = '=' then
               sOsnov:=copy(sOsnov,1,Length(sOsnov)-1);
           end;
        end;
        if ss[Length(ss)-1] = '=' then
        break;
      end;
      if Iter=1 then begin
        if sOsnov<>'' then begin
          ss:=sOsnov+#0;
          //CharToOEM(@ss[1],@ss[1]);
          ss:=UTF8ToCP866(ss);
          dm_Put_String(747,@ss[1]);
        end;
      end;
    end;


    case itype of
      1:lcodeP:=String2Code('X3211000');
      2:lcodeP:=String2Code('X3221000');
      3:lcodeP:=String2Code('X3231000');
      4:lcodeP:=String2Code('X3211000');
    end;
    case itype of
      1:lcodePP:=String2Code('X3310000');
      2:lcodePP:=String2Code('X3320000');
      3:lcodePP:=String2Code('X3330000');
      4:lcodePP:=String2Code('X3310000');
    end;

    ipunkt:=0;
    for ii:=ifrst+1  to iend-1 do begin
        ss:=TRIM(Mem_NW.lines[ii])+#0;
        if copy(ss,1,2)='1.' then begin
          ipunkt:=ii;
          break;
        end;
    end;
    if ipunkt=0 then
      ipunkt:=ifrstPunkt;

    if ipunkt<>0 then begin
      if Iter=1 then begin
        NodeP:=dm_Add_Object(lcodeP,loc_info,0,NIL,NIL,NIL, false);
      end;
      inodecnt:=1;
      pnodes[1]:=NodeP;
      plines[1]:=ipunkt;

      if Iter=1 then begin
        dm_put_long(714, 1);
        dm_Put_dBase(753,1);
      end;
      st:='';
      ipunktNext:=0;
      for ii:=ipunkt  to iend-1 do begin
        ss:=TRIM(Mem_NW.lines[ii]);
        if Length(ss)<1 then continue;
        if ii<>ipunkt then
        if ss[2]='.' then begin
          ipunktNext:=ii;
          if (ss[1]>='1') AND (ss[1]<='9') then begin
             chNext:=ss[1];
             ch2:=#0;
             ch2Next:=#0;
          end else begin
             chNext:=#0;
             ch2:=ss[1];
             ch2Next:=#0;
          end;
          break;
        end;
        s_errCrd:=proc_crd(ss);
        if s_errCrd<>'' then begin
          fl_err:=true;
          lb_Log.Items[ii]:='Ошибка: '+s_errCrd;
          inc(i_err);
        end;
        st:=st+ss+#$0D#$0A;
      end;

      if st<>'' then begin
        ws:=trim(st);
        if Iter=1 then begin
          dm_Put_Text(730,ws);
        end;
        s_errCrd:=proc_crd(ws);
        {if s_errCrd<>'' then begin
          s_err:=s_err+'Ошибка: '+s_errCrd+'; ';
          inc(i_err);
        end; }
        if Iter=1 then begin
         if plGlobal.N>-1 then begin
          if plGlobal.N=0 then
            NodeMetric:=dm_Add_Object(lcodeMetric,1,0,plGlobal,NIL,NIL, false)
          else
            NodeMetric:=dm_Add_Object(lcodeMetric,2,0,plGlobal,NIL,NIL, false);
            dm_Put_string(725,@s725[1]);
            if itype=3 then begin
              dm_Put_Dbase(746,i746);
            end else begin
              dm_Put_Dbase(733,i733);
            end;
            dm_link_objects(NodeMetric, NodeP,0, NIL);
         end;
        end;
      end;
      pc:=StrPos(@st[1], 'ОТМ ');
      if assigned(pc) then begin
                 case itype of
                   1:lcodeCanc:=String2Code('X3212000');
                   2:lcodeCanc:=String2Code('X3222000');
                   3:lcodeCanc:=String2Code('X3232000');
                   4:lcodeCanc:=String2Code('X3212000');
                  end;
          if Iter=1 then begin
            dm_Set_code(lcodeCanc);
          end;
      end;
      if Iter=1 then begin
        dm_link_objects(NodeNW, NodeP,0,'first');
      end;
      while ipunktNext<>0 do begin
         if chNext<>#0 then begin

           if Iter=1 then begin
             NodePNext:=dm_Add_Object(lcodeP,loc_info,0,NIL,NIL,NIL, false);
           end;
           inc(inodecnt);
           pnodes[inodecnt]:=NodePNext;
           plines[inodecnt]:=ipunktNext;

           if Iter=1 then begin
             st:=chNext+#0;
             try
               l714:=StrToint(st);
               dm_put_long(714, l714);
             except
               dm_put_String(714,@st[1]);
             end;
           end;
           //dm_link_objects(NodeP, NodePNext,0,'next');
           nd1:=NodeP;
           nd2:=NodePNext;
           slink:='next'#0;
           NodeP:=NodePNext;
           chNext:=#0;
           ch2:=#0;
         end else if ch2Next=#0 then begin
           if Iter=1 then begin
             NodeP2Next:=dm_Add_Object(lcodePP,loc_info,0,NIL,NIL,NIL, false);
             st:=ch2+#0;
             dm_put_String(754,@st[1]);
           end;
           //dm_link_objects(NodeP, NodeP2Next,0,'first');
           nd1:=NodeP;
           nd2:=NodeP2Next;
           slink:='first'#0;

           NodeP2:=NodeP2Next;
         end else begin
           if Iter=1 then begin
             NodeP2Next:=dm_Add_Object(lcodePP,loc_info,0,NIL,NIL,NIL, false);
             st:=ch2Next+#0;
             dm_Put_String(754,@st[1]);
           end;
           //dm_link_objects(NodeP2, NodeP2Next,0,'next');
           nd1:=NodeP2;
           nd2:=NodeP2Next;
           slink:='next'#0;

           NodeP2:=NodeP2Next;
           ch2:=ch2Next;
           ch2Next:=#0;
         end;
         if Iter=1 then begin
           dm_Put_dBase(753,1);
         end;
         st:='';
         ipunktNew:=0;
         for ii:=ipunktNext  to iend-1 do begin
          ss:=TRIM(Mem_NW.lines[ii]);
          if Length(ss)<1 then continue;
          if ii<>ipunktNext then
          if ss[2]='.' then begin
            ipunktNew:=ii;
            if (ss[1]>='1') AND (ss[1]<='9') then begin
               chNext:=ss[1];
            end else if ch2=#0 then begin
              chNext:=#0;
              ch2:=ss[1];
              ch2Next:=#0;
            end
            else begin
               chNext:=#0;
               ch2Next:=ss[1];
            end;
            break;
          end else if ss[3]='.' then begin
            ipunktNew:=ii;
            if (ss[1]>='1') AND (ss[1]<='9') then begin
               chNext:=copy(ss,1,2);
            end;
            break;
          end;
          s_errCrd:=proc_crd(ss);
          if s_errCrd<>'' then begin
            fl_err:=true;
            lb_Log.Items[ii]:='Ошибка: '+s_errCrd;
            inc(i_err);
          end;
          st:=st+ss+#$0D#$0A;
         end;
         if st<>'' then begin
           pc:=StrPos(@st[1], 'ОТМ ');
           if assigned(pc) then begin
             pc:=StrPos(@st[1], 'ОТМ ЭТОТ НР');
             if assigned(pc) then begin
                 case itype of
                   1:lcodeCanc:=String2Code('X3213000');
                   2:lcodeCanc:=String2Code('X3223000');
                   3:lcodeCanc:=String2Code('X3233000');
                   4:lcodeCanc:=String2Code('X3213000');
                  end;
             end else begin
                 case itype of
                   1:lcodeCanc:=String2Code('X3212000');
                   2:lcodeCanc:=String2Code('X3222000');
                   3:lcodeCanc:=String2Code('X3232000');
                   4:lcodeCanc:=String2Code('X3212000');
                  end;
             end;
             if Iter=1 then begin
               dm_Set_code(lcodeCanc);
             end;
           end;
           ws:=trim(st);
           if Iter=1 then begin
             dm_Put_Text(730,ws);
           end;
           proc_crd(ws);
           if Iter=1 then begin

            if plGlobal.N>-1 then begin
             if plGlobal.N=0 then
              NodeMetric:=dm_Add_Object(lcodeMetric,1,0,plGlobal,NIL,NIL, false)
            else
              NodeMetric:=dm_Add_Object(lcodeMetric,2,0,plGlobal,NIL,NIL, false);
              dm_Put_string(725,@s725[1]);
              if itype=3 then begin
                dm_Put_Dbase(746,i746);
               end else begin
                dm_Put_Dbase(733,i733);
               end;
              dm_link_objects(NodeMetric, NodeP2Next,0, NIL);
            end;
           end;
         end;
         if Iter=1 then begin
           dm_link_objects(Nd1, nd2,0,@slink[1]);
         end;
         ipunktNext:=ipunktNew;
      end;
    end;
    //Обработка отмен
    if Iter=1 then begin
      NodeCurr:=dm_object;
    end;
    for ii:=ifrst+1  to iend-1 do begin
      ss:=TRIM(Mem_NW.lines[ii]);
      if ss='' then continue;
      if ss[Length(ss)] = '=' then
        ss:=copy(ss,1,Length(ss)-1);
      if ss[2]='.' then
        ss:=trim(copy(ss,3,256))
      else if ss[3]='.' then
        ss:=trim(copy(ss,4,256));
      ss:=ss+#0;

      if copy(ss,1,3)='ОТМ' then begin
        pc:=StrPos(@ss[1], 'ОТМ ЭТОТ НР');
        if assigned(pc) then begin
          if Iter=1 then begin
            dm_jump_node(NodeNW);
          end;
          if ss= 'ОТМ ЭТОТ НР'#0 then begin
            if Iter=1 then begin
             dm_Put_dBase(753,2);
             for jj:=1 to inodecnt do begin
              dm_jump_node(pnodes[jj]);
              dm_Put_dBase(753,2);
             end;
            end;
          end else begin
           st:= copy(ss,13,256);
           if Get_DateTime(st,copy(stransf,5,2), st1, dt, ldate, ltime) then begin
             st:=st1+#0;
             {l_Y:=ldate div 10000;
             Decodedate(now, Year, Month, Day);
             If l_Y<Year then begin
               fl_err:=true;
               s_err:=s_err+'Ошибка в формате даты отмены. Год отмены меньше текущего: '+st+'; '
             end
             else begin

             // l_dt:=Year*10000 + Month*100 + Day;
             }
             If ldate<ldate_tr then begin
               fl_err:=true;
               s_err:=s_err+'Ошибка в формате даты отмены. Дата отмены меньше даты передачи: '+st+'; '
             end
             else begin
              if Iter=1 then begin
                pPoolBuff^.Len:=0;
                dm_hf_Pool_Put(pPoolBuff,65528,118, _date, pBytes(@ldate));
                dm_hf_Pool_Put(pPoolBuff,65528,119, _time, pBytes(@ltime));
                for jj:=1 to inodecnt do begin
                 if plines[jj]=ii then begin
                   dm_jump_node(pnodes[jj]);
                   dm_Add_DataType(731,pPoolBuff);
                   break
                 end
                end;
              end;
             end
             //end
             //dm_Put_String(731,@st[1]);
           end else
             s_err:=s_err+'Ошибка в формате даты отмены: '+st+'; ';
          end;
          continue;
        end;
        pc:=StrPos(@ss[1], 'И ЭТОТ НР');
        if assigned(pc) then begin
          if Iter=1 then begin
            dm_jump_node(NodeNW);
            dm_Put_dBase(753,2);
            for jj:=1 to inodecnt do begin
              dm_jump_node(pnodes[jj]);
              dm_Put_dBase(753,2);
            end;
          end
        end;
        pc:=StrPos(@ss[1], 'И ЭТОТ ПУНКТ');
        if assigned(pc) then begin
          if Iter=1 then begin
            for jj:=1 to inodecnt do begin
              if plines[jj]=ii then begin
                dm_jump_node(pnodes[jj]);
                dm_Put_dBase(753,2);
                break
              end
            end;
          end
        end;
        ss:=copy(ss,5,256)+#0;
        lCanc:
        pc:=StrScan(@ss[1],' ');
        if assigned(pc) then
          s2:=copy(ss, 1, (pc-pchar(@ss[1])))
        else
          s2:=StrPas(@ss[1]);
        if Ansipos('/', s2)=0 then begin
          s1:=s2;
          s2:='';
          for jj:=pc-pchar(@ss[1])+2 to Length(ss) do begin
            if ((ss[jj]>='0') AND  (ss[jj]<='9')) OR (ss[jj]='/') then
              s2:=s2+ss[jj]
            else begin
              jpos:=jj;
              break
            end
          end;
        end else begin
          s1:='';
          jpos:=Length(s2)+1;
        end;
          s3:='';
          if ss[jpos]='(' then begin
            jj:=jpos;
            while jj<Length(ss) do begin
              if ss[jj]=')' then break;
              s3:=s3+ss[jj];
            end
          end;
         { if s3<>'' then begin //Отмена пункта
            //todo
          end else} begin
             NodeCancel:=0;
             if Iter=1 then begin

               if dmx_find_frst_code(lcode,loc_info)<>0 then
               repeat
                if itype<>3 then begin
                  if not dm_Get_String(733,255, st1) then st1:='';
                  if st1<>s1 then continue;
                end else begin
                  if not dm_Get_String(746,255, st1) then st1:='';
                  if st1<>sRegPRIP then continue;
                end;
                if not dm_Get_String(725,255, st2) then st2:='';
                if st2=s2 then begin
                  NodeCancel:=dm_object;
                  break;
                end
               Until dmx_find_next_code(lcode,loc_info)=0;
               if NodeCancel=0 then begin

                dm_Goto_node(NodeCurr);
                NodeCancel:=dm_Add_Object(lcode,loc_info,0,NIL,NIL,NIL, false);
                if itype<>3 then begin
                  st:=s1+#0;
                  dm_Put_String(733,@st[1]);
                end else begin
                  st:=sRegPRIP+#0;
                  dm_Put_String(746,@st[1]);
                end;
                st:=s2+#0;
                dm_Put_String(725,@st[1]);
                dm_Put_dBase(753,2);
               end;

               for jj:=1 to inodecnt do begin
                 if plines[jj]=ii then begin

                   pPoolBuff^.Len:=0;
                   dm_hf_Pool_Put(pPoolBuff,65528,118, _date, pBytes(@ldate));

                   st:='НЕ ПОДЛЕЖИТ ОБЪЯВЛЕНИЮ В ИМ УНИО'#0;
                   pc:=StrPos(@ss[1], @st[1]);
                   if assigned(pc) then begin
                     dm_jump_node(pnodes[jj]);
                     //CharToOEM(@st[1],@st[1]);
                     //dm_Put_String(732,@st[1]);
                     ww:=4;
                     dm_hf_Pool_Put(pPoolBuff,65528,752, _dbase, pBytes(@ww));
                   end;
                   st:='НЕ ПОДТВЕРЖДЕНО НАЦИОНАЛЬНЫМ КООРДИНАТОРОМ'#0;
                   pc:=StrPos(@ss[1], @st[1]);
                   if assigned(pc) then begin
                     dm_jump_node(pnodes[jj]);
                     //CharToOEM(@st[1],@st[1]);
                     //dm_Put_String(732,@st[1]);
                     ww:=3;
                     dm_hf_Pool_Put(pPoolBuff,65528,752, _dbase, pBytes(@ww));
                   end;
                   st:='ПОЛУЧЕНИИ ИМ'#0;
                   pc:=StrPos(@ss[1], @st[1]);
                   if assigned(pc) then begin
                     dm_jump_node(pnodes[jj]);
                     st:=StrPas(pc)+#0;
                     st:=StringReplace(st,'ПОЛУЧЕНИИ ИМ','',[]);
                     st:=StringReplace(st,'УНИО','',[]);

                     CharToOEM(@st[1],@st[1]);
                     st:=UTF8ToCP866(st);
                     //dm_Put_String(732,@st[1]);
                     ww:=1;
                     dm_hf_Pool_Put(pPoolBuff,65528,752, _dbase, pBytes(@ww));
                     stt:=TRIM(st);
                     dm_hf_Pool_Put(pPoolBuff,65528,747, _string, pBytes(@stt));
                   end;
                   st:='ОПУБЛИКОВАНО ИМ'#0;
                   pc:=StrPos(@ss[1], @st[1]);
                   if assigned(pc) then begin
                     dm_jump_node(pnodes[jj]);
                     st:=StrPas(pc)+#0;
                     st:=StringReplace(st,'ОПУБЛИКОВАНО ИМ','',[]);
                     st:=StringReplace(st,'УНИО','',[]);
                     CharToOEM(@st[1],@st[1]);
                     //dm_Put_String(732,@st[1]);
                     ww:=2;
                     dm_hf_Pool_Put(pPoolBuff,65528,752, _dbase, pBytes(@ww));
                     stt:=TRIM(st);
                     dm_hf_Pool_Put(pPoolBuff,65528,747, _string, pBytes(@stt));
                   end;
                   if pPoolBuff^.Len>0 then begin
                     dm_Add_DataType(732,pPoolBuff);
                   end;
                   dm_link_objects(pnodes[jj],NodeCancel,0,'canc');
                   break
                 end
               end;
             end;
             if s3='' then
             if (Length(ss)- jpos>3) AND (ss[jpos+1]>='0') AND (ss[jpos+1]<='9')  then begin
               ss:=copy(ss,jpos+1,256);
               goto lCanc;
             end;
          end
      end
    end;
    dm_Goto_node(NodeCurr);
    if S_err='' then begin
      LB_log.Items[ifrst]:= sn+' - OK';
    end else begin
      LB_log.Items[ifrst]:= sn+' - '+s_err;
    end;
    if iEnd>0 then begin
    itype:=Define_PRIP(iEnd-1, ip,ifrst);

    i_Eng:=-1;
    if ifrst=-1 then
      iend_Eng:=Mem_NW.lines.Count-1
    else
      iend_Eng:=ifrst-1;
    for ii:=iend+1  to iend_Eng do begin
      ss:=TRIM(Mem_NW.lines[ii])+#0;
      pc:=StrPos(@ss[1],'TRANSMISSION');

      if assigned(pc) then begin
        i_Eng:=ii;
        break
      end else begin
        pc:=StrPos(@ss[1],'ZCZC');
        if assigned(pc) then begin
           i_Eng:=ii;
           break
        end else begin
           pc:=StrPos(@ss[1],'SECURITE');
           if assigned(pc) then begin
             i_Eng:=ii;
             break
           end
        end;
      end;
    end;
    if i_Eng<>-1 then begin
      st:='';
      for ii:=i_Eng+1 to iend_Eng do begin
        ss:=Mem_NW.lines[ii]+#0;
        pc:=StrPos(@ss[1],'NNNN');
        if assigned(pc) then
          break;
        if ii=i_Eng+1 then begin
          pc:=StrPos(@ss[1],'UTC');
          if assigned(pc) then
            continue;
        end;
        if get_eng_Numb(ss,s725Eng) then begin
           if trim(s725Eng)<>trim(s725) then begin
             sRus:=s725+#0;
             sEng:=s725Eng+#0;
             if StrPos(@sRus[1], @sEng[1]) = NIL then begin
               fl_err:=true;
               LB_log.Items[ii]:= 'Номер английского варианта не соответсвует русскому: '+trim(s725)+' - '+trim(s725Eng);
             end;
           end;
        end;

        st:=st+Mem_NW.lines[ii]+#$0D#$0A;
      end;
      if Iter=1 then begin
        ws:=trim(st);
        dm_jump_node(NodeNW);
        dm_Put_Text(825,ws);
        dm_Goto_node(NodeCurr);
      end;
    end;
      if itype>0 then begin
        Goto Lab0;
      end;
    end;
    dmw_done;

    if fl_err then begin
      ShowMessage('Обнаружены критичные ошибки. Предупреждения не загружены в карты');
      break
    end
    else
      if Iter=1 then
        ShowMessage('Создано предупреждений: '+IntToStr(iCnt));
  end else  begin
    ShowMessage('Ошибка при открытии карты');
    exit;
  end;
  if fl_err then break;
  end; // тестовый и реальный проход

  Freemem(pPoolBuff, 65528);

end;

procedure TFNavWarning.LB_NWDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(Rect.Left + 2, Rect.Top,
      LB_NW.items[index]); {DstList - имя списка}
  end;

if FNavWarning.ActiveControl= LB_NW then
  LB_Log.TopIndex:= LB_NW.TopIndex;


end;

procedure TFNavWarning.LB_LogDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(Rect.Left + 2, Rect.Top,
      LB_Log.items[index]); {DstList - имя списка}
  end;

if FNavWarning.ActiveControl= LB_Log then
  LB_NW.TopIndex:= LB_Log.TopIndex;

end;

procedure TFNavWarning.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 if (LB_Log.Top<MousePos.Y-FNavWarning.Top)  AND
 (LB_Log.Top+LB_Log.Height>MousePos.Y-FNavWarning.Top)  AND
 (LB_Log.Left<MousePos.X-FNavWarning.Left)  AND
 (LB_Log.left+LB_Log.width>MousePos.X-FNavWarning.Left) then
    LB_NW.TopIndex:= LB_Log.TopIndex;

 if (LB_NW.Top<MousePos.Y-FNavWarning.Top)  AND
 (LB_NW.Top+LB_NW.Height>MousePos.Y-FNavWarning.Top)  AND
 (LB_NW.Left<MousePos.X-FNavWarning.Left)  AND
 (LB_NW.left+LB_NW.width>MousePos.X-FNavWarning.Left)  Then
  LB_Log.TopIndex:= LB_NW.TopIndex;

end;

procedure TFNavWarning.Button3Click(Sender: TObject);
begin
end;

procedure TFNavWarning.Button4Click(Sender: TObject);
begin
  if LB_NW.Visible then begin
    LB_NW.Visible:=false;
    Mem_NW.Visible:=true;
    Caption:='Навигационные предупреждения (режим редактирования)';
    Button4.Caption:='Сохранить';
  end else begin
    LB_NW.Items.Text:=Mem_NW.Lines.Text;
    LB_NW.Visible:=true;
    Mem_NW.Visible:=false;
    Button4.Caption:='Редактировать';
    SaveDlg.FileName:=OpenDlg.FileName;
    Caption:='Навигационные предупреждения (режим просмотра)';
    if SaveDlg.Execute then begin
      LB_NW.Items.SaveToFile(SaveDlg.FileName);
    end;
  end;
end;

Initialization
  doubleQout :=  UTF8ToAnsi('”')[1];
  degree := UTF8ToAnsi('°')[1];
  rusC :=  UTF8ToString('С')[1];
  rusYu := UTF8ToString('Ю')[1];
  rusZ :=  UTF8ToString('З')[1];;
  rusV := UTF8ToString('В')[1];;

end.
