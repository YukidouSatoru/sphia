import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';

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
        final server = await serverDao.getSelectedServerModel();
        if (server == null) {
          return;
        }
        server.uplink = null;
        server.downlink = null;
        await serverDao.updateTraffic(server.id, null, null);
        final index = serverConfigProvider.servers
            .indexWhere((element) => element.id == server.id);
        if (index != -1) {
          serverConfigProvider.servers[index] = server;
        }
        logger.i('Clear Traffic for: ${server.address}:${server.port}');
      } else {
        // option == 'CurrentGroup'
        for (var i = 0; i < serverConfigProvider.servers.length; i++) {
          if (_cancel) {
            return;
          }
          serverConfigProvider.servers[i].uplink = null;
          serverConfigProvider.servers[i].downlink = null;
          await serverDao.updateTraffic(
            serverConfigProvider.servers[i].id,
            null,
            null,
          );
          logger.i(
              'Clear Traffic for: ${serverConfigProvider.servers[i].address}:${serverConfigProvider.servers[i].port}');
        }
      }
    } catch (e) {
      logger.e('Failed to clear traffic: $e');
    }
  }
}
