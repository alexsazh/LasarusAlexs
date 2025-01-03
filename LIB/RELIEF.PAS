(*
  ������ ����� .REL
  �������� ����� .REL �� ����� ���-��
  ��. "clutter.pas" ��� ������� ��������
*)
unit relief; interface

uses
  vlib;

type
  TRelHeader = record
    mark: array[1..4] of char;
    data,gray,res1: longint;
    nx,nz,ny,fn: longint;//nx,ny - ���-�� �������� � ����� � �������
    len,fmt,res2,res3: byte;
    xmin,zmin,ymin,
    xstep,zstep,ystep,
    xmax,zmax,ymax: double;
  end;

  //����� ������:
  tRel_Loc = record
    case integer of
    0: (d: double);
    1: (f: single);
    2: (l: longint);
    3: (i: SmallInt);
    4: (b: byte);
    5: (rel,cod,loc: word);
  end;

type
  TReliefBound = array[0..3]of tnum2;//4 ������� ����� (�����): UL,UR,DR,DL

  TRelief = class(TObject)
  private
    FGXY: TReliefBound;//4 ������� ����� (�����): UL,UR,DR,DL
    FMemSize: longint;//FMemSize>0 <=> Opened
    FMemory: PChar;//������ ����� (��������� �� ���.����.)
    FRelHeader: TRelHeader;
    FSize: tnum2;//����� (�����: FSize.x �� ���������!)
    FFileName: string;
  public
    destructor Destroy; override;
    function Open(aFileName: string): boolean; //''=>ActiveMapName
    procedure GetWidthHeight(var w,h: integer);//nx,ny - ���-�� �������� � ����� � �������
    procedure Close;//mfree, Fmemsize:=0
    function Ok: boolean;//FMemSize>0
    function Value(ix,iy: integer): double;//ix-������, iy-���� (m.b.Exception with Message)
    function ValueOnPoint(gp: tnum2): double;//gp - ����� (m.b.Exception with Message)
    procedure TellInfo;

    property Size: tnum2 read FSize;
    property LU: tnum2 read FGXY[0];//���.����. ����� - ������ �������
    property GXY: TReliefBound read FGXY;
  end;


{ Functions: }

function relief_tmp_rel_path: string;//TmpDir+'tmp_rel.rel'

//DmFileName->EmptyDmFileName(��� ��������, ��� ��������������(!)), ����� �������:
function relief_make_empty_dm(DmFileName, EmptyDmFileName: string): boolean;

//step - �����, nchara - ����� ���-��:
//�� ��������� dm-����� relief_tmp_dm_path � ���������� ���������:
function relief_make_file(DmFileName, RelFileName: string; step: single; nchara: integer): boolean;
//����� ����.���� ������� relief_tmp_rel_path:
function relief_make_and_load(DmFileName: string; step: single; nchara: integer; rel: TRelief): boolean;

//�� �� ��� ��������� ����� GLT,GRB(TopLeft, RightBottom):
function relief_make_file2(DmFileName, RelFileName: string; GLT,GRB: tnum2; step: single; nchara: integer): boolean;
function relief_make_and_load2(DmFileName: string; GLT,GRB: tnum2; step: single; nchara: integer; rel: TRelief): boolean;

implementation

uses
  Classes, SysUtils,
  otypes, dmw_use, dmw_ddw, dm_util,
  wcmn, dmwlib, dmlib;


{ Functions: }

//PRIVATE:
function relief_tmp_dm_path: string;//TmpDir+'tmp_rel.dm'
begin
  Result:=TmpDir+'tmp_rel.dm';
end;

function relief_tmp_rel_path: string;//TmpDir+'tmp_rel.rel'
begin
  Result:=TmpDir+'tmp_rel.rel';
end;

//DmFileName->EmptyDmFileName(��� ��������), ����� �������:
function relief_make_empty_dm(DmFileName, EmptyDmFileName: string): boolean;
begin
  Result:=false;
  if FileExists(EmptyDmFileName) and not DeleteFile(EmptyDmFileName) then begin
    Tellf('relief_make_empty_dm: ���� "%s" �� ����� ���� ������',[EmptyDmFileName]);
    exit;//!
  end;
  if dmw_HideMap then try
    Result:=dm_copy(PChar(DmFileName), PChar(EmptyDmFileName), '');//����� ��� ��������������
  finally
    dmw_BackMap;
  end;
