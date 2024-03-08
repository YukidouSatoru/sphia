import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:get_it/get_it.dart';

class TrafficDialog extends StatefulWidget {
  final String option;

  const TrafficDialog({super.key, required this.option});

  @override
  State<TrafficDialog> createState() => _TrafficDialog();
}

class _TrafficDialog extends State<TrafficDialog> {
  bool _cancel = false;
  Future<void>? _operation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _operation = clearTraffic(widget.option);
      _operation!.whenComplete(() => Navigator.of(context).pop());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).clearTraffic),
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

  Future<void> clearTraffic(String option) async {
    logger.i('Clearing Traffic: option=$option');

    try {
      final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
      if (option == 'SelectedServer') {
        final server = await serverDao.getSelectedServer();
        if (server == null) {
          return;
        }
        final newServer = server.copyWith(
          uplink: const Value(null),
          downlink: const Value(null),
        );
        await serverDao.updateServer(newServer);
        final index = serverConfigProvider.servers
            .indexWhere((element) => element.id == server.id);
        if (index != -1) {
          serverConfigProvider.servers[index] = newServer;
        }
        logger.i('Clear Traffic for: ${newServer.address}:${newServer.port}');
      } else {
        // option == 'CurrentGroup'
        for (var i = 0; i < serverConfigProvider.servers.length; i++) {
          if (_cancel) {
            return;
          }
          final server = serverConfigProvider.servers[i].copyWith(
            uplink: const Value(null),
            downlink: const Value(null),
          );
          await serverDao.updateServer(server);
          serverConfigProvider.servers[i] = server;
          logger.i('Clear Traffic for: ${server.address}:${server.port}');
        }
      }
    } catch (e) {
      logger.e('Failed to clear traffic: $e');
    }
  }
}
