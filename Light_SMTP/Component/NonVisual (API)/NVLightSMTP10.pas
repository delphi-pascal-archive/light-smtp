unit NVLightSMTP10;

interface

{
   ��������� Light SMTP �������� �������
   ��������� ��� ����������� �������� �����
   (������� � HTML) � ���������� � ��������
   �����������.
   
   � ������� �������������� ���������,        
   ��� ������������� ������� ����������,      
   ����������� ����� 9 ��, ��� � 17-20 ���    
   ������, ��� � IdSMTP, Synapse � ICS SMTPCli.

   ��� ��������� ��������� � �������, ���
   ������ ��� ������� "����������" ��� ���� ���,
   ��� ������ ������� ������ ������ � SMTP
   ����������.        
                                              
  Copyright 2010 ����� ������.                
  http://bulaj.ru                             
  mailto: bulka@sa-sec.org

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ������� ������:
                                              
  2008 ��� - 1.0:                             
  [+] ��� ���������                           
  [+] �������� �����                          
  [+] ��������� �������� ������ �����
  [+] ��������� �����������                   
                                              
  2008 ��� - 1.1                              
  [+] ����������� � ��������� ������
  [+] ������������� ���
  [+] ��������� ����������� ���������
      �������� ������, ����������,
      ������� �������

  14.01.2010 - 2.0
  [+] �������� ���������� ���������
  [+] �������� ���������� ������
  [+] ����������� ����

  18.01.2010 - 2.1
  [+] ��������� ������� �������
  [+] ��������� ��������� ����������
  [+] �������� ��������� X-Mailer

  01.05.2010 - 2.2
  [+] ��������� ��� ��� �������� ������ �����
  [+] ��������� ����������� �������� ������
      ��� HTML
  [+] �������� ��������� ���� ���������� ���
      �������� ������
  [+] ������ ��������� �������� ��������,
      ������������� � �������������� ��������   
                                              
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
                                              
  ������������ ��� ����������� Base64.        
                                              
  (c) 2002 ������� �.�.                       
  http://www.inta.portal.ru/dark/index.html   
  mailto:dark@online.ru                       

}

uses
  SysUtils, Classes, WinSock, Windows, NVEncoders;

type
  TAuthorizationType  =  (atAuthNone, atAuthPlain, atAuthLogin);
  TContentType        =  (ctTextPlain, ctTextHTML);

  TNVLightSMTP = class
  private
     FSocket: TSocket;
     
     FMsgBody,
     FCopyToList,
     FFilesToSend: TStringList;
     FPort: Integer;
     FSendTo,
     FHost,
     FUserName,
     FPassword,
     FSubject,
     FCharset,
     FXMailer: String;
     FAuthType: TAuthorizationType;
     FContentType: TContentType;
  protected
    { Protected declarations }
    RecCode: String[3];
    Answer: String;
    function GetResponseError : String;
    function ReceiveError(Code: String): Boolean;
    procedure SetMBLines(Value: TStringList);
    procedure SetCopyToLines(Value: TStringList);
    procedure SetFTSList(Value: TStringList);
    procedure SendFile(FN: String);
    procedure GetServerAnswer(Answer: String); virtual;
    procedure ServerConnected(Sender: TObject); virtual;
    procedure SendProgress(Total,Current: Integer); virtual;
    function ReadFromSocket: String;
    function GenerateBoundary: String;
    function SendToSocket(Cmd: string):integer;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
  published
    procedure SendMail(const ShowLog: Boolean = False);
    property Host: String read FHost write FHost;
    property XMailer: String read FXMailer write FXMailer;
    property Port: Integer read FPort write FPort;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property Subject: String read FSubject write FSubject;
    property MessageBody: TStringList read FMsgBody write SetMBLines;
    property CopyTo: TStringList read FCopyToList write SetCopyToLines;
    property SendTo: String read FSendTo write FSendTo;
    property CharSet: String read FCharset write FCharset;
    property FilesToSend: TStringList read FFilesToSend write SetFTSList;
    property Authorization: TAuthorizationType read FAuthType write FAuthType default atAuthLogin;
    property ContentType: TContentType read FContentType write FContentType;
  end;

var  Server_Addr: SockAddr_In;
     wData: WSAData;

