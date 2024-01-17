import 'package:json_annotation/json_annotation.dart';

part 'sphia.g.dart';

enum NavigationStyle { rail, drawer }

enum UserAgent { chrome, firefox, safari, edge, none }

// ignore: constant_identifier_names
enum DomainStrategy { AsIs, IPIfNonMatch, IPOnDemand }

enum DomainMatcher { hybrid, linear }

enum LogLevel { none, warning, debug, error, info }

enum RoutingProvider { sing, xray }

enum VmessProvider { sing, xray }

enum VlessProvider { sing, xray }

enum ShadowsocksProvider { sing, xray, ssrust }

enum TrojanProvider { sing, xray }

enum HysteriaProvider { sing, hysteria }

enum TunProvider { sing }

enum TunStack { system, gvisor, mixed }

@JsonSerializable(includeIfNull: false)
class SphiaConfig {
  /* Sphia */
  bool startOnBoot;
  bool autoRunServer;
  bool useMaterial3;
  int navigationStyle;
  bool darkMode;
  int themeColor;
  bool showAddress;
  bool enableStatistics;
  bool enableSpeedChart;
  int updateSubscribeInterval;
  bool updateThroughProxy;
  int userAgent;

  /* Proxy */
  bool autoGetIp;
  bool autoConfigureSystemProxy;
  bool multiOutboundSupport;
  bool enableTun;
  int socksPort;
  int httpPort;
  int mixedPort;
  String listen;
  bool enableUdp;
  bool authentication;
  String user;
  String password;

  /* Core */
  int coreApiPort;
  bool enableSniffing;
  bool configureDns;
  String remoteDns;
  String directDns;
  int domainStrategy;
  int domainMatcher;
  bool enableCoreLog;
  int logLevel;
  int maxLogCount;
  bool saveCoreLog;

  /* Provider */
  int routingProvider;
  int vmessProvider;
  int vlessProvider;
  int shadowsocksProvider;
  int trojanProvider;
  int hysteriaProvider;
  int additionalSocksPort;

  /* Tun */
  int tunProvider;
  bool enableIpv4;
  String ipv4Address;
  bool enableIpv6;
  String ipv6Address;
  int mtu;
  bool endpointIndependentNat;
  int stack;
  bool autoRoute;
  bool strictRoute;

  SphiaConfig({
    required this.startOnBoot,
    required this.autoRunServer,
    required this.useMaterial3,
    required this.navigationStyle,
    required this.darkMode,
    required this.themeColor,
    required this.showAddress,
    required this.enableStatistics,
    required this.enableSpeedChart,
    required this.updateSubscribeInterval,
    required this.updateThroughProxy,
    required this.userAgent,
    required this.autoGetIp,
    required this.autoConfigureSystemProxy,
    required this.multiOutboundSupport,
    required this.enableTun,
    required this.socksPort,
    required this.httpPort,
    required this.mixedPort,
    required this.listen,
    required this.enableUdp,
    required this.authentication,
    required this.user,
    required this.password,
    required this.coreApiPort,
    required this.enableSniffing,
    required this.configureDns,
    required this.remoteDns,
    required this.directDns,
    required this.domainStrategy,
    required this.domainMatcher,
    required this.enableCoreLog,
    required this.logLevel,
    required this.maxLogCount,
    required this.saveCoreLog,
    required this.routingProvider,
    required this.vmessProvider,
    required this.vlessProvider,
    required this.shadowsocksProvider,
    required this.trojanProvider,
    required this.hysteriaProvider,
    required this.additionalSocksPort,
    required this.tunProvider,
    required this.enableIpv4,
    required this.ipv4Address,
    required this.enableIpv6,
    required this.ipv6Address,
    required this.mtu,
    required this.endpointIndependentNat,
    required this.stack,
    required this.autoRoute,
    required this.strictRoute,
  });

  factory SphiaConfig.defaults() {
    return SphiaConfig(
      startOnBoot: false,
      autoRunServer: false,
      useMaterial3: false,
      navigationStyle: NavigationStyle.rail.index,
      darkMode: false,
      themeColor: 4278430196,
      showAddress: false,
      enableStatistics: false,
      enableSpeedChart: false,
      updateSubscribeInterval: -1,
      updateThroughProxy: false,
      userAgent: UserAgent.chrome.index,
      autoGetIp: false,
      autoConfigureSystemProxy: false,
      multiOutboundSupport: false,
      enableTun: false,
      socksPort: 11111,
      httpPort: 11112,
      mixedPort: 11113,
      listen: '127.0.0.1',
      enableUdp: true,
      authentication: false,
      user: 'sphia',
      password: 'where_is_self',
      coreApiPort: 11110,
      enableSniffing: true,
      configureDns: true,
      remoteDns: 'https://dns.google/dns-query',
      directDns: 'https+local://doh.pub/dns-query',
      domainStrategy: DomainStrategy.IPIfNonMatch.index,
      domainMatcher: DomainMatcher.hybrid.index,
      enableCoreLog: true,
      logLevel: LogLevel.warning.index,
      maxLogCount: 64,
      saveCoreLog: false,
      routingProvider: RoutingProvider.sing.index,
      vmessProvider: VmessProvider.sing.index,
      vlessProvider: VlessProvider.sing.index,
      shadowsocksProvider: ShadowsocksProvider.sing.index,
      trojanProvider: TrojanProvider.sing.index,
      hysteriaProvider: HysteriaProvider.sing.index,
      additionalSocksPort: 11114,
      tunProvider: TunProvider.sing.index,
      enableIpv4: true,
      ipv4Address: '172.19.0.1/30',
      enableIpv6: false,
      ipv6Address: 'fdfe:dcba:9876::1/126',
      mtu: 9000,
      endpointIndependentNat: false,
      stack: TunStack.system.index,
      autoRoute: true,
      strictRoute: false,
    );
  }

  String getUserAgent() {
    return userAgents[UserAgent.values[userAgent].name]!;
  }

  factory SphiaConfig.fromJson(Map<String, dynamic> json) =>
      _$SphiaConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SphiaConfigToJson(this);
}

const Map<String, String> userAgents = {
  'chrome':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36',
  'firefox':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:90.0) Gecko/20100101 Firefox/90.0',
  'safari':
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15',
  'edge':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.70',
  'none': ''
};
