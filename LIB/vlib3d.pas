unit vlib3d; interface

uses vlib;


type
  //3D-point (�����, �����):
  tnum3 = record
    p: tnum2;
    z: double;
  end;
  pnum3 = ^tnum3;

const v3_num3_000: tnum3 = (p:(x:0; y:0); z:0);
//var num3_000: tnum3 = (p:(x:0; y:0); z:0);//�.�. ����,�����-�� � ��� ���������������� ����?

(*
type
  //���������:
  tplane0 = tnum3;//a,b,c
  tplane  = record a,b,c,d: double; end;
*)

function  v3_xyz(x,y,z: double): tnum3;
function  v3_000: tnum3;//(0,0,0)
function  v3_pz(p:tnum2; z: double): tnum3;

procedure v3_eq(x1,y1,z1: double; var x,y,z: double);//����������

procedure v3_add(x1,y1,z1, x2,y2,z2: double; var x,y,z: double); overload;
function v3_add(p1,p2: tnum3): tnum3; overload;

procedure v3_sub(x1,y1,z1, x2,y2,z2: double; var x,y,z: double); overload;
function  v3_sub(p1,p2: tnum3): tnum3; overload;

procedure v3_mul(x1,y1,z1, t: double; var x,y,z: double); overload;
function  v3_mul(v: tnum3; t: double): tnum3; overload;

function  v3_scale(x1,y1,z1, x2,y2,z2: double): double; overload;//����-�� ������-��
function  v3_scale(v1,v2: tnum3): double; overload;//����-�� ������-��

function  v3_dist(x1,y1,z1, x2,y2,z2: double): double; overload;//���������� ����� �������
function  v3_dist(p1,p2: tnum3): double; overload;
function  v3_mod(v: tnum3): double; overload;

//����� ����� b, m.b. b2=b:
function  v3_norm(a,b: tnum3; newdist: double): tnum3; overload;
function  v3_norm(a,b: tnum3; newdist: double; var b2: tnum3): boolean; overload;

function  v3_fi0(v1,v2: tnum3): double;//0..180(arccos - ��� "�����������")

//���������� �� ����� � ������� (t=0,1 - ����� �������):
function  v3_lp(x1,y1,z1, x2,y2,z2, x,y,z: double): double; overload;//"����������" �������� (x,y,z) �� ����� <x1,y1,z1 - x2,y2,z2>
function  v3_lp(a,b,p: tnum3): double; overload;//"����������" �������� p �� ����� <ab>
function  v3_vp(a,b,p: tnum3): double;//"����������" �������� (x,y,z) �� �������
procedure v3_lt(x1,y1,z1, x2,y2,z2: double; t: double; var x,y,z: double); overload;//����� �� ����� �� "����������"
function  v3_lt(a,b: tnum3; t: double): tnum3; overload;//����� �� ����� �� "����������"
function  v3_vt(a,b: tnum3; t: double): tnum3;//����� �� ������� ("������������ � ������", ���� t ��� [0,1])

//�������� � ����������:

function v3_lp_prj(a,b,p: tnum3): tnum3;//"��������" p �� ����� <ab> - v3_lp+v3_lt
function v3_vp_prj(a,b,p: tnum3): tnum3;//"��������" p �� ������� <ab> - v3_lp+v3_vt

function v3_vp_dist(a,b,p: tnum3; var prj: tnum3): double;//���������� p �� ������� <ab> (v3_vp_prj)

//���������� ����� ��������� "�� ��������� ������":
function v3_vv0_dist(a1,b1,a2,b2: tnum3; var prj1,prj2: tnum3): double;


//3D ��������� ������������ (��� ���������� <a,b,c,d>) (3 ������ 3d-������������):

//�.�. <0,0,0>, ���� ������� �����������:
function v3_vmul(v1,v2: tnum3): tnum3; overload;
//�������������(1�) ������� vn1=<a,b,c> � ���� �������� (3 ������ 3d-������������):
//FALSE: vn1=<0,0,0>(�.�. �� ����������) - ������� �����������:
function v3_vmul(v1,v2: tnum3; var vn1: tnum3): boolean; overload;


//��������� <ax+by+cz+d=0> (|<abc>|<>0 !!! - ��� ��������������):
//plane_n=<abc>, plane_d=d:
//d=0 => ��������� �������� ����� ���.�����-�:
//�����-�� �� ������ �����-� = |d|/v3_mod(a,b,c):

