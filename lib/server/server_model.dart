import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/custom_config/server.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';

const defaultServerGroupId = -2;
const defaultServerId = -2;

enum Protocol {
  vmess,
  vless,
  shadowsocks,
  trojan,
  hysteria,
  custom,
  socks,
  clipboard,
}

/*
because members of a class in drift are immutable
ServerModel is used to create a new instance of a server record
and to convert a server record to a ServerModel instance
*/
class ServerModel {
  int id;
  int groupId;
  Protocol protocol;
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
      case Protocol.hysteria:
        return HysteriaServer.fromServer(server);
      case Protocol.shadowsocks:
        return ShadowsocksServer.fromServer(server);
      case Protocol.trojan:
        return TrojanServer.fromServer(server);
      case Protocol.vmess:
      case Protocol.vless:
      case Protocol.socks:
        return XrayServer.fromServer(server);
      case Protocol.custom:
        return CustomConfigServer.fromServer(server);
      default:
        throw Exception('Unsupported protocol: ${server.protocol}');
    }
  }

  ServersCompanion toCompanion() {
    switch (protocol) {
      case Protocol.hysteria:
        return (this as HysteriaServer).toCompanion();
      case Protocol.shadowsocks:
        return (this as ShadowsocksServer).toCompanion();
      case Protocol.trojan:
        return (this as TrojanServer).toCompanion();
      case Protocol.vmess:
      case Protocol.vless:
      case Protocol.socks:
        return (this as XrayServer).toCompanion();
      case Protocol.custom:
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

  T withTraffic<T extends ServerModel>(int? uplink, int? downlink) {
    return (this as T)
      ..uplink = uplink
      ..downlink = downlink;
  }

  T withLatency<T extends ServerModel>(int? latency) {
    return (this as T)..latency = latency;
  }
}
