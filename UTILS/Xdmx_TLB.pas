unit Xdmx_TLB;

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
// File generated on 07.07.2009 15:01:33 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Map\Bin\xdmx.ocx (1)
// LIBID: {ACE1D4BE-A1AD-4228-864F-A1A860751C61}
// LCID: 0
// Helpfile: 
// HelpString: Xdmx Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  XdmxMajorVersion = 1;
  XdmxMinorVersion = 0;

  LIBID_Xdmx: TGUID = '{ACE1D4BE-A1AD-4228-864F-A1A860751C61}';

  IID_IDmxActiveX: TGUID = '{A66FC1CA-D4C7-457C-8F5A-F1911C9F81B5}';
  DIID_IDmxActiveXEvents: TGUID = '{76FD0BF4-65DA-4DC7-BA83-77B1EA271E18}';
  CLASS_DmxActiveX: TGUID = '{3654902B-7C02-4F9E-8DD6-BC55D1F0D3F3}';
  IID_IDmxTools: TGUID = '{FB65EA72-4BB2-4953-9E95-5E1201DFA419}';
  IID_IDmxLink: TGUID = '{C712C7D7-974C-4D8D-90EF-77F22DA4C6B7}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TxActiveFormBorderStyle
type
  TxActiveFormBorderStyle = TOleEnum;
const
  afbNone = $00000000;
  afbSingle = $00000001;
  afbSunken = $00000002;
  afbRaised = $00000003;

// Constants for enum TxPrintScale
type
  TxPrintScale = TOleEnum;
const
  poNone = $00000000;
  poProportional = $00000001;
  poPrintToFit = $00000002;

// Constants for enum TxMouseButton
type
  TxMouseButton = TOleEnum;
const
  mbLeft = $00000000;
  mbRight = $00000001;
  mbMiddle = $00000002;

// Constants for enum TxWindowTool
type
  TxWindowTool = TOleEnum;
const
  penObject = $00000000;
  penPoint = $00000001;
  penVector = $00000002;
  penRect = $00000003;
  penPort = $00000004;
  penRing = $00000005;
  penPoly = $00000006;
  penLocator = $00000007;
  penCursor = $00000008;
  penPunkt = $00000009;
  penPair = $0000000A;
  penDrag = $0000000B;

// Constants for enum TxEditObject
type
  TxEditObject = TOleEnum;
const
  Object_add = $00000001;
  Object_del = $00000002;
  Object_mf = $00000004;
  Object_hf = $00000008;

// Constants for enum TxExtObject
type
  TxExtObject = TOleEnum;
const
  cn_object = $00000000;
  cn_ident = $00000001;
  cn_node = $00000002;
  cn_edge = $00000003;
  cn_group = $00000004;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDmxActiveX = interface;
  IDmxActiveXDisp = dispinterface;
  IDmxActiveXEvents = dispinterface;
  IDmxTools = interface;
  IDmxToolsDisp = dispinterface;
  IDmxLink = interface;
  IDmxLinkDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DmxActiveX = IDmxActiveX;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PPUserType1 = ^IFontDisp; {*}


