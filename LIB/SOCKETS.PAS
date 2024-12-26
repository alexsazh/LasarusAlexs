unit Sockets;
{ Install this component using Options|Install Compenents.
  The function of this module is to provide Delphi with a
  component capable of performing TCP/IP Socket's functions
  by interfacing with WINSOCK.DLL provided by many vendors
  including Microsoft.

  The code herein is released to the public domain under the condition
  that it will not be used for commercial or "For Profit" ventures.

  Written By:      Gary T. Desrosiers
  Date:            March 27th, 1995.
  Copyright:       (R) Copyright by Gary T. Desrosiers, 1995. All Rights Reserved
  UserID(s):       71062,2754
                   desrosi@pcnet.com

  Description:     This control performs WinSock TCP/IP functions.

  Properties:      IPAddr, Design time and runtime read/write.
                     Sets the IP Address of the partner that you will
                     eventually SConnect to. You may specify this as
                     dotted decimal or a literal name to be converted
                     via DNS.
                     examples;
                       Sockets1.IPAddr := 'desrosi';
                       Sockets1.IPAddr := '127.0.0.1';
                       addr := Sockets1.IPAddr;

                   Port, Design time and runtime read/write.
                     Sets the Port number of the remote port to connect
                     to or the local port to listen on depending on
                     whether you subsequently issue a SConnect or SListen.
                     This can be specified as a number or a literal name
                     to be converted via DNS.
                     examples;
                       Sockets1.Port := 'echo';
                       Sockets1.Port := '7';
                       port := Sockets1.Port;

                   SocketNumber, Runtime Readonly.
                     Returns the socket number of the currently allocated
                     connection.
                     example;
                       sock := Sockets1.SocketNumber;

                   Text, Design time and runtime read/write.
                     if set, sends the text to the partner.
                     if read, receives some text from the partner.
                     examples;
                       buffer := Sockets1.Text; (* Receive data *)
                       Sockets1.Text := 'This is a test'; (* Send Data *)

Methods:           SConnect - Connects to the remote (or local) system
                     specified in the IPAddr and Port properties.
                     example;
                       Sockets1.SConnect; (* Connect to partner *)

                   SListen - Listens on the port specified in the Port
                     property.
                     example;
                       Sockets1.SListen; (* Establish server environment *)

                   SAccept - Accepts a client request. Usually issued in
                     OnSessionAvailable event.
                     example;
                       Sock := Sockets1.SAccept; (* Get client connection *)

                   SClose - Closes the socket.
                     example;
                       Sockets1.SClose; (* Close connection *)

                   SReceive - Receives data from partner, similar to
                     reading the property Text.
                     example;
                       buffer := Sockets1.SReceive(Sockets1.SocketNumber,255);

                   SSend - Sends data to the partner, similar to
                     setting the property Text.
                     example;
                       Sockets1.SSend(Sockets1.SocketNumber,buffer,25);

Events:            OnDataAvailable - Called when data is available to
                     be received from the partner. You should issue;
                     buffer := Sockets1.Text; or a SReceive method to
                     receive the data from the partner.

                   OnSessionAvailable - Called when a client has requested
                     to connect to a 'listening' server. You can call
                     the method SAccept here.

                   OnSessionClosed - Called when the partner has closed
                     a socket on you. Normally, you would close your side
                     of the socket when this event happens.

                   OnSessionConnected - Called when the SConnect has
                     completed and the session is connected. This is a
                     good place to send the initial data of a conversation.
                     Also, you may want to enable certain controls that
                     allow the user to send data on the conversation here.
}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;
const
  { Not all of these constants are used in this component, I included
    the entire WinSock.h header file constants for completeness. }

  { User Windows Messages }
  WM_ASYNCSELECT = WM_USER + 0;

  { Misc constants }
  FD_SETSIZE = 64;
  INADDR_ANY: longint = 0;
  INADDR_NONE: longint = -1;
  INADDR_LOOPBACK: longint = $7f000001; { IPAddr: 127.0.0.1 }
  WSADESCRIPTION_LEN = 256;
  WSASYS_STATUS_LEN = 128;

  { Protocols }
  IPPROTO_IP         =  0;              { dummy for IP }
  IPPROTO_ICMP       =  1;              { control message protocol }
  IPPROTO_GGP        =  2;              { gateway^2 (deprecated) }
  IPPROTO_TCP        =  6;              { tcp }
  IPPROTO_PUP        =  12;             { pup }
  IPPROTO_UDP        =  17;             { user datagram protocol }
  IPPROTO_IDP        =  22;             { xns idp }
  IPPROTO_ND         =  77;             { UNOFFICIAL net disk proto }
  IPPROTO_RAW        = 255;             { raw IP packet }
  IPPROTO_MAX        = 256;

  { Port/socket numbers: network standard functions }
  IPPORT_ECHO        =     7;
  IPPORT_DISCARD     =     9;
  IPPORT_SYSTAT      =     11;
  IPPORT_DAYTIME     =     13;
  IPPORT_NETSTAT     =     15;
  IPPORT_FTP         =     21;
  IPPORT_TELNET      =     23;
  IPPORT_SMTP        =     25;
  IPPORT_TIMESERVER  =     37;
  IPPORT_NAMESERVER  =     42;
  IPPORT_WHOIS       =     43;
  IPPORT_MTP         =     57;

  { Port/socket numbers: host specific functions }
  IPPORT_TFTP        =     69;
  IPPORT_RJE         =     77;
  IPPORT_FINGER      =     79;
  IPPORT_TTYLINK     =     87;
  IPPORT_SUPDUP      =     95;

  { UNIX TCP sockets }
  IPPORT_EXECSERVER  =     512;
  IPPORT_LOGINSERVER =     513;
  IPPORT_CMDSERVER   =     514;
  IPPORT_EFSSERVER   =     520;

  { UNIX UDP sockets }
  IPPORT_BIFFUDP     =     512;
  IPPORT_WHOSERVER   =     513;
  IPPORT_ROUTESERVER =     520;

  { Ports < IPPORT_RESERVED are reserved for privileged processes (e.g. root) }
  IPPORT_RESERVED    =     1024;

  { Link numbers }
  IMPLINK_IP         =     155;
  IMPLINK_LOWEXPER   =     156;
  IMPLINK_HIGHEXPER  =     158;

  INVALID_SOCKET     =     $ffff;
  SOCKET_ERROR       =     (-1);

  { Types }
  SOCK_STREAM        =  1;              { stream socket }
  SOCK_DGRAM         =  2;              { datagram socket }
  SOCK_RAW           =  3;              { raw-protocol interface }
  SOCK_RDM           =  4;              { reliably-delivered message }
  SOCK_SEQPACKET     =  5;              { sequenced packet stream }

  { Option flags per-socket }
  SO_DEBUG           =  $0001;         { turn on debugging info recording }
  SO_ACCEPTCONN      =  $0002;         { socket has had listen() }
  SO_REUSEADDR       =  $0004;         { allow local address reuse }
  SO_KEEPALIVE       =  $0008;         { keep connections alive }
  SO_DONTROUTE       =  $0010;         { just use interface addresses }
  SO_BROADCAST       =  $0020;         { permit sending of broadcast msgs }
  SO_USELOOPBACK     =  $0040;         { bypass hardware when possible }
  SO_LINGER          =  $0080;         { linger on close if data present }
  SO_OOBINLINE       =  $0100;         { leave received OOB data in line }
  SO_DONTLINGER      = (not SO_LINGER);

 { Additional options }
  SO_SNDBUF          =  $1001;         { send buffer size }
  SO_RCVBUF          =  $1002;         { receive buffer size }
  SO_SNDLOWAT        =  $1003;         { send low-water mark }
  SO_RCVLOWAT        =  $1004;         { receive low-water mark }
  SO_SNDTIMEO        =  $1005;         { send timeout }
  SO_RCVTIMEO        =  $1006;         { receive timeout }
  SO_ERROR           =  $1007;         { get error status and clear }
  SO_TYPE            =  $1008;         { get socket type }


  { TCP options }
  TCP_NODELAY        =  $0001;

  { Address families }
  AF_UNSPEC          =  0;              { unspecified }
  AF_UNIX            =  1;              { local to host (pipes, portals) }
  AF_INET            =  2;              { internetwork: UDP, TCP, etc. }
  AF_IMPLINK         =  3;              { arpanet imp addresses }
  AF_PUP             =  4;              { pup protocols: e.g. BSP }
  AF_CHAOS           =  5;              { mit CHAOS protocols }
  AF_NS              =  6;              { XEROX NS protocols }
  AF_ISO             =  7;               { ISO protocols }
  AF_OSI             =  AF_ISO;         { OSI is ISO }
  AF_ECMA            =  8;              { european computer manufacturers }
  AF_DATAKIT         =  9;              { datakit protocols }
  AF_CCITT           =  10;             { CCITT protocols, X.25 etc }
  AF_SNA             =  11;             { IBM SNA }
  AF_DECnet          =  12;             { DECnet }
  AF_DLI             =  13;             { Direct data link interface }
  AF_LAT             =  14;             { LAT }
  AF_HYLINK          =  15;             { NSC Hyperchannel }
  AF_APPLETALK       =  16;             { AppleTalk }
  AF_NETBIOS         =  17;             { NetBios-style addresses }
  AF_MAX             =  18;

  { Protocol families, same as address families for now }
  PF_UNSPEC          =  AF_UNSPEC;
  PF_UNIX            =  AF_UNIX;
  PF_INET            =  AF_INET;
  PF_IMPLINK         =  AF_IMPLINK;
  PF_PUP             =  AF_PUP;
  PF_CHAOS           =  AF_CHAOS;
  PF_NS              =  AF_NS;
  PF_ISO             =  AF_ISO;
  PF_OSI             =  AF_OSI;
  PF_ECMA            =  AF_ECMA;
  PF_DATAKIT         =  AF_DATAKIT;
  PF_CCITT           =  AF_CCITT;
  PF_SNA             =  AF_SNA;
  PF_DECnet          =  AF_DECnet;
  PF_DLI             =  AF_DLI;
  PF_LAT             =  AF_LAT;
  PF_HYLINK          =  AF_HYLINK;
  PF_APPLETALK       =  AF_APPLETALK;
  PF_MAX             =  AF_MAX;

 { Level number for (get/set)sockopt() to apply to socket itself }
 SOL_SOCKET          = $ffff;          { options for socket level }

 { Maximum queue length specifiable by listen }
 SOMAXCONN     =   5;

 MSG_OOB       =  $1;             { process out-of-band data }
 MSG_PEEK      =  $2;             { peek at incoming message }
 MSG_DONTROUTE =  $4;             { send without using routing tables }

 MSG_MAXIOVLEN =  16;

 { Define constant based on rfc883, used by gethostbyxxxx() calls }
 MAXGETHOSTSTRUCT   =     1024;

 { Define flags to be used with the WSAAsyncSelect() call }
 FD_READ       =  $01;
 FD_WRITE      =  $02;
 FD_OOB        =  $04;
 FD_ACCEPT     =  $08;
 FD_CONNECT    =  $10;
 FD_CLOSE      =  $20;

 { All Windows Sockets error constants are biased by WSABASEERR fromthe normal }
 WSABASEERR    =          10000;

 { Windows Sockets definitions of regular Microsoft C error constants }
 WSAEINTR      =          (WSABASEERR+4);
 WSAEBADF      =          (WSABASEERR+9);
 WSAEACCES     =          (WSABASEERR+13);
 WSAEFAULT     =          (WSABASEERR+14);
 WSAEINVAL     =          (WSABASEERR+22);
 WSAEMFILE     =          (WSABASEERR+24);

 { Windows Sockets definitions of regular Berkeley error constants }
 WSAEWOULDBLOCK      =    (WSABASEERR+35);
 WSAEINPROGRESS      =    (WSABASEERR+36);
 WSAEALREADY         =    (WSABASEERR+37);
 WSAENOTSOCK         =    (WSABASEERR+38);
 WSAEDESTADDRREQ     =    (WSABASEERR+39);
 WSAEMSGSIZE         =    (WSABASEERR+40);
 WSAEPROTOTYPE       =    (WSABASEERR+41);
 WSAENOPROTOOPT      =    (WSABASEERR+42);
 WSAEPROTONOSUPPORT  =    (WSABASEERR+43);
 WSAESOCKTNOSUPPORT  =    (WSABASEERR+44);
 WSAEOPNOTSUPP       =    (WSABASEERR+45);
 WSAEPFNOSUPPORT     =    (WSABASEERR+46);
 WSAEAFNOSUPPORT     =    (WSABASEERR+47);
 WSAEADDRINUSE       =    (WSABASEERR+48);
 WSAEADDRNOTAVAIL    =    (WSABASEERR+49);
 WSAENETDOWN         =    (WSABASEERR+50);
 WSAENETUNREACH      =    (WSABASEERR+51);
 WSAENETRESET        =    (WSABASEERR+52);
 WSAECONNABORTED     =    (WSABASEERR+53);
 WSAECONNRESET       =    (WSABASEERR+54);
 WSAENOBUFS          =    (WSABASEERR+55);
 WSAEISCONN          =    (WSABASEERR+56);
 WSAENOTCONN         =    (WSABASEERR+57);
 WSAESHUTDOWN        =    (WSABASEERR+58);
 WSAETOOMANYREFS     =    (WSABASEERR+59);
 WSAETIMEDOUT        =    (WSABASEERR+60);
 WSAECONNREFUSED     =    (WSABASEERR+61);
 WSAELOOP            =    (WSABASEERR+62);
 WSAENAMETOOLONG     =    (WSABASEERR+63);
 WSAEHOSTDOWN        =    (WSABASEERR+64);
 WSAEHOSTUNREACH     =    (WSABASEERR+65);
 WSAENOTEMPTY        =    (WSABASEERR+66);
 WSAEPROCLIM         =    (WSABASEERR+67);
 WSAEUSERS           =    (WSABASEERR+68);
 WSAEDQUOT           =    (WSABASEERR+69);
 WSAESTALE           =    (WSABASEERR+70);
 WSAEREMOTE          =    (WSABASEERR+71);

 { Extended Windows Sockets error constant definitions }
 WSASYSNOTREADY      =    (WSABASEERR+91);
 WSAVERNOTSUPPORTED  =    (WSABASEERR+92);
 WSANOTINITIALISED   =    (WSABASEERR+93);

 { Authoritative Answer: Host not found }
 WSAHOST_NOT_FOUND   =    (WSABASEERR+1001);
 HOST_NOT_FOUND      =    WSAHOST_NOT_FOUND;

