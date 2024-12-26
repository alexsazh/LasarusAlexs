unit Msfile;

{$MODE Delphi}

 interface

uses
  LCLIntf, LCLType, Classes,
  List, Filex, Arrayx, Color,
  llib, llibx, nums, vlib,
  PSOBJ, Psdicts;


type

//MsObject:---------------------------

  TMsTxt = class
    fname: string;
    fsize: tnum;
    s: string;
    reversed: boolean;
  end;


  TMSObj = class
  private
    FLines,FLinesPath: TStringList;//строки ms-файла: B-sCode,Lev-FLines-FLines2-E
    HDict: TPsDict;//характеристики из FLines (/n value; EX.: /830 '.c.black')
    procedure LoadCharaFromHDict;//HDict->H-Dict(CHARA.PSL: H_Init+...) - for Parent перед выполнением команды
  public
    txt: tmstxt;
    sCode: string;     //"A00000000" (как в $.ms)
    Lev: integer;      //LEV>=0: level in map-tree
    Ofs: integer;       //"DB" остается в FLines;
    constructor Create(asCode: string; aLev: integer);
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(aFile: TFileX); //после "B"+"sCode" !
    procedure SaveToFile(aFile: TFileX);         //B-sCode,Lev-FLines-E

    procedure PolyFromLines(Poly: tpl); //tpl: с дырками!; Clear!;
    procedure TxtFromLines;

    procedure AddLine(s: string);
    procedure TxtToLines(aTxt: TMsTxt);
    procedure PolyToLines(Poly: tpl; dim: integer);
    procedure RingToLines(pc: tnum2; r1,r2: tnum);//кольцо между радиусами r1<r2
    procedure CurvesToLines(Poly: tpl; dim: integer);//moveto, curveto(3 точки)
    procedure TwoPolyToLines(pl1,pl2: tpa; dim: integer; mode: integer);//0-все,1-нечет.,2-чет.
    procedure RectsToLines(pl1,pl2: tpa; dim: integer);
    procedure transform_to_dash(dim: integer; dash_array: tnuma; dash_offset: tnum);

    //характеристики: Read:
    function Get_H_cmyk_S(var cmyk: tcmykcolor; ischild: boolean): boolean;//H-Dict/H-colorname->cmyk
    function Get_H_array: tnuma;//H-Dict/H-array->
    function Get_H_int(hname: string): integer;//H-Dict/hname->
    function Get_H_ukrep: integer;//H-Dict/H-ukrep(hname='H-ukrep')->

    function do_cmd: boolean;//ExecuteCmd if (not H-partdraw and not H-nodraw)

    //характеристики: Write:
    procedure Write_H_cmyk(cmyk: tcmykcolor);//->FLines(children)
    procedure Write_H_ukrep(H_ukrep: integer);//->FLines(children)
  end;


//Группа объектов (MSG[0]: parent):--------------------

  TMSGroup = class(TClassList)//of TMsObj
  private
    FInd: integer; //FindFirst,FindNext
    function Get(i: integer): TMsObj;
  public
    constructor Create;
    function FindFirst(sCodes: TStrings): integer;
    function FindNext(sCodes: TStrings): integer;
    procedure MoveSignChildren(sCodes: TStrings; mso_children: tclasslist);//mso_children.clear
    procedure MoveAllSignChildren(mso_children: tclasslist);
    procedure DrawPlList(PlList: tclasslist; asCode: string; aLev,dim: integer);
    procedure LoadFromFile(aInFile: TFileX; MainObj: TMsObj; var NextObj: TMsObj); // B-E ... B-E
    procedure SaveToFile(aOutFile: TFileX);

    procedure add_tpl(scode: string; lev,dim: tint; pl: tpl);
    procedure add_tpl_list(scode: string; lev,dim: tint; pl_list: tclasslist);
    procedure add_dash_from_tpl(scode: string; lev,dim: tint; pl: tpl; dash_array: tnuma; dash_offset: tnum);

    //MAIN FUNCTION:
    function ExecuteCmd(dim: integer; DmPerMm: single): boolean;

    property Items[Ind: Integer]: TMsObj read Get; default;
  end;


//MsFile:-----------------------------

  TMSFile_ = record
    DmPerMm: single;  //вычисляется в Execute по "map" из $.ms
    x1,y1,x2,y2: longint;//map
    dim: integer;  //2,3
    MapBound: tpl;//L00000000
    PageBound: tpl;//map
  end;

  TMSFile = class
  private
    _: TMSFile_;
    FLines: TStringList;   //строки кроме FData
    FInFile, FOutFile: TFileX;
  public
    constructor Create(aInName, aOutName: string);
    destructor Destroy; override;
    function Execute(width: single): boolean; //read $.ms
//    function PointOnMapBound(p: tnum2; var a,b: tnum2): boolean;
//    function PointOnPageBound(p: tnum2; var a,b: tnum2): boolean;
    function PointOnBound(p: tnum2; var a,b: tnum2): boolean;
    procedure PolyOnBound(pl: tpl; var a_first,b_first,a_last,b_last: tnum2; var first_ok,last_ok: boolean);
  end;


//main function:
function ProcessMsFile(msname: string; width: single): boolean;


var
  MSF: TMSFile;
  ChildList: tclasslist;//initialization



implementation



uses
  Forms, SysUtils,
  Wcmn, gcx, RUNLINE2, CMN,
  hline, hl_dp, SUN, DLINE, KRI_DP, STEPS, L2,
  FORMSX, ROADS, VOLNA, GRADFILL, MOSAIC,
  Psstacks, PSLIB, PSNAMES, PSX, Psarrays,
  Dmlib, dmw_Use;



//-----------------------------------------------------------------


//main function:
function ProcessMsFile(msname: string; width: single): boolean;
var
  InName, OutName: string; // $.ms->$2.ms
  InName0: string; //BAK
begin
  Result:=true;

  InName:=msname;
  OutName:=TmpDir+'$2.ms';
  InName0:=TmpDir+'$0.ms'; //BAK

  try
    MSF:=TMSFile.Create(InName, OutName);
  except
    Result:=false;
    exit; //=>MSCL определена, если нет except
  end;

  if Result then begin
    //RunForm:=TRunForm.Create(Application);
    Application.CreateForm(TRunForm, RunForm);
    //RunForm:=TRunForm.Create(NIL);
    RunForm.Start(InName); //курсор
  end;

  if Result then try
    try
      if Result then Result:=MSF.Execute(width); //<-RunForm.Go;
    except
      Result:=false;
    end;
  finally
    MSF.Free;
    RunForm.Finish; //курсор
  end;

  //после MSF.Free: $2.ms->$.ms
  if Result then begin
    DeleteFile(InName0); RenameFile(InName, InName0); //BAK
    DeleteFile(InName); Result:=RenameFile(OutName, InName);
  end;

  if not Result then Tell('Ошибка предобработки MS-файла');
end;



// TMsObject: -----------------------------------------------


constructor TMSObj.Create(asCode: string; aLev: integer);
begin
  FLines:=TStringList.Create;
  FLinesPath:=TStringList.Create;
  HDict:=TPsDict.Create;
  sCode:=asCode;
  Lev:=aLev;
end;

destructor TMSObj.Destroy;
begin
  txt.free;
  HDict.free;
  FLines.Free;
  FLinesPath.Free;
end;

procedure TMSObj.Clear;
begin
  FLines.Clear;
  FLinesPath.Clear;
  HDict.Clear;
//!  txt.s:='';//?
end;

procedure TMSObj.LoadFromFile(aFile: TFileX);
var
  fline,s1: string; ll: integer;
  ind,hn,hi: integer;
  pl: tpl;
  p1,p2,q1,q2: tnum2; d: tnum;
  pathline,editline: boolean;
  first_ok,last_ok: boolean;
begin
  Clear;
  pathline:=false;
  Ofs:=0;

  while not aFile.EOF do begin
    fline:=aFile.ReadLnS;
    ll:=Length(fline);
    if ll=0 then continue;
    if fline='E' then break; //конец объекта
    s1:=fline; //s1 будет меняться

    case fline[1] of
      'L': //LEV
        if 'LEV'=sread_word(s1) then begin
          Lev:=sread_int(s1);
          continue; //in while => этой строки не будет в FLines
        end;//'L'
      'D': //DB
        if 'DB'=sread_word(s1) then begin
          Ofs:=sread_int(s1);
        end;//'L'
      'H': //характеристика
        begin
          sread_word(s1);//HN,HS,HR,...
          hn:=sread_int(s1);//номер хар-ки

          case fline[2] of
            'S':
            begin
              s1:=copy(s1,2,Length(s1)-1);//значение хар-ки
              HDict.DefS( IntToStr(hn), psobj_str_s(s1) );
//              HNList.Add(hn);
//              HList.Add( psobj_str_s(s1) );
            end;
            'R','F','A','#':
            ;
            else begin
              hi:=sread_int(s1);//значение хар-ки
              HDict.DefS( IntToStr(hn), psobj_int(hi) );
