import 'package:json_annotation/json_annotation.dart';

part 'xray.g.dart';

@JsonSerializable(includeIfNull: false)
class XrayRule {
  String type = 'field';
  String? inboundTag;
  String? outboundTag;
  List<String>? domain;
  List<String>? ip;
  String? port;
  List<String>? source;
  String? sourcePort;
  String? network;
  List<String>? protocol;

  XrayRule({
    this.inboundTag,
    this.outboundTag,
    this.domain,
    this.ip,
    this.port,
    this.sourcePort,
    this.network,
    this.protocol,
    this.source,
  });

  factory XrayRule.fromJson(Map<String, dynamic> json) =>
      _$XrayRuleFromJson(json);

  Map<String, dynamic> toJson() => _$XrayRuleToJson(this);
}