{ Non-Authoritative: Host not found, or SERVERFAIL }
 WSATRY_AGAIN        =    (WSABASEERR+1002);
 TRY_AGAIN           =    WSATRY_AGAIN;

{ Non recoverable errors, FORMERR, REFUSED, NOTIMP }
 WSANO_RECOVERY      =    (WSABASEERR+1003);
 NO_RECOVERY         =    WSANO_RECOVERY;

{ Valid name, no data record of requested type }
 WSANO_DATA          =    (WSABASEERR+1004);
 NO_DATA             =    WSANO_DATA;

{ no address, look for MX record }
 WSANO_ADDRESS       =    WSANO_DATA;
 NO_ADDRESS          =    WSANO_ADDRESS;

{ Windows Sockets errors redefined as regular Berkeley error constants }
 EWOULDBLOCK         =    WSAEWOULDBLOCK;
 EINPROGRESS         =    WSAEINPROGRESS;
 EALREADY            =    WSAEALREADY;
 ENOTSOCK            =    WSAENOTSOCK;
 EDESTADDRREQ        =    WSAEDESTADDRREQ;
 EMSGSIZE            =    WSAEMSGSIZE;
 EPROTOTYPE          =    WSAEPROTOTYPE;
 ENOPROTOOPT         =    WSAENOPROTOOPT;
 EPROTONOSUPPORT     =    WSAEPROTONOSUPPORT;
 ESOCKTNOSUPPORT     =    WSAESOCKTNOSUPPORT;
 EOPNOTSUPP          =    WSAEOPNOTSUPP;
 EPFNOSUPPORT        =    WSAEPFNOSUPPORT;
 EAFNOSUPPORT        =    WSAEAFNOSUPPORT;
 EADDRINUSE          =    WSAEADDRINUSE;
 EADDRNOTAVAIL       =    WSAEADDRNOTAVAIL;
 ENETDOWN            =    WSAENETDOWN;
 ENETUNREACH         =    WSAENETUNREACH;
 ENETRESET           =    WSAENETRESET;
 ECONNABORTED        =    WSAECONNABORTED;
 ECONNRESET          =    WSAECONNRESET;
 ENOBUFS             =    WSAENOBUFS;
 EISCONN             =    WSAEISCONN;
 ENOTCONN            =    WSAENOTCONN;
 ESHUTDOWN           =    WSAESHUTDOWN;
 ETOOMANYREFS        =    WSAETOOMANYREFS;
 ETIMEDOUT           =    WSAETIMEDOUT;
 ECONNREFUSED        =    WSAECONNREFUSED;
 ELOOP               =    WSAELOOP;
 ENAMETOOLONG        =    WSAENAMETOOLONG;
 EHOSTDOWN           =    WSAEHOSTDOWN;
 EHOSTUNREACH        =    WSAEHOSTUNREACH;
 ENOTEMPTY           =    WSAENOTEMPTY;
 EPROCLIM            =    WSAEPROCLIM;
 EUSERS              =    WSAEUSERS;
 EDQUOT              =    WSAEDQUOT;
 ESTALE              =    WSAESTALE;
 EREMOTE             =    WSAEREMOTE;


