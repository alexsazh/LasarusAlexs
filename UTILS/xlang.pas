unit xlang; interface

uses
  Classes,Forms,
  OFiles,OTypes,OLists, dialogs;

procedure lang_load_dfm(txt: TTextfile; dfm: TForm);
procedure lang_dump_dfm(txt: TTextfile; dfm: TForm);

procedure lang_dump_dlg(txt: TTextfile;
                        InstanceClass: TComponentClass);

procedure lang_load_dlg(dlg: TForm; FName: PChar);

procedure lang_load_msg(msg: TLangMsgList; FName: PChar);

implementation

uses
  Controls,StdCtrls,
  ExtCtrls,Buttons,ComCtrls,
  Menus,Sysutils,Convert{,xlog};
{
procedure err(const Msg: String);
begin
  std_err.WriteStr('lang\'+Msg);
end;
}
procedure lang_load_dfm(txt: TTextfile; dfm: TForm);

{procedure _err(const Msg: String);
begin
  err('load_dfm\'+Msg);
end;
}
function skip_block(txt: TTextfile; lev: int): Boolean;
var
  s: TShortstr;
begin
  Result:=false;

  if lev >= 16 then
    showmessage('skip_block: lev >= 16')
  else begin
    while txt.xStrLine <> nil do
    if txt.x_str(s) <> nil then
    if s[0] = '}' then begin
      Result:=true; Break
    end else
    if s[0] = '{' then skip_block(txt,lev+1);

    if not Result then
      ShowMessage('skip_block: "}" not found.')
  end
end;

var
  c: TComponent;
  Items: TStrings;
  name,capt,hint: TShortstr;
  fl,rc: Boolean;
begin
  fl:=Is_Comma_Delimiter;
  Is_Comma_Delimiter:=false;

  if txt.x_str(capt) <> nil then
  if Assigned(dfm) then dfm.Caption:=capt;

  while txt.xStrLine <> nil do
  if txt.x_str(name) <> nil then
  if name[0] = '{' then

  if dfm = nil then begin
    skip_block(txt,0); Break
  end
  else begin
    Items:=nil; rc:=false;

    while txt.xStrLine <> nil do
    if txt.x_str(name) <> nil then

    if name[0] = '}' then begin
      rc:=true; Break
    end else

    if name[0] = '{' then begin

      if Assigned(Items) then begin
        Items.BeginUpdate;
        Items.Clear;
      end;

      while txt.xStrLine <> nil do
      if txt.x_str(name) <> nil then
      if name[0] = '}' then Break else
      if Assigned(Items) then
      Items.Add(name);

      if Assigned(Items) then
      Items.EndUpdate; Items:=nil
    end
    else begin Items:=nil;

      txt.x_str(capt); txt.x_str(hint);

      c:=dfm.FindComponent(name);
      if Assigned(c) then begin

        if c is TControl then
        (c as TControl).Hint:=hint;

        if (c.ClassName = 'TButton')
        or (c.ClassName = 'TBitBtn') then
          (c as TButton).Caption:=capt
        else
        if c.ClassName = 'TSpeedButton' then
          (c as TSpeedButton).Caption:=capt
        else
        if c.ClassName = 'TCheckBox' then
          (c as TCheckBox).Caption:=capt
        else
        if c.ClassName = 'TLabel' then
          (c as TLabel).Caption:=capt
        else
        if c.ClassName = 'TRadioGroup' then
          (c as TRadioGroup).Caption:=capt
        else
        if c.ClassName = 'TTabSheet' then
          (c as TTabSheet).Caption:=capt
        else
        if c.ClassName = 'TGroupBox' then
          (c as TGroupBox).Caption:=capt
        else
        if c.ClassName = 'TPanel' then
          (c as TPanel).Caption:=capt
        else
        if c.ClassName = 'TMenuItem' then
          (c as TMenuItem).Caption:=capt
        else
        if c.ClassName = 'TListBox' then
          Items:=(c as TListBox).Items
        else
        if c.ClassName = 'TComboBox' then
          Items:=(c as TComboBox).Items
        else
        if c.ClassName = 'TTabControl' then
          Items:=(c as TTabControl).Tabs

      end
    end;

    if not rc then
       ShowMessage(': "}" not found.');

    Break
  end;

  Is_Comma_Delimiter:=fl
end;

procedure lang_dump_dfm(txt: TTextfile; dfm: TForm);
var
  i,j: Integer; c: TComponent;
  items: TStrings; capt,hint,s: String;
begin
  s:='"'+dfm.Caption+'"';
  txt.WriteStr(dfm.Name+' '+s);
  txt.WriteStr('{');

  for i:=0 to dfm.ComponentCount-1 do begin
    c:=dfm.Components[i];

    if length(c.Name) > 0 then begin
      capt:=''; hint:=''; items:=nil;

      if c is TControl then
      hint:=(c as TControl).Hint;

      if (c.ClassName = 'TButton')
      or (c.ClassName = 'TBitBtn') then
        capt:=(c as TButton).Caption
      else
      if c.ClassName = 'TSpeedButton' then
        capt:=(c as TSpeedButton).Caption
      else
      if c.ClassName = 'TCheckBox' then
        capt:=(c as TCheckBox).Caption
      else
      if c.ClassName = 'TLabel' then begin
        capt:=(c as TLabel).Caption;
        if c.Name = capt then capt:='-';
      end else
      if c.ClassName = 'TRadioGroup' then
        capt:=(c as TRadioGroup).Caption
      else
      if c.ClassName = 'TTabSheet' then
        capt:=(c as TTabSheet).Caption
      else
      if c.ClassName = 'TGroupBox' then
        capt:=(c as TGroupBox).Caption
      else
      if c.ClassName = 'TPanel' then
        capt:=(c as TPanel).Caption
      else
      if c.ClassName = 'TMenuItem' then
        capt:=(c as TMenuItem).Caption
      else
      if c.ClassName = 'TListBox' then
        Items:=(c as TListBox).Items
      else
      if c.ClassName = 'TComboBox' then
        Items:=(c as TComboBox).Items
      else
      if c.ClassName = 'TTabControl' then
        Items:=(c as TTabControl).Tabs;

      if Assigned(Items) then
      if Items.Count = 0 then Items:=nil;

      s:='';
      if length(capt) > 0 then
      s:='"'+capt+'"';

      if length(hint) > 0 then begin
        if length(s) = 0 then
        s:='""'; s:=s+' "'+hint+'"';
      end;

      if capt <> '-' then

      if (length(s) > 0)
      or Assigned(Items) then begin
        txt.WriteStr('  '+c.Name+' '+s);

        if Assigned(Items) then begin
          txt.WriteStr('  {');
          for j:=0 to Items.Count-1 do
          txt.WriteStr('    "'+Items[j]+'"');
          txt.WriteStr('  }');
        end
      end
    end
  end;

  txt.WriteStr('}'); txt.WriteStr('')
end;

procedure lang_dump_dlg(txt: TTextfile;
                        InstanceClass: TComponentClass);
var
  obj: TComponent; dfm: TForm;
begin
  obj:=TComponent(InstanceClass.NewInstance);
  try
    dfm:=TForm(obj);
    dfm.Create(Application);
    lang_dump_dfm(txt,dfm)
  finally
    dfm.Free
  end
end;

procedure lang_load_dlg(dlg: TForm; FName: PChar);
var
  txt: TTextfile; s,nm: TShortstr;
  fl: Boolean;
begin
  if not rus_interface then begin

    txt:=TTextfile.Create;
    try
      StrLangPath(nm,FName);
      if txt.Open(nm) then begin

        fl:=Is_Comma_Delimiter;
        Is_Comma_Delimiter:=false;

        StrPCopy(nm,dlg.Name);

        while txt.xStrLine <> nil do
        if txt.x_str(s) <> nil then

        if StrIComp(s,nm) = 0 then
          lang_load_dfm(txt,dlg)
        else
          lang_load_dfm(txt,nil);

        Is_Comma_Delimiter:=fl
      end
    finally
      txt.Free
    end
  end
end;

procedure lang_load_msg(msg: TLangMsgList; FName: PChar);
var
  txt: TTextfile; s,nm: TShortstr;
  fl: Boolean;
begin
  if not rus_interface then begin

    txt:=TTextfile.Create;
    try
      StrLangPath(nm,FName);
      if txt.Open(nm) then begin

        fl:=Is_Comma_Delimiter;
        Is_Comma_Delimiter:=false;

        StrPCopy(nm,msg.Capt);

        while txt.xStrLine <> nil do
        if txt.x_str(s) <> nil then

        if StrIComp(s,'#msg') <> 0 then
          lang_load_dfm(txt,nil)
        else
        if txt.x_str(s) = nil then
          lang_load_dfm(txt,nil)
        else
        if StrIComp(s,nm) = 0 then
          msg.Loadfrom(txt)
        else
          lang_load_dfm(txt,nil);

        Is_Comma_Delimiter:=fl
      end
    finally
      txt.Free
    end
  end
end;


end.
