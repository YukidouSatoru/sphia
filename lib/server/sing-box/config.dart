import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(includeIfNull: false)
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

@JsonSerializable(includeIfNull: false)
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

@JsonSerializable(includeIfNull: false)
class Dns {
  List<DnsServer> servers;
  List<DnsRule> rules;

  Dns({
    required this.servers,
    required this.rules,
  });

  factory Dns.fromJson(Map<String, dynamic> json) => _$DnsFromJson(json);

  Map<String, dynamic> toJson() => _$DnsToJson(this);
}

@JsonSerializable(includeIfNull: false)
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

@JsonSerializable(includeIfNull: false)
class RouteRule {
  String? protocol;
  List<String>? geosite;
  List<String>? geoip;
  List<String>? domain;
  @JsonKey(name: 'ip_cidr')
  List<String>? ipCidr;
  List<int>? port;
  @JsonKey(name: 'port_range')
  List<String>? portRange;
  String? outbound;
  @JsonKey(name: 'process_name')
  List<String>? processName;

  RouteRule({
    this.protocol,
    this.geosite,
    this.geoip,
    this.domain,
    this.ipCidr,
    this.port,
    this.portRange,
    this.outbound,
    this.processName,
  });

  factory RouteRule.fromJson(Map<String, dynamic> json) =>
      _$RouteRuleFromJson(json);

  Map<String, dynamic> toJson() => _$RouteRuleToJson(this);
}

@JsonSerializable(includeIfNull: false)
class DnsRule {
  List<String>? geosite;
  List<String>? geoip;
  List<String>? domain;
  String? server;
  @JsonKey(name: 'disable_cache')
  bool? disableCache;
  List<String>? outbound;

  DnsRule({
    this.geosite,
    this.geoip,
    this.domain,
    this.server,
    this.disableCache,
    this.outbound,
  });

  factory DnsRule.fromJson(Map<String, dynamic> json) =>
      _$DnsRuleFromJson(json);

  Map<String, dynamic> toJson() => _$DnsRuleToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Route {
  Geoip? geoip;
  Geosite? geosite;
  List<RouteRule>? rules;
  @JsonKey(name: 'auto_detect_interface')
  bool autoDetectInterface;
  @JsonKey(name: 'final')
  String? finalTag;

  Route({
    this.geoip,
    this.geosite,
    this.rules,
    required this.autoDetectInterface,
    this.finalTag,
  });

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Geoip {
  String path;

  Geoip({
    required this.path,
  });

  factory Geoip.fromJson(Map<String, dynamic> json) => _$GeoipFromJson(json);

  Map<String, dynamic> toJson() => _$GeoipToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Geosite {
  String path;

  Geosite({
    required this.path,
  });

  factory Geosite.fromJson(Map<String, dynamic> json) =>
      _$GeositeFromJson(json);

  Map<String, dynamic> toJson() => _$GeositeToJson(this);
}

@JsonSerializable(includeIfNull: false)
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
  });

  factory Inbound.fromJson(Map<String, dynamic> json) =>
      _$InboundFromJson(json);

  Map<String, dynamic> toJson() => _$InboundToJson(this);
}

@JsonSerializable(includeIfNull: false)
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
  int? upMbps;
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

@JsonSerializable(includeIfNull: false)
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

@JsonSerializable(includeIfNull: false)
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

@JsonSerializable(includeIfNull: false)
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

@JsonSerializable(includeIfNull: false)
class Transport {
  String type;
  String? path;
  @JsonKey(name: 'service_name')
  String? serviceName;

  Transport({
    required this.type,
    this.path,
    this.serviceName,
  });

  factory Transport.fromJson(Map<String, dynamic> json) =>
      _$TransportFromJson(json);

  Map<String, dynamic> toJson() => _$TransportToJson(this);
}

@JsonSerializable(includeIfNull: false)
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

@JsonSerializable(includeIfNull: false)
class Experimental {
  @JsonKey(name: 'clash_api')
  ClashApi? clashApi;

  Experimental({
    this.clashApi,
  });

  factory Experimental.fromJson(Map<String, dynamic> json) =>
      _$ExperimentalFromJson(json);

  Map<String, dynamic> toJson() => _$ExperimentalToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ClashApi {
  @JsonKey(name: 'external_controller')
  String externalController;
  @JsonKey(name: 'store_selected')
  bool storeSelected;
  @JsonKey(name: 'cache_file')
  String? cacheFile;

  ClashApi({
    required this.externalController,
    required this.storeSelected,
    this.cacheFile,
  });

  factory ClashApi.fromJson(Map<String, dynamic> json) =>
      _$ClashApiFromJson(json);

  Map<String, dynamic> toJson() => _$ClashApiToJson(this);
}