//              HNList.Add(hn);
//              HList.Add( psobj_int(hi) );
            end;
          end;//case fline[2]

        end;//'H'
    end;//case

    //moveto => оставшаяся часть строк до 'E' попадет в FLinesPath:
    if ( (fline[ll]='m') OR (fline[ll]='R'{CR-круг}) )
    and ( pos(fline[1],'+-.,0123456789')>0 )
    then pathline:=true;

    //default (не было "continue"):
    if pathline then FLinesPath.Add(fline)
    else FLines.Add(fline);
  end;//while

  //рамка карты:
  if sCode='L00000000' then begin
    PolyFromLines(MSF._.MapBound);
  end;

  //ProlongLines (gcx.pas):
  ind:=ProlongLines.IndexOf(sCode);
  if ind>=0 then begin
    pl:=tpl.new;
    try
      PolyFromLines(pl);
      editline:=false;

      if (pl.count>1) and (sCode[1]='L') then begin
(*
        if MSF.PointOnBound(pl.First,p1,p2) then begin
          pl.prolong(0,1000*MSF._.DmPerMm);
          editline:=true;
        end;
        if MSF.PointOnBound(pl.Last,p1,p2) then begin
          pl.prolong(1,1000*MSF._.DmPerMm);
          editline:=true;
        end;
*)
        MSF.PolyOnBound(pl, p1,p2, q1,q2, first_ok,last_ok);
        if first_ok then begin
          pl.prolong(0,1000*MSF._.DmPerMm);
          editline:=true;
        end;
        if last_ok then begin
          pl.prolong(1,1000*MSF._.DmPerMm);
          editline:=true;
        end;

      end;//pa.count>1

      if editline then begin
        FLinesPath.Clear;
        PolyToLines(pl, MSF._.dim);
      end;
    finally
      pl.Free;
    end;//try
  end;//ind>=0

  //LinesOnBound (gcx.pas):
  ind:=LinesOnBound.IndexOf(sCode);
  if ind>=0 then begin
    d:=LinesOnBoundDelta[ind]*MSF._.DmPerMm;
    pl:=tpl.new;
    try
      PolyFromLines(pl);
      editline:=false;
      if pl.count>1 then begin

        if MSF.PointOnBound(pl.First,p1,p2) then begin
          pl.trunc_ab(0,d,p1,p2);
          editline:=true;
        end;

        if MSF.PointOnBound(pl.Last,p1,p2) then begin
          pl.trunc_ab(1,d,p1,p2);
          editline:=true;
        end;

      end;//pa.count>1
      if editline then begin
        FLinesPath.Clear;
        PolyToLines(pl, MSF._.dim);
      end;
    finally
      pl.Free;
    end;//try
  end;//ind>=0
end;

procedure TMSObj.SaveToFile(aFile: TFileX);   //B-FData-FLines-E
var i: integer;
begin
  aFile.WritelnS('B');
  aFile.WritelnS(sCode);
  aFile.WritelnS('LEV '+IntToStr(Lev));
  if FLines.Count>0 then for i:=0 to FLines.Count-1 do aFile.WritelnS(FLines[i]);
  if FLinesPath.Count>0 then for i:=0 to FLinesPath.Count-1 do aFile.WritelnS(FLinesPath[i]);
  aFile.WritelnS('E');
end;


procedure TMSObj.PolyFromLines(Poly: tpl);
var
  i,l,n: integer; s0,s: string;
  xy: array[0..8]of integer;//9 - макс кол-во эл-ов в строке $.ms
  p,pc: tnum2;
  pl: tpl;
  r: double;//радиус
  fi: double;//радианы
begin
  Poly.Clear;
  pl:=Poly;//текущий контур

  if FLinesPath.Count>0 then for l:=0 to FLinesPath.Count-1 do begin

    s0:=FLinesPath[l];
    if s0[1] in ['0'..'9','-','+'] then begin

      for i:=0 to 8 do begin
        s:=sread_word(s0);
        if (s='') or isalfa(s[1]) then break;
        xy[i]:=ivaldef(s,0);
      end;//for i

      if (s<>'') then case s[1] of
        'm':
        begin
          //начало дырки:
          if pl.Count>0 then begin
            pl.next:=tpl.new;
            pl:=pl.next;
          end;
          p.x:=xy[0];
          p.y:=xy[1];
          pl.Add(p);
        end;
        'l':
        begin
          p.x:=xy[0];
          p.y:=xy[1];
          pl.Add(p);
        end;
        'c': Tellf('%s: кривые Безье не обрабатываются',[sCode]); //!

        //КРУГ (cx cy r CR):
        'C':
        if s='CR' then begin
          pc.x:=xy[0];
          pc.y:=xy[1];
          r:=xy[2];

          n:=8{8?};//for frm_Besedka58

          for i:=0 to n{0..2*PI} do begin
            fi := i*(2*System.PI/n) + (2*System.PI/n)/2;
            p.x := Cos(fi);
            p.y := Sin(fi);
            p := v_add(pc, v_mul(p, r));
            pl.Add(p);
          end;//for i

        end;//'CR'

      end;{case}
    end;{if}
  end;{for l}
end;

//в DM_GCX стоим на родителе или предыдущем добавленном
//Poly м.б. с дырками!
procedure TMSObj.PolyToLines(Poly: tpl; dim: integer);
var
  i: integer; s,s2: string; p: tnum2; pl:tpl; _down: boolean;
begin
  //КАРТА cmn_dm( _GCX):
  if Assigned(cmn_newdm) then begin
    _down := cmn_newdmo_count=0;
    if cmn_newdm_add_pl(Self.sCode{A00000000}, Poly, _down)//с дырками
    then inc(cmn_newdmo_count)
    else Tellf('ERROR in cmn_dm_add_pl(%s(%d))',[Self.sCode,Self.Ofs]);
  end;

  // $.ms2:
  pl:=Poly;
  while pl<>nil do begin

    if pl.Count>0 then for i:=0 to pl.Count-1 do begin
      p:=pl[i];
      if i=0 then s:='m' else s:='l';
      if dim=2 then s2:=Format('%.0f %.0f %s',[p.x, p.y, s])
      else s2:=Format('%.0f %.0f 0 %s',[p.x, p.y, s]);
      FLinesPath.Add(s2);
    end;
    if pl.Closed then FLinesPath.Add('cp');

    pl:=pl.Next;//дырки

  end;//while
end;

procedure TMSObj.RingToLines(pc: tnum2; r1,r2: tnum);//кольцо между радиусами r1<r2
begin
  FLinesPath.Add( Format('%.2f %.2f %.4f CR',[pc.x,pc.y,r2]) );//круг
  FLinesPath.Add( Format('%.2f %.2f %.4f CR',[pc.x,pc.y,r1]) );//дырка
end;

procedure TMSObj.CurvesToLines(Poly: tpl; dim: integer);//moveto, curveto(3 точки)
var i,n: integer; s2: string; p1,p2,p3: tnum2; pl:tpl;
begin
  pl:=Poly;
  while pl<>nil do begin

    n:=(pl.Count-1) div 3; if n<=0 then continue;//!

    //moveto:
    p1:=pl[0];
    if dim=2 then s2:=Format('%.0f %.0f %s',[p1.x,p1.y, 'm'])
    else s2:=Format('%.0f %.0f 0 %s',[p1.x,p1.y, 'm']);
    FLinesPath.Add(s2);

    //curveto:
    for i:=0 to n-1 do begin
      p1:=pl[1+3*i];
      p2:=pl[2+3*i];
      p3:=pl[3+3*i];
      if dim=2 then s2:=Format('%.0f %.0f %.0f %.0f %.0f %.0f %s',[p1.x,p1.y, p2.x,p2.y, p3.x,p3.y, 'c'])
      else s2:=Format('%.0f %.0f 0 %.0f %.0f 0 %.0f %.0f 0 %s',[p1.x,p1.y, p2.x,p2.y, p3.x,p3.y, 'c']);
      FLinesPath.Add(s2);
    end;
    if pl.Closed then FLinesPath.Add('cp');//!

    pl:=pl.Next;

  end;//while
end;

//mode: 0-все,1-нечет.,2-чет.:
procedure TMSObj.TwoPolyToLines(pl1,pl2: tpa; dim: integer; mode: integer);
var i: integer; vec: tpl;
begin
  vec:=tpl.new; //2 точки
  if pl1.count>0 then for i:=0 to pl1.count-1 do begin
    if (mode=1) and ((i mod 2)=0) then continue;
    if (mode=2) and ((i mod 2)=1) then continue;
    vec[0]:=pl1[i];
    vec[1]:=pl2[i];
    PolyToLines(vec, dim);
  end;
  vec.free;
end;

procedure TMSObj.RectsToLines(pl1,pl2: tpa; dim: integer);
var i: integer; rec: tpl;
begin
  rec:=tpl.new; //5 точек
  if pl1.count>0 then for i:=0 to pl1.count-1 do begin
    if ((i mod 2)=1) then continue;
    rec[0]:=pl1[i];
    rec[1]:=pl2[i];
    rec[2]:=pl2[i+1];
    rec[3]:=pl1[i+1];
    rec[4]:=rec[0];
    PolyToLines(rec, dim);
  end;
  rec.free;
end;


