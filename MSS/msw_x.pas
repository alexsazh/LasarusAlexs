unit Msw_x;

{$MODE Delphi}{$H+}

 interface

uses
  SysUtils, LCLIntf, LCLType, Types, Forms, dialogs,
  dmw_Use,
  Dmw_ddw, Msw_msx, OTypes,
  Vlib, Nums, dynlibs;


var
  DmCopyData: record
    Rotation: boolean;//с поворотом
    a,b: tnum2;//Rotation => 1,2-ая точки; not Rotation => Bound(как раньше)
    map_pw,map_ph: tnum;//размеры страницы
    incmap: boolean;//MapIncludeItem.Checked в главном меню ("Использовать прозрачность листов")
  end;

function msw_MapScale: longint;
function msw_MapUPM: real;  {Units/Meter}
function msw_dm_Open(map: string): boolean;
function dmw_Active_Map:string;

// not ROTATE => a,b - bound; map_ph = b.y-a.y;
// ROTATE => a,b - 1-ая и 2-ая точки (основание страницы); map_ph = dist(b, 3-я точка)
function msw_FindPage(npage, pcode: longint; ROTATE: boolean; var map_pw,map_ph: tnum; var a,b: tnum2; var bln_pw,bln_ph: float): boolean;

function DmCopyCustom: boolean;//Use DmCopyData(!) MAIN: CALLS Tol's DmCopy

function msw_DmCopy(la,lb: lpoint; include_enabled: boolean): boolean;//->DmCopyCustom
function msw_DmCopy2(Rotation: boolean; map_pw,map_ph: tnum; a,b: tnum2; include_enabled: boolean): boolean;//->DmCopyCustom
//function msw_DmCopyG(ga,gb: tgauss; include_enabled: boolean): boolean;

{fonts,include - if exists near MS\LIB:}
function msw_GsIncludeDirs(xobs, from_abc: boolean): string;

// MAIN: CALLS GhostScript (включая запуск предобработчика!) - после DmCopyCustom:
//единственный вызов - in MsRepeatItemClick:
function msw_x_render(ms_file_name: string; prolog,epilog,gc_from_abc: boolean; ms_msg: string): boolean;

{-----------------------------------------------}
implementation
{----------------------------------------------}

uses
  Wcmn, MSCMN, GsOpt, MSW_1, cmdfile, dmcmn,
  Dmlib, msw_xm, cmn,
  dm_util, _webcmn;


function msw_dm_Open(map: string): boolean;
var zs: TChars;
begin
  if dmw_Open( StrPCopy(zs,map), false{Edit})=0 then begin
    result := false;
    Tell(msgs[10]+_EOL_+map);
  end else begin
    result := true;
  end;
end;

function dmw_Active_Map:string;
var pc:pchar;
const pc_length = 65528;
begin
  Getmem(pc,pc_length);
  result:=Strpas(dmw_ActiveMap(pc,pc_length-1));
  Freemem(pc);
end;


function msw_MapScale: longint;
var map: string; mscale: longint;
begin
  msw_MapScale := 1;
  map := dmw_Active_Map;
  if map='' then begin Tell(msgs[3]); exit; end;
  if not msw_dm_Open(map) then exit;

  {dm_Get_dm_Hdr(msw_dm_Hdr);
  mscale := msw_dm_Hdr.dm_scale;
  }
  dm_Goto_root;
  dm_Get_long(904,0,mscale);
  if (mscale<=0) or (mscale>100000000) then Tell(Format('MapScale=%d',[mscale]));

  msw_MapScale := mscale;
  dmw_Done;
end;

function msw_MapUPM: real;  {Units/Meter}
var
  map: string; a,b,l1,l2: lpoint; g1,g2: tgauss; ld,gd: real;
  //bl1,bl2{rad}: tnum2;
begin
  Result := 1;
  map := dmw_Active_Map;
  if map='' then begin Tell(msgs[3]); exit; end;
  if not msw_dm_Open(map) then exit;
