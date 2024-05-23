import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/server_config.dart';
import 'package:sphia/app/notifier/data/server.dart';
import 'package:sphia/l10n/generated/l10n.dart';

class TrafficDialog extends ConsumerWidget {
  final String option;

  const TrafficDialog({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Future<void> operation = clearTraffic(option, ref);
      await operation;
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
    return AlertDialog(
      title: Text(S.of(context).clearTraffic),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Future<void> clearTraffic(String option, WidgetRef ref) async {
    logger.i('Clearing Traffic: option=$option');
    try {
      if (option == 'SelectedServer') {
        final notifier = ref.read(serverNotifierProvider.notifier);
        final serverConfig = ref.read(serverConfigNotifierProvider);
        final id = serverConfig.selectedServerId;
        final server = await serverDao.getServerModelById(id);
        if (server == null) {
          logger.w('Selected server not exists');
          return;
        }
        if (server.protocol == 'custom') {
          logger.w('Custom server does not support traffic clearing');
          return;
        }
        await serverDao.updateTraffic(server.id, null, null);
        notifier.updateServer(
          server
            ..uplink = null
            ..downlink = null,
          shouldUpdateLite: false,
        );
      } else {
        // option == 'CurrentGroup'
        final servers = ref.read(serverNotifierProvider);
        servers.removeWhere((server) => server.protocol == 'custom');
        if (servers.isEmpty) {
          logger.w('No server to clear traffic');
          return;
        }
        for (var i = 0; i < servers.length; i++) {
          if (!ref.context.mounted) {
            return;
          }
          await serverDao.updateTraffic(servers[i].id, null, null);
        }
      }
    } catch (e) {
      logger.e('Failed to clear traffic: $e');
    }
  }
}
