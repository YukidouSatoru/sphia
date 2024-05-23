import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/server_model.dart';

class CustomConfigServer extends ServerModel {
  String configString;
  String configFormat;

  CustomConfigServer({
    required super.id,
    required super.groupId,
    super.protocol = 'custom',
    required super.remark,
    super.address = '',
    super.port = 0,
    super.uplink,
    super.downlink,
    super.routingProvider,
    super.protocolProvider,
    super.authPayload = '',
    super.latency,
    required this.configString,
    required this.configFormat,
  });

  factory CustomConfigServer.defaults() => CustomConfigServer(
        id: defaultServerId,
        groupId: defaultServerGroupId,
        remark: '',
        address: '',
        port: 0,
        configString: '',
        configFormat: 'json',
      );

  factory CustomConfigServer.fromServer(Server server) => CustomConfigServer(
        id: server.id,
        groupId: server.groupId,
        protocol: server.protocol,
        remark: server.remark,
        address: server.address,
        port: server.port,
        uplink: server.uplink,
        downlink: server.downlink,
        routingProvider: server.routingProvider,
        protocolProvider: server.protocolProvider,
        authPayload: server.authPayload,
        latency: server.latency,
        configString: server.configString ?? '',
        configFormat: server.configFormat ?? '',
      );

  @override
  ServersCompanion toCompanion() => ServersCompanion(
        groupId: Value(groupId),
        protocol: Value(protocol),
        remark: Value(remark),
        address: Value(address),
        port: Value(port),
        uplink: Value(uplink),
        downlink: Value(downlink),
        routingProvider: Value(routingProvider),
        protocolProvider: Value(protocolProvider),
        authPayload: Value(authPayload),
        latency: Value(latency),
        configString: Value(configString),
        configFormat: Value(configFormat),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomConfigServer &&
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
        other.latency == latency &&
        other.configString == configString &&
        other.configFormat == configFormat;
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
        latency.hashCode ^
        configString.hashCode ^
        configFormat.hashCode;
  }
}
