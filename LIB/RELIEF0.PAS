unit relief; interface

uses
  otypes;


type
  TRelHeader = record
    mark: char4;
    data,gray,res1: longint;
    nx,nz,ny,fn: longint;
    len,fmt,res2,res3: byte;
    xmin,zmin,ymin,
    xstep,zstep,ystep,
    xmax,zmax,ymax: double;
  end;

  //слово данных:
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
  TRelief = class(TObject)
  private
    PXY: array[0..3]of lPoint;
    memsize: longint;
    memory: PChar;
  public
    FileName: string;
    Hdr: TRelHeader;
    Size: lPoint;
    destructor Destroy; override;
    function Open(aFileName: string): boolean; //''=>ActiveMapName
    procedure Close;
    function Height(pnt: lPoint): double;

    procedure PrintTest;
  end;

{Functions:}

procedure dmcmn_pick_h;


implementation

uses
  Classes, SysUtils,
  wcmn, dmcmn, dmw_use, dmw_dde;


{Functions:}

procedure dmcmn_pick_h;
var rel: TRelief; gx,gy,h: double; P: lPoint;
begin
  rel:=TRelief.Create;
  try
    if rel.Open('') then begin
      if dmw_PickPoint(P.x,P.y, gx,gy) then begin
        h:=rel.Height(P);
        Tellf('Высота рельефа в точке:\nG: (%.0f, %.0f)\nDM: (%d, %d)\nH=%.2f',[gx,gy,P.x,P.y,h]);
      end;
      rel.Close;
    end;
  finally
    rel.Free;
  end;
end;


{ TRel: }

destructor TRelief.Destroy;
begin
  Close;
end;

function TRelief.Open(aFileName: string): boolean;
var
  mapname,xyname: string;
  st_rel,st_xy: TFileStream;
  i: integer; gx,gy: double;
begin
  Result:=false;
  Close;

  FileName:=aFileName;

  if Length(FileName)=0 then begin
    mapname:=dmcmn_active_map(true);
    if Length(mapname)=0 then exit;
    FileName:=ChangeFileExt(mapname, '.REL');
  end;

  if not FileExists(FileName) then begin
    Tellf('Нет файла рельефа "%s"',[FileName]);
    exit;
  end;

  xyname:=ChangeFileExt(FileName, '.XY');
  if not FileExists(xyname) then begin
    Tellf('Нет файла рельефа "%s"',[xyname]);
    exit;
  end;

  try
    st_xy:=TFileStream.Create(xyname, fmOpenRead);
  except
    exit;
  end;

  if not dmcmn_begin then exit; //for dm_G_to_L
  try
    for i:=0 to 3 do begin
      st_xy.Read(gx, sizeof(double));
      st_xy.Read(gy, sizeof(double));
      dm_G_to_L(gx,gy,PXY[i].x,PXY[i].y);
    end;
  finally
    st_xy.Free;
    dmcmn_end;
  end;

  Size.x:=PXY[2].x-PXY[0].x;
  Size.y:=PXY[2].y-PXY[0].y;
  if (Size.x<=0) or (Size.y<=0) then begin
    Tell('Нулевые размеры растра. Стоп.');
    exit;
  end;

  try
    st_rel:=TFileStream.Create(FileName, fmOpenRead);
  except ;
    exit;
  end;

  try
    st_rel.Read(Hdr, sizeof(TRelHeader));
    st_rel.Seek(Hdr.data, soFromBeginning);
    memsize:=st_rel.Size-Hdr.data;
    memory:=malloc(memsize);
    st_rel.Read(memory^, memsize);
  finally
    st_rel.Free;
  end;

  Result:=true;
end;

procedure TRelief.Close;
begin
  if memsize>0 then mfree(memory, memsize);
  memsize:=0;
end;

function TRelief.Height(pnt: lPoint): double;
var
  ix,iy,dx,dy,i: longint; p: PChar;
  loc: tRel_Loc;
begin
  Result:=0;
  if memsize=0 then exit;

  //относительное положение:
  dx:=abs(pnt.x-PXY[0].x);
  dy:=abs(pnt.y-PXY[0].y);

  try
    //строка и столбец:
    iy := Round( (dy/Size.y)*Hdr.ny );
    ix := Round( (dx/Size.x)*Hdr.nx );
    if iy>=Hdr.ny then iy:=Hdr.ny-1;
    if ix>=Hdr.nx then ix:=Hdr.nx-1;

    //слово данных:
    i:=iy*Hdr.nx+ix;
    p:=memory+i*Hdr.nz*Hdr.len;
    memcpy(@loc, p, sizeof(loc));
  except
    Tell('Ошибка получения высоты из рельефа');
    exit;
  end;

  case Hdr.fmt of
    1:  loc.d:=loc.b;
    2:  loc.d:=loc.i;
    4:  loc.d:=loc.l;
    5:  loc.d:=loc.f;
    8:  loc.d:=loc.d;
    else begin
      Tellf('Неизвестный формат данных:\nHdr.fmt=%d',[Hdr.fmt]);
      loc.d:=0;
    end;
  end;{case}

  Result:=loc.d;
end;


procedure TRelief.PrintTest;
var gx,gy,h: double; P: lPoint;
begin
  if not dmw_PickPoint(P.x,P.y, gx,gy) then exit;
  h:=Height(P);

  with Hdr do
    Tellf('data=%d; len=%d; nx=%d; ny=%d; nz=%d; fmt=%d;\n(%d, %d) - (%d, %d)\nP=(%d, %d), H=%f',
      [data,len,nx,ny,nz,fmt, PXY[0].x,PXY[0].y,PXY[2].x,PXY[2].y, P.x,P.y,h]);
end;


end.
