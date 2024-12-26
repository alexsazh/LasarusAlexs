{
  TScene: сцена 2D + 3D(if used)
}
unit scnlib; interface

uses
  Forms, Classes, comctrls{TTreeView}, stdctrls{TListBox},
  nums, vlib, dmmovlib, morf, camera;


type
  TScene = class(TMovPic)
  private
    FCameras: TCameras;
  public
    //Modified0: boolean;
    LoadProcess: boolean;
    //если в конструкторе nil, то aCamerasList не используется:
    constructor Create(aDmCameraCode: longint);
    destructor Destroy; override;
    procedure Clear;
    procedure SortByStrings(Strings: TStrings);
    procedure Camera_PlaceByVector(p1,p2: tnum2; h: tnum);
    procedure OnTimer(aTime: TDateTime; _objects, _camera: boolean);
    function AddMorfFromOfs(ofs0: integer): TMorf;

    function SaveToFile(aFileName: string): boolean;
    function LoadFromFile(aScnFileName, aDmFileName: string): boolean;

    property Cameras: TCameras read FCameras;
  end;

var
  Scene: TScene;//!!!


implementation

uses
  Sysutils,
  dmw_dde, dmw_use, Otypes,
  wcmn, list, llibx, dmwlib, dmlibx, dmpiclib, scnfile,
  obj;


constructor TScene.Create(aDmCameraCode: longint);
begin
  inherited Create(TmpDir+'tmp_move.dm', aDmCameraCode);
  FCameras:=TCameras.Create(Self);//=>count=1(!)
end;

destructor TScene.Destroy;
begin
  ObjFree(tobject(FCameras));
  inherited Destroy;
end;

procedure TScene.Clear;
begin
  inherited Clear;
  FCameras.Clear;//=>SetCurrent(Items[0]);
end;

procedure TScene.SortByStrings(Strings: TStrings);
begin
  FList.SortByStrings(Strings);
end;

procedure TScene.Camera_PlaceByVector(p1,p2: tnum2; h: tnum);
var z1,z2, d, firight,fidown: tnum;
begin
  if not F3dOk  then exit;

  z1 := F3d.GetZ(p1.x, p1.y) + h;
  z2 := F3d.GetZ(p2.x, p2.y);
  firight := v_fi( v_sub(p2, p1) );
  d:=v_dist(p2, p1);
  fidown:=v_fi( v_xy(d, z1-z2) );
  F3d.CameraPlaceAndRotate(p1.x, p1.y, z1, firight, -fidown);
end;

procedure TScene.OnTimer(aTime: TDateTime; _objects, _camera: boolean);
var do_dm: boolean;
begin
  try
    if F3DOk then F3D.FrameLock;//начало всех 3D-построений
    try
      do_dm := _objects or (_camera and F3DOk);

      if do_dm then begin
        if MoveDm_Open then try

          if _objects then inherited OnTimer(aTime);
          FCameras.Current.Place;//после установки объектов (для связанной камеры)

          if _camera then DmCamera_Draw;//слежение за 3D-камерой

        finally
          MoveDm_Close;
        end;
      end;//do_dm

    finally
      if F3DOk then F3D.FrameUnLock;//конец всех 3D-построений
//      Application.ProcessMessages;//OnTimer - это тоже Message(!)
    end;
  except
  end;
end;


function TScene.AddMorfFromOfs(ofs0: integer): TMorf;

  procedure _get_children(signs: tclasslist);
  var xdmo: tdmox;
  begin
    signs.Clear;
    if dm_goto_down then try
      repeat
        xdmo:=tdmox.CreateFromDm2(true, true);
        if xdmo.Loc=1 then signs.Add(xdmo)
        else xdmo.Free;
      until not dm_goto_right;
    finally
      dm_goto_upper;
    end;
  end;

var
  i, n, trcind: integer;
  trace, dmo1, dmo2, sign1, sign2: tdmox;
  morf: tmorf; signs1, signs2: tclasslist;{of tdmo}
