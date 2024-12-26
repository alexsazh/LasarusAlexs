unit DLL_KRI;

{$MODE Delphi}

 interface

uses Wcmn;

//function _dll_t(i1: integer; var i2: integer): integer; cdecl;
{
extern "C" __declspec(dllexport) int dll_kri(int*,int,float*, float,float, int*,int*);
//p,n,l,  k2,p2,n2,  sL:
extern "C" __declspec(dllexport) int dll_kri0(int*,int,float*,  float**,float**,int*  ,float);
}
procedure _dll_init; cdecl;
procedure _dll_done; cdecl;
function _dll_kri(mas: plong; n: longint; len,kri: psing; sL,Kmin: single; mas2,n2: plong): integer; cdecl;
function _dll_kri0(mas: plong; n: longint; len: psing;  k2,p2: ppsing; n2: plong;   sL: single): integer; cdecl;

implementation

const dll = 'dll_kri.dll';

//function _dll_t(i1: integer; var i2: integer): integer; external dll;

procedure _dll_init; external dll;
procedure _dll_done; external dll;
function _dll_kri(mas: plong; n: longint; len,kri: psing; sL,Kmin: single; mas2,n2: plong): integer; external dll;
function _dll_kri0(mas: plong; n: longint; len: psing;  k2,p2: ppsing; n2: plong;  sL: single): integer; external dll;


end.
