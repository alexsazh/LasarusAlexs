unit word; interface

uses Windows{, Messages, SysUtils}, Variants, WordXP;


//����������:
function word_begin(_visible: boolean): boolean;//run
procedure word_end;//quit

//��������:
function word_doc_open(aFileName: string; aReadOnly: boolean): boolean;
procedure word_doc_close;

var
  WordApp: variant;//Word Application
  //WordApp1: TWordApplication;//Word Application

implementation

uses
  ComObj,
  wcmn;


function word_begin(_visible: boolean): boolean;
begin
  Result:=true;
  try
    WordApp:=CreateOleObject('Word.Application');//IDispatch
    //WordApp1:=TWordApplication(WordApp);
    //variant(WordApp1):=WordApp;

    WordApp.Visible:=_visible;
  except
    Result:=false;//!
    WordApp:=Unassigned;//?
    Tell('������ ������� ���������� "Word"');
  end;
end;

procedure word_end;
begin
  try//Word.exe m.b. CLOSED!
    WordApp.Quit;
    WordApp:=Unassigned;//!
  except
  end;
end;

function word_doc_open(aFileName: string; aReadOnly: boolean): boolean;
begin
  try
    WordApp.Documents.Open(aFileName, ReadOnly:=aReadOnly{!!!});
    Result:=true;
  except
    Result:=false;
    Tellf('������ �������� ��������� "%s"',[aFileName]);
  end;
end;

procedure word_doc_close;
begin
  try
    //WordApp.Documents.Close(aFileName);
    WordApp.Documents.Close;
  except
    Tell('EXCEPTION in WordApp.Documents.Close');
  end;
end;


end.
