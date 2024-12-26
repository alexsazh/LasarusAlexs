(*
  ������� ��������� (����� �������)
*)
unit alwlib; interface

uses
  OTypes,
  nums, dmlib3d;


const alwl_dm_open_count: integer = 0;//>0 - ��������� ��������


//MISC (alw_misc.dll):

(*
Green - ���  - ���������!
Rlz - ������
Rgn: PLPoly; RgnCount: Integer; - �������
  (X,Y) - ��������� �� ���� ����� * 10          !!!
h1 - ����������� ���������� �������
dz - ����������
*)
function rlz_dz_green(Green,Rlz: PChar;
                      Rgn: PLPoly; RgnCount: Integer;
                      h1,dz: Float): Boolean; stdcall;


//����� (��������):

function  alwl_dm: string; overload;//���� � �������� �����
function  alwl_dm(_msg: boolean; var dmpath: string): boolean; overload;//"
function  alwl_dm_open(_edit: boolean; _msg: boolean = false): boolean;//������� �������� �����
function  alwl_dm_open_read: boolean;//_msg=true
function  alwl_dm_open_write: boolean;//_msg=true
procedure alwl_dm_close;

//������ ��������:

function  alwl_dm_offs(var offs: integer; _msg: boolean = false): boolean;
function  alwl_dm_id(var id{@1000}: integer; _msg: boolean = false): boolean;//alwl_dm_open!!!

//�������:

function  alwl_get_selection(offsa: tinta; _msg: boolean = false): integer;//return=count
procedure alwl_put_selection(offsa: tinta; _clear: boolean = false);

//������������� ���. ����� (Loc,Code ����� �������������):
//false => Loc,Code,Name �� ��������(!):
//����� �������(����� �������� �����������!):
function alwl_obj_name: string;//�� �������� (�� ����)
function alwl_obj_dir0: string;//���������� OBJ ��� "\" (USES "������� �����")
function alwl_obj_dirname: string;//���� .OBJ ��� ����������
function alwl_obj_path: string;//���� .OBJ
function alwl_obj_select(var Loc,Code: Integer; var Name: string): boolean; overload;
function alwl_obj_select(var Loc,Code: Integer): boolean; overload;

//����:
//mode:
//0 - ��� �����������, ���� ����� � ����;
//1 - ����� ���� � ��� �� ��������;
//2 - 3D (� ���������� ��������):
procedure alwl_show_DmId(aDmId{@1000}: integer; mode: integer);
procedure alwl_show_Offs(Offs: integer; mode: integer);
procedure alwl_show_OraId(OraID : Double);//type TSOMproc from viewer_dll.pas

//����� (.alx):

function  alwl_alx: string;
function  alwl_alx_Open(_msg: boolean): integer;//BlockCount
procedure alwl_alx_Close;

//������:

type
  TAlwList = class(TDmo3dList)//Items: tdmo3dClass - ������� tdmo3d
  private
  protected
  public
    procedure AddFromSelection(const aItemType: tdmo3dClass{�������}; _msg: boolean);//����� �������
  end;


implementation

uses
  SysUtils,
  dmw_use, dmw_wm,
  alw_dde, alw_use,
  wcmn, wait;


var alwl_tmp_chars: array[0..2048]of char;


//MISC (alw_misc.dll):


function rlz_dz_green(Green,Rlz: PChar;
                      Rgn: PLPoly; RgnCount: Integer;
                      h1,dz: Float): Boolean; stdcall;
external 'alw_misc.dll';


//����� (��������):

function alwl_dm: string;
begin
  Result:=StrPas( alw_Get_ActiveMap(@alwl_tmp_chars[0]) );
end;

function alwl_dm(_msg: boolean; var dmpath: string): boolean;
begin
  Result:=true;
  dmpath:=alwl_dm;
  if Length(dmpath)=0 then begin
    Result:=false;
    if _msg then Tell('��� �������� �����');
  end;
