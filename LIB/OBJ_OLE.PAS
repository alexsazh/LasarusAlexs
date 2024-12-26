procedure init_iobj;
begin
  Iobj:=nil;

  try
    Iobj:=Coobj_auto.Create;
  except
    Iobj:=nil;
  end;
end;