// *********************************************************************//
// Interface: IDmxActiveX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A66FC1CA-D4C7-457C-8F5A-F1911C9F81B5}
// *********************************************************************//
  IDmxActiveX = interface(IDispatch)
    ['{A66FC1CA-D4C7-457C-8F5A-F1911C9F81B5}']
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_AutoScroll: WordBool; safecall;
    procedure Set_AutoScroll(Value: WordBool); safecall;
    function Get_AutoSize: WordBool; safecall;
    procedure Set_AutoSize(Value: WordBool); safecall;
    function Get_AxBorderStyle: TxActiveFormBorderStyle; safecall;
    procedure Set_AxBorderStyle(Value: TxActiveFormBorderStyle); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Color: OLE_COLOR; safecall;
    procedure Set_Color(Value: OLE_COLOR); safecall;
    function Get_Font: IFontDisp; safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
    procedure _Set_Font(var Value: IFontDisp); safecall;
    function Get_KeyPreview: WordBool; safecall;
    procedure Set_KeyPreview(Value: WordBool); safecall;
    function Get_PixelsPerInch: Integer; safecall;
    procedure Set_PixelsPerInch(Value: Integer); safecall;
    function Get_PrintScale: TxPrintScale; safecall;
    procedure Set_PrintScale(Value: TxPrintScale); safecall;
    function Get_Scaled: WordBool; safecall;
    procedure Set_Scaled(Value: WordBool); safecall;
    function Get_Active: WordBool; safecall;
    function Get_DropTarget: WordBool; safecall;
    procedure Set_DropTarget(Value: WordBool); safecall;
    function Get_HelpFile: WideString; safecall;
    procedure Set_HelpFile(const Value: WideString); safecall;
    function Get_ScreenSnap: WordBool; safecall;
    procedure Set_ScreenSnap(Value: WordBool); safecall;
    function Get_SnapBuffer: Integer; safecall;
    procedure Set_SnapBuffer(Value: Integer); safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    function Get_AlignDisabled: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_App_Handle(Param1: Integer); safecall;
    function Get_Bin_Dir: WideString; safecall;
    procedure Set_Bin_Dir(const Value: WideString); safecall;
    function Get_Project: WideString; safecall;
    procedure Set_Project(const Value: WideString); safecall;
    function Get_Active_Map: WideString; safecall;
    procedure Set_Active_Map(const Value: WideString); safecall;
    function Get_Maps_Count: Integer; safecall;
    function Get_Alt_Project: WideString; safecall;
    procedure Save_Project(const FName: WideString); safecall;
    procedure New_Project(const FName: WideString); safecall;
    procedure Cls_Project; safecall;
    procedure Project_Map(i: Integer; out FName: WideString); safecall;
    procedure Map_Contains(x: Integer; y: Integer; out FName: WideString); safecall;
    procedure Insert_Map(const FName: WideString); safecall;
    procedure Delete_Map(const FName: WideString); safecall;
    procedure prj_Add_Map(const FName: WideString; lev1: Integer; lev2: Integer); safecall;
    procedure prj_Contains_Map(const FName: WideString; out Ind: Integer); safecall;
    function Get_Image: WideString; safecall;
    procedure Set_Image(const Value: WideString); safecall;
    function Get_Relief: WideString; safecall;
    procedure Set_Relief(const Value: WideString); safecall;
    function Get_Play_dm: WideString; safecall;
    procedure Set_Play_dm(const Value: WideString); safecall;
    procedure Play_Tick; safecall;
    procedure Hide_Map; safecall;
    function Get_isMoving: WordBool; safecall;
    procedure Set_isMoving(Value: WordBool); safecall;
    function Get_WindowTool: Integer; safecall;
    procedure Set_WindowTool(Value: Integer); safecall;
    function Get_Where_Is: WordBool; safecall;
    procedure Set_Where_Is(Value: WordBool); safecall;
    function Get_Where_xy: Integer; safecall;
    procedure Set_Where_xy(Value: Integer); safecall;
    procedure Azimuth(gx: Double; gy: Double; pps: Integer); safecall;
    procedure Port_w_h(w: Integer; h: Integer); safecall;
    procedure Info_Object(p: Integer; out rc: WordBool); safecall;
    procedure Draw_Object(p: Integer); safecall;
    procedure Hide_Object(p: Integer); safecall;
    procedure Free_Object; safecall;
    procedure Move_Object(p: Integer; dx: Integer; dy: Integer); safecall;
    procedure Move_Sign(p: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer); safecall;
    procedure Insert_Sign(Code: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer); safecall;
    procedure Menu_Object(iCode: Integer; iLoc: Integer; out Code: Integer; out Loc: Integer; 
                          out Name: WideString); safecall;
    procedure Show_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer); safecall;
    procedure Show_Point(gx: Double; gy: Double; scale: Double); safecall;
    procedure Show_Object(p: Integer; scale: Double); safecall;
    procedure Show_Link(id: Integer; scale: Double); safecall;
    procedure Show_Centre(cx: Double; cy: Double; scale: Double; pps: Integer); safecall;
    procedure Get_Window(out x1: Integer; out y1: Integer; out x2: Integer; out y2: Integer); safecall;
    procedure Get_Centre(out gx: Double; out gy: Double; out scale: Double); safecall;
    procedure Link_Object(p: Integer; out id: Integer); safecall;
    procedure Offs_Object(id: Integer; out ofs: Integer); safecall;
    procedure ext_Disp_Object(cn: Integer; id: Integer; scale: Double); safecall;
    procedure str_Disp_Object(const ptr: WideString; scale: Double); safecall;
    procedure xDraw_Object(const FName: WideString; cn: Integer; id: Integer; show: WordBool); safecall;
    procedure Print_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer); safecall;
    procedure KeyTransit(Key: Integer; out rc: Integer); safecall;
    procedure Set_Code_Chars(Param1: Double); safecall;
    function Get_Draw_DC: Integer; safecall;
    procedure Release_dc(dc: Integer); safecall;
    procedure DC_Undo(x: Integer; y: Integer; w: Integer; h: Integer); safecall;
    procedure DC_Project(vx: Integer; vy: Integer; out dc_x: Integer; out dc_y: Integer); safecall;
    procedure DC_Backup(dc_x: Integer; dc_y: Integer; out vx: Integer; out vy: Integer); safecall;
    procedure dm_Project(vx: Double; vy: Double; pps: Integer; out dc_x: Integer; out dc_y: Integer); safecall;
    procedure dm_Backup(dc_x: Integer; dc_y: Integer; out vx: Double; out vy: Double; 
                        out pps: Integer); safecall;
    procedure l_to_g(ix: Integer; iy: Integer; out gx: Double; out gy: Double); safecall;
    procedure g_to_l(gx: Double; gy: Double; out ix: Integer; out iy: Integer); safecall;
    procedure l_to_x(ix: Integer; iy: Integer; out gx: Double; out gy: Double; out pps: Integer); safecall;
    procedure x_to_l(gx: Double; gy: Double; pps: Integer; out lx: Integer; out ly: Integer); safecall;
    procedure XY_BL(x: Double; y: Double; out b: Double; out l: Double); safecall;
    procedure BL_XY(b: Double; l: Double; out x: Double; out y: Double); safecall;
    procedure dm_to_pcx(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer); safecall;
    procedure pcx_to_dm(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer); safecall;
    procedure pcx_Project(x: Integer; y: Integer; out dc_x: Integer; out dc_y: Integer); safecall;
    procedure ext_Draft(x1: Integer; y1: Integer; x2: Integer; y2: Integer; show: Integer); safecall;
    function Get_win_Objects_Visible: WordBool; safecall;
    procedure Set_win_Objects_Visible(Value: WordBool); safecall;
    function Get_View_Objects_Count: Integer; safecall;
    procedure View_Objects(i: Integer; out p: Integer); safecall;
    function Get_OccupeA: Integer; safecall;
    procedure Set_OccupeA(Value: Integer); safecall;
    function Get_OccupeB: Integer; safecall;
    procedure Set_OccupeB(Value: Integer); safecall;
    procedure SetParams(const Key: WideString; const Value: WideString); safecall;
    procedure dlg_Options; safecall;
    procedure dlg_Ground; safecall;
    procedure dlg_Object; safecall;
    procedure dlg_Layers; safecall;
    procedure dlg_project; safecall;
    procedure dlg_Print; safecall;
    procedure dlg_Palette; safecall;
    procedure trf_position(const FName: WideString; APosition: Integer; AColor: Integer); safecall;
    procedure lab_draft(x: Integer; y: Integer); safecall;
    procedure Lotsia(const chm: WideString; const htm: WideString; const dm: WideString); safecall;
    procedure dlg_legend(const FName: WideString; iCode: Integer; iLoc: Integer; out Code: Integer; 
                         out Loc: Integer; out Name: WideString); safecall;
    procedure dlg_info(const dm: WideString; ptr: Integer); safecall;
    function Get_North: Integer; safecall;
    procedure Set_North(Value: Integer); safecall;
    procedure Marker(qx: Double; qy: Double; px: Double; py: Double; flags: Integer; fi: Integer; 
                     df: Integer; out rc: Integer); safecall;
    procedure dlg_Attr; safecall;
    procedure xShow_window(x1: Integer; y1: Integer; x2: Integer; y2: Integer; out gx: Double; 
                           out gy: Double; out scale: Double); safecall;
    procedure GetIValue(const Key: WideString; out Value: Integer); safecall;
    procedure Exec(const Cmd: WideString; const Value: WideString); safecall;
    procedure Get_sys7(out pps: Integer; out prj: Integer; out elp: Integer; out b1: Double; 
                       out b2: Double; out lc: Double; out dx: Double; out dy: Double; 
                       out dz: Double; out wx: Double; out wy: Double; out wz: Double; out m: Double); safecall;
    procedure drawVector(id: Integer; Loc: Integer; Color: Integer; Info: Integer; 
                         const mf: WideString; const txt: WideString); safecall;
    procedure Get_gz(gx: Double; gy: Double; pps: Integer; elp: Integer; out gz: Integer); safecall;
    procedure GetSValue(const Key: WideString; out str: WideString); safecall;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property AutoScroll: WordBool read Get_AutoScroll write Set_AutoScroll;
    property AutoSize: WordBool read Get_AutoSize write Set_AutoSize;
    property AxBorderStyle: TxActiveFormBorderStyle read Get_AxBorderStyle write Set_AxBorderStyle;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Color: OLE_COLOR read Get_Color write Set_Color;
    property Font: IFontDisp read Get_Font write Set_Font;
    property KeyPreview: WordBool read Get_KeyPreview write Set_KeyPreview;
    property PixelsPerInch: Integer read Get_PixelsPerInch write Set_PixelsPerInch;
    property PrintScale: TxPrintScale read Get_PrintScale write Set_PrintScale;
    property Scaled: WordBool read Get_Scaled write Set_Scaled;
    property Active: WordBool read Get_Active;
    property DropTarget: WordBool read Get_DropTarget write Set_DropTarget;
    property HelpFile: WideString read Get_HelpFile write Set_HelpFile;
    property ScreenSnap: WordBool read Get_ScreenSnap write Set_ScreenSnap;
    property SnapBuffer: Integer read Get_SnapBuffer write Set_SnapBuffer;
    property DoubleBuffered: WordBool read Get_DoubleBuffered write Set_DoubleBuffered;
    property AlignDisabled: WordBool read Get_AlignDisabled;
    property VisibleDockClientCount: Integer read Get_VisibleDockClientCount;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property App_Handle: Integer write Set_App_Handle;
    property Bin_Dir: WideString read Get_Bin_Dir write Set_Bin_Dir;
    property Project: WideString read Get_Project write Set_Project;
    property Active_Map: WideString read Get_Active_Map write Set_Active_Map;
    property Maps_Count: Integer read Get_Maps_Count;
    property Alt_Project: WideString read Get_Alt_Project;
    property Image: WideString read Get_Image write Set_Image;
    property Relief: WideString read Get_Relief write Set_Relief;
    property Play_dm: WideString read Get_Play_dm write Set_Play_dm;
    property isMoving: WordBool read Get_isMoving write Set_isMoving;
    property WindowTool: Integer read Get_WindowTool write Set_WindowTool;
    property Where_Is: WordBool read Get_Where_Is write Set_Where_Is;
    property Where_xy: Integer read Get_Where_xy write Set_Where_xy;
    property Code_Chars: Double write Set_Code_Chars;
    property Draw_DC: Integer read Get_Draw_DC;
    property win_Objects_Visible: WordBool read Get_win_Objects_Visible write Set_win_Objects_Visible;
    property View_Objects_Count: Integer read Get_View_Objects_Count;
    property OccupeA: Integer read Get_OccupeA write Set_OccupeA;
    property OccupeB: Integer read Get_OccupeB write Set_OccupeB;
    property North: Integer read Get_North write Set_North;
  end;