end;

function alwl_dm_open(_edit: boolean; _msg: boolean = false): boolean;
var dmpath: string;
begin
  Result:=alwl_dm(TRUE{_msg}, dmpath);
  if Result then begin
    alw_HideMap;//alw_BackMap - �����������!!!
    Result:=dml3_Open(dmpath, _edit);
  end;

    if Result then begin
      inc(alwl_dm_open_count);
      if alwl_dm_open_count>1
      then Tellf('WARNING in alwl_dm_open: alwl_dm_open_count=%d',[alwl_dm_open_count]);
    end;

  if _msg and not Result then Tell('���������� ������� �������� �����');
end;

function  alwl_dm_open_read: boolean;//_msg=true
begin
  Result := alwl_dm_open(false{_edit}, true{_msg});
end;

function  alwl_dm_open_write: boolean;//_msg=true
begin
  Result := alwl_dm_open(true{_edit}, true{_msg});
end;

procedure alwl_dm_close;
begin
  dml3_Close;
  //dec(alwl_dm_open_count);//!
  alwl_dm_open_count:=0;//!
end;


function  alwl_dm_offs(var offs: integer; _msg: boolean = false): boolean;
var Code,Loc,x1,y1,x2,y2: Integer;
begin
  offs:=0;
  alw_OffsObject(Offs,Code,Loc, x1,y1,x2,y2, @alwl_tmp_chars[0]);
  Result := offs>0;
  if _msg and not Result then Tell('�� ����� ��� ��������� �������');
end;

function  alwl_dm_id(var id{@1000}: integer; _msg: boolean = false): boolean;
var offs: integer;
begin
  Result:=alwl_dm_offs(offs, true{_msg});
  if not Result then EXIT;

  if alwl_dm_open(false{_edit}, true{_msg}) then try
    //if dm_goto_node(offs) then
    id:=dm_Id_Object(offs);
    Result := id>0;
  finally
    alwl_dm_close;
  end;
end;


function alwl_get_selection(offsa: tinta; _msg: boolean = false): integer;
var i: integer;
begin
  offsa.Clear;
  Result:=alw_sel_Count; if Result<0 then Result:=0;
  if Result>0 then for i:=0 to Result-1 do offsa[i]:=alw_sel_Object(i);
  if _msg and (Result<=0) then Tell('������� �����');
end;

procedure alwl_put_selection(offsa: tinta; _clear: boolean);
var i: integer; alwl_Common: TAlwCommon;//������ ��� �������� �������
begin
  alwl_Common:=TAlwCommon.Create;
  try
    alwl_Common.IsWait:=true;//!!!(����)
    alwl_Common.sel_lock;//stop redraw
    if _clear then alwl_Common.sel_clear;

    if offsa.Count>0 then for i:=0 to offsa.Count-1 do
      alwl_Common.sel_add(offsa[i]);

  finally
    alwl_Common.sel_unlock;//redraw
    alwl_Common.Free;
  end;
end;


function alwl_obj_name: string;
var sShort: ShortString;
begin
  Result:='';//default
  if alwl_dm_open(false{_edit}, true{_msg}) then try
    if (dm_goto_root>0)
    and dm_Get_String(903,254,sShort)
    then Result:=sShort;//������������� - WIN-���������!
  finally
    alwl_dm_close;
  end;
  Result := wcmn_file_name(Result);//�������� ���, ���� ���� � �������� ������ ����! (��� ������������!)
end;

function alwl_obj_dir0: string;//���������� OBJ ��� "\" (USES "������� �����")
begin
  //Result := 'd:\neva_work\obj';//DEBUG
  alw_EnvDir( @alwl_tmp_chars[0] );//������� �����
  Result := StrPas( @alwl_tmp_chars[0] ) + '\obj';
end;

function alwl_obj_dirname: string;//���� ��� ����������
var objname: string;
begin
  objname:=alwl_obj_name;//m.b.''
  if objname<>''
  then Result := alwl_obj_dir0 + '\' + objname
  else Result := '';//default
