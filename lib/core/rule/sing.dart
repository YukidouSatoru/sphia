import 'package:json_annotation/json_annotation.dart';

part 'sing.g.dart';

@JsonSerializable()
class SingBoxRule {
  String? inbound;
  String? outbound;
  List<String>? geosite;
  List<String>? domain;
  List<String>? geoip;
  @JsonKey(name: 'ip_cidr')
  List<String>? ipCidr;
  List<int>? port;
  @JsonKey(name: 'port_range')
  List<String>? portRange;
  @JsonKey(name: 'source_geoip')
  List<String>? sourceGeoip;
  @JsonKey(name: 'source_ip_cidr')
  List<String>? sourceIpCidr;
  @JsonKey(name: 'source_port')
  List<int>? sourcePort;
  @JsonKey(name: "source_port_range")
  List<String>? sourcePortRange;
  String? network;
  List<String>? protocol;
  @JsonKey(name: 'process_name')
  List<String>? processName;

  SingBoxRule({
    this.inbound,
    this.outbound,
    this.domain,
    this.geosite,
    this.ipCidr,
    this.geoip,
    this.port,
    this.portRange,
    this.network,
    this.sourceGeoip,
    this.sourceIpCidr,
    this.sourcePort,
    this.sourcePortRange,
    this.protocol,
    this.processName,
  });

  factory SingBoxRule.fromJson(Map<String, dynamic> json) =>
      _$SingBoxRuleFromJson(json);

  Map<String, dynamic> toJson() => _$SingBoxRuleToJson(this);
}

@JsonSerializable()
class SingBoxDnsRule {
  List<String>? geosite;
  List<String>? geoip;
  List<String>? domain;
  String? server;
  @JsonKey(name: 'disable_cache')
  bool? disableCache;
  List<String>? outbound;

  SingBoxDnsRule({
    this.geosite,
    this.geoip,
    this.domain,
    this.server,
    this.disableCache,
    this.outbound,
  });

  factory SingBoxDnsRule.fromJson(Map<String, dynamic> json) =>
      _$SingBoxDnsRuleFromJson(json);

  Map<String, dynamic> toJson() => _$SingBoxDnsRuleToJson(this);
}