procedure TMSObj.transform_to_dash(dim: integer; dash_array: tnuma; dash_offset: tnum);
var i: integer; pl,pl_tmp: tpl; dash: tdash; pl_list: tclasslist;
begin
  pl:=tpl.New;
  pl_list:=tclasslist.new;
  dash:=tdash.Create(dash_array, dash_offset);
  try
    PolyFromLines(pl);
    dash.MakeDashLine(pl, pl_list, false);

    if pl_list.Count>0 then begin
      FLinesPath.Clear;//!
      for i:=0 to pl_list.Count-1 do begin
        tobject(pl_tmp):=pl_list[i];
        PolyToLines(pl_tmp, dim);
      end;
    end;//if pl_list.Count>0

  finally
    dash.free;
    pl_list.free;
    pl.Free;
  end;
end;


procedure TMSObj.TxtFromLines;
var s0,sw: string; l: integer;
begin
  if FLines.Count>0 then for l:=0 to FLines.Count-1 do begin
    s0:=FLines[l];//изменится!
    sw:=sread_word(s0);
    if (sw='F') then begin
      txt.fname:=sread_word(s0);
    end else if (sw='s') then begin
      txt.fsize:=sread_real(s0);
    end else if (sw='t') then begin
      txt.s:=system.copy(s0,2,Length(s0)-1);
    end;{if}
  end;{for l}
end;

procedure TMSObj.TxtToLines(aTxt: TMsTxt);
var s: string;
begin
  FLines.Add('F '+aTxt.fname);
  s := 's '+Format('%.2f',[aTxt.fsize]);
  FLines.Add(s);
  FLines.Add('t '+aTxt.s);
end;


procedure TMSObj.AddLine(s: string);
begin
  FLines.Add(s);
end;


//характеристики:

procedure TMSObj.LoadCharaFromHDict;//H-Dict(H_Init+...) - for Parent перед выполнением команды
begin
  if cmn_CharaExists then begin
//    pslib_runstring('ps');//DEBUG
    pslib_runstring('H-Init H-Dict begin');
    HDict.forall(cmn_CharaProc);
//    Tellf('303=<%s>',[HDict.View('303')]);//DEBUG
//    Tellf('H-nodraw=<%s>',[cmn_H_Dict.View('H-nodraw')]);//DEBUG
    pslib_runstring('end %H-Dict');
  end;
end;

function TMSObj.Get_H_cmyk_S(var cmyk: tcmykcolor; ischild: boolean): boolean;
var s: string; po: ppsobj; o: tpsobj; i: integer;
begin
  Result:=false;
  s:='';
  if ischild then LoadCharaFromHDict;//!!!

  if cmn_CharaExists then try
//    pslib_runstring('H-Dict /H-colorname known ps pop');//DEBUG
    pslib_runstring('H-Dict /H-colorname get');
    po:=operandstack.GetP(0);
    s:=psobj_asstring(po^);
    operandstack.pop;
  except
    s:='';
  end else begin
    if HDict.Value( Ps.Names.Key('830'), o, i) then s:=psobj_asstring(o);
  end;
  if Length(s)>0 then begin Result:=true; cmyk:=Str2CMYK(s); end;
end;

function TMSObj.Get_H_int(hname: string): integer;//H-Dict/hname->
var po: ppsobj; s: string;
begin
  Result:=0;
  if cmn_CharaExists then try
    s:=Format('H-Dict /%s known {H-Dict /%s get}{0}ifelse',[hname,hname]);
    pslib_runstring(s);
    po:=operandstack.GetP(0);
    Result:=psobj_asint(po^);
    operandstack.pop;
  except
    Result:=0;
  end;
end;

function TMSObj.Get_H_ukrep: integer;//H-Dict->
//var po: ppsobj;
begin
  Result:=Get_H_int('H-ukrep');
(*
  Result:=0;
  if cmn_CharaExists then try
    pslib_runstring('H-Dict /H-ukrep known {H-Dict /H-ukrep get}{0}ifelse');
    po:=operandstack.GetP(0);
    Result:=psobj_asint(po^);
    operandstack.pop;
  except
    Result:=0;
  end;
*)
end;

function TMSObj.Get_H_array: tnuma;//H-Dict->
var po: ppsobj; a: tpsarray; i: tint;
begin
  Result:=tnuma.new;
  if cmn_CharaExists then try
    pslib_runstring('H-Dict /H-array known {H-Dict /H-array get}{[]}ifelse');
//    pslib_runstring('dup dup type exch length ps pop pop');//DEBUG
    po:=operandstack.GetP(0);
    a:=tpsarray( psobj_psobjx(po^) );
    if a.count>0 then for i:=0 to a.count-1 do begin
      Result.Add( psobj_asreal(a.Items[i]) );
    end;
    operandstack.pop;
  except ;
  end;
end;

function TMSObj.do_cmd: boolean;//=>ExecuteCmd (HX 303 <> 1)
var po: ppsobj; o: tpsobj; i,i1,i2: integer;
begin
  if cmn_CharaExists then try
    pslib_runstring('H-Dict /H-nodraw get');
    po:=operandstack.GetP(0);
    i1:=psobj_asint(po^);
    operandstack.pop;
    pslib_runstring('H-Dict /H-partdraw get');
    po:=operandstack.GetP(0);
    i2:=psobj_asint(po^);
    operandstack.pop;
    Result := (i1=0) and (i2=0);
  except
    Result := true;
  end else begin
    if HDict.Value(Ps.Names.Key('303'), o, i) then i:=psobj_asint(o) else i:=-1;
    Result := (i<>1) and (i<>5);
  end;
end;


procedure TMSObj.Write_H_cmyk(cmyk: tcmykcolor);
begin
  FLines.Add( Format('%.4f %.4f %.4f %.4f @H-dmcmyk',[cmyk.c,cmyk.m,cmyk.y,cmyk.k]) );
end;

procedure TMSObj.Write_H_ukrep(H_ukrep: integer);//H-Dict->FLines(children)
begin
  if H_ukrep<>0 then FLines.Add( Format('%d @H-ukrep',[H_ukrep]) );
end;


// TMSGroup: ------------------------------------------

constructor TMSGroup.Create;
begin
  inherited Create(16);
end;

function TMSGroup.Get(i: integer): TMsObj;
begin
  TObject(Result):=inherited Get(i);
end;


function TMSGroup.FindFirst(sCodes: TStrings): integer;
begin
//  FInd:=-1;
  FInd:=0;//начиная с 1-го - без родителя
  Result:=FindNext(sCodes);
end;

function TMSGroup.FindNext(sCodes: TStrings): integer;
var i: integer; mso: tmsobj;
begin
  Result:=-1;
  if Count>FInd+1 then for i:=FInd+1 to Count-1 do begin
    if items[i]=nil then continue;//м.б. после Move... (!)
    tmsobj(mso):=items[i];
    if sCodes.IndexOf(mso.scode)<0 then continue;
    Result:=i;
    break;
  end;
  if Result>=0 then FInd:=Result;
end;

procedure TMSGroup.MoveSignChildren(sCodes: TStrings; mso_children: tclasslist);
var ind: integer; mso: tmsobj;
begin
  mso_children.clear;
  ind:=FindFirst(sCodes);
  while ind>0 do begin
    tobject(mso):=Items[ind];
    if mso.sCode[1]='S' then mso_children.MoveFrom(Self,ind);
    ind:=FindNext(sCodes);
  end;
end;

procedure TMSGroup.MoveAllSignChildren(mso_children: tclasslist);
var i: integer; mso: tmsobj;
begin
  mso_children.clear;
  if count>1 then for i:=1 to count-1 do begin//i=0: Parent!
    if items[i]=nil then continue;//м.б. после Move... (!)
    tobject(mso):=Items[i];
    if mso.sCode[1]='S' then mso_children.MoveFrom(Self,i);
  end;
end;

procedure TMSGroup.DrawPlList(PlList: tclasslist; asCode: string; aLev,dim: integer);
var i: integer; mso: tmsobj; pl: tpl;
begin
  if PlList.count>0 then for i:=0 to PlList.count-1 do begin
    TObject(pl):=PlList[i];
    mso:=tmsobj.Create(asCode, aLev);
    mso.PolyToLines(pl,dim);
    Add(mso);
  end;
end;

procedure TMSGroup.LoadFromFile(aInFile: TFileX; MainObj: TMsObj; var NextObj: TMsObj);
var fline,s1: string; obj: TMsObj;
begin
  NextObj:=nil;
  Clear;
  Add(MainObj); //parent - первый в списке

  //childs:
  while not aInFile.EOF do begin

    fline:=aInFile.ReadLnS;
    if Length(fline)=0 then continue;

    s1:=fline;
    case fline[1] of

      'B': //B
      if 'B'=sread_word(s1) then begin
        s1:=aInFile.ReadLnS;
        obj:=TMsObj.Create(s1,0); //default: Lev=0
        obj.LoadFromFile(aInFile);
        if obj.Lev>MainObj.Lev then begin
          Add(obj);
        end else begin
          NextObj:=obj;
          break;
        end;
        continue; //in while!
      end;

    end;//case

    //default (не было "continue"): пропуск
    //т.к. группа будет записываться потом!

  end;//while
end;

procedure TMSGroup.SaveToFile(aOutFile: TFileX);
var i: integer; o: TMsObj;
begin
  if Count>0 then for i:=0 to Count-1 do begin
    o:=Items[i];
    if o<>nil then o.SaveToFile(aOutFile);
  end;
