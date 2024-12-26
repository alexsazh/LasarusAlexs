unit Socket32; interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinSock;


const
  { User Windows Messages: }
  WM_ASYNCSELECT = WM_USER + 0;

type
  {Events handlers:}
  {FD_READ:}TDataAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
  {FD_CLOSE:}TSessionClosed = procedure (Sender: TObject; Socket: TSocket) of object;
  {FD_ACCEPT:}TSessionAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
  {FD_CONNECT:}TSessionConnected = procedure (Sender: TObject; Socket: TSocket) of object;

type
  PSockForm = ^TSockForm;
  TSockForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    Pse: PServEnt;
    Phe: PHostEnt;
    Ppe: Pprotoent;

    Sin: TSockAddrIn; {(sockaddr_in) -> TInAddr(in_addr) }
    InitData: TWSAData;

    FPort: String;
    FIPAddr: String;
    FSocket: TSocket;
    FMSocket: TSocket;

    {Events handlers:}
    FDataAvailable: TDataAvailable;
    FSessionClosed: TSessionClosed;
    FSessionAvailable: TSessionAvailable;
    FSessionConnected: TSessionConnected;

    procedure PutText(aText: string);
    function GetText : string;

    procedure SocketError(sockfunc: string);
    function SocketErrorDesc(error: integer) : string;

  protected
    {WinSock32 Events:}
    procedure WMASyncSelect(var msg: TMessage); message WM_ASYNCSELECT;

  public
    { I'd like to call these methods Connect, Close, Listen, etc but
      they would conflict with the WinSock.DLL function names ! }
    procedure SConnect; {client}
    procedure SClose;
    procedure SListen;
    function SAccept: TSocket;

    function SReceive(aSocket: TSocket; rlen: integer): string;
    procedure SSend(aSocket: TSocket;Text: string; Len: integer);

    function GetIPAddr: string;
    function GetPort(aSocket: TSocket): string;

    property Text: string read GetText write PutText;
    property IPAddr: string read FIPAddr write FIPAddr;
    property Port: string read FPort write FPort;
    property SocketNumber: TSocket read FSocket;

    property OnDataAvailable: TDataAvailable read FDataAvailable
      write FDataAvailable;
    property OnSessionClosed: TSessionClosed read FSessionClosed
      write FSessionClosed;
    property OnSessionAvailable: TSessionAvailable read FSessionAvailable
      write FSessionAvailable;
    property OnSessionConnected: TSessionConnected read FSessionConnected
      write FSessionConnected;
  end;

var
  SockForm: TSockForm;

  Sockets1: TSockForm;  {xxx}


{***********************************************}
implementation
{***********************************************}

{$R *.DFM}

uses wcmn, rexec;


{Public methods:}

procedure TSockForm.SConnect;
var
  iStatus: integer;
  szTcp: PChar;
  szPort: array[0..31] of char;
  szData: array[0..256] of char;
begin
  if FPort = '' then
  begin
    Application.MessageBox('No Port Specified', 'WINSOCK ERROR', mb_OKCancel +
      mb_DefButton1);
    exit;
  end;
  if FIPAddr = '' then
  begin
    Application.MessageBox('No IP Address Specified', 'WINSOCK ERROR', mb_OKCancel +
      mb_DefButton1);
    exit;
  end;

  sin.sin_family := AF_INET;

  StrPCopy(szPort,FPort);
  szTcp := 'tcp';

  {Service:}
  Pse := getservbyname(szPort,szTcp); {1: by name}
  if Pse = nil then
     sin.sin_port := htons(StrToInt(StrPas(szPort))) {2: by number}
  else sin.sin_port := Pse^.s_port;

  {HostName(IP address):}
  StrPCopy(szData,FIPAddr);
  sin.sin_addr.s_addr := inet_addr(szData); {1: by "."-standart}
  if sin.sin_addr.s_addr = INADDR_NONE then
    begin
      Phe := gethostbyname(szData); {2: by name}
      if Phe = nil then
        begin
          StrPCopy(szData,'Cannot convert host address');
          Application.MessageBox(szData, 'WINSOCK ERROR', mb_OKCancel +
             mb_DefButton1);
          exit;
        end;
      {sin.sin_addr := Phe^.h_addr^^;} {TInAddr<-Char)}
      memcpy(@(sin.sin_addr), Phe^.h_addr^, sizeof(TInAddr) );  {xxx}
    end;

  {Protocol:}
  Ppe := getprotobyname(szTcp);

  {WinSocket Initialization:}
  FSocket := socket(PF_INET,SOCK_STREAM,Ppe^.p_proto);
  if FSocket < 0 then
    SocketError('SConnect (socket)');

  iStatus := WSAASyncSelect(FSocket,SockForm.Handle,WM_ASYNCSELECT,
     FD_READ or FD_CLOSE or FD_CONNECT);
  if iStatus <> 0 then
    SocketError('WSAAsyncSelect');

  iStatus := connect(FSocket,sin,sizeof(sin));
  if iStatus <> 0 then
    begin
    iStatus := WSAGetLastError;
    if iStatus <> WSAEWOULDBLOCK then
       SocketError('SConnect');
    end;