// [����� ������� ����] Localization    
const
  ERROR_421  =  'C����� ����������; ���������� �����������';
  ERROR_450  =  '����������� ������� �������� ���������� �� ���������, ��� ��� �������� ���� ����������';
  ERROR_451  =  '����������� ������� �� ���������; ��������� ��������� ������ ��� ��������� ���������';
  ERROR_452  =  '����������� ������� �� ���������; ������� �� ������� ��������';
  ERROR_500  =  '�������������� ������ � ������ �������; ������� �� ��������!';
  ERROR_501  =  '�������������� ������ � ���������� ��� ���������� �������';
  ERROR_502  =  '������ ������� �� �����������';
  ERROR_503  =  '�������� ������������������ ������!';
  ERROR_504  =  '� ������ ������� �� ����� ���� ����������';
  ERROR_535  =  '�������� ��������������� ������!';
  ERROR_550  =  '����������� ������� �� ���������, ��� ��� �������� ���� ����������';
  ERROR_552  =  '����������� ������� �������� ���������� ��������; �������� ������������, ��������� �������, �������������';
  ERROR_554  =  '���������� �� ��������� ';
  ERROR_553  =  '����������� ������� �� ���������; ������� ������������ ��� ��������� �����';

  WSA_NOTINITIALISED  =  '������� ���������� �� ���� ����������������! ���������� � ������������';
  WSA_ENETDOWN        =  '����� �������� - �������� ������ ������� ������!';
  WSA_EADDRINUSE      =  '��������� �����/���� ��� ������������!';
  WSA_EINVAL          =  '����� ��� ������ � �������!';
  WSA_ENOBUFS         =  '������� ����� ����������. ���������� ������!';
  WSA_ENOTSOCK        =  '��������� ���������� ������!';
  WSA_EISCONN         =  '����� ��� ���������';
  WSA_EMFILE          =  '����������� ���������� �����������!';
  WSA_ETIMEDOUT       =  '����� �������� ������ �������!';
  WSA_ERROR           =  '������ ��� ������� �������� ���������...';

const
  BadCode: array[0..13] of SmallInt = (421, 450, 451, 452, 500,
                                       501, 502, 503, 504, 550,
                                       552, 553, 554, 535);

const
  CRLF = #13#10;

implementation

function ExistInArray(const ASearchInt: SmallInt; const InArray: array of SmallInt): SmallInt;
begin
  for Result := Low(InArray) to High(InArray) do begin
    if ASearchInt = InArray[Result] then begin
      Exit;
    end;
  end;
  Result := -1;
end;

function GetWinSockError: String;
var
 ErrCode: Integer;
begin
  Result:=WSA_ERROR;
  ErrCode:=WSAGetLastError();
  case ErrCode of
    WSANOTINITIALISED: Result:= WSA_NOTINITIALISED;
    WSAENETDOWN: Result:= WSA_ENETDOWN;
    WSAEADDRINUSE: Result:= WSA_EADDRINUSE;
    WSAEINVAL: Result:= WSA_EINVAL;
    WSAENOBUFS: Result:= WSA_ENOBUFS;
    WSAENOTSOCK: Result:= WSA_ENOTSOCK;
    WSAEISCONN: Result:= WSA_EISCONN;
    WSAEMFILE: Result:= WSA_EMFILE;
    WSAETIMEDOUT: Result:= WSA_ETIMEDOUT;
  end;
end;

function TNVLightSMTP.GetResponseError : String;
var
 ErrCode: Integer;
begin
  Result:='��������� ������ ��� ������� ��������� ������! ������� ������:'+#13;
  Val(RecCode, ErrCode, ErrCode);
  case ErrCode of
    421 : Result:= Result + ERROR_421;
    450 : Result:= Result + ERROR_450;
    451 : Result:= Result + ERROR_451;
    452 : Result:= Result + ERROR_452;
    500 : Result:= Result + ERROR_500;
    501 : Result:= Result + ERROR_501;
    502 : Result:= Result + ERROR_502;
    503 : Result:= Result + ERROR_503;
    504 : Result:= Result + ERROR_504;
    535 : Result:= Result + ERROR_535;
    550 : Result:= Result + ERROR_550;
    552 : Result:= Result + ERROR_552;
    553 : Result:= Result + ERROR_553;
    554 : Result:= Result + ERROR_554;
  end;
Result:= Result + #13#13 +'����� �������:' + #13 + Answer;
end;

constructor TNVLightSMTP.Create;
begin
  FMsgBody:= TStringList.Create;
  FCopyToList:= TStringList.Create;
  FFilesToSend:= TStringList.Create;
  FCharset:= 'Windows-1251';
  FXMailer:= 'LighSMTP Mailer';
end;

destructor TNVLightSMTP.Destroy;
begin
  FMsgBody.Free;
  FCopyToList.Free;
  FFilesToSend.Free;
end;

function TNVLightSMTP.ReceiveError(Code: String): Boolean;
begin
Result:= False;
if ExistInArray(StrToInt(Code), BadCode)<> -1 then
 Result:= True;
end;

procedure TNVLightSMTP.SetMBLines(Value: TStringList);
begin
  FMsgBody.Assign(Value);
end;

