import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class HysteriaConfig {
  String server;
  String protocol;
  String? obfs;
  String? alpn;
  String? auth;
  @JsonKey(name: 'auth_str')
  String? authStr;
  @JsonKey(name: 'server_name')
  String? serverName;
  bool insecure;
  @JsonKey(name: 'up_mbps')
  int upMbps;
  @JsonKey(name: 'down_mbps')
  int downMbps;
  @JsonKey(name: 'recv_window_conn')
  int? recvWindowConn;
  @JsonKey(name: 'recv_window')
  int? recvWindow;
  @JsonKey(name: 'disable_mtu_discovery')
  bool disableMtuDiscovery;
  Socks5 socks5;

  HysteriaConfig({
    required this.server,
    required this.protocol,
    this.obfs,
    this.alpn,
    this.auth,
    this.authStr,
    this.serverName,
    required this.insecure,
    required this.upMbps,
    required this.downMbps,
    this.recvWindowConn,
    this.recvWindow,
    required this.disableMtuDiscovery,
    required this.socks5,
  });

  factory HysteriaConfig.fromJson(Map<String, dynamic> json) =>
      _$HysteriaConfigFromJson(json);

  Map<String, dynamic> toJson() => _$HysteriaConfigToJson(this);
}

@JsonSerializable()
class Socks5 {
  String listen;
  int? timeout;
  @JsonKey(name: 'disable_udp')
  bool disableUdp;

  Socks5({
    required this.listen,
    this.timeout,
    required this.disableUdp,
  });

  factory Socks5.fromJson(Map<String, dynamic> json) => _$Socks5FromJson(json);

  Map<String, dynamic> toJson() => _$Socks5ToJson(this);
}