end;

function relief_make_file(DmFileName, RelFileName: string; step: single; nchara: integer): boolean;
var a,b: lpoint; istep{��},ires: Integer;
begin
  Result:=false;

  if not dmw_HideMap then exit;
  try
    ires:=wcmn_filecopy([DmFileName], relief_tmp_dm_path);
  finally
    dmw_BackMap;
  end;
  if ires<>1 then exit;

  if not dmlib_Open(PChar(relief_tmp_dm_path), true) then exit;
  try
    dm_goto_root;
    dm_Get_Bound(a,b);
    dm_put_long(1004, nchara);
    dm_Del_hf(903, _string);//obj-name
  finally
    dm_done;
  end;

  if FileExists(RelFileName) and not DeleteFile(RelFileName) then begin
    Tellf('relief_make_file: ���� "%s" ���������� �������.',[RelFileName]);
    exit;
  end;

  istep:=Round(step*10);//��
  try
    dm_Relief( PChar(relief_tmp_dm_path), nil, PChar(RelFileName), a.x,a.y,b.x,b.y, istep, false);
    Result := FileExists(RelFileName);
  except
    Tellf('������ ��� ���������� ����� "%s"',[RelFileName]);
  end;
end;

function relief_make_file2(DmFileName, RelFileName: string; GLT,GRB: tnum2; step: single; nchara: integer): boolean;
var a,b: lpoint; istep{��},ires: Integer;
begin
  Result:=false;

  if not dmw_HideMap then exit;
  try
    ires:=wcmn_filecopy([DmFileName], relief_tmp_dm_path);
  finally
    dmw_BackMap;
  end;
  if ires<>1 then exit;

  if not dmlib_Open(PChar(relief_tmp_dm_path), true) then exit;
  try
    dm_goto_root;
    //dm_Get_Bound(a,b);
    dm_put_long(1004, nchara);
    dm_Del_hf(903, _string);//obj-name
    dm_G_to_L(GLT.x,GLT.y, a.x,a.y);
    dm_G_to_L(GRB.x,GRB.y, b.x,b.y);
  finally
    dm_done;
  end;

  if FileExists(RelFileName) and not DeleteFile(RelFileName) then begin
    Tellf('relief_make_file2: ���� "%s" ���������� �������.',[RelFileName]);
    exit;
  end;

  istep:=Round(step*10);//��
  try
    dm_Relief( PChar(relief_tmp_dm_path), nil, PChar(RelFileName), a.x,a.y,b.x,b.y, istep, false);
    Result := FileExists(RelFileName);
  except
    Tellf('������ ��� ���������� ����� "%s"',[RelFileName]);
  end;
end;


//-------------------------------------------

//����� ����.���� ������� relief_tmp_rel_path:
function relief_make_and_load(DmFileName: string; step: single; nchara: integer; rel: TRelief): boolean;
begin
  Result:=false;
  if not relief_make_file(DmFileName, relief_tmp_rel_path, step, nchara) then exit;//�� �������� .REL
  Result:=rel.Open(relief_tmp_rel_path);
end;

function relief_make_and_load2(DmFileName: string; GLT,GRB: tnum2; step: single; nchara: integer; rel: TRelief): boolean;
begin
  Result:=false;
  if not relief_make_file2(DmFileName, relief_tmp_rel_path, GLT,GRB, step, nchara) then exit;//�� �������� .REL
  Result:=rel.Open(relief_tmp_rel_path);
end;


{ TRelief: }

destructor TRelief.Destroy;
begin
  Close;//!
  inherited Destroy;
end;

function TRelief.Open(aFileName: string): boolean;
var
  xyname: string;
  st_rel,st_xy: TFileStream;
  i: integer; gx,gy: double;