(*
  ld := 100;
  l1.x:=0; l1.y:=0; l2.y:=l1.y; l2.x := l1.x + Round(ld);
  dm_l_to_g(l1.x,l1.y,g1.x,g1.y); dm_l_to_g(l2.x,l2.y,g2.x,g2.y);
  gd:=sqrt(sqr(g2.x-g1.x)+sqr(g2.y-g1.y));
  Result := ld/gd;
  {Tell(Format('Units/Meter=%f',[ld/gd]));}
*)
(*
  dm_gauss_bound(g1,g2);//dm_gauss_bound(out lt,rb: TGauss);
  dm_G_to_L(g1.x,g1.y, l1.x,l1.y); dm_G_to_L(g2.x,g2.y, l2.x,l2.y);
  dm_L_to_R(l1.x,l1.y, bl1.x,bl1.y); dm_L_to_R(l2.x,l2.y, bl2.x,bl2.y);
  gd:=dmd_2d_rad (bl1,bl2{rad}, 9{wgs84});//расст. по дуге (м)
  ld:=sqrt(sqr(l2.x-l1.x)+sqr(l2.y-l1.y));
  Result := ld/gd;
  {Tell(Format('Units/Meter=%f',[ld/gd]));}
*)
  ld := 100;
  dm_Get_Bound(a,b);//a=b(!)
  l1.x:=Round(b.X/2); l1.y:=Round(b.Y/2);//примерно середина карты
  l2.x := l1.x + Round(ld); l2.y:=l1.y;
  dm_l_to_g(l1.x,l1.y,g1.x,g1.y); dm_l_to_g(l2.x,l2.y,g2.x,g2.y);
  gd:=sqrt(sqr(g2.x-g1.x)+sqr(g2.y-g1.y));
  Result := ld/gd;
  {Tell(Format('Units/Meter=%f',[ld/gd]));}

  //Result := 1;//DEBUG

  dmw_Done;
end;

{-----------------------------------------------}


function msw_FindPage(npage, pcode: longint; ROTATE: boolean; var map_pw,map_ph: tnum; var a,b: tnum2; var bln_pw,bln_ph: float): boolean;
var node: longint; n: word; la,lb: lpoint; dmo: tdmobj;
begin
  Result:=true;

  //поиск страницы n=npage:
  n:=0;
  node := dm_Find_Frst_Code(pcode, 3);
  while (node<>0) do begin
    if not dm_get_word(401,0,n) then n:=0;
    if n=npage then break;
    node := dm_Find_Next_Code(pcode, 3);
  end;

  //страница не найдена:
  if (node=0) or (n<>npage) then begin
    Tell(Format(msgs[11],[npage]));
    Result:=false;
  end;
  if not Result then exit;

  //страница найдена:
  if ROTATE then begin
    dmo:=tdmobj.CreateFromDm;
    try
      if dmo.points.count>2 then begin
        a:=dmo.points[0];
        b:=dmo.points[1];
        map_pw:=v_dist(a, b);
        map_ph:=v_dist(b, dmo.points[2]);
      end else begin
        Result:=false;
      end;
    finally
      dmo.free;
    end;
  end else begin
    dm_get_bound(la,lb);
    a:=LpToNum2(la);
    b:=LpToNum2(lb);
    map_pw:=abs(b.x-a.x);
    map_ph:=abs(b.y-a.y);
  end;
  if not Result then exit;

  //характеристики (могут отсутствовать!):
  if not dm_get_word(406,0,abc.rightpage) then abc.rightpage:=1;//-->abc(!)
  if not dm_get_real(17,0,bln_pw) then bln_pw:=0;
  if not dm_get_real( 6,0,bln_ph) then bln_ph:=0;

  if (map_pw+map_ph<2) then begin
    Result:=false;
    Tell(msgs[12]);
  end;

  abc.pageOk := Result;
end;