// *********************************************************************//
// DispIntf:  IDmxActiveXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A66FC1CA-D4C7-457C-8F5A-F1911C9F81B5}
// *********************************************************************//
  IDmxActiveXDisp = dispinterface
    ['{A66FC1CA-D4C7-457C-8F5A-F1911C9F81B5}']
    property Visible: WordBool dispid 201;
    property AutoScroll: WordBool dispid 202;
    property AutoSize: WordBool dispid 203;
    property AxBorderStyle: TxActiveFormBorderStyle dispid 204;
    property Caption: WideString dispid -518;
    property Color: OLE_COLOR dispid -501;
    property Font: IFontDisp dispid -512;
    property KeyPreview: WordBool dispid 205;
    property PixelsPerInch: Integer dispid 206;
    property PrintScale: TxPrintScale dispid 207;
    property Scaled: WordBool dispid 208;
    property Active: WordBool readonly dispid 209;
    property DropTarget: WordBool dispid 210;
    property HelpFile: WideString dispid 211;
    property ScreenSnap: WordBool dispid 212;
    property SnapBuffer: Integer dispid 213;
    property DoubleBuffered: WordBool dispid 214;
    property AlignDisabled: WordBool readonly dispid 215;
    property VisibleDockClientCount: Integer readonly dispid 216;
    property Enabled: WordBool dispid -514;
    property App_Handle: Integer writeonly dispid 1;
    property Bin_Dir: WideString dispid 2;
    property Project: WideString dispid 3;
    property Active_Map: WideString dispid 4;
    property Maps_Count: Integer readonly dispid 5;
    property Alt_Project: WideString readonly dispid 6;
    procedure Save_Project(const FName: WideString); dispid 7;
    procedure New_Project(const FName: WideString); dispid 8;
    procedure Cls_Project; dispid 9;
    procedure Project_Map(i: Integer; out FName: WideString); dispid 10;
    procedure Map_Contains(x: Integer; y: Integer; out FName: WideString); dispid 11;
    procedure Insert_Map(const FName: WideString); dispid 12;
    procedure Delete_Map(const FName: WideString); dispid 13;
    procedure prj_Add_Map(const FName: WideString; lev1: Integer; lev2: Integer); dispid 14;
    procedure prj_Contains_Map(const FName: WideString; out Ind: Integer); dispid 15;
    property Image: WideString dispid 16;
    property Relief: WideString dispid 17;
    property Play_dm: WideString dispid 18;
    procedure Play_Tick; dispid 19;
    procedure Hide_Map; dispid 20;
    property isMoving: WordBool dispid 22;
    property WindowTool: Integer dispid 23;
    property Where_Is: WordBool dispid 24;
    property Where_xy: Integer dispid 25;
    procedure Azimuth(gx: Double; gy: Double; pps: Integer); dispid 26;
    procedure Port_w_h(w: Integer; h: Integer); dispid 28;
    procedure Info_Object(p: Integer; out rc: WordBool); dispid 29;
    procedure Draw_Object(p: Integer); dispid 30;
    procedure Hide_Object(p: Integer); dispid 31;
    procedure Free_Object; dispid 32;
    procedure Move_Object(p: Integer; dx: Integer; dy: Integer); dispid 33;
    procedure Move_Sign(p: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 34;
    procedure Insert_Sign(Code: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 35;
    procedure Menu_Object(iCode: Integer; iLoc: Integer; out Code: Integer; out Loc: Integer; 
                          out Name: WideString); dispid 36;
    procedure Show_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 37;
    procedure Show_Point(gx: Double; gy: Double; scale: Double); dispid 38;
    procedure Show_Object(p: Integer; scale: Double); dispid 39;
    procedure Show_Link(id: Integer; scale: Double); dispid 40;
    procedure Show_Centre(cx: Double; cy: Double; scale: Double; pps: Integer); dispid 41;
    procedure Get_Window(out x1: Integer; out y1: Integer; out x2: Integer; out y2: Integer); dispid 42;
    procedure Get_Centre(out gx: Double; out gy: Double; out scale: Double); dispid 43;
    procedure Link_Object(p: Integer; out id: Integer); dispid 44;
    procedure Offs_Object(id: Integer; out ofs: Integer); dispid 45;
    procedure ext_Disp_Object(cn: Integer; id: Integer; scale: Double); dispid 46;
    procedure str_Disp_Object(const ptr: WideString; scale: Double); dispid 47;
    procedure xDraw_Object(const FName: WideString; cn: Integer; id: Integer; show: WordBool); dispid 48;
    procedure Print_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 49;
    procedure KeyTransit(Key: Integer; out rc: Integer); dispid 50;
    property Code_Chars: Double writeonly dispid 51;
    property Draw_DC: Integer readonly dispid 52;
    procedure Release_dc(dc: Integer); dispid 53;
    procedure DC_Undo(x: Integer; y: Integer; w: Integer; h: Integer); dispid 54;
    procedure DC_Project(vx: Integer; vy: Integer; out dc_x: Integer; out dc_y: Integer); dispid 55;
    procedure DC_Backup(dc_x: Integer; dc_y: Integer; out vx: Integer; out vy: Integer); dispid 56;
    procedure dm_Project(vx: Double; vy: Double; pps: Integer; out dc_x: Integer; out dc_y: Integer); dispid 57;
    procedure dm_Backup(dc_x: Integer; dc_y: Integer; out vx: Double; out vy: Double; 
                        out pps: Integer); dispid 58;
    procedure l_to_g(ix: Integer; iy: Integer; out gx: Double; out gy: Double); dispid 60;
    procedure g_to_l(gx: Double; gy: Double; out ix: Integer; out iy: Integer); dispid 61;
    procedure l_to_x(ix: Integer; iy: Integer; out gx: Double; out gy: Double; out pps: Integer); dispid 62;
    procedure x_to_l(gx: Double; gy: Double; pps: Integer; out lx: Integer; out ly: Integer); dispid 63;
    procedure XY_BL(x: Double; y: Double; out b: Double; out l: Double); dispid 64;
    procedure BL_XY(b: Double; l: Double; out x: Double; out y: Double); dispid 65;
    procedure dm_to_pcx(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer); dispid 66;
    procedure pcx_to_dm(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer); dispid 67;
    procedure pcx_Project(x: Integer; y: Integer; out dc_x: Integer; out dc_y: Integer); dispid 68;
    procedure ext_Draft(x1: Integer; y1: Integer; x2: Integer; y2: Integer; show: Integer); dispid 69;
    property win_Objects_Visible: WordBool dispid 72;
    property View_Objects_Count: Integer readonly dispid 73;
    procedure View_Objects(i: Integer; out p: Integer); dispid 74;
    property OccupeA: Integer dispid 75;
    property OccupeB: Integer dispid 76;
    procedure SetParams(const Key: WideString; const Value: WideString); dispid 80;
    procedure dlg_Options; dispid 96;
    procedure dlg_Ground; dispid 97;
    procedure dlg_Object; dispid 98;
    procedure dlg_Layers; dispid 99;
    procedure dlg_project; dispid 100;
    procedure dlg_Print; dispid 101;
    procedure dlg_Palette; dispid 220;
    procedure trf_position(const FName: WideString; APosition: Integer; AColor: Integer); dispid 217;
    procedure lab_draft(x: Integer; y: Integer); dispid 218;
    procedure Lotsia(const chm: WideString; const htm: WideString; const dm: WideString); dispid 219;
    procedure dlg_legend(const FName: WideString; iCode: Integer; iLoc: Integer; out Code: Integer; 
                         out Loc: Integer; out Name: WideString); dispid 221;
    procedure dlg_info(const dm: WideString; ptr: Integer); dispid 222;
    property North: Integer dispid 223;
    procedure Marker(qx: Double; qy: Double; px: Double; py: Double; flags: Integer; fi: Integer; 
                     df: Integer; out rc: Integer); dispid 224;
    procedure dlg_Attr; dispid 225;
    procedure xShow_window(x1: Integer; y1: Integer; x2: Integer; y2: Integer; out gx: Double; 
                           out gy: Double; out scale: Double); dispid 226;
    procedure GetIValue(const Key: WideString; out Value: Integer); dispid 227;
    procedure Exec(const Cmd: WideString; const Value: WideString); dispid 228;
    procedure Get_sys7(out pps: Integer; out prj: Integer; out elp: Integer; out b1: Double; 
                       out b2: Double; out lc: Double; out dx: Double; out dy: Double; 
                       out dz: Double; out wx: Double; out wy: Double; out wz: Double; out m: Double); dispid 229;
    procedure drawVector(id: Integer; Loc: Integer; Color: Integer; Info: Integer; 
                         const mf: WideString; const txt: WideString); dispid 230;
    procedure Get_gz(gx: Double; gy: Double; pps: Integer; elp: Integer; out gz: Integer); dispid 231;
    procedure GetSValue(const Key: WideString; out str: WideString); dispid 232;
  end;

// *********************************************************************//
// DispIntf:  IDmxActiveXEvents
// Flags:     (4096) Dispatchable
// GUID:      {76FD0BF4-65DA-4DC7-BA83-77B1EA271E18}
// *********************************************************************//
  IDmxActiveXEvents = dispinterface
    ['{76FD0BF4-65DA-4DC7-BA83-77B1EA271E18}']
    procedure OnActivate; dispid 201;
    procedure OnClick; dispid 202;
    procedure OnCreate; dispid 203;
    procedure OnDblClick; dispid 204;
    procedure OnDestroy; dispid 205;
    procedure OnDeactivate; dispid 206;
    procedure OnKeyPress(var Key: Smallint); dispid 207;
    procedure OnPaint; dispid 208;
    procedure OnCursor(ix: Integer; iy: Integer; gx: Double; gy: Double); dispid 9;
    procedure OnPoint(ix: Integer; iy: Integer; gx: Double; gy: Double); dispid 10;
    procedure OnVector(x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 11;
    procedure OnRect(x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 12;
    procedure OnPort(x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 13;
    procedure OnRing(x1: Integer; y1: Integer; x2: Integer; y2: Integer); dispid 14;
    procedure OnPoly(const lp: WideString); dispid 15;
    procedure OnObject(offs: Integer; id: Integer; Code: Integer; Loc: Integer; x1: Integer; 
                       y1: Integer; x2: Integer; y2: Integer); dispid 16;
    procedure OnCancel; dispid 17;
    procedure OnMap(const FName: WideString; out rc: WordBool); dispid 18;
    procedure OnScale(cx: Double; cy: Double; sc: Double; pps: Integer; out rc: WordBool); dispid 19;
    procedure OnDraw(cx: Double; cy: Double; sc: Double; pps: Integer); dispid 20;
    procedure OnEdit(p: Integer; id: Integer; Cmd: Integer); dispid 21;
    procedure OnXY_BL(x: Double; y: Double; out b: Double; out l: Double; out pps: SYSINT); dispid 22;
    procedure OnLocate(cx: Double; cy: Double; pps: Integer; out rc: WordBool); dispid 23;
    procedure OnNext(cx: Double; cy: Double; pps: Integer; out rc: WordBool); dispid 24;
    procedure OnMoveDown(var cx: Double; var cy: Double; pps: Integer; out ok: HResult); dispid 25;
    procedure OnMoveUp(cx: Double; cy: Double; pps: Integer); dispid 26;
    procedure OnDraft(x1: Integer; y1: Integer; z1: Integer; x2: Integer; y2: Integer; z2: Integer); dispid 27;
    procedure OnMouseDown(offs: Integer; id: Integer; Code: Integer; Loc: Integer; cx: Double; 
                          cy: Double; pps: Integer); dispid 28;
    procedure OnPopup(cx: Double; cy: Double; pps: Integer); dispid 29;
    procedure OnPunktDn(cx: Double; cy: Double; res: Double; out px: Double; out py: Double; 
                        out id: Integer); dispid 31;
    procedure OnPunktUp(cx: Double; cy: Double; cz: Double; id: Integer; bt: Integer); dispid 32;
    procedure OnTools(Visible: WordBool); dispid 30;
    procedure OnObjects(Visible: WordBool); dispid 33;
    procedure OnPair(p1: Integer; p2: Integer; code1: Integer; loc1: Integer; code2: Integer; 
                     loc2: Integer); dispid 209;
    procedure OnRefresh(dc: Integer; cx: Double; cy: Double; sc: Double; pps: Integer); dispid 210;
    procedure OnInvalidate(dc: Integer; cx: Double; cy: Double; sc: Double; pps: Integer); dispid 211;
    procedure OnOccupe(offs: Integer; id: Integer; Code: Integer; Loc: Integer; 
                       const Name: WideString); dispid 212;
    procedure OnMovePos(cx: Double; cy: Double; pps: Integer; out rc: HResult); dispid 213;
    procedure OnKeyDown(Key: Integer; Shift: Integer; out rc: HResult); dispid 214;
    procedure OnPunktSel(var id: Integer); dispid 215;
    procedure OnBackground(dc: Integer; cx: Double; cy: Double; sc: Double; pps: Integer); dispid 216;
    procedure OnButt(id: Integer); dispid 217;
  end;

// *********************************************************************//
// Interface: IDmxTools
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FB65EA72-4BB2-4953-9E95-5E1201DFA419}
// *********************************************************************//
  IDmxTools = interface(IDispatch)
    ['{FB65EA72-4BB2-4953-9E95-5E1201DFA419}']
    function Get_Tools_Visible: WordBool; safecall;
    procedure Set_Tools_Visible(Value: WordBool); safecall;
    procedure Tools_Default; safecall;
    procedure Tools_Add_Page(const Value: WideString); safecall;
    procedure Tools_Delete_Page; safecall;
    procedure Tools_Clear_Page; safecall;
    procedure Tools_Add_Tool(Value: Integer); safecall;
    procedure Tools_Delete_Tool(Value: Integer); safecall;
    procedure Tools_Clear; safecall;
    function Get_Tools_Page: Integer; safecall;
    procedure Set_Tools_Page(Value: Integer); safecall;
    procedure Tools_LoadFrom(const Path: WideString); safecall;
    procedure Tools_SaveAs(const Path: WideString); safecall;
    procedure Tools_Edit; safecall;
    property Tools_Visible: WordBool read Get_Tools_Visible write Set_Tools_Visible;
    property Tools_Page: Integer read Get_Tools_Page write Set_Tools_Page;
  end;

// *********************************************************************//
// DispIntf:  IDmxToolsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FB65EA72-4BB2-4953-9E95-5E1201DFA419}
// *********************************************************************//
  IDmxToolsDisp = dispinterface
    ['{FB65EA72-4BB2-4953-9E95-5E1201DFA419}']
    property Tools_Visible: WordBool dispid 1;
    procedure Tools_Default; dispid 2;
    procedure Tools_Add_Page(const Value: WideString); dispid 3;
    procedure Tools_Delete_Page; dispid 6;
    procedure Tools_Clear_Page; dispid 5;
    procedure Tools_Add_Tool(Value: Integer); dispid 4;
    procedure Tools_Delete_Tool(Value: Integer); dispid 7;
    procedure Tools_Clear; dispid 8;
    property Tools_Page: Integer dispid 9;
    procedure Tools_LoadFrom(const Path: WideString); dispid 10;
    procedure Tools_SaveAs(const Path: WideString); dispid 11;
    procedure Tools_Edit; dispid 12;
  end;

// *********************************************************************//
// Interface: IDmxLink
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C712C7D7-974C-4D8D-90EF-77F22DA4C6B7}
// *********************************************************************//
  IDmxLink = interface(IDispatch)
    ['{C712C7D7-974C-4D8D-90EF-77F22DA4C6B7}']
    function Get_Count: Integer; safecall;
    procedure AddPoint(ix: Double; iy: Double; gx: Double; gy: Double); safecall;
    procedure DelPoint(Ind: Integer); safecall;
    procedure MovPoint(Ind: Integer; ix: Double; iy: Double; gx: Double; gy: Double); safecall;
    procedure GetPoint(Ind: Integer; out ix: Double; out iy: Double; out gx: Double; out gy: Double); safecall;
    function Get_UndoCount: Integer; safecall;
    procedure UndoApply(out rc: Integer); safecall;
    procedure GetSys(out elp: Integer; out prj: Integer; out b1: Double; out b2: Double; 
                     out lc: Double); safecall;
    procedure SetSys(elp: Integer; prj: Integer; b1: Double; b2: Double; lc: Double); safecall;
    property Count: Integer read Get_Count;
    property UndoCount: Integer read Get_UndoCount;
  end;

// *********************************************************************//
// DispIntf:  IDmxLinkDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C712C7D7-974C-4D8D-90EF-77F22DA4C6B7}
// *********************************************************************//
  IDmxLinkDisp = dispinterface
    ['{C712C7D7-974C-4D8D-90EF-77F22DA4C6B7}']
    property Count: Integer readonly dispid 201;
    procedure AddPoint(ix: Double; iy: Double; gx: Double; gy: Double); dispid 202;
    procedure DelPoint(Ind: Integer); dispid 203;
    procedure MovPoint(Ind: Integer; ix: Double; iy: Double; gx: Double; gy: Double); dispid 204;
    procedure GetPoint(Ind: Integer; out ix: Double; out iy: Double; out gx: Double; out gy: Double); dispid 205;
    property UndoCount: Integer readonly dispid 206;
    procedure UndoApply(out rc: Integer); dispid 207;
    procedure GetSys(out elp: Integer; out prj: Integer; out b1: Double; out b2: Double; 
                     out lc: Double); dispid 208;
    procedure SetSys(elp: Integer; prj: Integer; b1: Double; b2: Double; lc: Double); dispid 209;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TDmxActiveX
// Help String      : DmxActiveX Control
// Default Interface: IDmxActiveX
// Def. Intf. DISP? : No
// Event   Interface: IDmxActiveXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TDmxActiveXOnKeyPress = procedure(ASender: TObject; var Key: Smallint) of object;
  TDmxActiveXOnCursor = procedure(ASender: TObject; ix: Integer; iy: Integer; gx: Double; gy: Double) of object;
  TDmxActiveXOnPoint = procedure(ASender: TObject; ix: Integer; iy: Integer; gx: Double; gy: Double) of object;
  TDmxActiveXOnVector = procedure(ASender: TObject; x1: Integer; y1: Integer; x2: Integer; 
                                                    y2: Integer) of object;
  TDmxActiveXOnRect = procedure(ASender: TObject; x1: Integer; y1: Integer; x2: Integer; y2: Integer) of object;
  TDmxActiveXOnPort = procedure(ASender: TObject; x1: Integer; y1: Integer; x2: Integer; y2: Integer) of object;
  TDmxActiveXOnRing = procedure(ASender: TObject; x1: Integer; y1: Integer; x2: Integer; y2: Integer) of object;
  TDmxActiveXOnPoly = procedure(ASender: TObject; const lp: WideString) of object;
  TDmxActiveXOnObject = procedure(ASender: TObject; offs: Integer; id: Integer; Code: Integer; 
                                                    Loc: Integer; x1: Integer; y1: Integer; 
                                                    x2: Integer; y2: Integer) of object;
  TDmxActiveXOnMap = procedure(ASender: TObject; const FName: WideString; out rc: WordBool) of object;
  TDmxActiveXOnScale = procedure(ASender: TObject; cx: Double; cy: Double; sc: Double; 
                                                   pps: Integer; out rc: WordBool) of object;
  TDmxActiveXOnDraw = procedure(ASender: TObject; cx: Double; cy: Double; sc: Double; pps: Integer) of object;
  TDmxActiveXOnEdit = procedure(ASender: TObject; p: Integer; id: Integer; Cmd: Integer) of object;
  TDmxActiveXOnXY_BL = procedure(ASender: TObject; x: Double; y: Double; out b: Double; 
                                                   out l: Double; out pps: SYSINT) of object;
  TDmxActiveXOnLocate = procedure(ASender: TObject; cx: Double; cy: Double; pps: Integer; 
                                                    out rc: WordBool) of object;
  TDmxActiveXOnNext = procedure(ASender: TObject; cx: Double; cy: Double; pps: Integer; 
                                                  out rc: WordBool) of object;
  TDmxActiveXOnMoveDown = procedure(ASender: TObject; var cx: Double; var cy: Double; pps: Integer; 
                                                      out ok: HResult) of object;
  TDmxActiveXOnMoveUp = procedure(ASender: TObject; cx: Double; cy: Double; pps: Integer) of object;
  TDmxActiveXOnDraft = procedure(ASender: TObject; x1: Integer; y1: Integer; z1: Integer; 
                                                   x2: Integer; y2: Integer; z2: Integer) of object;
  TDmxActiveXOnMouseDown = procedure(ASender: TObject; offs: Integer; id: Integer; Code: Integer; 
                                                       Loc: Integer; cx: Double; cy: Double; 
                                                       pps: Integer) of object;
  TDmxActiveXOnPopup = procedure(ASender: TObject; cx: Double; cy: Double; pps: Integer) of object;
  TDmxActiveXOnPunktDn = procedure(ASender: TObject; cx: Double; cy: Double; res: Double; 
                                                     out px: Double; out py: Double; out id: Integer) of object;
  TDmxActiveXOnPunktUp = procedure(ASender: TObject; cx: Double; cy: Double; cz: Double; 
                                                     id: Integer; bt: Integer) of object;
  TDmxActiveXOnTools = procedure(ASender: TObject; Visible: WordBool) of object;
  TDmxActiveXOnObjects = procedure(ASender: TObject; Visible: WordBool) of object;
  TDmxActiveXOnPair = procedure(ASender: TObject; p1: Integer; p2: Integer; code1: Integer; 
                                                  loc1: Integer; code2: Integer; loc2: Integer) of object;
  TDmxActiveXOnRefresh = procedure(ASender: TObject; dc: Integer; cx: Double; cy: Double; 
                                                     sc: Double; pps: Integer) of object;
  TDmxActiveXOnInvalidate = procedure(ASender: TObject; dc: Integer; cx: Double; cy: Double; 
                                                        sc: Double; pps: Integer) of object;
  TDmxActiveXOnOccupe = procedure(ASender: TObject; offs: Integer; id: Integer; Code: Integer; 
                                                    Loc: Integer; const Name: WideString) of object;
  TDmxActiveXOnMovePos = procedure(ASender: TObject; cx: Double; cy: Double; pps: Integer; 
                                                     out rc: HResult) of object;
  TDmxActiveXOnKeyDown = procedure(ASender: TObject; Key: Integer; Shift: Integer; out rc: HResult) of object;
  TDmxActiveXOnPunktSel = procedure(ASender: TObject; var id: Integer) of object;
  TDmxActiveXOnBackground = procedure(ASender: TObject; dc: Integer; cx: Double; cy: Double; 
                                                        sc: Double; pps: Integer) of object;
  TDmxActiveXOnButt = procedure(ASender: TObject; id: Integer) of object;

  TDmxActiveX = class(TOleControl)
  private
    FOnActivate: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnCreate: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;
    FOnKeyPress: TDmxActiveXOnKeyPress;
    FOnPaint: TNotifyEvent;
    FOnCursor: TDmxActiveXOnCursor;
    FOnPoint: TDmxActiveXOnPoint;
    FOnVector: TDmxActiveXOnVector;
    FOnRect: TDmxActiveXOnRect;
    FOnPort: TDmxActiveXOnPort;
    FOnRing: TDmxActiveXOnRing;
    FOnPoly: TDmxActiveXOnPoly;
    FOnObject: TDmxActiveXOnObject;
    FOnCancel: TNotifyEvent;
    FOnMap: TDmxActiveXOnMap;
    FOnScale: TDmxActiveXOnScale;
    FOnDraw: TDmxActiveXOnDraw;
    FOnEdit: TDmxActiveXOnEdit;
    FOnXY_BL: TDmxActiveXOnXY_BL;
    FOnLocate: TDmxActiveXOnLocate;
    FOnNext: TDmxActiveXOnNext;
    FOnMoveDown: TDmxActiveXOnMoveDown;
    FOnMoveUp: TDmxActiveXOnMoveUp;
    FOnDraft: TDmxActiveXOnDraft;
    FOnMouseDown: TDmxActiveXOnMouseDown;
    FOnPopup: TDmxActiveXOnPopup;
    FOnPunktDn: TDmxActiveXOnPunktDn;
    FOnPunktUp: TDmxActiveXOnPunktUp;
    FOnTools: TDmxActiveXOnTools;
    FOnObjects: TDmxActiveXOnObjects;
    FOnPair: TDmxActiveXOnPair;
    FOnRefresh: TDmxActiveXOnRefresh;
    FOnInvalidate: TDmxActiveXOnInvalidate;
    FOnOccupe: TDmxActiveXOnOccupe;
    FOnMovePos: TDmxActiveXOnMovePos;
    FOnKeyDown: TDmxActiveXOnKeyDown;
    FOnPunktSel: TDmxActiveXOnPunktSel;
    FOnBackground: TDmxActiveXOnBackground;
    FOnButt: TDmxActiveXOnButt;
    FIntf: IDmxActiveX;
    function  GetControlInterface: IDmxActiveX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Save_Project(const FName: WideString);
    procedure New_Project(const FName: WideString);
    procedure Cls_Project;
    procedure Project_Map(i: Integer; out FName: WideString);
    procedure Map_Contains(x: Integer; y: Integer; out FName: WideString);
    procedure Insert_Map(const FName: WideString);
    procedure Delete_Map(const FName: WideString);
    procedure prj_Add_Map(const FName: WideString; lev1: Integer; lev2: Integer);
    procedure prj_Contains_Map(const FName: WideString; out Ind: Integer);
    procedure Play_Tick;
    procedure Hide_Map;
    procedure Azimuth(gx: Double; gy: Double; pps: Integer);
    procedure Port_w_h(w: Integer; h: Integer);
    procedure Info_Object(p: Integer; out rc: WordBool);
    procedure Draw_Object(p: Integer);
    procedure Hide_Object(p: Integer);
    procedure Free_Object;
    procedure Move_Object(p: Integer; dx: Integer; dy: Integer);
    procedure Move_Sign(p: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer);
    procedure Insert_Sign(Code: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer);
    procedure Menu_Object(iCode: Integer; iLoc: Integer; out Code: Integer; out Loc: Integer; 
                          out Name: WideString);
    procedure Show_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer);
    procedure Show_Point(gx: Double; gy: Double; scale: Double);
    procedure Show_Object(p: Integer; scale: Double);
    procedure Show_Link(id: Integer; scale: Double);
    procedure Show_Centre(cx: Double; cy: Double; scale: Double; pps: Integer);
    procedure Get_Window(out x1: Integer; out y1: Integer; out x2: Integer; out y2: Integer);
    procedure Get_Centre(out gx: Double; out gy: Double; out scale: Double);
    procedure Link_Object(p: Integer; out id: Integer);
    procedure Offs_Object(id: Integer; out ofs: Integer);
    procedure ext_Disp_Object(cn: Integer; id: Integer; scale: Double);
    procedure str_Disp_Object(const ptr: WideString; scale: Double);
    procedure xDraw_Object(const FName: WideString; cn: Integer; id: Integer; show: WordBool);
    procedure Print_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer);
    procedure KeyTransit(Key: Integer; out rc: Integer);
    procedure Release_dc(dc: Integer);
    procedure DC_Undo(x: Integer; y: Integer; w: Integer; h: Integer);
    procedure DC_Project(vx: Integer; vy: Integer; out dc_x: Integer; out dc_y: Integer);
    procedure DC_Backup(dc_x: Integer; dc_y: Integer; out vx: Integer; out vy: Integer);
    procedure dm_Project(vx: Double; vy: Double; pps: Integer; out dc_x: Integer; out dc_y: Integer);
    procedure dm_Backup(dc_x: Integer; dc_y: Integer; out vx: Double; out vy: Double; 
                        out pps: Integer);
    procedure l_to_g(ix: Integer; iy: Integer; out gx: Double; out gy: Double);
    procedure g_to_l(gx: Double; gy: Double; out ix: Integer; out iy: Integer);
    procedure l_to_x(ix: Integer; iy: Integer; out gx: Double; out gy: Double; out pps: Integer);
    procedure x_to_l(gx: Double; gy: Double; pps: Integer; out lx: Integer; out ly: Integer);
    procedure XY_BL(x: Double; y: Double; out b: Double; out l: Double);
    procedure BL_XY(b: Double; l: Double; out x: Double; out y: Double);
    procedure dm_to_pcx(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer);
    procedure pcx_to_dm(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer);
    procedure pcx_Project(x: Integer; y: Integer; out dc_x: Integer; out dc_y: Integer);
    procedure ext_Draft(x1: Integer; y1: Integer; x2: Integer; y2: Integer; show: Integer);
    procedure View_Objects(i: Integer; out p: Integer);
    procedure SetParams(const Key: WideString; const Value: WideString);
    procedure dlg_Options;
    procedure dlg_Ground;
    procedure dlg_Object;
    procedure dlg_Layers;
    procedure dlg_project;
    procedure dlg_Print;
    procedure dlg_Palette;
    procedure trf_position(const FName: WideString; APosition: Integer; AColor: Integer);
    procedure lab_draft(x: Integer; y: Integer);
    procedure Lotsia(const chm: WideString; const htm: WideString; const dm: WideString);
    procedure dlg_legend(const FName: WideString; iCode: Integer; iLoc: Integer; out Code: Integer; 
                         out Loc: Integer; out Name: WideString);
    procedure dlg_info(const dm: WideString; ptr: Integer);
    procedure Marker(qx: Double; qy: Double; px: Double; py: Double; flags: Integer; fi: Integer; 
                     df: Integer; out rc: Integer);
    procedure dlg_Attr;
    procedure xShow_window(x1: Integer; y1: Integer; x2: Integer; y2: Integer; out gx: Double; 
                           out gy: Double; out scale: Double);
    procedure GetIValue(const Key: WideString; out Value: Integer);
    procedure Exec(const Cmd: WideString; const Value: WideString);
    procedure Get_sys7(out pps: Integer; out prj: Integer; out elp: Integer; out b1: Double; 
                       out b2: Double; out lc: Double; out dx: Double; out dy: Double; 
                       out dz: Double; out wx: Double; out wy: Double; out wz: Double; out m: Double);
    procedure drawVector(id: Integer; Loc: Integer; Color: Integer; Info: Integer; 
                         const mf: WideString; const txt: WideString);
    procedure Get_gz(gx: Double; gy: Double; pps: Integer; elp: Integer; out gz: Integer);
    procedure GetSValue(const Key: WideString; out str: WideString);
    property  ControlInterface: IDmxActiveX read GetControlInterface;
    property  DefaultInterface: IDmxActiveX read GetControlInterface;
    property Visible: WordBool index 201 read GetWordBoolProp write SetWordBoolProp;
    property Active: WordBool index 209 read GetWordBoolProp;
    property DropTarget: WordBool index 210 read GetWordBoolProp write SetWordBoolProp;
    property HelpFile: WideString index 211 read GetWideStringProp write SetWideStringProp;
    property ScreenSnap: WordBool index 212 read GetWordBoolProp write SetWordBoolProp;
    property SnapBuffer: Integer index 213 read GetIntegerProp write SetIntegerProp;
    property DoubleBuffered: WordBool index 214 read GetWordBoolProp write SetWordBoolProp;
    property AlignDisabled: WordBool index 215 read GetWordBoolProp;
    property VisibleDockClientCount: Integer index 216 read GetIntegerProp;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp;
    property App_Handle: Integer index 1 write SetIntegerProp;
    property Maps_Count: Integer index 5 read GetIntegerProp;
    property Alt_Project: WideString index 6 read GetWideStringProp;
    property Code_Chars: Double index 51 write SetDoubleProp;
    property Draw_DC: Integer index 52 read GetIntegerProp;
    property View_Objects_Count: Integer index 73 read GetIntegerProp;
  published
    property Anchors;
    property  ParentColor;
    property  ParentFont;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property AutoScroll: WordBool index 202 read GetWordBoolProp write SetWordBoolProp stored False;
    property AutoSize: WordBool index 203 read GetWordBoolProp write SetWordBoolProp stored False;
    property AxBorderStyle: TOleEnum index 204 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Caption: WideString index -518 read GetWideStringProp write SetWideStringProp stored False;
    property Color: TColor index -501 read GetTColorProp write SetTColorProp stored False;
    property Font: TFont index -512 read GetTFontProp write SetTFontProp stored False;
    property KeyPreview: WordBool index 205 read GetWordBoolProp write SetWordBoolProp stored False;
    property PixelsPerInch: Integer index 206 read GetIntegerProp write SetIntegerProp stored False;
    property PrintScale: TOleEnum index 207 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Scaled: WordBool index 208 read GetWordBoolProp write SetWordBoolProp stored False;
    property Bin_Dir: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property Project: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property Active_Map: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property Image: WideString index 16 read GetWideStringProp write SetWideStringProp stored False;
    property Relief: WideString index 17 read GetWideStringProp write SetWideStringProp stored False;
    property Play_dm: WideString index 18 read GetWideStringProp write SetWideStringProp stored False;
    property isMoving: WordBool index 22 read GetWordBoolProp write SetWordBoolProp stored False;
    property WindowTool: Integer index 23 read GetIntegerProp write SetIntegerProp stored False;
    property Where_Is: WordBool index 24 read GetWordBoolProp write SetWordBoolProp stored False;
    property Where_xy: Integer index 25 read GetIntegerProp write SetIntegerProp stored False;
    property win_Objects_Visible: WordBool index 72 read GetWordBoolProp write SetWordBoolProp stored False;
    property OccupeA: Integer index 75 read GetIntegerProp write SetIntegerProp stored False;
    property OccupeB: Integer index 76 read GetIntegerProp write SetIntegerProp stored False;
    property North: Integer index 223 read GetIntegerProp write SetIntegerProp stored False;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnDeactivate: TNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnKeyPress: TDmxActiveXOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnCursor: TDmxActiveXOnCursor read FOnCursor write FOnCursor;
    property OnPoint: TDmxActiveXOnPoint read FOnPoint write FOnPoint;
    property OnVector: TDmxActiveXOnVector read FOnVector write FOnVector;
    property OnRect: TDmxActiveXOnRect read FOnRect write FOnRect;
    property OnPort: TDmxActiveXOnPort read FOnPort write FOnPort;
    property OnRing: TDmxActiveXOnRing read FOnRing write FOnRing;
    property OnPoly: TDmxActiveXOnPoly read FOnPoly write FOnPoly;
    property OnObject: TDmxActiveXOnObject read FOnObject write FOnObject;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnMap: TDmxActiveXOnMap read FOnMap write FOnMap;
    property OnScale: TDmxActiveXOnScale read FOnScale write FOnScale;
    property OnDraw: TDmxActiveXOnDraw read FOnDraw write FOnDraw;
    property OnEdit: TDmxActiveXOnEdit read FOnEdit write FOnEdit;
    property OnXY_BL: TDmxActiveXOnXY_BL read FOnXY_BL write FOnXY_BL;
    property OnLocate: TDmxActiveXOnLocate read FOnLocate write FOnLocate;
    property OnNext: TDmxActiveXOnNext read FOnNext write FOnNext;
    property OnMoveDown: TDmxActiveXOnMoveDown read FOnMoveDown write FOnMoveDown;
    property OnMoveUp: TDmxActiveXOnMoveUp read FOnMoveUp write FOnMoveUp;
    property OnDraft: TDmxActiveXOnDraft read FOnDraft write FOnDraft;
    property OnMouseDown: TDmxActiveXOnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnPopup: TDmxActiveXOnPopup read FOnPopup write FOnPopup;
    property OnPunktDn: TDmxActiveXOnPunktDn read FOnPunktDn write FOnPunktDn;
    property OnPunktUp: TDmxActiveXOnPunktUp read FOnPunktUp write FOnPunktUp;
    property OnTools: TDmxActiveXOnTools read FOnTools write FOnTools;
    property OnObjects: TDmxActiveXOnObjects read FOnObjects write FOnObjects;
    property OnPair: TDmxActiveXOnPair read FOnPair write FOnPair;
    property OnRefresh: TDmxActiveXOnRefresh read FOnRefresh write FOnRefresh;
    property OnInvalidate: TDmxActiveXOnInvalidate read FOnInvalidate write FOnInvalidate;
    property OnOccupe: TDmxActiveXOnOccupe read FOnOccupe write FOnOccupe;
    property OnMovePos: TDmxActiveXOnMovePos read FOnMovePos write FOnMovePos;
    property OnKeyDown: TDmxActiveXOnKeyDown read FOnKeyDown write FOnKeyDown;
    property OnPunktSel: TDmxActiveXOnPunktSel read FOnPunktSel write FOnPunktSel;
    property OnBackground: TDmxActiveXOnBackground read FOnBackground write FOnBackground;
    property OnButt: TDmxActiveXOnButt read FOnButt write FOnButt;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'WebServices';

  dtlOcxPage = 'WebServices';

implementation

uses ComObj;

procedure TDmxActiveX.InitControlData;
const
  CEventDispIDs: array [0..41] of DWORD = (
    $000000C9, $000000CA, $000000CB, $000000CC, $000000CD, $000000CE,
    $000000CF, $000000D0, $00000009, $0000000A, $0000000B, $0000000C,
    $0000000D, $0000000E, $0000000F, $00000010, $00000011, $00000012,
    $00000013, $00000014, $00000015, $00000016, $00000017, $00000018,
    $00000019, $0000001A, $0000001B, $0000001C, $0000001D, $0000001F,
    $00000020, $0000001E, $00000021, $000000D1, $000000D2, $000000D3,
    $000000D4, $000000D5, $000000D6, $000000D7, $000000D8, $000000D9);
  CTFontIDs: array [0..0] of DWORD = (
    $FFFFFE00);
  CControlData: TControlData2 = (
    ClassID: '{3654902B-7C02-4F9E-8DD6-BC55D1F0D3F3}';
    EventIID: '{76FD0BF4-65DA-4DC7-BA83-77B1EA271E18}';
    EventCount: 42;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$00000000*);
    Flags: $0000001D;
    Version: 401;
    FontCount: 1;
    FontIDs: @CTFontIDs);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnActivate) - Cardinal(Self);
