import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/database/dao/config.dart';
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/dao/rule_group.dart';
import 'package:sphia/app/database/dao/server.dart';
import 'package:sphia/app/database/dao/server_group.dart';
import 'package:sphia/app/database/migration.dart';
import 'package:sphia/app/database/tables.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/util/system.dart';

part 'database.g.dart';

const sphiaConfigId = 1;
const serverConfigId = 2;
const ruleConfigId = 3;
const versionConfigId = 4;
const serverGroupsOrderId = 1;
const ruleGroupsOrderId = 2;

final sphiaConfigDao = SphiaDatabase.sphiaConfigDao;
final serverConfigDao = SphiaDatabase.serverConfigDao;
final ruleConfigDao = SphiaDatabase.ruleConfigDao;
final versionConfigDao = SphiaDatabase.versionConfigDao;
final serverGroupDao = SphiaDatabase.serverGroupDao;
final ruleGroupDao = SphiaDatabase.ruleGroupDao;
final serverDao = SphiaDatabase.serverDao;
final ruleDao = SphiaDatabase.ruleDao;

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

  static Future<void> backupDatabase() async {
    // close database before backup
    await _database.close();
    final file = File(p.join(configPath, 'sphia.db'));
    if (!await file.exists()) {
      logger.i('Database file does not exist');
      return;
    }
    final backupFile = File(p.join(configPath, 'sphia.db.bak'));
    if (await backupFile.exists()) {
      logger.i('Backup file already exists, deleting it');
      await backupFile.delete();
    }
    logger.i('Creating backup file: ${backupFile.path}');
    await file.rename(backupFile.path);
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from == 2) {
          await Migration.from2To3(migrator, servers, rules);
        }
      },
    );
  }
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