function DmCopyCustom: boolean;
 Type
 //"ВСТАВКИ" с разными .GC (регионы с характ-ми):
 //[H700=9], [H701 = "gc_dir\gc_name [gcx_dir\gcx_name]"]
 Tms_gc_Enabled=procedure(en: boolean); stdcall;

 Tms_include_enabled=procedure(en: boolean); stdcall;//"Использовать прозрачность листов"

 Tdm_Cut=procedure(srcPath,dstPath,altPath: pChar;
                 x1,y1,x2,y2: longint;
                 rgbp: pDmwColors;
                 a,b,c:lpoint;
                 rotate:boolean); stdcall;

 Tms_Cut=procedure(srcPath,dstPath,altPath: pChar;
                 x1,y1,x2,y2: longint; sc: Double; //sc=-1 ???
                 mm:boolean); stdcall;   //mm=true - миллиметровый проект "бумага"

 Tbit_Cut=procedure(bitPath,srcPath,dstPath,altPath: pChar;
                  x1,y1,x2,y2: longint; sc{-1}: double;
                  mm{false}: boolean); stdcall;
{
  Если rotate=true, то осуществляется вырезка наклоненного прямоугольника.
  a - левая нижняя вершина,
  b - правая нижняя вершина,
  c - третья точка угла - на горизонтали точки a, правее ее,
  x1,y1,x2,y2 - по прежнему вертикально расположенный прямоугольник!!!
  (как бы после поворота точки b на линию ac)
}
var
  _ErrCode: integer;
  ms_gc_Enabled: Tms_gc_Enabled;//"вставки"
  ms_include_enabled: Tms_include_enabled;//"Использовать прозрачность листов"
  dm_Cut: Tdm_Cut;
  bit_Cut: Tbit_Cut;
  ms_Cut: Tms_Cut;
var
  Libhandle: Thandle;
  include_enabled: boolean;
  mm_prj: boolean;
  bitPath, srcPath, fn, map, map_ms: pchar;//могут стать nil(!)
  _bitPath,_srcPath,_fn: pchar;//for malloc
const
  MaxNameLength=1024;//полное имя файла
const
  RelFileName : string = '$.REL' ;
var
  OutFileName,RelFileName1,RelFileName2 : string;
//  vw0,vh0: tnum2;//единичные вектора страницы (vh0-вверх!)
  vx0,vy0,c: tnum2;

  //параметры dm_Cut:
  lp1,lp2: lpoint; la,lb,lc: lpoint; rotation: boolean;

begin
  Result:=true;

  //if not dmw_connect then Tell('FALSE in dmw_connect');
  //миллиметровый ли проект? :
  mm_prj:=dmw_is_mm;//dmw_ddw.pas(!)

  //загрузка параметров:
  include_enabled:=DmCopyData.incmap;//"Использовать прозрачность листов"
  rotation:=DmCopyData.rotation;
  if rotation then begin
    vx0:=v_xy(1,0);
    vy0:=v_xy(0,1);
