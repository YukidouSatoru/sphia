import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/custom_config/server.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_model_lite.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';

const defaultServerGroupId = -2;
const defaultServerId = -2;

/*
because members of a class in drift are immutable
ServerModel is used to create a new instance of a server record
and to convert a server record to a ServerModel instance
*/
class ServerModel {
  int id;
  int groupId;
  String protocol;
  String remark;
  String address;
  int port;
  int? uplink;
  int? downlink;
  int? routingProvider;
  int? protocolProvider;
  String authPayload;
  int? latency;

  ServerModel({
    required this.id,
    required this.groupId,
    required this.protocol,
    required this.remark,
    required this.address,
    required this.port,
    this.uplink,
    this.downlink,
    this.routingProvider,
    this.protocolProvider,
    required this.authPayload,
    this.latency,
  });

  factory ServerModel.fromServer(Server server) {
    switch (server.protocol) {
      case 'hysteria':
        return HysteriaServer.fromServer(server);
      case 'shadowsocks':
        return ShadowsocksServer.fromServer(server);
      case 'trojan':
        return TrojanServer.fromServer(server);
      case 'vmess':
      case 'vless':
      case 'socks':
        return XrayServer.fromServer(server);
      case 'custom':
        return CustomConfigServer.fromServer(server);
      default:
        throw Exception('Unsupported protocol: ${server.protocol}');
    }
  }

  ServersCompanion toCompanion() {
    switch (protocol) {
      case 'hysteria':
        return (this as HysteriaServer).toCompanion();
      case 'shadowsocks':
        return (this as ShadowsocksServer).toCompanion();
      case 'trojan':
        return (this as TrojanServer).toCompanion();
      case 'vmess':
      case 'vless':
      case 'socks':
        return (this as XrayServer).toCompanion();
      case 'custom':
        return (this as CustomConfigServer).toCompanion();
      default:
        throw Exception('Unsupported protocol: $protocol');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServerModel &&
        other.id == id &&
        other.groupId == groupId &&
        other.protocol == protocol &&
        other.remark == remark &&
        other.address == address &&
        other.port == port &&
        other.uplink == uplink &&
        other.downlink == downlink &&
        other.routingProvider == routingProvider &&
        other.protocolProvider == protocolProvider &&
        other.authPayload == authPayload &&
        other.latency == latency;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        groupId.hashCode ^
        protocol.hashCode ^
        remark.hashCode ^
        address.hashCode ^
        port.hashCode ^
        uplink.hashCode ^
        downlink.hashCode ^
        routingProvider.hashCode ^
        protocolProvider.hashCode ^
        authPayload.hashCode ^
        latency.hashCode;
  }

  ServerModelLite toLite() {
    return ServerModelLite(id: id, remark: remark);
  }
}
