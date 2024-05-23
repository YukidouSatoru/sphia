import 'package:drift/drift.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';

class RuleGroupDao {
  final Database _db;

  RuleGroupDao(this._db);

  Future<List<RuleGroup>> getRuleGroups() {
    return _db.select(_db.ruleGroups).get();
  }

  Future<List<RuleGroup>> getOrderedRuleGroups() async {
    logger.i('Getting ordered rule groups');
    final order = await getRuleGroupsOrder();
    final groups = await getRuleGroups();
    final orderedGroups = <RuleGroup>[];
    for (final id in order) {
      final group = groups.firstWhere((element) => element.id == id);
      orderedGroups.add(group);
    }
    return orderedGroups;
  }

  Future<RuleGroup?> getRuleGroupById(int id) {
    return (_db.select(_db.ruleGroups)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<String?> getRuleGroupNameById(int id) async {
    final ruleGroup = await getRuleGroupById(id);
    if (ruleGroup == null) {
      return null;
    }
    return ruleGroup.name;
  }

  Future<int> insertRuleGroup(String name) async {
    final groupId = await _db.into(_db.ruleGroups).insert(
          RuleGroupsCompanion.insert(
            name: name,
          ),
        );
    await _db.ruleDao.createEmptyRulesOrder(groupId);
    return groupId;
  }

  Future<void> updateRuleGroup(int id, String name) {
    return _db.update(_db.ruleGroups).replace(
          RuleGroupsCompanion(
            id: Value(id),
            name: Value(name),
          ),
        );
  }

  Future<void> deleteRuleGroup(int id) {
    return _db.transaction(() async {
      await (_db.delete(_db.ruleGroups)..where((tbl) => tbl.id.equals(id)))
          .go();
    });
  }

  Future<List<int>> getRuleGroupsOrder() {
    return _db.select(_db.groupsOrder).get().then((value) {
      if (value.isEmpty) {
        return [];
      }
      final data = value.last.data;
      return data.split(',').map((e) => int.parse(e)).toList();
    });
  }

  Future<void> updateRuleGroupsOrder(List<int> order) async {
    final data = order.join(',');
    (_db.update(_db.groupsOrder)
          ..where((tbl) => tbl.id.equals(ruleGroupsOrderId)))
        .write(GroupsOrderCompanion(data: Value(data)));
  }

  Future<void> refreshRuleGroupsOrder() async {
    final groups = await getRuleGroups();
    final order = groups.map((e) => e.id).toList();
    await updateRuleGroupsOrder(order);
  }

  Future<void> clearRuleGroupsOrder() async {
    (_db.update(_db.groupsOrder)
          ..where((tbl) => tbl.id.equals(ruleGroupsOrderId)))
        .write(const GroupsOrderCompanion(data: Value('')));
  }
}
