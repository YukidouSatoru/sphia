// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingBoxRule _$SingBoxRuleFromJson(Map<String, dynamic> json) => SingBoxRule(
      protocol: json['protocol'] as String?,
      geosite:
          (json['geosite'] as List<dynamic>?)?.map((e) => e as String).toList(),
      geoip:
          (json['geoip'] as List<dynamic>?)?.map((e) => e as String).toList(),
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ipCidr:
          (json['ip_cidr'] as List<dynamic>?)?.map((e) => e as String).toList(),
      port: (json['port'] as List<dynamic>?)?.map((e) => e as int).toList(),
      portRange: (json['port_range'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      outbound: json['outbound'] as String?,
      processName: (json['process_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SingBoxRuleToJson(SingBoxRule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('protocol', instance.protocol);
  writeNotNull('geosite', instance.geosite);
  writeNotNull('geoip', instance.geoip);
  writeNotNull('domain', instance.domain);
  writeNotNull('ip_cidr', instance.ipCidr);
  writeNotNull('port', instance.port);
  writeNotNull('port_range', instance.portRange);
  writeNotNull('outbound', instance.outbound);
  writeNotNull('process_name', instance.processName);
  return val;
}

SingBoxDnsRule _$SingBoxDnsRuleFromJson(Map<String, dynamic> json) =>
    SingBoxDnsRule(
      geosite:
          (json['geosite'] as List<dynamic>?)?.map((e) => e as String).toList(),
      geoip:
          (json['geoip'] as List<dynamic>?)?.map((e) => e as String).toList(),
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      server: json['server'] as String?,
      disableCache: json['disable_cache'] as bool?,
      outbound: (json['outbound'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SingBoxDnsRuleToJson(SingBoxDnsRule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('geosite', instance.geosite);
  writeNotNull('geoip', instance.geoip);
  writeNotNull('domain', instance.domain);
  writeNotNull('server', instance.server);
  writeNotNull('disable_cache', instance.disableCache);
  writeNotNull('outbound', instance.outbound);
  return val;
}
