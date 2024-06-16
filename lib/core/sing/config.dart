import 'package:json_annotation/json_annotation.dart';
import 'package:sphia/core/rule/sing.dart';

part 'config.g.dart';

@JsonSerializable()
class SingBoxConfig {
  Log? log;
  Dns? dns;
  Route? route;
  List<Inbound>? inbounds;
  List<Outbound>? outbounds;
  Experimental? experimental;

  SingBoxConfig({
    this.log,
    this.dns,
    this.route,
    this.inbounds,
    this.outbounds,
    this.experimental,
  });

  factory SingBoxConfig.fromJson(Map<String, dynamic> json) =>
      _$SingBoxConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SingBoxConfigToJson(this);
}

@JsonSerializable()
class Log {
  bool disabled;
  String? level;
  String? output;
  bool timestamp;

  Log({
    required this.disabled,
    this.level,
    this.output,
    required this.timestamp,
  });

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);

  Map<String, dynamic> toJson() => _$LogToJson(this);
}

@JsonSerializable()
class Dns {
  List<DnsServer> servers;
  List<SingBoxDnsRule> rules;
  @JsonKey(name: 'final')
  String? finalTag;

  Dns({
    required this.servers,
    required this.rules,
    this.finalTag,
  });

  factory Dns.fromJson(Map<String, dynamic> json) => _$DnsFromJson(json);

  Map<String, dynamic> toJson() => _$DnsToJson(this);
}

@JsonSerializable()
class DnsServer {
  String tag;
  String address;
  @JsonKey(name: 'address_resolver')
  String? addressResolver;
  String? strategy;
  String? detour;

  DnsServer({
    required this.tag,
    required this.address,
    this.addressResolver,
    this.strategy,
    this.detour,
  });

  factory DnsServer.fromJson(Map<String, dynamic> json) =>
      _$DnsServerFromJson(json);

  Map<String, dynamic> toJson() => _$DnsServerToJson(this);
}

@JsonSerializable()
class Route {
  Geoip? geoip;
  Geosite? geosite;
  List<SingBoxRule> rules;
  @JsonKey(name: 'auto_detect_interface')
  bool autoDetectInterface;
  @JsonKey(name: 'final')
  String? finalTag;

  Route({
    this.geoip,
    this.geosite,
    required this.rules,
    required this.autoDetectInterface,
    this.finalTag,
  });

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}

@JsonSerializable()
class Geoip {
  String path;

  Geoip({
    required this.path,
  });

  factory Geoip.fromJson(Map<String, dynamic> json) => _$GeoipFromJson(json);

  Map<String, dynamic> toJson() => _$GeoipToJson(this);
}

@JsonSerializable()
class Geosite {
  String path;

  Geosite({
    required this.path,
  });

  factory Geosite.fromJson(Map<String, dynamic> json) =>
      _$GeositeFromJson(json);

  Map<String, dynamic> toJson() => _$GeositeToJson(this);
}

@JsonSerializable()
class Inbound {
  String type;
  String? tag;
  String? listen;
  @JsonKey(name: 'listen_port')
  int? listenPort;
  List<User>? users;
  @JsonKey(name: 'interface_name')
  String? interfaceName;
  @JsonKey(name: 'inet4_address')
  String? inet4Address;
  @JsonKey(name: 'inet6_address')
  String? inet6Address;
  int? mtu;
  @JsonKey(name: 'auto_route')
  bool? autoRoute;
  @JsonKey(name: 'strict_route')
  bool? strictRoute;
  String? stack;
  bool? sniff;
  @JsonKey(name: 'endpoint_independent_nat')
  bool? endpointIndependentNat;
  @JsonKey(name: 'domain_strategy')
  String? domainStrategy;

  Inbound({
    required this.type,
    this.tag,
    this.listen,
    this.listenPort,
    this.users,
    this.interfaceName,
    this.inet4Address,
    this.inet6Address,
    this.mtu,
    this.autoRoute,
    this.strictRoute,
    this.stack,
    this.sniff,
    this.endpointIndependentNat,
    this.domainStrategy,
  });

  factory Inbound.fromJson(Map<String, dynamic> json) =>
      _$InboundFromJson(json);

  Map<String, dynamic> toJson() => _$InboundToJson(this);
}

@JsonSerializable()
class Outbound {
  String type;
  String? tag;
  String? server;
  @JsonKey(name: 'server_port')
  int? serverPort;
  String? version;
  String? username;
  String? method;
  String? password;
  String? plugin;
  @JsonKey(name: 'plugin_opts')
  String? pluginOpts;
  String? uuid;
  String? flow;
  String? security;
  @JsonKey(name: 'alter_id')
  int? alterId;
  String? network;
  Tls? tls;
  Transport? transport;
  @JsonKey(name: 'up_mbps')
  int? upMbps;
  @JsonKey(name: 'down_mbps')
  int? downMbps;
  String? obfs;
  String? auth;
  @JsonKey(name: 'auth_str')
  String? authStr;
  @JsonKey(name: 'recv_window_conn')
  int? recvWindowConn;
  @JsonKey(name: 'recv_window')
  int? recvWindow;
  @JsonKey(name: 'disable_mtu_discovery')
  int? disableMtuDiscovery;

