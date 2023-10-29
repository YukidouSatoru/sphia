import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/database/tables.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/provider/version_config.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/server/xray/config.dart';
import 'package:sphia/util/system.dart';

part 'database.g.dart';

const sphiaConfigId = 1;
const serverConfigId = 2;
const ruleConfigId = 3;
const versionConfigId = 4;
const serverGroupsOrderId = 1;
const ruleGroupsOrderId = 2;

class SphiaDatabase {
  static late Database _database;

  static Future<void> init() async {
    _database = Database();
  }

  static Database get I => _database;

  static SphiaConfigDao get sphiaConfigDao => _database.sphiaConfigDao;

  static ServerConfigDao get serverConfigDao => _database.serverConfigDao;

  static RuleConfigDao get ruleConfigDao => _database.ruleConfigDao;

  static VersionConfigDao get versionConfigDao => _database.versionConfigDao;

  static ServerGroupDao get serverGroupDao => _database.serverGroupDao;

  static RuleGroupDao get ruleGroupDao => _database.ruleGroupDao;

  static ServerDao get serverDao => _database.serverDao;

  static RuleDao get ruleDao => _database.ruleDao;

  static Future<void> close() async {
    logger.i('Closing database');
    await _database.close();
  }
}

@DriftDatabase(tables: [
  Config,
  ServerGroups,
  Servers,
  RuleGroups,
  Rules,
  GroupsOrder,
  ServersOrder,
  RulesOrder,
])
class Database extends _$Database {
  SphiaConfigDao get sphiaConfigDao => SphiaConfigDao(this);

  ServerConfigDao get serverConfigDao => ServerConfigDao(this);

  RuleConfigDao get ruleConfigDao => RuleConfigDao(this);

  VersionConfigDao get versionConfigDao => VersionConfigDao(this);

  ServerGroupDao get serverGroupDao => ServerGroupDao(this);

  RuleGroupDao get ruleGroupDao => RuleGroupDao(this);

  ServerDao get serverDao => ServerDao(this);

  RuleDao get ruleDao => RuleDao(this);