//�������� p �� 0-��������� Pn{a,b,c}, ����-�� ����� ����� �� (��� d)
//function v3_Pp_prj(Pn{a,b,c},p: tnum3): tnum3;

//�������� � ���������� ����� ������� � ���������:
//t1,t2 ���������� ��� Result>=0:
//Result=0 - ����� ����������:
//Result=1 - ����� ������������ (1-�� �����������) (t1,t2 ���������):
//Result=-1 - EXCEPTION (t1,t2 �� ����������):
function v3_ll_tt(a1,b1, a2,b2: tnum3; var t1,t2: double): integer;//t1,t2 ��������� ������
function v3_vv_dist(a1,b1, a2,b2: tnum3; var prj1,prj2: tnum3): double;//�������� �_�� ��� �����-�� ����� �����������:

//BYPOINTS: ��� step2 - ����� ������� <a2,b2>:
//function v3_dist_vv_step2(a1,b1, a2,b2: tnum3; step2: double; var p1,p2: tnum3): double; overload;//


implementation

uses
  Math,
  wcmn, nums;


function  v3_xyz(x,y,z: double): tnum3;
begin
  Result.p.x:=x;
  Result.p.y:=y;
  Result.z:=z;
end;

function  v3_000: tnum3;
begin
  Result:=v3_xyz(0,0,0);
end;

function  v3_pz(p:tnum2; z: double): tnum3;
begin
  Result.p:=p;
  Result.z:=z;
end;


procedure v3_eq(x1,y1,z1: double; var x,y,z: double);
begin
  x:=x1;
  y:=y1;
  z:=z1;
end;

procedure v3_add(x1,y1,z1, x2,y2,z2: double; var x,y,z: double);
begin
  x := x1 + x2;
  y := y1 + y2;
  z := z1 + z2;
end;

function v3_add(p1,p2: tnum3): tnum3;
begin
  Result.p.x := p1.p.x + p2.p.x;
  Result.p.y := p1.p.y + p2.p.y;
  Result.z   := p1.z   + p2.z;
end;

procedure v3_sub(x1,y1,z1, x2,y2,z2: double; var x,y,z: double);
begin
  x := x1 - x2;
  y := y1 - y2;
  z := z1 - z2;
end;

function v3_sub(p1,p2: tnum3): tnum3;
begin
  Result.p.x := p1.p.x - p2.p.x;
  Result.p.y := p1.p.y - p2.p.y;
  Result.z   := p1.z   - p2.z;
end;

procedure v3_mul(x1,y1,z1, t: double; var x,y,z: double);
begin
  x := x1*t;
  y := y1*t;
  z := z1*t;
end;

function  v3_mul(v: tnum3; t: double): tnum3; overload;
begin
  v3_mul(v.p.x,v.p.y,v.z, t, Result.p.x,Result.p.y,Result.z);
end;

function v3_scale(x1,y1,z1, x2,y2,z2: double): double;
begin
  Result := x1*x2 + y1*y2 + z1*z2;
end;

function  v3_scale(v1,v2: tnum3): double;
begin
  Result := v1.p.x*v2.p.x + v1.p.y*v2.p.y + v1.z*v2.z;
end;


function v3_dist(x1,y1,z1, x2,y2,z2: double): double;
begin
  Result := 0;
  try
    Result := sqrt( sqr(x2-x1) + sqr(y2-y1) + sqr(z2-z1) );
  except
    Tell('Real Overflow in v3_dist');
  end;
end;

function  v3_dist(p1,p2: tnum3): double;
begin
  Result := 0;
  try
    Result := sqrt( sqr(p2.p.x-p1.p.x) + sqr(p2.p.y-p1.p.y) + sqr(p2.z-p1.z) );
  except
    Tell('Real Overflow in v3_dist');
  end;
end;


function  v3_mod(v: tnum3): double;
begin
  Result := 0;
  try
    Result := sqrt( sqr(v.p.x) + sqr(v.p.y) + sqr(v.z) );
  except
    Tell('Real Overflow in v3_mod');
  end;
end;


function v3_norm(a,b: tnum3; newdist: double): tnum3;//����� ����� b
var d: double;
begin
  try
    d:=v3_dist(a,b);
    Result:=v3_lt(a,b, newdist/d);//�.�. "������� �� 0"
  except
    Result:=b;
    Tell('Real Overflow in v3_norm');
  end;