end;


procedure TMSGroup.add_tpl(scode: string; lev,dim: tint; pl: tpl);
var mso: tmsobj;
begin
  mso:=tmsobj.create(scode, lev);
  mso.PolyToLines(pl, dim);
  Add(mso);
end;

procedure TMSGroup.add_tpl_list(scode: string; lev,dim: tint; pl_list: tclasslist);
var i: integer; pl: tpl;
begin
  if pl_list.count>0 then for i:=0 to pl_list.count-1 do begin
    tobject(pl):=pl_list[i];
    add_tpl(scode, lev,dim, pl);
  end;
end;

procedure TMSGroup.add_dash_from_tpl(scode: string; lev,dim: tint; pl: tpl; dash_array: tnuma; dash_offset: tnum);
var dash: tdash; pl_list: tclasslist;
begin
  pl_list:=tclasslist.new;
  dash:=tdash.Create(dash_array, dash_offset);
  try
    dash.MakeDashLine(pl, pl_list, false);
    add_tpl_list(scode,lev,dim, pl_list);
  finally
    dash.free;
    pl_list.free;
  end;
end;

//========================= MAIN: ===========================

//в gcx.pas команда уже установлена:
function TMSGroup.ExecuteCmd(dim: integer; DmPerMm: single): boolean;
var
  i,j,j0,j1,ind,ind2,ind3,n: integer;
  cmdname,childcode,scode,scode_b,scode_m,scode_e: string;
  mso0: tmsobj;//parent!
  mso1,mso2,mso,child,mso_l,mso_r: tmsobj;//tmp
  pa0,pa1,pa2,pa_l1,pa_l2,pa_s,pax: tpl;//global new-free
  paxtmp,pl1,pl2: tpl;//local vars
  pab,pae,pab2,pae2: tpa;//local vars
  outlist,outlistx: tclasslist;//of tpl (DIV,VOLNA)
  isyama: boolean; //for SUN
  txtreversed: boolean; //for DIV
  inds: tinta;//VOLNA
  H_ukrep: integer;//HL
  numa: tnuma;
  dash: tdash;//DASH
begin
  Result:=false;
  gcx_DmPerMm := DmPerMm;
  cmdname := gcx_cmdname;

  //Input:
  pa0:=tpl.new; //parent общего пользования
  pa1:=tpl.new; //child общего пользования
  pa2:=tpl.new; //...
  pa_l1:=tpl.new;//дети-линии
  pa_l2:=tpl.new;//...
  pa_s:=tpl.new;//дети-точки
  pax:=tpl.new;

  mso0:=Items[0]; //parent pa0 есть всегда
  mso0.PolyFromLines(pa0); //parent pa0 есть всегда

  ChildList.Clear;//initialization
  hldp_init;//hl_dp.pas

  //объекты, добавляемые в dm_GCX - встаем на PARENT:
  if Assigned(cmn_newdm) then begin
    cmn_newdmo_count:=0;
    if not dm_goto_node( mso0.Ofs ) then
      Tellf('FALSE in dm_goto_node(%d) on DM_GCX',[mso0.Ofs]);
  end;

  try //except
  try //finally

//----------------------------------------------------
//----------------------------------------------------
  if (cmdname='MOSAIC') then begin
    gcx_hl_load;
    gcx_st_load;
    gcx_mosaic_load;

    //дочерняя линия:
    pa1.clear;//первая ступень
    ind:=FindFirst(gcx_obj.child);
    if ind<=0 then exit;
    tobject(mso):=Items[ind];
    mso.PolyFromLines(pa1);
    pa1.DirectLine(pa0,false);

    //Шаг1: ступени:
    pa2.clear;//последняя ступень
    numa:=mso0.Get_H_array;
    //вместе с 1-ой и посл. ступенями:
    outlist:=st_execute(pa0,pa1,pa2,gcx_st.nsteps,gcx_st.dx,numa,true);//steps.pas
    numa.free;//!
    Result:=true;

    //Шаг2: штрихи:
    outlistx:=tclasslist.new;//4-хугольники
    pab:=tpl.new; pae:=tpl.new;
    pab2:=tpl.new; pae2:=tpl.new;
    try
      //четное кол-во промеж-ов:
      n:=Round(pa1.lena.last/gcx_hl.step); if n<1 then n:=1;
      if odd(n){нечет} then inc(n);

      if outlist.count>1 then for i:=0 to outlist.count-2 do begin
        tobject(pl1):=outlist[i];
        tobject(pl2):=outlist[i+1];

        hldp_init;
        pab.clear;
        pae.clear;
        Result:=hldp_connect(pl1,pl2, pab,pae, n);

        //pab2,pae2:
        j0:=0;
        if (pab.count>1) and (pab.count=pae.count) then for j:=0 to pab.count-1 do begin
          if (not odd(i){чет} and not odd(j)) or (odd(i){нечет} and odd(j)) then begin
            inc(j0);
            pab2.add(pab[j]);
            pae2.add(pae[j]);

            //4-хугольник (против час.стр.):
            if j0>1 then begin
              paxtmp:=tpl.New;
              if gcx_mosaic.imode=1 then begin
                paxtmp.add( pab[j-2] );
                paxtmp.add( pab[j] );
                paxtmp.add( pae[j] );
                paxtmp.add( pae[j-2] );
              end else begin
                paxtmp.add( pab[j-1] );
                paxtmp.add( v_lt(pab[j],pae[j],0.5) );
                paxtmp.add( pae[j-1] );
                paxtmp.add( v_lt(pab[j-2],pae[j-2],0.5) );
              end;
              paxtmp.add(paxtmp.first);//замыкание
              outlistx.Add(paxtmp);
            end;//if j0>1

          end;//odd&odd
        end;//for j

      end;//for i

      if gcx_mosaic.imode=0 then begin

        //Output outlist:
        if outlist.count>0 then for i:=0 to outlist.count-1 do begin
          mso:=tmsobj.create(gcx_obj.outcode[gcx_st.parent_code], mso0.lev);
          mso.PolyToLines(tpl(outlist[i]), dim);
          Add(mso);//->MSG
        end;
        //Output pab2, pae2:
        if pab2.count>0 then begin
          mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch_code], mso0.lev);
          mso.TwoPolyToLines(pab2, pae2, dim, 0);//отрезки
          Add(mso);//->MSG
        end;//pab2.count>0

      end else begin//gcx_mosaic.imode=0

        //Output outlistx (овалы):
        if outlistx.count>0 then for i:=0 to outlistx.count-1 do begin
          tobject(paxtmp):=outlistx[i];
          mosaic_make_oval(paxtmp,pax);
          mso:=tmsobj.create(gcx_obj.outcode[gcx_st.parent_code], mso0.lev);
          mso.CurvesToLines(pax, dim);
          Add(mso);//->MSG
        end;

      end;//gcx_mosaic.imode=0

    finally
      outlist.free;
      outlistx.free;
      pab.free; pae.free;
      pab2.free; pae2.free;
    end;

  end;//cmdname='MOSAIC'

//----------------------------------------------------
  //градиентная заливка(grsdfill.pas):
  if cmdname='GF' then begin
    gcx_gf_load;

    //загрузка точек цвета:
    MoveAllSignChildren(ChildList);
    GfColor.LoadColorPoints(ChildList);

    //клиппинг - начало (EXIT - НЕЛЬЗЯ!!!):
    if mso0.sCode[1]='A' then begin
      mso:=tmsobj.Create(mso0.scode,mso0.lev);
      mso.FLinesPath.AddStrings(mso0.FLinesPath);
      mso.FLinesPath.Add('@0 GS Clip');
      Insert(1,mso);
    end;
    try

      //круг:
      if gcx_gf.mode=0 then begin
        //область:
        if mso0.sCode[1]='A' then begin
          ind:=FindFirst(gcx_obj.child);
          if ind>0 then begin
            mso:=Items[ind]; mso.PolyFromLines(pa1);
            if pa1.count>1 then gf_AddColorAreasOnRing(Self, pa1, mso0.Lev);
          end;
        end;
        //радиус:
        if (mso0.sCode[1]='L') or (mso0.sCode[1]='S') then begin
          if pa0.count>1 then gf_AddColorAreasOnRing(Self, pa0, mso0.Lev);
        end;
      end;

      //линия в области:
      if gcx_gf.mode=1 then begin
        ind:=FindFirst(gcx_obj.child);
        if ind>0 then begin
          mso:=Items[ind]; mso.PolyFromLines(pa1);
          gf_AddColorAreasByLine(Self, pa0,pa1, mso0.Lev,dim);
        end;
      end;

      //область и 3 линии (в одном направлении!):
      if gcx_gf.mode=2 then begin
        ind:=FindFirst(gcx_obj.child);
        ind2:=FindNext(gcx_obj.child);
        ind3:=FindNext(gcx_obj.child);
        if (ind>0) and (ind2>0) and (ind3>0) then begin
          mso:=Items[ind];  mso.PolyFromLines(pa1);
          mso:=Items[ind2]; mso.PolyFromLines(pa2);
          mso:=Items[ind3]; mso.PolyFromLines(pax);
          gf_AddColorAreasBy3Lines(Self, pa1,pa2,pax, mso0.Lev,dim);
        end;
      end;

      //отмывка линии:
      if gcx_gf.mode=3 then begin
        if mso0.sCode[1]='L' then begin
          ind:=FindFirst(gcx_obj.child);
          if ind>0 then begin
            mso:=Items[ind]; mso.PolyFromLines(pa1);
            if (pa0.count>1) and (pa1.count>1) then
              gf_AddColorAreasByWidth(Self, pa0,pa1, mso0.Lev,dim);
          end;
        end;
      end;

    finally
      //клиппинг - конец:
      if mso0.sCode[1]='A' then begin
        mso:=tmsobj.Create(mso0.scode,mso0.lev);
        mso.FLinesPath.Add('@0 GR');
        Add(mso);
      end;
    end;//try

  end;//GF

