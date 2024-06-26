import 'package:json_annotation/json_annotation.dart';
import 'package:sphia/core/rule/xray.dart';

part 'config.g.dart';

@JsonSerializable()
class XrayConfig {
  Log? log;
  Dns? dns;
  List<Inbound>? inbounds;
  List<Outbound>? outbounds;
  Routing? routing;
  Api? api;
  Policy? policy;
  Stats? stats;

  XrayConfig({
    this.log,
    this.dns,
    this.inbounds,
    this.outbounds,
    this.routing,
    this.api,
    this.policy,
    this.stats,
  });

  factory XrayConfig.fromJson(Map<String, dynamic> json) =>
      _$XrayConfigFromJson(json);

  Map<String, dynamic> toJson() => _$XrayConfigToJson(this);
}

@JsonSerializable()
class Sniffing {
  bool enabled = true;
  List<String> destOverride = ['http', 'tls'];

  Sniffing();

  factory Sniffing.fromJson(Map<String, dynamic> json) =>
      _$SniffingFromJson(json);

  Map<String, dynamic> toJson() => _$SniffingToJson(this);
}

@JsonSerializable()
class Dns {
  List<DnsServer> servers;

  Dns({
    required this.servers,
  });

  factory Dns.fromJson(Map<String, dynamic> json) => _$DnsFromJson(json);

  Map<String, dynamic> toJson() => _$DnsToJson(this);
}

@JsonSerializable()
class DnsServer {
  String address;
  List<String>? domains;
  bool? skipFallback;

  DnsServer({
    required this.address,
    this.domains,
    this.skipFallback,
  });

  factory DnsServer.fromJson(Map<String, dynamic> json) =>
      _$DnsServerFromJson(json);

  Map<String, dynamic> toJson() => _$DnsServerToJson(this);
}

@JsonSerializable()
class Log {
  String? access;
  String? error;
  String loglevel;

  Log({
    this.access,
    this.error,
    required this.loglevel,
  });

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);

  Map<String, dynamic> toJson() => _$LogToJson(this);
}

@JsonSerializable()
class Inbound {
  String? tag;
  int port;
  String listen;
  String protocol;
  Sniffing? sniffing;
  InboundSetting settings;

  Inbound({
    this.tag,
    required this.port,
    required this.listen,
    required this.protocol,
    this.sniffing,
    required this.settings,
  });

  factory Inbound.fromJson(Map<String, dynamic> json) =>
      _$InboundFromJson(json);

  Map<String, dynamic> toJson() => _$InboundToJson(this);
}

@JsonSerializable()
class InboundSetting {
  String? auth;
  List<Accounts>? accounts;
  bool? udp;
  String? address;

  InboundSetting({
    this.auth,
    this.accounts,
    this.udp,
    this.address,
  });

  factory InboundSetting.fromJson(Map<String, dynamic> json) =>
      _$InboundSettingFromJson(json);

  Map<String, dynamic> toJson() => _$InboundSettingToJson(this);
}

@JsonSerializable()
class Accounts {
  String user;
  String pass;

  Accounts({
    required this.user,
    required this.pass,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) =>
      _$AccountsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountsToJson(this);
}

@JsonSerializable()
class Outbound {
  String? tag;
  String protocol;
  OutboundSetting? settings;
  StreamSettings? streamSettings;
  Mux? mux;

  Outbound({
    this.tag,
    required this.protocol,
    this.settings,
    this.streamSettings,
    this.mux,
  });

  factory Outbound.fromJson(Map<String, dynamic> json) =>
      _$OutboundFromJson(json);

  Map<String, dynamic> toJson() => _$OutboundToJson(this);
}

@JsonSerializable()
class OutboundSetting {
  List<Vnext>? vnext;
  List<dynamic>? servers;

  OutboundSetting({
    this.vnext,
    this.servers,
  });

  factory OutboundSetting.fromJson(Map<String, dynamic> json) =>
      _$OutboundSettingFromJson(json);