type
  u_char = byte;
  u_short = word;
  u_int = word;
  u_long = longint;
  TSocket = u_int;
  servent = record
    s_name: PChar;
    s_aliases: ^PChar;
    s_port: integer;
    s_proto: PChar;
  end;
  Pservent = ^servent;

  Protoent = record
    p_name: PChar;
    p_aliases: ^PChar;
    p_proto: integer;
  end;
  Pprotoent = ^protoent;

  { some liberties taken with this structure }
  in_addr = record
    Case integer of
    0: (s_net, s_host, s_lh, s_impno: u_char);
    1: (s_w1,s_imp: u_short);
    2: (s_addr: u_long);
  end;
  Pin_addr = ^in_addr;

  sockaddr_in = record
    sin_family: integer;
    sin_port: u_short;
    sin_addr: in_addr;
    sin_zero: array[0..7] of char;
  end;
  Psockaddr_in = ^sockaddr_in;

  hostent = record
    h_name: PChar;
    h_aliases: ^PChar;
    h_addrtype: word;
    h_length: word;
    Case integer of
    0: (h_addr_list: ^PChar);
    1: (h_addr: ^pin_addr);
  end;
  Phostent = ^hostent;

  WSADATA = record
    wVersion: word;
    wHighVersion: word;
    szDescription: array[0..WSADESCRIPTION_LEN] of char;
    szSystemStatus: array[0..WSASYS_STATUS_LEN] of char;
    iMaxSockets: u_short;
    iMaxUdpDg: u_short;
    lpVendorInfo: PChar;
  end;

  sockaddr = record
    sa_family: u_short;
    sa_data: array[0..13] of char;
  end;

  sockproto = record
    sp_family: u_short;
    sp_protocol: u_short;
  end;

  linger = record
    l_onoff: u_short;
    l_linger: u_short;
  end;

  TDataAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
  TSessionClosed = procedure (Sender: TObject; Socket: TSocket) of object;
  TSessionAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
  TSessionConnected = procedure (Sender: TObject; Socket: TSocket) of object;

  TSockets = class(TWinControl)
  private
    Pse: Pservent;
    Phe: Phostent;
    Ppe: Pprotoent;
    sin: sockaddr_in;
    initdata: WSADATA;
    FPort: String;
    FIPAddr: String;
    FSocket: TSocket;
    FMSocket: TSocket;
    FDataAvailable: TDataAvailable;
    FSessionClosed: TSessionClosed;
    FSessionAvailable: TSessionAvailable;
    FSessionConnected: TSessionConnected;
    procedure SetText(Text: string);
    function GetText : string;
    function SocketErrorDesc(error: integer) : string;
    procedure SocketError(sockfunc: string);
    procedure TWMPaint(var msg:TWMPaint); message WM_PAINT;
  protected
    procedure WMASyncSelect(var msg: TMessage); message WM_ASYNCSELECT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { I'd like to call these methods Connect, Close, Listen, etc but
      they would conflict with the WinSock.DLL function names ! }
    procedure SConnect;
    procedure SClose;
    procedure SListen;
    function SAccept: TSocket;
    function SReceive(aSocket: TSocket; rlen: integer): string;
    function SReceiveBuf(Buf: PChar; const size: Integer): Integer;
    procedure SSend(aSocket: TSocket;Text: string; Len: integer);
    function GetIPAddr: string;
    function GetPort(aSocket: TSocket): string;
  published
    property Text: string read GetText write SetText;
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