//----------------------------------------------------
  //зигзаг или волна (volna.pas):
  if cmdname='VOLNA' then begin
    gcx_volna_load;

    inds:=tinta.new;
    outlist:=tclasslist.new;
    try
      volna_execute(pa0,outlist,inds);
      //Output:
      if outlist.count>0 then begin
        for i:=0 to outlist.count-1 do begin
          scode:=gcx_obj.outcode[ inds[i] ];
          if Length(scode)=0 then scode:=mso0.scode;
          mso:=tmsobj.create( scode, mso0.lev );
          if gcx_volna.dash_modes[ inds[i] ]<>2 then mso.PolyToLines( tpl(outlist[i]), dim)
          else mso.CurvesToLines( tpl(outlist[i]), dim);
          Add(mso);//->MSG
        end;//for i
        //DeleteFirst;//исходная линия
      end;//Output
    finally
      outlist.free;
      inds.free;
    end;
  end;//VOLNA
//----------------------------------------------------

  //пунктир:
  if cmdname='DASH' then begin
    gcx_dash_load;

    outlist:=tclasslist.new;
    try

      //make outlist:
      if gcx_dash.dash_array.Count>0 then begin
        dash:=tdash.Create(gcx_dash.dash_array, gcx_dash.dash_offset);
        try
          dash.MakeDashLine(pa0, outlist, false);
        finally
          dash.free;
        end;
      end;//make outlist

      //Output:
      if outlist.count>0 then begin
        for i:=0 to outlist.count-1 do begin
          if gcx_obj.outcode.Count>0 then scode:=gcx_obj.outcode[0]
          else scode:=mso0.scode;
          mso:=tmsobj.create( scode, mso0.lev );
          mso.PolyToLines( tpl(outlist[i]), dim);
          Add(mso);//->MSG
        end;//for i

        DeleteFirst;//исходная линия
      end;//Output

    finally
      outlist.free;
    end;
  end;//DASH


//----------------------------------------------------
  //формы:
  if cmdname='FORMS' then begin
    gcx_forms_load;

    if gcx_forms.name='Pogreb' then begin
      gcx_hl_load;//!
      pab:=tpa.new; pae:=tpa.new;
      try
        frm_pogreb(pa0, pab,pae);
        mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch_code], mso0.lev);
        mso.TwoPolyToLines(pab, pae, dim, 0);//отрезки
        Add(mso);//->MSG
      finally
        pab.free; pae.free;
      end;
    end;//'Pogreb'

    if gcx_forms.name='Besedka58' then begin
      pab:=tpa.new;
      pae:=tpa.new;
      try
        frm_Besedka58(pa0, pab,pae);
        mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
        mso.TwoPolyToLines(pab, pae, dim, 0);//отрезки
        Add(mso);//->MSG
      finally
        pab.free;
        pae.free;
      end;
    end;//'Besedka58'

    if gcx_forms.name='Kran105' then begin
      pax.clear;
      frm_Kran105(pa0, pax);
      mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
      mso.PolyToLines(pax, dim);
      Add(mso);//->MSG
    end;//'Kran105'

    //76,77:
    if (gcx_forms.name='Bak76') or (gcx_forms.name='Bak77') then begin
      pax.clear;
      pa1.clear;
      frm_Bak76_77(pa0, pa1, pax, (gcx_forms.name='Bak76'));
      if (gcx_forms.name='Bak76') and (gcx_obj.outcode.Count>0) then begin
        mso:=tmsobj.create(gcx_obj.outcode[1], mso0.lev);//вторая (внутренняя) линия
        mso.PolyToLines(pa1, dim);
        Add(mso);//->MSG
      end;
      mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);//площадь черная
      mso.PolyToLines(pax, dim);
      Add(mso);//->MSG
    end;//'Bak76'

    //78:
    if (gcx_forms.name='Bak78') then begin
      //pa1.clear;
      pab:=tpa.new;
      pae:=tpa.new;
      try
        frm_Bak78(pa0, pab, pae);
        (*
        mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);//линия
        mso.PolyToLines(pa0, dim);
        Add(mso);//->MSG
        *)
        mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);//линия
        mso.TwoPolyToLines(pab, pae, dim, 0);//отрезки
        Add(mso);//->MSG
//        Delete(0);//parent       //оставим mso0 для бланкирования(!)
      finally
        pab.free;
        pae.free;
      end;
    end;//'Bak78'

    //79,80:
    if (gcx_forms.name='Bak79') or (gcx_forms.name='Bak80') then begin
      //pa1.clear;
      pax.clear;
      pab:=tpa.new;
      pae:=tpa.new;
      try
        frm_Bak79_80(pa0, pax, pab,pae,(gcx_forms.name='Bak79'), (gcx_forms.name='Bak80'));

        //pax:
        if (gcx_forms.name='Bak79') and (gcx_obj.outcode.Count>0) then begin
          mso:=tmsobj.create(gcx_obj.outcode[1], mso0.lev);//черная область
          mso.PolyToLines(pax, dim);
          Add(mso);//->MSG
        end;

        mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);//линия
        mso.PolyToLines(pa0, dim);// - без нижнего отрезка!
        Add(mso);//->MSG

        mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);//линия
        mso.TwoPolyToLines(pab, pae, dim, 0);//отрезки
        Add(mso);//->MSG

      finally
        pab.free;
        pae.free;
      end;
    end;//'Bak79_80'

    if gcx_forms.name='Bunker98' then begin
      pax.clear;
      frm_Bunker98(pa0, pax);
      mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
      mso.PolyToLines(pax, dim);
      Add(mso);//->MSG
    end;//'Bunker98'

    if gcx_forms.name='Bak95' then begin
      ind:=FindFirst(gcx_obj.child); if ind<1 then exit;
      mso:=Items[ind]; mso.PolyFromLines(pa1);
      pax.clear;
      frm_Bak95(pa0,pa1, pax);
      mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
      mso.PolyToLines(pax, dim);
      Add(mso);//->MSG
    end;//'Bak95'

    if (gcx_forms.name='Krilco35') or (gcx_forms.name='Krilco36') then begin
      ind:=FindFirst(gcx_obj.child);
      if ind>=1 then begin
        mso:=Items[ind];
        mso.PolyFromLines(pa1);
        pa1.DirectLine(pa0,true);
      end else begin
        pa1.Clear;
        pa1[0]:=pa0[0];
        pa1[1]:=pa0[1];
      end;
      pax.clear;
      frm_Krilco35(pa0,pa1, pax, gcx_forms.name='Krilco35');
      add_tpl(gcx_obj.outcode[0],mso0.lev,dim,pax);
    end;//'Krilco35'

    if gcx_forms.name='Stenka' then begin
      ind:=FindFirst(gcx_obj.child);
      if ind>=1 then begin
        mso1:=Items[ind];
        mso1.PolyFromLines(pa1);
        pa1.DirectLine(pa0,false);
      end else begin
        pa1.Clear;
        pa1[0]:=pa0[1];
        pa1[1]:=pa0[0];
      end;
      pax.clear;
      outlist:=frm_Stenka(pa0,pa1, gcx_forms.len);//m.b.Area!
      if outlist.count>0 then for i:=0 to outlist.count-1 do begin
        mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
        mso.PolyToLines(tpl(outlist[i]), dim);
        Add(mso);//->MSG
      end;
      outlist.free;
    end;//'Stenka'

    if gcx_forms.name='Priyamok54' then begin
      frm_Priyamok54(pa0,pax,gcx_forms.step);
      add_tpl(gcx_obj.outcode[0],mso0.lev,dim,pax);
    end;//'Priyamok54'


    //МОСТЫ:

    if (gcx_forms.name='Bridge') or (gcx_forms.name='BridgeM')
    or (gcx_forms.name='BridgeS') or (gcx_forms.name='BridgeMY')
    or (gcx_forms.name='BridgeMYM')
    then begin

      ind:=FindFirst(gcx_obj.child);
      if ind<1 then exit;
      mso1:=Items[ind];
      mso1.PolyFromLines(pa1);//сторона моста 1-ая
      pa1.DirectLine(pa0,true);

      ind:=FindNext(gcx_obj.child);
      if ind<1 then exit;
      mso2:=Items[ind];
      mso2.PolyFromLines(pa2); //сторона моста 2-ая
      pa2.DirectLine(pa0,true);

      pax.clear;
      pab:=tpa.new;
      pae:=tpa.new;
      try
        //гармошка:
        if gcx_forms.name='BridgeM' then begin
          frm_Pila(pa1,pa2, pax);
          mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
          mso.PolyToLines(pax, dim);
          Add(mso);//->MSG
        end;
        //поперечные штрихи:
        if gcx_forms.name='BridgeS' then begin
          frm_Steps(pa1,pa2, pab,pae);
          mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
          mso.TwoPolyToLines(pab,pae, dim, 0);
          Add(mso);//->MSG
        end;
        //дополн-ые боковые линии:
        if gcx_forms.name='BridgeMY' then begin
          frm_MY(pa1, pax);
          mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
          mso.PolyToLines(pax, dim);
          Add(mso);//->MSG
          frm_MY(pa2, pax);
          mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
          mso.PolyToLines(pax, dim);
          Add(mso);//->MSG
        end;
        //гармошка + боковые линии:
        if gcx_forms.name='BridgeMYM' then begin
          frm_Pila(pa1,pa2, pax);
          mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
          mso.PolyToLines(pax, dim);
          Add(mso);//->MSG
          frm_MY(pa1, pax);
          mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
          mso.PolyToLines(pax, dim);
          Add(mso);//->MSG
          frm_MY(pa2, pax);
          mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
          mso.PolyToLines(pax, dim);
          Add(mso);//->MSG
        end;

      finally
        pab.free;
        pae.free;
      end;

      //Усы (изменение pa0,pa1,pa2!):
      frm_BridgeSide(pa1,gcx_forms.len,45);
      mso1.FLinesPath.Clear;
      mso1.PolyToLines(pa1, dim);
      frm_BridgeSide(pa2,gcx_forms.len,45);
      mso2.FLinesPath.Clear;
      mso2.PolyToLines(pa2, dim);
      pa0.clear;
      pa0.addfrom(pa1);
      pa0.addfrom(pa2);
      pa0.add(pa0.first);
      mso0.FLinesPath.Clear; mso0.PolyToLines(pa0, dim);

    end;//'Bridge'


  end; //cmdname='FORMS'

