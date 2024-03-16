import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/latency.dart';

class ProgressDialog extends StatefulWidget {
  final Map<String, String> options;

  const ProgressDialog({super.key, required this.options});

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  bool _cancel = false;
  Future<void>? _operation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.options['action'] == 'clear') {
        _operation = clearLatency(widget.options['option']!);
      } else {
        _operation =
            latencyTest(widget.options['option']!, widget.options['type']!);
      }
      _operation!.whenComplete(() => Navigator.of(context).pop());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).latencyTest),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _cancel = true;
          },
          child: Text(S.of(context).cancel),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> latencyTest(String option, String type) async {
    logger.i('Testing Latency: option=$option, type=$type');

    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    final servers = <Server>[];

    final isICMP = (type == 'ICMP');
    final isTCP = (type == 'TCP');
    final isUrl = (type == 'Url');
    if (option == 'SelectedServer') {
      final server = await serverDao.getSelectedServer();
      if (server == null) {
        return;
      }
      //
      late final int latency;
      if (isICMP) {
        latency = await IcmpLatency.testIcmpLatency(server.address);
      } else if (isTCP) {
        latency = await TcpLatency.testTcpLatency(server.address, server.port);
      } else if (isUrl) {
        final urlLatency = UrlLatency([server]);
        final tag = 'proxy-${server.id}';
        await urlLatency.init();
        latency = await urlLatency.testUrlLatency(tag);
      }
      await serverDao.updateServer(server.copyWith(latency: Value(latency)));
      final index =
          serverConfigProvider.servers.indexWhere((e) => e.id == server.id);
      if (index != -1) {
        serverConfigProvider.servers[index] =
            server.copyWith(latency: Value(latency));
      }
    } else {
      // option == 'CurrentGroup'
      final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
      servers.addAll(serverConfigProvider.servers);
      late final UrlLatency urlLatency;
      if (isUrl) {
        urlLatency = UrlLatency(servers);
        await urlLatency.init();
      }
      for (var i = 0; i < servers.length; i++) {
        if (_cancel) {
          if (isUrl) {
            await urlLatency.stop();
          }
          return;
        }
        final server = servers[i];
        late final int latency;
        if (isUrl) {
          final server = servers[i];
          final tag = 'proxy-${server.id}';
          latency = await urlLatency.testUrlLatency(tag);
        } else if (isTCP) {
          latency =
              await TcpLatency.testTcpLatency(server.address, server.port);
        } else if (isICMP) {
          latency = await IcmpLatency.testIcmpLatency(server.address);
        }
        await serverDao.updateServer(server.copyWith(latency: Value(latency)));
        serverConfigProvider.servers[i] =
            server.copyWith(latency: Value(latency));
      }
    }
  }

  Future<void> clearLatency(String option) async {
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    if (option == 'SelectedServer') {
      final server = await serverDao.getSelectedServer();
      if (server == null) {
        return;
      }
      final newServer = server.copyWith(
        latency: const Value(null),
      );
      await serverDao.updateServer(newServer);
      final index = serverConfigProvider.servers
          .indexWhere((element) => element.id == server.id);
      if (index != -1) {
        serverConfigProvider.servers[index] = newServer;
      }
    } else {
      // option == 'CurrentGroup'
      for (var i = 0; i < serverConfigProvider.servers.length; i++) {
        if (_cancel) {
          return;
        }
        final server = serverConfigProvider.servers[i].copyWith(
          latency: const Value(null),
        );
        await serverDao.updateServer(server);
        serverConfigProvider.servers[i] = server;
      }
    }
  }
}