end;

procedure TDmxActiveX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IDmxActiveX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TDmxActiveX.GetControlInterface: IDmxActiveX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TDmxActiveX.Save_Project(const FName: WideString);
begin
  DefaultInterface.Save_Project(FName);
end;

procedure TDmxActiveX.New_Project(const FName: WideString);
begin
  DefaultInterface.New_Project(FName);
end;

procedure TDmxActiveX.Cls_Project;
begin
  DefaultInterface.Cls_Project;
end;

procedure TDmxActiveX.Project_Map(i: Integer; out FName: WideString);
begin
  DefaultInterface.Project_Map(i, FName);
end;

procedure TDmxActiveX.Map_Contains(x: Integer; y: Integer; out FName: WideString);
begin
  DefaultInterface.Map_Contains(x, y, FName);
end;

procedure TDmxActiveX.Insert_Map(const FName: WideString);
begin
  DefaultInterface.Insert_Map(FName);
end;

procedure TDmxActiveX.Delete_Map(const FName: WideString);
begin
  DefaultInterface.Delete_Map(FName);
end;

procedure TDmxActiveX.prj_Add_Map(const FName: WideString; lev1: Integer; lev2: Integer);
begin
  DefaultInterface.prj_Add_Map(FName, lev1, lev2);
end;

