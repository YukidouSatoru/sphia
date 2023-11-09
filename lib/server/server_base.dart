import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';

abstract class ServerBase {
  String protocol;
  String address;
  int port;
  String remark;
  int? uplink;
  int? downlink;
  int? routingProvider;
  int? protocolProvider;

  ServerBase({
    required this.protocol,
    required this.address,
    required this.port,
    required this.remark,
    this.uplink,
    this.downlink,
    this.routingProvider,
    this.protocolProvider,
  });

  // factory Server.fromJson(Map<String, dynamic> json) => _$ServerFromJson(json);
  factory ServerBase.fromJson(Map<String, dynamic> json) {
    switch (json['protocol']) {
      case 'vmess':
      case 'vless':
      case 'socks':
        return XrayServer.fromJson(json);
      case 'shadowsocks':
        return ShadowsocksServer.fromJson(json);
      case 'trojan':
        return TrojanServer.fromJson(json);
      case 'hysteria':
        return HysteriaServer.fromJson(json);
      default:
        throw FormatException('Failed to parse server: ${json['protocol']}');
    }
  }

  Map<String, dynamic> toJson() {
    switch (protocol) {
      case 'vmess':
      case 'vless':
      case 'socks':
        return (this as XrayServer).toJson();
      case 'shadowsocks':
        return (this as ShadowsocksServer).toJson();
      case 'trojan':
        return (this as TrojanServer).toJson();
      case 'hysteria':
        return (this as HysteriaServer).toJson();
      default:
        throw FormatException('Failed to parse server: $protocol');
    }
  }
}