procedure TNVLightSMTP.SetCopyToLines(Value: TStringList);
begin
  FCopyToList.Assign(Value);
end;

procedure TNVLightSMTP.SetFTSList(Value: TStringList);
begin
  FFilesToSend.Assign(Value);
end;

procedure TNVLightSMTP.GetServerAnswer(Answer: string);
begin
 // Must be empty!
end;

procedure TNVLightSMTP.ServerConnected(Sender: TObject);
begin
 // Must be empty!
end;

procedure TNVLightSMTP.SendProgress(Total, Current: Integer);
begin
 // Must be empty!
end;

function TNVLightSMTP.GenerateBoundary: string;
const StrTable = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
var
  N, X: SmallInt;
begin
  SetLength(Result, 14);
  N := 0;
  while N < 14 do begin
    X := Random(37) + 1;
    if (pos(StrTable[X], result) = 0) then begin
      inc(N);
      Result[N] := StrTable[X];
    end;
  end;
end;

function GetLocalHost: string;
var
 Buff : array [0..255] of Char;
begin
 if GetHostName(Buff, 255) = 0 then
  Result := StrPas(Buff)
 else
  Result := 'lightsmtp';
end;

function LookupName(Str: string): TInAddr;
var
  hostEnt: PHostEnt;
  inAddr: TInAddr;
begin
  if (LowerCase(str)[1] IN ['a'..'z']) OR
      (LowerCase(str)[2] IN ['a'..'z']) then
  begin
    hostEnt := GetHostByName(PChar(Str));
    FillChar(inAddr, SizeOf(inAddr), 0);
    if hostEnt<>nil then
    begin
      with hostEnt^, inAddr do
      begin
        s_un_b.s_b1 := h_addr^[0];
        s_un_b.s_b2 := h_addr^[1];
        s_un_b.s_b3 := h_addr^[2];
        s_un_b.s_b4 := h_addr^[3];
      end;
    end;
  end
  else
    inAddr.s_addr := inet_addr(PChar(str));
 Result:= inAddr;
end;

function CreateSocket(serverAddress: string; port: integer): TSocket;
var
  iSocket: TSocket;
begin
 iSocket := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
 if iSocket = INVALID_SOCKET then
 begin
  Result:=0;
  Exit;
 end;
 Server_Addr.sin_family := AF_INET;
 Server_Addr.sin_addr.S_addr := htonl (INADDR_ANY);
 Server_Addr.sin_port := htons(port);
 Server_Addr.sin_addr := lookupname(ServerAddress);
 Result := iSocket;
end;

function TNVLightSMTP.SendToSocket(Cmd: string):integer;
var
 Buff :array [0..255] of Char;
begin
  Result:=0;
  Cmd := Cmd + CRLF;
  CopyMemory(@Buff, PChar(Cmd), Length(Cmd));
  Result:= Send(FSocket, Buff, Length(Cmd), 0);
end;

function TNVLightSMTP.ReadFromSocket: String;
var
  Buff: array [0..255] of Char;
  Str: AnsiString;
  Ret: Integer;