procedure TDmxActiveX.prj_Contains_Map(const FName: WideString; out Ind: Integer);
begin
  DefaultInterface.prj_Contains_Map(FName, Ind);
end;

procedure TDmxActiveX.Play_Tick;
begin
  DefaultInterface.Play_Tick;
end;

procedure TDmxActiveX.Hide_Map;
begin
  DefaultInterface.Hide_Map;
end;

procedure TDmxActiveX.Azimuth(gx: Double; gy: Double; pps: Integer);
begin
  DefaultInterface.Azimuth(gx, gy, pps);
end;

procedure TDmxActiveX.Port_w_h(w: Integer; h: Integer);
begin
  DefaultInterface.Port_w_h(w, h);
end;

procedure TDmxActiveX.Info_Object(p: Integer; out rc: WordBool);
begin
  DefaultInterface.Info_Object(p, rc);
end;

procedure TDmxActiveX.Draw_Object(p: Integer);
begin
  DefaultInterface.Draw_Object(p);
end;

procedure TDmxActiveX.Hide_Object(p: Integer);
begin
  DefaultInterface.Hide_Object(p);
end;

procedure TDmxActiveX.Free_Object;
begin
  DefaultInterface.Free_Object;
end;

procedure TDmxActiveX.Move_Object(p: Integer; dx: Integer; dy: Integer);
begin
  DefaultInterface.Move_Object(p, dx, dy);