end;

procedure TSockForm.SClose;
var
  iStatus: integer;
begin
  WSAASyncSelect(FSocket,SockForm.Handle,WM_ASYNCSELECT,0);
  iStatus := closesocket(FSocket);
  if iStatus <> 0 then
    SocketError('Disconnect (closesocket)');
  FIPAddr := '';
  FPort := '';
  FSocket := 0;
end;

procedure TSockForm.SListen;
var
  iStatus: integer;
  szTcp: PChar;
  szPort: array[0..31] of char;
  {szData: array[0..256] of char;}
begin
  if FPort = '' then
  begin
    Application.MessageBox('No Port Specified', 'WINSOCK ERROR', mb_OKCancel +
      mb_DefButton1);
    exit;
  end;
  sin.sin_family := AF_INET;
  sin.sin_addr.s_addr := INADDR_ANY;
  szTcp := 'tcp';
  StrPCopy(szPort,FPort);
  Pse := getservbyname(szPort,szTcp);
  if Pse = nil then
     sin.sin_port := htons(StrToInt(StrPas(szPort)))
  else sin.sin_port := Pse^.s_port;
  Ppe := getprotobyname(szTcp);
  FMSocket := socket(PF_INET,SOCK_STREAM,Ppe^.p_proto);
  if FMSocket < 0 then
    SocketError('socket');
  iStatus := bind(FMSocket, sin, sizeof(sin));
  if iStatus <> 0 then
    SocketError('Bind');
  iStatus := listen(FMSocket,5);
  if iStatus <> 0 then
    SocketError('Listen');
  iStatus := WSAASyncSelect(FMSocket,SockForm.Handle,WM_ASYNCSELECT,
     FD_READ or FD_ACCEPT or FD_CLOSE);
  if iStatus <> 0 then
    SocketError('WSAASyncSelect');
end;

function TSockForm.SAccept: TSocket;
var
  {iStatus: integer;}
  len: integer;
begin
  len := sizeof(sin);
  FSocket := accept(FMSocket,@sin,@len);
  if FMSocket < 0 then
    SocketError('Accept');
  Result := FSocket;
end;


function TSockForm.SReceive(aSocket: TSocket; rlen: integer) : string;
var
  len: integer;
  BigBuff: string[255];
  {szBigBuff: array[0..256] of char absolute BigBuff;}
begin
  Result:='';
  if FSocket <> 0 then
  begin
    if rlen>255 then rlen:=255;   {xxx}
    len := recv(aSocket,BigBuff[1],rlen,0);
    if len <= 0 then begin
      SocketError('SReceive');
      exit;
    end;

    {szBigBuff[0] := chr(len);}
    SetLength(BigBuff, len);
    Result := BigBuff;
  end
  else Result := '';
end;

procedure TSockForm.SSend(aSocket: TSocket; Text: string; Len: integer);
var
  iStatus: integer;
  szBigBuff: array[0..256] of char;
begin
  StrPCopy(szBigBuff,Text);
  iStatus := send(aSocket,szBigBuff,Len,0);
  if iStatus < 0 then
    SocketError('SSend');
end;


