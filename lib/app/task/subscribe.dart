import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/task.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/util/uri/uri.dart';

class SubscribeTask {
  static const name = 'Update Subscribe';

  static Task generate() {
    return Task(
      name,
      updateSubscribeDuration(),
      updateSubscribe,
    );
  }

  static Duration updateSubscribeDuration() {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final serverConfig = GetIt.I.get<ServerConfigProvider>().config;
    late final Duration duration;
    if (serverConfig.updatedSubscribeTime == 0) {
      updateSubscribe();
      duration = Duration(minutes: sphiaConfig.updateSubscribeInterval);
    } else {
      final interval = DateTime.now()
          .difference(
            DateTime.fromMillisecondsSinceEpoch(
              serverConfig.updatedSubscribeTime,
            ),
          )
          .inMinutes;
      if (interval >= sphiaConfig.updateSubscribeInterval) {
        updateSubscribe();
        duration = Duration(minutes: sphiaConfig.updateSubscribeInterval);
      } else {
        duration =
            Duration(minutes: sphiaConfig.updateSubscribeInterval - interval);
      }
    }
    return duration;
  }

  static void updateSubscribe() async {
    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    serverConfigProvider.config.updatedSubscribeTime =
        DateTime.now().millisecondsSinceEpoch;
    final groups = await SphiaDatabase.serverGroupDao.getOrderedServerGroups();
    for (var group in groups) {
      final subscribe = group.subscribe;
      if (subscribe.isEmpty) {
        continue;
      }
      final groupName = group.name;
      try {
        List<String> uris;
        uris = await UriUtil.importUriFromSubscribe(
            subscribe, userAgents[sphiaConfigProvider.config.userAgent]!);
        final servers = uris
            .map((e) => UriUtil.parseUri(e))
            .whereType<ServerBase>()
            .toList();
        await SphiaDatabase.serverDao.deleteServerByGroupId(group.id);
        final serverJsons = servers
            .map((e) => const JsonEncoder().convert(e.toJson()))
            .toList();
        await SphiaDatabase.serverDao.insertServers(group.id, serverJsons);
        await SphiaDatabase.serverDao.refreshServersOrderByGroupId(group.id);
        logger.i('Updated group successfully: $groupName');
      } on Exception catch (e) {
        logger.e('Failed to update group: $groupName\n$e');
        continue;
      }
    }
    serverConfigProvider.servers = await SphiaDatabase.serverDao
        .getOrderedServersByGroupId(
            serverConfigProvider.config.selectedServerGroupId);
    SphiaTray.generateServerItems();
    SphiaTray.setMenu();
    serverConfigProvider.saveConfig();
  }
}
