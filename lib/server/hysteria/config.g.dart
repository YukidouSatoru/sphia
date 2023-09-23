// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HysteriaConfig _$HysteriaConfigFromJson(Map<String, dynamic> json) =>
    HysteriaConfig(
      server: json['server'] as String,
      protocol: json['protocol'] as String,
      obfs: json['obfs'] as String?,
      alpn: json['alpn'] as String?,
      auth: json['auth'] as String?,
      authStr: json['auth_str'] as String?,
      serverName: json['server_name'] as String?,
      insecure: json['insecure'] as bool,
      upMbps: json['up_mbps'] as int,
      downMbps: json['down_mbps'] as int,
      recvWindowConn: json['recv_window_conn'] as int?,
      recvWindow: json['recv_window'] as int?,
      disableMtuDiscovery: json['disable_mtu_discovery'] as bool,
      socks5: Socks5.fromJson(json['socks5'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HysteriaConfigToJson(HysteriaConfig instance) {
  final val = <String, dynamic>{
    'server': instance.server,
    'protocol': instance.protocol,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('obfs', instance.obfs);
  writeNotNull('alpn', instance.alpn);
  writeNotNull('auth', instance.auth);
  writeNotNull('auth_str', instance.authStr);
  writeNotNull('server_name', instance.serverName);
  val['insecure'] = instance.insecure;
  val['up_mbps'] = instance.upMbps;
  val['down_mbps'] = instance.downMbps;
  writeNotNull('recv_window_conn', instance.recvWindowConn);
  writeNotNull('recv_window', instance.recvWindow);
  val['disable_mtu_discovery'] = instance.disableMtuDiscovery;
  val['socks5'] = instance.socks5;
  return val;
}

Socks5 _$Socks5FromJson(Map<String, dynamic> json) => Socks5(
      listen: json['listen'] as String,
      timeout: json['timeout'] as int?,
      disableUdp: json['disable_udp'] as bool,
    );

Map<String, dynamic> _$Socks5ToJson(Socks5 instance) {
  final val = <String, dynamic>{
    'listen': instance.listen,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('timeout', instance.timeout);
  val['disable_udp'] = instance.disableUdp;
  return val;
}