end;

function v3_norm(a,b: tnum3; newdist: double; var b2: tnum3): boolean;
var d: double;
begin
  Result:=false;//default
  try
    d:=v3_dist(a,b);
    b2:=v3_lt(a,b, newdist/d);//�.�. "������� �� 0"
    Result:=true;//!
  except
  end;
end;


function  v3_fi0(v1,v2: tnum3): double;//0..180(arccos)
var _cosfi: double;
begin
  try
    _cosfi := v3_scale(v1,v2)/(v3_mod(v1)*v3_mod(v2));
    Result := arccos(_cosfi);//0..PI
    Result := grad(Result);//0..180(arccos)
  except
    Result := 0;
    Tell('EXCEPTION in v3_fi (arccos)');
  end;
end;


function v3_lp(x1,y1,z1, x2,y2,z2, x,y,z: double): double;//"����������" �������� (x,y,z) �� �����
var v1x,v1y,v1z, v2x,v2y,v2z, d2: double;
begin
  try
    v3_sub(x2,y2,z2, x1,y1,z1, v1x,v1y,v1z);
    d2 := sqr(v1x) + sqr(v1y) + sqr(v1z);
    v3_sub(x,y,z, x1,y1,z1, v2x,v2y,v2z);
    if d2>0 then Result:=v3_scale(v1x,v1y,v1z, v2x,v2y,v2z)/d2
    else Result:=0;//0-�����
  except
    Result:=0;//0-�����
  end;
end;

function  v3_lp(a,b,p: tnum3): double;
begin
  Result := v3_lp(a.p.x,a.p.y,a.z, b.p.x,b.p.y,b.z, p.p.x,p.p.y,p.z);
end;

function v3_vp(a,b,p: tnum3): double;//"����������" �������� (x,y,z) �� �������
begin
  Result := v3_lp(a,b,p);
  if Result<0 then Result:=0 else
  if Result>1 then Result:=1;
end;

procedure v3_lt(x1,y1,z1, x2,y2,z2: double; t: double; var x,y,z: double);//����� �� ����� �� "����������"
var xx,yy,zz: double;
begin
  v3_sub(x2,y2,z2, x1,y1,z1, xx,yy,zz);
  v3_mul(xx,yy,zz, t, xx,yy,zz);
  v3_add(x1,y1,z1, xx,yy,zz, x,y,z);
end;

function v3_lt(a,b: tnum3; t: double): tnum3;
begin
  v3_lt(a.p.x,a.p.y,a.z, b.p.x,b.p.y,b.z, t, Result.p.x,Result.p.y,Result.z);
end;

function v3_vt(a,b: tnum3; t: double): tnum3;
begin
  if t<=0 then Result:=a else
  if t>=1 then Result:=b else
  Result:=v3_lt(a,b, t);
end;


function  v3_lp_prj(a,b,p: tnum3): tnum3;
var t: double;
begin
  t:=v3_lp(a,b,p);//���������� �� �����
  Result:=v3_lt(a,b,t);//����� �� �����
end;

function v3_vp_prj(a,b,p: tnum3): tnum3;
var t: double;
begin
  t:=v3_lp(a,b,p);//���������� �� �����
  Result:=v3_vt(a,b,t);//����� �� �������
end;
(*
procedure v3_vp_prj(x1,y1,z1, x2,y2,z2, x,y,z: double; var px,py,pz: double);//(px,py,pz) - �������� (x,y,z) �� �������(!)
var t: double;
begin
  t:=v3_vp(x1,y1,z1, x2,y2,z2, x,y,z);//����������
  if t=0 then v3_eq(x1,y1,z1, px,py,pz) else
  if t=1 then v3_eq(x2,y2,z2, px,py,pz) else
  v3_lt(x1,y1,z1, x2,y2,z2, t, px,py,pz);
end;
*)

function v3_vp_dist(a,b,p: tnum3; var prj: tnum3): double;
begin
  prj := v3_vp_prj(a,b,p);
  Result := v3_dist(p, prj);
end;


//���������� ����� ��������� "�� ��������� ������":
function v3_vv0_dist(a1,b1,a2,b2: tnum3; var prj1,prj2: tnum3): double;

  procedure _Result(d: double; p1,p2: tnum3);//->Result!
  begin
    Result:=d;
    prj1:=p1;
    prj2:=p2;
  end;

