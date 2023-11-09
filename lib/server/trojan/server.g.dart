// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrojanServer _$TrojanServerFromJson(Map<String, dynamic> json) => TrojanServer(
      protocol: json['protocol'] as String,
      address: json['address'] as String,
      port: json['port'] as int,
      remark: json['remark'] as String,
      password: json['password'] as String,
      serverName: json['serverName'] as String?,
      fingerPrint: json['fingerPrint'] as String?,
      allowInsecure: json['allowInsecure'] as bool,
      routingProvider: json['routingProvider'] as int?,
      protocolProvider: json['protocolProvider'] as int?,
    )
      ..uplink = json['uplink'] as int?
      ..downlink = json['downlink'] as int?;

Map<String, dynamic> _$TrojanServerToJson(TrojanServer instance) {
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
  writeNotNull('serverName', instance.serverName);
  writeNotNull('fingerPrint', instance.fingerPrint);
  val['allowInsecure'] = instance.allowInsecure;
  return val;
}
