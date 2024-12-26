unit _webmap; interface

uses Windows, Types, vlib, llibx;


/////////////////////////////////////////////////////////
// �� ����� path1 ������ ����� path2
// ������ �������� �� �������� �������.
// ������ ������� ����� path2
/////////////////////////////////////////////////////////
function _webmap_MC0_scale_region(const path1,path2: string; const scale1: integer; region: tpl): boolean;

function _webmap_bound(path: string; var scale: integer; var mpunit{m/unit}: double;
                var a,b: TPoint; var page{w,h ��}: tnum2): boolean;


implementation

uses wcmn, OTypes, dm_util{dm_sys_dm}, dmw_ddw, dmw_use, dmlib;


function _webmap_MC0_scale_region(const path1,path2: string; const scale1: integer; region: tpl): boolean;
var
  n,scale2: integer; sys: tsys; key,lp1,lp2: TPoint;
  bla: array[1..4]of tnum2;
begin
  //�������� �������� path1, �������������� �������:
  Result := dmlib_Open(PChar(path1), false{_edit});
  if Result then try
    Result := dm_Scale=scale1;

    //������� ����� (�� LT �� ���.���.):
    if Result then begin
      dm_goto_root;//!
      dm_get_bound(lp1,lp2);
      dm_L_to_R(lp1.X,lp1.Y{xmin,ymin}, bla[1].x,bla[1].y);
      dm_L_to_R(lp2.X,lp1.Y{xmax,ymin}, bla[2].x,bla[2].y);
      dm_L_to_R(lp2.X,lp2.Y{xmin,ymax}, bla[3].x,bla[3].y);
      dm_L_to_R(lp1.X,lp2.Y{xmax,ymax}, bla[4].x,bla[4].y);

      n:=0;
      if region.PointIn(bla[1]) then inc(n);
      if region.PointIn(bla[2]) then inc(n);
      if region.PointIn(bla[3]) then inc(n);
      if region.PointIn(bla[4]) then inc(n);

      Result := n>0;
    end;
  finally
    dm_done;//!
  end;

  //��������� �������� (path1->path2):
  if Result then begin
    sys := sys7(1,3,9, 0,0,0);//OTypes: 1 - ������ �����, 3 - ���� ������, 9 - wgs84, 0 - ��� ������
    key := Point(0,0);
    Result := dm_sys_dm(PChar(path1), PChar(path2), sys, key);
  end;

  //��������� �������� path2:
  Result := Result and dmlib_Open(PChar(path2), TRUE{_edit});
  if Result then try
    dm_goto_root;

    scale2 := Round(1.72*scale1);//////////////////////////// 1.72 ??????????

    dm_Put_long(904,scale2);
  finally
    dm_done;//!
  end;
end;


function _webmap_bound(path: string; var scale: integer; var mpunit{m/unit}: double;
                var a,b: TPoint; var page{w,h ��}: tnum2): boolean;
var lw,lh: integer; mw,mh: double;
begin
  Result:=FALSE;
  dmw_HideMap;//�� ������ ������!

  if dmlib_open(PChar(path), false{edit}) then try
    dm_goto_root;
    dm_get_bound(a,b);
    lw:=abs(b.x-a.x); lh:=abs(b.y-a.y);//��. �����

    mpunit:=dm_Resolution;
    mw:=lw*mpunit; mh:=lh*mpunit;//�����

    scale:=dm_Scale;
    page.x:=mw*1000/scale; page.y:=mh*1000/scale;//��

    Result:=TRUE;
  finally
    dm_done;
  end;
end;


end.