var d: double; q: tnum3;
begin
  d:=v3_dist(a1,a2);//default
  _Result(d,a1,a2);//default>=0

  d := v3_vp_dist(a1,b1, a2, q); if d<Result then _Result(d,q,a2);
  d := v3_vp_dist(a1,b1, b2, q); if d<Result then _Result(d,q,b2);
  d := v3_vp_dist(a2,b2, a1, q); if d<Result then _Result(d,a1,q);
  d := v3_vp_dist(a2,b2, b1, q); if d<Result then _Result(d,b1,q);
end;



function v3_vmul(v1,v2: tnum3): tnum3;
begin
  Result.p.x :=   v1.p.y*v2.z   - v1.z*v2.p.y   ;//y-z
  Result.p.y := -(v1.p.x*v2.z   - v1.z*v2.p.x)  ;//x-z
  Result.z   :=   v1.p.x*v2.p.y - v1.p.y*v2.p.x ;//x-y
end;

function v3_vmul(v1,v2: tnum3; var vn1: tnum3): boolean;
var d: double;
begin
  Result:=true;
  try
    vn1 := v3_vmul(v1,v2);
    d := v3_mod(vn1);
    if d>v_zero then vn1 := v3_mul(vn1, 1/d)//m.b. ������� �� ����
    else Result:=false;
  except
    Result:=false;
  end;
end;

(*
//�������� p �� 0-���������, ����-�� ����� ����� �� (��� d):
function v3_Pp_prj(Pn{a,b,c},p: tnum3): tnum3;
var Pna,Pnb,p_Pn: tnum3;
begin
  //2 ����� ����� Pn, �������-�� �� Pn{a,b,c}:
  Pna:=v3_num3_000;
  Pnb:=Pn;

  //�������� ����� p �� ����� Pn:
  p_Pn := v3_lp_prj(Pna,Pnb, p);
  Result := v3_sub(p, p_Pn);//Result ����������� Pn
end;
*)

//t1,t2 ��������� ������:
function v3_ll_tt(a1,b1, a2,b2: tnum3; var t1,t2: double): integer;

  procedure _EXIT1;//->t1,t2
  var prj1,prj2: tnum3;
  begin
    v3_vv0_dist(a1,b1,a2,b2, prj1,prj2);//������������ �������!
    t1 := v3_vp(a1,b1,prj1);
    t2 := v3_vp(a2,b2,prj2);
    Result:=1;//��������������
  end;

var x1,x2: double; v1,v2,v12,a21: tnum3;
//var a1P,a2P: tnum3;
begin
  Result:=1;//default - ��������������!

  //vl1,vl2: ������� �����:
  v1 := v3_sub(b1,a1);
  v2 := v3_sub(b2,a2);

  //v12: ������� � 0-��������� P (m.b. <0,0,0>):
  v12 := v3_vmul(v1,v2);
  if v3_mod(v12)=0 then begin//������������ �������:
    _EXIT1;//!
    EXIT;//!
  end;

  //v12<>0 - �������������� ������:
  try
(*
    //a1P,a2P: �������� ����� a1,a2 �� (v1,v2)-��������� P:
    a1P := v3_Pp_prj(v12{a,b,c}, a1);
    a2P := v3_Pp_prj(v12{a,b,c}, a2);
    a21 := v3_sub(a2P,a1P);

    //t1 �� <a1,b1>, t2 �� <a2,b2> (x1,x2 - ��������� � �����������):
    x2 := v3_scale( v12, v12 );//����������� ����������
    //t1(v1*v2)=(a2P-a1P)*v2:
    x1 := v3_scale( v12, v3_vmul(a21,v2) );
    t1 := x1/x2;//x2<>0, if v12<>0
    //t2(v1*v2)=(a2P-a1P)*v1:
    x1 := v3_scale( v12, v3_vmul(a21,v1) );
    t2 := x1/x2;//x2<>0, if v12<>0
*)
    //���������� ����� (092008), ���� ������ �� ������ �����-��:
    a21 := v3_sub(a2,a1);

    //t1 �� <a1,b1>, t2 �� <a2,b2> (x1,x2 - ��������� � �����������):
    x2 := v3_scale( v12, v12 );//����������� ����������

    //t1(v1*v2)(v1*v2)=-(v2*a21)(v1*v2):
    x1 := - v3_scale( v3_vmul(v2, a21), v12 );
    t1 := x1/x2;//x2<>0, if v12<>0

    //t2(v1*v2)(v1*v2)=-(v1*a21)(v1*v2):
    x1 := - v3_scale( v3_vmul(v1, a21), v12 );
    t2 := x1/x2;//x2<>0, if v12<>0

    Result:=0;//�������������� ������
  except
    Tell('Exception in v3_ll_tt');//DEBUG
    Result:=-1;
    _EXIT1;//m.b. v12=0(except - ��� ��������������!)
  end;
