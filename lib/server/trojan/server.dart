import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/server_model.dart';

class TrojanServer extends ServerModel {
  String tls;
  String? serverName;
  String fingerprint;
  bool allowInsecure;

  TrojanServer({
    required super.id,
    required super.groupId,
    required super.protocol,
    required super.remark,
    required super.address,
    required super.port,
    super.uplink,
    super.downlink,
    super.routingProvider,
    super.protocolProvider,
    required super.authPayload,
    super.latency,
    required this.tls,
    this.serverName,
    required this.fingerprint,
    required this.allowInsecure,
  });

  factory TrojanServer.defaults() => TrojanServer(
        id: defaultServerId,
        groupId: defaultServerGroupId,
        protocol: 'trojan',
        remark: '',
        address: '',
        port: 0,
        authPayload: '',
        tls: 'true',
        fingerprint: 'chrome',
        allowInsecure: false,
      );

  factory TrojanServer.fromServer(Server server) => TrojanServer(
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
        tls: server.tls ?? 'true',
        serverName: server.serverName,
        fingerprint: server.fingerprint ?? 'chrome',
        allowInsecure: server.allowInsecure ?? false,
      );

  @override
  Server toServer() => Server(
        id: id,
        groupId: groupId,
        protocol: protocol,
        remark: remark,
        address: address,
        port: port,
        uplink: uplink,
        downlink: downlink,
        routingProvider: routingProvider,
        protocolProvider: protocolProvider,
        authPayload: authPayload,
        latency: latency,
        tls: tls,
        serverName: serverName,
        fingerprint: fingerprint,
        allowInsecure: allowInsecure,
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
        tls: Value(tls),
        serverName: Value(serverName),
        fingerprint: Value(fingerprint),
        allowInsecure: Value(allowInsecure),
      );

  TrojanServer copyWith({
    int? id,
    int? groupId,
    String? protocol,
    String? remark,
    String? address,
    int? port,
    int? uplink,
    int? downlink,
    int? routingProvider,
    int? protocolProvider,
    String? authPayload,
    int? latency,
    String? tls,
    String? serverName,
    String? fingerprint,
    bool? allowInsecure,
  }) {
    return TrojanServer(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      protocol: protocol ?? this.protocol,
      remark: remark ?? this.remark,
      address: address ?? this.address,
      port: port ?? this.port,
      uplink: uplink ?? this.uplink,
      downlink: downlink ?? this.downlink,
      routingProvider: routingProvider ?? this.routingProvider,
      protocolProvider: protocolProvider ?? this.protocolProvider,
      authPayload: authPayload ?? this.authPayload,
      latency: latency ?? this.latency,
      tls: tls ?? this.tls,
      serverName: serverName ?? this.serverName,
      fingerprint: fingerprint ?? this.fingerprint,
      allowInsecure: allowInsecure ?? this.allowInsecure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrojanServer &&
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
        other.tls == tls &&
        other.serverName == serverName &&
        other.fingerprint == fingerprint &&
        other.allowInsecure == allowInsecure;
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
        tls.hashCode ^
        serverName.hashCode ^
        fingerprint.hashCode ^
        allowInsecure.hashCode;
  }
}
