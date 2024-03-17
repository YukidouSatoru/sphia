import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/server_model.dart';

class HysteriaServer extends ServerModel {
  String hysteriaProtocol;
  String? obfs;
  String? alpn;
  String authType;
  String? serverName;
  bool insecure;
  int upMbps;
  int downMbps;
  int? recvWindowConn;
  int? recvWindow;
  bool disableMtuDiscovery;

  HysteriaServer({
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
    required this.hysteriaProtocol,
    this.obfs,
    this.alpn,
    required this.authType,
    this.serverName,
    required this.insecure,
    required this.upMbps,
    required this.downMbps,
    this.recvWindowConn,
    this.recvWindow,
    required this.disableMtuDiscovery,
  });

  factory HysteriaServer.defaults() => HysteriaServer(
        id: defaultServerId,
        groupId: defaultServerGroupId,
        protocol: 'hysteria',
        remark: '',
        address: '',
        port: 0,
        authPayload: '',
        hysteriaProtocol: 'udp',
        authType: 'none',
        insecure: false,
        upMbps: 10,
        downMbps: 50,
        recvWindowConn: 15728640,
        recvWindow: 67108864,
        disableMtuDiscovery: false,
      );

  factory HysteriaServer.fromServer(Server server) => HysteriaServer(
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
        hysteriaProtocol: server.hysteriaProtocol ?? 'udp',
        obfs: server.obfs,
        alpn: server.alpn,
        authType: server.authType ?? 'none',
        serverName: server.serverName,
        insecure: server.allowInsecure ?? false,
        upMbps: server.upMbps ?? 10,
        downMbps: server.downMbps ?? 50,
        recvWindowConn: server.recvWindowConn,
        recvWindow: server.recvWindow,
        disableMtuDiscovery: server.disableMtuDiscovery ?? false,
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
        hysteriaProtocol: hysteriaProtocol,
        obfs: obfs,
        alpn: alpn,
        authType: authType,
        serverName: serverName,
        allowInsecure: insecure,
        upMbps: upMbps,
        downMbps: downMbps,
        recvWindowConn: recvWindowConn,
        recvWindow: recvWindow,
        disableMtuDiscovery: disableMtuDiscovery,
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
        hysteriaProtocol: Value(hysteriaProtocol),
        obfs: Value(obfs),
        alpn: Value(alpn),
        authType: Value(authType),
        serverName: Value(serverName),
        allowInsecure: Value(insecure),
        upMbps: Value(upMbps),
        downMbps: Value(downMbps),
        recvWindowConn: Value(recvWindowConn),
        recvWindow: Value(recvWindow),
        disableMtuDiscovery: Value(disableMtuDiscovery),
      );

  HysteriaServer copyWith({
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
    String? hysteriaProtocol,
    String? obfs,
    String? alpn,
    String? authType,
    String? serverName,
    bool? insecure,
    int? upMbps,
    int? downMbps,
    int? recvWindowConn,
    int? recvWindow,
    bool? disableMtuDiscovery,
  }) =>
      HysteriaServer(
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
        hysteriaProtocol: hysteriaProtocol ?? this.hysteriaProtocol,
        obfs: obfs ?? this.obfs,
        alpn: alpn ?? this.alpn,
        authType: authType ?? this.authType,
        serverName: serverName ?? this.serverName,
        insecure: insecure ?? this.insecure,
        upMbps: upMbps ?? this.upMbps,
        downMbps: downMbps ?? this.downMbps,
        recvWindowConn: recvWindowConn ?? this.recvWindowConn,
        recvWindow: recvWindow ?? this.recvWindow,
        disableMtuDiscovery: disableMtuDiscovery ?? this.disableMtuDiscovery,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HysteriaServer &&
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
        other.hysteriaProtocol == hysteriaProtocol &&
        other.obfs == obfs &&
        other.alpn == alpn &&
        other.authType == authType &&
        other.serverName == serverName &&
        other.insecure == insecure &&
        other.upMbps == upMbps &&
        other.downMbps == downMbps &&
        other.recvWindowConn == recvWindowConn &&
        other.recvWindow == recvWindow &&
        other.disableMtuDiscovery == disableMtuDiscovery;
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
        hysteriaProtocol.hashCode ^
        obfs.hashCode ^
        alpn.hashCode ^
        authType.hashCode ^
        serverName.hashCode ^
        insecure.hashCode ^
        upMbps.hashCode ^
        downMbps.hashCode ^
        recvWindowConn.hashCode ^
        recvWindow.hashCode ^
        disableMtuDiscovery.hashCode;
  }
}
