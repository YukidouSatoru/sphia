import 'package:drift/drift.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/server/server_model.dart';

const additionalServerId = -1;

class ServerDao {
  final Database _db;

  ServerDao(this._db);

  Future<List<Server>> getServers() {
    return _db.select(_db.servers).get();
  }

  Future<List<ServerModel>> getServerModelsByIdList(List<int> id) {
    return (_db.select(_db.servers)..where((tbl) => tbl.id.isIn(id)))
        .get()
        .then((value) => value.map((e) => ServerModel.fromServer(e)).toList());
  }

  Future<List<Server>> getServersByGroupId(int groupId) {
    return (_db.select(_db.servers)
          ..where((tbl) => tbl.groupId.equals(groupId)))
        .get();
  }

  Future<List<ServerModel>> getServerModelsByGroupId(int groupId) async {
    return getServersByGroupId(groupId).then((value) {
      return value.map((e) => ServerModel.fromServer(e)).toList();
    });
  }

  Future<List<ServerModel>> getOrderedServerModelsByGroupId(int groupId) async {
    logger.i('Getting ordered servers by group id: $groupId');
    final order = await getServersOrder(groupId);
    final servers = await getServerModelsByGroupId(groupId);
    final orderedServers = <ServerModel>[];
    for (final id in order) {
      final server = servers.firstWhere((element) => element.id == id);
      orderedServers.add(server);
    }
    return orderedServers;
  }

  Future<String> getServerRemarkById(int id) {
    if (id == additionalServerId) {
      return Future.value('Additional Socks Server');
    }
    return (_db.select(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull()
        .then((value) => value?.remark ?? '');
  }

  Future<Server?> getServerById(int id) {
    if (id == additionalServerId) {
      return Future.value(null);
    }
    return (_db.select(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<ServerModel?> getServerModelById(int id) {
    if (id == additionalServerId) {
      return Future.value(null);
    }
    return (_db.select(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull()
        .then((value) => value == null ? null : ServerModel.fromServer(value));
  }

  Future<int> insertServer(ServerModel server) {
    return _db.into(_db.servers).insert(server.toCompanion());
  }

  Future<List<int>> insertServers(List<ServerModel> servers) async {
    final idList = <int>[];
    for (final server in servers) {
      final id = await insertServer(server);
      idList.add(id);
    }
    return idList;
  }

  Future<void> updateServer(ServerModel server) async {
    await (_db.update(_db.servers)..where((tbl) => tbl.id.equals(server.id)))
        .write(server.toServer());
  }

  Future<void> updateTraffic(int id, int? uplink, int? downlink) async {
    await (_db.update(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .write(ServersCompanion(
      uplink: Value(uplink),
      downlink: Value(downlink),
    ));
  }

  Future<void> updateLatency(int id, int? latency) async {
    await (_db.update(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .write(ServersCompanion(
      latency: Value(latency),
    ));
  }

  Future<void> deleteServer(int id) {
    return (_db.delete(_db.servers)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteServersByGroupId(int groupId) {
    return (_db.delete(_db.servers)
          ..where((tbl) => tbl.groupId.equals(groupId)))
        .go();
  }

  Future<List<int>> getServersOrder(int groupId) async {
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

  Future<void> createEmptyServersOrder(int groupId) async {
    await _db.into(_db.serversOrder).insert(
          ServersOrderCompanion.insert(
            groupId: groupId,
            data: '',
          ),
        );
  }

  Future<void> updateServersOrder(int groupId, List<int> order) async {
    final data = order.join(',');
    (_db.update(_db.serversOrder)..where((tbl) => tbl.groupId.equals(groupId)))
        .write(ServersOrderCompanion(data: Value(data)));
  }

  Future<void> refreshServersOrder(int groupId) async {
    final servers = await getServersByGroupId(groupId);
    final order = servers.map((e) => e.id).toList();
    await updateServersOrder(groupId, order);
  }

  Future<void> deleteServersOrder(int groupId) async {
    (_db.delete(_db.serversOrder)..where((tbl) => tbl.groupId.equals(groupId)))
        .go();
  }
}
