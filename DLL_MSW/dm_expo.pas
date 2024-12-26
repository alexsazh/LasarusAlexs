///////////////////////////////////////////////////////
//
// msw.dll "<dxf> - AutoCad с предобработкой" - строка в work\export.###
//
// procedure dm_Export(dm: PChar); stdcall; - для dmw.exe/меню/карта/экспорт
//
// (dmw.exe обновить с ftp!)
//
///////////////////////////////////////////////////////

unit dm_expo;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, SysUtils, IniFiles, Types;

// 1. создает $.ms
// 2. создает новую карту dm2 с GCX-построениями
// 3. коррекция dm2 (mss_acad.cod)
// 4. удаление z-координаты в dm2
// 5. вызывает dm_Export из dm_dxf.dll: dm2 -> dxf
procedure dm_Export(dm: PChar); stdcall;


implementation

uses Wcmn, main{mscnv_exec2}, dmw_Use, Dmlib, dm_util,
  dm_expo_dlgs, check_dm_xy;


procedure dm_expo_del_z(dm: PChar);
var ofs: longint;
begin
  if not (dm_open(dm, true{edit})>0) then begin
    Tellf('MSW.DLL/dm_expo_del_z: ERROR in dm_open(%s)',[dm]);
    EXIT;//!
  end;

  try
    ofs := dm_Find_Frst_Code(0,0);//ВСЕ ОБЪЕКТЫ
    while ofs>0 do begin
      if dm_z_axe_exist(ofs)
      then dm_Trunc_z_axe(ofs);

      ofs := dm_Find_Next_Code(0,0);//Next object
    end;//while ofs>0
  finally
    dm_done;
  end;
end;


//dm_dxf.dll/dm_Export(dm):
procedure dm_expo_dm_to_dxf(dm: PChar; sout: string);
const
  dll_name = 'dm_dxf';
  dm_Exp_name = 'dm_Export';
  dm_Exp1_name = 'dm_Export1';
type
  Tdm_Exp=procedure(dm: PChar); stdcall;//экспорт dm -> dxf
  Tdm_Exp1=procedure(Path,Dest,Chan: PChar); stdcall;//экспорт dm -> dxf
  //procedure dm_Export1(Path,Dest,Chan: PChar); stdcall;
  //Path=dm, Dest=dxf, Chan - out-файл
  //если Dest=NIL, то SavAs dialog
var
  LibHandle: THandle;
  dm_Exp: Tdm_Exp;//процедура Толи с запросом имен .out, .dxf
  dm_Exp1: Tdm_Exp1;//процедура Толи без запросов имен .out, .dxf
  sdm,sdxf: string;
begin
  LibHandle:=wcmn_dll_open(dll_name); {0-error, MSG}
  if LibHandle>0 then
  try

    sdm := strpas(dm);
    sdxf := wcmn_file_dirname(sdm) + '.dxf';

    if FileExists(sout) then begin
      @dm_Exp1:=GetProcaddress(LibHandle, dm_Exp1_name);
      if Assigned(dm_Exp1) then dm_Exp1(dm, PChar(sdxf), PChar(sout))
      else Tellf('procedure not found: "%s/%s"',[dll_name,dm_Exp1_name]);
    end else begin
      Tellf('file not found: "%s"',[sout]);
      @dm_Exp:=GetProcaddress(LibHandle, dm_Exp_name);
      if Assigned(dm_Exp) then dm_Exp(dm)
      else Tellf('procedure not found: "%s/%s"',[dll_name,dm_Exp_name]);
    end;

  finally
    wcmn_dll_close(LibHandle);
  end;
end;


///////////////////////////////////////////////////////


procedure dm_Export(dm: PChar);
const
  IniSection1 = 'General';
  Ini_gcxname = 'MSW_gcxname';
var
  //пар-ры входной карты:
  dm_a,dm_b: TPoint;
  dm_lpmm,dm_mpl: double;
  dm_picwidth: single;//мм
  sdm,sobj,sobj_short: string;

  //пар-ры для mscnv_exec2:
  msname: PChar;
  //gcxname,mslibdir: PChar;
  //gclist: PChar;
  //flags: PChar;
  //picwidth: single;
  //a,b: TPoint;

  //пар-ры:
  _ExeDir: string;
  IniFile: TIniFile;
  sdm2: string;
  sgcxname,sout: string;
  smslibdir,smsdir: string;