  Map<String, dynamic> toJson() => _$OutboundSettingToJson(this);
}

@JsonSerializable()
class Socks {
  String address;
  int port;
  List<User>? users;

  Socks({
    required this.address,
    required this.port,
    this.users,
  });

  factory Socks.fromJson(Map<String, dynamic> json) => _$SocksFromJson(json);

  Map<String, dynamic> toJson() => _$SocksToJson(this);
}

@JsonSerializable()
class Vnext {
  String address;
  int port;
  List<User> users;

  Vnext({
    required this.address,
    required this.port,
    required this.users,
  });

  factory Vnext.fromJson(Map<String, dynamic> json) => _$VnextFromJson(json);

  Map<String, dynamic> toJson() => _$VnextToJson(this);
}

@JsonSerializable()
class Shadowsocks {
  String address;
  int port;
  String method;
  String password;

  Shadowsocks({
    required this.address,
    required this.port,
    required this.method,
    required this.password,
  });

  factory Shadowsocks.fromJson(Map<String, dynamic> json) =>
      _$ShadowsocksFromJson(json);

  Map<String, dynamic> toJson() => _$ShadowsocksToJson(this);
}

@JsonSerializable()
class Trojan {
  String address;
  int port;
  String password;

  Trojan({
    required this.address,
    required this.port,
    required this.password,
  });

  factory Trojan.fromJson(Map<String, dynamic> json) => _$TrojanFromJson(json);

  Map<String, dynamic> toJson() => _$TrojanToJson(this);
}

@JsonSerializable()
class User {
  String? user;
  String? pass;
  String? id;
  int? alterId;
  String? security;
  String? encryption;
  String? flow;