begin
  Result:=false;
  Close;//!

  //FileName.REL, FileName.XY - �������� �������������:
  FFileName:=aFileName;
  if not FileExists(FFileName) then begin
    Tellf('TRelief.Open: ��� ����� "%s"',[FFileName]);
    exit;
  end;
  xyname:=ChangeFileExt(FFileName, '.XY');
  if not FileExists(xyname) then begin
    Tellf('TRelief.Open: ��� ����� "%s"',[xyname]);
    exit;
  end;

  //������� �����, ������:
  try
    st_xy:=TFileStream.Create(xyname, fmOpenRead);
  except
    Tellf('TRelief.Open: ������ �������� ����� "%s"',[xyname]);
    exit;
  end;
  try
    for i:=0 to 3 do begin
      st_xy.Read(gx, sizeof(double));
      st_xy.Read(gy, sizeof(double));
      FGXY[i].x:=gx;
      FGXY[i].y:=gy;
    end;
  finally
    st_xy.Free;
  end;
  FSize.x:=abs(FGXY[2].x-FGXY[0].x);
  FSize.y:=abs(FGXY[2].y-FGXY[0].y);
  if (FSize.x<0.01) or (FSize.y<0.01) then begin
    Tellf('TRelief.Open(%s): ������� ��������� ���',[FFileName]);
    exit;
  end;

  //������� �����:
  try
    st_rel:=TFileStream.Create(FFileName, fmOpenRead);
  except ;
    Tellf('TRelief.Open: ������ �������� ����� "%s"',[FFileName]);
    exit;
  end;
  try
    st_rel.Read(FRelHeader, sizeof(TRelHeader));
    st_rel.Seek(FRelHeader.data, soFromBeginning);
    Fmemsize:=st_rel.Size-FRelHeader.data;
    Fmemory:=malloc(Fmemsize);
    st_rel.Read(Fmemory^, Fmemsize);
  finally
    st_rel.Free;
  end;

  Result:=true;
end;

procedure TRelief.GetWidthHeight(var w,h: integer);//nx,ny - ���-�� �������� � ����� � �������
begin
  w:=0; h:=0; //default
  if Ok then begin
    w:=FRelHeader.nx;
    h:=FRelHeader.ny;
  end;
end;

procedure TRelief.Close;
begin
  if Fmemsize>0 then try mfree(Fmemory, Fmemsize);
  except
  end;
  Fmemsize:=0;
end;

function TRelief.Ok: boolean;//FMemSize>0
begin
  Result := Fmemsize>0;
end;

function TRelief.Value(ix,iy: integer): double;//ix-������, iy-����
var ind: longint; p: PChar; loc: tRel_Loc;
begin
  Result:=0;//default
  if not Ok then exit;

  try
    if ix>=FRelHeader.nx then ix:=FRelHeader.nx-1;
    if ix<0 then ix:=0;
    if iy>=FRelHeader.ny then iy:=FRelHeader.ny-1;
    if iy<0 then iy:=0;
    ind:=iy*FRelHeader.nx+ix;//max i=ny*nx-1
    p:=FMemory+ind*FRelHeader.nz*FRelHeader.len;//������: nz=1, len=4(single), fmt=5(single)
    memcpy(@loc, p, sizeof(loc));

    //Result:
    case FRelHeader.fmt of
    1:  Result:=loc.b;
    2:  Result:=loc.i;
    4:  Result:=loc.l;
    5:  Result:=loc.f;
    8:  Result:=loc.d;
    else
      Tellf('TRelief.ValueOnInds: ����������� ������ ������ (%d) � ����� "%s"',[FRelHeader.fmt, FFileName]);
      Close;//=>��� ����������� (not Ok)
    end;{case}
  except
    Tellf('TRelief.ValueOnInds: ������ ��������� ������ �� ������� ����� "%s"',[FFileName]);
    Abort;//"false"
  end;
end;

function TRelief.ValueOnPoint(gp: tnum2): double;//gp - �����
var ix,iy: longint; dx,dy: double;//�, x ������, y ���� ("�������� �������")
begin
  Result:=0;//default
  if not Ok then exit;

  //��������� � "�������� �������" ������������ ���.����. ����� FGXY[0]:
  dy:=FGXY[0].x-gp.x;
  dx:=gp.y-FGXY[0].y;

  try
    //������ � �������:
    ix := Round( (dx/Size.y)*FRelHeader.nx );
    iy := Round( (dy/Size.x)*FRelHeader.ny );
    Result:=Value(ix,iy);
  except
    Abort;//"false", ��������� - � "ValueOnInds"
  end;
end;

procedure TRelief.TellInfo;
begin
  with FRelHeader do
    Tellf('%s\nnx=%d; ny=%d; nz=%d; fmt=%d (len=%d);\n(%.0f, %.0f) - (%.0f, %.0f)',
      [FFileName, nx,    ny,    nz,     fmt,    len,  FGXY[3].x,FGXY[3].y,FGXY[1].x,FGXY[1].y]);
end;


end.
