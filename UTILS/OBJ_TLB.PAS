unit Obj_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 22.05.2013 10:43:34 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\tol\DMD\Obj.tlb (1)
// LIBID: {C9958520-BB67-11D1-868D-004095013CFD}
// LCID: 0
// Helpfile: 
// HelpString: Obj Library
// DepndLst: 
//   (1) v1.0 stdole, (C:\Windows\system32\stdole32.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ObjMajorVersion = 1;
  ObjMinorVersion = 0;

  LIBID_Obj: TGUID = '{C9958520-BB67-11D1-868D-004095013CFD}';

  IID_Iobj_auto: TGUID = '{C9958521-BB67-11D1-868D-004095013CFD}';
  CLASS_obj_auto: TGUID = '{C9958522-BB67-11D1-868D-004095013CFD}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  Iobj_auto = interface;
  Iobj_autoDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  obj_auto = Iobj_auto;


// *********************************************************************//
// Interface: Iobj_auto
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {C9958521-BB67-11D1-868D-004095013CFD}
// *********************************************************************//
  Iobj_auto = interface(IDispatch)
    ['{C9958521-BB67-11D1-868D-004095013CFD}']
    function Get_Count: Integer; safecall;
    function Get_FName: WideString; safecall;
    procedure ItemColor(Ind: Integer; out Code: Integer; out Loc: Integer; out Msg: WideString); safecall;
    procedure ItemIndex(Code: Integer; Loc: Integer; out Ind: Integer); safecall;
    procedure Locate(Code: Integer; Loc: Integer; out Ind: Integer); safecall;
    procedure Delete(Code: Integer; Loc: Integer); safecall;
    procedure Rename(const str: WideString); safecall;
    property Count: Integer read Get_Count;
    property FName: WideString read Get_FName;
  end;

// *********************************************************************//
// DispIntf:  Iobj_autoDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {C9958521-BB67-11D1-868D-004095013CFD}
// *********************************************************************//
  Iobj_autoDisp = dispinterface
    ['{C9958521-BB67-11D1-868D-004095013CFD}']
    property Count: Integer readonly dispid 1;
    property FName: WideString readonly dispid 3;
    procedure ItemColor(Ind: Integer; out Code: Integer; out Loc: Integer; out Msg: WideString); dispid 4;
    procedure ItemIndex(Code: Integer; Loc: Integer; out Ind: Integer); dispid 2;
    procedure Locate(Code: Integer; Loc: Integer; out Ind: Integer); dispid 201;
    procedure Delete(Code: Integer; Loc: Integer); dispid 202;
    procedure Rename(const str: WideString); dispid 203;
  end;

// *********************************************************************//
// The Class Coobj_auto provides a Create and CreateRemote method to          
// create instances of the default interface Iobj_auto exposed by              
// the CoClass obj_auto. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Coobj_auto = class
    class function Create: Iobj_auto;
    class function CreateRemote(const MachineName: string): Iobj_auto;
  end;

implementation

uses ComObj;

class function Coobj_auto.Create: Iobj_auto;
begin
  Result := CreateComObject(CLASS_obj_auto) as Iobj_auto;
end;

class function Coobj_auto.CreateRemote(const MachineName: string): Iobj_auto;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_obj_auto) as Iobj_auto;
end;

end.