end;

procedure TDmxActiveX.Move_Sign(p: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer);
begin
  DefaultInterface.Move_Sign(p, x1, y1, x2, y2);
end;

procedure TDmxActiveX.Insert_Sign(Code: Integer; x1: Integer; y1: Integer; x2: Integer; y2: Integer);
begin
  DefaultInterface.Insert_Sign(Code, x1, y1, x2, y2);
end;

procedure TDmxActiveX.Menu_Object(iCode: Integer; iLoc: Integer; out Code: Integer; 
                                  out Loc: Integer; out Name: WideString);
begin
  DefaultInterface.Menu_Object(iCode, iLoc, Code, Loc, Name);
end;

procedure TDmxActiveX.Show_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer);
begin
  DefaultInterface.Show_Window(x1, y1, x2, y2);
end;

procedure TDmxActiveX.Show_Point(gx: Double; gy: Double; scale: Double);
begin
  DefaultInterface.Show_Point(gx, gy, scale);
end;

procedure TDmxActiveX.Show_Object(p: Integer; scale: Double);
begin
  DefaultInterface.Show_Object(p, scale);
end;

procedure TDmxActiveX.Show_Link(id: Integer; scale: Double);
begin
  DefaultInterface.Show_Link(id, scale);
end;

procedure TDmxActiveX.Show_Centre(cx: Double; cy: Double; scale: Double; pps: Integer);
begin
  DefaultInterface.Show_Centre(cx, cy, scale, pps);