procedure Register;


implementation

uses wcmn;


{ Function declarations for window's sockets (winsock)  This is a complete
  set of function declarations for winsock, not all functions are called
  from this component. }
function accept(s: TSocket; var addr: sockaddr_in; var addrlen: integer) : TSocket;
  far; external 'WINSOCK';
function bind(s: TSocket; var addr: sockaddr_in; namelen: integer) : integer;
  far; external 'WINSOCK';
function closesocket(s: TSocket) : integer;
  far; external 'WINSOCK';
function connect(s: TSocket; var name: sockaddr_in; namelen: integer) : integer;
  far; external 'WINSOCK';
function ioctlsocket(s: TSocket; cmd: longint; var argp: longint) : integer;
  far; external 'WINSOCK';
function getpeername(s: TSocket; var name: sockaddr_in; var namelen: integer) :
  integer; far; external 'WINSOCK';
function getsockname(s: TSocket; var name: sockaddr_in; var namelen: integer) :
  integer; far; external 'WINSOCK';
function getsockopt(s: TSocket; level: integer; optname: integer;
  optval: PChar; var optlen: integer) : integer; far; external 'WINSOCK';
function htonl(hostlong: u_long) : u_long; far; external 'WINSOCK';
function htons(hostshort: u_short) : u_short; far; external 'WINSOCK';
function inet_addr(cp: PChar) : u_long; far; external 'WINSOCK';
function inet_ntoa(sin: in_addr) : PChar; far; external 'WINSOCK';
function listen(s: TSocket; backlog: integer) : integer;
  far; external 'WINSOCK';