  Database() : super(_openDatabase());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openDatabase() {
  return LazyDatabase(() async {
    final file = File(p.join(configPath, 'sphia.db'));
    if (!await file.exists()) {
      logger.i('Creating database file: ${file.path}');
      final blob = await rootBundle.load('assets/sphia.db');
      final buffer = blob.buffer;
      await file.writeAsBytes(
          buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    }
    return NativeDatabase.createInBackground(file);
  });
}

class SphiaConfigDao {
  final Database _db;

  SphiaConfigDao(this._db);

  Future<String> getConfigJson() async {
    final sphiaConfig = await (_db.select(_db.config)
          ..where((tbl) => tbl.id.equals(sphiaConfigId)))
        .getSingleOrNull();
    if (sphiaConfig == null) {
      await (_db.into(_db.config).insert(
            ConfigCompanion.insert(
              id: const Value(sphiaConfigId),
              config: const JsonEncoder().convert(SphiaConfig.defaults()),
            ),
          ));
      return const JsonEncoder().convert(SphiaConfig.defaults().toJson());
    }
    return sphiaConfig.config;
  }

  Future<SphiaConfig> loadConfig() async {
    logger.i('Loading Sphia config');
    final defaultConfig = SphiaConfig.defaults();
    try {
      final json = await getConfigJson();
      var data = jsonDecode(json);
      final defaultData = defaultConfig.toJson();
      defaultData.forEach((key, value) {
        if (data[key] == null) {
          logger
              .w('Sphia config missing key: $key, using default value: $value');
          data[key] = value;
        }
      });
      late final SphiaConfig sphiaConfig;
      try {
        sphiaConfig = SphiaConfig.fromJson(data);
      } catch (e) {
        logger.wtf('Failed to load sphia config: $e');
        logger.i('Resetting sphia config');
        sphiaConfig = defaultConfig;
        await (_db.update(_db.config)
              ..where((tbl) => tbl.id.equals(sphiaConfigId)))
            .write(ConfigCompanion(config: Value(jsonEncode(sphiaConfig))));
      }
      return sphiaConfig;
    } on Exception catch (e) {
      logger.wtf('Failed to load sphia config: $e');
      rethrow;
    }
  }

  void saveConfig() async {
    logger.i('Saving sphia config');
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final jsonString = jsonEncode(sphiaConfig.toJson());
    await (_db.update(_db.config)..where((tbl) => tbl.id.equals(sphiaConfigId)))
        .write(ConfigCompanion(config: Value(jsonString)));
  }
}

class ServerConfigDao {
  final Database _db;

  ServerConfigDao(this._db);

  Future<String> getConfigJson() async {
    final serverConfig = await (_db.select(_db.config)
          ..where((tbl) => tbl.id.equals(serverConfigId)))
        .getSingleOrNull();
    if (serverConfig == null) {
      await (_db.into(_db.config).insert(
            ConfigCompanion.insert(
              id: const Value(serverConfigId),
              config: const JsonEncoder().convert(ServerConfig.defaults()),
            ),
          ));
      return const JsonEncoder().convert(ServerConfig.defaults().toJson());
    }
    return serverConfig.config;
  }

  Future<ServerConfig> loadConfig() async {
    logger.i('Loading server config');
    final defaultConfig = ServerConfig.defaults();
    try {
      final json = await getConfigJson();
      var data = jsonDecode(json);
      final defaultData = defaultConfig.toJson();
      defaultData.forEach((key, value) {
        if (data[key] == null) {
          logger.w(
              'Server config missing key: $key, using default value: $value');
          data[key] = value;
        }
      });
      return ServerConfig.fromJson(data);
    } on Exception catch (e) {
      logger.wtf('Failed to load server config: $e');
      rethrow;
    }
  }

  void saveConfig() async {
    logger.i('Saving server config');
    final serverConfig = GetIt.I.get<ServerConfigProvider>().config;
    final jsonString = jsonEncode(serverConfig.toJson());
    await (_db.update(_db.config)
          ..where((tbl) => tbl.id.equals(serverConfigId)))
        .write(ConfigCompanion(config: Value(jsonString)));
  }
}

class RuleConfigDao {
  final Database _db;

  RuleConfigDao(this._db);

  Future<String> getConfigJson() async {
    final ruleConfig = await (_db.select(_db.config)
          ..where((tbl) => tbl.id.equals(ruleConfigId)))
        .getSingleOrNull();
    if (ruleConfig == null) {
      await (_db.into(_db.config).insert(
            ConfigCompanion.insert(
              id: const Value(ruleConfigId),
              config: const JsonEncoder().convert(RuleConfig.defaults()),
            ),
          ));
      return const JsonEncoder().convert(RuleConfig.defaults().toJson());
    }
    return ruleConfig.config;
  }

  Future<RuleConfig> loadConfig() async {
    logger.i('Loading rule config');
    final defaultConfig = RuleConfig.defaults();
    try {
      final json = await getConfigJson();
      var data = jsonDecode(json);
      final defaultData = defaultConfig.toJson();
      defaultData.forEach((key, value) {
        if (data[key] == null) {
          logger
              .w('Rule config missing key: $key, using default value: $value');
          data[key] = value;
        }
      });
      return RuleConfig.fromJson(data);
    } on Exception catch (e) {
      logger.wtf('Failed to load rule config: $e');
      rethrow;
    }
  }

  void saveConfig() async {
    logger.i('Saving rule config');
    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    final jsonString = jsonEncode(ruleConfig.toJson());
    await (_db.update(_db.config)..where((tbl) => tbl.id.equals(ruleConfigId)))
        .write(ConfigCompanion(config: Value(jsonString)));
  }
}

class VersionConfigDao {
  final Database _db;

  VersionConfigDao(this._db);

  Future<String> getConfigJson() async {
    final versionConfig = await (_db.select(_db.config)
          ..where((tbl) => tbl.id.equals(versionConfigId)))
        .getSingleOrNull();
    if (versionConfig == null) {
      await (_db.into(_db.config).insert(
            ConfigCompanion.insert(
              id: const Value(versionConfigId),
              config: const JsonEncoder().convert(VersionConfig.empty()),
            ),
          ));
      return const JsonEncoder().convert(VersionConfig.empty().toJson());
    }
    return versionConfig.config;
  }

  Future<VersionConfig> loadConfig() async {
    logger.i('Loading version config');
    try {
      final json = await getConfigJson();
      var data = jsonDecode(json);
      return VersionConfig.fromJson(data);
    } on Exception catch (e) {
      logger.wtf('Failed to load version config: $e');
      rethrow;
    }
  }

  void saveConfig() async {
    logger.i('Saving version config');
    final versionConfig = GetIt.I.get<VersionConfigProvider>().config;
    final jsonString = jsonEncode(versionConfig.toJson());
    await (_db.update(_db.config)
          ..where((tbl) => tbl.id.equals(versionConfigId)))
        .write(ConfigCompanion(config: Value(jsonString)));
  }
}

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

  Future<int> getLastServerGroupId() async {
    final groups = await getServerGroups();
    return groups.last.id;
  }

  Future<String?> getServerGroupNameById(int id) async {
    final serverGroup = await getServerGroupById(id);
    if (serverGroup == null) {
      return null;
    }
    return serverGroup.name;
  }

  Future<void> insertServerGroup(String name, String subscribe) {
    return _db.transaction(() async {
      await _db.into(_db.serverGroups).insert(
            ServerGroupsCompanion.insert(
              name: name,
              subscribe: subscribe,
            ),
          );
      await _db.serverDao
          .createEmptyServersOrderByGroupId(await getLastServerGroupId());
    });
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

  Future<int> getLastRuleGroupId() async {
    final groups = await getRuleGroups();
    return groups.last.id;
  }

  Future<String?> getRuleGroupNameById(int id) async {
    final ruleGroup = await getRuleGroupById(id);
    if (ruleGroup == null) {
      return null;
    }
    return ruleGroup.name;
  }

  Future<void> insertRuleGroup(String name) {
    return _db.transaction(() async {
      await _db.into(_db.ruleGroups).insert(
            RuleGroupsCompanion.insert(
              name: name,
            ),
          );
      await _db.ruleDao
          .createEmptyRulesOrderByGroupId(await getLastRuleGroupId());
    });
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
      await _db.ruleDao.deleteRuleByGroupId(id);
      await _db.ruleDao.deleteRulesOrderByGroupId(id);
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
}

class ServerDao {
  final Database _db;

  ServerDao(this._db);

  Future<List<Server>> getServers() {
    return _db.select(_db.servers).get();
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

  Future<Server?> getServerById(int id) {
    return (_db.select(_db.servers)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<ServerBase?> getServerBaseById(int id) async {
    final server = await getServerById(id);
    if (server == null) {
      return null;
    }
    return ServerBase.fromJson(jsonDecode(server.data));
  }

  Future<int> getLastServerId() async {
    final servers = await getServers();
    return servers.last.id;
  }

  Future<void> insertServer(int groupId, String data) {
    return _db.into(_db.servers).insert(
          ServersCompanion.insert(
            groupId: groupId,
            data: data,
          ),
        );
  }

  Future<void> insertServers(int groupId, List<String> jsons) async {
    for (final json in jsons) {
      await insertServer(groupId, json);
    }
  }

  Future<void> updateServer(int id, String data) async {
    final server = await getServerById(id);
    if (server == null) {
      return;
    }
    await _db.update(_db.servers).replace(server.copyWith(data: data));
  }

  Future<void> deleteServer(Server server) {
    return _db.delete(_db.servers).delete(server);
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

  Future<List<XrayRule>> getXrayRulesByGroupId(int groupId) async {
    final rules = await getOrderedRulesByGroupId(groupId);
    return rules.map((e) => XrayRule.fromJson(jsonDecode(e.data))).toList();
  }

  Future<Rule?> getRuleById(int id) {
    return (_db.select(_db.rules)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<XrayRule?> getXrayRuleById(int id) async {
    final rule = await getRuleById(id);
    if (rule == null) {
      return null;
    }
    return XrayRule.fromJson(jsonDecode(rule.data));
  }

  Future<int> getLastRuleId() async {
    final rules = await getRules();
    return rules.last.id;
  }

  Future<void> insertRule(int groupId, String data) {
    return _db.into(_db.rules).insert(
          RulesCompanion.insert(
            groupId: groupId,
            data: data,
          ),
        );
  }

  Future<void> updateRule(int id, String data) async {
    final rule = await getRuleById(id);
    if (rule == null) {
      return;
    }
    await _db.update(_db.rules).replace(rule.copyWith(data: data));
  }

  Future<void> deleteRule(Rule rule) {
    return _db.delete(_db.rules).delete(rule);
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