//----------------------------------------------------
  //Дороги:
  if (cmdname='ROAD') then begin

    gcx_r_load;

    //стороны:
    mso_l:=nil;
    mso_r:=nil;
    ind:=FindFirst(gcx_obj.child);
    while ind>=0 do begin
      mso:=Items[ind]; //ребёнок
      if gcx_obj.child.IndexOf(mso.scode)=0 then mso_l:=mso;//левая первая в списке детей
      if gcx_obj.child.IndexOf(mso.scode)=1 then mso_r:=mso;//правая вторая в списке детей
      ind:=FindNext(gcx_obj.child);
    end;

    //есть 2 стороны:
    if (mso_l<>nil) and (mso_r<>nil) then begin

      //Выходные коды (изменение прямо в текущей MSGroup):
      if length(gcx_r.out_area_scode)>0 then mso0.scode:=gcx_r.out_area_scode;
      if length(gcx_r.out_left_scode)>0 then mso_l.scode:=gcx_r.out_left_scode;
      if length(gcx_r.out_right_scode)>0 then mso_r.scode:=gcx_r.out_right_scode;

      //Поперечные линии и области:
      if (gcx_r.fname='HL') or (gcx_r.fname='HR') or (gcx_r.fname='HR2') then begin

        mso_l.PolyFromLines(pa_l1);
        mso_r.PolyFromLines(pa_l2);

        //Коррекция: две линии в ОДНОМ направлении:
        pa_l2.DirectLine(pa_l1,true);//сравнение друг с другом (причина - стена историч-ая)

        pab:=tpa.new;
        pae:=tpa.new;
        outlist:=tclasslist.new;
        try
          //поперечные линии:
          if (gcx_r.fname='HL') then begin
            roads_hl(pa_l1,pa_l2, 1, pab,pae, outlist);
            mso:=tmsobj.create(gcx_r.out_h_scode, mso0.lev);
            mso.TwoPolyToLines(pab, pae, dim, 0);//отрезки
            Add(mso);//->MSG
          end;
          //поперечные области:
          if (gcx_r.fname='HR') then begin
            roads_hl(pa_l1,pa_l2, 3, pab,pae, outlist);
            add_tpl_list(gcx_r.out_h_scode, mso0.lev, dim, outlist);//->MSG
          end;
          //поперечные прямоугольники:
          if (gcx_r.fname='HR2') then begin
            roads_hl(pa_l1,pa_l2, 2, pab,pae, outlist);
            add_tpl_list(gcx_r.out_h_scode, mso0.lev, dim, outlist);//->MSG
          end;
        finally
          pab.free;
          pae.free;
          outlist.free;
        end;//try

      end;//gcx_r.fname='HL'

      //Пунктиры:
      if gcx_r.dash_l.Count>0 then
        mso_l.transform_to_dash(dim, gcx_r.dash_l, 0);
      if gcx_r.dash_r.Count>0 then
        mso_r.transform_to_dash(dim, gcx_r.dash_r, 0);

    end;//есть 2 стороны.

  end; //cmdname='ROAD'

//----------------------------------------------------
  if (cmdname='LEP') then begin

    pa1.clear;//список столбов
    ind:=FindFirst(gcx_obj.child);
    while ind>0 do begin
      tobject(mso):=Items[ind];
      mso.PolyFromLines(pa_s); //child-столбы
      pa1.add(pa_s.first);
      ind:=FindNext(gcx_obj.child);
    end;

    pab:=tpa.new; pae:=tpa.new;
    try

      frm_LEP(pa0,pa1, pab,pae);

      //OutPut:
      mso:=tmsobj.create(gcx_obj.outcode[0], mso0.lev);
      mso.TwoPolyToLines(pab, pae, dim, 0);//стрелки
      Add(mso);//->MSG

    finally
      pab.free; pae.free;
    end;
  end;//cmdname='LEP'

//----------------------------------------------------
  //откос от ребенка к родителю:
  if (cmdname='HL') or (cmdname='SUN') or (cmdname='LHL') then begin

    H_ukrep:=mso0.Get_H_ukrep;
    hldp_init;

    if gcx_obj.outcode.count=0 then exit; //код штрихов должен быть
    if gcx_hl.hatch_code<0 then exit;

    gcx_hl_load;//параметры (=> можно отличить яму от бугра)

    if (cmdname='SUN') and (gcx_hl.parent_code>=0) then isyama:=true
    else isyama:=false;

    //A,L,S-childs:
    ind:=-1;
    j:=FindFirst(gcx_obj.child);
    while j>0 do begin
      tobject(mso):=Items[j];
      if (mso.sCode[1]='A') or (mso.sCode[1]='L') then begin ind:=j; break; end;
      if (mso.sCode[1]='S') and (cmdname='SUN') then begin
        mso.PolyFromLines(pa1);//pl.clear;
        if pa1.Count=1 then begin
          ind:=j;
          break;
        end;
      end;
      j:=FindNext(gcx_obj.child);
    end;
    pa1.Clear;

    if (ind<=0) then begin
      //нет A,L-детей:
      if not (cmdname='SUN') and not (cmdname='LHL') then exit;
    end;

    //=> при ind>0 определен объект mso - вершина или дно:

    //выделение S-детей:
    ChildList.Clear;
    if (ind>0) and (mso.sCode[1]<>'S') then MoveSignChildren(gcx_obj.child, ChildList);

    //Основной этап:
    pab:=tpa.new; pae:=tpa.new;
    pab2:=tpa.new; pae2:=tpa.new;

    try

      if (ind>0) then begin

        mso:=Items[ind];
        mso.PolyFromLines(pa1); //child

        if (cmdname='HL') then pa1.DirectLine(pa0,false);  //!!!

        childcode:=mso.scode;

      end else begin // => без ребёнка:

        if (cmdname='LHL') then begin //=> лин. обрывы, откосы
          //pa0: lbase; pa1: lclip (области нет вообще!!!) :
          childcode:='X00000000'; //???
          pa0.leftline(pa1, -gcx_hl.sh_size);
        end else if isyama then begin // => яма без ребёнка:
          childcode:='A00000000';
          pa0.leftline(pa1, gcx_hl.sh_size);
        end else begin // => бугор без ребёнка:
          childcode:='A00000000';
          pa1.AddFrom(pa0);//parent --> vertex
          pa0.clear; //parent clear
          pa1.leftline(pa0, -gcx_hl.sh_size); //new parent
        end;

      end;//if (ind>0)

      if cmdname='SUN' then begin

        Result:=sun_execute(pa1,pa0, pab,pae, childcode[1], ChildList);

      end else begin //cmdname='HL','LHL':

        do_short_beginning:=false;
        if cmdname='HL' then begin

          Result:=hl_execute(pa1,pa0, pab,pae, ChildList);

        end else begin//cmdname='LHL':

          Result:=hldp_connect(pa0,pa1, pab,pae, 0);
          hl_short(pab,pae, 0);

          if gcx_hl.twosides=1 then begin
            pa0.reverse;
            pa0.leftline(pa1, -gcx_hl.sh_size);
            Result:=hldp_connect(pa0,pa1, pab2,pae2, 0);
            hl_short(pab2,pae2, 0);
            pa0.reverse;
          end;

        end;

      end;//if cmdname='SUN'

      //Output:
      if pab.count>0 then begin
        //штрихи четные (0,2,...):
        mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch_code], mso0.lev);
        if H_ukrep=2 then mso.Write_H_ukrep(2);
        mso.TwoPolyToLines(pab, pae, dim, 2);//отрезки
        Add(mso);//->MSG
        //штрихи нечетные (1,3,...):
        if gcx_hl.hatch2_code>=0 then mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch2_code], mso0.lev)
        else mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch_code], mso0.lev);
        if H_ukrep<>0 then mso.Write_H_ukrep(1);
        mso.TwoPolyToLines(pab, pae, dim, 1);//отрезки
        Add(mso);//->MSG
      end;//pab.count>0

      //вторая сторона LHL:
      if pab2.count>0 then begin
        //штрихи четные:
        mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch_code], mso0.lev);
        if H_ukrep=2 then mso.Write_H_ukrep(2);
        mso.TwoPolyToLines(pab2, pae2, dim, 2);//отрезки
        Add(mso);//->MSG
        //штрихи нечетные:
        if gcx_hl.hatch2_code>=0 then mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch2_code], mso0.lev)
        else mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.hatch_code], mso0.lev);
        if H_ukrep<>0 then mso.Write_H_ukrep(1);
        mso.TwoPolyToLines(pab2, pae2, dim, 1);//отрезки
        Add(mso);//->MSG
      end;//pab2.count>0

      //родительская линия:
      if gcx_hl.parent_code>=0 then begin
          mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.parent_code], mso0.lev);
          mso.PolyToLines(pa0, dim);
          Add(mso);//->MSG
      end;

      //дочерняя линия:
      mso:=nil;
      if (childcode[1]='L') and (length(gcx_hl.child_code_l)>0)
          then mso:=tmsobj.create(gcx_hl.child_code_l, mso0.lev)
      else if (gcx_hl.child_code>=0)
          then mso:=tmsobj.create(gcx_obj.outcode[gcx_hl.child_code], mso0.lev);
      if mso<>nil then begin
          mso.PolyToLines(pa1, dim);
          Add(mso);//->MSG
      end;

    finally
      pab.free; pae.free;
      pab2.free; pae2.free;
    end;
  end;//'HL','SUN'
