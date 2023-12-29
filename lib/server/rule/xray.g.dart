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
  return val;
}