end;

function alwl_obj_path: string;//���� .OBJ
var objdirname: string;
begin
  objdirname:=alwl_obj_dirname;
  if objdirname<>''
  then Result := objdirname + '.obj'
  else Result := '';//default
end;


function alwl_obj_select(var Loc,Code: Integer; var Name: string): boolean;
var ObjName: string; xCode,xLoc: integer;
begin
  Result := false;//default
  xLoc:=0;
  xCode:=0;

  ObjName:=alwl_obj_name;//����� ����/����
  if ObjName<>'' then
    Result:=alw_Dial_Object(PChar(ObjName), Code,Loc, xCode,xLoc, @alwl_tmp_chars[0]);

  if Result and (xLoc>=0) and (xCode>0) then begin
    Loc:=xLoc;
    Code:=xCode;
    Name:=StrPas( @alwl_tmp_chars[0] );
  end else
    Result := false;//!
end;

function alwl_obj_select(var Loc,Code: Integer): boolean;
var Name: string;
begin
  Result := alwl_obj_select(Loc,Code, Name);
end;


//����:

procedure alwl_show_DmId(aDmId{@1000}: integer; mode: integer);
begin
  if aDmId<=0 then exit;//!
  case mode of
    0: alw_ShowObject(1,aDmId, 8,-1);//"8,-1" - �����������, ������ ���� ��� � ����
    1: alw_ShowObject(1,aDmId, 0,0);//"0,0" - ����� ���� � ��� �� ��������
    2: alw_ShowObject(1,aDmId, 8+128,-1);//"8,-1" + �������
  end;//case
  alw_SetFocus;//!
end;

procedure alwl_show_Offs(Offs: integer; mode: integer);
begin
  if offs<=0 then exit;//!
  case mode of
    0: alw_ShowObject(0,Offs, 8,-1);//"8,-1" - �����������, ������ ���� ��� � ����
    1: alw_ShowObject(0,Offs, 0,0);//"0,0" - ����� ���� � ��� �� ��������
    2: alw_ShowObject(0,Offs, 8+128,-1);//"8,-1" + �������
  end;//case
  alw_SetFocus;//!
end;

procedure alwl_show_OraId(OraID : Double);
var offs: longint;
begin
  offs:=0;//default

  if alwl_dm_open(false{_edit}, false{_msg}) then try
    offs:=dm_Find_Frst_Char(1002, _double, 0,OraID,nil);
  finally
    alwl_dm_close;
  end;

  if offs>0
  then alwl_show_Offs(offs, 2);
  //else Tell('������ �� ������ � �������� �����'); - �� ���� (����)
end;


//�����:

function  alwl_alx: string;
begin
  Result:=string( alw_Get_Points(@alwl_tmp_chars[0]) );
end;

function  alwl_alx_Open(_msg: boolean): integer;
var pc: pchar;
begin
  Result:=-1;
  pc:=alw_Get_Points(@alwl_tmp_chars[0]);
  if Length(pc)>0 then begin
    if alx_open(pc) then Result:=alx_Get_BlockCount;
  end;
  if _msg and (Result<0) then Tell('��� ����� �����');
end;

procedure alwl_alx_Close;
begin
  alx_close;
end;


//������:

{ TAlwList: }

procedure TAlwList.AddFromSelection(const aItemType: tdmo3dClass{�������}; _msg: boolean);
var offsa: tinta;
begin
  //wait_show('����� �� ������� ...');
  offsa:=tinta.New;
  try
    if (alwl_get_selection(offsa, _msg)>0)
    and alwl_dm_open(false{_edit}, true{_msg}) then try
      AddFromOffsArray(aItemType, offsa);//NEW
    finally
      alwl_dm_close;
    end;
  finally
    offsa.Free;
    //wait_hide;
  end;
end;


end.