//----------------------------------------------------
  //деление линии:
  if (cmdname='DIV') then begin
    gcx_dl_load;//параметры

    //ChildList: сбор точек в pa2 (ind>=0):
    ChildList.Clear;
    pa2.clear;
    ind:=FindFirst(gcx_obj.child); //первый ребенок из списка кодов
    if ind<=0 then exit; //нужен ребенок
    txtreversed:=false;
    repeat
      TObject(mso):=ChildList.MoveFrom(Self, ind); //mso: Group->ChildList
      mso.PolyFromLines(pa1); //child; Clear;
      pa2.add(pa1.first); //точка привязки
      if mso.scode[1]='T' then begin
        mso.Txt:=TMsTxt.Create;
        mso.TxtFromLines;
        mso.Txt.reversed := v_scale( v_sub(pa1.first,pa1.last), v_sub(pa0.first,pa0.last) )<0 ;
        txtreversed := txtreversed or mso.Txt.reversed ; //хотя бы один!
      end;
      ind:=FindNext(gcx_obj.child);
    until ind<0;

    outlist:=dl_execute(pa0,pa2,gcx_dl.dlen/2,0.2*gcx_DmPerMm, true);
    Result:=true;

    //Output:
    try
      if outlist.count>0 then begin

        //возможен другой код вывода:
        if gcx_dl.parent_code>=0 then begin
          scode_b:=gcx_obj.outcode[gcx_dl.parent_code];
          scode_m:=scode_b;
          scode_e:=scode_b;
        end else begin
          if gcx_dl.b_code>=0 then scode_b:=gcx_obj.outcode[gcx_dl.b_code]
          else scode_b:=mso0.sCode;
          if gcx_dl.m_code>=0 then scode_m:=gcx_obj.outcode[gcx_dl.m_code]
          else scode_m:=mso0.sCode;
          if gcx_dl.e_code>=0 then scode_e:=gcx_obj.outcode[gcx_dl.e_code]
          else scode_e:=mso0.sCode;
        end;

        //смена кода родителя:
        if gcx_dl.parent_code_a>=0 then
          mso0.scode:=gcx_obj.outcode[gcx_dl.parent_code_a];

        for i:=0 to outlist.count-1 do begin
          if i=0 then scode:=scode_b
          else if i=outlist.count-1 then scode:=scode_e
          else scode:=scode_m;

          //отрезок #i:
          mso:=tmsobj.create(scode, mso0.lev);
          mso.PolyToLines(tpl(outlist[i]), dim);
          j0:=dline_inds0[i]; //индекс начала среди точек деления
          j1:=dline_inds1[i]; //индекс конца среди точек деления
          if txtreversed then j:=j1 else j:=j0;
          if (j>=0) then begin
            TObject(child):=ChildList[j];
            if (child<>nil) and (child.txt<>nil) then begin
              mso.TxtToLines(child.txt);
              if txtreversed then mso.AddLine('@tofse') else mso.AddLine('@tofs');
            end;
          end;

          Add(mso);//->MSG
        end;

        if gcx_dl.parent_code_a<0 then Delete(0);//после использования mso0!

      end;//outlist.count>0

      //возврат детей:
      if ChildList.Count>0 then for i:=0 to ChildList.Count-1 do begin
        MoveFrom(ChildList, i);
      end;

     finally
      outlist.free;
    end;

  end;//'DIV'
//----------------------------------------------------
  //кривизна:
  if (cmdname='KRI') then begin
    gcx_kri_load;//параметры
    Result:=true;

    //outlistx: будут куски:
    outlistx:=nil;//!

    //описаны дети => DIV
    if gcx_obj.child.count>0 then begin

      //сбор точек в pa2 (ind>=0):
      pa2.clear;
      ind:=FindFirst(gcx_obj.child); //первый ребенок из списка кодов
      while ind>=0 do begin
        mso:=Items[ind];
        mso.PolyFromLines(pa1); //child; Clear;
        pa2.add(pa1.first);
        ind:=FindNext(gcx_obj.child);
      end;

      //деление => dline_inds0,dline_inds1 :
      if pa2.count>0 then
        outlistx:=dl_execute(pa0,pa2,0,1*gcx_DmPerMm, true);

    end;//if gcx_obj.child.count>0

    //если деления не было:
    if outlistx=nil then outlistx:=tclasslist.create(4);
    if outlistx.count=0 then begin
      outlistx.add(pa0);/// ADD TO CLASSLIST!!!!!!!!!!!!!!!!
      dline_inds0.clear; dline_inds0.add(-1);
      dline_inds1.clear; dline_inds1.add(-1);
    end;

    //у области начало и конец - пол-штриха: -1 --> 0  :
    if pa0.closed then begin
      dline_inds0[0]:=0;
      dline_inds1[dline_inds1.count-1]:=0;
    end;

    //теперь outlistx.count>0:
    try
    if outlistx.count>0 then for i:=0 to outlistx.count-1 do begin

      tobject(paxtmp):=outlistx[i];
      outlist:=kri_dp_execute(paxtmp, gcx_kri.dlen/2, gcx_kri.zero,
        dline_inds0[i]>=0,dline_inds1[i]>=0);//kri_dp.pas
      Result:=true;

      //Output:
      try
      //возможен другой код вывода:
      if gcx_kri.parent_code>=0
        then scode:=gcx_obj.outcode[gcx_kri.parent_code]
        else scode:=mso0.sCode;

      if outlist.count>0 then begin
        for j:=0 to outlist.count-1 do add_tpl( scode, mso0.lev,dim, tpl(outlist[j]) )
      end else begin
        add_tpl( mso0.sCode, mso0.lev,dim, paxtmp);//короткий отрезок
      end;

      finally
        outlist.free;
      end;

    end;//for i

    finally
      if (outlistx.Count>0) and (outlistx[0]=pa0){это м.б.} then pa0:=nil;//!
      outlistx.free;//classlist!!!
    end;

    Delete(0);//после использования ms0!

  end;//'KRI'
//----------------------------------------------------
  //ступени:
  if (cmdname='STEPS') then begin
    gcx_st_load;//параметры
    n:=mso0.Get_H_int('H-nsteps');
    if n>0 then gcx_st.nsteps:=n;//приоритетнее gcx_st.dx

    pa1.clear;
    pa2.clear;

    //первый ребенок:
    ind:=FindFirst(gcx_obj.child);
    if ind>0 then begin
      mso:=Items[ind];
      mso.PolyFromLines(pa1);
      pa1.DirectLine(pa0,false);
    end else begin
      pa1[0]:=pa0[1];
      pa1[1]:=pa0[0];
    end;

    //второй ребенок (отсутствие: pa2.count=0):
    ind:=FindNext(gcx_obj.child);
    if ind>0 then begin
      mso:=Items[ind];
      mso.PolyFromLines(pa2);
      pa2.DirectLine(pa0,true);
    end;

    outlist:=st_execute(pa0,pa1,pa2,gcx_st.nsteps,gcx_st.dx,nil,false);//steps.pas
    Result:=true;

    //Output:
    try
      if outlist.count>0 then begin

        //возможен другой код вывода:
        if gcx_st.parent_code>=0
          then scode:=gcx_obj.outcode[gcx_st.parent_code]
          else scode:=mso0.sCode;

        for i:=0 to outlist.count-1 do begin
          mso:=tmsobj.create(scode, mso0.lev);
          mso.PolyToLines(tpl(outlist[i]), dim);
          Add(mso);//->MSG
        end;

      end;//Output
    finally
      outlist.free;
    end;

  end;//'STEPS'