function ntohl(netlong: u_long) : u_long; far; external 'WINSOCK';
function ntohs(netshort: u_short) : u_short; far; external 'WINSOCK';
function recv(s: TSocket; buf: PChar; len: integer; flags: integer) : integer;
  far; external 'WINSOCK';
function recvfrom(s: TSocket; buf: PChar; len: integer; flags: integer;
  var from: sockaddr_in; var fromlen: integer) : integer; far; external 'WINSOCK';
function send(s: TSocket; buf: PChar; len: integer; flags: integer) : integer;
  far; external 'WINSOCK';
function sendto(s: TSocket; buf: PChar; len: integer; flags: integer;
  var saddrto: sockaddr_in; tolen: integer) : integer; far; external 'WINSOCK';
function setsockopt(s: TSocket; level: integer; optname: integer; optval: PChar;
  optlen: integer) : integer; far; external 'WINSOCK';
function shutdown(s: TSocket; how: integer) : integer; far; external 'WINSOCK';
function socket(af: integer; stype: integer; protocol: integer) : TSocket;
  far; external 'WINSOCK';
function gethostbyaddr(addr: PChar; len: integer; stype: integer) : phostent;
  far; external 'WINSOCK';
function gethostbyname(name: PChar) :  phostent; far; external 'WINSOCK';
function gethostname(name: PChar) : integer; far; external 'WINSOCK';
function getservbyport(port: integer; proto: PChar) : pservent;
  far; external 'WINSOCK';
