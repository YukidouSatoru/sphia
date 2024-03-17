import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/server_model.dart';

class ShadowsocksServer extends ServerModel {
  String encryption;
  String? plugin;
  String? pluginOpts;

  ShadowsocksServer({
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
    required this.encryption,
    this.plugin,
    this.pluginOpts,
  });

  factory ShadowsocksServer.defaults() => ShadowsocksServer(
        id: defaultServerId,
        groupId: defaultServerGroupId,
        protocol: 'shadowsocks',
        remark: '',
        address: '',
        port: 0,
        authPayload: '',
        encryption: 'aes-128-gcm',
      );

  factory ShadowsocksServer.fromServer(Server server) => ShadowsocksServer(
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
        encryption: server.encryption ?? 'aes-128-gcm',
        plugin: server.plugin,
        pluginOpts: server.pluginOpts,
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
        encryption: encryption,
        plugin: plugin,
        pluginOpts: pluginOpts,
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
        encryption: Value(encryption),
        plugin: Value(plugin),
        pluginOpts: Value(pluginOpts),
      );

  ShadowsocksServer copyWith({
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
    String? encryption,
    String? plugin,
    String? pluginOpts,
  }) {
    return ShadowsocksServer(
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
      encryption: encryption ?? this.encryption,
      plugin: plugin ?? this.plugin,
      pluginOpts: pluginOpts ?? this.pluginOpts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadowsocksServer &&
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
        other.encryption == encryption &&
        other.plugin == plugin &&
        other.pluginOpts == pluginOpts;
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
        encryption.hashCode ^
        plugin.hashCode ^
        pluginOpts.hashCode;
  }
}
