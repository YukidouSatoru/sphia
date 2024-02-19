import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/provider/version_config.dart';

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
        logger.e('Failed to load sphia config: $e');
        logger.i('Resetting sphia config');
        sphiaConfig = defaultConfig;
        await (_db.update(_db.config)
              ..where((tbl) => tbl.id.equals(sphiaConfigId)))
            .write(ConfigCompanion(config: Value(jsonEncode(sphiaConfig))));
      }
      return sphiaConfig;
    } catch (_) {
      rethrow;
    }
  }

  void saveConfig() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final jsonString = jsonEncode(sphiaConfig.toJson());
    try {
      await (_db.update(_db.config)
            ..where((tbl) => tbl.id.equals(sphiaConfigId)))
          .write(ConfigCompanion(config: Value(jsonString)));
    } catch (e) {
      logger.f('Failed to save sphia config: $e');
      rethrow;
    }
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
    } catch (_) {
      rethrow;
    }
  }

  void saveConfig() async {
    final serverConfig = GetIt.I.get<ServerConfigProvider>().config;
    final jsonString = jsonEncode(serverConfig.toJson());
    try {
      await (_db.update(_db.config)
            ..where((tbl) => tbl.id.equals(serverConfigId)))
          .write(ConfigCompanion(config: Value(jsonString)));
    } catch (e) {
      logger.f('Failed to save server config: $e');
      rethrow;
    }
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
    } catch (_) {
      rethrow;
    }
  }

  void saveConfig() async {
    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    final jsonString = jsonEncode(ruleConfig.toJson());
    try {
      await (_db.update(_db.config)
            ..where((tbl) => tbl.id.equals(ruleConfigId)))
          .write(ConfigCompanion(config: Value(jsonString)));
    } catch (e) {
      logger.f('Failed to save rule config: $e');
      rethrow;
    }
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
    } catch (_) {
      rethrow;
    }
  }

  void saveConfig() async {
    final versionConfig = GetIt.I.get<VersionConfigProvider>().config;
    final jsonString = jsonEncode(versionConfig.toJson());
    try {
      await (_db.update(_db.config)
            ..where((tbl) => tbl.id.equals(versionConfigId)))
          .write(ConfigCompanion(config: Value(jsonString)));
    } catch (e) {
      logger.f('Failed to save version config: $e');
      rethrow;
    }
  }
}
