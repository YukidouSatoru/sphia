// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MixedRule _$MixedRuleFromJson(Map<String, dynamic> json) => MixedRule(
      name: json['name'] as String,
      enabled: json['enabled'] as bool,
      inboundTag: json['inboundTag'] as String?,
      outboundTag: json['outboundTag'] as String?,
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ip: (json['ip'] as List<dynamic>?)?.map((e) => e as String).toList(),
      port: (json['port'] as List<dynamic>?)?.map((e) => e as String).toList(),
      processName: (json['processName'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MixedRuleToJson(MixedRule instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'enabled': instance.enabled,
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
  writeNotNull('processName', instance.processName);
  return val;
}
