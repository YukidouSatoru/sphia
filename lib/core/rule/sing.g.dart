// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingBoxRule _$SingBoxRuleFromJson(Map<String, dynamic> json) => SingBoxRule(
      inbound: json['inbound'] as String?,
      outbound: json['outbound'] as String?,
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      geosite:
          (json['geosite'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ipCidr:
          (json['ip_cidr'] as List<dynamic>?)?.map((e) => e as String).toList(),
      geoip:
          (json['geoip'] as List<dynamic>?)?.map((e) => e as String).toList(),
      port: (json['port'] as List<dynamic>?)?.map((e) => e as int).toList(),
      portRange: (json['port_range'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      network: json['network'] as String?,
      sourceGeoip: (json['source_geoip'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sourceIpCidr: (json['source_ip_cidr'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sourcePort: (json['source_port'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      sourcePortRange: (json['source_port_range'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      protocol: (json['protocol'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
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

  writeNotNull('inbound', instance.inbound);
  writeNotNull('outbound', instance.outbound);
  writeNotNull('geosite', instance.geosite);
  writeNotNull('domain', instance.domain);
  writeNotNull('geoip', instance.geoip);
  writeNotNull('ip_cidr', instance.ipCidr);
  writeNotNull('port', instance.port);
  writeNotNull('port_range', instance.portRange);
  writeNotNull('source_geoip', instance.sourceGeoip);
  writeNotNull('source_ip_cidr', instance.sourceIpCidr);
  writeNotNull('source_port', instance.sourcePort);
  writeNotNull('source_port_range', instance.sourcePortRange);
  writeNotNull('network', instance.network);
  writeNotNull('protocol', instance.protocol);
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