function getservbyname(name: PChar; proto: PChar) : pservent;
  far; external 'WINSOCK';
function getprotobynumber(proto: integer) : pprotoent; far; external 'WINSOCK';
function getprotobyname(name: PChar) : pprotoent; far; external 'WINSOCK';
{ Winsock extensions to Berkeley Sockets }
function WSAStartup(wVersionRequired: word; var lpWSAData: WSADATA) : integer;
  far; external 'WINSOCK';
function WSACleanup : integer; far; external 'WINSOCK';
procedure WSASetLastError(iError: integer); far; external 'WINSOCK';
function WSAGetLastError : integer; far; external 'WINSOCK';
function WSAIsBlocking : Boolean; far; external 'WINSOCK';
function WSASetBlockingHook : integer; far; external 'WINSOCK';
function WSACancelBlockingCall : integer; far; external 'WINSOCK';
function WSAAsyncGetServByName(handle: HWND; wMsg: u_int; name: pChar;
  proto: PChar; buf: PChar; buflen: integer) : THandle; far; external 'WINSOCK';
function WSAAsyncGetServByPort(handle: HWND; wMsg: u_int; port: integer;
  proto: PChar; buf: PChar; buflen: integer) : THandle; far; external 'WINSOCK';
function WSAAsyncGetProtoByName(handle: HWND; wMsg: u_int; name: PChar;
  buf: PChar; buflen: integer) : THandle; far; external 'WINSOCK';
function WSAAsyncGetProtoByNumber(handle: HWND; wMsg: u_int; number: integer;
  buf: PChar; buflen: integer) : THandle; far; external 'WINSOCK';
function WSAAsyncGetHostByName(handle: HWND; wMsg: u_int; name: PChar;
  buf: PChar; buflen: integer) : THandle; far; external 'WINSOCK';
