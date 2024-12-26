unit nvunzarm;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, odbcconn, SQLDB, ExtCtrls, DBCtrls, DBGrids, StdCtrls,
  nevautil, dmw_ddw, win_use;

type

  { TFtuneZaram }

  TFtuneZaram = class(TForm)
    Label1: TLabel;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    DS_Frame: TDataSource;
    ADODS_FrameID: TAutoIncField;
    ADODS_FrameID_TYPE: TIntegerField;
    ADODS_FrameDSDesigner: TFloatField;
    ADODS_FrameDSDesigner2: TFloatField;
    ADODS_FrameDSDesigner3: TWideStringField;
    ADODS_FrameDSDesigner4: TMemoField;
    ADODS_FrameDSDesigner5: TWordField;
    ADODS_FrameLOCTYPE: TStringField;
    ADODS_FrameID_LAYOUT: TIntegerField;
    ADODS_FrameField: TStringField;
    DBMemText: TDBMemo;
    Button1: TButton;
    ODBCConnFrame: TODBCConnection;
    SQLQuery_layout: TSQLQuery;
    SQLQuery_Frame: TSQLQuery;
    SQLQuery_Types: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FtuneZaram: TFtuneZaram;

implementation

{$R *.dfm}

procedure TFtuneZaram.FormCreate(Sender: TObject);
begin
  try
    ODBCConnFrame.Params.Clear;
    ODBCConnFrame.Driver:='Microsoft Access Driver (*.mdb)';
    ODBCConnFrame.Params.Add('DBQ='+make_ini('Frame_N.mdb'));
    ODBCConnFrame.Params.Add('Locale Identifier=1031');
    ODBCConnFrame.Params.Add('ExtendedAnsiSQL=1');
    ODBCConnFrame.Params.Add('CHARSET=ansi');
    ODBCConnFrame.Connected := True;
    ODBCConnFrame.KeepConnection := True;

    SQLQuery_layout.Active :=true;
    SQLQuery_Types.Active :=true;
    SQLQuery_Frame.Active :=true;
  except
  end;
end;

procedure TFtuneZaram.Button1Click(Sender: TObject);
var
  ss:shortstring;
  cod : longint;
  loc: Byte;
begin
if SQLQuery_frame.state in [dsInsert] then begin
  ss:='0';
  loc:=0;
end else begin
  ss:=SQLQuery_frame.FieldByName('КОД').asstring;
  if ss='' then ss:='0';
  if SQLQuery_frame.FieldByName('ТИП').isnull then loc:=0
  else if trim(SQLQuery_frame.FieldByName('ТИП').asstring)='' then loc:=0
  else loc:=SQLQuery_frame.FieldByName('ТИП').asinteger;
end;
If dmw_ChooseObject(String2Code(ss),loc,cod,loc,NIL,0) THEN begin
    if not (SQLQuery_frame.state in [dsEdit,dsInsert])  then SQLQuery_frame.Edit;
    SQLQuery_frame.FieldByName('КОД').asstring:=Code2String(cod);
    SQLQuery_frame.FieldByName('ТИП').asinteger:=loc;
    SQLQuery_frame.Post
end;
Show;
end;

end.