  User({
    this.user,
    this.pass,
    this.id,
    this.alterId,
    this.security,
    this.encryption,
    this.flow,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class StreamSettings {
  String network;
  String security;
  TlsSettings? tlsSettings;
  RealitySettings? realitySettings;
  TcpSettings? tcpSettings;
  WsSettings? wsSettings;
  GrpcSettings? grpcSettings;
  HttpUpgradeSettings? httpUpgradeSettings;

  StreamSettings({
    required this.network,
    required this.security,
    this.tlsSettings,
    this.realitySettings,
    this.tcpSettings,
    this.wsSettings,
    this.grpcSettings,
    this.httpUpgradeSettings,
  });

  factory StreamSettings.fromJson(Map<String, dynamic> json) =>
      _$StreamSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$StreamSettingsToJson(this);
}

@JsonSerializable()
class TcpSettings {
  Header? header;

  TcpSettings({
    this.header,
  });

  factory TcpSettings.fromJson(Map<String, dynamic> json) =>
      _$TcpSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$TcpSettingsToJson(this);
}

@JsonSerializable()
class Header {
  String? type;
  Request? request;

  Header({
    this.type,
    this.request,
  });

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderToJson(this);
}

@JsonSerializable()
class Request {
  String? version;
  String? method;
  List<String>? path;
  TcpHeaders? headers;

  Request({
    this.version,
    this.method,
    this.path,
    this.headers,
  });

  factory Request.defaults() => Request(
        version: '1.1',
        method: 'GET',
        path: ['/'],
        headers: TcpHeaders.defaults(),
      );

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

@JsonSerializable()
class TcpHeaders {
  @JsonKey(name: 'Host')
  List<String>? host;
  @JsonKey(name: 'User-Agent')
  List<String>? userAgent;
  @JsonKey(name: 'Accept-Encoding')
  List<String>? acceptEncoding;
  @JsonKey(name: 'Connection')
  List<String>? connection;
  @JsonKey(name: 'Pragma')
  String? pragma;

  TcpHeaders({
    this.host,
    this.userAgent,
    this.acceptEncoding,
    this.connection,
    this.pragma,
  });

  factory TcpHeaders.defaults() => TcpHeaders(
        host: [''],
        userAgent: [''],
        acceptEncoding: ['gzip, deflate'],
        connection: ['keep-alive'],
        pragma: 'no-cache',
      );

  factory TcpHeaders.fromJson(Map<String, dynamic> json) =>
      _$TcpHeadersFromJson(json);

  Map<String, dynamic> toJson() => _$TcpHeadersToJson(this);
}

@JsonSerializable()
class GrpcSettings {
  String? serviceName;
  bool? multiMode;

  GrpcSettings({
    this.serviceName,
    this.multiMode,
  });

  factory GrpcSettings.fromJson(Map<String, dynamic> json) =>
      _$GrpcSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$GrpcSettingsToJson(this);
}

@JsonSerializable()
class WsSettings {
  String path;
  Headers? headers;

  WsSettings({
    required this.path,
    this.headers,
  });

  factory WsSettings.fromJson(Map<String, dynamic> json) =>
      _$WsSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$WsSettingsToJson(this);
}

@JsonSerializable()
class Headers {
  String? host;

  Headers({
    this.host,
  });

  factory Headers.fromJson(Map<String, dynamic> json) =>
      _$HeadersFromJson(json);

  Map<String, dynamic> toJson() => _$HeadersToJson(this);
}

@JsonSerializable()
class TlsSettings {
  bool allowInsecure;
  String? serverName;
  String? fingerprint;

  TlsSettings({
    required this.allowInsecure,
    this.serverName,
    this.fingerprint,
  });

  factory TlsSettings.fromJson(Map<String, dynamic> json) =>
      _$TlsSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$TlsSettingsToJson(this);
}

@JsonSerializable()
class RealitySettings {
  String? serverName;
  String fingerprint;
  String? shortId;
  String publicKey;
  String? spiderX;

  RealitySettings({
    this.serverName,
    required this.fingerprint,
    this.shortId,
    required this.publicKey,
    this.spiderX,
  });

  factory RealitySettings.fromJson(Map<String, dynamic> json) =>
      _$RealitySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$RealitySettingsToJson(this);
}

@JsonSerializable()
class HttpUpgradeSettings {
  String path;
  Headers? headers;

  HttpUpgradeSettings({
    required this.path,
    this.headers,
  });

  factory HttpUpgradeSettings.fromJson(Map<String, dynamic> json) =>
      _$HttpUpgradeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$HttpUpgradeSettingsToJson(this);
}

@JsonSerializable()
class Mux {
  bool enabled;
  int concurrency;

  Mux({
    required this.enabled,
    required this.concurrency,
  });

  factory Mux.fromJson(Map<String, dynamic> json) => _$MuxFromJson(json);

  Map<String, dynamic> toJson() => _$MuxToJson(this);
}

@JsonSerializable()
class Routing {
  String domainStrategy;

  String domainMatcher;

  List<XrayRule> rules;

  Routing({
    required this.domainStrategy,
    required this.domainMatcher,
    required this.rules,
  });

  factory Routing.fromJson(Map<String, dynamic> json) =>
      _$RoutingFromJson(json);

  Map<String, dynamic> toJson() => _$RoutingToJson(this);
}

@JsonSerializable()
class Api {
  String tag;
  List<String>? services;

  Api({
    required this.tag,
    this.services,
  });

  factory Api.fromJson(Map<String, dynamic> json) => _$ApiFromJson(json);

  Map<String, dynamic> toJson() => _$ApiToJson(this);
}

@JsonSerializable()
class Policy {
  System system;

  Policy({
    required this.system,
  });

  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyToJson(this);
}

@JsonSerializable()
class System {
  bool? statsInboundUplink;
  bool? statsInboundDownlink;
  bool? statsOutboundUplink;
  bool? statsOutboundDownlink;

  System({
    this.statsInboundUplink,
    this.statsInboundDownlink,
    this.statsOutboundUplink,
    this.statsOutboundDownlink,
  });

  factory System.fromJson(Map<String, dynamic> json) => _$SystemFromJson(json);

  Map<String, dynamic> toJson() => _$SystemToJson(this);
}

@JsonSerializable()
class Stats {
  Stats();

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
