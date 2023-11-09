// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HysteriaServer _$HysteriaServerFromJson(Map<String, dynamic> json) =>
    HysteriaServer(
      protocol: json['protocol'] as String,
      address: json['address'] as String,
      port: json['port'] as int,
      remark: json['remark'] as String,
      hysteriaProtocol: json['hysteriaProtocol'] as String,
      obfs: json['obfs'] as String?,
      alpn: json['alpn'] as String?,
      authType: json['authType'] as String,
      authPayload: json['authPayload'] as String?,
      serverName: json['server_name'] as String?,
      insecure: json['insecure'] as bool,
      upMbps: json['up_mbps'] as int,
      downMbps: json['down_mbps'] as int,
      recvWindowConn: json['recv_window_conn'] as int?,
      recvWindow: json['recv_window'] as int?,
      disableMtuDiscovery: json['disable_mtu_discovery'] as bool,
      routingProvider: json['routingProvider'] as int?,
      protocolProvider: json['protocolProvider'] as int?,
    )
      ..uplink = json['uplink'] as int?
      ..downlink = json['downlink'] as int?;

Map<String, dynamic> _$HysteriaServerToJson(HysteriaServer instance) {
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
  val['hysteriaProtocol'] = instance.hysteriaProtocol;
  writeNotNull('obfs', instance.obfs);
  writeNotNull('alpn', instance.alpn);
  val['authType'] = instance.authType;
  writeNotNull('authPayload', instance.authPayload);
  writeNotNull('server_name', instance.serverName);
  val['insecure'] = instance.insecure;
  val['up_mbps'] = instance.upMbps;
  val['down_mbps'] = instance.downMbps;
  writeNotNull('recv_window_conn', instance.recvWindowConn);
  writeNotNull('recv_window', instance.recvWindow);
  val['disable_mtu_discovery'] = instance.disableMtuDiscovery;
  return val;
}
