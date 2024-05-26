import 'package:freezed_annotation/freezed_annotation.dart';

part 'sphia.freezed.dart';

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

enum CustomServerProvider { sing, xray, hysteria }

enum TunProvider { sing }

enum TunStack { system, gvisor, mixed }

@freezed
class SphiaConfig with _$SphiaConfig {
  const factory SphiaConfig({
    @Default(false) bool startOnBoot,
    @Default(false) bool autoRunServer,
    @Default(false) bool useMaterial3,
    @Default(NavigationStyle.rail) NavigationStyle navigationStyle,
    @Default(false) bool darkMode,
    @Default(4278430196) int themeColor,
    @Default(false) bool showTransport,
    @Default(false) bool showAddress,
    @Default(false) bool enableStatistics,
    @Default(false) bool enableSpeedChart,
    @Default('http://cp.cloudflare.com') String latencyTestUrl,
    // @Default(-1) int updateSubscriptionInterval,
    @Default(false) bool updateThroughProxy,
    @Default(UserAgent.chrome) UserAgent userAgent,
    @Default(false) bool autoGetIp,
    @Default(false) bool autoConfigureSystemProxy,
    @Default(false) bool multiOutboundSupport,
    @Default(false) bool enableTun,
    @Default(11111) int socksPort,
    @Default(11112) int httpPort,
    @Default(11113) int mixedPort,
    @Default('127.0.0.1') String listen,
    @Default(true) bool enableUdp,
    @Default(false) bool authentication,
    @Default('sphia') String user,
    @Default('where_is_self') String password,
    @Default(11110) int coreApiPort,
    @Default(true) bool enableSniffing,
    @Default(true) bool configureDns,
    @Default('https://dns.google/dns-query') String remoteDns,
    @Default('https+local://dns.alidns.com/dns-query') String directDns,
    @Default('223.5.5.5') String dnsResolver,
    @Default(DomainStrategy.IPIfNonMatch) DomainStrategy domainStrategy,
    @Default(DomainMatcher.hybrid) DomainMatcher domainMatcher,
    @Default(true) bool enableCoreLog,
    @Default(LogLevel.warning) LogLevel logLevel,
    @Default(64) int maxLogCount,
    @Default(false) bool saveCoreLog,
    @Default(RoutingProvider.sing) RoutingProvider routingProvider,
    @Default(VmessProvider.sing) VmessProvider vmessProvider,
    @Default(VlessProvider.sing) VlessProvider vlessProvider,
    @Default(ShadowsocksProvider.sing) ShadowsocksProvider shadowsocksProvider,
    @Default(TrojanProvider.sing) TrojanProvider trojanProvider,
    @Default(HysteriaProvider.sing) HysteriaProvider hysteriaProvider,
    @Default('/usr/bin/code') String editorPath,
    @Default(11114) int additionalSocksPort,
    @Default(TunProvider.sing) TunProvider tunProvider,
    @Default(true) bool enableIpv4,
    @Default('172.19.0.1/30') String ipv4Address,
    @Default(false) bool enableIpv6,
    @Default('fdfe:dcba:9876::1/126') String ipv6Address,
    @Default(9000) int mtu,
    @Default(false) bool endpointIndependentNat,
    @Default(TunStack.system) TunStack stack,
    @Default(true) bool autoRoute,
    @Default(false) bool strictRoute,
  }) = _SphiaConfig;

  factory SphiaConfig.fromJson(Map<String, dynamic> json) =>
      _$SphiaConfigFromJson(json);
}

extension GetUserAgent on SphiaConfig {
  String getUserAgent() {
    return userAgents[UserAgent.values[userAgent.index].name]!;
  }
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