//----------------------------------------------------
  //2 линии (стороны):
  if (cmdname='L2') then begin
    gcx_hl_load;//параметры
    gcx_l2_load;//параметры

    pa1.clear;
    pa2.clear;
    pa_s.clear;
    pa_l1.clear;
    pa_l2.clear;

    //первый ребенок:
    ind:=FindFirst(gcx_obj.child);
    if ind<=0 then exit; //нужен ребенок
    repeat
      mso:=Items[ind];
      if mso.sCode[1]='L' then begin
        //дети-линии: pa_l1,pa_l2:
        if pa_l1.count=0 then mso.PolyFromLines(pa_l1) //l-child; Clear;
        else if pa_l2.count=0 then mso.PolyFromLines(pa_l2); //l-child; Clear;
      end else if mso.sCode[1]='S' then begin
        //дети-точки: pa_s:
        mso.PolyFromLines(pa1); //child; Clear;
        pa_s.add(pa1.first);
      end;
      ind:=FindNext(gcx_obj.child);
    until ind<0;

    outlist:=l2_execute(pa0,pa_l1,pa_l2);
    //outlist:=l2_execute(pa0,pa_l1,pa_l2,pa_s);
    Result:=true;

    //Output:
    try
      if outlist.count>0 then begin

        //возможен другой код вывода:
        if gcx_l2.child_code>=0
          then scode:=gcx_obj.outcode[gcx_l2.child_code]
          else scode:=mso0.sCode;
        for i:=0 to outlist.count-1 do begin
          mso:=tmsobj.create(scode, mso0.lev);
          mso.PolyToLines(tpl(outlist[i]), dim);
          Add(mso);//->MSG
        end;

        //возможен другой код вывода области:
        if gcx_st.parent_code>=0
          then scode:=gcx_obj.outcode[gcx_st.parent_code]
          else scode:=mso0.sCode;
        add_tpl( scode, mso0.lev,dim, pa0);
        Delete(0);

      end;//Output
    finally
      outlist.free;
    end;

  end;//'L2'
//----------------------------------------------------
//----------------------------------------------------
  except
    Tellf('(!)ERROR rendering procedure "%s"\non object %s (%d)',[cmdname,mso0.scode,mso0.ofs]);
//    Raise;//except - in TMSFile.Execute
  end;
  finally
    if Assigned(pa0) then pa0.free;
    pa1.free;
    pa2.free;
    pa_l1.free;
    pa_l2.free;
    pa_s.free;
    pax.free;
  end;
end;//TMSGroup.ExecuteCmd


// TMsFile: --------------------------------------------

constructor TMSFile.Create(aInName, aOutName: string);
begin
  FInFile:=TFileX.Create(aInName, fmOpenRead, true); //m.b. exception
  FOutFile:=TFileX.Create(aOutName, fmCreate, true); //m.b. exception
  FLines:=TStringList.Create;
  _.MapBound:=tpl.new;
  _.PageBound:=tpl.new;
  _.DmPerMm:=100;//default
end;

destructor TMSFile.Destroy;
begin
  FInFile.Free;
  FOutFile.Free;
  FLines.Free;
  _.MapBound.Free;
  _.PageBound.Free;
end;

function TMSFile.Execute(width: single): boolean;
var
  i: tint;
  fline,s1: string;
  MSO: TMSObj;      //MainObject
  NextObj: TMSObj;  //Первый объект после группы, м.б. nil
  MSG: TMsGroup;    //MainObject & Childs
  parent_scode: string; parent_ofs: integer;
  do_cmd_ok: boolean;
begin
  Result:=true;

  while not FInFile.EOF do begin

    RunForm.Go(FInFile.Position/FInFile.Size);
    if RunForm.Cancelled then begin
      Result:=false; //=> "Ошибка ..."
      break; //from while
    end;

    fline:=FInFile.ReadLnS;
    if Length(fline)=0 then continue;

    s1:=fline; //s1 будет меняться
    case fline[1] of

      'B': //B
      if 'B'=sread_word(s1) then begin
        s1:=FInFile.ReadLnS; //sCode: "A00000000"
        MSO:=TMsObj.Create(s1,0);
        MSO.LoadFromFile(FInFile); //стоим после "E"

        //обработка группы:
        repeat

          NextObj:=nil;
          do_cmd_ok:=gcx_knowncode(MSO.sCode);
          if do_cmd_ok then begin
            MSO.LoadCharaFromHDict;//!!!
            do_cmd_ok:=MSO.do_cmd//HX 303 <> 1 & ...
          end;

          if do_cmd_ok then begin

            parent_scode:=MSO.sCode;
            parent_ofs:=MSO.ofs;;

            MSG:=TMsGroup.Create;
            try
            try
              MSG.LoadFromFile(FInFile,MSO,NextObj);

              //список команд для данного родительского кода:
              if gcx_obj_list.count>0 then for i:=0 to gcx_obj_list.count-1 do begin
                ox_begin(i);
                MSG.ExecuteCmd(_.Dim, _.DmPerMm);
                ox_end;
              end;

              MSG.SaveToFile(FOutFile);    //if <>nil
            except
              Tellf('Ошибка предобработчика на объекте\n%s (%d)',[parent_scode,parent_ofs]);
            end;
            finally
              MSG.Free;
            end;

          end else begin
            MSO.SaveToFile(FOutFile);
            MSO.Free;
          end;//do_cmd_ok

          MSO:=NextObj;

        until MSO=nil;

        continue; //in while!
      end;//B

      'm': //map
      if 'map'=sread_word(s1) then begin
        FOutFile.WriteLnS(fline);
        fline:=FInFile.ReadLnS; //x1 y1 x2 y2 - будет записана!
        s1:=fline; //!
        _.x1:=sread_int(s1);
        _.y1:=sread_int(s1);
        _.x2:=sread_int(s1);
        _.y2:=sread_int(s1);
        _.DmPerMm:=(_.x2-_.x1)/width; //!
        _.PageBound.Clear;
        _.PageBound.AddRect(_.x1,_.y1,_.x2,_.y2);
      end;

      'd': //dim
      if 'dim'=sread_word(s1) then begin
        _.Dim:=sread_int(s1);
      end;

    end;//case

    //default (не было "continue"):
    FOutFile.WriteLnS(fline);

  end;//while
end;

(*
function TMSFile.PointOnMapBound(p: tnum2; var a,b: tnum2): boolean;
var zero: tnum;
begin
  zero:=0.1*_.DmPerMm;
  Result := (_.MapBound.dist_p(p,a,b)<zero);
end;

function TMSFile.PointOnPageBound(p: tnum2; var a,b: tnum2): boolean;
var zero: tnum;
begin
  zero:=0.1*_.DmPerMm;
  Result := (_.PageBound.dist_p(p,a,b)<zero);
end;

function TMSFile.PointOnBound(p: tnum2; var a,b: tnum2): boolean;
begin
  Result := PointOnMapBound(p,a,b) or PointOnPageBound(p,a,b);
end;
*)

function TMSFile.PointOnBound(p: tnum2; var a,b: tnum2): boolean;
var zero: tnum;
begin
  zero:=0.1*_.DmPerMm;
  Result := (_.MapBound.dist_p(p,a,b)<zero) or (_.PageBound.dist_p(p,a,b)<zero);
end;

procedure TMSFile.PolyOnBound(pl: tpl; var a_first,b_first,a_last,b_last: tnum2; var first_ok,last_ok: boolean);
var zero: tnum; i: integer; middle_ok: boolean; a,b: tnum2;

  function _PointOnBound(p: tnum2; var a,b: tnum2): boolean;
  begin
    Result := (_.MapBound.dist_p(p,a,b)<zero) or (_.PageBound.dist_p(p,a,b)<zero);
  end;

begin
  zero:=0.1*_.DmPerMm;

  if pl.Count<=1 then begin
    first_ok := false;
    last_ok  := false;
    exit;
  end;

  //pl.Count>=2:
  first_ok := _PointOnBound(pl.First,a_first,b_first);
  last_ok  := _PointOnBound(pl.Last,a_Last,b_Last);

  //middle_ok должна быть false:
  middle_ok:=true;
  if first_ok or last_ok then begin
    //pl.Count=2 (=> средняя точка):
    if pl.Count=2 then begin
      middle_ok:=_PointOnBound( v_lt(pl.First, pl.Last, 0.5), a, b);
    end;

    //pl.Count>2:
    if pl.Count>2 then for i:=1 to pl.Count-2 do begin
      middle_ok:=_PointOnBound(pl[i], a, b);
      if not middle_ok then break;//!
    end;
  end;

  //короткий отрезок:
  if middle_ok then begin
    first_ok := false;
    last_ok  := false;
  end;
end;


initialization
  ChildList:=tclasslist.new;
finalization
  ChildList.free;


end.