  Outbound({
    required this.type,
    this.tag,
    this.server,
    this.serverPort,
    this.version,
    this.username,
    this.method,
    this.password,
    this.plugin,
    this.pluginOpts,
    this.uuid,
    this.flow,
    this.security,
    this.alterId,
    this.network,
    this.tls,
    this.transport,
    this.upMbps,
    this.downMbps,
    this.obfs,
    this.auth,
    this.authStr,
    this.recvWindowConn,
    this.recvWindow,
    this.disableMtuDiscovery,
  });

  factory Outbound.fromJson(Map<String, dynamic> json) =>
      _$OutboundFromJson(json);

  Map<String, dynamic> toJson() => _$OutboundToJson(this);
}

@JsonSerializable()
class Tls {
  bool enabled;
  @JsonKey(name: 'server_name')
  String serverName;
  bool insecure;
  List<String>? alpn;
  UTls? utls;
  Reality? reality;

  Tls({
    required this.enabled,
    required this.serverName,
    required this.insecure,
    this.alpn,
    this.utls,
    this.reality,
  });

  factory Tls.fromJson(Map<String, dynamic> json) => _$TlsFromJson(json);

  Map<String, dynamic> toJson() => _$TlsToJson(this);
}

@JsonSerializable()
class UTls {
  bool enabled;
  String? fingerprint;

  UTls({
    required this.enabled,
    this.fingerprint,
  });

  factory UTls.fromJson(Map<String, dynamic> json) => _$UTlsFromJson(json);

  Map<String, dynamic> toJson() => _$UTlsToJson(this);
}

@JsonSerializable()
class Reality {
  bool enabled;
  @JsonKey(name: 'public_key')
  String publicKey;
  @JsonKey(name: "short_id")
  String? shortId;

  Reality({
    required this.enabled,
    required this.publicKey,
    this.shortId,
  });

  factory Reality.fromJson(Map<String, dynamic> json) =>
      _$RealityFromJson(json);

  Map<String, dynamic> toJson() => _$RealityToJson(this);
}

@JsonSerializable()
class Transport {
  String type;
  String? host;
  String? path;
  @JsonKey(name: 'service_name')
  String? serviceName;
  @JsonKey(name: 'max_early_data')
  int? maxEarlyData;
  @JsonKey(name: 'early_data_header_name')
  String? earlyDataHeaderName;
  Headers? headers;

  Transport({
    required this.type,
    this.host,
    this.path,
    this.serviceName,
    this.maxEarlyData,
    this.earlyDataHeaderName,
    this.headers,
  });

  factory Transport.fromJson(Map<String, dynamic> json) =>
      _$TransportFromJson(json);

  Map<String, dynamic> toJson() => _$TransportToJson(this);
}

@JsonSerializable()
class Headers {
  @JsonKey(name: 'Host')
  String host;

  Headers({
    required this.host,
  });

  factory Headers.fromJson(Map<String, dynamic> json) =>
      _$HeadersFromJson(json);

  Map<String, dynamic> toJson() => _$HeadersToJson(this);
}

@JsonSerializable()
class User {
  String? username;
  String? password;

  User({
    this.username,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Experimental {
  @JsonKey(name: 'clash_api')
  ClashApi? clashApi;
  @JsonKey(name: 'cache_file')
  CacheFile? cacheFile;

  Experimental({
    this.clashApi,
    this.cacheFile,
  });

  factory Experimental.fromJson(Map<String, dynamic> json) =>
      _$ExperimentalFromJson(json);

  Map<String, dynamic> toJson() => _$ExperimentalToJson(this);
}

@JsonSerializable()
class ClashApi {
  @JsonKey(name: 'external_controller')
  String externalController;
  @JsonKey(name: 'store_selected')
  bool? storeSelected; // deprecated since v1.8.0
  @JsonKey(name: 'cache_file')
  String? cacheFile; // deprecated since v1.8.0

  ClashApi({
    required this.externalController,
    this.storeSelected,
    this.cacheFile,
  });

  factory ClashApi.fromJson(Map<String, dynamic> json) =>
      _$ClashApiFromJson(json);

  Map<String, dynamic> toJson() => _$ClashApiToJson(this);
}

@JsonSerializable()
class CacheFile {
  bool enabled;
  String path;

  CacheFile({
    required this.enabled,
    required this.path,
  });

  factory CacheFile.fromJson(Map<String, dynamic> json) =>
      _$CacheFileFromJson(json);

  Map<String, dynamic> toJson() => _$CacheFileToJson(this);
}
