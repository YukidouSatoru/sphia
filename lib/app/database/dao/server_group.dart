import 'package:drift/drift.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';

class ServerGroupDao {
  final Database _db;

  ServerGroupDao(this._db);

  Future<List<ServerGroup>> getServerGroups() {
    return _db.select(_db.serverGroups).get();
  }

  Future<List<ServerGroup>> getOrderedServerGroups() async {
    logger.i('Getting ordered server groups');
    final order = await getServerGroupsOrder();
    final groups = await getServerGroups();
    final orderedGroups = <ServerGroup>[];
    for (final id in order) {
      final group = groups.firstWhere((element) => element.id == id);
      orderedGroups.add(group);
    }
    return orderedGroups;
  }

  Future<ServerGroup?> getServerGroupById(int id) {
    return (_db.select(_db.serverGroups)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<String?> getServerGroupNameById(int id) async {
    final serverGroup = await getServerGroupById(id);
    if (serverGroup == null) {
      return null;
    }
    return serverGroup.name;
  }

  Future<int> insertServerGroup(String name, String subscribe) async {
    final groupId = await _db.into(_db.serverGroups).insert(
          ServerGroupsCompanion.insert(
            name: name,
            subscribe: subscribe,
          ),
        );
    await _db.serverDao.createEmptyServersOrderByGroupId(groupId);
    return groupId;
  }

  Future<void> updateServerGroup(int id, String name, String subscribe) {
    return _db.update(_db.serverGroups).replace(
          ServerGroupsCompanion(
            id: Value(id),
            name: Value(name),
            subscribe: Value(subscribe),
          ),
        );
  }

  Future<void> deleteServerGroup(int id) {
    return _db.transaction(() async {
      await _db.serverDao.deleteServerByGroupId(id);
      await _db.serverDao.deleteServersOrderByGroupId(id);
      await (_db.delete(_db.serverGroups)..where((tbl) => tbl.id.equals(id)))
          .go();
    });
  }

  Future<List<int>> getServerGroupsOrder() {
    return _db.select(_db.groupsOrder).get().then((value) {
      if (value.isEmpty) {
        return [];
      }
      final data = value.first.data;
      return data.split(',').map((e) => int.parse(e)).toList();
    });
  }

  Future<void> updateServerGroupsOrder(List<int> order) async {
    final data = order.join(',');
    (_db.update(_db.groupsOrder)
          ..where((tbl) => tbl.id.equals(serverGroupsOrderId)))
        .write(GroupsOrderCompanion(data: Value(data)));
  }

  Future<void> refreshServerGroupsOrder() async {
    final groups = await getServerGroups();
    final order = groups.map((e) => e.id).toList();
    await updateServerGroupsOrder(order);
  }
}
