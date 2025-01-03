unit contain; interface

uses Otypes;



(*
	lp - ��������� �� {xi,yi}; n=count-1;
        lt,rb: bound (LeftTop, RightBottom)
	Return: -1 - ���; 0 - �� �������; 1 - ������;
        lp.first=lp.last; ����� ���;
        ������� ����� k ����� ����������� lp � �������������� �����,
        ������������� ������ p. Odd(k) (k �������) => ������;
*)
function PolyGonContainsPoint(lp: PLPoly; n: Integer; lt,rb: LPoint; p: LPoint): Integer;



implementation

uses wcmn;


function Points_Equal(p1,p2: lpoint): boolean;
begin
  Result := (p1.x=p2.x) and (p1.y=p2.y) ;
end;

function PolyGonContainsPoint(lp: PLPoly; n: Integer; lt,rb: LPoint; p: LPoint): Integer;
var
  p1,p2: LPoint;
  i, dx,dy, min_y,max_y: Integer;
  k: Integer;//����� ����������� lp � �������������� ����� ������ p
  x,y: Double;
begin
  Result:=-1;//���

  //����� � ����� ���������:
  if (p.x >= lt.x) and (p.x <= rb.x) and
     (p.y >= lt.y) and (p.y <= rb.y) then begin

    k:=0;
    p2:=lp[0];

    if Points_Equal(p,p2) then begin
      Result:=0; Exit
    end else

    //���� �� �������� ��������� [p1,p2]:
    for i:=1 to N do begin

      p1:=p2; p2:=lp[i];//��������� �������

      min_y:=Mini(p1.y,p2.y);
      max_y:=Maxi(p1.y,p2.y);
      dx:=p2.x-p1.x;
      dy:=p2.y-p1.y;

      if Points_Equal(p,p2) then begin
        Result:=0; Exit
      end else

      if p1.y = p2.y then begin
      //��������-�� �������:

        if p.y = p1.y then

        if p.x >= Mini(p1.x,p2.x) then
        if p.x <= Maxi(p1.x,p2.x) then begin
          Result:=0; Exit
        end

      end else
      //�� ��������-�� ������� (dy<>0):

      if p.y >= min_y then

      if p.y < max_y then begin

        x:=(p.y-p1.y)*dx/dy + p1.x;//=> (x,p.y) - �� �������

        if Round(x) = p.x then begin
          Result:=0; Exit
        end else
        if p1.x <> p2.x then begin //=> dx<>0 :

          y:=(p.x-p1.x)*dy/dx + p1.y;//=> (p.x,y) - �� �������

          if Round(y) = p.y then begin
            Result:=0; Exit
          end
        end;

        if p.x < x then Inc(k)

      end else

      if p.y = max_y then

      if p.y <> p1.y then begin

        x:=(p.y-p1.y)*dx/dy + p1.x;//=> (x,p.y) - �� �������

        if Round(x) = p.x then begin
          Result:=0; Exit
        end
        else
        if p1.x <> p2.x then begin //=> dx<>0 :

          y:=(p.x-p1.x)*dy/dx + p1.y;//=> (p.x,y) - �� �������

          if Round(y) = p.y then begin
            Result:=0; Exit
          end
        end

      end else
      if p1.x <> p2.x then begin
        y:=(p.x-p1.x)/dx*dy + p1.y;
        if Round(y) = p.y then begin
          Result:=0; Exit
        end
      end

    end;//for i

    if Odd(k) then Result:=1 //���� ������� => ������

  end //����� � �����
end;


end.
