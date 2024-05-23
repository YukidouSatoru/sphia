import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/server_config.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/config/version_config.dart';
import 'package:sphia/app/notifier/data/server.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/latency.dart';

part 'progress.g.dart';

@riverpod
class ProgressDialogCancelNotifier extends _$ProgressDialogCancelNotifier {
  @override
  bool build() {
    return false;
  }

  void updateValue(bool value) {
    state = value;
  }
}

class ProgressDialog extends ConsumerStatefulWidget {
  final Map<String, String> options;

  const ProgressDialog({
    super.key,
    required this.options,
  });

  @override
  ConsumerState<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends ConsumerState<ProgressDialog> {
  final _completer = Completer<void>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      late final Future<void> operation;
      if (widget.options['action'] == 'Clear') {
        operation = clearLatency(widget.options['option']!, ref);
      } else {
        operation = latencyTest(
            widget.options['option']!, widget.options['type']!, ref);
      }
      await operation;
      if (_completer.isCompleted && mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCancel = ref.watch(progressDialogCancelNotifierProvider);
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
          onPressed: isCancel
              ? null
              : () {
                  _completer.complete();
                  final notifier =
                      ref.read(progressDialogCancelNotifierProvider.notifier);
                  notifier.updateValue(true);
                },
          child: Text(S.of(context).cancel),
        )
      ],
    );
  }

  Future<void> latencyTest(String option, String type, WidgetRef ref) async {
    logger.i('Testing Latency: option=$option, type=$type');

    final isICMP = (type == 'ICMP');
    final isTCP = (type == 'TCP');
    final isUrl = (type == 'Url');
    final sphiaConfig = ref.read(sphiaConfigNotifierProvider);
    final testUrl = sphiaConfig.latencyTestUrl;
    final serverConfig = ref.read(serverConfigNotifierProvider);
    if (option == 'SelectedServer') {
      final notifier = ref.read(serverNotifierProvider.notifier);
      final id = serverConfig.selectedServerId;
      final server = await serverDao.getServerModelById(id);
      if (server == null) {
        logger.w('Selected server not exists');
        _completer.complete();
        return;
      }
      if (server.protocol == 'custom') {
        logger.w('Custom config server does not support latency test');
        _completer.complete();
        return;
      }
      //
      late final int latency;
      if (isICMP) {
        latency = await IcmpLatency.testIcmpLatency(server.address);
      } else if (isTCP) {
        latency = await TcpLatency.testTcpLatency(server.address, server.port);
      } else if (isUrl) {
        final urlLatency = UrlLatency(servers: [server], testUrl: testUrl);
        final tag = 'proxy-${server.id}';
        final versionConfig = ref.read(versionConfigNotifierProvider);
        await urlLatency.init(sphiaConfig, versionConfig);
        latency = await urlLatency.testUrlLatency(tag);
        urlLatency.stop();
      }
      await serverDao.updateLatency(server.id, latency);
      notifier.updateServer(
        server..latency = latency,
        shouldUpdateLite: false,
      );
    } else {
      // option == 'CurrentGroup'
      final servers = ref.read(serverNotifierProvider);
      servers.removeWhere((server) => server.protocol == 'custom');
      if (servers.isEmpty) {
        logger.w('No server to test latency');
        _completer.complete();
        return;
      }
      late final UrlLatency urlLatency;
      if (isUrl) {
        urlLatency = UrlLatency(servers: servers, testUrl: testUrl);
        final versionConfig = ref.read(versionConfigNotifierProvider);
        await urlLatency.init(sphiaConfig, versionConfig);
      }
      for (var i = 0; i < servers.length; i++) {
        if (_completer.isCompleted) {
          if (isUrl) {
            await urlLatency.stop();
          }
          return;
        }
        final server = servers[i];
        late final int latency;
        if (isUrl) {
          final tag = 'proxy-${server.id}';
          latency = await urlLatency.testUrlLatency(tag);
        } else if (isTCP) {
          latency =
              await TcpLatency.testTcpLatency(server.address, server.port);
        } else if (isICMP) {
          latency = await IcmpLatency.testIcmpLatency(server.address);
        }
        await serverDao.updateLatency(server.id, latency);
      }
      if (isUrl) {
        await urlLatency.stop();
      }
    }
    _completer.complete();
  }

  Future<void> clearLatency(String option, WidgetRef ref) async {
    logger.i('Clearing Latency: option=$option');

    final serverConfig = ref.read(serverConfigNotifierProvider);
    if (option == 'SelectedServer') {
      final notifier = ref.read(serverNotifierProvider.notifier);
      final id = serverConfig.selectedServerId;
      final server = await serverDao.getServerModelById(id);
      if (server == null) {
        logger.w('Selected server not exists');
        _completer.complete();
        return;
      }
      if (server.protocol == 'custom') {
        logger.w('Custom config server does not support latency clearing');
        _completer.complete();
        return;
      }
      await serverDao.updateLatency(server.id, null);
      notifier.updateServer(
        server..latency = null,
        shouldUpdateLite: false,
      );
    } else {
      // option == 'CurrentGroup'
      final servers = ref.read(serverNotifierProvider);
      servers.removeWhere((server) => server.protocol == 'custom');
      if (servers.isEmpty) {
        logger.w('No server to clear latency');
        _completer.complete();
        return;
      }
      for (var i = 0; i < servers.length; i++) {
        if (_completer.isCompleted) {
          return;
        }
        await serverDao.updateLatency(
          servers[i].id,
          null,
        );
      }
    }
    _completer.complete();
  }
}