//    vw0 := v_mul( v_sub(DmCopyData.b,DmCopyData.a), 1/v_dist(DmCopyData.b,DmCopyData.a) );
//    vh0 := v_rot( vw0, -90 );
    lp1 := Num2ToLp( v_add( DmCopyData.a, v_mul(vy0, -DmCopyData.map_ph) ) );//лев.верх.
    lp2 := Num2ToLp( v_add( DmCopyData.a, v_mul(vx0, DmCopyData.map_pw) ) );//прав.нижн.
    la:=Num2ToLp(DmCopyData.a);
    lb:=Num2ToLp(DmCopyData.b);
    c := v_prj(DmCopyData.a, v_add(DmCopyData.a, vx0), DmCopyData.b);//проекция b на OX
    lc:=Num2ToLp(c);
  end else begin
    lp1:=Num2ToLp(DmCopyData.a);
    lp2:=Num2ToLp(DmCopyData.b);
  end;

  //ФАЙЛЫ (pchar):
  map:=malloc(MaxNameLength);       strpcopy(map,MsFileShortName{доллар}+'.dm');
  map_ms:=malloc(MaxNameLength);    strpcopy(map_ms,MsFileShortName{доллар}+'.ms');

  //srcPath = ActiveMap (PChar)
  //fn = AltProject (PChar) - имя файла (C:\Users\Andreas\AppData\Roaming\dmw\tmp\###.###)
  //bitPath = PcxPath (PChar); NIL=>нет
  if not _webcmn_webmaps_process then begin
    _fn:=malloc(MaxNameLength);       fn:=dmw_AltProject(_fn,MaxNameLength-1);
    _srcPath:=malloc(MaxNameLength);  srcPath:=dmw_ActiveMap(_srcPath,MaxNameLength-1);
    _bitPath:=malloc(MaxNameLength);  bitPath:=dmw_PcxPath(_bitPath,MaxNameLength-1);
  end else begin
    srcPath:=PChar(_webcmn_dmpath);
    fn:=PChar(_webcmn_Altpath);
    bitPath:=NIL;//нет растровой подложки
  end;

  if wcmn_DeleteFile(map, true) and wcmn_DeleteFile(map_ms, true) and assigned(srcpath) then begin

    dmw_Hidemap;
    Libhandle:=LoadLibrary('dm_util');

    if LibHandle<32 then begin

      ShowMessage('Ошибка при загрузке DLL dm_util');

    end else begin {dll ok}

    //------------------------------------------------------
      //вставки (uses FormMain, FormXm(msw_xm.pas)):
      FormXm.Clear;
      @ms_gc_Enabled:=GetProcaddress(Libhandle,'ms_gc_Enabled');
      if Assigned(ms_gc_Enabled) then
        ms_gc_Enabled(FormMain.MultiMsGroup.ItemIndex>0);//=> будет $.txt       //multi
    //------------------------------------------------------

      @ms_include_enabled:=GetProcaddress(Libhandle,'ms_Include_Enabled');
      if Assigned(ms_include_enabled) then ms_include_enabled(include_enabled);

      if bitPath <> nil then begin

        @bit_Cut:=GetProcaddress(Libhandle,'bit_Cut');
        if Assigned(bit_Cut)
          then bit_Cut(bitPath,srcPath,map,fn, lp1.x,lp1.y,lp2.x,lp2.y, -1,mm_prj)
          else begin Tell('dm_util.dll: "bit_Cut" not found'); Result:=false; end;

//          for i:=0 to 20000 do ;

      end else begin

        //не миллиметровый проект => м.б. поворот, м.б. вставки:
        if not mm_prj then begin

          @dm_Cut:=GetProcaddress(Libhandle,'dm_Cut');
          if Assigned(dm_Cut)
            then dm_Cut(srcPath,map,fn, lp1.x,lp1.y,lp2.x,lp2.y, NIL, la,lb,lc, rotation)
            else begin Tell('dm_util.dll: "dm_Cut" not found'); Result:=false; end;