function TSockForm.GetPort(aSocket: TSocket): string;
var
  addr: TSockAddrIn;
  addrlen: integer;
  port: integer;
begin
  addrlen := sizeof(addr);
  getsockname(aSocket,addr,addrlen);
  port := ntohs(addr.sin_port);
  Result := Format('%d',[port]);
end;

function TSockForm.GetIPAddr: string;
var
  szAddr: array[0..31] of char;
  addr: PChar;
begin
  addr := inet_ntoa(sin.sin_addr);
  StrCopy(szAddr,addr);
  Result := StrPas(szAddr);
end;


{Private methods:}

procedure TSockForm.PutText(aText: string);
var
  iStatus: integer;
  szBigBuff: array[0..256] of char;
begin
  SetLength( aText, mini(Length(aText), 255) );   {xxx}

  StrPCopy(szBigBuff,aText);
  iStatus := send(FSocket,szBigBuff,StrLen(szBigBuff),0);
  if iStatus < 0 then
    SocketError('SetText (Send)');
end;

function TSockForm.GetText: string;
var
  len, acount: integer;
  BigBuff: string[255];
  {szBigBuff: array[0..256] of char absolute BigBuff;}
begin
  Result:='';
  if FSocket <> 0 then
  begin
    acount := 255;
    len := recv(FSocket,{@sz}BigBuff[1],acount,0);
    {
    Tellf('TSockForm.GetText:\nlen=%d acount=%d',[len, acount]);
    }
    if len <= 0 then begin
      SocketError('GetText (Recv)');
      exit;
    end;
    {szBigBuff[0] := chr(len);}
    SetLength(BigBuff, len);
    Result := BigBuff;
  end
  else Result := '';
end;


procedure TSockForm.SocketError(sockfunc: string);
var
  szLine: array[0..255]  of char;
  error: integer;
  line: string;
begin
  error := WSAGetLastError;
  line := 'Error '+ IntToStr(error) + ' in function ' + sockfunc +
  #13#10 + SocketErrorDesc(error);
  StrPCopy(szLine,line);
  Application.MessageBox(szLine, 'WINSOCK ERROR', mb_OkCancel +
    mb_DefButton1);
  halt;
end;