begin
  Sleep(100);
  Result:='';
  FillChar(Buff, SizeOf(Buff), 0);
  Ret := Recv(FSocket, Buff, 1024, 0);
  if Ret = -1 then
  begin
    Result:='';
    Exit;
  end;
  Str := Buff;
  while Pos(#13, Str)>0 do
  begin
    Result := Result+Copy(Str, 1, pos(#13, Str));
    Delete(Str, 1, pos(#13, Str)+1);
  end;
 RecCode:= Copy(Result, 1, 3);
 Answer:= Result;
end;

procedure TNVLightSMTP.SendFile(FN: String);
const
  Base64MaxLength = 72;
var
  base64String: String;
  hFile: Integer;
  Buf: array[0..2] Of Byte;
  Base64: TBase64;
begin
    hFile:=FileOpen(FN, fmOpenRead or fmShareDenyNone);
    if hFile= -1 then
    begin
      raise Exception.Create('���������� �������� ������ � �����: "'+#13+FN+'"');
      Exit;
    end;

    SendToSocket('Content-Type: application/octet-stream; name="'+ExtractFileName(FN)+'"');
    SendToSocket('Content-Transfer-Encoding: base64');
    SendToSocket('Content-Disposition: attachment; filename="'+ExtractFileName(FN)+'"');
    SendToSocket('Content-Description: attachment');
    SendToSocket('');
    base64String:='';

    FillChar(Buf,SizeOf(Buf),#0);
    // �������� �����������
    repeat
      Base64.ByteCount:= FileRead(hFile, Buf, SizeOf(Buf));
      Move(Buf, Base64.ByteArr, SizeOf(Buf));
      base64String:= base64String + CodeBase64(Base64);
      if Length(base64String)=Base64MaxLength then
      begin
        SendToSocket(base64String);
        base64String:='';
      end;
    until Base64.ByteCount < 3;
    SendToSocket(base64String);
    FileClose(hFile);
end;

procedure TNVLightSMTP.SendMail;
var Buff: String;
    I: integer;
    Boundary, Log: String;
begin
 Log:='';
 if WSAStartup(MakeWord(2,0), wData)<>0 then
  begin
   raise Exception.Create(GetWinSockError);
   Exit;
  end;
 // ���� �������������
 Sleep(50);
 //������� ����� ��� ���������� � smtp �������
 FSocket := CreateSocket(FHost, FPort);
 //�������� ��������� �����. ���� ����� 0, �� ������ �������� ������
 if (FSocket = 0) then
 begin
  raise Exception.Create('���������� ������� �����!');
  Exit;
 end;
 //������� �������������� � smtp �������
 if (Connect(FSocket, Server_Addr, sizeOf(Server_Addr)) = SOCKET_ERROR) then
 begin
  // ������� �������
  raise Exception.Create(GetWinSockError);
  Exit;
 end;
 Sleep(100);
 // ������ ����������� �������
 Log:=Log+ReadFromSocket+#13;

 // ����������� ��������� Boundary
 Boundary:=GenerateBoundary;
 // �������������� ������
 SendToSocket('HELO ' + GetLocalHost);
 Log:=Log+ReadFromSocket+#13;

  // ������������ �� �������
 case Authorization of
  atAuthNone: {������ �� �������� �������} ;
  atAuthLogin: SendToSocket('AUTH LOGIN '+Base64Encode(FUsername+#0+FPassword));
  atAuthPlain: SendToSocket('AUTH PLAIN '+Base64Encode(FUsername+#0+FUsername+#0+FPassword));
 end;
 Log:=Log+ReadFromSocket+#13;

 // ������ �� �����������
 SendToSocket('MAIL FROM:<'+FUsername+'>');
 Log:=Log+ReadFromSocket+#13;

 // ������ �� �����������
 SendToSocket('RCPT TO:<'+FSendTo+'>');
 for I := 0 to FCopyToList.Count - 1 do
       SendToSocket('RCPT TO:<'+FCopyToList.Strings[i]+'>');
 //��������� ��������� ������
 SendToSocket('DATA');
 Log:=Log+ReadFromSocket+#13;

 //�� ����
 //��� ��������� ������� ReadFromSocket ������,
 //����� ���������� Incoming data timeout.
 SendToSocket('From:<'+FUsername+'>');
 // BUG!!: FOnReceive(ReadFromSocket) ���-���-���...
 //����
 SendToSocket('To:<'+FSendTo+'>');
 //���� ������
 SendToSocket('Subject: '+FSubject);
 // ���������
 SendToSocket('Mime-Version: 1.0');
  //��������� �����������
 SendToSocket('X-Mailer: '+FXMailer);
 // ��� ������
 SendToSocket('Content-Type: multipart/mixed;');
 // �������� �������������� Boundary
 SendToSocket(' boundary="----------'+Boundary+'"');
 // Boundary ������
 SendToSocket('------------'+Boundary);
 // ��������� ������
 case ContentType of
  ctTextPlain: SendToSocket('Content-Type: text/plain; charset='+Charset);
  ctTextHTML: SendToSocket('Content-Type: text/html; charset='+Charset);
 end;
 // ��������� ��� �����������: 7bit ��� 8bit
 SendToSocket('Content-Transfer-Encoding: 8bit');
 // � ������ ������ ��������� �������� ������ ������
 SendToSocket('');
  //����� ������
 For I:=0 to FMsgBody.Count-1 do
 begin
     Buff:=FMsgBody.Strings[i];
     if SendToSocket(Buff) = SOCKET_ERROR then
       raise Exception.Create(GetResponseError);
 end;
 // ���� ����� ��� ��������
 if FFilesToSend.Count > 0 then
 begin
  for I := 0 to FFilesToSend.Count - 1 do
   begin
    SendToSocket('------------'+Boundary);
    // ���������� ����������� ����
    SendFile(FFilesToSend[i]);
   end;
 end;
 // ��������� �� ����� MIME �����
 SendToSocket('------------' + Boundary + '--');
 // ����� ���������
 SendToSocket(CRLF + '.' + CRLF);
 Log:=Log+ReadFromSocket+#13;

 // �������� ������ �������� ������
 SendToSocket('QUIT');
 Log:=Log+ReadFromSocket+#13;

 // �������� ������
 CloseSocket(FSocket);
 WSACleanup;
 if ShowLog then MessageBox(0, PChar(Log), 'Log', $000040+ MB_OK);
end;

end.