function WSAAsyncGetHostByAddr(handle: HWND; wMsg: u_int; addr: PChar;
  len: integer; atype: integer; buf: PChar; buflen: integer) : THandle;
  far; external 'WINSOCK';
function WSACancelAsyncRequest(handle: THandle) :THandle;
  far; external 'WINSOCK';
function WSAAsyncSelect(s: TSocket; handle: HWND; wMsg: u_int; lEvent: longint)
  : integer; far; external 'WINSOCK';

procedure Register;
begin
  RegisterComponents('Samples', [TSockets]);
end;


constructor TSockets.Create(AOwner: TComponent);
var
  iStatus: integer;
begin
  inherited Create(AOwner);
  FPort := '';
  FIPAddr := '';
  FSocket := 0;
  iStatus := WSAStartup($101,initdata);
  if iStatus <> 0 then
    SocketError('Constructor (WSAStartup)');
  Invalidate;
end;

destructor TSockets.Destroy;
var
  iStatus: integer;
begin
  iStatus := WSACleanup;
  if iStatus < 0 then
    SocketError('Destructor (WSACleanup)');
  inherited Destroy;
end;

procedure TSockets.TWMPaint(var msg: TWMPaint);
var
  icon: HIcon;
  dc: HDC;
begin
  if csDesigning in ComponentState then
  begin
    icon := LoadIcon(HInstance,MAKEINTRESOURCE('TSOCKETS'));
    dc := GetDC(Handle);
    Width := 32;
    Height := 32;
    DrawIcon(dc,0,0,icon);
    ReleaseDC(Handle,dc);
    FreeResource(icon);
  end;
  ValidateRect(Handle,nil);
end;

procedure TSockets.SetText(Text: string);
var
  iStatus: integer;
  szBigBuff: array[0..256] of char;
begin
  StrPCopy(szBigBuff,Text);
  iStatus := send(FSocket,szBigBuff,StrLen(szBigBuff),0);
  if iStatus < 0 then
    SocketError('SetText (Send)');
end;

function TSockets.GetText: string;
var
  len: integer;
  BigBuff: string;
  szBigBuff: array[0..256] of char absolute BigBuff;
  iStatus: Integer;
begin
  if FSocket <> 0 then
  begin
    len := recv(FSocket,@szBigBuff[1],255,0);
    if len <= 0 then begin
      {
      iStatus := WSAGetLastError;
      if iStatus <> WSAEWOULDBLOCK then SocketError('GetText (Recv)');
      }
      SocketError('GetText (Recv)');

      len:=0;
    end;
    szBigBuff[0] := chr(len);
    Result := BigBuff;
  end
  else Result := '';
end;

function TSockets.GetPort(aSocket: TSocket): string;
var
  addr: sockaddr_in;
  addrlen: integer;
  port: integer;
begin
  addrlen := sizeof(addr);
  getsockname(aSocket,addr,addrlen);
  port := ntohs(addr.sin_port);
  Result := Format('%d',[port]);
end;

function TSockets.GetIPAddr: string;
var
  szAddr: array[0..31] of char;
  addr: PChar;
begin
  addr := inet_ntoa(sin.sin_addr);
  StrCopy(szAddr,addr);
  Result := StrPas(szAddr);
end;

function TSockets.SReceive(aSocket: TSocket; rlen: integer) : string;
var
  len: integer;
  BigBuff: string;
  szBigBuff: array[0..256] of char absolute BigBuff;
  iStatus: Integer;
begin
  if FSocket <> 0 then
  begin
    len := recv(aSocket,@szBigBuff[1],rlen,0);
    if len <= 0 then begin
      {
      iStatus := WSAGetLastError;
      if iStatus <> WSAEWOULDBLOCK then SocketError('SReceive (Recv)');
      }
      SocketError('SReceive');

      len:=0;
    end;
    szBigBuff[0] := chr(len);
    Result := BigBuff;
  end
  else Result := '';
end;

function TSockets.SReceiveBuf(Buf: PChar; const size: Integer): Integer;
var iStatus: Integer;
begin
  Result:=0;
  if FSocket=0 then exit;
  Result := recv(FSocket, Buf, size, 0);
  if Result < 0 then begin
    SocketError('SReceiveBuf (Recv)');
    Result:=0;
  end;
end;

procedure TSockets.SSend(aSocket: TSocket; Text: string; Len: integer);
var
  iStatus: integer;
  szBigBuff: array[0..256] of char;
