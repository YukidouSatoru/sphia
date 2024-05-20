import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/server_model.dart';
import 'package:uuid/uuid.dart';

class XrayServer extends ServerModel {
  int? alterId;
  String encryption;
  String? flow;
  String transport;
  String? host;
  String? path;
  String? grpcMode;
  String? serviceName;
  String tls;
  String? serverName;
  String? fingerprint;
  String? publicKey;
  String? shortId;
  String? spiderX;
  bool allowInsecure;

  XrayServer({
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
    this.alterId,
    required this.encryption,
    this.flow,
    required this.transport,
    this.host,
    this.path,
    this.grpcMode,
    this.serviceName,
    required this.tls,
    this.serverName,
    this.fingerprint,
    this.publicKey,
    this.shortId,
    this.spiderX,
    required this.allowInsecure,
  });

  factory XrayServer.socksDefaults() => XrayServer(
        id: defaultServerId,
        groupId: defaultServerGroupId,
        protocol: 'socks',
        remark: '',
        address: '',
        port: 0,
        authPayload: '',
        encryption: 'none',
        transport: 'tcp',
        tls: 'none',
        allowInsecure: false,
      );

  factory XrayServer.vmessDefaults() => XrayServer(
        id: defaultServerId,
        groupId: defaultServerGroupId,
        protocol: 'vmess',
        remark: '',
        address: '',
        port: 0,
        authPayload: const Uuid().v4(),
        alterId: 0,
        encryption: 'auto',
        transport: 'tcp',
        tls: 'none',
        allowInsecure: false,
      );

  factory XrayServer.vlessDefaults() => XrayServer(
        id: defaultServerId,
        groupId: defaultServerGroupId,
        protocol: 'vless',
        remark: '',
        address: '',
        port: 0,
        authPayload: const Uuid().v4(),
        encryption: 'none',
        flow: null,
        transport: 'tcp',
        tls: 'none',
        allowInsecure: false,
      );

  factory XrayServer.fromServer(Server server) => XrayServer(
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
        alterId: server.alterId,
        encryption: server.encryption ?? 'auto',
        flow: server.flow,
        transport: server.transport ?? 'tcp',
        host: server.host,
        path: server.path,
        grpcMode: server.grpcMode,
        serviceName: server.serviceName,
        tls: server.tls ?? 'none',
        serverName: server.serverName,
        fingerprint: server.fingerprint,
        publicKey: server.publicKey,
        shortId: server.shortId,
        spiderX: server.spiderX,
        allowInsecure: server.allowInsecure ?? false,
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
        alterId: Value(alterId),
        encryption: Value(encryption),
        flow: Value(flow),
        transport: Value(transport),
        host: Value(host),
        path: Value(path),
        grpcMode: Value(grpcMode),
        serviceName: Value(serviceName),
        tls: Value(tls),
        serverName: Value(serverName),
        fingerprint: Value(fingerprint),
        publicKey: Value(publicKey),
        shortId: Value(shortId),
        spiderX: Value(spiderX),
        allowInsecure: Value(allowInsecure),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is XrayServer &&
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
        other.alterId == alterId &&
        other.encryption == encryption &&
        other.flow == flow &&
        other.transport == transport &&
        other.host == host &&
        other.path == path &&
        other.grpcMode == grpcMode &&
        other.serviceName == serviceName &&
        other.tls == tls &&
        other.serverName == serverName &&
        other.fingerprint == fingerprint &&
        other.publicKey == publicKey &&
        other.shortId == shortId &&
        other.spiderX == spiderX &&
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
        alterId.hashCode ^
        encryption.hashCode ^
        flow.hashCode ^
        transport.hashCode ^
        host.hashCode ^
        path.hashCode ^
        grpcMode.hashCode ^
        serviceName.hashCode ^
        tls.hashCode ^
        serverName.hashCode ^
        fingerprint.hashCode ^
        publicKey.hashCode ^
        shortId.hashCode ^
        spiderX.hashCode ^
        allowInsecure.hashCode;
  }
}
