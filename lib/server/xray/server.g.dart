// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XrayServer _$XrayServerFromJson(Map<String, dynamic> json) => XrayServer(
      protocol: json['protocol'] as String,
      address: json['address'] as String,
      port: json['port'] as int,
      remark: json['remark'] as String,
      uuid: json['uuid'] as String,
      alterId: json['alterId'] as int?,
      encryption: json['encryption'] as String,
      flow: json['flow'] as String?,
      transport: json['transport'] as String,
      host: json['host'] as String?,
      path: json['path'] as String?,
      grpcMode: json['grpcMode'] as String?,
      serviceName: json['serviceName'] as String?,
      tls: json['tls'] as String,
      serverName: json['serverName'] as String?,
      fingerPrint: json['fingerPrint'] as String?,
      publicKey: json['publicKey'] as String?,
      shortId: json['shortId'] as String?,
      spiderX: json['spiderX'] as String?,
      allowInsecure: json['allowInsecure'] as bool,
      routingProvider: json['routingProvider'] as int?,
      protocolProvider: json['protocolProvider'] as int?,
    )
      ..uplink = json['uplink'] as int?
      ..downlink = json['downlink'] as int?;

Map<String, dynamic> _$XrayServerToJson(XrayServer instance) {
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
  val['uuid'] = instance.uuid;
  writeNotNull('alterId', instance.alterId);
  val['encryption'] = instance.encryption;
  writeNotNull('flow', instance.flow);
  val['transport'] = instance.transport;
  writeNotNull('host', instance.host);
  writeNotNull('path', instance.path);
  writeNotNull('grpcMode', instance.grpcMode);
  writeNotNull('serviceName', instance.serviceName);
  val['tls'] = instance.tls;
  writeNotNull('serverName', instance.serverName);
  writeNotNull('fingerPrint', instance.fingerPrint);
  writeNotNull('publicKey', instance.publicKey);
  writeNotNull('shortId', instance.shortId);
  writeNotNull('spiderX', instance.spiderX);
  val['allowInsecure'] = instance.allowInsecure;
  return val;
}
