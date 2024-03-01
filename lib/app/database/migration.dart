import 'package:drift/drift.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';

class Migration {
  static Future<void> from2To3(
      Migrator m, $ServersTable servers, $RulesTable rules) async {
    logger.i('Migrating database from version 2 to 3');
    final latency = GeneratedColumn(
      'latency',
      'servers',
      true,
      type: DriftSqlType.int,
    );
    await m.addColumn(servers, latency);
    final source = GeneratedColumn(
      'source',
      'rules',
      true,
      type: DriftSqlType.string,
    );
    await m.addColumn(rules, source);
    final sourcePort = GeneratedColumn(
      'source_port',
      'rules',
      true,
      type: DriftSqlType.string,
    );
    await m.addColumn(rules, sourcePort);
    final network = GeneratedColumn(
      'network',
      'rules',
      true,
      type: DriftSqlType.string,
    );
    await m.addColumn(rules, network);
    final protocol = GeneratedColumn(
      'protocol',
      'rules',
      true,
      type: DriftSqlType.string,
    );
    await m.addColumn(rules, protocol);
  }
}
