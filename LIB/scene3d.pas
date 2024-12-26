unit scene3d; interface

uses terra3dlib_tlb;

type
  TScn3D = class
  private
    scn: IScene3D;//COM-object (terra3dlib_tlb.pas)
  public
    constructor Create;
  end;

var
  Scn3D: TScn3D;


implementation


constructor TScn3D.Create;
begin
  scn:=CoScene3D.Create;
end;



end.