begin
  if check_active_dm_xy then Tell('Активная карта проверена и переоткрыта');//!

  //dm - входная карта:
  if not (dm_open(dm, false{edit})>0) then begin
    Tellf('MSW.DLL/dm_Export: ERROR in dm_open(%s)',[dm]);
    EXIT;//!
  end;
  try
    sdm:=StrPas(dm);//!
    dm_goto_root;//!
    dmlib_ReadString(903, sobj); sobj_short:=wcmn_file_name(sobj);
    dm_Get_Bound(dm_a,dm_b);
    dm_mpl:=dm_Resolution; //m/l
    dm_lpmm:=dm_Scale/(dm_mpl*1000);
    dm_picwidth:=(dm_b.X-dm_a.X)/dm_lpmm;//(pwidth/zoom)мм - считаем, что zoom=1 (!!!)
  finally
    dm_done;
  end;


  //1: dm -> Tmp+$.ms(msname), Tmp+$.dm:
  my_dm_Cut1(dm, dm_a.X,dm_a.Y ,dm_b.X,dm_b.Y);//lib\dm_util
  msname := PChar(TmpDir + '$.MS');//!!!


  //2,3: mscnv_exec2: dm<>NIL!!!: ===> sdm2!!!
  _ExeDir:=ExeDir;
  IniFile:=TIniFile.Create(_ExeDir+'mss.ini');
  dm_expo_dlgs1:=Tdm_expo_dlgs1.Create(NIL);
  try
    //smslibdir,smsdir: from mss.ini:
    //smslibdir := 'c:\ms\lib\';//DEBUG
    smslibdir := wcmn_file_dir( IniFile.ReadString(IniSection1, 'MsLibPath', '') );
    if not DirExists(smslibdir) then begin
      Tell('directory not found: "MS\LIB"');
      EXIT;//!!!                                           //EXIT in try-finally!!!
    end;
    smsdir := UpperDir(smslibdir);
    if not DirExists(smsdir) then begin
      Tell('directory not found: "MS"');
      EXIT;//!!!                                           //EXIT in try-finally!!!
    end;

    //sgcxname: Ini or Dialog:
    //sgcxname := 'c:\ms\05k.lib\05k.gcx';//DEBUG
    sgcxname:=Format('%s%s.lib\%s.gcx', [smsdir, sobj_short, sobj_short]);

    if not FileExists(sgcxname) then begin
      Tellf('file not found: "%s"',[sgcxname]);
      sgcxname := IniFile.ReadString(IniSection1, Ini_gcxname, '');
      if FileExists(sgcxname) then dm_expo_dlgs1.open_gcx.FileName:=sgcxname;
      if dm_expo_dlgs1.open_gcx.FileName=''
      then dm_expo_dlgs1.open_gcx.InitialDir:=smsdir;

      if dm_expo_dlgs1.open_gcx.Execute
      then begin
        sgcxname := dm_expo_dlgs1.open_gcx.FileName;
        IniFile.WriteString(IniSection1, Ini_gcxname, sgcxname);
      end
      else EXIT;//!!!                                           //EXIT in try-finally!!!
    end;

    sdm2:=main_dmpath_after_mscnv_exec2(sdm);//name.dm -> name_GCX.dm (!!!)

    if not mscnv_exec2(msname,
              PChar(sgcxname),
              NIL{gclist},
              PChar(smslibdir),
              NIL{flags},
              dm_picwidth, dm, dm_a,dm_b)
    then EXIT;//!

  finally
    dm_expo_dlgs1.Free;
    IniFile.Free;
  end;


  //4: DEL Z:
  dm_expo_del_z(PChar(sdm2));


  //5: dm -> dxf:
  sout := Format('%sexport_dxf\%s.out', [UpperDir(_ExeDir){Neva\}, sobj_short]);
  dm_expo_dm_to_dxf(PChar(sdm2), sout);

end;

end.
