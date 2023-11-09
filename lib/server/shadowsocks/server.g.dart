// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadowsocksServer _$ShadowsocksServerFromJson(Map<String, dynamic> json) =>
    ShadowsocksServer(
      protocol: json['protocol'] as String,
      address: json['address'] as String,
      port: json['port'] as int,
      remark: json['remark'] as String,
      password: json['password'] as String,
      encryption: json['encryption'] as String,
      plugin: json['plugin'] as String?,
      pluginOpts: json['pluginOpts'] as String?,
      routingProvider: json['routingProvider'] as int?,
      protocolProvider: json['protocolProvider'] as int?,
    )
      ..uplink = json['uplink'] as int?
      ..downlink = json['downlink'] as int?;

Map<String, dynamic> _$ShadowsocksServerToJson(ShadowsocksServer instance) {
  final val = <String, dynamic>{
    'protocol': instance.protocol,
    'address': instance.address,
    'port': instance.port,
    'remark': instance.remark,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uplink', instance.uplink);
  writeNotNull('downlink', instance.downlink);
  writeNotNull('routingProvider', instance.routingProvider);
  writeNotNull('protocolProvider', instance.protocolProvider);
  val['password'] = instance.password;
  val['encryption'] = instance.encryption;
  writeNotNull('plugin', instance.plugin);
  writeNotNull('pluginOpts', instance.pluginOpts);
  return val;
}
