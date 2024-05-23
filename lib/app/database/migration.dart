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

  static Future<void> from3To4(
      Migrator m,
      $ServersTable servers,
      $RulesTable rules,
      $ServersOrderTable serversOrder,
      $RulesOrderTable rulesOrder) async {
    logger.i('Migrating database from version 3 to 4');

    await m.database.customStatement('''
      CREATE TABLE servers_old AS SELECT * FROM servers;
    ''');
    await m.database.customStatement('''
      CREATE TABLE rules_old AS SELECT * FROM rules;
    ''');
    await m.database.customStatement('''
      CREATE TABLE servers_order_old AS SELECT * FROM servers_order;
    ''');
    await m.database.customStatement('''
      CREATE TABLE rules_order_old AS SELECT * FROM rules_order;
    ''');

    await m.deleteTable('servers');
    await m.deleteTable('rules');
    await m.deleteTable('servers_order');
    await m.deleteTable('rules_order');

    await m.createTable($ServersTable(m.database));
    await m.createTable($RulesTable(m.database));
    await m.createTable($ServersOrderTable(m.database));
    await m.createTable($RulesOrderTable(m.database));

    await m.database.customStatement('''
      INSERT INTO servers (id, group_id, protocol, remark, address, port, uplink, downlink, routing_provider, protocol_provider, auth_payload, alter_id, encryption, flow, transport, host, path, grpc_mode, service_name, tls, server_name, fingerprint, public_key, short_id, spider_x, allow_insecure, plugin, plugin_opts, hysteria_protocol, obfs, alpn, auth_type, up_mbps, down_mbps, recv_window_conn, recv_window, disable_mtu_discovery, latency, config_string, config_format) SELECT id, group_id, protocol, remark, address, port, uplink, downlink, routing_provider, protocol_provider, auth_payload, alter_id, encryption, flow, transport, host, path, grpc_mode, service_name, tls, server_name, fingerprint, public_key, short_id, spider_x, allow_insecure, plugin, plugin_opts, hysteria_protocol, obfs, alpn, auth_type, up_mbps, down_mbps, recv_window_conn, recv_window, disable_mtu_discovery, latency, NULL AS config_string, NULL AS config_format FROM servers_old;
    ''');
    await m.database.customStatement(
        'INSERT INTO rules (id, group_id, name, enabled, outbound_tag, domain, ip, port, source, source_port, network, protocol, process_name) SELECT id, group_id, name, enabled, outbound_tag, domain, ip, port, source, source_port, network, protocol, process_name FROM rules_old');
    await m.database.customStatement(
        'INSERT INTO servers_order (id, group_id, data) SELECT id, group_id, data FROM servers_order_old');
    await m.database.customStatement(
        'INSERT INTO rules_order (id, group_id, data) SELECT id, group_id, data FROM rules_order_old');

    await m.deleteTable('servers_old');
    await m.deleteTable('rules_old');
    await m.deleteTable('servers_order_old');
    await m.deleteTable('rules_order_old');
  }
}
