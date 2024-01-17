import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/task.dart';
import 'package:sphia/app/tray.dart';
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

  static Future<bool> updateSubscribe() async {
    logger.i('Updating All Server Groups');
    bool flag = false;
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    serverConfigProvider.config.updatedSubscribeTime =
        DateTime.now().millisecondsSinceEpoch;
    final serverGroups = await serverGroupDao.getOrderedServerGroups();
    for (var serverGroup in serverGroups) {
      final subscribe = serverGroup.subscribe;
      if (subscribe.isEmpty) {
        continue;
      }
      logger.i('Updating Server Group: ${serverGroup.name}');
      try {
        await UriUtil.updateSingleGroup(serverGroup.id, subscribe);
        flag = true;
      } on Exception catch (e) {
        logger.e('Failed to update group: ${serverGroup.name}\n$e');
        continue;
      }
    }
    if (flag) {
      serverConfigProvider.servers = await serverDao.getOrderedServersByGroupId(
          serverConfigProvider.config.selectedServerGroupId);
      SphiaTray.generateServerItems();
      SphiaTray.setMenu();
    }
    serverConfigProvider.saveConfig();
    return flag;
  }
}