function TSockForm.SocketErrorDesc(error: integer) : string;
begin
  case error of
    WSAEINTR:
      SocketErrorDesc := 'Interrupted system call';
    WSAEBADF:
      SocketErrorDesc := 'Bad file number';
    WSAEACCES:
      SocketErrorDesc := 'Permission denied';
    WSAEFAULT:
      SocketErrorDesc := 'Bad address';
    WSAEINVAL:
      SocketErrorDesc := 'Invalid argument';
    WSAEMFILE:
      SocketErrorDesc := 'Too many open files';
    WSAEWOULDBLOCK:
      SocketErrorDesc := 'Operation would block';
    WSAEINPROGRESS:
      SocketErrorDesc := 'Operation now in progress';
    WSAEALREADY:
      SocketErrorDesc := 'Operation already in progress';
    WSAENOTSOCK:
      SocketErrorDesc := 'Socket operation on non-socket';
    WSAEDESTADDRREQ:
      SocketErrorDesc := 'Destination address required';
    WSAEMSGSIZE:
      SocketErrorDesc := 'Message too long';
    WSAEPROTOTYPE:
      SocketErrorDesc := 'Protocol wrong type for socket';
    WSAENOPROTOOPT:
      SocketErrorDesc := 'Protocol not available';
    WSAEPROTONOSUPPORT:
      SocketErrorDesc := 'Protocol not supported';
    WSAESOCKTNOSUPPORT:
      SocketErrorDesc := 'Socket type not supported';
    WSAEOPNOTSUPP:
      SocketErrorDesc := 'Operation not supported on socket';
    WSAEPFNOSUPPORT:
      SocketErrorDesc := 'Protocol family not supported';
    WSAEAFNOSUPPORT:
      SocketErrorDesc := 'Address family not supported by protocol family';
    WSAEADDRINUSE:
      SocketErrorDesc := 'Address already in use';
    WSAEADDRNOTAVAIL:
      SocketErrorDesc := 'Can''t assign requested address';
    WSAENETDOWN:
      SocketErrorDesc := 'Network is down';
    WSAENETUNREACH:
      SocketErrorDesc := 'Network is unreachable';
    WSAENETRESET:
      SocketErrorDesc := 'Network dropped connection on reset';
    WSAECONNABORTED:
      SocketErrorDesc := 'Software caused connection abort';
    WSAECONNRESET:
      SocketErrorDesc := 'Connection reset by peer';
    WSAENOBUFS:
      SocketErrorDesc := 'No buffer space available';
    WSAEISCONN:
      SocketErrorDesc := 'Socket is already connected';
    WSAENOTCONN:
      SocketErrorDesc := 'Socket is not connected';
    WSAESHUTDOWN:
      SocketErrorDesc := 'Can''t send after socket shutdown';
    WSAETOOMANYREFS:
      SocketErrorDesc := 'Too many references: can''t splice';
    WSAETIMEDOUT:
      SocketErrorDesc := 'Connection timed out';
    WSAECONNREFUSED:
      SocketErrorDesc := 'Connection refused';
    WSAELOOP:
      SocketErrorDesc := 'Too many levels of symbolic links';
    WSAENAMETOOLONG:
      SocketErrorDesc := 'File name too long';
    WSAEHOSTDOWN:
      SocketErrorDesc := 'Host is down';
    WSAEHOSTUNREACH:
      SocketErrorDesc := 'No route to host';
    WSAENOTEMPTY:
      SocketErrorDesc := 'Directory not empty';
    WSAEPROCLIM:
      SocketErrorDesc := 'Too many processes';
    WSAEUSERS:
      SocketErrorDesc := 'Too many users';
    WSAEDQUOT:
      SocketErrorDesc := 'Disc quota exceeded';
    WSAESTALE:
      SocketErrorDesc := 'Stale NFS file handle';
    WSAEREMOTE:
      SocketErrorDesc := 'Too many levels of remote in path';
    WSASYSNOTREADY:
      SocketErrorDesc := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED:
      SocketErrorDesc := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED:
      SocketErrorDesc := 'WinSock not initialized';
    WSAHOST_NOT_FOUND:
      SocketErrorDesc := 'Host not found';
    WSATRY_AGAIN:
      SocketErrorDesc := 'Non-authoritative host not found';
    WSANO_RECOVERY:
      SocketErrorDesc := 'Non-recoverable error';
    WSANO_DATA:
      SocketErrorDesc := 'No Data';
    else SocketErrorDesc := 'Not a WinSock error';
  end;
end;

{**************}

procedure TSockForm.WMASyncSelect(var msg: TMessage);
begin
  case LoWord(msg.lParam) of
    FD_READ:
    begin
      if Assigned(FDataAvailable) then
        FDataAvailable(Self,msg.wParam);
    end;
    FD_CLOSE:
    begin
      if Assigned(FSessionClosed) then
        FSessionClosed(Self,msg.wParam);
    end;
    FD_ACCEPT:
    begin
      if Assigned(FSessionAvailable) then
        FSessionAvailable(Self,msg.wParam);
    end;
    FD_CONNECT:
    begin
      {Tell('FD_CONNECT');}
      if Assigned(FSessionConnected) then
        FSessionConnected(Self,msg.wParam);
    end;
  end;
end;



procedure TSockForm.FormCreate(Sender: TObject);
var
  iStatus: integer;
begin
  FPort := '';
  FIPAddr := '';
  FSocket := 0;
  iStatus := WSAStartup($101,initdata);
  if iStatus <> 0 then begin
    SocketError('Constructor (WSAStartup)');
    exit;
  end;

  {Invalidate;}

  Sockets1:=Self;  {???}

  with RExecFrm do begin
    OnDataAvailable    := Sockets1DataAvailable;
    OnSessionClosed    := Sockets1SessionClosed;
    OnSessionConnected := Sockets1SessionConnected;
  end;  
end;

procedure TSockForm.FormDestroy(Sender: TObject);
var
  iStatus: integer;
begin
  iStatus := WSACleanup;
  if iStatus < 0 then
    SocketError('Destructor (WSACleanup)');
end;


end. {of unit}