end;

procedure TDmxActiveX.Get_Window(out x1: Integer; out y1: Integer; out x2: Integer; out y2: Integer);
begin
  DefaultInterface.Get_Window(x1, y1, x2, y2);
end;

procedure TDmxActiveX.Get_Centre(out gx: Double; out gy: Double; out scale: Double);
begin
  DefaultInterface.Get_Centre(gx, gy, scale);
end;

procedure TDmxActiveX.Link_Object(p: Integer; out id: Integer);
begin
  DefaultInterface.Link_Object(p, id);
end;

procedure TDmxActiveX.Offs_Object(id: Integer; out ofs: Integer);
begin
  DefaultInterface.Offs_Object(id, ofs);
end;

procedure TDmxActiveX.ext_Disp_Object(cn: Integer; id: Integer; scale: Double);
begin
  DefaultInterface.ext_Disp_Object(cn, id, scale);
end;

procedure TDmxActiveX.str_Disp_Object(const ptr: WideString; scale: Double);
begin
  DefaultInterface.str_Disp_Object(ptr, scale);
end;

procedure TDmxActiveX.xDraw_Object(const FName: WideString; cn: Integer; id: Integer; show: WordBool);
begin
  DefaultInterface.xDraw_Object(FName, cn, id, show);
end;

procedure TDmxActiveX.Print_Window(x1: Integer; y1: Integer; x2: Integer; y2: Integer);
begin
  DefaultInterface.Print_Window(x1, y1, x2, y2);