//xxx:
          _ErrCode:=dmw_ErrCode;
          if _ErrCode<>0 then
            Tellf('ERROR %d in dm_Cut',[_ErrCode]);
          if not FileExists(map) or not FileExists(map_ms) then
            Tellf('ERROR %d in dm_Cut - нет MS-файла',[_ErrCode]);

          //------------------------------------------------------
          //вставки (uses FormMain, GsOptDlg, FormXm(msw_xm.pas)):
          if (FormMain.MultiMsGroup.ItemIndex>0) and Assigned(ms_gc_Enabled) then     //multi
            FormXm.LoadFromMngFile(MsFileShortName+'.txt', GsOptDlg.LibLabel.Caption);
          //------------------------------------------------------

        end else begin

          //миллиметровый проект => без поворота, без вставок:
          @ms_Cut:=GetProcaddress(Libhandle,'ms_Cut');
          if Assigned(ms_Cut)
            then ms_Cut(srcPath,map,fn, lp1.x,lp1.y,lp2.x,lp2.y, -1,mm_prj)
            else begin Tell('dm_util.dll: "ms_Cut" not found'); Result:=false; end;

        end;//if mm_prj

      end;

      FreeLibrary(LibHandle);

    end; {dll ok}

    dmw_Backmap;

  end else begin {if assigned(srcpath)}

    Result:=false;

  end; {if assigned(srcpath)}

  mfree2(_bitPath);
  mfree2(_srcPath);
  mfree2(_fn);
  mfree2(map_ms);
  mfree2(map);

  //Обработка файла рельефа "$.REL":
  RelFileName1 := TmpDir+RelFileName;
  if FileExists(RelFileName1) then begin
    OutFileName := FormMain.AiFileLabel.Caption;
    if Result and (Length(OutFileName)>0) then begin
      RelFileName2 := wcmn_file_dirname(OutFileName) + '.REL' ;
      wcmn_DeleteFile( RelFileName2, true );
      RenameFile(RelFileName1, RelFileName2);
    end else begin
      wcmn_DeleteFile( RelFileName1, true );
    end;
  end;//if FileExists(RelFileName1)
end;


function msw_DmCopy(la,lb: lpoint; include_enabled: boolean): boolean;
begin
  //запись в DmCopyData:
  DmCopyData.Rotation:=false;
  DmCopyData.a:=LpToNum2(la);
  DmCopyData.b:=LpToNum2(lb);
  DmCopyData.map_pw:=abs(lb.x-la.x);
  DmCopyData.map_ph:=abs(lb.y-la.y);
  DmCopyData.incmap:=include_enabled;

  Result:=DmCopyCustom;
end;

function msw_DmCopy2(Rotation: boolean; map_pw,map_ph: tnum; a,b: tnum2; include_enabled: boolean): boolean;//->DmCopyCustom
begin
  //запись в DmCopyData:
  DmCopyData.Rotation:=Rotation;
  DmCopyData.a:=a;
  DmCopyData.b:=b;
  DmCopyData.map_pw:=map_pw;
  DmCopyData.map_ph:=map_ph;
  DmCopyData.incmap:=include_enabled;

  Result:=DmCopyCustom;
end;

{---------------------------------------}