begin
  StrPCopy(szBigBuff,Text);
  iStatus := send(aSocket,szBigBuff,Len,0);
  if iStatus < 0 then
    SocketError('SSend');
end;

procedure TSockets.WMASyncSelect(var msg: TMessage);
var n: Integer;
begin
  case LoWord(msg.lParam) of
    FD_READ:
    begin
      n:=HiWord(msg.lParam);
      {
      Tellf('Read: lo(event)=%d, hi=%d, w=%d\n%s',
        [LoWord(msg.lParam),n,msg.wParam, SocketErrorDesc(n)]);
      }
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
      n:=HiWord(msg.lParam);
      {
      Tellf('Connected: lo(event)=%d, hi=%d, w=%d\n%s',
        [LoWord(msg.lParam),n,msg.wParam, SocketErrorDesc(n)]);
      }
      if n<>0 then begin
        SocketError('WMASyncSelect (FD_CONNECT)');
      end else begin
        if Assigned(FSessionConnected) then
          FSessionConnected(Self,msg.wParam);
      end;
    end;
  end;
end;

procedure TSockets.SConnect;
var
  iStatus: integer;
  szTcp: PChar;
  szPort: array[0..31] of char;
  szData: array[0..256] of char;
  (*
  zs: tchars;
  optlen: integer;
  *)
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
  Pse := getservbyname(szPort,szTcp);
  if Pse = nil then
     sin.sin_port := htons(StrToInt(StrPas(szPort)))
  else sin.sin_port := Pse^.s_port;
  StrPCopy(szData,FIPAddr);
  sin.sin_addr.s_addr := inet_addr(szData);
  if sin.sin_addr.s_addr = INADDR_NONE then
    begin
      Phe := gethostbyname(szData);
      if Phe = nil then
        begin
          StrPCopy(szData,'Cannot convert host address');
          Application.MessageBox(szData, 'WINSOCK ERROR', mb_OKCancel +
             mb_DefButton1);
          exit;
        end;
      sin.sin_addr := Phe^.h_addr^^;
    end;
  Ppe := getprotobyname(szTcp);

  FSocket := socket(PF_INET,SOCK_STREAM,Ppe^.p_proto);
  if FSocket < 0 then begin
    SocketError('SConnect (socket)');
    exit;
  end;
  (*
  getsockopt(FSocket, 0{SOL_SOCKET}, SO_RCVBUF, zs, optlen);
  Tell(StrPas(zs));
  *)
  iStatus := WSAASyncSelect(FSocket,Handle,WM_ASYNCSELECT,
     FD_READ or FD_CLOSE or FD_CONNECT);
  if iStatus <> 0 then begin
    SocketError('WSAAsyncSelect');
    exit;
  end;

  iStatus := connect(FSocket,sin,sizeof(sin));
  if iStatus <> 0 then
  begin
    iStatus := WSAGetLastError;
    if iStatus <> WSAEWOULDBLOCK then SocketError('SConnect');
  end;

end;

procedure TSockets.SListen;
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
  iStatus := WSAASyncSelect(FMSocket,Handle,WM_ASYNCSELECT,
     FD_READ or FD_ACCEPT or FD_CLOSE);
  if iStatus <> 0 then
    SocketError('WSAASyncSelect');
end;

function TSockets.SAccept: TSocket;
var
  iStatus: integer;
  len: integer;
begin
  len := sizeof(sin);
  FSocket := accept(FMSocket,sin,len);
  if FMSocket < 0 then
    SocketError('Accept');
  Result := FSocket;
end;

procedure TSockets.SClose;
var
  iStatus: integer;
begin
  WSAASyncSelect(FSocket,Handle,WM_ASYNCSELECT,0);
  iStatus := closesocket(FSocket);
  if iStatus <> 0 then
    SocketError('Disconnect (closesocket)');
  FIPAddr := '';
  FPort := '';
  FSocket := 0;
end;


procedure TSockets.SocketError(sockfunc: string);
var
  szLine: array[0..255]  of char;
  error: integer;
  line: string;
begin
  error := WSAGetLastError;
  line := 'Error '+ IntToStr(error) + ' in function ' + sockfunc +
  #13#10 + SocketErrorDesc(error);
  StrPCopy(szLine,line);
  Application.MessageBox(szLine, 'WINSOCK ERROR', mb_OKCancel +
    mb_DefButton1);
  {halt;}
end;

function TSockets.SocketErrorDesc(error: integer) : string;
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

end.
