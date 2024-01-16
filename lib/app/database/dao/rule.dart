import 'package:drift/drift.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';

const outboundProxyId = -2;
const outboundDirectId = -1;
const outboundBlockId = 0;

class RuleDao {
  final Database _db;

  RuleDao(this._db);

  Future<List<Rule>> getRules() {
    return _db.select(_db.rules).get();
  }

  Future<List<Rule>> getRulesByGroupId(int groupId) {
    return (_db.select(_db.rules)..where((tbl) => tbl.groupId.equals(groupId)))
        .get();
  }

  Future<List<Rule>> getOrderedRulesByGroupId(int groupId) async {
    logger.i('Getting ordered rules by group id: $groupId');
    final order = await getRulesOrderByGroupId(groupId);
    final rules = await getRulesByGroupId(groupId);
    final orderedRules = <Rule>[];
    for (final id in order) {
      final rule = rules.firstWhere((element) => element.id == id);
      orderedRules.add(rule);
    }
    return orderedRules;
  }

  Future<List<int>> getRuleOutboundTagsByGroupId(List<Rule> rules) async {
    final outboundTags = <int>[];
    for (final rule in rules) {
      if (rule.outboundTag != outboundProxyId &&
          rule.outboundTag != outboundDirectId &&
          rule.outboundTag != outboundBlockId) {
        outboundTags.add(rule.outboundTag);
      }
    }
    return outboundTags;
  }

  Future<Rule?> getRuleById(int id) {
    return (_db.select(_db.rules)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertRule(Rule rule) {
    return _db.into(_db.rules).insert(
          RulesCompanion.insert(
            groupId: rule.groupId,
            name: rule.name,
            enabled: rule.enabled,
            outboundTag: rule.outboundTag,
            domain: Value(rule.domain),
            ip: Value(rule.ip),
            port: Value(rule.port),
            processName: Value(rule.processName),
          ),
        );
  }

  Future<void> updateRule(Rule rule) async {
    final oldRule = await getRuleById(rule.id);
    if (oldRule == null) {
      return;
    }
    await _db.update(_db.rules).replace(rule.copyWith());
  }

  Future<void> deleteRule(int id) {
    return (_db.delete(_db.rules)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteRuleByGroupId(int groupId) {
    return (_db.delete(_db.rules)..where((tbl) => tbl.groupId.equals(groupId)))
        .go();
  }

  Future<List<int>> getRulesOrderByGroupId(int groupId) async {
    return _db.select(_db.rulesOrder).get().then((value) {
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

  Future<void> createEmptyRulesOrderByGroupId(int groupId) async {
    await _db.into(_db.rulesOrder).insert(
          RulesOrderCompanion.insert(
            groupId: groupId,
            data: '',
          ),
        );
  }

  Future<void> updateRulesOrderByGroupId(int groupId, List<int> order) async {
    final data = order.join(',');
    (_db.update(_db.rulesOrder)..where((tbl) => tbl.groupId.equals(groupId)))
        .write(RulesOrderCompanion(data: Value(data)));
  }

  Future<void> refreshRulesOrderByGroupId(int groupId) async {
    final rules = await getRulesByGroupId(groupId);
    final order = rules.map((e) => e.id).toList();
    await updateRulesOrderByGroupId(groupId, order);
  }

  Future<void> deleteRulesOrderByGroupId(int groupId) async {
    (_db.delete(_db.rulesOrder)..where((tbl) => tbl.groupId.equals(groupId)))
        .go();
  }
}
