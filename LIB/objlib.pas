(*
  ������ � ���������������.
  � �.�. - MDB.
  ������ ������ - objl_init - ���� � ����-�� �� alw ��� dmw
  ALW: objl_init(alwl_obj_path) (USES ������� �����!)
  DMW:
*)
unit objlib; interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB,
  nums, list;

type
  TObjTab = class
  private
    //FTime: TDateTime;//system, double, function Now
  public
    Nums: tinta;//1-�� �������
    Names1: tstringlist;//������� ���, ���������� Nums
    Names2: tstringlist;//������� ������� ���, ���������� Nums, default - �������� ''

    constructor Create;
    destructor Destroy; override;
    function NameByNum(aNum: integer; _1: boolean = true): string;//default=''
  end;

var
  //objl_init => ���� � ������ .obj, .mdb:
  objl_ObjPath: string;
  objl_MdbPath: string;

  //����������� ������� ���-�:
  objl_Tabs: TClassList;//initialization

  //initialization + objl_mdb_tabload:
  objl_Mdb_Nums: tinta;//1-�� �������
  objl_Mdb_Names: tstringlist;//������� ���, ���������� objl_Mdb_Nums
  objl_Mdb_Names2: tstringlist;//������� ���, ���������� objl_Mdb_Nums

  objl_Mdb751_1: tinta;//1-�� �������
  objl_Mdb751_2: tstringlist;//������� ���, ����������
  objl_Mdb751_3: tstringlist;//������� "������" ���, ����������

//������ ������ - ���� � ����-�� �� alw ��� dmw (USES ������� �����!):
//ALW: objl_init(alwl_obj_path):
//TRUE: ���� aObjPath ����������:
//_msg - ��������� �� FALSE (���� aObjPath �� ����������):
function objl_init(aObjPath: string; _msg: boolean): boolean;


//MDB:

//aChNum (����� ���-��) - ��� �������
//aColNum (>1) - ����� ������� ��� (1-��=1 - ������!)
//Fields[0] -> FNums
//Fields[aColNum-1] -> FNames
//Fields[aColNum2-1] -> FNames2
function objl_mdb_tabload(aChNum{����� ���-��},aColNum{>1},aColNum2{m.b.0}: integer): boolean;

function objl_mdb751_tabload(aChNum: integer): boolean;//msg


type
  TFormObjLib = class(TForm)
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
  private
  public
  end;

var
  FormObjLib: TFormObjLib;

implementation

{$R *.dfm}

uses wcmn, adolib;


{ TObjTab: }

constructor TObjTab.Create;
begin
  Nums:=tinta.New;//1-�� �������
  Names1:=tstringlist.Create;//������� ���, ���������� Nums
  Names2:=tstringlist.Create;//������� "������" ���, ���������� Nums
end;

destructor TObjTab.Destroy;
begin
  Names2.Free;
  Names1.Free;
  Nums.Free;
end;


function TObjTab.NameByNum(aNum: integer; _1: boolean): string;//default=''
var ind: integer;
begin
  ind:=Nums.IndexOf(aNum);
  if ind>=0
  then
    if _1
    then Result:=Names1[ind]
    else Result:=Names2[ind]
  else Result:='';//default
end;


{ ����������: }

//������ ������:
function objl_init(aObjPath: string; _msg: boolean): boolean;
var obj_dirname: string;
begin
  Result:=false;//default
  if aObjPath='' then EXIT;//��������, ����� ��������� � alw!

  Result:=FileExists(aObjPath);
  if not Result then begin
    if _msg then
      Tellf('���� �������������� "%s" �� ������\n��������� ������� ����� � ��������� ��� "������� �����"',[aObjPath]);
    EXIT;//!
  end;

  obj_dirname := wcmn_file_dirname(aObjPath);
  objl_ObjPath := obj_dirname + '.obj';
  objl_MdbPath := obj_dirname + '.mdb';
end;


{ MDB: }

function objl_mdb_tabload(aChNum, aColNum{>=1},aColNum2{m.b.0}: integer): boolean;
var s: string;
begin
  objl_Mdb_Nums.Clear;
  objl_Mdb_Names.Clear;
  objl_Mdb_Names2.Clear;
  Result := false;//default

  if ado_Connect(FormObjLib.ADOConnection1, objl_MdbPath, true{_msg})
  then try
    if ado_open(FormObjLib.ADOTable1, IntToStr(aChNum), true{readonly}, true{_msg})
    then try

      FormObjLib.ADOTable1.First;
      while not FormObjLib.ADOTable1.Eof{TDataSet property} do begin
        objl_Mdb_Nums.Add ( FormObjLib.ADOTable1.Fields[0].AsInteger );

        s := FormObjLib.ADOTable1.Fields[aColNum-1].AsString;
        //s := AnsiUpperCase(s); - �� ����� (������ 30.11.2006)
        objl_Mdb_Names.Add(s);

        s:='';
        if aColNum2>1
        then s := FormObjLib.ADOTable1.Fields[aColNum2-1].AsString;
        objl_Mdb_Names2.Add(s);

        FormObjLib.ADOTable1.Next;//to Next Record
      end;

      Result := true;//���� ���� ������ �������
    finally
      ado_close(FormObjLib.ADOTable1, true{readonly});
    end;
  finally
    ado_Disconnect(FormObjLib.ADOConnection1);
  end;
end;

function objl_mdb751_tabload(aChNum: integer): boolean;//msg
var s: string;
begin
  Result := false;//default
  objl_Mdb751_3.Clear;
  objl_Mdb751_2.Clear;
  objl_Mdb751_1.Clear;

  if ado_Connect(FormObjLib.ADOConnection1, objl_MdbPath, true{_msg})
  then try
    if ado_open(FormObjLib.ADOTable1, IntToStr(aChNum), true{readonly}, true{_msg})
    then try

      FormObjLib.ADOTable1.First;
      while not FormObjLib.ADOTable1.Eof{TDataSet property} do begin
        objl_Mdb751_1.Add ( FormObjLib.ADOTable1.Fields[0].AsInteger );

        s := FormObjLib.ADOTable1.Fields[1].AsString;
        objl_Mdb751_2.Add(s);

        if FormObjLib.ADOTable1.Fields.Count>2
        then s := FormObjLib.ADOTable1.Fields[2].AsString
        else s:='';
        objl_Mdb751_3.Add(s);

        FormObjLib.ADOTable1.Next;//to Next Record
      end;

      Result := true;//���� ���� ������ �������
    finally
      ado_close(FormObjLib.ADOTable1, true{readonly});
    end;
  finally
    ado_Disconnect(FormObjLib.ADOConnection1);
  end;
end;


initialization
  objl_Tabs:=TClassList.New;

  objl_Mdb_Nums:=tinta.New;
  objl_Mdb_Names:=tstringlist.Create;
  objl_Mdb_Names2:=tstringlist.Create;

  objl_Mdb751_1:=tinta.New;
  objl_Mdb751_2:=tstringlist.Create;
  objl_Mdb751_3:=tstringlist.Create;

finalization
  objl_Mdb751_3.Free;
  objl_Mdb751_2.Free;
  objl_Mdb751_1.Free;

  objl_Mdb_Names2.Free;
  objl_Mdb_Names.Free;
  objl_Mdb_Nums.Free;

  objl_Tabs.Free;

end.
