// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xray.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XrayRule _$XrayRuleFromJson(Map<String, dynamic> json) => XrayRule(
      inboundTag: json['inboundTag'] as String?,
      outboundTag: json['outboundTag'] as String?,
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ip: (json['ip'] as List<dynamic>?)?.map((e) => e as String).toList(),
      port: json['port'] as String?,
      sourcePort: json['sourcePort'] as String?,
      network: json['network'] as String?,
      protocol: (json['protocol'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      source:
          (json['source'] as List<dynamic>?)?.map((e) => e as String).toList(),
    )..type = json['type'] as String;

Map<String, dynamic> _$XrayRuleToJson(XrayRule instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('inboundTag', instance.inboundTag);
  writeNotNull('outboundTag', instance.outboundTag);
  writeNotNull('domain', instance.domain);
  writeNotNull('ip', instance.ip);
  writeNotNull('port', instance.port);
  writeNotNull('source', instance.source);
  writeNotNull('sourcePort', instance.sourcePort);
  writeNotNull('network', instance.network);
  writeNotNull('protocol', instance.protocol);
  return val;
}