function msw_GsIncludeDirs(xobs, from_abc: boolean): string;
var i: Integer; libdir,msdir: string;
begin
  Result:='';

  libdir:=wcmn_file_dir0(wcmn_UTF2System(GsOptDlg.LibLabel.Caption));
  if libdir<>'' then Result:=libdir+';';

  if xobs then begin
    if from_abc then begin
      Result:=Result+wcmn_file_dir0(abc.gc_names)+';';
    end else begin
      with FormMain.XobList do if Items.Count>0 then
        for i:=0 to Items.Count-1 do Result:=Result+wcmn_file_dir0(wcmn_UTF2System(Items[i]))+';';
    end;//if from_abc
  end;//if xobs

  msdir:=wcmn_System2UTF(UpperDir(libdir)); {with '\'}
  if msdir<>'' then begin
    if DirExists(msdir+'FONTS') then Result:=Result+UpperDir(libdir)+'FONTS'+';';
    if DirExists(msdir+'INCLUDE') then Result:=Result+UpperDir(libdir)+'INCLUDE'+';';
    //Result := Result + wcmn_file_dir0(dmw_Active_Map) + ';';//Комосов: .eps м.б. в дир-ии карты
  end;

  if Length(Result)>0 then SetLength(Result,Length(Result)-1);//обрезание ';' в конце
end;

function msw_x_render(ms_file_name: string; prolog,epilog,gc_from_abc: boolean; ms_msg: string): boolean;
type
//  tmscnv=function(msname,gcxname: PChar; picwidth: single): boolean; stdcall;
  tmscnv=function(msname,gcxname,gclist,mslibdir,flags: PChar; picwidth: single;
                dmname: PChar; a,b: TPoint): boolean; stdcall;
var
  cmd_gs{, cmd_mswcnv}: string; use_run: boolean;
  zs_ms,zs_gcx,zs_gclist,zs_mslibdir,zs_flags: array[1..1024]of Char;
  mscnv: tmscnv;
  MyLibhandle: TLibHandle;
  smsxfname, smslibdir, gslib, gsPath: string;
  pic_width: real;//for GCX

  sdmname: string;
begin

  Result:=false;
  gslib:= wcmn_UTF2System(GsOptDlg.LibLabel.Caption);
  gsPath:= wcmn_UTF2System(GsOptDlg.GSLabel.Caption);

  //ожидание окончания(!!!):
  use_run := ExecuteCmdFile or not epilog or cmn_Tiffs_for_Web;//!

  //файл $.ms:
  if not FileExists(ms_file_name) then begin
     Tell(msgs[13]+_EOL_+ms_file_name);
     exit;
  end;

  //файл ms.x (перед GCX - for pic_width):
  smsxfname:=TmpDir+'ms.x';
  wcmn_DeleteFile(smsxfname, true);
  MakeMsx(smsxfname, pic_width{VAR}, prolog,epilog, ms_msg);//=>ms.x
  if not FileExists(smsxfname) then begin
     Tell(msgs[13]+_EOL_+smsxfname);
     exit;
  end;

  //предобработчик:
  if (abc.gcx_name<>'') then begin

    //GCX:
    if not FileExists(abc.gcx_name) then begin
      Tell(msgs[13]+_EOL_+abc.gcx_name);
      exit;
    end;

    smslibdir:=wcmn_file_dir(gslib);

    //PChar:
    StrPCopy(@zs_ms[1], ms_file_name);
    StrPCopy(@zs_gcx[1], wcmn_UTF2System(abc.gcx_name));
    StrPCopy(@zs_gclist[1], wcmn_UTF2System(abc.gc_names));
    StrPCopy(@zs_mslibdir[1], smslibdir);
    StrPCopy(@zs_flags[1], '');//потом!

    MyLibhandle:=DynLibs.LoadLibrary('msw_las.dll');

    //try
      if MyLibHandle<32 then begin
        ShowMessage(msgs[21]);
      end else begin

        //вызов предобработчика:
        @mscnv:=GetProcaddress(MyLibhandle,'mscnv_exec2');
        if Assigned(mscnv) then begin

          if FormMain.Check_GCX_dm.Checked then begin

            sdmname := dmcmn_active_map(true);
            if Length(sdmname)>0
            then
              Result:=mscnv(@zs_ms[1],@zs_gcx[1],@zs_gclist[1],@zs_mslibdir[1],
                  @zs_flags[1], pic_width, PChar(sdmname), cmn_a,cmn_b);

          end else begin
            Result:=mscnv(@zs_ms[1],@zs_gcx[1],@zs_gclist[1],@zs_mslibdir[1], @zs_flags[1], pic_width, NIL, Point(0,0),Point(0,0));
          end;

        end
        else Tell('ERROR: Load "mscnv_exec2" from "msw.dll"');

      end;
      FreeLibrary(MyLibHandle);
      MyLibHandle := 0;
    {finally
      if MyLibHandle>0 then FreeLibrary(MyLibHandle);
    end;}

  end else begin

    Result:=true; //нет предобработчика

  end;

  if Result and not FormMain.Check_GCX_dm.Checked{!} then begin
    MakeGsCmd(cmd_gs,true{@psl.ini});  {in "msw_msx.pas"}
    {Tell(cmd_gs);}
    Result:=exec_gs2(gsPath, msw_GsIncludeDirs(true,gc_from_abc), cmd_gs, use_run);
    //if epilog and FormMain.CheckShowPage.Checked then EPS_Add_ShowPage(FileName);
  end;
end;


{-----------------------------------------------}
end.