end;

procedure TDmxActiveX.KeyTransit(Key: Integer; out rc: Integer);
begin
  DefaultInterface.KeyTransit(Key, rc);
end;

procedure TDmxActiveX.Release_dc(dc: Integer);
begin
  DefaultInterface.Release_dc(dc);
end;

procedure TDmxActiveX.DC_Undo(x: Integer; y: Integer; w: Integer; h: Integer);
begin
  DefaultInterface.DC_Undo(x, y, w, h);
end;

procedure TDmxActiveX.DC_Project(vx: Integer; vy: Integer; out dc_x: Integer; out dc_y: Integer);
begin
  DefaultInterface.DC_Project(vx, vy, dc_x, dc_y);
end;

procedure TDmxActiveX.DC_Backup(dc_x: Integer; dc_y: Integer; out vx: Integer; out vy: Integer);
begin
  DefaultInterface.DC_Backup(dc_x, dc_y, vx, vy);
end;

procedure TDmxActiveX.dm_Project(vx: Double; vy: Double; pps: Integer; out dc_x: Integer; 
                                 out dc_y: Integer);
begin
  DefaultInterface.dm_Project(vx, vy, pps, dc_x, dc_y);
end;

procedure TDmxActiveX.dm_Backup(dc_x: Integer; dc_y: Integer; out vx: Double; out vy: Double; 
                                out pps: Integer);
begin
  DefaultInterface.dm_Backup(dc_x, dc_y, vx, vy, pps);
end;

procedure TDmxActiveX.l_to_g(ix: Integer; iy: Integer; out gx: Double; out gy: Double);
begin
  DefaultInterface.l_to_g(ix, iy, gx, gy);
end;

procedure TDmxActiveX.g_to_l(gx: Double; gy: Double; out ix: Integer; out iy: Integer);
begin
  DefaultInterface.g_to_l(gx, gy, ix, iy);
end;

procedure TDmxActiveX.l_to_x(ix: Integer; iy: Integer; out gx: Double; out gy: Double; 
                             out pps: Integer);
begin
  DefaultInterface.l_to_x(ix, iy, gx, gy, pps);
end;

procedure TDmxActiveX.x_to_l(gx: Double; gy: Double; pps: Integer; out lx: Integer; out ly: Integer);
begin
  DefaultInterface.x_to_l(gx, gy, pps, lx, ly);
end;

procedure TDmxActiveX.XY_BL(x: Double; y: Double; out b: Double; out l: Double);
begin
  DefaultInterface.XY_BL(x, y, b, l);
end;

procedure TDmxActiveX.BL_XY(b: Double; l: Double; out x: Double; out y: Double);
begin
  DefaultInterface.BL_XY(b, l, x, y);
end;

procedure TDmxActiveX.dm_to_pcx(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer);
begin
  DefaultInterface.dm_to_pcx(ix, iy, ox, oy);
end;

procedure TDmxActiveX.pcx_to_dm(ix: Integer; iy: Integer; out ox: Integer; out oy: Integer);
begin
  DefaultInterface.pcx_to_dm(ix, iy, ox, oy);
end;

procedure TDmxActiveX.pcx_Project(x: Integer; y: Integer; out dc_x: Integer; out dc_y: Integer);
begin
  DefaultInterface.pcx_Project(x, y, dc_x, dc_y);
end;

procedure TDmxActiveX.ext_Draft(x1: Integer; y1: Integer; x2: Integer; y2: Integer; show: Integer);
begin
  DefaultInterface.ext_Draft(x1, y1, x2, y2, show);
end;

procedure TDmxActiveX.View_Objects(i: Integer; out p: Integer);
begin
  DefaultInterface.View_Objects(i, p);
end;

procedure TDmxActiveX.SetParams(const Key: WideString; const Value: WideString);
begin
  DefaultInterface.SetParams(Key, Value);
end;

procedure TDmxActiveX.dlg_Options;
begin
  DefaultInterface.dlg_Options;
end;

procedure TDmxActiveX.dlg_Ground;
begin
  DefaultInterface.dlg_Ground;
end;

procedure TDmxActiveX.dlg_Object;
begin
  DefaultInterface.dlg_Object;
end;

procedure TDmxActiveX.dlg_Layers;
begin
  DefaultInterface.dlg_Layers;
end;

procedure TDmxActiveX.dlg_project;
begin
  DefaultInterface.dlg_project;
end;

procedure TDmxActiveX.dlg_Print;
begin
  DefaultInterface.dlg_Print;
end;

procedure TDmxActiveX.dlg_Palette;
begin
  DefaultInterface.dlg_Palette;
end;

procedure TDmxActiveX.trf_position(const FName: WideString; APosition: Integer; AColor: Integer);
begin
  DefaultInterface.trf_position(FName, APosition, AColor);
end;

procedure TDmxActiveX.lab_draft(x: Integer; y: Integer);
begin
  DefaultInterface.lab_draft(x, y);
end;

procedure TDmxActiveX.Lotsia(const chm: WideString; const htm: WideString; const dm: WideString);
begin
  DefaultInterface.Lotsia(chm, htm, dm);
end;

procedure TDmxActiveX.dlg_legend(const FName: WideString; iCode: Integer; iLoc: Integer; 
                                 out Code: Integer; out Loc: Integer; out Name: WideString);
begin
  DefaultInterface.dlg_legend(FName, iCode, iLoc, Code, Loc, Name);
end;

procedure TDmxActiveX.dlg_info(const dm: WideString; ptr: Integer);
begin
  DefaultInterface.dlg_info(dm, ptr);
end;

procedure TDmxActiveX.Marker(qx: Double; qy: Double; px: Double; py: Double; flags: Integer; 
                             fi: Integer; df: Integer; out rc: Integer);
begin
  DefaultInterface.Marker(qx, qy, px, py, flags, fi, df, rc);
end;

procedure TDmxActiveX.dlg_Attr;
begin
  DefaultInterface.dlg_Attr;
end;

procedure TDmxActiveX.xShow_window(x1: Integer; y1: Integer; x2: Integer; y2: Integer; 
                                   out gx: Double; out gy: Double; out scale: Double);
begin
  DefaultInterface.xShow_window(x1, y1, x2, y2, gx, gy, scale);
end;

procedure TDmxActiveX.GetIValue(const Key: WideString; out Value: Integer);
begin
  DefaultInterface.GetIValue(Key, Value);
end;

procedure TDmxActiveX.Exec(const Cmd: WideString; const Value: WideString);
begin
  DefaultInterface.Exec(Cmd, Value);
end;

procedure TDmxActiveX.Get_sys7(out pps: Integer; out prj: Integer; out elp: Integer; 
                               out b1: Double; out b2: Double; out lc: Double; out dx: Double; 
                               out dy: Double; out dz: Double; out wx: Double; out wy: Double; 
                               out wz: Double; out m: Double);
begin
  DefaultInterface.Get_sys7(pps, prj, elp, b1, b2, lc, dx, dy, dz, wx, wy, wz, m);
end;

procedure TDmxActiveX.drawVector(id: Integer; Loc: Integer; Color: Integer; Info: Integer; 
                                 const mf: WideString; const txt: WideString);
begin
  DefaultInterface.drawVector(id, Loc, Color, Info, mf, txt);
end;

procedure TDmxActiveX.Get_gz(gx: Double; gy: Double; pps: Integer; elp: Integer; out gz: Integer);
begin
  DefaultInterface.Get_gz(gx, gy, pps, elp, gz);
end;

procedure TDmxActiveX.GetSValue(const Key: WideString; out str: WideString);
begin
  DefaultInterface.GetSValue(Key, str);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TDmxActiveX]);
end;

end.
