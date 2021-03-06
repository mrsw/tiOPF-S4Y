unit tiWebServerClientConnectionDetails;

interface
uses
   tiBaseObject
 ;

type

  TtiWebServerClientConnectionDetails = class(TtiBaseObject)
  private
    FConnectWith: string;
    FProxyServerPort: Integer;
    FProxyServerActive: Boolean;
    FAppServerURL: string;
    FProxyServerName: string;
    FLongword: Longword;
    FRetryLimit: byte;
    FResolveTimeout: Longword;
    FConnectTimeout: Longword;
    FSendTimeout: Longword;
    FReceiveTimeout: Longword;
  public
    constructor Create;
    property AppServerURL: string read FAppServerURL write FAppServerURL;
    property ConnectWith: string read FConnectWith write FConnectWith;
    property ProxyServerActive: Boolean read FProxyServerActive write FProxyServerActive;
    property ProxyServerName: string read FProxyServerName write FProxyServerName;
    property ProxyServerPort: Integer read FProxyServerPort write FProxyServerPort;
    property BlockSize: Longword read FLongword write FLongword;
    property RetryLimit: byte read FRetryLimit write FRetryLimit;
    property ResolveTimeout: Longword read FResolveTimeout write FResolveTimeout;
    property ConnectTimeout: Longword read FConnectTimeout write FConnectTimeout;
    property SendTimeout: Longword read FSendTimeout write FSendTimeout;
    property ReceiveTimeout: Longword read FReceiveTimeout write FReceiveTimeout;

    procedure Assign(const ASource: TtiWebServerClientConnectionDetails);
    function  Equals(const ACompareWith: TtiWebServerClientConnectionDetails): boolean; reintroduce;

  end;

implementation
uses
  tiConstants
  ;

{ TtiWebServerClientConnectionDetails }

procedure TtiWebServerClientConnectionDetails.Assign(
  const ASource: TtiWebServerClientConnectionDetails);
begin
  Assert(ASource.TestValid, CTIErrorInvalidObject);
  AppServerURL:=      ASource.AppServerURL;
  ConnectWith:=       ASource.ConnectWith;
  ProxyServerActive:= ASource.ProxyServerActive;
  ProxyServerName:=   ASource.ProxyServerName;
  ProxyServerPort:=   ASource.ProxyServerPort;
  BlockSize:=         ASource.BlockSize;
  RetryLimit:=        ASource.RetryLimit;
  ResolveTimeout:=    ASource.ResolveTimeout;
  ConnectTimeout:=    ASource.ConnectTimeout;
  SendTimeout:=       ASource.SendTimeout;
  ReceiveTimeout:=    ASource.ReceiveTimeout;
end;

constructor TtiWebServerClientConnectionDetails.Create;
begin
  inherited Create;
  FRetryLimit:= 1;
end;

function TtiWebServerClientConnectionDetails.Equals(
  const ACompareWith: TtiWebServerClientConnectionDetails): boolean;
begin
  result:=
    (AppServerURL = ACompareWith.AppServerURL) and
    (ConnectWith = ACompareWith.ConnectWith) and
    (ProxyServerActive = ACompareWith.ProxyServerActive) and
    (ProxyServerName = ACompareWith.ProxyServerName) and
    (ProxyServerPort = ACompareWith.ProxyServerPort) and
    (BlockSize = ACompareWith.BlockSize) and
    (RetryLimit = ACompareWith.RetryLimit) and
    (ResolveTimeout = ACompareWith.ResolveTimeout) and
    (ConnectTimeout = ACompareWith.ConnectTimeout) and
    (SendTimeout = ACompareWith.SendTimeout) and
    (ReceiveTimeout = ACompareWith.ReceiveTimeout);
end;

end.

