import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';

const additionalServerId = -1;

class ServerDao {
  final Database _db;

  ServerDao(this._db);

  Future<List<Server>> getServers() {
    return _db.select(_db.servers).get();
  }

  Future<List<Server>> getServersById(List<int> id) {
    return (_db.select(_db.servers)..where((tbl) => tbl.id.isIn(id))).get();
  }

  Future<List<Server>> getServersByGroupId(int groupId) {
    return (_db.select(_db.servers)
          ..where((tbl) => tbl.groupId.equals(groupId)))
        .get();
  }

  Future<List<Server>> getOrderedServersByGroupId(int groupId) async {
    logger.i('Getting ordered servers by group id: $groupId');
    final order = await getServersOrderByGroupId(groupId);
    final servers = await getServersByGroupId(groupId);
    final orderedServers = <Server>[];
    for (final id in order) {
      final server = servers.firstWhere((element) => element.id == id);
      orderedServers.add(server);
    }
    return orderedServers;
  }

  Future<List<int>> getServerIds() {
    return _db.select(_db.servers).get().then((value) {
      if (value.isEmpty) {
        return [];
      }
      return value.map((e) => e.id).toList();
    });
  }

  Future<String?> getServerRemarkById(int id) {
    return (_db.select(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull()
        .then((value) => value?.remark);
  }

  Future<List<String>> getServerRemarks() {
    return (_db.select(_db.servers)
          ..where((tbl) => tbl.id.isNotIn([additionalServerId])))
        .get()
        .then((value) => value.map((e) => e.remark).toList());
  }

  Future<bool> checkServerExists(int id) {
    return (_db.select(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull()
        .then((value) => value != null);
  }

  Future<Server?> getServerById(int id) {
    return (_db.select(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Server?> getSelectedServer() async {
    final selectedServerId =
        GetIt.I.get<ServerConfigProvider>().config.selectedServerId;
    return getServerById(selectedServerId);
  }

  Future<List<String>> getServerRemarksById(List<int> id) {
    if (id.length == 1 && id[0] == additionalServerId) {
      return Future.value(['Additional Socks Server']);
    }
    return (_db.select(_db.servers)..where((tbl) => tbl.id.isIn(id)))
        .get()
        .then((value) => value.map((e) => e.remark).toList());
  }

  Future<int> insertServer(Server server) {
    return _db.into(_db.servers).insert(
          ServersCompanion.insert(
            groupId: server.groupId,
            protocol: server.protocol,
            remark: server.remark,
            address: server.address,
            port: server.port,
            uplink: Value(server.uplink),
            downlink: Value(server.downlink),
            routingProvider: Value(server.routingProvider),
            protocolProvider: Value(server.protocolProvider),
            authPayload: server.authPayload,
            alterId: Value(server.alterId),
            encryption: Value(server.encryption),
            flow: Value(server.flow),
            transport: Value(server.transport),
            host: Value(server.host),
            path: Value(server.path),
            grpcMode: Value(server.grpcMode),
            serviceName: Value(server.serviceName),
            tls: Value(server.tls),
            serverName: Value(server.serverName),
            fingerprint: Value(server.fingerprint),
            publicKey: Value(server.publicKey),
            shortId: Value(server.shortId),
            spiderX: Value(server.spiderX),
            allowInsecure: Value(server.allowInsecure),
            plugin: Value(server.plugin),
            pluginOpts: Value(server.pluginOpts),
            hysteriaProtocol: Value(server.hysteriaProtocol),
            obfs: Value(server.obfs),
            alpn: Value(server.alpn),
            authType: Value(server.authType),
            upMbps: Value(server.upMbps),
            downMbps: Value(server.downMbps),
            recvWindowConn: Value(server.recvWindowConn),
            recvWindow: Value(server.recvWindow),
            disableMtuDiscovery: Value(server.disableMtuDiscovery),
          ),
        );
  }

  Future<void> insertServers(int groupId, List<Server> servers) async {
    await _db.transaction(() async {
      for (final server in servers) {
        await insertServer(server.copyWith(groupId: groupId));
      }
    });
  }

  Future<void> updateServer(Server server) async {
    final oldServer = await getServerById(server.id);
    if (oldServer == null) {
      return;
    }
    await _db.update(_db.servers).replace(server.copyWith());
  }

  Future<void> deleteServer(int serverId) {
    return (_db.delete(_db.servers)..where((tbl) => tbl.id.equals(serverId)))
        .go();
  }

  Future<void> deleteServerByGroupId(int groupId) {
    return (_db.delete(_db.servers)
          ..where((tbl) => tbl.groupId.equals(groupId)))
        .go();
  }

  Future<List<int>> getServersOrderByGroupId(int groupId) async {
    return _db.select(_db.serversOrder).get().then((value) {
      if (value.isEmpty) {
        return [];
      }
      final data =
          value.firstWhere((element) => element.groupId == groupId).data;
      if (data.isEmpty) {
        return [];
      }
      return data.split(',').map((e) => int.parse(e)).toList();
    });
  }

  Future<void> createEmptyServersOrderByGroupId(int groupId) async {
    await _db.into(_db.serversOrder).insert(
          ServersOrderCompanion.insert(
            groupId: groupId,
            data: '',
          ),
        );
  }

  Future<void> updateServersOrderByGroupId(int groupId, List<int> order) async {
    final data = order.join(',');
    (_db.update(_db.serversOrder)..where((tbl) => tbl.groupId.equals(groupId)))
        .write(ServersOrderCompanion(data: Value(data)));
  }

  Future<void> refreshServersOrderByGroupId(int groupId) async {
    final servers = await getServersByGroupId(groupId);
    final order = servers.map((e) => e.id).toList();
    await updateServersOrderByGroupId(groupId, order);
  }

  Future<void> deleteServersOrderByGroupId(int groupId) async {
    (_db.delete(_db.serversOrder)..where((tbl) => tbl.groupId.equals(groupId)))
        .go();
  }
}
