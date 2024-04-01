import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';

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
              config: const JsonEncoder().convert(const SphiaConfig()),
            ),
          ));
      return const JsonEncoder().convert(const SphiaConfig().toJson());
    }
    return sphiaConfig.config;
  }

  Future<SphiaConfig> loadConfig() async {
    logger.i('Loading Sphia config');
    const defaultConfig = SphiaConfig();
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

  void saveConfig(SphiaConfig sphiaConfig) async {
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
              config: const JsonEncoder().convert(const ServerConfig()),
            ),
          ));
      return const JsonEncoder().convert(const ServerConfig().toJson());
    }
    return serverConfig.config;
  }

  Future<ServerConfig> loadConfig() async {
    logger.i('Loading server config');
    const defaultConfig = ServerConfig();
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

  void saveConfig(ServerConfig serverConfig) async {
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
              config: const JsonEncoder().convert(const RuleConfig()),
            ),
          ));
      return const JsonEncoder().convert(const RuleConfig().toJson());
    }
    return ruleConfig.config;
  }

  Future<RuleConfig> loadConfig() async {
    logger.i('Loading rule config');
    const defaultConfig = RuleConfig();
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

  void saveConfig(RuleConfig ruleConfig) async {
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
              config: const JsonEncoder().convert(const VersionConfig()),
            ),
          ));
      return const JsonEncoder().convert(const VersionConfig().toJson());
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

  void saveConfig(VersionConfig versionConfig) async {
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