end;

(*
//�������� �_�� ��� �����-�� ����� �����������:
function v3_vv_prj(a1,b1, a2,b2: tnum3; var prj1,prj2: tnum3): integer;
var t1,t2: double;
begin
  Result := v3_ll_tt(a1,b1, a2,b2, t1,t2);;//t=0..1, t1,t2 ���������� ��� Result>=0
  if Result<0 then EXIT;//!

    if t1<0 then t1:=0 else
    if t1>1 then t1:=1;
    if t2<0 then t2:=0 else
    if t2>1 then t2:=1;

  //Result>=0 - t1,t2 ����������:
  prj1 := v3_vt(a1,b1,t1);
  prj2 := v3_vt(a2,b2,t2);
end;
*)
//�������� �_�� ��� �����-�� ����� �����������:
function v3_vv_dist(a1,b1, a2,b2: tnum3; var prj1,prj2: tnum3): double;

  procedure _Result(d: double; p1,p2: tnum3);//->Result � ���������
  begin
    if (d>=0) and ( (d<Result) or (Result<0) ) then begin
      Result:=d;
      prj1:=p1;
      prj2:=p2;
    end;
  end;

var ires: integer; t1,t2,d: double; p1,p2: tnum3;
begin
  Result:=-1;//default

  d := v3_vv0_dist(a1,b1,a2,b2, p1,p2);//"�� ��������� ������"
  _Result(d, p1,p2);//->Result � ���������

  //����� �� �������������� ������:
  ires := v3_ll_tt(a1,b1, a2,b2, t1,t2);;//t=0..1, t1,t2 ���������� ��� Result>=0
  if ires>=0 then begin

    if (t1>0) and (t1<1) then begin
      p1 := v3_lt(a1,b1, t1);
      d := v3_vp_dist(a2,b2,p1, p2);
      _Result(d, p1,p2);//->Result � ���������
    end;

    if (t2>0) and (t2<1) then begin
      p2 := v3_lt(a2,b2, t2);
      d := v3_vp_dist(a1,b1,p2, p1);
      _Result(d, p1,p2);//->Result � ���������
    end;

  end;
(*
  //DEBUG:
  if t1=0 then Tellf('end 1 - Result=%f',[Result]) else
  if (t1>0) and (t1<1) then Tellf('mid - Result=%f',[Result]) else
  if t1=1 then Tellf('end 2 - Result=%f',[Result]) else
  Tellf('??? - Result=%f',[Result]);
*)  
end;

(*
//BYPOINTS: step2 - �� ������� <a2,b2>:
function v3_dist_vv_step2(a1,b1, a2,b2: tnum3; step2: double; var p1,p2: tnum3): double;
var n2,i2: integer; l2,dt2,d: double; p1i,p2i: tnum3;
begin
  Result:=v3_vp_dist(a1,b1, a2, p1{on <a1,b1>}); p2:=a2{on <a2,b2>};//default
  if Result<0 then exit;//!

  l2:=v3_dist(a2,b2);
  if l2<=0 then exit;//!

  n2:=Round(l2/step2)+1;//=>n2>0 - ���-�� �����(!) �� a2 �� b2 ������������!
  if n2<2 then n2:=2;//=> n2-1>0!
  dt2:=1/(n2-1);//��� "����������" t
  for i2:=0 to n2-1 do begin
    p2i:=v3_lt(a2,b2, i2*dt2);//i2*dt2 = 0 .. 1
    d:=v3_vp_dist(a1,b1, p2i{on <a2,b2>}, p1i{on <a1,b1>});
    if (d>=0) and (d<Result) then begin
      p1:=p1i;
      p2:=p2i;
    end;
  end;//for i2
end;
*)

end.
