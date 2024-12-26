(*
  MAIN:
    mscnv_exec2 -> msfile\MSF.Execute
*)
unit main;

{$MODE Delphi}

 interface

uses LCLIntf, LCLType, Classes, Forms, Msfile, Types, SysUtils;


function mscnv_exec(msname,gcxname: PChar; picwidth: single): boolean; stdcall;

function main_dmpath_after_mscnv_exec2(sdmpath: string): string;

//версия 2001.7.1:
//версия 2013.8:
//версия 2013.11:
//dmpath<>nil => make GCX-dm for Autocad-export, a,b - rect in dm, БЕЗ ПЕЧАТИ, cmn_dm<>NIL!
//dmpath=nil => обычный режим печати, cmn_dm=NIL!
//function dmpath_after_mscnv_exec2 - путь к НОВОЙ КАРТЕ (если dmpath<>nil)
function mscnv_exec2(msname,gcxname,gclist,mslibdir,flags: PChar; picwidth: single;
          dmpath: PChar; a,b: TPoint): boolean; stdcall;

var gcfilenames: TStringList;//initialization


implementation


uses
  PSLIB, gcx, Wcmn, CHARA, CMN, PSX, Psstacks, add2dm,
  Dmlib;


//старая версия:
function mscnv_exec(msname,gcxname: PChar; picwidth: single): boolean; stdcall;
var smsname,sgcxname: string;
begin
  Result:=false;
  smsname:=StrPas(msname);
  sgcxname:=StrPas(gcxname);
  if pslib_init(nil, '') then try
    if gcx_read(sgcxname) then try
      Result:=ProcessMsFile(smsname,picwidth);
    except
      Result:=false;
    end;
  finally
    pslib_done;
  end;
end;

///////////////////////////////////////////////////////////////////////////


function main_dmpath_after_mscnv_exec2(sdmpath: string): string;
begin
  Result := wcmn_file_dirname(sdmpath) + '_GCX' + wcmn_file_ext(sdmpath);
end;

function mscnv_exec2(msname,gcxname,gclist,mslibdir,flags: PChar; picwidth: single;
                  dmpath: PChar; a,b: TPoint): boolean; stdcall;
const
  GcxIniFileName='gcx.ini';
var
  smsname,sgcxname,sgclist,smslibdir,smslibdir0,sdmpath,sdmpath_gcx,sdmpath_gcx_system, sUTF8: string;
  key,i: integer;
  add2dm_list: Tadd2dm_list;
  newdmocount: integer;//кол-во ГРУПП объектов, добавленных к карте sdmpath_gcx
begin
   Result:=false;//default
  cmn_newdm:=NIL;//default!!!

  //Application.MainForm.SetFocus;//!?!

  smsname:=StrPas(msname);
  sgcxname:=wcmn_System2UTF(StrPas(gcxname));
  sgclist:=wcmn_System2UTF(StrPas(gclist));
  smslibdir:=wcmn_System2UTF(StrPas(mslibdir));
  smslibdir0:=system.copy(smslibdir,1,Length(smslibdir)-1);//без '\'

  //sdmpath --> sdmpath_gcx:
  sdmpath:='';
  sdmpath_gcx:='';
  if dmpath<>nil then begin
    sdmpath:=wcmn_System2UTF(StrPas(dmpath));
    if sdmpath='' then begin
      dmpath:=NIL;
    end else begin
      sdmpath_gcx := main_dmpath_after_mscnv_exec2(sdmpath);
(*
    //СОЗДАНИЕ ОСНОВЫ sdmpath_gcx:
    if FileExists(sdmpath_gcx) then
      if not TellfYN('Файл "%s" существует.\nЗаменить его?',[sdmpath_gcx]) then EXIT;//!
*)
     if not wcmn_filecopy1(sdmpath, sdmpath_gcx) then//удаляет sdmpath_gcx, если надо
       begin
        Tellf('ОШИБКА копирования\n%s\nв\n%s',[sdmpath, sdmpath_gcx]);
        EXIT;//!
       end;
    end;
  end;

//  Tellf('Run GCX: %s',[sgcxname]);

  cmn_CharaExists:=false;

  if dmpath=nil then begin
    sgetlist(sgclist, gcfilenames);//=>gcfilenames(!)
    if gcfilenames.Count<=0 then begin
      Tell('Не указан GC-файл');
      EXIT;//!
    end;
  end;
  sUTF8:=smslibdir+GcxIniFileName;
  if not FileExists(sUTF8) then begin
    Tellf('Не найден файл\n'+sUTF8,[]);
    EXIT;//!
  end;

  //PsLib:
  if pslib_init(nil, smslibdir0) then
  try

    //gcx.ini:
    if pslib_runcmdline('@gcx.ini')
    then begin

      cmn_CharaExists:=Chara_FindAndReadBlocks(gcfilenames);
      if cmn_CharaExists then begin
        key:=Ps.Names.Key('Chara_execute_in_dll');
        pslib_runstring('H-Dict begin');
        cmn_H_Dict:=dictstack.currentdict;
        cmn_H_Dict.Value( key, cmn_CharaProc, i);
        pslib_runstring('end %H-Dict');
      end;

      //cmn_newdm:
      try
      if (dmpath<>nil) then begin

        cmn_dm_a:=a;
        cmn_dm_b:=b;
        sdmpath_gcx_system := wcmn_UTF2System(sdmpath_gcx);
        cmn_newdm:=TDm.Create(sdmpath_gcx_system);//edit=TRUE
        if cmn_newdm.FullName='' then begin
          Tellf('ОШИБКА открытия карты "%s"',[sdmpath_gcx]);
          try cmn_newdm.Free; except end;
          cmn_newdm:=NIL;//!!!
          ABORT;//!
        end;
      end;

      //чтение GCX & $.ms:
      if gcx_read(sgcxname)//--- чтение GCX (gcx.pas) - gcxdict(!)
      then
      try

        //чтение $.ms -> создание НОВОГО $.ms ИЛИ карты sdmpath_gcx (if cmn_newdm<>nil):
        Result:=ProcessMsFile(smsname,picwidth);

      except
        Result:=false;
      end;//if gcx_read

      //Добавления к карте sdmpath_gcx (if dmpath<>nil):
      newdmocount:=0;
      if Result and Assigned(cmn_newdm) then begin
        add2dm_list:=Tadd2dm_list.New;
        try
          //add2line_list.CreateDebugList;//--------------DEBUG
          if
            add2dm_list.load_cod_file//чтение MSS_ACAD.COD
          then
            newdmocount := add2dm_list.add2dm;
        finally
          add2dm_list.Free;
        end;
      end;
      if newdmocount>0 then ;//против хинта "value never used"

      if Assigned(cmn_newdm) then begin
        if Result
        then //Tellf('Создана карта\n%s\nДобавлено групп объектов: %d',[sdmpath_gcx,newdmocount])
        else Tellf('ОШИБКИ при создании карты "%s"',[sdmpath_gcx]);
      end;

      finally
        if Assigned(cmn_newdm) then cmn_newdm.Free;//!
      end;//cmn_newdm

    end else begin
      Tellf('MSW.DLL: Ошибка чтения библиотечных файлов из MS\LIB.\nВозможная причина - несоответствие версий.',[]);
    end;//gcx.psl

  finally
    pslib_done;
  end;
end;


initialization
  gcfilenames:=TStringList.Create;
finalization
  gcfilenames.Free;

end.
