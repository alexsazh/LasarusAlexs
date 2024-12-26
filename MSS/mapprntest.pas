(*
  тест mapprn.dll
*)
unit mapprntest;

{$MODE Delphi}

 interface


//вызов в msw_1.MsRepeatItemClick после StoreToAbc
function mapprn_dll_test: integer;//0 => Ok


implementation

uses
  LCLIntf, LCLType,
  Wcmn,
  MSW_1{FormMain}, Msw_msx{Abc};


{ private: }

var
ParamsRec: record
  gc_file: string;      //путь к классификатору .gc
  w,h: double;          //размеры картинки из $.MS в мм (высота - пропорционально)
  mw,mh: double;        //поля в мм
  zoom: double;         //увеличение (текст, значки, ширина линий)
  out_file: string;     //путь к выходному файлу .ps
  flags: DWORD;
end;

procedure LoadParamsRec;
begin
  ParamsRec.gc_file  := abc.gc_names;
  ParamsRec.w        := abc.pw;
  ParamsRec.h        := abc.ph;
  ParamsRec.mw       := abc.px0;
  ParamsRec.mh       := abc.py0;
  ParamsRec.zoom     := abc.zoom;
  ParamsRec.out_file := FormMain.AiFileLabel.Caption;

  ParamsRec.flags:=0;
  if FormMain.Markers.Checked then ParamsRec.flags := ParamsRec.flags OR 1;
end;

{ public: }

function mapprn_dll_test: integer;
var func: function(
  gc_file: PChar;       //путь к классификатору .gc
  w,h: double;          //размеры картинки из $.MS в мм (высота - пропорционально)
  mw,mh: double;        //поля в мм
  zoom: double;         //увеличение (текст, значки, ширина линий)
  out_file: PChar;      //путь к выходному файлу .ps
  flags: DWORD          //см. выше константы flags_*
  ): integer; stdcall;	//0 => Ok
var DllHandle: THandle;
begin
  Result:=-1;
  DllHandle:=wcmn_dll_open('mapprn');
  if DllHandle>0 then try
    @func:=GetProcaddress(DllHandle,'mapprn1');
    if Assigned(func) then begin
      LoadParamsRec;
      Result:=func(
        PChar(ParamsRec.gc_file),
        ParamsRec.w,ParamsRec.h,
        ParamsRec.mw,ParamsRec.mh,
        ParamsRec.zoom,
        PChar(ParamsRec.out_file),
        ParamsRec.flags
      );
    end;
  finally
    wcmn_dll_close(DllHandle);
  end;
end;

end.