begin
  Result:=nil;
  if DMW.OpenDMA then try try
    if not dm_goto_node(ofs0) then abort;

    //trace: линия морфинга:
    trace:=tdmox.CreateFromDm2(true,true);//gauss
    if (trace.Loc<>2) and (trace.Loc<>3) then begin
      Tell('Указанный объект не является линией');
      trace.Free;
      abort;
    end;
    trcind:=Scene.AddTrace(trace);

    signs1:=tclasslist.New;
    signs2:=tclasslist.New;
    try
      //dmo1,dmo2: начальное и конечное положения (с дочерними значками):
      dmo1:=nil;
      dmo2:=nil;
      if dm_goto_down then begin
        dmo1:=tdmox.CreateFromDm2(true,true);//1-ая линия
        _get_children(signs1);
        if dm_goto_right then begin
          dmo2:=tdmox.CreateFromDm2(true,true);//2-ая линия
          _get_children(signs2);
        end;//if dm_goto_right
      end;//if dm_goto_down
      if (dmo1=nil) or (dmo2=nil) then begin
        Tell('Нет 2-х дочерних линий');
        abort;
      end;

      //morf:
      if ( (dmo1.loc=2) or (dmo1.loc=3) ) and ( (dmo2.loc=2) or (dmo2.loc=3) ) then begin
        morf:=tmorf.Create(Scene, dmo1, trcind, dmo2);
        //morf.Visible:=true;

        n:=mini(signs1.Count, signs2.Count);
        if n>0 then for i:=0 to n-1 do begin
          tobject(sign1):=signs1.Disconnect(i);//!
          tobject(sign2):=signs2.Disconnect(i);//!
          morf.AddSign(sign1, sign2);
        end;

        if Scene.AddItem(morf) then Result:=morf else morf.Free;
      end;//if loc=2||3
    finally
      signs2.Free;
      signs1.Free;
    end;

  finally
    DMW.CloseDMA;
  end;
  except
  end;
end;


//---------------------------------------------------------

function TScene.SaveToFile(aFileName: string): boolean;
var f: TextFile; i: integer; mo: tmovobj; cam: TCamera;
begin
  Result:=false;
  if ftopen(f, aFileName, 'w') then try
    SetWaitCursor;

    //scnfile_read_version:
    writeln(f, 'version 2');//1: глоб.время, 2: новые маркеры

    //запись объектов:
    if FList.Count>0 then for i:=0 to FList.Count-1 do begin
      if not (FList[i] is tmovobj) then continue;
      tobject(mo):=FList[i];
      scnfile_save_movobj(f, mo, FList[i] is TMorf);
    end;//for i

    //запись камер (кроме первой):
    if FCameras.Count>1 then for i:=1 to FCameras.Count-1 do begin
      tobject(cam):=FCameras[i];
      scnfile_save_camera(f, cam);
    end;//for i

    Result:=true;
  finally
    SetDefCursor;
    ftclose(f);
    if not Result then Tell('Ошибка записи');
  end;
end;

function TScene.LoadFromFile(aScnFileName, aDmFileName: string): boolean;
var f: TextFile; fline,sw: string;
begin
  Result:=false;
  scnfile_read_version:=0;//default
  Clear;

  try
  if ftopen(f, aScnFileName, 'r') then try
    LoadProcess:=true;
    SetWaitCursor;

    //FPlayDmPath: пустая копия dmfname:
    if FileExists(aDmFileName) then Scene.Create_2D(aDmFileName)
    else abort;//!

    if dmw_open( PChar(aDmFileName), false)>0 then try
      while not eof(f) do begin
        readln(f, fline);
        sw:=sread_word(fline);

        if sw='version' then scnfile_read_version:=sread_int(fline);

        if sw='#' then begin
          sw:=sread_word(fline);
          if sw='movobj' then scnfile_load_movobj(f, Self);
          if sw='camera' then scnfile_load_camera(f, FCameras);
        end;
      end;//while not eof(f)

      Result:=true;
    finally
      dmw_done;
    end else begin
      Tell('Ошибка открытия карты.');
    end;

  finally
    LoadProcess:=false;
    SetDefCursor;
    ftclose(f);
    if not Result then Tell('Ошибка чтения');
  end;
  except
  end;
end;


end.
