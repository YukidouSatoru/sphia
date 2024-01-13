import 'package:json_annotation/json_annotation.dart';

part 'sing.g.dart';

@JsonSerializable(includeIfNull: false)
class SingBoxRule {
  String? protocol;
  List<String>? geosite;
  List<String>? geoip;
  List<String>? domain;
  @JsonKey(name: 'ip_cidr')
  List<String>? ipCidr;
  List<int>? port;
  @JsonKey(name: 'port_range')
  List<String>? portRange;
  String? inbound;
  String? outbound;
  @JsonKey(name: 'process_name')
  List<String>? processName;

  SingBoxRule({
    this.protocol,
    this.geosite,
    this.geoip,
    this.domain,
    this.ipCidr,
    this.port,
    this.portRange,
    this.inbound,
    this.outbound,
    this.processName,
  });

  factory SingBoxRule.fromJson(Map<String, dynamic> json) =>
      _$SingBoxRuleFromJson(json);

  Map<String, dynamic> toJson() => _$SingBoxRuleToJson(this);
}

@JsonSerializable(includeIfNull: false)
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
